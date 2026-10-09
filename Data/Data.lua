local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

ns.ADDON_TITLE = ns.L["ADDON_TITLE"]
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

--[[
    AceConfig registry names, derived from the TOC add-on name and never
    localized. The root General panel uses the bare add-on name; feature panels
    suffix it. Referenced by the registration calls in Options/Options.lua and by
    NotifyChange in the panels.
]]
ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	YourCurrentBags = ADDON_NAME .. "_YourCurrentBags",
	Erasing = ADDON_NAME .. "_Erasing",
	MerchantBank = ADDON_NAME .. "_MerchantBank",
	AlertsTooltips = ADDON_NAME .. "_AlertsTooltips",
	IgnoreList = ADDON_NAME .. "_IgnoreList",
	EraseList = ADDON_NAME .. "_EraseList",
	Profiles = ADDON_NAME .. "_Profiles",
	Diagnostics = ADDON_NAME .. "_Diagnostics",
}

--------------------------------------------------------------------------------
-- Options Layout Grid
--------------------------------------------------------------------------------

--[[
    The label-beside-control grid. AceConfig renders a widget's own name above it,
    so a captioned control is built as two args instead -- an ns.OptionsRowLabel
    cell, then the control with name = "" ordered immediately after. The two flow
    onto one line because their widths add up to exactly one row.
]]
ns.OPTIONS_ROW_WIDTH = 3.4
ns.OPTIONS_LABEL_WIDTH = 2.1
ns.OPTIONS_CONTROL_WIDTH = ns.OPTIONS_ROW_WIDTH - ns.OPTIONS_LABEL_WIDTH

-- The item lists' remove column, sized to its icon rather than a caption.
ns.OPTIONS_REMOVE_ICON_WIDTH = 0.25

--[[
    The blank cell a sub-option row leads with. AceConfig pins a checkbox at the
    left edge of its own widget, so padding a label indents the caption and
    leaves the box behind; leading the row with this cell instead moves the box
    itself.

    Sized so the sub-option's box starts where its parent's box visually ends.
    That lands short of a full checkbox: AceGUI's checkbox is a 24px texture
    anchored flush left and the flow layout adds no gap between widgets, but
    UI-CheckBox-Up carries transparent padding, so the gold square the player
    actually sees is inset a couple of pixels inside that footprint. Matching the
    footprint (0.14) therefore reads as a visible step too far; this matches the
    square. Nudge here if the two edges drift apart on a different UI scale.
]]
ns.OPTIONS_SUB_INDENT_WIDTH = 0.115

--[[
    The caption of a captioned sub-row: the label width less the indent that
    leads the row, so the control after it (ns.OPTIONS_CONTROL_WIDTH) ends on
    the right edge exactly where a top-level row's control does. Every dropdown
    and slider then lines up down the panel, right-aligned, the way every
    Gogo1951 add-on lays them out. Less a hair of slack, because an inline
    group summing to its budget can tip its last control onto its own line.
]]
ns.OPTIONS_SUB_LABEL_WIDTH = ns.OPTIONS_LABEL_WIDTH - ns.OPTIONS_SUB_INDENT_WIDTH - 0.05

-- The item lists' promote column, sized to hold "All Characters" without truncating.
ns.OPTIONS_PROMOTE_WIDTH = 0.9

--[[
    A tree panel's sidebar eats into the pane its rows are laid out in, so rows
    inside one spend a shorter budget than ns.OPTIONS_ROW_WIDTH. AceGUI's tree
    defaults to 175px; this is a hair wider, enough for a long realm name, and
    no more, since every pixel it takes is one the item pane's promote button
    needs. Narrowing it gives the item pane exactly what it loses, hence the
    paired constant. The tree stays drag-resizable, and a drag wins over this
    seed.
]]
ns.OPTIONS_TREE_WIDTH = 180
ns.OPTIONS_TREE_ROW_WIDTH = 2.5

--[[
    The AceGUI widget the shared item-list builder draws each row's item with --
    icon, colored link, and the item's own tooltip on hover. Registered in
    Options/Options-Utilities.lua and named off the add-on so two add-ons in one
    session never collide on the widget registry.
]]
ns.ITEM_LINK_WIDGET_TYPE = ADDON_NAME .. "_ItemLink"

--------------------------------------------------------------------------------
-- Item List Scopes
--------------------------------------------------------------------------------

--[[
    The Ignore List and Erase List panels each name one scope per list on the
    account. Every scope but one is an AceDB char key ("Name - Realm", from
    ns.db.keys.char and ns.db.sv.char, never localized), so the account-wide
    list needs a key no character can collide with -- hence the asterisks, which
    no character or realm name can contain. One constant serves both panels
    because the two never share a table:
    the key is only ever looked up against one list at a time. Read by
    ns:GetIgnoreListForScope in Features/Ignore-List.lua and
    ns:GetEraseListForScope in Features/Erase-List.lua.
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
	ammo = 3,
	equipment = 3,
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

    The rows are listed in the order the panel draws them, each with the locale
    keys for its caption, its tooltip and its Your Current Bags tag. They are
    string values rather than literal L["..."] reads; search the key name, not
    the L[] form.
]]
ns.ERASE_KINDS = {
	-- { deleteReason, labelKey, descKey, tagKey }
	{ "quest", "OPTIONS_KIND_QUEST", "OPTIONS_KIND_QUEST_DESCRIPTION", "REASON_QUEST" },
	{
		"questIneligible",
		"OPTIONS_KIND_STARTER",
		"OPTIONS_KIND_STARTER_UNAVAILABLE_DESCRIPTION",
		"REASON_QUEST_INELIGIBLE",
	},
	{ "consumable", "OPTIONS_KIND_FOOD", "OPTIONS_KIND_FOOD_DESCRIPTION", "REASON_OUTGROWN" },
	{ "ammo", "OPTIONS_KIND_AMMO", "OPTIONS_KIND_AMMO_DESCRIPTION", "REASON_OUTGROWN" },
	{ "equipment", "OPTIONS_KIND_WHITE", "OPTIONS_KIND_WHITE_DESCRIPTION", "REASON_EQUIPMENT" },
	{ "gray", "OPTIONS_KIND_GRAY", "OPTIONS_KIND_GRAY_DESCRIPTION", "REASON_GRAY" },
}
