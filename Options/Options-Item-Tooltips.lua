local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Tooltip Warnings Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Safety panel rather than a panel of its own: it adds its
    widgets to the args table ns.BuildSafetyOptions hands it, and its order
    numbers are what place the section on that panel. See
    Features/Item-Tooltips.lua for the behavior this setting drives.
]]
function ns.BuildItemTooltipsOptions(args)
	args.spacerTooltip0 = ns.OptionsSpacer(10)
	args.headerTooltip = ns.OptionsHeader(L["OPTIONS_TOOLTIP_HEADER"], 11)
	args.spacerTooltip1 = ns.OptionsSpacer(12)
	args.descTooltip = ns.OptionsDesc(L["OPTIONS_TOOLTIP_DESCRIPTION"], 13)
	args.spacerTooltip2 = ns.OptionsSpacer(14)

	args.toggleTooltipWarning = {
		type = "toggle",
		name = L["OPTIONS_ENABLE_TOOLTIPS"],
		width = "full",
		order = 15,
		get = function()
			return ns.db and ns.db.global.tooltipWarningEnabled
		end,
		set = function(_, value)
			ns.db.global.tooltipWarningEnabled = value
		end,
	}
end
