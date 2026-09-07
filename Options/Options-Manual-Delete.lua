local _, ns = ...
local L = ns.L

local GetColor = ns.GetColor
local SubRow, SubLabel = ns.OptionsSubRow, ns.OptionsSubLabel

--[[
    The manual-delete row is a caption beside a dropdown, the same shape as the
    value cap's and bag-space rows, so it spends the same pair of widths and all
    three line up with each other down the panel.
]]
local MANUAL_DELETE_LABEL_WIDTH = 1.3
local MANUAL_DELETE_SELECT_WIDTH = 1.0

local function ManualDeleteOff()
	return not (ns.db and ns.db.global.manualDeleteAutoFillEnabled)
end

--------------------------------------------------------------------------------
-- Manual Delete Assistance Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Safety panel rather than a panel of its own: it adds its
    widgets to the args table ns.BuildSafetyOptions hands it, and its order
    numbers are what place the section on that panel.

    This is the client's own delete prompt, not the eraser's -- see
    Features/Manual-Delete.lua, which owns the behavior and explains why the two
    are separate sections.
]]
function ns.BuildManualDeleteOptions(args)
	args.spacerManualDelete0 = ns.OptionsSpacer(30)
	args.headerManualDelete = ns.OptionsHeader(L["OPTIONS_MANUAL_DELETE_HEADER"], 31)
	args.spacerManualDelete1 = ns.OptionsSpacer(32)
	args.descManualDelete = ns.OptionsDesc(L["OPTIONS_MANUAL_DELETE_DESCRIPTION"], 33)
	args.spacerManualDelete2 = ns.OptionsSpacer(34)

	args.toggleManualDelete = {
		type = "toggle",
		name = GetColor("TEXT") .. L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] .. "|r",
		width = "full",
		order = 35,
		get = function()
			return ns.db and ns.db.global.manualDeleteAutoFillEnabled
		end,
		set = function(_, value)
			ns.db.global.manualDeleteAutoFillEnabled = value
		end,
	}

	--[[
	    Hidden rather than greyed, which the sub-row carries for the whole row: a
	    scope for a skip that is not happening is not a setting the player has any
	    use for, and the section reads as one line until it has something to say.
	]]
	args.rowManualDeleteScope = SubRow(36, ManualDeleteOff, {
		ns.OptionsRowLabel(SubLabel(L["OPTIONS_MANUAL_DELETE_SCOPE"]), nil, MANUAL_DELETE_LABEL_WIDTH),
		{
			type = "select",
			name = "",
			width = MANUAL_DELETE_SELECT_WIDTH,
			values = {
				all = L["OPTIONS_MANUAL_DELETE_ALL"],
				noValue = L["OPTIONS_MANUAL_DELETE_NO_VALUE"],
			},
			sorting = { "all", "noValue" },
			get = function()
				return (ns.db and ns.db.global.manualDeleteNoValueOnly) and "noValue" or "all"
			end,
			set = function(_, value)
				ns.db.global.manualDeleteNoValueOnly = (value == "noValue")
			end,
		},
	})
end
