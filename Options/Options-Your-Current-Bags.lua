local _, ns = ...
local L = ns.L

local format, ipairs = string.format, ipairs

local GetColor = ns.GetColor

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Your Current Bags Panel
--------------------------------------------------------------------------------

--[[
    The mini-map tooltip, made clickable: the Clutter Report, led by the next
    item up with Erase and Protect beside it, then the queue behind it under Up
    Next, and the total last. Erase enters
    through ns:RunEraser and Protect through ns:ProtectItemWithMessage, the same
    paths the mini-map button and the key bindings take, so every gate,
    confirmation and chat line is theirs.

    Registered as a builder function (see Options/Options.lua) and repainted by
    ns:RefreshDisplay on every bag change, so the queue is always the live bags.
    The Settings panel can't open in combat, and ns:RunEraser refuses there
    anyway, so nothing here needs its own combat check.
]]

-- How many items the Up Next list shows after the one up next.
local QUEUE_LENGTH = 5

--[[
    Column widths for the whole page. This page spends the pane's full width
    rather than ns.OPTIONS_ROW_WIDTH, because its rows are a table and the
    buttons need room for their captions: AceGUI's Button insets its text 15px
    from each edge, so anything narrower clips "Protect". The pane holds about
    3.7 units; the columns sum to 3.6, leaving the slack ns.OptionsSubRow
    explains.

    Every row shares one set of columns: the item with its count, its value,
    its reason, then two button slots. Up Next rows leave the Erase slot blank,
    so their Protect buttons sit under the top row's. The Everything in Your
    Bags table below reuses the same edges: its item column spans item and
    value, Type sits under the reason, and the two checkboxes sit under the two
    buttons.
]]
local ITEM_WIDTH = 1.45
local VALUE_WIDTH = 0.45
local REASON_WIDTH = 0.6
local BUTTON_WIDTH = 0.55

local REASON_TAG_KEYS = { manual = "REASON_MANUAL" }
for _, kind in ipairs(ns.ERASE_KINDS) do
	REASON_TAG_KEYS[kind[1]] = kind[4]
end

--[[
    The item cell, with the count right after the name so the value column
    stays aligned however long the name is: "x20" for a stack, and "(5 stacks)"
    when an Up Next row gathers several. The ItemLink widget takes the id and
    the suffix together, "id;suffix", so the row keeps the item's own tooltip.
]]
local function ItemCell(itemId, count, stacks, width, order)
	local suffix = ""
	if count > 1 then
		suffix = " " .. GetColor("TEXT") .. "x" .. ns:FormatCommaNumber(count) .. "|r"
	end
	if stacks and stacks > 1 then
		suffix = suffix .. " " .. GetColor("MUTED") .. format(L["OPTIONS_STACKS"], stacks) .. "|r"
	end
	return {
		type = "input",
		name = "",
		dialogControl = ns.ITEM_LINK_WIDGET_TYPE,
		width = width,
		order = order,
		get = function()
			return tostring(itemId) .. ";" .. suffix
		end,
		set = function() end,
	}
end

local function TextOnly(text, width, order)
	return {
		type = "description",
		name = text,
		fontSize = "medium",
		width = width,
		order = order,
	}
end

local function ValueCell(value, order)
	local text = (value > 0) and ns:FormatCurrency(value) or (GetColor("MUTED") .. L["NO_VALUE"] .. "|r")
	return TextOnly(text, VALUE_WIDTH, order)
end

--[[
    Why the row counts as junk, with "Asks First" when the Erasing panel says
    so, in place of the reason, since that is the thing the player needs to
    know before they click.
]]
local function ReasonCell(candidate, order)
	local text
	if ns:NeedsSafetyConfirm(candidate) then
		text = GetColor("TITLE") .. L["REASON_ASKS_FIRST"] .. "|r"
	else
		text = GetColor("HELP") .. L[REASON_TAG_KEYS[candidate.deleteReason] or "REASON_MANUAL"] .. "|r"
	end
	return TextOnly(text, REASON_WIDTH, order)
end

local function ProtectButton(candidate, order)
	return {
		type = "execute",
		name = L["OPTIONS_PROTECT_BUTTON"],
		desc = L["OPTIONS_PROTECT_BUTTON_DESC"],
		width = BUTTON_WIDTH,
		order = order,
		func = function()
			ns:ProtectItemWithMessage(candidate.itemId, candidate.link)
		end,
	}
end

