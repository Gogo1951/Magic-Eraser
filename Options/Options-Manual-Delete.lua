local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Delete Without Typing Section
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
	Kit.Section(
		args,
		"ManualDelete",
		40,
		L["OPTIONS_MANUAL_DELETE_HEADER"],
		format(L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"], DELETE_ITEM_CONFIRM_STRING or "", ITEM_QUALITY3_DESC)
	)

	--[[
	    The switch and its scope share one line (Kit.ToggleRow), the same shape
	    as Maximum Value to Erase. The dropdown hides while the switch is off: a
	    setting for a feature that is not running is not shown at all.
	]]
	args.rowManualDelete = Kit.ToggleRow(45, Kit.FeatureSwitch("manualDeleteAutoFillEnabled"), {
		control = {
			type = "select",
			desc = L["OPTIONS_MANUAL_DELETE_SCOPE_DESCRIPTION"],
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
				ns.RefreshSettings()
			end,
		},
	})
end
