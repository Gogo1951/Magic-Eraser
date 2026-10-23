local _, ns = ...
local L = ns.L

local function TintOff()
	return not (ns.db and ns.db.profile.tintJunkEnabled)
end

--------------------------------------------------------------------------------
-- Junk Item Tint Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Alerts & Tints panel rather than a panel of its own: it
    adds its widgets to the args table ns.BuildAlertsTintsOptions hands it, and
    its order numbers are what place the section on that panel. See
    Features/Tint-Junk.lua for the behavior these settings drive. Its switch is
    also in the root panel's Features section.

    The switch and the color share one line, laid out by ns.OptionsTogglePairs
    like the root panel's switches, and the color hides with the switch off.
    Both repaint the bags at once, so the player sees each change land on an
    open bag window.
]]
function ns.OnTintJunkChanged()
	ns:RefreshTints()
end

function ns.BuildTintJunkOptions(args)
	args.spacerTint0 = ns.OptionsSpacer(10)
	args.headerTint = ns.OptionsHeader(L["OPTIONS_TINT_HEADER"], 11)
	args.spacerTint1 = ns.OptionsSpacer(12)
	args.descTint = ns.OptionsDesc(L["OPTIONS_TINT_DESCRIPTION"], 13)
	args.spacerTint2 = ns.OptionsSpacer(14)

	ns.OptionsTogglePairs(args, "rowTint", 14, {
		ns.OptionsFeatureToggle(
			"tintJunkEnabled",
			"OPTIONS_ENABLE_TINT",
			"OPTIONS_ENABLE_TINT_DESCRIPTION",
			nil,
			nil,
			ns.OnTintJunkChanged
		),
		{
			type = "color",
			name = L["OPTIONS_TINT_COLOR"],
			desc = L["OPTIONS_TINT_COLOR_DESCRIPTION"],
			hasAlpha = true,
			hidden = TintOff,
			get = function()
				local color = ns.db and ns.db.profile.tintColor
				if not color then
					return
				end
				return color.r, color.g, color.b, color.a
			end,
			set = function(_, r, g, b, a)
				local color = ns.db.profile.tintColor
				color.r, color.g, color.b, color.a = r, g, b, a
				ns.OnTintJunkChanged()
			end,
		},
	})
end
