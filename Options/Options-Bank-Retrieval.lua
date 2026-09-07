local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Bank Retrieval Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Safety panel rather than a panel of its own: it adds its
    widgets to the args table ns.BuildSafetyOptions hands it, and its order
    numbers are what place the section on that panel. See
    Features/Bank-Retrieval.lua for the behavior this setting drives.
]]
function ns.BuildBankRetrievalOptions(args)
	args.spacerBank0 = ns.OptionsSpacer(20)
	args.headerBank = ns.OptionsHeader(L["OPTIONS_BANK_HEADER"], 21)
	args.spacerBank1 = ns.OptionsSpacer(22)
	args.descBank = ns.OptionsDesc(L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"], 23)
	args.spacerBank2 = ns.OptionsSpacer(24)

	args.toggleBankRetrieval = {
		type = "toggle",
		name = L["OPTIONS_ENABLE_BANK_RETRIEVAL"],
		width = "full",
		order = 25,
		get = function()
			return ns.db and ns.db.global.bankRetrievalEnabled
		end,
		set = function(_, value)
			ns.db.global.bankRetrievalEnabled = value
		end,
	}
end
