local _, Addon = ...

-------------------------------------------------------------------------
-- Identity
-------------------------------------------------------------------------
Addon.AddonTitle  = "Magic Eraser"
Addon.DefaultIcon = "Interface\\Icons\\inv_misc_bag_07_green"

-------------------------------------------------------------------------
-- Colors
-------------------------------------------------------------------------
local colorPrefix = "|cff"

Addon.Colors = {
    TITLE       = colorPrefix .. "FFD100", -- Gold
    INFO        = colorPrefix .. "00BBFF", -- Blue
    DESCRIPTION = colorPrefix .. "CCCCCC", -- Silver
    TEXT        = colorPrefix .. "FFFFFF", -- White
    SUCCESS     = colorPrefix .. "33CC33", -- Green
    DISABLED    = colorPrefix .. "CC3333", -- Red
    SEPARATOR   = colorPrefix .. "AAAAAA", -- Gray
    MUTED       = colorPrefix .. "808080", -- Dark Gray
}

Addon.CurrencyColors = {
    GOLD   = "FFD700",
    SILVER = "C7C7CF",
    COPPER = "EDA55F",
}

Addon.BrandPrefix = string.format(
    "%s%s|r %s//|r ",
    Addon.Colors.INFO,
    Addon.AddonTitle,
    Addon.Colors.SEPARATOR
)

-------------------------------------------------------------------------
-- Class Reagent Exclusions
-------------------------------------------------------------------------
Addon.ClassReagentExclusions = {
    SHAMAN = { 
        [17057] = true, -- Shiny Fish Scales
        [17058] = true, -- Fish Oil
    },
}

-------------------------------------------------------------------------
-- Deletion Priority
-------------------------------------------------------------------------
Addon.DeletePriority = {
    quest      = 1,
    gray       = 2,
    consumable = 3,
    equipment  = 3,
}