local _, ns = ...
local L = ns.L

local format, ipairs = string.format, ipairs

local GetColor = ns.GetColor

--[[
    The value cap's dropdown, built once from ns.VALUE_CAP_CHOICES rather than
    typed out twice. values is keyed by the gold amount the setting stores, and
    sorting repeats those keys in run order because AceConfig otherwise orders a
    dropdown by its labels -- which sorts them as text, landing "13 Gold"
    between "1 Gold" and "2 Gold".
]]
local VALUE_CAP_VALUES, VALUE_CAP_SORTING = {}, {}

for index, gold in ipairs(ns.VALUE_CAP_CHOICES) do
	VALUE_CAP_VALUES[gold] = format(L["OPTIONS_VALUE_CAP_GOLD"], gold)
	VALUE_CAP_SORTING[index] = gold
end

local function ValueCapOff()
	return not (ns.db and ns.db.profile.valueCapEnabled)
end

--[[
    A kind's checkbox changes what counts as junk at all, so it drops the scan
    cache and repaints like the value cap does: the mini-map icon and the Your
    Current Bags queue move on the spot.
]]
local function SetJunkKind(deleteReason, isJunk)
	ns.db.profile.junkKinds[deleteReason] = isJunk
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

--[[
    The value-cap switch's onSet, shared by its Erasing-page copy and its copy
    in the root panel's Features section. The cap changes which items are
    candidates at all, so without this the mini-map button keeps wearing the
    icon of something the eraser will no longer touch until the next bag update
    happens to clear it.
]]
function ns.OnValueCapToggled()
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

local function NoKindChecked()
	for _, kind in ipairs(ns.ERASE_KINDS) do
		if ns:IsJunkKind(kind[1]) then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------
-- Eraser Sections
--------------------------------------------------------------------------------

--[[
    The two Erasing-panel sections owned by Features/Junk-Rules.lua: What Counts as
    Junk, one checkbox per kind, two to a line, then Maximum Value to Erase.
    Manual Delete Assistance follows them from its own fragment, and Erase
    Confirmation closes the panel from ns.BuildEraseConfirmOptions below.
]]
function ns.BuildEraserOptions(args)
	args.spacerKinds0 = ns.OptionsSpacer(10)
	args.headerKinds = ns.OptionsHeader(L["OPTIONS_JUNK_HEADER"], 11)
	args.spacerKinds1 = ns.OptionsSpacer(12)
	args.descKinds = ns.OptionsDesc(L["OPTIONS_JUNK_DESCRIPTION"], 13)
	args.spacerKinds2 = ns.OptionsSpacer(14)

	args.descNoneChecked = {
		type = "description",
		name = GetColor("OFF") .. L["OPTIONS_KINDS_NONE_CHECKED"] .. "|r",
		fontSize = "medium",
		order = 15,
		hidden = function()
			return not NoKindChecked()
		end,
	}

	local toggles = {}
	for index, kind in ipairs(ns.ERASE_KINDS) do
		local deleteReason, labelKey, descKey = kind[1], kind[2], kind[3]
		toggles[index] = {
			type = "toggle",
			name = L[labelKey],
			desc = L[descKey] .. "\n\n" .. L["OPTIONS_KIND_UNCHECKED_DESCRIPTION"],
			get = function()
				return ns:IsJunkKind(deleteReason)
			end,
			set = function(_, value)
				SetJunkKind(deleteReason, value)
			end,
		}
	end
	ns.OptionsTogglePairs(args, "rowKinds", 15, toggles)

	--[[
	    Maximum Value to Erase. Both controls invalidate the scan cache and
	    repaint rather than only writing the setting (see ns.OnValueCapToggled).
	]]
	args.spacerValueCap0 = ns.OptionsSpacer(30)
	args.headerValueCap = ns.OptionsHeader(L["OPTIONS_VALUE_CAP_HEADER"], 31)
	args.spacerValueCap1 = ns.OptionsSpacer(32)
	args.descValueCap = ns.OptionsDesc(L["OPTIONS_VALUE_CAP_DESCRIPTION"], 33)
	args.spacerValueCap2 = ns.OptionsSpacer(34)

	--[[
	    The switch and its limit share one line, the switch at
	    ns.OPTIONS_LABEL_WIDTH where a caption would sit and the dropdown at
	    ns.OPTIONS_CONTROL_WIDTH, so the dropdown still ends where every other
	    row's does. The
	    dropdown hides while the switch is off: a setting for a feature that is
	    not running is not shown at all.
	]]
	args.toggleValueCap = ns.OptionsFeatureToggle(
		"valueCapEnabled",
		"OPTIONS_ENABLE_VALUE_CAP",
		"OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION",
		35,
		ns.OPTIONS_LABEL_WIDTH,
		ns.OnValueCapToggled
	)

	args.selectValueCap = {
		type = "select",
		name = "",
		desc = L["OPTIONS_VALUE_CAP_LIMIT_DESCRIPTION"],
		width = ns.OPTIONS_CONTROL_WIDTH,
		order = 36,
		hidden = ValueCapOff,
		values = VALUE_CAP_VALUES,
		sorting = VALUE_CAP_SORTING,
		get = function()
			return ns:GetValueCapGold()
		end,
		set = function(_, value)
			ns.db.profile.valueCapGold = value
			ns:InvalidateCache()
			ns:RefreshDisplay()
		end,
	}
end

--[[
    The last section on the Erasing panel. One switch for every erase, the
    Erase List included, rather than one per kind.
]]
function ns.BuildEraseConfirmOptions(args)
	args.spacerEraseConfirm0 = ns.OptionsSpacer(50)
	args.headerEraseConfirm = ns.OptionsHeader(L["OPTIONS_ERASE_CONFIRM_HEADER"], 51)
	args.spacerEraseConfirm1 = ns.OptionsSpacer(52)
	args.descEraseConfirm = ns.OptionsDesc(L["OPTIONS_ERASE_CONFIRM_DESCRIPTION"], 53)
	args.spacerEraseConfirm2 = ns.OptionsSpacer(54)
	args.toggleEraseConfirm = ns.OptionsFeatureToggle(
		"eraseConfirmEnabled",
		"OPTIONS_ENABLE_ERASE_CONFIRM",
		"OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION",
		55
	)
end
