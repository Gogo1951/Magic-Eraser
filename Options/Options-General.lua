local ADDON_NAME, ns = ...
local L = ns.L

local format, ipairs = string.format, ipairs

local GetColor = ns.GetColor

--[[
    A sub-option is a control that only means anything while the toggle above it
    is on, and it is marked two ways at once.

    The row leads with a blank indent cell, which moves the checkbox itself.
    Padding the label instead would indent only the caption -- AceConfig pins a
    checkbox at the left edge of its own widget -- leaving the box lined up with
    its parent's and the words drifting away from it.

    SubLabel then colors the caption HELP silver against the parent's white, so
    the row reads as subordinate rather than merely shifted. Silver is the
    palette's secondary-text role and is well clear of the dimmer gray AceGUI
    paints a genuinely disabled label.

    The whole row is wrapped in an inline group with no name, which AceConfig
    renders as a bare SimpleGroup -- no border, no title, no padding -- at "fill"
    width. That wrapper is load-bearing, not decoration. Laid out flat, the
    indent and its control are just two more widgets in the panel's flow, kept
    together only by their widths happening to fill the line; the pair after them
    then packs onto whatever space is left and its indent stops indenting
    anything. A fill widget always gets a line to itself, so one group per
    sub-option pins one row per sub-option no matter what the pane is doing.

    Inside the group the controls need slack rather than an exact fit: a row
    summing to the full pane width sits on the wrap boundary, where a pass that
    measures a control before its width is applied tips the control onto its own
    line and strands the indent above it.
]]
local function SubRow(order, hidden, controls)
	local args = {
		indent = {
			type = "description",
			name = " ",
			width = ns.OPTIONS_SUB_INDENT_WIDTH,
			order = 1,
		},
	}

	for index, control in ipairs(controls) do
		control.order = index + 1
		args["control" .. index] = control
	end

	return {
		type = "group",
		name = "",
		inline = true,
		order = order,
		hidden = hidden,
		args = args,
	}
end

local function SubLabel(text)
	return GetColor("HELP") .. text .. "|r"
end

local function AutoVendOff()
	return not (ns.db and ns.db.global.autoVendEnabled)
end

local function ValueCapOff()
	return not (ns.db and ns.db.global.valueCapEnabled)
end

local function BagsFullOff()
	return not (ns.db and ns.db.global.bagsFullNudgeEnabled)
end

local function SafetyOff()
	return not (ns.db and ns.db.global.safetyEnabled)
end

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
    The four link rows split ns.OPTIONS_ROW_WIDTH unevenly: their labels are one
    short word, while the box beside them holds a full URL the player is meant to
    select and copy. The label takes 0.6 so the box lands on exactly 2.0, the
    guide's double width for a read-only URL input, without the row outgrowing
    every other row on the panel.
]]
local LINK_LABEL_WIDTH = 0.6
local LINK_URL_WIDTH = ns.OPTIONS_ROW_WIDTH - LINK_LABEL_WIDTH

--[[
    Sub-row control widths, sized to their captions with room to spare rather
    than to the row budget -- see SubRow on why an exact fit is the one thing
    these must not do. Auto-Vend's row carries its message-mode dropdown beside
    the toggle, so the two share the line with the indent.
]]
local SUB_TOGGLE_WIDTH = 2.0
local AUTO_VEND_MESSAGE_MODE_WIDTH = 1.0
local AUTO_VEND_MESSAGES_WIDTH = 1.3

--[[
    The value cap's row is a caption beside a dropdown, the same shape as
    Auto-Vend's message row two sections above it, so it spends the same pair of
    widths and the two dropdowns line up with each other down the panel.
]]
local VALUE_CAP_LABEL_WIDTH = 1.3
local VALUE_CAP_SELECT_WIDTH = 1.0

