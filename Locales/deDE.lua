local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "deDE")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] = "Version %s. Einstellungen (einschließlich der Option, diese Nachricht zu deaktivieren) findest du unter Optionen > AddOns > Magic Eraser. Gefällt dir das Add-on? Erzähle einem Freund davon! (="
L["MESSAGE_RESET"] = "Alle Einstellungen wurden auf die Standardwerte zurückgesetzt."

-- Eraser
L["COMBAT_LOCKOUT"] = "Gegenstände können im Kampf nicht gelöscht werden."
L["CURSOR_TOO_FAST"] = "Langsamer! Du klickst schneller als das Spiel Gegenstände löschen kann."
L["ERASED_ITEM"] = "%s%s%s gelöscht."
L["ERASED_VALUE_SUFFIX"] = ", Wert %s"
L["ERASED_QUEST_SUFFIX"] = ", dieser Gegenstand gehörte zu einer abgeschlossenen Quest"
L["BAGS_CLEAN"] = "Glückwunsch, deine Taschen sind voller nützlicher Dinge! Du musst manuell etwas löschen, um Platz zu schaffen."
L["QUEST_ITEM_READY"] = "%s kann jetzt sicher gelöscht werden!"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s verkauft, Wert %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "Auto-Verkauf wird ausgeführt, sobald der Kampf endet."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Gegenstand mit geringstem Wert"
L["NO_VALUE"] = "Kein Wert"
L["LEFT_CLICK"] = "Linksklick"
L["RIGHT_CLICK"] = "Rechtsklick"
L["MIDDLE_CLICK"] = "Mittelklick"
L["SHIFT_RIGHT_CLICK"] = "Umschalt + Rechtsklick"
L["ACTION_ERASE"] = "Löschen"
L["ACTION_IGNORE"] = "Ignorieren"
L["ACTION_TOGGLE"] = "Umschalten"
L["ACTION_CLEAR_IGNORE"] = "Ignorierliste leeren"
L["BAGS_CLEAN_SHORT"] = "Glückwunsch, deine Taschen sind voller nützlicher Dinge!"
L["BAGS_CLEAN_HINT"] = "Du musst manuell etwas löschen, um Platz zu schaffen."
L["LOADING_ITEM"] = "Lade ID: %d"
L["TOOLTIP_HINT"] = "Weitere Einstellungen unter Optionen > AddOns > Magic Eraser."

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-Verkauf"
L["AUTO_VEND_DESCRIPTION"] = "Verkauft automatisch Gegenstände, die von Magic Eraser als Ramsch markiert sind."
L["IGNORE_LIST"] = "Ignorierliste"
L["ON"] = "Aktiviert"
L["OFF"] = "Deaktiviert"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Magic Eraser identifiziert den wertlosesten Ramsch in deinem Inventar und löscht ihn mit einem einzigen Klick auf die Minikarten-Schaltfläche. Abgeschlossene Questgegenstände, niedrigstufige Verbrauchsgüter, weiße Gegenstände in Händlerqualität und grauer Müll — weg. Wenn du einen Händler besuchst, verkauft Auto-Verkauf den Rest automatisch für dich."
L["OPTIONS_WELCOME"] = "Willkommensnachricht aktivieren"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "Verkauft automatisch Gegenstände, die von Magic Eraser als Ramsch markiert sind, wenn du ein Händlerfenster öffnest."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Auto-Verkauf aktivieren"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Auto-Verkauf-Nachrichten aktivieren"
L["OPTIONS_COMMANDS_HEADER"] = "/Befehle"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "Öffnet das Einstellungsmenü von Magic Eraser."
L["OPTIONS_RESET"] = "Zurücksetzen"
L["OPTIONS_RESET_DESCRIPTION"] = "Setzt alle Optionen auf ihre Standardwerte zurück."
L["OPTIONS_RESET_IGNORE"] = "Ignorierliste zurücksetzen"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Alle Gegenstände von der Ignorierliste dieses Charakters entfernen?"
L["OPTIONS_RESET_ALL"] = "Alle Magic Eraser Einstellungen zurücksetzen"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Alle Magic Eraser Einstellungen auf Standard zurücksetzen? Die Ignorierliste wird geleert und Auto-Verkauf wird deaktiviert."
L["OPTIONS_FEEDBACK"] = "Feedback und Unterstützung"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
