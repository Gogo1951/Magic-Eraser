local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "deDE")
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
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) findest du unter Optionen > AddOns > Magic Eraser. Gefällt dir das Add-on? Erzähle einem Freund davon! (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Aus Sicherheitsgründen kann das Optionsfenster im Kampf nicht geöffnet werden."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "Aus Sicherheitsgründen kann die Tastaturbelegung im Kampf nicht geöffnet werden."

-- Eraser
L["COMBAT_LOCKOUT"] = "Gegenstände können im Kampf nicht gelöscht werden."
L["CONFIRM_ERASE"] = "%s%s löschen?"
L["BAGS_FULL"] = "Deine Taschen sind voll!"
L["BAGS_FULL_NUDGE"] = "Deine Taschen sind fast voll. Du hast noch %d freie Plätze."
L["BAGS_FULL_NUDGE_ONE"] = "Deine Taschen sind fast voll. Du hast noch 1 freien Platz."
L["CURSOR_TOO_FAST"] = "Langsamer! Du klickst schneller, als das Spiel Gegenstände löschen kann."
L["ERASE_CANDIDATE_CHANGED"] =
	"Dieser Gegenstand hat sich vor dem Löschen verändert, daher wurde nichts gelöscht. Sieh dir die Minikarten-Schaltfläche an und versuche es erneut."
L["ERASED_ITEM"] = "%s%s gelöscht."
L["QUEST_ITEM_READY"] =
	"%s%s kann jetzt sicher gelöscht werden. Der Gegenstand ist von einer Quest übrig, die du abgeschlossen hast."
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s%s kann jetzt sicher gelöscht werden. Der Gegenstand startet eine Quest, die dein Charakter nicht annehmen kann."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s verkauft, Wert %s."
L["SOLD_SUMMARY"] = "%s Gegenstände (%s Taschenplätze) verkauft, Wert %s."
L["SOLD_SUMMARY_ONE_SLOT"] = "%s Gegenstände (1 Taschenplatz) verkauft, Wert %s."
L["SOLD_SUMMARY_ONE_ITEM"] = "1 Gegenstand (1 Taschenplatz) verkauft, Wert %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-Verkauf wird ausgeführt, sobald der Kampf endet."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s Gegenstände (%s Taschenplätze) aus deiner Bank geholt, Wert %s."
L["BANK_RETRIEVED_ONE_SLOT"] = "%s Gegenstände (1 Taschenplatz) aus deiner Bank geholt, Wert %s."
L["BANK_RETRIEVED_ONE_ITEM"] = "1 Gegenstand (1 Taschenplatz) aus deiner Bank geholt, Wert %s."

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "%s zu deiner Schutzliste hinzugefügt."
L["IGNORE_LIST_MOVED"] = "%s von deiner Löschliste auf deine Schutzliste verschoben."
L["IGNORE_LIST_ALREADY"] = "%s steht bereits auf deiner Schutzliste."
L["ERASE_LIST_ADDED"] = "%s zu deiner Löschliste hinzugefügt."
L["ERASE_LIST_ALREADY"] = "%s steht bereits auf deiner Löschliste."
L["ERASE_LIST_PROTECTED"] =
	"%s steht auf deiner Schutzliste, und die hat immer Vorrang. Entferne den Gegenstand zuerst dort."
L["NO_HOVERED_ITEM"] = "Fahre mit der Maus über einen Gegenstand und drücke die Taste dann erneut."

--------------------------------------------------------------------------------
-- Item Tooltips
--------------------------------------------------------------------------------

L["TOOLTIP_WILL_ERASE"] = "Kann gelöscht werden."
L["TOOLTIP_IGNORED"] = "Auf deiner Schutzliste."
L["TOOLTIP_ON_ERASE_LIST"] = "Auf deiner Löschliste, kann gelöscht werden."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Gegenstand mit geringstem Wert"
L["CLUTTER_REPORT"] = "Ramsch-Bericht"
L["CLUTTER_ITEMS"] = "(%s Gegenstände)"
L["CLUTTER_ITEMS_ONE"] = "(1 Gegenstand)"
L["CLUTTER_SLOTS"] = "%s Taschenplätze"
L["CLUTTER_SLOTS_ONE"] = "1 Taschenplatz"
L["NO_VALUE"] = "Kein Wert"
L["LEFT_CLICK"] = "Linksklick"
L["RIGHT_CLICK"] = "Rechtsklick"
L["MIDDLE_CLICK"] = "Mittelklick"
L["SHIFT_RIGHT_CLICK"] = "Umschalt + Rechtsklick"
L["SHIFT_MIDDLE_CLICK"] = "Umschalt + Mittelklick"
L["ACTION_ERASE"] = "Löschen"
L["ACTION_IGNORE"] = "Schützen"
L["ACTION_TOGGLE"] = "Umschalten"
L["ACTION_CLEAR_IGNORE"] = "Schutzliste leeren"
L["BAGS_CLEAN_CONGRATS"] = "Glückwunsch, deine Taschen sind voller nützlicher Dinge!"
L["BAGS_CLEAN_HINT"] = "Du musst manuell etwas löschen, wenn du mehr Platz schaffen willst."
L["LOADING_ITEM"] = "Lade ID: %d"
L["MINIMAP_OPTIONS"] = "Magic Eraser Optionen"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "Gegenstand mit geringstem Wert löschen"
L["BINDING_ADD_TO_IGNORE_LIST"] = "Gegenstand unter der Maus zur Schutzliste hinzufügen"
L["BINDING_ADD_TO_ERASE_LIST"] = "Gegenstand unter der Maus zur Löschliste hinzufügen"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-Verkauf"
L["AUTO_VEND_DESCRIPTION"] =
	"Verkauft deinen Ramsch, sobald du ein Händlerfenster öffnest, die günstigsten Gegenstände zuerst."
L["TAB_YOUR_CURRENT_BAGS"] = "Deine aktuellen Taschen"
L["TAB_ERASING"] = "Löschen"
L["TAB_MERCHANT_BANK"] = "Händler und Bank"
L["TAB_ALERTS"] = "Hinweise und Tooltips"
L["TAB_IGNORE_LIST"] = "Schutzliste"
L["TAB_ERASE_LIST"] = "Löschliste"
L["ENABLED"] = "Aktiviert"
L["DISABLED"] = "Deaktiviert"

-- Example lines under chat-printing features. %s is the whole chat line.
L["OPTIONS_EXAMPLE"] = "Beispiel: %s"
L["OPTIONS_EXAMPLE_ITEM"] = "Beispielgegenstand"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Lösche Ramsch und schaffe im Handumdrehen Taschenplatz. Räume Gegenstände abgeschlossener Quests, ausgediente Verbrauchsgüter, Händlermüll und graue Gegenstände mit einem Klick auf die Minikarten-Schaltfläche weg. Eine kuratierte Ramschliste schützt, was du brauchst, während der Auto-Verkauf den Rest beim nächsten Händler verkauft."
L["OPTIONS_ENABLE_WELCOME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_ENABLE_WELCOME_DESC"] =
	"Zeigt bei jedem Einloggen eine einzeilige Begrüßung mit der Versionsnummer im Chat."
L["OPTIONS_ENABLE_MINIMAP"] = "Minikarten-Schaltfläche aktivieren"
L["OPTIONS_ENABLE_MINIMAP_DESC"] =
	"Zeigt die Schaltfläche von Magic Eraser an deiner Minikarte. Ihr Symbol ist der nächste Gegenstand an der Reihe, und wenn du mit der Maus darüberfährst, siehst du den Ramsch-Bericht."

-- Features
L["OPTIONS_FEATURES_HEADER"] = "Funktionen"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet das Optionsfenster dieses Add-ons."

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Tastaturbelegung"
L["OPTIONS_KEY_NOT_BOUND"] = "Nicht belegt"
L["OPTIONS_KEY_SET"] = "Taste festlegen"
L["OPTIONS_KEY_SET_DESC"] = "Öffnet die Tastaturbelegung des Spiels, in der Magic Eraser einen eigenen Abschnitt hat."
L["KEY_BINDINGS_LOCATION"] = "Öffne das Spielmenü, dann %s, dann %s, und suche den Abschnitt Magic Eraser."
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Löscht den nächsten Gegenstand an der Reihe, genau wie ein Linksklick auf die Minikarten-Schaltfläche. Vor einem Tastendruck gibt es keine Vorschau, also leg die Taste irgendwohin, wo du sie nicht versehentlich drückst."
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"Schützt den Gegenstand unter deiner Maus auf diesem Charakter, wo immer du ihn siehst: Taschen, Bank, Händler oder Beutefenster. Stand er auf der Löschliste dieses Charakters, wird er dort entfernt."
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"Fügt den Gegenstand unter deiner Maus zur Löschliste dieses Charakters hinzu, egal was er wert ist. Deine Schutzliste hat trotzdem Vorrang."

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Feedback & Unterstützung"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Options: Your Current Bags Panel
--------------------------------------------------------------------------------

L["OPTIONS_YOUR_CURRENT_BAGS_DESCRIPTION"] =
	"Was die Minikarten-Schaltfläche als Nächstes löscht und der Ramsch dahinter, danach alles andere, was du bei dir trägst, bereit zum Löschen oder Schützen."
L["OPTIONS_UP_NEXT"] = "Als Nächstes"
L["OPTIONS_CLUTTER_TOTAL"] = "Gesamt"
L["OPTIONS_STACKS"] = "(%d Stapel)"
L["OPTIONS_ERASE_BUTTON"] = "Löschen"
L["OPTIONS_ERASE_BUTTON_DESC"] =
	"Löscht den nächsten Gegenstand an der Reihe, genau wie ein Linksklick auf die Minikarten-Schaltfläche."
L["OPTIONS_PROTECT_BUTTON"] = "Schützen"
L["OPTIONS_PROTECT_BUTTON_DESC"] =
	"Fügt diesen Gegenstand zur Schutzliste dieses Charakters hinzu, damit er nie gelöscht oder verkauft wird."

-- Everything in Your Bags
L["OPTIONS_EVERYTHING_HEADER"] = "Alles in deinen Taschen"
L["OPTIONS_EVERYTHING_DESCRIPTION"] =
	"Jeder Gegenstand, den du bei dir trägst, ob Ramsch oder nicht. Hake Löschen oder Schützen an, um ihn auf die Liste dieses Charakters zu setzen."
L["OPTIONS_COLUMN_ITEM"] = "Gegenstand"
L["OPTIONS_COLUMN_TYPE"] = "Typ"
L["OPTIONS_COLUMN_ERASE"] = "Löschen"
L["OPTIONS_COLUMN_PROTECT"] = "Schützen"
L["OPTIONS_CHECK_ERASE_DESC"] =
	"Setzt diesen Gegenstand auf die Löschliste dieses Charakters, damit er immer als Ramsch gilt, egal was er wert ist. Entfernt ihn von der Schutzliste dieses Charakters."
L["OPTIONS_CHECK_ERASE_GLOBAL_DESC"] =
	"Dieser Gegenstand steht auf einer Liste für Alle Charaktere. Ändere das auf der Seite Löschliste oder Schutzliste, da diese Liste für jeden Charakter gilt."
L["OPTIONS_CHECK_PROTECT_DESC"] =
	"Setzt diesen Gegenstand auf die Schutzliste dieses Charakters, damit er nie gelöscht oder verkauft wird. Entfernt ihn von der Löschliste dieses Charakters."
L["OPTIONS_CHECK_PROTECT_GLOBAL_DESC"] =
	"Dieser Gegenstand steht auf der Schutzliste für Alle Charaktere. Ändere das auf der Seite Schutzliste, da diese Liste für jeden Charakter gilt."

-- Why an item counts as junk, beside it in the queue.
L["REASON_QUEST"] = "Quest erledigt"
L["REASON_QUEST_INELIGIBLE"] = "Nicht annehmbar"
L["REASON_OUTGROWN"] = "Ausgedient"
L["REASON_EQUIPMENT"] = "Weiße Ausrüstung"
L["REASON_GRAY"] = "Grau"
L["REASON_MANUAL"] = "Löschliste"
L["REASON_ASKS_FIRST"] = "Fragt erst"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] =
	"Jeder Klick löscht den günstigsten Ramsch in deinen Taschen, einen Stapel nach dem anderen."
