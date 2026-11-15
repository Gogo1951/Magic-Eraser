local _, ns = ...
local L = ns.L
local D = ns.DiagnosticsStrings

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Registration only -- panel content lives in the per-panel builder files.
    Called from ns:OnPlayerLogin once ns.db exists, because the Protect List,
    Erase List and Profiles builders need the AceDB database. The tree:

      Magic Eraser (General, the root)
        Erasing
          Erase List
          Protect List
        Merchant & Bank
        Alerts & Tints
        Profiles
        Feedback & Support
        Diagnostic Tools

    Kit.RegisterPanel registers each panel's builder function, so every repaint
    (ns.RefreshSettings) rebuilds it and no panel ever draws a stale value,
    then adds it to the Settings tree under the root, or under the panel its
    parent key names, by the category ID that panel's registration returned.
    Registration order is tree order within each level. The Profiles display
    name comes already localized from AceDBOptions-3.0.
]]
function ns:RegisterOptionsPanels()
	--[[
	    The root's category ID is kept for the Eraser Context report, which
	    prints the route ns:OpenOptionsPanel takes (Diagnostics/Manifests.lua).
	]]
	local _, generalCategoryID = Kit.RegisterPanel("General", ns.BuildGeneralOptions, L["ADDON_TITLE"])
	ns.generalCategoryID = generalCategoryID

	-- Erasing holds everything about what gets erased, with the two lists that decide it nested beneath it.
	Kit.RegisterPanel("Erasing", ns.BuildErasingOptions, L["TAB_ERASING"])

	--[[
	    The two list pages are trees: All Characters, then each character, with
	    the selected list's items beside them. Each opens on the character being
	    played, every visit.
	]]
	local function CurrentCharacter()
		return ns.db.keys.char
	end
	Kit.RegisterPanel("EraseList", ns.BuildEraseListOptions, L["TAB_ERASE_LIST"], "Erasing")
	Kit.PrepareTree("EraseList", CurrentCharacter)
	Kit.RegisterPanel("IgnoreList", ns.BuildIgnoreListOptions, L["TAB_PROTECT_LIST"], "Erasing")
	Kit.PrepareTree("IgnoreList", CurrentCharacter)

	Kit.RegisterPanel("MerchantBank", ns.BuildMerchantBankOptions, L["TAB_MERCHANT_BANK"])
	Kit.RegisterPanel("AlertsTints", ns.BuildAlertsTintsOptions, L["TAB_ALERTS"])

	local profilesOptions = ns.BuildProfilesOptions()
	Kit.RegisterPanel("Profiles", profilesOptions, profilesOptions.name)
	Kit.RegisterPanel("FeedbackSupport", ns.BuildFeedbackSupportOptions, L["OPTIONS_FEEDBACK"])

	-- A builder function, so the tabs come and go with the enable toggle (see Diagnostics/Options-Diagnostics.lua).
	Kit.RegisterPanel("Diagnostics", ns.BuildDiagnosticsOptions, D.TAB)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

-- ns:OpenOptionsPanel is Options-Kit's: the Combat Guard first, then the root panel by its category ID.
SLASH_MAGICERASER1 = "/eraser"
SlashCmdList.MAGICERASER = function()
	ns:OpenOptionsPanel()
end
