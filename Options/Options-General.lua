local _, ns = ...
local L = ns.L

local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

--[[
    Every feature's on/off switch, the one list the root panel's Features
    section and the mini-map menu both draw from (Features Mirror): same
    features, same order, same names. Listed Merchant & Bank first, then
    Erasing's Maximum Value to Erase, Delete Without Typing and Erase Confirmation,
    then Alerts & Tints.

    Each switch is built by ns.OptionsFeatureToggle, as on its own page, so the
    copies share one setting, caption and tooltip. Auto-Vend is a block, with
    its own title, description and Toggle row in the menu; the rest are one
    On/Off row each under More Features, named by their page's heading. onSet
    runs after the write for a switch whose change has to reach something
    beyond the saved value, from either place.
]]
ns.FEATURES = {
	{
		setting = "autoVendEnabled",
		name = "AUTO_VEND",
		caption = "OPTIONS_ENABLE_AUTO_VEND",
		desc = "OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION",
		block = true,
	},
	{
		setting = "bankRetrievalEnabled",
		name = "OPTIONS_BANK_HEADER",
		caption = "OPTIONS_ENABLE_BANK_RETRIEVAL",
		desc = "OPTIONS_ENABLE_BANK_RETRIEVAL_DESCRIPTION",
	},
	{
		setting = "valueCapEnabled",
		name = "OPTIONS_VALUE_CAP_HEADER",
		caption = "OPTIONS_ENABLE_VALUE_CAP",
		desc = "OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION",
		onSet = ns.OnValueCapToggled,
	},
	{
		setting = "manualDeleteAutoFillEnabled",
		name = "OPTIONS_MANUAL_DELETE_HEADER",
		caption = "OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL",
		desc = "OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION",
	},
	{
		setting = "eraseConfirmEnabled",
		name = "OPTIONS_ERASE_CONFIRM_HEADER",
		caption = "OPTIONS_ENABLE_ERASE_CONFIRM",
		desc = "OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION",
	},
	{
		setting = "tintJunkEnabled",
		name = "OPTIONS_TINT_HEADER",
		caption = "OPTIONS_ENABLE_TINT",
		desc = "OPTIONS_ENABLE_TINT_DESCRIPTION",
		onSet = ns.OnTintJunkChanged,
	},
	{
		setting = "questAlertsEnabled",
		name = "OPTIONS_QUEST_ALERTS_HEADER",
		caption = "OPTIONS_ENABLE_QUEST_ALERTS",
		desc = "OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION",
	},
	{
		setting = "bagsFullNudgeEnabled",
		name = "OPTIONS_BAGS_FULL_HEADER",
		caption = "OPTIONS_ENABLE_BAGS_FULL_WARNINGS",
		desc = "OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION",
	},
}

local function AddFeatureToggles(args, startOrder)
	local toggles = {}
	for index, feature in ipairs(ns.FEATURES) do
		toggles[index] =
			ns.OptionsFeatureToggle(feature.setting, feature.caption, feature.desc, nil, nil, feature.onSet)
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
	{ "MAGICERASER_ADD_TO_IGNORE_LIST", "BINDING_ADD_TO_PROTECT_LIST", "OPTIONS_KEY_BINDING_PROTECT_DESCRIPTION" },
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
    with every feature's switch, Key Bindings, then /Commands. The links and
    the version line have their own Feedback & Support page. Each
    feature's full settings live on its own page under this one. The mini-map
    clicks are named on the menu's rows, so they aren't repeated here.
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
				ns.RefreshSettings()
			end,
		},
		toggleMinimap = {
			type = "toggle",
			name = L["OPTIONS_ENABLE_MINIMAP"],
			desc = L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"],
			width = "full",
			order = 7,
			get = function()
				return ns.db and not ns.db.profile.minimap.hide
			end,
			set = function(_, value)
				ns.db.profile.minimap.hide = not value
				ns:ApplyMinimapButton()
				ns.RefreshSettings()
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

	return {
		type = "group",
		name = ns.ADDON_TITLE,
		args = args,
	}
end
