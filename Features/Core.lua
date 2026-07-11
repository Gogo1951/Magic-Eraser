local ADDON_NAME, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local PickupContainerItem = C_Container.PickupContainerItem
local format, ipairs = string.format, ipairs

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

function ns:IsIgnored(itemId)
	return ns.db and ns.db.profile.ignoreList[itemId]
end

function ns:ToggleIgnore(itemId)
	if not itemId then
		return
	end
	local ignoreList = ns.db.profile.ignoreList
	if ignoreList[itemId] then
		ignoreList[itemId] = nil
	else
		ignoreList[itemId] = true
	end
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

function ns:ClearIgnoreList()
	wipe(ns.db.profile.ignoreList)
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

--------------------------------------------------------------------------------
-- Scan Cache
--------------------------------------------------------------------------------

local cachedItem = nil
local isCacheValid = false

--[[
    Cold item-data misses reschedule a rescan. Without a cap, an item whose
    GetItemInfo never resolves would reschedule forever; without a pending
    guard, concurrent cold-cache triggers would stack timers. So: cap the
    reschedules, allow only one pending retry, and reset the counter on every
    fresh scan trigger -- any InvalidateCache that is not itself a retry.
]]
local MAX_SCAN_RETRIES = 5
local scanRetries = 0
local retryPending = false
local inScanRetry = false

function ns:InvalidateCache()
	isCacheValid = false
	cachedItem = nil
	if not inScanRetry then
		scanRetries = 0
	end
end

local function ScheduleScanRetry()
	if retryPending or scanRetries >= MAX_SCAN_RETRIES then
		return
	end
	retryPending = true
	scanRetries = scanRetries + 1
	C_Timer.After(1.0, function()
		retryPending = false
		inScanRetry = true
		ns:RefreshDisplay()
		inScanRetry = false
	end)
end

--------------------------------------------------------------------------------
-- Scanning & Evaluation
--------------------------------------------------------------------------------

function ns:GetItemDeleteReason(itemId, rarity, sellPrice, requiredLevel)
	local playerLevel = UnitLevel("player")
	local questItemDatabase = ns.AllowedDeleteQuestItems or {}
	local consumableDatabase = ns.AllowedDeleteConsumables or {}
	local equipmentDatabase = ns.AllowedDeleteEquipment or {}

	if questItemDatabase[itemId] then
		for _, questId in ipairs(questItemDatabase[itemId]) do
			if self:IsQuestCompleted(questId) then
				return "quest"
			end
		end
	elseif consumableDatabase[itemId] then
		if (playerLevel - (requiredLevel or 1)) >= 10 then
			return "consumable"
		end
	elseif equipmentDatabase[itemId] then
		return "equipment"
	elseif rarity == 0 and (sellPrice or 0) > 0 then
		return "gray"
	end

	return nil
end

local function isBetterDeletionCandidate(candidate, current)
	if candidate.value < current.value then
		return true
	end
	if candidate.value == current.value then
		return ns.DeletePriority[candidate.deleteReason] < ns.DeletePriority[current.deleteReason]
	end
	return false
end

function ns:FindItemToDelete()
	if isCacheValid then
		return cachedItem
	end

	local best = nil
	local _, playerClass = UnitClass("player")
	local isDataMissing = false
	local classReagentExclusions = (ns.ClassReagentExclusions and ns.ClassReagentExclusions[playerClass]) or {}

	for bag = 0, 4 do
		local slotCount = GetContainerNumSlots(bag) or 0
		for slot = 1, slotCount do
			local itemInfo = GetContainerItemInfo(bag, slot)

			if itemInfo and itemInfo.hyperlink then
				local itemId = itemInfo.itemID

				if not ns:IsIgnored(itemId) and not classReagentExclusions[itemId] then
					local name, _, rarity, _, requiredLevel, _, _, _, _, icon, sellPrice =
						GetItemInfo(itemInfo.hyperlink)

					if not name then
						isDataMissing = true
						if C_Item and C_Item.RequestLoadItemDataByID then
							C_Item.RequestLoadItemDataByID(itemId)
						end
					else
						local count = itemInfo.stackCount or 1
						local totalValue = (sellPrice or 0) * count
						local deleteReason = self:GetItemDeleteReason(itemId, rarity, sellPrice, requiredLevel)

						if deleteReason then
							local candidate = {
								link = itemInfo.hyperlink,
								itemId = itemId,
								count = count,
								value = totalValue,
								icon = icon,
								bag = bag,
								slot = slot,
								deleteReason = deleteReason,
							}
							if not best or isBetterDeletionCandidate(candidate, best) then
								best = candidate
							end
						end
					end
				end
			end
		end
	end

	if isDataMissing then
		ScheduleScanRetry()
	end

	cachedItem = best
	isCacheValid = true
	return best
