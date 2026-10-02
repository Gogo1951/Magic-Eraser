local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "zhCN")
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
	"版本 %s。设置（包括关闭此消息的选项）可以在 选项 > 插件 > Magic Eraser 中找到。喜欢这个插件吗？告诉朋友吧！(="
L["CHAT_OPTIONS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开选项界面。"
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "出于安全考虑，战斗中无法打开按键设置列表。"

-- Eraser
L["COMBAT_LOCKOUT"] = "战斗中无法删除物品。"
L["CONFIRM_ERASE"] = "删除 %s%s？"
L["BAGS_FULL"] = "你的背包已满！"
L["BAGS_FULL_NUDGE"] = "你的背包快满了。还剩 %d 个背包格子。"
L["BAGS_FULL_NUDGE_ONE"] = "你的背包快满了。还剩 1 个背包格子。"
L["CURSOR_TOO_FAST"] = "慢一点！你的点击速度超过了游戏删除物品的速度。"
L["ERASE_CANDIDATE_CHANGED"] =
	"该物品在删除前发生了变化，因此没有删除任何物品。请查看小地图按钮后再试一次。"
L["ERASED_ITEM"] = "已删除 %s%s。"
L["ERASED_ITEM_WITH_VALUE"] = "已删除 %s%s，价值 %s。"
L["ERASED_ITEM_FROM_QUEST"] = "已删除 %s%s，这是你已完成任务的遗留物品。"
L["ERASED_ITEM_QUEST_UNAVAILABLE"] = "已删除 %s%s，它会开启一个你的角色无法接取的任务。"
L["QUEST_ITEM_READY"] = "%s%s 现在可以安全删除了。它是你已完成任务的遗留物品。"
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s%s 现在可以安全删除了。它会开启一个你的角色无法接取的任务。"

-- Auto-Vend
L["SOLD_ITEM"] = "已出售 %s%s，价值 %s。"
L["SOLD_SUMMARY"] = "已出售 %s 件物品（%s 个背包格子），价值 %s。"
L["SOLD_SUMMARY_ONE_SLOT"] = "已出售 %s 件物品（1 个背包格子），价值 %s。"
L["SOLD_SUMMARY_ONE_ITEM"] = "已出售 1 件物品（1 个背包格子），价值 %s。"
L["AUTO_VEND_COMBAT_DEFERRED"] = "自动售卖将在战斗结束后进行。"

-- Bank Retrieval
L["BANK_RETRIEVED"] = "已从银行取出 %s 件物品（%s 个背包格子），价值 %s。"
L["BANK_RETRIEVED_ONE_SLOT"] = "已从银行取出 %s 件物品（1 个背包格子），价值 %s。"
L["BANK_RETRIEVED_ONE_ITEM"] = "已从银行取出 1 件物品（1 个背包格子），价值 %s。"

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "已将 %s 加入你的保护列表。"
L["IGNORE_LIST_MOVED"] = "已将 %s 从你的删除列表移到保护列表。"
L["IGNORE_LIST_ALREADY"] = "%s 已在你的保护列表中。"
L["ERASE_LIST_ADDED"] = "已将 %s 加入你的删除列表。"
L["ERASE_LIST_ALREADY"] = "%s 已在你的删除列表中。"
L["ERASE_LIST_PROTECTED"] = "%s 在你的保护列表中，保护列表始终优先。请先将它从那里移除。"
L["NO_HOVERED_ITEM"] = "请将鼠标悬停在物品上，然后再按一次该按键。"

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "可能会被删除。"
L["TOOLTIP_IGNORED"] = "在你的保护列表中。"
L["TOOLTIP_ON_ERASE_LIST"] = "在你的删除列表中，可能会被删除。"

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "最低价值物品"
L["CLUTTER_REPORT"] = "杂物报告"
L["CLUTTER_ITEMS"] = "(%s 件物品)"
L["CLUTTER_ITEMS_ONE"] = "(1 件物品)"
L["CLUTTER_SLOTS"] = "%s 个背包格子"
L["CLUTTER_SLOTS_ONE"] = "1 个背包格子"
L["NO_VALUE"] = "无价值"
L["LEFT_CLICK"] = "左键点击"
L["RIGHT_CLICK"] = "右键点击"
L["MIDDLE_CLICK"] = "中键点击"
L["SHIFT_RIGHT_CLICK"] = "Shift + 右键点击"
L["SHIFT_MIDDLE_CLICK"] = "Shift + 中键点击"
L["ACTION_ERASE"] = "删除"
L["ACTION_IGNORE"] = "保护"
L["ACTION_TOGGLE"] = "切换"
L["ACTION_CLEAR_IGNORE"] = "清空保护列表"
L["BAGS_CLEAN_CONGRATS"] = "恭喜，你的背包里都是好东西！"
L["BAGS_CLEAN_HINT"] = "如果想腾出更多空间，你需要手动删除一些物品。"
L["LOADING_ITEM"] = "加载中 ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser 选项"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "删除最低价值物品"
L["BINDING_ADD_TO_IGNORE_LIST"] = "将鼠标悬停的物品加入保护列表"
L["BINDING_ADD_TO_ERASE_LIST"] = "将鼠标悬停的物品加入删除列表"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "自动售卖"
L["AUTO_VEND_DESCRIPTION"] = "打开商人窗口时立即出售你的杂物，从最便宜的开始。"
L["TAB_YOUR_CURRENT_BAGS"] = "当前背包"
L["TAB_ERASING"] = "删除"
L["TAB_MERCHANT_BANK"] = "商人与银行"
L["TAB_ALERTS"] = "提醒与提示"
L["TAB_IGNORE_LIST"] = "保护列表"
L["TAB_ERASE_LIST"] = "删除列表"
L["ENABLED"] = "已启用"
L["DISABLED"] = "已禁用"

-- Example lines under chat-printing features. %s is the whole chat line.
L["OPTIONS_EXAMPLE"] = "示例：%s"
L["OPTIONS_EXAMPLE_ITEM"] = "示例物品"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"删除杂物，瞬间腾出背包空间。点击一下小地图按钮，即可清理已完成任务的物品、已经用不上的消耗品、可卖给商人的杂物和灰色物品。精心整理的杂物清单会保护你需要的物品，自动售卖则会在你下次遇到商人时卖掉其余物品。"
L["OPTIONS_ENABLE_WELCOME"] = "启用欢迎消息"
L["OPTIONS_ENABLE_WELCOME_DESC"] = "每次登录时在聊天框中显示一行包含版本号的欢迎消息。"
L["OPTIONS_ENABLE_MINIMAP"] = "启用小地图按钮"
L["OPTIONS_ENABLE_MINIMAP_DESC"] =
	"在小地图上显示 Magic Eraser 按钮。它的图标就是下一件要删除的物品，鼠标悬停时会显示杂物报告。"

-- Features
L["OPTIONS_FEATURES_HEADER"] = "功能"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/命令"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "打开本插件的选项界面。"

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "按键设置"
L["OPTIONS_KEY_NOT_BOUND"] = "未绑定"
L["OPTIONS_KEY_SET"] = "设置按键"
L["OPTIONS_KEY_SET_DESC"] = "打开游戏的按键设置列表，Magic Eraser 在其中有自己的分类。"
L["KEY_BINDINGS_LOCATION"] = "打开游戏菜单，依次进入 %s 和 %s，然后找到 Magic Eraser 分类。"
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"删除下一件物品，与左键点击小地图按钮相同。按键前没有预览，所以请把它绑定在不容易误按的位置。"
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"在此角色上保护鼠标指向的物品，无论它出现在哪里：背包、银行、商人或拾取窗口。如果它在此角色的删除列表中，会被移出。"
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"将鼠标指向的物品加入此角色的删除列表，无论它价值多少。你的保护列表仍然优先。"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "反馈与支持"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "版本 %s"

--------------------------------------------------------------------------------
-- Options: Your Current Bags Panel
--------------------------------------------------------------------------------

L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"] =
	"小地图按钮接下来要删除的物品及排在其后的杂物，然后是你携带的其他所有物品，随时可以删除或保护。"
L["OPTIONS_UP_NEXT"] = "下一件"
L["OPTIONS_CLUTTER_TOTAL"] = "总计"
L["OPTIONS_STACKS"] = "(%d 组)"
L["OPTIONS_ERASE_BUTTON"] = "删除"
L["OPTIONS_ERASE_BUTTON_DESC"] = "删除下一件物品，与左键点击小地图按钮完全相同。"
L["OPTIONS_PROTECT_BUTTON"] = "保护"
L["OPTIONS_PROTECT_BUTTON_DESC"] =
	"将此物品加入此角色的保护列表，使其永远不会被删除或出售。"

-- Everything in Your Bags
L["OPTIONS_EVERYTHING_HEADER"] = "背包中的所有物品"
L["OPTIONS_EVERYTHING_DESCRIPTION"] =
	"你携带的每一件物品，无论是不是杂物。勾选删除或保护，即可将其加入此角色的列表。"
L["OPTIONS_COLUMN_ITEM"] = "物品"
L["OPTIONS_COLUMN_TYPE"] = "类型"
L["OPTIONS_COLUMN_ERASE"] = "删除"
L["OPTIONS_COLUMN_PROTECT"] = "保护"
L["OPTIONS_CHECK_ERASE_DESC"] =
	"将此物品加入此角色的删除列表，使其无论价值多少都始终被视为杂物。同时会将它移出此角色的保护列表。"
L["OPTIONS_CHECK_ERASE_GLOBAL_DESC"] =
	"此物品在所有角色列表中。请在删除列表或保护列表页面修改它，因为该列表对每个角色都生效。"
L["OPTIONS_CHECK_PROTECT_DESC"] =
	"将此物品加入此角色的保护列表，使其永远不会被删除或出售。同时会将它移出此角色的删除列表。"
L["OPTIONS_CHECK_PROTECT_GLOBAL_DESC"] =
	"此物品在所有角色保护列表中。请在保护列表页面修改它，因为该列表对每个角色都生效。"

-- Why an item counts as junk, beside it in the queue.
L["REASON_QUEST"] = "任务已完成"
L["REASON_QUEST_INELIGIBLE"] = "无法接取"
L["REASON_OUTGROWN"] = "已用不上"
L["REASON_EQUIPMENT"] = "白色装备"
L["REASON_GRAY"] = "灰色"
L["REASON_MANUAL"] = "删除列表"
L["REASON_ASKS_FIRST"] = "先询问"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] = "每次点击都会删除背包中最便宜的杂物，一次一组。"
L["TAB_ERASING_RESTORE_NOTE"] =
	"提示：几乎所有误删的物品都仍然可以通过暴雪的物品恢复服务找回。"

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "哪些算杂物"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"选择要删除哪些种类的物品。如需微调，可以把任意物品加入保护列表以始终保留，或加入删除列表以始终删除。"
L["OPTIONS_KIND_QUEST"] = "已完成任务的物品"
L["OPTIONS_KIND_QUEST_DESC"] = "交付最后一个需要它们的任务后剩下的物品。"
L["OPTIONS_KIND_STARTER"] = "无法接取的任务起始物品"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESC"] =
	"会开启一个你的种族或职业永远无法接取的任务的物品。"
