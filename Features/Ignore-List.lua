local _, ns = ...

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

--[[
    Two ignore lists, and protection is additive: an item on either one is left
    alone. The per-character list is the one profile-scoped setting -- each
    character has its own AceDB profile (ns.db is created without the
    shared-Default flag, so a fresh character lands on its own "Name - Realm"
    profile), so it lives directly in the profile as a flat table. The
    account-wide list is its mirror in global, shared by every character.

    Both are created on first use, so a brand-new character simply starts empty,
    and both return nil only before the database exists.
]]
function ns:GetIgnoreList()
	if not ns.db then
		return nil
	end
	local ignoreList = ns.db.profile.ignoreList
	if type(ignoreList) ~= "table" then
		ignoreList = {}
		ns.db.profile.ignoreList = ignoreList
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
    The minimap button's right-click (toggle) and middle-click (clear) act on the
    current character's list only, which is exactly what the minimap tooltip's
    Ignore List section shows -- so both keep meaning what the player just read.
    The account-wide list is edited from the Ignore List panel instead, through
    ns:SetIgnoredInScope below.

    Both repaint that panel as well. It is registered as a builder function, so a
    repaint rebuilds its rows straight off the live lists -- but something has to
    ask for one, and a minimap click while the panel is already on screen is the
    one edit path with nothing that does. Opening the panel builds it, and an
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

--------------------------------------------------------------------------------
-- Ignore List Scopes
--------------------------------------------------------------------------------

--[[
    One list looked up by the scope key the Ignore List panel uses: the global
    sentinel (ns.IGNORE_SCOPE_GLOBAL), the profile the player is on right now, or
    any other AceDB profile on the account.

    The current profile resolves through ns.db.profile rather than the raw saved
    table, so an edit lands on the very list the eraser reads and applies live.
    Every other profile is read straight out of ns.db.sv.profiles, because AceDB
    only materializes the profile you are on -- and it strips default-valued
    tables at logout, so a character who never added an entry has no stored
    ignoreList, and one who never changed a setting has no stored profile at all.
    A read returns nil in those cases; a write passes createIfMissing and builds
    what it needs on the spot.
]]
function ns:GetIgnoreListForScope(scopeKey, createIfMissing)
	if not (ns.db and scopeKey) then
		return nil
	end

	if scopeKey == ns.IGNORE_SCOPE_GLOBAL then
		return ns:GetGlobalIgnoreList()
	end

	if scopeKey == ns.db:GetCurrentProfile() then
		return ns:GetIgnoreList()
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

	local ignoreList = profile.ignoreList
	if type(ignoreList) ~= "table" then
		if not createIfMissing then
			return nil
		end
		ignoreList = {}
		profile.ignoreList = ignoreList
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

    The live table behind ns.db.profile is the same table as its sv.profiles
    entry, so the loop covers the current character too -- but only once AceDB
    has materialized that profile, hence the direct pass afterwards.
]]
local function ClearFromAllProfiles(itemId)
	local profiles = ns.db.sv and ns.db.sv.profiles
	if profiles then
		for _, profile in pairs(profiles) do
			if type(profile) == "table" and type(profile.ignoreList) == "table" then
				profile.ignoreList[itemId] = nil
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

	if isIgnored and scopeKey == ns.IGNORE_SCOPE_GLOBAL then
		ClearFromAllProfiles(itemId)
	end

	ns:InvalidateCache()
	ns:RefreshDisplay()
end
