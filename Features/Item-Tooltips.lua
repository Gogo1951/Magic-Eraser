local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Item Tooltip Warning
--------------------------------------------------------------------------------

--[[
    Appends a single branded line to an item's tooltip: a warning when Magic
    Eraser would erase the item, or a protection notice when the Ignore List is
    shielding it. The verdict comes from the very rules the eraser's scan uses
    (ns:IsIgnored, the class-reagent exclusions, and ns:GetItemDeleteReason), so
    the line shows only when the item truly would be erased -- the consumable
    level gate and quest-completion check included. Purely read-only.

    Two hook paths, because the tooltip API differs across the flavors we target:
    modern clients expose the data-driven TooltipDataProcessor; others lack it and
    instead get a hooksecurefunc on GameTooltip:SetBagItem. Hooking the setter (not
    the shared OnTooltipSetItem script) means our line is added AFTER other add-ons'
    OnTooltipSetItem rebuilds, so a heavy tooltip add-on like TSM that clears and
    re-fills the tooltip can't wipe our line. Only one path is ever active, so the
    line is never doubled.

    Layout mirrors the add-on's chat output -- ns.BrandPrefix ("Magic Eraser //")
    plus a colored body -- under a one-line spacer, so it reads as a distinct
    footer near the bottom of the tooltip. White (TEXT) for the protected
    notice, red (OFF) for the will-erase warning.
]]
--[[
    True only when the tooltip is anchored to one of the player's carried bag
    slots (bags 0..NUM_BAG_SLOTS) -- never a merchant, bank, or chat-link tooltip.
    Used by the TooltipDataProcessor path, which fires for every item tooltip and
    so needs this filter; the SetBagItem path is already bag-scoped by its own
    args. Modern container item buttons expose GetBagID(); the default frames fall
    back to their ContainerFrame name and the parent frame's bag id.
]]
local function IsCarriedBagSlot(tooltip)
	local owner = tooltip:GetOwner()
	if not owner then
		return false
	end

	local getBagID = owner.GetBagID
	if type(getBagID) == "function" then
		local ok, bag = pcall(getBagID, owner)
		if ok and type(bag) == "number" then
			return bag >= 0 and bag <= NUM_BAG_SLOTS
		end
	end

	local name = owner.GetName and owner:GetName()
	if name and name:find("ContainerFrame", 1, true) then
		local parent = owner.GetParent and owner:GetParent()
		local bag = parent and parent.GetID and parent:GetID()
		if type(bag) == "number" then
			return bag >= 0 and bag <= NUM_BAG_SLOTS
		end
	end

	return false
end

local function AddEraserWarning(tooltip, itemId)
	if tooltip ~= GameTooltip or not (ns.db and ns.db.global.tooltipWarningEnabled) then
		return
	end
	if not itemId then
		return
	end

	-- Ignore List protection wins over any erase verdict.
	if ns:IsIgnored(itemId) then
		tooltip:AddLine(" ")
		tooltip:AddLine(ns.BrandPrefix .. GetColor("TEXT") .. L["TOOLTIP_IGNORED"] .. "|r")
		return true
	end

	-- Class reagents the scan skips are never erased; say nothing.
	local _, playerClass = UnitClass("player")
	local classReagentExclusions = (ns.ClassReagentExclusions and ns.ClassReagentExclusions[playerClass]) or {}
	if classReagentExclusions[itemId] then
		return
	end

	-- Cold item cache: let the API resolve and add nothing this pass.
	local _, _, rarity, _, _, _, _, _, _, _, sellPrice = GetItemInfo(itemId)
	if rarity == nil then
		return
	end

	if ns:GetItemDeleteReason(itemId, rarity, sellPrice) then
		tooltip:AddLine(" ")
		tooltip:AddLine(ns.BrandPrefix .. GetColor("OFF") .. L["TOOLTIP_WILL_ERASE"] .. "|r")
		return true
	end
end

function ns.SetupTooltipHooks()
	if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
		-- Modern data-driven hook. Fires for any item tooltip, so gate to bag slots
		-- (data.id is the itemID; see Enum.TooltipDataType.Item).
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
			if IsCarriedBagSlot(tooltip) then
				AddEraserWarning(tooltip, data and data.id)
			end
		end)
	else
		--[[
		    Clients without TooltipDataProcessor: hook the bag-item setter.
		    hooksecurefunc wraps whatever GameTooltip:SetBagItem currently is, so it
		    runs after the wrapped function returns. Because this is registered late
		    (see below), we wrap OTHER add-ons' hooks/wrappers -- TSM replaces the
		    tooltip setters with prehook/orig/posthook wrappers on these clients --
		    landing outermost, so our line is added last and survives their rebuilds.
		    Bag-scoped: the bag arg is the container, and bank bags (5..11) are
		    excluded by the range check, so no owner sniffing is needed.

		    Running outermost means the tooltip has already been sized and shown, so
		    AddLine alone would render our line outside the frame. Re-Show() when we
		    added a line so the tooltip grows to include it.
		]]
		hooksecurefunc(GameTooltip, "SetBagItem", function(tooltip, bag, slot)
			if type(bag) ~= "number" or bag < 0 or bag > NUM_BAG_SLOTS then
				return
			end
			local info = C_Container and C_Container.GetContainerItemInfo(bag, slot)
			if AddEraserWarning(tooltip, info and info.itemID) then
				tooltip:Show()
			end
		end)
	end
end
