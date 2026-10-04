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
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Per sicurezza, l'elenco delle assegnazioni tasti non può essere aperto durante il combattimento."

-- Eraser
L["COMBAT_LOCKOUT"] = "Non puoi eliminare oggetti durante il combattimento."
L["CONFIRM_ERASE"] = "Eliminare %s%s?"
L["BAGS_FULL"] = "Le tue borse sono piene!"
L["BAGS_FULL_NUDGE"] = "Le tue borse sono quasi piene. Ti restano %d slot."
L["BAGS_FULL_NUDGE_ONE"] = "Le tue borse sono quasi piene. Ti resta 1 slot."
L["CURSOR_TOO_FAST"] = "Piano! Stai cliccando più velocemente di quanto il gioco possa eliminare gli oggetti."
L["ERASE_CANDIDATE_CHANGED"] =
	"Quell'oggetto è cambiato prima di poter essere eliminato, quindi non è stato eliminato nulla. Controlla il pulsante della minimappa e riprova."
L["ERASED_ITEM"] = "%s%s eliminato."
L["QUEST_ITEM_READY"] = "%s%s ora può essere eliminato in sicurezza. È avanzato da una missione che hai completato."
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s%s ora può essere eliminato in sicurezza. Avvia una missione che il tuo personaggio non può accettare."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s venduto, valore %s."
L["SOLD_SUMMARY"] = "%s oggetti (%s slot borse) venduti, valore %s."
L["SOLD_SUMMARY_ONE_SLOT"] = "%s oggetti (1 slot borsa) venduti, valore %s."
L["SOLD_SUMMARY_ONE_ITEM"] = "1 oggetto (1 slot borsa) venduto, valore %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "La Vendita automatica venderà al termine del combattimento."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s oggetti (%s slot borse) prelevati dalla tua banca, valore %s."
L["BANK_RETRIEVED_ONE_SLOT"] = "%s oggetti (1 slot borsa) prelevati dalla tua banca, valore %s."
L["BANK_RETRIEVED_ONE_ITEM"] = "1 oggetto (1 slot borsa) prelevato dalla tua banca, valore %s."

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "%s aggiunto alla tua Lista protetti."
L["IGNORE_LIST_MOVED"] = "%s spostato dalla tua Lista eliminazione alla tua Lista protetti."
L["IGNORE_LIST_ALREADY"] = "%s è già nella tua Lista protetti."
L["ERASE_LIST_ADDED"] = "%s aggiunto alla tua Lista eliminazione."
L["ERASE_LIST_ALREADY"] = "%s è già nella tua Lista eliminazione."
L["ERASE_LIST_PROTECTED"] = "%s è nella tua Lista protetti, che ha sempre la precedenza. Rimuovilo prima da lì."
L["NO_HOVERED_ITEM"] = "Passa il mouse su un oggetto, poi premi di nuovo il tasto."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Può essere eliminato."
L["TOOLTIP_IGNORED"] = "Nella tua Lista protetti."
L["TOOLTIP_ON_ERASE_LIST"] = "Nella tua Lista eliminazione: può essere eliminato."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Oggetto di minor valore"
L["CLUTTER_REPORT"] = "Rapporto spazzatura"
L["CLUTTER_ITEMS"] = "(%s oggetti)"
L["CLUTTER_ITEMS_ONE"] = "(1 oggetto)"
L["CLUTTER_SLOTS"] = "%s slot borse"
L["CLUTTER_SLOTS_ONE"] = "1 slot borsa"
L["NO_VALUE"] = "Nessun valore"
L["LEFT_CLICK"] = "Clic sinistro"
L["RIGHT_CLICK"] = "Clic destro"
L["MIDDLE_CLICK"] = "Clic centrale"
L["SHIFT_RIGHT_CLICK"] = "Maiusc + Clic destro"
L["SHIFT_MIDDLE_CLICK"] = "Maiusc + Clic centrale"
L["ACTION_ERASE"] = "Elimina"
L["ACTION_IGNORE"] = "Proteggi"
L["ACTION_TOGGLE"] = "Attiva/Disattiva"
L["ACTION_CLEAR_IGNORE"] = "Svuota Lista protetti"
L["BAGS_CLEAN_CONGRATS"] = "Congratulazioni, le tue borse sono piene di cose utili!"
L["BAGS_CLEAN_HINT"] = "Dovrai eliminare qualcosa manualmente se vuoi liberare più spazio."
L["LOADING_ITEM"] = "Caricamento ID: %d"
L["MINIMAP_OPTIONS"] = "Opzioni di Magic Eraser"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "Elimina oggetto di minor valore"
L["BINDING_ADD_TO_IGNORE_LIST"] = "Aggiungi oggetto sotto il mouse alla Lista protetti"
L["BINDING_ADD_TO_ERASE_LIST"] = "Aggiungi oggetto sotto il mouse alla Lista eliminazione"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Vendita automatica"
L["AUTO_VEND_DESCRIPTION"] =
	"Vende la tua spazzatura non appena apri la finestra di un mercante, a partire da quella di minor valore."
