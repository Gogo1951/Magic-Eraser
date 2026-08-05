local ADDON_NAME, ns = ...
local L = ns.L
local GetColor = ns.GetColor

local format = string.format
local insert = table.insert

local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

local function RefreshTooltip(anchor)
	local tooltip = GameTooltip

	tooltip:SetOwner(anchor, "ANCHOR_BOTTOMLEFT")
	tooltip:ClearLines()

	tooltip:AddDoubleLine(GetColor("TITLE") .. ns.AddonTitle .. "|r", GetColor("MUTED") .. ns.Version .. "|r")
	tooltip:AddLine(" ")
	tooltip:AddLine(" ")

	local item = ns:FindItemToDelete()

	if item then
		-- Lowest Value Item
		tooltip:AddLine(GetColor("TITLE") .. L["LOWEST_VALUE_ITEM"] .. "|r")

		local iconString = format("|T%s:14:14|t", item.icon)
		local countString = (item.count > 1) and format("%sx%d|r", GetColor("TEXT"), item.count) or ""

		local leftText = iconString .. " " .. item.link .. " " .. countString
		local rightText = (item.value > 0) and ns:FormatCurrency(item.value)
			or (GetColor("MUTED") .. L["NO_VALUE"] .. "|r")

		tooltip:AddDoubleLine(leftText, rightText)

		tooltip:AddDoubleLine(
			GetColor("INFO") .. L["LEFT_CLICK"] .. "|r",
			GetColor("INFO") .. L["ACTION_ERASE"] .. "|r"
		)
		tooltip:AddDoubleLine(
			GetColor("INFO") .. L["RIGHT_CLICK"] .. "|r",
			GetColor("INFO") .. L["ACTION_IGNORE"] .. "|r"
		)
	else
		--[[
		    Replaces the Lowest Value Item section when bags are clean. The
		    congratulation leads and the Clutter Report below carries the
		    follow-up hint, matching the order RunEraser prints the same two
		    strings in, so they read the same way wherever the player meets them.
		]]
		tooltip:AddLine(GetColor("ON") .. L["BAGS_CLEAN_CONGRATS"] .. "|r", 1, 1, 1, true)
	end

	-- Auto-Vend
	tooltip:AddLine(" ")
	local autoVendStatus = (ns.db and ns.db.global.autoVendEnabled) and (GetColor("ON") .. L["ENABLED"] .. "|r")
		or (GetColor("OFF") .. L["DISABLED"] .. "|r")
	tooltip:AddDoubleLine(GetColor("TITLE") .. L["AUTO_VEND"] .. "|r", autoVendStatus)
	tooltip:AddLine(GetColor("BODY") .. L["AUTO_VEND_DESCRIPTION"] .. "|r", 1, 1, 1, true)

	tooltip:AddDoubleLine(
		GetColor("INFO") .. L["SHIFT_RIGHT_CLICK"] .. "|r",
		GetColor("INFO") .. L["ACTION_TOGGLE"] .. "|r"
	)

	-- Clutter Report. With clutter it summarizes the haul; with clean bags there
	-- is nothing to total, so it carries the hint about what to do instead.
	tooltip:AddLine(" ")
	tooltip:AddLine(GetColor("TITLE") .. L["CLUTTER_REPORT"] .. "|r")
	if item then
		local reclaimSlots, reclaimItems, reclaimValue = ns:GetReclaimSummary()
		local slotsText = GetColor("TEXT") .. format(L["CLUTTER_SLOTS"], ns:FormatCommaNumber(reclaimSlots)) .. "|r"
		local itemsText = GetColor("MUTED") .. format(L["CLUTTER_ITEMS"], ns:FormatCommaNumber(reclaimItems)) .. "|r"
		tooltip:AddDoubleLine(
			slotsText .. " " .. itemsText,
			GetColor("TEXT") .. ns:FormatCurrency(reclaimValue) .. "|r"
		)
	else
		tooltip:AddLine(GetColor("BODY") .. L["BAGS_CLEAN_HINT"] .. "|r", 1, 1, 1, true)
	end

	--[[
	    Ignore List, this character's only -- which is what keeps the Middle-Click
	    hint underneath it honest, since Clear Ignore List clears exactly what is
	    listed here and never touches the account-wide list (see ns:ToggleIgnore
	    and ns:ClearIgnoreList in Features/Ignore-List.lua). Last of the content
	    sections because it is the only one whose length varies with how much the
	    player has protected, so everything above it holds a fixed position no
	    matter how long the list grows.
	]]
	local ignoreList = ns:GetIgnoreList()
	local hasIgnoredItems = ignoreList and next(ignoreList) ~= nil

	if hasIgnoredItems then
		tooltip:AddLine(" ")
		tooltip:AddLine(GetColor("TITLE") .. L["IGNORE_LIST"] .. "|r")

		local sortedItems = {}
		local loadingItems = {}

		for itemId in pairs(ignoreList) do
			local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemId)
			if name then
				insert(sortedItems, { name = name, quality = quality, icon = icon })
			else
				insert(loadingItems, itemId)
				if C_Item and C_Item.RequestLoadItemDataByID then
					C_Item.RequestLoadItemDataByID(itemId)
				end
			end
		end

		table.sort(sortedItems, function(a, b)
			return a.name < b.name
		end)

		for _, ignoredItem in ipairs(sortedItems) do
			local _, _, _, hexColor = GetItemQualityColor(ignoredItem.quality)
			tooltip:AddLine(format("|T%s:14:14|t |c%s[%s]|r", ignoredItem.icon, hexColor, ignoredItem.name))
		end

		for _, itemId in ipairs(loadingItems) do
			tooltip:AddLine(GetColor("MUTED") .. format(L["LOADING_ITEM"], itemId) .. "|r")
		end

		tooltip:AddDoubleLine(
			GetColor("INFO") .. L["MIDDLE_CLICK"] .. "|r",
			GetColor("INFO") .. L["ACTION_CLEAR_IGNORE"] .. "|r"
		)
	end

	-- Options
	tooltip:AddLine(" ")
	tooltip:AddLine(GetColor("TITLE") .. L["MINIMAP_OPTIONS"] .. "|r")
	tooltip:AddLine(GetColor("INFO") .. L["SHIFT_MIDDLE_CLICK"] .. "|r")

	tooltip:Show()
