local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Erase List Panel
--------------------------------------------------------------------------------

--[[
    Every erase list on the account, one scope per list, laid out exactly like
    the Ignore List panel: childGroups = "tree" splits the panel in two, with the
    scope list on the left (the account-wide Global list, then the characters)
    and the selected scope's items on the right. Each scope group closes over its
    own scope key, so the add box and the row buttons in a pane always act on the
    list the player is looking at, including another character's.

    Registered as a builder function rather than a built table (see
    Options/Options.lua): the rows here are the erase lists themselves, so
    AceConfig re-invokes this on every open and every NotifyChange and the panel
    is always current.

    The rows come from ns:BuildItemListOptions, the shared builder every
    player-managed item list renders through, so a list adds and removes the same
    way here as in any other panel. A pane spends ns.OPTIONS_TREE_ROW_WIDTH
    rather than the full row width, because the tree sidebar takes its share of
    the panel first.

    There is no drop target, for the same reason the Ignore List has none: the
    game closes the bags and the bank when the options interface opens, so there
    is no way to have an item on the cursor and this panel in front of you at the
    same time.
]]

--[[
    Promote, not copy. Only the account-wide add is issued here:
    ns:SetOnEraseListInScope clears a newly globalized item off every character's
    list itself, so the row leaves this pane, leaves any other character who
    happened to hold the same item, and turns up under Global instead.

    Note which way this widens. On the Ignore List, promoting only ever protects
    more. Here it erases more, on every character including one the item was
    deliberately never seeded for -- a Shaman and their fishing reagents being
    the case that exists today. The button's description says "every character"
    outright so that is a decision rather than a discovery.
]]
local function PromoteColumn()
	return {
		type = "execute",
		name = L["OPTIONS_LIST_GLOBAL"],
		desc = L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"],
		width = ns.OPTIONS_PROMOTE_WIDTH,
		func = function(itemId)
			ns:SetOnEraseListInScope(ns.LIST_SCOPE_GLOBAL, itemId, true)
		end,
	}
end

local function BuildScopeArgs(scopeKey)
	local isGlobalScope = scopeKey == ns.LIST_SCOPE_GLOBAL

	--[[
	    Only the character being played gets Restore Defaults. ns:SeedEraseList
	    reads that character's own class and writes ns.db.profile, so it cannot
	    re-seed another character's list, and the Global scope ships no defaults
	    to restore in the first place.
	]]
	local isCurrentProfile = ns.db and scopeKey == ns.db:GetCurrentProfile()

	local args = ns:BuildItemListOptions({
		rowWidth = ns.OPTIONS_TREE_ROW_WIDTH,
		startOrder = 3,
		notifyKey = ns.OPTIONS_REGISTRY.EraseList,
		getSourceTable = function()
			return ns:GetEraseListForScope(scopeKey)
		end,
		onAdd = function(itemId)
			ns:SetOnEraseListInScope(scopeKey, itemId, true)
		end,
		onRemove = function(itemId)
			ns:SetOnEraseListInScope(scopeKey, itemId, false)
		end,
		onRestore = isCurrentProfile and function()
			ns:RestoreEraseListDefaults()
		end or nil,
		labels = {
			addName = L["OPTIONS_LIST_ADD_ID"],
			addHelp = L["OPTIONS_LIST_ADD_ID_DESCRIPTION"],
			addInvalid = L["OPTIONS_LIST_ADD_ID_INVALID"],
			removeDesc = L["OPTIONS_LIST_REMOVE"],
			empty = L["OPTIONS_LIST_EMPTY"],
			restoreName = L["OPTIONS_ERASE_RESTORE"],
			restoreConfirm = L["OPTIONS_ERASE_RESTORE_CONFIRM"],
		},
		--[[
		    The Global pane has nowhere to promote to, so its item cell absorbs
		    that column and the remove icon stays put as scopes are picked.
		]]
		actionColumn = (not isGlobalScope) and PromoteColumn() or nil,
	})

	args.spacerTop = ns.OptionsSpacer(2)

	return args
end

local function ScopeGroup(name, order, scopeKey)
	return {
		type = "group",
		name = name,
		order = order,
		args = BuildScopeArgs(scopeKey),
	}
end

function ns.BuildEraseListOptions()
	--[[
	    The description lives on the root group, not in the scope panes: a tree
	    group renders its own non-group args once, full width, between the panel
	    title and the tree, so the copy reads once above the whole panel instead
	    of repeating in every pane.
	]]
	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_ERASE_DESCRIPTION"], 1),
		spacerIntro = ns.OptionsSpacer(2),
	}

	--[[
	    Keyed by scope, not by position: the tree remembers the selected node by
	    its arg key, so a key that moved when a profile appeared or dropped out of
	    the list would silently reselect a different character.
	]]
	args[ns.LIST_SCOPE_GLOBAL] = ScopeGroup(L["OPTIONS_LIST_GLOBAL"], 3, ns.LIST_SCOPE_GLOBAL)

	if ns.db then
		local profiles = ns.db:GetProfiles()
		table.sort(profiles)

		local currentProfile = ns.db:GetCurrentProfile()
		local order = 10

		for _, profileName in ipairs(profiles) do
			--[[
			    A character with an empty list is noise in the tree, so it is left
			    out -- except for the character playing right now, whose list has
			    to be reachable to put a first item in it. Profile names are
			    character keys ("Name - Realm") and are never localized, so they
			    are shown as-is and sorted as plain strings.
			]]
			local eraseList = ns:GetEraseListForScope(profileName)
			if profileName == currentProfile or (eraseList and next(eraseList) ~= nil) then
				args[profileName] = ScopeGroup(profileName, order, profileName)
				order = order + 1
			end
		end
	end

	return {
		type = "group",
		name = L["TAB_ERASE_LIST"],
		childGroups = "tree",
		args = args,
	}
end
