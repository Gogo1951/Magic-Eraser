local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Erase List Panel
--------------------------------------------------------------------------------

--[[
    Each scope group closes over its own scope key, so a pane always acts on
    the list shown. No drop target: the game closes the bags when options open.
]]

--[[
    Promote, not copy. Unlike the Protect List, this widens erasing to every
    character, even one never seeded the item, so the button says so outright.
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

-- The All Characters pane checks only the account-wide Protect List; no one character's list decides it.
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

	local restoreDesc = isGlobalScope and L["OPTIONS_ERASE_RESTORE_GLOBAL_DESCRIPTION"]
		or L["OPTIONS_ERASE_RESTORE_DESCRIPTION"]
	local restoreConfirm = isGlobalScope and L["OPTIONS_ERASE_RESTORE_GLOBAL_CONFIRM"]
		or L["OPTIONS_ERASE_RESTORE_CONFIRM"]

	local args = Kit.ItemList({
		rowWidth = Kit.TREE_ROW_WIDTH,
		startOrder = 3,
		registryName = ns.OPTIONS_REGISTRY.EraseList,
		getSourceTable = function()
			return ns:GetEraseListForScope(scopeKey)
		end,
		onAdd = function(itemId)
			ns:SetOnEraseListInScope(scopeKey, itemId, true)
		end,
		onRemove = function(itemId)
			ns:SetOnEraseListInScope(scopeKey, itemId, false)
		end,
		onRestore = function()
			ns:RestoreEraseListDefaults(scopeKey)
		end,
		onClear = function()
			ns:ClearEraseListInScope(scopeKey)
			ns.LeaveClearedScope(ns.OPTIONS_REGISTRY.EraseList, scopeKey)
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
			restoreName = L["OPTIONS_ERASE_RESTORE"],
			restoreDesc = restoreDesc,
			restoreConfirm = restoreConfirm,
			clearName = L["OPTIONS_LIST_CLEAR"],
			clearDesc = L["OPTIONS_LIST_CLEAR_DESCRIPTION"],
			clearConfirm = L["OPTIONS_LIST_CLEAR_CONFIRM"],
		},
		--[[
		    The Global pane has nowhere to promote to, so its item cell absorbs
		    that column and the remove icon stays put as scopes are picked.
		]]
		actionColumn = (not isGlobalScope) and PromoteColumn() or nil,
	})

	args.spacerTop = Kit.Spacer(2)

	return args
end

function ns.BuildEraseListOptions()
	return ns.BuildCharacterListTree({
		name = Kit.SubPanelTitle(L["TAB_ERASING"], L["TAB_ERASE_LIST"]),
		description = L["OPTIONS_ERASE_DESCRIPTION"],
		getListForScope = function(scopeKey)
			return ns:GetEraseListForScope(scopeKey)
		end,
		buildScopeArgs = BuildScopeArgs,
	})
end
