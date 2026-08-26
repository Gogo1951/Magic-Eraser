local _, ns = ...

--------------------------------------------------------------------------------
-- Erase List
--------------------------------------------------------------------------------

--[[
    The Ignore List in reverse, and built to the same shape so the two panels
    behave identically. Two lists of items the player wants gone, and membership
    is additive exactly the way protection is: an item on either one is erased
    and sold, whatever its rarity and whatever the curated databases say about
    it.

    That last part is the reason the feature exists. The four databases in Data/
    are regenerated from SQL queries over a world DB, so an item those queries
    cannot express has no way into them that survives the next regeneration --
    see ns.ClassReagents in Data/Data.lua for the case that proved it. A list
    the player owns is not derived from anything, so nothing can drop rows out
    of it.

    The per-character list lives directly in the profile, because each character
    gets its own AceDB profile (ns.db is created without the shared-Default
    flag). The account-wide list is its mirror in global. Both are created on
    first use, so a brand-new character simply starts empty, and both return nil
    only before the database exists.

    The Ignore List always wins, and not by a check anywhere in this file. All
    three scanners gate on ns:IsIgnored before they ever call
    ns:GetItemDeleteReason, and the item tooltip returns its protected line
    first, so an ignored item never reaches this list at all. Each of those four
    gates says so where it stands.
]]
function ns:GetEraseList()
	if not ns.db then
		return nil
	end
	local eraseList = ns.db.profile.eraseList
	if type(eraseList) ~= "table" then
		eraseList = {}
		ns.db.profile.eraseList = eraseList
	end
	return eraseList
end

function ns:GetGlobalEraseList()
	if not ns.db then
		return nil
	end
	local eraseList = ns.db.global.eraseList
	if type(eraseList) ~= "table" then
		eraseList = {}
		ns.db.global.eraseList = eraseList
	end
	return eraseList
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

--------------------------------------------------------------------------------
-- Erase List Scopes
--------------------------------------------------------------------------------

--[[
    One list looked up by the scope key the Erase List panel uses: the global
    sentinel (ns.LIST_SCOPE_GLOBAL), the profile the player is on right now, or
    any other AceDB profile on the account.

    The current profile resolves through ns.db.profile rather than the raw saved
    table, so an edit lands on the very list the eraser reads and applies live.
    Every other profile is read straight out of ns.db.sv.profiles, because AceDB
    only materializes the profile you are on -- and it strips default-valued
    tables at logout, so a character who never added an entry has no stored
    eraseList, and one who never changed a setting has no stored profile at all.
    A read returns nil in those cases; a write passes createIfMissing and builds
    what it needs on the spot.
]]
function ns:GetEraseListForScope(scopeKey, createIfMissing)
	if not (ns.db and scopeKey) then
		return nil
	end

	if scopeKey == ns.LIST_SCOPE_GLOBAL then
		return ns:GetGlobalEraseList()
	end

	if scopeKey == ns.db:GetCurrentProfile() then
		return ns:GetEraseList()
	end

	local profiles = ns.db.sv and ns.db.sv.profiles
	if not profiles then
		return nil
	end

	local profile = profiles[scopeKey]
	if type(profile) ~= "table" then
		if not createIfMissing then
			return nil
		end
		profile = {}
		profiles[scopeKey] = profile
	end

	local eraseList = profile.eraseList
	if type(eraseList) ~= "table" then
		if not createIfMissing then
			return nil
		end
		eraseList = {}
		profile.eraseList = eraseList
	end

	return eraseList
end

--[[
    Drop one item from every character's list. Called when the item joins the
    account-wide list, which already covers everyone: membership is additive, so
    a per-character entry for a globally listed item can no longer change any
    outcome, and all it does is clutter that character's pane with a row that
    does nothing.

    The live table behind ns.db.profile is the same table as its sv.profiles
    entry, so the loop covers the current character too -- but only once AceDB
    has materialized that profile, hence the direct pass afterwards.
]]
local function ClearFromAllProfiles(itemId)
	local profiles = ns.db.sv and ns.db.sv.profiles
	if profiles then
		for _, profile in pairs(profiles) do
			if type(profile) == "table" and type(profile.eraseList) == "table" then
				profile.eraseList[itemId] = nil
			end
		end
	end

	local eraseList = ns:GetEraseList()
	if eraseList then
		eraseList[itemId] = nil
	end
end

--[[
    Add or remove one item in one scope. The refresh pair runs for every scope,
    not just the current character's: an edit to the account-wide list changes
    what this character may erase, and an edit to another character's list is
    cheap enough that checking which scope it was is not worth the branch.

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
		ClearFromAllProfiles(itemId)
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
    a Shaman's. ns.ClassReagents carries which class owns which ids, and the
    seed is the only thing that acts on it -- nothing filters on it at scan time,
    so a Shaman who deliberately lists Fish Oil is obeyed rather than silently
    overridden.

    Once per character, tracked by profile.eraseListSeeded rather than inferred
    from the list. AceDB defaults cannot express a conditional seed, and an empty
    list cannot tell "the player cleared these out" from "never seeded" -- so
    without the flag, every login would put back exactly what the player just
    removed. The flag is profile-scoped, so a Reset Profile clears it along with
    the list and the character seeds again, which is what reset should mean.

    Two items are skipped rather than seeded, both because the row would provably
    do nothing:

      - reagents this character's own class also uses, for an id shared by two
        classes. Without this, a Shaman would be seeded Fish Oil by any other
        class that happened to list it.
      - anything already ignored or already listed, since either state already
        decides the outcome.
]]
function ns:SeedEraseList()
	if not ns.db or ns.db.profile.eraseListSeeded then
		return
	end
	ns.db.profile.eraseListSeeded = true

	local eraseList = ns:GetEraseList()
	if not eraseList then
		return
	end

	local _, playerClass = UnitClass("player")
	local ownReagents = (ns.ClassReagents and ns.ClassReagents[playerClass]) or {}
	local seeded = false

	for classToken, reagents in pairs(ns.ClassReagents or {}) do
		if classToken ~= playerClass then
			for itemId in pairs(reagents) do
				if not (ownReagents[itemId] or ns:IsIgnored(itemId) or ns:IsOnEraseList(itemId)) then
					eraseList[itemId] = true
					seeded = true
				end
			end
		end
	end

	--[[
	    Only the cache is dropped here. Both callers (ns:OnPlayerLogin and
	    ns:OnProfileSwitched) repaint immediately afterwards, so a second
	    RefreshDisplay would draw the same frame twice.
	]]
	if seeded then
		ns:InvalidateCache()
	end
end

--[[
    Restore Defaults for this character's list. A wipe and re-seed, not a
    top-up: anything the player added by hand goes with it, which is what the
    confirmation warns about.

    The marker has to be cleared before the call, because ns:SeedEraseList
    returns early while it is set. Repainting is this function's job rather than
    the seed's -- the seed only drops the cache, leaving the repaint to whoever
    called it.
]]
function ns:RestoreEraseListDefaults()
	local eraseList = ns:GetEraseList()
	if not eraseList then
		return
	end

	wipe(eraseList)
	ns.db.profile.eraseListSeeded = false
	ns:SeedEraseList()

	ns:InvalidateCache()
	ns:RefreshDisplay()
end
