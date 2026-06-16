local addonName, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

--[[
    The raw hex palette lives in Data/Data.lua (ns.PALETTE); the derived escape
    strings and the accessor live here, because Data files hold no logic. COLORS
    is file-local -- consumers never read it directly; they call ns.GetColor(key)
    (aliased once per file as `local GetColor = ns.GetColor`). Color constants
    carry no |cff prefix -- it is prepended once here, and |r is appended at each
    call site.
]]
local COLOR_PREFIX = "|cff"

local COLORS = {
    TITLE     = COLOR_PREFIX .. ns.PALETTE.TITLE,
    INFO      = COLOR_PREFIX .. ns.PALETTE.INFO,
    BODY      = COLOR_PREFIX .. ns.PALETTE.BODY,
    TEXT      = COLOR_PREFIX .. ns.PALETTE.TEXT,
    ON        = COLOR_PREFIX .. ns.PALETTE.ON,
    OFF       = COLOR_PREFIX .. ns.PALETTE.OFF,
    SEPARATOR = COLOR_PREFIX .. ns.PALETTE.SEPARATOR,
    MUTED     = COLOR_PREFIX .. ns.PALETTE.MUTED,
}

function ns.GetColor(key)
    return COLORS[key] or COLORS.TEXT
end

ns.BrandPrefix = string.format(
    "%s%s|r %s//|r ",
    COLORS.INFO,
    ns.AddonTitle,
    COLORS.SEPARATOR
)

--------------------------------------------------------------------------------
-- Formatting
--------------------------------------------------------------------------------

local format, insert, floor = string.format, table.insert, math.floor

function ns:FormatCommaNumber(number)
    return tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function ns:FormatCurrency(rawValue)
    local value = math.max(rawValue or 0, 0)

    local gold = floor(value / 10000)
    local silver = floor((value % 10000) / 100)
    local copper = value % 100
    local parts = {}

    local goldColor = ns.CurrencyColors.GOLD
    local silverColor = ns.CurrencyColors.SILVER
    local copperColor = ns.CurrencyColors.COPPER

    if gold > 0 then
        insert(parts, format(COLORS.TEXT .. "%s|r|cff%sg|r", ns:FormatCommaNumber(gold), goldColor))
    end

    if gold > 0 then
        insert(parts, format(COLORS.TEXT .. "%02d|r|cff%ss|r", silver, silverColor))
    elseif silver > 0 then
        insert(parts, format(COLORS.TEXT .. "%d|r|cff%ss|r", silver, silverColor))
    end

    if gold > 0 or silver > 0 then
        insert(parts, format(COLORS.TEXT .. "%02d|r|cff%sc|r", copper, copperColor))
    else
        insert(parts, format(COLORS.TEXT .. "%d|r|cff%sc|r", copper, copperColor))
    end

    return table.concat(parts, " ")
end

--------------------------------------------------------------------------------
-- Game State
--------------------------------------------------------------------------------

function ns:IsQuestCompleted(questId)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questId)
    end
    return false
end
