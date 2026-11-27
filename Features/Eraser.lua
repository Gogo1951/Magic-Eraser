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

-- Clutter Report totals, filled by FindItemToDelete's scan and dropped with it. Items count stacked quantity.
local cachedReclaimSlots = 0
local cachedReclaimItems = 0
local cachedReclaimValue = 0

-- Junk slots from the same scan, so the tint and the eraser never disagree.
local SLOT_KEY_STRIDE = 1000
local cachedJunkSlots = {}

-- The same scan's verdicts by item id, for the item tooltips (Features/Item-Tooltips.lua).
local cachedJunkReasons = {}

--[[
    Capped, one pending at a time, and reset by any InvalidateCache that isn't
    itself a retry: an item that never loads must not reschedule forever.
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
	cachedJunkSlots = {}
	cachedJunkReasons = {}
	if not inScanRetry then
		scanRetries = 0
	end
end

function ns:GetScanRetryState()
	return scanRetries, MAX_SCAN_RETRIES, retryPending
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
		ns:RefreshWhenOutOfCombat()
		inScanRetry = false
	end)
end

--------------------------------------------------------------------------------
-- Scanning
--------------------------------------------------------------------------------

-- Ammo goes last: nearly worthless, so cheapest-first would empty the quiver before the gray cloth.
local PROJECTILE_CLASS = (Enum and Enum.ItemClass and Enum.ItemClass.Projectile) or 6

local function IsBetterDeletionCandidate(candidate, current)
	if candidate.isProjectile ~= current.isProjectile then
		return current.isProjectile
	end
	if candidate.value < current.value then
		return true
	end
	if candidate.value == current.value then
		return ns.DELETE_PRIORITY[candidate.deleteReason] < ns.DELETE_PRIORITY[current.deleteReason]
	end
	return false
end

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
					local name, _, rarity, _, _, _, _, _, _, icon, sellPrice, classId = GetItemInfo(itemInfo.hyperlink)

					if not name then
						isDataMissing = true
						C_Item.RequestLoadItemDataByID(itemId)
					else
						local count = itemInfo.stackCount or 1
						local totalValue = (sellPrice or 0) * count
						local deleteReason = ns:GetItemDeleteReason(itemId, rarity, sellPrice, bag, slot)

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
								isProjectile = classId == PROJECTILE_CLASS,
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
	local junkSlots = {}
	local junkReasons = {}

	local isDataMissing = ForEachCandidate(function(candidate)
		junkSlots[candidate.bag * SLOT_KEY_STRIDE + candidate.slot] = candidate.itemId
		junkReasons[candidate.itemId] = candidate.deleteReason
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
	cachedJunkSlots = junkSlots
	cachedJunkReasons = junkReasons
	isCacheValid = true
	return best
end

-- The scan can lag the bags, so a slot whose item changed answers false rather than lend its old verdict.
function ns:IsJunkSlot(bag, slot, itemId)
	ns:FindItemToDelete()
	local junkItemId = cachedJunkSlots[bag * SLOT_KEY_STRIDE + slot]
	return junkItemId ~= nil and junkItemId == itemId
end

-- By item id: one junk stack of it answers for every stack.
function ns:GetJunkReason(itemId)
	ns:FindItemToDelete()
	return cachedJunkReasons[itemId]
end

-- Zeros unless FindItemToDelete has run since the last invalidation.
function ns:GetReclaimSummary()
	return cachedReclaimSlots or 0, cachedReclaimItems or 0, cachedReclaimValue or 0
end

--------------------------------------------------------------------------------
-- Deletion
--------------------------------------------------------------------------------

function ns:NeedsSafetyConfirm(item)
	return item ~= nil and (ns.db and ns.db.profile.eraseConfirmEnabled) and true or false
end

-- The candidate rides as the dialog's data, so Yes acts on the exact stack shown. preferredIndex = 3 avoids taint.
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

-- A confirmation can stay open while the stack grows or gets protected; Yes must then erase nothing.
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
	local deleteReason = ns:GetItemDeleteReason(item.itemId, rarity, sellPrice, item.bag, item.slot)
	return deleteReason ~= nil and not ns:IsOverValueCap((sellPrice or 0) * item.count, deleteReason)
end

-- Re-guards combat: a confirmation can stay open into a fight. The cursor check stops a shifted slot.
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

		-- Just the item, never its value or reason: quest items already had their alert.
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
