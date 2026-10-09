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
L["CHAT_OPTIONS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟選項介面。"
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "基於安全考量，戰鬥中無法開啟按鍵設定清單。"
L["KEY_BINDINGS_LOCATION"] = "開啟遊戲選單，依序點選 %s、%s，然後找到 Magic Eraser 分類。"

-- Eraser
L["COMBAT_LOCKOUT"] = "戰鬥中無法刪除物品。"
L["CONFIRM_ERASE"] = "刪除 %s%s？"
L["BAGS_FULL"] = "你的背包已滿！"
L["BAGS_FULL_NUDGE"] = "你的背包快滿了。還剩 %d 個背包空格。"
L["BAGS_FULL_NUDGE_ONE"] = "你的背包快滿了。還剩 1 個背包空格。"
L["CURSOR_TOO_FAST"] = "慢一點！你的點擊速度超過了遊戲刪除物品的速度。"
L["ERASE_CANDIDATE_CHANGED"] =
	"該物品在刪除前發生了變化，因此沒有刪除任何東西。請查看小地圖按鈕後再試一次。"
L["ERASED_ITEM"] = "已刪除 %s%s。"
L["QUEST_ITEM_READY"] = "%s%s 現在可以安全刪除了。它是你已完成任務的遺留物品。"
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s%s 現在可以安全刪除了。它會開始一個你的角色無法接受的任務。"

-- Auto-Vend
L["SOLD_ITEM"] = "已出售 %s%s，價值 %s。"
L["SOLD_SUMMARY"] = "已出售 %s 件物品（%s 個背包空格），價值 %s。"
L["SOLD_SUMMARY_ONE_SLOT"] = "已出售 %s 件物品（1 個背包空格），價值 %s。"
L["SOLD_SUMMARY_ONE_ITEM"] = "已出售 1 件物品（1 個背包空格），價值 %s。"
L["AUTO_VEND_COMBAT_DEFERRED"] = "戰鬥結束後，自動售賣就會開始出售。"

-- Bank Retrieval
L["BANK_RETRIEVED"] = "已從你的銀行取出 %s 件物品（%s 個背包空格），價值 %s。"
L["BANK_RETRIEVED_ONE_SLOT"] = "已從你的銀行取出 %s 件物品（1 個背包空格），價值 %s。"
L["BANK_RETRIEVED_ONE_ITEM"] = "已從你的銀行取出 1 件物品（1 個背包空格），價值 %s。"

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "已將 %s 加入你的保護清單。"
L["IGNORE_LIST_MOVED"] = "已將 %s 從你的刪除清單移到你的保護清單。"
L["IGNORE_LIST_ALREADY"] = "%s 已在你的保護清單中。"
L["ERASE_LIST_ADDED"] = "已將 %s 加入你的刪除清單。"
L["ERASE_LIST_ALREADY"] = "%s 已在你的刪除清單中。"
L["ERASE_LIST_PROTECTED"] = "%s 在你的保護清單中，而保護清單永遠優先。請先將它從那裡移除。"
L["NO_HOVERED_ITEM"] = "將滑鼠移到物品上，然後再按一次該按鍵。"

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "可能會被刪除。"
L["TOOLTIP_IGNORED"] = "在你的保護清單中。"
L["TOOLTIP_ON_ERASE_LIST"] = "在你的刪除清單中，可能會被刪除。"

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "最低價值物品"
L["CLUTTER_REPORT"] = "雜物報告"
L["CLUTTER_ITEMS"] = "(%s 件物品)"
L["CLUTTER_ITEMS_ONE"] = "(1 件物品)"
L["CLUTTER_SLOTS"] = "%s 個背包空格"
L["CLUTTER_SLOTS_ONE"] = "1 個背包空格"
L["NO_VALUE"] = "無價值"
L["LEFT_CLICK"] = "左鍵點擊"
L["RIGHT_CLICK"] = "右鍵點擊"
L["MIDDLE_CLICK"] = "中鍵點擊"
L["SHIFT_RIGHT_CLICK"] = "Shift + 右鍵點擊"
L["SHIFT_MIDDLE_CLICK"] = "Shift + 中鍵點擊"
L["ACTION_ERASE"] = "刪除"
L["ACTION_IGNORE"] = "保護"
L["ACTION_TOGGLE"] = "切換"
L["ACTION_CLEAR_IGNORE"] = "清空保護清單"
L["BAGS_CLEAN_CONGRATS"] = "恭喜，你的背包裡都是好東西！"
L["BAGS_CLEAN_HINT"] = "如果想騰出更多空間，你得手動刪除一些東西。"
L["LOADING_ITEM"] = "正在載入 ID：%d"
L["MINIMAP_OPTIONS"] = "Magic Eraser 選項"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "刪除最低價值物品"
L["BINDING_ADD_TO_IGNORE_LIST"] = "將滑鼠指向的物品加入保護清單"
L["BINDING_ADD_TO_ERASE_LIST"] = "將滑鼠指向的物品加入刪除清單"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "自動售賣"
L["AUTO_VEND_DESCRIPTION"] = "一開啟商人視窗就出售你的雜物，從最便宜的開始。"
L["TAB_YOUR_CURRENT_BAGS"] = "你目前的背包"
L["TAB_ERASING"] = "刪除"
L["TAB_MERCHANT_BANK"] = "商人與銀行"
L["TAB_ALERTS"] = "提醒與物品提示"
L["TAB_IGNORE_LIST"] = "保護清單"
L["TAB_ERASE_LIST"] = "刪除清單"
L["ENABLED"] = "已啟用"
L["DISABLED"] = "已停用"

-- Example lines under features that print to chat or add a tooltip line. %s is that whole line.
L["OPTIONS_EXAMPLE"] = "範例：%s"
L["OPTIONS_EXAMPLE_ITEM"] = "範例物品"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"刪除雜物，瞬間騰出背包空間。點擊一下小地圖按鈕，即可清理已完成任務的物品、已經用不上的消耗品、只能賣給商人的廢品和灰色物品。精心整理的雜物清單會保護你需要的物品，自動售賣則會在你下次遇到商人時賣掉其餘物品。"
L["OPTIONS_ENABLE_WELCOME"] = "啟用歡迎訊息"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] = "每次登入時，在聊天框顯示一行附帶版本號的歡迎訊息。"
L["OPTIONS_ENABLE_MINIMAP"] = "啟用小地圖按鈕"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] =
	"在小地圖上顯示 Magic Eraser 按鈕。按鈕圖示就是下一件要刪除的物品，滑鼠移到上面會顯示雜物報告。"

