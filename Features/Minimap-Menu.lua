local ADDON_NAME, ns = ...
local L = ns.L
local Kit = ns.MenuKit
local GetColor = ns.GetColor

local format = string.format
local GetItemInfo = C_Item.GetItemInfo
local GetItemQualityColor = C_Item.GetItemQualityColor

--------------------------------------------------------------------------------
-- Mini-map Menu
--------------------------------------------------------------------------------

--[[
    The Protect List sits last of the reports because it is the only one whose
    length varies, so nothing above it moves as it grows. Every row is a plain
    click, so a controller's cursor reaches all of it.
]]

local HOVER_CLOSE_DELAY = 0.5
local CLICK_CLOSE_DELAY = 1.0
local MENU_GAP = 2 -- From the button's corner to the menu's
local LIST_MAX = 8 -- Protect List rows before the "%d more" note
local LOADING_RETRY = 0.5 -- Seconds before redrawing rows still waiting on item data

local menu = Kit.CreatePanel(ADDON_NAME .. "Menu", UIParent)

table.insert(UISpecialFrames, menu:GetName())

-- The More Features flyout, a child of the menu so it closes and hides with it.
local flyout = Kit.CreatePanel(nil, menu)
flyout:SetFrameLevel(menu:GetFrameLevel() + 20)

Kit.SetToggleText(L["MENU_ON"], L["MENU_OFF"])

