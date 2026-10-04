local _, ns = ...

--------------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------------

--[[
    The raw hex palette lives in Data/Data.lua (ns.PALETTE); the derived escape
    strings and the accessor live here, because Data files hold no logic. COLORS
    is file-local -- consumers never read it directly; they call ns.GetColor(key)
    (aliased once per file as `local GetColor = ns.GetColor`). Color constants
    carry no |cff prefix -- it is prepended once here, and |r is appended at each
    call site.
]]
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

--[[
    The item a tooltip is showing, as its name and link. WoW Forever ships
    TooltipUtil.GetDisplayedItem, and there GameTooltip:GetItem survives only as
    a wrapper around it that Blizzard has marked for removal. Classic Era and TBC
    Anniversary load no TooltipUtil and answer through GetItem itself. Resolved
    once at load, modern first; both halves are rows in the Diagnostic Tools API
    report.
]]
ns.GetDisplayedItem = (TooltipUtil and TooltipUtil.GetDisplayedItem) or function(tooltip)
	return tooltip:GetItem()
end

--------------------------------------------------------------------------------
-- Item Stats
--------------------------------------------------------------------------------

--[[
    An item's stat table from its link. WoW Forever ships C_Item.GetItemStats;
    Classic Era and TBC Anniversary have only the legacy global GetItemStats,
    which returns the same table. Resolved once at load, modern first; both are
    rows in the Diagnostic Tools API report.
]]
ns.GetItemStats = C_Item.GetItemStats or GetItemStats

--------------------------------------------------------------------------------
-- Tooltip Text
--------------------------------------------------------------------------------

--[[
    An item's or spell's tooltip as plain lines, a right-hand column kept after
    " >> ". kind is "item" or "spell". C_TooltipInfo hands the lines over as
    data where the client ships its GetItemByID and GetSpellByID getters (WoW
    Forever); elsewhere they are read off a hidden tooltip that is never shown
    (Classic Era and TBC Anniversary). Color escapes are stripped so each line
    reads as its words. Resolved once at load. A read can throw on an odd id, so
    callers protect it.
]]
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

