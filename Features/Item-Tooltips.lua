local _, ns = ...
local L = ns.L
local GetColor = ns.GetColor
local GetItemInfo = C_Item.GetItemInfo

--------------------------------------------------------------------------------
-- Item Tooltip Warning
--------------------------------------------------------------------------------

--[[
    Appends a single branded line to an item's tooltip: a warning when Magic
    Eraser would erase the item, a distinct one when the item is on an Erase
    List, or a protection notice when the Ignore List is shielding it. The
    verdict comes from the very rules the eraser's scan uses (ns:IsIgnored and
    ns:GetItemDeleteReason), in the same order, so the line shows only when the
    item truly would be erased -- the consumable and ammo level gates and the
    quest-completion check included. Purely read-only.

    Two hook paths, because the tooltip API differs across the flavors we target:
    WoW Forever's GameTooltip is data-driven and runs TooltipDataProcessor
    post-calls; the others instead get a hooksecurefunc on GameTooltip:SetBagItem. Hooking the setter (not
    the shared OnTooltipSetItem script) means our line is added AFTER other add-ons'
    OnTooltipSetItem rebuilds, so a heavy tooltip add-on like TSM that clears and
    re-fills the tooltip can't wipe our line. Only one path is ever active, so the
    line is never doubled.

    Layout mirrors the add-on's chat output -- ns.BRAND_PREFIX ("Magic Eraser //")
    plus a colored body -- under a one-line spacer, so it reads as a distinct
    footer near the bottom of the tooltip. White (TEXT) for the protected
    notice, red (OFF) for the will-erase warning.
]]
--[[
    The bag and slot the tooltip is anchored to, or nil unless the anchor is one
    of the player's carried bag slots (ns.CARRIED_BAGS) -- never a
    merchant, bank, or chat-link tooltip. Used by the TooltipDataProcessor path,
    which fires for every item tooltip and so needs this filter; the SetBagItem
    path is already bag-scoped by its own args. Modern container item buttons
    expose GetBagID(); the default frames fall back to their ContainerFrame name
    and the parent frame's bag id. The slot is the button's own id either way.

    The slot half is what the value cap needs: the cap is judged on the stack,
    so the tooltip has to know which stack it is looking at rather than just
    which bag.
]]
local function GetCarriedBagSlot(tooltip)
	local owner = tooltip:GetOwner()
	if not owner then
		return nil
	end

	local slot = owner.GetID and owner:GetID()
	if type(slot) ~= "number" then
		return nil
	end

	local getBagID = owner.GetBagID
	if type(getBagID) == "function" then
		local ok, bag = pcall(getBagID, owner)
		if ok and ns.IS_CARRIED_BAG[bag] then
			return bag, slot
		end
	end

	local name = owner.GetName and owner:GetName()
	if name and name:find("ContainerFrame", 1, true) then
		local parent = owner.GetParent and owner:GetParent()
		local bag = parent and parent.GetID and parent:GetID()
		if ns.IS_CARRIED_BAG[bag] then
			return bag, slot
		end
	end

	return nil
end

--[[
    The stack sitting in one bag slot, for the value cap's comparison. The item
    id is re-checked against the slot rather than trusted, so a slot we resolved
    wrongly falls back to a single item and the cap is judged on the unit price
    -- protecting less than it should, never more, which is the safe direction
    for a guard the player switched on deliberately.
]]
local function GetBagStackCount(bag, slot, itemId)
	local info = bag and C_Container.GetContainerItemInfo(bag, slot)
	if info and info.itemID == itemId then
		return info.stackCount or 1
	end
	return 1
end

