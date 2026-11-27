local _, ns = ...
local L = ns.L
local Tip = ns.TooltipKit

--------------------------------------------------------------------------------
-- Junk Item Tooltips
--------------------------------------------------------------------------------

-- The verdict is the eraser's own scan (ns:GetJunkReason), so tooltip, tint and eraser always agree.

local KIND_LABELS = { manual = "TAB_ERASE_LIST" }
for _, kind in ipairs(ns.ERASE_KINDS) do
	KIND_LABELS[kind[1]] = kind[2]
end

local function TooltipsOn()
	return ns.db and ns.db.profile.tooltipsEnabled
end

-- The list that protects it, this character's first, as ns:IsIgnored checks.
local function ProtectedBy(itemId)
	local list = ns:GetIgnoreList()
	if list and list[itemId] then
		return L["TOOLTIP_PROTECTED_CHARACTER"]
	end
	return L["TOOLTIP_PROTECTED_GLOBAL"]
end

Tip.OnItem(function(block, itemId)
	if not TooltipsOn() then
		return
	end

	if ns:IsIgnored(itemId) then
		block:Header(L["TOOLTIP_PROTECTED"]):Row(ProtectedBy(itemId))
		return
	end

	local reason = ns:GetJunkReason(itemId)
	local label = reason and KIND_LABELS[reason]
	if not label then
		return
	end
	local nextItem = ns:FindItemToDelete()
	local erasedNext = nextItem and nextItem.itemId == itemId
	block:Header(L["TOOLTIP_JUNK"]):Row(L[label], erasedNext and L["TOOLTIP_ERASED_NEXT"] or nil)
end, { bagsOnly = true })
