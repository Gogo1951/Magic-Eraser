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
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "As a safety precaution, the key binding list cannot be opened during combat."
L["KEY_BINDINGS_LOCATION"] = "Open the game menu, then %s, then %s, and find the Magic Eraser section."

-- Eraser
L["COMBAT_LOCKOUT"] = "Cannot erase items while in combat."
L["CONFIRM_ERASE"] = "Erase %s%s?"
L["BAGS_FULL"] = "Your bags are full!"
L["BAGS_FULL_NUDGE"] = "Your bags are nearly full. You have %d slots remaining."
L["BAGS_FULL_NUDGE_ONE"] = "Your bags are nearly full. You have 1 slot remaining."
L["CURSOR_TOO_FAST"] = "Slow down! You're clicking faster than the game can erase items."
L["ERASE_CANDIDATE_CHANGED"] =
	"That item changed before it could be erased, so nothing was erased. Check the mini-map button and try again."
L["ERASED_ITEM"] = "Erased %s%s."
L["QUEST_ITEM_READY"] = "%s%s can now be safely erased. It's left over from a quest you have completed."
L["QUEST_STARTER_UNAVAILABLE"] = "%s%s can now be safely erased. It starts a quest your character can't take."

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

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "Added %s to your Protect List."
L["IGNORE_LIST_MOVED"] = "Moved %s from your Erase List to your Protect List."
L["IGNORE_LIST_ALREADY"] = "%s is already on your Protect List."
L["ERASE_LIST_ADDED"] = "Added %s to your Erase List."
L["ERASE_LIST_ALREADY"] = "%s is already on your Erase List."
L["ERASE_LIST_PROTECTED"] = "%s is on your Protect List, which always wins. Remove it from there first."
L["NO_HOVERED_ITEM"] = "Hover over an item, then press the key again."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "May be erased."
L["TOOLTIP_IGNORED"] = "On your Protect List."
L["TOOLTIP_ON_ERASE_LIST"] = "On your Erase List, and may be erased."

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
L["ACTION_IGNORE"] = "Protect"
L["ACTION_TOGGLE"] = "Toggle"
L["ACTION_CLEAR_IGNORE"] = "Clear Protect List"
L["BAGS_CLEAN_CONGRATS"] = "Congratulations, your bags are full of good stuff!"
L["BAGS_CLEAN_HINT"] = "You'll have to manually erase something if you want to free up more space."
L["LOADING_ITEM"] = "Loading ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser Options"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "Erase Lowest-Value Item"
L["BINDING_ADD_TO_IGNORE_LIST"] = "Add Hovered Item to Protect List"
L["BINDING_ADD_TO_ERASE_LIST"] = "Add Hovered Item to Erase List"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-Vend"
L["AUTO_VEND_DESCRIPTION"] = "Sells your junk the moment you open a merchant, cheapest first."
L["TAB_YOUR_CURRENT_BAGS"] = "Your Current Bags"
L["TAB_ERASING"] = "Erasing"
L["TAB_MERCHANT_BANK"] = "Merchant & Bank"
L["TAB_ALERTS"] = "Alerts & Tooltips"
L["TAB_IGNORE_LIST"] = "Protect List"
L["TAB_ERASE_LIST"] = "Erase List"
L["ENABLED"] = "Enabled"
L["DISABLED"] = "Disabled"

-- Example lines under chat-printing features. %s is the whole chat line.
L["OPTIONS_EXAMPLE"] = "Example: %s"
L["OPTIONS_EXAMPLE_ITEM"] = "Example Item"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Erase junk and free up bag space instantly. Clear completed quest items, outgrown consumables, vendor trash, and grays with a click of the mini-map button. A curated junk list keeps what you need safe, while Auto-Vend sells the rest at your next merchant."
L["OPTIONS_ENABLE_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "Prints a one-line welcome with the version in chat each time you log in."
L["OPTIONS_ENABLE_MINIMAP"] = "Enable Mini-map Button"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] =
	"Shows the Magic Eraser button on your mini-map. Its icon is the next item up, and hovering it shows the Clutter Report."

-- Features
L["OPTIONS_FEATURES_HEADER"] = "Features"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Opens the Options Interface for this add-on."

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Key Bindings"
L["OPTIONS_KEY_SET"] = "Set Key"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "Opens the game's key binding list, where Magic Eraser has its own section."
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Erases the next item up, same as a left-click on the mini-map button. There's no preview before a keypress, so bind it somewhere you won't hit by accident."
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"Protects the item under your mouse on this character, wherever you see it: bags, bank, merchant or loot window. If it was on this character's Erase List, it comes off."
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"Adds the item under your mouse to this character's Erase List, whatever it's worth. Your Protect List still wins."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback & Support"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Options: Your Current Bags Panel
--------------------------------------------------------------------------------

