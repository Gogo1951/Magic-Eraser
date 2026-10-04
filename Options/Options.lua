local _, ns = ...
local L = ns.L
local D = ns.DiagnosticsStrings

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

--[[
    Registration only -- panel content lives in the per-panel builder files.
    Called from ns:OnPlayerLogin once ns.db exists, because the Ignore List,
    Erase List and Profiles builders need the AceDB database. Child order is
    General (root) -> Erasing -> Merchant & Bank -> Alerts & Tooltips ->
    Protect List -> Erase List -> Your Current Bags -> Profiles -> the
    Diagnostic Tools panel last; each child's third AddToBlizOptions argument is the root's
    display name (ns.ADDON_TITLE), so the eight children nest under Magic
    Eraser. Registration order is tree order.
    The Profiles display name comes already localized from AceDBOptions-3.0.
]]
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--[[
    Seeds a list panel's tree status before it is first drawn:
      - treewidth sizes the tree (see ns.OPTIONS_TREE_WIDTH). AceGUI's
        SetStatusTable fills it in only when the key is absent, so seeding it
        here wins, while a player dragging the splitter still overwrites it.
      - selected opens the tree on the character being played. It is set
        again every time the panel hides, so each visit starts there, while
        picking another character holds until the player leaves the page.
]]
local function PrepareListTree(registryName, panel)
	local status = AceConfigDialog:GetStatusTable(registryName)
	status.groups = status.groups or {}
	status.groups.treewidth = ns.OPTIONS_TREE_WIDTH
	status.groups.selected = ns.db.keys.char

	if panel then
		panel:HookScript("OnHide", function()
			status.groups.selected = ns.db.keys.char
		end)
	end
end

function ns:RegisterOptionsPanels()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.General, ns.BuildGeneralOptions())
	--[[
	    AddToBlizOptions returns (frame, categoryID). The ID is what
	    Settings.OpenToCategory expects; relying on the display name matching the
	    ID is fragile -- the library only aliases the ID to the name on clients
	    without C_SettingsUtil.OpenSettingsPanel (Era), so on TBC Anniversary a
	    name-based lookup returns nil. Capture the real references here.
	]]
	ns.generalPanel, ns.generalCategoryID =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.General, ns.ADDON_TITLE)

	--[[
	    The three feature pages, ahead of the two list panels: they are
	    configuration, the lists are data. Built tables rather than builder
	    functions, because nothing on them is drawn from a live list.
	]]
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Erasing, ns.BuildErasingOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Erasing, L["TAB_ERASING"], ns.ADDON_TITLE)

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.MerchantBank, ns.BuildMerchantBankOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.MerchantBank, L["TAB_MERCHANT_BANK"], ns.ADDON_TITLE)

	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.AlertsTooltips, ns.BuildAlertsTooltipsOptions())
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.AlertsTooltips, L["TAB_ALERTS"], ns.ADDON_TITLE)

	--[[
	    The builder function, not a built table: the Ignore List panel's rows are
	    the ignore lists themselves, so AceConfig re-invokes it on every open and
	    every NotifyChange and the panel never renders a stale list.
	]]
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.IgnoreList, ns.BuildIgnoreListOptions)
	local ignorePanel =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.IgnoreList, L["TAB_IGNORE_LIST"], ns.ADDON_TITLE)
	PrepareListTree(ns.OPTIONS_REGISTRY.IgnoreList, ignorePanel)

	-- The Erase List is the same panel in reverse, so it gets the same treatment.
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.EraseList, ns.BuildEraseListOptions)
	local erasePanel =
		AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.EraseList, L["TAB_ERASE_LIST"], ns.ADDON_TITLE)
	PrepareListTree(ns.OPTIONS_REGISTRY.EraseList, erasePanel)

	--[[
	    Your Current Bags right after the two lists, since its rows are where a
	    player sorts what they carry onto them. A builder function, because its
	    rows are the live bags; ns:RefreshDisplay repaints it on every bag
	    change.
	]]
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.YourCurrentBags, ns.BuildYourCurrentBagsOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.YourCurrentBags, L["TAB_YOUR_CURRENT_BAGS"], ns.ADDON_TITLE)

	local profilesOptions = ns.BuildProfilesOptions()
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Profiles, profilesOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Profiles, profilesOptions.name, ns.ADDON_TITLE)

	-- A builder function, so the tabs come and go with the enable toggle (see Diagnostics/Options-Diagnostics.lua).
	AceConfig:RegisterOptionsTable(ns.OPTIONS_REGISTRY.Diagnostics, ns.BuildDiagnosticsOptions)
	AceConfigDialog:AddToBlizOptions(ns.OPTIONS_REGISTRY.Diagnostics, D.TAB, ns.ADDON_TITLE)
end

--------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------

function ns:OpenOptionsPanel()
	--[[
	    Combat first: the Settings panel is protected there, so every route below
	    is blocked and the player would get an ADDON_ACTION_BLOCKED error instead.
	]]
	if InCombatLockdown() then
		ns:PrintMessage(L["CHAT_OPTIONS_IN_COMBAT"])
		return
	end

	if Settings and Settings.OpenToCategory and ns.generalCategoryID then
		Settings.OpenToCategory(ns.generalCategoryID)
		return
	end
	AceConfigDialog:Open(ns.OPTIONS_REGISTRY.General)
end

SLASH_MAGICERASER1 = "/eraser"
SlashCmdList.MAGICERASER = function()
	ns:OpenOptionsPanel()
end
