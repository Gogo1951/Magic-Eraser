local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    AceDB-3.0 defaults. AceDB copies these into the saved table itself when a
    scope is first touched (no hand-rolled merge, and explicit false survives).
    Only wildcard defaults resolve lazily through metatables, and there are none
    here.

    Three scopes, each for one kind of data:

      - profile holds every setting. Core.lua opens ns.db with the shared-Default
        flag, so every character on the account lands on the one Default
        profile: a setting changed once applies everywhere. A player who wants a
        one-off, such as a bank alt with Auto-Vend off, makes a new profile by
        hand in the Profiles panel.
      - char holds what belongs to one character whatever profile it is on: its
        own Protect List (ignoreList) and Erase List (eraseList), and
        eraseListSeeded, the marker that ns:SeedEraseList has run for it. The
        marker has to be stored rather than inferred, because an empty erase
        list cannot tell "the player cleared it out" from "never seeded" and
        every login would put the rows back. classToken records the
        character's class at each login, so the list panels can color its name
        while another character is being played.
      - global holds the All Characters twins of both lists, which apply on
        every character at once, and minimap, so switching or resetting a
        profile never moves the button.

    Both pairs of lists are additive: ns:IsIgnored and ns:IsOnEraseList answer
    for both scopes. Features/Migrations.lua carries saved data from the old
    per-character-profile shape into this one.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
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
		questAlertsEnabled = true,
		junkKinds = {
			quest = true,
			questIneligible = true,
			consumable = true,
			ammo = true,
			equipment = true,
			gray = true,
		},
		eraseConfirmEnabled = false,
		manualDeleteAutoFillEnabled = true,
		manualDeleteNoValueOnly = true,
	},
	char = {
		ignoreList = {},
		eraseList = {},
		eraseListSeeded = false,
		classToken = false,
	},
	global = {
		ignoreList = {},
		eraseList = {},
		minimap = {},
	},
}
