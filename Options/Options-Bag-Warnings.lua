local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

local EXAMPLE_FREE_SLOTS = 3

local function BagsFullOff()
	return not (ns.db and ns.db.profile.bagsFullNudgeEnabled)
end

--------------------------------------------------------------------------------
-- Bag-Space Warnings Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Alerts & Tints panel rather than a panel of its own: it
    adds its widgets to the args table ns.BuildAlertsTintsOptions hands it,
    and its order numbers are what place the section on that panel. See
    Features/Bag-Warnings.lua for the behavior these settings drive. Its switch
    is also in the root panel's Features section.

    The threshold is a sub-option of the warnings toggle, and Bank Retrieval
    reads it as a cushion only while that toggle is on -- see GetMoveBudget in
    Features/Bank-Retrieval.lua, which is why a hidden slider never holds back a
    visible feature. Bank Retrieval's own section says so while it applies.

    Toggling or moving the threshold ends in ns.RefreshSettings, which repaints
    Merchant & Bank, so that line is right the next time the player opens it.
]]
function ns.BuildBagWarningsOptions(args)
	Kit.Section(args, "BagsFull", 30, L["OPTIONS_BAGS_FULL_HEADER"], L["OPTIONS_BAGS_FULL_DESCRIPTION"])
	args.toggleBagsFullNudge = Kit.FeatureSwitch("bagsFullNudgeEnabled", 35)

	-- A sub-option: a silver caption beside a slider in the control column, indented under its switch.
	args.rowBagsFullThreshold = Kit.SubLabelRow(36, BagsFullOff, L["OPTIONS_BAGS_FULL_THRESHOLD"], {
		type = "range",
		desc = L["OPTIONS_BAGS_FULL_THRESHOLD_DESCRIPTION"],
		min = 1,
		max = 10,
		step = 1,
		get = function()
			return ns.db and ns.db.profile.bagsFullThreshold
		end,
		set = function(_, value)
			ns.db.profile.bagsFullThreshold = value
			ns.RefreshSettings()
		end,
	})

	args.exampleBagsFull = Kit.Example(37, BagsFullOff, function()
		return ns.ExampleLine(format(L["BAGS_FULL_NUDGE"], EXAMPLE_FREE_SLOTS))
	end)
end
