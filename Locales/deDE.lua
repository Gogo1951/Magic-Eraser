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
	"Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) findest du unter Optionen > AddOns > Magic Eraser. Gefällt dir dieses Add-on? Erzähl einem Freund davon, markiere es auf CurseForge als Favorit oder gib ihm auf GitHub einen Stern. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Aus Sicherheitsgründen kann das Optionsfenster im Kampf nicht geöffnet werden."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] = "Aus Sicherheitsgründen kann die Tastaturbelegung im Kampf nicht geöffnet werden."
L["KEY_BINDINGS_LOCATION"] = "Öffne das Spielmenü, dann %s, dann %s, und suche den Abschnitt Magic Eraser."

-- Eraser
L["COMBAT_LOCKOUT"] = "Aus Sicherheitsgründen können im Kampf keine Gegenstände gelöscht werden."
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
L["TAB_ERASING"] = "Löschen"
L["TAB_MERCHANT_BANK"] = "Händler und Bank"
L["TAB_ALERTS"] = "Hinweise und Einfärbung"
L["TAB_IGNORE_LIST"] = "Schutzliste"
L["TAB_ERASE_LIST"] = "Löschliste"
L["ENABLED"] = "Aktiviert"
L["DISABLED"] = "Deaktiviert"
L["ACTION_ERASE"] = "Löschen"
L["ACTION_IGNORE"] = "Schützen"

-- Example lines under features that print to chat. %s is that whole line.
L["OPTIONS_EXAMPLE"] = "Beispiel: %s"
L["OPTIONS_EXAMPLE_ITEM"] = "Beispielgegenstand"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Verkaufe und lösche Ramsch, um Taschenplatz freizumachen. Verkaufe graue Gegenstände und Händlermüll automatisch bei jedem Händler, und vernichte Gegenstände abgeschlossener Quests, ausgediente Speisen, Getränke und Munition sowie weiße Ausrüstung mit einem Klick auf die Minikarten-Schaltfläche. Eine Schutzliste behält, was du brauchst."
L["OPTIONS_ENABLE_WELCOME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Zeigt bei jedem Einloggen eine einzeilige Begrüßung mit der Versionsnummer im Chat."
L["OPTIONS_ENABLE_MINIMAP"] = "Minikarten-Schaltfläche aktivieren"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] =
	"Zeigt die Schaltfläche von Magic Eraser an deiner Minikarte. Ihr Symbol ist dein Gegenstand mit geringstem Wert, und wenn du mit der Maus darüberfährst, siehst du den Ramsch-Bericht."

-- Features
L["OPTIONS_FEATURES_HEADER"] = "Funktionen"

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Tastaturbelegung"
L["OPTIONS_KEY_SET"] = "Taste festlegen"
L["OPTIONS_KEY_SET_DESCRIPTION"] =
	"Öffnet die Tastaturbelegung des Spiels, in der Magic Eraser einen eigenen Abschnitt hat."
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Löscht deinen Gegenstand mit geringstem Wert, genau wie ein Linksklick auf die Minikarten-Schaltfläche. Vor einem Tastendruck gibt es keine Vorschau, also leg die Taste irgendwohin, wo du sie nicht versehentlich drückst."
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"Schützt den Gegenstand unter deiner Maus auf diesem Charakter, wo immer du ihn siehst: Taschen, Bank, Händler oder Beutefenster. Stand er auf der Löschliste dieses Charakters, wird er dort entfernt."
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"Fügt den Gegenstand unter deiner Maus zur Löschliste dieses Charakters hinzu, egal was er wert ist. Deine Schutzliste hat trotzdem Vorrang."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Öffnet das Optionsfenster dieses Add-ons."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

