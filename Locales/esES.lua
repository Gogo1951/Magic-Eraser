local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "esES")
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
	"Versión %s. Los ajustes (incluyendo la opción para desactivar este mensaje) se pueden encontrar en Opciones > AddOns > Magic Eraser. ¿Disfrutando del add-on? ¡Díselo a un amigo! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Por seguridad, el panel de opciones no se puede abrir durante el combate."

-- Eraser
L["COMBAT_LOCKOUT"] = "No se pueden eliminar objetos durante el combate."
L["CONFIRM_ERASE"] = "¿Eliminar %s%s?"
L["BAGS_FULL"] = "¡Tus bolsas están llenas!"
L["BAGS_FULL_NUDGE"] = "Tus bolsas están casi llenas. Te quedan %d espacios."
L["BAGS_FULL_NUDGE_ONE"] = "Tus bolsas están casi llenas. Te queda 1 espacio."
L["CURSOR_TOO_FAST"] = "¡Más despacio! Estás haciendo clic más rápido de lo que el juego puede eliminar objetos."
L["ERASED_ITEM"] = "%s%s eliminado."
L["ERASED_ITEM_WITH_VALUE"] = "%s%s eliminado, valor %s."
L["ERASED_ITEM_FROM_QUEST"] = "%s%s eliminado, de una misión que has completado."
L["ERASED_ITEM_QUEST_UNAVAILABLE"] = "%s%s eliminado, de una misión que tu personaje no puede aceptar."
L["QUEST_ITEM_READY"] = "¡%s ahora se puede eliminar de forma segura!"
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s se puede eliminar de forma segura, de una misión que tu personaje no puede aceptar."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["SOLD_SUMMARY"] = "%s objetos (%s espacios) vendidos, valor %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-venta venderá los objetos al terminar el combate."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s objetos (%s espacios) sacados de tu banco, valor %s."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Magic Eraser eliminará esto."
L["TOOLTIP_IGNORED"] = "Protegido por tu lista de ignorados."
L["TOOLTIP_ON_ERASE_LIST"] = "Marcado por tu lista de eliminación."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Objeto de menor valor"
L["CLUTTER_REPORT"] = "Informe de basura"
L["CLUTTER_ITEMS"] = "(%s objetos)"
L["CLUTTER_SLOTS"] = "%s espacios"
L["NO_VALUE"] = "Sin valor"
L["LEFT_CLICK"] = "Clic izquierdo"
L["RIGHT_CLICK"] = "Clic derecho"
L["MIDDLE_CLICK"] = "Clic central"
L["SHIFT_RIGHT_CLICK"] = "Mayús + Clic derecho"
L["SHIFT_MIDDLE_CLICK"] = "Mayús + Clic central"
L["ACTION_ERASE"] = "Eliminar"
L["ACTION_IGNORE"] = "Ignorar"
L["ACTION_TOGGLE"] = "Alternar"
L["ACTION_CLEAR_IGNORE"] = "Vaciar lista de ignorados"
L["BAGS_CLEAN_CONGRATS"] = "¡Felicidades, tus bolsas están llenas de cosas buenas!"
L["BAGS_CLEAN_HINT"] = "Tendrás que eliminar algo manualmente si quieres liberar más espacio."
L["LOADING_ITEM"] = "Cargando ID: %d"
L["MINIMAP_OPTIONS"] = "Opciones de Magic Eraser"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-venta"
L["AUTO_VEND_DESCRIPTION"] =
	"Vende automáticamente los objetos marcados como basura por Magic Eraser al abrir una ventana de comerciante."
