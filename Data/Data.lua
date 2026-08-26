local ADDON_NAME, ns = ...
ns.L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME)

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

ns.AddonTitle = ns.L["ADDON_TITLE"]
ns.DefaultIcon = "Interface/Icons/inv_misc_bag_07_green"

--------------------------------------------------------------------------------
-- Links
--------------------------------------------------------------------------------

ns.Links = {
	CURSEFORGE = "https://www.curseforge.com/wow/addons/magic-eraser",
	GITHUB = "https://github.com/Gogo1951/Magic-Eraser",
	DISCORD = "https://discord.gg/eh8hKq992Q",
	WAGO = "https://addons.wago.io/addons/magic-eraser",
}

--------------------------------------------------------------------------------
-- Options Registry
--------------------------------------------------------------------------------

--[[
    AceConfig registry names, derived from the TOC addon name and never
    localized. The root General panel uses the bare addon name; feature panels
    suffix it. Referenced by the registration calls in Options/Options.lua and by
    NotifyChange in the panels.
]]
ns.OPTIONS_REGISTRY = {
	General = ADDON_NAME,
	IgnoreList = ADDON_NAME .. "_IgnoreList",
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
ns.OPTIONS_ROW_WIDTH = 2.6
ns.OPTIONS_LABEL_WIDTH = 1.3
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

-- The item lists' promote column, sized to hold its button caption.
ns.OPTIONS_PROMOTE_WIDTH = 0.6

--[[
    A tree panel's sidebar eats into the pane its rows are laid out in, so rows
    inside one spend a shorter budget than ns.OPTIONS_ROW_WIDTH. AceGUI's tree
    defaults to 175px, which truncates the longer "Name - Realm" scope keys;
    widening it costs the item pane exactly what it gains, hence the paired
    constant. The tree stays drag-resizable, and a drag wins over this seed.
]]
ns.OPTIONS_TREE_WIDTH = 220
ns.OPTIONS_TREE_ROW_WIDTH = 2.3

--[[
    The AceGUI widget the shared item-list builder draws each row's item with --
    icon, colored link, and the item's own tooltip on hover. Registered in
    Options/Options-Utilities.lua and named off the add-on so two add-ons in one
    session never collide on the widget registry.
]]
ns.ITEM_LINK_WIDGET_TYPE = ADDON_NAME .. "_ItemLink"

--------------------------------------------------------------------------------
-- Ignore List Scopes
--------------------------------------------------------------------------------

--[[
    The Ignore List panel names one scope per list on the account. Every scope
    but one is an AceDB profile name ("Name - Realm", never localized), so the
    account-wide list needs a key that no profile can collide with -- hence the
    asterisks, which the profile picker's name box would never produce. Read by
    ns:GetIgnoreListForScope in Features/Ignore-List.lua.
]]
ns.IGNORE_SCOPE_GLOBAL = "**global**"

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

ns.CurrencyColors = {
	GOLD = "FFD700",
	SILVER = "C7C7CF",
	COPPER = "EDA55F",
}

--------------------------------------------------------------------------------
-- Class Reagent Exclusions
--------------------------------------------------------------------------------

ns.ClassReagentExclusions = {
	SHAMAN = {
		[17057] = true, -- Shiny Fish Scales
		[17058] = true, -- Fish Oil
	},
}

--------------------------------------------------------------------------------
-- Race & Class Bits
--------------------------------------------------------------------------------

--[[
    Bit values for quest_template.RequiredRaces and RequiredClasses, carried in
    Data/Quest-Starting-Items.lua. A quest whose mask is non-zero and lacks the
    player's bit can never be taken by this character, so the item that starts
    it is dead weight the moment it drops, with no quest state involved.

    Keyed by the tokens UnitRace and UnitClass return, not by localized names.
    Undead's race token is "Scourge", which is why it reads oddly here.
]]
ns.RaceBits = {
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

ns.ClassBits = {
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

ns.DeletePriority = {
	quest = 1,
	questIneligible = 1,
	gray = 2,
	consumable = 3,
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
]]
ns.COPPER_PER_GOLD = 10000
ns.VALUE_CAP_CHOICES = { 1, 2, 3, 5, 8, 13, 21 }