L["TAB_ERASING_RESTORE_NOTE"] =
	"Gut zu wissen: Fast alles, was versehentlich gelöscht wurde, lässt sich über Blizzards Gegenstandswiederherstellung zurückholen."

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "Was als Ramsch gilt"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"Wähle, welche Arten von Gegenständen gelöscht werden. Zur Feinabstimmung füge einen Gegenstand deiner Schutzliste hinzu, um ihn immer zu behalten, oder deiner Löschliste, um ihn immer zu löschen."
L["OPTIONS_KIND_QUEST"] = "Gegenstände abgeschlossener Quests"
L["OPTIONS_KIND_QUEST_DESC"] =
	"Gegenstände, die übrig bleiben, sobald du die letzte Quest abgegeben hast, für die sie gebraucht werden."
L["OPTIONS_KIND_STARTER"] = "Unbrauchbare Queststarter"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESC"] =
	"Gegenstände, die eine Quest starten, die dein Volk oder deine Klasse niemals annehmen kann."
L["OPTIONS_KIND_FOOD"] = "Ausgediente Speisen und Getränke"
L["OPTIONS_KIND_FOOD_DESC"] =
	"Speisen und Getränke, sobald du zehn Stufen über der Stufe bist, ab der du sie benutzen konntest. Anfängerbrot und -wasser gehen ab Stufe 5."
