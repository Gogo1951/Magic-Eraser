local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

ns.AddonTitle = ns.L["ADDON_TITLE"]
ns.DefaultIcon = "Interface/Icons/inv_misc_bag_07_green"

--------------------------------------------------------------------------------
-- Links
--------------------------------------------------------------------------------

ns.Links = {
	CURSEFORGE = "https://www.curseforge.com/wow/addons/magic-eraser",
	GITHUB = "https://github.com/Gogo1951/Magic-Eraser",
	DISCORD = "https://discord.gg/eh8hKq992Q",
	WAGO = "https://addons.wago.io/addons/magic-eraser",
}

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

--[[
    AceConfig registry names, derived from the TOC addon name and never
    localized. The root General panel uses the bare addon name; feature panels
    suffix it. Referenced by the registration calls in Options/Options.lua and by
    NotifyChange in the panels.
]]
ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	IgnoreList = ADDON_NAME .. "_IgnoreList",
	Profiles = ADDON_NAME .. "_Profiles",
	Diagnostics = ADDON_NAME .. "_Diagnostics",
}

--------------------------------------------------------------------------------
-- Ignore List Scopes
--------------------------------------------------------------------------------

--[[
    The Ignore List panel names one scope per list on the account. Every scope
    but one is an AceDB profile name ("Name - Realm", never localized), so the
    account-wide list needs a key that no profile can collide with -- hence the
    asterisks, which the profile picker's name box would never produce. Read by
    ns:GetIgnoreListForScope in Features/Ignore-List.lua.
]]
ns.IGNORE_SCOPE_GLOBAL = "**global**"

--------------------------------------------------------------------------------
-- Color Palette
--------------------------------------------------------------------------------

--[[
    Raw 6-character hex only -- no |cff prefix (that is a display escape, added
    in Features/Utilities.lua, where the derived COLORS table and ns.GetColor
    accessor are built). Keys match the COLORS keys one-to-one.
]]
ns.PALETTE = {
	TITLE = "FFD100", -- Gold: Titles, Headers, Section Names
	INFO = "00BBFF", -- Blue: Interactions, Toggles, Links, Keybinds
	BODY = "FFFFFF", -- White: Descriptions, Options Body Text
	HELP = "CCCCCC", -- Silver: Pro Tips, Helper Text
	TEXT = "FFFFFF", -- White: Messages, Values, Spell Names
	ON = "33CC33", -- Green: Enabled / On
	OFF = "CC3333", -- Red: Disabled / Off
	SEPARATOR = "AAAAAA", -- Gray: Separators, Dividers
	MUTED = "808080", -- Dark Gray: Meta-data, Version Numbers
}

ns.CurrencyColors = {
	GOLD = "FFD700",
	SILVER = "C7C7CF",
	COPPER = "EDA55F",
}

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
	quest = 1,
	gray = 2,
	consumable = 3,
	equipment = 3,
}
