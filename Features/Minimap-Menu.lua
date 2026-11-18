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
    The mini-map button's menu, drawn by Menu-Kit (Features/Menu-Kit.lua), in the
    order the old tooltip used: the Lowest-Value Item and its Erase and Protect
    rows (or, with clean bags, the congratulation and its hint as one message),
    the Auto-Vend block, the Clutter Report (only while there is clutter), this
    character's Protect List, the More Features label (its switches open in a
    flyout beside it), and the Options row.
    The Protect List sits last of the reports because it is the only one whose
    length varies, so nothing above it moves as it grows.

    Hovering the button opens it, and moving into it keeps it open; it closes a
    moment after the cursor leaves both. Every row is a plain click, so a
    controller's cursor reaches all of it, and the button keeps every click it
    had, each named on the row that does the same job (Button Clicks, below).

    The menu shows only what this character can use right now: no Erase or
    Protect rows with clean bags, no Protect List while it is empty. The options
    panel still shows every setting.
]]

local HOVER_CLOSE_DELAY = 0.4
local CLICK_CLOSE_DELAY = 1.0
local MENU_GAP = 2 -- From the button's corner to the menu's
local LIST_MAX = 8 -- Protect List rows before the "%d more" note
local LOADING_RETRY = 0.5 -- Seconds before redrawing rows still waiting on item data

local menu = Kit.CreatePanel(ADDON_NAME .. "Menu", UIParent)

-- Escape closes it, as it does any game menu.
table.insert(UISpecialFrames, menu:GetName())

-- The More Features flyout, a child of the menu so it closes and hides with it.
local flyout = Kit.CreatePanel(nil, menu)
flyout:SetFrameLevel(menu:GetFrameLevel() + 20)

Kit.SetToggleText(L["MENU_ON"], L["MENU_OFF"])

local state = {
	anchor = nil,
	closeDelay = HOVER_CLOSE_DELAY,
	flyoutKey = nil,
	idle = 0,
	openLeft = true,
	openDown = true,
	retryPending = false,
}

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

-- An option's caption and tooltip, drawn the way the options panel draws them.
local function OptionTooltip(name, desc)
	return function(tooltip)
		tooltip:SetText(name, 1, 0.82, 0, 1, true)
		if desc and desc ~= "" then
			tooltip:AddLine(desc, 1, 1, 1, true)
		end
	end
end

-- An item's own tooltip, as hovering it in the bags shows it.
local function ItemTooltip(itemId)
	return function(tooltip)
		tooltip:SetItemByID(itemId)
	end
end

-- Every row click and button click ends here: the menu and any open options page redraw.
local function AfterChange()
	ns.RefreshSettings()
end

-- The right side of a feature's title: On in green, Off in gray.
local function OnOff(enabled)
	if enabled then
		return L["MENU_ON"], "ON"
	end
	return L["MENU_OFF"], "MUTED"
end

-- An icon at line height, then the text.
local function WithIcon(icon, text)
	return format("|T%s:0|t %s", icon or ns.DEFAULT_ICON, text)
end

--------------------------------------------------------------------------------
-- Button Clicks
--------------------------------------------------------------------------------

--[[
    Protects the item a Left-Click would erase, onto this character's list,
    exactly as the Add Hovered Item to Protect List binding does: add-only, off
    this character's Erase List if it was there, and one chat line saying which
    (Features/Key-Bindings.lua).
]]
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

--[[
    One table, both ways: the button's OnClick looks the click up here, and the
    row that does the same job names the click on its right, so a row never names
    a click that does something else. Left-Click runs the eraser even with clean
    bags, which prints the congratulation, as it always has.
]]
local CLICKS = {
	erase = {
		button = "LeftButton",
		shift = false,
		name = "MENU_CLICK_LEFT",
		run = function()
			ns:RunEraser()
		end,
	},
	protect = {
		button = "RightButton",
		shift = false,
		name = "MENU_CLICK_RIGHT",
		run = ProtectLowestValueItem,
	},
	clear = {
		button = "MiddleButton",
		shift = false,
		name = "MENU_CLICK_MIDDLE",
		run = function()
			ns:ConfirmClearIgnoreList()
		end,
	},
	autoVend = {
		button = "RightButton",
		shift = true,
		name = "MENU_CLICK_SHIFT_RIGHT",
		run = function()
			ns.db.profile.autoVendEnabled = not ns.db.profile.autoVendEnabled
		end,
	},
	options = {
		button = "MiddleButton",
		shift = true,
		name = "MENU_CLICK_SHIFT_MIDDLE",
		run = function()
			ns.HideMenu()
			ns:OpenOptionsPanel()
		end,
	},
}

-- Runs the click's job and redraws the menu and any open options page; false when the click has none.
function ns.RunButtonClick(button)
	local shift = IsShiftKeyDown() and true or false
	for _, click in pairs(CLICKS) do
		if click.button == button and click.shift == shift then
			if not ns.db and click ~= CLICKS.options then
				return true
			end
			click.run()
			AfterChange()
			return true
		end
	end
	return false
