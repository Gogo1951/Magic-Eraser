local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "zhCN")
if not L then return end

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["COMBAT_LOCKOUT"] = "战斗中无法删除物品。"
L["ERASED_ITEM"] = "已删除 %s%s%s。"
L["ERASED_QUEST_SUFFIX"] = "，该物品关联的任务已完成"
L["ERASED_VALUE_SUFFIX"] = "，价值 %s"
L["SOLD_ITEM"] = "已出售 %s%s，价值 %s。"
L["CURSOR_TOO_FAST"] = "慢一点！你的点击速度超过了游戏删除物品的速度。"
L["BAGS_CLEAN"] = "恭喜，你的背包里都是好东西！如果需要更多空间，你需要手动删除一些物品。"
L["QUEST_ITEM_READY"] = "%s 现在可以安全删除了！"

--------------------------------------------------------------------------------
-- Tooltip
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
L["TOOLTIP_HINT"] = "更多设置请前往 选项 > 插件 > Magic Eraser"

--------------------------------------------------------------------------------
-- Auto-Vend
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "自动售卖"
L["AUTO_VEND_DESC"] = "自动出售被 Magic Eraser 标记为垃圾的物品。"
L["ENABLED"] = "已启用"
L["DISABLED"] = "已禁用"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

L["IGNORE_LIST"] = "忽略列表"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "点击小地图按钮时删除背包中价值最低的物品。"
L["OPTIONS_AUTO_VEND_DESC"] = "打开商人窗口时自动出售被 Magic Eraser 标记为垃圾的物品。"
L["OPTIONS_RESET"] = "重置"
L["OPTIONS_RESET_IGNORE"] = "重置忽略列表"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "移除该角色忽略列表中的所有物品？"
L["OPTIONS_RESET_ALL"] = "重置所有 Magic Eraser 设置"
L["OPTIONS_RESET_ALL_CONFIRM"] = "将所有 Magic Eraser 设置恢复为默认值？忽略列表将被清空，自动售卖将被禁用。"
L["OPTIONS_FEEDBACK"] = "反馈与支持"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