--[[
    The rest of the queue, one row per item rather than per stack: six stacks of
    bread are one row, "x100 (5 stacks)", with the total value, in the order its
    cheapest stack comes up. Protect covers every stack at once, so a row per
    stack would only repeat the same button.
]]
local function GroupByItem(queue, firstIndex)
	local groups, byItem = {}, {}
	for index = firstIndex, #queue do
		local candidate = queue[index]
		local group = byItem[candidate.itemId]
		if not group then
			group = {
				itemId = candidate.itemId,
				link = candidate.link,
				deleteReason = candidate.deleteReason,
				count = 0,
				value = 0,
				stacks = 0,
			}
			byItem[candidate.itemId] = group
			groups[#groups + 1] = group
		end
		group.count = group.count + candidate.count
		group.value = group.value + candidate.value
		group.stacks = group.stacks + 1
	end
	return groups
end

--------------------------------------------------------------------------------
-- Everything in Your Bags
--------------------------------------------------------------------------------

--[[
    Every distinct item the player carries, junk or not, sorted by name, each
    with its item type and two checkboxes: Erase and Protect. It is the fastest
    way to sort a bagful of things onto the two lists, since the options can't
    be open with the bags.

    The boxes act on this character's own lists and are exclusive, matching the
    rule that the Protect List always wins: ticking Protect takes the item off
    this character's Erase List (ns:AddToIgnoreList already does), and ticking
    Erase first takes it off this character's Protect List. An item held by an
    All Characters list shows its box ticked and greyed, because unticking it
    here would change every character; the tooltip sends the player to that
    list's page instead.
]]
local ROW_ITEM_WIDTH = ITEM_WIDTH + VALUE_WIDTH
local ROW_TYPE_WIDTH = REASON_WIDTH
local ROW_CHECK_WIDTH = BUTTON_WIDTH

local function NotifyListPanels()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.IgnoreList)
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.EraseList)
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.YourCurrentBags)
end

local function OnGlobalList(getGlobalList, itemId)
	local list = getGlobalList(ns)
	return (list and list[itemId]) and true or false
end

local function SetErase(itemId, value)
	local scopeKey = ns.db.keys.char
	if value then
		ns:SetIgnoredInScope(scopeKey, itemId, false)
	end
	ns:SetOnEraseListInScope(scopeKey, itemId, value)
	NotifyListPanels()
end

local function SetProtect(itemId, value)
	if value then
		ns:AddToIgnoreList(itemId)
	else
		ns:SetIgnoredInScope(ns.db.keys.char, itemId, false)
	end
	NotifyListPanels()
end

