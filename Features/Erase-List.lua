local _, ns = ...

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Erase List
--------------------------------------------------------------------------------

--[[
    The Ignore List in reverse, and built to the same shape so the two panels
    behave identically. Two lists of items the player wants gone, and membership
    is additive exactly the way protection is: an item on either one is erased
    and sold, whatever its rarity and whatever the curated databases say about
    it.

    That last part is the reason the feature exists. The tables in each Data/
    flavor folder are curated per flavor and rebuilt from each client's
    Validate Data report, so an item outside their rules has no lasting place in them
    -- see ns.CLASS_REAGENTS, in the Class-Reagents file beside them, for the
    case that proved it. A list the player owns is not derived from anything, so
    nothing can drop rows out of it.

    Both lists, this character's and the account-wide one, are stored through
    the shared Character Lists helpers in Features/Utilities.lua.

    The Ignore List always wins, and nothing in this file enforces it. All three
    scanners gate on ns:IsIgnored before they ever call ns:GetItemDeleteReason,
    so an ignored item never reaches this list at all, and the junk tint reads
    the eraser's scan, so it inherits that gate. Each of those three gates says
    so where it stands. ns:AddToEraseList turns a protected item away as well, but only so
    the key binding can tell the player why; a row that got in through the panel
    is still overruled at the gates.
]]
function ns:GetEraseList()
	return ns:GetCharacterList("eraseList")
end

function ns:GetGlobalEraseList()
	return ns:GetAccountList("eraseList")
end

--[[
    True when either list carries the item. Neither list can override the other:
    adding an item anywhere marks it, and it stays marked until it is off both.
]]
function ns:IsOnEraseList(itemId)
	local eraseList = ns:GetEraseList()
	if eraseList and eraseList[itemId] then
		return true
	end
	local globalEraseList = ns:GetGlobalEraseList()
	return (globalEraseList and globalEraseList[itemId]) and true or false
end

--[[
    The Add Hovered Item to Erase List binding (Features/Key-Bindings.lua), onto
    this character's list, mirroring ns:AddToIgnoreList: add-only, and an item
    either list already carries counts as already there.

    A protected item is turned away rather than listed. The Ignore List would
    overrule the row at every gate, so all it could do is report an addition
    that changes nothing -- and lifting protection the player set on purpose is
    a decision for the Ignore List panel, not a side effect of a key press.

    Returns "protected", "already" or "added" for the caller's chat line, or nil
    before the database exists. A key press is an edit made outside the panel,
    so this fires the panel's NotifyChange itself, as ns:AddToIgnoreList does
    when it takes a row off this list.
]]
function ns:AddToEraseList(itemId)
	local eraseList = ns:GetEraseList()
	if not (itemId and eraseList) then
		return nil
	end

	if ns:IsIgnored(itemId) then
		return "protected"
	end
	if ns:IsOnEraseList(itemId) then
		return "already"
	end

	eraseList[itemId] = true

	ns:InvalidateCache()
	ns:RefreshDisplay()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.EraseList)

	return "added"
end

--------------------------------------------------------------------------------
-- Erase List Scopes
--------------------------------------------------------------------------------

-- One list by the Erase List panel's scope key; see ns:GetCharacterListForScope.
function ns:GetEraseListForScope(scopeKey, createIfMissing)
	return ns:GetCharacterListForScope("eraseList", scopeKey, createIfMissing)
end

--[[
    Add or remove one item in one scope. The refresh pair runs for every scope,
    not just the current character's: an edit to the account-wide list changes
    what this character may erase, and an edit to another character's list is
    cheap enough that checking which scope it was is not worth the branch.

    An item joining the account-wide list comes off every character's list,
    since that list already covers everyone: a per-character entry could no
    longer change any outcome and would only clutter that character's pane.

    Removing from the account-wide list deliberately does not put the item back
    on anyone: there is no record of who held it, and re-adding to a list the
    player did not ask for would be a surprise. That includes the seeded class
    reagents below, which is why the seed runs once per character and never
    re-checks.
]]
function ns:SetOnEraseListInScope(scopeKey, itemId, isOnList)
	if not itemId then
		return
	end

	local eraseList = ns:GetEraseListForScope(scopeKey, isOnList and true or false)
	if not eraseList then
		return
	end

	eraseList[itemId] = isOnList and true or nil

	if isOnList and scopeKey == ns.LIST_SCOPE_GLOBAL then
		ns:ClearFromEveryCharacter("eraseList", itemId)
	end

	ns:InvalidateCache()
	ns:RefreshDisplay()
end

--[[
    Clear List for one scope. The seed marker is set as well, so a cleared list
    stays empty at that character's next login; only Restore Defaults seeds it
    again. The All Characters list has no marker.
]]
function ns:ClearEraseListInScope(scopeKey)
	local eraseList = ns:GetEraseListForScope(scopeKey)
	if not eraseList then
		return
	end
	wipe(eraseList)

	if scopeKey == ns.db.keys.char then
		ns.db.char.eraseListSeeded = true
	elseif scopeKey ~= ns.LIST_SCOPE_GLOBAL then
		ns.db.sv.char[scopeKey].eraseListSeeded = true
	end

	ns:InvalidateCache()
	ns:RefreshDisplay()