local function AddEraserWarning(tooltip, itemId, stackCount)
	if tooltip ~= GameTooltip or not (ns.db and ns.db.profile.tooltipWarningEnabled) then
		return
	end
	if not itemId then
		return
	end

	-- Ignore List protection wins over any erase verdict, Erase List included.
	if ns:IsIgnored(itemId) then
		tooltip:AddLine(" ")
		tooltip:AddLine(ns.BRAND_PREFIX .. GetColor("TEXT") .. L["TOOLTIP_IGNORED"] .. "|r")
		return true
	end

	-- Cold item cache: let the API resolve and add nothing this pass.
	local _, _, rarity, _, _, _, _, _, _, _, sellPrice = GetItemInfo(itemId)
	if rarity == nil then
		return
	end

	local deleteReason = ns:GetItemDeleteReason(itemId, rarity, sellPrice)
	if not deleteReason then
		return
	end

	--[[
	    Over the player's Maximum Value to Erase, the eraser leaves it alone, so
	    the tooltip says nothing rather than promising an erase that never comes.
	    The reason is passed through because an Erase List entry is exempt from
	    the cap and so always keeps its line (see ns:IsOverValueCap).

	    The verdict is read before the cap here, where the scan reads it after.
	    Same outcome either way, since the cap only ever suppresses; this order
	    just means the exemption is decided in one place instead of two.
	]]
	if ns:IsOverValueCap((sellPrice or 0) * (stackCount or 1), deleteReason) then
		return
	end

	--[[
	    A listed item names the Erase List rather than the generic warning. The
	    player put it there, possibly months ago on another character, so saying
	    which list is what turns a surprise into a reminder.
	]]
	local warning = (deleteReason == "manual") and L["TOOLTIP_ON_ERASE_LIST"] or L["TOOLTIP_WILL_ERASE"]
	tooltip:AddLine(" ")
	tooltip:AddLine(ns.BRAND_PREFIX .. GetColor("OFF") .. warning .. "|r")
	return true
end

--[[
    The data-driven path needs both halves: TooltipDataProcessor to register
    with, and a GameTooltip that runs its setters through ProcessInfo. TBC
    Anniversary loads TooltipDataProcessor but its GameTooltip never mixes in
    the data handler (only WoW Forever's Mainline GameTooltip does, per
    wow-ui-source), so a post-call registered there never fires.
]]
local function IsTooltipDataDriven()
	return TooltipDataProcessor
		and TooltipDataProcessor.AddTooltipPostCall
		and type(GameTooltip.ProcessInfo) == "function"
end

function ns.SetupTooltipHooks()
	if IsTooltipDataDriven() then
		--[[
		    Modern data-driven hook. Fires for any item tooltip, so gate to bag
		    slots (data.id is the itemID; see Enum.TooltipDataType.Item).
		]]
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
			local bag, slot = GetCarriedBagSlot(tooltip)
			if bag then
				local itemId = data and data.id
				AddEraserWarning(tooltip, itemId, GetBagStackCount(bag, slot, itemId))
			end
		end)
	else
		--[[
		    Clients whose GameTooltip isn't data-driven (Classic Era, TBC
		    Anniversary): hook the bag-item setter. hooksecurefunc wraps whatever
		    GameTooltip:SetBagItem currently is, so it runs after the wrapped
		    function returns. Because this is registered late (ns:OnPlayerLogin in
		    Core.lua defers it a frame), we wrap OTHER add-ons' hooks/wrappers --
		    TSM replaces the tooltip setters with prehook/orig/posthook wrappers on
		    these clients -- landing outermost, so our line is added last and
		    survives their rebuilds.
		    Bag-scoped: the bag arg is the container, and anything not in
		    ns.IS_CARRIED_BAG, bank bags included, is excluded, so no owner
		    sniffing is needed.

		    Running outermost means the tooltip has already been sized and shown, so
		    AddLine alone would render our line outside the frame. Re-Show() when we
		    added a line so the tooltip grows to include it.
		]]
		hooksecurefunc(GameTooltip, "SetBagItem", function(tooltip, bag, slot)
			if not ns.IS_CARRIED_BAG[bag] then
				return
			end
			local info = C_Container.GetContainerItemInfo(bag, slot)
			if AddEraserWarning(tooltip, info and info.itemID, info and info.stackCount) then
				tooltip:Show()
			end
		end)
	end
end