L["TAB_YOUR_CURRENT_BAGS"] = "Le tue borse attuali"
L["TAB_ERASING"] = "Eliminazione"
L["TAB_MERCHANT_BANK"] = "Mercante e banca"
L["TAB_ALERTS"] = "Avvisi e descrizioni"
L["TAB_IGNORE_LIST"] = "Lista protetti"
L["TAB_ERASE_LIST"] = "Lista eliminazione"
L["ENABLED"] = "Attivato"
L["DISABLED"] = "Disattivato"

-- Example lines under chat-printing features. %s is the whole chat line.
L["OPTIONS_EXAMPLE"] = "Esempio: %s"
L["OPTIONS_EXAMPLE_ITEM"] = "Oggetto di esempio"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Elimina la spazzatura e libera spazio nelle borse all'istante. Rimuovi oggetti di missioni completate, consumabili ormai superati, spazzatura da mercante e oggetti grigi con un clic sul pulsante della minimappa. Una lista di spazzatura curata a mano protegge ciò che ti serve, mentre la Vendita automatica vende il resto dal prossimo mercante."
L["OPTIONS_ENABLE_WELCOME"] = "Abilita messaggio di benvenuto"
L["OPTIONS_ENABLE_WELCOME_DESC"] =
	"Mostra in chat un messaggio di benvenuto di una riga con la versione ogni volta che accedi."
L["OPTIONS_ENABLE_MINIMAP"] = "Abilita pulsante della minimappa"
L["OPTIONS_ENABLE_MINIMAP_DESC"] =
	"Mostra il pulsante di Magic Eraser sulla minimappa. La sua icona è il prossimo oggetto in coda, e passandoci sopra il mouse vedi il Rapporto spazzatura."

-- Features
L["OPTIONS_FEATURES_HEADER"] = "Funzionalità"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Comandi"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Apre il pannello delle opzioni di questo add-on."

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Assegnazione tasti"
L["OPTIONS_KEY_NOT_BOUND"] = "Non assegnato"
L["OPTIONS_KEY_SET"] = "Assegna tasto"
L["OPTIONS_KEY_SET_DESC"] = "Apre l'elenco delle assegnazioni tasti del gioco, dove Magic Eraser ha una sua sezione."
L["KEY_BINDINGS_LOCATION"] = "Apri il menu di gioco, poi %s, poi %s, e cerca la sezione Magic Eraser."
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Elimina il prossimo oggetto in coda, come un clic sinistro sul pulsante della minimappa. Non c'è anteprima prima di premere il tasto, quindi assegnalo a un tasto che non premeresti per sbaglio."
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"Protegge l'oggetto sotto il mouse su questo personaggio, ovunque tu lo veda: borse, banca, mercante o finestra del bottino. Se era nella Lista eliminazione di questo personaggio, viene tolto da lì."
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"Aggiunge l'oggetto sotto il mouse alla Lista eliminazione di questo personaggio, qualunque sia il suo valore. La tua Lista protetti ha comunque la precedenza."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Commenti e supporto"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Versione %s"

--------------------------------------------------------------------------------
-- Options: Your Current Bags Panel
--------------------------------------------------------------------------------

L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"] =
	"Cosa eliminerà dopo il pulsante della minimappa e la spazzatura in coda, poi tutto il resto che porti con te, pronto da eliminare o proteggere."
