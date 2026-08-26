local _, ns = ...
local L = ns.L

local format = string.format

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

function ns.OptionsSpacer(order)
	return { type = "description", name = " ", order = order }
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
-- Item Cache Warming
--------------------------------------------------------------------------------

--[[
    GetItemInfo answers nil for an item the client has not cached yet, which is
    the normal state for a list of item ids on a fresh login -- nothing has put
    those items in front of the player, so nothing has pulled their data. A panel
    that lists items renders those rows as L["LOADING_ITEM"] and hands the cold
    ids here.

    RequestLoadItemDataByID asks the server for each one, then a bounded poll
    repaints the panel as answers land. NotifyChange fires only when the cold
    count actually drops, so a repaint always means a row changed; the attempt
    cap means an id the server never answers for (a removed item) stops polling
    instead of spinning forever. One chain per registry name at a time: the
    repaint re-enters this function with the still-cold ids, and the pending flag
    keeps that from stacking a second chain of timers on top of the first.
]]
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local WARM_RETRY_SECONDS = 0.5
local WARM_MAX_ATTEMPTS = 10

local warmingPending = {}

function ns.WarmItemCache(itemIds, registryName)
	if not (itemIds and itemIds[1] and registryName) then
		return
	end

	for _, itemId in ipairs(itemIds) do
		if C_Item and C_Item.RequestLoadItemDataByID then
			C_Item.RequestLoadItemDataByID(itemId)
		end
	end

	if warmingPending[registryName] then
		return
	end
	warmingPending[registryName] = true

	local coldCount = #itemIds
	local attempts = 0

	local function Poll()
		attempts = attempts + 1

		local stillCold = 0
		for _, itemId in ipairs(itemIds) do
			if not GetItemInfo(itemId) then
				stillCold = stillCold + 1
			end
		end

		if stillCold < coldCount then
			coldCount = stillCold
			AceConfigRegistry:NotifyChange(registryName)
		end

		if stillCold > 0 and attempts < WARM_MAX_ATTEMPTS then
			C_Timer.After(WARM_RETRY_SECONDS, Poll)
		else
			warmingPending[registryName] = nil
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
]]
function ns:SortItemIdentifiersByName(identifiers)
	table.sort(identifiers, function(a, b)
		local nameA = GetItemInfo(a) or ""
		local nameB = GetItemInfo(b) or ""
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
		return format("|T%s:16|t %s", icon, itemLink)
	elseif itemLink then
		return itemLink
	end

	return GetColor("MUTED") .. format(L["LOADING_ITEM"], itemId) .. "|r"
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
      onRestore: optional function() putting the list back to its defaults
      notifyKey: AceConfigRegistry name to NotifyChange on every mutation
      labels: { addName, addHelp, addInvalid, removeDesc, empty }
        plus { restoreName, restoreConfirm } when onRestore is supplied
      rowWidth: optional total row budget, default ns.OPTIONS_ROW_WIDTH
      startOrder: optional first order, so a panel can seat its own head above
      actionColumn: optional extra cell per row, either
        { type = "execute", name, desc, width, func = function(itemId) }
        or { type = "select", desc, values, sorting, width, get, set }

    Restore Defaults appears only for a list that ships defaults, which is why
    onRestore is optional rather than part of the shape: a list the player built
    from nothing has none to restore, so the row would only offer to empty it.
    Today the Erase List's per-character scope is the one caller that passes it.
]]

--[[
    Remove is an icon, not a labeled button. An execute carrying an image renders
    as an AceGUI Icon; the stock Button insets its font string 15px from each
    edge, which in a column this narrow clips a caption to a sliver. The
    group-loot pass texture is already the game's own "get rid of this" mark, and
    name stays empty so the Icon draws no caption -- the label rides in desc,
    which AceConfigDialog shows on hover.
]]
local REMOVE_ICON = "Interface/Buttons/UI-GroupLoot-Pass-Up"
local REMOVE_ICON_SIZE = 16

