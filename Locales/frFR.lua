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
	"Version %s. Les paramètres (y compris l'option pour désactiver ce message) se trouvent dans Options > Extensions > Magic Eraser. Vous appréciez cette extension ? Parlez-en à un ami, ajoutez-la à vos favoris sur CurseForge ou donnez-lui une étoile sur GitHub. (="
L["CHAT_OPTIONS_IN_COMBAT"] = "Par mesure de sécurité, le panneau d'options ne peut pas être ouvert en combat."
L["CHAT_KEY_BINDINGS_IN_COMBAT"] =
	"Par mesure de sécurité, la liste des raccourcis clavier ne peut pas être ouverte en combat."
L["KEY_BINDINGS_LOCATION"] = "Ouvrez le menu du jeu, puis %s, puis %s, et trouvez la section Magic Eraser."

-- Eraser
L["COMBAT_LOCKOUT"] = "Par mesure de sécurité, les objets ne peuvent pas être supprimés en combat."
L["CONFIRM_ERASE"] = "Supprimer %s%s ?"
L["BAGS_FULL"] = "Vos sacs sont pleins !"
L["BAGS_FULL_NUDGE"] = "Vos sacs sont presque pleins. Il vous reste %d emplacements."
L["BAGS_FULL_NUDGE_ONE"] = "Vos sacs sont presque pleins. Il vous reste 1 emplacement."
L["CURSOR_TOO_FAST"] = "Doucement ! Vous cliquez plus vite que le jeu ne peut supprimer les objets."
L["ERASE_CANDIDATE_CHANGED"] =
	"Cet objet a changé avant de pouvoir être supprimé, rien n'a donc été supprimé. Vérifiez le bouton de la minicarte et réessayez."
L["ERASED_ITEM"] = "%s%s supprimé."
L["QUEST_ITEM_READY"] =
	"%s%s peut maintenant être supprimé en toute sécurité. C'est un reste d'une quête que vous avez terminée."
L["QUEST_STARTER_UNAVAILABLE"] =
	"%s%s peut maintenant être supprimé en toute sécurité. Il démarre une quête que votre personnage ne peut pas accepter."

-- Auto-Vend
L["SOLD_ITEM"] = "%s%s vendu, valeur %s."
L["SOLD_SUMMARY"] = "%s objets (%s emplacements de sac) vendus, valeur %s."
L["SOLD_SUMMARY_ONE_SLOT"] = "%s objets (1 emplacement de sac) vendus, valeur %s."
L["SOLD_SUMMARY_ONE_ITEM"] = "1 objet (1 emplacement de sac) vendu, valeur %s."
L["AUTO_VEND_COMBAT_DEFERRED"] = "La Vente auto s'effectuera à la fin du combat."

-- Bank Retrieval
L["BANK_RETRIEVED"] = "%s objets (%s emplacements de sac) retirés de votre banque, valeur %s."
L["BANK_RETRIEVED_ONE_SLOT"] = "%s objets (1 emplacement de sac) retirés de votre banque, valeur %s."
L["BANK_RETRIEVED_ONE_ITEM"] = "1 objet (1 emplacement de sac) retiré de votre banque, valeur %s."

-- Key Bindings
L["IGNORE_LIST_ADDED"] = "%s ajouté à votre Liste de protection."
L["IGNORE_LIST_MOVED"] = "%s déplacé de votre Liste de suppression vers votre Liste de protection."
L["IGNORE_LIST_ALREADY"] = "%s est déjà sur votre Liste de protection."
L["ERASE_LIST_ADDED"] = "%s ajouté à votre Liste de suppression."
L["ERASE_LIST_ALREADY"] = "%s est déjà sur votre Liste de suppression."
L["ERASE_LIST_PROTECTED"] =
	"%s est sur votre Liste de protection, qui l'emporte toujours. Retirez-le d'abord de cette liste."
L["NO_HOVERED_ITEM"] = "Survolez un objet, puis appuyez de nouveau sur la touche."