L["OPTIONS_KIND_AMMO"] = "Ausgediente Pfeile und Kugeln"
L["OPTIONS_KIND_AMMO_DESC"] =
	"Pfeile und Kugeln, sobald du eine bessere Sorte benutzen kannst, die Händler verkaufen. Die beste Händlermunition für deine Stufe wird nie gelöscht."
L["OPTIONS_KIND_WHITE"] = "Weiße Waffen und Rüstungen"
L["OPTIONS_KIND_WHITE_DESC"] =
	"Weiße Waffen und Rüstungen, die ein Händler ankauft. Berufswerkzeuge, Hemden, festliche Kleidung und weiße Gegenstände, die eine Quest noch braucht, werden behalten."
L["OPTIONS_KIND_GRAY"] = "Grauer Müll"
L["OPTIONS_KIND_GRAY_DESC"] = "Jeder graue Gegenstand, den ein Händler ankauft."
L["OPTIONS_KIND_ERASE"] = "Löschen"
L["OPTIONS_KIND_ASK"] = "Löschen, erst fragen"
L["OPTIONS_KIND_KEEP"] = "Behalten"
L["OPTIONS_KIND_ACTION_DESC"] =
	"Löschen löscht ohne Nachfrage. Löschen, erst fragen zeigt vor dem Löschen ein Ja oder Nein. Behalten heißt, es ist kein Ramsch: Es wird nie gelöscht, verkauft oder aus der Bank geholt. Gegenstände auf deiner Löschliste gehen immer ohne Nachfrage, egal was sie wert sind."
