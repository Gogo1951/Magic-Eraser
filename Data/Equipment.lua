local _, ns = ...

--[[

============================================================================
Magic Eraser :: white weapons  (CMaNGOS WotLK world DB, MySQL 8)

Regenerates the WEAPONS half of ns.AllowedDeleteEquipment below. Quality = 1,
soulbound included, minus vanity, tools and developer junk. The armor query
that regenerates the ARMOR half follows this one in the same file.

RULE: class 2, deals damage (dmg_max1 > 0), and not a profession tool.
      Tools are weapon subclass 14 (blacksmith hammer, mining pick, skinning
      knife) and 20 (fishing pole). They must be excluded by subclass, never
      by name: Kobold Excavation Pick is a real mace and any '%Pick%' filter
      would throw it out.

SHARED EXCLUSIONS, identical in both queries so the two can be diffed:

  ItemLevel > 1        The single highest-value filter. Every ilvl 1 white in
                       the game is developer junk: the CRobinson sets named
                       after a Blizzard dev, the D02 / C03 / D03 display
                       dummies, Durability test items, Engineer's Shield 1-3,
                       Bloodsail costume, Festival Dress, Demon Hunter
                       Blindfold. Real starter gear begins at ilvl 2 (Worn
                       Shortsword, Recruit's Shortsword), so nothing genuine
                       is lost.
  InventoryType 4, 19  Shirt and tabard slots. Always vanity, no exceptions.
  quest safety        Three separate ways an item can matter to a quest, and
                      all three are excluded: startquest (the item hands out a
                      quest), ReqItemId1..6 (it is a turn-in objective), and
                      SrcItemId / ReqSourceId1..4 (a quest hands it to you).
                      Erasing any of them destroys quest progress.
  SellPrice > 0        Unsellable whites are almost all unused data, and the
                       item cannot be vendored anyway.
  name blocklist       Five closed families that carry real item levels, so
                       no structural signal catches them: PVP placeholder
                       sets, (Action Figure) toys, "DO NOT USE", "... Target",
                       and CRobinson. Name matching is honest here; inventing
                       a stat rule for these would be worse.

NOT filtered: Bonding. Soulbound white gear is exactly what piles up and
cannot be traded away, so it belongs.

STILL NEEDS YOUR EYE: formal wear with genuine armor values, such as White
Wedding Dress (44 armor, ilvl 35), Tuxedo Pants and the Haliscan set. No
clean rule separates those from real cloth, so they come through.

section is an item-id heuristic, fine for grouping inside the Lua file but
not exact: Blood Elf and Draenei starter gear carries sub-22500 ids while
being TBC content. Re-bucket by eye if a row looks wrong.
============================================================================

WITH quest_touched AS (
  -- Every item any quest hands out or takes back, in one set. Deliberately no
  -- Method <> 0 filter: this is a protective exclusion, so a disabled quest
  -- still shields its item. Over-excluding costs nothing here, since a missing
  -- row only means the item is not auto-erased.
      SELECT ReqItemId1 AS item FROM quest_template WHERE ReqItemId1 > 0
  UNION SELECT ReqItemId2   FROM quest_template WHERE ReqItemId2   > 0
  UNION SELECT ReqItemId3   FROM quest_template WHERE ReqItemId3   > 0
  UNION SELECT ReqItemId4   FROM quest_template WHERE ReqItemId4   > 0
  UNION SELECT ReqItemId5   FROM quest_template WHERE ReqItemId5   > 0
  UNION SELECT ReqItemId6   FROM quest_template WHERE ReqItemId6   > 0
  UNION SELECT SrcItemId    FROM quest_template WHERE SrcItemId    > 0
  UNION SELECT ReqSourceId1 FROM quest_template WHERE ReqSourceId1 > 0
  UNION SELECT ReqSourceId2 FROM quest_template WHERE ReqSourceId2 > 0
  UNION SELECT ReqSourceId3 FROM quest_template WHERE ReqSourceId3 > 0
  UNION SELECT ReqSourceId4 FROM quest_template WHERE ReqSourceId4 > 0
),
eq AS (
  SELECT it.entry AS item, it.name, it.subclass, it.InventoryType,
         it.armor, it.dmg_max1, it.ItemLevel, it.RequiredLevel,
         it.SellPrice, it.Bonding, it.spellid_1
  FROM item_template it
  WHERE it.Quality = 1
    AND it.ItemLevel > 1
    AND it.InventoryType > 0
    AND it.InventoryType NOT IN (4, 19)
    AND it.startquest = 0        -- does not START a quest
    AND it.entry NOT IN (SELECT item FROM quest_touched)  -- and is not an
                                 -- objective of one, nor handed out by one
    AND it.SellPrice > 0
    AND it.class = 2
    AND it.subclass NOT IN (14, 20)   -- profession tools
    AND it.dmg_max1 > 0               -- weapon slot items that do not attack
    AND it.name NOT LIKE '%Test%'
    AND it.name NOT LIKE '%[PH]%'
    AND it.name NOT LIKE '%UNUSED%'
    AND it.name NOT LIKE '%DEPRECATED%'
    AND it.name NOT LIKE BINARY 'OLD%'   -- BINARY: LIKE is case-insensitive,
                                         -- and 'Old Blunderbuss' is a real item
    AND it.name NOT LIKE '%(old%'
    AND it.name NOT LIKE '%Monster%'
    AND it.name NOT LIKE '%NPC%'
    AND it.name NOT LIKE 'PVP %'
    AND it.name NOT LIKE '(Action Figure)%'
    AND it.name NOT LIKE '%DO NOT USE%'
    AND it.name NOT LIKE '% Target'
    AND it.name NOT LIKE 'CRobinson%'
)
SELECT
  CASE WHEN item < 22500 THEN '01 WoW'
       WHEN item < 33117 THEN '02 TBC'
       ELSE '03 WotLK' END                                  AS section,
  item, name,
  CASE subclass WHEN  0 THEN 'Axe 1H'   WHEN  1 THEN 'Axe 2H'   WHEN  2 THEN 'Bow'
                WHEN  3 THEN 'Gun'      WHEN  4 THEN 'Mace 1H'  WHEN  5 THEN 'Mace 2H'
                WHEN  6 THEN 'Polearm'  WHEN  7 THEN 'Sword 1H' WHEN  8 THEN 'Sword 2H'
                WHEN 10 THEN 'Staff'    WHEN 13 THEN 'Fist'     WHEN 15 THEN 'Dagger'
                WHEN 16 THEN 'Thrown'   WHEN 17 THEN 'Spear'    WHEN 18 THEN 'Crossbow'
                WHEN 19 THEN 'Wand'     ELSE CONCAT('weapon ', subclass) END  AS kind,
  InventoryType AS slot, dmg_max1 AS dmg, ItemLevel AS ilvl,
  RequiredLevel AS req, SellPrice AS sell, Bonding AS bind,
  NULLIF(spellid_1, 0)                                      AS has_spell,
  CONCAT('\t[', item, '] = true, -- ', name)                AS lua_line
FROM eq
ORDER BY section, name;


============================================================================
Magic Eraser :: white armor  (CMaNGOS WotLK world DB, MySQL 8)

Regenerates Data/Equipment-Armor.lua. Quality = 1, soulbound included, minus
vanity, tools and developer junk. Companion query: equipment-weapons.sql.

RULE: class 4, worn armor subclasses only, and armor > 0.
      Subclass 0 (Misc) is excluded on purpose: that is where necks, rings,
      trinkets and off-hand holdables live, none of which are in the table
      today. Relics (7-10) are excluded for the same reason.

SHARED EXCLUSIONS, identical in both queries so the two can be diffed:

  ItemLevel > 1        The single highest-value filter. Every ilvl 1 white in
                       the game is developer junk: the CRobinson sets named
                       after a Blizzard dev, the D02 / C03 / D03 display
                       dummies, Durability test items, Engineer's Shield 1-3,
                       Bloodsail costume, Festival Dress, Demon Hunter
                       Blindfold. Real starter gear begins at ilvl 2 (Worn
                       Shortsword, Recruit's Shortsword), so nothing genuine
                       is lost.
  InventoryType 4, 19  Shirt and tabard slots. Always vanity, no exceptions.
  quest safety        Three separate ways an item can matter to a quest, and
                      all three are excluded: startquest (the item hands out a
                      quest), ReqItemId1..6 (it is a turn-in objective), and
                      SrcItemId / ReqSourceId1..4 (a quest hands it to you).
                      Erasing any of them destroys quest progress.
  SellPrice > 0        Unsellable whites are almost all unused data, and the
                       item cannot be vendored anyway.
  name blocklist       Five closed families that carry real item levels, so
                       no structural signal catches them: PVP placeholder
                       sets, (Action Figure) toys, "DO NOT USE", "... Target",
                       and CRobinson. Name matching is honest here; inventing
                       a stat rule for these would be worse.

NOT filtered: Bonding. Soulbound white gear is exactly what piles up and
cannot be traded away, so it belongs.

STILL NEEDS YOUR EYE: formal wear with genuine armor values, such as White
Wedding Dress (44 armor, ilvl 35), Tuxedo Pants and the Haliscan set. No
clean rule separates those from real cloth, so they come through.

section is an item-id heuristic, fine for grouping inside the Lua file but
not exact: Blood Elf and Draenei starter gear carries sub-22500 ids while
being TBC content. Re-bucket by eye if a row looks wrong.
============================================================================

WITH quest_touched AS (
  -- Every item any quest hands out or takes back, in one set. Deliberately no
  -- Method <> 0 filter: this is a protective exclusion, so a disabled quest
  -- still shields its item. Over-excluding costs nothing here, since a missing
  -- row only means the item is not auto-erased.
      SELECT ReqItemId1 AS item FROM quest_template WHERE ReqItemId1 > 0
  UNION SELECT ReqItemId2   FROM quest_template WHERE ReqItemId2   > 0
  UNION SELECT ReqItemId3   FROM quest_template WHERE ReqItemId3   > 0
  UNION SELECT ReqItemId4   FROM quest_template WHERE ReqItemId4   > 0
  UNION SELECT ReqItemId5   FROM quest_template WHERE ReqItemId5   > 0
  UNION SELECT ReqItemId6   FROM quest_template WHERE ReqItemId6   > 0
  UNION SELECT SrcItemId    FROM quest_template WHERE SrcItemId    > 0
  UNION SELECT ReqSourceId1 FROM quest_template WHERE ReqSourceId1 > 0
  UNION SELECT ReqSourceId2 FROM quest_template WHERE ReqSourceId2 > 0
  UNION SELECT ReqSourceId3 FROM quest_template WHERE ReqSourceId3 > 0
  UNION SELECT ReqSourceId4 FROM quest_template WHERE ReqSourceId4 > 0
),
eq AS (
  SELECT it.entry AS item, it.name, it.subclass, it.InventoryType,
         it.armor, it.dmg_max1, it.ItemLevel, it.RequiredLevel,
         it.SellPrice, it.Bonding, it.spellid_1
  FROM item_template it
  WHERE it.Quality = 1
    AND it.ItemLevel > 1
    AND it.InventoryType > 0
    AND it.InventoryType NOT IN (4, 19)
    AND it.startquest = 0        -- does not START a quest
    AND it.entry NOT IN (SELECT item FROM quest_touched)  -- and is not an
                                 -- objective of one, nor handed out by one
    AND it.SellPrice > 0
    AND it.class = 4
    AND it.subclass IN (1, 2, 3, 4, 5, 6)  -- cloth, leather, mail, plate, buckler, shield
    AND it.armor > 0                       -- armor slot items with no armor
    AND it.name NOT LIKE '%Test%'
    AND it.name NOT LIKE '%[PH]%'
    AND it.name NOT LIKE '%UNUSED%'
    AND it.name NOT LIKE '%DEPRECATED%'
    AND it.name NOT LIKE BINARY 'OLD%'   -- BINARY: LIKE is case-insensitive,
                                         -- and 'Old Blunderbuss' is a real item
    AND it.name NOT LIKE '%(old%'
    AND it.name NOT LIKE '%Monster%'
    AND it.name NOT LIKE '%NPC%'
    AND it.name NOT LIKE 'PVP %'
    AND it.name NOT LIKE '(Action Figure)%'
    AND it.name NOT LIKE '%DO NOT USE%'
    AND it.name NOT LIKE '% Target'
    AND it.name NOT LIKE 'CRobinson%'
)
SELECT
  CASE WHEN item < 22500 THEN '01 WoW'
       WHEN item < 33117 THEN '02 TBC'
       ELSE '03 WotLK' END                                  AS section,
  item, name,
  CASE subclass WHEN 1 THEN 'Cloth'   WHEN 2 THEN 'Leather' WHEN 3 THEN 'Mail'
                WHEN 4 THEN 'Plate'   WHEN 5 THEN 'Buckler' WHEN 6 THEN 'Shield'
                ELSE CONCAT('armor ', subclass) END                          AS kind,
  InventoryType AS slot, armor, ItemLevel AS ilvl,
  RequiredLevel AS req, SellPrice AS sell, Bonding AS bind,
  NULLIF(spellid_1, 0)                                      AS has_spell,
  CONCAT('\t[', item, '] = true, -- ', name)                AS lua_line
FROM eq
ORDER BY section, name;

]]

--[[
    Every white item you can equip that is worth erasing on sight. One table and
    one delete reason, split into WEAPONS and ARMOR sections because the two
    halves are identified by different rules and by the two different queries
    above, and into expansion blocks inside each because the file is large.

    No level gate: white gear is trash at every level. Soulbound is included on
    purpose, since that is the gear that piles up and cannot be traded away.
    Anything a quest hands out, takes back, or is started by is excluded in the
    queries, so nothing here can cost quest progress.

    The queries run against a WotLK world DB while the add-on ships to Era, TBC
    and WotLK, and item quality drifted between them: Bronze Mace and most of
    the low-level crafted gear are white in Era and green by WotLK, so the
    WotLK DB filters them out even though they are trash on the client most
    players are on. Those rows are carried here anyway, all 28 of them
    verified Quality 2 in the WotLK DB and quest-free. Eraser.lua gates the
    equipment branch on the live rarity, so a row that is green on the player's
    own client simply does nothing there. Membership is a candidate, not a
    verdict.

    Held out by hand, because no structural rule separates them from real gear:
      Lucky Fishing Hat      permanent fishing bonus
      Borrowed Broom         Hallow's End event item with an on-use
      White Wedding Dress    formal wear with genuine armor values
      Tuxedo Pants           formal wear
      Haliscan Jacket        formal wear
      Haliscan Pantaloons    formal wear
      Formal Draenic Robe    formal wear
]]
ns.AllowedDeleteEquipment = {

	--------------------------------------------------------------------------------
	-- WEAPONS
	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	-- 01. World of Warcraft
	--------------------------------------------------------------------------------

	[2487] = true, -- Acolyte Staff
	[20983] = true, -- Acolyte's Dagger
	[2503] = true, -- Adept Short Staff
	[5235] = true, -- Alchemist's Wand
	[2048] = true, -- Anvilmar Hammer
	[2047] = true, -- Anvilmar Hand Axe
	[2195] = true, -- Anvilmar Knife
	[12446] = true, -- Anvilmar Musket
	[5761] = true, -- Anvilmar Sledge
	[20978] = true, -- Apprentice's Staff
	[20850] = true, -- Arcane Forged Axe
	[20852] = true, -- Arcane Forged Dirk
	[20851] = true, -- Arcane Forged Mace
	[20849] = true, -- Arcane Forged Shortsword
	[5596] = true, -- Ashwood Bow
	[1194] = true, -- Bastard Sword
	[926] = true, -- Battle Axe
	[2527] = true, -- Battle Staff
	[2361] = true, -- Battleworn Hammer
	[2025] = true, -- Bearded Axe
	[3190] = true, -- Beatstick
	[35] = true, -- Bent Staff
	[4563] = true, -- Billy Club
	[3024] = true, -- BKP 2700 "Enforcer"
	[3025] = true, -- BKP 42 "Ultra"
	[5239] = true, -- Blackbone Wand
	[4938] = true, -- Blemished Wooden Staff
	[4965] = true, -- Bloodhoof Hand Axe
	[3225] = true, -- Bloodstained Knife
	[5777] = true, -- Brave's Axe
	[2479] = true, -- Broad Axe
	[2520] = true, -- Broadsword
	[6651] = true, -- Broken Wine Bottle
	[2849] = true, -- Bronze Axe
	[2848] = true, -- Bronze Mace
	[2850] = true, -- Bronze Shortsword
	[2523] = true, -- Bullova
	[5210] = true, -- Burning Wand
	[8179] = true, -- Cadet's Bow
	[10547] = true, -- Camping Knife
	[3445] = true, -- Ceremonial Knife
	[3443] = true, -- Ceremonial Tomahawk
	[1198] = true, -- Claymore
	[2029] = true, -- Cleaver
	[2130] = true, -- Club
	[5236] = true, -- Combustible Wand
	[7955] = true, -- Copper Claymore
	[7166] = true, -- Copper Dagger
	[2844] = true, -- Copper Mace
	[2847] = true, -- Copper Shortsword
	[2522] = true, -- Crescent Axe
	[1388] = true, -- Crooked Staff
	[2492] = true, -- Cudgel
	[851] = true, -- Cutlass
	[922] = true, -- Dacian Falx
	[3295] = true, -- Deadman Blade
	[3293] = true, -- Deadman Cleaver
	[3294] = true, -- Deadman Club
	[3296] = true, -- Deadman Dagger
	[3455] = true, -- Deathstalker Shortsword
	[2139] = true, -- Dirk
	[927] = true, -- Double Axe
	[2499] = true, -- Double-bladed Axe
	[4961] = true, -- Dreamwatcher Staff
	[7094] = true, -- Driftwood Branch
	[1384] = true, -- Dull Blade
	[5211] = true, -- Dusk Wand
	[5776] = true, -- Elder's Cane
	[2024] = true, -- Espadon
	[3277] = true, -- Executor Staff
	[2528] = true, -- Falchion
	[3335] = true, -- Farmer's Broom
	[3334] = true, -- Farmer's Shovel
	[15808] = true, -- Fine Light Crossbow
	[4560] = true, -- Fine Scimitar
	[925] = true, -- Flail
	[2521] = true, -- Flamberge
	[766] = true, -- Flanged Mace
	[5779] = true, -- Forsaken Bastard Sword
	[3268] = true, -- Forsaken Dagger
	[3269] = true, -- Forsaken Maul
	[3267] = true, -- Forsaken Shortsword
	[2530] = true, -- Francisca
	[2067] = true, -- Frostbit Staff
	[2259] = true, -- Frostmane Club
	[2260] = true, -- Frostmane Hand Axe
	[2258] = true, -- Frostmane Shortsword
	[2257] = true, -- Frostmane Staff
	[1197] = true, -- Giant Mace
	[2488] = true, -- Gladius
	[5209] = true, -- Gloom Wand
	[1010] = true, -- Gnarled Short Staff
	[2030] = true, -- Gnarled Staff
	[2531] = true, -- Great Axe
	[2028] = true, -- Hammer
	[2134] = true, -- Hand Axe
	[3661] = true, -- Handcrafted Staff
	[4932] = true, -- Harpy Wing Clipper
	[853] = true, -- Hatchet
	[15809] = true, -- Heavy Crossbow
	[3027] = true, -- Heavy Recurve Bow
	[15811] = true, -- Heavy Spear
	[4931] = true, -- Hickory Shortbow
	[2506] = true, -- Hornwood Recurve Bow
	[2511] = true, -- Hunter's Boomstick
	[8181] = true, -- Hunting Rifle
	[2482] = true, -- Inferior Tomahawk
	[2207] = true, -- Jambiya
	[18610] = true, -- Keen Machete
	[778] = true, -- Kobold Excavation Pick
	[1389] = true, -- Kobold Mining Mallet
	[1195] = true, -- Kobold Mining Shovel
	[2209] = true, -- Kris
	[2507] = true, -- Laminated Recurve Bow
	[2491] = true, -- Large Axe
	[3023] = true, -- Large Bore Blunderbuss
	[2480] = true, -- Large Club
	[2486] = true, -- Large Stone Mace
	[19292] = true, -- Last Month's Mutton
	[19293] = true, -- Last Year's Mutton
	[15909] = true, -- Left-Handed Blades
	[15906] = true, -- Left-Handed Brass Knuckles
	[15907] = true, -- Left-Handed Claw
	[15807] = true, -- Light Crossbow
	[2500] = true, -- Light Hammer
	[12448] = true, -- Light Hunting Rifle
	[4840] = true, -- Long Bayonet
	[767] = true, -- Long Bo Staff
	[928] = true, -- Long Staff
	[3028] = true, -- Longbow
	[923] = true, -- Longsword
	[768] = true, -- Lumberjack Axe
	[852] = true, -- Mace
	[2526] = true, -- Main Gauche
	[20853] = true, -- Mana Gathering Staff
	[924] = true, -- Maul
	[2224] = true, -- Militia Dagger
	[5580] = true, -- Militia Hammer
	[1159] = true, -- Militia Quarterstaff
	[1161] = true, -- Militia Shortsword
	[5579] = true, -- Militia Warhammer
	[2532] = true, -- Morning Star
	[20981] = true, -- Neophyte's Mace
	[2508] = true, -- Old Blunderbuss
	[6741] = true, -- Orcish War Sword
	[2509] = true, -- Ornate Blunderbuss
	[8182] = true, -- Pellet Rifle
	[2481] = true, -- Peon Sword
	[5347] = true, -- Pestilent Wand
	[5238] = true, -- Pitchwood Wand
	[2057] = true, -- Pitted Defias Shortsword
	[2505] = true, -- Polished Shortbow
	[2208] = true, -- Poniard
	[8177] = true, -- Practice Sword
	[12449] = true, -- Primitive Bow
	[4924] = true, -- Primitive Club
	[4925] = true, -- Primitive Hand Blade
	[4923] = true, -- Primitive Hatchet
	[5778] = true, -- Primitive Walking Stick
	[5605] = true, -- Pruning Knife
	[3262] = true, -- Putrid Wooden Hammer
	[854] = true, -- Quarter Staff
	[2496] = true, -- Raider Shortsword
	[20977] = true, -- Recruit's Shortsword
	[3026] = true, -- Reinforced Bow
	[15904] = true, -- Right-Handed Blades
	[15905] = true, -- Right-Handed Brass Knuckles
	[15903] = true, -- Right-Handed Claw
	[6206] = true, -- Rock Chipper
	[2026] = true, -- Rock Hammer
	[1382] = true, -- Rock Mace
	[2065] = true, -- Rockjaw Blade
	[2282] = true, -- Rodentia Shortsword
	[2534] = true, -- Rondel
	[2483] = true, -- Rough Broad Axe
	[2497] = true, -- Rusted Claymore
	[2027] = true, -- Scimitar
	[2128] = true, -- Scratched Claymore
	[2502] = true, -- Scuffed Dagger
	[1011] = true, -- Sharp Axe
	[20982] = true, -- Sharp Dagger
	[2225] = true, -- Sharp Kitchen Knife
	[3319] = true, -- Short Sabre
	[15810] = true, -- Short Spear
	[2132] = true, -- Short Staff
	[2131] = true, -- Shortsword
	[4565] = true, -- Simple Dagger
	[2066] = true, -- Skull Hatchet
	[4302] = true, -- Small Green Dagger
	[2484] = true, -- Small Knife
	[2498] = true, -- Small Tomahawk
	[2055] = true, -- Small Wooden Hammer
	[5208] = true, -- Smoldering Wand
	[5581] = true, -- Smooth Walking Staff
	[2510] = true, -- Solid Blunderbuss
	[1158] = true, -- Solid Metal Club
	[3329] = true, -- Spiked Wooden Plank
	[2485] = true, -- Splintered Board
	[20910] = true, -- Stiff Shortbow
	[2494] = true, -- Stiletto
	[781] = true, -- Stone Gnoll Hammer
	[1383] = true, -- Stone Tomahawk
	[2268] = true, -- Stonesplinter Blade
	[3071] = true, -- Striking Hatchet
	[1913] = true, -- Studded Blackjack
	[20837] = true, -- Sunstrider Axe
	[20838] = true, -- Sunstrider Bow
	[20836] = true, -- Sunstrider Dagger
	[20840] = true, -- Sunstrider Mace
	[20839] = true, -- Sunstrider Staff
	[20835] = true, -- Sunstrider Sword
	[1196] = true, -- Tabar
	[2754] = true, -- Tarnished Bastard Sword
	[5595] = true, -- Thicket Hammer
	[1386] = true, -- Thistlewood Axe
	[5586] = true, -- Thistlewood Blade
	[12447] = true, -- Thistlewood Bow
	[5392] = true, -- Thistlewood Dagger
	[10544] = true, -- Thistlewood Maul
	[5393] = true, -- Thistlewood Staff
	[2490] = true, -- Tomahawk
	[2064] = true, -- Trogg Club
	[2787] = true, -- Trogg Dagger
	[2054] = true, -- Trogg Hand Axe
	[2524] = true, -- Truncheon
	[2489] = true, -- Two-handed Sword
	[14083] = true, -- Tyrande's Staff
	[3325] = true, -- Vile Fin Battle Axe
	[3327] = true, -- Vile Fin Oracle Staff
	[2495] = true, -- Walking Stick
	[2525] = true, -- War Hammer
	[2533] = true, -- War Maul
	[2535] = true, -- War Staff
	[20979] = true, -- Warder's Axe
	[20980] = true, -- Warder's Shortbow
	[1008] = true, -- Well-used Sword
	[2137] = true, -- Whittling Knife
	[3189] = true, -- Wood Chopper
	[2493] = true, -- Wooden Mallet
	[2501] = true, -- Wooden Warhammer
	[37] = true, -- Worn Axe
	[12282] = true, -- Worn Battleaxe
	[2092] = true, -- Worn Dagger
	[36] = true, -- Worn Mace
	[2504] = true, -- Worn Shortbow
	[25] = true, -- Worn Shortsword
	[2529] = true, -- Zweihander

	--------------------------------------------------------------------------------
	-- 02. World of Warcraft : The Burning Crusade
	--------------------------------------------------------------------------------

	[30758] = true, -- Aldor Guardian Rifle
	[23923] = true, -- Amani Sacrificial Dagger
	[29518] = true, -- Amani Scimitar
	[30754] = true, -- Ancient Bone Mace
	[25872] = true, -- Balanced Throwing Dagger
	[23346] = true, -- Battleworn Claymore
	[29014] = true, -- Blacksteel Throwing Dagger
	[23372] = true, -- Bloodhawk Claymore
	[24433] = true, -- Crossbow of the Albatross
	[25861] = true, -- Crude Throwing Axe
	[25875] = true, -- Deadly Throwing Axe
	[30757] = true, -- Draenic Light Crossbow
	[30749] = true, -- Draenic Sparring Blade
	[30750] = true, -- Draenic Warblade
	[23390] = true, -- Exodar Bastard Sword
	[24441] = true, -- Exodar Crossbow
	[23391] = true, -- Exodar Dagger
	[23392] = true, -- Exodar Maul
	[23393] = true, -- Exodar Shortsword
	[25553] = true, -- Exodar Staff
	[22958] = true, -- Farstrider Sword
	[25876] = true, -- Gleaming Throwing Axe
	[29009] = true, -- Heavy Throwing Dagger
	[29013] = true, -- Jagged Throwing Axe
	[25873] = true, -- Keen Throwing Knife
	[23370] = true, -- Ley-Keeper's Blade
	[28979] = true, -- Light Throwing Knife
	[23373] = true, -- Long Knife
	[30752] = true, -- Mag'hari Battleaxe
	[30751] = true, -- Mag'hari Light Axe
	[30759] = true, -- Mag'hari Light Recurve
	[25877] = true, -- Master's Throwing Dagger
	[24431] = true, -- McWeaksauce's Meat Tenderizer
	[22963] = true, -- Ranger's Pocketknife
	[22956] = true, -- Rusty Mace
	[22957] = true, -- Rusty Sin'dorei Sword
	[24430] = true, -- Seafarer's Blade
	[29008] = true, -- Sharp Throwing Axe
	[23396] = true, -- Slightly Used Ranger's Blade
	[22959] = true, -- Smooth Metal Staff
	[24434] = true, -- The Discipline Stick
	[24432] = true, -- The Shell Cracker
	[23371] = true, -- Velania's Walking Stick
	[24100] = true, -- Warder's Dagger
	[23347] = true, -- Weathered Crossbow
	[29007] = true, -- Weighted Throwing Axe
	[29010] = true, -- Wicked Throwing Dagger
	[23398] = true, -- Worn Ranger's Bow

	--------------------------------------------------------------------------------
	-- 03. World of Warcraft : Wrath of the Lich King
	--------------------------------------------------------------------------------

	[41752] = true, -- Brunnhildar Axe
	[41746] = true, -- Brunnhildar Bow
	[43601] = true, -- Brunnhildar Great Axe
	[43600] = true, -- Brunnhildar Harpoon
	[44642] = true, -- Dalaran Axe
	[44643] = true, -- Dalaran Bow
	[44637] = true, -- Dalaran Crossbow
	[44636] = true, -- Dalaran Cudgel
	[44652] = true, -- Dalaran Dagger
	[44644] = true, -- Dalaran Dart
	[44640] = true, -- Dalaran Great Axe
	[44639] = true, -- Dalaran Greatsword
	[44645] = true, -- Dalaran Hammer
	[44641] = true, -- Dalaran Knuckles
	[44635] = true, -- Dalaran Rifle
	[44654] = true, -- Dalaran Spear
	[44655] = true, -- Dalaran Stave
	[44638] = true, -- Dalaran Sword
	[40005] = true, -- Forsaken Blade
	[40004] = true, -- Forsaken Greatsword
	[40006] = true, -- Forsaken Sword
	[40007] = true, -- Forsaken Throwing Knife
	[34859] = true, -- Razor Sharp Fillet Knife
	[50057] = true, -- Sharp Dirk
	[39987] = true, -- Tuskarr Fishing Spear
	[39995] = true, -- Tuskarr Javelin
	[40019] = true, -- Wand of Amber
	[40021] = true, -- Wand of Crystal
	[40020] = true, -- Wand of Jade
	[40018] = true, -- Wand of Onyx
	[39522] = true, -- Wolvar Shortbow
	[50055] = true, -- Worn Dirk
	[49778] = true, -- Worn Greatsword

	--------------------------------------------------------------------------------
	-- ARMOR
	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	-- 01. World of Warcraft
	--------------------------------------------------------------------------------

	[14115] = true, -- Aboriginal Bands
	[14116] = true, -- Aboriginal Cape
	[14169] = true, -- Aboriginal Shoulder Pads
	[3833] = true, -- Adept's Cloak
	[4672] = true, -- Ancestral Belt
	[3289] = true, -- Ancestral Boots
	[3642] = true, -- Ancestral Bracers
	[4671] = true, -- Ancestral Cloak
	[3290] = true, -- Ancestral Gloves
	[5936] = true, -- Animal Skin Belt
	[3442] = true, -- Apprentice Sash
	[5394] = true, -- Archery Training Gloves
	[2419] = true, -- Augmented Chain Belt
	[2420] = true, -- Augmented Chain Boots
	[2421] = true, -- Augmented Chain Bracers
	[2422] = true, -- Augmented Chain Gloves
	[3891] = true, -- Augmented Chain Helm
	[2418] = true, -- Augmented Chain Leggings
	[2417] = true, -- Augmented Chain Vest
	[7048] = true, -- Azure Silk Hood
	[17187] = true, -- Banded Buckler
	[1193] = true, -- Banded Buckler
	[10405] = true, -- Bandit Shoulders
	[4687] = true, -- Barbaric Cloth Belt
	[3644] = true, -- Barbaric Cloth Bracers
	[4686] = true, -- Barbaric Cloth Cloak
	[6555] = true, -- Bard's Cloak
	[10656] = true, -- Barkmail Vest
	[5319] = true, -- Bashing Pauldrons
	[11847] = true, -- Battered Cloak
	[2371] = true, -- Battered Leather Belt
	[2373] = true, -- Battered Leather Boots
	[2374] = true, -- Battered Leather Bracers
	[2375] = true, -- Battered Leather Gloves
	[2370] = true, -- Battered Leather Harness
	[2372] = true, -- Battered Leather Pants
	[3279] = true, -- Battle Chain Boots
	[3280] = true, -- Battle Chain Bracers
	[4668] = true, -- Battle Chain Cloak
	[4669] = true, -- Battle Chain Girdle
	[3281] = true, -- Battle Chain Gloves
	[6526] = true, -- Battle Harness
	[3650] = true, -- Battle Shield
	[4920] = true, -- Battleworn Cape
	[4917] = true, -- Battleworn Chain Leggings
	[4914] = true, -- Battleworn Leather Gloves
	[14088] = true, -- Beaded Cloak
	[14093] = true, -- Beaded Cord
	[14087] = true, -- Beaded Cuffs
	[14089] = true, -- Beaded Gloves
	[14086] = true, -- Beaded Sandals
	[6185] = true, -- Bear Shawl
	[1154] = true, -- Belt of the People's Militia
	[2069] = true, -- Black Bear Hide Vest
	[6058] = true, -- Blackened Leather Belt
	[1445] = true, -- Blackrock Pauldrons
	[15490] = true, -- Bloodspattered Cloak
	[15496] = true, -- Bloodspattered Shoulder Pads
	[18612] = true, -- Bloody Chain Boots
	[2547] = true, -- Boar Handler Gloves
	[7095] = true, -- Bog Boots
	[5940] = true, -- Bone Buckler
	[3320] = true, -- Bonecaster Sash
	[4968] = true, -- Bound Harness
	[710] = true, -- Bracers of the People's Militia
	[3303] = true, -- Brackwater Bracers
	[4680] = true, -- Brackwater Cloak
	[3304] = true, -- Brackwater Gauntlets
	[4681] = true, -- Brackwater Girdle
	[5941] = true, -- Brass Scale Pants
	[1182] = true, -- Brass-studded Bracers
	[2424] = true, -- Brigandine Belt
	[2426] = true, -- Brigandine Boots
	[2427] = true, -- Brigandine Bracers
	[2428] = true, -- Brigandine Gloves
	[3894] = true, -- Brigandine Helm
	[2425] = true, -- Brigandine Leggings
	[2423] = true, -- Brigandine Vest
	[4343] = true, -- Brown Linen Pants
	[2568] = true, -- Brown Linen Vest
	[14170] = true, -- Buccaneer's Mantle
	[6523] = true, -- Buckled Harness
	[2617] = true, -- Burning Robes
	[4694] = true, -- Burnished Pauldrons
	[15895] = true, -- Burnt Buckler
	[4665] = true, -- Burnt Cloak
	[3158] = true, -- Burnt Hide Bracers
	[4666] = true, -- Burnt Leather Belt
	[2963] = true, -- Burnt Leather Boots
	[3200] = true, -- Burnt Leather Bracers
	[2964] = true, -- Burnt Leather Gloves
	[9758] = true, -- Cadet Belt
	[9759] = true, -- Cadet Boots
	[9760] = true, -- Cadet Bracers
	[9761] = true, -- Cadet Cloak
	[9762] = true, -- Cadet Gauntlets
	[5398] = true, -- Canopy Leggings
	[860] = true, -- Cavalier's Boots
	[4692] = true, -- Ceremonial Cloak
	[3311] = true, -- Ceremonial Leather Ankleguards
	[4693] = true, -- Ceremonial Leather Belt
	[3312] = true, -- Ceremonial Leather Bracers
	[847] = true, -- Chainmail Armor
	[1845] = true, -- Chainmail Belt
	[849] = true, -- Chainmail Boots
	[1846] = true, -- Chainmail Bracers
	[850] = true, -- Chainmail Gloves
	[848] = true, -- Chainmail Pants
	[15472] = true, -- Charger's Belt
	[15474] = true, -- Charger's Bindings
	[15473] = true, -- Charger's Boots
	[15475] = true, -- Charger's Cloak
	[15476] = true, -- Charger's Handwraps
	[15478] = true, -- Charger's Shield
	[4937] = true, -- Charging Buckler
	[2615] = true, -- Chromatic Robe
	[15400] = true, -- Clamshell Bracers
	[3437] = true, -- Clasped Belt
	[4972] = true, -- Cliff Runner Boots
	[6063] = true, -- Cold Steel Gauntlets
	[2853] = true, -- Copper Bracers
	[3469] = true, -- Copper Chain Boots
	[2852] = true, -- Copper Chain Pants
	[5590] = true, -- Cord Bracers
	[2122] = true, -- Cracked Leather Belt
	[2123] = true, -- Cracked Leather Boots
	[2124] = true, -- Cracked Leather Bracers
	[2125] = true, -- Cracked Leather Gloves
	[2126] = true, -- Cracked Leather Pants
	[2127] = true, -- Cracked Leather Vest
	[5593] = true, -- Crag Buckler
	[2451] = true, -- Crested Heater Shield
	[7062] = true, -- Crimson Silk Pantaloons
	[7058] = true, -- Crimson Silk Vest
	[3447] = true, -- Cryptwalker Boots
	[2142] = true, -- Cuirboulli Belt
	[2143] = true, -- Cuirboulli Boots
	[2144] = true, -- Cuirboulli Bracers
	[2145] = true, -- Cuirboulli Gloves
	[2146] = true, -- Cuirboulli Pants
	[2141] = true, -- Cuirboulli Vest
	[236] = true, -- Cured Leather Armor
	[1849] = true, -- Cured Leather Belt
	[238] = true, -- Cured Leather Boots
	[1850] = true, -- Cured Leather Bracers
	[239] = true, -- Cured Leather Gloves
	[237] = true, -- Cured Leather Pants
	[9601] = true, -- Cushioned Boots
	[5110] = true, -- Dalaran Wizard's Robe
	[5108] = true, -- Dark Iron Leather
	[2315] = true, -- Dark Leather Boots
	[2316] = true, -- Dark Leather Cloak
	[20991] = true, -- Daylight Cloak
	[3276] = true, -- Deathguard Buckler
	[6579] = true, -- Defender Spaulders
	[17183] = true, -- Dented Buckler
	[1166] = true, -- Dented Buckler
	[4936] = true, -- Dirt-trodden Boots
	[5458] = true, -- Dirtwood Belt
	[1835] = true, -- Dirty Leather Belt
	[210] = true, -- Dirty Leather Boots
	[1836] = true, -- Dirty Leather Bracers
	[714] = true, -- Dirty Leather Gloves
	[209] = true, -- Dirty Leather Pants
	[85] = true, -- Dirty Leather Vest
	[7351] = true, -- Disciple's Boots
	[7350] = true, -- Disciple's Bracers
	[6514] = true, -- Disciple's Cloak
	[6515] = true, -- Disciple's Gloves
	[6513] = true, -- Disciple's Sash
	[4962] = true, -- Double-layered Gloves
	[2613] = true, -- Double-stitched Robes
	[4314] = true, -- Double-stitched Woolen Shoulders
	[5405] = true, -- Draped Cloak
	[3152] = true, -- Driving Gloves
	[1201] = true, -- Dull Heater Shield
	[6189] = true, -- Durable Chain Shoulders
	[4921] = true, -- Dust-covered Leggings
	[79] = true, -- Dwarven Cloth Britches
	[6176] = true, -- Dwarven Kite Shield
	[61] = true, -- Dwarven Leather Pants
	[1183] = true, -- Elastic Wristguards
	[2435] = true, -- Embroidered Armor
	[3587] = true, -- Embroidered Belt
	[2438] = true, -- Embroidered Boots
	[3588] = true, -- Embroidered Bracers
	[2440] = true, -- Embroidered Gloves
	[3892] = true, -- Embroidered Hat
	[2437] = true, -- Embroidered Pants
	[3070] = true, -- Ensign Cloak
	[11191] = true, -- Farmer's Boots
	[4190] = true, -- Feathered Armor
	[4195] = true, -- Feathered Boots
	[4194] = true, -- Feathered Bracers
	[4191] = true, -- Feathered Leggings
	[5419] = true, -- Feral Bracers
	[15313] = true, -- Feral Shoulder Pads
	[4246] = true, -- Fine Leather Belt
	[2307] = true, -- Fine Leather Boots
	[6202] = true, -- Fingerless Gloves
	[11848] = true, -- Flax Belt
	[3274] = true, -- Flax Boots
	[6060] = true, -- Flax Bracers
	[3275] = true, -- Flax Gloves
	[3270] = true, -- Flax Vest
	[4969] = true, -- Fortified Bindings
	[2109] = true, -- Frostmane Chain Vest
	[2108] = true, -- Frostmane Leather Vest
	[5606] = true, -- Gardening Gloves
	[3323] = true, -- Ghostly Bracers
	[18611] = true, -- Gnarlpine Leggings
	[1213] = true, -- Gnoll Kindred Bracers
	[2905] = true, -- Goat Fur Cloak
	[3321] = true, -- Gray Fur Booties
	[6061] = true, -- Graystone Bracers
	[20997] = true, -- Green Chain Boots
	[20999] = true, -- Green Chain Gauntlets
	[20994] = true, -- Green Chain Vest
	[4308] = true, -- Green Linen Bracers
	[2582] = true, -- Green Woolen Vest
	[15302] = true, -- Grizzly Belt
	[15297] = true, -- Grizzly Bracers
	[15299] = true, -- Grizzly Cape
	[15300] = true, -- Grizzly Gloves
	[15301] = true, -- Grizzly Slippers
	[6525] = true, -- Grunt's Harness
	[5966] = true, -- Guardian Gloves
	[9752] = true, -- Gypsy Bands
	[9754] = true, -- Gypsy Cloak
	[9755] = true, -- Gypsy Gloves
	[9751] = true, -- Gypsy Sandals
	[9750] = true, -- Gypsy Sash
	[4944] = true, -- Handsewn Cloak
	[4237] = true, -- Handstitched Leather Belt
	[2302] = true, -- Handstitched Leather Boots
	[7277] = true, -- Handstitched Leather Bracers
	[7276] = true, -- Handstitched Leather Cloak
	[2303] = true, -- Handstitched Leather Pants
	[5957] = true, -- Handstitched Leather Vest
	[6062] = true, -- Heavy Cord Bracers
	[4307] = true, -- Heavy Linen Gloves
	[2448] = true, -- Heavy Pavise
	[837] = true, -- Heavy Weave Armor
	[3589] = true, -- Heavy Weave Belt
	[3590] = true, -- Heavy Weave Bracers
	[839] = true, -- Heavy Weave Gloves
	[838] = true, -- Heavy Weave Pants
	[840] = true, -- Heavy Weave Shoes
	[3732] = true, -- Hooded Cowl
	[4690] = true, -- Hunting Belt
	[2975] = true, -- Hunting Boots
	[3207] = true, -- Hunting Bracers
	[4689] = true, -- Hunting Cloak
	[763] = true, -- Ice-covered Bracers
	[6509] = true, -- Infantry Belt
	[6506] = true, -- Infantry Boots
	[6507] = true, -- Infantry Bracers
	[6508] = true, -- Infantry Cloak
	[6510] = true, -- Infantry Gauntlets
	[4700] = true, -- Inscribed Leather Spaulders
	[6177] = true, -- Ironwrought Bracers
	[5612] = true, -- Ivy Cuffs
	[2326] = true, -- Ivy-weave Bracers
	[4922] = true, -- Jagged Chain Vest
	[4663] = true, -- Journeyman's Belt
	[2959] = true, -- Journeyman's Boots
	[3641] = true, -- Journeyman's Bracers
	[4662] = true, -- Journeyman's Cloak
	[2960] = true, -- Journeyman's Gloves
	[2446] = true, -- Kite Shield
	[3602] = true, -- Knitted Belt
	[3603] = true, -- Knitted Bracers
	[793] = true, -- Knitted Gloves
	[794] = true, -- Knitted Pants
	[792] = true, -- Knitted Sandals
	[795] = true, -- Knitted Tunic
	[9600] = true, -- Lace Pants
	[2445] = true, -- Large Metal Shield
	[2129] = true, -- Large Round Shield
	[20912] = true, -- Large Shield
	[1200] = true, -- Large Wooden Shield
	[2690] = true, -- Latched Belt
	[60] = true, -- Layered Tunic
	[2398] = true, -- Light Chain Armor
	[2399] = true, -- Light Chain Belt
	[2401] = true, -- Light Chain Boots
	[2402] = true, -- Light Chain Bracers
	[2403] = true, -- Light Chain Gloves
	[2400] = true, -- Light Chain Leggings
	[20990] = true, -- Light Cloth Armor
	[20989] = true, -- Light Cloth Belt
	[20988] = true, -- Light Cloth Bracers
	[20987] = true, -- Light Cloth Gloves
	[20986] = true, -- Light Cloth Pants
	[20985] = true, -- Light Cloth Shoes
	[20911] = true, -- Light Guard
	[7281] = true, -- Light Leather Bracers
	[2110] = true, -- Light Magesmith Robe
	[2392] = true, -- Light Mail Armor
	[2393] = true, -- Light Mail Belt
	[2395] = true, -- Light Mail Boots
	[2396] = true, -- Light Mail Bracers
	[2397] = true, -- Light Mail Gloves
	[2394] = true, -- Light Mail Leggings
	[4929] = true, -- Light Scorpid Armor
	[4946] = true, -- Lightweight Boots
	[7026] = true, -- Linen Belt
	[2569] = true, -- Linen Boots
	[2570] = true, -- Linen Cloak
	[1359] = true, -- Lion-stamped Gloves
	[6201] = true, -- Lithe Boots
	[2112] = true, -- Lumberjack Jerkin
	[15015] = true, -- Lupine Cloak
	[15013] = true, -- Lupine Cuffs
	[15019] = true, -- Lupine Mantle
	[20993] = true, -- Lynxskin Gloves
	[20913] = true, -- Medium Guard
	[3331] = true, -- Melrache's Cape
	[17189] = true, -- Metal Buckler
	[2443] = true, -- Metal Buckler
	[2249] = true, -- Militia Buckler
	[5589] = true, -- Moss-covered Gauntlets
	[2898] = true, -- Mountaineer Chestpiece
	[14368] = true, -- Mystic's Shoulder Pads
	[14095] = true, -- Native Bands
	[14098] = true, -- Native Cloak
	[14102] = true, -- Native Handwraps
	[14110] = true, -- Native Sandals
	[14099] = true, -- Native Sash
	[12299] = true, -- Netted Gloves
	[4954] = true, -- Nomadic Belt
	[4908] = true, -- Nomadic Bracers
	[10636] = true, -- Nomadic Gloves
	[6059] = true, -- Nomadic Vest
	[15402] = true, -- Noosegrip Gauntlets
	[3153] = true, -- Oil-stained Cloak
	[2165] = true, -- Old Blanchy's Blanket
	[2173] = true, -- Old Leather Belt
	[17190] = true, -- Ornate Buckler
	[2186] = true, -- Outfitter Belt
	[2691] = true, -- Outfitter Boots
	[11192] = true, -- Outfitter Gloves
	[15505] = true, -- Outrunner's Pauldrons
	[2160] = true, -- Padded Armor
	[3591] = true, -- Padded Belt
	[2156] = true, -- Padded Boots
	[3592] = true, -- Padded Bracers
	[2158] = true, -- Padded Gloves
	[2159] = true, -- Padded Pants
	[14157] = true, -- Pagan Mantle
	[4913] = true, -- Painted Chain Belt
	[4910] = true, -- Painted Chain Gloves
	[10635] = true, -- Painted Chain Leggings
	[2237] = true, -- Patched Pants
	[3332] = true, -- Perrine's Boots
	[6078] = true, -- Pikeman Shield
	[6517] = true, -- Pioneer Belt
	[6518] = true, -- Pioneer Boots
	[6519] = true, -- Pioneer Bracers
	[7109] = true, -- Pioneer Buckler
	[6520] = true, -- Pioneer Cloak
	[6521] = true, -- Pioneer Gloves
	[2612] = true, -- Plain Robe
	[4973] = true, -- Plains Hunter Wristguards
	[8094] = true, -- Platemail Armor
	[8088] = true, -- Platemail Belt
	[8089] = true, -- Platemail Boots
	[8090] = true, -- Platemail Bracers
	[8091] = true, -- Platemail Gloves
	[8092] = true, -- Platemail Helm
	[8093] = true, -- Platemail Leggings
	[2148] = true, -- Polished Scale Belt
	[2149] = true, -- Polished Scale Boots
	[2150] = true, -- Polished Scale Bracers
	[2151] = true, -- Polished Scale Gloves
	[2152] = true, -- Polished Scale Leggings
	[2153] = true, -- Polished Scale Vest
	[15005] = true, -- Primal Bands
	[15003] = true, -- Primal Belt
	[15004] = true, -- Primal Boots
	[15006] = true, -- Primal Buckler
	[15007] = true, -- Primal Cape
	[15008] = true, -- Primal Mitts
	[3453] = true, -- Quilted Bracers
	[719] = true, -- Rabbit Handler Gloves
	[10407] = true, -- Raider's Shoulderpads
	[5591] = true, -- Rain-spotted Cape
	[4906] = true, -- Rainwalker Boots
	[6147] = true, -- Ratty Old Belt
	[3454] = true, -- Reconnaissance Boots
	[983] = true, -- Red Linen Sash
	[2471] = true, -- Reinforced Leather Belt
	[2473] = true, -- Reinforced Leather Boots
	[2474] = true, -- Reinforced Leather Bracers
	[3893] = true, -- Reinforced Leather Cap
	[2475] = true, -- Reinforced Leather Gloves
	[2472] = true, -- Reinforced Leather Pants
	[2470] = true, -- Reinforced Leather Vest
	[2580] = true, -- Reinforced Linen Cape
	[17192] = true, -- Reinforced Targe
	[2442] = true, -- Reinforced Targe
	[4315] = true, -- Reinforced Woolen Shoulders
	[17188] = true, -- Ringed Buckler
	[2441] = true, -- Ringed Buckler
	[6713] = true, -- Ripped Pants
	[14126] = true, -- Ritual Amice
	[11852] = true, -- Roamer's Leggings
	[2614] = true, -- Robe of Apprenticeship
	[6350] = true, -- Rough Bronze Boots
	[2866] = true, -- Rough Bronze Cuirass
	[3480] = true, -- Rough Bronze Shoulders
	[10421] = true, -- Rough Copper Vest
	[1839] = true, -- Rough Leather Belt
	[796] = true, -- Rough Leather Boots
	[1840] = true, -- Rough Leather Bracers
	[797] = true, -- Rough Leather Gloves
	[798] = true, -- Rough Leather Pants
	[799] = true, -- Rough Leather Vest
	[4970] = true, -- Rough-hewn Kodo Leggings
	[17185] = true, -- Round Buckler
	[2377] = true, -- Round Buckler
	[2546] = true, -- Royal Frostmane Girdle
	[2240] = true, -- Rugged Cape
	[3273] = true, -- Rugged Mail Vest
	[2854] = true, -- Runed Copper Bracers
	[3472] = true, -- Runed Copper Gauntlets
	[3593] = true, -- Russet Belt
	[2432] = true, -- Russet Boots
	[3594] = true, -- Russet Bracers
	[2434] = true, -- Russet Gloves
	[3889] = true, -- Russet Hat
	[2431] = true, -- Russet Pants
	[2429] = true, -- Russet Vest
	[2444] = true, -- Rusted Buckler
	[2387] = true, -- Rusted Chain Belt
	[2389] = true, -- Rusted Chain Boots
	[2390] = true, -- Rusted Chain Bracers
	[2391] = true, -- Rusted Chain Gloves
	[2388] = true, -- Rusted Chain Leggings
	[2386] = true, -- Rusted Chain Vest
	[2172] = true, -- Rustic Belt
	[11849] = true, -- Rustmetal Bracers
	[1479] = true, -- Salma's Oven Mitts
	[15398] = true, -- Sandcomber Boots
	[4928] = true, -- Sandrunner Wristguards
	[1853] = true, -- Scalemail Belt
	[287] = true, -- Scalemail Boots
	[1852] = true, -- Scalemail Bracers
	[718] = true, -- Scalemail Gloves
	[286] = true, -- Scalemail Pants
	[285] = true, -- Scalemail Vest
	[3260] = true, -- Scarlet Initiate Robes
	[11851] = true, -- Scavenger Tunic
	[5618] = true, -- Scout's Cloak
	[6588] = true, -- Scouting Spaulders
	[4933] = true, -- Seasoned Fighter's Cloak
	[10655] = true, -- Sedgeweed Britches
	[4698] = true, -- Seer's Mantle
	[5939] = true, -- Sewing Gloves
	[5592] = true, -- Shackled Girdle
	[6566] = true, -- Shimmering Amice
	[2616] = true, -- Shimmering Silk Robes
	[11850] = true, -- Short Duskbat Cape
	[3151] = true, -- Siege Brigade Vest
	[7050] = true, -- Silk Headband
	[2618] = true, -- Silver Dress Robes
	[3224] = true, -- Silver-lined Bracers
	[9744] = true, -- Simple Bands
	[9745] = true, -- Simple Cape
	[9742] = true, -- Simple Cord
	[9746] = true, -- Simple Gloves
	[10047] = true, -- Simple Kilt
	[10046] = true, -- Simple Linen Boots
	[10045] = true, -- Simple Linen Pants
	[9743] = true, -- Simple Shoes
	[17184] = true, -- Small Shield
	[2133] = true, -- Small Shield
	[17186] = true, -- Small Targe
	[1167] = true, -- Small Targe
	[6173] = true, -- Snow Boots
	[2114] = true, -- Snowy Robe
	[80] = true, -- Soft Fur-lined Shoes
	[4919] = true, -- Soft Wool Belt
	[4915] = true, -- Soft Wool Boots
	[4916] = true, -- Soft Wool Vest
	[6549] = true, -- Soldier's Cloak
	[4261] = true, -- Solliden's Trousers
	[4684] = true, -- Spellbinder Belt
	[2971] = true, -- Spellbinder Boots
	[3643] = true, -- Spellbinder Bracers
	[4683] = true, -- Spellbinder Cloak
	[2972] = true, -- Spellbinder Gloves
	[3328] = true, -- Spider Web Robe
	[4951] = true, -- Squealer's Belt
	[4263] = true, -- Standard Issue Shield
	[11187] = true, -- Stemleaf Bracers
	[2900] = true, -- Stone Buckler
	[5109] = true, -- Stonesplinter Rags
	[1360] = true, -- Stormwind Chain Gloves
	[21001] = true, -- Striding Pants
	[2464] = true, -- Studded Belt
	[2467] = true, -- Studded Boots
	[2468] = true, -- Studded Bracers
	[2463] = true, -- Studded Doublet
	[2469] = true, -- Studded Gloves
	[3890] = true, -- Studded Hat
	[6524] = true, -- Studded Leather Harness
	[2465] = true, -- Studded Pants
	[3834] = true, -- Sturdy Cloth Trousers
	[2327] = true, -- Sturdy Leather Bracers
	[20920] = true, -- Sun Cured Belt
	[20921] = true, -- Sun Cured Boots
	[20922] = true, -- Sun Cured Bracers
	[20923] = true, -- Sun Cured Gloves
	[20924] = true, -- Sun Cured Pants
	[20925] = true, -- Sun Cured Vest
	[4958] = true, -- Sun-beaten Cloak
	[20992] = true, -- Sunrise Bracers
	[20996] = true, -- Sunspire Cord
	[20841] = true, -- Sunstrider Shield
	[1843] = true, -- Tanned Leather Belt
	[843] = true, -- Tanned Leather Boots
	[1844] = true, -- Tanned Leather Bracers
	[844] = true, -- Tanned Leather Gloves
	[846] = true, -- Tanned Leather Jerkin
	[845] = true, -- Tanned Leather Pants
	[6076] = true, -- Tapered Pants
	[2380] = true, -- Tarnished Chain Belt
	[2383] = true, -- Tarnished Chain Boots
	[2384] = true, -- Tarnished Chain Bracers
	[2385] = true, -- Tarnished Chain Gloves
	[2381] = true, -- Tarnished Chain Leggings
	[2379] = true, -- Tarnished Chain Vest
	[3595] = true, -- Tattered Cloth Belt
	[195] = true, -- Tattered Cloth Boots
	[3596] = true, -- Tattered Cloth Bracers
	[711] = true, -- Tattered Cloth Gloves
	[194] = true, -- Tattered Cloth Pants
	[193] = true, -- Tattered Cloth Vest
	[9444] = true, -- Techbot CPU Shell
	[4911] = true, -- Thick Bark Buckler
	[3597] = true, -- Thick Cloth Belt
	[3598] = true, -- Thick Cloth Bracers
	[203] = true, -- Thick Cloth Gloves
	[201] = true, -- Thick Cloth Pants
	[202] = true, -- Thick Cloth Shoes
	[200] = true, -- Thick Cloth Vest
	[2121] = true, -- Thin Cloth Armor
	[3599] = true, -- Thin Cloth Belt
	[3600] = true, -- Thin Cloth Bracers
	[2119] = true, -- Thin Cloth Gloves
	[2120] = true, -- Thin Cloth Pants
	[2117] = true, -- Thin Cloth Shoes
	[6203] = true, -- Thuggish Shield
	[4963] = true, -- Thunderhorn Cloak
	[4942] = true, -- Tiger Hide Boots
	[3444] = true, -- Tiller's Vest
	[5399] = true, -- Tracking Boots
	[4675] = true, -- Tribal Belt
	[3284] = true, -- Tribal Boots
	[3285] = true, -- Tribal Bracers
	[3649] = true, -- Tribal Buckler
	[4674] = true, -- Tribal Cloak
	[3286] = true, -- Tribal Gloves
	[4967] = true, -- Tribal Warrior's Shield
	[20914] = true, -- Unadorned Chain Belt
	[20915] = true, -- Unadorned Chain Boots
	[20916] = true, -- Unadorned Chain Bracers
	[20917] = true, -- Unadorned Chain Gloves
	[20918] = true, -- Unadorned Chain Leggings
	[20919] = true, -- Unadorned Chain Vest
	[2238] = true, -- Urchin's Pants
	[4940] = true, -- Veiled Grips
	[2979] = true, -- Veteran Boots
	[3213] = true, -- Veteran Bracers
	[4677] = true, -- Veteran Cloak
	[4678] = true, -- Veteran Girdle
	[21000] = true, -- Vigorous Bracers
	[11190] = true, -- Viny Gloves
	[2571] = true, -- Viny Wrappings
	[5767] = true, -- Violet Robes
	[1202] = true, -- Wall Shield
	[14728] = true, -- War Paint Shoulder Pads
	[15482] = true, -- War Torn Bands
	[15483] = true, -- War Torn Cape
	[15480] = true, -- War Torn Girdle
	[15481] = true, -- War Torn Greaves
	[15484] = true, -- War Torn Handgrips
	[4772] = true, -- Warm Cloak
	[3216] = true, -- Warm Winter Robe
	[2967] = true, -- Warrior's Boots
	[3214] = true, -- Warrior's Bracers
	[3648] = true, -- Warrior's Buckler
	[4658] = true, -- Warrior's Cloak
	[4659] = true, -- Warrior's Girdle
	[2968] = true, -- Warrior's Gloves
	[1438] = true, -- Warrior's Shield
	[1173] = true, -- Weather-worn Boots
	[3583] = true, -- Weathered Belt
	[6148] = true, -- Web-covered Boots
	[3261] = true, -- Webbed Cloak
	[3263] = true, -- Webbed Pants
	[20995] = true, -- Well Watcher Gloves
	[1171] = true, -- Well-stitched Robe
	[15401] = true, -- Welldrip Gloves
	[3008] = true, -- Wendigo Fur Cloak
	[2311] = true, -- White Leather Jerkin
	[1965] = true, -- White Wolf Gloves
	[4935] = true, -- Wide Metal Girdle
	[11475] = true, -- Wine-stained Cloak
	[3322] = true, -- Wispy Cloak
	[6171] = true, -- Wolf Handler Gloves
	[6070] = true, -- Wolfskin Bracers
	[11189] = true, -- Woodland Robes
	[5395] = true, -- Woodland Shield
	[4907] = true, -- Woodland Tunic
	[2584] = true, -- Woolen Cape
	[10550] = true, -- Wooly Mittens
	[2376] = true, -- Worn Heater Shield
	[3606] = true, -- Woven Belt
	[2367] = true, -- Woven Boots
	[3607] = true, -- Woven Bracers
	[2369] = true, -- Woven Gloves
	[2366] = true, -- Woven Pants
	[2364] = true, -- Woven Vest
	[20998] = true, -- Wyrm Sash
	[3439] = true, -- Zombie Skin Boots
	[3435] = true, -- Zombie Skin Bracers
	[3272] = true, -- Zombie Skin Leggings

	--------------------------------------------------------------------------------
	-- 02. World of Warcraft : The Burning Crusade
	--------------------------------------------------------------------------------

	[30777] = true, -- Aldor Heavy Belt
	[24141] = true, -- Battle Worn Gauntlets
	[24142] = true, -- Battle Worn Gloves
	[24144] = true, -- Battle Worn Handguards
	[24423] = true, -- Beaten Chain Leggings
	[23375] = true, -- Black Leather Vest
	[23265] = true, -- Blackened Chain Girdle
	[24443] = true, -- Bracers of Shed Fur
	[23395] = true, -- Farstrider's Buckler
	[24445] = true, -- Fortified Wristguards
	[22953] = true, -- Fur Lined Chain Shirt
	[23376] = true, -- Gatewatcher's Chain Gloves
	[24241] = true, -- Green Chain Belt
	[23377] = true, -- Guard's Leggings
	[24425] = true, -- Hand Sewn Pants
	[30771] = true, -- Heavy Draenic Bracers
	[30765] = true, -- Heavy Draenic Breastplate
	[24436] = true, -- Huntsman's Bracers
	[30775] = true, -- Layered Bone Shield
	[23367] = true, -- Light Silk Robe
	[22965] = true, -- Longshoreman's Bindings
	[30781] = true, -- Mag'hari Chain Vest
	[24442] = true, -- Mail Belt of the Silverpine
	[24104] = true, -- Moongraze Fur Cloak
	[24103] = true, -- Moongraze Hide Boots
	[24447] = true, -- Naga Scale Boots
	[24444] = true, -- Newly Weaved Pants
	[23266] = true, -- Ranger's Vest
	[24435] = true, -- Reinforced Mail Boots
	[24424] = true, -- Rough Leather Leggings
	[24129] = true, -- Salvaged Leather Belt
	[23267] = true, -- Satin Lined Boots
	[23397] = true, -- Satin Lined Gloves
	[22966] = true, -- Silk Wristbands
	[24131] = true, -- Slightly Rusted Bracers
	[24437] = true, -- Slightly Worn Bracer
	[24227] = true, -- Soft Leather Belt
	[23368] = true, -- Soft Leather Boots
	[27552] = true, -- Soft Leather Vest
	[22952] = true, -- Springpaw Hide Cloak
	[22951] = true, -- Springpaw Hide Leggings
	[23365] = true, -- Steel Rimmed Buckler
	[24446] = true, -- Sturdy Leather Belt
	[22964] = true, -- Sunsail Bracers
	[24135] = true, -- Weathered Cloth Armor
	[24134] = true, -- Weathered Leather Vest
	[24133] = true, -- Weathered Mail Tunic
	[30784] = true, -- Worn Mag'hari Gauntlets
	[24130] = true, -- Worn Slippers

	--------------------------------------------------------------------------------
	-- 03. World of Warcraft : Wrath of the Lich King
	--------------------------------------------------------------------------------

	[38645] = true, -- Bone-Plated Armor
	[38646] = true, -- Bone-Plated Belt
	[38647] = true, -- Bone-Plated Boots
	[38648] = true, -- Bone-Plated Bracers
	[38649] = true, -- Bone-Plated Gloves
	[38650] = true, -- Bone-Plated Helm
	[38651] = true, -- Bone-Plated Leggings
	[41754] = true, -- Brunnhildar Shield
	[54617] = true, -- Darkspear Shroud
	[53097] = true, -- Gnomeregan Drape
	[42084] = true, -- Snowhide Belt
	[42092] = true, -- Snowhide Bracers
	[42094] = true, -- Snowhide Cap
	[42088] = true, -- Snowhide Hoof-Warmers
	[42097] = true, -- Snowhide Mitts
	[42098] = true, -- Snowhide Pants
	[42099] = true, -- Snowhide Vest
}