--------------------------------------------------------------------------------
-- Minimap Button Tooltip
--------------------------------------------------------------------------------

L["LOWEST_VALUE_ITEM"] = "Objet de plus faible valeur"
L["CLUTTER_REPORT"] = "Rapport de rebut"
L["CLUTTER_ITEMS"] = "(%s objets)"
L["CLUTTER_ITEMS_ONE"] = "(1 objet)"
L["CLUTTER_SLOTS"] = "%s emplacements de sac"
L["CLUTTER_SLOTS_ONE"] = "1 emplacement de sac"
L["NO_VALUE"] = "Aucune valeur"
L["LEFT_CLICK"] = "Clic gauche"
L["RIGHT_CLICK"] = "Clic droit"
L["MIDDLE_CLICK"] = "Clic central"
L["SHIFT_RIGHT_CLICK"] = "Maj + Clic droit"
L["SHIFT_MIDDLE_CLICK"] = "Maj + Clic central"
L["ACTION_TOGGLE"] = "Basculer"
L["ACTION_CLEAR_IGNORE"] = "Vider la Liste de protection"
L["BAGS_CLEAN_CONGRATS"] = "Félicitations, vos sacs sont remplis de bonnes choses !"
L["BAGS_CLEAN_HINT"] = "Vous devrez supprimer quelque chose manuellement pour libérer plus d'espace."
L["LOADING_ITEM"] = "Chargement ID : %d"
L["MINIMAP_OPTIONS"] = "Options de Magic Eraser"

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

L["BINDING_ERASE"] = "Supprimer l'objet de plus faible valeur"
L["BINDING_ADD_TO_IGNORE_LIST"] = "Ajouter l'objet survolé à la Liste de protection"
L["BINDING_ADD_TO_ERASE_LIST"] = "Ajouter l'objet survolé à la Liste de suppression"

--------------------------------------------------------------------------------
-- Shared Labels
--------------------------------------------------------------------------------

L["AUTO_VEND"] = "Vente auto"
L["AUTO_VEND_DESCRIPTION"] =
	"Vend votre rebut dès que vous ouvrez la fenêtre d'un marchand, en commençant par le moins cher."
L["TAB_ERASING"] = "Suppression"
L["TAB_MERCHANT_BANK"] = "Marchand et banque"
L["TAB_ALERTS"] = "Alertes et teintes"
L["TAB_IGNORE_LIST"] = "Liste de protection"
L["TAB_ERASE_LIST"] = "Liste de suppression"
L["ENABLED"] = "Activé"
L["DISABLED"] = "Désactivé"
L["ACTION_ERASE"] = "Supprimer"
L["ACTION_IGNORE"] = "Protéger"

-- Example lines under features that print to chat. %s is that whole line.
L["OPTIONS_EXAMPLE"] = "Exemple : %s"
L["OPTIONS_EXAMPLE_ITEM"] = "Objet d'exemple"

--------------------------------------------------------------------------------
-- Options: Main Panel
--------------------------------------------------------------------------------

L["OPTIONS_DESCRIPTION"] =
	"Supprimez le rebut et libérez de la place dans vos sacs en un instant. Éliminez les objets de quêtes terminées, les consommables devenus inutiles, la camelote de vendeur et les objets gris d'un clic sur le bouton de la minicarte. Une liste de rebut sélectionnée à la main protège ce dont vous avez besoin, tandis que la Vente auto écoule le reste chez votre prochain marchand."
L["OPTIONS_ENABLE_WELCOME"] = "Activer le message de bienvenue"
L["OPTIONS_ENABLE_WELCOME_DESCRIPTION"] =
	"Affiche dans la discussion un message de bienvenue d'une ligne, avec la version, à chaque connexion."
L["OPTIONS_ENABLE_MINIMAP"] = "Activer le bouton de la minicarte"
L["OPTIONS_ENABLE_MINIMAP_DESCRIPTION"] =
	"Affiche le bouton Magic Eraser sur votre minicarte. Son icône montre votre Objet de plus faible valeur, et le survoler affiche le Rapport de rebut."

