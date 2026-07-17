local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local PickupContainerItem = C_Container.PickupContainerItem
local format, ipairs = string.format, ipairs

--------------------------------------------------------------------------------
-- Scan Cache
--------------------------------------------------------------------------------

local cachedItem = nil
local isCacheValid = false

--[[
    Running totals for the tooltip's Clutter Report, populated as a side effect
    of FindItemToDelete's single bag scan so the summary shares the candidate
    cache's lifecycle -- one scan feeds both the lowest-value pick and the
    report, and both go stale together on InvalidateCache. Slots counts bag slots
    freed; items counts stacked quantity (a stack of 5 is one slot, five items).
]]
local cachedReclaimSlots = 0
local cachedReclaimItems = 0
local cachedReclaimValue = 0

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
	cachedReclaimSlots = 0
	cachedReclaimItems = 0
	cachedReclaimValue = 0
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
	local reclaimSlots, reclaimItems, reclaimValue = 0, 0, 0
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
							-- Slots counts one per qualifying slot; items counts stacked quantity.
							reclaimSlots = reclaimSlots + 1
							reclaimItems = reclaimItems + count
							reclaimValue = reclaimValue + totalValue
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
	cachedReclaimSlots = reclaimSlots
	cachedReclaimItems = reclaimItems
	cachedReclaimValue = reclaimValue
	isCacheValid = true
	return best
end

--[[
    Totals for the tooltip's Clutter Report: slots freed, item quantity, and total
    value. FindItemToDelete populates these as a side effect of its scan, so
    callers must have called it first this cache cycle (the tooltip does, just
    above where it reads this).
]]
function ns:GetReclaimSummary()
	return cachedReclaimSlots or 0, cachedReclaimItems or 0, cachedReclaimValue or 0
end

--------------------------------------------------------------------------------
-- Deletion
--------------------------------------------------------------------------------

--[[
    Safety Guard. Maps each delete reason to its opt-in confirmation toggle. When
    the guard is on and the matching per-reason toggle is set, erasing that item
    pops a confirmation first. "White vendor-quality" maps to the curated
    equipment reason; the four reasons GetItemDeleteReason returns line up 1:1
    with the four toggles.
]]
local SAFETY_REASON_KEYS = {
	quest = "safetyQuest",
	consumable = "safetyConsumable",
	equipment = "safetyWhite",
	gray = "safetyGray",
}

function ns:NeedsSafetyConfirm(item)
	if not (item and ns.db and ns.db.global.safetyEnabled) then
		return false
	end
	local key = SAFETY_REASON_KEYS[item.deleteReason]
	return (key and ns.db.global[key]) and true or false
end

--[[
    Confirmation dialog for guarded erases. The candidate is passed as the
    dialog's data so each showing acts on the exact item the player saw, and
    PerformErase re-validates the slot before deleting. preferredIndex = 3 avoids
    tainting the shared dialog stack.
]]
StaticPopupDialogs["MAGICERASER_CONFIRM_ERASE"] = {
	text = L["CONFIRM_ERASE"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(_, data)
		if data then
			ns:PerformErase(data)
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
	preferredIndex = 3,
}

--[[
    Actually erase the item: pick it up and delete it from the cursor. The
    cursor's item id is re-checked against the candidate so a slot that shifted
    (e.g. while a confirmation was open) aborts instead of deleting the wrong
    thing. Re-guards combat because a safety confirmation can span the moment
    combat begins.
]]
function ns:PerformErase(item)
	if InCombatLockdown() then
		self:PrintMessage(L["COMBAT_LOCKOUT"])
		return
	end

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

	ns:RefreshDisplay()
end

function ns:RunEraser()
	if InCombatLockdown() then
		self:PrintMessage(L["COMBAT_LOCKOUT"])
		return
	end

	local item = self:FindItemToDelete()

	if not item then
		self:PrintMessage(L["BAGS_CLEAN_SHORT"] .. " " .. L["BAGS_CLEAN_HINT"])
		ns:RefreshDisplay()
		return
	end

	if ns:NeedsSafetyConfirm(item) then
		local stackString = (item.count > 1) and format(" x%d", item.count) or ""
		StaticPopup_Show("MAGICERASER_CONFIRM_ERASE", item.link, stackString, item)
	else
		ns:PerformErase(item)
	end
end
