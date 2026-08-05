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
L["CHAT_OPTIONS_IN_COMBAT"] =
	"В целях безопасности панель настроек нельзя открыть во время боя."

-- Eraser
L["COMBAT_LOCKOUT"] = "Нельзя удалять предметы во время боя."
L["CONFIRM_ERASE"] = "Удалить %s%s?"
L["BAGS_FULL"] = "Ваши сумки полны!"
L["BAGS_FULL_NUDGE"] = "Ваши сумки почти полны. Свободных ячеек: %d."
L["BAGS_FULL_NUDGE_ONE"] = "Ваши сумки почти полны. Свободна 1 ячейка."
L["CURSOR_TOO_FAST"] =
	"Помедленнее! Вы кликаете быстрее, чем игра успевает удалять предметы."
L["ERASED_ITEM"] = "%s%s удалён."
L["ERASED_ITEM_WITH_VALUE"] = "%s%s удалён, стоимость %s."
L["ERASED_ITEM_FROM_QUEST"] = "%s%s удалён, из выполненного вами задания."
L["QUEST_ITEM_READY"] = "%s теперь можно безопасно удалить!"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s продан, стоимость %s."
L["SOLD_SUMMARY"] = "Продано предметов: %s (%s ячеек), стоимость %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Автопродажа сработает после окончания боя."

-- Bank Retrieval
L["BANK_RETRIEVED"] =
	"Из банка извлечено предметов: %s (%s ячеек), стоимость %s."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Magic Eraser удалит этот предмет."
L["TOOLTIP_IGNORED"] = "Защищён вашим списком игнорируемых."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Предмет наименьшей ценности"
L["CLUTTER_REPORT"] = "Отчёт о хламе"
L["CLUTTER_ITEMS"] = "(%s предметов)"
L["CLUTTER_SLOTS"] = "%s ячеек"
L["NO_VALUE"] = "Без ценности"
L["LEFT_CLICK"] = "Левый клик"
L["RIGHT_CLICK"] = "Правый клик"
L["MIDDLE_CLICK"] = "Средний клик"
L["SHIFT_RIGHT_CLICK"] = "Shift + Правый клик"
L["SHIFT_MIDDLE_CLICK"] = "Shift + Средний клик"
L["ACTION_ERASE"] = "Удалить"
L["ACTION_IGNORE"] = "Игнорировать"
L["ACTION_TOGGLE"] = "Переключить"
L["ACTION_CLEAR_IGNORE"] = "Очистить список игнорируемых"
L["BAGS_CLEAN_CONGRATS"] = "Поздравляем, ваши сумки полны полезных вещей!"
L["BAGS_CLEAN_HINT"] =
	"Чтобы освободить больше места, придётся удалить что-нибудь вручную."
L["LOADING_ITEM"] = "Загрузка ID: %d"
L["MINIMAP_OPTIONS"] = "Настройки Magic Eraser"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Автопродажа"
L["AUTO_VEND_DESCRIPTION"] =
	"Автоматически продаёт предметы, отмеченные Magic Eraser как хлам, при открытии окна торговца."
L["IGNORE_LIST"] = "Список игнорируемых"
L["TAB_IGNORE_LIST"] = "Список игнорируемых"
L["ENABLED"] = "Включено"
L["DISABLED"] = "Выключено"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Мгновенно наведите порядок в сумках. Завершённые квестовые предметы, низкоуровневые расходники, белые предметы для продажи и серый мусор удаляются с каждым кликом по кнопке у миникарты. Когда вы посещаете торговца, всё, что можно продать, продаётся автоматически."
L["OPTIONS_ENABLE_WELCOME"] = "Включить приветственное сообщение"
L["OPTIONS_ENABLE_MINIMAP"] = "Включить кнопку у миникарты"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Команды"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Открывает панель настроек этого аддона."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Включить автопродажу"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "Включить сообщения автопродажи"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "По предметам"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Только сводка"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Извлечение из банка"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Включить извлечение из банка"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Автоматически извлекает из банка предметы, отмеченные Magic Eraser как хлам, когда вы его открываете, чтобы вы могли их удалить."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Подсказки предметов"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Добавляет строку в подсказку предмета в сумках, когда Magic Eraser собирается его удалить или когда его защищает список игнорируемых."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Включить подсказки для предметов в сумках"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Предупреждения о месте в сумках"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Ведёт обратный отсчёт в чате, пока свободные ячейки сумок снижаются до заданного ниже порога."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Включить предупреждения о месте в сумках"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Порог свободных ячеек"

-- Eraser Confirmations
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

--------------------------------------------------------------------------------
-- Options: Ignore List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Предметы из списка игнорируемых никогда не удаляются и не продаются. Общий список защищает предмет на всех персонажах, а собственный список персонажа защищает его только на нём."
L["OPTIONS_IGNORE_GLOBAL"] = "Общий"
L["OPTIONS_IGNORE_ADD_ID"] = "Добавить по ID предмета"
L["OPTIONS_IGNORE_ADD_ID_DESCRIPTION"] =
	"Введите ID предмета и нажмите Enter. Также можно нажать Shift+клик по ссылке на предмет в чате, чтобы вставить её сюда."
L["OPTIONS_IGNORE_ADD_ID_INVALID"] =
	"Введите ID предмета или нажмите Shift+клик по ссылке на предмет в чате."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Переместить этот предмет в общий список, чтобы он был защищён на всех персонажах."
L["OPTIONS_IGNORE_REMOVE"] = "Убрать"
L["OPTIONS_IGNORE_EMPTY"] = "Этот список пуст."
