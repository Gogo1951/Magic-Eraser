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

-- Eraser
L["COMBAT_LOCKOUT"] = "战斗中无法删除物品。"
L["CONFIRM_ERASE"] = "删除 %s%s？"
L["BAGS_FULL"] = "你的背包已满！"
L["BAGS_FULL_NUDGE"] = "你的背包快满了。还剩 %d 个空格。"
L["BAGS_FULL_NUDGE_ONE"] = "你的背包快满了。还剩 1 个空格。"
L["CURSOR_TOO_FAST"] = "慢一点！你的点击速度超过了游戏删除物品的速度。"
L["ERASED_ITEM"] = "已删除 %s%s。"
L["ERASED_ITEM_WITH_VALUE"] = "已删除 %s%s，价值 %s。"
L["ERASED_ITEM_FROM_QUEST"] = "已删除 %s%s，来自你已完成的任务。"
L["QUEST_ITEM_READY"] = "%s 现在可以安全删除了！"

-- Auto-Vend
L["SOLD_ITEM"] = "已出售 %s%s，价值 %s。"
L["SOLD_SUMMARY"] = "已出售 %s 件物品（%s 个格子），价值 %s。"
L["AUTO_VEND_COMBAT_DEFERRED"] = "战斗结束后将执行自动售卖。"

-- Bank Retrieval
L["BANK_RETRIEVED"] = "已从银行取出 %s 件物品（%s 个格子），价值 %s。"

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Magic Eraser 将删除此物品。"
L["TOOLTIP_IGNORED"] = "受你的忽略列表保护。"

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "最低价值物品"
L["CLUTTER_REPORT"] = "杂物报告"
L["CLUTTER_ITEMS"] = "(%s 件物品)"
L["CLUTTER_SLOTS"] = "%s 个格子"
L["NO_VALUE"] = "无价值"
L["LEFT_CLICK"] = "左键点击"
L["RIGHT_CLICK"] = "右键点击"
L["MIDDLE_CLICK"] = "中键点击"
L["SHIFT_RIGHT_CLICK"] = "Shift + 右键点击"
L["SHIFT_MIDDLE_CLICK"] = "Shift + 中键点击"
L["ACTION_ERASE"] = "删除"
L["ACTION_IGNORE"] = "忽略"
L["ACTION_TOGGLE"] = "切换"
L["ACTION_CLEAR_IGNORE"] = "清空忽略列表"
L["BAGS_CLEAN_SHORT"] = "恭喜，你的背包里都是好东西！"
L["BAGS_CLEAN_HINT"] = "如果需要更多空间，你需要手动删除一些物品。"
L["LOADING_ITEM"] = "加载中 ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser 选项"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "自动售卖"
L["AUTO_VEND_DESCRIPTION"] = "打开商人窗口时自动出售被 Magic Eraser 标记为杂物的物品。"
L["IGNORE_LIST"] = "忽略列表"
L["ENABLED"] = "已启用"
L["DISABLED"] = "已禁用"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"瞬间清理你的背包。每次点击小地图按钮，都会删除已完成的任务物品、低级消耗品、可售卖给商人的白色物品以及灰色垃圾。当你拜访商人时，所有可出售的物品都会自动售出。"
L["OPTIONS_ENABLE_WELCOME"] = "启用欢迎消息"
L["OPTIONS_ENABLE_MINIMAP"] = "启用小地图按钮"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/命令"
L["OPTIONS_COMMAND_ERASER"] = "/eraser"
L["OPTIONS_COMMAND_ERASER_DESCRIPTION"] = "打开 Magic Eraser 选项面板。"

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "启用自动售卖"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "启用自动售卖消息"
L["OPTIONS_AUTO_VEND_VERBOSE"] = "逐项"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "仅汇总"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "银行取回"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "启用银行取回"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"打开银行时自动取出被 Magic Eraser 标记为杂物的物品，方便你删除它们。"

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "物品提示"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"当 Magic Eraser 会删除某件背包物品，或忽略列表正在保护它时，为该物品的提示添加一行说明。"
L["OPTIONS_ENABLE_TOOLTIPS"] = "为背包内物品启用提示"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "背包空间警告"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"当背包空格减少到你在下方设置的阈值时，在聊天框中倒数提醒。"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "启用背包空间警告"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "空格阈值"

-- Eraser Confirmations
L["OPTIONS_SAFETY_HEADER"] = "删除确认"
L["OPTIONS_SAFETY_DESCRIPTION"] = "在删除下方勾选的物品类型前先询问。"
L["OPTIONS_ENABLE_SAFETY"] = "启用删除确认"
L["OPTIONS_SAFETY_QUEST"] = "对已完成任务的物品"
L["OPTIONS_SAFETY_CONSUMABLE"] = "对低级消耗品"
L["OPTIONS_SAFETY_WHITE"] = "对可售卖的白色物品"
L["OPTIONS_SAFETY_GRAY"] = "对可售卖的灰色物品"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "反馈与支持"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Ignore List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"忽略列表中的物品永远不会被删除或出售。全局列表会在所有角色上保护该物品，而角色自己的列表只在该角色上保护它。"
L["OPTIONS_IGNORE_GLOBAL"] = "全局"
L["OPTIONS_IGNORE_ADD_ID"] = "按物品 ID 添加"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"输入物品 ID 后按回车。你也可以在聊天框中 Shift+点击物品链接，将其填入此处。"
L["OPTIONS_IGNORE_ADD_ID_INVALID"] = "请输入物品 ID，或在聊天框中 Shift+点击物品链接。"
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] = "将此物品移到全局列表，使其在所有角色上都受保护。"
L["OPTIONS_IGNORE_REMOVE"] = "移除"
L["OPTIONS_IGNORE_EMPTY"] = "此列表为空。"