L["OPTIONS_UP_NEXT"] = "Prossimo"
L["OPTIONS_CLUTTER_TOTAL"] = "Totale"
L["OPTIONS_STACKS"] = "(%d pile)"
L["OPTIONS_ERASE_BUTTON"] = "Elimina"
L["OPTIONS_ERASE_BUTTON_DESC"] =
	"Elimina il prossimo oggetto in coda, esattamente come un clic sinistro sul pulsante della minimappa."
L["OPTIONS_PROTECT_BUTTON"] = "Proteggi"
L["OPTIONS_PROTECT_BUTTON_DESC"] =
	"Aggiunge questo oggetto alla Lista protetti di questo personaggio, così non viene mai eliminato né venduto."

-- Everything in Your Bags
L["OPTIONS_EVERYTHING_HEADER"] = "Tutto ciò che hai nelle borse"
L["OPTIONS_EVERYTHING_DESCRIPTION"] =
	"Ogni oggetto che porti con te, spazzatura o no. Spunta Elimina o Proteggi per metterlo nella lista di questo personaggio."
L["OPTIONS_COLUMN_ITEM"] = "Oggetto"
L["OPTIONS_COLUMN_TYPE"] = "Tipo"
L["OPTIONS_COLUMN_ERASE"] = "Elimina"
L["OPTIONS_COLUMN_PROTECT"] = "Proteggi"
L["OPTIONS_CHECK_ERASE_DESC"] =
	"Mette questo oggetto nella Lista eliminazione di questo personaggio, così è sempre spazzatura, qualunque sia il suo valore. Lo toglie dalla Lista protetti di questo personaggio."
L["OPTIONS_CHECK_ERASE_GLOBAL_DESC"] =
	"Questo oggetto è in una lista Tutti i personaggi. Modificalo nella pagina Lista eliminazione o Lista protetti, perché quella lista vale per ogni personaggio."
L["OPTIONS_CHECK_PROTECT_DESC"] =
	"Mette questo oggetto nella Lista protetti di questo personaggio, così non viene mai eliminato né venduto. Lo toglie dalla Lista eliminazione di questo personaggio."
L["OPTIONS_CHECK_PROTECT_GLOBAL_DESC"] =
	"Questo oggetto è nella Lista protetti di Tutti i personaggi. Modificalo nella pagina Lista protetti, perché quella lista vale per ogni personaggio."

-- Why an item counts as junk, beside it in the queue.
L["REASON_QUEST"] = "Missione completata"
L["REASON_QUEST_INELIGIBLE"] = "Non accettabile"
L["REASON_OUTGROWN"] = "Superato"
L["REASON_EQUIPMENT"] = "Oggetto bianco"
L["REASON_GRAY"] = "Grigio"
L["REASON_MANUAL"] = "Lista eliminazione"
L["REASON_ASKS_FIRST"] = "Chiede prima"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] = "Ogni clic elimina la spazzatura di minor valore nelle tue borse, una pila alla volta."
L["TAB_ERASING_RESTORE_NOTE"] =
	"Nota: quasi tutto ciò che elimini per errore può ancora essere recuperato tramite il servizio di ripristino oggetti di Blizzard."

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "Cosa conta come spazzatura"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"Scegli quali tipi di oggetti vengono eliminati. Per perfezionare la scelta, aggiungi un oggetto alla tua Lista protetti per tenerlo sempre, o alla tua Lista eliminazione per eliminarlo sempre."
L["OPTIONS_KIND_QUEST"] = "Oggetti di missioni completate"
L["OPTIONS_KIND_QUEST_DESC"] = "Oggetti che avanzano dopo aver consegnato l'ultima missione che li richiede."
L["OPTIONS_KIND_STARTER"] = "Avvii di missione inaccessibili"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESC"] =
	"Oggetti che avviano una missione che la tua razza o classe non potrà mai accettare."
L["OPTIONS_KIND_FOOD"] = "Cibo e bevande superati"
L["OPTIONS_KIND_FOOD_DESC"] =
	"Cibo e bevande dieci livelli oltre il livello in cui potevi usarli per la prima volta. Pane e acqua iniziali se ne vanno al livello 5."
