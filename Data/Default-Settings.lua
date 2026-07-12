local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    AceDB-3.0 defaults. AceDB applies these via metatables (no hand-rolled merge,
    and explicit false survives).

    Only the ignore list is profile-scoped, and it is stored per character inside
    the profile: profile.ignoreLists is keyed by ns.db.keys.char (see
    ns:GetIgnoreList), so every toon keeps its own list while a single shared
    "Default" profile holds them all. Switching profiles swaps the whole set of
    per-toon lists -- e.g. a "Farming" profile carries its own toon lists.

    Everything else lives under global: account-wide, identical on every toon,
    and untouched by profile switches. minimap is global too, so switching or
    resetting a profile never moves the button.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		ignoreLists = {},
	},
	global = {
		showWelcome = true,
		tooltipWarningEnabled = true,
		autoVendEnabled = true,
		autoVendMessagesEnabled = true,
		autoVendSummaryEnabled = true,
		bagsFullNudgeEnabled = false,
		bagsFullThreshold = 4,
		safetyEnabled = false,
		safetyQuest = true,
		safetyConsumable = false,
		safetyWhite = false,
		safetyGray = false,
		minimap = {},
	},
}