L["OPTIONS_KIND_FOOD"] = "已用不上的食物与饮料"
L["OPTIONS_KIND_FOOD_DESC"] =
	"超过最初可使用等级十级的食物和饮料。新手面包和水在 5 级时删除。"
L["OPTIONS_KIND_AMMO"] = "已用不上的箭与子弹"
L["OPTIONS_KIND_AMMO_DESC"] =
	"一旦你能使用商人出售的更好弹药，旧的箭和子弹就会被删除。适合你当前等级的最佳商人弹药永远不会被删除。"
L["OPTIONS_KIND_WHITE"] = "白色武器与护甲"
L["OPTIONS_KIND_WHITE_DESC"] =
	"商人会收购的白色武器和护甲。专业工具、衬衣、礼服以及任务仍需要的白色物品会被保留。"
L["OPTIONS_KIND_GRAY"] = "灰色垃圾"
L["OPTIONS_KIND_GRAY_DESC"] = "商人会收购的任何灰色物品。"
L["OPTIONS_KIND_ERASE"] = "删除"
L["OPTIONS_KIND_ASK"] = "删除，先询问"
L["OPTIONS_KIND_KEEP"] = "保留"
L["OPTIONS_KIND_ACTION_DESC"] =
	"删除：不询问直接删除。删除，先询问：删除前显示是或否确认。保留：表示它不是杂物，永远不会被删除、出售或从银行取出。删除列表中的物品无论价值多少，总是不经询问直接删除。"
