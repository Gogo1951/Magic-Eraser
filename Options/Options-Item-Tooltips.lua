local _, ns = ...
local L = ns.L

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Junk Item Tooltips Section
--------------------------------------------------------------------------------

function ns.BuildItemTooltipsOptions(args)
	Kit.Section(args, "Tooltips", 40, L["OPTIONS_TOOLTIPS_HEADER"], L["OPTIONS_TOOLTIPS_DESCRIPTION"])
	args.toggleTooltips = Kit.FeatureSwitch("tooltipsEnabled", 45)
end
