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

    The tree comes from ns.BuildCharacterListTree, shared with the Protect List
    panel, and the rows from ns:BuildItemListOptions, the shared builder every
    player-managed item list renders through, so a list adds and removes the same
    way here as in any other panel. A pane spends ns.OPTIONS_TREE_ROW_WIDTH
    rather than the full row width, because the tree sidebar takes its share of
    the panel first.

    There is no drop target, for the same reason the Protect List has none: the
    game closes the bags and the bank when the options interface opens, so there
    is no way to have an item on the cursor and this panel in front of you at the
    same time. The Add from Bags picker stands in for it.

    A row a Protect List overrules says Protected, so the list never looks like
    it is doing something it isn't.
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

--[[
    Whether a Protect List overrules this row, so the row can say so instead of
    looking like it does something. The account-wide Protect List covers every
    scope; a character's own covers that character's pane. The All Characters
    Erase List pane checks the account-wide Protect List only, since no single
    character's list decides it.
]]
local function IsProtectedInScope(scopeKey, itemId)
	local globalList = ns:GetGlobalIgnoreList()
	if globalList and globalList[itemId] then
		return true
	end
	if scopeKey == ns.LIST_SCOPE_GLOBAL then
		return false
	end
	local scopeList = ns:GetIgnoreListForScope(scopeKey)
	return (scopeList and scopeList[itemId]) and true or false
end

local function BuildScopeArgs(scopeKey)
	local isGlobalScope = scopeKey == ns.LIST_SCOPE_GLOBAL

	--[[
	    Every pane gets Restore Defaults, so a list is never left without a way
	    back. On the All Characters pane it empties the list, which ships empty;
	    on a character's pane it re-seeds that character's list (see
	    ns:RestoreEraseListDefaults).
	]]
	local restoreDesc = isGlobalScope and L["OPTIONS_ERASE_RESTORE_GLOBAL_DESCRIPTION"]
		or L["OPTIONS_ERASE_RESTORE_DESCRIPTION"]
	local restoreConfirm = isGlobalScope and L["OPTIONS_ERASE_RESTORE_GLOBAL_CONFIRM"]
		or L["OPTIONS_ERASE_RESTORE_CONFIRM"]

	local args = ns:BuildItemListOptions({
		rowWidth = ns.OPTIONS_TREE_ROW_WIDTH,
		startOrder = 3,
		notifyKey = ns.OPTIONS_REGISTRY.EraseList,
		paneKey = scopeKey,
		getSourceTable = function()
			return ns:GetEraseListForScope(scopeKey)
		end,
		onAdd = function(itemId)
			ns:SetOnEraseListInScope(scopeKey, itemId, true)
		end,
		onRemove = function(itemId)
			ns:SetOnEraseListInScope(scopeKey, itemId, false)
		end,
		onRemoveMany = function(itemIds)
			ns:RemoveFromListInScope("eraseList", scopeKey, itemIds)
		end,
		onRestore = function()
			ns:RestoreEraseListDefaults(scopeKey)
		end,
		addFromBags = true,
		getRowTag = function(itemId)
			return IsProtectedInScope(scopeKey, itemId) and L["OPTIONS_LIST_PROTECTED_TAG"] or nil
		end,
		labels = {
			fromBagsName = L["OPTIONS_LIST_ADD_FROM_BAGS"],
			fromBagsDesc = L["OPTIONS_LIST_ADD_FROM_BAGS_DESCRIPTION"],
			addName = L["OPTIONS_LIST_ADD_ID"],
			addHelp = L["OPTIONS_LIST_ADD_ID_DESCRIPTION"],
			addInvalid = L["OPTIONS_LIST_ADD_ID_INVALID"],
			removeDesc = L["OPTIONS_LIST_REMOVE"],
			empty = L["OPTIONS_LIST_EMPTY"],
			missingOne = L["OPTIONS_LIST_MISSING_ONE"],
			missingMany = L["OPTIONS_LIST_MISSING_MANY"],
			removeMissingOne = L["OPTIONS_LIST_REMOVE_MISSING_ONE"],
			removeMissingMany = L["OPTIONS_LIST_REMOVE_MISSING_MANY"],
			removeMissingDesc = L["OPTIONS_LIST_REMOVE_MISSING_DESCRIPTION"],
			removeMissingConfirm = L["OPTIONS_LIST_REMOVE_MISSING_CONFIRM"],
			restoreName = L["OPTIONS_ERASE_RESTORE"],
			restoreDesc = restoreDesc,
			restoreConfirm = restoreConfirm,
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

function ns.BuildEraseListOptions()
	return ns.BuildCharacterListTree({
		name = L["TAB_ERASE_LIST"],
		description = L["OPTIONS_ERASE_DESCRIPTION"],
		getListForScope = function(scopeKey)
			return ns:GetEraseListForScope(scopeKey)
		end,
		buildScopeArgs = BuildScopeArgs,
	})
end
