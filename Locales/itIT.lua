local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "itIT")
if not L then return end

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["COMBAT_LOCKOUT"] = "Non puoi eliminare oggetti durante il combattimento."
L["ERASED_ITEM"] = "%s%s%s eliminato."
L["ERASED_QUEST_SUFFIX"] = ", questo oggetto era associato a una missione completata"
L["ERASED_VALUE_SUFFIX"] = ", valore %s"
L["SOLD_ITEM"] = "%s%s venduto, valore %s."
L["CURSOR_TOO_FAST"] = "Piano! Stai cliccando più velocemente di quanto il gioco possa eliminare gli oggetti."
L["BAGS_CLEAN"] = "Congratulazioni, le tue borse sono piene di cose utili! Dovrai eliminare qualcosa manualmente se vuoi liberare spazio."
L["QUEST_ITEM_READY"] = "%s ora può essere eliminato in sicurezza!"

--------------------------------------------------------------------------------
-- Tooltip
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
L["TOOLTIP_HINT"] = "Impostazioni aggiuntive in Opzioni > AddOn > Magic Eraser"

--------------------------------------------------------------------------------
-- Auto-Vend
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Vendita automatica"
L["AUTO_VEND_DESC"] = "Vende automaticamente gli oggetti segnalati come spazzatura da Magic Eraser."
L["ENABLED"] = "Attivato"
L["DISABLED"] = "Disattivato"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

L["IGNORE_LIST"] = "Lista ignorati"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "Elimina l'oggetto di minor valore nelle tue borse cliccando sul pulsante della minimappa."
L["OPTIONS_AUTO_VEND_DESC"] = "Vende automaticamente gli oggetti segnalati come spazzatura da Magic Eraser quando apri la finestra di un mercante."
L["OPTIONS_RESET"] = "Ripristina"
L["OPTIONS_RESET_IGNORE"] = "Ripristina lista ignorati"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Rimuovere tutti gli oggetti dalla lista ignorati di questo personaggio?"
L["OPTIONS_RESET_ALL"] = "Ripristina tutte le impostazioni di Magic Eraser"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Ripristinare tutte le impostazioni di Magic Eraser ai valori predefiniti? La lista ignorati verrà svuotata e la vendita automatica verrà disattivata."
L["OPTIONS_FEEDBACK"] = "Feedback e supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
