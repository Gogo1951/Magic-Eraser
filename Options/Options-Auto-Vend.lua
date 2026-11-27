local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

local function AutoVendOff()
	return not (ns.db and ns.db.profile.autoVendEnabled)
end

-- One dropdown over two saved switches, which Features/Auto-Vend.lua reads directly.
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

local EXAMPLE_SALE_VALUE = 18
local EXAMPLE_SUMMARY_VALUE = 79

--------------------------------------------------------------------------------
-- Auto-Vend Section
--------------------------------------------------------------------------------

function ns.BuildAutoVendOptions(args)
	Kit.Section(args, "AutoVend", 10, L["AUTO_VEND"], L["AUTO_VEND_DESCRIPTION"])

	-- Each choice names chat itself, so "No Chat Report" never reads as Auto-Vend being off.
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
