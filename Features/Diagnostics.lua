local ADDON_NAME, ns = ...

--------------------------------------------------------------------------------
-- Diagnostic Tools
--------------------------------------------------------------------------------

--[[
    Environment probing and state capture for bug reports, not unit tests. WoW's
    sandboxed Lua has no assertion runner, so everything here is read-only and
    side-effect free. The one exception is the explicit Taint Log button, which
    sets the taintLog CVar. Reports build only on a button press, never on load
    or panel open.
]]

--------------------------------------------------------------------------------
-- Runtime State
--------------------------------------------------------------------------------

--[[
    Runtime-only state. NOT a SavedVariable. File-scope init is correct here --
    the "initialize on PLAYER_LOGIN" rule applies only to SavedVariables, which
    don't exist until the client loads them. This is a plain namespace table, so
    it starts false at every login and is never persisted.
]]
ns.diagnostics = ns.diagnostics or { enabled = false, logging = false, log = nil }

--------------------------------------------------------------------------------
-- Strings
--------------------------------------------------------------------------------

--[[
    Diagnostics strings are intentionally NOT localized. They are
    developer-facing troubleshooting text; translating them is wasted effort for
    zero player value. Every diagnostics string lives here as plain English, in
    the diagnostics files only -- never in Locales/. The one exception is the
    add-on's own display name (ns.ADDON_TITLE), which is the add-on's identity,
    not a diagnostics string.
]]
ns.DiagnosticsStrings = {
	TAB = "Diagnostic Tools",
	WARNING = "These tools help diagnose problems and are meant for developers. They won't change how the add-on works, but their output includes technical details about your client and installed add-ons. Leave this off unless you're troubleshooting with someone.",
	ENABLE = "Enable Diagnostic Tools",
	EVENT_LOG_TITLE = "Event Log",
	EVENT_LOG_START = "Start Event Log",
	EVENT_LOG_STOP = "Stop Event Log",
	EVENT_LOG_SHOW = "Show Captured Events",
	EVENT_LOG_HINT = "Captures the events Magic Eraser registered for, with arguments, in the order they fired. Best for 'nothing gets erased' or 'Auto-Vend didn't sell' reports -- it separates 'the event never fired' from 'the event fired but nothing happened.'",
	EVENTS_TITLE = "Event Registration",
	EVENTS_BUTTON = "Test Event Registration",
	API_TITLE = "API Endpoints",
	API_BUTTON = "Test WoW API Endpoints",
	ERASER_TITLE = "Eraser Context",
	ERASER_BUTTON = "Show Eraser Context",
	VALIDATE_TITLE = "Validate Data: %s",
	VALIDATE_BUTTON = "Validate %s",
	VALIDATE_HINT = "Checks every item and quest id a data file ships against this client and exports what the client knows about each one as tab-separated text, ready to paste into a spreadsheet. Item rows carry every item API return, the file's own values in the DATA columns so you can sort for mismatches, and the full tooltip, one line per TOOLTIP column. STATUS reads OK, NOT ON CLIENT for an item id this client does not recognize, or NOT LOADED when the client knows the id but never answered with its data. Quest ids follow in a block of their own, where NO TITLE means the client never answered with the quest's title, which is also how an unknown quest looks. A large file takes a few seconds; the box shows progress until the export replaces it.",
	DISPLAY_TITLE = "Display Context",
	DISPLAY_BUTTON = "Show Display Context",
	ADDONS_TITLE = "Other Add-ons",
	ADDONS_BUTTON = "List Installed Add-ons",
	SAVED_TITLE = "Saved Variables",
	SAVED_BUTTON = "Dump Saved Variables",
	LIBS_TITLE = "Library Versions",
	LIBS_BUTTON = "List Library Versions",
	TAINT_TITLE = "Taint Log",
	TAINT_STATE = "Taint logging is currently set to level %d (0 = off, 2 = verbose).",
	TAINT_ON = "Turn On Taint Log",
	TAINT_OFF = "Turn Off Taint Log",
	TAINT_HINT = "Writes to Logs\\taint.log. The setting persists until turned off; reload your UI to capture taint from login onward.",
	TOOLS_TITLE = "External Tools",
	TOOLS_ERRORS = "Lua errors: install BugSack and !BugGrabber, or enable %s to surface them.",
	TOOLS_ETRACE = "Live event tracing: use %s.",
}

--------------------------------------------------------------------------------
-- Enable Gate
--------------------------------------------------------------------------------

function ns:SetDiagnosticsEnabled(value)
	ns.diagnostics.enabled = value and true or false
	if not ns.diagnostics.enabled then
		ns:StopEventLog()
		ns:StopDataValidation()
	end
end

--------------------------------------------------------------------------------
-- Report Header
--------------------------------------------------------------------------------

local function GetClientHeader()
	local version, build, _, tocVersion = GetBuildInfo()
	local flavor = (ns.FLAVOR or "?") .. (ns.IS_SOD and " (Season of Discovery)" or "")
	return string.format(
		"%s %s // Client %s // Build %s // TOC %s // Locale %s // Flavor %s",
		ns.ADDON_TITLE,
		ns.Version,
		version,
		build,
		tocVersion,
		GetLocale(),
		flavor
	)