L["OPTIONS_KINDS_ALL_KEPT"] =
	"Jede Art steht auf Behalten, daher werden nur Gegenstände deiner Löschliste gelöscht oder verkauft."

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Maximaler Wert zum Löschen"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] =
	"Löscht niemals einen Gegenstand oder Stapel, der mehr wert ist als das unten festgelegte Limit."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Maximalen Wert zum Löschen aktivieren"
L["OPTIONS_ENABLE_VALUE_CAP_DESC"] =
	"Schaltet das Wertlimit ein oder aus. Der Auto-Verkauf verkauft trotzdem alles, was dadurch zurückgehalten wird, und für deine Löschliste gilt das Limit nicht."
L["OPTIONS_VALUE_CAP_LIMIT_DESC"] = "Stapel, deren gesamter Verkaufswert darüber liegt, werden nie gelöscht."
L["OPTIONS_VALUE_CAP_GOLD"] = "%d Gold"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Hilfe beim manuellen Löschen"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'Standardmäßig musst du "%s" eintippen, wenn du einen Gegenstand der Qualität %s oder besser löschst. Das hier macht daraus ein einfaches Ja oder Nein.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Hilfe beim manuellen Löschen aktivieren"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESC"] =
	"Schaltet die Hilfe beim manuellen Löschen ein oder aus. Das Spiel fragt trotzdem Ja oder Nein, nur das Eintippen entfällt."
L["OPTIONS_MANUAL_DELETE_SCOPE_DESC"] =
	"Gegenstände ohne Verkaufswert vereinfacht nur Gegenstände, die kein Händler ankauft. Alle Gegenstände vereinfacht jede Eingabeaufforderung."
L["OPTIONS_MANUAL_DELETE_ALL"] = "Alle Gegenstände"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "Gegenstände ohne Verkaufswert"

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"Verkauft deinen Ramsch, sobald du ein Händlerfenster öffnest, und holt Ramsch aus deiner Bank zurück in deine Taschen, damit er gleich mit verkauft wird. Nichts auf deiner Schutzliste wird angerührt."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Auto-Verkauf aktivieren"
L["OPTIONS_ENABLE_AUTO_VEND_DESC"] =
	"Schaltet das Verkaufen bei Händlern ein oder aus. Gegenstände auf deiner Schutzliste werden nie verkauft."
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Zusammenfassung im Chat"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Jeder Verkauf im Chat"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "Kein Chatbericht"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESC"] =
	"Was der Auto-Verkauf im Chat ausgibt. Zusammenfassung im Chat gibt eine Summe pro Besuch aus. Jeder Verkauf im Chat gibt jeden Verkauf und dann die Summe aus. Kein Chatbericht gibt nichts aus."

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Bankentnahme"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Holt Ramsch aus deiner Bank, wenn du sie öffnest, damit er mit dem Rest verkauft oder gelöscht werden kann. Es wird nur aus deiner eigenen Bank genommen, nie aus einer Gildenbank oder einer accountweiten Bank."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Bankentnahme aktivieren"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESC"] =
	"Schaltet die Bankentnahme ein oder aus. Sie holt nie mehr, als deine freien Taschenplätze fassen können."
