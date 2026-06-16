local addonName, ns = ...

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
    TOOLS_ETRACE = "Live event tracing: use %s."
}

--------------------------------------------------------------------------------
-- Enable Gate
--------------------------------------------------------------------------------

function ns:SetDiagnosticsEnabled(value)
    ns.diagnostics.enabled = value and true or false
    if not ns.diagnostics.enabled then
        ns:StopEventLog()
    end
end

--------------------------------------------------------------------------------
-- Report Header
--------------------------------------------------------------------------------

local function GetClientHeader()
    local version, build, _, tocVersion = GetBuildInfo()
    return string.format(
        "%s %s // Client %s // Build %s // TOC %s // Locale %s // Project %s",
        ns.AddonTitle, ns.Version, version, build, tocVersion,
        GetLocale(), tostring(WOW_PROJECT_ID)
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
    Firehose events flood the log in milliseconds and bury the signal, so the
    logger skips them. Magic Eraser never registers any of these (it uses
    BAG_UPDATE_DELAYED, not the raw BAG_UPDATE), so the set is defensive -- it
    keeps the log clean if a future event is added.
]]
ns.DIAGNOSTIC_EVENT_EXCLUDE = {
    COMBAT_LOG_EVENT_UNFILTERED = true,
    UNIT_AURA = true,
    BAG_UPDATE = true,
    UPDATE_MOUSEOVER_UNIT = true
}

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
    if ns.DIAGNOSTIC_EVENT_EXCLUDE[event] then return end
    local log = ns.diagnostics.log
    if not log then return end
    local parts = {}
    for index = 1, select("#", ...) do
        if index > EVENT_LOG_MAX_ARGS then break end
        local raw = string.sub(tostring((select(index, ...))), 1, EVENT_LOG_MAX_ARG_LENGTH)
        parts[index] = (raw:gsub("|", "||"))
    end
    log[#log + 1] = string.format("%.3f %s(%s)", GetTime(), event, table.concat(parts, ", "))
    if #log > EVENT_LOG_SIZE then
        table.remove(log, 1)
    end
end

function ns:BuildEventLogReport()
    local lines = {GetClientHeader(), ""}
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
    local lines = {GetClientHeader(), ""}
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
    calls. Kept one-to-one with the APIs Magic Eraser calls or guards in Core.lua,
    Auto-Vend.lua, Minimap-Button.lua, and Data/Data.lua. The C_AddOns /
    GetAddOnMetadata pair is listed modern + legacy so the report shows what each
    client provides -- the legacy global ships on Era but is gone on TBC.
]]
ns.DIAGNOSTIC_API_CHECKS = {
    -- { label, testFunction }
    {"C_AddOns.GetAddOnMetadata", function() return type(C_AddOns) == "table" and type(C_AddOns.GetAddOnMetadata) == "function" end},
    {"GetAddOnMetadata (legacy)", function() return type(GetAddOnMetadata) == "function" end},
    {"C_Container.GetContainerNumSlots", function() return type(C_Container) == "table" and type(C_Container.GetContainerNumSlots) == "function" end},
    {"C_Container.GetContainerItemInfo", function() return type(C_Container) == "table" and type(C_Container.GetContainerItemInfo) == "function" end},
    {"C_Container.PickupContainerItem", function() return type(C_Container) == "table" and type(C_Container.PickupContainerItem) == "function" end},
    {"C_Container.UseContainerItem", function() return type(C_Container) == "table" and type(C_Container.UseContainerItem) == "function" end},
    {"C_QuestLog.IsQuestFlaggedCompleted", function() return type(C_QuestLog) == "table" and type(C_QuestLog.IsQuestFlaggedCompleted) == "function" end},
    {"C_Item.RequestLoadItemDataByID", function() return type(C_Item) == "table" and type(C_Item.RequestLoadItemDataByID) == "function" end},
    {"GetItemInfo", function() return type(GetItemInfo) == "function" end},
    {"GetItemQualityColor", function() return type(GetItemQualityColor) == "function" end},
    {"GetCursorInfo", function() return type(GetCursorInfo) == "function" end},
    {"CursorHasItem", function() return type(CursorHasItem) == "function" end},
    {"ClearCursor", function() return type(ClearCursor) == "function" end},
    {"DeleteCursorItem", function() return type(DeleteCursorItem) == "function" end},
    {"IsShiftKeyDown", function() return type(IsShiftKeyDown) == "function" end},
    {"InCombatLockdown", function() return type(InCombatLockdown) == "function" end},
    {"UnitLevel", function() return type(UnitLevel) == "function" end},
    {"UnitClass", function() return type(UnitClass) == "function" end},
    {"PlaySound", function() return type(PlaySound) == "function" end},
    {"C_Timer.After", function() return type(C_Timer) == "table" and type(C_Timer.After) == "function" end},
    {"C_EventUtils.IsEventValid", function() return type(C_EventUtils) == "table" and type(C_EventUtils.IsEventValid) == "function" end},
    {"GetCVar", function() return type(GetCVar) == "function" end},
    {"SetCVar", function() return type(SetCVar) == "function" end},
    {"GetBuildInfo", function() return type(GetBuildInfo) == "function" end},
    {"GetLocale", function() return type(GetLocale) == "function" end}
}

