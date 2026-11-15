local _, ns = ...
local L = ns.L

local Kit = ns.OptionsKit
local GetItemInfo = C_Item.GetItemInfo

--------------------------------------------------------------------------------
-- Options-Kit
--------------------------------------------------------------------------------

--[[
    The shared pieces every panel is built from (rows, switches, lines, the
    item list, registration, One Refresh) are Options-Kit's, in
    Options/Options-Kit.lua, copied unchanged from Common-Core. This file holds
    what only Magic Eraser has: the strings the kit draws, the feature list, the
    Example item link and the character tree its two list pages share.
]]
Kit.SetText({
	example = L["SAMPLE_EXAMPLE"],
	loading = L["LOADING_ITEM"],
	inCombat = L["CHAT_OPTIONS_IN_COMBAT"],
})

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

--[[
    Every feature's on/off switch, the one list the root panel's Features
    section, each feature's own Enable switch (Kit.FeatureSwitch) and the
    mini-map menu all draw from: same features, same order, same names. Listed
    Merchant & Bank first, then Erasing's Maximum Value to Erase, Delete
    Without Typing and Erase Confirmation, then Alerts & Tints.

    Auto-Vend is a block, with its own title, description and Toggle row in the
    menu; the rest are one On/Off row each under More Features, named by their
    page's heading. apply writes the value and the side effect for a switch
    whose change has to reach something beyond the saved value, from any of
    the three places.
]]
local function WriteThen(setting, sideEffect)
	return function(value)
		ns.db.profile[setting] = value
		sideEffect(value)
	end
end

ns.FEATURES = {
	{
		store = "profile",
		setting = "autoVendEnabled",
		name = "AUTO_VEND",
		caption = "OPTIONS_ENABLE_AUTO_VEND",
		desc = "OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION",
		block = true,
	},
	{
		store = "profile",
		setting = "bankRetrievalEnabled",
		name = "OPTIONS_BANK_HEADER",
		caption = "OPTIONS_ENABLE_BANK_RETRIEVAL",
		desc = "OPTIONS_ENABLE_BANK_RETRIEVAL_DESCRIPTION",
	},
	{
		store = "profile",
		setting = "valueCapEnabled",
		name = "OPTIONS_VALUE_CAP_HEADER",
		caption = "OPTIONS_ENABLE_VALUE_CAP",
		desc = "OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION",
		apply = WriteThen("valueCapEnabled", function(value)
			ns.OnValueCapToggled(value)
		end),
	},
	{
		store = "profile",
		setting = "manualDeleteAutoFillEnabled",
		name = "OPTIONS_MANUAL_DELETE_HEADER",
		caption = "OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL",
		desc = "OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION",
	},
	{
		store = "profile",
		setting = "eraseConfirmEnabled",
		name = "OPTIONS_ERASE_CONFIRM_HEADER",
		caption = "OPTIONS_ENABLE_ERASE_CONFIRM",
		desc = "OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION",
	},
	{
		store = "profile",
		setting = "tintJunkEnabled",
		name = "OPTIONS_TINT_HEADER",
		caption = "OPTIONS_ENABLE_TINT",
		desc = "OPTIONS_ENABLE_TINT_DESCRIPTION",
		apply = WriteThen("tintJunkEnabled", function(value)
			ns.OnTintJunkChanged(value)
		end),
	},
	{
		store = "profile",
		setting = "questAlertsEnabled",
		name = "OPTIONS_QUEST_ALERTS_HEADER",
		caption = "OPTIONS_ENABLE_QUEST_ALERTS",
		desc = "OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION",
	},
	{
		store = "profile",
		setting = "bagsFullNudgeEnabled",
		name = "OPTIONS_BAGS_FULL_HEADER",
		caption = "OPTIONS_ENABLE_BAGS_FULL_WARNINGS",
		desc = "OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION",
	},
}

--------------------------------------------------------------------------------
-- Example Lines
--------------------------------------------------------------------------------

