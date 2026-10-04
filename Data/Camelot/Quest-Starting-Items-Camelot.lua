local _, ns = ...

-- [itemId] = { questId, racesMask, classesMask }, -- Item Name
ns.ALLOWED_DELETE_QUEST_STARTING_ITEMS = {
	--------------------------------------------------------------------------------
	-- 01. World of Warcraft
	--------------------------------------------------------------------------------

	[22970] = { 9301 }, -- A Bloodstained Envelope
	[22972] = { 9299 }, -- A Careworn Note
	[22973] = { 9302 }, -- A Crumpled Missive
	[11446] = { 4264 }, -- A Crumpled Up Note
	[22723] = { 9247 }, -- A Letter from the Keeper of the Rolls
	[2839] = { 361, 690, 0 }, -- A Letter to Yvette
	[22974] = { 9300 }, -- A Ragged Page
	[22975] = { 9304 }, -- A Smudged Document
	[3317] = { 460, 690, 0 }, -- A Talking Head
	[22977] = { 9295 }, -- A Torn Letter
	[280438] = { 97288 }, -- Abominable Head
	[4881] = { 830, 690, 0 }, -- Aged Envelope
	[2794] = { 337, 1101, 0 }, -- An Old History Book
	[2874] = { 373, 1101, 0 }, -- An Unsent Letter
	[21230] = { 8784 }, -- Ancient Qiraji Artifact
	[3668] = { 522, 1101, 0 }, -- Assassin's Contract
	[12564] = { 4881, 690, 0 }, -- Assassination Note
	[18987] = { 7761 }, -- Blackhand's Command
	[13140] = { 5202 }, -- Blood Red Key
	[251270] = { 92415 }, -- Blood-Stained Parchment
	[268535] = { 95195 }, -- Bloodied Insignia
	[273658] = { 96294 }, -- Bloody Parchment
	[14650] = { 5844, 32, 0 }, -- Camp Narache Gift Voucher
	[12558] = { 4882, 690, 0 }, -- Blue-feathered Necklace
	[5352] = { 968 }, -- Book: The Powers Below
	[20461] = { 8308 }, -- Brann Bronzebeard's Lost Letter
	[20460] = { 8308 }, -- Brann Bronzebeard's Lost Letter
	[4613] = { 708 }, -- Corroded Black Box
	[268579] = { 95189 }, -- Crest of Lordaeron
	[275521] = { 95204 }, -- Crest of Lordaeron
	[247826] = { 91740 }, -- Croaky's Head
	[274268] = { 96391 }, -- Dark Iron Map
	[14651] = { 5847, 16, 0 }, -- Deathknell Gift Voucher
	[18950] = { 7704 }, -- Chambermaid Pillaclencher's Pillow
	[4926] = { 819, 690, 0 }, -- Chen's Empty Keg
	[5877] = { 1148, 690, 0 }, -- Cracked Silithid Carapace
	[12842] = { 5123 }, -- Crudely-written Log
	[16790] = { 6564, 690, 0 }, -- Damp Note
	[20741] = { 8470 }, -- Deadwood Ritual Totem
	[4854] = { 770, 690, 0 }, -- Demon Scarred Cloak
	[4851] = { 781, 690, 0 }, -- Dirt-stained Map
	[277661] = { 97281 }, -- Dull Storm Orb
	[247862] = { 91746 }, -- Elmpaw's Head
	[268548] = { 95213 }, -- Empty Powder Keg
	[278049] = { 86613 }, -- Excavation Tools
	[277190] = { 97236 }, -- Fang of Githyiss
	[23184] = { 9332, 690, 0 }, -- Flame of Darnassus
	[23183] = { 9331, 690, 0 }, -- Flame of Ironforge
	[23179] = { 9324, 1101, 0 }, -- Flame of Orgrimmar
	[23182] = { 9330, 690, 0 }, -- Flame of Stormwind
	[23181] = { 9326, 1101, 0 }, -- Flame of the Undercity
	[23180] = { 9325, 1101, 0 }, -- Flame of Thunder Bluff
	[253711] = { 92707 }, -- Goliath's Wristguards
	[281147] = { 79362 }, -- Grant's Shield
	[275723] = { 96877 }, -- Halikor's Hoof
	[13920] = { 5582 }, -- Healthy Dragon Scale
	[281143] = { 96137 }, -- Ira's Dagger
	[251520] = { 92415 }, -- Last Scrawlings of Edward Heartweaver
	[6172] = { 1423 }, -- Lost Supplies
	[281142] = { 96138 }, -- Merrick's Bow
	[281330] = { 98471 }, -- Message from the Supreme Magister
	[281031] = { 98424 }, -- Mulgore Expansion Plans
	[247834] = { 91741 }, -- Nibbled-On Book
	[271343] = { 95884 }, -- Note Scrap
	[22719] = { 9233 }, -- Omarion's Handbook
	[18972] = { 7738 }, -- Perfect Yeti Hide
	[10590] = { 3482 }, -- Pocked Black Box
	[255155] = { 92910 }, -- Precessive Autocognition Assembly
	[211269] = { 78823 }, -- Primitive Drawing
	[18969] = { 7735 }, -- Pristine Yeti Hide
	[265476] = { 94490 }, -- Ripped Missive
	[257215] = { 93173 }, -- Rusty Gadget
	[19443] = { 7944 }, -- Sayge's Fortune #25
	[14648] = { 5842, 8, 0 }, -- Shadowglen Gift Voucher
	[17126] = { 6681, 0, 8 }, -- Elegant Letter
	[12771] = { 5083 }, -- Empty Firewater Flask
	[3706] = { 551, 1101, 0 }, -- Ensorcelled Parchment
	[4903] = { 832, 690, 0 }, -- Eye of Burning Shadow
	[20310] = { 1480, 690, 0 }, -- Flayed Demon Skin
	[11668] = { 939, 1101, 0 }, -- Flute of Xavaric
	[12780] = { 5089, 1101, 0 }, -- General Drakkisath's Command
	[1962] = { 178, 1101, 0 }, -- Glowing Shadowhide Pendant
	[10441] = { 6981 }, -- Glowing Shard
	[1307] = { 123, 1101, 0 }, -- Gold Pickup Schedule
	[14646] = { 5805, 1, 0 }, -- Northshire Gift Voucher
	[9370] = { 2978, 690, 0 }, -- Gordunni Scroll
	[9326] = { 2945 }, -- Grime-Encrusted Ring
	[5138] = { 897, 690, 0 }, -- Harvester's Head
	[13250] = { 5262 }, -- Head of Balnazzar
	[5099] = { 883, 690, 0 }, -- Hoof of Lakota'mani
	[14647] = { 5841, 1101, 0 }, -- Coldridge Valley Gift Voucher
	[20949] = { 8575 }, -- Magical Ledger
	[10000] = { 3181, 1101, 0 }, -- Margol's Horn
	[5179] = { 927 }, -- Moss-twined Heart
	[6196] = { 1392 }, -- Noboru's Cudgel
	[10589] = { 3374 }, -- Oathstone of Ysera's Dragonflight
	[5102] = { 884, 690, 0 }, -- Owatanka's Tailspike
	[280179] = { 98247 }, -- Shipping Label
	[280180] = { 98248 }, -- Shipping Label
	[281145] = { 79363 }, -- Silvia's Sword
	[213421] = { 95534 }, -- Singed Note
	[251900] = { 92454 }, -- Thendal Grove Gift Voucher
	[270865] = { 95810 }, -- Titan Relic
	[270866] = { 95664 }, -- Titan Relic
	[281030] = { 98423 }, -- Treaty of Understanding
	[275722] = { 96876 }, -- Ukor's Lost Pack
	[14649] = { 5843, 130, 0 }, -- Valley of Trials Gift Voucher
	[10621] = { 3513, 690, 0 }, -- Runed Scroll
	[19423] = { 7937 }, -- Sayge's Fortune #23
	[19424] = { 7938 }, -- Sayge's Fortune #24
	[19452] = { 7945 }, -- Sayge's Fortune #27
	[9250] = { 2876 }, -- Ship Schedule
	[17008] = { 6522, 690, 0 }, -- Small Scroll
	[17115] = { 6661, 1101, 0 }, -- Squirrel Token
	[17116] = { 6662, 1101, 0 }, -- Squirrel Token
	[6775] = { 1642, 1, 2 }, -- Tome of Divinity
	[6916] = { 1646, 4, 2 }, -- Tome of Divinity
	[6776] = { 1649, 1101, 2 }, -- Tome of Valor
	[12563] = { 4903, 690, 0 }, -- Warlord Goretooth's Command
	[5103] = { 885, 690, 0 }, -- Washte Pawne's Feather
	[4433] = { 637, 1101, 0 }, -- Waterlogged Envelope
	[1972] = { 184, 1101, 0 }, -- Westfall Deed
	[268812] = { 95328 }, -- Whispering Horror Residue
	[20742] = { 8471 }, -- Winterfall Ritual Totem
}