function ns:RunApiChecks()
    local lines = {GetClientHeader(), ""}
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
    local lines = {GetClientHeader(), ""}

    local _, class = UnitClass("player")
    lines[#lines + 1] = string.format("Player: %s level %d", tostring(class), UnitLevel("player") or 0)
    lines[#lines + 1] = string.format("Auto-Vend: %s", (MagicEraserCharDB and MagicEraserCharDB.autoVendEnabled) and "enabled" or "disabled")

    local ignoreCount = CountKeys(MagicEraserCharDB and MagicEraserCharDB.ignoreList)
    lines[#lines + 1] = string.format("Ignore list: %d %s", ignoreCount, ignoreCount == 1 and "entry" or "entries")
    lines[#lines + 1] = string.format(
        "Databases: quest=%d, consumables=%d, equipment=%d",
        CountKeys(ns.AllowedDeleteQuestItems), CountKeys(ns.AllowedDeleteConsumables), CountKeys(ns.AllowedDeleteEquipment)
    )
    local reagents = ns.ClassReagentExclusions and ns.ClassReagentExclusions[class]
    lines[#lines + 1] = string.format("Class reagent exclusions (%s): %d", tostring(class), CountKeys(reagents))

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
-- Display Context
--------------------------------------------------------------------------------

--[[
    Answers "the minimap button is gone / off-screen" reports: screen size, UI
    scale, and the button's saved placement. Read-only.
]]
function ns:BuildDisplayContextReport()
    local lines = {GetClientHeader(), ""}

    local width, height = GetPhysicalScreenSize()
    lines[#lines + 1] = string.format("Physical screen size: %s x %s", tostring(width), tostring(height))
    lines[#lines + 1] = string.format("UIParent scale: %s", tostring(UIParent and UIParent:GetScale()))
    lines[#lines + 1] = string.format("uiScale CVar: %s", tostring(GetCVar("uiScale")))

    lines[#lines + 1] = ""
    local LibDBIcon = LibStub("LibDBIcon-1.0")
    local button = LibDBIcon and LibDBIcon.GetMinimapButton and LibDBIcon:GetMinimapButton(addonName)
    lines[#lines + 1] = string.format("Minimap button created: %s", button and "yes" or "no")

    local minimap = MagicEraserDB and MagicEraserDB.minimap
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
    local lines = {GetClientHeader(), ""}
    local getInfo = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo
    local getMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local count = (C_AddOns and C_AddOns.GetNumAddOns and C_AddOns.GetNumAddOns()) or GetNumAddOns()
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
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
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
    Dumps the account table in full (small) and summarizes the per-character
    ignore list by length rather than printing every itemId (see DATA -- large
    lists are described, not reproduced).
]]
function ns:BuildSavedVariablesReport()
    local lines = {GetClientHeader(), "", "MagicEraserDB = {"}
    DumpTable(MagicEraserDB or {}, "    ", 1, lines)
    lines[#lines + 1] = "}"
    lines[#lines + 1] = ""

    local char = MagicEraserCharDB or {}
    local ignoreCount = CountKeys(char.ignoreList)
    lines[#lines + 1] = "MagicEraserCharDB = {"
    lines[#lines + 1] = "    autoVendEnabled = " .. tostring(char.autoVendEnabled)
    lines[#lines + 1] = string.format("    ignoreList = { %d %s }", ignoreCount, ignoreCount == 1 and "entry" or "entries")
    lines[#lines + 1] = "}"
    return table.concat(lines, "\n")
end

--------------------------------------------------------------------------------
-- Library Versions
--------------------------------------------------------------------------------

function ns:BuildLibraryReport()
    local lines = {GetClientHeader(), ""}
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