-- Features
L["OPTIONS_FEATURES_HEADER"] = "Fonctionnalités"

-- Key Bindings
L["OPTIONS_KEY_BINDINGS_HEADER"] = "Raccourcis clavier"
L["OPTIONS_KEY_SET"] = "Assigner une touche"
L["OPTIONS_KEY_SET_DESCRIPTION"] = "Ouvre la liste des raccourcis clavier du jeu, où Magic Eraser a sa propre section."
L["OPTIONS_KEY_BINDING_ERASE_DESCRIPTION"] =
	"Supprime votre Objet de plus faible valeur, comme un clic gauche sur le bouton de la minicarte. Il n'y a aucun aperçu avant d'appuyer sur la touche, alors choisissez-en une que vous ne toucherez pas par accident."
L["OPTIONS_KEY_BINDING_IGNORE_DESCRIPTION"] =
	"Protège l'objet sous votre souris sur ce personnage, où que vous le voyiez : sacs, banque, marchand ou fenêtre de butin. S'il était sur la Liste de suppression de ce personnage, il en est retiré."
L["OPTIONS_KEY_BINDING_ERASE_LIST_DESCRIPTION"] =
	"Ajoute l'objet sous votre souris à la Liste de suppression de ce personnage, quelle que soit sa valeur. Votre Liste de protection l'emporte toujours."

-- /Commands
L["OPTIONS_COMMANDS_HEADER"] = "/Commandes"
L["OPTIONS_COMMAND"] = "/eraser"
L["OPTIONS_COMMAND_DESCRIPTION"] = "Ouvre le panneau d'options de cette extension."

--------------------------------------------------------------------------------
-- Options: Feedback & Support Panel
--------------------------------------------------------------------------------

-- Help Magic Eraser Level Up
L["OPTIONS_LEVEL_UP_TITLE"] = "Aidez Magic Eraser à monter de niveau"
L["OPTIONS_LEVEL_UP_INTRO"] =
	"Cette extension a été créée par des joueurs qui aiment ce jeu et veulent le rendre aussi amusant que possible pour tout le monde. Nous ne demanderons jamais de dons. La vraie satisfaction, c'est de savoir que notre travail rend le jeu un peu meilleur pour vous. Si c'est le cas, nous serions ravis de le savoir !"
L["OPTIONS_LEVEL_UP_WAYS"] = "Voici quelques façons de nous aider à toucher plus de joueurs."
L["OPTIONS_LEVEL_UP_FEEDBACK"] =
	"• Donnez votre avis : vous avez trouvé un bug ou vous avez une idée ? Dites-le-nous sur Discord. Vos retours nous aident à améliorer l'extension, et les pull requests sont toujours les bienvenues."
L["OPTIONS_LEVEL_UP_FRIEND"] =
	"• Parlez-en à un ami : vous connaissez quelqu'un qui pourrait aimer cette extension ? Faites-la-lui découvrir. Le bouche-à-oreille aide plus de joueurs à découvrir de super extensions."
L["OPTIONS_LEVEL_UP_CURSEFORGE"] =
	"• Ajoutez-la à vos favoris sur CurseForge : ouvrez le lien CurseForge ci-dessous, connectez-vous et cliquez sur l'étoile sous le bouton \"Download\". Les favoris aident plus de joueurs à découvrir l'extension."
L["OPTIONS_LEVEL_UP_GITHUB"] =
	'• Donnez-lui une étoile sur GitHub : ouvrez le lien GitHub ci-dessous, connectez-vous et cliquez sur "Star" en haut à droite. Les étoiles rendent le projet éligible à davantage d\'outils de développement gratuits.'
L["OPTIONS_LEVEL_UP_THANKS"] = "Merci d'avoir choisi Magic Eraser !"

