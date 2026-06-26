local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "frFR")
if not L then return end

--------------------------------------------------------------------------------
-- Add-on Identity
--------------------------------------------------------------------------------

L["ADDON_TITLE"] = "Magic Eraser"

--------------------------------------------------------------------------------
-- Chat Messages
--------------------------------------------------------------------------------

-- System
L["CHAT_LOADED"] = "Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > Extensions > Magic Eraser. Vous appréciez l'extension ? Parlez-en à un ami ! (="
L["MESSAGE_RESET"] = "Tous les paramètres ont été réinitialisés à leurs valeurs par défaut."

-- Eraser
L["COMBAT_LOCKOUT"] = "Impossible de supprimer des objets en combat."
L["CURSOR_TOO_FAST"] = "Doucement ! Vous cliquez plus vite que le jeu ne peut supprimer les objets."
L["ERASED_ITEM"] = "%s%s%s supprimé."
L["ERASED_VALUE_SUFFIX"] = ", valeur %s"
L["ERASED_QUEST_SUFFIX"] = ", cet objet était associé à une quête terminée"
L["BAGS_CLEAN"] = "Félicitations, vos sacs sont remplis de bonnes choses ! Vous devrez supprimer quelque chose manuellement pour libérer de l'espace."
L["QUEST_ITEM_READY"] = "%s peut maintenant être supprimé en toute sécurité !"

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendu, valeur %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "La vente automatique s'effectuera à la fin du combat."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
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
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Vente auto"
L["AUTO_VEND_DESCRIPTION"] = "Vend automatiquement les objets signalés comme rebut par Magic Eraser."
L["IGNORE_LIST"] = "Liste d'ignorés"
L["ON"] = "Activé"
L["OFF"] = "Désactivé"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] = "Magic Eraser identifie les déchets de la plus faible valeur dans votre inventaire et les supprime d'un simple clic sur le bouton de la minicarte. Objets de quête terminés, consommables de bas niveau, objets blancs de qualité vendeur et camelote grise : tout disparaît. Lorsque vous visitez un marchand, la Vente auto vend automatiquement le reste pour vous."
L["OPTIONS_WELCOME"] = "Activer le message de bienvenue"
L["OPTIONS_AUTO_VEND_DESCRIPTION"] = "Vend automatiquement les objets signalés comme rebut par Magic Eraser à l'ouverture d'une fenêtre de marchand."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Activer la Vente auto"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Activer les messages de Vente auto"
L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_CMD_ERASER"] = "/eraser"
L["OPTIONS_CMD_ERASER_DESCRIPTION"] = "Ouvre l'interface des options de Magic Eraser."
L["OPTIONS_RESET"] = "Réinitialiser"
L["OPTIONS_RESET_DESCRIPTION"] = "Restaure toutes les options à leur valeur par défaut."
L["OPTIONS_RESET_IGNORE"] = "Réinitialiser la liste d'ignorés"
L["OPTIONS_RESET_IGNORE_CONFIRM"] = "Retirer tous les objets de la liste d'ignorés de ce personnage ?"
L["OPTIONS_RESET_ALL"] = "Réinitialiser tous les paramètres de Magic Eraser"
L["OPTIONS_RESET_ALL_CONFIRM"] = "Réinitialiser tous les paramètres de Magic Eraser ? Cela vide la liste d'ignorés et désactive la vente auto."
L["OPTIONS_FEEDBACK"] = "Commentaires et assistance"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
