local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "itIT")
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
L["CHAT_LOADED"] = "Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOn > Magic Eraser. Ti piace l'add-on? Dillo a un amico! (="

-- Eraser
L["COMBAT_LOCKOUT"] = "Non puoi eliminare oggetti durante il combattimento."
L["CURSOR_TOO_FAST"] = "Piano! Stai cliccando più velocemente di quanto il gioco possa eliminare gli oggetti."
L["ERASED_ITEM"] = "%s%s%s eliminato."
L["ERASED_VALUE_SUFFIX"] = ", valore %s"
L["ERASED_QUEST_SUFFIX"] = ", questo oggetto era associato a una missione completata"
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
L["MINIMAP_OPTIONS"] = "Opzioni di Magic Eraser"
L["MINIMAP_OPTIONS_KEYBIND"] = "Maiusc + Clic centrale"

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

L["OPTIONS_DESCRIPTION"] = "Riordina le tue borse all'istante. Oggetti di missioni completate, consumabili di basso livello, oggetti bianchi di qualità dal mercante e spazzatura grigia vengono eliminati a ogni clic sul pulsante della minimappa. Quando visiti un mercante, tutto ciò che è vendibile viene venduto automaticamente."
L["OPTIONS_WELCOME"] = "Abilita messaggio di benvenuto"
L["OPTIONS_MINIMAP"] = "Abilita pulsante della minimappa"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "Vende automaticamente gli oggetti segnalati come spazzatura da Magic Eraser quando apri la finestra di un mercante."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Abilita Vendita automatica"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Abilita messaggi Vendita automatica"
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "Apre l'interfaccia delle opzioni di Magic Eraser."
L["OPTIONS_FEEDBACK"] = "Feedback e supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
