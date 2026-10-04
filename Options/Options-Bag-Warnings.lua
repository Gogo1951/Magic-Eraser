local _, ns = ...
local L = ns.L

local format = string.format

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local SubRow, SubLabel = ns.OptionsSubRow, ns.OptionsSubLabel

--[[
    The bag-space row is a caption beside a slider, the same pair of widths every
    captioned row spends, so it lines up with the rows on the other panels.
]]
local BAGS_FULL_LABEL_WIDTH = ns.OPTIONS_SUB_LABEL_WIDTH
local BAGS_FULL_RANGE_WIDTH = ns.OPTIONS_CONTROL_WIDTH

local EXAMPLE_FREE_SLOTS = 3

local function BagsFullOff()
	return not (ns.db and ns.db.profile.bagsFullNudgeEnabled)
end

--------------------------------------------------------------------------------
-- Bag-Space Warnings Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Alerts & Tooltips panel rather than a panel of its own: it
    adds its widgets to the args table ns.BuildAlertsTooltipsOptions hands it,
    and its order numbers are what place the section on that panel. See
    Features/Bag-Warnings.lua for the behavior these settings drive. Its switch
    is also in the root panel's Features section.

    The threshold is a sub-option of the warnings toggle, and Bank Retrieval
    reads it as a cushion only while that toggle is on -- see GetMoveBudget in
    Features/Bank-Retrieval.lua, which is why a hidden slider never holds back a
    visible feature. Bank Retrieval's own section says so while it applies.

    Toggling or moving the threshold repaints Merchant & Bank, so that line is
    right the next time the player opens it.
]]
local function NotifyMerchantBank()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.MerchantBank)
end

function ns.BuildBagWarningsOptions(args)
	args.spacerBagsFull0 = ns.OptionsSpacer(30)
	args.headerBagsFull = ns.OptionsHeader(L["OPTIONS_BAGS_FULL_HEADER"], 31)
	args.spacerBagsFull1 = ns.OptionsSpacer(32)
	args.descBagsFull = ns.OptionsDesc(L["OPTIONS_BAGS_FULL_DESCRIPTION"], 33)
	args.spacerBagsFull2 = ns.OptionsSpacer(34)

	args.toggleBagsFullNudge = ns.OptionsFeatureToggle(
		"bagsFullNudgeEnabled",
		"OPTIONS_ENABLE_BAGS_FULL_WARNINGS",
		"OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION",
		35,
		nil,
		NotifyMerchantBank
	)

	args.rowBagsFullThreshold = SubRow(36, BagsFullOff, {
		ns.OptionsRowLabel(SubLabel(L["OPTIONS_BAGS_FULL_THRESHOLD"]), nil, BAGS_FULL_LABEL_WIDTH),
		{
			type = "range",
			name = "",
			desc = L["OPTIONS_BAGS_FULL_THRESHOLD_DESCRIPTION"],
			width = BAGS_FULL_RANGE_WIDTH,
			min = 1,
			max = 10,
			step = 1,
			get = function()
				return ns.db and ns.db.profile.bagsFullThreshold
			end,
			set = function(_, value)
				ns.db.profile.bagsFullThreshold = value
				NotifyMerchantBank()
			end,
		},
	})

	args.spacerBagsFullExample = ns.OptionsSpacer(36.5, BagsFullOff)
	args.exampleBagsFull = ns.OptionsExample(function()
		return format(L["BAGS_FULL_NUDGE"], EXAMPLE_FREE_SLOTS)
	end, 37, BagsFullOff)
end
