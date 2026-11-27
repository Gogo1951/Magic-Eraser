local _, ns = ...

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetItemInfo = C_Item.GetItemInfo
local GetItemSpell = C_Item.GetItemSpell
local GetItemStats = ns.GetItemStats
local ipairs = ipairs

--------------------------------------------------------------------------------
-- Quest State
--------------------------------------------------------------------------------

function ns:IsQuestCompleted(questId)
	return C_QuestLog.IsQuestFlaggedCompleted(questId)
end

--[[
    A quest-item row overrides "quest complete": it is keyed to a later quest
    (Ensorcelled Parchment starts 551, is carried to 554). A nil or 0 mask
    means no gate. A bitless race gates by side alone; a bitless class never.
]]
local playerRaceBit, playerClassBit, playerSideBits

local function GetPlayerBits()
	if not playerRaceBit then
		local _, raceToken = UnitRace("player")
		local _, classToken = UnitClass("player")
		playerRaceBit = (raceToken and ns.RACE_BITS[raceToken]) or 0
		playerClassBit = (classToken and ns.CLASS_BITS[classToken]) or 0
	end
	if playerRaceBit == 0 and not playerSideBits then
		-- Not cached until the faction answers: nil leaves the race ungated meanwhile.
		playerSideBits = ns.SIDE_RACE_BITS[UnitFactionGroup("player") or ""]
	end
	return playerRaceBit, playerClassBit, playerSideBits
end

function ns:GetPlayerQuestBits()
	return GetPlayerBits()
end

local function IsGatedOut(mask, playerBit)
	return mask and mask ~= 0 and playerBit ~= 0 and bit.band(mask, playerBit) == 0
end

local function IsRaceGatedOut(mask, raceBit, sideBits)
	if raceBit ~= 0 then
		return IsGatedOut(mask, raceBit)
	end
	return IsGatedOut(mask, sideBits or 0)
end

function ns:GetQuestStarterReason(itemId)
	local entry = (ns.ALLOWED_DELETE_QUEST_STARTING_ITEMS or {})[itemId]
	if not entry then
		return nil
	end

	local raceBit, classBit, sideBits = GetPlayerBits()
	if IsRaceGatedOut(entry[2], raceBit, sideBits) or IsGatedOut(entry[3], classBit) then
		return "questIneligible"
	end

	if not (ns.ALLOWED_DELETE_QUEST_ITEMS or {})[itemId] and self:IsQuestCompleted(entry[1]) then
		return "quest"
	end

	return nil
end

--------------------------------------------------------------------------------
-- Evaluation
--------------------------------------------------------------------------------

-- The use level comes from the data row, never requiredLevel, which is nil on a cold cache.
local CONSUMABLE_OUTGROWN_DELTA = 10
local CONSUMABLE_STARTER_LEVEL = 5

local function GetConsumableEraseLevel(useLevel)
	if useLevel < CONSUMABLE_STARTER_LEVEL then
		return CONSUMABLE_STARTER_LEVEL
	end
	return useLevel + CONSUMABLE_OUTGROWN_DELTA
end

-- Their own kind, unchecked by default, so a fisher or cook keeps what they gather.
local GetMeatFishEraseLevel = GetConsumableEraseLevel

-- No wait like food's: a hunter buys the next tier on the spot. No next tier, never junk.
local function GetAmmoEraseLevel(nextTierLevel)
	return nextTierLevel
end

-- The level PLAYER_LEVEL_UP reported, since UnitLevel may lag the event itself.
local levelUpLevel = 0

function ns:NoteLevelUp(level)
	if type(level) == "number" then
		levelUpLevel = level
	end
end

-- A ding brings no bag update, so it rescans itself, with the event's level.
function ns:OnPlayerLevelUp(level)
	ns:NoteLevelUp(level)
	ns:RefreshWhenOutOfCombat()
end

-- The level the consumable and ammo rules compare against.
function ns:GetJunkRulesLevel()
	return math.max(UnitLevel("player"), levelUpLevel)
end