end

-- An action row: blue, naming its button click on the right in gray.
local function ClickRow(label, clickKey, tooltip)
	local click = CLICKS[clickKey]
	return {
		kind = "action",
		left = label,
		leftColor = "INFO",
		right = L[click.name],
		rightColor = "MUTED",
		tooltip = tooltip,
		onClick = function()
			click.run()
			AfterChange()
		end,
	}
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
		right, rightColor = ns:FormatCurrency(item.value), "TEXT"
	end
	entries[#entries + 1] = {
		kind = "item",
		left = left,
		right = right,
		rightColor = rightColor,
		tooltip = ItemTooltip(item.itemId),
	}

	entries[#entries + 1] = ClickRow(L["ACTION_ERASE"], "erase")
	entries[#entries + 1] = ClickRow(L["ACTION_PROTECT"], "protect")
end

local function AddAutoVend(entries)
	local right, rightColor = OnOff(ns.db.profile.autoVendEnabled)
	entries[#entries + 1] = { kind = "status", left = L["AUTO_VEND"], right = right, rightColor = rightColor }
	entries[#entries + 1] = { kind = "description", left = L["AUTO_VEND_DESCRIPTION"] }
	entries[#entries + 1] = ClickRow(
		L["MENU_TOGGLE"],
		"autoVend",
		OptionTooltip(L["OPTIONS_ENABLE_AUTO_VEND"], L["OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION"])
	)
end

--[[
    The haul's slots, items and value, only while there is clutter to count.
    With clean bags there's no report: the congratulation and its hint at the
    top of the menu already say so.
]]
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
		right = ns:FormatCurrency(value),
	}
end

--[[
    A Protect List row: click it to take the item off this character's list,
    with one chat line saying so. The delete icon on its right shows only while
    the row is hovered (ApplyHoverIcons, below), but it is always part of the
    row, so the menu is drawn wide enough for it and nothing shifts on hover.
]]
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

--[[
    This character's Protect List only, sorted by name, which is what keeps
    Clear Protect List honest: it clears exactly what is listed here and never
    touches the account-wide list. Items the client hasn't cached yet show as
    Loading ID rows, and the menu redraws shortly to fill them in.
]]
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

-- The first LIST_MAX rows, then a note saying how many more there are.
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
	entries[#entries + 1] = ClickRow(L["ACTION_CLEAR_PROTECT_LIST"], "clear")
	return isLoading
end

--------------------------------------------------------------------------------
-- Flyouts
--------------------------------------------------------------------------------

-- Each flyout's rows by its submenu key; a submenu row opens the flyout its key names.
local FLYOUTS = {}

--[[
    More Features: every feature on the options' main page that isn't a block
    above, one On/Off row each, in the main page's order, with its switch's
    caption and description as the tooltip (ns.FEATURES, Options/Options-Utilities.lua).
    They live in a flyout so the main menu stays short; its label counts how
    many are on and off, so the main menu still says where they stand.
]]
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
	entries[#entries + 1] = ClickRow(L["MENU_OPTIONS"], "options")
	return entries, isLoading
end

--------------------------------------------------------------------------------
-- Drawing & Placement
--------------------------------------------------------------------------------

--[[
    Right-side text that shows only while its row is hovered, for entries
    marked rightOnHover. Menu-Kit draws every row's right side and is shared
    unchanged between add-ons, so this works around it rather than in it: each
    pooled row gets one pair of hooks the first time it is seen, and after every
    draw the marked rows hide that text unless the cursor is already on them.
    The kit has measured the text by then, so the menu keeps its width.
]]
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

--[[
    The flyout beside its label, its first row level with the label, on the side
    the menu opened toward. The label keeps its highlight while it's open.
]]
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
	flyout:Hide()
	if ns.IsMenuFrame(GameTooltip:GetOwner()) then
		GameTooltip:Hide()
	end
end)

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

--[[
    Opens the menu from a launcher: the mini-map button, or any LDB display's
    plugin. how is "hover" or "click"; a click keeps it open a little longer once
    the cursor leaves. A launcher already showing the menu keeps its place.
]]
function ns.ShowMenu(anchor, how)
	if not ns.db or not anchor then
		return
	end
	local reopen = menu:IsShown() and state.anchor == anchor
	if not reopen then
		state.closeDelay = HOVER_CLOSE_DELAY
		state.flyoutKey = nil
	end
	state.anchor = anchor
	state.idle = 0
	if how == "click" then
		state.closeDelay = CLICK_CLOSE_DELAY
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

-- Redraws the menu in place while it is open; a no-op otherwise.
function ns.RefreshMenu()
	Render()
end

function ns.IsMenuShown()
	return menu:IsShown()
end

-- True for the menu, its flyout, and anything inside them.
function ns.IsMenuFrame(frame)
	return frame ~= nil and Kit.IsInside(frame, menu)
end
