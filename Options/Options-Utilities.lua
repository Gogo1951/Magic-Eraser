local _, ns = ...
local L = ns.L

local format = string.format
local GetItemInfo = C_Item.GetItemInfo

--------------------------------------------------------------------------------
-- Shared Options Helpers
--------------------------------------------------------------------------------

--[[
    Widget constructors shared by every options panel file. Dot-defined (no
    self), so callers use dot invocation -- ns.OptionsHeader(...) -- matching the
    panel builders.
]]
local GetColor = ns.GetColor

function ns.OptionsHeader(text, order, hidden)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order, hidden = hidden }
end

function ns.OptionsDesc(text, order)
	return { type = "description", name = text, fontSize = "medium", order = order }
end

function ns.OptionsSpacer(order, hidden)
	return { type = "description", name = " ", order = order, hidden = hidden }
end

--[[
    The left half of a label-beside-control row. The control that follows carries
    name = "" and ns.OPTIONS_CONTROL_WIDTH, ordered one past its label; a caption
    left on the control puts the label back above the widget and breaks the row. A
    row whose control needs more room passes its own width here and gives the
    control ns.OPTIONS_ROW_WIDTH minus that, so every row still ends where every
    other row ends.
]]
function ns.OptionsRowLabel(text, order, width)
	return {
		type = "description",
		name = text,
		fontSize = "medium",
		width = width or ns.OPTIONS_LABEL_WIDTH,
		order = order,
	}
end

--------------------------------------------------------------------------------
-- Feature Switches
--------------------------------------------------------------------------------

--[[
    A feature's on/off switch, built once and used twice: on the feature's own
    page, and in the Features section of the root panel, so the two are always
    the same setting with the same caption and tooltip. Reads and writes
    ns.db.profile[settingKey]; onSet runs after the write for a switch whose
    change has to reach something beyond the saved value.

    Both copies read the live setting on every draw, so flipping one and then
    opening the other page never shows a stale box.
]]
function ns.OptionsFeatureToggle(settingKey, nameKey, descKey, order, width, onSet)
	return {
		type = "toggle",
		name = L[nameKey],
		desc = L[descKey],
		width = width or "full",
		order = order,
		get = function()
			return ns.db and ns.db.profile[settingKey]
		end,
		set = function(_, value)
			ns.db.profile[settingKey] = value
			if onSet then
				onSet(value)
			end
		end,
	}
end

--[[
    Lays toggles out two to a line, each pair in its own unnamed inline group so
    every pair pins its own row. The widths leave slack under
    ns.OPTIONS_ROW_WIDTH: a row summing
    exactly to the pane sits on the wrap boundary and can drop its second
    toggle onto a line of its own. Each toggle's width and order are set here.
]]
local TOGGLE_PAIR_WIDTH = 1.6

function ns.OptionsTogglePairs(args, keyPrefix, startOrder, toggles)
	for index = 1, #toggles, 2 do
		local pair = {}
		for offset = 0, 1 do
			local toggle = toggles[index + offset]
			if toggle then
				toggle.width = TOGGLE_PAIR_WIDTH
				toggle.order = offset + 1
				pair["toggle" .. (offset + 1)] = toggle
			end
		end
		args[keyPrefix .. index] = {
			type = "group",
			name = "",
			inline = true,
			order = startOrder + index,
			args = pair,
		}
	end
end

--------------------------------------------------------------------------------
-- Example Lines
--------------------------------------------------------------------------------

--[[
    One line showing what a chat-printing feature actually says, built from the
    real locale string it prints, under the switch that controls it. getText
    returns the message body (without the brand prefix, which is added here, as
    ns:PrintMessage adds it); a function rather than a string so an example that
    follows a dropdown redraws with it. hidden works as on any other widget.
    Callers put an ns.OptionsSpacer with the same hidden above the first
    example, so the example sits one blank line below the control it shows.
]]
ns.EXAMPLE_ITEM_LINK = GetColor("TEXT") .. L["OPTIONS_EXAMPLE_ITEM"] .. "|r"

function ns.OptionsExample(getText, order, hidden)
	return {
		type = "description",
		name = function()
			return GetColor("HELP")
				.. format(L["OPTIONS_EXAMPLE"], ns.BRAND_PREFIX .. GetColor("TEXT") .. getText() .. "|r")
				.. "|r"
		end,
		fontSize = "medium",
		order = order,
		hidden = hidden,
	}
end

