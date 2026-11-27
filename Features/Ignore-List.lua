local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

function ns:GetIgnoreList()
	return ns:GetCharacterList("ignoreList")
end

function ns:GetGlobalIgnoreList()
	return ns:GetAccountList("ignoreList")
end

function ns:IsIgnored(itemId)
	local ignoreList = ns:GetIgnoreList()
	if ignoreList and ignoreList[itemId] then
		return true
	end
	local globalIgnoreList = ns:GetGlobalIgnoreList()
	return (globalIgnoreList and globalIgnoreList[itemId]) and true or false
end

--[[
    This character's list only, which is what the menu shows. Out-of-panel
    edits end in ns.RefreshSettings themselves, or an open panel keeps its old rows.
]]
function ns:RemoveFromIgnoreList(itemId)
	local ignoreList = ns:GetIgnoreList()
	if not (itemId and ignoreList and ignoreList[itemId]) then
		return false
	end
	ignoreList[itemId] = nil
	ns:InvalidateCache()
	ns:RefreshDisplay()
	ns.RefreshSettings()
	return true
end

function ns:ClearIgnoreList()
	local ignoreList = ns:GetIgnoreList()
	if ignoreList then
		wipe(ignoreList)
	end
	ns:InvalidateCache()
	ns:RefreshDisplay()
	ns.RefreshSettings()
end

-- The row sits under the item rows, where a stray click is easy. preferredIndex = 3 avoids taint.
StaticPopupDialogs["MAGICERASER_CLEAR_PROTECT_LIST"] = { -- luacheck: ignore 122
	text = L["OPTIONS_LIST_CLEAR_CONFIRM"],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		ns:ClearIgnoreList()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
	preferredIndex = 3,
}

function ns:ConfirmClearIgnoreList()
	local ignoreList = ns:GetIgnoreList()
	if ignoreList and next(ignoreList) ~= nil then
		StaticPopup_Show("MAGICERASER_CLEAR_PROTECT_LIST")
	end
end

--[[
    Add-only, never a toggle: a stray second press must not unprotect an item.
    Drops this character's Erase List row, never the global one, which still
    decides the item on other characters.
]]
function ns:AddToIgnoreList(itemId)
	local ignoreList = ns:GetIgnoreList()
	if not (itemId and ignoreList) then
		return nil
	end

	if ns:IsIgnored(itemId) then
		return "already"
	end

	local eraseList = ns:GetEraseList()
	local wasOnEraseList = (eraseList and eraseList[itemId]) and true or false
	if wasOnEraseList then
		eraseList[itemId] = nil
	end
	ignoreList[itemId] = true

	ns:InvalidateCache()
	ns:RefreshDisplay()
	ns.RefreshSettings()

	return wasOnEraseList and "moved" or "added"
end

--------------------------------------------------------------------------------
-- Ignore List Scopes
--------------------------------------------------------------------------------

function ns:GetIgnoreListForScope(scopeKey, createIfMissing)
	return ns:GetCharacterListForScope("ignoreList", scopeKey, createIfMissing)
end

--[[
    Adding to global promotes: the item comes off every character's list.
    Removing from global restores no one; nothing records who held it.
]]
function ns:SetIgnoredInScope(scopeKey, itemId, isIgnored)
	if not itemId then
		return
	end

	local ignoreList = ns:GetIgnoreListForScope(scopeKey, isIgnored and true or false)
	if not ignoreList then
		return
	end

	ignoreList[itemId] = isIgnored and true or nil

	if isIgnored and scopeKey == ns.LIST_SCOPE_GLOBAL then
		ns:ClearFromEveryCharacter("ignoreList", itemId)
	end

	ns:InvalidateCache()
	ns:RefreshDisplay()
end

function ns:ClearIgnoreListInScope(scopeKey)
	local ignoreList = ns:GetIgnoreListForScope(scopeKey)
	if not ignoreList then
		return
	end
	wipe(ignoreList)

	ns:InvalidateCache()
	ns:RefreshDisplay()
end