L["OPTIONS_KIND_AMMO"] = "Frecce e proiettili superati"
L["OPTIONS_KIND_AMMO_DESC"] =
	"Frecce e proiettili non appena puoi usarne un tipo migliore venduto dai mercanti. Le migliori munizioni da mercante per il tuo livello non vengono mai eliminate."
L["OPTIONS_KIND_WHITE"] = "Armi e armature bianche"
L["OPTIONS_KIND_WHITE_DESC"] =
	"Armi e armature bianche che un mercante compra. Strumenti di professione, camicie, abiti eleganti e oggetti bianchi ancora richiesti da una missione vengono tenuti."
L["OPTIONS_KIND_GRAY"] = "Spazzatura grigia"
L["OPTIONS_KIND_GRAY_DESC"] = "Qualsiasi oggetto grigio che un mercante compra."
L["OPTIONS_KIND_ERASE"] = "Elimina"
L["OPTIONS_KIND_ASK"] = "Elimina, chiedi prima"
L["OPTIONS_KIND_KEEP"] = "Tieni"
L["OPTIONS_KIND_ACTION_DESC"] =
	"Elimina lo elimina senza chiedere. Elimina, chiedi prima mostra un Sì o No prima di eliminarlo. Tieni significa che non è spazzatura: mai eliminato, venduto o prelevato dalla banca. Gli oggetti nella tua Lista eliminazione se ne vanno sempre senza chiedere, qualunque sia il loro valore."
L["OPTIONS_KINDS_ALL_KEPT"] =
	"Ogni tipo è impostato su Tieni, quindi vengono eliminati o venduti solo gli oggetti della tua Lista eliminazione."

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Valore massimo da eliminare"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] = "Non elimina mai un oggetto o una pila che valga più del limite impostato sotto."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Abilita valore massimo da eliminare"
L["OPTIONS_ENABLE_VALUE_CAP_DESC"] =
	"Attiva o disattiva il limite di valore. La Vendita automatica vende comunque ciò che viene trattenuto, e la tua Lista eliminazione non è soggetta al limite."
L["OPTIONS_VALUE_CAP_LIMIT_DESC"] =
	"Le pile che valgono più di questo, contando il valore di vendita dell'intera pila, non vengono mai eliminate."
L["OPTIONS_VALUE_CAP_GOLD"] = "%d oro"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Assistenza all'eliminazione manuale"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'Per impostazione predefinita, il gioco ti fa digitare "%s" quando elimini un oggetto %s o superiore. Questo trasforma la richiesta in un semplice Sì o No.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Abilita assistenza all'eliminazione manuale"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESC"] =
	"Attiva o disattiva l'Assistenza all'eliminazione manuale. Il gioco chiede comunque Sì o No; sparisce solo la digitazione."
L["OPTIONS_MANUAL_DELETE_SCOPE_DESC"] =
	"Oggetti senza valore di vendita semplifica solo gli oggetti che nessun mercante compra. Tutti gli oggetti semplifica ogni richiesta da digitare."
L["OPTIONS_MANUAL_DELETE_ALL"] = "Tutti gli oggetti"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "Oggetti senza valore di vendita"

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"Vende la tua spazzatura non appena apri la finestra di un mercante, e riporta nelle borse la spazzatura che hai in banca perché venga venduta insieme. Niente di ciò che è nella tua Lista protetti viene toccato."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Abilita Vendita automatica"
L["OPTIONS_ENABLE_AUTO_VEND_DESC"] =
	"Attiva o disattiva la vendita ai mercanti. Gli oggetti nella tua Lista protetti non vengono mai venduti."
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Riepilogo in chat"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Ogni vendita in chat"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "Nessun resoconto in chat"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESC"] =
	"Cosa scrive in chat la Vendita automatica. Riepilogo in chat scrive un totale per visita. Ogni vendita in chat scrive ogni vendita, poi il totale. Nessun resoconto in chat non scrive nulla."

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Prelievo dalla banca"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Preleva la spazzatura dalla tua banca quando la apri, così può essere venduta o eliminata insieme al resto. Preleva solo dalla tua banca personale, mai da una banca di gilda o da una banca condivisa dall'account."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Abilita prelievo dalla banca"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESC"] =
	"Attiva o disattiva il prelievo dalla banca. Non preleva mai più di quanto possano contenere i tuoi slot borse liberi."
