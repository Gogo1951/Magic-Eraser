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
    add-on's own display name (ns.AddonTitle), which is the add-on's identity,
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
	VALIDATE_HINT = "Checks every item id a data file ships against this client and exports what the client knows about each one as tab-separated text, ready to paste into a spreadsheet. STATUS reads OK, NOT ON CLIENT for an id this client does not recognize, or NOT LOADED when the client knows the id but never answered with its data. A large file takes a few seconds; the box shows progress until the export replaces it.",
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
	return string.format(
		"%s %s // Client %s // Build %s // TOC %s // Locale %s // Project %s",
		ns.AddonTitle,
		ns.Version,
		version,
		build,
		tocVersion,
		GetLocale(),
		tostring(WOW_PROJECT_ID)
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

    Every modern/legacy pair the add-on guards on is listed as both halves, and a
    FAIL on one half is the report working rather than a defect: the pair is what
    tells a bug report which branch that client actually took. Reading the
    tooltip pair as PASS legacy plus FAIL modern is how you know the SetBagItem
    hook is the live path there, and the option-opener pair answers the same
    question for ns:OpenOptionsPanel's routing. Never drop the half that fails on
    the client in front of you -- that is the half carrying the answer.
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
		"GetAddOnMetadata (legacy)",
		function()
			return type(GetAddOnMetadata) == "function"
		end,
	},
	{
		"C_AddOns.GetAddOnInfo",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnInfo) == "function"
		end,
	},
	{
		"GetAddOnInfo (legacy)",
		function()
			return type(GetAddOnInfo) == "function"
		end,
	},
	{
		"C_AddOns.GetNumAddOns",
		function()
			return type(C_AddOns) == "table" and type(C_AddOns.GetNumAddOns) == "function"
		end,
	},
	{
		"GetNumAddOns (legacy)",
		function()
			return type(GetNumAddOns) == "function"
		end,
	},
	{
		"Settings.OpenToCategory",
		function()
			return type(Settings) == "table" and type(Settings.OpenToCategory) == "function"
		end,
	},
	{
		"InterfaceOptionsFrame_OpenToCategory (legacy)",
		function()
			return type(InterfaceOptionsFrame_OpenToCategory) == "function"
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
		"GetItemInfo",
		function()
			return type(GetItemInfo) == "function"
		end,
	},
	{
		"GetItemInfoInstant",
		function()
			return type(GetItemInfoInstant) == "function"
		end,
	},
	{
		"GetItemQualityColor",
		function()
			return type(GetItemQualityColor) == "function"
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
		CountKeys(ns.AllowedDeleteQuestItems),
		CountKeys(ns.AllowedDeleteQuestStartingItems),
		CountKeys(ns.AllowedDeleteConsumables),
		CountKeys(ns.AllowedDeleteEquipment)
	)
	-- Seed data only. Nothing filters on this at scan time; see ns.ClassReagents.
	local reagents = ns.ClassReagents and ns.ClassReagents[class]
	lines[#lines + 1] = string.format("Class reagents (%s): %d", tostring(class), CountKeys(reagents))

	lines[#lines + 1] = ""
	local item = ns:FindItemToDelete()
	if item then
		lines[#lines + 1] = "Current erase candidate:"
		lines[#lines + 1] = "  link     = " .. (tostring(item.link):gsub("|", "||"))
		lines[#lines + 1] = string.format("  itemId   = %s", tostring(item.itemId))
		lines[#lines + 1] = string.format("  reason   = %s", tostring(item.deleteReason))
		lines[#lines + 1] = string.format("  value    = %d copper (x%d)", item.value or 0, item.count or 1)
		lines[#lines + 1] = string.format("  bag/slot = %s/%s", tostring(item.bag), tostring(item.slot))
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
    Options/Options-Diagnostics.lua. Each source names the static table on ns,
    its kind, and how to reach the id in a row. Every table Magic Eraser ships
    is keyed by item id, so the row's key is the id. Adding a data file adds an
    entry here, and the panel and the validator pick it up with no second list.
]]
local function KeyIsId(key)
	return key
end

ns.DIAGNOSTIC_DATA_SOURCES = {
	-- { file, sources = { { table, kind, rowId } } }
	{
		file = "Quest-Items.lua",
		sources = { { table = "AllowedDeleteQuestItems", kind = "item", rowId = KeyIsId } },
	},
	{
		file = "Quest-Starting-Items.lua",
		sources = { { table = "AllowedDeleteQuestStartingItems", kind = "item", rowId = KeyIsId } },
	},
	{
		file = "Consumables.lua",
		sources = { { table = "AllowedDeleteConsumables", kind = "item", rowId = KeyIsId } },
	},
	{
		file = "Equipment.lua",
		sources = { { table = "AllowedDeleteEquipment", kind = "item", rowId = KeyIsId } },
	},
}

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--[[
    Item data loads asynchronously, so a run works in batches across frames
    rather than stalling the client on a thousand lookups at once, and an id the
    server never answers for is flagged after a bounded number of polls instead
    of holding the run open forever.
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

local STATUS_OK = "OK"
local STATUS_NOT_ON_CLIENT = "NOT ON CLIENT"
local STATUS_NOT_LOADED = "NOT LOADED"

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

local function AppendReturns(cells, count, ...)
	for index = 1, count do
		cells[#cells + 1] = CellText((select(index, ...)))
	end
end

local function BuildItemRow(status, sourceName, itemId)
	local cells = { status, sourceName, tostring(itemId) }
	AppendReturns(cells, ITEM_INFO_RETURNS, GetItemInfo(itemId))
	if type(GetItemInfoInstant) == "function" then
		AppendReturns(cells, ITEM_INFO_INSTANT_RETURNS, GetItemInfoInstant(itemId))
	else
		for _ = 1, ITEM_INFO_INSTANT_RETURNS do
			cells[#cells + 1] = ""
		end
	end
	return table.concat(cells, "\t")
end

--[[
    Whether this client's item database knows the id at all, which is a
    different question from whether the item's data is cached. Modern clients
    answer it directly; older ones answer through GetItemInfoInstant, which
    reads the local database with no server round-trip. Nil means the client
    cannot say, and the run falls back to the load budget alone.
]]
local function ItemExistsOnClient(itemId)
	if C_Item and type(C_Item.DoesItemExistByID) == "function" then
		return C_Item.DoesItemExistByID(itemId) and true or false
	end
	if type(GetItemInfoInstant) == "function" then
		return GetItemInfoInstant(itemId) ~= nil
	end
	return nil
end

local function CollectIds(entry)
	local ids = {}
	for _, source in ipairs(entry.sources) do
		local rows = ns[source.table]
		if type(rows) == "table" then
			for key, row in pairs(rows) do
				local id = source.rowId(key, row)
				if type(id) == "number" then
					ids[#ids + 1] = { id = id, source = source.table }
				end
			end
		end
	end
	table.sort(ids, function(a, b)
		if a.id == b.id then
			return a.source < b.source
		end
		return a.id < b.id
	end)
	return ids
end

local function ResolveRow(run, index, status)
	local entry = run.ids[index]
	run.rows[index] = BuildItemRow(status, entry.source, entry.id)
	run.resolved = run.resolved + 1
	run.counts[status] = run.counts[status] + 1
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

--[[
    The report is the standard client header plus a one-line tally, a blank
    line, then one TSV block: a column header naming every field, then one row
    per id in id order. Flagged rows keep their id and source table so the bad
    entry is copyable straight out of the sheet.
]]
local function FinishValidation(fileIndex, run)
	local lines = {
		GetClientHeader(),
		string.format(
			"%s // %s ids // %s %s // %s %s // %s %s",
			run.file,
			ns:FormatCommaNumber(#run.ids),
			ns:FormatCommaNumber(run.counts[STATUS_OK]),
			STATUS_OK,
			ns:FormatCommaNumber(run.counts[STATUS_NOT_ON_CLIENT]),
			STATUS_NOT_ON_CLIENT,
			ns:FormatCommaNumber(run.counts[STATUS_NOT_LOADED]),
			STATUS_NOT_LOADED
		),
		"",
		table.concat(ITEM_COLUMNS, "\t"),
	}
	for index = 1, #run.ids do
		lines[#lines + 1] = run.rows[index]
	end

	run.finished = true
	run.ids = {}
	run.rows = {}
	run.pending = {}
	PublishValidation(fileIndex, table.concat(lines, "\n"))
end

local PollValidation

--[[
    The first sweep. An id the client does not know is flagged on the spot, a
    cached id is exported on the spot, and everything else is requested from
    the server and left for the polls below.
]]
local function SweepValidation(fileIndex, run)
	local last = math.min(run.cursor + VALIDATE_BATCH_SIZE, #run.ids)
	for index = run.cursor + 1, last do
		local itemId = run.ids[index].id
		if ItemExistsOnClient(itemId) == false then
			ResolveRow(run, index, STATUS_NOT_ON_CLIENT)
		elseif GetItemInfo(itemId) then
			ResolveRow(run, index, STATUS_OK)
		else
			if C_Item and C_Item.RequestLoadItemDataByID then
				C_Item.RequestLoadItemDataByID(itemId)
			end
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

function PollValidation(fileIndex, run)
	run.retries = run.retries + 1
	local stillPending = {}
	for _, index in ipairs(run.pending) do
		if GetItemInfo(run.ids[index].id) then
			ResolveRow(run, index, STATUS_OK)
		elseif run.retries >= VALIDATE_MAX_RETRIES then
			ResolveRow(run, index, STATUS_NOT_LOADED)
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
	run.ids = CollectIds(entry)
	run.rows = {}
	run.pending = {}
	run.counts = { [STATUS_OK] = 0, [STATUS_NOT_ON_CLIENT] = 0, [STATUS_NOT_LOADED] = 0 }
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
			run.ids = {}
			run.rows = {}
			run.pending = {}
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
	local button = LibDBIcon and LibDBIcon.GetMinimapButton and LibDBIcon:GetMinimapButton(ADDON_NAME)
	lines[#lines + 1] = string.format("Minimap button created: %s", button and "yes" or "no")

	local minimap = ns.db and ns.db.global.minimap
	if type(minimap) == "table" then
		lines[#lines + 1] = string.format("Minimap button hidden: %s", tostring(minimap.hide or false))
		lines[#lines + 1] = string.format("Minimap saved angle: %s", tostring(minimap.minimapPos))
	else
		lines[#lines + 1] = "Minimap saved position: (none yet)"
	end

	return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Other Add-ons
--------------------------------------------------------------------------------

function ns:BuildAddOnReport()
	local lines = { GetClientHeader(), "" }
	local getInfo = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo
	local getMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
	local getCount = (C_AddOns and C_AddOns.GetNumAddOns) or GetNumAddOns
	local count = getCount()
	for index = 1, count do
		local name, _, _, loadable = getInfo(index)
		local version = getMeta(index, "Version") or "?"
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
