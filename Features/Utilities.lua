local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

-- |cff is prepended here once; each call site appends its own |r.
local COLOR_PREFIX = "|cff"

local COLORS = {}
for key, hex in pairs(ns.PALETTE) do
	COLORS[key] = COLOR_PREFIX .. hex
end

function ns.GetColor(key)
	return COLORS[key] or COLORS.TEXT
end

--------------------------------------------------------------------------------
-- Displayed Item
--------------------------------------------------------------------------------

-- On WoW Forever GameTooltip:GetItem is a deprecated wrapper, so TooltipUtil comes first.
ns.GetDisplayedItem = (TooltipUtil and TooltipUtil.GetDisplayedItem) or function(tooltip)
	return tooltip:GetItem()
end

--------------------------------------------------------------------------------
-- Item Stats
--------------------------------------------------------------------------------

ns.GetItemStats = C_Item.GetItemStats or GetItemStats

--------------------------------------------------------------------------------
-- Tooltip Text
--------------------------------------------------------------------------------

-- kind is "item" or "spell"; a right-hand column follows " >> ". Can throw on an odd id, so callers pcall it.
local SCAN_TOOLTIP_NAME = "MagicEraserScanTooltip"
local TOOLTIP_DATA_GETTERS = C_TooltipInfo
	and C_TooltipInfo.GetItemByID
	and C_TooltipInfo.GetSpellByID
	and { item = C_TooltipInfo.GetItemByID, spell = C_TooltipInfo.GetSpellByID }
local scanTooltip