--[[
    A silver line that only shows when something elsewhere changes this page's
    feature, such as Bag-Space Warnings holding bag slots back from Bank
    Retrieval. getText may return nil, which hides it.
]]
function ns.OptionsStatusLine(getText, order)
	return {
		type = "description",
		name = function()
			local text = getText()
			return text and (GetColor("HELP") .. text .. "|r") or ""
		end,
		fontSize = "medium",
		order = order,
		hidden = function()
			return getText() == nil
		end,
	}
end

--------------------------------------------------------------------------------
-- Item Cache Warming
--------------------------------------------------------------------------------

--[[
    C_Item.GetItemInfo answers nil for an item the client has not cached yet,
    which is the normal state for a list of item ids on a fresh login -- nothing
    has put those items in front of the player, so nothing has pulled their
    data. A panel that lists items renders those rows as L["LOADING_ITEM"] and
    hands the cold ids here.

    RequestLoadItemDataByID asks the server for each one, then a bounded poll
    repaints the panel as answers land. One chain per registry name watches a
    set of every cold id handed in while it runs, so a panel that builds
    several lists (one per scope) has all of them watched, not just the first.
    NotifyChange fires only when an id leaves the set, so a repaint always means
    a row changed. The attempt count restarts whenever a new id joins, giving it
    a full window, while an id the server never answers for (a removed item)
    still stops the chain instead of spinning forever. The repaint re-enters
    this function with ids already in the set, which neither restarts the count
    nor stacks a second chain.
]]
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local WARM_RETRY_SECONDS = 0.5
local WARM_MAX_ATTEMPTS = 10

local warmingIds = {}
local warmingAttempts = {}

function ns.WarmItemCache(itemIds, registryName)
	if not (itemIds and itemIds[1] and registryName) then
		return
	end

	local outstanding = warmingIds[registryName]
	local isChainRunning = outstanding ~= nil
	if not outstanding then
		outstanding = {}
		warmingIds[registryName] = outstanding
	end

	for _, itemId in ipairs(itemIds) do
		C_Item.RequestLoadItemDataByID(itemId)
		if not outstanding[itemId] then
			outstanding[itemId] = true
			warmingAttempts[registryName] = 0
		end
	end

	if isChainRunning then
		return
	end

	local function Poll()
		warmingAttempts[registryName] = warmingAttempts[registryName] + 1

		local isAnyWarm, isAnyCold = false, false
		for itemId in pairs(outstanding) do
			if GetItemInfo(itemId) then
				outstanding[itemId] = nil
				isAnyWarm = true
			else
				isAnyCold = true
			end
		end

		if isAnyWarm then
			AceConfigRegistry:NotifyChange(registryName)
		end

		if isAnyCold and warmingAttempts[registryName] < WARM_MAX_ATTEMPTS then
			C_Timer.After(WARM_RETRY_SECONDS, Poll)
		else
			warmingIds[registryName] = nil
			warmingAttempts[registryName] = nil
		end
	end

	C_Timer.After(WARM_RETRY_SECONDS, Poll)
end

--------------------------------------------------------------------------------
-- Item Input Parsing
--------------------------------------------------------------------------------

--[[
    Two shapes reach an add box: a bare id the player looked up, and a whole item
    link, which is what shift-clicking an item link in chat drops into a focused
    edit box. Anything else is rejected, so a stray word never becomes a row that
    renders as an unresolvable id forever.
]]
function ns:ParseItemInput(rawInput)
	if type(rawInput) ~= "string" then
		return nil
	end

	local itemId = tonumber(rawInput:match("item:(%d+)") or rawInput:match("^%s*(%d+)%s*$"))
	if itemId and itemId > 0 then
		return itemId
	end
	return nil
end

--------------------------------------------------------------------------------
-- Item Identifier Sort
--------------------------------------------------------------------------------

--[[
    Sorted by name, because a list ordered by id reads as random to the player.
    Items the client has not cached yet have no name to sort on, so they fall to
    the bottom by id rather than clustering under an empty string at the top;
    they re-sort into place as the panel repaints. Equal names tie-break on id,
    which makes the comparator a total order -- without it two identically named
    items compare equal and their rows reshuffle on every repaint.

    Each name is looked up once, before the sort. The comparator runs n log n
    times, so asking the client inside it would cost a thousand-item list tens
    of thousands of item lookups per repaint.
]]
function ns:SortItemIdentifiersByName(identifiers)
	local names = {}
	for _, itemId in ipairs(identifiers) do
		names[itemId] = GetItemInfo(itemId) or ""
	end

	table.sort(identifiers, function(a, b)
		local nameA, nameB = names[a], names[b]
		if nameA == nameB then
			return a < b
		end
		if nameA == "" then
			return false
		end
		if nameB == "" then
			return true
		end
		return nameA < nameB
	end)
end

--------------------------------------------------------------------------------
-- Item Display
--------------------------------------------------------------------------------