end

--------------------------------------------------------------------------------
-- Display Refresh
--------------------------------------------------------------------------------

function ns:RefreshDisplay()
	if not ns.LDBObject then
		return
	end

	ns:InvalidateCache()
	local item = ns:FindItemToDelete()

	if item and item.icon then
		ns.LDBObject.icon = item.icon
	else
		ns.LDBObject.icon = ns.DefaultIcon
	end

	if LibDBIcon then
		local button = LibDBIcon:GetMinimapButton(ADDON_NAME)
		if button then
			if button.icon then
				button.icon:SetTexture(ns.LDBObject.icon)
			end

			if GameTooltip:GetOwner() == button then
				RefreshTooltip(button)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- LDB Data Object
--------------------------------------------------------------------------------

if LibDataBroker then
	ns.LDBObject = LibDataBroker:NewDataObject(ADDON_NAME, {
		type = "data source",
		text = ns.AddonTitle,
		icon = ns.DefaultIcon,

		OnClick = function(self, button)
			if IsShiftKeyDown() and button == "MiddleButton" then
				ns:OpenOptionsPanel()
				return
			end

			if IsShiftKeyDown() and button == "RightButton" then
				if not ns.db then
					return
				end
				ns.db.global.autoVendEnabled = not ns.db.global.autoVendEnabled
				AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.General)
				RefreshTooltip(self)
				return
			end

			if button == "LeftButton" then
				ns:RunEraser()
			elseif button == "RightButton" then
				local item = ns:FindItemToDelete()
				if item then
					ns:ToggleIgnore(item.itemId)
				end
			elseif button == "MiddleButton" then
				ns:ClearIgnoreList()
			end
		end,

		OnEnter = function(self)
			RefreshTooltip(self)
		end,

		OnLeave = function()
			GameTooltip:Hide()
		end,
	})
end