end

--------------------------------------------------------------------------------
-- Deletion
--------------------------------------------------------------------------------

function ns:RunEraser()
	if InCombatLockdown() then
		self:PrintMessage(L["COMBAT_LOCKOUT"])
		return
	end

	local item = self:FindItemToDelete()

	if item then
		if CursorHasItem() then
			ClearCursor()
		end
		PickupContainerItem(item.bag, item.slot)

		local cursorType, cursorItemId = GetCursorInfo()
		if cursorType == "item" and cursorItemId == item.itemId then
			DeleteCursorItem()
			PlaySound(5156)

			local stackString = (item.count > 1) and format(" x%d", item.count) or ""

			local valueString
			if item.deleteReason == "quest" then
				valueString = L["ERASED_QUEST_SUFFIX"]
			elseif item.value > 0 then
				valueString = format(L["ERASED_VALUE_SUFFIX"], ns:FormatCurrency(item.value))
			else
				valueString = ""
			end

			self:PrintMessage(format(L["ERASED_ITEM"], item.link, stackString, valueString))

			ns:InvalidateCache()
			C_Timer.After(0.2, function()
				ns:RefreshDisplay()
			end)
			return
		else
			self:PrintMessage(L["CURSOR_TOO_FAST"])
			ClearCursor()
		end
	else
		self:PrintMessage(L["BAGS_CLEAN_SHORT"] .. " " .. L["BAGS_CLEAN_HINT"])
	end

	ns:RefreshDisplay()
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

--[[
    The add-on's complete event surface and the single source the dispatcher
    registers from -- add an event here and it is registered, dispatched, and
    covered by the Diagnostic Tools panel automatically, with no second list to
    keep in sync. Feature files own their handlers (Auto-Vend.lua defines
    ns:OnMerchantShow / ns:OnMerchantClosed); the dispatcher routes each event to
    its handler so every event passes through one point, which is what makes the
    diagnostics event log complete.
]]
ns.EVENT_NAMES = {
	"PLAYER_LOGIN",
	"PLAYER_LEVEL_UP",
	"BAG_UPDATE_DELAYED",
	"QUEST_TURNED_IN",
	"MERCHANT_SHOW",
	"MERCHANT_CLOSED",
	"PLAYER_REGEN_ENABLED",
}

local EVENT_HANDLERS = {
	PLAYER_LOGIN = "OnPlayerLogin",
	PLAYER_LEVEL_UP = "OnPlayerLevelUp",
	BAG_UPDATE_DELAYED = "OnBagUpdateDelayed",
	QUEST_TURNED_IN = "OnQuestTurnedIn",
	MERCHANT_SHOW = "OnMerchantShow",
	MERCHANT_CLOSED = "OnMerchantClosed",
	PLAYER_REGEN_ENABLED = "OnCombatEnded",
}

local updatePending = false

