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
L["CHAT_LOADED"] =
	"Versione %s. Le impostazioni (inclusa l'opzione per disabilitare questo messaggio) si trovano in Opzioni > AddOn > Magic Eraser. Ti piace l'add-on? Dillo a un amico! (="
L["CHAT_OPTIONS_IN_COMBAT"] =
	"Per sicurezza, il pannello delle opzioni non può essere aperto durante il combattimento."

-- Eraser
L["COMBAT_LOCKOUT"] = "Non puoi eliminare oggetti durante il combattimento."
L["CONFIRM_ERASE"] = "Eliminare %s%s?"
L["BAGS_FULL"] = "Le tue borse sono piene!"
L["BAGS_FULL_NUDGE"] = "Le tue borse sono quasi piene. Ti restano %d slot."
L["BAGS_FULL_NUDGE_ONE"] = "Le tue borse sono quasi piene. Ti resta 1 slot."
L["CURSOR_TOO_FAST"] = "Piano! Stai cliccando più velocemente di quanto il gioco possa eliminare gli oggetti."
L["ERASED_ITEM"] = "%s%s eliminato."
L["ERASED_ITEM_WITH_VALUE"] = "%s%s eliminato, valore %s."
L["ERASED_ITEM_FROM_QUEST"] = "%s%s eliminato, da una missione che hai completato."
L["ERASED_ITEM_QUEST_UNAVAILABLE"] = "%s%s eliminato, da una missione che il tuo personaggio non può accettare."
L["QUEST_ITEM_READY"] = "%s ora può essere eliminato in sicurezza!"
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s può essere eliminato in sicurezza, da una missione che il tuo personaggio non può accettare."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s venduto, valore %s."
L["SOLD_SUMMARY"] = "%s oggetti (%s slot) venduti, valore %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "La vendita automatica avverrà al termine del combattimento."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s oggetti (%s slot) prelevati dalla tua banca, valore %s."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Magic Eraser eliminerà questo oggetto."
L["TOOLTIP_IGNORED"] = "Protetto dalla tua lista ignorati."
L["TOOLTIP_ON_ERASE_LIST"] = "Contrassegnato dalla tua lista eliminazione."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Oggetto di minor valore"
L["CLUTTER_REPORT"] = "Rapporto spazzatura"
L["CLUTTER_ITEMS"] = "(%s oggetti)"
L["CLUTTER_SLOTS"] = "%s slot"
L["NO_VALUE"] = "Nessun valore"
L["LEFT_CLICK"] = "Clic sinistro"
L["RIGHT_CLICK"] = "Clic destro"
L["MIDDLE_CLICK"] = "Clic centrale"
L["SHIFT_RIGHT_CLICK"] = "Maiusc + Clic destro"
L["SHIFT_MIDDLE_CLICK"] = "Maiusc + Clic centrale"
L["ACTION_ERASE"] = "Elimina"
L["ACTION_IGNORE"] = "Ignora"
L["ACTION_TOGGLE"] = "Attiva/Disattiva"
L["ACTION_CLEAR_IGNORE"] = "Svuota lista ignorati"
L["BAGS_CLEAN_CONGRATS"] = "Congratulazioni, le tue borse sono piene di cose utili!"
L["BAGS_CLEAN_HINT"] = "Dovrai eliminare qualcosa manualmente se vuoi liberare più spazio."
L["LOADING_ITEM"] = "Caricamento ID: %d"
L["MINIMAP_OPTIONS"] = "Opzioni di Magic Eraser"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Vendita automatica"
L["AUTO_VEND_DESCRIPTION"] =
	"Vende automaticamente gli oggetti segnalati come spazzatura da Magic Eraser quando apri la finestra di un mercante."
