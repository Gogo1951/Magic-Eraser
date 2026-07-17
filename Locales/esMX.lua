local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "esMX")
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

-- Eraser
L["COMBAT_LOCKOUT"] = "No se pueden eliminar objetos durante el combate."
L["CONFIRM_ERASE"] = "¿Eliminar %s%s?"
L["BAGS_FULL"] = "¡Tus bolsas están llenas!"
L["BAGS_FULL_NUDGE"] = "Tus bolsas están casi llenas. Te quedan %d espacios."
L["BAGS_FULL_NUDGE_ONE"] = "Tus bolsas están casi llenas. Te queda 1 espacio."
L["CURSOR_TOO_FAST"] = "¡Más despacio! Estás haciendo clic más rápido de lo que el juego puede eliminar objetos."
L["ERASED_ITEM"] = "%s%s%s eliminado."
L["ERASED_VALUE_SUFFIX"] = ", valor %s"
L["ERASED_QUEST_SUFFIX"] = ", este objeto estaba asociado a una misión completada"
L["QUEST_ITEM_READY"] = "¡%s ahora se puede eliminar de forma segura!"

-- Item Tooltip
L["TOOLTIP_WILL_ERASE"] = "Magic Eraser eliminará esto."
L["TOOLTIP_IGNORED"] = "Protegido por tu lista de ignorados."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["SOLD_SUMMARY"] = "%s objetos (%s espacios) vendidos, valor %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-venta venderá los objetos al terminar el combate."

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
L["ACTION_ERASE"] = "Eliminar"
L["ACTION_IGNORE"] = "Ignorar"
L["ACTION_TOGGLE"] = "Alternar"
L["ACTION_CLEAR_IGNORE"] = "Vaciar lista de ignorados"
L["BAGS_CLEAN_SHORT"] = "¡Felicidades, tus bolsas están llenas de cosas buenas!"
L["BAGS_CLEAN_HINT"] = "Tendrás que eliminar algo manualmente si quieres liberar espacio."
L["LOADING_ITEM"] = "Cargando ID: %d"
L["MINIMAP_OPTIONS"] = "Opciones de Magic Eraser"
L["MINIMAP_OPTIONS_KEYBIND"] = "Mayús + Clic central"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-venta"
L["AUTO_VEND_DESCRIPTION"] =
	"Vende automáticamente los objetos marcados como basura por Magic Eraser al abrir una ventana de comerciante."
L["IGNORE_LIST"] = "Lista de ignorados"
L["ON"] = "Activado"
L["OFF"] = "Desactivado"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Limpia tus bolsas al instante. Los objetos de misiones completadas, consumibles de bajo nivel, objetos blancos de calidad de vendedor y basura gris se eliminan con cada clic en el botón del minimapa. Cuando visitas a un comerciante, todo lo que se puede vender se vende automáticamente."
L["OPTIONS_WELCOME"] = "Habilitar mensaje de bienvenida"
L["OPTIONS_MINIMAP"] = "Habilitar botón del minimapa"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND_ERASER"] = "/eraser"
L["OPTIONS_COMMAND_ERASER_DESCRIPTION"] = "Abre la interfaz de opciones de Magic Eraser."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Descripciones de objetos"
L["OPTIONS_TOOLTIP_WARNING"] = "Habilitar descripciones para objetos en las bolsas"

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Habilitar Auto-venta"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Habilitar mensajes de Auto-venta"
L["OPTIONS_AUTO_VEND_VERBOSE"] = "Por objeto"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Solo resumen"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Avisos de espacio en bolsas"
L["OPTIONS_BAGS_FULL_NUDGE"] = "Habilitar avisos de espacio en bolsas"
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