L["OPTIONS_BANK_CUSHION_NOTE"] = "Lässt %d Taschenplätze frei, weil Taschenplatz-Warnungen aktiviert sind."
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] = "Lässt 1 Taschenplatz frei, weil Taschenplatz-Warnungen aktiviert sind."

--------------------------------------------------------------------------------
-- Options: Alerts & Tooltips Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "Was dir Magic Eraser von sich aus mitteilt, im Chat und in Tooltips."

-- Tooltip Warnings
L["OPTIONS_TOOLTIP_HEADER"] = "Tooltip-Warnungen"
L["OPTIONS_TOOLTIP_DESCRIPTION"] =
	"Fügt dem Tooltip jedes Gegenstands in deinen Taschen eine Zeile hinzu, den Magic Eraser löschen kann oder den deine Schutzliste schützt."
L["OPTIONS_ENABLE_TOOLTIPS"] = "Tooltip-Warnungen aktivieren"
L["OPTIONS_ENABLE_TOOLTIPS_DESC"] = "Schaltet die Zeile von Magic Eraser in Taschen-Tooltips ein oder aus."

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "Hinweise zu Questgegenständen"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"Sagt dir sofort Bescheid, wenn ein Gegenstand abgeschlossener Quests oder ein unbrauchbarer Queststarter in deinen Taschen sicher gelöscht werden kann."
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "Hinweise zu Questgegenständen aktivieren"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESC"] =
	"Schaltet diese Nachrichten ein oder aus. Gegenstände abgeschlossener Quests und unbrauchbare Queststarter werden so oder so gelöscht."

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Taschenplatz-Warnungen"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Warnt dich, wenn sich deine letzten freien Taschenplätze füllen. Bleibt still, solange ein Händler-, Briefkasten- oder Bankfenster geöffnet ist."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Taschenplatz-Warnungen aktivieren"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESC"] = "Schaltet den Countdown im Chat ein oder aus."
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Schwellenwert für freie Plätze"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESC"] =
	"Ab wie vielen freien Plätzen der Countdown beginnt. Solange die Warnungen aktiv sind, lässt die Bankentnahme auch so viele Plätze frei."

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Alle Charaktere"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "Aus Taschen hinzufügen"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESC"] =
	"Wähle etwas aus, das du bei dir trägst. Die Taschen schließen sich, wenn das Optionsfenster geöffnet wird, daher ersetzt das hier das Hineinziehen eines Gegenstands."
L["OPTIONS_LIST_ADD_ID"] = "Über Gegenstands-ID hinzufügen"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Gib eine Gegenstands-ID ein und drücke die Eingabetaste. Du kannst auch mit Umschalt auf einen Gegenstandslink im Chat klicken, um ihn hier einzufügen."
L["OPTIONS_LIST_ADD_ID_INVALID"] =
	"Gib eine Gegenstands-ID ein oder klicke mit Umschalt auf einen Gegenstandslink im Chat."
L["OPTIONS_LIST_REMOVE"] = "Entfernen"
L["OPTIONS_LIST_EMPTY"] = "Diese Liste ist leer."
L["OPTIONS_LIST_PROTECTED_TAG"] = "Geschützt"

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Gegenstände auf einer Schutzliste werden nie gelöscht und nie verkauft. Die Liste für Alle Charaktere schützt einen Gegenstand überall, die eigene Liste eines Charakters nur dort."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Verschiebt diesen Gegenstand auf die Liste für Alle Charaktere, damit er überall geschützt ist."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Gegenstände auf einer Löschliste gelten immer als Ramsch, egal was sie wert sind: Sie werden über die Minikarten-Schaltfläche gelöscht und bei Händlern verkauft. Deine Schutzliste hat trotzdem Vorrang, und eine Zeile, die sie überstimmt, zeigt Geschützt an."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"Verschiebt diesen Gegenstand auf die Liste für Alle Charaktere, damit er auf jedem Charakter gelöscht wird, auch auf denen, für die er nie hinzugefügt wurde."
L["OPTIONS_ERASE_RESTORE"] = "Standard wiederherstellen"
L["OPTIONS_ERASE_RESTORE_DESC"] =
	"Setzt die Löschliste dieses Charakters auf die Gegenstände zurück, mit denen Magic Eraser sie anlegt."
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Die Löschliste dieses Charakters leeren und nur die Gegenstände zurückholen, mit denen Magic Eraser startet? Alles, was du selbst hinzugefügt hast, wird entfernt."
