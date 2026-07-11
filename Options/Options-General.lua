local _, ns = ...
local L = ns.L

local GetColor = ns.GetColor

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
					return ns.db and ns.db.profile.showWelcome
				end,
				set = function(_, value)
					ns.db.profile.showWelcome = value
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
						LibStub("LibDBIcon-1.0"):Show("MagicEraser")
					else
						LibStub("LibDBIcon-1.0"):Hide("MagicEraser")
					end
				end,
			},

			spacerCommands0 = ns.OptionsSpacer(20),
			headerCommands = ns.OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], 21),
			spacerCommands1 = ns.OptionsSpacer(22),
			descCommands = ns.OptionsDesc(
				GetColor("INFO") .. L["OPTIONS_CMD_ERASER"] .. "|r" .. "  " .. L["OPTIONS_CMD_ERASER_DESCRIPTION"],
				23
			),

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
					return ns.db and ns.db.profile.autoVendEnabled
				end,
				set = function(_, value)
					ns.db.profile.autoVendEnabled = value
				end,
			},
			toggleAutoVendMessages = {
				type = "toggle",
				name = L["OPTIONS_AUTO_VEND_MESSAGES"],
				width = "full",
				order = 36,
				hidden = function()
					return not (ns.db and ns.db.profile.autoVendEnabled)
				end,
				get = function()
					return ns.db and ns.db.profile.autoVendMessagesEnabled
				end,
				set = function(_, value)
					ns.db.profile.autoVendMessagesEnabled = value
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