L["OPTIONS_BANK_CUSHION_NOTE"] = "Lascia liberi %d slot borse, perché gli Avvisi di spazio nelle borse sono attivi."
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] = "Lascia libero 1 slot borsa, perché gli Avvisi di spazio nelle borse sono attivi."

--------------------------------------------------------------------------------
-- Options: Alerts & Tooltips Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "Cosa ti dice Magic Eraser di sua iniziativa, in chat e nelle descrizioni."

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "Avvisi nelle descrizioni"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Aggiunge una riga alla descrizione di qualsiasi oggetto nelle tue borse che Magic Eraser potrebbe eliminare, o che la tua Lista protetti protegge."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Abilita avvisi nelle descrizioni"
L["OPTIONS_ENABLE_TOOLTIPS_DESC"] =
	"Attiva o disattiva la riga di Magic Eraser nelle descrizioni degli oggetti nelle borse."

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "Avvisi oggetti di missione"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"Ti avvisa non appena un Oggetto di missioni completate o un Avvio di missione inaccessibile nelle tue borse può essere eliminato in sicurezza."
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "Abilita avvisi oggetti di missione"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESC"] =
	"Attiva o disattiva questi messaggi. Gli Oggetti di missioni completate e gli Avvii di missione inaccessibili vengono eliminati comunque."

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Avvisi di spazio nelle borse"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Ti avvisa mentre si riempiono i tuoi ultimi slot borse liberi. Resta in silenzio mentre è aperta la finestra di un mercante, della cassetta postale o della banca."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Abilita avvisi di spazio nelle borse"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESC"] = "Attiva o disattiva il conto alla rovescia in chat."
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Soglia di slot liberi"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESC"] =
	"Quanti slot liberi fanno partire il conto alla rovescia. Mentre gli avvisi sono attivi, anche il Prelievo dalla banca lascia liberi altrettanti slot."

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Tutti i personaggi"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "Aggiungi dalle borse"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESC"] =
	"Scegli qualsiasi cosa tu abbia con te. Le borse si chiudono quando si apre il pannello delle opzioni, quindi questo sostituisce il trascinamento di un oggetto qui."
L["OPTIONS_LIST_ADD_ID"] = "Aggiungi tramite ID oggetto"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Digita un ID oggetto e premi Invio. Puoi anche fare Maiusc+clic su un collegamento a un oggetto in chat per inserirlo qui."
L["OPTIONS_LIST_ADD_ID_INVALID"] =
	"Digita un ID oggetto, oppure fai Maiusc+clic su un collegamento a un oggetto in chat."
L["OPTIONS_LIST_REMOVE"] = "Rimuovi"
L["OPTIONS_LIST_EMPTY"] = "Questa lista è vuota."
L["OPTIONS_LIST_PROTECTED_TAG"] = "Protetto"

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Gli oggetti in una Lista protetti non vengono mai eliminati né venduti. La lista Tutti i personaggi protegge un oggetto ovunque, mentre la lista di un personaggio lo protegge solo su quel personaggio."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Sposta questo oggetto nella lista Tutti i personaggi, così è protetto ovunque."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Gli oggetti in una Lista eliminazione sono sempre spazzatura, qualunque sia il loro valore: eliminati dal pulsante della minimappa e venduti ai mercanti. La tua Lista protetti ha comunque la precedenza, e le righe su cui prevale mostrano Protetto."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"Sposta questo oggetto nella lista Tutti i personaggi, così viene eliminato su ogni personaggio, anche su quelli per cui non era mai stato aggiunto."
L["OPTIONS_ERASE_RESTORE"] = "Ripristina predefiniti"
L["OPTIONS_ERASE_RESTORE_DESC"] =
	"Riporta la Lista eliminazione di questo personaggio agli oggetti con cui Magic Eraser la fa partire."
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Svuotare la Lista eliminazione di questo personaggio e rimettere solo gli oggetti con cui Magic Eraser ti fa partire? Tutto ciò che hai aggiunto tu viene rimosso."