--[[
How We Got the Data

Last Validated
	2026-10-04, WoW Forever 1.60.1.70205

Notes
	- Items that hand you a quest when you right-click them. Unlike Quest-Items, which a turn-in consumes, these create the quest, so they're safe to erase for two separate reasons:
		- The quest they start is flagged complete, so the item is spent.
		- The player's race or class can never take that quest, so the item is dead weight the moment it drops (an Alliance-only starter in a Horde player's bags, a Paladin tome on a Rogue). That needs no quest state at all.
	- questId is the quest the item starts. racesMask and classesMask are that quest's race and class limits (quest_template.RequiredRaces and RequiredClasses), left off when it has none.
		- Race bits: Human 1, Orc 2, Dwarf 4, NightElf 8, Undead 16, Tauren 32, Gnome 64, Troll 128, BloodElf 512, Draenei 1024. Alliance = 1101, Horde = 690, 0 = no restriction.
		- Class bits: Warrior 1, Paladin 2, Hunter 4, Rogue 8, Priest 16, DeathKnight 32, Shaman 64, Mage 128, Warlock 256, Druid 1024.
	- Repeatable, daily and weekly quests are left out: their starter can come back, so a completed flag proves nothing. The repeatable flag has gaps (five Craftsman's Writs lack it while the other nineteen in the family have it); the bind rule catches all five.
	- Only starters bound to the looter (bind on pickup, or quest item) are kept. One that doesn't bind can be handed to an alt or another player who does qualify, so deleting it destroys something still useful: Carefully Folded Note and Captain Sanders' Treasure Map, and the five unflagged Writs are unbound too.
	- Poor and common quality only. Plenty of quest starters are epics and legendaries (Dormant Wind Kissed Blade, Frame of Atiesh, Shattered Fragments of Val'anyr, Battered Hilt), and none may ever be erased. Relax the cap only after reading every row.
	- Disabled quests, quest 1 (a dev test entry), and dev-marked or placeholder quests and items are left out.
	- Rows outside the query were added from wago.tools build 1.60.1.70205.
	- Read by Features/Junk-Rules.lua and Features/Quest-Item-Alerts.lua.

SQL (CMaNGOS)
	CMaNGOS WotLK world DB (wotlk-db), MySQL 8. item_template.startquest holds the quest an item hands you.

	-- Bonding: 0 = no bind, 1 = bind on pickup, 2 = bind on equip, 3 = bind on use,
	-- 4 = quest item (bound). Only 1 and 4 can never reach another character.
	-- If your schema names the flags differently, check with
	--   SHOW COLUMNS FROM quest_template LIKE '%Flags%';

	WITH starter AS (
	  SELECT it.entry AS item, it.name, it.Quality, it.class, it.subclass,
	         it.SellPrice, it.Bonding,
	         q.entry AS quest, q.Title, q.QuestLevel, q.MinLevel,
	         q.RequiredRaces, q.RequiredClasses
	  FROM item_template it
	  JOIN quest_template q ON q.entry = it.startquest
	  WHERE it.startquest > 0
	    AND q.Method <> 0                 -- skip disabled quests
	    AND (q.SpecialFlags &     1) = 0  -- not repeatable
	    AND (q.QuestFlags   &  4096) = 0  -- not daily
	    AND (q.QuestFlags   & 32768) = 0  -- not weekly
	    AND it.Quality <= 1               -- see header before relaxing this
	    AND it.Bonding IN (1, 4)          -- bound to the looter, see header
	    AND q.entry <> 1                  -- quest 1 is a dev test entry
	    AND q.Title NOT LIKE '%[PH]%'
	    AND q.Title NOT LIKE '%<%'        -- <NYI> and <TXT> dev markers
	    AND q.Title NOT LIKE '%Blahblah%'
	    AND it.name NOT LIKE '%Test%'
	    AND it.name NOT LIKE '%[PH]%'
	    AND it.name NOT LIKE '%UNUSED%'
	    AND it.name NOT LIKE '%DEPRECATED%'
	    AND it.name NOT LIKE 'OLD %'
	    AND it.name NOT LIKE '%(old%'
	)
	SELECT
	  CASE WHEN item < 22500 THEN '01 WoW'
	       WHEN item < 33117 THEN '02 TBC'
	       ELSE '03 WotLK' END                                      AS section,
	  CASE WHEN RequiredRaces = 0                THEN 'Both'
	       WHEN (RequiredRaces &  690) = 0       THEN 'Alliance'
	       WHEN (RequiredRaces & 1101) = 0       THEN 'Horde'
	       ELSE 'Both' END                                          AS faction,
	  item, name, quest, Title AS quest_title,
	  RequiredRaces AS races_mask, RequiredClasses AS classes_mask,
	  CONCAT_WS(',',
	    IF(RequiredRaces &    1, 'Human',    NULL), IF(RequiredRaces &    2, 'Orc',      NULL),
	    IF(RequiredRaces &    4, 'Dwarf',    NULL), IF(RequiredRaces &    8, 'NightElf', NULL),
	    IF(RequiredRaces &   16, 'Undead',   NULL), IF(RequiredRaces &   32, 'Tauren',   NULL),
	    IF(RequiredRaces &   64, 'Gnome',    NULL), IF(RequiredRaces &  128, 'Troll',    NULL),
	    IF(RequiredRaces &  512, 'BloodElf', NULL), IF(RequiredRaces & 1024, 'Draenei',  NULL))
	                                                                AS races,
	  CONCAT_WS(',',
	    IF(RequiredClasses &    1, 'Warrior', NULL), IF(RequiredClasses &   2, 'Paladin', NULL),
	    IF(RequiredClasses &    4, 'Hunter',  NULL), IF(RequiredClasses &   8, 'Rogue',   NULL),
	    IF(RequiredClasses &   16, 'Priest',  NULL), IF(RequiredClasses &  32, 'DK',      NULL),
	    IF(RequiredClasses &   64, 'Shaman',  NULL), IF(RequiredClasses & 128, 'Mage',    NULL),
	    IF(RequiredClasses &  256, 'Warlock', NULL), IF(RequiredClasses &1024, 'Druid',   NULL))
	                                                                AS classes,
	  Quality AS quality, class, SellPrice AS sell_price, Bonding AS bind,
	  QuestLevel AS quest_level,
	  -- [itemId] = { questId, racesMask, classesMask } and masks are omitted when both are 0
	  CONCAT('\t[', item, '] = { ', quest,
	         CASE WHEN RequiredRaces = 0 AND RequiredClasses = 0 THEN ''
	              ELSE CONCAT(', ', RequiredRaces, ', ', RequiredClasses) END,
	         ' }, -- ', name)                                       AS lua_line
	FROM starter
	ORDER BY faction, section, name;

	-- How wide the repeatable-flag gap is: look for families with counts in both columns.

	WITH st AS (
	  SELECT it.entry AS item, it.name, q.entry AS quest, q.SpecialFlags,
	         SUBSTRING_INDEX(it.name, ' - ', 1) AS family
	  FROM item_template it
	  JOIN quest_template q ON q.entry = it.startquest
	  WHERE it.startquest > 0 AND q.Method <> 0 AND it.Quality <= 1)
	SELECT family, COUNT(*) AS items,
	       SUM((SpecialFlags & 1) <> 0) AS flagged_repeatable,
	       SUM((SpecialFlags & 1) =  0) AS not_flagged,
	       GROUP_CONCAT(DISTINCT SpecialFlags ORDER BY SpecialFlags) AS flags_seen
	FROM st GROUP BY family
	HAVING items > 1 AND flagged_repeatable > 0 AND not_flagged > 0
	ORDER BY not_flagged DESC, family;

Wowhead
	None.

wago.tools
	Build 1.60.1.70205; the file never recorded which tables.
	https://wago.tools/db2/ItemSparse?build=1.60.1.70205
]]
