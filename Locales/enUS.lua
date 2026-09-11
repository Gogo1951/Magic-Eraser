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
L["ERASED_ITEM_FROM_QUEST"] = "Erased %s%s, left over from a quest you have completed."
L["ERASED_ITEM_QUEST_UNAVAILABLE"] = "Erased %s%s, which starts a quest your character cannot take."
L["QUEST_ITEM_READY"] = "%s can now be safely erased!"
L["QUEST_STARTER_UNAVAILABLE"] = "%s can be safely erased. It starts a quest your character cannot take."

-- Auto-Vend
L["SOLD_ITEM"] = "Sold %s%s, worth %s."
L["SOLD_SUMMARY"] = "Sold %s items (%s bag slots), worth %s."
L["SOLD_SUMMARY_ONE_SLOT"] = "Sold %s items (1 bag slot), worth %s."
L["SOLD_SUMMARY_ONE_ITEM"] = "Sold 1 item (1 bag slot), worth %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-Vend will sell once combat ends."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "Pulled %s items (%s bag slots) out of your bank, worth %s."
L["BANK_RETRIEVED_ONE_SLOT"] = "Pulled %s items (1 bag slot) out of your bank, worth %s."
L["BANK_RETRIEVED_ONE_ITEM"] = "Pulled 1 item (1 bag slot) out of your bank, worth %s."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Will be erased."
L["TOOLTIP_IGNORED"] = "Protected by your Ignore List."
L["TOOLTIP_ON_ERASE_LIST"] = "Flagged by your Erase List."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Lowest-Value Item"
L["CLUTTER_REPORT"] = "Clutter Report"
L["CLUTTER_ITEMS"] = "(%s Items)"
L["CLUTTER_ITEMS_ONE"] = "(1 Item)"
L["CLUTTER_SLOTS"] = "%s Bag Slots"
L["CLUTTER_SLOTS_ONE"] = "1 Bag Slot"
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
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "Erase Lowest-Value Item"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-Vend"
L["AUTO_VEND_DESCRIPTION"] =
	"Automatically sell items flagged as clutter by Magic Eraser when you open a merchant window."
L["TAB_SAFETY"] = "Safety Features"
L["TAB_IGNORE_LIST"] = "Ignore List"
L["TAB_ERASE_LIST"] = "Erase List"
L["ENABLED"] = "Enabled"
L["DISABLED"] = "Disabled"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Erase junk and free up bag space instantly. Clear completed quest items, outgrown consumables, vendor trash, and grays with one click. A curated junk list keeps it safe, while Auto-Vend sells the rest at your next merchant."
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_MINIMAP"] = "Enable Mini-map Button"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Key Bindings"
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Does exactly what Left-clicking the mini-map button does. Use at your own risk: a stray keypress erases just as surely as a deliberate one. Set it under Key Bindings in the game menu, in the Magic Eraser section."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Enable Auto-Vend"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "Enable Auto-Vend Messages"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Line Item"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Summary Only"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback & Support"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Safety Panel
--------------------------------------------------------------------------------

L["TAB_SAFETY_DESCRIPTION"] =
	"Nearly every item you erase can be brought back through Blizzard's item restoration service, so a mistake here is rarely permanent. These settings are still worth a look: they are where you decide how cautious Magic Eraser is, and how much it tells you along the way."

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "Tooltip Warnings"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Add a line to an item's tooltip in your bags when Magic Eraser would erase it, or when your Ignore List is protecting it."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Enable Tooltip Warnings"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Bank Retrieval"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Automatically pull items flagged as clutter by Magic Eraser out of your bank when you open it, so you can erase them."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Enable Bank Retrieval"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Manual Delete Assistance"
L["OPTIONS_MANUAL_DELETE_DESCRIPTION"] =
	'By default, Rare and better items make you type "%s" before you can toss them. This turns that into a simple Yes or No, for the items you choose below.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Enable Manual Delete Assistance"
L["OPTIONS_MANUAL_DELETE_SCOPE"] = "Applies To"
L["OPTIONS_MANUAL_DELETE_ALL"] = "All Items"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "No Sale Value"

-- Mini-map Eraser Confirmation
L["OPTIONS_SAFETY_HEADER"] = "Mini-map Eraser Confirmation"
L["OPTIONS_SAFETY_DESCRIPTION"] = "Ask before erasing the item types you check below."
L["OPTIONS_ENABLE_SAFETY"] = "Enable Mini-map Eraser Confirmation"
L["OPTIONS_SAFETY_QUEST"] = "For Completed Quest Items"
L["OPTIONS_SAFETY_CONSUMABLE"] = "For Outgrown Consumable Items"
L["OPTIONS_SAFETY_WHITE"] = "For White Vendor-Quality Items"
L["OPTIONS_SAFETY_GRAY"] = "For Gray Vendor-Trash Items"

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Maximum Value to Erase"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] = "Never erase an item or stack worth more than the limit you set below."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Enable Maximum Value to Erase"
L["OPTIONS_VALUE_CAP_LIMIT"] = "Never Erase Anything Worth More Than"
L["OPTIONS_VALUE_CAP_GOLD"] = "%d Gold"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Bag-Space Warnings"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] = "Count down in chat once your free bag slots drop to the threshold you set below."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Enable Bag-Space Warnings"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Free-Slot Threshold"

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Global"
L["OPTIONS_LIST_ADD_ID"] = "Add by Item ID"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Type an item ID and press Enter. You can also Shift-click an item link in chat to drop it in here."
L["OPTIONS_LIST_ADD_ID_INVALID"] = "Type an item ID, or Shift-click an item link in chat."
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
	"Items on an Erase List are always treated as clutter, whatever they are worth: erased by the mini-map button, or sold when you are at a merchant. The Global list applies on every character, and a character's own list applies on that character only. An Ignore List always wins, so an item on both is left alone."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] = "Move this item to the Global list, so it is erased on every character."
L["OPTIONS_ERASE_RESTORE"] = "Restore Defaults"
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Clear this character's Erase List and put back only the items Magic Eraser starts you with? Anything you added yourself is removed."
