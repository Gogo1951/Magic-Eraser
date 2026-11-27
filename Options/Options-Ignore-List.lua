local _, ns = ...
local L = ns.L
local Kit = ns.OptionsKit

--------------------------------------------------------------------------------
-- Ignore List Panel
--------------------------------------------------------------------------------

--[[
    Players see the Protect List; saved keys and the binding keep the Ignore
    List name, since renaming them would cost every player their list and keys.
]]

-- Promote, not copy: the global list already covers everyone the item leaves.
local function PromoteColumn()
	return {
		type = "execute",
		name = L["OPTIONS_LIST_GLOBAL"],
		desc = L["OPTIONS_PROTECT_PROMOTE_DESCRIPTION"],
		width = ns.OPTIONS_PROMOTE_WIDTH,
		func = function(itemId)
			ns:SetIgnoredInScope(ns.LIST_SCOPE_GLOBAL, itemId, true)
		end,
	}
end

local function BuildScopeArgs(scopeKey)
	local isGlobalScope = scopeKey == ns.LIST_SCOPE_GLOBAL

	local args = Kit.ItemList({
		rowWidth = Kit.TREE_ROW_WIDTH,
		startOrder = 3,
		registryName = ns.OPTIONS_REGISTRY.IgnoreList,
		getSourceTable = function()
			return ns:GetIgnoreListForScope(scopeKey)
		end,
		onAdd = function(itemId)
			ns:SetIgnoredInScope(scopeKey, itemId, true)
		end,
		onRemove = function(itemId)
			ns:SetIgnoredInScope(scopeKey, itemId, false)
		end,
		onClear = function()
			ns:ClearIgnoreListInScope(scopeKey)
			ns.LeaveClearedScope(ns.OPTIONS_REGISTRY.IgnoreList, scopeKey)
		end,
		addFromBags = true,
		labels = {
			fromBagsName = L["OPTIONS_LIST_ADD_FROM_BAGS"],
			fromBagsDesc = L["OPTIONS_LIST_ADD_FROM_BAGS_DESCRIPTION"],
			addName = L["OPTIONS_LIST_ADD_ID"],
			addHelp = L["OPTIONS_LIST_ADD_ID_DESCRIPTION"],
			addInvalid = L["OPTIONS_LIST_ADD_ID_INVALID"],
			removeDesc = L["OPTIONS_LIST_REMOVE"],
			empty = L["OPTIONS_LIST_EMPTY"],
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

function ns.BuildIgnoreListOptions()
	return ns.BuildCharacterListTree({
		name = Kit.SubPanelTitle(L["TAB_ERASING"], L["TAB_PROTECT_LIST"]),
		description = L["OPTIONS_PROTECT_DESCRIPTION"],
		getListForScope = function(scopeKey)
			return ns:GetIgnoreListForScope(scopeKey)
		end,
		buildScopeArgs = BuildScopeArgs,
	})
end
