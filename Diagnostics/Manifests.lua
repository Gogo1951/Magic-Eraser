local _, ns = ...

local GetClientHeader = ns.GetDiagnosticClientHeader
local CountKeys = ns.CountDiagnosticKeys
local TooltipLines = ns.DiagnosticTooltipLines

--------------------------------------------------------------------------------
-- API Endpoints
--------------------------------------------------------------------------------

--[[
    Existence and shape checks only: read-only, no side effects, no protected
    calls. One row per API Magic Eraser actually calls or guards, wherever it
    lives -- nothing incidental, and nothing the add-on does not use.

    Every modern/legacy pair the add-on still picks between is listed as both
    halves: the tooltip hook (TooltipDataProcessor with a data-driven
    GameTooltip.ProcessInfo, or GameTooltip:SetBagItem)
    and the list bindings' hovered-item read (TooltipUtil.GetDisplayedItem or
    GameTooltip:GetItem, picked by ns.GetDisplayedItem in Features/Utilities.lua),
    and the tooltip-text read (C_TooltipInfo.GetItemByID and GetSpellByID, or
    the hidden scan tooltip, picked by ns.GetTooltipLines, which needs both
    getters). The scan tooltip is probed
    through the GameTooltip methods it inherits, so the check creates nothing.
    A FAIL on one half is the report working rather than a defect: the pair is
    what tells a bug report which branch that client actually took. Reading the
    tooltip pair as PASS legacy plus FAIL modern is how you know the SetBagItem
    hook is the live path there. Never drop the half that fails on the client in
    front of you -- that is the half carrying the answer.
]]
ns.DIAGNOSTIC_API_CHECKS = {
	-- { label, testFunction }
	{
		"C_AddOns.GetAddOnMetadata",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnMetadata) == "function"
		end,
	},
	{
		"C_AddOns.GetAddOnInfo",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnInfo) == "function"
		end,
	},
	{
		"C_AddOns.GetNumAddOns",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetNumAddOns) == "function"
		end,
	},
	{
		"C_Seasons.GetActiveSeason",
		function()
			return type(C_Seasons) == "table" and type(C_Seasons.GetActiveSeason) == "function"
		end,
	},
	{
		"Enum.SeasonID.SeasonOfDiscovery",
		function()
			return type(Enum) == "table" and type(Enum.SeasonID) == "table" and Enum.SeasonID.SeasonOfDiscovery ~= nil
		end,
	},
	{
		"Settings.OpenToCategory",
		function()
			return type(Settings) == "table" and type(Settings.OpenToCategory) == "function"
		end,
	},
	--[[
	    The three routes ns:OpenKeyBindings tries for the Set Key button, in its
	    order, each with what it needs: the category id; the Settings panel's
	    category list and its GetAllCategories; the legacy KeyBindingFrame and
	    ShowUIPanel. One route passing whole is enough; the report says which one
	    this client has.
	]]
	{
		"Settings.KEYBINDINGS_CATEGORY_ID",
		function()
			return type(Settings) == "table" and Settings.KEYBINDINGS_CATEGORY_ID ~= nil
		end,
	},
	{
		"SettingsPanel.GetCategoryList",
		function()
			return type(SettingsPanel) == "table" and type(SettingsPanel.GetCategoryList) == "function"
		end,
	},
	{
		"SettingsPanel category list GetAllCategories",
		function()
			if not (type(SettingsPanel) == "table" and type(SettingsPanel.GetCategoryList) == "function") then
				return false
			end
			local ok, list = pcall(SettingsPanel.GetCategoryList, SettingsPanel)
			return ok and type(list) == "table" and type(list.GetAllCategories) == "function"
		end,
	},
	{
		"KeyBindingFrame_LoadUI (legacy)",
		function()
			return type(KeyBindingFrame_LoadUI) == "function" or type(KeyBindingFrame) == "table"
		end,
	},
	{
		"ShowUIPanel (legacy)",
		function()
			return type(ShowUIPanel) == "function"
		end,
	},
	{
		"C_Container.GetContainerNumSlots",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerNumSlots) == "function"
		end,
	},
	{
		"C_Container.GetContainerItemInfo",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerItemInfo) == "function"
		end,
	},
	{
		"C_Container.PickupContainerItem",
		function()
			return type(C_Container) == "table" and type(C_Container.PickupContainerItem) == "function"
		end,
	},
	{
		"C_Container.UseContainerItem",
		function()
			return type(C_Container) == "table" and type(C_Container.UseContainerItem) == "function"
		end,
	},
	{
		"C_Container.GetContainerNumFreeSlots",
		function()
			return type(C_Container) == "table" and type(C_Container.GetContainerNumFreeSlots) == "function"
		end,
	},
	{
		"C_QuestLog.IsQuestFlaggedCompleted",
		function()
			return type(C_QuestLog) == "table" and type(C_QuestLog.IsQuestFlaggedCompleted) == "function"
		end,
	},
	{
		"C_Item.RequestLoadItemDataByID",
		function()
			return type(C_Item) == "table" and type(C_Item.RequestLoadItemDataByID) == "function"
		end,
	},
	{
		"C_Item.DoesItemExistByID",
		function()
			return type(C_Item) == "table" and type(C_Item.DoesItemExistByID) == "function"
		end,
	},
	{
		"C_Item.GetItemInfo",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemInfo) == "function"
		end,
	},
	{
		"C_Item.GetItemInfoInstant",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemInfoInstant) == "function"
		end,
	},
	{
		"C_Item.GetItemQualityColor",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemQualityColor) == "function"
		end,
	},
	--[[
	    Validate Data's extra reads; one a client lacks leaves its columns blank.
	    GetItemSpell and the stat read are the white-gear rule's reads as well,
	    and the stat read goes through ns.GetItemStats, so a client needs either
	    C_Item.GetItemStats or the legacy GetItemStats row below, or it never
	    erases white gear.
	]]
	{
		"C_Item.GetItemSpell",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemSpell) == "function"
		end,
	},
	{
		"C_Item.GetDetailedItemLevelInfo",
		function()
			return type(C_Item) == "table" and type(C_Item.GetDetailedItemLevelInfo) == "function"
		end,
	},
	{
		"C_Item.GetItemStats",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemStats) == "function"
		end,
	},
	{
		"GetItemStats (legacy)",
		function()
			return type(GetItemStats) == "function"
		end,
	},
	{
		"C_Item.GetItemClassInfo",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemClassInfo) == "function"
		end,
	},
	{
		"C_Item.GetItemSubClassInfo",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemSubClassInfo) == "function"
		end,
	},
	{
		"C_Spell.GetSpellDescription",
		function()
			return type(C_Spell) == "table" and type(C_Spell.GetSpellDescription) == "function"
		end,
	},
	{
		"C_Spell.RequestLoadSpellData",
		function()
			return type(C_Spell) == "table" and type(C_Spell.RequestLoadSpellData) == "function"
		end,
	},
	{
		"C_TooltipInfo.GetItemByID",
		function()
			return type(C_TooltipInfo) == "table" and type(C_TooltipInfo.GetItemByID) == "function"
		end,
	},
	{
		"C_TooltipInfo.GetSpellByID",
		function()
			return type(C_TooltipInfo) == "table" and type(C_TooltipInfo.GetSpellByID) == "function"
		end,
	},
	{
		"Hidden scan tooltip (legacy)",
		function()
			return type(CreateFrame) == "function"
				and type(GameTooltip) == "table"
				and type(GameTooltip.SetHyperlink) == "function"
				and type(GameTooltip.NumLines) == "function"
		end,
	},
	{
		"C_QuestLog.GetTitleForQuestID",
		function()
			return type(C_QuestLog) == "table" and type(C_QuestLog.GetTitleForQuestID) == "function"
		end,
	},
	{
		"C_QuestLog.GetQuestInfo",
		function()
			return type(C_QuestLog) == "table" and type(C_QuestLog.GetQuestInfo) == "function"
		end,
	},
	{
		"C_QuestLog.RequestLoadQuestByID",
		function()
			return type(C_QuestLog) == "table" and type(C_QuestLog.RequestLoadQuestByID) == "function"
		end,
	},
	{
		"GetCursorInfo",
		function()
			return type(GetCursorInfo) == "function"
		end,
	},
	{
		"CursorHasItem",
		function()
			return type(CursorHasItem) == "function"
		end,
	},
	{
		"ClearCursor",
		function()
			return type(ClearCursor) == "function"
		end,
	},
	{
		"DeleteCursorItem",
		function()
			return type(DeleteCursorItem) == "function"
		end,
	},
	{
		"StaticPopup_Show",
		function()
			return type(StaticPopup_Show) == "function"
		end,
	},
	{
		"StaticPopup_FindVisible",
		function()
			return type(StaticPopup_FindVisible) == "function"
		end,
	},
	--[[
	    Manual Delete Assistance reads two client strings and calls four methods on
	    the delete dialog. A client missing any of them leaves the feature silently
	    inert -- the prompt still asks for the typed word -- so each is a row here
	    and the report says which one was absent. StaticPopup1 is a global frame,
	    so the probe needs no dialog open.
	]]
	{
		"DELETE_GOOD_ITEM",
		function()
			return type(DELETE_GOOD_ITEM) == "string"
		end,
	},
	{
		"DELETE_ITEM_CONFIRM_STRING",
		function()
			return type(DELETE_ITEM_CONFIRM_STRING) == "string"
		end,
	},
	{
		"StaticPopup1.GetEditBox",
		function()
			return type(StaticPopup1) == "table" and type(StaticPopup1.GetEditBox) == "function"
		end,
	},
	{
		"StaticPopup1.GetButton1",
		function()
			return type(StaticPopup1) == "table" and type(StaticPopup1.GetButton1) == "function"
		end,
	},
	{
		"StaticPopup1.GetTextFontString",
		function()
			return type(StaticPopup1) == "table" and type(StaticPopup1.GetTextFontString) == "function"
		end,
	},
	{
		"StaticPopup1.Resize",
		function()
			return type(StaticPopup1) == "table" and type(StaticPopup1.Resize) == "function"
		end,
	},
	{
		"TooltipDataProcessor.AddTooltipPostCall",
		function()
			return type(TooltipDataProcessor) == "table" and type(TooltipDataProcessor.AddTooltipPostCall) == "function"
		end,
	},
	{
		"GameTooltip.ProcessInfo (data-driven tooltips)",
		function()
			return type(GameTooltip) == "table" and type(GameTooltip.ProcessInfo) == "function"
		end,
	},
	{
		"Enum.TooltipDataType.Item",
		function()
			return type(Enum) == "table" and type(Enum.TooltipDataType) == "table" and Enum.TooltipDataType.Item ~= nil
		end,
	},
	{
		"GameTooltip.SetBagItem (legacy)",
		function()
			return type(GameTooltip) == "table" and type(GameTooltip.SetBagItem) == "function"
		end,
	},
	{
		"TooltipUtil.GetDisplayedItem",
		function()
			return type(TooltipUtil) == "table" and type(TooltipUtil.GetDisplayedItem) == "function"
		end,
	},
	{
		"GameTooltip.GetItem (legacy)",
		function()
			return type(GameTooltip) == "table" and type(GameTooltip.GetItem) == "function"
		end,
	},
	{
		"Enum.BagIndex.ReagentBag",
		function()
			return type(Enum) == "table" and type(Enum.BagIndex) == "table" and Enum.BagIndex.ReagentBag ~= nil
		end,
	},
	{
		"Enum.BagIndex.CharacterBankTab_1",
		function()
			return type(Enum) == "table" and type(Enum.BagIndex) == "table" and Enum.BagIndex.CharacterBankTab_1 ~= nil
		end,
	},
	{
		"BANK_CONTAINER (legacy)",
		function()
			return type(BANK_CONTAINER) == "number"
		end,
	},
	{
		"InCombatLockdown",
		function()
			return type(InCombatLockdown) == "function"
		end,
	},
	{
		"C_Timer.After",
		function()
			return type(C_Timer) == "table" and type(C_Timer.After) == "function"
		end,
	},
	{
		"C_EventUtils.IsEventValid",
		function()
			return type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function"
		end,
	},
	{
		"GetCVar",
		function()
			return type(GetCVar) == "function"
		end,
	},
	{
		"SetCVar",
		function()
			return type(SetCVar) == "function"
		end,
	},
}

