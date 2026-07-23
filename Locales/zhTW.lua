local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "zhTW")
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
	"版本 %s。設定（包含關閉此訊息的選項）可以在 選項 > 插件 > Magic Eraser 中找到。喜歡這個插件嗎？告訴朋友吧！(="

-- Eraser
L["COMBAT_LOCKOUT"] = "戰鬥中無法刪除物品。"
L["CONFIRM_ERASE"] = "刪除 %s%s？"
L["BAGS_FULL"] = "你的背包已滿！"
L["BAGS_FULL_NUDGE"] = "你的背包快滿了。還剩 %d 個空格。"
L["BAGS_FULL_NUDGE_ONE"] = "你的背包快滿了。還剩 1 個空格。"
L["CURSOR_TOO_FAST"] = "慢一點！你的點擊速度超過了遊戲刪除物品的速度。"
L["ERASED_ITEM"] = "已刪除 %s%s。"
L["ERASED_ITEM_WITH_VALUE"] = "已刪除 %s%s，價值 %s。"
L["ERASED_ITEM_FROM_QUEST"] = "已刪除 %s%s，來自你已完成的任務。"
L["QUEST_ITEM_READY"] = "%s 現在可以安全刪除了！"

-- Auto-Vend
L["SOLD_ITEM"] = "已出售 %s%s，價值 %s。"
L["SOLD_SUMMARY"] = "已出售 %s 件物品（%s 個格子），價值 %s。"
L["AUTO_VEND_COMBAT_DEFERRED"] = "戰鬥結束後將執行自動售賣。"

-- Bank Retrieval
L["BANK_RETRIEVED"] = "已從銀行取出 %s 件物品（%s 個格子），價值 %s。"

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Magic Eraser 將刪除此物品。"
L["TOOLTIP_IGNORED"] = "受你的忽略清單保護。"

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "最低價值物品"
L["CLUTTER_REPORT"] = "雜物報告"
L["CLUTTER_ITEMS"] = "(%s 件物品)"
L["CLUTTER_SLOTS"] = "%s 個格子"
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
L["MINIMAP_OPTIONS"] = "Magic Eraser 選項"
L["MINIMAP_OPTIONS_KEYBIND"] = "Shift + 中鍵點擊"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "自動售賣"
L["AUTO_VEND_DESCRIPTION"] = "開啟商人視窗時自動出售被 Magic Eraser 標記為垃圾的物品。"
L["IGNORE_LIST"] = "忽略清單"
L["ON"] = "已啟用"
L["OFF"] = "已停用"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"瞬間清理你的背包。每次點擊小地圖按鈕，都會刪除已完成的任務物品、低等級消耗品、可售賣給商人的白色物品以及灰色垃圾。當你拜訪商人時，所有可出售的物品都會自動售出。"
L["OPTIONS_ENABLE_WELCOME"] = "啟用歡迎訊息"
L["OPTIONS_ENABLE_MINIMAP"] = "啟用小地圖按鈕"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_COMMAND_ERASER"] = "/eraser"
L["OPTIONS_COMMAND_ERASER_DESCRIPTION"] = "開啟 Magic Eraser 選項面板。"

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "啟用自動售賣"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "啟用自動售賣訊息"
L["OPTIONS_AUTO_VEND_VERBOSE"] = "逐項"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "僅彙總"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "銀行取回"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "啟用銀行取回"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"開啟銀行時自動取出被 Magic Eraser 標記為垃圾的物品，方便你刪除它們。"

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "物品提示"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"當 Magic Eraser 會刪除某件背包物品，或忽略清單正在保護它時，為該物品的提示加入一行說明。"
L["OPTIONS_ENABLE_TOOLTIPS"] = "為背包內物品啟用提示"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "背包空間警告"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"當背包空格減少到你在下方設定的閾值時，在聊天框中倒數提醒。"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "啟用背包空間警告"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "空格閾值"

-- Eraser Confirmations
L["OPTIONS_SAFETY_HEADER"] = "刪除確認"
L["OPTIONS_SAFETY_DESCRIPTION"] = "在刪除下方勾選的物品類型前先詢問。"
L["OPTIONS_ENABLE_SAFETY"] = "啟用刪除確認"
L["OPTIONS_SAFETY_QUEST"] = "對已完成任務的物品"
L["OPTIONS_SAFETY_CONSUMABLE"] = "對低等級消耗品"
L["OPTIONS_SAFETY_WHITE"] = "對可售賣的白色物品"
L["OPTIONS_SAFETY_GRAY"] = "對可售賣的灰色物品"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "回饋與支援"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Ignore List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"忽略清單中的物品永遠不會被刪除或出售。全域清單會在所有角色上保護該物品，而角色自己的清單只在該角色上保護它。"
L["OPTIONS_IGNORE_GLOBAL"] = "全域"
L["OPTIONS_IGNORE_ADD_ID"] = "以物品 ID 新增"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"輸入物品 ID 後按 Enter。你也可以在聊天框中 Shift+點擊物品連結，將其填入此處。"
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "請輸入物品 ID，或在聊天框中 Shift+點擊物品連結。"
L["OPTIONS_IGNORE_PROMOTE"] = "全域"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] = "將此物品移到全域清單，使其在所有角色上都受保護。"
L["OPTIONS_IGNORE_REMOVE"] = "移除"
L["OPTIONS_IGNORE_EMPTY"] = "此清單為空。"