end

local function CountKeys(value)
	local count = 0
	if type(value) == "table" then
		for _ in pairs(value) do
			count = count + 1
		end
	end
	return count
end

--------------------------------------------------------------------------------
-- Event Log
--------------------------------------------------------------------------------

local EVENT_LOG_SIZE = 500
local EVENT_LOG_MAX_ARGS = 8
local EVENT_LOG_MAX_ARG_LENGTH = 255

--[[
    Events ns:LogEvent drops before recording -- deliberately empty. The
    dispatcher only ever hands LogEvent the events Magic Eraser registers (Core's
    ns.EVENT_NAMES), and none of those is a sustained firehose worth dropping:
    the add-on listens on the coalesced BAG_UPDATE_DELAYED rather than raw
    BAG_UPDATE, and every registered event is potential signal in a bug report.
    The lookup in LogEvent stays so a genuine no-signal firehose can be excluded
    here if one is ever registered. Generic offenders
    (COMBAT_LOG_EVENT_UNFILTERED, UNIT_AURA, ...) do not belong here unless
    registered -- the log never sees an event the add-on didn't register.
]]
ns.DIAGNOSTIC_EVENT_EXCLUDE = {}

function ns:StartEventLog()
	ns.diagnostics.log = {}
	ns.diagnostics.logging = true
end

function ns:StopEventLog()
	ns.diagnostics.logging = false
	ns.diagnostics.log = nil
end