-- Features
L["OPTIONS_FEATURES_HEADER"] = "功能"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/指令"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "開啟本插件的選項介面。"

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "按鍵設定"
L["OPTIONS_KEY_SET"] = "設定按鍵"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "開啟遊戲的按鍵設定清單，Magic Eraser 在其中有自己的分類。"
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"刪除下一件物品，效果等同左鍵點擊小地圖按鈕。按下按鍵前不會有預覽，所以請設定在不會誤按的按鍵上。"
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"在此角色上保護滑鼠指向的物品，無論它出現在哪裡：背包、銀行、商人或拾取視窗。如果它在此角色的刪除清單中，會從中移除。"
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"將滑鼠指向的物品加入此角色的刪除清單，無論它價值多少。你的保護清單依然優先。"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "回饋與支援"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "版本 %s"

--------------------------------------------------------------------------------
-- Options: Your Current Bags Panel
--------------------------------------------------------------------------------

L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"] =
	"小地圖按鈕下一件要刪除的物品和排在後面的雜物，接著是你身上的其他所有物品，隨時可以刪除或保護。"
L["OPTIONS_UP_NEXT"] = "下一件"
L["OPTIONS_CLUTTER_TOTAL"] = "總計"
L["OPTIONS_STACKS"] = "(%d 個堆疊)"
L["OPTIONS_ERASE_BUTTON"] = "刪除"
L["OPTIONS_ERASE_BUTTON_DESCRIPTION"] = "刪除下一件物品，效果等同左鍵點擊小地圖按鈕。"
L["OPTIONS_PROTECT_BUTTON"] = "保護"

-- Everything in Your Bags
L["OPTIONS_EVERYTHING_HEADER"] = "背包中的所有物品"
L["OPTIONS_EVERYTHING_DESCRIPTION"] =
	"你身上的每件物品，不論是不是雜物。勾選刪除或保護，即可將它加入此角色的清單。"
L["OPTIONS_COLUMN_ITEM"] = "物品"
L["OPTIONS_COLUMN_TYPE"] = "類型"
L["OPTIONS_COLUMN_ERASE"] = "刪除"
L["OPTIONS_COLUMN_PROTECT"] = "保護"
L["OPTIONS_CHECK_ERASE_DESCRIPTION"] =
	"將此物品加入此角色的刪除清單，讓它無論價值多少都一律視為雜物。同時會將它從此角色的保護清單移除。"
L["OPTIONS_CHECK_ERASE_GLOBAL_DESCRIPTION"] =
	"此物品在所有角色清單中。請到刪除清單或保護清單頁面修改，因為該清單套用於每個角色。"
