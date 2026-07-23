local _, ns = ...
local L = ns.L
local D = ns.DiagnosticsStrings

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Registration only -- panel content lives in the per-panel builder files.
    Called from ns:OnPlayerLogin once ns.db exists, because the Ignore List and
    Profiles builders need the AceDB database. Child order is General (root) ->
    Ignore List -> Profiles -> the Diagnostic Tools panel last; each panel's
    third AddToBlizOptions argument is the parent's display name (ns.AddonTitle)
    so all four nest under Magic Eraser. The Profiles display name comes already
    localized from AceDBOptions-3.0.
]]
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function ns:RegisterOptionsPanels()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	-- AddToBlizOptions returns (frame, categoryID). The ID is what Settings.OpenToCategory
	-- expects; relying on the display name matching the ID is fragile -- the library only
	-- aliases the ID to the name on clients without C_SettingsUtil.OpenSettingsPanel (Era),
	-- so on TBC Anniversary a name-based lookup returns nil. Capture the real references here.
	ns.GeneralPanel, ns.GeneralCategoryID = AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, ns.AddonTitle)

	-- The builder function, not a built table: the Ignore List panel's rows are
	-- the ignore lists themselves, so AceConfig re-invokes it on every open and
	-- every NotifyChange and the panel never renders a stale list.
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.IgnoreList, ns.BuildIgnoreListOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.IgnoreList, L["IGNORE_LIST"], ns.AddonTitle)

	local profilesOptions = ns.BuildProfilesOptions()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Profiles, profilesOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Profiles, profilesOptions.name, ns.AddonTitle)

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, D.TAB, ns.AddonTitle)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

function ns:OpenOptionsPanel()
	if Settings and Settings.OpenToCategory and ns.GeneralCategoryID then
		Settings.OpenToCategory(ns.GeneralCategoryID)
		return
	end
	if InterfaceOptionsFrame_OpenToCategory and ns.GeneralPanel then
		InterfaceOptionsFrame_OpenToCategory(ns.GeneralPanel)
		-- Called twice for Classic compatibility.
		InterfaceOptionsFrame_OpenToCategory(ns.GeneralPanel)
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

SLASH_MAGICERASER1 = "/eraser"
SlashCmdList.MAGICERASER = function()
	ns:OpenOptionsPanel()
end