--[[
    Called by the event handlers for every event while logging is active.
    Snapshots arguments to strings immediately -- never retain references, since
    some events carry frames or tables that would leak memory or go stale. Caps
    the arg count and per-argument byte length so a single entry can't run away.

    Pipes are escaped (| -> ||) AFTER the length cut so each argument shows
    verbatim in the report editbox instead of rendering as a clickable item
    swatch. Escaping last also means the cut can never leave a dangling pipe that
    would eat the following ", " separator.
]]
function ns:LogEvent(event, ...)
	if ns.DIAGNOSTIC_EVENT_EXCLUDE[event] then
		return
	end
	local log = ns.diagnostics.log
	if not log then
		return
	end
	local parts = {}
	for index = 1, select("#", ...) do
		if index > EVENT_LOG_MAX_ARGS then
			break
		end
		local raw = string.sub(tostring((select(index, ...))), 1, EVENT_LOG_MAX_ARG_LENGTH)
		parts[index] = (raw:gsub("|", "||"))
	end
	log[#log + 1] = string.format("%.3f %s(%s)", GetTime(), event, table.concat(parts, ", "))
	if #log > EVENT_LOG_SIZE then
		table.remove(log, 1)
	end
end

function ns:BuildEventLogReport()
	local lines = { GetClientHeader(), "" }
	local log = ns.diagnostics.log
	if not log or #log == 0 then
		lines[#lines + 1] = "(no events captured)"
	else
		for _, entry in ipairs(log) do
			lines[#lines + 1] = entry
		end
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Event Registration
--------------------------------------------------------------------------------

--[[
    For every event Magic Eraser registers (ns.EVENT_NAMES, exported by
    Core.lua), report whether it is valid on this client
    (C_EventUtils.IsEventValid) and whether RegisterEvent succeeds. The probe
    frame registers then immediately unregisters each event with no handler
    attached, so nothing is ever processed. The list is sourced from Core so it
    can never drift from the events the add-on actually uses.
]]

local probeFrame

local function GetProbeFrame()
	if not probeFrame then
		probeFrame = CreateFrame("Frame")
	end
	return probeFrame
end

function ns:RunEventChecks()
	local lines = { GetClientHeader(), "" }
	local hasIsEventValid = type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function"
	local probe = GetProbeFrame()
	local failures = 0
	for _, event in ipairs(ns.EVENT_NAMES or {}) do
		local valid = "n/a"
		if hasIsEventValid then
			valid = C_EventUtils.IsEventValid(event) and "valid" or "INVALID"
		end
		local ok = pcall(probe.RegisterEvent, probe, event)
		if ok then
			probe:UnregisterEvent(event)
		else
			failures = failures + 1
		end
		lines[#lines + 1] = string.format("[%s] %s (IsEventValid: %s)", ok and "PASS" or "FAIL", event, valid)
	end
	lines[#lines + 1] = ""
	if failures == 0 then
		lines[#lines + 1] = "All events register on this client."
	else
		lines[#lines + 1] = string.format("%d event(s) failed to register.", failures)
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- API Endpoints
--------------------------------------------------------------------------------

--[[
    Existence and shape checks only: read-only, no side effects, no protected
    calls. One row per API Magic Eraser actually calls or guards, wherever it
    lives -- nothing incidental, and nothing the add-on does not use.

    Every modern/legacy pair the add-on still picks between is listed as both
    halves: the tooltip hook (TooltipDataProcessor or GameTooltip:SetBagItem),
    the three item-info accessors in Features/Utilities.lua, and the item class
    names Validate Data reads. A FAIL on one half is the report working rather
    than a defect: the pair is what tells a bug report which branch that client
    actually took. Reading the tooltip pair as PASS legacy plus FAIL modern is
    how you know the SetBagItem hook is the live path there. Never drop the half
    that fails on the client in front of you -- that is the half carrying the
    answer.
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
		"Settings.OpenToCategory",
		function()
			return type(Settings) == "table" and type(Settings.OpenToCategory) == "function"
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
	{
		"GetItemInfo (legacy)",
		function()
			return type(_G.GetItemInfo) == "function"
		end,
	},
	{
		"GetItemInfoInstant (legacy)",
		function()
			return type(_G.GetItemInfoInstant) == "function"
		end,
	},
	{
		"GetItemQualityColor (legacy)",
		function()
			return type(_G.GetItemQualityColor) == "function"
		end,
	},
	-- Validate Data's extra reads; one a client lacks leaves its columns blank.
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
		"C_Item.GetItemClassInfo",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemClassInfo) == "function"
		end,
	},
	{
		"GetItemClassInfo (legacy)",
		function()
			return type(_G.GetItemClassInfo) == "function"
		end,
	},
	{
		"C_Item.GetItemSubClassInfo",
		function()
			return type(C_Item) == "table" and type(C_Item.GetItemSubClassInfo) == "function"
		end,
	},
	{
		"GetItemSubClassInfo (legacy)",
		function()
			return type(_G.GetItemSubClassInfo) == "function"
		end,
	},
	{
		"C_TooltipInfo.GetItemByID",
		function()
			return type(C_TooltipInfo) == "table" and type(C_TooltipInfo.GetItemByID) == "function"
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
		"GameTooltip.SetBagItem (legacy)",
		function()
			return type(GameTooltip) == "table" and type(GameTooltip.SetBagItem) == "function"
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

function ns:RunApiChecks()
	local lines = { GetClientHeader(), "" }
	for _, check in ipairs(ns.DIAGNOSTIC_API_CHECKS) do
		local ok, result = pcall(check[2])
		lines[#lines + 1] = ((ok and result) and "[PASS] " or "[FAIL] ") .. check[1]
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Tooltip Lines
--------------------------------------------------------------------------------

--[[
    Every line of an item's tooltip as plain text, for the Validate Data export
    and the Eraser Context candidate. A client with C_TooltipInfo hands the lines
    over as data; any other is read off a hidden tooltip that is never shown.
    Color escapes are stripped so a cell sorts on its words, and a line with a
    right-hand column keeps it after " :: ". Both reads are protected, because
    one item the client chokes on must not end a run of a thousand.
]]
local SCAN_TOOLTIP_NAME = "MagicEraserScanTooltip"
local GetTooltipItemData = C_TooltipInfo and C_TooltipInfo.GetItemByID
local scanTooltip

local function PlainText(text)
	if type(text) ~= "string" then
		return nil
	end
	return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|cn[^:]*:", ""):gsub("|r", ""))
end

local function JoinTooltipLine(left, right)
	left = PlainText(left) or ""
	right = PlainText(right)
	if right and right ~= "" then
		return left .. " :: " .. right
	end
	return left
end

local function ReadTooltipData(itemId, lines)
	local data = GetTooltipItemData(itemId)
	for _, line in ipairs(data and data.lines or {}) do
		lines[#lines + 1] = JoinTooltipLine(line.leftText, line.rightText)
	end
end

local function ReadScanTooltip(itemId, lines)
	if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", SCAN_TOOLTIP_NAME, nil, "GameTooltipTemplate")
	end
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	scanTooltip:SetHyperlink("item:" .. itemId)
	for index = 1, scanTooltip:NumLines() do
		local left = _G[SCAN_TOOLTIP_NAME .. "TextLeft" .. index]
		local right = _G[SCAN_TOOLTIP_NAME .. "TextRight" .. index]
		lines[#lines + 1] = JoinTooltipLine(left and left:GetText(), right and right:IsShown() and right:GetText())
	end
	scanTooltip:Hide()
end

local function ReadTooltipLines(itemId)
	local lines = {}
	local ok = pcall(GetTooltipItemData and ReadTooltipData or ReadScanTooltip, itemId, lines)
	if not ok then
		return { "(tooltip read failed)" }
	end
	return lines
end

--------------------------------------------------------------------------------
-- Eraser Context
--------------------------------------------------------------------------------

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
		string.format("Auto-Vend: %s", (ns.db and ns.db.global.autoVendEnabled) and "enabled" or "disabled")
	lines[#lines + 1] =
		string.format("Bank retrieval: %s", (ns.db and ns.db.global.bankRetrievalEnabled) and "enabled" or "disabled")

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
		tostring((ns.db and ns.db.profile.eraseListSeeded) and true or false)
	)
	lines[#lines + 1] = string.format(
		"Databases: quest=%d, questStarting=%d, consumables=%d, equipment=%d",
		CountKeys(ns.ALLOWED_DELETE_QUEST_ITEMS),
		CountKeys(ns.ALLOWED_DELETE_QUEST_STARTING_ITEMS),
		CountKeys(ns.ALLOWED_DELETE_CONSUMABLES),
		CountKeys(ns.ALLOWED_DELETE_EQUIPMENT)
	)
	-- Seed data only. Nothing filters on this at scan time; see ns.CLASS_REAGENTS.
	local reagents = ns.CLASS_REAGENTS and ns.CLASS_REAGENTS[class]
	lines[#lines + 1] = string.format("Class reagents (%s): %d", tostring(class), CountKeys(reagents))

	--[[
	    Bank Retrieval builds its container list from these globals, so a client
	    whose bank is laid out differently shows up here without a bank window
	    open. A missing global prints nil.
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
	for index = -1, ns.LAST_BAG_INDEX + 8 do
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
		for _, tooltipLine in ipairs(ReadTooltipLines(item.itemId)) do
			lines[#lines + 1] = "  tooltip  = " .. (tooltipLine:gsub("|", "||"))
		end
	else
		lines[#lines + 1] = "Current erase candidate: (none -- no flagged items in bags)"
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Validate Data
--------------------------------------------------------------------------------

--[[
    One entry per data file, and one gated Validate Data section per entry in
    Options/Options-Diagnostics.lua. Each source names the static table on ns and
    its kind, "item" or "quest". Ids are reached through rowId(key, row) over the
    table's pairs, or through collect(tbl) for a table not keyed by the id it
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
	-- { file, sources = { { table, kind, rowId or collect, dataColumns } } }
	{
		file = "Data.lua",
		sources = {
			{
				table = "CLASS_REAGENTS",
				kind = "item",
				collect = CollectClassReagents,
				dataColumns = { { "DATA_CLASS", KeyValue } },
			},
		},
	},
	{
		file = "Quest-Items.lua",
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
		file = "Quest-Starting-Items.lua",
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
		file = "Consumables.lua",
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
		file = "Equipment.lua",
		sources = { { table = "ALLOWED_DELETE_EQUIPMENT", kind = "item", rowId = KeyIsId } },
	},
}

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local GetItemInfo = ns.GetItemInfo
local GetItemInfoInstant = ns.GetItemInfoInstant

--[[
    The reads beyond the item-info pair, each picked once by existence. One the
    client lacks leaves its cells blank, and its API Endpoints row says why.
]]
local GetItemSpell = C_Item.GetItemSpell
local GetDetailedItemLevelInfo = C_Item.GetDetailedItemLevelInfo
local GetItemStats = C_Item.GetItemStats
local GetItemClassName = C_Item.GetItemClassInfo or GetItemClassInfo
local GetItemSubClassName = C_Item.GetItemSubClassInfo or GetItemSubClassInfo
local GetQuestTitle = C_QuestLog.GetTitleForQuestID or C_QuestLog.GetQuestInfo
local RequestLoadQuest = C_QuestLog.RequestLoadQuestByID

--[[
    Item and quest data load asynchronously, so a run works in batches across
    frames rather than stalling the client on a thousand lookups at once, and an
    id the server never answers for is flagged after a bounded number of polls
    instead of holding the run open forever.
]]
local VALIDATE_BATCH_SIZE = 100
local VALIDATE_TICK_SECONDS = 0.1
local VALIDATE_RETRY_SECONDS = 0.5
local VALIDATE_MAX_RETRIES = 20

local ITEM_INFO_RETURNS = 17
local ITEM_INFO_INSTANT_RETURNS = 7

local ITEM_COLUMNS = {
	"STATUS",
	"SOURCE",
	"ITEM_ID",
	"NAME",
	"LINK",
	"QUALITY",
	"ITEM_LEVEL",
	"MIN_LEVEL",
	"TYPE",
	"SUBTYPE",
	"STACK_COUNT",
	"EQUIP_LOC",
	"TEXTURE",
	"SELL_PRICE",
	"CLASS_ID",
	"SUBCLASS_ID",
	"BIND_TYPE",
	"EXPANSION_ID",
	"SET_ID",
	"CRAFTING_REAGENT",
	"INSTANT_ITEM_ID",
	"INSTANT_TYPE",
	"INSTANT_SUBTYPE",
	"INSTANT_EQUIP_LOC",
	"INSTANT_ICON",
	"INSTANT_CLASS_ID",
	"INSTANT_SUBCLASS_ID",
}

-- Follow the DATA_* columns on every item row.
local EXTRA_ITEM_COLUMNS = {
	"SPELL_NAME",
	"SPELL_ID",
	"ILVL_EFFECTIVE",
	"ILVL_PREVIEW",
	"ILVL_BASE",
	"CLASS_NAME",
	"SUBCLASS_NAME",
	"STATS",
}

local QUEST_COLUMNS = {
	"STATUS",
	"SOURCE",
	"QUEST_ID",
	"TITLE",
	"IS_FLAGGED_COMPLETED",
}

local STATUS_OK = "OK"
local STATUS_NOT_ON_CLIENT = "NOT ON CLIENT"
local STATUS_NOT_LOADED = "NOT LOADED"
local STATUS_NO_TITLE = "NO TITLE"

local validations = {}

function ns.DataValidationField(fileIndex)
	return "validateReport" .. fileIndex
end

local function PublishValidation(fileIndex, text)
	ns.diagnostics[ns.DataValidationField(fileIndex)] = text
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.Diagnostics)
end

--[[
    One TSV cell. A tab or newline inside a value would break the row, and a
    raw pipe would render an item link as a clickable swatch instead of the
    copyable text a spreadsheet needs.
]]
local function CellText(value)
	if value == nil then
		return ""
	end
	local text = tostring(value):gsub("[\t\r\n]", " ")
	return (text:gsub("|", "||"))
end

local function AppendBlanks(cells, count)
	for _ = 1, count do
		cells[#cells + 1] = ""
	end
end

local function AppendReturns(cells, count, ...)
	for index = 1, count do
		cells[#cells + 1] = CellText((select(index, ...)))
	end
end

local function AppendProtected(cells, count, ok, ...)
	if ok then
		AppendReturns(cells, count, ...)
	else
		cells[#cells + 1] = "ERROR"
		AppendBlanks(cells, count - 1)
	end
end

--[[
    Calls a read the client may lack or may refuse for one odd item, filling
    exactly count cells either way so every row keeps its column alignment.
]]
local function AppendCall(cells, count, fn, ...)
	if type(fn) ~= "function" then
		AppendBlanks(cells, count)
		return
	end
	AppendProtected(cells, count, pcall(fn, ...))
end

local function FormatStats(stats)
	if type(stats) ~= "table" then
		return nil
	end
	local keys = {}
	for key in pairs(stats) do
		keys[#keys + 1] = tostring(key)
	end
	table.sort(keys)
	local parts = {}
	for _, key in ipairs(keys) do
		parts[#parts + 1] = key .. "=" .. tostring(stats[key])
	end
	return table.concat(parts, "; ")
end

local function AppendExtraItemCells(cells, itemId)
	local _, link, _, _, _, _, _, _, _, _, _, classId, subclassId = GetItemInfo(itemId)
	AppendCall(cells, 2, GetItemSpell, itemId)
	AppendCall(cells, 3, GetDetailedItemLevelInfo, link or itemId)
	if classId then
		AppendCall(cells, 1, GetItemClassName, classId)
	else
		AppendBlanks(cells, 1)
	end
	if classId and subclassId then
		AppendCall(cells, 1, GetItemSubClassName, classId, subclassId)
	else
		AppendBlanks(cells, 1)
	end
	local ok, stats = false, nil
	if type(GetItemStats) == "function" and link then
		ok, stats = pcall(GetItemStats, link)
	end
	cells[#cells + 1] = CellText(ok and FormatStats(stats) or nil)
end

local function AppendDataCells(cells, entry, dataHeaders)
	for _, header in ipairs(dataHeaders) do
		cells[#cells + 1] = CellText(entry.data[header])
	end
end

--[[
    Everything up to the tooltip. The tooltip lines come back separately because
    the number of TOOLTIP_ columns is only known once the whole run is in, and
    only a row that resolved OK reads extras or a tooltip at all.
]]
local function BuildItemCells(status, entry, dataHeaders)
	local itemId = entry.id
	local cells = { status, entry.source, tostring(itemId) }
	AppendReturns(cells, ITEM_INFO_RETURNS, GetItemInfo(itemId))
	AppendCall(cells, ITEM_INFO_INSTANT_RETURNS, GetItemInfoInstant, itemId)
	AppendDataCells(cells, entry, dataHeaders)

	if status ~= STATUS_OK then
		AppendBlanks(cells, #EXTRA_ITEM_COLUMNS)
		return cells, {}
	end

	AppendExtraItemCells(cells, itemId)
	return cells, ReadTooltipLines(itemId)
end

--[[
    A quest has no existence check to ask, so an unknown quest and an uncached
    one look the same until the retries run out: the title is the only answer.
]]
local function QuestTitle(questId)
	if type(GetQuestTitle) ~= "function" then
		return nil
	end
	local ok, title = pcall(GetQuestTitle, questId)
	if ok and type(title) == "string" and title ~= "" then
		return title
	end
	return nil
end

local function BuildQuestCells(status, entry, dataHeaders)
	local questId = entry.id
	local cells = {
		status,
		entry.source,
		tostring(questId),
		CellText(QuestTitle(questId)),
		CellText(C_QuestLog.IsQuestFlaggedCompleted(questId)),
	}
	AppendDataCells(cells, entry, dataHeaders)
	return cells
end

--[[
    Whether this client's item database knows the id at all, which is a
    different question from whether the item's data is cached.
]]
local function ItemExistsOnClient(itemId)
	return C_Item.DoesItemExistByID(itemId) and true or false
end

local function CollectEntries(source)
	local rows = ns[source.table]
	if type(rows) ~= "table" then
		return {}
	end
	if source.collect then
		return source.collect(rows)
	end
	local entries = {}
	for key, row in pairs(rows) do
		entries[#entries + 1] = { id = source.rowId(key, row), key = key, row = row }
	end
	return entries
end

--[[
    Every id the entry's sources reach, items before quests and each in id
    order, with its DATA_* values already read, plus each kind's DATA_* headers
    in first-seen order so a file with several sources still gets one header row
    per block.
]]
local function CollectIds(entry)
	local ids = {}
	local headers = { item = {}, quest = {} }
	local seenHeaders = { item = {}, quest = {} }

	for _, source in ipairs(entry.sources) do
		local columns = source.dataColumns or {}
		for _, column in ipairs(columns) do
			if not seenHeaders[source.kind][column[1]] then
				seenHeaders[source.kind][column[1]] = true
				headers[source.kind][#headers[source.kind] + 1] = column[1]
			end
		end

		for _, found in ipairs(CollectEntries(source)) do
			if type(found.id) == "number" then
				local data = {}
				for _, column in ipairs(columns) do
					data[column[1]] = column[2](found.key, found.row)
				end
				ids[#ids + 1] = { id = found.id, source = source.table, kind = source.kind, data = data }
			end
		end
	end

	table.sort(ids, function(a, b)
		if a.kind ~= b.kind then
			return a.kind < b.kind
		end
		if a.id == b.id then
			return a.source < b.source
		end
		return a.id < b.id
	end)
	return ids, headers
end

local function ResolveRow(run, index, status)
	local entry = run.ids[index]
	if entry.kind == "quest" then
		run.rows[index] = BuildQuestCells(status, entry, run.headers.quest)
	else
		local cells, tooltip = BuildItemCells(status, entry, run.headers.item)
		run.rows[index] = cells
		run.tooltips[index] = tooltip
		if #tooltip > run.maxTooltipLines then
			run.maxTooltipLines = #tooltip
		end
	end
	run.resolved = run.resolved + 1
	run.counts[entry.kind][status] = run.counts[entry.kind][status] + 1
end

local function ProgressText(run)
	return table.concat({
		GetClientHeader(),
		"",
		string.format("Validated %s / %s ...", ns:FormatCommaNumber(run.resolved), ns:FormatCommaNumber(#run.ids)),
	}, "\n")
end

--[[
    Every timer a run schedules carries the generation it was created under and
    drops out once a newer one exists, so a second click on the button, or the
    panel being switched off, retires the old chain rather than leaving two runs
    writing the same box.
]]
local function ScheduleValidation(fileIndex, run, delay, step)
	local generation = run.generation
	C_Timer.After(delay, function()
		if run.generation == generation then
			step(fileIndex, run)
		end
	end)
end

local function ReleaseRun(run)
	run.ids = {}
	run.rows = {}
	run.tooltips = {}
	run.pending = {}
end

local function AppendHeaderRow(lines, ...)
	local header = {}
	for index = 1, select("#", ...) do
		for _, column in ipairs((select(index, ...))) do
			header[#header + 1] = column
		end
	end
	lines[#lines + 1] = table.concat(header, "\t")
end

--[[
    The report is the standard client header plus a one-line tally, a blank
    line, then up to two TSV blocks, each a header row naming every column and
    then one row per id in id order: the items, padded out to the run's longest
    tooltip so every row carries the same number of columns, then the quests
    after a blank line. Flagged rows keep their id and source table so the bad
    entry is copyable straight out of the sheet.
]]
local function FinishValidation(fileIndex, run)
	local itemCounts, questCounts = run.counts.item, run.counts.quest
	local tally = string.format(
		"%s // %s item ids // %s %s // %s %s // %s %s",
		run.file,
		ns:FormatCommaNumber(run.itemCount),
		ns:FormatCommaNumber(itemCounts[STATUS_OK]),
		STATUS_OK,
		ns:FormatCommaNumber(itemCounts[STATUS_NOT_ON_CLIENT]),
		STATUS_NOT_ON_CLIENT,
		ns:FormatCommaNumber(itemCounts[STATUS_NOT_LOADED]),
		STATUS_NOT_LOADED
	)
	if run.questCount > 0 then
		tally = tally
			.. string.format(
				" // %s quest ids // %s %s // %s %s",
				ns:FormatCommaNumber(run.questCount),
				ns:FormatCommaNumber(questCounts[STATUS_OK]),
				STATUS_OK,
				ns:FormatCommaNumber(questCounts[STATUS_NO_TITLE]),
				STATUS_NO_TITLE
			)
	end

	local lines = { GetClientHeader(), tally, "" }

	if run.itemCount > 0 then
		local tooltipColumns = { "TOOLTIP_LINES" }
		for index = 1, run.maxTooltipLines do
			tooltipColumns[#tooltipColumns + 1] = "TOOLTIP_" .. index
		end
		AppendHeaderRow(lines, ITEM_COLUMNS, run.headers.item, EXTRA_ITEM_COLUMNS, tooltipColumns)

		for index, entry in ipairs(run.ids) do
			if entry.kind == "item" then
				local cells = run.rows[index]
				local tooltip = run.tooltips[index] or {}
				cells[#cells + 1] = tostring(#tooltip)
				for line = 1, run.maxTooltipLines do
					cells[#cells + 1] = CellText(tooltip[line])
				end
				lines[#lines + 1] = table.concat(cells, "\t")
			end
		end
	end

	if run.questCount > 0 then
		if run.itemCount > 0 then
			lines[#lines + 1] = ""
		end
		AppendHeaderRow(lines, QUEST_COLUMNS, run.headers.quest)
		for index, entry in ipairs(run.ids) do
			if entry.kind == "quest" then
				lines[#lines + 1] = table.concat(run.rows[index], "\t")
			end
		end
	end

	run.finished = true
	ReleaseRun(run)
	PublishValidation(fileIndex, table.concat(lines, "\n"))
end

local PollValidation

--[[
    The first sweep. An item id the client does not know is flagged on the
    spot, a cached item or a quest with a title is exported on the spot, and
    everything else is requested from the server and left for the polls below.
]]
local function SweepValidation(fileIndex, run)
	local last = math.min(run.cursor + VALIDATE_BATCH_SIZE, #run.ids)
	for index = run.cursor + 1, last do
		local entry = run.ids[index]
		if entry.kind == "quest" then
			if QuestTitle(entry.id) then
				ResolveRow(run, index, STATUS_OK)
			else
				if type(RequestLoadQuest) == "function" then
					pcall(RequestLoadQuest, entry.id)
				end
				run.pending[#run.pending + 1] = index
			end
		elseif not ItemExistsOnClient(entry.id) then
			ResolveRow(run, index, STATUS_NOT_ON_CLIENT)
		elseif GetItemInfo(entry.id) then
			ResolveRow(run, index, STATUS_OK)
		else
			C_Item.RequestLoadItemDataByID(entry.id)
			run.pending[#run.pending + 1] = index
		end
	end
	run.cursor = last

	if run.cursor < #run.ids then
		PublishValidation(fileIndex, ProgressText(run))
		ScheduleValidation(fileIndex, run, VALIDATE_TICK_SECONDS, SweepValidation)
	elseif #run.pending > 0 then
		PublishValidation(fileIndex, ProgressText(run))
		ScheduleValidation(fileIndex, run, VALIDATE_RETRY_SECONDS, PollValidation)
	else
		FinishValidation(fileIndex, run)
	end
end

local function IsAnswered(entry)
	if entry.kind == "quest" then
		return QuestTitle(entry.id) ~= nil
	end
	return GetItemInfo(entry.id) ~= nil
end

function PollValidation(fileIndex, run)
	run.retries = run.retries + 1
	local stillPending = {}
	for _, index in ipairs(run.pending) do
		local entry = run.ids[index]
		if IsAnswered(entry) then
			ResolveRow(run, index, STATUS_OK)
		elseif run.retries >= VALIDATE_MAX_RETRIES then
			ResolveRow(run, index, entry.kind == "quest" and STATUS_NO_TITLE or STATUS_NOT_LOADED)
		else
			stillPending[#stillPending + 1] = index
		end
	end
	run.pending = stillPending

	if #run.pending > 0 then
		PublishValidation(fileIndex, ProgressText(run))
		ScheduleValidation(fileIndex, run, VALIDATE_RETRY_SECONDS, PollValidation)
	else
		FinishValidation(fileIndex, run)
	end
end

function ns:StartDataValidation(fileIndex)
	local entry = ns.DIAGNOSTIC_DATA_SOURCES[fileIndex]
	if not entry then
		return
	end

	local run = validations[fileIndex] or { generation = 0 }
	validations[fileIndex] = run

	run.generation = run.generation + 1
	run.file = entry.file
	run.ids, run.headers = CollectIds(entry)
	run.rows = {}
	run.tooltips = {}
	run.pending = {}
	run.maxTooltipLines = 0
	run.itemCount, run.questCount = 0, 0
	for _, id in ipairs(run.ids) do
		if id.kind == "quest" then
			run.questCount = run.questCount + 1
		else
			run.itemCount = run.itemCount + 1
		end
	end
	run.counts = {
		item = { [STATUS_OK] = 0, [STATUS_NOT_ON_CLIENT] = 0, [STATUS_NOT_LOADED] = 0 },
		quest = { [STATUS_OK] = 0, [STATUS_NO_TITLE] = 0 },
	}
	run.cursor = 0
	run.resolved = 0
	run.retries = 0
	run.finished = false

	PublishValidation(fileIndex, ProgressText(run))
	SweepValidation(fileIndex, run)
end

--[[
    Called when the panel is switched off, so a disabled panel has nothing
    ticking. The bumped generation retires every pending timer, and a run cut
    off mid-way drops its progress text rather than leaving a stale "Validated
    300 / 1,240" in the box for the next time the panel is enabled.
]]
function ns:StopDataValidation()
	for fileIndex, run in pairs(validations) do
		run.generation = run.generation + 1
		if not run.finished then
			ReleaseRun(run)
			ns.diagnostics[ns.DataValidationField(fileIndex)] = nil
		end
	end
end

--------------------------------------------------------------------------------
-- Display Context
--------------------------------------------------------------------------------

--[[
    Answers "the minimap button is gone / off-screen" reports: screen size, UI
    scale, and the button's saved placement. Read-only.
]]
function ns:BuildDisplayContextReport()
	local lines = { GetClientHeader(), "" }

	local width, height = GetPhysicalScreenSize()
	lines[#lines + 1] = string.format("Physical screen size: %s x %s", tostring(width), tostring(height))
	lines[#lines + 1] = string.format("UIParent scale: %s", tostring(UIParent and UIParent:GetScale()))
	lines[#lines + 1] = string.format("uiScale CVar: %s", tostring(GetCVar("uiScale")))

	lines[#lines + 1] = ""
	local LibDBIcon = LibStub("LibDBIcon-1.0")
	local button = LibDBIcon:GetMinimapButton(ADDON_NAME)
	lines[#lines + 1] = string.format("Minimap button created: %s", button and "yes" or "no")

	local minimap = ns.db and ns.db.global.minimap
	if type(minimap) == "table" then
		lines[#lines + 1] = string.format("Minimap button hidden: %s", tostring(minimap.hide or false))
		lines[#lines + 1] = string.format("Minimap saved angle: %s", tostring(minimap.minimapPos))
	else
		lines[#lines + 1] = "Minimap saved position: (none yet)"
	end

	--[[
	    Where a dragged position lives, link by link: LibDBIcon's drag handler
	    computes the angle with math.atan2 every frame and writes it into the
	    button's db, which has to be the very table AceDB saves, and the raw
	    SavedVariables value is what the client writes at logout.
	]]
	lines[#lines + 1] = ""
	lines[#lines + 1] = string.format("math.atan2 present: %s", tostring(type(math.atan2) == "function"))
	lines[#lines + 1] = string.format("LibDBIcon-1.0 minor: %s", tostring(LibStub.minors["LibDBIcon-1.0"]))
	if button then
		lines[#lines + 1] = string.format("Button db present: %s", tostring(button.db ~= nil))
		lines[#lines + 1] = string.format(
			"Button db is ns.db.global.minimap: %s",
			tostring(button.db ~= nil and minimap ~= nil and button.db == minimap)
		)
		lines[#lines + 1] = string.format("Button db.minimapPos: %s", tostring(button.db and button.db.minimapPos))
		lines[#lines + 1] = string.format("Button minimapPos: %s", tostring(button.minimapPos))
	end
	local savedGlobal = type(MagicEraserDB) == "table" and MagicEraserDB.global
	local savedMinimap = type(savedGlobal) == "table" and savedGlobal.minimap
	lines[#lines + 1] = string.format(
		"MagicEraserDB.global.minimap.minimapPos: %s",
		tostring(type(savedMinimap) == "table" and savedMinimap.minimapPos or nil)
	)

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Other Add-ons
--------------------------------------------------------------------------------

function ns:BuildAddOnReport()
	local lines = { GetClientHeader(), "" }
	local count = C_AddOns.GetNumAddOns()
	for index = 1, count do
		local name, _, _, loadable = C_AddOns.GetAddOnInfo(index)
		local version = C_AddOns.GetAddOnMetadata(index, "Version") or "?"
		lines[#lines + 1] = string.format("%s v%s [%s]", name, version, loadable and "loadable" or "disabled")
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Saved Variables
--------------------------------------------------------------------------------

local function DumpTable(value, indent, depth, lines)
	if depth > 8 then
		lines[#lines + 1] = indent .. "<max depth>"
		return
	end
	local keys = {}
	for key in pairs(value) do
		keys[#keys + 1] = key
	end
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	for _, key in ipairs(keys) do
		local entry = value[key]
		if type(entry) == "table" then
			lines[#lines + 1] = indent .. tostring(key) .. " = {"
			DumpTable(entry, indent .. "    ", depth + 1, lines)
			lines[#lines + 1] = indent .. "}"
		else
			lines[#lines + 1] = indent .. tostring(key) .. " = " .. tostring(entry)
		end
	end
end

--[[
    Dumps the single AceDB-managed table (profiles, profileKeys, global) so a
    player can paste their exact configuration. Every player-managed item list is
    replaced with a length summary rather than printing each itemId: these lists
    are described by their size, never reproduced row by row, so a long one
    cannot bury the settings a bug report is actually about.

    Keyed by name because both lists exist in two scopes -- the profile's and its
    account-wide twin in global -- and the recursion meets each of them.
]]
local SUMMARIZED_LIST_KEYS = {
	ignoreList = true,
	eraseList = true,
}

local function SummarizeList(entry)
	local count = CountKeys(entry)
	return string.format("{ %d %s }", count, count == 1 and "entry" or "entries")
end

local function SummarizeForDump(value)
	if type(value) ~= "table" then
		return value
	end
	local copy = {}
	for key, entry in pairs(value) do
		if SUMMARIZED_LIST_KEYS[key] and type(entry) == "table" then
			copy[key] = SummarizeList(entry)
		else
			copy[key] = SummarizeForDump(entry)
		end
	end
	return copy
end

function ns:BuildSavedVariablesReport()
	local lines = { GetClientHeader(), "", "MagicEraserDB = {" }
	DumpTable(SummarizeForDump(MagicEraserDB or {}), "    ", 1, lines)
	lines[#lines + 1] = "}"
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Library Versions
--------------------------------------------------------------------------------

function ns:BuildLibraryReport()
	local lines = { GetClientHeader(), "" }
	local names = {}
	for name in LibStub:IterateLibraries() do
		names[#names + 1] = name
	end
	table.sort(names)
	for _, name in ipairs(names) do
		lines[#lines + 1] = string.format("%s (minor %s)", name, tostring(LibStub.minors[name]))
	end
	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Taint Log
--------------------------------------------------------------------------------

--[[
    The taintLog CVar controls UI taint logging to Logs\taint.log. Level 2 logs
    both blocked actions and accesses to tainted globals; 0 is off. This is the
    only state the diagnostics panel ever writes.
]]

function ns:GetTaintLogState()
	return tonumber(GetCVar("taintLog")) or 0
end

function ns:SetTaintLog(enabled)
	SetCVar("taintLog", enabled and 2 or 0)
end
