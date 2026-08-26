local _, ns = ...

--[[

============================================================================
Magic Eraser :: items that START a quest, non-repeatable

Target: CMaNGOS WotLK (mangos-wotlk) world DB, MySQL 8. One statement.

item_template.startquest holds the quest an item hands you when you right
click it. Two independent reasons such an item is safe to erase:

  1. the quest it starts is already flagged complete, so the item is spent
  2. the player's race or class can never take that quest at all, so the
     item is dead weight the moment it drops (an Alliance-only starter in a
     Horde player's bags, a Paladin tome on a Rogue)

Reason 2 needs no quest state, which is why RequiredRaces and RequiredClasses
ride along in the output.

Repeatable quests are excluded: their starter can come back, so a completed
flag proves nothing. If your schema names these differently, check with
  SHOW COLUMNS FROM quest_template LIKE '%Flags%';

SpecialFlags alone is not enough. Five Craftsman's Writs came through an
earlier run with SpecialFlags & 1 clear while the other nineteen in the same
family were flagged correctly, so the repeatable flag has gaps in the data.
The Bonding rule below catches all five on its own, but to see how wide the
gap is, run this and look for families with counts in both columns:

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

Bonding is capped to bound items. A quest starter that does not bind can be
handed to an alt or another player who does qualify, so deleting it destroys
something still useful -- Carefully Folded Note and Captain Sanders' Treasure
Map are the obvious cases, and every leaked Writ was unbound as well.
  0 = no bind, 1 = bind on pickup, 2 = bind on equip,
  3 = bind on use, 4 = quest item (bound)
Only 1 and 4 can never reach another character.

Quality is capped at 1 (poor and common) on purpose. Plenty of quest
starters are epics and legendaries -- Dormant Wind Kissed Blade, Frame of
Atiesh, Shattered Fragments of Val'anyr, Battered Hilt -- and none of those
may ever be auto deleted. Relax the cap only if you read every row.

Race bits: Human 1, Orc 2, Dwarf 4, NightElf 8, Undead 16, Tauren 32,
           Gnome 64, Troll 128, BloodElf 512, Draenei 1024
           Alliance = 1101, Horde = 690, 0 = no restriction
Class bits: Warrior 1, Paladin 2, Hunter 4, Rogue 8, Priest 16,
            DeathKnight 32, Shaman 64, Mage 128, Warlock 256, Druid 1024
============================================================================

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

]]

--[[
    Items that hand you a quest when you right click them. Distinct from
    AllowedDeleteQuestItems: those are consumed by a turn-in, these create the
    quest in the first place, so they are safe to erase for two separate
    reasons.

    [itemId] = { questId, racesMask, classesMask }

    questId     the quest the item starts. Erasable once it is flagged
                complete, because the item is spent.
    racesMask   quest_template.RequiredRaces. Omitted when unrestricted. When
                the player's race bit is absent the quest can never be taken,
                so the item is dead weight from the moment it drops and needs
                no quest state at all.
    classesMask quest_template.RequiredClasses, same rule.

    Race bits:  Human 1, Orc 2, Dwarf 4, NightElf 8, Undead 16, Tauren 32,
                Gnome 64, Troll 128, BloodElf 512, Draenei 1024
                Alliance = 1101, Horde = 690
    Class bits: Warrior 1, Paladin 2, Hunter 4, Rogue 8, Priest 16,
                DeathKnight 32, Shaman 64, Mage 128, Warlock 256, Druid 1024

    Poor and common quality only. Several quest starters are epics and
    legendaries and none of those belong here.
]]
ns.AllowedDeleteQuestStartingItems = {

	--------------------------------------------------------------------------------
	-- 01. World of Warcraft
	--------------------------------------------------------------------------------

	[2839] = { 361, 690, 0 }, -- A Letter to Yvette
	[3317] = { 460, 690, 0 }, -- A Talking Head
	[4881] = { 830, 690, 0 }, -- Aged Envelope
	[2794] = { 337, 1101, 0 }, -- An Old History Book
	[2874] = { 373, 1101, 0 }, -- An Unsent Letter
	[3668] = { 522, 1101, 0 }, -- Assassin's Contract
	[12564] = { 4881, 690, 0 }, -- Assassination Note
	[18987] = { 7761 }, -- Blackhand's Command
	[13140] = { 5202 }, -- Blood Red Key
	[14650] = { 5844, 32, 0 }, -- Bloodhoof Village Gift Voucher
	[12558] = { 4882, 690, 0 }, -- Blue-feathered Necklace
	[5352] = { 968 }, -- Book: The Powers Below
	[20461] = { 8308 }, -- Brann Bronzebeard's Lost Letter
	[20460] = { 8308 }, -- Brann Bronzebeard's Lost Letter
	[14651] = { 5847, 16, 0 }, -- Brill Gift Voucher
	[21776] = { 8887, 690, 0 }, -- Captain Kelisendra's Lost Rutters
	[18950] = { 7704 }, -- Chambermaid Pillaclencher's Pillow
	[4926] = { 819, 690, 0 }, -- Chen's Empty Keg
	[5877] = { 1148, 690, 0 }, -- Cracked Silithid Carapace
	[12842] = { 5123 }, -- Crudely-written Log
	[16790] = { 6564, 690, 0 }, -- Damp Note
	[20741] = { 8470 }, -- Deadwood Ritual Totem
	[4854] = { 770, 690, 0 }, -- Demon Scarred Cloak
	[4851] = { 781, 690, 0 }, -- Dirt-stained Map
	[14648] = { 5842, 8, 0 }, -- Dolanaar Gift Voucher
	[17126] = { 6681, 0, 8 }, -- Elegant Letter
	[12771] = { 5083 }, -- Empty Firewater Flask
	[3706] = { 551, 1101, 0 }, -- Ensorcelled Parchment
	[4903] = { 832, 690, 0 }, -- Eye of Burning Shadow
	[20938] = { 8547, 512, 0 }, -- Falconwing Square Gift Voucher
	[20310] = { 1480, 690, 0 }, -- Flayed Demon Skin
	[11668] = { 939, 1101, 0 }, -- Flute of Xavaric
	[12780] = { 5089, 1101, 0 }, -- General Drakkisath's Command
	[1962] = { 178, 1101, 0 }, -- Glowing Shadowhide Pendant
	[10441] = { 6981 }, -- Glowing Shard
	[1307] = { 123, 1101, 0 }, -- Gold Pickup Schedule
	[14646] = { 5805, 1, 0 }, -- Goldshire Gift Voucher
	[9370] = { 2978, 690, 0 }, -- Gordunni Scroll
	[9326] = { 2945 }, -- Grime-Encrusted Ring
	[5138] = { 897, 690, 0 }, -- Harvester's Head
	[13250] = { 5262 }, -- Head of Balnazzar
	[5099] = { 883, 690, 0 }, -- Hoof of Lakota'mani
	[20765] = { 8482, 690, 0 }, -- Incriminating Documents
	[20798] = { 8489 }, -- Intact Arcane Converter
	[14647] = { 5841, 1101, 0 }, -- Kharanos Gift Voucher
	[20949] = { 8575 }, -- Magical Ledger
	[10000] = { 3181, 1101, 0 }, -- Margol's Horn
	[5179] = { 927 }, -- Moss-twined Heart
	[6196] = { 1392 }, -- Noboru's Cudgel
	[10589] = { 3374 }, -- Oathstone of Ysera's Dragonflight
	[5102] = { 884, 690, 0 }, -- Owatanka's Tailspike
	[14649] = { 5843, 130, 0 }, -- Razor Hill Gift Voucher
	[10621] = { 3513, 690, 0 }, -- Runed Scroll
	[19423] = { 7937 }, -- Sayge's Fortune #23
	[19424] = { 7938 }, -- Sayge's Fortune #24
	[19452] = { 7945 }, -- Sayge's Fortune #27
	[9250] = { 2876 }, -- Ship Schedule
	[17008] = { 6522, 690, 0 }, -- Small Scroll
	[17115] = { 6661, 1101, 0 }, -- Squirrel Token
	[17116] = { 6662, 1101, 0 }, -- Squirrel Token
	[20483] = { 8338, 512, 0 }, -- Tainted Arcane Sliver
	[6775] = { 1642, 1, 2 }, -- Tome of Divinity
	[6916] = { 1646, 4, 2 }, -- Tome of Divinity
	[6776] = { 1649, 1101, 2 }, -- Tome of Valor
	[12563] = { 4903, 690, 0 }, -- Warlord Goretooth's Command
	[5103] = { 885, 690, 0 }, -- Washte Pawne's Feather
	[4433] = { 637, 1101, 0 }, -- Waterlogged Envelope
	[1972] = { 184, 1101, 0 }, -- Westfall Deed
	[20742] = { 8471 }, -- Winterfall Ritual Totem

	--------------------------------------------------------------------------------
	-- 02. World of Warcraft : The Burning Crusade
	--------------------------------------------------------------------------------

	[22970] = { 9301 }, -- A Bloodstained Envelope
	[22972] = { 9299 }, -- A Careworn Note
	[22973] = { 9302 }, -- A Crumpled Missive
	[24132] = { 9672, 1101, 0 }, -- A Letter from the Admiral
	[22723] = { 9247 }, -- A Letter from the Keeper of the Rolls
	[28552] = { 10229, 690, 0 }, -- A Mysterious Tome
	[22974] = { 9300 }, -- A Ragged Page
	[22975] = { 9304 }, -- A Smudged Document
	[22977] = { 9295 }, -- A Torn Letter
	[23249] = { 9360, 690, 0 }, -- Amani Invasion Plans
	[23580] = { 9418 }, -- Avruu's Orb
	[22888] = { 9278 }, -- Azure Watch Gift Voucher
	[29234] = { 10305 }, -- Belmara's Tome
	[23910] = { 9616, 1101, 0 }, -- Blood Elf Communication
	[24414] = { 9798, 1101, 0 }, -- Blood Elf Plans
	[29588] = { 10395, 1101, 0 }, -- Burning Legion Missive
	[29590] = { 10393, 690, 0 }, -- Burning Legion Missive
	[31707] = { 10880 }, -- Cabal Orders
	[29236] = { 10307 }, -- Cohlien's Cap
	[25459] = { 9911 }, -- "Count" Ungula's Mandible
	[29476] = { 10134 }, -- Crimson Crystal Shard
	[31384] = { 10810 }, -- Damaged Mask
	[29233] = { 10182 }, -- Dathric's Blade
	[23777] = { 9520, 1101, 0 }, -- Diabolical Plans
	[23797] = { 9535, 690, 0 }, -- Diabolical Plans
	[24330] = { 9731 }, -- Drain Schematics
	[23338] = { 9373 }, -- Eroded Leather Case
	[23678] = { 9455, 1101, 0 }, -- Faintly Glowing Crystal
	[23184] = { 9332, 690, 0 }, -- Flame of Darnassus
	[23183] = { 9331, 690, 0 }, -- Flame of Ironforge
	[23179] = { 9324, 1101, 0 }, -- Flame of Orgrimmar
	[23182] = { 9330, 690, 0 }, -- Flame of Stormwind
	[23181] = { 9326, 1101, 0 }, -- Flame of the Undercity
	[23180] = { 9325, 1101, 0 }, -- Flame of Thunder Bluff
	[31363] = { 10797, 1101, 0 }, -- Gorgrom's Favor
	[23850] = { 9564, 1101, 0 }, -- Gurf's Dignity
	[24504] = { 9861 }, -- Howling Wind
	[30756] = { 10621, 1101, 0 }, -- Illidari-Bane Shard
	[30579] = { 10623, 690, 0 }, -- Illidari-Bane Shard
	[32523] = { 11021 }, -- Ishaal's Almanac
	[25705] = { 9984 }, -- Luanga's Orders
	[25706] = { 9985 }, -- Luanga's Orders
	[29235] = { 10306 }, -- Luminrath's Mantle
	[31120] = { 10719 }, -- Meeting Note
	[32726] = { 11081 }, -- Murkblood Escape Plans
	[24559] = { 9871, 1101, 0 }, -- Murkblood Invasion Plans
	[24558] = { 9872, 690, 0 }, -- Murkblood Invasion Plans
	[22719] = { 9233 }, -- Omarion's Handbook
	[23890] = { 9587, 1101, 0 }, -- Ominous Letter
	[23892] = { 9588, 690, 0 }, -- Ominous Letter
	[31489] = { 10825 }, -- Orb of the Grishna
	[24367] = { 9764 }, -- Orders from Lady Vashj
	[32621] = { 11041 }, -- Partially Digested Hand
	[31239] = { 10754, 1101, 0 }, -- Primed Key Mold
	[31241] = { 10755, 690, 0 }, -- Primed Key Mold
	[23870] = { 9576, 1101, 0 }, -- Red Crystal Pendant
	[23759] = { 9514, 1101, 0 }, -- Rune Covered Tablet
	[33114] = { 11185, 1101, 0 }, -- Sealed Letter
	[33115] = { 11186, 690, 0 }, -- Sealed Letter
	[31345] = { 10793 }, -- The Journal of Val'zareq
	[22597] = { 9175, 690, 0 }, -- The Lady's Necklace
	[30431] = { 10524, 690, 0 }, -- Thunderlord Clan Artifact
	[23900] = { 9594, 1101, 0 }, -- Tzerak's Armor Plate
	[29738] = { 10413 }, -- Vial of Void Horror Ooze
	[28113] = { 10130 }, -- Warboss Nekrogg's Orders
	[28114] = { 10152 }, -- Warboss Nekrogg's Orders
	[23837] = { 9550, 1101, 0 }, -- Weathered Treasure Map
	[24483] = { 9827, 1101, 0 }, -- Withered Basidium
	[24484] = { 9828, 690, 0 }, -- Withered Basidium

	--------------------------------------------------------------------------------
	-- 03. World of Warcraft : Wrath of the Lich King
	--------------------------------------------------------------------------------

	[35855] = { 12021 }, -- A Letter Home
	[37571] = { 12278, 1101, 0 }, -- "Brew of the Month" Club Membership Form
	[37736] = { 12420, 1101, 0 }, -- "Brew of the Month" Club Membership Form
	[37599] = { 12306, 690, 0 }, -- "Brew of the Month" Club Membership Form
	[37737] = { 12421, 690, 0 }, -- "Brew of the Month" Club Membership Form
	[36756] = { 12067, 1101, 0 }, -- Captain Malin's Letter
	[42203] = { 12979 }, -- Dark Armor Plate
	[38280] = { 12491, 1101, 0 }, -- Direbrew's Dire Brew
	[38281] = { 12492, 690, 0 }, -- Direbrew's Dire Brew
	[42772] = { 13043 }, -- Dr. Terrible's "Building a Better Flesh Giant"
	[39713] = { 12781 }, -- Ebon Hold Gift Voucher
	[36855] = { 12146, 1101, 0 }, -- Emblazoned Battle Horn
	[36856] = { 12147, 690, 0 }, -- Emblazoned Battle Horn
	[44725] = { 13420 }, -- Everfrost Chip
	[49641] = { 14483 }, -- Faded Lovely Greeting Card
	[50320] = { 24745 }, -- Faded Lovely Greeting Card
	[35568] = { 11935, 1101, 0 }, -- Flame of Silvermoon
	[35569] = { 11933, 690, 0 }, -- Flame of the Exodar
	[36744] = { 12057, 690, 0 }, -- Flesh-bound Tome
	[33289] = { 11237, 1101, 0 }, -- Gjalerbron Attack Plans
	[33347] = { 11266, 690, 0 }, -- Gjalerbron Attack Plans
	[36742] = { 12055, 1101, 0 }, -- Goramosh's Strange Device
	[36746] = { 12059, 690, 0 }, -- Goramosh's Strange Device
	[33978] = { 11400, 1101, 0 }, -- "Honorary Brewer" Hand Stamp
	[34028] = { 11419, 690, 0 }, -- "Honorary Brewer" Hand Stamp
	[34777] = { 11632, 690, 0 }, -- Ith'rix's Hardened Carapace
	[43242] = { 13136 }, -- Jagged Shard
	[49676] = { 24442 }, -- Kvaldir Attack Plans
	[36780] = { 12085, 690, 0 }, -- Lieutenant Ta'zinni's Letter
	[34090] = { 11452, 1101, 0 }, -- Mezhen's Writings
	[34091] = { 11453, 690, 0 }, -- Mezhen's Writings
	[36940] = { 12105, 1101, 0 }, -- Mikhail's Journal
	[37830] = { 12423, 690, 0 }, -- Mikhail's Journal
	[40666] = { 12839 }, -- Note from the Grand Admiral
	[43512] = { 13204 }, -- Ooze-covered Fungus
	[46882] = { 14081 }, -- Riding Training Pamphlet
	[46879] = { 14082 }, -- Riding Training Pamphlet
	[46877] = { 14083 }, -- Riding Training Pamphlet
	[46878] = { 14084 }, -- Riding Training Pamphlet
	[46876] = { 14085 }, -- Riding Training Pamphlet
	[46880] = { 14086 }, -- Riding Training Pamphlet
	[46884] = { 14087 }, -- Riding Training Pamphlet
	[46883] = { 14088 }, -- Riding Training Pamphlet
	[46875] = { 14079 }, -- Riding Training Pamphlet
	[46881] = { 14089 }, -- Riding Training Pamphlet
	[37833] = { 12419 }, -- Ruby Brooch
	[35648] = { 11941 }, -- Scintillating Fragment
	[33961] = { 11395, 1101, 0 }, -- Scourge Device
	[33962] = { 11398, 690, 0 }, -- Scourge Device
	[41267] = { 12888 }, -- SCRAP-E Access Card
	[35723] = { 11972 }, -- Shards of Ahune
	[41556] = { 12922 }, -- Slag Covered Metal
	[49205] = { 14352 }, -- Small Scroll
	[38321] = { 12507 }, -- Strange Mojo
	[33121] = { 11189 }, -- Tarnished Promise Ring
	[36958] = { 12168, 1101, 0 }, -- The Favor of Zangus
	[34984] = { 11729, 1101, 0 }, -- The Ultrasonic Screwdriver
	[37432] = { 12271, 690, 0 }, -- Torturer's Rod
	[38660] = { 12631 }, -- Unliving Choker
	[34815] = { 11654, 690, 0 }, -- Vial of Fresh Blood
	[33314] = { 11249, 1101, 0 }, -- Vrykul Scroll of Ascension
	[33345] = { 11260, 690, 0 }, -- Vrykul Scroll of Ascension
	[38673] = { 12633 }, -- Writhing Choker
}