-- Help Magic Eraser Level Up
L["OPTIONS_LEVEL_UP_TITLE"] = "Hilf Magic Eraser beim Leveln"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Dieses Add-on wurde von Spielern gebaut, die dieses Spiel lieben und es für alle so unterhaltsam wie möglich machen wollen. Wir werden nie um Spenden bitten. Die wahre Belohnung ist das Wissen, dass unsere Arbeit das Spiel für dich ein bisschen besser macht. Wenn das so ist, würden wir uns freuen, davon zu hören!"
L["OPTIONS_LEVEL_UP_WAYS"] = "Hier sind ein paar Möglichkeiten, wie du uns helfen kannst, mehr Spieler zu erreichen."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Feedback geben: Einen Fehler gefunden oder eine Idee? Sag es uns auf Discord. Dein Feedback hilft uns, das Add-on zu verbessern, und Pull-Requests sind jederzeit willkommen."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Einem Freund erzählen: Kennst du jemanden, dem dieses Add-on gefallen könnte? Erzähl ihm davon. Mundpropaganda hilft mehr Spielern, großartige Add-ons zu entdecken."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	'• Auf CurseForge favorisieren: Öffne unten den CurseForge-Link, melde dich an und klicke auf den Stern unter der Schaltfläche "Download". Favoriten helfen mehr Spielern, das Add-on zu entdecken.'
L["OPTIONS_LEVEL_UP_GITHUB"] =
	'• Auf GitHub einen Stern geben: Öffne unten den GitHub-Link, melde dich an und klicke oben rechts auf "Star". Sterne helfen dem Projekt, sich für mehr kostenlose Entwicklertools zu qualifizieren.'
L["OPTIONS_LEVEL_UP_THANKS"] = "Danke, dass du dich für Magic Eraser entschieden hast!"

-- Feedback & Support Links
L["OPTIONS_FEEDBACK"] = "Feedback & Unterstützung"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Links zu Feedback & Unterstützung"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Um einen Link zu kopieren, klicke in sein Feld und drücke dann Strg+A und Strg+C."
L["OPTIONS_VERSION"] = "Version %s"

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
	"Wähle, welche Arten von Gegenständen gelöscht werden. Das sind grobe Regeln. Zur Feinabstimmung füge einen Gegenstand deiner Schutzliste hinzu, um ihn immer zu behalten, oder deiner Löschliste, um ihn immer zu löschen."
L["OPTIONS_KIND_QUEST"] = "Gegenstände abgeschlossener Quests"
L["OPTIONS_KIND_QUEST_DESCRIPTION"] =
	"Gegenstände, die übrig bleiben, sobald du die letzte Quest abgegeben hast, für die sie gebraucht werden."
L["OPTIONS_KIND_STARTER"] = "Unbrauchbare Queststarter"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESCRIPTION"] =
	"Gegenstände, die eine Quest starten, die dein Volk oder deine Klasse niemals annehmen kann."
L["OPTIONS_KIND_FOOD"] = "Ausgediente Speisen und Getränke"
L["OPTIONS_KIND_FOOD_DESCRIPTION"] =
	"Speisen und Getränke, sobald du zehn Stufen über der Stufe bist, ab der du sie benutzen konntest. Anfängerbrot und -wasser gehen ab Stufe 5."
L["OPTIONS_KIND_AMMO"] = "Ausgediente Pfeile und Kugeln"
L["OPTIONS_KIND_AMMO_DESCRIPTION"] =
	"Pfeile und Kugeln, sobald du eine bessere Sorte benutzen kannst, die Händler verkaufen. Die beste Händlermunition für deine Stufe wird nie gelöscht."
L["OPTIONS_KIND_WHITE"] = "Weiße Waffen und Rüstungen"
L["OPTIONS_KIND_WHITE_DESCRIPTION"] =
	"Weiße Waffen und Rüstungen, die ein Händler ankauft. Berufswerkzeuge, Hemden, festliche Kleidung und weiße Gegenstände, die eine Quest noch braucht, werden behalten."
L["OPTIONS_KIND_GRAY"] = "Grauer Müll"
L["OPTIONS_KIND_GRAY_DESCRIPTION"] = "Jeder graue Gegenstand, den ein Händler ankauft."
L["OPTIONS_KIND_UNCHECKED_DESCRIPTION"] =
	"Nicht angehakt ist es kein Ramsch: Es wird nie gelöscht, verkauft oder aus der Bank geholt."
L["OPTIONS_KINDS_NONE_CHECKED"] =
	"Keine Art ist angehakt, daher werden nur Gegenstände deiner Löschliste gelöscht oder verkauft."

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Maximaler Wert zum Löschen"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] =
	"Löscht niemals einen Gegenstand oder Stapel, der mehr wert ist als das unten festgelegte Limit."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Maximalen Wert zum Löschen aktivieren"
