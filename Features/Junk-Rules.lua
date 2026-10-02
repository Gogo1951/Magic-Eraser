local _, ns = ...

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetItemInfo = C_Item.GetItemInfo
local GetItemSpell = C_Item.GetItemSpell
local GetItemStats = C_Item.GetItemStats
local ipairs = ipairs

--[[
    What counts as junk: the verdict the eraser, the item tooltip, Auto-Vend,
    Bank Retrieval and the quest alerts all share. Features/Eraser.lua finds and
    erases the next item; this file only answers whether an item qualifies.
]]

--------------------------------------------------------------------------------
-- Quest State
--------------------------------------------------------------------------------

function ns:IsQuestCompleted(questId)
	return C_QuestLog.IsQuestFlaggedCompleted(questId)
end

--[[
    A quest-starting item is spent for one of two reasons, and the second needs
    no quest state at all: either the quest it hands out is already flagged
    complete, or this character's race or class can never take that quest, which
    makes the item dead weight from the moment it drops. A Goldshire Gift
    Voucher on a Tauren is the cheap case, a Paladin-only Tome of Divinity on a
    Rogue the other.

    Masks come from quest_template and are omitted from the data when the quest
    is unrestricted, so a nil or 0 mask always means "no gate here" rather than
    "nobody qualifies".
]]
local playerRaceBit, playerClassBit

local function GetPlayerBits()
	if not playerRaceBit then
		local _, raceToken = UnitRace("player")
		local _, classToken = UnitClass("player")
		playerRaceBit = (raceToken and ns.RACE_BITS[raceToken]) or 0
		playerClassBit = (classToken and ns.CLASS_BITS[classToken]) or 0
	end
	return playerRaceBit, playerClassBit
end

local function IsGatedOut(mask, playerBit)
	return mask and mask ~= 0 and bit.band(mask, playerBit) == 0
end

function ns:GetQuestStarterReason(itemId)
	local entry = (ns.ALLOWED_DELETE_QUEST_STARTING_ITEMS or {})[itemId]
	if not entry then
		return nil
	end

	local raceBit, classBit = GetPlayerBits()
	if IsGatedOut(entry[2], raceBit) or IsGatedOut(entry[3], classBit) then
		return "questIneligible"
	end

	if self:IsQuestCompleted(entry[1]) then
		return "quest"
	end

	return nil
end

--------------------------------------------------------------------------------
-- Evaluation
--------------------------------------------------------------------------------

--[[
    The player level at which a consumable counts as outgrown. Normally ten
    levels past the item's own use level; the starter food and drink usable below
    level 5 are the exception, and go at 5 flat rather than lingering in the bags
    until 11 -- by 5 the player has already replaced them.

    The use level is read from the flavor folder's Consumables file
    ([itemId] = { useLevel }), never from the item info's requiredLevel: static
    data answers on a cold item cache and does not shift between client
    versions (Style Guide → DATA).
]]
local CONSUMABLE_OUTGROWN_DELTA = 10
local CONSUMABLE_STARTER_LEVEL = 5

local function GetConsumableEraseLevel(useLevel)
	if useLevel < CONSUMABLE_STARTER_LEVEL then
		return CONSUMABLE_STARTER_LEVEL
	end
	return useLevel + CONSUMABLE_OUTGROWN_DELTA
end

--[[
    The player level at which an arrow or bullet counts as outgrown: the moment
    the player can use a better kind a vendor sells, with no ten-level wait the
    way food has. A hunter buys the new tier on the spot, so the old stack is
    dead weight from that level on. Where nothing a vendor sells is better, as
    with Jagged Arrows on Classic Era, there is no such level and the row is
    never junk.

    The level comes from the flavor folder's Ammo file
    ([itemId] = { useLevel, nextTierLevel }), for the same cold-cache reason
    as the consumable use level. The use level is carried for Validate Data
    and is not part of the rule.
]]
local function GetAmmoEraseLevel(nextTierLevel)
	return nextTierLevel
end

