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

-- Bank Retrieval reads the threshold only while warnings are on, so a hidden slider never holds it back.
function ns.BuildBagWarningsOptions(args)
	Kit.Section(args, "BagsFull", 30, L["OPTIONS_BAGS_FULL_HEADER"], L["OPTIONS_BAGS_FULL_DESCRIPTION"])
	args.toggleBagsFullNudge = Kit.FeatureSwitch("bagsFullNudgeEnabled", 35)

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
