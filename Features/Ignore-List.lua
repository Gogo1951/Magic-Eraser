local _, ns = ...

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

--[[
    Two ignore lists, and protection is additive: an item on either one is left
    alone. The per-character list lives in char, AceDB's per-character scope,
    as a flat table, so it stays with the character whatever profile is
    active: every character shares the Default profile, which holds settings
    only. The account-wide list is its mirror in global, shared by every
    character.

    Both are created on first use, so a brand-new character simply starts empty,
    and both return nil only before the database exists.
]]
function ns:GetIgnoreList()
	if not ns.db then
		return nil
	end
	local ignoreList = ns.db.char.ignoreList
	if type(ignoreList) ~= "table" then
		ignoreList = {}
		ns.db.char.ignoreList = ignoreList
	end
	return ignoreList
end

function ns:GetGlobalIgnoreList()
	if not ns.db then
		return nil
	end
	local ignoreList = ns.db.global.ignoreList
	if type(ignoreList) ~= "table" then
		ignoreList = {}
		ns.db.global.ignoreList = ignoreList
	end
	return ignoreList
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
    The mini-map button's right-click (toggle) and middle-click (clear) act on
    the current character's list only, which is exactly what the mini-map
    tooltip's Ignore List section shows -- so both keep meaning what the player just read.
    The account-wide list is edited from the Ignore List panel instead, through
    ns:SetIgnoredInScope below.

    Both repaint that panel as well. It is registered as a builder function, so a
    repaint rebuilds its rows straight off the live lists -- but something has to
    ask for one, and an edit made outside the panel while it is on screen, a
    mini-map click here or a key press through ns:AddToIgnoreList below, has
    nothing else that does. Opening the panel builds it, and an
    edit made in the panel is followed by AceConfigDialog re-opening the frame,
    which is why ns:SetIgnoredInScope does not repeat this; without it here, the
    panel would keep showing the rows it drew when it opened until the player
    closed and reopened it. NotifyChange costs nothing while nothing is
    displaying the table.
]]
function ns:ToggleIgnore(itemId)
	if not itemId then
		return
	end
	local ignoreList = ns:GetIgnoreList()
	if not ignoreList then
		return
	end
	if ignoreList[itemId] then
		ignoreList[itemId] = nil
	else
		ignoreList[itemId] = true
	end
	ns:InvalidateCache()
	ns:RefreshDisplay()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.IgnoreList)
end

function ns:ClearIgnoreList()
	local ignoreList = ns:GetIgnoreList()
	if ignoreList then
		wipe(ignoreList)
	end
	ns:InvalidateCache()
	ns:RefreshDisplay()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.IgnoreList)
end

--[[
    The Add Hovered Item to Ignore List binding (Features/Key-Bindings.lua), onto
    this character's list: the list the mini-map right-click writes, so a click
    and a key press land in one place, and the account-wide list stays something
    the player chooses in the panel.

    Add-only, never a toggle. A second press reports the item is already
    protected rather than taking the protection away, since that is the one edit
    where a stray press costs the player an item they meant to keep; removing
    stays in the panel. An item either list protects counts as already there.

    Protecting an item also retires this character's Erase List row for it. The
    Ignore List always wins, so the row could no longer change any outcome --
    the reason ClearFromAllCharacters clears rows on a promote. The account-wide
    Erase List is left alone, because it still decides the item on every other
    character.

    Returns "already", "moved" or "added" for the caller's chat line, or nil
    before the database exists. A key press is an edit made outside both panels,
    so this repaints whichever of them it changed.
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
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.IgnoreList)
	if wasOnEraseList then
		AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.EraseList)
	end

	return wasOnEraseList and "moved" or "added"
end

--------------------------------------------------------------------------------
-- Ignore List Scopes
--------------------------------------------------------------------------------

--[[
    One list looked up by the scope key the Ignore List panel uses: the global
    sentinel (ns.LIST_SCOPE_GLOBAL), the character being played ("Name -
    Realm", ns.db.keys.char), or any other character on the account.

    The character being played resolves through ns.db.char rather than the raw
    saved table, so an edit lands on the very list the eraser reads and applies
    live. Every other character is read straight out of ns.db.sv.char, because
    AceDB only materializes the character you are on -- and it strips
    default-valued tables at logout, so a character who never added an entry
    has no stored ignoreList. A read returns nil in those cases; a write passes
    createIfMissing and builds what it needs on the spot.
]]
function ns:GetIgnoreListForScope(scopeKey, createIfMissing)
	if not (ns.db and scopeKey) then
		return nil
	end

	if scopeKey == ns.LIST_SCOPE_GLOBAL then
		return ns:GetGlobalIgnoreList()
	end

	if scopeKey == ns.db.keys.char then
		return ns:GetIgnoreList()
	end

	local characters = ns.db.sv and ns.db.sv.char
	if not characters then
		return nil
	end

	local charData = characters[scopeKey]
	if type(charData) ~= "table" then
		if not createIfMissing then
			return nil
		end
		charData = {}
		characters[scopeKey] = charData
	end

	local ignoreList = charData.ignoreList
	if type(ignoreList) ~= "table" then
		if not createIfMissing then
			return nil
		end
		ignoreList = {}
		charData.ignoreList = ignoreList
	end

	return ignoreList
end

--[[
    Drop one item from every character's list. Called when the item joins the
    account-wide list, which already protects it everywhere: protection is
    additive, so a per-character entry for a globally ignored item can no longer
    change any outcome, and all it does is clutter that character's pane with a
    row that does nothing. Clearing them is what makes "add to Global" mean the
    item lives in exactly one place.

    The live table behind ns.db.char is the same table as its sv.char entry,
    so the loop covers the current character too -- but only once AceDB has
    materialized it, hence the direct pass afterwards.
]]
local function ClearFromAllCharacters(itemId)
	local characters = ns.db.sv and ns.db.sv.char
	if characters then
		for _, charData in pairs(characters) do
			if type(charData) == "table" and type(charData.ignoreList) == "table" then
				charData.ignoreList[itemId] = nil
			end
		end
	end

	local ignoreList = ns:GetIgnoreList()
	if ignoreList then
		ignoreList[itemId] = nil
	end
end

--[[
    Add or remove one item in one scope. The refresh pair runs for every scope,
    not just the current character's: an edit to the account-wide list changes
    what this character may erase, and an edit to another character's list is
    cheap enough that checking which scope it was is not worth the branch.

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
		ClearFromAllCharacters(itemId)
	end

	ns:InvalidateCache()
	ns:RefreshDisplay()
end
