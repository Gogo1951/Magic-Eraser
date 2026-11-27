local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

local EXAMPLE_COST = 340

local function AutoRepairOff()
	return not (ns.db and ns.db.profile.autoRepairEnabled)
end

--------------------------------------------------------------------------------
-- Auto-Repair Section
--------------------------------------------------------------------------------

function ns.BuildAutoRepairOptions(args)
	Kit.Section(args, "AutoRepair", 30, L["OPTIONS_AUTO_REPAIR_HEADER"], L["OPTIONS_AUTO_REPAIR_DESCRIPTION"])
	args.toggleAutoRepair = Kit.FeatureSwitch("autoRepairEnabled", 35)

	args.exampleAutoRepair = Kit.Example(37, AutoRepairOff, function()
		return ns.ExampleLine(format(L["REPAIRED_GEAR"], ns:FormatCurrency(EXAMPLE_COST)))
	end)
end
