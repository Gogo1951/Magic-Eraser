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
L["CHAT_OPTIONS_IN_COMBAT"] = "Por seguridad, el panel de opciones no se puede abrir durante el combate."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Por seguridad, la lista de asignación de teclas no se puede abrir durante el combate."

-- Eraser
L["COMBAT_LOCKOUT"] = "No se pueden eliminar objetos durante el combate."
L["CONFIRM_ERASE"] = "¿Eliminar %s%s?"
L["BAGS_FULL"] = "¡Tus bolsas están llenas!"
L["BAGS_FULL_NUDGE"] = "Tus bolsas están casi llenas. Te quedan %d espacios."
L["BAGS_FULL_NUDGE_ONE"] = "Tus bolsas están casi llenas. Te queda 1 espacio."
L["CURSOR_TOO_FAST"] = "¡Más despacio! Estás haciendo clic más rápido de lo que el juego puede eliminar objetos."
L["ERASE_CANDIDATE_CHANGED"] =
	"Ese objeto cambió antes de poder eliminarlo, así que no se eliminó nada. Revisa el botón del minimapa y vuelve a intentarlo."
L["ERASED_ITEM"] = "%s%s eliminado."
L["ERASED_ITEM_WITH_VALUE"] = "%s%s eliminado, con un valor de %s."
L["ERASED_ITEM_FROM_QUEST"] = "%s%s eliminado, sobrante de una misión que has completado."
L["ERASED_ITEM_QUEST_UNAVAILABLE"] = "%s%s eliminado, que inicia una misión que tu personaje no puede aceptar."
L["QUEST_ITEM_READY"] = "%s%s ya se puede eliminar de forma segura. Sobra de una misión que has completado."
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s%s ya se puede eliminar de forma segura. Inicia una misión que tu personaje no puede aceptar."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendido, con un valor de %s."
L["SOLD_SUMMARY"] = "%s objetos (%s espacios de bolsa) vendidos, con un valor de %s."
L["SOLD_SUMMARY_ONE_SLOT"] = "%s objetos (1 espacio de bolsa) vendidos, con un valor de %s."
L["SOLD_SUMMARY_ONE_ITEM"] = "1 objeto (1 espacio de bolsa) vendido, con un valor de %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "La Auto-venta venderá en cuanto termine el combate."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s objetos (%s espacios de bolsa) sacados de tu banco, con un valor de %s."
L["BANK_RETRIEVED_ONE_SLOT"] = "%s objetos (1 espacio de bolsa) sacados de tu banco, con un valor de %s."
L["BANK_RETRIEVED_ONE_ITEM"] = "1 objeto (1 espacio de bolsa) sacado de tu banco, con un valor de %s."

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "%s agregado a tu Lista de protegidos."
L["IGNORE_LIST_MOVED"] = "%s movido de tu Lista de eliminación a tu Lista de protegidos."
L["IGNORE_LIST_ALREADY"] = "%s ya está en tu Lista de protegidos."
L["ERASE_LIST_ADDED"] = "%s agregado a tu Lista de eliminación."
L["ERASE_LIST_ALREADY"] = "%s ya está en tu Lista de eliminación."
L["ERASE_LIST_PROTECTED"] = "%s está en tu Lista de protegidos, que siempre tiene prioridad. Quítalo de ahí primero."
L["NO_HOVERED_ITEM"] = "Pasa el cursor por encima de un objeto y vuelve a presionar la tecla."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Se puede eliminar."
L["TOOLTIP_IGNORED"] = "En tu Lista de protegidos."
L["TOOLTIP_ON_ERASE_LIST"] = "En tu Lista de eliminación; se puede eliminar."

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
L["ACTION_IGNORE"] = "Proteger"
L["ACTION_TOGGLE"] = "Alternar"
L["ACTION_CLEAR_IGNORE"] = "Vaciar Lista de protegidos"
L["BAGS_CLEAN_CONGRATS"] = "¡Felicidades, tus bolsas están llenas de cosas buenas!"
L["BAGS_CLEAN_HINT"] = "Tendrás que eliminar algo manualmente si quieres liberar más espacio."
L["LOADING_ITEM"] = "Cargando ID: %d"
L["MINIMAP_OPTIONS"] = "Opciones de Magic Eraser"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "Eliminar objeto de menor valor"
L["BINDING_ADD_TO_IGNORE_LIST"] = "Agregar objeto bajo el cursor a la Lista de protegidos"
L["BINDING_ADD_TO_ERASE_LIST"] = "Agregar objeto bajo el cursor a la Lista de eliminación"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-venta"
L["AUTO_VEND_DESCRIPTION"] = "Vende tu basura en cuanto abres la ventana de un vendedor, empezando por lo más barato."
L["TAB_YOUR_CURRENT_BAGS"] = "Tus bolsas actuales"
L["TAB_ERASING"] = "Eliminación"
L["TAB_MERCHANT_BANK"] = "Vendedor y banco"
L["TAB_ALERTS"] = "Avisos y descripciones"
L["TAB_IGNORE_LIST"] = "Lista de protegidos"
L["TAB_ERASE_LIST"] = "Lista de eliminación"
L["ENABLED"] = "Activado"
L["DISABLED"] = "Desactivado"