L["OPTIONS_CHECK_PROTECT_DESCRIPTION"] =
	"將此物品加入此角色的保護清單，讓它永遠不會被刪除或出售。同時會將它從此角色的刪除清單移除。"
L["OPTIONS_CHECK_PROTECT_GLOBAL_DESCRIPTION"] =
	"此物品在所有角色的保護清單中。請到保護清單頁面修改，因為該清單套用於每個角色。"

-- Why an item counts as junk, beside it in the queue.
L["REASON_QUEST"] = "任務已完成"
L["REASON_QUEST_INELIGIBLE"] = "無法接受"
L["REASON_OUTGROWN"] = "已用不上"
L["REASON_EQUIPMENT"] = "白色裝備"
L["REASON_GRAY"] = "灰色"
L["REASON_MANUAL"] = "刪除清單"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] = "每次點擊都會刪除背包中最便宜的雜物，一次一個堆疊。"
L["TAB_ERASING_RESTORE_NOTE"] =
	"附註：幾乎所有誤刪的物品，仍可透過暴雪的物品恢復服務找回。"

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "哪些算是雜物"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"選擇要刪除哪些類型的物品。這些是大致的規則，若要微調，可將任何物品加入保護清單以永遠保留，或加入刪除清單以永遠刪除。"
L["OPTIONS_KIND_QUEST"] = "已完成任務的物品"
L["OPTIONS_KIND_QUEST_DESCRIPTION"] = "在你交完最後一個需要它們的任務後留下的物品。"
L["OPTIONS_KIND_STARTER"] = "無法接受的任務起始物品"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESCRIPTION"] =
	"會開始任務，但你的種族或職業永遠無法接受該任務的物品。"
L["OPTIONS_KIND_FOOD"] = "用不上的食物與飲料"
L["OPTIONS_KIND_FOOD_DESCRIPTION"] =
	"比你首次能使用的等級高出十級後的食物與飲料。新手麵包和水在 5 級時就會被清掉。"
L["OPTIONS_KIND_AMMO"] = "用不上的箭矢與子彈"
L["OPTIONS_KIND_AMMO_DESCRIPTION"] =
	"一旦你能使用商人出售的更好種類，舊的箭矢與子彈就會被清掉。適合你等級的最佳商人彈藥永遠不會被刪除。"
L["OPTIONS_KIND_WHITE"] = "白色武器與護甲"
L["OPTIONS_KIND_WHITE_DESCRIPTION"] =
	"商人願意收購的白色武器與護甲。專業工具、襯衣、正式服裝，以及任務仍需要的白色物品會被保留。"
L["OPTIONS_KIND_GRAY"] = "灰色廢品"
L["OPTIONS_KIND_GRAY_DESCRIPTION"] = "任何商人願意收購的灰色物品。"
L["OPTIONS_KIND_UNCHECKED_DESCRIPTION"] =
	"未勾選時，它就不算雜物：永遠不會被刪除、出售或從銀行取出。"
L["OPTIONS_KINDS_NONE_CHECKED"] =
	"沒有勾選任何類型，因此只有你刪除清單中的物品會被刪除或出售。"

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "刪除的最高價值"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] = "永不刪除價值超過你在下方所設上限的物品或堆疊。"
L["OPTIONS_ENABLE_VALUE_CAP"] = "啟用刪除的最高價值"
L["OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION"] =
	"開啟或關閉價值上限。被它擋下的物品仍會由自動售賣出售，而你的刪除清單不受此限制。"
L["OPTIONS_VALUE_CAP_LIMIT_DESCRIPTION"] =
	"價值超過此金額的堆疊（以整個堆疊的售價計算）永遠不會被刪除。"
L["OPTIONS_VALUE_CAP_GOLD"] = "%d 金"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "手動刪除輔助"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'預設情況下，遊戲會要求你輸入"%s"才能刪除%s或更高品質的物品。此功能會把這個提示改成簡單的是或否。'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "啟用手動刪除輔助"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION"] =
	"開啟或關閉手動刪除輔助。遊戲仍會詢問是或否，只是不必再打字。"
L["OPTIONS_MANUAL_DELETE_SCOPE_DESCRIPTION"] =
	"無出售價值的物品：只簡化商人不收購之物品的提示。所有物品：簡化每一個需要打字的提示。"
L["OPTIONS_MANUAL_DELETE_ALL"] = "所有物品"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "無出售價值的物品"

