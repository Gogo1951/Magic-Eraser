local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "itIT")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] = "Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOn > Magic Eraser. Ti piace l'add-on? Dillo a un amico! (="
L["MESSAGE_RESET"] = "Tutte le impostazioni sono state ripristinate ai valori predefiniti."

-- Eraser
L["COMBAT_LOCKOUT"] = "Non puoi eliminare oggetti durante il combattimento."
L["CURSOR_TOO_FAST"] = "Piano! Stai cliccando più velocemente di quanto il gioco possa eliminare gli oggetti."
L["ERASED_ITEM"] = "%s%s%s eliminato."
L["ERASED_VALUE_SUFFIX"] = ", valore %s"
L["ERASED_QUEST_SUFFIX"] = ", questo oggetto era associato a una missione completata"
L["BAGS_CLEAN"] = "Congratulazioni, le tue borse sono piene di cose utili! Dovrai eliminare qualcosa manualmente se vuoi liberare spazio."
L["QUEST_ITEM_READY"] = "%s ora può essere eliminato in sicurezza!"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s venduto, valore %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "La vendita automatica avverrà al termine del combattimento."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Oggetto di minor valore"
L["NO_VALUE"] = "Nessun valore"
L["LEFT_CLICK"] = "Clic sinistro"
L["RIGHT_CLICK"] = "Clic destro"
L["MIDDLE_CLICK"] = "Clic centrale"
L["SHIFT_RIGHT_CLICK"] = "Maiusc + Clic destro"
L["ACTION_ERASE"] = "Elimina"
L["ACTION_IGNORE"] = "Ignora"
L["ACTION_TOGGLE"] = "Attiva/Disattiva"
L["ACTION_CLEAR_IGNORE"] = "Svuota lista ignorati"
L["BAGS_CLEAN_SHORT"] = "Congratulazioni, le tue borse sono piene di cose utili!"
L["BAGS_CLEAN_HINT"] = "Dovrai eliminare qualcosa manualmente se vuoi liberare spazio."
L["LOADING_ITEM"] = "Caricamento ID: %d"
L["TOOLTIP_HINT"] = "Impostazioni aggiuntive in Opzioni > AddOn > Magic Eraser."

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Vendita automatica"
L["AUTO_VEND_DESCRIPTION"] = "Vende automaticamente gli oggetti segnalati come spazzatura da Magic Eraser."
L["IGNORE_LIST"] = "Lista ignorati"
L["ON"] = "Attivato"
L["OFF"] = "Disattivato"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Magic Eraser identifica le cianfrusaglie di minor valore nel tuo inventario e le elimina con un solo clic sul pulsante della minimappa. Oggetti di missioni completate, consumabili di basso livello, oggetti bianchi di qualità dal mercante e spazzatura grigia: spariti. Quando visiti un mercante, la Vendita automatica vende il resto per te."
L["OPTIONS_WELCOME"] = "Abilita messaggio di benvenuto"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "Vende automaticamente gli oggetti segnalati come spazzatura da Magic Eraser quando apri la finestra di un mercante."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Abilita Vendita automatica"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Abilita messaggi Vendita automatica"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di Magic Eraser."
L["OPTIONS_RESET"] = "Ripristina"
L["OPTIONS_RESET_DESCRIPTION"] = "Ripristina ogni opzione al suo valore predefinito."
L["OPTIONS_RESET_IGNORE"] = "Ripristina lista ignorati"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Rimuovere tutti gli oggetti dalla lista ignorati di questo personaggio?"
L["OPTIONS_RESET_ALL"] = "Ripristina tutte le impostazioni di Magic Eraser"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Ripristinare tutte le impostazioni di Magic Eraser ai valori predefiniti? La lista ignorati verrà svuotata e la vendita automatica verrà disattivata."
L["OPTIONS_FEEDBACK"] = "Feedback e supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