-- Example lines under chat-printing features. %s is the whole chat line.
L["OPTIONS_EXAMPLE"] = "Ejemplo: %s"
L["OPTIONS_EXAMPLE_ITEM"] = "Objeto de ejemplo"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Elimina la basura y libera espacio en las bolsas al instante. Quita objetos de misiones completadas, consumibles que ya has superado, basura de vendedor y objetos grises con un clic en el botón del minimapa. Una lista de basura revisada a mano protege lo que necesitas, mientras que la Auto-venta vende el resto al próximo vendedor que visites."
L["OPTIONS_ENABLE_WELCOME"] = "Habilitar mensaje de bienvenida"
L["OPTIONS_ENABLE_WELCOME_DESC"] =
	"Muestra en el chat una línea de bienvenida con la versión cada vez que inicias sesión."
L["OPTIONS_ENABLE_MINIMAP"] = "Habilitar botón del minimapa"
L["OPTIONS_ENABLE_MINIMAP_DESC"] =
	"Muestra el botón de Magic Eraser en tu minimapa. Su icono es el próximo objeto a eliminar, y al pasar el cursor por encima se muestra el Informe de basura."

-- Features
L["OPTIONS_FEATURES_HEADER"] = "Funciones"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandos"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Abre el panel de opciones de este add-on."

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Asignación de teclas"
L["OPTIONS_KEY_NOT_BOUND"] = "Sin asignar"
L["OPTIONS_KEY_SET"] = "Asignar tecla"
L["OPTIONS_KEY_SET_DESC"] =
	"Abre la lista de asignación de teclas del juego, donde Magic Eraser tiene su propia sección."
L["KEY_BINDINGS_LOCATION"] = "Abre el menú del juego, luego %s, luego %s, y busca la sección Magic Eraser."
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Elimina el próximo objeto, igual que un clic izquierdo en el botón del minimapa. No hay vista previa antes de presionar la tecla, así que asígnala donde no la presiones sin querer."
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"Protege el objeto bajo el cursor en este personaje, dondequiera que lo veas: bolsas, banco, vendedor o ventana de botín. Si estaba en la Lista de eliminación de este personaje, sale de ella."
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"Agrega el objeto bajo el cursor a la Lista de eliminación de este personaje, valga lo que valga. Tu Lista de protegidos sigue teniendo prioridad."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Comentarios y soporte"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versión %s"

--------------------------------------------------------------------------------
-- Options: Your Current Bags Panel
--------------------------------------------------------------------------------

L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"] =
	"Lo próximo que eliminará el botón del minimapa y la basura que viene detrás; después, todo lo demás que llevas, listo para eliminar o proteger."
