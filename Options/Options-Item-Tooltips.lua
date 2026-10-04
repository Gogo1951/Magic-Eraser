local _, ns = ...
local L = ns.L

local GetColor = ns.GetColor

local function TooltipsOff()
	return not (ns.db and ns.db.profile.tooltipWarningEnabled)
end

--------------------------------------------------------------------------------
-- Tooltip Warnings Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Alerts & Tooltips panel rather than a panel of its own: it
    adds its widgets to the args table ns.BuildAlertsTooltipsOptions hands it,
    and its order numbers are what place the section on that panel. See
    Features/Item-Tooltips.lua for the behavior this setting drives. Its switch
    is also in the root panel's Features section.

    The examples are the three lines the tooltip can draw, exactly as it draws
    them: brand prefix, then the will-erase and Erase List lines in red and the
    Protect List line in white. A blank line sits above each.
]]
local TOOLTIP_EXAMPLES = {
	-- { key, locale key, color }
	{ "WillErase", "TOOLTIP_WILL_ERASE", "OFF" },
	{ "EraseList", "TOOLTIP_ON_ERASE_LIST", "OFF" },
	{ "Protected", "TOOLTIP_IGNORED", "TEXT" },
}

function ns.BuildItemTooltipsOptions(args)
	args.spacerTooltip0 = ns.OptionsSpacer(10)
	args.headerTooltip = ns.OptionsHeader(L["OPTIONS_TOOLTIP_HEADER"], 11)
	args.spacerTooltip1 = ns.OptionsSpacer(12)
	args.descTooltip = ns.OptionsDesc(L["OPTIONS_TOOLTIP_DESCRIPTION"], 13)
	args.spacerTooltip2 = ns.OptionsSpacer(14)

	args.toggleTooltipWarning = ns.OptionsFeatureToggle(
		"tooltipWarningEnabled",
		"OPTIONS_ENABLE_TOOLTIPS",
		"OPTIONS_ENABLE_TOOLTIPS_DESCRIPTION",
		15
	)

	for index, example in ipairs(TOOLTIP_EXAMPLES) do
		local key, textKey, color = example[1], example[2], example[3]
		local order = 15 + index
		args["spacerTooltip" .. key] = ns.OptionsSpacer(order - 0.5, TooltipsOff)
		args["exampleTooltip" .. key] = {
			type = "description",
			name = function()
				return GetColor("HELP")
					.. string.format(L["OPTIONS_EXAMPLE"], ns.BRAND_PREFIX .. GetColor(color) .. L[textKey] .. "|r")
					.. "|r"
			end,
			fontSize = "medium",
			order = order,
			hidden = TooltipsOff,
		}
	end
end
