local ADDON_NAME, ns = ...
local L = ns.L

local GetColor = ns.GetColor

-- Leading indent that marks a checkbox as a sub-option of the one above it.
-- Kept white (not grayed) so it reads as nested rather than disabled.
local SUB_INDENT = "      "

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
				name = L["OPTIONS_WELCOME"],
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
				name = L["OPTIONS_MINIMAP"],
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
				GetColor("INFO")
					.. L["OPTIONS_COMMAND_ERASER"]
					.. "|r"
					.. "  "
					.. L["OPTIONS_COMMAND_ERASER_DESCRIPTION"],
				23
			),

			spacerTooltip0 = ns.OptionsSpacer(24),
			headerTooltip = ns.OptionsHeader(L["OPTIONS_TOOLTIP_HEADER"], 25),
			spacerTooltip1 = ns.OptionsSpacer(26),
			--[[
				A live sample of the tooltip line, composed exactly as
				Features/Item-Tooltips.lua renders the Ignore List protection notice
				(ns.BrandPrefix + a colored body), so the panel shows the real line
				a player sees on a protected item.
			]]
			exampleTooltip = ns.OptionsDesc(ns.BrandPrefix .. GetColor("TEXT") .. L["TOOLTIP_IGNORED"] .. "|r", 27),
			spacerTooltip2 = ns.OptionsSpacer(28),
			toggleTooltipWarning = {
				type = "toggle",
				name = L["OPTIONS_TOOLTIP_WARNING"],
				width = "full",
				order = 29,
				get = function()
					return ns.db and ns.db.global.tooltipWarningEnabled
				end,
				set = function(_, value)
					ns.db.global.tooltipWarningEnabled = value
				end,
			},

			spacerAutoVend0 = ns.OptionsSpacer(30),
			headerAutoVend = ns.OptionsHeader(L["AUTO_VEND"], 31),
			spacerAutoVend1 = ns.OptionsSpacer(32),
			descAutoVend = ns.OptionsDesc(L["OPTIONS_AUTO_VEND_DESCRIPTION"], 33),
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
			toggleAutoVendMessages = {
				type = "toggle",
				name = SUB_INDENT .. L["OPTIONS_AUTO_VEND_MESSAGES"],
				width = "double",
				order = 36,
				hidden = function()
					return not (ns.db and ns.db.global.autoVendEnabled)
				end,
				get = function()
					return ns.db and ns.db.global.autoVendMessagesEnabled
				end,
				set = function(_, value)
					ns.db.global.autoVendMessagesEnabled = value
				end,
			},
			selectAutoVendMessageMode = {
				type = "select",
				name = "",
				width = "normal",
				order = 37,
				values = {
					verbose = L["OPTIONS_AUTO_VEND_VERBOSE"],
					summary = L["OPTIONS_AUTO_VEND_SUMMARY"],
				},
				sorting = { "verbose", "summary" },
				hidden = function()
					return not (ns.db and ns.db.global.autoVendEnabled)
				end,
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

			spacerBagsFull0 = ns.OptionsSpacer(40),
			headerBagsFull = ns.OptionsHeader(L["OPTIONS_BAGS_FULL_HEADER"], 41),
			spacerBagsFull1 = ns.OptionsSpacer(42),
			--[[
			    A live sample of the warning, composed exactly as PrintMessage
			    renders it (ns.BrandPrefix + TEXT-colored body) so the panel shows
			    the real chat line. Built from the same BAGS_FULL_NUDGE string the
			    warning uses -- with a stand-in count of 3 -- so the example tracks
			    any future wording change instead of drifting from it.
			]]
			exampleBagsFull = ns.OptionsDesc(
				ns.BrandPrefix .. GetColor("TEXT") .. string.format(L["BAGS_FULL_NUDGE"], 3) .. "|r",
				43
			),
			spacerBagsFull2 = ns.OptionsSpacer(44),
			toggleBagsFullNudge = {
				type = "toggle",
				name = L["OPTIONS_BAGS_FULL_NUDGE"],
				width = "full",
				order = 45,
				get = function()
					return ns.db and ns.db.global.bagsFullNudgeEnabled
				end,
				set = function(_, value)
					ns.db.global.bagsFullNudgeEnabled = value
				end,
			},
			rangeBagsFullThreshold = {
				type = "range",
				name = L["OPTIONS_BAGS_FULL_THRESHOLD"],
				width = "full",
				order = 46,
				min = 1,
				max = 10,
				step = 1,
				hidden = function()
					return not (ns.db and ns.db.global.bagsFullNudgeEnabled)
				end,
				get = function()
					return ns.db and ns.db.global.bagsFullThreshold
				end,
				set = function(_, value)
					ns.db.global.bagsFullThreshold = value
				end,
			},

			spacerSafety0 = ns.OptionsSpacer(60),
			headerSafety = ns.OptionsHeader(L["OPTIONS_SAFETY_HEADER"], 61),
			spacerSafety1 = ns.OptionsSpacer(62),
			descSafety = ns.OptionsDesc(L["OPTIONS_SAFETY_DESCRIPTION"], 63),
			spacerSafety2 = ns.OptionsSpacer(64),
			toggleSafety = {
				type = "toggle",
				name = GetColor("TEXT") .. L["OPTIONS_ENABLE_SAFETY"] .. "|r",
				width = "full",
				order = 65,
				get = function()
					return ns.db and ns.db.global.safetyEnabled
				end,
				set = function(_, value)
					ns.db.global.safetyEnabled = value
				end,
			},
			toggleSafetyQuest = {
				type = "toggle",
				name = SUB_INDENT .. L["OPTIONS_SAFETY_QUEST"],
				width = "full",
				order = 66,
				hidden = function()
					return not (ns.db and ns.db.global.safetyEnabled)
				end,
				get = function()
					return ns.db and ns.db.global.safetyQuest
				end,
				set = function(_, value)
					ns.db.global.safetyQuest = value
				end,
			},
			toggleSafetyConsumable = {
				type = "toggle",
				name = SUB_INDENT .. L["OPTIONS_SAFETY_CONSUMABLE"],
				width = "full",
				order = 67,
				hidden = function()
					return not (ns.db and ns.db.global.safetyEnabled)
				end,
				get = function()
					return ns.db and ns.db.global.safetyConsumable
				end,
				set = function(_, value)
					ns.db.global.safetyConsumable = value
				end,
			},
			toggleSafetyWhite = {
				type = "toggle",
				name = SUB_INDENT .. L["OPTIONS_SAFETY_WHITE"],
				width = "full",
				order = 68,
				hidden = function()
					return not (ns.db and ns.db.global.safetyEnabled)
				end,
				get = function()
					return ns.db and ns.db.global.safetyWhite
				end,
				set = function(_, value)
					ns.db.global.safetyWhite = value
				end,
			},
			toggleSafetyGray = {
				type = "toggle",
				name = SUB_INDENT .. L["OPTIONS_SAFETY_GRAY"],
				width = "full",
				order = 69,
				hidden = function()
					return not (ns.db and ns.db.global.safetyEnabled)
				end,
				get = function()
					return ns.db and ns.db.global.safetyGray
				end,
				set = function(_, value)
					ns.db.global.safetyGray = value
				end,
			},

			-- Feedback & Support (Discord, GitHub, CurseForge, Wago, in that order)
			spacerFeedback0 = ns.OptionsSpacer(90),
			headerFeedback = ns.OptionsHeader(L["OPTIONS_FEEDBACK"], 91),
			spacerFeedback1 = ns.OptionsSpacer(92),
			labelDiscord = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_DISCORD"] .. "|r", 93),
			linkDiscord = {
				type = "input",
				name = "",
				width = "double",
				order = 94,
				get = function()
					return ns.Links.DISCORD
				end,
				set = function() end,
			},
			spacerFeedback2 = ns.OptionsSpacer(95),
			labelGitHub = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_GITHUB"] .. "|r", 96),
			linkGitHub = {
				type = "input",
				name = "",
				width = "double",
				order = 97,
				get = function()
					return ns.Links.GITHUB
				end,
				set = function() end,
			},
			spacerFeedback3 = ns.OptionsSpacer(98),
			labelCurseForge = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_CURSEFORGE"] .. "|r", 99),
			linkCurseForge = {
				type = "input",
				name = "",
				width = "double",
				order = 100,
				get = function()
					return ns.Links.CURSEFORGE
				end,
				set = function() end,
			},
			spacerFeedback4 = ns.OptionsSpacer(101),
			labelWago = ns.OptionsDesc(GetColor("TITLE") .. L["OPTIONS_WAGO"] .. "|r", 102),
			linkWago = {
				type = "input",
				name = "",
				width = "double",
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