--[[
    One row's item, rendered for the ItemLink widget below: icon plus the item's
    own colored link, so quality reads at a glance. An id the client has not
    answered for yet shows as loading text instead -- ns.WarmItemCache repaints
    the panel as the data lands.
]]
function ns:GetItemDisplayName(itemId)
	local _, itemLink, _, _, _, _, _, _, _, icon = GetItemInfo(itemId)

	if itemLink and icon then
		return format("|T%s:16|t %s", icon, ns:StripLinkBrackets(itemLink))
	elseif itemLink then
		return ns:StripLinkBrackets(itemLink)
	end

	return GetColor("MUTED") .. format(L["LOADING_ITEM"], itemId) .. "|r"
end

--[[
    Whether this version of the game has the item at all, which is a different
    question from whether its data is cached yet. A list can carry ids the
    client has never heard of -- a saved-variables file edited by hand, or ids
    copied in from another version of the game -- and the server never answers
    for those, so as rows they would read Loading forever and keep the warm
    poll running for nothing.

    Anything that isn't a whole positive number counts as missing too, so a
    hand-edited key never reaches the sort or the item API. The call is
    guarded because a throw here would take the whole panel down with it; a
    client without the call treats every id as real, as before.
]]
local DoesItemExistByID = C_Item.DoesItemExistByID

local function IsItemInGame(itemId)
	if type(itemId) ~= "number" or itemId < 1 or itemId % 1 ~= 0 then
		return false
	end
	if not DoesItemExistByID then
		return true
	end
	local isOk, exists = pcall(DoesItemExistByID, itemId)
	return (isOk and exists) and true or false
end

--------------------------------------------------------------------------------
-- Shared Item List Builder
--------------------------------------------------------------------------------

--[[
    Every player-managed item list renders through here, so lists add and remove
    the same way in every panel. The caller supplies the labels, the source
    table, and the callbacks; this owns the shape. Spec:

      getSourceTable: function returning the table of itemId keys to list
      onAdd: function(itemId) adding an item to that source
      onRemove: function(itemId) removing one
      onRemoveMany: function(itemIds) removing several with one refresh, for
        the Remove Them button under ids this version of the game doesn't have
      onRestore: optional function() putting the list back to its defaults
      notifyKey: AceConfigRegistry name to NotifyChange on every mutation
      paneKey: key naming this pane among the notifyKey's panes (the list
        panels pass the scope key), so its rows' model has one slot to live in
      labels: { addName, addHelp, addInvalid, removeDesc, empty, missingOne,
        missingMany, removeMissingOne, removeMissingMany, removeMissingDesc,
        removeMissingConfirm }
        plus { restoreName, restoreDesc, restoreConfirm } when onRestore is
        supplied
      rowWidth: optional total row budget, default ns.OPTIONS_ROW_WIDTH
      startOrder: optional first order, so a panel can seat its own head above
      actionColumn: optional button per row,
        { name, desc, width, func = function(itemId) }
      getRowTag: optional function(itemId) returning a short word to show in
        silver beside the item, or nil for none
      addFromBags: optional true to put an Add from Bags picker above the add
        box, listing what the player carries that isn't on the list yet
        (labels then carry fromBagsName and fromBagsDesc)

    onRestore is optional rather than part of the shape, so each panel decides
    whether its lists get Restore Defaults. Today the Erase List is the one
    caller that passes it, on every scope: a character's list re-seeds, and the
    All Characters list, which ships empty, is emptied.
]]

--[[
    Remove is an icon, not a labeled button: a captioned button in a column this
    narrow would clip its caption to a sliver. The group-loot pass texture is
    already the game's own "get rid of this" mark, and the word rides in the
    tooltip instead.
]]
local REMOVE_ICON = "Interface/Buttons/UI-GroupLoot-Pass-Up"
local REMOVE_ICON_SIZE = 16

-- A row tag is one short word, so it gets a fixed slice of the item's share.
local ROW_TAG_WIDTH = 0.55

