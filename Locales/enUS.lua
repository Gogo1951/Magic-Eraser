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

-- Eraser
L["COMBAT_LOCKOUT"] = "Cannot erase items while in combat."
L["CONFIRM_ERASE"] = "Erase %s%s?"
L["BAGS_FULL"] = "Your bags are full!"
L["BAGS_FULL_NUDGE"] = "Your bags are nearly full. You have %d slots remaining."
L["BAGS_FULL_NUDGE_ONE"] = "Your bags are nearly full. You have 1 slot remaining."
L["CURSOR_TOO_FAST"] = "Slow down! You are clicking faster than the game can erase items."
L["ERASED_ITEM"] = "Erased %s%s%s."
L["ERASED_VALUE_SUFFIX"] = ", worth %s"
L["ERASED_QUEST_SUFFIX"] = ", this item was associated with a quest you have completed"
L["QUEST_ITEM_READY"] = "%s can now be safely erased!"

-- Item Tooltip
L["TOOLTIP_WILL_ERASE"] = "Magic Eraser will erase this."
L["TOOLTIP_IGNORED"] = "Protected by your Ignore List."

-- Auto-Vend
L["SOLD_ITEM"] = "Sold %s%s, worth %s."
L["SOLD_SUMMARY"] = "Sold %s Items (%s Bag Slots), worth %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-Vend will sell once combat ends."

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
L["ACTION_ERASE"] = "Erase"
L["ACTION_IGNORE"] = "Ignore"
L["ACTION_TOGGLE"] = "Toggle"
L["ACTION_CLEAR_IGNORE"] = "Clear Ignore List"
L["BAGS_CLEAN_SHORT"] = "Congratulations, your bags are full of good stuff!"
L["BAGS_CLEAN_HINT"] = "You'll have to manually erase something if you want to free up more space."
L["LOADING_ITEM"] = "Loading ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser Options"
L["MINIMAP_OPTIONS_KEYBIND"] = "Shift + Middle-Click"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-Vend"
L["AUTO_VEND_DESCRIPTION"] = "Automatically sell items flagged as junk by Magic Eraser when you open a merchant window."
L["IGNORE_LIST"] = "Ignore List"
L["ON"] = "Enabled"
L["OFF"] = "Disabled"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Clean up your bags instantly. Completed quest items, low-level consumables, vendor-quality whites, and gray trash are erased with each click of the mini-map button. When you visit a merchant, anything that can be is sold automatically."
L["OPTIONS_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_MINIMAP"] = "Enable Mini-map Button"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commands"
L["OPTIONS_COMMAND_ERASER"] = "/eraser"
L["OPTIONS_COMMAND_ERASER_DESCRIPTION"] = "Opens the Magic Eraser options interface."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Item Tooltips"
L["OPTIONS_TOOLTIP_WARNING"] = "Enable Tooltips for In-Bag Items"

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Enable Auto-Vend"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Enable Auto-Vend Messages"
L["OPTIONS_AUTO_VEND_VERBOSE"] = "Line Item"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Summary Only"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Bag-Space Warnings"
L["OPTIONS_BAGS_FULL_NUDGE"] = "Enable Bag-Space Warnings"
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
