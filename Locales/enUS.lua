local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "enUS", true)
if not L then
	return
end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] =
	"Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Magic Eraser. Enjoying the add-on? Tell a friend about it! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "As a safety precaution, the Options Interface cannot be opened during combat."

-- Eraser
L["COMBAT_LOCKOUT"] = "Cannot erase items while in combat."
L["CONFIRM_ERASE"] = "Erase %s%s?"
L["BAGS_FULL"] = "Your bags are full!"
L["BAGS_FULL_NUDGE"] = "Your bags are nearly full. You have %d slots remaining."
L["BAGS_FULL_NUDGE_ONE"] = "Your bags are nearly full. You have 1 slot remaining."
L["CURSOR_TOO_FAST"] = "Slow down! You're clicking faster than the game can erase items."
L["ERASED_ITEM"] = "Erased %s%s."
L["ERASED_ITEM_WITH_VALUE"] = "Erased %s%s, worth %s."
L["ERASED_ITEM_FROM_QUEST"] = "Erased %s%s, from a quest you have completed."
L["ERASED_ITEM_QUEST_UNAVAILABLE"] = "Erased %s%s, from a quest your character cannot take."
L["QUEST_ITEM_READY"] = "%s can now be safely erased!"
L["QUEST_STARTER_UNAVAILABLE"] = "%s can be safely erased, from a quest your character cannot take."

-- Auto-Vend
L["SOLD_ITEM"] = "Sold %s%s, worth %s."
L["SOLD_SUMMARY"] = "Sold %s items (%s bag slots), worth %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-Vend will sell once combat ends."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "Pulled %s items (%s bag slots) out of your bank, worth %s."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Magic Eraser will erase this."
L["TOOLTIP_IGNORED"] = "Protected by your Ignore List."
L["TOOLTIP_ON_ERASE_LIST"] = "Flagged by your Erase List."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Lowest Value Item"
L["CLUTTER_REPORT"] = "Clutter Report"
L["CLUTTER_ITEMS"] = "(%s Items)"
L["CLUTTER_SLOTS"] = "%s Bag Slots"
L["NO_VALUE"] = "No Value"
L["LEFT_CLICK"] = "Left-Click"
L["RIGHT_CLICK"] = "Right-Click"
L["MIDDLE_CLICK"] = "Middle-Click"
L["SHIFT_RIGHT_CLICK"] = "Shift + Right-Click"
L["SHIFT_MIDDLE_CLICK"] = "Shift + Middle-Click"
L["ACTION_ERASE"] = "Erase"
L["ACTION_IGNORE"] = "Ignore"
L["ACTION_TOGGLE"] = "Toggle"
L["ACTION_CLEAR_IGNORE"] = "Clear Ignore List"
L["BAGS_CLEAN_CONGRATS"] = "Congratulations, your bags are full of good stuff!"
L["BAGS_CLEAN_HINT"] = "You'll have to manually erase something if you want to free up more space."
L["LOADING_ITEM"] = "Loading ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser Options"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-Vend"
L["AUTO_VEND_DESCRIPTION"] =
	"Automatically sell items flagged as clutter by Magic Eraser when you open a merchant window."
L["IGNORE_LIST"] = "Ignore List"
L["TAB_IGNORE_LIST"] = "Ignore List"
L["TAB_ERASE_LIST"] = "Erase List"
L["ENABLED"] = "Enabled"
L["DISABLED"] = "Disabled"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Erase junk and free up bag space instantly. Completed quest items, low-level consumables, vendor-quality whites, and gray trash go with one click of the mini-map button, and anything sellable auto-sells at the merchant. Never haul vendor trash again."
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_MINIMAP"] = "Enable Mini-map Button"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Enable Auto-Vend"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "Enable Auto-Vend Messages"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Line Item"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Summary Only"

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Maximum Value to Erase"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] = "Never erase an item or stack worth more than the limit you set below."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Enable Maximum Value to Erase"
L["OPTIONS_VALUE_CAP_LIMIT"] = "Never Erase Anything Worth More Than"
L["OPTIONS_VALUE_CAP_GOLD"] = "%d Gold"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Bank Retrieval"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Enable Bank Retrieval"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Automatically pull items flagged as clutter by Magic Eraser out of your bank when you open it, so you can erase them."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Item Tooltips"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Add a line to an item's tooltip in your bags when Magic Eraser would erase it, or when your Ignore List is protecting it."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Enable Tooltips for In-Bag Items"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Bag-Space Warnings"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] = "Count down in chat as your free bag slots drop to the threshold you set below."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Enable Bag-Space Warnings"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Free-Slot Threshold"

-- Eraser Confirmations
L["OPTIONS_SAFETY_HEADER"] = "Eraser Confirmations"
L["OPTIONS_SAFETY_DESCRIPTION"] = "Ask before erasing the item types you check below."
L["OPTIONS_ENABLE_SAFETY"] = "Enable Eraser Confirmations"
L["OPTIONS_SAFETY_QUEST"] = "For Completed Quest Items"
L["OPTIONS_SAFETY_CONSUMABLE"] = "For Low-Level Consumable Items"
L["OPTIONS_SAFETY_WHITE"] = "For White Vendor-Quality Items"
L["OPTIONS_SAFETY_GRAY"] = "For Gray Vendor-Quality Items"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback & Support"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Global"
L["OPTIONS_LIST_ADD_ID"] = "Add by Item ID"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Type an item ID and press Enter. You can also shift-click an item link in chat to drop it in here."
L["OPTIONS_LIST_ADD_ID_INVALID"] = "Type an item ID, or shift-click an item link in chat."
L["OPTIONS_LIST_REMOVE"] = "Remove"
L["OPTIONS_LIST_EMPTY"] = "This list is empty."

--------------------------------------------------------------------------------
-- Options: Ignore List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Items on an Ignore List are never erased and never sold. The Global list protects an item on every character, and a character's own list protects it on that character only."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] = "Move this item to the Global list, so it is protected on every character."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Items on an Erase List are always treated as junk, whatever they are worth: erased by the mini-map button, or sold when you are at a merchant. The Global list applies on every character, and a character's own list applies on that character only. An Ignore List always wins, so an item on both is left alone."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] = "Move this item to the Global list, so it is erased on every character."
L["OPTIONS_ERASE_RESTORE"] = "Restore Defaults"
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Clear this character's Erase List and put back only the items Magic Eraser starts you with? Anything you added yourself is removed."
