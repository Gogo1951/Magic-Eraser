local _, ns = ...
local L = ns.L

local GetColor = ns.GetColor

local format, ipairs, pairs = string.format, ipairs, pairs

--------------------------------------------------------------------------------
-- Ignore List Panel
--------------------------------------------------------------------------------

--[[
    Every ignore list on the account, one scope per list. childGroups = "tree"
    splits the panel in two: the tree on the left is the scope list (the
    account-wide Global list, then the characters), and the pane on the right is
    the selected scope's items. Each scope group closes over its own scope key,
    so the add box and the row buttons in a pane always act on the list the
    player is looking at, including another character's.

    Registered as a builder function rather than a built table (see
    Options/Options.lua): the rows here are the ignore lists themselves, so
    AceConfig re-invokes this on every open and every NotifyChange and the panel
    is always current.

    There is no drop target. The game closes the bags and the bank when the
    options interface opens, so there is no way to have an item on the cursor and
    this panel in front of you at the same time; typing or shift-clicking an id
    into the add box is the only path that can actually work.
]]

--[[
    Column widths as a fraction of the pane rather than of AceConfig's fixed
    200px control unit, so the columns track however wide the settings panel
    happens to be on a given client. They sum to slightly under 1 on purpose: at
    exactly 1, a rounding wobble in the flow layout's "does this still fit" test
    can bump the last cell onto a line of its own.

    A character scope carries a promote button that the Global scope does not, so
    on the Global scope the item cell absorbs that column's width instead. That
    leaves the remove button in the same place on both, so picking a different
    scope out of the tree does not shuffle the columns sideways.
]]
local COLUMN_WIDTH_ITEM = 0.7
local COLUMN_WIDTH_PROMOTE = 0.18
local COLUMN_WIDTH_REMOVE = 0.1

-- Orders 1-19 are the pane's fixed head (description, add box); item rows start
-- here, one order step apart.
local FIRST_ROW_ORDER = 20
local ROW_ORDER_STEP = 10

--[[
    An item id off the Add by Item ID box. Two shapes get typed in: a bare id the
    player looked up, and a whole item link, which is what shift-clicking an item
    link in chat drops into a focused edit box. Anything else is rejected by the
    box's validate, so a stray word never becomes a row that renders as an
    unresolvable id forever.
]]
local function ParseItemId(value)
	if type(value) ~= "string" then
		return nil
	end

	local itemId = tonumber(value:match("item:(%d+)") or value:match("^%s*(%d+)%s*$"))
	if itemId and itemId > 0 then
		return itemId
	end
	return nil
end

--------------------------------------------------------------------------------
-- Row Widgets
--------------------------------------------------------------------------------

--[[
    The item's own game tooltip on hover. Two pieces make that work.

    dialogControl, because AceConfig renders a description as a plain Label,
    which has no mouse scripts at all and so never fires the OnEnter that
    AceConfigDialog hangs its tooltip on. InteractiveLabel is that same widget
    with mouse handling bolted on (its constructor literally hijacks a Label), so
    everything AceConfigDialog does to a description still applies.

    tooltipHyperlink, which is AceConfig's own hook: when it is set,
    OptionOnMouseOver hands the string straight to GameTooltip:SetHyperlink and
    shows nothing else. The bare "item:id" form is used rather than the link off
    GetItemInfo so that a row still waiting on its item data gets a tooltip too,
    and so hovering it pulls the very data the row is waiting for.
]]
local function ItemCell(itemId, text, width, order)
	return {
		type = "description",
		name = text,
		fontSize = "medium",
		dialogControl = "InteractiveLabel",
		tooltipHyperlink = "item:" .. itemId,
		width = "relative",
		relWidth = width,
		order = order,
	}
end

