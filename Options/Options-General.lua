local _, ns = ...
local L = ns.L

local GetColor = ns.GetColor
local Kit = ns.OptionsKit

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

-- On the grid: the caption in the label column, then the key and Set Key, totalling one row.
local KEY_LABEL_WIDTH = Kit.LABEL_WIDTH
local KEY_STATUS_WIDTH = 0.75
local KEY_BUTTON_WIDTH = Kit.ROW_WIDTH - KEY_LABEL_WIDTH - KEY_STATUS_WIDTH

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
			args["spacerKeyBinding" .. index] = Kit.Spacer(order)
			order = order + 1
		end

		args["rowKeyBinding" .. index] = {
			type = "group",
			name = "",
			inline = true,
			order = order,
			args = {
				caption = Kit.Label(Kit.Color("INFO", L[captionKey]), 1, KEY_LABEL_WIDTH),
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

		args["descKeyBinding" .. index] = Kit.Desc(Kit.Color("HELP", L[descKey]), order)
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
		descIntro = Kit.Desc(L["OPTIONS_DESCRIPTION"], 1),

		spacerWelcome0 = Kit.Spacer(5),
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

		spacerFeatures0 = Kit.Spacer(10),
		headerFeatures = Kit.Header(L["OPTIONS_FEATURES_HEADER"], 11),
		spacerFeatures1 = Kit.Spacer(12),

		spacerKeyBindings0 = Kit.Spacer(30),
		headerKeyBindings = Kit.Header(L["OPTIONS_KEY_BINDINGS_HEADER"], 31),
		spacerKeyBindings1 = Kit.Spacer(32),

		spacerCommands0 = Kit.Spacer(90),
		headerCommands = Kit.Header(L["OPTIONS_COMMANDS_HEADER"], 91),
		spacerCommands1 = Kit.Spacer(92),
		descCommands = Kit.Desc(
			GetColor("INFO") .. L["OPTIONS_COMMAND"] .. "|r" .. "  " .. L["OPTIONS_COMMAND_DESCRIPTION"],
			93
		),
	}

	args.features = Kit.FeatureSwitches(13)
	AddKeyBindingRows(args, 33)

	return {
		type = "group",
		name = L["ADDON_TITLE"],
		args = args,
	}
end
