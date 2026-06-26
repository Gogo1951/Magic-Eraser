local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "enUS", true)
if not L then return end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] = "Version %s. Settings (including the option to disable this message) can be found under Options > AddOns > Magic Eraser. Enjoying the add-on? Tell a friend about it! (="
L["MESSAGE_RESET"] = "All settings have been reset to defaults."

-- Eraser
L["COMBAT_LOCKOUT"] = "Cannot erase items while in combat."
L["CURSOR_TOO_FAST"] = "Slow down! You are clicking faster than the game can erase items."
L["ERASED_ITEM"] = "Erased %s%s%s."
L["ERASED_VALUE_SUFFIX"] = ", worth %s"
L["ERASED_QUEST_SUFFIX"] = ", this item was associated with a quest you have completed"
L["BAGS_CLEAN"] = "Congratulations, your bags are full of good stuff! You'll have to manually erase something if you want to free up more space."
L["QUEST_ITEM_READY"] = "%s can now be safely erased!"

-- Auto-Vend
L["SOLD_ITEM"] = "Sold %s%s, worth %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-Vend will sell once combat ends."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Lowest Value Item"
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
L["TOOLTIP_HINT"] = "Additional settings can be found under Options > AddOns > Magic Eraser."

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-Vend"
L["AUTO_VEND_DESCRIPTION"] = "Automatically sell items flagged as junk by Magic Eraser."
L["IGNORE_LIST"] = "Ignore List"
L["ON"] = "Enabled"
L["OFF"] = "Disabled"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Magic Eraser identifies the lowest-value junk in your inventory and erases it with a single click on the minimap button. Completed quest items, low-level consumables, vendor-quality whites, and gray trash — gone. When you visit a merchant, Auto-Vend sells the rest for you automatically."
L["OPTIONS_WELCOME"] = "Enable Welcome Message"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "Automatically sell items flagged as junk by Magic Eraser when you open a merchant window."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Enable Auto-Vend"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Enable Auto-Vend Messages"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "Opens the Magic Eraser options interface."
L["OPTIONS_RESET"] = "Reset"
L["OPTIONS_RESET_DESCRIPTION"] = "Restore every option to its default value."
L["OPTIONS_RESET_IGNORE"] = "Reset Ignore List"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Remove all items from the Ignore List on this character?"
L["OPTIONS_RESET_ALL"] = "Reset All Magic Eraser Settings"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Reset all Magic Eraser settings to their defaults? This clears the Ignore List and disables Auto-Vend."
L["OPTIONS_FEEDBACK"] = "Feedback and Support"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