--[[
    One rendered line. AceGUI's flow layout has no notion of a row: it packs
    widgets left to right and wraps only when the next one will not fit, so laid
    out flat, cells from different items run together on one line the moment the
    leftover space is wide enough to take the next item's name.

    An inline group with an empty name fixes that. AceConfigDialog renders that
    as a bare SimpleGroup, which has no border, no title and no padding, and
    gives it "fill" width; the flow layout always puts a "fill" widget on a line
    of its own and starts the next widget on a fresh one. The cells then flow
    inside that line, so every row breaks at the same points no matter what the
    pane is doing.
]]
local function ItemRow(order, cells)
	return {
		type = "group",
		name = "",
		inline = true,
		order = order,
		args = cells,
	}
end

--[[
    Promote, not copy. Only the account-wide add is issued here: ns:SetIgnoredInScope
    clears a newly globalized item off every character's list itself, so the row
    leaves this pane, leaves any other character who happened to hold the same
    item, and turns up under Global instead. Protection only ever widens doing it
    this way, because the global list already covers everyone it just left.
]]
local function PromoteButton(itemId, order)
	return {
		type = "execute",
		name = L["OPTIONS_IGNORE_GLOBAL"],
		desc = L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"],
		width = "relative",
		relWidth = COLUMN_WIDTH_PROMOTE,
		order = order,
		func = function()
			ns:SetIgnoredInScope(ns.IGNORE_SCOPE_GLOBAL, itemId, true)
		end,
	}
end

--[[
    An execute carrying an image renders as an AceGUI Icon rather than the stock
    Button, which is what this column wants: the Button widget pins its font
    string 15px in from each edge, so in a column this narrow its label has about
    ten pixels to live in and any glyph is clipped to a sliver. An icon has no
    such inset, and the group-loot pass texture is already the game's own "no,
    get rid of this" mark.

    The name is deliberately empty so the Icon draws no caption under the
    texture; the label rides in desc instead, where AceConfigDialog shows it as
    the hover tooltip.
]]
local REMOVE_ICON = "Interface/Buttons/UI-GroupLoot-Pass-Up"
local REMOVE_ICON_SIZE = 16

local function RemoveButton(scopeKey, itemId, order)
	return {
		type = "execute",
		name = "",
		desc = L["OPTIONS_IGNORE_REMOVE"],
		image = REMOVE_ICON,
		imageWidth = REMOVE_ICON_SIZE,
		imageHeight = REMOVE_ICON_SIZE,
		width = "relative",
		relWidth = COLUMN_WIDTH_REMOVE,
		order = order,
		func = function()
			ns:SetIgnoredInScope(scopeKey, itemId, false)
		end,
	}
end

local function RowCells(scopeKey, isGlobalScope, itemId, itemText)
	local itemWidth = isGlobalScope and (COLUMN_WIDTH_ITEM + COLUMN_WIDTH_PROMOTE) or COLUMN_WIDTH_ITEM

	local cells = {
		item = ItemCell(itemId, itemText, itemWidth, 1),
		remove = RemoveButton(scopeKey, itemId, 3),
	}

	if not isGlobalScope then
		cells.promote = PromoteButton(itemId, 2)
	end

	return cells
end

--------------------------------------------------------------------------------
-- Panel
--------------------------------------------------------------------------------