L["IGNORE_LIST"] = "Lista de ignorados"
L["TAB_IGNORE_LIST"] = "Lista de ignorados"
L["TAB_ERASE_LIST"] = "Lista de eliminación"
L["ENABLED"] = "Activado"
L["DISABLED"] = "Desactivado"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Elimina la basura y libera espacio en las bolsas al instante. Los objetos de misiones completadas, consumibles de bajo nivel, objetos blancos de calidad de vendedor y basura gris se van con un solo clic en el botón del minimapa, y todo lo vendible se vende solo en el comerciante. No vuelvas a cargar con basura de vendedor."
L["OPTIONS_ENABLE_WELCOME"] = "Habilitar mensaje de bienvenida"
L["OPTIONS_ENABLE_MINIMAP"] = "Habilitar botón del minimapa"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre el panel de opciones de este complemento."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Habilitar Auto-venta"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "Habilitar mensajes de Auto-venta"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Por objeto"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Solo resumen"

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Valor máximo a eliminar"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] =
	"Nunca elimina un objeto o montón que valga más que el límite que definas abajo."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Habilitar valor máximo a eliminar"
L["OPTIONS_VALUE_CAP_LIMIT"] = "Nunca eliminar nada que valga más de"
L["OPTIONS_VALUE_CAP_GOLD"] = "%d de oro"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Recuperación del banco"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Habilitar recuperación del banco"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Saca automáticamente de tu banco los objetos marcados como basura por Magic Eraser al abrirlo, para que puedas eliminarlos."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Descripciones de objetos"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Añade una línea a la descripción de un objeto en tus bolsas cuando Magic Eraser vaya a eliminarlo, o cuando tu lista de ignorados lo esté protegiendo."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Habilitar descripciones para objetos en las bolsas"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Avisos de espacio en bolsas"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Cuenta atrás en el chat a medida que tus espacios libres bajan hasta el umbral que definas abajo."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Habilitar avisos de espacio en bolsas"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Umbral de espacios libres"

-- Eraser Confirmations
L["OPTIONS_SAFETY_HEADER"] = "Confirmaciones de eliminación"
L["OPTIONS_SAFETY_DESCRIPTION"] = "Preguntar antes de eliminar los tipos de objeto que marques abajo."
L["OPTIONS_ENABLE_SAFETY"] = "Habilitar confirmaciones de eliminación"
L["OPTIONS_SAFETY_QUEST"] = "Para objetos de misiones completadas"
L["OPTIONS_SAFETY_CONSUMABLE"] = "Para consumibles de bajo nivel"
L["OPTIONS_SAFETY_WHITE"] = "Para objetos blancos de calidad de vendedor"
L["OPTIONS_SAFETY_GRAY"] = "Para objetos grises de calidad de vendedor"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Global"
L["OPTIONS_LIST_ADD_ID"] = "Añadir por ID de objeto"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Escribe un ID de objeto y pulsa Intro. También puedes hacer Mayús+clic en un enlace de objeto del chat para insertarlo aquí."
L["OPTIONS_LIST_ADD_ID_INVALID"] = "Escribe un ID de objeto, o haz Mayús+clic en un enlace de objeto del chat."
L["OPTIONS_LIST_REMOVE"] = "Quitar"
L["OPTIONS_LIST_EMPTY"] = "Esta lista está vacía."

--------------------------------------------------------------------------------
-- Options: Ignore List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Los objetos de una Lista de ignorados nunca se eliminan ni se venden. La lista Global protege un objeto en todos los personajes, y la lista propia de un personaje lo protege solo en ese personaje."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Mueve este objeto a la lista Global, para que esté protegido en todos los personajes."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Los objetos de una Lista de eliminación siempre se tratan como basura, sea cual sea su valor: se eliminan con el botón del minimapa, o se venden al visitar a un comerciante. La lista Global se aplica en todos los personajes, y la lista propia de un personaje solo en ese personaje. Una Lista de ignorados siempre tiene prioridad, así que un objeto que esté en ambas se deja intacto."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"Mueve este objeto a la lista Global, para que se elimine en todos los personajes."
L["OPTIONS_ERASE_RESTORE"] = "Restaurar valores predeterminados"
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"¿Vaciar la Lista de eliminación de este personaje y dejar solo los objetos con los que Magic Eraser empieza? Se quita todo lo que hayas añadido tú."
