local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit
local GetItemInfo = C_Item.GetItemInfo

--------------------------------------------------------------------------------
-- Options-Kit
--------------------------------------------------------------------------------

Kit.SetText({
	example = L["SAMPLE_EXAMPLE"],
	loading = L["LOADING_ITEM"],
	inCombat = L["CHAT_OPTIONS_IN_COMBAT"],
})

--------------------------------------------------------------------------------
-- Features
--------------------------------------------------------------------------------

-- The game's delete word fills these %s keys once, before the kit or the menu reads them.
for _, key in ipairs({
	"OPTIONS_MANUAL_DELETE_HEADER",
	"OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL",
	"OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION",
}) do
	L[key] = format(L[key], DELETE_ITEM_CONFIRM_STRING or "")
end

--[[
    One list for the root panel, each Enable switch and the menu's flyout.
    apply writes the value itself, so it suits profile settings only.
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
		setting = "autoRepairEnabled",
		name = "OPTIONS_AUTO_REPAIR_HEADER",
		caption = "OPTIONS_ENABLE_AUTO_REPAIR",
		desc = "OPTIONS_ENABLE_AUTO_REPAIR_DESCRIPTION",
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
	{
		store = "profile",
		setting = "tooltipsEnabled",
		name = "OPTIONS_TOOLTIPS_HEADER",
		caption = "OPTIONS_ENABLE_TOOLTIPS",
		desc = "OPTIONS_ENABLE_TOOLTIPS_DESCRIPTION",
	},
}

--------------------------------------------------------------------------------
-- Example Lines
--------------------------------------------------------------------------------

-- A cold item shows its name, or nothing, until Kit.WarmItems repaints the panel.
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

-- No Kit.PrintedLine: the print helper already wraps and closes the line's color.
function ns.ExampleLine(message)
	return ns:FormatMessage(message)
end

--------------------------------------------------------------------------------
-- Character List Tree
--------------------------------------------------------------------------------

--[[
    spec: name, description, getListForScope(scopeKey), buildScopeArgs(scopeKey).
    The description sits on the root group so it draws once above the tree.
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

	-- Keyed by scope, not position: the tree remembers selection by arg key.
	args[ns.LIST_SCOPE_GLOBAL] = ScopeGroup(L["OPTIONS_LIST_GLOBAL"], 3, ns.LIST_SCOPE_GLOBAL)

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
			-- Empty lists are left out, except the played character's, which must take a first item.
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

-- Clearing another character's list drops its node, so selection returns to the played character.
function ns.LeaveClearedScope(registryName, scopeKey)
	if scopeKey == ns.LIST_SCOPE_GLOBAL or scopeKey == ns.db.keys.char then
		return
	end
	local status = LibStub("AceConfigDialog-3.0"):GetStatusTable(registryName)
	status.groups = status.groups or {}
	status.groups.selected = ns.db.keys.char
end
