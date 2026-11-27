local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Auto-Repair
--------------------------------------------------------------------------------

-- Own gold only, and nothing short of the full cost: never broke, never half repaired.
function ns:RepairAtMerchant()
	if not (ns.db and ns.db.profile.autoRepairEnabled) then
		return
	end
	if IsShiftKeyDown() then
		return
	end
	if not (CanMerchantRepair and CanMerchantRepair()) then
		return
	end

	local cost, canRepair = GetRepairAllCost()
	if not (canRepair and cost and cost > 0 and cost <= GetMoney()) then
		return
	end

	RepairAllItems(false)
	ns:PrintMessage(string.format(L["REPAIRED_GEAR"], ns:FormatCurrency(cost)))
end