end

--------------------------------------------------------------------------------
-- Class Reagent Seed
--------------------------------------------------------------------------------

--[[
    Seed this character's list with every class reagent that belongs to some
    other class. Shiny Fish Scales and Fish Oil are the Shaman's Water Breathing
    and Water Walking reagents: junk in a Warrior's bags, and not junk at all in
    a Shaman's. ns.CLASS_REAGENTS carries which class owns which ids, and the
    seed is the only thing that acts on it -- nothing filters on it at scan time,
    so a Shaman who deliberately lists Fish Oil is obeyed rather than silently
    overridden.

    Once per character, tracked by char.eraseListSeeded rather than inferred
    from the list. AceDB defaults cannot express a conditional seed, and an empty
    list cannot tell "the player cleared these out" from "never seeded" -- so
    without the flag, every login would put back exactly what the player just
    removed. The flag lives in char beside the list, so a profile switch or
    reset never re-seeds; Restore Defaults on the Erase List panel is the one
    way to seed again.

    Two items are skipped rather than seeded, both because the row would provably
    do nothing:

      - reagents this character's own class also uses, for an id shared by two
        classes. Without this, a Shaman would be seeded Fish Oil by any other
        class that happened to list it.
      - anything already ignored or already listed, since either state already
        decides the outcome.

    SeedList does the work for any character's list, given that character's
    class and Protect List, so Restore Defaults can re-seed a character other
    than the one being played.
]]
local function SeedList(eraseList, playerClass, characterIgnoreList)
	local ownReagents = (ns.CLASS_REAGENTS and ns.CLASS_REAGENTS[playerClass]) or {}
	local globalIgnoreList = ns:GetGlobalIgnoreList() or {}
	local globalEraseList = ns:GetGlobalEraseList() or {}
	if type(characterIgnoreList) ~= "table" then
		characterIgnoreList = {}
	end
	local seeded = false

	for classToken, reagents in pairs(ns.CLASS_REAGENTS or {}) do
		if classToken ~= playerClass then
			for itemId in pairs(reagents) do
				if
					not (
						ownReagents[itemId]
						or characterIgnoreList[itemId]
						or globalIgnoreList[itemId]
						or globalEraseList[itemId]
						or eraseList[itemId]
					)
				then
					eraseList[itemId] = true
					seeded = true
				end
			end
		end
	end

	return seeded
end

function ns:SeedEraseList()
	if not ns.db or ns.db.char.eraseListSeeded then
		return
	end
	ns.db.char.eraseListSeeded = true

	local eraseList = ns:GetEraseList()
	if not eraseList then
		return
	end

	local _, playerClass = UnitClass("player")
	local seeded = SeedList(eraseList, playerClass, ns:GetIgnoreList())

	--[[
	    Only the cache is dropped here. Both callers (ns:OnPlayerLogin and
	    ns:RestoreEraseListDefaults) repaint immediately afterwards, so a second
	    RefreshDisplay would draw the same frame twice.
	]]
	if seeded then
		ns:InvalidateCache()
	end
end

--[[
    Restore Defaults for one scope's list, offered on every pane. A wipe and
    re-seed, not a top-up: anything the player added by hand goes with it, which
    is what the confirmation warns about.

      - The All Characters list ships empty, so restoring it just empties it.
      - The character being played re-seeds through ns:SeedEraseList. The marker
        has to be cleared before the call, because the seed returns early while
        it is set.
      - Any other character re-seeds with the class saved at its last login
        (char.classToken) and its own Protect List. One with no class saved yet
        is left empty with its marker cleared, so it seeds itself at its next
        login.

    Repainting is this function's job rather than the seed's -- the seed only
    drops the cache, leaving the repaint to whoever called it.
]]
function ns:RestoreEraseListDefaults(scopeKey)
	if not ns.db then
		return
	end

	if scopeKey == ns.LIST_SCOPE_GLOBAL then
		local globalEraseList = ns:GetGlobalEraseList()
		if globalEraseList then
			wipe(globalEraseList)
		end
	elseif scopeKey == ns.db.keys.char then
		local eraseList = ns:GetEraseList()
		if not eraseList then
			return
		end
		wipe(eraseList)
		ns.db.char.eraseListSeeded = false
		ns:SeedEraseList()
	else
		local eraseList = ns:GetEraseListForScope(scopeKey, true)
		if not eraseList then
			return
		end
		wipe(eraseList)
		local charData = ns.db.sv.char[scopeKey]
		if charData.classToken then
			SeedList(eraseList, charData.classToken, charData.ignoreList)
			charData.eraseListSeeded = true
		else
			charData.eraseListSeeded = false
		end
	end

	ns:InvalidateCache()
	ns:RefreshDisplay()
end
