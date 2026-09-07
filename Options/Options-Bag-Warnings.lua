local _, ns = ...
local L = ns.L

local SubRow, SubLabel = ns.OptionsSubRow, ns.OptionsSubLabel

--[[
    The bag-space row is a caption beside a slider, the same shape as the value
    cap's row, so it spends the same pair of widths and the two rows line up with
    each other down the panel.
]]
local BAGS_FULL_LABEL_WIDTH = 1.3
local BAGS_FULL_RANGE_WIDTH = 1.0

local function BagsFullOff()
	return not (ns.db and ns.db.global.bagsFullNudgeEnabled)
end

--------------------------------------------------------------------------------
-- Bag-Space Warnings Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Safety panel rather than a panel of its own: it adds its
    widgets to the args table ns.BuildSafetyOptions hands it, and its order
    numbers are what place the section on that panel. See
    Features/Bag-Warnings.lua for the behavior these settings drive.

    The threshold is a sub-option of the warnings toggle, and Bank Retrieval
    reads it as a cushion only while that toggle is on -- see GetMoveBudget in
    Features/Bank-Retrieval.lua, which is why a hidden slider never holds back a
    visible feature.
]]
function ns.BuildBagWarningsOptions(args)
	args.spacerBagsFull0 = ns.OptionsSpacer(60)
	args.headerBagsFull = ns.OptionsHeader(L["OPTIONS_BAGS_FULL_HEADER"], 61)
	args.spacerBagsFull1 = ns.OptionsSpacer(62)
	args.descBagsFull = ns.OptionsDesc(L["OPTIONS_BAGS_FULL_DESCRIPTION"], 63)
	args.spacerBagsFull2 = ns.OptionsSpacer(64)

	args.toggleBagsFullNudge = {
		type = "toggle",
		name = L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"],
		width = "full",
		order = 65,
		get = function()
			return ns.db and ns.db.global.bagsFullNudgeEnabled
		end,
		set = function(_, value)
			ns.db.global.bagsFullNudgeEnabled = value
		end,
	}

	args.rowBagsFullThreshold = SubRow(66, BagsFullOff, {
		ns.OptionsRowLabel(SubLabel(L["OPTIONS_BAGS_FULL_THRESHOLD"]), nil, BAGS_FULL_LABEL_WIDTH),
		{
			type = "range",
			name = "",
			width = BAGS_FULL_RANGE_WIDTH,
			min = 1,
			max = 10,
			step = 1,
			get = function()
				return ns.db and ns.db.global.bagsFullThreshold
			end,
			set = function(_, value)
				ns.db.global.bagsFullThreshold = value
			end,
		},
	})
end
