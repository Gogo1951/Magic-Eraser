local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "zhTW")
if not L then return end

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "版本 @project-version@。設定可以在 選項 > 插件 > Magic Eraser 中找到，包含關閉此訊息。喜歡 Magic Eraser 嗎？告訴朋友吧！(="
L["COMBAT_LOCKOUT"] = "戰鬥中無法刪除物品。"
L["ERASED_ITEM"] = "已刪除 %s%s%s。"
L["ERASED_QUEST_SUFFIX"] = "，該物品關聯的任務已完成"
L["ERASED_VALUE_SUFFIX"] = "，價值 %s"
L["SOLD_ITEM"] = "已出售 %s%s，價值 %s。"
L["CURSOR_TOO_FAST"] = "慢一點！你的點擊速度超過了遊戲刪除物品的速度。"
L["BAGS_CLEAN"] = "恭喜，你的背包裡都是好東西！如果需要更多空間，你需要手動刪除一些物品。"
L["QUEST_ITEM_READY"] = "%s 現在可以安全刪除了！"

--------------------------------------------------------------------------------
-- Tooltip
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
-- Auto-Vend
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "自動售賣"
L["AUTO_VEND_DESC"] = "自動出售被 Magic Eraser 標記為垃圾的物品。"
L["ENABLED"] = "已啟用"
L["DISABLED"] = "已停用"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

L["IGNORE_LIST"] = "忽略清單"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "使用 Magic Eraser 解決背包雜亂問題。自動刪除低價值物品、灰色垃圾和舊任務物品。功能包含自動售賣、易於配置的忽略清單以及保持背包整潔的智能掃描。"
L["OPTIONS_WELCOME"] = "啟用歡迎訊息"
L["OPTIONS_AUTO_VEND_DESC"] = "開啟商人視窗時自動出售被 Magic Eraser 標記為垃圾的物品。"
L["OPTIONS_RESET"] = "重置"
L["OPTIONS_RESET_IGNORE"] = "重置忽略清單"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "移除該角色忽略清單中的所有物品？"
L["OPTIONS_RESET_ALL"] = "重置所有 Magic Eraser 設定"
L["OPTIONS_RESET_ALL_CONFIRM"] = "將所有 Magic Eraser 設定恢復為預設值？忽略清單將被清空，自動售賣將被停用。"
L["OPTIONS_FEEDBACK"] = "回饋與支援"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"