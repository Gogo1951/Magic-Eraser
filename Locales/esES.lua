local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "esES")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] = "Versión %s. Los ajustes (incluyendo la opción para desactivar este mensaje) se pueden encontrar en Opciones > AddOns > Magic Eraser. ¿Disfrutando del add-on? ¡Díselo a un amigo! (="
L["MESSAGE_RESET"] = "Todos los ajustes han sido restablecidos a sus valores predeterminados."

-- Eraser
L["COMBAT_LOCKOUT"] = "No se pueden eliminar objetos durante el combate."
L["CURSOR_TOO_FAST"] = "¡Más despacio! Estás haciendo clic más rápido de lo que el juego puede eliminar objetos."
L["ERASED_ITEM"] = "%s%s%s eliminado."
L["ERASED_VALUE_SUFFIX"] = ", valor %s"
L["ERASED_QUEST_SUFFIX"] = ", este objeto estaba asociado a una misión completada"
L["BAGS_CLEAN"] = "¡Felicidades, tus bolsas están llenas de cosas buenas! Tendrás que eliminar algo manualmente si quieres liberar espacio."
L["QUEST_ITEM_READY"] = "¡%s ahora se puede eliminar de forma segura!"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-venta venderá los objetos al terminar el combate."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Objeto de menor valor"
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
L["TOOLTIP_HINT"] = "Ajustes adicionales en Opciones > AddOns > Magic Eraser."

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-venta"
L["AUTO_VEND_DESCRIPTION"] = "Vende automáticamente los objetos marcados como basura por Magic Eraser."
L["IGNORE_LIST"] = "Lista de ignorados"
L["ON"] = "Activado"
L["OFF"] = "Desactivado"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Magic Eraser identifica la basura de menor valor en tu inventario y la elimina con un solo clic en el botón del minimapa. Objetos de misiones completadas, consumibles de bajo nivel, objetos blancos de calidad de vendedor y basura gris... desaparecidos. Cuando visitas a un comerciante, Auto-venta vende el resto por ti automáticamente."
L["OPTIONS_WELCOME"] = "Habilitar mensaje de bienvenida"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "Vende automáticamente los objetos marcados como basura por Magic Eraser al abrir una ventana de comerciante."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Habilitar Auto-venta"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Habilitar mensajes de Auto-venta"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "Abre la interfaz de opciones de Magic Eraser."
L["OPTIONS_RESET"] = "Restablecer"
L["OPTIONS_RESET_DESCRIPTION"] = "Restaura todas las opciones a su valor predeterminado."
L["OPTIONS_RESET_IGNORE"] = "Restablecer lista de ignorados"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "¿Eliminar todos los objetos de la lista de ignorados de este personaje?"
L["OPTIONS_RESET_ALL"] = "Restablecer todos los ajustes de Magic Eraser"
L["OPTIONS_RESET_ALL_CONFIRM"] = "¿Restablecer todos los ajustes de Magic Eraser a sus valores predeterminados? Esto vacía la lista de ignorados y desactiva la auto-venta."
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
