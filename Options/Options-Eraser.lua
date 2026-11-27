local _, ns = ...
local L = ns.L

local format, ipairs = string.format, ipairs

local Kit = ns.OptionsKit

-- sorting, or AceConfig orders by label text and lands "13 Gold" between "1 Gold" and "2 Gold".
local VALUE_CAP_VALUES, VALUE_CAP_SORTING = {}, {}

for index, gold in ipairs(ns.VALUE_CAP_CHOICES) do
	VALUE_CAP_VALUES[gold] = format(GOLD_AMOUNT, gold)
	VALUE_CAP_SORTING[index] = gold
end

local function SetJunkKind(deleteReason, isJunk)
	ns.db.profile.junkKinds[deleteReason] = isJunk
	ns:InvalidateCache()
	ns:RefreshDisplay()
	ns.RefreshSettings()
end

-- Run by its ns.FEATURES apply, so every copy of the switch invalidates and repaints.
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

	-- Both controls invalidate and repaint, not just write (ns.OnValueCapToggled).
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

function ns.BuildEraseConfirmOptions(args)
	Kit.Section(args, "EraseConfirm", 50, L["OPTIONS_ERASE_CONFIRM_HEADER"], L["OPTIONS_ERASE_CONFIRM_DESCRIPTION"])
	args.toggleEraseConfirm = Kit.FeatureSwitch("eraseConfirmEnabled", 55)
end