-- Erase Confirmation
L["OPTIONS_ERASE_CONFIRM_HEADER"] = "刪除確認"
L["OPTIONS_ERASE_CONFIRM_DESCRIPTION"] = "刪除任何物品前先詢問是或否。"
L["OPTIONS_ENABLE_ERASE_CONFIRM"] = "啟用刪除確認"
L["OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION"] =
	"每次刪除前都顯示是或否確認，無論來自小地圖按鈕、快速鍵還是你目前的背包，刪除清單中的物品也包含在內。"

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"一開啟商人視窗就出售你的雜物，並把銀行裡的雜物取回背包一起處理。保護清單中的物品都不會被動到。"

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "啟用自動售賣"
L["OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION"] =
	"開啟或關閉在商人處出售。保護清單中的物品永遠不會被出售。"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "在聊天框顯示總結"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "在聊天框顯示每筆出售"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "不在聊天框報告"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESCRIPTION"] =
	"自動售賣在聊天框顯示的內容。在聊天框顯示總結：每次造訪顯示一筆總計。在聊天框顯示每筆出售：逐筆顯示，最後再顯示總計。不在聊天框報告：不顯示任何內容。"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "銀行取回"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"開啟銀行時取出裡面的雜物，讓它們能和其他雜物一起出售或刪除。只會從你自己的銀行拿取，絕不會動到公會銀行或帳號共用銀行。"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "啟用銀行取回"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESCRIPTION"] =
	"開啟或關閉銀行取回。取出的數量絕不會超過你的背包空格所能容納的量。"
L["OPTIONS_BANK_CUSHION_NOTE"] = "由於背包空間警告已開啟，會保留 %d 個背包空格。"
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] = "由於背包空間警告已開啟，會保留 1 個背包空格。"

--------------------------------------------------------------------------------
-- Options: Alerts & Tooltips Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "Magic Eraser 主動在聊天框與物品提示中告訴你的訊息。"

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "物品提示警告"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"在背包中 Magic Eraser 可能刪除，或受你的保護清單保護的物品提示上，加入一行說明。"
L["OPTIONS_ENABLE_TOOLTIPS"] = "啟用物品提示警告"
L["OPTIONS_ENABLE_TOOLTIPS_DESCRIPTION"] = "開啟或關閉背包物品提示中的 Magic Eraser 說明。"

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "任務物品提醒"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"當背包中的已完成任務的物品或無法接受的任務起始物品可以安全刪除時，立即通知你。"
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "啟用任務物品提醒"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION"] =
	"開啟或關閉聊天框中的提醒。無論如何，已完成任務的物品和無法接受的任務起始物品仍會被刪除。"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "背包空間警告"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"在最後幾個背包空格快被填滿時警告你。開啟商人、信箱或銀行視窗時不會提醒。"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "啟用背包空間警告"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION"] = "開啟或關閉聊天框倒數提醒。"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "空格閾值"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESCRIPTION"] =
	"剩下多少空格時開始倒數。警告開啟時，銀行取回也會保留這麼多空格。"

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "所有角色"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "從背包新增"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESCRIPTION"] =
	"從你身上的物品中挑選。開啟選項介面時背包會關閉，所以這可以代替把物品拖到這裡。"
L["OPTIONS_LIST_ADD_ID"] = "以物品 ID 新增"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"輸入物品 ID 後按 Enter。你也可以在聊天框中 Shift+點擊物品連結，將其填入此處。"
L["OPTIONS_LIST_ADD_ID_INVALID"] = "請輸入物品 ID，或在聊天框中 Shift+點擊物品連結。"
L["OPTIONS_LIST_REMOVE"] = "移除"
L["OPTIONS_LIST_EMPTY"] = "此清單為空。"

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"保護清單中的物品永遠不會被刪除或出售。所有角色清單會在每個角色上保護該物品，而角色自己的清單只在該角色上保護它。"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"將此物品移到所有角色清單，使它在每個角色上都受保護。"

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"刪除清單中的物品無論價值多少都一律視為雜物：由小地圖按鈕刪除，並在商人處出售。你的保護清單依然優先，被它否決的項目會標示為已保護。"
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"將此物品移到所有角色清單，使它在每個角色上都會被刪除，包括從未加入過它的角色。"
L["OPTIONS_LIST_PROTECTED_TAG"] = "已保護"
L["OPTIONS_ERASE_RESTORE"] = "恢復預設"
L["OPTIONS_ERASE_RESTORE_DESCRIPTION"] = "將此角色的刪除清單恢復為 Magic Eraser 的初始物品。"
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"清空此角色的刪除清單，只放回 Magic Eraser 的初始物品？你自己新增的物品都會被移除。"