L["OPTIONS_UP_NEXT"] = "Siguiente"
L["OPTIONS_CLUTTER_TOTAL"] = "Total"
L["OPTIONS_STACKS"] = "(%d montones)"
L["OPTIONS_ERASE_BUTTON"] = "Eliminar"
L["OPTIONS_ERASE_BUTTON_DESC"] =
	"Elimina el próximo objeto, exactamente igual que un clic izquierdo en el botón del minimapa."
L["OPTIONS_PROTECT_BUTTON"] = "Proteger"
L["OPTIONS_PROTECT_BUTTON_DESC"] =
	"Agrega este objeto a la Lista de protegidos de este personaje, para que nunca se elimine ni se venda."

-- Everything in Your Bags
L["OPTIONS_EVERYTHING_HEADER"] = "Todo lo que llevas en las bolsas"
L["OPTIONS_EVERYTHING_DESCRIPTION"] =
	"Todos los objetos que llevas, sean basura o no. Marca Eliminar o Proteger para ponerlos en la lista de este personaje."
L["OPTIONS_COLUMN_ITEM"] = "Objeto"
L["OPTIONS_COLUMN_TYPE"] = "Tipo"
L["OPTIONS_COLUMN_ERASE"] = "Eliminar"
L["OPTIONS_COLUMN_PROTECT"] = "Proteger"
L["OPTIONS_CHECK_ERASE_DESC"] =
	"Pone este objeto en la Lista de eliminación de este personaje, para que siempre sea basura, valga lo que valga. Lo quita de la Lista de protegidos de este personaje."
L["OPTIONS_CHECK_ERASE_GLOBAL_DESC"] =
	"Este objeto está en una lista de Todos los personajes. Cámbialo en la página Lista de eliminación o Lista de protegidos, ya que esa lista se aplica a todos los personajes."
L["OPTIONS_CHECK_PROTECT_DESC"] =
	"Pone este objeto en la Lista de protegidos de este personaje, para que nunca se elimine ni se venda. Lo quita de la Lista de eliminación de este personaje."
L["OPTIONS_CHECK_PROTECT_GLOBAL_DESC"] =
	"Este objeto está en la Lista de protegidos de Todos los personajes. Cámbialo en la página Lista de protegidos, ya que esa lista se aplica a todos los personajes."

-- Why an item counts as junk, beside it in the queue.
L["REASON_QUEST"] = "Misión hecha"
L["REASON_QUEST_INELIGIBLE"] = "No disponible"
L["REASON_OUTGROWN"] = "Superado"
L["REASON_EQUIPMENT"] = "Equipo blanco"
L["REASON_GRAY"] = "Gris"
L["REASON_MANUAL"] = "Lista de eliminación"
L["REASON_ASKS_FIRST"] = "Pregunta antes"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] = "Cada clic elimina la basura más barata de tus bolsas, un montón cada vez."
L["TAB_ERASING_RESTORE_NOTE"] =
	"Nota: casi todo lo que elimines por error se puede recuperar mediante el servicio de restauración de objetos de Blizzard."

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "Qué cuenta como basura"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"Elige qué tipos de objetos se eliminan. Para ajustarlo, agrega cualquier objeto a tu Lista de protegidos para conservarlo siempre, o a tu Lista de eliminación para eliminarlo siempre."
L["OPTIONS_KIND_QUEST"] = "Objetos de misión completada"
L["OPTIONS_KIND_QUEST_DESC"] = "Objetos que sobran cuando has entregado la última misión que los necesita."
L["OPTIONS_KIND_STARTER"] = "Iniciadores de misión sin salida"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESC"] = "Objetos que inician una misión que tu raza o clase nunca puede aceptar."
L["OPTIONS_KIND_FOOD"] = "Comida y bebida superadas"
L["OPTIONS_KIND_FOOD_DESC"] =
	"Comida y bebida diez niveles por encima del nivel en que pudiste usarlas por primera vez. El pan y el agua iniciales se van al nivel 5."
