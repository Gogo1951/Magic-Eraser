local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "zhCN")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] = "版本 %s。设置（包括关闭此消息的选项）可以在 选项 > 插件 > Magic Eraser 中找到。喜欢这个插件吗？告诉朋友吧！(="
L["MESSAGE_RESET"] = "所有设置已恢复为默认值。"

-- Eraser
L["COMBAT_LOCKOUT"] = "战斗中无法删除物品。"
L["CURSOR_TOO_FAST"] = "慢一点！你的点击速度超过了游戏删除物品的速度。"
L["ERASED_ITEM"] = "已删除 %s%s%s。"
L["ERASED_VALUE_SUFFIX"] = "，价值 %s"
L["ERASED_QUEST_SUFFIX"] = "，该物品关联的任务已完成"
L["BAGS_CLEAN"] = "恭喜，你的背包里都是好东西！如果需要更多空间，你需要手动删除一些物品。"
L["QUEST_ITEM_READY"] = "%s 现在可以安全删除了！"

-- Auto-Vend
L["SOLD_ITEM"] = "已出售 %s%s，价值 %s。"
L["AUTO_VEND_COMBAT_DEFERRED"] = "战斗结束后将执行自动售卖。"

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "最低价值物品"
L["NO_VALUE"] = "无价值"
L["LEFT_CLICK"] = "左键点击"
L["RIGHT_CLICK"] = "右键点击"
L["MIDDLE_CLICK"] = "中键点击"
L["SHIFT_RIGHT_CLICK"] = "Shift + 右键点击"
L["ACTION_ERASE"] = "删除"
L["ACTION_IGNORE"] = "忽略"
L["ACTION_TOGGLE"] = "切换"
L["ACTION_CLEAR_IGNORE"] = "清空忽略列表"
L["BAGS_CLEAN_SHORT"] = "恭喜，你的背包里都是好东西！"
L["BAGS_CLEAN_HINT"] = "如果需要更多空间，你需要手动删除一些物品。"
L["LOADING_ITEM"] = "加载中 ID: %d"
L["TOOLTIP_HINT"] = "更多设置请前往 选项 > 插件 > Magic Eraser."

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "自动售卖"
L["AUTO_VEND_DESCRIPTION"] = "自动出售被 Magic Eraser 标记为垃圾的物品。"
L["IGNORE_LIST"] = "忽略列表"
L["ON"] = "已启用"
L["OFF"] = "已禁用"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Magic Eraser 可以识别你背包中价值最低的垃圾，只需点击小地图按钮即可将其删除。已完成的任务物品、低级消耗品、可售卖给商人的白色物品以及灰色垃圾——通通清理掉。当你拜访商人时，自动售卖会自动为你出售剩下的物品。"
L["OPTIONS_WELCOME"] = "启用欢迎消息"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "打开商人窗口时自动出售被 Magic Eraser 标记为垃圾的物品。"
L["OPTIONS_ENABLE_AUTO_VEND"] = "启用自动售卖"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "启用自动售卖消息"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "打开 Magic Eraser 选项界面。"
L["OPTIONS_RESET"] = "重置"
L["OPTIONS_RESET_DESCRIPTION"] = "将所有选项恢复为默认值。"
L["OPTIONS_RESET_IGNORE"] = "重置忽略列表"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "移除该角色忽略列表中的所有物品？"
L["OPTIONS_RESET_ALL"] = "重置所有 Magic Eraser 设置"
L["OPTIONS_RESET_ALL_CONFIRM"] = "将所有 Magic Eraser 设置恢复为默认值？忽略列表将被清空，自动售卖将被禁用。"
L["OPTIONS_FEEDBACK"] = "反馈与支持"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
