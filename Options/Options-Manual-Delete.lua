local _, ns = ...
local L = ns.L

local format = string.format

local function ManualDeleteOff()
	return not (ns.db and ns.db.profile.manualDeleteAutoFillEnabled)
end

--------------------------------------------------------------------------------
-- Manual Delete Assistance Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Erasing panel rather than a panel of its own: it adds its
    widgets to the args table ns.BuildErasingOptions hands it, and its order
    numbers are what place the section on that panel.

    This is the client's own delete prompt, not the eraser's -- see
    Features/Manual-Delete.lua, which owns the behavior and explains why the two
    are separate sections.
]]
function ns.BuildManualDeleteOptions(args)
	args.spacerManualDelete0 = ns.OptionsSpacer(40)
	args.headerManualDelete = ns.OptionsHeader(L["OPTIONS_MANUAL_DELETE_HEADER"], 41)
	args.spacerManualDelete1 = ns.OptionsSpacer(42)
	args.descManualDelete = ns.OptionsDesc(
		format(L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"], DELETE_ITEM_CONFIRM_STRING or "", ITEM_QUALITY3_DESC),
		43
	)
	args.spacerManualDelete2 = ns.OptionsSpacer(44)

	--[[
	    The switch and its scope share one line, the switch at
	    ns.OPTIONS_LABEL_WIDTH where a caption would sit and the dropdown at
	    ns.OPTIONS_CONTROL_WIDTH, the same shape as Maximum Value to Erase. The
	    dropdown hides while the switch is off: a setting for a feature that is
	    not running is not shown at all.
	]]
	args.toggleManualDelete = ns.OptionsFeatureToggle(
		"manualDeleteAutoFillEnabled",
		"OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL",
		"OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESC",
		45,
		ns.OPTIONS_LABEL_WIDTH
	)

	args.selectManualDeleteScope = {
		type = "select",
		name = "",
		desc = L["OPTIONS_MANUAL_DELETE_SCOPE_DESC"],
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = 46,
		hidden = ManualDeleteOff,
		values = {
			all = L["OPTIONS_MANUAL_DELETE_ALL"],
			noValue = L["OPTIONS_MANUAL_DELETE_NO_VALUE"],
		},
		sorting = { "all", "noValue" },
		get = function()
			return (ns.db and ns.db.profile.manualDeleteNoValueOnly) and "noValue" or "all"
		end,
		set = function(_, value)
			ns.db.profile.manualDeleteNoValueOnly = (value == "noValue")
		end,
	}
end
