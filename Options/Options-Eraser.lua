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

--[[
    The three choices every kind row offers, in the order the dropdown lists
    them: least cautious to most.
]]
local ACTION_VALUES = {
	[ns.ERASE_ACTION_ERASE] = L["OPTIONS_KIND_ERASE"],
	[ns.ERASE_ACTION_ASK] = L["OPTIONS_KIND_ASK"],
	[ns.ERASE_ACTION_KEEP] = L["OPTIONS_KIND_KEEP"],
}
local ACTION_SORTING = { ns.ERASE_ACTION_ERASE, ns.ERASE_ACTION_ASK, ns.ERASE_ACTION_KEEP }

local function ValueCapOff()
	return not (ns.db and ns.db.profile.valueCapEnabled)
end

--[[
    A kind's choice changes what counts as junk at all, so it drops the scan
    cache and repaints like the value cap does: the mini-map icon and the Your
    Current Bags queue move on the spot.
]]
local function SetEraseAction(deleteReason, action)
	ns.db.profile.eraseActions[deleteReason] = action
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

local function EveryKindKept()
	for _, kind in ipairs(ns.ERASE_KINDS) do
		if ns:GetEraseAction(kind[1]) ~= ns.ERASE_ACTION_KEEP then
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
    Junk, one row per kind with Erase, Ask First or Keep, then Maximum Value to
    Erase. Manual Delete Assistance follows them from its own fragment.

    One dropdown per kind covers erasing, asking first, and taking the kind out
    of the junk pile entirely.
]]
function ns.BuildEraserOptions(args)
	args.spacerKinds0 = ns.OptionsSpacer(10)
	args.headerKinds = ns.OptionsHeader(L["OPTIONS_JUNK_HEADER"], 11)
	args.spacerKinds1 = ns.OptionsSpacer(12)
	args.descKinds = ns.OptionsDesc(L["OPTIONS_JUNK_DESCRIPTION"], 13)
	args.spacerKinds2 = ns.OptionsSpacer(14)

	args.descAllKept = {
		type = "description",
		name = GetColor("OFF") .. L["OPTIONS_KINDS_ALL_KEPT"] .. "|r",
		fontSize = "medium",
		order = 15,
		hidden = function()
			return not EveryKindKept()
		end,
	}

	--[[
	    Standard one-line rows, a caption at ns.OPTIONS_LABEL_WIDTH beside a
	    dropdown at ns.OPTIONS_CONTROL_WIDTH. Not sub-rows: no switch above
	    them gates these, so they take no indent and no gray caption.
	]]
	for index, kind in ipairs(ns.ERASE_KINDS) do
		local deleteReason, labelKey, descKey = kind[1], kind[2], kind[3]
		local order = 14 + index * 2
		args["labelKind" .. index] = ns.OptionsRowLabel(GetColor("TEXT") .. L[labelKey] .. "|r", order)
		args["selectKind" .. index] = {
			type = "select",
			name = "",
			desc = L[descKey] .. "\n\n" .. L["OPTIONS_KIND_ACTION_DESC"],
			width = ns.OPTIONS_CONTROL_WIDTH,
			order = order + 1,
			values = ACTION_VALUES,
			sorting = ACTION_SORTING,
			get = function()
				return ns:GetEraseAction(deleteReason)
			end,
			set = function(_, value)
				SetEraseAction(deleteReason, value)
			end,
		}
	end

	--[[
	    Maximum Value to Erase. Both controls invalidate the scan cache and
	    repaint rather than only writing the setting: the cap changes which items
	    are candidates at all, so without this the mini-map button keeps wearing
	    the icon of something the eraser will no longer touch until the next bag
	    update happens to clear it.
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
		"OPTIONS_ENABLE_VALUE_CAP_DESC",
		35,
		ns.OPTIONS_LABEL_WIDTH,
		function()
			ns:InvalidateCache()
			ns:RefreshDisplay()
		end
	)

	args.selectValueCap = {
		type = "select",
		name = "",
		desc = L["OPTIONS_VALUE_CAP_LIMIT_DESC"],
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
