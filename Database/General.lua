local addonName, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

ns.AddonTitle = "Magic Eraser"
ns.DefaultIcon = "Interface/Icons/inv_misc_bag_07_green"

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
    local version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version")
        or GetAddOnMetadata(addonName, "Version")
    if not version or version:find("@") then
        return "Dev"
    end
    return version
end

ns.Version = GetVersion()

--------------------------------------------------------------------------------
-- Links
--------------------------------------------------------------------------------

ns.Links = {
    CURSEFORGE = "https://www.curseforge.com/wow/addons/magic-eraser",
    GITHUB     = "https://github.com/Gogo1951/Magic-Eraser",
    DISCORD    = "https://discord.gg/eh8hKq992Q",
}

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

local C_TITLE    = "FFD100" -- Gold: Titles, Headers, Section Names
local C_INFO     = "00BBFF" -- Blue: Interactions, Toggles, Links, Keybinds
local C_BODY     = "CCCCCC" -- Silver: Descriptions, Help Text
local C_TEXT     = "FFFFFF" -- White: Messages, Values, Spell Names
local C_SUCCESS  = "33CC33" -- Green: Enabled / On
local C_DISABLED = "CC3333" -- Red: Disabled / Off
local C_SEP      = "AAAAAA" -- Gray: Separators, Dividers
local C_MUTED    = "808080" -- Dark Gray: Meta-data, Version Numbers

local COLOR_PREFIX = "|cff"

ns.Colors = {
    TITLE    = COLOR_PREFIX .. C_TITLE,
    INFO     = COLOR_PREFIX .. C_INFO,
    DESC     = COLOR_PREFIX .. C_BODY,
    TEXT     = COLOR_PREFIX .. C_TEXT,
    SUCCESS  = COLOR_PREFIX .. C_SUCCESS,
    DISABLED = COLOR_PREFIX .. C_DISABLED,
    SEP      = COLOR_PREFIX .. C_SEP,
    MUTED    = COLOR_PREFIX .. C_MUTED,
}

function ns:GetColor(key)
    return self.Colors[key] or (COLOR_PREFIX .. C_TEXT)
end

ns.CurrencyColors = {
    GOLD   = "FFD700",
    SILVER = "C7C7CF",
    COPPER = "EDA55F",
}

ns.BrandPrefix = string.format(
    "%s%s|r %s//|r ",
    ns.Colors.INFO,
    ns.AddonTitle,
    ns.Colors.SEP
)

--------------------------------------------------------------------------------
-- Class Reagent Exclusions
--------------------------------------------------------------------------------

ns.ClassReagentExclusions = {
    SHAMAN = {
        [17057] = true, -- Shiny Fish Scales
        [17058] = true, -- Fish Oil
    },
}

--------------------------------------------------------------------------------
-- Deletion Priority
--------------------------------------------------------------------------------

ns.DeletePriority = {
    quest      = 1,
    gray       = 2,
    consumable = 3,
    equipment  = 3,
}