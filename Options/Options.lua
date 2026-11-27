local _, ns = ...
local L = ns.L
local D = ns.DiagnosticsStrings

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

-- At login, after ns.db. Registration order is tree order; the root registers first.
function ns:RegisterOptionsPanels()
	-- Kept only for the Eraser Context report.
	local _, generalCategoryID = Kit.RegisterPanel("General", ns.BuildGeneralOptions, L["ADDON_TITLE"])
	ns.generalCategoryID = generalCategoryID

	Kit.RegisterPanel("Erasing", ns.BuildErasingOptions, L["TAB_ERASING"])

	local function CurrentCharacter()
		return ns.db.keys.char
	end
	Kit.RegisterPanel("EraseList", ns.BuildEraseListOptions, L["TAB_ERASE_LIST"], "Erasing")
	Kit.PrepareTree("EraseList", CurrentCharacter)
	Kit.RegisterPanel("IgnoreList", ns.BuildIgnoreListOptions, L["TAB_PROTECT_LIST"], "Erasing")
	Kit.PrepareTree("IgnoreList", CurrentCharacter)

	Kit.RegisterPanel("MerchantBank", ns.BuildMerchantBankOptions, L["TAB_MERCHANT_BANK"])
	Kit.RegisterPanel("AlertsTints", ns.BuildAlertsTintsOptions, L["TAB_ALERTS"])

	-- The builder is registered like every other panel's; it is called here only for the AceDBOptions-localized name.
	Kit.RegisterPanel("Profiles", ns.BuildProfilesOptions, ns.BuildProfilesOptions().name)
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
