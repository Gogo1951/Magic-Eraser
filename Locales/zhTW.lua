local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "zhTW")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] = "版本 %s。設定（包含關閉此訊息的選項）可以在 選項 > 插件 > Magic Eraser 中找到。喜歡這個插件嗎？告訴朋友吧！(="
L["MESSAGE_RESET"] = "所有設定已恢復為預設值。"

-- Eraser
L["COMBAT_LOCKOUT"] = "戰鬥中無法刪除物品。"
L["CURSOR_TOO_FAST"] = "慢一點！你的點擊速度超過了遊戲刪除物品的速度。"
L["ERASED_ITEM"] = "已刪除 %s%s%s。"
L["ERASED_VALUE_SUFFIX"] = "，價值 %s"
L["ERASED_QUEST_SUFFIX"] = "，該物品關聯的任務已完成"
L["BAGS_CLEAN"] = "恭喜，你的背包裡都是好東西！如果需要更多空間，你需要手動刪除一些物品。"
L["QUEST_ITEM_READY"] = "%s 現在可以安全刪除了！"

-- Auto-Vend
L["SOLD_ITEM"] = "已出售 %s%s，價值 %s。"
L["AUTO_VEND_COMBAT_DEFERRED"] = "戰鬥結束後將執行自動售賣。"

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "最低價值物品"
L["NO_VALUE"] = "無價值"
L["LEFT_CLICK"] = "左鍵點擊"
L["RIGHT_CLICK"] = "右鍵點擊"
L["MIDDLE_CLICK"] = "中鍵點擊"
L["SHIFT_RIGHT_CLICK"] = "Shift + 右鍵點擊"
L["ACTION_ERASE"] = "刪除"
L["ACTION_IGNORE"] = "忽略"
L["ACTION_TOGGLE"] = "切換"
L["ACTION_CLEAR_IGNORE"] = "清空忽略清單"
L["BAGS_CLEAN_SHORT"] = "恭喜，你的背包裡都是好東西！"
L["BAGS_CLEAN_HINT"] = "如果需要更多空間，你需要手動刪除一些物品。"
L["LOADING_ITEM"] = "載入中 ID: %d"
L["TOOLTIP_HINT"] = "更多設定請前往 選項 > 插件 > Magic Eraser."

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "自動售賣"
L["AUTO_VEND_DESCRIPTION"] = "自動出售被 Magic Eraser 標記為垃圾的物品。"
L["IGNORE_LIST"] = "忽略清單"
L["ON"] = "已啟用"
L["OFF"] = "已停用"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Magic Eraser 可以識別你背包中價值最低的垃圾，只需點擊小地圖按鈕即可將其刪除。已完成的任務物品、低等級消耗品、可售賣給商人的白色物品以及灰色垃圾——通通清理掉。當你拜訪商人時，自動售賣會自動為你出售剩下的物品。"
L["OPTIONS_WELCOME"] = "啟用歡迎訊息"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "開啟商人視窗時自動出售被 Magic Eraser 標記為垃圾的物品。"
L["OPTIONS_ENABLE_AUTO_VEND"] = "啟用自動售賣"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "啟用自動售賣訊息"
L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "開啟 Magic Eraser 選項介面。"
L["OPTIONS_RESET"] = "重置"
L["OPTIONS_RESET_DESCRIPTION"] = "將所有選項恢復為預設值。"
L["OPTIONS_RESET_IGNORE"] = "重置忽略清單"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "移除該角色忽略清單中的所有物品？"
L["OPTIONS_RESET_ALL"] = "重置所有 Magic Eraser 設定"
L["OPTIONS_RESET_ALL_CONFIRM"] = "將所有 Magic Eraser 設定恢復為預設值？忽略清單將被清空，自動售賣將被停用。"
L["OPTIONS_FEEDBACK"] = "回饋與支援"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