L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"] =
	"What the mini-map button erases next and the junk behind it, then everything else you're carrying, ready to erase or protect."
L["OPTIONS_UP_NEXT"] = "Up Next"
L["OPTIONS_CLUTTER_TOTAL"] = "Total"
L["OPTIONS_STACKS"] = "(%d stacks)"
L["OPTIONS_ERASE_BUTTON"] = "Erase"
L["OPTIONS_ERASE_BUTTON_DESCRIPTION"] = "Erases the next item up, same as a left-click on the mini-map button."
L["OPTIONS_PROTECT_BUTTON"] = "Protect"
L["OPTIONS_PROTECT_BUTTON_DESCRIPTION"] =
	"Adds this item to this character's Protect List, so it's never erased or sold."

-- Everything in Your Bags
L["OPTIONS_EVERYTHING_HEADER"] = "Everything in Your Bags"
L["OPTIONS_EVERYTHING_DESCRIPTION"] =
	"Every item you're carrying, junk or not. Check Erase or Protect to put it on this character's list."
L["OPTIONS_COLUMN_ITEM"] = "Item"
L["OPTIONS_COLUMN_TYPE"] = "Type"
L["OPTIONS_COLUMN_ERASE"] = "Erase"
L["OPTIONS_COLUMN_PROTECT"] = "Protect"
L["OPTIONS_CHECK_ERASE_DESCRIPTION"] =
	"Puts this item on this character's Erase List, so it's always junk, whatever it's worth. Takes it off this character's Protect List."
L["OPTIONS_CHECK_ERASE_GLOBAL_DESCRIPTION"] =
	"This item is on an All Characters list. Change it on the Erase List or Protect List page, since that list applies to every character."
L["OPTIONS_CHECK_PROTECT_DESCRIPTION"] =
	"Puts this item on this character's Protect List, so it's never erased or sold. Takes it off this character's Erase List."
L["OPTIONS_CHECK_PROTECT_GLOBAL_DESCRIPTION"] =
	"This item is on the All Characters Protect List. Change it on the Protect List page, since that list applies to every character."

-- Why an item counts as junk, beside it in the queue.
L["REASON_QUEST"] = "Quest Done"
L["REASON_QUEST_INELIGIBLE"] = "Can't Take"
L["REASON_OUTGROWN"] = "Outgrown"
L["REASON_EQUIPMENT"] = "White Gear"
L["REASON_GRAY"] = "Gray"
L["REASON_MANUAL"] = "Erase List"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] = "Each click erases the cheapest junk in your bags, one stack at a time."
L["TAB_ERASING_RESTORE_NOTE"] =
	"FYI: Nearly anything erased by mistake can still be recovered through Blizzard's item restoration service!"

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "What Counts as Junk"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"Choose which kinds of items get erased. These are broad rules, so to fine-tune them, add any item to your Protect List to always keep it, or to your Erase List to always erase it."
L["OPTIONS_KIND_QUEST"] = "Completed Quest Items"
L["OPTIONS_KIND_QUEST_DESCRIPTION"] = "Items left over once you've handed in the last quest that needs them."
L["OPTIONS_KIND_STARTER"] = "Dead-End Quest Starters"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESCRIPTION"] = "Items that start a quest your race or class can never take."
L["OPTIONS_KIND_FOOD"] = "Outgrown Food & Drink"
L["OPTIONS_KIND_FOOD_DESCRIPTION"] =
	"Food and drink ten levels past the level you could first use it. Starter bread and water go at level 5."
L["OPTIONS_KIND_AMMO"] = "Outgrown Arrows & Bullets"
L["OPTIONS_KIND_AMMO_DESCRIPTION"] =
	"Arrows and bullets the moment you can use a better kind sold by vendors. The best vendor ammo for your level is never erased."
L["OPTIONS_KIND_WHITE"] = "White Weapons & Armor"
L["OPTIONS_KIND_WHITE_DESCRIPTION"] =
	"White weapons and armor a vendor will buy. Profession tools, shirts, formal wear and whites a quest still needs are kept."
L["OPTIONS_KIND_GRAY"] = "Gray Trash"
L["OPTIONS_KIND_GRAY_DESCRIPTION"] = "Any gray item a vendor will buy."
L["OPTIONS_KIND_UNCHECKED_DESCRIPTION"] = "Unchecked, it isn't junk: never erased, sold or pulled from the bank."
L["OPTIONS_KINDS_NONE_CHECKED"] = "No kind is checked, so only your Erase List is erased or sold."

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Maximum Value to Erase"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] = "Never erase an item or stack worth more than the limit you set below."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Enable Maximum Value to Erase"
L["OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION"] =
	"Turns the value limit on or off. Auto-Vend still sells anything it holds back, and your Erase List isn't limited by it."
L["OPTIONS_VALUE_CAP_LIMIT_DESCRIPTION"] =
	"Stacks worth more than this, counting the whole stack's sale value, are never erased."