--------------------------------------------------------------------------------
-- Eraser Context
--------------------------------------------------------------------------------

-- The add-on's own example reports, appended to the shared Event Log intro.
ns.DiagnosticsStrings.EVENT_LOG_EXAMPLES = "Best for 'nothing gets erased' or 'Auto-Vend didn't sell' reports."

--[[
    The state most likely to explain a "nothing gets erased" report: the player
    context the evaluator reads, the sizes of the curated databases, and the
    item the eraser would act on right now. Existence/value reads only. The
    candidate's link has its pipes escaped so it pastes as plain text rather than
    a clickable swatch.
]]
function ns:BuildEraserContextReport()
	local lines = { GetClientHeader(), "" }

	local _, class = UnitClass("player")
	lines[#lines + 1] = string.format("Player: %s level %d", tostring(class), UnitLevel("player") or 0)
	lines[#lines + 1] =
		string.format("Auto-Vend: %s", (ns.db and ns.db.profile.autoVendEnabled) and "enabled" or "disabled")
	lines[#lines + 1] =
		string.format("Bank retrieval: %s", (ns.db and ns.db.profile.bankRetrievalEnabled) and "enabled" or "disabled")

	--[[
	    Both scopes, because protection is additive: an unexpectedly skipped item
	    may be on either list, and the character's own list alone would not say so.
	]]
	lines[#lines + 1] = string.format(
		"Ignore list: character=%d, global=%d",
		CountKeys(ns:GetIgnoreList()),
		CountKeys(ns:GetGlobalIgnoreList())
	)
	--[[
	    Both scopes again, and the seed marker with them: "why is Fish Oil not on
	    my list" is answered by whether this character was ever seeded, which the
	    counts alone cannot say.
	]]
	lines[#lines + 1] = string.format(
		"Erase list: character=%d, global=%d, seeded=%s",
		CountKeys(ns:GetEraseList()),
		CountKeys(ns:GetGlobalEraseList()),
		tostring((ns.db and ns.db.char.eraseListSeeded) and true or false)
	)
	lines[#lines + 1] = string.format(
		"Databases: quest=%d, questStarting=%d, consumables=%d, ammo=%d, keepEquipment=%d",
		CountKeys(ns.ALLOWED_DELETE_QUEST_ITEMS),
		CountKeys(ns.ALLOWED_DELETE_QUEST_STARTING_ITEMS),
		CountKeys(ns.ALLOWED_DELETE_CONSUMABLES),
		CountKeys(ns.ALLOWED_DELETE_AMMO),
		CountKeys(ns.KEEP_EQUIPMENT)
	)
	-- Seed data only. Nothing filters on this at scan time; see ns.CLASS_REAGENTS.
	local reagents = ns.CLASS_REAGENTS and ns.CLASS_REAGENTS[class]
	lines[#lines + 1] = string.format("Class reagents (%s): %d", tostring(class), CountKeys(reagents))

	--[[
	    Bank Retrieval scans ns.BANK_CONTAINERS, built from the client's character
	    bank tabs where it has them and from these globals where it does not, so
	    printing both beside every container's slot count shows a client whose
	    bank is laid out differently without a bank window open. A missing global
	    prints nil. ns.CARRIED_BAGS is listed too, so a report shows whether the
	    reagent bag is among the bags every scan walks.
	]]
	lines[#lines + 1] = ""
	lines[#lines + 1] = "Bank layout:"
	lines[#lines + 1] = string.format(
		"  NUM_BAG_SLOTS=%s, BANK_CONTAINER=%s, NUM_BANKBAGSLOTS=%s, LAST_BAG_INDEX=%s",
		tostring(NUM_BAG_SLOTS),
		tostring(BANK_CONTAINER),
		tostring(NUM_BANKBAGSLOTS),
		tostring(ns.LAST_BAG_INDEX)
	)
	lines[#lines + 1] = "  Carried bags scanned: " .. table.concat(ns.CARRIED_BAGS, ", ")
	lines[#lines + 1] = "  Bank Retrieval scans: " .. table.concat(ns.BANK_CONTAINERS, ", ")
	local bagIndex = Enum.BagIndex
	if type(bagIndex) == "table" then
		local entries = {}
		for name, value in pairs(bagIndex) do
			entries[#entries + 1] = { name = tostring(name), value = value }
		end
		table.sort(entries, function(a, b)
			if a.value == b.value then
				return a.name < b.name
			end
			return (tonumber(a.value) or 0) < (tonumber(b.value) or 0)
		end)
		lines[#lines + 1] = "  Enum.BagIndex:"
		for _, entry in ipairs(entries) do
			lines[#lines + 1] = string.format("    %s = %s", entry.name, tostring(entry.value))
		end
	else
		lines[#lines + 1] = "  Enum.BagIndex: (absent)"
	end
	-- pcall because an index this client does not define may throw rather than answer 0.
	local lastIndex = math.max(ns.LAST_BAG_INDEX + 8, ns.BANK_CONTAINERS[#ns.BANK_CONTAINERS] or 0)
	for index = -1, lastIndex do
		local ok, slots = pcall(C_Container.GetContainerNumSlots, index)
		lines[#lines + 1] = string.format("  container %d: %s", index, ok and (tostring(slots) .. " slots") or "error")
	end

	lines[#lines + 1] = ""
	local item = ns:FindItemToDelete()
	if item then
		lines[#lines + 1] = "Current erase candidate:"
		lines[#lines + 1] = "  link     = " .. (tostring(item.link):gsub("|", "||"))
		lines[#lines + 1] = string.format("  itemId   = %s", tostring(item.itemId))
		lines[#lines + 1] = string.format("  reason   = %s", tostring(item.deleteReason))
		lines[#lines + 1] = string.format("  value    = %d copper (x%d)", item.value or 0, item.count or 1)
		lines[#lines + 1] = string.format("  bag/slot = %s/%s", tostring(item.bag), tostring(item.slot))
		local tooltipLines, problem = TooltipLines("item", item.itemId)
		if problem then
			lines[#lines + 1] = "  tooltip  = (read failed: " .. (problem:gsub("|", "||")) .. ")"
		end
		for _, tooltipLine in ipairs(tooltipLines) do
			lines[#lines + 1] = "  tooltip  = " .. (tooltipLine:gsub("|", "||"))
		end
	else
		lines[#lines + 1] = "Current erase candidate: (none -- no flagged items in bags)"
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Validate Data Sources
--------------------------------------------------------------------------------

--[[
    One entry per data file, and one report row per entry on the Data tab
    (Diagnostics/Options-Diagnostics.lua). Each entry's label is the table-name part of
    its file name, so ns.DataSourceFileName can name the file this client's
    folder built. Each source names the static table on ns and its kind, "item"
    or "quest". Ids are reached through rowId(key, row) over the table's pairs, or through collect(tbl) for a table not keyed by the id it
    holds, which returns { id, key, row } entries. dataColumns carries the
    shipped row's own values as { header, getter(key, row) }, so the export sets
    what the file says beside what the client says. Adding a data file adds an
    entry here, and the panel and the validator pick it up with no second list.
]]
local function KeyIsId(key)
	return key
end

local function RowField(position)
	return function(_, row)
		return type(row) == "table" and row[position] or nil
	end
end

local function RowJoined(_, row)
	return type(row) == "table" and table.concat(row, ",") or nil
end

local function KeyValue(key)
	return key
end

local function CollectClassReagents(reagentsByClass)
	local entries = {}
	for classToken, reagents in pairs(reagentsByClass) do
		for itemId, row in pairs(reagents) do
			entries[#entries + 1] = { id = itemId, key = classToken, row = row }
		end
	end
	return entries
end

--[[
    Quest ids live inside item rows, so a quest source walks the item table and
    answers once per quest, its row the sorted list of item ids that point at it.
]]
local function QuestCollector(questIdsOf)
	return function(itemRows)
		local itemsByQuest = {}
		for itemId, row in pairs(itemRows) do
			if type(row) == "table" then
				for _, questId in ipairs(questIdsOf(row)) do
					if type(questId) == "number" then
						itemsByQuest[questId] = itemsByQuest[questId] or {}
						itemsByQuest[questId][#itemsByQuest[questId] + 1] = itemId
					end
				end
			end
		end
		local entries = {}
		for questId, itemIds in pairs(itemsByQuest) do
			table.sort(itemIds)
			entries[#entries + 1] = { id = questId, key = questId, row = itemIds }
		end
		return entries
	end
end

local CollectItemQuests = QuestCollector(function(row)
	return row
end)

local CollectStarterQuests = QuestCollector(function(row)
	return { row[1] }
end)

local QUEST_ITEM_IDS_COLUMN = { "DATA_ITEM_IDS", RowJoined }

ns.DIAGNOSTIC_DATA_SOURCES = {
	-- { label, sources = { { table, kind, rowId or collect, dataColumns } } }
	{
		label = "Quest-Items",
		sources = {
			{
				table = "ALLOWED_DELETE_QUEST_ITEMS",
				kind = "item",
				rowId = KeyIsId,
				dataColumns = { { "DATA_QUEST_IDS", RowJoined } },
			},
			{
				table = "ALLOWED_DELETE_QUEST_ITEMS",
				kind = "quest",
				collect = CollectItemQuests,
				dataColumns = { QUEST_ITEM_IDS_COLUMN },
			},
		},
	},
	{
		label = "Quest-Starting-Items",
		sources = {
			{
				table = "ALLOWED_DELETE_QUEST_STARTING_ITEMS",
				kind = "item",
				rowId = KeyIsId,
				dataColumns = {
					{ "DATA_QUEST_ID", RowField(1) },
					{ "DATA_RACE_MASK", RowField(2) },
					{ "DATA_CLASS_MASK", RowField(3) },
				},
			},
			{
				table = "ALLOWED_DELETE_QUEST_STARTING_ITEMS",
				kind = "quest",
				collect = CollectStarterQuests,
				dataColumns = { QUEST_ITEM_IDS_COLUMN },
			},
		},
	},
	{
		label = "Consumables",
		sources = {
			{
				table = "ALLOWED_DELETE_CONSUMABLES",
				kind = "item",
				rowId = KeyIsId,
				dataColumns = { { "DATA_USE_LEVEL", RowField(1) } },
			},
		},
	},
	{
		label = "Ammo",
		sources = {
			{
				table = "ALLOWED_DELETE_AMMO",
				kind = "item",
				rowId = KeyIsId,
				dataColumns = {
					{ "DATA_USE_LEVEL", RowField(1) },
					{ "DATA_NEXT_TIER_LEVEL", RowField(2) },
				},
			},
		},
	},
	{
		label = "Equipment",
		sources = { { table = "KEEP_EQUIPMENT", kind = "item", rowId = KeyIsId } },
	},
	{
		label = "Class-Reagents",
		sources = {
			{
				table = "CLASS_REAGENTS",
				kind = "item",
				collect = CollectClassReagents,
				dataColumns = { { "DATA_CLASS", KeyValue } },
			},
		},
	},
}