--[[
    Every check fails toward keeping. Subclasses are allowlists, so one a later
    client repurposes (armor 5 is Cosmetic on modern clients) is kept. Item
    level 1 is not a keep signal; ns.KEEP_EQUIPMENT holds what no structural
    signal can see. Cached per id for the session; a cold read isn't cached.
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
	if (itemLevel or 0) < 1 or bindType == BIND_TYPE_QUEST then
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

--[[
    The <Made by> line belongs to one copy, so it is read off the slot every
    time, never cached by id. Every failure answers nil and keeps the item.
]]
local CREATED_BY_PATTERN
do
	local createdBy = type(ITEM_CREATED_BY) == "string" and ITEM_CREATED_BY
	if createdBy and createdBy:find("%%%d?%$?s") then
		createdBy = createdBy:gsub("%%%d?%$?s", "\001")
		createdBy = createdBy:gsub("[%^%$%(%)%.%[%]%*%+%-%?%%]", "%%%0")
		CREATED_BY_PATTERN = (createdBy:gsub("\001", ".+"))
	end
end

function ns:GetCraftedLinePattern()
	return CREATED_BY_PATTERN
end

-- True when the copy in this slot was crafted, false when it wasn't, nil when that can't be told yet.
local function IsCraftedSlot(bag, slot)
	if not (CREATED_BY_PATTERN and bag and slot and ns.GetSlotTooltipLines) then
		return nil
	end
	local isRead, lines = pcall(ns.GetSlotTooltipLines, bag, slot)
	if not (isRead and type(lines) == "table" and lines[1] and lines[1] ~= "") then
		return nil
	end
	for _, line in ipairs(lines) do
		if line:find(CREATED_BY_PATTERN) then
			return true
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Junk Kinds
--------------------------------------------------------------------------------

local DEFAULT_JUNK_KINDS = ns.DATABASE_DEFAULTS.profile.junkKinds

function ns:IsJunkKind(deleteReason)
	if deleteReason == "manual" then
		return true
	end
	local kinds = ns.db and ns.db.profile.junkKinds
	local isJunk = kinds and kinds[deleteReason]
	if isJunk == nil then
		isJunk = DEFAULT_JUNK_KINDS[deleteReason]
	end
	return isJunk ~= false
end

local function GetRuleDeleteReason(itemId, rarity, sellPrice, bag, slot)
	-- No protection check here: every scanner gates on ns:IsIgnored before calling.
	if ns:IsOnEraseList(itemId) then
		return "manual"
	end

	local playerLevel = ns:GetJunkRulesLevel()
	local questItemDatabase = ns.ALLOWED_DELETE_QUEST_ITEMS or {}
	local questStarterDatabase = ns.ALLOWED_DELETE_QUEST_STARTING_ITEMS or {}
	local consumableDatabase = ns.ALLOWED_DELETE_CONSUMABLES or {}
	local meatFishDatabase = ns.ALLOWED_DELETE_MEAT_FISH or {}
	local ammoDatabase = ns.ALLOWED_DELETE_AMMO or {}

	-- One branch for both tables: only the starter row carries the masks, so an elseif would shadow them.
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
	elseif meatFishDatabase[itemId] then
		local level = meatFishDatabase[itemId][1] or 1
		if playerLevel >= GetMeatFishEraseLevel(level) then
			return "meatFish"
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
		local isCrafted = IsCraftedSlot(bag, slot)
		if isCrafted == nil then
			return nil
		end
		return isCrafted and "crafted" or "equipment"
	elseif rarity == 0 and (sellPrice or 0) > 0 then
		return "gray"
	end

	return nil
end

-- Without bag and slot every white weapon and armor piece is kept: the crafted check needs them.
function ns:GetItemDeleteReason(itemId, rarity, sellPrice, bag, slot)
	local deleteReason = GetRuleDeleteReason(itemId, rarity, sellPrice, bag, slot)
	if deleteReason and not ns:IsJunkKind(deleteReason) then
		return nil
	end
	return deleteReason
end

-- Snapped to a choice, so the dropdown never shows blank and the cap used is the one shown.
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
    Stack value, since the stack is what gets destroyed. Auto-Vend and Bank
    Retrieval skip it (selling pays), and an Erase List entry is never capped.
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
