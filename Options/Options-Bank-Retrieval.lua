local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

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
	Kit.Section(args, "Bank", 20, L["OPTIONS_BANK_HEADER"], L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"])
	args.toggleBankRetrieval = Kit.FeatureSwitch("bankRetrievalEnabled", 25)

	args.statusBankCushion = Kit.StatusLine(function()
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

	-- What a bank visit prints, closing the switch's field set.
	args.exampleBank = Kit.Example(27, BankRetrievalOff, function()
		return ns.ExampleLine(format(L["BANK_RETRIEVED"], "6", "3", ns:FormatCurrency(EXAMPLE_VALUE)))
	end)
end
