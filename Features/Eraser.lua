local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local PickupContainerItem = C_Container.PickupContainerItem
local GetItemInfo = C_Item.GetItemInfo
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
    item info never resolves would reschedule forever; without a pending
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
-- Scanning
--------------------------------------------------------------------------------

local function IsBetterDeletionCandidate(candidate, current)
	if candidate.value < current.value then
		return true
	end
	if candidate.value == current.value then
		return ns.DELETE_PRIORITY[candidate.deleteReason] < ns.DELETE_PRIORITY[current.deleteReason]
	end
	return false
end

--[[
    One walk of the carried bags, handing each erasable stack to visit. Shared
    by the cached single-best scan below and the ranked queue the Your Current
    Bags panel draws, so the two can never disagree about what counts. Returns
    true when some item's data was still loading.
]]
local function ForEachCandidate(visit)
	local isDataMissing = false

	for _, bag in ipairs(ns.CARRIED_BAGS) do
		local slotCount = GetContainerNumSlots(bag) or 0
		for slot = 1, slotCount do
			local itemInfo = GetContainerItemInfo(bag, slot)

			if itemInfo and itemInfo.hyperlink then
				local itemId = itemInfo.itemID

				-- Ignore List first, so it wins over any Erase List entry.
				if not ns:IsIgnored(itemId) then
					local name, _, rarity, _, _, _, _, _, _, icon, sellPrice = GetItemInfo(itemInfo.hyperlink)

					if not name then
						isDataMissing = true
						C_Item.RequestLoadItemDataByID(itemId)
					else
						local count = itemInfo.stackCount or 1
						local totalValue = (sellPrice or 0) * count
						local deleteReason = ns:GetItemDeleteReason(itemId, rarity, sellPrice)

						if deleteReason and not ns:IsOverValueCap(totalValue, deleteReason) then
							visit({
								link = itemInfo.hyperlink,
								itemId = itemId,
								count = count,
								value = totalValue,
								icon = icon,
								bag = bag,
								slot = slot,
								deleteReason = deleteReason,
							})
						end
					end
				end
			end
		end
	end

	return isDataMissing
end

function ns:FindItemToDelete()
	if isCacheValid then
		return cachedItem
	end

	local best = nil
	local reclaimSlots, reclaimItems, reclaimValue = 0, 0, 0

	local isDataMissing = ForEachCandidate(function(candidate)
		-- Slots counts one per qualifying slot; items counts stacked quantity.
		reclaimSlots = reclaimSlots + 1
		reclaimItems = reclaimItems + candidate.count
		reclaimValue = reclaimValue + candidate.value
		if not best or IsBetterDeletionCandidate(candidate, best) then
			best = candidate
		end
	end)

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

--[[
    Every erasable stack in the bags, in the order the eraser would take them,
    for the Your Current Bags panel. Not cached: the panel asks only while it is
    on screen, and the mini-map's single-best scan keeps its own cache. The first
    entry is always the one FindItemToDelete picks, because both rank through
    IsBetterDeletionCandidate; bag position breaks the last tie so the order
    holds still between repaints.
]]
function ns:GetEraseQueue()
	local queue = {}
	ForEachCandidate(function(candidate)
		queue[#queue + 1] = candidate
	end)
	table.sort(queue, function(a, b)
		if IsBetterDeletionCandidate(a, b) then
			return true
		end
		if IsBetterDeletionCandidate(b, a) then
			return false
		end
		if a.bag ~= b.bag then
			return a.bag < b.bag
		end
		return a.slot < b.slot
	end)
	return queue
end

--------------------------------------------------------------------------------
-- Deletion
--------------------------------------------------------------------------------

--[[
    Erase Confirmation. With the switch on, every erase pops a confirmation
    first, Erase List entries included, from the mini-map button, the key
    binding and the Your Current Bags panel alike, since all three enter
    through ns:RunEraser.
]]
function ns:NeedsSafetyConfirm(item)
	return item ~= nil and (ns.db and ns.db.profile.eraseConfirmEnabled) and true or false
end

--[[
    Confirmation dialog for guarded erases. The candidate is passed as the
    dialog's data so each showing acts on the exact item the player saw, and
    PerformErase erases only if the slot still holds that exact stack and the
    cursor then picks up the same item. preferredIndex = 3 avoids tainting the
    shared dialog stack.
]]
StaticPopupDialogs["MAGICERASER_CONFIRM_ERASE"] = { -- luacheck: ignore 122
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
    Whether the slot still holds exactly the stack the candidate describes, and
    that stack is still erasable. A confirmation can stay open while looting
    grows the pile or the player protects the item, and Yes must then erase
    nothing rather than more than the player agreed to.
]]
local function IsCandidateCurrent(item)
	local info = GetContainerItemInfo(item.bag, item.slot)
	if not info or info.itemID ~= item.itemId or (info.stackCount or 1) ~= item.count then
		return false
	end
	if ns:IsIgnored(item.itemId) then
		return false
	end
	local name, _, rarity, _, _, _, _, _, _, _, sellPrice = GetItemInfo(item.itemId)
	if not name then
		return false
	end
	local deleteReason = ns:GetItemDeleteReason(item.itemId, rarity, sellPrice)
	return deleteReason ~= nil and not ns:IsOverValueCap((sellPrice or 0) * item.count, deleteReason)
end

--[[
    Actually erase the item: pick it up and delete it from the cursor. Two
    checks stand in front of the delete: the slot must still hold the stack the
    candidate describes (IsCandidateCurrent), and the cursor's item id must match
    it once picked up, so a slot that shifted aborts instead of deleting the
    wrong thing. Re-guards combat because a safety confirmation can span the
    moment combat begins.
]]
function ns:PerformErase(item)
	if InCombatLockdown() then
		self:PrintMessage(L["COMBAT_LOCKOUT"])
		return
	end

	if not IsCandidateCurrent(item) then
		self:PrintMessage(L["ERASE_CANDIDATE_CHANGED"])
		ns:InvalidateCache()
		ns:RefreshDisplay()
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

		--[[
		    Just the item, never its value or why it went. Quest leftovers already
		    got their "can now be safely erased" alert, so repeating the reason is
		    noise, and the price of something gone for good only stings.
		]]
		self:PrintMessage(format(L["ERASED_ITEM"], item.link, stackString))

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

--------------------------------------------------------------------------------
-- Erasing
--------------------------------------------------------------------------------

function ns:RunEraser()
	if InCombatLockdown() then
		self:PrintMessage(L["COMBAT_LOCKOUT"])
		return
	end

	local item = self:FindItemToDelete()

	if not item then
		self:PrintMessage(L["BAGS_CLEAN_CONGRATS"] .. " " .. L["BAGS_CLEAN_HINT"])
		ns:RefreshDisplay()
		return
	end

	if ns:NeedsSafetyConfirm(item) then
		local stackString = (item.count > 1) and format(" x%d", item.count) or ""
		StaticPopup_Show("MAGICERASER_CONFIRM_ERASE", ns:StripLinkBrackets(item.link), stackString, item)
	else
		ns:PerformErase(item)
	end
end
