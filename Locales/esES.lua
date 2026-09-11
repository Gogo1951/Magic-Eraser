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
L["ERASED_ITEM_FROM_QUEST"] = "%s%s eliminado, sobrante de una misión que has completado."
L["ERASED_ITEM_QUEST_UNAVAILABLE"] = "%s%s eliminado, que inicia una misión que tu personaje no puede aceptar."
L["QUEST_ITEM_READY"] = "¡%s ahora se puede eliminar de forma segura!"
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s se puede eliminar de forma segura. Inicia una misión que tu personaje no puede aceptar."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["SOLD_SUMMARY"] = "%s objetos (%s espacios de bolsa) vendidos, valor %s."
L["SOLD_SUMMARY_ONE_SLOT"] = "%s objetos (1 espacio de bolsa) vendidos, valor %s."
L["SOLD_SUMMARY_ONE_ITEM"] = "1 objeto (1 espacio de bolsa) vendido, valor %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-venta venderá los objetos al terminar el combate."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s objetos (%s espacios de bolsa) sacados de tu banco, valor %s."
L["BANK_RETRIEVED_ONE_SLOT"] = "%s objetos (1 espacio de bolsa) sacados de tu banco, valor %s."
L["BANK_RETRIEVED_ONE_ITEM"] = "1 objeto (1 espacio de bolsa) sacado de tu banco, valor %s."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Se eliminará."
L["TOOLTIP_IGNORED"] = "Protegido por tu lista de ignorados."
L["TOOLTIP_ON_ERASE_LIST"] = "Marcado por tu lista de eliminación."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Objeto de menor valor"
L["CLUTTER_REPORT"] = "Informe de basura"
L["CLUTTER_ITEMS"] = "(%s objetos)"
L["CLUTTER_ITEMS_ONE"] = "(1 objeto)"
L["CLUTTER_SLOTS"] = "%s espacios de bolsa"
L["CLUTTER_SLOTS_ONE"] = "1 espacio de bolsa"
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
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "Eliminar objeto de menor valor"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-venta"
L["AUTO_VEND_DESCRIPTION"] =
	"Vende automáticamente los objetos marcados como basura por Magic Eraser al abrir una ventana de comerciante."
L["TAB_SAFETY"] = "Funciones de seguridad"
L["TAB_IGNORE_LIST"] = "Lista de ignorados"
L["TAB_ERASE_LIST"] = "Lista de eliminación"
L["ENABLED"] = "Activado"
L["DISABLED"] = "Desactivado"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Elimina la basura y libera espacio en las bolsas al instante. Quita objetos de misiones completadas, consumibles que ya has superado, basura de vendedor y objetos grises con un solo clic. Una lista de basura revisada a mano lo mantiene todo seguro, mientras que la Auto-venta vende el resto en tu próximo comerciante."
L["OPTIONS_ENABLE_WELCOME"] = "Habilitar mensaje de bienvenida"
L["OPTIONS_ENABLE_MINIMAP"] = "Habilitar botón del minimapa"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre el panel de opciones de este add-on."

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Asignación de teclas"
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Hace exactamente lo mismo que hacer clic izquierdo en el botón del minimapa. Úsalo bajo tu propia responsabilidad: una pulsación accidental elimina igual que una intencionada. Asígnale una tecla en el menú del juego, en Asignación de teclas, dentro de la sección Magic Eraser."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Habilitar Auto-venta"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "Habilitar mensajes de Auto-venta"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Por objeto"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Solo resumen"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Safety Panel
--------------------------------------------------------------------------------

L["TAB_SAFETY_DESCRIPTION"] =
	"Casi cualquier objeto que elimines se puede recuperar mediante el servicio de restauración de objetos de Blizzard, así que un error aquí rara vez es permanente. Aun así, merece la pena revisar estos ajustes: aquí decides lo cauteloso que es Magic Eraser y cuánto te cuenta por el camino."

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "Avisos en las descripciones"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Añade una línea a la descripción de un objeto en tus bolsas cuando Magic Eraser vaya a eliminarlo, o cuando tu lista de ignorados lo esté protegiendo."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Habilitar avisos en las descripciones"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Recuperación del banco"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Habilitar recuperación del banco"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Saca automáticamente de tu banco los objetos marcados como basura por Magic Eraser al abrirlo, para que puedas eliminarlos."

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Ayuda al eliminar a mano"
L["OPTIONS_MANUAL_DELETE_DESCRIPTION"] =
	'Por defecto, los objetos de calidad Rara o superior te obligan a escribir "Borrar" antes de poder deshacerte de ellos. Esto lo convierte en un simple Sí o No, para los objetos que elijas abajo.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Habilitar ayuda al eliminar a mano"
L["OPTIONS_MANUAL_DELETE_SCOPE"] = "Se aplica a"
L["OPTIONS_MANUAL_DELETE_ALL"] = "Todos los objetos"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "Sin valor de venta"

-- Mini-map Eraser Confirmation
L["OPTIONS_SAFETY_HEADER"] = "Confirmación al eliminar desde el minimapa"
L["OPTIONS_SAFETY_DESCRIPTION"] = "Preguntar antes de eliminar los tipos de objeto que marques abajo."
L["OPTIONS_ENABLE_SAFETY"] = "Habilitar confirmación al eliminar desde el minimapa"
L["OPTIONS_SAFETY_QUEST"] = "Para objetos de misiones completadas"
L["OPTIONS_SAFETY_CONSUMABLE"] = "Para consumibles que ya has superado"
L["OPTIONS_SAFETY_WHITE"] = "Para objetos blancos de calidad de vendedor"
L["OPTIONS_SAFETY_GRAY"] = "Para basura de vendedor gris"

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Valor máximo a eliminar"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] =
	"Nunca elimina un objeto o montón que valga más que el límite que definas abajo."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Habilitar valor máximo a eliminar"
L["OPTIONS_VALUE_CAP_LIMIT"] = "Nunca eliminar nada que valga más de"
L["OPTIONS_VALUE_CAP_GOLD"] = "%d de oro"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Avisos de espacio en bolsas"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Cuenta atrás en el chat a medida que tus espacios libres bajan hasta el umbral que definas abajo."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Habilitar avisos de espacio en bolsas"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Umbral de espacios libres"

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