function ns:OnPlayerLogin()
	--[[
        MIGRATION (remove after 2026-10-08): the pre-AceDB build kept two raw
        saved tables -- account-wide MagicEraserDB (showWelcome, minimap, and, on
        the oldest builds, an account-level autoVendEnabled) and per-character
        MagicEraserCharDB (autoVendEnabled, autoVendMessagesEnabled, ignoreList).
        Capture those legacy values before AceDB adopts MagicEraserDB, fold them
        into the profile once the database exists, then clear the legacy keys.
        autoVendEnabled prefers the per-character value and falls back to the old
        account-level one, folding in the previous account->character migration.
    ]]
	local legacyAccount = MagicEraserDB
	local legacyChar = MagicEraserCharDB
	local hasLegacyAccount = type(legacyAccount) == "table"
	local hasLegacyChar = type(legacyChar) == "table"

	--[[
        Read each legacy value only inside its table guard so a fresh install
        leaves every capture nil. Folding the guard into the expression (e.g.
        `hasLegacyAccount and legacyAccount.showWelcome`) would yield false, not
        nil, when no legacy table exists -- and the ~= nil checks below would then
        overwrite a correct default (true) with that false.
    ]]
	local legacyShowWelcome, legacyMinimap
	local legacyAutoVend, legacyAutoVendMessages, legacyIgnoreList
	if hasLegacyAccount then
		legacyShowWelcome = legacyAccount.showWelcome
		if type(legacyAccount.minimap) == "table" then
			legacyMinimap = legacyAccount.minimap
		end
	end
	if hasLegacyChar then
		legacyAutoVendMessages = legacyChar.autoVendMessagesEnabled
		if type(legacyChar.ignoreList) == "table" then
			legacyIgnoreList = legacyChar.ignoreList
		end
	end

	if hasLegacyChar and legacyChar.autoVendEnabled ~= nil then
		legacyAutoVend = legacyChar.autoVendEnabled
	elseif hasLegacyAccount and legacyAccount.autoVendEnabled ~= nil then
		legacyAutoVend = legacyAccount.autoVendEnabled
	end

	ns.db = LibStub("AceDB-3.0"):New("MagicEraserDB", ns.DATABASE_DEFAULTS, true)

	local profile = ns.db.profile
	if legacyShowWelcome ~= nil then
		profile.showWelcome = legacyShowWelcome
	end
	if legacyAutoVend ~= nil then
		profile.autoVendEnabled = legacyAutoVend
	end
	if legacyAutoVendMessages ~= nil then
		profile.autoVendMessagesEnabled = legacyAutoVendMessages
	end
	if legacyIgnoreList then
		for itemId in pairs(legacyIgnoreList) do
			profile.ignoreList[itemId] = true
		end
	end
	if legacyMinimap then
		for key, value in pairs(legacyMinimap) do
			ns.db.global.minimap[key] = value
		end
	end

	-- Clear the legacy keys now that everything lives in the profile.
	MagicEraserDB.showWelcome = nil
	MagicEraserDB.minimap = nil
	MagicEraserDB.autoVendEnabled = nil
	MagicEraserCharDB = nil

	ns:RegisterOptionsPanels()

	local LibDBIcon = LibStub("LibDBIcon-1.0")
	if LibDBIcon and ns.LDBObject then
		LibDBIcon:Register(ADDON_NAME, ns.LDBObject, ns.db.global.minimap)
	end

	if ns.db.profile.showWelcome then
		ns:PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
	end

	ns:RefreshDisplay()
end

--[[
    Consumable eligibility is gated on the player's level
    (playerLevel - requiredLevel >= 10 in GetItemDeleteReason), so leveling up
    can newly qualify outgrown food. Re-scan on level-up so the candidate
    reflects the new level immediately instead of waiting for the next bag
    update or quest turn-in to happen to fire.
]]
function ns:OnPlayerLevelUp()
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

function ns:OnBagUpdateDelayed()
	if not updatePending then
		updatePending = true
		C_Timer.After(0.1, function()
			ns:InvalidateCache()
			ns:RefreshDisplay()
			updatePending = false
		end)
	end
end

function ns:OnQuestTurnedIn(questId)
	C_Timer.After(1.0, function()
		local questItemDatabase = ns.AllowedDeleteQuestItems or {}
		local alertedItems = {}

		for bag = 0, 4 do
			local slotCount = GetContainerNumSlots(bag) or 0
			for slot = 1, slotCount do
				local itemInfo = GetContainerItemInfo(bag, slot)
				if itemInfo then
					local itemId = itemInfo.itemID

					if questItemDatabase[itemId] and not alertedItems[itemId] then
						for _, trackedQuestId in ipairs(questItemDatabase[itemId]) do
							if trackedQuestId == questId then
								ns:PrintMessage(format(L["QUEST_ITEM_READY"], itemInfo.hyperlink))
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

--[[
    Central dispatcher. Every registered event routes through here: it taps the
    diagnostics event log first (a single boolean check when logging is off, so
    it costs nothing) and then calls the event's handler, resolved by name at
    fire time so feature files loaded after Core can supply their own.
]]
local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if ns.diagnostics and ns.diagnostics.logging then
		ns:LogEvent(event, ...)
	end

	local handlerName = EVENT_HANDLERS[event]
	local handler = handlerName and ns[handlerName]
	if handler then
		handler(ns, ...)
	end
end)

for _, event in ipairs(ns.EVENT_NAMES) do
	eventFrame:RegisterEvent(event)
end
