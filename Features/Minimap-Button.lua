local ADDON_NAME, ns = ...

local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

--------------------------------------------------------------------------------
-- Display Refresh
--------------------------------------------------------------------------------

--[[
    The button wears the icon of the item a Left-Click will erase next, set
    through the LDB object alone so LibDBIcon and every LDB display follow it.
    Reads the scan cache as it stands; ns:RefreshDisplay drops the cache first,
    and ns.RefreshSettings calls this after any writer that changed what counts.
    Nothing to scan before the database opens: UPDATE_BINDINGS can reach
    ns.RefreshSettings ahead of PLAYER_LOGIN.
]]
function ns.UpdateMinimapIcon()
	if not (ns.dataBrokerObject and ns.db) then
		return
	end

	local item = ns:FindItemToDelete()
	ns.dataBrokerObject.icon = (item and item.icon) or ns.DEFAULT_ICON
end

--[[
    Every bag change lands here. The scan cache is dropped, the button takes the
    next item's icon (ns.UpdateMinimapIcon), the open menu redraws on the new
    item, and the bag tints catch up (Features/Tint-Junk.lua). The options
    panels are left alone, so an item ID being typed into a list page survives
    the loot that lands meanwhile; settings changes repaint them through
    ns.RefreshSettings (Options/Options-Kit.lua) instead.
]]
function ns:RefreshDisplay()
	if not ns.dataBrokerObject then
		return
	end

	ns:InvalidateCache()
	ns.UpdateMinimapIcon()

	ns.RefreshMenu()
	ns:RefreshTints()
end

--------------------------------------------------------------------------------
-- LDB Data Object
--------------------------------------------------------------------------------

--[[
    A launcher: hovering opens the menu (Features/Minimap-Menu.lua), and a click
    runs its job from the menu's click table. Every click has a job except
    Shift + Left-Click, which opens and holds the menu like a launcher's
    Left-Click. OnEnter rather than OnTooltipShow, since LibDBIcon and every LDB
    display call it on hover, and the menu closes itself once the cursor leaves,
    so OnLeave has nothing to do.
]]
ns.dataBrokerObject = LibDataBroker:NewDataObject(ADDON_NAME, {
	type = "launcher",
	label = ns.ADDON_TITLE,
	icon = ns.DEFAULT_ICON,

	OnClick = function(self, button)
		if not ns.RunButtonClick(button) and button == "LeftButton" then
			ns.ShowMenu(self, "click")
		end
	end,

	OnEnter = function(self)
		ns.ShowMenu(self, "hover")
	end,

	OnLeave = function() end,
})

--------------------------------------------------------------------------------
-- Button Registration
--------------------------------------------------------------------------------

--[[
    Called from ns:OnPlayerLogin once ns.db exists. The button's position and
    its Enable Mini-map Button switch live in the profile, so a profile switch
    or reset moves it too (ns:ApplyMinimapButton).
]]
function ns:RegisterMinimapButton()
	if not ns.dataBrokerObject then
		return
	end

	LibDBIcon:Register(ADDON_NAME, ns.dataBrokerObject, ns.db.profile.minimap)

	if ns.FLAVOR == "Camelot" or ns.FLAVOR == "Mainline" then
		--[[
		    Size and anchor the icon directly rather than through
		    SetButtonIcon: that first runs LibDBIcon's ResetButtonIcon, which
		    calls icon:UpdateCoord() and errors when another add-on has
		    rebuilt or replaced the button's icon without that method.
		]]
		local button = LibDBIcon:GetMinimapButton(ADDON_NAME)
		if button and button.icon then
			button.icon:SetSize(20, 20)
			button.icon:ClearAllPoints()
			button.icon:SetPoint("CENTER", 1, -0.35)
			local mask = button:CreateMaskTexture()
			mask:SetTexture(130924, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE") -- Interface\CharacterFrame\TempPortraitAlphaMask
			mask:SetAllPoints(button.icon)
			button.icon:AddMaskTexture(mask)
		end
	end
end

-- Puts the button where the active profile has it, shown or hidden as its switch says.
function ns:ApplyMinimapButton()
	if not ns.db then
		return
	end
	LibDBIcon:Refresh(ADDON_NAME, ns.db.profile.minimap)
end
