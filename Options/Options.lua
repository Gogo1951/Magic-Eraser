local addonName, ns = ...
local D = ns.DiagnosticsStrings

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Registration only -- panel content lives in the per-panel builder files.
    Loads last so every builder is defined. The Diagnostic Tools panel is
    registered last so it sits at the bottom of the settings tree; its third
    AddToBlizOptions argument is the parent panel's display name and must match
    the General panel's name exactly, so it nests under Magic Eraser.
]]
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, ns.AddonTitle)

AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions())
AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, D.TAB, ns.AddonTitle)

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

local function OpenOptions()
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
SlashCmdList.MAGICERASER = OpenOptions
