local _, ns = ...

--------------------------------------------------------------------------------
-- Erase List
--------------------------------------------------------------------------------

--[[
    The data tables are rebuilt from each client's data, so a player's own
    list is the only place nothing can drop rows from. Protection wins at the
    scanners' gates, never here.
]]
function ns:GetEraseList()
	return ns:GetCharacterList("eraseList")
end

function ns:GetGlobalEraseList()
	return ns:GetAccountList("eraseList")
end

function ns:IsOnEraseList(itemId)
	local eraseList = ns:GetEraseList()
	if eraseList and eraseList[itemId] then
		return true
	end
	local globalEraseList = ns:GetGlobalEraseList()
	return (globalEraseList and globalEraseList[itemId]) and true or false
end

-- A protected item is turned away only so the binding can say why; the gates would overrule it anyway.
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
	ns.RefreshSettings()

	return "added"
end

--------------------------------------------------------------------------------
-- Erase List Scopes
--------------------------------------------------------------------------------

function ns:GetEraseListForScope(scopeKey, createIfMissing)
	return ns:GetCharacterListForScope("eraseList", scopeKey, createIfMissing)
end

--[[
    Adding to global promotes: the item comes off every character's list.
    Removing from global restores no one, seeded reagents included.
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

-- Sets the seed marker, so a cleared list stays empty at the next login.
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
    Nothing filters on ns.CLASS_REAGENTS at scan time, so a Shaman who lists
    Fish Oil is obeyed. Tracked by eraseListSeeded, since an empty list can't
    tell cleared from never seeded.
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

	-- Both callers repaint right after, so only the cache drops here.
	if seeded then
		ns:InvalidateCache()
	end
end

-- Wipe and re-seed. For the played character the marker clears first: the seed returns early while it is set.
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