-- Feedback & Support Links
L["OPTIONS_FEEDBACK"] = "Commentaires et assistance"
L["OPTIONS_FEEDBACK_LINKS_HEADER"] = "Liens de commentaires et d'assistance"
L["OPTIONS_CURSEFORGE"] = "CurseForge"
L["OPTIONS_GITHUB"] = "GitHub"
L["OPTIONS_DISCORD"] = "Discord"
L["OPTIONS_WAGO"] = "Wago"
L["OPTIONS_COPY_LINK"] = "Pour copier un lien, cliquez dans son champ, puis appuyez sur Ctrl+A et Ctrl+C."
L["OPTIONS_VERSION"] = "Version %s"

--------------------------------------------------------------------------------
-- Options: Erasing Panel
--------------------------------------------------------------------------------

L["TAB_ERASING_DESCRIPTION"] = "Chaque clic supprime le rebut le moins cher de vos sacs, une pile à la fois."
L["TAB_ERASING_RESTORE_NOTE"] =
	"Bon à savoir : presque tout objet supprimé par erreur peut encore être récupéré via le service de restauration d'objets de Blizzard."

-- What Counts as Junk
L["OPTIONS_JUNK_HEADER"] = "Ce qui compte comme rebut"
L["OPTIONS_JUNK_DESCRIPTION"] =
	"Choisissez les types d'objets à supprimer. Ce sont des règles générales. Pour les affiner, ajoutez un objet à votre Liste de protection pour toujours le garder, ou à votre Liste de suppression pour toujours le supprimer."
L["OPTIONS_KIND_QUEST"] = "Objets de quête terminée"
L["OPTIONS_KIND_QUEST_DESCRIPTION"] =
	"Objets restants une fois que vous avez rendu la dernière quête qui en a besoin."
L["OPTIONS_KIND_STARTER"] = "Déclencheurs de quête sans issue"
L["OPTIONS_KIND_STARTER_UNAVAILABLE_DESCRIPTION"] =
	"Objets qui démarrent une quête que votre race ou votre classe ne pourra jamais accepter."
L["OPTIONS_KIND_FOOD"] = "Nourriture et boissons dépassées"
L["OPTIONS_KIND_FOOD_DESCRIPTION"] =
	"Nourriture et boissons dix niveaux au-delà du niveau où vous pouviez les utiliser. Le pain et l'eau de départ partent au niveau 5."
L["OPTIONS_KIND_AMMO"] = "Flèches et balles dépassées"
L["OPTIONS_KIND_AMMO_DESCRIPTION"] =
	"Flèches et balles dès que vous pouvez utiliser un meilleur type vendu par les marchands. Les meilleures munitions de marchand pour votre niveau ne sont jamais supprimées."
L["OPTIONS_KIND_WHITE"] = "Armes et armures blanches"
L["OPTIONS_KIND_WHITE_DESCRIPTION"] =
	"Armes et armures blanches qu'un marchand achète. Les outils de métier, les chemises, les tenues de soirée et les objets blancs encore utiles à une quête sont conservés."
L["OPTIONS_KIND_GRAY"] = "Camelote grise"
L["OPTIONS_KIND_GRAY_DESCRIPTION"] = "Tout objet gris qu'un marchand achète."
L["OPTIONS_KIND_UNCHECKED_DESCRIPTION"] =
	"Décoché, ce n'est pas du rebut : jamais supprimé, vendu ni retiré de la banque."
L["OPTIONS_KINDS_NONE_CHECKED"] =
	"Aucun type n'est coché, seule votre Liste de suppression est donc supprimée ou vendue."

-- Maximum Value to Erase
L["OPTIONS_VALUE_CAP_HEADER"] = "Valeur maximale à supprimer"
L["OPTIONS_VALUE_CAP_DESCRIPTION"] =
	"Ne supprime jamais un objet ou une pile valant plus que la limite définie ci-dessous."