local state = {
	anchor = nil,
	closeDelay = HOVER_CLOSE_DELAY,
	held = false,
	flyoutKey = nil,
	idle = 0,
	openLeft = true,
	openDown = true,
	retryPending = false,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function OptionTooltip(name, desc)
	return function(tooltip)
		tooltip:SetText(name, 1, 0.82, 0, 1, true)
		if desc and desc ~= "" then
			tooltip:AddLine(desc, 1, 1, 1, true)
		end
	end
end

local function ItemTooltip(itemId)
	return function(tooltip)
		tooltip:SetItemByID(itemId)
	end
end

-- Every row click ends here: the menu and any open options page redraw.
local function AfterChange()
	ns.RefreshSettings()
end

local function OnOff(enabled)
	if enabled then
		return L["MENU_ON"], "ON"
	end
	return L["MENU_OFF"], "MUTED"
end

local function WithIcon(icon, text)
	return format("|T%s:0|t %s", icon or ns.DEFAULT_ICON, text)
end

--------------------------------------------------------------------------------
-- Button Clicks
--------------------------------------------------------------------------------

-- Left-Click only: players' hands know Right-Click as Protect, so every other job lives on a row.
function ns.RunButtonClick(button, anchor)
	if button ~= "LeftButton" then
		return false
	end
	ns.ToggleMenu(anchor)
	return true
end

-- Same path and chat line as the Add Hovered Item to Protect List binding.
local function ProtectLowestValueItem()
	local item = ns:FindItemToDelete()
	if not item then
		return
	end
	local outcome = ns:AddToIgnoreList(item.itemId)
	if outcome then
		ns:PrintMessage(format(L[ns.IGNORE_LIST_MESSAGE_KEYS[outcome]], item.link))
	end
end

local function ActionRow(label, run, tooltip)
	return {
		kind = "action",
		left = label,
		leftColor = "INFO",
		tooltip = tooltip,
		onClick = function()
			run()
			AfterChange()
		end,
	}
end

local function RunEraser()
	ns:RunEraser()
end

local function ToggleAutoVend()
	ns.db.profile.autoVendEnabled = not ns.db.profile.autoVendEnabled
end

local function ClearProtectList()
	ns:ConfirmClearIgnoreList()
end

local function OpenOptions()
	ns.HideMenu()
	ns:OpenOptionsPanel()
end

--------------------------------------------------------------------------------
-- Rows
--------------------------------------------------------------------------------

local function AddLowestValueItem(entries, item)
	if not item then
		entries[#entries + 1] = { kind = "description", left = L["BAGS_CLEAN_CONGRATS"], leftColor = "ON" }
		entries[#entries + 1] = { kind = "note", left = L["BAGS_CLEAN_HINT"] }
		return
	end

	entries[#entries + 1] = { kind = "status", left = L["LOWEST_VALUE_ITEM"] }

	local left = WithIcon(item.icon, ns:StripLinkBrackets(item.link))
	if item.count > 1 then
		left = left .. " " .. GetColor("TEXT") .. "x" .. item.count .. "|r"
	end
	local right, rightColor = L["NO_VALUE"], "MUTED"
	if item.value > 0 then
		right, rightColor = ns:FormatCoins(item.value), "TEXT"
	end
	entries[#entries + 1] = {
		kind = "item",
		left = left,
		right = right,
		rightColor = rightColor,
		tooltip = ItemTooltip(item.itemId),
	}

	entries[#entries + 1] = ActionRow(L["ACTION_ERASE"], RunEraser)
	entries[#entries + 1] = ActionRow(L["ACTION_PROTECT"], ProtectLowestValueItem)
end

local function AddAutoVend(entries)
	local right, rightColor = OnOff(ns.db.profile.autoVendEnabled)
	entries[#entries + 1] = { kind = "status", left = L["AUTO_VEND"], right = right, rightColor = rightColor }
	entries[#entries + 1] = { kind = "description", left = L["AUTO_VEND_DESCRIPTION"] }
	entries[#entries + 1] = ActionRow(
		L["MENU_TOGGLE"],
		ToggleAutoVend,
		OptionTooltip(L["OPTIONS_ENABLE_AUTO_VEND"], L["OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION"])
	)
end

local function AddClutterReport(entries, item)
	if not item then
		return
	end

	entries[#entries + 1] = { kind = "status", left = L["CLUTTER_REPORT"] }

	local slots, items, value = ns:GetReclaimSummary()
	local slotsLabel = (slots == 1) and L["CLUTTER_SLOTS_ONE"]
		or format(L["CLUTTER_SLOTS"], ns:FormatCommaNumber(slots))
	local itemsLabel = (items == 1) and L["CLUTTER_ITEMS_ONE"]
		or format(L["CLUTTER_ITEMS"], ns:FormatCommaNumber(items))
	entries[#entries + 1] = {
		kind = "value",
		left = GetColor("TEXT") .. slotsLabel .. "|r " .. GetColor("MUTED") .. itemsLabel .. "|r",
		right = ns:FormatCoins(value),
	}
end

-- The remove icon shows only on hover, but is always measured, so nothing shifts.
local REMOVE_ICON = "|TInterface\\Buttons\\UI-GroupLoot-Pass-Up:0|t"

local function UnprotectRow(itemId, left, leftColor, label)
	return {
		kind = "item",
		left = left,
		leftColor = leftColor,
		right = REMOVE_ICON,
		rightOnHover = true,
		tooltip = function(tooltip)
			tooltip:SetItemByID(itemId)
			tooltip:AddLine(" ")
			tooltip:AddLine(GetColor("HELP") .. L["MENU_UNPROTECT_HINT"] .. "|r")
			tooltip:Show()
		end,
		onClick = function()
			if ns:RemoveFromIgnoreList(itemId) then
				local _, link = GetItemInfo(itemId)
				ns:PrintMessage(format(L["PROTECT_LIST_REMOVED"], link or label))
			end
			AfterChange()
		end,
	}
end

-- This character's list only, so Clear Protect List clears exactly what is shown.
local function ProtectListRows()
	local ignoreList = ns:GetIgnoreList()
	local named, loading = {}, {}
	for itemId in pairs(ignoreList or {}) do
		local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemId)
		if name then
			named[#named + 1] = { itemId = itemId, name = name, quality = quality, icon = icon }
		else
			loading[#loading + 1] = itemId
			C_Item.RequestLoadItemDataByID(itemId)
		end
	end
	table.sort(named, function(a, b)
		return a.name < b.name
	end)
	table.sort(loading)

	local rows = {}
	for _, data in ipairs(named) do
		local _, _, _, hexColor = GetItemQualityColor(data.quality or 1)
		local name = "|c" .. hexColor .. data.name .. "|r"
		rows[#rows + 1] = UnprotectRow(data.itemId, WithIcon(data.icon, name), nil, name)
	end
	for _, itemId in ipairs(loading) do
		local label = format(L["LOADING_ITEM"], itemId)
		rows[#rows + 1] = UnprotectRow(itemId, label, "MUTED", label)
	end
	return rows, #loading > 0
end

local function AddList(entries, rows)
	for index = 1, math.min(#rows, LIST_MAX) do
		entries[#entries + 1] = rows[index]
	end
	if #rows > LIST_MAX then
		entries[#entries + 1] = { kind = "note", left = format(L["MENU_MORE"], #rows - LIST_MAX) }
	end
end

local function AddProtectList(entries)
	local rows, isLoading = ProtectListRows()
	if #rows == 0 then
		return false
	end
	entries[#entries + 1] = { kind = "status", left = L["TAB_PROTECT_LIST"] }
	AddList(entries, rows)
	entries[#entries + 1] = ActionRow(L["ACTION_CLEAR_PROTECT_LIST"], ClearProtectList)
	return isLoading
end

--------------------------------------------------------------------------------
-- Flyouts
--------------------------------------------------------------------------------

-- Each flyout's rows by its submenu key; a submenu row opens the flyout its key names.
local FLYOUTS = {}

local function MoreFeatures()
	local features = {}
	for _, feature in ipairs(ns.FEATURES or {}) do
		if not feature.block then
			features[#features + 1] = feature
		end
	end
	return features
end

function FLYOUTS.features()
	local profile = ns.db.profile
	local rows = {}
	for _, feature in ipairs(MoreFeatures()) do
		rows[#rows + 1] = {
			kind = "toggle",
			left = L[feature.name],
			on = profile[feature.setting] and true or false,
			tooltip = OptionTooltip(L[feature.caption], L[feature.desc]),
			onClick = function()
				local value = not profile[feature.setting]
				if feature.apply then
					feature.apply(value)
				else
					profile[feature.setting] = value
				end
				AfterChange()
			end,
		}
	end
	return rows
end

local function AddMoreFeatures(entries)
	local profile = ns.db.profile
	local on, off = 0, 0
	for _, feature in ipairs(MoreFeatures()) do
		if profile[feature.setting] then
			on = on + 1
		else
			off = off + 1
		end
	end
	-- The On count green, like an On switch, the comma white, and the Off count the label's gray.
	local onText = GetColor("ON") .. format(L["MENU_FEATURE_COUNT_ON"], on) .. "|r"
	local offText = format(L["MENU_FEATURE_COUNT_OFF"], off)
	entries[#entries + 1] = {
		kind = "submenu",
		left = L["MENU_MORE_FEATURES"],
		right = onText .. GetColor("TEXT") .. ",|r " .. offText,
		submenu = "features",
		onClick = function()
			ns.OpenFlyout("features")
		end,
	}
end

local function BuildMainEntries()
	local entries = {
		{ kind = "header", left = ns.ADDON_TITLE, right = ns.Version or "" },
		{ kind = "spacer" },
	}

	local item = ns:FindItemToDelete()
	AddLowestValueItem(entries, item)
	AddAutoVend(entries)
	AddClutterReport(entries, item)
	local isLoading = AddProtectList(entries)
	AddMoreFeatures(entries)

	entries[#entries + 1] = { kind = "spacer" }
	entries[#entries + 1] = { kind = "separator" }
	entries[#entries + 1] = ActionRow(L["MENU_OPTIONS"], OpenOptions)
	return entries, isLoading
end

--------------------------------------------------------------------------------
-- Drawing & Placement
--------------------------------------------------------------------------------

-- Repeats on the main menu's pooled rows what Menu-Kit v2 already does for rightOnHover entries.
local function ShowHoverText(row)
	if row.entry and row.entry.rightOnHover then
		row.right:Show()
	end
end

local function HideHoverText(row)
	if row.entry and row.entry.rightOnHover then
		row.right:Hide()
	end
end

local function ApplyHoverIcons()
	for _, row in ipairs(menu.rows) do
		if not row.hoverTextHooked then
			row:HookScript("OnEnter", ShowHoverText)
			row:HookScript("OnLeave", HideHoverText)
			row.hoverTextHooked = true
		end
		if row.entry and row.entry.rightOnHover then
			row.right:SetShown(Kit.IsCursorOver(row))
		end
	end
end

local function PositionFlyout(row)
	flyout:ClearAllPoints()
	if state.openLeft then
		flyout:SetPoint("TOPRIGHT", row, "TOPLEFT", -Kit.FLYOUT_GAP, Kit.FLYOUT_RISE)
	else
		flyout:SetPoint("TOPLEFT", row, "TOPRIGHT", Kit.FLYOUT_GAP, Kit.FLYOUT_RISE)
	end
end

local function RenderFlyout()
	local key = state.flyoutKey
	local row = key and menu:SubmenuRow(key)
	local builder = key and FLYOUTS[key]
	if not (row and builder) then
		state.flyoutKey = nil
		flyout:Hide()
		return
	end
	flyout.tooltipAnchor = menu.tooltipAnchor
	flyout:Render(builder())
	PositionFlyout(row)
	flyout:Show()
	row:LockHighlight()
end

local Render

local function RetryLoading()
	state.retryPending = false
	Render()
end

function Render()
	if not menu:IsShown() or not ns.db then
		return
	end
	local entries, isLoading = BuildMainEntries()
	menu:Render(entries)
	ApplyHoverIcons()
	RenderFlyout()
	if isLoading and not state.retryPending then
		state.retryPending = true
		C_Timer.After(LOADING_RETRY, RetryLoading)
	end
end

function ns.OpenFlyout(key)
	if key ~= state.flyoutKey then
		state.flyoutKey = key
		Render()
	end
end

-- Entering a label opens its flyout, and any other row closes it, the way any game submenu behaves.
menu.onEnterRow = function(_, entry)
	ns.OpenFlyout(entry and entry.submenu or nil)
end

-- Opens away from the screen edges: left of the button on the right half of the screen, below it on the top half.
local function PositionMenu(anchor)
	local x, y = anchor:GetCenter()
	local scale = anchor:GetEffectiveScale() / UIParent:GetEffectiveScale()
	state.openLeft = (x or 0) * scale > UIParent:GetWidth() / 2
	state.openDown = (y or 0) * scale > UIParent:GetHeight() / 2

	local point = (state.openDown and "TOP" or "BOTTOM") .. (state.openLeft and "RIGHT" or "LEFT")
	local relative = (state.openDown and "BOTTOM" or "TOP") .. (state.openLeft and "LEFT" or "RIGHT")
	menu:ClearAllPoints()
	menu:SetPoint(
		point,
		anchor,
		relative,
		state.openLeft and -MENU_GAP or MENU_GAP,
		state.openDown and -MENU_GAP or MENU_GAP
	)
	menu.tooltipAnchor = state.openLeft and "ANCHOR_LEFT" or "ANCHOR_RIGHT"
end

-- Closes a moment after the cursor has left the button, the menu, and the flyout.
menu:SetScript("OnUpdate", function(self, elapsed)
	local anchor = state.anchor
	if not anchor or not anchor:IsVisible() then
		self:Hide()
		return
	end
	if Kit.IsCursorOver(anchor) or Kit.IsCursorOver(self) or Kit.IsCursorOver(flyout) then
		state.idle = 0
		return
	end
	state.idle = state.idle + elapsed
	if state.idle >= state.closeDelay then
		self:Hide()
	end
end)

menu:SetScript("OnHide", function()
	state.flyoutKey = nil
	state.anchor = nil
	state.held = false
	flyout:Hide()
	if ns.IsMenuFrame(GameTooltip:GetOwner()) then
		GameTooltip:Hide()
	end
end)

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

-- how is "hover" or "click"; a click holds it and waits longer to close.
function ns.ShowMenu(anchor, how)
	if not ns.db or not anchor then
		return
	end
	local reopen = menu:IsShown() and state.anchor == anchor
	if not reopen then
		state.closeDelay = HOVER_CLOSE_DELAY
		state.flyoutKey = nil
		state.held = false
	end
	state.anchor = anchor
	state.idle = 0
	if how == "click" then
		state.closeDelay = CLICK_CLOSE_DELAY
		state.held = true
	end
	if not reopen then
		PositionMenu(anchor)
	end
	menu:Show()
	Render()
end

function ns.HideMenu()
	menu:Hide()
end

-- A hover-opened menu isn't held, so the click after a hover holds it instead of closing it.
function ns.ToggleMenu(anchor)
	if menu:IsShown() and state.anchor == anchor and state.held then
		menu:Hide()
		return
	end
	ns.ShowMenu(anchor, "click")
end

function ns.RefreshMenu()
	Render()
end

function ns.IsMenuShown()
	return menu:IsShown()
end

function ns.IsMenuFrame(frame)
	return frame ~= nil and Kit.IsInside(frame, menu)
end
