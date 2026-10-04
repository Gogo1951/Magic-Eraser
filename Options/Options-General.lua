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

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

--[[
    Every feature's on/off switch, two to a line, so the front page shows at a
    glance what Magic Eraser is doing. Each is built by ns.OptionsFeatureToggle,
    as on its own page, so the two copies share one setting, caption and
    tooltip; the Bag-Space Warnings section also passes an onSet this copy
    doesn't. Listed Merchant & Bank first, then Erasing's Maximum Value to Erase,
    Manual Delete Assistance and Erase Confirmation, then Alerts & Tooltips.
]]
local FEATURE_TOGGLES = {
	-- { settingKey, nameKey, descKey, onSet }
	{ "autoVendEnabled", "OPTIONS_ENABLE_AUTO_VEND", "OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION" },
	{ "bankRetrievalEnabled", "OPTIONS_ENABLE_BANK_RETRIEVAL", "OPTIONS_ENABLE_BANK_RETRIEVAL_DESCRIPTION" },
	{ "valueCapEnabled", "OPTIONS_ENABLE_VALUE_CAP", "OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION", ns.OnValueCapToggled },
	{
		"manualDeleteAutoFillEnabled",
		"OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL",
		"OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION",
	},
	{ "eraseConfirmEnabled", "OPTIONS_ENABLE_ERASE_CONFIRM", "OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION" },
	{ "tooltipWarningEnabled", "OPTIONS_ENABLE_TOOLTIPS", "OPTIONS_ENABLE_TOOLTIPS_DESCRIPTION" },
	{ "questAlertsEnabled", "OPTIONS_ENABLE_QUEST_ALERTS", "OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION" },
	{ "bagsFullNudgeEnabled", "OPTIONS_ENABLE_BAGS_FULL_WARNINGS", "OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION" },
}

local function AddFeatureToggles(args, startOrder)
	local toggles = {}
	for index, entry in ipairs(FEATURE_TOGGLES) do
		toggles[index] = ns.OptionsFeatureToggle(entry[1], entry[2], entry[3], nil, nil, entry[4])
	end
	ns.OptionsTogglePairs(args, "rowFeatures", startOrder, toggles)
end

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

--[[
    A binding cannot be set from an AceConfig panel, so each row shows the key
    the player bound, or a muted Not Bound, and a Set Key button that opens the
    game's Key Bindings list through ns:OpenKeyBindings (Features/Key-Bindings.lua),
    which tries each route the clients use and prints where to look if none
    works. The binding names come from Bindings.xml's name attributes; the
    captions are the same BINDING_* strings the Key Bindings list prints.
    ns:OnUpdateBindings repaints this panel when the player changes a key.
]]
local KEY_BINDINGS = {
	-- { bindingName, captionKey, descKey }
	{ "MAGICERASER_ERASE", "BINDING_ERASE", "OPTIONS_KEY_BINDING_ERASE_DESCRIPTION" },
	{ "MAGICERASER_ADD_TO_IGNORE_LIST", "BINDING_ADD_TO_IGNORE_LIST", "OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION" },
	{ "MAGICERASER_ADD_TO_ERASE_LIST", "BINDING_ADD_TO_ERASE_LIST", "OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION" },
}

local KEY_LABEL_WIDTH = 1.9
local KEY_STATUS_WIDTH = 0.85
local KEY_BUTTON_WIDTH = 0.55

local function GetBindingStatus(bindingName)
	local key = GetBindingKey(bindingName)
	if not key then
		return GetColor("MUTED") .. NOT_BOUND .. "|r"
	end
	local text = (GetBindingText and GetBindingText(key)) or key
	return GetColor("TEXT") .. text .. "|r"
end

--[[
    Each binding is its row (caption, key, Set Key), its description under it,
    and a blank line before the next, so the three read as separate entries.
]]
local function AddKeyBindingRows(args, startOrder)
	local order = startOrder

	for index, entry in ipairs(KEY_BINDINGS) do
		local bindingName, captionKey, descKey = entry[1], entry[2], entry[3]

		if index > 1 then
			args["spacerKeyBinding" .. index] = ns.OptionsSpacer(order)
			order = order + 1
		end

		args["rowKeyBinding" .. index] = {
			type = "group",
			name = "",
			inline = true,
			order = order,
			args = {
				caption = ns.OptionsRowLabel(GetColor("INFO") .. L[captionKey] .. "|r", 1, KEY_LABEL_WIDTH),
				status = {
					type = "description",
					name = function()
						return GetBindingStatus(bindingName)
					end,
					fontSize = "medium",
					width = KEY_STATUS_WIDTH,
					order = 2,
				},
				setKey = {
					type = "execute",
					name = L["OPTIONS_KEY_SET"],
					desc = L["OPTIONS_KEY_SET_DESCRIPTION"],
					width = KEY_BUTTON_WIDTH,
					order = 3,
					func = function()
						ns:OpenKeyBindings()
					end,
				},
			},
		}
		order = order + 1

		args["descKeyBinding" .. index] = ns.OptionsDesc(GetColor("HELP") .. L[descKey] .. "|r", order)
		order = order + 1
	end
end

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

--[[
    The root panel, in the order every Gogo1951 add-on's root panel uses: the
    pitch, the Welcome Message and Mini-map Button switches, a Features section
    with every feature's switch, Key Bindings, /Commands, then Feedback &
    Support and the version line at the bottom. Each feature's full settings
    live on its own page under this one. The mini-map clicks are spelled out in
    the button's own tooltip, so they aren't repeated here.
]]
function ns.BuildGeneralOptions()
	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_DESCRIPTION"], 1),

		spacerWelcome0 = ns.OptionsSpacer(5),
		toggleWelcome = {
			type = "toggle",
			name = L["OPTIONS_ENABLE_WELCOME"],
			desc = L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"],
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
			name = L["OPTIONS_ENABLE_MINIMAP"],
			desc = L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"],
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

		spacerFeatures0 = ns.OptionsSpacer(10),
		headerFeatures = ns.OptionsHeader(L["OPTIONS_FEATURES_HEADER"], 11),
		spacerFeatures1 = ns.OptionsSpacer(12),

		spacerKeyBindings0 = ns.OptionsSpacer(30),
		headerKeyBindings = ns.OptionsHeader(L["OPTIONS_KEY_BINDINGS_HEADER"], 31),
		spacerKeyBindings1 = ns.OptionsSpacer(32),

		spacerCommands0 = ns.OptionsSpacer(90),
		headerCommands = ns.OptionsHeader(L["OPTIONS_COMMANDS_HEADER"], 91),
		spacerCommands1 = ns.OptionsSpacer(92),
		descCommands = ns.OptionsDesc(
			GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
			93
		),
	}

	AddFeatureToggles(args, 12)
	AddKeyBindingRows(args, 33)

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
			return ns.LINKS.DISCORD
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
			return ns.LINKS.GITHUB
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
			return ns.LINKS.CURSEFORGE
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
			return ns.LINKS.WAGO
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
		name = GetColor("MUTED") .. L["OPTIONS_VERSION"]:format(ns.Version) .. "|r",
		fontSize = "medium",
		order = 999,
	}

	return {
		type = "group",
		name = ns.ADDON_TITLE,
		args = args,
	}
end