--[[
    One scope's items, split into rows the client can describe and ids it cannot
    yet. Only the name, quality and icon are read: the panel lists what is
    protected, and sell prices earned their space on the minimap tooltip's
    Clutter Report, not here.
]]
local function CollectRows(scopeKey)
	local rows, coldItemIds = {}, {}

	local ignoreList = ns:GetIgnoreListForScope(scopeKey)
	if not ignoreList then
		return rows, coldItemIds
	end

	for itemId in pairs(ignoreList) do
		local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemId)
		if name then
			rows[#rows + 1] = {
				itemId = itemId,
				name = name,
				quality = quality,
				icon = icon,
			}
		else
			coldItemIds[#coldItemIds + 1] = itemId
		end
	end

	table.sort(rows, function(a, b)
		return a.name < b.name
	end)

	table.sort(coldItemIds)

	return rows, coldItemIds
end

local function BuildScopeArgs(scopeKey)
	local isGlobalScope = scopeKey == ns.IGNORE_SCOPE_GLOBAL

	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_IGNORE_DESCRIPTION"], 1),
		spacerAdd = ns.OptionsSpacer(2),

		--[[
		    Typing an id, or shift-clicking an item link out of chat into the
		    box, adds without needing the bags open at all. get returns empty so
		    the box clears itself on the repaint AceConfigDialog runs after each
		    add, which is also why nothing here calls NotifyChange.
		]]
		inputAddId = {
			type = "input",
			name = L["OPTIONS_IGNORE_ADD_ID"],
			desc = L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"],
			width = "double",
			order = 3,
			validate = function(_, value)
				return ParseItemId(value) and true or L["OPTIONS_IGNORE_ADD_ID_INVALID"]
			end,
			get = function()
				return ""
			end,
			set = function(_, value)
				ns:SetIgnoredInScope(scopeKey, ParseItemId(value), true)
			end,
		},

		spacerRows = ns.OptionsSpacer(4),
	}

	local rows, coldItemIds = CollectRows(scopeKey)

	if #rows == 0 and #coldItemIds == 0 then
		args.descEmpty = ns.OptionsDesc(GetColor("HELP") .. L["OPTIONS_IGNORE_EMPTY"] .. "|r", 5)
		return args
	end

	local order = FIRST_ROW_ORDER

	for _, row in ipairs(rows) do
		local _, _, _, hexColor = GetItemQualityColor(row.quality or 0)
		local itemText = format("|T%s:14:14|t |c%s%s|r", row.icon, hexColor, row.name)

		args["row" .. tostring(row.itemId)] = ItemRow(order, RowCells(scopeKey, isGlobalScope, row.itemId, itemText))

		order = order + ROW_ORDER_STEP
	end

	--[[
	    Rows whose item data has not arrived yet, listed after the named ones
	    because they have no name to sort by. They keep both buttons, so an id
	    the client can never describe is still promotable and still removable.
	]]
	for _, itemId in ipairs(coldItemIds) do
		local itemText = GetColor("MUTED") .. format(L["LOADING_ITEM"], itemId) .. "|r"

		args["row" .. tostring(itemId)] = ItemRow(order, RowCells(scopeKey, isGlobalScope, itemId, itemText))

		order = order + ROW_ORDER_STEP
	end

	ns.WarmItemCache(coldItemIds, ns.OPTIONS_REGISTRY.IgnoreList)

	return args
end

local function ScopeGroup(name, order, scopeKey)
	return {
		type = "group",
		name = name,
		order = order,
		args = BuildScopeArgs(scopeKey),
	}
end

function ns.BuildIgnoreListOptions()
	local args = {}

	-- Keyed by scope, not by position: the tree remembers the selected node by
	-- its arg key, so a key that moved when a profile appeared or dropped out of
	-- the list would silently reselect a different character.
	args[ns.IGNORE_SCOPE_GLOBAL] = ScopeGroup(L["OPTIONS_IGNORE_GLOBAL"], 1, ns.IGNORE_SCOPE_GLOBAL)

	if ns.db then
		local profiles = ns.db:GetProfiles()
		table.sort(profiles)

		local currentProfile = ns.db:GetCurrentProfile()
		local order = 10

		for _, profileName in ipairs(profiles) do
			--[[
			    A character with nothing ignored is noise in the tree, so it is
			    left out -- except for the character playing right now, whose
			    list has to be reachable to put a first item in it. Profile names
			    are character keys ("Name - Realm") and are never localized, so
			    they are shown as-is and sorted as plain strings.
			]]
			local ignoreList = ns:GetIgnoreListForScope(profileName)
			if profileName == currentProfile or (ignoreList and next(ignoreList) ~= nil) then
				args[profileName] = ScopeGroup(profileName, order, profileName)
				order = order + 1
			end
		end
	end

	return {
		type = "group",
		name = L["IGNORE_LIST"],
		childGroups = "tree",
		args = args,
	}
end
