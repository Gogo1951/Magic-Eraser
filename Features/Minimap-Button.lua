local ADDON_NAME, ns = ...

local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

--------------------------------------------------------------------------------
-- Display Refresh
--------------------------------------------------------------------------------

--[[
    Set on the LDB object alone so every LDB display follows. Reads the scan
    cache as it stands. UPDATE_BINDINGS can reach here before PLAYER_LOGIN.
]]
function ns.UpdateMinimapIcon()
	if not (ns.dataBrokerObject and ns.db) then
		return
	end

	local item = ns:FindItemToDelete()
	ns.dataBrokerObject.icon = (item and item.icon) or ns.DEFAULT_ICON
end

--[[
    Bag changes only. Never notifies the options panels, so an item ID being
    typed into a list page survives loot; settings go through ns.RefreshSettings.
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

-- OnEnter, not OnTooltipShow: every LDB display calls it on hover. The menu closes itself, so no OnLeave.
ns.dataBrokerObject = LibDataBroker:NewDataObject(ADDON_NAME, {
	type = "launcher",
	label = ns.ADDON_TITLE,
	icon = ns.DEFAULT_ICON,

	OnClick = function(self, button)
		ns.RunButtonClick(button, self)
	end,

	OnEnter = function(self)
		ns.ShowMenu(self, "hover")
	end,

	OnLeave = function() end,
})

--------------------------------------------------------------------------------
-- Button Registration
--------------------------------------------------------------------------------

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

function ns:ApplyMinimapButton()
	if not ns.db then
		return
	end
	LibDBIcon:Refresh(ADDON_NAME, ns.db.profile.minimap)
end