L["OPTIONS_VALUE_CAP_GOLD"] = "%d Gold"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Manual Delete Assistance"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'By default, the game makes you type "%s" when deleting a %s or better item. This turns that prompt into a simple Yes or No.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Enable Manual Delete Assistance"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION"] =
	"Turns Manual Delete Assistance on or off. The game still asks Yes or No; only the typing goes away."
L["OPTIONS_MANUAL_DELETE_SCOPE_DESCRIPTION"] =
	"Items with No Sale Value simplifies only items no vendor will buy. All Items simplifies every typed prompt."
L["OPTIONS_MANUAL_DELETE_ALL"] = "All Items"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "Items with No Sale Value"

-- Erase Confirmation
L["OPTIONS_ERASE_CONFIRM_HEADER"] = "Erase Confirmation"
L["OPTIONS_ERASE_CONFIRM_DESCRIPTION"] = "Asks Yes or No before anything is erased."
L["OPTIONS_ENABLE_ERASE_CONFIRM"] = "Enable Erase Confirmation"
L["OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION"] =
	"Shows a Yes or No before every erase, from the mini-map button, the key binding or Your Current Bags, including items on your Erase List."

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"Sells your junk the moment you open a merchant, and brings junk in your bank back to your bags to go with it. Nothing on your Protect List is touched."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Enable Auto-Vend"
L["OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION"] =
	"Turns selling at merchants on or off. Items on your Protect List are never sold."
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Summary in Chat"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Every Sale in Chat"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "No Chat Report"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESCRIPTION"] =
	"What Auto-Vend prints in chat. Summary in Chat prints one total per visit. Every Sale in Chat prints each sale, then the total. No Chat Report prints nothing."

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Bank Retrieval"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Pulls junk out of your bank when you open it, so it can be sold or erased with the rest. It only ever takes from your own bank, never a guild bank or an account-wide bank."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Enable Bank Retrieval"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESCRIPTION"] =
	"Turns bank retrieval on or off. It never pulls more than your free bag slots can hold."
L["OPTIONS_BANK_CUSHION_NOTE"] = "Leaves %d bag slots free, because Bag-Space Warnings are on."
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] = "Leaves 1 bag slot free, because Bag-Space Warnings are on."

--------------------------------------------------------------------------------
-- Options: Alerts & Tooltips Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "What Magic Eraser tells you on its own, in chat and in tooltips."

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "Tooltip Warnings"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Adds a line to the tooltip of anything in your bags that Magic Eraser may erase, or that your Protect List protects."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Enable Tooltip Warnings"
L["OPTIONS_ENABLE_TOOLTIPS_DESCRIPTION"] = "Turns the Magic Eraser line in bag tooltips on or off."

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "Quest Item Alerts"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"Lets you know the moment a Completed Quest Item or Dead-End Quest Starter in your bags is safe to erase."
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "Enable Quest Item Alerts"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION"] =
	"Turns these messages on or off. Completed Quest Items and Dead-End Quest Starters are still erased either way."

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Bag-Space Warnings"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Warns you as your last free bag slots fill up. Stays quiet while a merchant, mailbox or bank window is open."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Enable Bag-Space Warnings"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION"] = "Turns the chat countdown on or off."
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Free-Slot Threshold"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESCRIPTION"] =
	"How many free slots start the countdown. While warnings are on, Bank Retrieval also leaves this many slots free."

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "All Characters"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "Add from Bags"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESCRIPTION"] =
	"Pick anything you're carrying. The bags close when the Options Interface opens, so this stands in for dragging an item here."
L["OPTIONS_LIST_ADD_ID"] = "Add by Item ID"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Type an item ID and press Enter. You can also Shift-click an item link in chat to drop it in here."
L["OPTIONS_LIST_ADD_ID_INVALID"] = "Type an item ID, or Shift-click an item link in chat."
L["OPTIONS_LIST_REMOVE"] = "Remove"
L["OPTIONS_LIST_EMPTY"] = "This list is empty."
L["OPTIONS_LIST_PROTECTED_TAG"] = "Protected"

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Items on a Protect List are never erased and never sold. The All Characters list protects an item everywhere, and a character's own list protects it there only."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] = "Moves this item to the All Characters list, so it's protected everywhere."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Items on an Erase List are always junk, whatever they're worth: erased by the mini-map button and sold at merchants. Your Protect List still wins, and a row it overrules says Protected."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"Moves this item to the All Characters list, so it's erased on every character, including ones it was never added for."
L["OPTIONS_ERASE_RESTORE"] = "Restore Defaults"
L["OPTIONS_ERASE_RESTORE_DESCRIPTION"] =
	"Puts this character's Erase List back to the items Magic Eraser starts it with."
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Clear this character's Erase List and put back only the items Magic Eraser starts you with? Anything you added yourself is removed."
