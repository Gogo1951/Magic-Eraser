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
    shared-Default flag), so the profile-scoped entries are the ones that are
    naturally per-character: the two item lists, flat profile.ignoreList and
    profile.eraseList (see ns:GetIgnoreList and ns:GetEraseList), plus the seed
    marker below.

    eraseListSeeded records that ns:SeedEraseList has run for this character. It
    has to be stored rather than inferred, because an empty erase list cannot
    tell "the player cleared it out" from "never seeded" and every login would
    put the rows back. It is profile-scoped so Reset Profile clears the marker
    and the list together and the character seeds again.

    Everything else lives under global: account-wide, identical on every toon,
    and untouched by profile switches. That includes each list's account-wide
    twin, global.ignoreList and global.eraseList, which apply on every character
    at once; both pairs are additive, and ns:IsIgnored and ns:IsOnEraseList
    answer for both scopes. minimap is global too, so switching or resetting a
    profile never moves the button.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		ignoreList = {},
		eraseList = {},
		eraseListSeeded = false,
	},
	global = {
		ignoreList = {},
		eraseList = {},
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
