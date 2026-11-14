local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

--[[
    Two ignore lists, this character's and the account-wide one, and protection
    is additive: an item on either one is left alone. Both are stored through
    the shared Character Lists helpers in Features/Utilities.lua.
]]
function ns:GetIgnoreList()
	return ns:GetCharacterList("ignoreList")
end

function ns:GetGlobalIgnoreList()
	return ns:GetAccountList("ignoreList")
end

--[[
    True when either list protects the item. Neither list can override the
    other: adding an item anywhere protects it, and it stays protected until it
    is off both lists.
]]
function ns:IsIgnored(itemId)
	local ignoreList = ns:GetIgnoreList()
	if ignoreList and ignoreList[itemId] then
		return true
	end
	local globalIgnoreList = ns:GetGlobalIgnoreList()
	return (globalIgnoreList and globalIgnoreList[itemId]) and true or false
end

--[[
    The mini-map menu's Protect List rows (click one to remove it) and its Clear
    Protect List (the row or the button's Middle-Click) act on the current
    character's list only, which is exactly what the menu's Protect List shows
    -- so both keep meaning what the player just read. The account-wide list is
    edited from the Protect List panel instead, through ns:SetIgnoredInScope
    below.

    Both end in ns.RefreshSettings, which repaints that panel as well. It is
    registered as a builder function, so a repaint rebuilds its rows straight
    off the live lists -- but something has to ask for one, and an edit made
    outside the panel while it is on screen, a menu click here or a key press
    through ns:AddToIgnoreList below, has nothing else that does. An edit made
    in the panel is refreshed by the item-list builder in
    Options/Options-Utilities.lua, which is why ns:SetIgnoredInScope does not
    repeat this; without it here, the panel would
    keep showing the rows it drew when it opened until the player closed and
    reopened it. NotifyChange costs nothing while nothing is displaying the
    table.

    True when the item was on this character's list and is now off it.
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

--[[
    Clear Protect List from the mini-map menu's row or the button's
    Middle-Click asks first, in the words the Protect List page's Clear List
    uses: the row sits right under the item rows, where a stray click is easy,
    and everything it protected could be erased or sold on the very next click.
    With nothing on the list there is nothing to ask about. preferredIndex = 3
    avoids tainting the shared dialog stack.
]]
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
    The Add Hovered Item to Ignore List binding (Features/Key-Bindings.lua), onto
    this character's list: the list the mini-map Right-Click writes, so a click
    and a key press land in one place, and the account-wide list stays something
    the player chooses in the panel.

    Add-only, never a toggle. A second press reports the item is already
    protected rather than taking the protection away, since that is the one edit
    where a stray press costs the player an item they meant to keep; removing
    takes a click on the item's own row, in the menu or the panel. An item
    either list protects counts as already there.

    Protecting an item also retires this character's Erase List row for it. The
    Ignore List always wins, so the row could no longer change any outcome --
    the reason a promote clears every character's rows. The account-wide
    Erase List is left alone, because it still decides the item on every other
    character.

    Returns "already", "moved" or "added" for the caller's chat line, or nil
    before the database exists. A key press is an edit made outside both panels,
    so this ends in ns.RefreshSettings, which repaints both and the menu.
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

-- One list by the Ignore List panel's scope key; see ns:GetCharacterListForScope.
function ns:GetIgnoreListForScope(scopeKey, createIfMissing)
	return ns:GetCharacterListForScope("ignoreList", scopeKey, createIfMissing)
end

--[[
    Add or remove one item in one scope. The refresh pair runs for every scope,
    not just the current character's: an edit to the account-wide list changes
    what this character may erase, and an edit to another character's list is
    cheap enough that checking which scope it was is not worth the branch.

    An item joining the account-wide list comes off every character's list,
    since that list already protects it everywhere: a per-character entry could
    no longer change any outcome and would only clutter that character's pane.
    That is what makes "add to Global" mean the item lives in exactly one place.

    Removing from the account-wide list deliberately does not put the item back
    on anyone: there is no record of who held it, and re-adding to a list the
    player did not ask for would be a surprise.
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