-- Each distinct item id in the carried bags, once, sorted by name.
local function GetCarriedItemIds()
	local ids, seen = {}, {}
	for _, bag in ipairs(ns.CARRIED_BAGS) do
		for slot = 1, (C_Container.GetContainerNumSlots(bag) or 0) do
			local info = C_Container.GetContainerItemInfo(bag, slot)
			local itemId = info and info.itemID
			if itemId and not seen[itemId] then
				seen[itemId] = true
				ids[#ids + 1] = itemId
			end
		end
	end
	ns:SortItemIdentifiersByName(ids)
	return ids
end

--[[
    One text cell in a row. The column headings are gold (TITLE, the palette's
    header color) so they stand apart from the silver cell values under them,
    the item types included.
]]
local function TextCell(text, width, order, colorKey)
	return {
		type = "description",
		name = GetColor(colorKey or "HELP") .. text .. "|r",
		fontSize = "medium",
		width = width,
		order = order,
	}
end

local function AddEverythingInBags(args, startOrder)
	local ids = GetCarriedItemIds()
	if not ids[1] then
		return
	end

	args.spacerEverything = ns.OptionsSpacer(startOrder)
	args.headerEverything = ns.OptionsHeader(L["OPTIONS_EVERYTHING_HEADER"], startOrder + 1)
	args.descEverything = ns.OptionsDesc(L["OPTIONS_EVERYTHING_DESCRIPTION"], startOrder + 2)
	args.spacerEverythingIntro = ns.OptionsSpacer(startOrder + 2.5)
	args.rowEverythingCaptions = {
		type = "group",
		name = "",
		inline = true,
		order = startOrder + 3,
		args = {
			item = TextCell(L["OPTIONS_COLUMN_ITEM"], ROW_ITEM_WIDTH, 1, "TITLE"),
			itemType = TextCell(L["OPTIONS_COLUMN_TYPE"], ROW_TYPE_WIDTH, 2, "TITLE"),
			erase = TextCell(L["OPTIONS_COLUMN_ERASE"], ROW_CHECK_WIDTH, 3, "TITLE"),
			protect = TextCell(L["OPTIONS_COLUMN_PROTECT"], ROW_CHECK_WIDTH, 4, "TITLE"),
		},
	}

	local coldItemIds = {}
	local order = startOrder + 4

	for _, itemId in ipairs(ids) do
		local _, _, _, _, _, itemType = C_Item.GetItemInfo(itemId)
		if not itemType then
			coldItemIds[#coldItemIds + 1] = itemId
		end

		local eraseGlobal = OnGlobalList(ns.GetGlobalEraseList, itemId)
		local protectGlobal = OnGlobalList(ns.GetGlobalIgnoreList, itemId)

		args["rowBagItem_" .. itemId] = {
			type = "group",
			name = "",
			inline = true,
			order = order,
			args = {
				item = ItemCell(itemId, 1, nil, ROW_ITEM_WIDTH, 1),
				itemType = TextCell(itemType or "", ROW_TYPE_WIDTH, 2),
				erase = {
					type = "toggle",
					name = "",
					desc = eraseGlobal and L["OPTIONS_CHECK_ERASE_GLOBAL_DESC"] or L["OPTIONS_CHECK_ERASE_DESC"],
					width = ROW_CHECK_WIDTH,
					order = 3,
					disabled = eraseGlobal or protectGlobal,
					get = function()
						return ns:IsOnEraseList(itemId) and not ns:IsIgnored(itemId)
					end,
					set = function(_, value)
						SetErase(itemId, value)
					end,
				},
				protect = {
					type = "toggle",
					name = "",
					desc = protectGlobal and L["OPTIONS_CHECK_PROTECT_GLOBAL_DESC"] or L["OPTIONS_CHECK_PROTECT_DESC"],
					width = ROW_CHECK_WIDTH,
					order = 4,
					disabled = protectGlobal,
					get = function()
						return ns:IsIgnored(itemId)
					end,
					set = function(_, value)
						SetProtect(itemId, value)
					end,
				},
			},
		}
		order = order + 1
	end

	ns.WarmItemCache(coldItemIds, ns.OPTIONS_REGISTRY.YourCurrentBags)
end

function ns.BuildYourCurrentBagsOptions()
	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"], 1),
		spacerIntro = ns.OptionsSpacer(2),
	}

	local queue = ns:GetEraseQueue()
	local nextItem = queue[1]

	if not nextItem then
		args.descClean = ns.OptionsDesc(GetColor("ON") .. L["BAGS_CLEAN_CONGRATS"] .. "|r", 10)
		args.spacerClean = ns.OptionsSpacer(10.5)
		args.descCleanHint = ns.OptionsDesc(GetColor("HELP") .. L["BAGS_CLEAN_HINT"] .. "|r", 11)
	else
		args.headerClutter = ns.OptionsHeader(L["CLUTTER_REPORT"], 10)

		args.rowUpNext = {
			type = "group",
			name = "",
			inline = true,
			order = 11,
			args = {
				item = ItemCell(nextItem.itemId, nextItem.count, 1, ITEM_WIDTH, 1),
				value = ValueCell(nextItem.value, 2),
				reason = ReasonCell(nextItem, 3),
				erase = {
					type = "execute",
					name = L["OPTIONS_ERASE_BUTTON"],
					desc = L["OPTIONS_ERASE_BUTTON_DESC"],
					width = BUTTON_WIDTH,
					order = 4,
					func = function()
						ns:RunEraser()
					end,
				},
				protect = ProtectButton(nextItem, 5),
			},
		}

		--[[
		    The Clutter Report, worded as the mini-map tooltip words it, over the
		    whole queue rather than the cached scan so the two lines on this
		    page always agree.
		]]
		local items, value = 0, 0
		for _, candidate in ipairs(queue) do
			items = items + candidate.count
			value = value + candidate.value
		end
		local slotsLabel = (#queue == 1) and L["CLUTTER_SLOTS_ONE"]
			or format(L["CLUTTER_SLOTS"], ns:FormatCommaNumber(#queue))
		local itemsLabel = (items == 1) and L["CLUTTER_ITEMS_ONE"]
			or format(L["CLUTTER_ITEMS"], ns:FormatCommaNumber(items))

		--[[
		    The total closes the section, under the rows it adds up, like a
		    receipt. It counts the whole queue, not just the rows shown.
		]]
		args.spacerReport = ns.OptionsSpacer(30)
		args.descReport = ns.OptionsDesc(
			GetColor("TITLE")
				.. L["OPTIONS_CLUTTER_TOTAL"]
				.. "|r  "
				.. GetColor("TEXT")
				.. slotsLabel
				.. "|r "
				.. GetColor("MUTED")
				.. itemsLabel
				.. "|r  "
				.. ns:FormatCurrency(value),
			31
		)

		local groups = GroupByItem(queue, 2)
		if groups[1] then
			args.headerUpNext = ns.OptionsHeader(L["OPTIONS_UP_NEXT"], 20)
			for index = 1, math.min(#groups, QUEUE_LENGTH) do
				local group = groups[index]
				args["rowQueue" .. index] = {
					type = "group",
					name = "",
					inline = true,
					order = 20 + index,
					args = {
						item = ItemCell(group.itemId, group.count, group.stacks, ITEM_WIDTH, 1),
						value = ValueCell(group.value, 2),
						reason = ReasonCell(group, 3),
						eraseSlot = TextOnly(" ", BUTTON_WIDTH, 4),
						protect = ProtectButton(group, 5),
					},
				}
			end
		end
	end

	AddEverythingInBags(args, 50)

	return {
		type = "group",
		name = L["TAB_YOUR_CURRENT_BAGS"],
		args = args,
	}
end