L["IGNORE_LIST"] = "Lista ignorati"
L["TAB_IGNORE_LIST"] = "Lista ignorati"
L["TAB_ERASE_LIST"] = "Lista eliminazione"
L["ENABLED"] = "Attivato"
L["DISABLED"] = "Disattivato"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Elimina la spazzatura e libera spazio nelle borse all'istante. Oggetti di missioni completate, consumabili di basso livello, oggetti bianchi di qualità dal mercante e spazzatura grigia se ne vanno con un solo clic sul pulsante della minimappa, e tutto ciò che è vendibile si vende da solo dal mercante. Non trascinarti mai più dietro la spazzatura."
L["OPTIONS_ENABLE_WELCOME"] = "Abilita messaggio di benvenuto"
L["OPTIONS_ENABLE_MINIMAP"] = "Abilita pulsante della minimappa"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre il pannello delle opzioni di questo addon."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Abilita Vendita automatica"
L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"] = "Abilita messaggi Vendita automatica"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Per oggetto"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Solo riepilogo"

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Valore massimo da eliminare"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] = "Non elimina mai un oggetto o una pila che valga più del limite impostato sotto."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Abilita valore massimo da eliminare"
L["OPTIONS_VALUE_CAP_LIMIT"] = "Non eliminare mai nulla che valga più di"
L["OPTIONS_VALUE_CAP_GOLD"] = "%d oro"

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Prelievo dalla banca"
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Abilita prelievo dalla banca"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Preleva automaticamente dalla tua banca gli oggetti segnalati come spazzatura da Magic Eraser quando la apri, così puoi eliminarli."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Descrizioni oggetti"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Aggiunge una riga alla descrizione di un oggetto nelle tue borse quando Magic Eraser lo eliminerebbe, o quando la tua lista ignorati lo sta proteggendo."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Abilita descrizioni per gli oggetti nelle borse"

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Avvisi di spazio nelle borse"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Conta alla rovescia in chat mentre i tuoi slot liberi scendono verso la soglia impostata sotto."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Abilita avvisi di spazio nelle borse"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Soglia di slot liberi"

-- Eraser Confirmations
L["OPTIONS_SAFETY_HEADER"] = "Conferme di eliminazione"
L["OPTIONS_SAFETY_DESCRIPTION"] = "Chiedi conferma prima di eliminare i tipi di oggetto selezionati sotto."
L["OPTIONS_ENABLE_SAFETY"] = "Abilita conferme di eliminazione"
L["OPTIONS_SAFETY_QUEST"] = "Per gli oggetti di missioni completate"
L["OPTIONS_SAFETY_CONSUMABLE"] = "Per i consumabili di basso livello"
L["OPTIONS_SAFETY_WHITE"] = "Per gli oggetti bianchi di qualità dal mercante"
L["OPTIONS_SAFETY_GRAY"] = "Per gli oggetti grigi di qualità dal mercante"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Commenti e supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Globale"
L["OPTIONS_LIST_ADD_ID"] = "Aggiungi tramite ID oggetto"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Digita un ID oggetto e premi Invio. Puoi anche fare Maiusc+clic su un collegamento a un oggetto in chat per inserirlo qui."
L["OPTIONS_LIST_ADD_ID_INVALID"] =
	"Digita un ID oggetto, oppure fai Maiusc+clic su un collegamento a un oggetto in chat."
L["OPTIONS_LIST_REMOVE"] = "Rimuovi"
L["OPTIONS_LIST_EMPTY"] = "Questa lista è vuota."

--------------------------------------------------------------------------------
-- Options: Ignore List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Gli oggetti in una Lista ignorati non vengono mai eliminati né venduti. La lista Globale protegge un oggetto su ogni personaggio, mentre la lista di un personaggio lo protegge solo su quel personaggio."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Sposta questo oggetto nella lista Globale, così da proteggerlo su ogni personaggio."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Gli oggetti in una Lista eliminazione vengono sempre trattati come spazzatura, qualunque sia il loro valore: eliminati con il pulsante della minimappa, oppure venduti quando sei da un mercante. La lista Globale si applica su ogni personaggio, mentre la lista di un personaggio solo su quel personaggio. Una Lista ignorati ha sempre la precedenza, quindi un oggetto presente in entrambe viene lasciato intatto."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"Sposta questo oggetto nella lista Globale, così da eliminarlo su ogni personaggio."
L["OPTIONS_ERASE_RESTORE"] = "Ripristina predefiniti"
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Svuotare la Lista eliminazione di questo personaggio e rimettere solo gli oggetti con cui Magic Eraser parte? Tutto ciò che hai aggiunto tu viene rimosso."