L["OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION"] =
	"Schaltet das Wertlimit ein oder aus. Der Auto-Verkauf verkauft trotzdem alles, was dadurch zurückgehalten wird, und für deine Löschliste gilt das Limit nicht."
L["OPTIONS_VALUE_CAP_LIMIT_DESCRIPTION"] = "Stapel, deren gesamter Verkaufswert darüber liegt, werden nie gelöscht."
L["OPTIONS_VALUE_CAP_GOLD"] = "%d Gold"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Hilfe beim manuellen Löschen"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'Standardmäßig musst du "%s" eintippen, wenn du einen Gegenstand der Qualität %s oder besser löschst. Das hier macht daraus ein einfaches Ja oder Nein.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Hilfe beim manuellen Löschen aktivieren"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION"] =
	"Schaltet die Hilfe beim manuellen Löschen ein oder aus. Das Spiel fragt trotzdem Ja oder Nein, nur das Eintippen entfällt."
L["OPTIONS_MANUAL_DELETE_SCOPE_DESCRIPTION"] =
	"Gegenstände ohne Verkaufswert vereinfacht nur Gegenstände, die kein Händler ankauft. Alle Gegenstände vereinfacht jede Eingabeaufforderung."
L["OPTIONS_MANUAL_DELETE_ALL"] = "Alle Gegenstände"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "Gegenstände ohne Verkaufswert"

-- Erase Confirmation
L["OPTIONS_ERASE_CONFIRM_HEADER"] = "Löschbestätigung"
L["OPTIONS_ERASE_CONFIRM_DESCRIPTION"] = "Fragt Ja oder Nein, bevor etwas gelöscht wird."
L["OPTIONS_ENABLE_ERASE_CONFIRM"] = "Löschbestätigung aktivieren"
L["OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION"] =
	"Zeigt vor jedem Löschen ein Ja oder Nein, ob über die Minikarten-Schaltfläche oder die Tastenbelegung, auch für Gegenstände auf deiner Löschliste."

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"Verkauft deinen Ramsch, sobald du ein Händlerfenster öffnest, und holt Ramsch aus deiner Bank zurück in deine Taschen, damit er gleich mit verkauft wird. Nichts auf deiner Schutzliste wird angerührt."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Auto-Verkauf aktivieren"
L["OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION"] =
	"Schaltet das Verkaufen bei Händlern ein oder aus. Gegenstände auf deiner Schutzliste werden nie verkauft."
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Zusammenfassung im Chat"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Jeder Verkauf im Chat"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "Kein Chatbericht"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESCRIPTION"] =
	"Was der Auto-Verkauf im Chat ausgibt. Zusammenfassung im Chat gibt eine Summe pro Besuch aus. Jeder Verkauf im Chat gibt jeden Verkauf und dann die Summe aus. Kein Chatbericht gibt nichts aus."

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Bankentnahme"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Holt Ramsch aus deiner Bank, wenn du sie öffnest, damit er mit dem Rest verkauft oder gelöscht werden kann. Es wird nur aus deiner eigenen Bank genommen, nie aus einer Gildenbank oder einer accountweiten Bank."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Bankentnahme aktivieren"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESCRIPTION"] =
	"Schaltet die Bankentnahme ein oder aus. Sie holt nie mehr, als deine freien Taschenplätze fassen können."
L["OPTIONS_BANK_CUSHION_NOTE"] = "Lässt %d Taschenplätze frei, weil Taschenplatz-Warnungen aktiviert sind."
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] = "Lässt 1 Taschenplatz frei, weil Taschenplatz-Warnungen aktiviert sind."

--------------------------------------------------------------------------------
-- Options: Alerts & Tints Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "Was dir Magic Eraser von sich aus mitteilt, im Chat und in deinen Taschen."

-- Junk Item Tint
L["OPTIONS_TINT_HEADER"] = "Ramsch-Einfärbung"
L["OPTIONS_TINT_DESCRIPTION"] =
	"Färbt den Ramsch ein, den Magic Eraser löschen würde, damit du ihn in deinen Taschen und deiner Bank auf einen Blick erkennst."
