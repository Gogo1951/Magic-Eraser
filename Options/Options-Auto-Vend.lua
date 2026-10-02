local _, ns = ...
local L = ns.L

local format = string.format

local function AutoVendOff()
	return not (ns.db and ns.db.profile.autoVendEnabled)
end

--[[
    One dropdown over two saved switches. No Chat Report is
    autoVendMessagesEnabled false; Summary in Chat and Every Sale in Chat are it
    true with autoVendSummaryEnabled true or false. Features/Auto-Vend.lua reads
    the two switches directly.
]]
local REPORT_VALUES = {
	summary = L["OPTIONS_AUTO_VEND_SUMMARY"],
	verbose = L["OPTIONS_AUTO_VEND_LINE_ITEM"],
	off = L["OPTIONS_AUTO_VEND_REPORT_OFF"],
}
local REPORT_SORTING = { "summary", "verbose", "off" }

local function GetReportMode()
	local settings = ns.db and ns.db.profile
	if not (settings and settings.autoVendMessagesEnabled) then
		return "off"
	end
	return settings.autoVendSummaryEnabled and "summary" or "verbose"
end

local function SetReportMode(mode)
	ns.db.profile.autoVendMessagesEnabled = (mode ~= "off")
	if mode ~= "off" then
		ns.db.profile.autoVendSummaryEnabled = (mode == "summary")
	end
end

-- Sample figures for the example lines: nine items across four stacks.
local EXAMPLE_SALE_VALUE = 18
local EXAMPLE_SUMMARY_VALUE = 79

--------------------------------------------------------------------------------
-- Auto-Vend Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Merchant & Bank panel rather than a panel of its own: it
    adds its widgets to the args table ns.BuildMerchantBankOptions hands it,
    keeping the section's order numbers so the panel renders in one fixed
    sequence. See Features/Auto-Vend.lua for the behavior these settings drive.
    Its switch is also in the root panel's Features section.
]]
function ns.BuildAutoVendOptions(args)
	args.spacerAutoVend0 = ns.OptionsSpacer(10)
	args.headerAutoVend = ns.OptionsHeader(L["AUTO_VEND"], 11)
	args.spacerAutoVend1 = ns.OptionsSpacer(12)
	args.descAutoVend = ns.OptionsDesc(L["AUTO_VEND_DESCRIPTION"], 13)
	args.spacerAutoVend2 = ns.OptionsSpacer(14)

	--[[
	    The switch and its chat report share one line, the switch at
	    ns.OPTIONS_LABEL_WIDTH where a caption would sit and the dropdown at
	    ns.OPTIONS_CONTROL_WIDTH. With no caption, each choice names chat itself,
	    so "No Chat Report" never reads as Auto-Vend being off. The
	    dropdown hides while the switch is off: a setting for a feature that is
	    not running is not shown at all.
	]]
	args.toggleAutoVend = ns.OptionsFeatureToggle(
		"autoVendEnabled",
		"OPTIONS_ENABLE_AUTO_VEND",
		"OPTIONS_ENABLE_AUTO_VEND_DESC",
		15,
		ns.OPTIONS_LABEL_WIDTH
	)

	args.selectAutoVendReport = {
		type = "select",
		name = "",
		desc = L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESC"],
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = 16,
		hidden = AutoVendOff,
		values = REPORT_VALUES,
		sorting = REPORT_SORTING,
		get = GetReportMode,
		set = function(_, value)
			SetReportMode(value)
		end,
	}

	--[[
	    What the chosen report prints, from the real sale strings. Every Sale in
	    Chat shows a sale line above the closing total, as a visit does.
	]]
	args.spacerAutoVendExample = ns.OptionsSpacer(16.5, function()
		return AutoVendOff() or GetReportMode() == "off"
	end)

	args.exampleAutoVendSale = ns.OptionsExample(
		function()
			return format(L["SOLD_ITEM"], ns.EXAMPLE_ITEM_LINK, " x3", ns:FormatCurrency(EXAMPLE_SALE_VALUE))
		end,
		17,
		function()
			return AutoVendOff() or GetReportMode() ~= "verbose"
		end
	)

	args.exampleAutoVendSummary = ns.OptionsExample(
		function()
			return format(L["SOLD_SUMMARY"], "9", "4", ns:FormatCurrency(EXAMPLE_SUMMARY_VALUE))
		end,
		18,
		function()
			return AutoVendOff() or GetReportMode() == "off"
		end
	)
end
