local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

local EXAMPLE_VALUE = 1240

local function BankRetrievalOff()
	return not (ns.db and ns.db.profile.bankRetrievalEnabled)
end

--------------------------------------------------------------------------------
-- Bank Retrieval Section
--------------------------------------------------------------------------------

-- The cushion line is the one place the player learns Bag-Space Warnings holds slots back from this.
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

	args.exampleBank = Kit.Example(27, BankRetrievalOff, function()
		return ns.ExampleLine(format(L["BANK_RETRIEVED"], "6", "3", ns:FormatCurrency(EXAMPLE_VALUE)))
	end)
end
