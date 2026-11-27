local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

ns.ADDON_TITLE = ns.L["ADDON_TITLE"]
ns.ADDON_SHORT_NAME = ns.L["ADDON_SHORT_NAME"]
ns.SAVED_VARIABLES_NAME = "MagicEraserDB"
ns.DEFAULT_ICON = "Interface/Icons/inv_misc_bag_07_green"

--------------------------------------------------------------------------------
-- Links
--------------------------------------------------------------------------------

ns.LINKS = {
	CURSEFORGE = "https://www.curseforge.com/wow/addons/magic-eraser",
	GITHUB = "https://github.com/Gogo1951/Magic-Eraser",
	DISCORD = "https://discord.gg/eh8hKq992Q",
	WAGO = "https://addons.wago.io/addons/magic-eraser",
}

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	Erasing = ADDON_NAME .. "_Erasing",
	MerchantBank = ADDON_NAME .. "_MerchantBank",
	AlertsTints = ADDON_NAME .. "_AlertsTints",
	IgnoreList = ADDON_NAME .. "_IgnoreList",
	EraseList = ADDON_NAME .. "_EraseList",
	Profiles = ADDON_NAME .. "_Profiles",
	FeedbackSupport = ADDON_NAME .. "_FeedbackSupport",
	Diagnostics = ADDON_NAME .. "_Diagnostics",
}

--------------------------------------------------------------------------------
-- Options Layout
--------------------------------------------------------------------------------

-- The grid is Options-Kit's; only the promote button's width, sized for "All Characters", is ours.
ns.OPTIONS_PROMOTE_WIDTH = 0.9

--------------------------------------------------------------------------------
-- Item List Scopes
--------------------------------------------------------------------------------

-- Asterisks, which no character or realm name can contain, so it never collides with a char key.
ns.LIST_SCOPE_GLOBAL = "**global**"

--------------------------------------------------------------------------------
-- Color Palette
--------------------------------------------------------------------------------

-- Raw hex, no |cff: Features/Utilities.lua adds it.
ns.PALETTE = {
	TITLE = "FFD100", -- Gold: Titles, Headers, Section Names
	INFO = "00BBFF", -- Blue: Interactions, Toggles, Links, Keybinds
	BODY = "FFFFFF", -- White: Descriptions, Options Body Text
	HELP = "CCCCCC", -- Silver: Pro Tips, Helper Text
	TEXT = "FFFFFF", -- White: Messages, Values, Spell Names
	ON = "33CC33", -- Green: Enabled / On
	OFF = "CC3333", -- Red: Disabled / Off
	SEPARATOR = "AAAAAA", -- Gray: Separators, Dividers
	MUTED = "808080", -- Dark Gray: Meta-data, Version Numbers
}

-- Through Wrath, so the table is the same on every flavor.
ns.CLASS_COLORS = {
	DEATHKNIGHT = "C41E3A",
	DRUID = "FF7C0A",
	HUNTER = "AAD372",
	MAGE = "3FC7EB",
	PALADIN = "F48CBA",
	PRIEST = "FFFFFF",
	ROGUE = "FFF468",
	SHAMAN = "0070DD",
	WARLOCK = "8788EE",
	WARRIOR = "C69B6D",
}

ns.CURRENCY_COLORS = {
	GOLD = "FFD700",
	SILVER = "C7C7CF",
	COPPER = "EDA55F",
}

--------------------------------------------------------------------------------
-- Carried Bag Range
--------------------------------------------------------------------------------

-- Stated once here; scans walk ns.CARRIED_BAGS, which adds the reagent bag where there is one.
ns.LAST_BAG_INDEX = NUM_BAG_SLOTS or 4

--------------------------------------------------------------------------------
-- Race & Class Bits
--------------------------------------------------------------------------------

--[[
    Keyed by UnitRace/UnitClass tokens; Undead is "Scourge". Skyborne has no
    bit: its 2^32 and 2^33 overflow the 32-bit bit library, so it gates by side.
]]
ns.RACE_BITS = {
	Human = 1,
	Orc = 2,
	Dwarf = 4,
	NightElf = 8,
	Scourge = 16, -- Undead
	Tauren = 32,
	Gnome = 64,
	Troll = 128,
	Goblin = 256,
	BloodElf = 512,
	Draenei = 1024,
}

-- Every race bit on each side, keyed by the faction token UnitFactionGroup returns.
ns.SIDE_RACE_BITS = {
	Alliance = 1101, -- Human, Dwarf, NightElf, Gnome, Draenei
	Horde = 946, -- Orc, Scourge, Tauren, Troll, Goblin, BloodElf
}

ns.CLASS_BITS = {
	WARRIOR = 1,
	PALADIN = 2,
	HUNTER = 4,
	ROGUE = 8,
	PRIEST = 16,
	DEATHKNIGHT = 32,
	SHAMAN = 64,
	MAGE = 128,
	WARLOCK = 256,
	DRUID = 1024,
}

--------------------------------------------------------------------------------
-- Deletion Priority
--------------------------------------------------------------------------------

-- Ties, lowest first. Erase List entries lead: a rule never beats an item the player listed.
ns.DELETE_PRIORITY = {
	manual = 0,
	quest = 1,
	questIneligible = 1,
	gray = 2,
	consumable = 3,
	meatFish = 3,
	ammo = 3,
	equipment = 3,
	crafted = 3,
}

--------------------------------------------------------------------------------
-- Maximum Value to Erase
--------------------------------------------------------------------------------

--[[
    The gold amounts the value cap offers, and the conversion its comparison
    needs: the setting is stored in gold because gold is what the player picked,
    while item values come back from the API in copper.

    The run is the modified Fibonacci sequence, the same one agile estimators
    reach for, and for the same reason -- the gaps widen the way tolerance does.
    One gold to two is a real difference; twenty to twenty-one is not. (=

    One gold is the floor; the run deliberately has no zero.
]]
ns.COPPER_PER_GOLD = 10000
ns.VALUE_CAP_CHOICES = { 1, 2, 3, 5, 8, 13, 21 }

--------------------------------------------------------------------------------
-- Junk Kinds
--------------------------------------------------------------------------------

--[[
    The kinds of junk the Erasing panel draws a checkbox for, keyed by the
    delete reason ns:GetItemDeleteReason returns. "manual" is absent on
    purpose: an Erase List entry is always junk.

    Panel order, two to a line, each kind beside its closest relative. Keys
    are strings, not L[] reads: search the key name.
]]
ns.ERASE_KINDS = {
	-- { deleteReason, labelKey, descKey }
	{ "quest", "OPTIONS_KIND_QUEST", "OPTIONS_KIND_QUEST_DESCRIPTION" },
	{ "questIneligible", "OPTIONS_KIND_STARTER", "OPTIONS_KIND_STARTER_DESCRIPTION" },
	{ "consumable", "OPTIONS_KIND_FOOD", "OPTIONS_KIND_FOOD_DESCRIPTION" },
	{ "meatFish", "OPTIONS_KIND_MEAT_FISH", "OPTIONS_KIND_MEAT_FISH_DESCRIPTION" },
	{ "equipment", "OPTIONS_KIND_WHITE", "OPTIONS_KIND_WHITE_DESCRIPTION" },
	{ "crafted", "OPTIONS_KIND_CRAFTED", "OPTIONS_KIND_CRAFTED_DESCRIPTION" },
	{ "ammo", "OPTIONS_KIND_AMMO", "OPTIONS_KIND_AMMO_DESCRIPTION" },
	{ "gray", "OPTIONS_KIND_GRAY", "OPTIONS_KIND_GRAY_DESCRIPTION" },
}
