local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "frFR")
if not L then return end

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

L["CHAT_LOADED"] = "Version @project-version@. Les paramètres se trouvent dans Options > Extensions > Magic Eraser, y compris pour désactiver ce message. Vous appréciez Magic Eraser ? Parlez-en à un ami ! (="
L["COMBAT_LOCKOUT"] = "Impossible de supprimer des objets en combat."
L["ERASED_ITEM"] = "%s%s%s supprimé."
L["ERASED_QUEST_SUFFIX"] = ", cet objet était associé à une quête terminée"
L["ERASED_VALUE_SUFFIX"] = ", valeur %s"
L["SOLD_ITEM"] = "%s%s vendu, valeur %s."
L["CURSOR_TOO_FAST"] = "Doucement ! Vous cliquez plus vite que le jeu ne peut supprimer les objets."
L["BAGS_CLEAN"] = "Félicitations, vos sacs sont remplis de bonnes choses ! Vous devrez supprimer quelque chose manuellement pour libérer de l'espace."
L["QUEST_ITEM_READY"] = "%s peut maintenant être supprimé en toute sécurité !"

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Objet de plus faible valeur"
L["NO_VALUE"] = "Aucune valeur"
L["LEFT_CLICK"] = "Clic gauche"
L["RIGHT_CLICK"] = "Clic droit"
L["MIDDLE_CLICK"] = "Clic central"
L["SHIFT_RIGHT_CLICK"] = "Maj + Clic droit"
L["ACTION_ERASE"] = "Supprimer"
L["ACTION_IGNORE"] = "Ignorer"
L["ACTION_TOGGLE"] = "Basculer"
L["ACTION_CLEAR_IGNORE"] = "Vider la liste d'ignorés"
L["BAGS_CLEAN_SHORT"] = "Félicitations, vos sacs sont remplis de bonnes choses !"
L["BAGS_CLEAN_HINT"] = "Vous devrez supprimer quelque chose manuellement pour libérer de l'espace."
L["LOADING_ITEM"] = "Chargement ID : %d"
L["TOOLTIP_HINT"] = "Paramètres supplémentaires dans Options > Extensions > Magic Eraser."

--------------------------------------------------------------------------------
-- Auto-Vend
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Vente auto"
L["AUTO_VEND_DESC"] = "Vend automatiquement les objets signalés comme rebut par Magic Eraser."
L["ENABLED"] = "Activé"
L["DISABLED"] = "Désactivé"

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

L["IGNORE_LIST"] = "Liste d'ignorés"

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

L["OPTIONS_DESC"] = "Éliminez l'encombrement de l'inventaire avec Magic Eraser. Supprime automatiquement les objets de faible valeur, la camelote grise et les anciens objets de quête. Propose la vente automatique, une liste d'ignorés facile à configurer et une analyse intelligente pour garder vos sacs bien rangés."
L["OPTIONS_WELCOME"] = "Activer le message de bienvenue"
L["OPTIONS_AUTO_VEND_DESC"] = "Vend automatiquement les objets signalés comme rebut par Magic Eraser à l'ouverture d'une fenêtre de marchand."
L["OPTIONS_RESET"] = "Réinitialiser"
L["OPTIONS_RESET_IGNORE"] = "Réinitialiser la liste d'ignorés"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Retirer tous les objets de la liste d'ignorés de ce personnage ?"
L["OPTIONS_RESET_ALL"] = "Réinitialiser tous les paramètres de Magic Eraser"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Réinitialiser tous les paramètres de Magic Eraser ? Cela vide la liste d'ignorés et désactive la vente auto."
L["OPTIONS_FEEDBACK"] = "Commentaires et assistance"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"