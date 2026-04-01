local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "deDE")
if not L then return end

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["COMBAT_LOCKOUT"] = "Gegenstände können im Kampf nicht gelöscht werden."
L["ERASED_ITEM"] = "%s%s%s gelöscht."
L["ERASED_QUEST_SUFFIX"] = ", dieser Gegenstand gehörte zu einer abgeschlossenen Quest"
L["ERASED_VALUE_SUFFIX"] = ", Wert %s"
L["SOLD_ITEM"] = "%s%s verkauft, Wert %s."
L["CURSOR_TOO_FAST"] = "Langsamer! Du klickst schneller als das Spiel Gegenstände löschen kann."
L["BAGS_CLEAN"] = "Glückwunsch, deine Taschen sind voller nützlicher Dinge! Du musst manuell etwas löschen, um Platz zu schaffen."
L["QUEST_ITEM_READY"] = "%s kann jetzt sicher gelöscht werden!"

--------------------------------------------------------------------------------
-- Tooltip
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
L["TOOLTIP_HINT"] = "Weitere Einstellungen unter Optionen > AddOns > Magic Eraser"

--------------------------------------------------------------------------------
-- Auto-Vend
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Auto-Verkauf"
L["AUTO_VEND_DESC"] = "Verkauft automatisch Gegenstände, die von Magic Eraser als Ramsch markiert sind."
L["ENABLED"] = "Aktiviert"
L["DISABLED"] = "Deaktiviert"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

L["IGNORE_LIST"] = "Ignorierliste"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "Löscht den Gegenstand mit dem geringsten Wert in deinen Taschen per Klick auf den Minikartenknopf."
L["OPTIONS_AUTO_VEND_DESC"] = "Verkauft automatisch Gegenstände, die von Magic Eraser als Ramsch markiert sind, wenn du ein Händlerfenster öffnest."
L["OPTIONS_RESET"] = "Zurücksetzen"
L["OPTIONS_RESET_IGNORE"] = "Ignorierliste zurücksetzen"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Alle Gegenstände von der Ignorierliste dieses Charakters entfernen?"
L["OPTIONS_RESET_ALL"] = "Alle Magic Eraser Einstellungen zurücksetzen"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Alle Magic Eraser Einstellungen auf Standard zurücksetzen? Die Ignorierliste wird geleert und Auto-Verkauf wird deaktiviert."
L["OPTIONS_FEEDBACK"] = "Feedback und Unterstützung"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
