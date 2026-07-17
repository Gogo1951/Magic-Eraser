local _, ns = ...
local D = ns.DiagnosticsStrings

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Registration only -- panel content lives in the per-panel builder files.
    Called from ns:OnPlayerLogin once ns.db exists, because the Profiles builder
    needs the AceDB database. Child order is General (root) -> Profiles -> the
    Diagnostic Tools panel last; each panel's third AddToBlizOptions argument is
    the parent's display name (ns.AddonTitle) so all three nest under Magic
    Eraser. The Profiles display name comes already localized from
    AceDBOptions-3.0.
]]
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

function ns:RegisterOptionsPanels()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, ns.AddonTitle)

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
	if Settings and Settings.GetCategory then
		local category = Settings.GetCategory(ns.AddonTitle)
		if category then
			Settings.OpenToCategory(category.ID)
			return
		end
	end
	if InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(ns.AddonTitle)
		InterfaceOptionsFrame_OpenToCategory(ns.AddonTitle)
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

SLASH_MAGICERASER1 = "/eraser"
SlashCmdList.MAGICERASER = function()
	ns:OpenOptionsPanel()
end