--[[
    The Add from Bags picker's choices: one entry per distinct item in the
    carried bags that the list doesn't hold yet, as icon and link, sorted by
    name. Built on every repaint, which the list panels get after each edit; an
    item looted while the panel stays open shows up on the next one. The game
    closes the bags when the options open, so this is the only way to pick an
    item without knowing its id.
]]
local function GetCarriedItemChoices(sourceTable)
	local values, sorting, seen = {}, {}, {}

	for _, bag in ipairs(ns.CARRIED_BAGS) do
		for slot = 1, (C_Container.GetContainerNumSlots(bag) or 0) do
			local info = C_Container.GetContainerItemInfo(bag, slot)
			local itemId = info and info.itemID
			if itemId and not seen[itemId] and not (sourceTable and sourceTable[itemId]) then
				seen[itemId] = true
				values[itemId] = ns:GetItemDisplayName(itemId)
				sorting[#sorting + 1] = itemId
			end
		end
	end

	ns:SortItemIdentifiersByName(sorting)
	return values, sorting
end

--[[
    What one pane's item list widget draws, by pane: the sorted ids, each one's
    row tag, and the callbacks its buttons call. Rebuilt with the options on
    every repaint, which is cheap now that it is data rather than a few
    thousand option tables, and the option row carries only the key the widget
    looks it up by (AceConfig hands a widget nothing but its get value). One
    slot per pane, so repaints overwrite rather than pile up.
]]
local itemListModels = {}

--[[
    Ids this version of the game doesn't have get one line between them instead
    of a row each: a count and a Remove Them button. They are never sorted,
    never warmed and never drawn as rows, and nothing takes them off the list
    but that button -- the list is the player's, and an id missing from this
    client may be one they still want on another.
]]
local function AddMissingSummary(args, spec, rowWidth, order, missingItemIds)
	local labels = spec.labels
	local isOne = #missingItemIds == 1
	local text = isOne and labels.missingOne or format(labels.missingMany, ns:FormatCommaNumber(#missingItemIds))

	args.missingLabel =
		ns.OptionsRowLabel(GetColor("MUTED") .. text .. "|r", order, rowWidth - ns.OPTIONS_CONTROL_WIDTH)
	args.missingRemove = {
		type = "execute",
		name = isOne and labels.removeMissingOne or labels.removeMissingMany,
		desc = labels.removeMissingDesc,
		confirm = true,
		confirmText = labels.removeMissingConfirm,
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = order + 1,
		func = function()
			spec.onRemoveMany(missingItemIds)
			AceConfigRegistry:NotifyChange(spec.notifyKey)
		end,
	}
	args.spacerMissing = ns.OptionsSpacer(order + 2)

	return order + 3
end

function ns:BuildItemListOptions(spec)
	local labels = spec.labels
	local rowWidth = spec.rowWidth or ns.OPTIONS_ROW_WIDTH
	local args = {}
	local order = spec.startOrder or 1

	--[[
	    Restore Defaults goes last, under the rows, at normal width: the top of a
	    list is for finding and adding, and a rarely used reset shouldn't be the
	    first thing there. Ordered far past any row so it lands last however
	    long the list is.
	]]
	if spec.onRestore then
		args.spacerRestore = ns.OptionsSpacer(9998)
		args.restoreDefaults = {
			type = "execute",
			name = labels.restoreName,
			desc = labels.restoreDesc,
			confirm = true,
			confirmText = labels.restoreConfirm,
			order = 9999,
			func = function()
				spec.onRestore()
				AceConfigRegistry:NotifyChange(spec.notifyKey)
			end,
		}
	end

	--[[
	    Spends this panel's own budget rather than the default label width. A tree
	    panel passes a shorter rowWidth than ns.OPTIONS_ROW_WIDTH (its sidebar eats
	    the difference), so a label sized to the full-panel grid would push the box
	    beside it onto its own line. Taking the remainder after the control keeps
	    the pair on one line and ending where the rows below it end.
	]]
	if spec.addFromBags then
		local values, sorting = GetCarriedItemChoices(spec.getSourceTable())

		args.addFromBagsLabel = ns.OptionsRowLabel(labels.fromBagsName, order, rowWidth - ns.OPTIONS_CONTROL_WIDTH)
		order = order + 1

		-- get returns nil so the picker reads empty again after each add.
		args.addFromBagsSelect = {
			type = "select",
			name = "",
			desc = labels.fromBagsDesc,
			width = ns.OPTIONS_CONTROL_WIDTH,
			order = order,
			values = values,
			sorting = sorting,
			disabled = function()
				return sorting[1] == nil
			end,
			get = function()
				return nil
			end,
			set = function(_, itemId)
				spec.onAdd(itemId)
				AceConfigRegistry:NotifyChange(spec.notifyKey)
			end,
		}
		order = order + 1
	end

	args.addItemLabel = ns.OptionsRowLabel(labels.addName, order, rowWidth - ns.OPTIONS_CONTROL_WIDTH)
	order = order + 1

	--[[
	    get returns empty so the box clears itself on the repaint that follows
	    each add. validate rejects anything ParseItemInput cannot read, which is
	    what keeps a typo out of the list rather than into it as a dead row.
	]]
	args.addItemInput = {
		type = "input",
		name = "",
		desc = labels.addHelp,
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = order,
		validate = function(_, value)
			return ns:ParseItemInput(value) and true or labels.addInvalid
		end,
		get = function()
			return ""
		end,
		set = function(_, value)
			local itemId = ns:ParseItemInput(value)
			if not itemId then
				return
			end
			spec.onAdd(itemId)
			AceConfigRegistry:NotifyChange(spec.notifyKey)
		end,
	}
	order = order + 1

	args.spacerRows = ns.OptionsSpacer(order)
	order = order + 1

	local itemIds, missingItemIds, tags = {}, {}, {}
	for itemId in pairs(spec.getSourceTable() or {}) do
		if IsItemInGame(itemId) then
			itemIds[#itemIds + 1] = itemId
			tags[itemId] = spec.getRowTag and spec.getRowTag(itemId) or nil
		else
			missingItemIds[#missingItemIds + 1] = itemId
		end
	end

	if not (itemIds[1] or missingItemIds[1]) then
		args.descEmpty = ns.OptionsDesc(GetColor("HELP") .. labels.empty .. "|r", order)
		return args
	end

	if missingItemIds[1] then
		order = AddMissingSummary(args, spec, rowWidth, order, missingItemIds)
	end

	if not itemIds[1] then
		return args
	end

	ns:SortItemIdentifiersByName(itemIds)

	local coldItemIds = {}
	for _, itemId in ipairs(itemIds) do
		if not GetItemInfo(itemId) then
			coldItemIds[#coldItemIds + 1] = itemId
		end
	end

	--[[
	    Every row lives in the one widget below rather than as an option of its
	    own, so a thousand-item list costs AceConfig one widget, not five
	    thousand. See the Item List Widget section for how it draws.
	]]
	local modelKey = spec.notifyKey .. "\001" .. tostring(spec.paneKey)
	itemListModels[modelKey] = {
		itemIds = itemIds,
		tags = tags,
		actionColumn = spec.actionColumn,
		removeDesc = labels.removeDesc,
		onRemove = spec.onRemove,
		notifyKey = spec.notifyKey,
	}

	args.itemList = {
		type = "input",
		name = "",
		dialogControl = ns.ITEM_LIST_WIDGET_TYPE,
		width = rowWidth,
		order = order,
		get = function()
			return modelKey
		end,
		set = function() end,
	}

	ns.WarmItemCache(coldItemIds, spec.notifyKey)

	return args
end

--------------------------------------------------------------------------------
-- Character List Tree
--------------------------------------------------------------------------------

--[[
    The panel both list pages share: childGroups = "tree", with the scope list
    on the left (All Characters, a blank row, then the characters) and the
    selected scope's items on the right. The caller supplies spec.name, the
    spec.description shown above the tree, spec.getListForScope(scopeKey) to
    read a list, and spec.buildScopeArgs(scopeKey) to build one pane.

    The description lives on the root group, not in the scope panes: a tree
    group renders its own non-group args once, full width, between the panel
    title and the tree, so the copy reads once above the whole panel instead of
    repeating in every pane.
]]
function ns.BuildCharacterListTree(spec)
	local function ScopeGroup(name, order, scopeKey)
		return {
			type = "group",
			name = name,
			order = order,
			args = spec.buildScopeArgs(scopeKey),
		}
	end

	local args = {
		descIntro = ns.OptionsDesc(spec.description, 1),
		spacerIntro = ns.OptionsSpacer(2),
	}

	--[[
	    Keyed by scope, not by position: the tree remembers the selected node by
	    its arg key, so a key that moved when a character appeared or dropped out
	    of the list would silently reselect a different character.
	]]
	args[ns.LIST_SCOPE_GLOBAL] = ScopeGroup(L["OPTIONS_LIST_GLOBAL"], 3, ns.LIST_SCOPE_GLOBAL)

	--[[
	    A blank, unclickable row between All Characters and the characters.
	    Disabled tree rows take no mouse input, so it can never be selected.
	]]
	args.spacerCharacters = {
		type = "group",
		name = " ",
		order = 4,
		disabled = true,
		args = {},
	}

	if ns.db then
		local currentCharacter = ns.db.keys.char
		local order = 10

		for _, charKey in ipairs(ns:GetCharacterKeys()) do
			--[[
			    A character with an empty list is noise in the tree, so it is left
			    out -- except for the character playing right now, whose list has
			    to be reachable to put a first item in it. Character keys
			    ("Name - Realm") are never localized, so they are shown as-is in
			    their class color and sorted as plain strings.
			]]
			local list = spec.getListForScope(charKey)
			if charKey == currentCharacter or (list and next(list) ~= nil) then
				args[charKey] = ScopeGroup(ns:GetCharacterDisplayName(charKey), order, charKey)
				order = order + 1
			end
		end
	end

	return {
		type = "group",
		name = spec.name,
		childGroups = "tree",
		args = args,
	}
end

--------------------------------------------------------------------------------
-- Item Link Widget
--------------------------------------------------------------------------------

--[[
    A label that draws an item and shows that item's own tooltip on hover, used
    via dialogControl on the rows the builder above emits. AceConfig renders a
    description as a plain Label, which has no mouse scripts at all and so never
    fires an OnEnter; this is that same widget with mouse handling, so the row
    can carry a real GameTooltip. The option's get returns the item id as a
    string and SetText resolves it through ns:GetItemDisplayName.
]]
local AceGUI = LibStub("AceGUI-3.0")
local ITEM_LINK_WIDGET_VERSION = 1

local function OnItemLinkEnter(frame)
	local widget = frame.obj
	if not widget.itemId then
		return
	end
	--[[
	    The bare "item:id" form rather than the link off C_Item.GetItemInfo, so a row
	    still waiting on its item data gets a tooltip too -- and hovering it pulls
	    the very data the row is waiting for.
	]]
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink("item:" .. widget.itemId)
	GameTooltip:Show()
end

local function OnItemLinkLeave()
	GameTooltip:Hide()
end

local itemLinkMethods = {}

function itemLinkMethods:OnAcquire()
	self.itemId = nil
	self:SetHeight(20)
end

function itemLinkMethods:OnRelease()
	self.itemId = nil
end

--[[
    The text is the item id, optionally followed by ";" and a suffix drawn after
    the item, such as a stack count ("1234; x20"). The suffix rides in the text
    because AceConfig hands a dialogControl nothing but its get value.
]]
function itemLinkMethods:SetText(text)
	local idText, suffix = tostring(text or ""):match("^(%d+);(.*)$")
	local itemId = tonumber(idText or text)
	if itemId then
		self.itemId = itemId
		self.label:SetText(ns:GetItemDisplayName(itemId) .. (suffix or ""))
	else
		self.label:SetText(text or "")
	end
end

function itemLinkMethods:GetText()
	return self.itemId and tostring(self.itemId) or ""
end

-- AceConfigDialog drives every input control through these; a row is read-only.
function itemLinkMethods:SetLabel() end

function itemLinkMethods:SetMaxLetters() end

function itemLinkMethods:SetDisabled() end

local function ItemLinkWidgetConstructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(20)
	frame:EnableMouse(true)
	frame:SetScript("OnEnter", OnItemLinkEnter)
	frame:SetScript("OnLeave", OnItemLinkLeave)

	local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetJustifyH("LEFT")
	label:SetPoint("TOPLEFT")
	label:SetPoint("BOTTOMRIGHT")

	local widget = {
		label = label,
		frame = frame,
		type = ns.ITEM_LINK_WIDGET_TYPE,
	}

	for method, func in pairs(itemLinkMethods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(ns.ITEM_LINK_WIDGET_TYPE, ItemLinkWidgetConstructor, ITEM_LINK_WIDGET_VERSION)

--------------------------------------------------------------------------------
-- Item List Widget
--------------------------------------------------------------------------------

--[[
    A whole item list as one AceGUI widget, drawn virtually. AceConfig has no
    way to add rows to a pane that is already drawn -- every repaint throws the
    pane away and feeds it again -- so a list of a thousand option rows cost a
    thousand rows' worth of widgets on every open and every repaint, and the
    game hung while it built them.

    This widget is as tall as the whole list, so the pane keeps its one outer
    scrollbar and looks as it always has, but it only ever builds enough rows
    to fill the visible part of that pane. An OnUpdate compares where the
    widget sits against the scroll frame around it and, when the visible range
    moves, hands the same few row frames the next ids. Repaints therefore cost
    the same for ten items or ten thousand.

    The columns mirror the option rows this replaced, measured in AceConfig's
    own width units: the item, then the row tag when there is one, then the
    actionColumn button, then the remove icon. The option row's get value is
    the itemListModels key, set in ns:BuildItemListOptions.
]]
local ITEM_LIST_WIDGET_VERSION = 1

-- AceConfigDialog's width_multiplier: one unit of option width, in pixels.
local WIDTH_UNIT = 170

local ROW_HEIGHT = 28
local BUTTON_HEIGHT = 24

--[[
    Rows drawn past each edge of the viewport. The scroll frame moves before
    the OnUpdate below notices, so without a margin a fast scroll can show a
    blank strip at the edge for a frame.
]]
local OVERSCAN_ROWS = 2

local function OnItemCellEnter(cell)
	local itemId = cell:GetParent().itemId
	if not itemId then
		return
	end
	GameTooltip:SetOwner(cell, "ANCHOR_RIGHT")
	GameTooltip:SetHyperlink("item:" .. itemId)
	GameTooltip:Show()
end

-- The same title-and-body tooltip AceConfigDialog gives an option's desc.
local function OnButtonCellEnter(cell)
	GameTooltip:SetOwner(cell, "ANCHOR_TOPRIGHT")
	if cell.tooltipTitle then
		GameTooltip:SetText(cell.tooltipTitle, 1, 0.82, 0, 1, true)
		GameTooltip:AddLine(cell.tooltipText, 1, 1, 1, true)
	else
		GameTooltip:SetText(cell.tooltipText, 1, 1, 1, 1, true)
	end
	GameTooltip:Show()
end

local function OnCellLeave()
	GameTooltip:Hide()
end

local function OnActionClick(cell)
	local row = cell:GetParent()
	local model = row.widget.model
	if model and row.itemId then
		model.actionColumn.func(row.itemId)
		AceConfigRegistry:NotifyChange(model.notifyKey)
	end
end

local function OnRemoveClick(cell)
	local row = cell:GetParent()
	local model = row.widget.model
	if model and row.itemId then
		model.onRemove(row.itemId)
		AceConfigRegistry:NotifyChange(model.notifyKey)
	end
end

local function CreateRow(widget)
	local row = CreateFrame("Frame", nil, widget.frame)
	row:SetHeight(ROW_HEIGHT)
	row.widget = widget

	local item = CreateFrame("Button", nil, row)
	item:SetPoint("TOPLEFT")
	item:SetPoint("BOTTOMLEFT")
	item:SetScript("OnEnter", OnItemCellEnter)
	item:SetScript("OnLeave", OnCellLeave)
	row.item = item

	local itemText = item:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	itemText:SetJustifyH("LEFT")
	itemText:SetWordWrap(false)
	itemText:SetAllPoints()
	row.itemText = itemText

	local tag = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	tag:SetJustifyH("LEFT")
	tag:SetPoint("TOPLEFT", item, "TOPRIGHT")
	tag:SetPoint("BOTTOMLEFT", item, "BOTTOMRIGHT")
	tag:SetWidth(ROW_TAG_WIDTH * WIDTH_UNIT)
	row.tag = tag

	local removeWidth = ns.OPTIONS_REMOVE_ICON_WIDTH * WIDTH_UNIT

	local remove = CreateFrame("Button", nil, row)
	remove:SetSize(REMOVE_ICON_SIZE, REMOVE_ICON_SIZE)
	remove:SetPoint("RIGHT", row, "RIGHT", -(removeWidth - REMOVE_ICON_SIZE) / 2, 0)
	remove:SetNormalTexture(REMOVE_ICON)
	-- The hover glow AceGUI's Icon widget draws, so the icon reacts as it did.
	local highlight = remove:CreateTexture(nil, "HIGHLIGHT")
	highlight:SetAllPoints()
	highlight:SetTexture(136580)
	highlight:SetTexCoord(0, 1, 0.23, 0.77)
	highlight:SetBlendMode("ADD")
	remove:SetScript("OnClick", OnRemoveClick)
	remove:SetScript("OnEnter", OnButtonCellEnter)
	remove:SetScript("OnLeave", OnCellLeave)
	row.remove = remove

	local action = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
	action:SetHeight(BUTTON_HEIGHT)
	action:SetPoint("RIGHT", row, "RIGHT", -removeWidth, 0)
	action:SetScript("OnClick", OnActionClick)
	action:SetScript("OnEnter", OnButtonCellEnter)
	action:SetScript("OnLeave", OnCellLeave)
	row.action = action

	widget.rows[#widget.rows + 1] = row
	return row
end

local function BindRow(widget, row, index)
	local model = widget.model
	local itemId = model.itemIds[index]
	local actionColumn = model.actionColumn
	local tagText = model.tags[itemId]

	row.itemId = itemId
	row:ClearAllPoints()
	row:SetPoint("TOPLEFT", widget.frame, "TOPLEFT", 0, -(index - 1) * ROW_HEIGHT)
	row:SetPoint("TOPRIGHT", widget.frame, "TOPRIGHT", 0, -(index - 1) * ROW_HEIGHT)

	-- The item takes whatever the columns to its right leave over.
	local rightWidth = ns.OPTIONS_REMOVE_ICON_WIDTH * WIDTH_UNIT
	if actionColumn then
		rightWidth = rightWidth + actionColumn.width * WIDTH_UNIT
	end
	if tagText then
		rightWidth = rightWidth + ROW_TAG_WIDTH * WIDTH_UNIT
	end
	row.item:SetPoint("RIGHT", row, "RIGHT", -rightWidth, 0)
	row.itemText:SetText(ns:GetItemDisplayName(itemId))

	if tagText then
		row.tag:SetText(GetColor("HELP") .. tagText .. "|r")
		row.tag:Show()
	else
		row.tag:Hide()
	end

	if actionColumn then
		row.action:SetWidth(actionColumn.width * WIDTH_UNIT)
		row.action:SetText(actionColumn.name)
		row.action.tooltipTitle = actionColumn.name
		row.action.tooltipText = actionColumn.desc
		row.action:Show()
	else
		row.action:Hide()
	end

	row.remove.tooltipText = model.removeDesc
	row:Show()

	-- A row rebound under the cursor shows its new item's tooltip, not the old one's.
	if GameTooltip:IsOwned(row.item) then
		OnItemCellEnter(row.item)
	end
end

--[[
    The nearest scroll frame around the widget is the window rows are seen
    through; UIParent stands in if there is none, so the list still draws.
]]
local function FindViewport(frame)
	local parent = frame:GetParent()
	while parent do
		if parent:GetObjectType() == "ScrollFrame" then
			return parent
		end
		parent = parent:GetParent()
	end
	return UIParent
end

local function HideRowsFrom(widget, firstUnused)
	for index = firstUnused, #widget.rows do
		widget.rows[index]:Hide()
		widget.rows[index].itemId = nil
	end
end

--[[
    Which ids are on screen, from where the widget's top sits against the
    viewport's top and bottom. Both are measured in the widget's own scale, as
    the viewport can sit under a different one. Before the first layout
    anchors the widget it has no position at all, so nothing is drawn and the
    next frame tries again.
]]
local function UpdateVisibleRows(widget)
	local model = widget.model
	local count = model and #model.itemIds or 0
	local top = widget.frame:GetTop()
	if count == 0 or not top then
		HideRowsFrom(widget, 1)
		widget.firstShown, widget.lastShown = nil, nil
		return
	end

	widget.viewport = widget.viewport or FindViewport(widget.frame)
	local viewport = widget.viewport
	local viewTop, viewBottom = viewport:GetTop(), viewport:GetBottom()
	if not (viewTop and viewBottom) then
		return
	end
	local toWidgetScale = viewport:GetEffectiveScale() / widget.frame:GetEffectiveScale()
	viewTop, viewBottom = viewTop * toWidgetScale, viewBottom * toWidgetScale

	local first = math.max(1, math.floor((top - viewTop) / ROW_HEIGHT) + 1 - OVERSCAN_ROWS)
	local last = math.min(count, math.ceil((top - viewBottom) / ROW_HEIGHT) + OVERSCAN_ROWS)
	if first == widget.firstShown and last == widget.lastShown then
		return
	end
	widget.firstShown, widget.lastShown = first, last

	local used = 0
	for index = first, last do
		used = used + 1
		BindRow(widget, widget.rows[used] or CreateRow(widget), index)
	end
	HideRowsFrom(widget, used + 1)
end

local function OnItemListUpdate(frame)
	UpdateVisibleRows(frame.obj)
end

local itemListMethods = {}

function itemListMethods:OnAcquire()
	self.model = nil
	self.viewport = nil
	self.firstShown, self.lastShown = nil, nil
	self:SetHeight(ROW_HEIGHT)
end

function itemListMethods:OnRelease()
	self.model = nil
	self.viewport = nil
	self.firstShown, self.lastShown = nil, nil
	HideRowsFrom(self, 1)
end

-- The text is the itemListModels key; the widget is as tall as every row it holds.
function itemListMethods:SetText(text)
	self.model = itemListModels[text]
	self.firstShown, self.lastShown = nil, nil
	local count = self.model and #self.model.itemIds or 0
	self:SetHeight(math.max(count, 1) * ROW_HEIGHT)
end

function itemListMethods:GetText()
	return ""
end

-- AceConfigDialog drives every input control through these; the list is read-only.
function itemListMethods:SetLabel() end

function itemListMethods:SetMaxLetters() end

function itemListMethods:SetDisabled() end

local function ItemListWidgetConstructor()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetHeight(ROW_HEIGHT)
	frame:SetScript("OnUpdate", OnItemListUpdate)

	local widget = {
		frame = frame,
		rows = {},
		type = ns.ITEM_LIST_WIDGET_TYPE,
	}

	for method, func in pairs(itemListMethods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(ns.ITEM_LIST_WIDGET_TYPE, ItemListWidgetConstructor, ITEM_LIST_WIDGET_VERSION)