L["OPTIONS_ENABLE_VALUE_CAP"] = "Activer la valeur maximale à supprimer"
L["OPTIONS_ENABLE_VALUE_CAP_DESCRIPTION"] =
	"Active ou désactive la limite de valeur. La Vente auto vend quand même tout ce que la limite épargne, et votre Liste de suppression n'y est pas soumise."
L["OPTIONS_VALUE_CAP_LIMIT_DESCRIPTION"] =
	"Les piles valant plus que ce montant, en comptant la valeur de vente de toute la pile, ne sont jamais supprimées."
L["OPTIONS_VALUE_CAP_GOLD"] = "%d po"

-- Manual Delete Assistance
L["OPTIONS_MANUAL_DELETE_HEADER"] = "Aide à la suppression manuelle"
L["OPTIONS_MANUAL_DELETE_PROMPT_DESCRIPTION"] =
	'Par défaut, le jeu vous oblige à taper "%s" pour supprimer un objet de qualité %s ou supérieure. Cette option transforme cette demande en un simple Oui ou Non.'
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL"] = "Activer l'aide à la suppression manuelle"
L["OPTIONS_ENABLE_MANUAL_DELETE_AUTOFILL_DESCRIPTION"] =
	"Active ou désactive l'Aide à la suppression manuelle. Le jeu demande toujours Oui ou Non, seule la saisie disparaît."
L["OPTIONS_MANUAL_DELETE_SCOPE_DESCRIPTION"] =
	"Objets sans valeur de vente ne simplifie que les objets qu'aucun marchand n'achète. Tous les objets simplifie chaque demande de saisie."
L["OPTIONS_MANUAL_DELETE_ALL"] = "Tous les objets"
L["OPTIONS_MANUAL_DELETE_NO_VALUE"] = "Objets sans valeur de vente"

-- Erase Confirmation
L["OPTIONS_ERASE_CONFIRM_HEADER"] = "Confirmation de suppression"
L["OPTIONS_ERASE_CONFIRM_DESCRIPTION"] = "Demande Oui ou Non avant toute suppression."
L["OPTIONS_ENABLE_ERASE_CONFIRM"] = "Activer la confirmation de suppression"
L["OPTIONS_ENABLE_ERASE_CONFIRM_DESCRIPTION"] =
	"Affiche un Oui ou Non avant chaque suppression, depuis le bouton de la minicarte ou le raccourci clavier, y compris pour les objets de votre Liste de suppression."

--------------------------------------------------------------------------------
-- Options: Merchant & Bank Panel
--------------------------------------------------------------------------------

L["TAB_MERCHANT_BANK_DESCRIPTION"] =
	"Vend votre rebut dès que vous ouvrez la fenêtre d'un marchand, et ramène dans vos sacs le rebut de votre banque pour qu'il parte avec le reste. Rien de ce qui figure sur votre Liste de protection n'est touché."

-- Auto-Vend
L["OPTIONS_ENABLE_AUTO_VEND"] = "Activer la Vente auto"
L["OPTIONS_ENABLE_AUTO_VEND_DESCRIPTION"] =
	"Active ou désactive la vente chez les marchands. Les objets de votre Liste de protection ne sont jamais vendus."
L["OPTIONS_AUTO_VEND_SUMMARY"] = "Résumé dans la discussion"
L["OPTIONS_AUTO_VEND_LINE_ITEM"] = "Chaque vente dans la discussion"
L["OPTIONS_AUTO_VEND_REPORT_OFF"] = "Aucun rapport dans la discussion"
L["OPTIONS_AUTO_VEND_MESSAGE_MODE_DESCRIPTION"] =
	"Ce que la Vente auto affiche dans la discussion. Résumé dans la discussion affiche un total par visite. Chaque vente dans la discussion affiche chaque vente, puis le total. Aucun rapport dans la discussion n'affiche rien."

-- Bank Retrieval
L["OPTIONS_BANK_HEADER"] = "Récupération à la banque"
L["OPTIONS_BANK_RETRIEVAL_DESCRIPTION"] =
	"Retire le rebut de votre banque quand vous l'ouvrez, pour qu'il soit vendu ou supprimé avec le reste. Ne prend que dans votre propre banque, jamais dans une banque de guilde ni dans une banque partagée du compte."