L["OPTIONS_KINDS_ALL_KEPT"] =
	"所有种类都设为保留，因此只有删除列表中的物品会被删除或出售。"

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "删除的最高价值"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] = "永不删除价值超过你在下方所设上限的物品或整组物品。"
L["OPTIONS_ENABLE_VALUE_CAP"] = "启用删除的最高价值"
L["OPTIONS_ENABLE_VALUE_CAP_DESC"] =
	"开启或关闭价值上限。被它拦下的物品仍会由自动售卖出售，而你的删除列表不受此上限限制。"
L["OPTIONS_VALUE_CAP_LIMIT_DESC"] =
	"按整组物品的出售价值计算，价值超过此数额的物品组永远不会被删除。"
L["OPTIONS_VALUE_CAP_GOLD"] = "%d 金"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "手动删除辅助"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'默认情况下，游戏会要求你输入"%s"才能删除%s或更高品质的物品。此功能会把这个提示变成简单的是或否确认。'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "启用手动删除辅助"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESC"] =
	"开启或关闭手动删除辅助。游戏仍会询问是或否，只是不用再输入文字。"
L["OPTIONS_MANUAL_DELETE_SCOPE_DESC"] =
	"无出售价值的物品：只简化商人不收购的物品。所有物品：简化每一个需要输入文字的提示。"
