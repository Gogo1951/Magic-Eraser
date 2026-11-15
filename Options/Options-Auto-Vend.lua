local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

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
	Kit.Section(args, "AutoVend", 10, L["AUTO_VEND"], L["AUTO_VEND_DESCRIPTION"])

	--[[
	    The switch and its chat report share one line (Kit.ToggleRow). With no
	    caption, each choice names chat itself, so "No Chat Report" never reads
	    as Auto-Vend being off. The dropdown hides while the switch is off: a
	    setting for a feature that is not running is not shown at all.
	]]
	args.rowAutoVend = Kit.ToggleRow(15, Kit.FeatureSwitch("autoVendEnabled"), {
		control = {
			type = "select",
			desc = L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESCRIPTION"],
			values = REPORT_VALUES,
			sorting = REPORT_SORTING,
			get = GetReportMode,
			set = function(_, value)
				SetReportMode(value)
				ns.RefreshSettings()
			end,
		},
	})

	--[[
	    What the chosen report prints, from the real sale strings, closing the
	    switch's field set. Every Sale in Chat shows the total with a sale
	    line beneath it, as a visit prints them. One sale line is enough to
	    show the shape.
	]]
	args.exampleAutoVend = Kit.Example(16, function()
		return AutoVendOff() or GetReportMode() == "off"
	end, function()
		local summary = ns.ExampleLine(
			format(L["SOLD_SUMMARY"], "9", "4", ns:FormatCurrency(EXAMPLE_SUMMARY_VALUE))
				.. " "
				.. L["AUTO_VEND_SHIFT_HINT"]
		)
		if GetReportMode() ~= "verbose" then
			return summary
		end
		local sale = ns.ExampleLine(
			format(
				L["SOLD_ITEM"],
				ns.ExampleItemLink(ns.EXAMPLE_JUNK_ITEM_ID, ns.OPTIONS_REGISTRY.MerchantBank),
				" x3",
				ns:FormatCurrency(EXAMPLE_SALE_VALUE)
			)
		)
		return { summary, sale }
	end)
end
