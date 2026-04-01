local strings = {}

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

strings["COMBAT_LOCKOUT"] = "No se pueden eliminar objetos durante el combate."
strings["ERASED_ITEM"] = "%s%s%s eliminado."
strings["ERASED_QUEST_SUFFIX"] = ", este objeto estaba asociado a una misión completada"
strings["ERASED_VALUE_SUFFIX"] = ", valor %s"
strings["SOLD_ITEM"] = "%s%s vendido, valor %s."
strings["CURSOR_TOO_FAST"] = "¡Más despacio! Estás haciendo clic más rápido de lo que el juego puede eliminar objetos."
strings["BAGS_CLEAN"] = "¡Felicidades, tus bolsas están llenas de cosas buenas! Tendrás que eliminar algo manualmente si quieres liberar espacio."
strings["QUEST_ITEM_READY"] = "¡%s ahora se puede eliminar de forma segura!"

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

strings["LOWEST_VALUE_ITEM"] = "Objeto de menor valor"
strings["NO_VALUE"] = "Sin valor"
strings["LEFT_CLICK"] = "Clic izquierdo"
strings["RIGHT_CLICK"] = "Clic derecho"
strings["MIDDLE_CLICK"] = "Clic central"
strings["SHIFT_RIGHT_CLICK"] = "Mayús + Clic derecho"
strings["ACTION_ERASE"] = "Eliminar"
strings["ACTION_IGNORE"] = "Ignorar"
strings["ACTION_TOGGLE"] = "Alternar"
strings["ACTION_CLEAR_IGNORE"] = "Vaciar lista de ignorados"
strings["BAGS_CLEAN_SHORT"] = "¡Felicidades, tus bolsas están llenas de cosas buenas!"
strings["BAGS_CLEAN_HINT"] = "Tendrás que eliminar algo manualmente si quieres liberar espacio."
strings["LOADING_ITEM"] = "Cargando ID: %d"
strings["TOOLTIP_HINT"] = "Ajustes adicionales en Opciones > AddOns > Magic Eraser"

--------------------------------------------------------------------------------
-- Auto-Vend
--------------------------------------------------------------------------------

strings["AUTO_VEND"] = "Auto-venta"
strings["AUTO_VEND_DESC"] = "Vende automáticamente los objetos marcados como basura por Magic Eraser."
strings["ENABLED"] = "Activado"
strings["DISABLED"] = "Desactivado"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

strings["IGNORE_LIST"] = "Lista de ignorados"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

strings["OPTIONS_DESC"] = "Elimina el objeto de menor valor en tus bolsas al hacer clic en el botón del minimapa."
strings["OPTIONS_AUTO_VEND_DESC"] = "Vende automáticamente los objetos marcados como basura por Magic Eraser al abrir una ventana de comerciante."
strings["OPTIONS_RESET"] = "Restablecer"
strings["OPTIONS_RESET_IGNORE"] = "Restablecer lista de ignorados"
strings["OPTIONS_RESET_IGNORE_CONFIRM"] = "¿Eliminar todos los objetos de la lista de ignorados de este personaje?"
strings["OPTIONS_RESET_ALL"] = "Restablecer todos los ajustes de Magic Eraser"
strings["OPTIONS_RESET_ALL_CONFIRM"] = "¿Restablecer todos los ajustes de Magic Eraser a sus valores predeterminados? Esto vacía la lista de ignorados y desactiva la auto-venta."
strings["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
strings["OPTIONS_CURSEFORGE"] = "CurseForge"
strings["OPTIONS_GITHUB"] = "GitHub"
strings["OPTIONS_DISCORD"] = "Discord"

local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "esES")
if L then
    for k, v in pairs(strings) do L[k] = v end
end

local L2 = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "esMX")
if L2 then
    for k, v in pairs(strings) do L2[k] = v end
end
