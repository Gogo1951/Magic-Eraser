local _, ns = ...
local L = ns.L

local format, ipairs = string.format, ipairs

local Kit = ns.OptionsKit

--[[
    The value cap's dropdown, built once from ns.VALUE_CAP_CHOICES rather than
    typed out twice. values is keyed by the gold amount the setting stores, and
    sorting repeats those keys in run order because AceConfig otherwise orders a
    dropdown by its labels -- which sorts them as text, landing "13 Gold"
    between "1 Gold" and "2 Gold".
]]
local VALUE_CAP_VALUES, VALUE_CAP_SORTING = {}, {}

for index, gold in ipairs(ns.VALUE_CAP_CHOICES) do
	VALUE_CAP_VALUES[gold] = format(GOLD_AMOUNT, gold)
	VALUE_CAP_SORTING[index] = gold
end

--[[
    A kind's checkbox changes what counts as junk at all, so it drops the scan
    cache and repaints like the value cap does: the mini-map icon moves on the
    spot. Ends in ns.RefreshSettings like every other writer.
]]
local function SetJunkKind(deleteReason, isJunk)
	ns.db.profile.junkKinds[deleteReason] = isJunk
	ns:InvalidateCache()
	ns:RefreshDisplay()
	ns.RefreshSettings()
end

--[[
    The value-cap switch's side effect, run by its ns.FEATURES apply, so every
    copy of the switch (its Erasing page, the root panel's Features section and
    the mini-map menu's More Features) shares it. The cap changes which items are
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
    Skip Typing DELETE follows them from its own fragment, and Erase
    Confirmation closes the panel from ns.BuildEraseConfirmOptions below.
]]
function ns.BuildEraserOptions(args)
	Kit.Section(args, "Kinds", 10, L["OPTIONS_JUNK_HEADER"], L["OPTIONS_JUNK_DESCRIPTION"])
	args.descNoneChecked = Kit.WarningLine(L["OPTIONS_KINDS_NONE_CHECKED"], NoKindChecked, 15)

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
	args.rowKinds = Kit.Pairs(16, nil, toggles)

	--[[
	    Maximum Value to Erase. Both controls invalidate the scan cache and
	    repaint rather than only writing the setting (see ns.OnValueCapToggled).
	    The switch and its limit share one line (Kit.ToggleRow); the dropdown
	    hides while the switch is off: a setting for a feature that is not
	    running is not shown at all.
	]]
	Kit.Section(args, "ValueCap", 30, L["OPTIONS_VALUE_CAP_HEADER"], L["OPTIONS_VALUE_CAP_DESCRIPTION"])
	args.rowValueCap = Kit.ToggleRow(35, Kit.FeatureSwitch("valueCapEnabled"), {
		control = {
			type = "select",
			desc = L["OPTIONS_VALUE_CAP_LIMIT_DESCRIPTION"],
			values = VALUE_CAP_VALUES,
			sorting = VALUE_CAP_SORTING,
			get = function()
				return ns:GetValueCapGold()
			end,
			set = function(_, value)
				ns.db.profile.valueCapGold = value
				ns:InvalidateCache()
				ns:RefreshDisplay()
				ns.RefreshSettings()
			end,
		},
	})
end

--[[
    The last section on the Erasing panel. One switch for every erase, the
    Erase List included, rather than one per kind.
]]
function ns.BuildEraseConfirmOptions(args)
	Kit.Section(args, "EraseConfirm", 50, L["OPTIONS_ERASE_CONFIRM_HEADER"], L["OPTIONS_ERASE_CONFIRM_DESCRIPTION"])
	args.toggleEraseConfirm = Kit.FeatureSwitch("eraseConfirmEnabled", 55)
end
