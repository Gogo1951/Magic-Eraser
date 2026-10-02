local _, ns = ...
local L = ns.L

local format = string.format

-- Sample figures for the example line: six items across three stacks.
local EXAMPLE_VALUE = 1240

local function BankRetrievalOff()
	return not (ns.db and ns.db.profile.bankRetrievalEnabled)
end

--------------------------------------------------------------------------------
-- Bank Retrieval Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Merchant & Bank panel rather than a panel of its own: it
    adds its widgets to the args table ns.BuildMerchantBankOptions hands it, and
    its order numbers are what place the section on that panel. See
    Features/Bank-Retrieval.lua for the behavior this setting drives. Its switch
    is also in the root panel's Features section.

    The cushion line is the one place the player learns that Bag-Space Warnings
    holds slots back from this feature (see GetMoveBudget), so it sits here, on
    the page of the feature it changes, and shows only while it applies.
]]
function ns.BuildBankRetrievalOptions(args)
	args.spacerBank0 = ns.OptionsSpacer(20)
	args.headerBank = ns.OptionsHeader(L["OPTIONS_BANK_HEADER"], 21)
	args.spacerBank1 = ns.OptionsSpacer(22)
	args.descBank = ns.OptionsDesc(L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"], 23)
	args.spacerBank2 = ns.OptionsSpacer(24)

	args.toggleBankRetrieval = ns.OptionsFeatureToggle(
		"bankRetrievalEnabled",
		"OPTIONS_ENABLE_BANK_RETRIEVAL",
		"OPTIONS_ENABLE_BANK_RETRIEVAL_DESC",
		25
	)

	args.spacerBankExample = ns.OptionsSpacer(25.5, BankRetrievalOff)
	args.statusBankCushion = ns.OptionsStatusLine(function()
		local settings = ns.db and ns.db.profile
		if not (settings and settings.bankRetrievalEnabled and settings.bagsFullNudgeEnabled) then
			return nil
		end
		local cushion = settings.bagsFullThreshold or 0
		if cushion == 1 then
			return L["OPTIONS_BANK_CUSHION_NOTE_ONE"]
		end
		return format(L["OPTIONS_BANK_CUSHION_NOTE"], cushion)
	end, 26)

	args.exampleBank = ns.OptionsExample(function()
		return format(L["BANK_RETRIEVED"], "6", "3", ns:FormatCurrency(EXAMPLE_VALUE))
	end, 27, BankRetrievalOff)
end
