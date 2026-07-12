local L = LibStub("AceLocale-3.0"):NewLocale("MagicEraser", "frFR")
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
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > Extensions > Magic Eraser. Vous appréciez l'extension ? Parlez-en à un ami ! (="

-- Eraser
L["COMBAT_LOCKOUT"] = "Impossible de supprimer des objets en combat."
L["CONFIRM_ERASE"] = "Supprimer %s%s ?"
L["BAGS_FULL"] = "Vos sacs sont pleins !"
L["BAGS_FULL_NUDGE"] = "Vos sacs sont presque pleins. Il vous reste %d emplacements."
L["BAGS_FULL_NUDGE_ONE"] = "Vos sacs sont presque pleins. Il vous reste 1 emplacement."
L["CURSOR_TOO_FAST"] = "Doucement ! Vous cliquez plus vite que le jeu ne peut supprimer les objets."
L["ERASED_ITEM"] = "%s%s%s supprimé."
L["ERASED_VALUE_SUFFIX"] = ", valeur %s"
L["ERASED_QUEST_SUFFIX"] = ", cet objet était associé à une quête terminée"
L["QUEST_ITEM_READY"] = "%s peut maintenant être supprimé en toute sécurité !"

-- Item Tooltip
L["TOOLTIP_WILL_ERASE"] = "Magic Eraser va supprimer ceci."
L["TOOLTIP_IGNORED"] = "Protégé par votre liste d'ignorés."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendu, valeur %s."
L["SOLD_SUMMARY"] = "%s objets vendus, valeur %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "La vente automatique s'effectuera à la fin du combat."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Objet de plus faible valeur"
L["CLUTTER_REPORT"] = "Rapport de rebut"
L["CLUTTER_SLOTS"] = "%s emplacements"
L["CLUTTER_ITEMS"] = "(%s objets)"
L["CLUTTER_VALUE"] = "Valeur %s"
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
L["MINIMAP_OPTIONS"] = "Options de Magic Eraser"
L["MINIMAP_OPTIONS_KEYBIND"] = "Maj + Clic central"

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

L["OPTIONS_DESCRIPTION"] =
	"Nettoyez vos sacs en un instant. Les objets de quête terminés, les consommables de bas niveau, les objets blancs de qualité vendeur et la camelote grise sont supprimés à chaque clic sur le bouton de la minicarte. Lorsque vous visitez un marchand, tout ce qui peut l'être est vendu automatiquement."
L["OPTIONS_WELCOME"] = "Activer le message de bienvenue"
L["OPTIONS_MINIMAP"] = "Activer le bouton de la minicarte"

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_COMMAND_ERASER"] = "/eraser"
L["OPTIONS_COMMAND_ERASER_DESCRIPTION"] = "Ouvre l'interface des options de Magic Eraser."

-- Item Tooltips
L["OPTIONS_TOOLTIP_HEADER"] = "Infobulles d'objets"
L["OPTIONS_TOOLTIP_WARNING"] = "Activer les infobulles pour les objets dans les sacs"

-- Auto-Vend
L["OPTIONS_AUTO_VEND_DESCRIPTION"] =
	"Vend automatiquement les objets signalés comme rebut par Magic Eraser à l'ouverture d'une fenêtre de marchand."
L["OPTIONS_ENABLE_AUTO_VEND"] = "Activer la Vente auto"
L["OPTIONS_AUTO_VEND_MESSAGES"] = "Activer les messages de Vente auto"
L["OPTIONS_AUTO_VEND_VERBOSE"] = "Par objet"
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Résumé"
L["OPTIONS_BAGS_FULL_HEADER"] = "Alertes d'espace de sac"
L["OPTIONS_BAGS_FULL_NUDGE"] = "Activer les alertes d'espace de sac"
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Seuil d'emplacements libres"

-- Eraser Confirmation
L["OPTIONS_SAFETY_HEADER"] = "Confirmations de suppression"
L["OPTIONS_SAFETY_DESCRIPTION"] = "Demander avant de supprimer les types d'objets cochés ci-dessous."
L["OPTIONS_ENABLE_SAFETY"] = "Activer les confirmations de suppression"
L["OPTIONS_SAFETY_QUEST"] = "Pour les objets de quête terminés"
L["OPTIONS_SAFETY_CONSUMABLE"] = "Pour les consommables de bas niveau"
L["OPTIONS_SAFETY_WHITE"] = "Pour les objets blancs de qualité vendeur"
L["OPTIONS_SAFETY_GRAY"] = "Pour les objets gris de qualité vendeur"

-- Feedback & Support
L["OPTIONS_FEEDBACK"] = "Commentaires et assistance"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
