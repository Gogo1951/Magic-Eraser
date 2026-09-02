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
-- Formatting
--------------------------------------------------------------------------------

local format, insert, floor = string.format, table.insert, math.floor

function ns:FormatCommaNumber(number)
	return (tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
end

function ns:FormatCurrency(rawValue)
	local value = math.max(rawValue or 0, 0)

	local gold = floor(value / 10000)
	local silver = floor((value % 10000) / 100)
	local copper = value % 100
	local parts = {}

	local goldColor = ns.CurrencyColors.GOLD
	local silverColor = ns.CurrencyColors.SILVER
	local copperColor = ns.CurrencyColors.COPPER

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
