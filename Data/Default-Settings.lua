local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    AceDB-3.0 defaults. AceDB copies these into the saved table itself when a
    scope is first touched (no hand-rolled merge, and explicit false survives).
    Only wildcard defaults resolve lazily through metatables, and there are none
    here.

    Each character gets its own AceDB profile (Core.lua creates ns.db without the
    shared-Default flag), so the one profile-scoped setting -- the per-character
    ignore list -- is a flat profile.ignoreList that is naturally per-character
    (see ns:GetIgnoreList).

    Everything else lives under global: account-wide, identical on every toon,
    and untouched by profile switches. That includes the second ignore list,
    global.ignoreList, which protects an item on every character at once; the two
    lists are additive and ns:IsIgnored answers for both. minimap is global too,
    so switching or resetting a profile never moves the button.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		ignoreList = {},
	},
	global = {
		ignoreList = {},
		showWelcome = true,
		tooltipWarningEnabled = true,
		autoVendEnabled = true,
		autoVendMessagesEnabled = true,
		autoVendSummaryEnabled = true,
		valueCapEnabled = false,
		valueCapGold = 5,
		bagsFullNudgeEnabled = false,
		bagsFullThreshold = 4,
		bankRetrievalEnabled = true,
		safetyEnabled = false,
		safetyQuest = true,
		safetyConsumable = false,
		safetyWhite = false,
		safetyGray = false,
		minimap = {},
	},
}
