local ADDON_NAME, ns = ...
local L = ns.L

local GetColor = ns.GetColor

--[[
    The four link rows split ns.OPTIONS_ROW_WIDTH unevenly: their labels are one
    short word, while the box beside them holds a full URL the player is meant to
    select and copy. The label takes 0.6 and the box takes the rest of the row,
    the remaining width the guide gives a read-only URL input, so the row still
    ends where every other row on the panel ends.
]]
local LINK_LABEL_WIDTH = 0.6
local LINK_URL_WIDTH = ns.OPTIONS_ROW_WIDTH - LINK_LABEL_WIDTH

--[[
    The feature sections on the root panel. Auto-Vend is the only one: everything
    governing how careful erasing is moved to the Safety panel, which is composed
    from the other five fragments the same way (see Options/Options-Safety.lua).
    A list of one rather than a bare call, so adding a second root section is an
    entry here instead of a change in shape.
]]
local FEATURE_SECTIONS = {
	"BuildAutoVendOptions",
}

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

--[[
    The root panel: the add-on's own settings at the top, every feature's
    settings merged in from its Options-{Feature-Name}.lua fragment, then
    Feedback & Support and the version line at the bottom. The fragments load
    before this file (see the TOC), so their builders exist by the time this
    runs.
]]
function ns.BuildGeneralOptions()
	local args = {
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
				LibStub("LibDBIcon-1.0"):Refresh(ADDON_NAME, ns.db.global.minimap)
			end,
		},

		spacerCommands0 = ns.OptionsSpacer(20),
		headerCommands = ns.OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], 21),
		spacerCommands1 = ns.OptionsSpacer(22),
		descCommands = ns.OptionsDesc(
			GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
			23
		),
	}

	for _, builder in ipairs(FEATURE_SECTIONS) do
		ns[builder](args)
	end

	-- Feedback & Support (Discord, GitHub, CurseForge, Wago, in that order)
	args.spacerFeedback0 = ns.OptionsSpacer(100)
	args.headerFeedback = ns.OptionsHeader(L["OPTIONS_FEEDBACK"], 101)
	args.spacerFeedback1 = ns.OptionsSpacer(102)
	args.labelDiscord = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_DISCORD"] .. "|r", 103, LINK_LABEL_WIDTH)
	args.linkDiscord = {
		type = "input",
		name = "",
		width = LINK_URL_WIDTH,
		order = 104,
		get = function()
			return ns.Links.DISCORD
		end,
		set = function() end,
	}
	args.spacerBetweenLinks1 = ns.OptionsSpacer(105)
	args.labelGitHub = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_GITHUB"] .. "|r", 106, LINK_LABEL_WIDTH)
	args.linkGitHub = {
		type = "input",
		name = "",
		width = LINK_URL_WIDTH,
		order = 107,
		get = function()
			return ns.Links.GITHUB
		end,
		set = function() end,
	}
	args.spacerBetweenLinks2 = ns.OptionsSpacer(108)
	args.labelCurseForge =
		ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_CURSEFORGE"] .. "|r", 109, LINK_LABEL_WIDTH)
	args.linkCurseForge = {
		type = "input",
		name = "",
		width = LINK_URL_WIDTH,
		order = 110,
		get = function()
			return ns.Links.CURSEFORGE
		end,
		set = function() end,
	}
	args.spacerBetweenLinks3 = ns.OptionsSpacer(111)
	args.labelWago = ns.OptionsRowLabel(GetColor("TITLE") .. L["OPTIONS_WAGO"] .. "|r", 112, LINK_LABEL_WIDTH)
	args.linkWago = {
		type = "input",
		name = "",
		width = LINK_URL_WIDTH,
		order = 113,
		get = function()
			return ns.Links.WAGO
		end,
		set = function() end,
	}

	args.spaceVersion0 = {
		type = "description",
		name = " ",
		width = "full",
		order = 998,
	}
	args.versionLine = {
		type = "description",
		name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
		fontSize = "medium",
		order = 999,
	}

	return {
		type = "group",
		name = ns.AddonTitle,
		args = args,
	}
end