L["OPTIONS_MANUAL_DELETE_ALL"] = "所有物品"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "无出售价值的物品"

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"打开商人窗口时立即出售你的杂物，并把银行里的杂物取回背包一起处理。保护列表中的物品不会被动。"

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "启用自动售卖"
L["OPTIONS_ENABLE_AUTO_VEND_DESC"] =
	"开启或关闭在商人处出售。保护列表中的物品永远不会被出售。"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "聊天框显示汇总"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "聊天框显示每笔出售"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "不在聊天框显示"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESC"] =
	"自动售卖在聊天框中显示的内容。聊天框显示汇总：每次光顾商人显示一条总计。聊天框显示每笔出售：逐条显示每笔出售，最后显示总计。不在聊天框显示：什么都不显示。"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "银行取回"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"打开银行时取出其中的杂物，以便和其他杂物一起出售或删除。它只会从你自己的银行取出物品，绝不会动公会银行或账号共享银行。"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "启用银行取回"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESC"] =
	"开启或关闭银行取回。取出的物品永远不会超过你的空余背包格子所能容纳的数量。"
L["OPTIONS_BANK_CUSHION_NOTE"] = "由于背包空间警告已开启，会保留 %d 个空余背包格子。"
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] = "由于背包空间警告已开启，会保留 1 个空余背包格子。"

--------------------------------------------------------------------------------
-- Options: Alerts & Tooltips Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "Magic Eraser 会主动在聊天框和物品提示中告诉你的信息。"

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "物品提示警告"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"为背包中 Magic Eraser 可能删除的物品，或受你的保护列表保护的物品，在其提示中添加一行说明。"
L["OPTIONS_ENABLE_TOOLTIPS"] = "启用物品提示警告"
L["OPTIONS_ENABLE_TOOLTIPS_DESC"] = "开启或关闭背包物品提示中的 Magic Eraser 说明行。"

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "任务物品提醒"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"当背包中的已完成任务的物品或无法接取的任务起始物品可以安全删除时，立即通知你。"
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "启用任务物品提醒"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESC"] =
	"开启或关闭这些消息。无论如何，已完成任务的物品和无法接取的任务起始物品仍会被删除。"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "背包空间警告"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"在最后几个空余背包格子被填满时提醒你。打开商人、邮箱或银行窗口时不会提醒。"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "启用背包空间警告"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESC"] = "开启或关闭聊天框中的倒数提醒。"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "空余格子阈值"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESC"] =
	"剩余多少个空余格子时开始倒数提醒。警告开启时，银行取回也会保留这么多空余格子。"

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "所有角色"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "从背包添加"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESC"] =
	"从你携带的物品中任选一件。打开选项界面时背包会关闭，所以这里代替了把物品拖到此处的操作。"
L["OPTIONS_LIST_ADD_ID"] = "按物品 ID 添加"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"输入物品 ID 后按回车。你也可以在聊天框中 Shift+点击物品链接，将其填入此处。"
L["OPTIONS_LIST_ADD_ID_INVALID"] = "请输入物品 ID，或在聊天框中 Shift+点击物品链接。"
L["OPTIONS_LIST_REMOVE"] = "移除"
L["OPTIONS_LIST_EMPTY"] = "此列表为空。"
L["OPTIONS_LIST_PROTECTED_TAG"] = "受保护"

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"保护列表中的物品永远不会被删除或出售。所有角色列表会在每个角色上保护该物品，而角色自己的列表只在该角色上保护它。"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"将此物品移到所有角色列表，使其在每个角色上都受保护。"

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"删除列表中的物品无论价值多少都始终被视为杂物：由小地图按钮删除，并在商人处出售。你的保护列表仍然优先，被它否决的条目会显示受保护。"
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"将此物品移到所有角色列表，使其在每个角色上都被删除，包括从未添加过它的角色。"
L["OPTIONS_ERASE_RESTORE"] = "恢复默认"
L["OPTIONS_ERASE_RESTORE_DESC"] = "将此角色的删除列表恢复为 Magic Eraser 预设的物品。"
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"清空此角色的删除列表，只恢复 Magic Eraser 预设的物品？你自己添加的内容会被移除。"