function ns:BuildItemListOptions(spec)
	local labels = spec.labels
	local rowWidth = spec.rowWidth or ns.OPTIONS_ROW_WIDTH
	local args = {}
	local order = spec.startOrder or 1

	if spec.onRestore then
		args.restoreDefaults = {
			type = "execute",
			name = labels.restoreName,
			width = "double",
			confirm = true,
			confirmText = labels.restoreConfirm,
			order = order,
			func = function()
				spec.onRestore()
				AceConfigRegistry:NotifyChange(spec.notifyKey)
			end,
		}
		order = order + 1

		args.spacerRestore = ns.OptionsSpacer(order)
		order = order + 1
	end

	args.addItemLabel = ns.OptionsRowLabel(labels.addName, order)
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

	local identifiers = {}
	for itemId in pairs(spec.getSourceTable() or {}) do
		identifiers[#identifiers + 1] = itemId
	end

	if #identifiers == 0 then
		args.descEmpty = ns.OptionsDesc(GetColor("HELP") .. labels.empty .. "|r", order)
		return args
	end

	ns:SortItemIdentifiersByName(identifiers)

	local actionColumn = spec.actionColumn
	local itemWidth = rowWidth - ns.OPTIONS_REMOVE_ICON_WIDTH
	if actionColumn then
		itemWidth = itemWidth - actionColumn.width
	end

	local coldItemIds = {}

	for _, itemId in ipairs(identifiers) do
		local capturedId = itemId

		if not GetItemInfo(capturedId) then
			coldItemIds[#coldItemIds + 1] = capturedId
		end

		--[[
		    AceGUI's flow layout has no notion of a row: it packs widgets left to
		    right and wraps only when the next will not fit, so laid out flat,
		    cells from different items run together the moment the leftover space
		    takes the next item's name. An inline group with an empty name renders
		    as a bare SimpleGroup -- no border, no title, no padding -- at "fill"
		    width, and the flow layout always gives a fill widget its own line. The
		    cells then flow inside it, so every row breaks at the same points.
		]]
		local cells = {
			item = {
				type = "input",
				name = "",
				dialogControl = ns.ITEM_LINK_WIDGET_TYPE,
				width = itemWidth,
				order = 1,
				get = function()
					return tostring(capturedId)
				end,
				set = function() end,
			},
		}

		if actionColumn then
			if actionColumn.type == "execute" then
				cells.action = {
					type = "execute",
					name = actionColumn.name,
					desc = actionColumn.desc,
					width = actionColumn.width,
					order = 2,
					func = function()
						actionColumn.func(capturedId)
						AceConfigRegistry:NotifyChange(spec.notifyKey)
					end,
				}
			else
				cells.action = {
					type = "select",
					name = "",
					desc = actionColumn.desc,
					values = actionColumn.values,
					sorting = actionColumn.sorting,
					width = actionColumn.width,
					order = 2,
					get = function()
						return actionColumn.get(capturedId)
					end,
					set = function(_, value)
						actionColumn.set(capturedId, value)
					end,
				}
			end
		end

		-- Removing one row takes one click and no confirm.
		cells.remove = {
			type = "execute",
			name = "",
			desc = labels.removeDesc,
			image = REMOVE_ICON,
			imageWidth = REMOVE_ICON_SIZE,
			imageHeight = REMOVE_ICON_SIZE,
			width = ns.OPTIONS_REMOVE_ICON_WIDTH,
			order = 3,
			func = function()
				spec.onRemove(capturedId)
				AceConfigRegistry:NotifyChange(spec.notifyKey)
			end,
		}

		args["item_" .. tostring(capturedId)] = {
			type = "group",
			name = "",
			inline = true,
			order = order,
			args = cells,
		}
		order = order + 1
	end

	ns.WarmItemCache(coldItemIds, spec.notifyKey)

	return args
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
	    The bare "item:id" form rather than the link off GetItemInfo, so a row
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

function itemLinkMethods:SetText(text)
	local itemId = tonumber(text)
	if itemId then
		self.itemId = itemId
		self.label:SetText(ns:GetItemDisplayName(itemId))
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
