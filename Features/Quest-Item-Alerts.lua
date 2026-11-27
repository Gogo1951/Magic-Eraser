local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local format, ipairs = string.format, ipairs

-- The whole carried count: the alert is about the item, not the first slot found.
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
    By item id for the session, so moving a stack never re-announces. A starter
    not yet erasable, or protected, stays unmarked so it can speak later.
]]
local announcedStarters = {}

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

-- Items are still marked while alerts are off, so turning them on doesn't replay the bags.
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

					-- Skip what the starter scan already announced.
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

		ns:RefreshWhenOutOfCombat()
	end)
end