L["OPTIONS_ENABLE_BANK_RETRIEVAL"] = "Activer la récupération à la banque"
L["OPTIONS_ENABLE_BANK_RETRIEVAL_DESCRIPTION"] =
	"Active ou désactive la Récupération à la banque. Elle ne retire jamais plus que ce que vos emplacements de sac libres peuvent contenir."
L["OPTIONS_BANK_CUSHION_NOTE"] = "Laisse %d emplacements de sac libres, car les Alertes d'espace de sac sont activées."
L["OPTIONS_BANK_CUSHION_NOTE_ONE"] =
	"Laisse 1 emplacement de sac libre, car les Alertes d'espace de sac sont activées."

--------------------------------------------------------------------------------
-- Options: Alerts & Tints Panel
--------------------------------------------------------------------------------

L["TAB_ALERTS_DESCRIPTION"] = "Ce que Magic Eraser vous signale de lui-même, dans la discussion et dans vos sacs."

-- Junk Item Tint
L["OPTIONS_TINT_HEADER"] = "Teinte des rebuts"
L["OPTIONS_TINT_DESCRIPTION"] =
	"Teinte les rebuts que Magic Eraser supprimerait, pour les repérer d'un coup d'œil dans vos sacs et votre banque."
L["OPTIONS_ENABLE_TINT"] = "Activer la teinte des rebuts"
L["OPTIONS_ENABLE_TINT_DESCRIPTION"] =
	"Active ou désactive la teinte. Fonctionne avec les sacs par défaut, Baganator, Bagnon, AdiBags, ArkInventory, BetterBags et ElvUI."
L["OPTIONS_TINT_COLOR"] = "Couleur de la teinte"
L["OPTIONS_TINT_COLOR_DESCRIPTION"] =
	"La couleur et l'opacité de la teinte. Une opacité plus faible laisse mieux voir l'icône de l'objet."
L["TINT_BAGANATOR_WIDGET_LABEL"] = "Teinte des rebuts (Magic Eraser)"

-- Quest Item Alerts
L["OPTIONS_QUEST_ALERTS_HEADER"] = "Alertes d'objets de quête"
L["OPTIONS_QUEST_ALERTS_DESCRIPTION"] =
	"Vous prévient dès qu'un Objet de quête terminée ou un Déclencheur de quête sans issue dans vos sacs peut être supprimé en toute sécurité."
L["OPTIONS_ENABLE_QUEST_ALERTS"] = "Activer les alertes d'objets de quête"
L["OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION"] =
	"Active ou désactive les alertes dans la discussion. Les Objets de quête terminée et les Déclencheurs de quête sans issue sont supprimés dans tous les cas."

-- Bag-Space Warnings
L["OPTIONS_BAGS_FULL_HEADER"] = "Alertes d'espace de sac"
L["OPTIONS_BAGS_FULL_DESCRIPTION"] =
	"Vous avertit à mesure que vos derniers emplacements de sac libres se remplissent. Reste silencieux tant qu'une fenêtre de marchand, de boîte aux lettres ou de banque est ouverte."
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS"] = "Activer les alertes d'espace de sac"
L["OPTIONS_ENABLE_BAGS_FULL_WARNINGS_DESCRIPTION"] = "Active ou désactive le décompte dans la discussion."
L["OPTIONS_BAGS_FULL_THRESHOLD"] = "Seuil d'emplacements libres"
L["OPTIONS_BAGS_FULL_THRESHOLD_DESCRIPTION"] =
	"Nombre d'emplacements libres qui déclenche le décompte. Tant que les alertes sont activées, la Récupération à la banque laisse aussi ce nombre d'emplacements libres."

--------------------------------------------------------------------------------
-- Options: Item Lists
--------------------------------------------------------------------------------