L["OPTIONS_KIND_AMMO"] = "Flechas y balas superadas"
L["OPTIONS_KIND_AMMO_DESC"] =
	"Flechas y balas en cuanto puedes usar un tipo mejor a la venta en los vendedores. La mejor munición de vendedor para tu nivel nunca se elimina."
L["OPTIONS_KIND_WHITE"] = "Armas y armaduras blancas"
L["OPTIONS_KIND_WHITE_DESC"] =
	"Armas y armaduras blancas que un vendedor compre. Se conservan las herramientas de profesión, las camisas, la ropa formal y los objetos blancos que aún necesita una misión."
L["OPTIONS_KIND_GRAY"] = "Basura gris"
L["OPTIONS_KIND_GRAY_DESC"] = "Cualquier objeto gris que un vendedor compre."
L["OPTIONS_KIND_ERASE"] = "Eliminar"
L["OPTIONS_KIND_ASK"] = "Eliminar, preguntar antes"
L["OPTIONS_KIND_KEEP"] = "Conservar"
L["OPTIONS_KIND_ACTION_DESC"] =
	"Eliminar lo quita sin preguntar. Eliminar, preguntar antes muestra un Sí o No antes de eliminar. Conservar significa que no es basura: nunca se elimina, se vende ni se saca del banco. Los objetos de tu Lista de eliminación siempre se van sin preguntar, valgan lo que valgan."
L["OPTIONS_KINDS_ALL_KEPT"] =
	"Todos los tipos están en Conservar, así que solo se elimina o se vende lo que hay en tu Lista de eliminación."

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Valor máximo a eliminar"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] =
	"Nunca elimina un objeto o montón que valga más que el límite que definas abajo."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Habilitar valor máximo a eliminar"
L["OPTIONS_ENABLE_VALUE_CAP_DESC"] =
	"Activa o desactiva el límite de valor. La Auto-venta sigue vendiendo lo que este límite retiene, y tu Lista de eliminación no está sujeta a él."
L["OPTIONS_VALUE_CAP_LIMIT_DESC"] =
	"Los montones que valgan más que esto, contando el valor de venta del montón entero, nunca se eliminan."
L["OPTIONS_VALUE_CAP_GOLD"] = "%d de oro"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Ayuda al eliminar a mano"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'Por defecto, el juego te obliga a escribir "%s" al eliminar un objeto %s o superior. Esto convierte esa confirmación en un simple Sí o No.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Habilitar ayuda al eliminar a mano"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESC"] =
	"Activa o desactiva la Ayuda al eliminar a mano. El juego sigue preguntando Sí o No; solo desaparece la escritura."
L["OPTIONS_MANUAL_DELETE_SCOPE_DESC"] =
	"Objetos sin valor de venta simplifica solo los objetos que ningún vendedor compra. Todos los objetos simplifica todas las confirmaciones con escritura."
L["OPTIONS_MANUAL_DELETE_ALL"] = "Todos los objetos"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "Objetos sin valor de venta"

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"Vende tu basura en cuanto abres la ventana de un vendedor, y trae a tus bolsas la basura de tu banco para que se vaya con ella. No se toca nada de tu Lista de protegidos."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Habilitar Auto-venta"
L["OPTIONS_ENABLE_AUTO_VEND_DESC"] =
	"Activa o desactiva la venta a los vendedores. Los objetos de tu Lista de protegidos nunca se venden."
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Resumen en el chat"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Cada venta en el chat"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "Sin informe en el chat"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESC"] =
	"Lo que la Auto-venta muestra en el chat. Resumen en el chat muestra un total por visita. Cada venta en el chat muestra cada venta y luego el total. Sin informe en el chat no muestra nada."

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Recuperación del banco"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Saca la basura de tu banco al abrirlo, para que pueda venderse o eliminarse con el resto. Solo toma objetos de tu propio banco, nunca de un banco de hermandad ni de un banco de cuenta."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Habilitar recuperación del banco"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESC"] =
	"Activa o desactiva la recuperación del banco. Nunca saca más de lo que cabe en tus espacios de bolsa libres."
