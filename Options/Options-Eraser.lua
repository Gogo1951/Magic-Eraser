local _, ns = ...
local L = ns.L

local format, ipairs = string.format, ipairs

local GetColor = ns.GetColor
local SubRow, SubLabel = ns.OptionsSubRow, ns.OptionsSubLabel

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
    The value cap's row is a caption beside a dropdown, so it spends the label
    and control widths every captioned row on the Safety panel spends, and the
    dropdowns line up with each other down the panel.
]]
local VALUE_CAP_LABEL_WIDTH = 1.3
local VALUE_CAP_SELECT_WIDTH = 1.0

-- Sized to its caption with room to spare, per ns.OptionsSubRow.
local SUB_TOGGLE_WIDTH = 2.0

local function ValueCapOff()
	return not (ns.db and ns.db.global.valueCapEnabled)
end

local function SafetyOff()
	return not (ns.db and ns.db.global.safetyEnabled)
end

--[[
    One sub-toggle per erase reason, all four the same shape, so they are built
    from a table rather than written out four times. The locale keys are string
    values here rather than literal L["..."] reads, the same way ALERT_KEYS
    carries them in Features/Eraser.lua; search the key name, not the L[] form.
]]
local SAFETY_TOGGLES = {
	-- { argKey, order, labelKey, settingKey }
	{ "rowSafetyQuest", 46, "OPTIONS_SAFETY_QUEST", "safetyQuest" },
	{ "rowSafetyConsumable", 47, "OPTIONS_SAFETY_CONSUMABLE", "safetyConsumable" },
	{ "rowSafetyWhite", 48, "OPTIONS_SAFETY_WHITE", "safetyWhite" },
	{ "rowSafetyGray", 49, "OPTIONS_SAFETY_GRAY", "safetyGray" },
}

--------------------------------------------------------------------------------
-- Eraser Sections
--------------------------------------------------------------------------------

--[[
    The two Safety-panel sections owned by Features/Eraser.lua, fourth and fifth
    on that panel: Mini-map Eraser Confirmation, which decides what the eraser
    asks about before it acts, then Maximum Value to Erase, which decides what it
    may pick at all. They share a file because they share a feature, and they sit
    adjacent by their order numbers rather than by being written together.
]]
function ns.BuildEraserOptions(args)
	args.spacerSafety0 = ns.OptionsSpacer(40)
	args.headerSafety = ns.OptionsHeader(L["OPTIONS_SAFETY_HEADER"], 41)
	args.spacerSafety1 = ns.OptionsSpacer(42)
	args.descSafety = ns.OptionsDesc(L["OPTIONS_SAFETY_DESCRIPTION"], 43)
	args.spacerSafety2 = ns.OptionsSpacer(44)

	args.toggleSafety = {
		type = "toggle",
		name = GetColor("TEXT") .. L["OPTIONS_ENABLE_SAFETY"] .. "|r",
		width = "full",
		order = 45,
		get = function()
			return ns.db and ns.db.global.safetyEnabled
		end,
		set = function(_, value)
			ns.db.global.safetyEnabled = value
		end,
	}

	for _, entry in ipairs(SAFETY_TOGGLES) do
		local argKey, order, labelKey, settingKey = entry[1], entry[2], entry[3], entry[4]
		args[argKey] = SubRow(order, SafetyOff, {
			{
				type = "toggle",
				name = SubLabel(L[labelKey]),
				width = SUB_TOGGLE_WIDTH,
				get = function()
					return ns.db and ns.db.global[settingKey]
				end,
				set = function(_, value)
					ns.db.global[settingKey] = value
				end,
			},
		})
	end

	--[[
	    Maximum Value to Erase. Both controls invalidate the scan cache and
	    repaint rather than only writing the setting: the cap changes which items
	    are candidates at all, so without this the mini-map button keeps wearing
	    the icon of something the eraser will no longer touch until the next bag
	    update happens to clear it.
	]]
	args.spacerValueCap0 = ns.OptionsSpacer(50)
	args.headerValueCap = ns.OptionsHeader(L["OPTIONS_VALUE_CAP_HEADER"], 51)
	args.spacerValueCap1 = ns.OptionsSpacer(52)
	args.descValueCap = ns.OptionsDesc(L["OPTIONS_VALUE_CAP_DESCRIPTION"], 53)
	args.spacerValueCap2 = ns.OptionsSpacer(54)

	args.toggleValueCap = {
		type = "toggle",
		name = L["OPTIONS_ENABLE_VALUE_CAP"],
		width = "full",
		order = 55,
		get = function()
			return ns.db and ns.db.global.valueCapEnabled
		end,
		set = function(_, value)
			ns.db.global.valueCapEnabled = value
			ns:InvalidateCache()
			ns:RefreshDisplay()
		end,
	}

	args.rowValueCapLimit = SubRow(56, ValueCapOff, {
		ns.OptionsRowLabel(SubLabel(L["OPTIONS_VALUE_CAP_LIMIT"]), nil, VALUE_CAP_LABEL_WIDTH),
		{
			type = "select",
			name = "",
			width = VALUE_CAP_SELECT_WIDTH,
			values = VALUE_CAP_VALUES,
			sorting = VALUE_CAP_SORTING,
			get = function()
				return ns.db and ns.db.global.valueCapGold
			end,
			set = function(_, value)
				ns.db.global.valueCapGold = value
				ns:InvalidateCache()
				ns:RefreshDisplay()
			end,
		},
	})
end