-- Shared by every player-managed item list panel; never names the list itself.
L["OPTIONS_LIST_GLOBAL"] = "Tous les personnages"
L["OPTIONS_LIST_ADD_FROM_BAGS"] = "Ajouter depuis les sacs"
L["OPTIONS_LIST_ADD_FROM_BAGS_DESCRIPTION"] =
	"Choisissez n'importe quel objet que vous transportez. Les sacs se ferment à l'ouverture du panneau d'options, cette option remplace donc le glisser-déposer d'un objet ici."
L["OPTIONS_LIST_ADD_ID"] = "Ajouter par ID d'objet"
L["OPTIONS_LIST_ADD_ID_DESCRIPTION"] =
	"Saisissez un ID d'objet et appuyez sur Entrée. Vous pouvez aussi Maj+cliquer sur un lien d'objet dans la discussion pour l'insérer ici."
L["OPTIONS_LIST_ADD_ID_INVALID"] = "Saisissez un ID d'objet, ou Maj+cliquez sur un lien d'objet dans la discussion."
L["OPTIONS_LIST_REMOVE"] = "Retirer"
L["OPTIONS_LIST_EMPTY"] = "Cette liste est vide."
L["OPTIONS_LIST_CLEAR"] = "Vider la liste"
L["OPTIONS_LIST_CLEAR_DESCRIPTION"] =
	"Retire tous les objets de cette liste. Un personnage dont la liste est vide disparaît de la liste de gauche, sauf s'il s'agit de celui que vous jouez."
L["OPTIONS_LIST_CLEAR_CONFIRM"] = "Retirer tous les objets de cette liste ? Cette action est irréversible."

--------------------------------------------------------------------------------
-- Options: Protect List
--------------------------------------------------------------------------------

L["OPTIONS_IGNORE_DESCRIPTION"] =
	"Les objets d'une Liste de protection ne sont jamais supprimés ni vendus. La liste Tous les personnages protège un objet partout, et la liste propre à un personnage le protège uniquement sur celui-ci."
L["OPTIONS_IGNORE_PROMOTE_DESCRIPTION"] =
	"Déplace cet objet vers la liste Tous les personnages, pour qu'il soit protégé partout."

--------------------------------------------------------------------------------
-- Options: Erase List
--------------------------------------------------------------------------------

L["OPTIONS_ERASE_DESCRIPTION"] =
	"Les objets d'une Liste de suppression sont toujours du rebut, quelle que soit leur valeur : supprimés par le bouton de la minicarte et vendus chez les marchands. Votre Liste de protection l'emporte toujours, et une ligne qu'elle annule affiche Protégé."
L["OPTIONS_ERASE_PROMOTE_DESCRIPTION"] =
	"Déplace cet objet vers la liste Tous les personnages, pour qu'il soit supprimé sur tous vos personnages, y compris ceux pour lesquels il n'a jamais été ajouté."
L["OPTIONS_LIST_PROTECTED_TAG"] = "Protégé"
L["OPTIONS_ERASE_RESTORE"] = "Restaurer les valeurs par défaut"
L["OPTIONS_ERASE_RESTORE_DESCRIPTION"] =
	"Rétablit la Liste de suppression de ce personnage avec les objets fournis au départ par Magic Eraser."
L["OPTIONS_ERASE_RESTORE_CONFIRM"] =
	"Vider la Liste de suppression de ce personnage et n'y remettre que les objets fournis au départ par Magic Eraser ? Tout ce que vous avez ajouté vous-même est retiré."
L["OPTIONS_ERASE_RESTORE_GLOBAL_DESCRIPTION"] =
	"Vide la Liste de suppression Tous les personnages, que Magic Eraser crée vide. La liste propre à chaque personnage n'est pas modifiée."
L["OPTIONS_ERASE_RESTORE_GLOBAL_CONFIRM"] =
	"Vider la Liste de suppression Tous les personnages ? Tout ce qu'elle contient est retiré, et la liste propre à chaque personnage n'est pas modifiée."
