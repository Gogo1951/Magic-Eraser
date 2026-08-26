local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Ignore List Panel
--------------------------------------------------------------------------------

--[[
    Every ignore list on the account, one scope per list. childGroups = "tree"
    splits the panel in two: the tree on the left is the scope list (the
    account-wide Global list, then the characters), and the pane on the right is
    the selected scope's items. Each scope group closes over its own scope key,
    so the add box and the row buttons in a pane always act on the list the
    player is looking at, including another character's.

    Registered as a builder function rather than a built table (see
    Options/Options.lua): the rows here are the ignore lists themselves, so
    AceConfig re-invokes this on every open and every NotifyChange and the panel
    is always current.

    The rows come from ns:BuildItemListOptions, the shared builder every
    player-managed item list renders through, so a list adds and removes the same
    way here as in any other panel. A pane spends ns.OPTIONS_TREE_ROW_WIDTH
    rather than the full row width, because the tree sidebar takes its share of
    the panel first.

    There is no drop target. The game closes the bags and the bank when the
    options interface opens, so there is no way to have an item on the cursor and
    this panel in front of you at the same time; typing or shift-clicking an id
    into the add box is the only path that can actually work.
]]

--[[
    Promote, not copy. Only the account-wide add is issued here:
    ns:SetIgnoredInScope clears a newly globalized item off every character's
    list itself, so the row leaves this pane, leaves any other character who
    happened to hold the same item, and turns up under Global instead. Protection
    only ever widens doing it this way, because the global list already covers
    everyone it just left.
]]
local function PromoteColumn()
	return {
		type = "execute",
		name = L["OPTIONS_IGNORE_GLOBAL"],
		desc = L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"],
		width = ns.OPTIONS_PROMOTE_WIDTH,
		func = function(itemId)
			ns:SetIgnoredInScope(ns.IGNORE_SCOPE_GLOBAL, itemId, true)
		end,
	}
end

local function BuildScopeArgs(scopeKey)
	local isGlobalScope = scopeKey == ns.IGNORE_SCOPE_GLOBAL

	local args = ns:BuildItemListOptions({
		rowWidth = ns.OPTIONS_TREE_ROW_WIDTH,
		startOrder = 3,
		notifyKey = ns.OPTIONS_REGISTRY.IgnoreList,
		getSourceTable = function()
			return ns:GetIgnoreListForScope(scopeKey)
		end,
		onAdd = function(itemId)
			ns:SetIgnoredInScope(scopeKey, itemId, true)
		end,
		onRemove = function(itemId)
			ns:SetIgnoredInScope(scopeKey, itemId, false)
		end,
		labels = {
			addName = L["OPTIONS_IGNORE_ADD_ID"],
			addHelp = L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"],
			addInvalid = L["OPTIONS_IGNORE_ADD_ID_INVALID"],
			removeDesc = L["OPTIONS_IGNORE_REMOVE"],
			empty = L["OPTIONS_IGNORE_EMPTY"],
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

function ns.BuildIgnoreListOptions()
	--[[
	    The description lives on the root group, not in the scope panes: a tree
	    group renders its own non-group args once, full width, between the panel
	    title and the tree, so the copy reads once above the whole panel instead
	    of repeating in every pane.
	]]
	local args = {
		descIntro = ns.OptionsDesc(L["OPTIONS_IGNORE_DESCRIPTION"], 1),
		spacerIntro = ns.OptionsSpacer(2),
	}

	--[[
	    Keyed by scope, not by position: the tree remembers the selected node by
	    its arg key, so a key that moved when a profile appeared or dropped out of
	    the list would silently reselect a different character.
	]]
	args[ns.IGNORE_SCOPE_GLOBAL] = ScopeGroup(L["OPTIONS_IGNORE_GLOBAL"], 3, ns.IGNORE_SCOPE_GLOBAL)

	if ns.db then
		local profiles = ns.db:GetProfiles()
		table.sort(profiles)

		local currentProfile = ns.db:GetCurrentProfile()
		local order = 10

		for _, profileName in ipairs(profiles) do
			--[[
			    A character with nothing ignored is noise in the tree, so it is
			    left out -- except for the character playing right now, whose
			    list has to be reachable to put a first item in it. Profile names
			    are character keys ("Name - Realm") and are never localized, so
			    they are shown as-is and sorted as plain strings.
			]]
			local ignoreList = ns:GetIgnoreListForScope(profileName)
			if profileName == currentProfile or (ignoreList and next(ignoreList) ~= nil) then
				args[profileName] = ScopeGroup(profileName, order, profileName)
				order = order + 1
			end
		end
	end

	return {
		type = "group",
		name = L["TAB_IGNORE_LIST"],
		childGroups = "tree",
		args = args,
	}
end
