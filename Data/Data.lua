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
-- Example Items
--------------------------------------------------------------------------------

--[[
    The item the Auto-Vend example sells: Ruined Pelt, a gray drop from beasts
    on every client Magic Eraser ships for, so the example shows the kind of
    junk a visit really sells. The quest-item examples take theirs from the
    flavor's own quest-item tables instead (Options/Options-Quest-Item-Alerts.lua).
]]
ns.EXAMPLE_JUNK_ITEM_ID = 4865

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

--[[
    AceConfig registry names, derived from the TOC add-on name and never
    localized. The root General panel uses the bare add-on name; feature panels
    suffix it. Referenced by the registration calls in Options/Options.lua and by
    NotifyChange in the panels.
]]
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

--[[
    The options grid (ns.OPTIONS_ROW_WIDTH and the rest) belongs to Options-Kit
    (Options/Options-Kit.lua), which publishes it under the same names. Only
    the column no other add-on has stays here: the item lists' promote button,
    sized to hold "All Characters" without truncating.
]]
ns.OPTIONS_PROMOTE_WIDTH = 0.9

--------------------------------------------------------------------------------
-- Item List Scopes
--------------------------------------------------------------------------------

--[[
    The Ignore List and Erase List panels each name one scope per list on the
    account. Every scope but one is an AceDB char key ("Name - Realm" on realm
    clients, "First Last" on WoW Forever, from ns.db.keys.char and
    ns.db.sv.char, never localized), so the account-wide
    list needs a key no character can collide with -- hence the asterisks, which
    no character or realm name can contain. One constant serves both panels
    because the two never share a table:
    the key is only ever looked up against one list at a time.
    ns:GetCharacterListForScope in Features/Utilities.lua resolves it for both
    lists.
]]
ns.LIST_SCOPE_GLOBAL = "**global**"

--------------------------------------------------------------------------------
-- Color Palette
--------------------------------------------------------------------------------

--[[
    Raw 6-character hex only -- no |cff prefix (that is a display escape, added
    in Features/Utilities.lua, where the derived COLORS table and ns.GetColor
    accessor are built). Keys match the COLORS keys one-to-one.
]]
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

--[[
    Class colors, keyed by the token UnitClass returns, covering classes
    through Wrath so the table is the same on every flavor. The list panels
    color each character's name with them.
]]
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

--[[
    The highest general-purpose bag index: the backpack is 0 and the
    equippable bags run up from there. The fallback covers a client that never
    defined the global, which a bare comparison against it would error on
    rather than simply skip.

    The range is stated once here. It seeds ns.CARRIED_BAGS (Features/
    Utilities.lua), which adds the reagent bag where the client has one and is
    what every carried-bag scan and range test walks; on its own it bounds the
    free-slot count and the first bank bag on clients without character bank
    tabs.
]]
ns.LAST_BAG_INDEX = NUM_BAG_SLOTS or 4

--------------------------------------------------------------------------------
-- Race & Class Bits
--------------------------------------------------------------------------------

--[[
    Bit values for quest_template.RequiredRaces and RequiredClasses, carried in
    each flavor folder's Quest-Starting-Items file. A quest whose mask is
    non-zero and lacks the player's bit can never be taken by this character,
    so the item that starts it is dead weight the moment it drops, with no
    quest state involved.

    Keyed by the tokens UnitRace and UnitClass return, not by localized names.
    Undead's race token is "Scourge", which is why it reads oddly here.
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

--[[
    Tie-break when two erase candidates are worth the same, lowest first. Erase
    List entries lead at 0: everything below is the add-on picking an item out by
    rule, and a rule should never win a tie against an item the player listed by
    hand.
]]
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

    "crafted" is the white-gear rule's match with a <Made by> line on the
    stack's own tooltip, split out so gear made for an alt survives a trip to
    the vendor. Unchecked by default (Data/Default-Settings.lua).

    "meatFish" is meat and fish a cooking recipe uses, raw fish you can eat
    included, split out of food and drink so a fisher or cook keeps what they
    gather. Also unchecked by default.

    The rows are listed in the order the panel draws them, each with the locale
    keys for its caption and its tooltip. The panel lays them out two to a
    line, so each pair is a kind and its closest relative: the two quest kinds,
    the two outgrown-food kinds, the two white-gear kinds, then ammo and grays.
    They are string values rather than literal L["..."] reads; search the key
    name, not the L[] form.
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
