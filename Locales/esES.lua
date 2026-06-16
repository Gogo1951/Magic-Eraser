local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "esES")
if not L then return end

--------------------------------------------------------------------------------
-- Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Versión %s. Los ajustes (incluyendo la opción para desactivar este mensaje) se pueden encontrar en Opciones > AddOns > Magic Eraser. ¿Disfrutando del add-on? ¡Díselo a un amigo! (="
L["COMBAT_LOCKOUT"] = "No se pueden eliminar objetos durante el combate."
L["ERASED_ITEM"] = "%s%s%s eliminado."
L["ERASED_QUEST_SUFFIX"] = ", este objeto estaba asociado a una misión completada"
L["ERASED_VALUE_SUFFIX"] = ", valor %s"
L["SOLD_ITEM"] = "%s%s vendido, valor %s."
L["CURSOR_TOO_FAST"] = "¡Más despacio! Estás haciendo clic más rápido de lo que el juego puede eliminar objetos."
L["BAGS_CLEAN"] = "¡Felicidades, tus bolsas están llenas de cosas buenas! Tendrás que eliminar algo manualmente si quieres liberar espacio."
L["QUEST_ITEM_READY"] = "¡%s ahora se puede eliminar de forma segura!"

--------------------------------------------------------------------------------
-- Tooltip
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
-- Auto-Vend
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-venta"
L["AUTO_VEND_DESC"] = "Vende automáticamente los objetos marcados como basura por Magic Eraser."
L["ON"] = "Activado"
L["OFF"] = "Desactivado"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

L["IGNORE_LIST"] = "Lista de ignorados"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "Pon fin al desorden del inventario con Magic Eraser. Elimina automáticamente objetos de bajo valor, basura gris y objetos de misiones antiguas. Cuenta con auto-venta, una lista de ignorados fácil de configurar y escaneo inteligente para mantener tus bolsas limpias."
L["OPTIONS_WELCOME"] = "Habilitar mensaje de bienvenida"
L["OPTIONS_AUTO_VEND_DESC"] = "Vende automáticamente los objetos marcados como basura por Magic Eraser al abrir una ventana de comerciante."
L["OPTIONS_RESET"] = "Restablecer"
L["OPTIONS_RESET_IGNORE"] = "Restablecer lista de ignorados"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "¿Eliminar todos los objetos de la lista de ignorados de este personaje?"
L["OPTIONS_RESET_ALL"] = "Restablecer todos los ajustes de Magic Eraser"
L["OPTIONS_RESET_ALL_CONFIRM"] = "¿Restablecer todos los ajustes de Magic Eraser a sus valores predeterminados? Esto vacía la lista de ignorados y desactiva la auto-venta."
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"