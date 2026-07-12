local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "ruRU")
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
	"Версия %s. Настройки (включая опцию отключения этого сообщения) можно найти в Настройки > Аддоны > Magic Eraser. Нравится аддон? Расскажите другу! (="

-- Eraser
L["COMBAT_LOCKOUT"] = "Нельзя удалять предметы во время боя."
L["CONFIRM_ERASE"] = "Удалить %s%s?"
L["BAGS_FULL"] = "Ваши сумки полны!"
L["BAGS_FULL_NUDGE"] = "Ваши сумки почти полны. Свободных ячеек: %d."
L["BAGS_FULL_NUDGE_ONE"] = "Ваши сумки почти полны. Свободна 1 ячейка."
L["CURSOR_TOO_FAST"] =
	"Помедленнее! Вы кликаете быстрее, чем игра успевает удалять предметы."
L["ERASED_ITEM"] = "%s%s%s удалён."
L["ERASED_VALUE_SUFFIX"] = ", стоимость %s"
L["ERASED_QUEST_SUFFIX"] = ", этот предмет был связан с выполненным заданием"
L["QUEST_ITEM_READY"] = "%s теперь можно безопасно удалить!"

-- Item Tooltip
L["TOOLTIP_WILL_ERASE"] = "Magic Eraser удалит этот предмет."
L["TOOLTIP_IGNORED"] = "Защищён вашим списком игнорируемых."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s продан, стоимость %s."
L["SOLD_SUMMARY"] = "Продано предметов: %s, стоимость %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Автопродажа сработает после окончания боя."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Предмет наименьшей ценности"
L["CLUTTER_REPORT"] = "Отчёт о хламе"
L["CLUTTER_SLOTS"] = "%s ячеек"
L["CLUTTER_ITEMS"] = "(%s предметов)"
L["CLUTTER_VALUE"] = "Стоимость %s"
L["NO_VALUE"] = "Без ценности"
L["LEFT_CLICK"] = "Левый клик"
L["RIGHT_CLICK"] = "Правый клик"
L["MIDDLE_CLICK"] = "Средний клик"
L["SHIFT_RIGHT_CLICK"] = "Shift + Правый клик"
L["ACTION_ERASE"] = "Удалить"
L["ACTION_IGNORE"] = "Игнорировать"
L["ACTION_TOGGLE"] = "Переключить"
L["ACTION_CLEAR_IGNORE"] = "Очистить список игнорируемых"
L["BAGS_CLEAN_SHORT"] = "Поздравляем, ваши сумки полны полезных вещей!"
L["BAGS_CLEAN_HINT"] =
	"Чтобы освободить место, придётся удалить что-нибудь вручную."
L["LOADING_ITEM"] = "Загрузка ID: %d"
L["MINIMAP_OPTIONS"] = "Настройки Magic Eraser"
L["MINIMAP_OPTIONS_KEYBIND"] = "Shift + Средний клик"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Автопродажа"
L["AUTO_VEND_DESCRIPTION"] =
	"Автоматически продаёт предметы, отмеченные Magic Eraser как мусор."
L["IGNORE_LIST"] = "Список игнорируемых"
L["ON"] = "Включено"
L["OFF"] = "Выключено"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Мгновенно наведите порядок в сумках. Завершённые квестовые предметы, низкоуровневые расходники, белые предметы для продажи и серый мусор удаляются с каждым кликом по кнопке у миникарты. Когда вы посещаете торговца, всё, что можно продать, продаётся автоматически."
L["OPTIONS_WELCOME"] = "Включить приветственное сообщение"
L["OPTIONS_MINIMAP"] = "Включить кнопку у миникарты"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Команды"
L["OPTIONS_COMMAND_ERASER"] = "/eraser"
L["OPTIONS_COMMAND_ERASER_DESCRIPTION"] = "Открывает интерфейс настроек Magic Eraser."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Подсказки предметов"
L["OPTIONS_TOOLTIP_WARNING"] = "Включить подсказки для предметов в сумках"

-- Auto-Vend
L["OPTIONS_AUTO_VEND_DESCRIPTION"] =
	"Автоматически продаёт предметы, отмеченные Magic Eraser как мусор, при открытии окна торговца."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Включить автопродажу"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Включить сообщения автопродажи"
L["OPTIONS_AUTO_VEND_VERBOSE"] = "По предметам"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Сводка"
L["OPTIONS_BAGS_FULL_HEADER"] = "Предупреждения о месте в сумках"
L["OPTIONS_BAGS_FULL_NUDGE"] = "Включить предупреждения о месте в сумках"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Порог свободных ячеек"

-- Eraser Confirmation
L["OPTIONS_SAFETY_HEADER"] = "Подтверждения удаления"
L["OPTIONS_SAFETY_DESCRIPTION"] =
	"Спрашивать перед удалением отмеченных ниже типов предметов."
L["OPTIONS_ENABLE_SAFETY"] = "Включить подтверждения удаления"
L["OPTIONS_SAFETY_QUEST"] = "Для предметов выполненных заданий"
L["OPTIONS_SAFETY_CONSUMABLE"] = "Для низкоуровневых расходников"
L["OPTIONS_SAFETY_WHITE"] = "Для белых предметов для продажи"
L["OPTIONS_SAFETY_GRAY"] = "Для серых предметов для продажи"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Обратная связь и поддержка"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