L["OPTIONS_ENABLE_TINT"] = "Ramsch-Einfärbung aktivieren"
L["OPTIONS_ENABLE_TINT_DESCRIPTION"] =
	"Schaltet die Einfärbung ein oder aus. Funktioniert mit den Standardtaschen, Baganator, Bagnon, AdiBags, ArkInventory, BetterBags und ElvUI."
L["OPTIONS_TINT_COLOR"] = "Farbe der Einfärbung"
L["OPTIONS_TINT_COLOR_DESCRIPTION"] =
	"Farbe und Deckkraft der Einfärbung. Mit geringerer Deckkraft bleibt das Symbol des Gegenstands besser erkennbar."
L["TINT_BAGANATOR_WIDGET_LABEL"] = "Ramsch-Einfärbung (Magic Eraser)"

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "Hinweise zu Questgegenständen"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"Sagt dir sofort Bescheid, wenn ein Gegenstand abgeschlossener Quests oder ein unbrauchbarer Queststarter in deinen Taschen sicher gelöscht werden kann."
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "Hinweise zu Questgegenständen aktivieren"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION"] =
	"Schaltet die Hinweise im Chat ein oder aus. Gegenstände abgeschlossener Quests und unbrauchbare Queststarter werden so oder so gelöscht."

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Taschenplatz-Warnungen"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Warnt dich, wenn sich deine letzten freien Taschenplätze füllen. Bleibt still, solange ein Händler-, Briefkasten- oder Bankfenster geöffnet ist."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Taschenplatz-Warnungen aktivieren"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION"] = "Schaltet den Countdown im Chat ein oder aus."
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Schwellenwert für freie Plätze"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESCRIPTION"] =
	"Ab wie vielen freien Plätzen der Countdown beginnt. Solange die Warnungen aktiv sind, lässt die Bankentnahme auch so viele Plätze frei."

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Alle Charaktere"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "Aus Taschen hinzufügen"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESCRIPTION"] =
	"Wähle etwas aus, das du bei dir trägst. Die Taschen schließen sich, wenn das Optionsfenster geöffnet wird, daher ersetzt das hier das Hineinziehen eines Gegenstands."
L["OPTIONS_LIST_ADD_ID"] = "Über Gegenstands-ID hinzufügen"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Gib eine Gegenstands-ID ein und drücke die Eingabetaste. Du kannst auch mit Umschalt auf einen Gegenstandslink im Chat klicken, um ihn hier einzufügen."
L["OPTIONS_LIST_ADD_ID_INVALID"] =
	"Gib eine Gegenstands-ID ein oder klicke mit Umschalt auf einen Gegenstandslink im Chat."
L["OPTIONS_LIST_REMOVE"] = "Entfernen"
L["OPTIONS_LIST_EMPTY"] = "Diese Liste ist leer."
L["OPTIONS_LIST_CLEAR"] = "Liste leeren"
L["OPTIONS_LIST_CLEAR_DESCRIPTION"] =
	"Entfernt alle Gegenstände aus dieser Liste. Ein Charakter mit leerer Liste verschwindet aus der Liste links, außer es ist der, den du gerade spielst."
L["OPTIONS_LIST_CLEAR_CONFIRM"] =
	"Alle Gegenstände aus dieser Liste entfernen? Das lässt sich nicht rückgängig machen."

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
L["OPTIONS_LIST_PROTECTED_TAG"] = "Geschützt"
L["OPTIONS_ERASE_RESTORE"] = "Standard wiederherstellen"
L["OPTIONS_ERASE_RESTORE_DESCRIPTION"] =
	"Setzt die Löschliste dieses Charakters auf die Gegenstände zurück, mit denen Magic Eraser sie anlegt."
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Die Löschliste dieses Charakters leeren und nur die Gegenstände zurückholen, mit denen Magic Eraser sie anlegt? Alles, was du selbst hinzugefügt hast, wird entfernt."
L["OPTIONS_ERASE_RESTORE_GLOBAL_DESCRIPTION"] =
	"Leert die Löschliste für Alle Charaktere, die Magic Eraser leer anlegt. Die eigene Liste jedes Charakters bleibt unverändert."
L["OPTIONS_ERASE_RESTORE_GLOBAL_CONFIRM"] =
	"Die Löschliste für Alle Charaktere leeren? Alles darauf wird entfernt, und die eigene Liste jedes Charakters bleibt unverändert."