--[[
    White gear is decided by rule, the way grays are, rather than looked up in a
    list: a white weapon that deals damage, or a white piece of worn armor that
    carries armor. The rule reads the client the player is on, so it covers
    whites a world DB doesn't know and items whose quality differs between
    clients, with no rows to maintain.

    Every check fails toward keeping. An item the rule cannot place is kept, and
    so is anything that looks like more than trash:

      - Subclasses are allowlists, so one a later client adds or repurposes is
        kept rather than erased: armor subclass 5 is the unused Buckler in the
        WotLK DB and Cosmetic on modern clients. Weapon subclass 14 holds the
        profession tools and 20 the fishing poles; armor subclass 0 holds rings,
        necks, trinkets, off-hand frills, shirts and tabards.
      - Shirt and tabard slots are vanity whatever subclass they carry.
      - Item level 1 is developer junk and formal wear such as the Tuxedo
        Jacket, which carries 3 armor. Real starter gear begins at 2.
      - Quest binding or an on-use spell (Borrowed Broom) marks an item as
        something other than trash.
      - The weapon has to deal damage and the armor has to carry armor, read
        through GetItemStats. That is what separates worn gear from costume
        pieces with none.

    What no structural signal can see is ns.KEEP_EQUIPMENT, in the flavor
    folder's Equipment file: formal wear with real armor values, an Equip:
    effect such as the Lucky Fishing Hat's (GetItemSpell reports Use: spells
    only), and whites a quest takes back at turn-in. A player who wants a kept
    item gone lists it; the Erase List is checked ahead of every rule.

    The verdict depends only on static item data, so it is worked out once per
    item id and remembered for the session: the tooltip asks again every 0.2s
    while the player hovers, and GetItemStats builds a new table on every call.
    A read the item cache cannot answer yet is not remembered, so the item is
    asked about again rather than settled as kept.
]]
local ITEM_CLASS_WEAPON = 2
local ITEM_CLASS_ARMOR = 4
local BIND_TYPE_QUEST = 4

-- 11, 12 and 17 are left out as well: no real item uses them.
local WEAPON_SUBCLASSES = {
	[0] = true, -- One-Handed Axes
	[1] = true, -- Two-Handed Axes
	[2] = true, -- Bows
	[3] = true, -- Guns
	[4] = true, -- One-Handed Maces
	[5] = true, -- Two-Handed Maces
	[6] = true, -- Polearms
	[7] = true, -- One-Handed Swords
	[8] = true, -- Two-Handed Swords
	[9] = true, -- Warglaives
	[10] = true, -- Staves
	[13] = true, -- Fist Weapons
	[15] = true, -- Daggers
	[16] = true, -- Thrown
	[18] = true, -- Crossbows
	[19] = true, -- Wands
}

local ARMOR_SUBCLASSES = {
	[1] = true, -- Cloth
	[2] = true, -- Leather
	[3] = true, -- Mail
	[4] = true, -- Plate
	[6] = true, -- Shields
}

local VANITY_SLOTS = {
	INVTYPE_BODY = true, -- Shirt
	INVTYPE_TABARD = true,
}

local whiteGearVerdicts = {}

-- True or false once the item is placed; nil while its data is still loading.
local function ReadWhiteGearVerdict(itemId)
	if (ns.KEEP_EQUIPMENT or {})[itemId] or not (GetItemSpell and GetItemStats) then
		return false
	end

	local _, link, _, itemLevel, _, _, _, _, equipLoc, _, _, classId, subclassId, bindType = GetItemInfo(itemId)
	if not link then
		return nil
	end

	local isWeapon = classId == ITEM_CLASS_WEAPON and WEAPON_SUBCLASSES[subclassId]
	local isArmor = classId == ITEM_CLASS_ARMOR and ARMOR_SUBCLASSES[subclassId]
	if not (isWeapon or isArmor) or VANITY_SLOTS[equipLoc] then
		return false
	end
	if (itemLevel or 0) <= 1 or bindType == BIND_TYPE_QUEST then
		return false
	end

	local spellName, spellId = GetItemSpell(itemId)
	if spellName or spellId then
		return false
	end

	local stats = GetItemStats(link)
	if not stats then
		return nil
	end
	if isWeapon then
		return (stats.ITEM_MOD_DAMAGE_PER_SECOND_SHORT or 0) > 0
	end
	return (stats.RESISTANCE0_NAME or 0) > 0
end

local function IsWhiteGearTrash(itemId)
	local verdict = whiteGearVerdicts[itemId]
	if verdict == nil then
		verdict = ReadWhiteGearVerdict(itemId)
		whiteGearVerdicts[itemId] = verdict
	end
	return verdict == true
end

--------------------------------------------------------------------------------
-- Erase Actions
--------------------------------------------------------------------------------

--[[
    The player's choice for one kind of junk, from the Erasing panel's rows: see
    ns.ERASE_KINDS in Data/Data.lua. An Erase List entry has no row and always
    erases, and anything unreadable falls back to erasing, the default for
    every kind.
]]
function ns:GetEraseAction(deleteReason)
	if deleteReason == "manual" then
		return ns.ERASE_ACTION_ERASE
	end
	local actions = ns.db and ns.db.profile.eraseActions
	return (actions and actions[deleteReason]) or ns.ERASE_ACTION_ERASE
end