--[[
    An Example line's item: the client's own quality-colored link for itemId,
    brackets kept as a chat line keeps them. A cold item shows its name, or nothing, while
    Kit.WarmItems asks the server and repaints registryName's panel once the
    link is in.
]]
function ns.ExampleItemLink(itemId, registryName)
	if not itemId then
		return ""
	end
	local name, link = GetItemInfo(itemId)
	if link then
		return link
	end
	Kit.WarmItems({ itemId }, registryName)
	return name or ""
end

--[[
    An Example's line exactly as chat shows it: the message through the
    add-on's own print helper, which already closes every color it opens.
    Kit.PrintedLine is left out on purpose: it reopens the line's color after
    every |r, and the game's text keeps a short stack of open colors, so on a
    two-line Example (Every Sale in Chat) the reopenings piled up past it and
    the second line's money lost its gold, silver and copper.
]]
function ns.ExampleLine(message)
	return ns:FormatMessage(message)
end

--------------------------------------------------------------------------------
-- Character List Tree
--------------------------------------------------------------------------------

--[[
    The panel both list pages share: childGroups = "tree", with the scope list
    on the left (All Characters, a blank row, then the characters) and the
    selected scope's items on the right. The caller supplies spec.name, the
    spec.description shown above the tree, spec.getListForScope(scopeKey) to
    read a list, and spec.buildScopeArgs(scopeKey) to build one pane.

    The description lives on the root group, not in the scope panes: a tree
    group renders its own non-group args once, full width, between the panel
    title and the tree, so the copy reads once above the whole panel instead of
    repeating in every pane.
]]
function ns.BuildCharacterListTree(spec)
	local function ScopeGroup(name, order, scopeKey)
		return {
			type = "group",
			name = name,
			order = order,
			args = spec.buildScopeArgs(scopeKey),
		}
	end

	local args = {
		descIntro = Kit.Desc(spec.description, 1),
		spacerIntro = Kit.Spacer(2),
	}

	--[[
	    Keyed by scope, not by position: the tree remembers the selected node by
	    its arg key, so a key that moved when a character appeared or dropped out
	    of the list would silently reselect a different character.
	]]
	args[ns.LIST_SCOPE_GLOBAL] = ScopeGroup(L["OPTIONS_LIST_GLOBAL"], 3, ns.LIST_SCOPE_GLOBAL)

	--[[
	    A blank, unclickable row between All Characters and the characters.
	    Disabled tree rows take no mouse input, so it can never be selected.
	]]
	args.spacerCharacters = {
		type = "group",
		name = " ",
		order = 4,
		disabled = true,
		args = {},
	}

	if ns.db then
		local currentCharacter = ns.db.keys.char
		local order = 10

		for _, charKey in ipairs(ns:GetCharacterKeys()) do
			--[[
			    A character with an empty list is noise in the tree, so it is left
			    out -- except for the character playing right now, whose list has
			    to be reachable to put a first item in it. Character keys
			    ("Name - Realm", or "First Last" on WoW Forever) are never
			    localized, so they are shown as-is in their class color and
			    sorted as plain strings.
			]]
			local list = spec.getListForScope(charKey)
			if charKey == currentCharacter or (list and next(list) ~= nil) then
				args[charKey] = ScopeGroup(ns:GetCharacterDisplayName(charKey), order, charKey)
				order = order + 1
			end
		end
	end

	return {
		type = "group",
		name = spec.name,
		childGroups = "tree",
		args = args,
	}
end

--[[
    Clear List on another character's pane drops that character from the tree,
    since an empty list is left out of it, so the tree is pointed back at the
    character being played rather than a pane that no longer exists.
]]
function ns.LeaveClearedScope(registryName, scopeKey)
	if scopeKey == ns.LIST_SCOPE_GLOBAL or scopeKey == ns.db.keys.char then
		return
	end
	local status = LibStub("AceConfigDialog-3.0"):GetStatusTable(registryName)
	status.groups = status.groups or {}
	status.groups.selected = ns.db.keys.char
end
