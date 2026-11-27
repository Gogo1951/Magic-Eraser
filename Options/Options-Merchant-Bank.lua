local _, ns = ...
local L = ns.L

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Merchant & Bank Panel
--------------------------------------------------------------------------------

-- Auto-Vend and Bank Retrieval share a rule: neither consults Maximum Value to Erase, since selling pays.
local MERCHANT_BANK_SECTIONS = {
	"BuildAutoVendOptions",
	"BuildBankRetrievalOptions",
	"BuildAutoRepairOptions",
}

function ns.BuildMerchantBankOptions()
	local args = {
		descIntro = Kit.Desc(L["TAB_MERCHANT_BANK_DESCRIPTION"], 1),
	}

	for _, builder in ipairs(MERCHANT_BANK_SECTIONS) do
		ns[builder](args)
	end

	return {
		type = "group",
		name = L["TAB_MERCHANT_BANK"],
		args = args,
	}
end