--[[
    The bag-space row is a caption beside a slider, the same shape as the value
    cap's row above it, so it spends the same pair of widths and the two rows
    line up with each other down the panel.
]]
local BAGS_FULL_LABEL_WIDTH = 1.3
local BAGS_FULL_RANGE_WIDTH = 1.0

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

function ns.BuildGeneralOptions()
	return {
		type = "group",
		name = ns.AddonTitle,
		args = {
			descIntro = ns.OptionsDesc(L["OPTIONS_DESCRIPTION"], 1),

			spacerWelcome0 = ns.OptionsSpacer(5),
			toggleWelcome = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_WELCOME"],
				width = "full",
				order = 6,
				get = function()
					return ns.db and ns.db.global.showWelcome
				end,
				set = function(_, value)
					ns.db.global.showWelcome = value
				end,
			},
			toggleMinimap = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_MINIMAP"],
				width = "full",
				order = 7,
				get = function()
					return ns.db and not ns.db.global.minimap.hide
				end,
				set = function(_, value)
					ns.db.global.minimap.hide = not value
					if value then
						LibStub("LibDBIcon-1.0"):Show(ADDON_NAME)
					else
						LibStub("LibDBIcon-1.0"):Hide(ADDON_NAME)
					end
				end,
			},
			spacerCommands0 = ns.OptionsSpacer(20),
			headerCommands = ns.OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], 21),
			spacerCommands1 = ns.OptionsSpacer(22),
			descCommands = ns.OptionsDesc(
				GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
				23
			),

			spacerAutoVend0 = ns.OptionsSpacer(30),
			headerAutoVend = ns.OptionsHeader(L["AUTO_VEND"], 31),
			spacerAutoVend1 = ns.OptionsSpacer(32),
			descAutoVend = ns.OptionsDesc(L["AUTO_VEND_DESCRIPTION"], 33),
			spacerAutoVend2 = ns.OptionsSpacer(34),
			toggleAutoVend = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_AUTO_VEND"],
				width = "full",
				order = 35,
				get = function()
					return ns.db and ns.db.global.autoVendEnabled
				end,
				set = function(_, value)
					ns.db.global.autoVendEnabled = value
				end,
			},
			rowAutoVendMessages = SubRow(36, AutoVendOff, {
				{
					type = "toggle",
					name = SubLabel(L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"]),
					width = AUTO_VEND_MESSAGES_WIDTH,
					get = function()
						return ns.db and ns.db.global.autoVendMessagesEnabled
					end,
					set = function(_, value)
						ns.db.global.autoVendMessagesEnabled = value
					end,
				},
				{
					type = "select",
					name = "",
					width = AUTO_VEND_MESSAGE_MODE_WIDTH,
					values = {
						verbose = L["OPTIONS_AUTO_VEND_LINE_ITEM"],
						summary = L["OPTIONS_AUTO_VEND_SUMMARY"],
					},
					sorting = { "verbose", "summary" },
					disabled = function()
						return not (ns.db and ns.db.global.autoVendMessagesEnabled)
					end,
					get = function()
						return (ns.db and ns.db.global.autoVendSummaryEnabled) and "summary" or "verbose"
					end,
					set = function(_, value)
						ns.db.global.autoVendSummaryEnabled = (value == "summary")
					end,
				},
			}),

			--[[
			    Maximum Value to Erase. Both controls invalidate the scan cache
			    and repaint rather than only writing the setting: the cap changes
			    which items are candidates at all, so without this the mini-map
			    button keeps wearing the icon of something the eraser will no
			    longer touch until the next bag update happens to clear it.
			]]
			spacerValueCap0 = ns.OptionsSpacer(40),
			headerValueCap = ns.OptionsHeader(L["OPTIONS_VALUE_CAP_HEADER"], 41),
			spacerValueCap1 = ns.OptionsSpacer(42),
			descValueCap = ns.OptionsDesc(L["OPTIONS_VALUE_CAP_DESCRIPTION"], 43),
			spacerValueCap2 = ns.OptionsSpacer(44),
			toggleValueCap = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_VALUE_CAP"],
				width = "full",
				order = 45,
				get = function()
					return ns.db and ns.db.global.valueCapEnabled
				end,
				set = function(_, value)
					ns.db.global.valueCapEnabled = value
					ns:InvalidateCache()
					ns:RefreshDisplay()
				end,
			},
			rowValueCapLimit = SubRow(46, ValueCapOff, {
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
			}),

			spacerBank0 = ns.OptionsSpacer(50),
			headerBank = ns.OptionsHeader(L["OPTIONS_BANK_HEADER"], 51),
			spacerBank1 = ns.OptionsSpacer(52),
			descBank = ns.OptionsDesc(L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"], 53),
			spacerBank2 = ns.OptionsSpacer(54),
			toggleBankRetrieval = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_BANK_RETRIEVAL"],
				width = "full",
				order = 55,
				get = function()
					return ns.db and ns.db.global.bankRetrievalEnabled
				end,
				set = function(_, value)
					ns.db.global.bankRetrievalEnabled = value
				end,
			},

			spacerTooltip0 = ns.OptionsSpacer(60),
			headerTooltip = ns.OptionsHeader(L["OPTIONS_TOOLTIP_HEADER"], 61),
			spacerTooltip1 = ns.OptionsSpacer(62),
			descTooltip = ns.OptionsDesc(L["OPTIONS_TOOLTIP_DESCRIPTION"], 63),
			spacerTooltip2 = ns.OptionsSpacer(64),
			toggleTooltipWarning = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_TOOLTIPS"],
				width = "full",
				order = 65,
				get = function()
					return ns.db and ns.db.global.tooltipWarningEnabled
				end,
				set = function(_, value)
					ns.db.global.tooltipWarningEnabled = value
				end,
			},

			spacerBagsFull0 = ns.OptionsSpacer(70),
			headerBagsFull = ns.OptionsHeader(L["OPTIONS_BAGS_FULL_HEADER"], 71),
			spacerBagsFull1 = ns.OptionsSpacer(72),
			descBagsFull = ns.OptionsDesc(L["OPTIONS_BAGS_FULL_DESCRIPTION"], 73),
			spacerBagsFull2 = ns.OptionsSpacer(74),
			toggleBagsFullNudge = {
				type = "toggle",
				name = L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"],
				width = "full",
				order = 75,
				get = function()
					return ns.db and ns.db.global.bagsFullNudgeEnabled
				end,
				set = function(_, value)
					ns.db.global.bagsFullNudgeEnabled = value
				end,
			},
			rowBagsFullThreshold = SubRow(76, BagsFullOff, {
				ns.OptionsRowLabel(SubLabel(L["OPTIONS_BAGS_FULL_THRESHOLD"]), nil, BAGS_FULL_LABEL_WIDTH),
				{
					type = "range",
					name = "",
					width = BAGS_FULL_RANGE_WIDTH,
					min = 1,
					max = 10,
					step = 1,
					get = function()
						return ns.db and ns.db.global.bagsFullThreshold
					end,
					set = function(_, value)
						ns.db.global.bagsFullThreshold = value
					end,
				},
			}),

			spacerSafety0 = ns.OptionsSpacer(80),
			headerSafety = ns.OptionsHeader(L["OPTIONS_SAFETY_HEADER"], 81),
			spacerSafety1 = ns.OptionsSpacer(82),
			descSafety = ns.OptionsDesc(L["OPTIONS_SAFETY_DESCRIPTION"], 83),
			spacerSafety2 = ns.OptionsSpacer(84),
			toggleSafety = {
				type = "toggle",
				name = GetColor("TEXT") .. L["OPTIONS_ENABLE_SAFETY"] .. "|r",
				width = "full",
				order = 85,
				get = function()
					return ns.db and ns.db.global.safetyEnabled
				end,
				set = function(_, value)
					ns.db.global.safetyEnabled = value
				end,
			},
			rowSafetyQuest = SubRow(86, SafetyOff, {
				{
					type = "toggle",
					name = SubLabel(L["OPTIONS_SAFETY_QUEST"]),
					width = SUB_TOGGLE_WIDTH,
					get = function()
						return ns.db and ns.db.global.safetyQuest
					end,
					set = function(_, value)
						ns.db.global.safetyQuest = value
					end,
				},
			}),
			rowSafetyConsumable = SubRow(87, SafetyOff, {
				{
					type = "toggle",
					name = SubLabel(L["OPTIONS_SAFETY_CONSUMABLE"]),
					width = SUB_TOGGLE_WIDTH,
					get = function()
						return ns.db and ns.db.global.safetyConsumable
					end,
					set = function(_, value)
						ns.db.global.safetyConsumable = value
					end,
				},
			}),
			rowSafetyWhite = SubRow(88, SafetyOff, {
				{
					type = "toggle",
					name = SubLabel(L["OPTIONS_SAFETY_WHITE"]),
					width = SUB_TOGGLE_WIDTH,
					get = function()
						return ns.db and ns.db.global.safetyWhite
					end,
					set = function(_, value)
						ns.db.global.safetyWhite = value
					end,
				},
			}),
			rowSafetyGray = SubRow(89, SafetyOff, {
				{
					type = "toggle",
					name = SubLabel(L["OPTIONS_SAFETY_GRAY"]),
					width = SUB_TOGGLE_WIDTH,
					get = function()
						return ns.db and ns.db.global.safetyGray
					end,
					set = function(_, value)
						ns.db.global.safetyGray = value
					end,
				},
			}),

			-- Feedback & Support (Discord, GitHub, CurseForge, Wago, in that order)
			spacerFeedback0 = ns.OptionsSpacer(90),
			headerFeedback = ns.OptionsHeader(L["OPTIONS_FEEDBACK"], 91),
			spacerFeedback1 = ns.OptionsSpacer(92),
			labelDiscord = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_DISCORD"] .. "|r", 93, LINK_LABEL_WIDTH),
			linkDiscord = {
				type = "input",
				name = "",
				width = LINK_URL_WIDTH,
				order = 94,
				get = function()
					return ns.Links.DISCORD
				end,
				set = function() end,
			},
			spacerBetweenLinks1 = ns.OptionsSpacer(95),
			labelGitHub = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_GITHUB"] .. "|r", 96, LINK_LABEL_WIDTH),
			linkGitHub = {
				type = "input",
				name = "",
				width = LINK_URL_WIDTH,
				order = 97,
				get = function()
					return ns.Links.GITHUB
				end,
				set = function() end,
			},
			spacerBetweenLinks2 = ns.OptionsSpacer(98),
			labelCurseForge = ns.OptionsRowLabel(
				GetColor("TITLE") .. L["OPTIONS_CURSEFORGE"] .. "|r",
				99,
				LINK_LABEL_WIDTH
			),
			linkCurseForge = {
				type = "input",
				name = "",
				width = LINK_URL_WIDTH,
				order = 100,
				get = function()
					return ns.Links.CURSEFORGE
				end,
				set = function() end,
			},
			spacerBetweenLinks3 = ns.OptionsSpacer(101),
			labelWago = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_WAGO"] .. "|r", 102, LINK_LABEL_WIDTH),
			linkWago = {
				type = "input",
				name = "",
				width = LINK_URL_WIDTH,
				order = 103,
				get = function()
					return ns.Links.WAGO
				end,
				set = function() end,
			},

			spaceVersion0 = {
				type = "description",
				name = " ",
				width = "full",
				order = 998,
			},
			versionLine = {
				type = "description",
				name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
				fontSize = "medium",
				order = 999,
			},
		},
	}
end
