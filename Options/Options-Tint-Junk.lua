local _, ns = ...
local L = ns.L

local Kit = ns.OptionsKit

local function TintOff()
	return not (ns.db and ns.db.profile.tintJunkEnabled)
end

--------------------------------------------------------------------------------
-- Junk Item Tint Section
--------------------------------------------------------------------------------

-- Switch and color on one line: a README-Notes.md exception.
function ns.OnTintJunkChanged()
	ns:RefreshTints()
end

function ns.BuildTintJunkOptions(args)
	Kit.Section(args, "Tint", 10, L["OPTIONS_TINT_HEADER"], L["OPTIONS_TINT_DESCRIPTION"])

	args.rowTint = Kit.Pairs(15, nil, {
		Kit.FeatureSwitch("tintJunkEnabled"),
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
				ns.RefreshSettings()
			end,
		},
	})
end
