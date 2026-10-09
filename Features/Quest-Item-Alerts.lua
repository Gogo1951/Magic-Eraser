local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local format, ipairs = string.format, ipairs

--[[
    The " x2" after an alert's item link, in the same form the eraser's own
    chat lines use: the whole count across every carried stack, since the alert
    is about the item, not the one slot the scan happened to reach first.
    Empty for a single item.
]]
local function StackSuffix(itemId)
	local count = 0
	for _, bag in ipairs(ns.CARRIED_BAGS) do
		for slot = 1, GetContainerNumSlots(bag) or 0 do
			local itemInfo = GetContainerItemInfo(bag, slot)
			if itemInfo and itemInfo.itemID == itemId then
				count = count + (itemInfo.stackCount or 1)
			end
		end
	end
	return (count > 1) and format(" x%d", count) or ""
end

--------------------------------------------------------------------------------
-- Quest-Item Alerts
--------------------------------------------------------------------------------

--[[
    Quest starters announce themselves on the way in rather than waiting for the
    player to notice: the whole point of the race and class gate is that the item
    is dead the moment it drops, which is not something a tooltip alone tells you
    while you are still looting.

    BAG_UPDATE_DELAYED fires a burst at login, so ns:SeedQuestStarterAlerts marks
    the starters already erasable at login and only one that becomes erasable
    while playing speaks up. A starter held but not yet erasable is left unmarked
    on purpose, so finishing its quest later still alerts. Same reasoning as
    ns:SeedBagSpaceBaseline in Bag-Warnings.lua.

    Keyed by item id and living for the session, so moving a stack between bags or
    opening a merchant cannot make the same item announce twice.
    ns:OnQuestTurnedIn reads the same set before its own walk: most starters
    also carry a row in ALLOWED_DELETE_QUEST_ITEMS under the same quest id, so
    without that check a starter still in the bags at turn-in would announce
    twice.

    An item on either Ignore List never announces, since the eraser will never
    act on it; it is left unmarked, so lifting the protection lets it speak on a
    later bag update.
]]
local announcedStarters = {}

-- How many starters have been marked this session, for the Diagnostic Tools Eraser Context.
function ns:CountAnnouncedQuestStarters()
	local count = 0
	for _ in pairs(announcedStarters) do
		count = count + 1
	end
	return count
end

local ALERT_KEYS = {
	quest = "QUEST_ITEM_READY",
	questIneligible = "QUEST_STARTER_UNAVAILABLE",
}

--[[
    Whether an alert for this kind may print: the Enable Quest Item Alerts switch
    is on, and the player hasn't unchecked the kind on the Erasing panel, where
    "safe to erase" would be telling them about an item Magic Eraser will never
    touch. Items are still marked as announced while alerts are off, so turning
    them back on doesn't replay every quest item already in the bags.
]]
local function ShouldAlert(reason)
	return ns.db and ns.db.profile.questAlertsEnabled and ns:IsJunkKind(reason)
end

local function ScanQuestStarters(announce)
	local starterDatabase = ns.ALLOWED_DELETE_QUEST_STARTING_ITEMS
	if not starterDatabase then
		return
	end

	for _, bag in ipairs(ns.CARRIED_BAGS) do
		local slotCount = GetContainerNumSlots(bag) or 0
		for slot = 1, slotCount do
			local itemInfo = GetContainerItemInfo(bag, slot)
			local itemId = itemInfo and itemInfo.itemID

			--[[
			    The cheap table lookup gates everything: an item that starts no
			    quest never reaches the race, class or quest-state checks, and an
			    ignored one never announces.
			]]
			if itemId and starterDatabase[itemId] and not announcedStarters[itemId] and not ns:IsIgnored(itemId) then
				local reason = ns:GetQuestStarterReason(itemId)
				if reason then
					announcedStarters[itemId] = true
					if announce and ShouldAlert(reason) then
						ns:PrintMessage(format(L[ALERT_KEYS[reason]], itemInfo.hyperlink, StackSuffix(itemId)))
					end
				end
			end
		end
	end
end

--[[
    Called once from OnPlayerLogin, before the login BAG_UPDATE_DELAYED burst can
    reach CheckQuestStarters.
]]
function ns:SeedQuestStarterAlerts()
	ScanQuestStarters(false)
end

function ns:CheckQuestStarters()
	ScanQuestStarters(true)
end

function ns:OnQuestTurnedIn(questId)
	C_Timer.After(1.0, function()
		ns:CheckQuestStarters()

		local questItemDatabase = ns.ALLOWED_DELETE_QUEST_ITEMS or {}
		local alertedItems = {}

		for _, bag in ipairs(ns.CARRIED_BAGS) do
			local slotCount = GetContainerNumSlots(bag) or 0
			for slot = 1, slotCount do
				local itemInfo = GetContainerItemInfo(bag, slot)
				if itemInfo then
					local itemId = itemInfo.itemID

					--[[
					    Skip anything the starter scan above already spoke for.
					    Nearly every quest starter also has a row here under the
					    same quest id, so without this the one line arrives twice.
					    Ignored items never announce.
					]]
					if
						questItemDatabase[itemId]
						and not alertedItems[itemId]
						and not announcedStarters[itemId]
						and not ns:IsIgnored(itemId)
					then
						for _, trackedQuestId in ipairs(questItemDatabase[itemId]) do
							if trackedQuestId == questId then
								if ShouldAlert("quest") then
									ns:PrintMessage(
										format(L["QUEST_ITEM_READY"], itemInfo.hyperlink, StackSuffix(itemId))
									)
								end
								alertedItems[itemId] = true
								break
							end
						end
					end
				end
			end
		end

		ns:InvalidateCache()
		ns:RefreshDisplay()
	end)
end