--[[
    The rules half of the verdict. ns:GetItemDeleteReason below adds the
    player's Keep choices on top, so this only ever answers what the curated
    data and the gray and white-gear rules say.
]]
local function GetRuleDeleteReason(itemId, rarity, sellPrice)
	--[[
	    The Erase List first, and outside the chain below rather than a branch in
	    it: a listed item is the player's own instruction, so it matches whatever
	    its rarity and whatever the curated databases do or do not say about it.
	    That is the entire point of the list. A white trade good matches no branch
	    below -- not quest, not consumable, not ammo, not equipment, and the gray fallback
	    needs rarity 0 -- so this is the only way one can ever be erased.

	    The Ignore List still wins, and not by a check here. All three scanners
	    gate on ns:IsIgnored before calling this, and Item-Tooltips.lua returns its
	    protected line first, so an ignored item never reaches this line at all.
	]]
	if ns:IsOnEraseList(itemId) then
		return "manual"
	end

	local playerLevel = UnitLevel("player")
	local questItemDatabase = ns.ALLOWED_DELETE_QUEST_ITEMS or {}
	local questStarterDatabase = ns.ALLOWED_DELETE_QUEST_STARTING_ITEMS or {}
	local consumableDatabase = ns.ALLOWED_DELETE_CONSUMABLES or {}
	local ammoDatabase = ns.ALLOWED_DELETE_AMMO or {}

	--[[
	    Starters are checked alongside quest items rather than after them: most
	    of them appear in both tables, and only the starter entry carries the
	    race and class masks, so an elseif here would shadow the gate that makes
	    the wrong-faction case erasable at all. Either table matching also stops
	    the item falling through to the white-gear and gray rules below, which is
	    what keeps a quest item of either quality safe until its quest is done.
	]]
	if questStarterDatabase[itemId] or questItemDatabase[itemId] then
		local starterReason = ns:GetQuestStarterReason(itemId)
		if starterReason then
			return starterReason
		end
		for _, questId in ipairs(questItemDatabase[itemId] or {}) do
			if ns:IsQuestCompleted(questId) then
				return "quest"
			end
		end
	elseif consumableDatabase[itemId] then
		local useLevel = consumableDatabase[itemId][1] or 1
		if playerLevel >= GetConsumableEraseLevel(useLevel) then
			return "consumable"
		end
	elseif ammoDatabase[itemId] then
		local eraseLevel = GetAmmoEraseLevel(ammoDatabase[itemId][2])
		if eraseLevel and playerLevel >= eraseLevel then
			return "ammo"
		end
	elseif rarity == 1 and (sellPrice or 0) > 0 and IsWhiteGearTrash(itemId) then
		return "equipment"
	elseif rarity == 0 and (sellPrice or 0) > 0 then
		return "gray"
	end

	return nil
end

--[[
    The verdict every scanner, the tooltip and Auto-Vend share. A kind the player
    set to Keep is not junk anywhere, so it drops out here rather than at each
    caller: never erased, never sold, never pulled from the bank, and never
    marked in a tooltip.
]]
function ns:GetItemDeleteReason(itemId, rarity, sellPrice)
	local deleteReason = GetRuleDeleteReason(itemId, rarity, sellPrice)
	if deleteReason and ns:GetEraseAction(deleteReason) == ns.ERASE_ACTION_KEEP then
		return nil
	end
	return deleteReason
end

--[[
    The cap in gold, always one of ns.VALUE_CAP_CHOICES. A saved amount the
    dropdown doesn't offer, such as 0, reads as the smallest choice at or above
    it (the largest if none is), so the dropdown never shows blank and the cap
    the eraser uses is the one it shows.
]]
function ns:GetValueCapGold()
	local saved = (ns.db and ns.db.profile.valueCapGold) or 0
	for _, gold in ipairs(ns.VALUE_CAP_CHOICES) do
		if gold >= saved then
			return gold
		end
	end
	return ns.VALUE_CAP_CHOICES[#ns.VALUE_CAP_CHOICES]
end

--[[
    Maximum Value to Erase. Off by default; switched on, anything worth more than
    the cap stops being an erase candidate, so it is never picked by the mini-map
    button, never counted in the Clutter Report, and never warned about in a bag
    tooltip.

    Judged on the stack's total value rather than the unit price, because the
    stack is what the eraser would actually destroy -- forty grays at two silver
    each is exactly the pile worth guarding, and each one alone never looks like
    much.

    Auto-Vend and Bank Retrieval deliberately do not consult this. The cap exists
    to stop the player losing gold, and selling an over-cap stack hands them that
    gold instead, so the two features that move an item rather than destroy it
    keep working on it.

    An Erase List entry is never capped either, which is why the delete reason is
    passed in. Everything else the cap guards is the add-on picking an item out by
    rule, and a rule can be wrong about what the player values; a listed item is
    not a guess. Capping one would leave the player watching a list they built do
    nothing, with no line in the tooltip and no message in chat to say why.
]]
function ns:IsOverValueCap(totalValue, deleteReason)
	if deleteReason == "manual" then
		return false
	end
	if not (ns.db and ns.db.profile.valueCapEnabled) then
		return false
	end
	return (totalValue or 0) > ns:GetValueCapGold() * ns.COPPER_PER_GOLD
end