local function ReadTooltipData(kind, id)
	local lines = {}
	local data = TOOLTIP_DATA_GETTERS[kind](id)
	for _, line in ipairs(data and data.lines or {}) do
		lines[#lines + 1] = JoinTooltipLine(line.leftText, line.rightText)
	end
	return lines
end

local function ReadScanTooltip(kind, id)
	if not scanTooltip then
		scanTooltip = CreateFrame("GameTooltip", SCAN_TOOLTIP_NAME, nil, "GameTooltipTemplate")
	end
	scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTooltip:ClearLines()
	scanTooltip:SetHyperlink(kind .. ":" .. id)
	local lines = {}
	for index = 1, scanTooltip:NumLines() do
		local left = _G[SCAN_TOOLTIP_NAME .. "TextLeft" .. index]
		local right = _G[SCAN_TOOLTIP_NAME .. "TextRight" .. index]
		lines[#lines + 1] = JoinTooltipLine(left and left:GetText(), right and right:IsShown() and right:GetText())
	end
	scanTooltip:Hide()
	return lines
end

ns.GetTooltipLines = TOOLTIP_DATA_GETTERS and ReadTooltipData or ReadScanTooltip

--------------------------------------------------------------------------------
-- Formatting
--------------------------------------------------------------------------------

local format, insert, floor = string.format, table.insert, math.floor

--[[
    An item link without the square brackets around its name, which is how
    Magic Eraser shows every item: Options rows and pickers, the mini-map
    tooltip, the Erase Confirmation dialog and its chat lines. Only the brackets inside
    a hyperlink's |h...|h text go; the link itself still hovers, clicks and
    shift-clicks as before, and any other text passes through untouched.
]]
function ns:StripLinkBrackets(text)
	return (text:gsub("(|H[^|]*|h)%[(.-)%]|h", "%1%2|h"))
end

function ns:FormatCommaNumber(number)
	return (tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

function ns:FormatCurrency(rawValue)
	local value = math.max(rawValue or 0, 0)

	local gold = floor(value / 10000)
	local silver = floor((value % 10000) / 100)
	local copper = value % 100
	local parts = {}

	local goldColor = ns.CURRENCY_COLORS.GOLD
	local silverColor = ns.CURRENCY_COLORS.SILVER
	local copperColor = ns.CURRENCY_COLORS.COPPER

	if gold > 0 then
		insert(parts, format(COLORS.TEXT .. "%s|r|cff%sg|r", ns:FormatCommaNumber(gold), goldColor))
	end

	if gold > 0 then
		insert(parts, format(COLORS.TEXT .. "%02d|r|cff%ss|r", silver, silverColor))
	elseif silver > 0 then
		insert(parts, format(COLORS.TEXT .. "%d|r|cff%ss|r", silver, silverColor))
	end

	if gold > 0 or silver > 0 then
		insert(parts, format(COLORS.TEXT .. "%02d|r|cff%sc|r", copper, copperColor))
	else
		insert(parts, format(COLORS.TEXT .. "%d|r|cff%sc|r", copper, copperColor))
	end

	return table.concat(parts, " ")
end

--------------------------------------------------------------------------------
-- Bag Space
--------------------------------------------------------------------------------

local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container.GetContainerNumSlots

local BAG_SLOTS = ns.LAST_BAG_INDEX

--[[
    Free general-purpose bag slots, or nil when the container API has no data yet.

    Specialty bags -- soul bags, quivers, ammo pouches, profession bags -- are
    excluded: ordinary loot can't go there, so their free slots are useless to
    the callers. GogoLoot's Speedy-Loot budget is deliberately conservative in
    exactly the same way.

    Return nil, not 0, when no container has answered yet. Summing "(bagFree or
    0)" across bags can't tell "the API has no data yet" apart from "zero free
    slots": mid-loading-screen every container reads nil, so the total collapses
    to 0 and reads as bags-full. Reporting "unknown" instead lets the caller skip
    rather than act on space the player actually has.

    Readiness is judged from the data itself: the backpack always has slots and
    always answers once the inventory is loaded, so a zero slot total, or no bag
    answering at all, means nothing is loaded yet.

    Shared by the bag-space warning (Bag-Warnings.lua) and the bank-retrieval
    budget (Bank-Retrieval.lua), which is what puts it here rather than in either.
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
    Every container the player carries, built once at load: the backpack and
    the equippable bags, then the reagent bag on clients that number their bank
    as character bank tabs (WoW Forever, where container 5 is a reagent bag).
    Classic Era and TBC Anniversary define Enum.BagIndex.ReagentBag as 5 too,
    but their own BankFrame.lua numbers bank bag N as container N +
    NUM_BAG_SLOTS, so 5 there is the first bank bag and never carried. Every
    carried-bag scan walks this list, and ns.IS_CARRIED_BAG answers the range
    tests. ns:CountFreeBagSlots above stays on the general bags, since ordinary
    loot can't go in a reagent bag.
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

--[[
    The containers Bank Retrieval scans, built once at load. WoW Forever numbers
    its bank the modern way, as character bank tabs, and there -1 is the keyring
    and 5 the reagent bag; Classic Era and TBC Anniversary keep BANK_CONTAINER
    plus the bank bags right after the carried bags, with fallbacks for a client
    that never defined those globals. The account-wide Warband tabs are never
    included: Bank Retrieval pulls from the character's own bank only.
]]
ns.BANK_CONTAINERS = {}
do
	local bagIndex = Enum.BagIndex
	if bagIndex and bagIndex.CharacterBankTab_1 then
		local tab = 1
		while bagIndex["CharacterBankTab_" .. tab] do
			ns.BANK_CONTAINERS[tab] = bagIndex["CharacterBankTab_" .. tab]
			tab = tab + 1
		end
	else
		ns.BANK_CONTAINERS[1] = BANK_CONTAINER or -1
		for bag = BAG_SLOTS + 1, BAG_SLOTS + (NUM_BANKBAGSLOTS or 6) do
			ns.BANK_CONTAINERS[#ns.BANK_CONTAINERS + 1] = bag
		end
	end
end

--------------------------------------------------------------------------------
-- Characters
--------------------------------------------------------------------------------

--[[
    Every character on the account that has per-character data, plus the one
    being played, as "Name - Realm" keys sorted as plain strings. The list
    panels draw one tree node per key. Characters live in AceDB's char scope,
    not in profiles: every character shares the Default profile, so profile
    names say nothing about who has a list.
]]
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

--[[
    A character key in its class color, for the list panels' trees. The
    character being played answers from UnitClass; any other one from the
    classToken it saved at its last login. A character that hasn't logged in
    since that was recorded keeps the tree's default color.
]]
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