local function PlainText(text)
	if type(text) ~= "string" then
		return nil
	end
	return (text:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|cn[^:]*:", ""):gsub("|r", ""))
end

local function JoinTooltipLine(left, right)
	left = PlainText(left) or ""
	right = PlainText(right)
	if right and right ~= "" then
		return left .. " >> " .. right
	end
	return left
end

local function CollectDataLines(data)
	local lines = {}
	for _, line in ipairs(data and data.lines or {}) do
		lines[#lines + 1] = JoinTooltipLine(line.leftText, line.rightText)
	end
	return lines
end

-- The hidden scan tooltip, cleared and ready for one Set* call.
local function PrepareScanTooltip()
	if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", SCAN_TOOLTIP_NAME, nil, "GameTooltipTemplate")
	end
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	return scanTooltip
end

local function CollectScanLines()
	local lines = {}
	for index = 1, scanTooltip:NumLines() do
		local left = _G[SCAN_TOOLTIP_NAME .. "TextLeft" .. index]
		local right = _G[SCAN_TOOLTIP_NAME .. "TextRight" .. index]
		lines[#lines + 1] = JoinTooltipLine(left and left:GetText(), right and right:IsShown() and right:GetText())
	end
	scanTooltip:Hide()
	return lines
end

local function ReadTooltipData(kind, id)
	return CollectDataLines(TOOLTIP_DATA_GETTERS[kind](id))
end

local function ReadScanTooltip(kind, id)
	PrepareScanTooltip():SetHyperlink(kind .. ":" .. id)
	return CollectScanLines()
end

ns.GetTooltipLines = TOOLTIP_DATA_GETTERS and ReadTooltipData or ReadScanTooltip

--[[
    Per slot, for what belongs to one copy (the <Made by> line). The Classic and
    TBC main bank reads as an inventory slot. Callers pcall it.
]]
local GetBankInventorySlot = BankButtonIDToInvSlotID
local SLOT_DATA_GETTERS = C_TooltipInfo
	and C_TooltipInfo.GetBagItem
	and { bag = C_TooltipInfo.GetBagItem, inventory = C_TooltipInfo.GetInventoryItem }

function ns.GetSlotTooltipLines(bag, slot)
	local inventorySlot = bag == ns.LEGACY_BANK_CONTAINER and GetBankInventorySlot and GetBankInventorySlot(slot)
	if bag == ns.LEGACY_BANK_CONTAINER and not inventorySlot then
		return nil
	end

	if SLOT_DATA_GETTERS then
		if inventorySlot then
			local getInventory = SLOT_DATA_GETTERS.inventory
			return getInventory and CollectDataLines(getInventory("player", inventorySlot)) or nil
		end
		return CollectDataLines(SLOT_DATA_GETTERS.bag(bag, slot))
	end

	local tooltip = PrepareScanTooltip()
	if inventorySlot then
		tooltip:SetInventoryItem("player", inventorySlot)
	else
		tooltip:SetBagItem(bag, slot)
	end
	return CollectScanLines()
end

--------------------------------------------------------------------------------
-- Formatting
--------------------------------------------------------------------------------

local format, insert, floor = string.format, table.insert, math.floor

-- Outside chat only; chat lines keep the brackets. The link still hovers and clicks.
function ns:StripLinkBrackets(text)
	return (text:gsub("(|H[^|]*|h)%[(.-)%]|h", "%1%2|h"))
end

function ns:FormatCommaNumber(number)
	return (tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

--[[
    Copper split into the coins shown, each with its digits: the first coin
    shown takes no leading zero, and every coin after it takes two
    (123g 00s 00c, 1s 12c, 3c). Both money formats below draw from this.
]]
local function MoneyParts(rawValue)
	local value = math.max(rawValue or 0, 0)

	local gold = floor(value / 10000)
	local silver = floor((value % 10000) / 100)
	local copper = value % 100
	local parts = {}

	if gold > 0 then
		insert(parts, { "GOLD", ns:FormatCommaNumber(gold) })
	end

	if gold > 0 then
		insert(parts, { "SILVER", format("%02d", silver) })
	elseif silver > 0 then
		insert(parts, { "SILVER", format("%d", silver) })
	end

	if gold > 0 or silver > 0 then
		insert(parts, { "COPPER", format("%02d", copper) })
	else
		insert(parts, { "COPPER", format("%d", copper) })
	end

	return parts
end

local COIN_LETTERS = { GOLD = "g", SILVER = "s", COPPER = "c" }

-- Money for chat: white digits, then the coin's letter in its color.
function ns:FormatCurrency(rawValue)
	local out = {}
	for _, part in ipairs(MoneyParts(rawValue)) do
		local coin, digits = part[1], part[2]
		insert(out, format(COLORS.TEXT .. "%s|r|cff%s%s|r", digits, ns.CURRENCY_COLORS[coin], COIN_LETTERS[coin]))
	end
	return table.concat(out, " ")
end

local COIN_ICONS = {
	GOLD = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t",
	SILVER = "|TInterface\\MoneyFrame\\UI-SilverIcon:0|t",
	COPPER = "|TInterface\\MoneyFrame\\UI-CopperIcon:0|t",
}

-- Money for a window or menu: white digits, then the coin's icon at line height.
function ns:FormatCoins(rawValue)
	local out = {}
	for _, part in ipairs(MoneyParts(rawValue)) do
		insert(out, COLORS.TEXT .. part[2] .. "|r" .. COIN_ICONS[part[1]])
	end
	return table.concat(out, " ")
end

--------------------------------------------------------------------------------
-- Bag Space
--------------------------------------------------------------------------------

local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container.GetContainerNumSlots

local BAG_SLOTS = ns.LAST_BAG_INDEX

--[[
    General bags only: ordinary loot can't go in a specialty bag. nil, not 0,
    while no container has answered, or a loading screen reads as bags-full.
]]
function ns:CountFreeBagSlots()
	local free, totalSlots, answered = 0, 0, 0
	for bag = 0, BAG_SLOTS do
		totalSlots = totalSlots + (GetContainerNumSlots(bag) or 0)

		local bagFree, bagFamily = GetContainerNumFreeSlots(bag)
		-- 0 is truthy in Lua, so this rejects only a missing reading, never a full bag.
		if bagFree then
			answered = answered + 1
			if bagFamily == 0 or bagFamily == nil then
				free = free + bagFree
			end
		end
	end

	if totalSlots == 0 or answered == 0 then
		return nil
	end
	return free
end

--------------------------------------------------------------------------------
-- Carried Bags
--------------------------------------------------------------------------------

--[[
    The reagent bag only where the bank is character bank tabs: Classic Era and
    TBC define ReagentBag as 5 too, but there 5 is the first bank bag.
]]
ns.CARRIED_BAGS = {}
ns.IS_CARRIED_BAG = {}
do
	for bag = 0, BAG_SLOTS do
		ns.CARRIED_BAGS[#ns.CARRIED_BAGS + 1] = bag
	end
	local bagIndex = Enum.BagIndex
	local reagentBag = bagIndex and bagIndex.CharacterBankTab_1 and bagIndex.ReagentBag
	if reagentBag then
		ns.CARRIED_BAGS[#ns.CARRIED_BAGS + 1] = reagentBag
	end
	for _, bag in ipairs(ns.CARRIED_BAGS) do
		ns.IS_CARRIED_BAG[bag] = true
	end
end

--------------------------------------------------------------------------------
-- Bank Containers
--------------------------------------------------------------------------------

-- The character's own bank only, never Warband tabs. On Forever -1 is the keyring and 5 the reagent bag.
ns.BANK_CONTAINERS = {}
ns.IS_BANK_BAG = {}
do
	local bagIndex = Enum.BagIndex
	if bagIndex and bagIndex.CharacterBankTab_1 then
		local tab = 1
		while bagIndex["CharacterBankTab_" .. tab] do
			ns.BANK_CONTAINERS[tab] = bagIndex["CharacterBankTab_" .. tab]
			tab = tab + 1
		end
	else
		ns.LEGACY_BANK_CONTAINER = BANK_CONTAINER or -1
		ns.BANK_CONTAINERS[1] = ns.LEGACY_BANK_CONTAINER
		for bag = BAG_SLOTS + 1, BAG_SLOTS + (NUM_BANKBAGSLOTS or 6) do
			ns.BANK_CONTAINERS[#ns.BANK_CONTAINERS + 1] = bag
		end
	end
	for _, bag in ipairs(ns.BANK_CONTAINERS) do
		ns.IS_BANK_BAG[bag] = true
	end
end

--------------------------------------------------------------------------------
-- Character Lists
--------------------------------------------------------------------------------

local function GetOrCreateList(scope, listKey)
	local list = scope[listKey]
	if type(list) ~= "table" then
		list = {}
		scope[listKey] = list
	end
	return list
end

function ns:GetCharacterList(listKey)
	return ns.db and GetOrCreateList(ns.db.char, listKey) or nil
end

function ns:GetAccountList(listKey)
	return ns.db and GetOrCreateList(ns.db.global, listKey) or nil
end

--[[
    The played character through ns.db.char, so edits apply live; others
    through ns.db.sv.char, since AceDB materializes only the current one.
]]
function ns:GetCharacterListForScope(listKey, scopeKey, createIfMissing)
	if not (ns.db and scopeKey) then
		return nil
	end

	if scopeKey == ns.LIST_SCOPE_GLOBAL then
		return ns:GetAccountList(listKey)
	end

	if scopeKey == ns.db.keys.char then
		return ns:GetCharacterList(listKey)
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

	local list = charData[listKey]
	if type(list) ~= "table" then
		if not createIfMissing then
			return nil
		end
		list = {}
		charData[listKey] = list
	end

	return list
end

-- The direct pass afterwards covers a current character AceDB hasn't materialized yet.
function ns:ClearFromEveryCharacter(listKey, itemId)
	local characters = ns.db.sv and ns.db.sv.char
	if characters then
		for _, charData in pairs(characters) do
			if type(charData) == "table" and type(charData[listKey]) == "table" then
				charData[listKey][itemId] = nil
			end
		end
	end

	local list = ns:GetCharacterList(listKey)
	if list then
		list[itemId] = nil
	end
end

--------------------------------------------------------------------------------
-- Characters
--------------------------------------------------------------------------------

-- From char, not profiles: everyone shares Default, so profile names say nothing.
function ns:GetCharacterKeys()
	local keys, seen = {}, {}
	local current = ns.db and ns.db.keys and ns.db.keys.char
	if current then
		keys[1] = current
		seen[current] = true
	end
	for charKey in pairs((ns.db and ns.db.sv and ns.db.sv.char) or {}) do
		if not seen[charKey] then
			seen[charKey] = true
			keys[#keys + 1] = charKey
		end
	end
	table.sort(keys)
	return keys
end

function ns:GetCharacterDisplayName(charKey)
	local classToken
	if ns.db and charKey == ns.db.keys.char then
		local _, token = UnitClass("player")
		classToken = token
	else
		local charData = ns.db and ns.db.sv and ns.db.sv.char and ns.db.sv.char[charKey]
		classToken = type(charData) == "table" and charData.classToken or nil
	end
	local hex = classToken and ns.CLASS_COLORS[classToken]
	if not hex then
		return charKey
	end
	return COLOR_PREFIX .. hex .. charKey .. "|r"
end
