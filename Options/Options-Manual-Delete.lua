local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Skip Typing DELETE Section
--------------------------------------------------------------------------------

-- The client's own delete prompt, not the eraser's: a separate section on purpose.
function ns.BuildManualDeleteOptions(args)
	Kit.Section(
		args,
		"ManualDelete",
		40,
		L["OPTIONS_MANUAL_DELETE_HEADER"],
		format(L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"], DELETE_ITEM_CONFIRM_STRING or "", ITEM_QUALITY3_DESC)
	)

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
