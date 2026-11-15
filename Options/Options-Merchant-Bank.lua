local _, ns = ...
local L = ns.L

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Merchant & Bank Panel
--------------------------------------------------------------------------------

--[[
    The two features that move junk rather than destroy it: Auto-Vend at a
    merchant, and Bank Retrieval at the bank. They share a page because they
    share a rule -- neither consults Maximum Value to Erase, since selling an
    over-cap stack pays the player instead of costing them. Auto-Vend at 10,
    Bank Retrieval at 20.

    Registered as its builder function (Kit.RegisterPanel), so every repaint
    rebuilds it.
]]
local MERCHANT_BANK_SECTIONS = {
	"BuildAutoVendOptions",
	"BuildBankRetrievalOptions",
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