L["OPTIONS_BANK_CUSHION_NOTE"] =
	"Deja %d espacios de bolsa libres, porque los Avisos de espacio en bolsas están activados."
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] =
	"Deja 1 espacio de bolsa libre, porque los Avisos de espacio en bolsas están activados."

--------------------------------------------------------------------------------
-- Options: Alerts & Tooltips Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "Lo que Magic Eraser te dice por iniciativa propia, en el chat y en las descripciones."

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "Avisos en las descripciones"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Agrega una línea a la descripción de cualquier objeto de tus bolsas que Magic Eraser pueda eliminar, o que proteja tu Lista de protegidos."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Habilitar avisos en las descripciones"
L["OPTIONS_ENABLE_TOOLTIPS_DESC"] = "Activa o desactiva la línea de Magic Eraser en las descripciones de las bolsas."

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "Avisos de objetos de misión"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"Te avisa en cuanto un Objeto de misión completada o un Iniciador de misión sin salida de tus bolsas se puede eliminar sin riesgo."
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "Habilitar avisos de objetos de misión"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESC"] =
	"Activa o desactiva estos mensajes. Los Objetos de misión completada y los Iniciadores de misión sin salida se eliminan igualmente."

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Avisos de espacio en bolsas"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Te avisa a medida que se llenan tus últimos espacios de bolsa libres. No dice nada mientras haya abierta una ventana de vendedor, buzón o banco."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Habilitar avisos de espacio en bolsas"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESC"] = "Activa o desactiva la cuenta regresiva en el chat."
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Umbral de espacios libres"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESC"] =
	"Cuántos espacios libres inician la cuenta regresiva. Mientras los avisos están activados, la Recuperación del banco también deja libres esos espacios."

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Todos los personajes"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "Agregar desde las bolsas"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESC"] =
	"Elige cualquier cosa que lleves. Las bolsas se cierran al abrir el panel de opciones, así que esto sustituye a arrastrar un objeto hasta aquí."
L["OPTIONS_LIST_ADD_ID"] = "Agregar por ID de objeto"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Escribe un ID de objeto y presiona Enter. También puedes hacer Mayús+clic en un enlace de objeto del chat para insertarlo aquí."
L["OPTIONS_LIST_ADD_ID_INVALID"] = "Escribe un ID de objeto, o haz Mayús+clic en un enlace de objeto del chat."
L["OPTIONS_LIST_REMOVE"] = "Quitar"
L["OPTIONS_LIST_EMPTY"] = "Esta lista está vacía."
L["OPTIONS_LIST_PROTECTED_TAG"] = "Protegido"

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Los objetos de una Lista de protegidos nunca se eliminan ni se venden. La lista de Todos los personajes protege un objeto en todas partes, y la lista propia de un personaje lo protege solo en ese personaje."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Mueve este objeto a la lista de Todos los personajes, para que esté protegido en todas partes."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Los objetos de una Lista de eliminación siempre son basura, valgan lo que valgan: los elimina el botón del minimapa y se venden a los vendedores. Tu Lista de protegidos sigue teniendo prioridad, y una fila que esta anula indica Protegido."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"Mueve este objeto a la lista de Todos los personajes, para que se elimine en todos los personajes, incluidos aquellos en los que nunca se agregó."
L["OPTIONS_ERASE_RESTORE"] = "Restaurar valores predeterminados"
L["OPTIONS_ERASE_RESTORE_DESC"] =
	"Devuelve la Lista de eliminación de este personaje a los objetos con los que Magic Eraser la empieza."
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"¿Vaciar la Lista de eliminación de este personaje y dejar solo los objetos con los que Magic Eraser te hace empezar? Se quitará todo lo que hayas agregado tú."
