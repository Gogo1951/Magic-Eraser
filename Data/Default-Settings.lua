local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    AceDB-3.0 defaults. Every user setting lives under profile; AceDB applies
    these via metatables (no hand-rolled merge, and explicit false survives).
    The global subtable holds only the minimap button position, which is
    profile-independent so switching or resetting a profile never moves it.
]]
ns.DATABASE_DEFAULTS = {
	profile = {
		showWelcome = true,
		autoVendEnabled = false,
		autoVendMessagesEnabled = true,
		ignoreList = {},
	},
	global = {
		minimap = {},
	},
}
