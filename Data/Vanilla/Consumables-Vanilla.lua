local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

-- [itemId] = {Item Use Level}, -- Item Name
ns.ALLOWED_DELETE_CONSUMABLES = {
	-- Food
	[8932] = { 45 }, -- Alterac Swiss
	[13935] = { 45 }, -- Baked Salmon
	[16166] = { 1 }, -- Bean Soup
	[18635] = { 35 }, -- Bellara's Nutterbar
	[13546] = { 25 }, -- Bloodbelly Fish
	[1119] = { 15 }, -- Bottled Spirits
	[6290] = { 1 }, -- Brilliant Smallfish
	[4593] = { 15 }, -- Bristle Whisker Catfish
	[21031] = { 45 }, -- Cabbage Kimchi
	[17344] = { 1 }, -- Candy Cane
	[2679] = { 1 }, -- Charred Wolf Meat
	[5526] = { 10 }, -- Clam Chowder
	[1113] = { 5 }, -- Conjured Bread
	[22895] = { 55 }, -- Conjured Cinnamon Roll
	[5349] = { 1 }, -- Conjured Muffin
	[1487] = { 25 }, -- Conjured Pumpernickel
	[1114] = { 15 }, -- Conjured Rye
	[8075] = { 35 }, -- Conjured Sourdough
	[8076] = { 45 }, -- Conjured Sweet Roll
	[19306] = { 35 }, -- Crunchy Frog
	[4599] = { 35 }, -- Cured Ham Steak
	[414] = { 5 }, -- Dalaran Sharp
	[13888] = { 45 }, -- Darkclaw Lobster
	[19223] = { 1 }, -- Darkmoon Dog
	[12238] = { 5 }, -- Darkshore Grouper
	[2070] = { 1 }, -- Darnassian Bleu
	[21030] = { 35 }, -- Darnassus Kimchi Pie
	[19225] = { 45 }, -- Deep Fried Candybar
	[8953] = { 45 }, -- Deep Fried Plantains
	[17119] = { 5 }, -- Deeprun Rat Kabob
	[4607] = { 25 }, -- Delicious Cave Mold
	[1321] = { 5 }, -- Deprecated Broiled Sunfish
	[4418] = { 35 }, -- Deprecated Creeper Cakes
	[761] = { 1 }, -- Deprecated Elwynn Trout
	[5478] = { 10 }, -- Dig Rat Stew
	[8948] = { 45 }, -- Dried King Bolete
	[422] = { 15 }, -- Dwarven Mild
	[13930] = { 35 }, -- Filet of Redgill
	[3927] = { 35 }, -- Fine Aged Cheddar
	[5066] = { 5 }, -- Fissure Plant
	[5845] = { 15 }, -- Flank of Meat
	[4604] = { 1 }, -- Forest Mushroom Cap
	[4541] = { 5 }, -- Freshly Baked Bread
	[23160] = { 45 }, -- Friendship Bread
	[6807] = { 25 }, -- Frog Leg Stew
	[4539] = { 25 }, -- Goldenbark Apple
	[17407] = { 25 }, -- Graccu's Homemade Meat Pie
	[9681] = { 35 }, -- Grilled King Crawler Legs
	[11444] = { 45 }, -- Grim Guzzler Boar
	[2287] = { 5 }, -- Haunch of Meat
	[961] = { 1 }, -- Healing Herb
	[16168] = { 35 }, -- Heaven Peach
	[17406] = { 5 }, -- Holiday Cheesewheel
	[8950] = { 45 }, -- Homemade Cherry Pie
	[13893] = { 45 }, -- Large Raw Mightfish
	[7097] = { 1 }, -- Leg Meat
	[13933] = { 45 }, -- Lobster Stew
	[6316] = { 5 }, -- Loch Frenzy Delight
	[4592] = { 5 }, -- Longjaw Mud Snapper
	[8364] = { 25 }, -- Mithril Head Trout
	[11415] = { 45 }, -- Mixed Berries
	[4542] = { 15 }, -- Moist Cornbread
	[4602] = { 35 }, -- Moon Harvest Pumpkin
	[18632] = { 25 }, -- Moonbrook Riot Taffy
	[4544] = { 25 }, -- Mulgore Spice Bread
	[3770] = { 15 }, -- Mutton Chop
	[6458] = { 5 }, -- Oil Covered Fish
	[19305] = { 15 }, -- Pickled Kodo Foot
	[21033] = { 45 }, -- Radish Kimchi
	[5095] = { 5 }, -- Rainbow Fin Albacore
	[4608] = { 35 }, -- Raw Black Truffle
	[6291] = { 1 }, -- Raw Brilliant Smallfish
	[6308] = { 15 }, -- Raw Bristle Whisker Catfish
	[13754] = { 35 }, -- Raw Glossy Mightfish
	[6317] = { 5 }, -- Raw Loch Frenzy
	[6289] = { 5 }, -- Raw Longjaw Mud Snapper
	[8365] = { 25 }, -- Raw Mithril Head Trout
	[13759] = { 35 }, -- Raw Nightfin Snapper
	[6361] = { 5 }, -- Raw Rainbow Fin Albacore
	[13758] = { 35 }, -- Raw Redgill
	[6362] = { 25 }, -- Raw Rockscale Cod
	[6303] = { 1 }, -- Raw Slitherskin Mackerel
	[8959] = { 45 }, -- Raw Spinefin Halibut
	[4603] = { 35 }, -- Raw Spotted Yellowtail
	[13756] = { 35 }, -- Raw Summer Bass
	[13760] = { 35 }, -- Raw Sunscale Salmon
	[13889] = { 45 }, -- Raw Whitescale Salmon
	[19224] = { 25 }, -- Red Hot Wings
	[4605] = { 5 }, -- Red-speckled Mushroom
	[5057] = { 1 }, -- Ripe Watermelon
	[2681] = { 1 }, -- Roasted Boar Meat
	[8952] = { 45 }, -- Roasted Quail
	[4594] = { 25 }, -- Rockscale Cod
	[18255] = { 45 }, -- Runn Tum Tuber
	[1326] = { 5 }, -- Sauteed Sunfish
	[16171] = { 45 }, -- Shinsollo
	[4536] = { 1 }, -- Shiny Red Apple
	[6299] = { 1 }, -- Sickly Looking Fish
	[787] = { 1 }, -- Slitherskin Mackerel
	[4656] = { 1 }, -- Small Pumpkin
	[6890] = { 5 }, -- Smoked Bear Meat
	[4538] = { 15 }, -- Snapvine Watermelon
	[4601] = { 35 }, -- Soft Banana Bread
	[11109] = { 1 }, -- Special Chicken Feed
	[19304] = { 5 }, -- Spiced Beef Jerky
	[17408] = { 35 }, -- Spicy Beefstick
	[8957] = { 45 }, -- Spinefin Halibut
	[4606] = { 15 }, -- Spongy Morel
	[6887] = { 35 }, -- Spotted Yellowtail
	[16170] = { 15 }, -- Steamed Mandu
	[1707] = { 25 }, -- Stormwind Brie
	[21552] = { 35 }, -- Striped Yellowtail
	[18633] = { 5 }, -- Styleen's Sour Suckerpop
	[2685] = { 10 }, -- Succulent Pork Ribs
	[4537] = { 5 }, -- Tel'Abim Banana
	[7228] = { 15 }, -- Tigule's Strawberry Ice Cream
	[4540] = { 1 }, -- Tough Hunk of Bread
	[117] = { 1 }, -- Tough Jerky
	[12763] = { 45 }, -- Un'Goro Etherfruit
	[16766] = { 35 }, -- Undermine Clam Chowder
	[8543] = { 25 }, -- Underwater Mushroom Cap
	[16167] = { 5 }, -- Versicolor Treat
	[733] = { 5 }, -- Westfall Stew
	[3771] = { 25 }, -- Wild Hog Shank
	[16169] = { 25 }, -- Wild Ricecake
	[22324] = { 45 }, -- Winter Kimchi
	[13755] = { 35 }, -- Winter Squid

	-- Water
	[17404] = { 5 }, -- Blended Bean Brew
	[19300] = { 35 }, -- Bottled Winterspring Water
	[9451] = { 15 }, -- Bubbling Water
	[8079] = { 55 }, -- Conjured Crystal Water
	[2288] = { 5 }, -- Conjured Fresh Water
	[8077] = { 35 }, -- Conjured Mineral Water
	[2136] = { 15 }, -- Conjured Purified Water
	[8078] = { 45 }, -- Conjured Sparkling Water
	[3772] = { 25 }, -- Conjured Spring Water
	[5350] = { 1 }, -- Conjured Water
	[2071] = { 1 }, -- Deprecated Mountain Spring Water
	[3773] = { 35 }, -- Deprecated Murkwood Sap
	[4791] = { 25 }, -- Enchanted Water
	[19299] = { 15 }, -- Fizzy Faire Drink
	[23161] = { 45 }, -- Freshly-Squeezed Lemonade
	[10841] = { 25 }, -- Goldthorn Tea
	[17405] = { 25 }, -- Green Garden Tea
	[18300] = { 55 }, -- Hyjal Nectar
	[1179] = { 5 }, -- Ice Cold Milk
	[1205] = { 15 }, -- Melon Juice
	[1645] = { 35 }, -- Moonberry Juice
	[8766] = { 45 }, -- Morning Glory Dew
	[159] = { 1 }, -- Refreshing Spring Water
	[1708] = { 25 }, -- Sweet Nectar

	-- Both
	[19301] = { 51 }, -- Alterac Manna Biscuit
	[20062] = { 45 }, -- Arathi Basin Enriched Ration
	[20063] = { 25 }, -- Arathi Basin Field Ration
	[20064] = { 35 }, -- Arathi Basin Iron Ration
	[2682] = { 5 }, -- Cooked Crab Claw
	[20222] = { 45 }, -- Defiler's Enriched Ration
	[20223] = { 25 }, -- Defiler's Field Ration
	[20224] = { 35 }, -- Defiler's Iron Ration
	[13724] = { 45 }, -- Enriched Manna Biscuit
	[20031] = { 55 }, -- Essence Mango
	[20225] = { 45 }, -- Highlander's Enriched Ration
	[20226] = { 25 }, -- Highlander's Field Ration
	[20227] = { 35 }, -- Highlander's Iron Ration
	[13931] = { 35 }, -- Nightfin Soup
	[21153] = { 30 }, -- Raw Greater Sagefish
	[21071] = { 10 }, -- Raw Sagefish
	[3448] = { 5 }, -- Senggin Root
	[19060] = { 45 }, -- Warsong Gulch Enriched Ration
	[19062] = { 25 }, -- Warsong Gulch Field Ration
	[19061] = { 35 }, -- Warsong Gulch Iron Ration

	-- Alcohol
	[2723] = { 1 }, -- Bottle of Dalaran Noir
	[19222] = { 1 }, -- Cheap Beer
	[4600] = { 25 }, -- Cherry Grog
	[9360] = { 1 }, -- Cuergo's Gold
	[9361] = { 1 }, -- Cuergo's Gold with Worm
	[12003] = { 45 }, -- Dark Dwarven Lager
	[19221] = { 1 }, -- Darkmoon Special Reserve
	[18287] = { 1 }, -- Evermurky
	[2594] = { 15 }, -- Flagon of Dwarven Honeymead
	[2593] = { 5 }, -- Flask of Stormwind Tawny
	[17402] = { 25 }, -- Greatfather's Winter Ale
	[17196] = { 1 }, -- Holiday Spirits
	[2595] = { 25 }, -- Jug of Badlands Bourbon
	[4595] = { 1 }, -- Junglevine Wine
	[18288] = { 1 }, -- Molasses Firewater
	[2894] = { 1 }, -- Rhapsody Malt
	[2596] = { 5 }, -- Skin of Dwarven Stout
	[3703] = { 1 }, -- Southshore Stout
	[17403] = { 5 }, -- Steamwheedle Fizzy Spirits
	[2686] = { 1 }, -- Thunder Ale
	[9260] = { 1 }, -- Volatile Rum
	[11846] = { 5 }, -- Wizbang's Special Brew
}

--[[
How We Got the Data

Last Validated
	2026-10-04, Classic Era 1.15.9.70003

Notes
	- Food, water, food-and-water, and alcohol, one section each: items whose use only restores health or mana, or makes you drunk, so outgrowing one costs nothing. Test and placeholder items are left out.
	- Item Use Level is the item level minus 10, never below 1. Where the game sets a required level, the row holds that instead.
	- A consumable becomes junk ten levels past its use level, or at level 5 for anything under level 5 (GetConsumableEraseLevel in Features/Junk-Rules.lua).
	- Rows outside the query were added from wago.tools build 1.15.9.70003.

SQL (CMaNGOS)
	CMaNGOS WotLK world DB (wotlk-db).

	WITH regen AS (
	  SELECT Id,
	    (84 IN (EffectApplyAuraName1, EffectApplyAuraName2, EffectApplyAuraName3)) AS is_food,
	    (85 IN (EffectApplyAuraName1, EffectApplyAuraName2, EffectApplyAuraName3)) AS is_drink,
	    (Effect1 IN (0,6) AND Effect2 IN (0,6) AND Effect3 IN (0,6)
	     AND EffectApplyAuraName1 IN (0,84,85,226)
	     AND EffectApplyAuraName2 IN (0,84,85,226)
	     AND EffectApplyAuraName3 IN (0,84,85,226)) AS is_pure
	  FROM spell_template
	  WHERE 84 IN (EffectApplyAuraName1, EffectApplyAuraName2, EffectApplyAuraName3)
	     OR 85 IN (EffectApplyAuraName1, EffectApplyAuraName2, EffectApplyAuraName3)
	),
	items AS (
	  SELECT x.entry, x.name,
	         GREATEST(CAST(x.ItemLevel AS SIGNED) - 10, 1) AS lvl,
	         CASE WHEN x.booze = 1                THEN 'Alcohol'
	              WHEN x.food = 1 AND x.drink = 1 THEN 'Both'
	              WHEN x.food = 1                 THEN 'Food'
	              WHEN x.drink = 1                THEN 'Water' END AS kind
	  FROM (
	    SELECT i.entry, i.name, i.ItemLevel,
	      (100 IN (s.Effect1, s.Effect2, s.Effect3)) AS booze,
	      GREATEST(84 IN (s.EffectApplyAuraName1, s.EffectApplyAuraName2, s.EffectApplyAuraName3),
	               COALESCE(t1.is_food,0), COALESCE(t2.is_food,0), COALESCE(t3.is_food,0)) AS food,
	      GREATEST(85 IN (s.EffectApplyAuraName1, s.EffectApplyAuraName2, s.EffectApplyAuraName3),
	               COALESCE(t1.is_drink,0), COALESCE(t2.is_drink,0), COALESCE(t3.is_drink,0)) AS drink,
	      (s.Effect1 IN (0,6,64,100) AND s.Effect2 IN (0,6,64,100) AND s.Effect3 IN (0,6,64,100)
	       AND s.EffectApplyAuraName1 IN (0,84,85,226)
	       AND s.EffectApplyAuraName2 IN (0,84,85,226)
	       AND s.EffectApplyAuraName3 IN (0,84,85,226)
	       AND (s.Effect1 <> 64 OR COALESCE(t1.is_pure,0) = 1)
	       AND (s.Effect2 <> 64 OR COALESCE(t2.is_pure,0) = 1)
	       AND (s.Effect3 <> 64 OR COALESCE(t3.is_pure,0) = 1)) AS clean
	    FROM item_template i
	    JOIN spell_template s ON s.Id = i.spellid_1
	    LEFT JOIN regen t1 ON s.Effect1 = 64 AND t1.Id = s.EffectTriggerSpell1
	    LEFT JOIN regen t2 ON s.Effect2 = 64 AND t2.Id = s.EffectTriggerSpell2
	    LEFT JOIN regen t3 ON s.Effect3 = 64 AND t3.Id = s.EffectTriggerSpell3
	    WHERE (i.class = 0 OR (i.class = 7 AND i.subclass = 8))
	      AND i.spellcategory_1 IN (11, 59)
	      AND i.name NOT LIKE '%Test%'
	      AND i.name NOT LIKE '%[PH]%'
	  ) x
	  WHERE x.clean = 1 AND (x.booze = 1 OR x.food = 1 OR x.drink = 1)
	)
	SELECT z.line
	FROM (
	  SELECT FIELD(kind, 'Food', 'Water', 'Both', 'Alcohol') AS grp, 0 AS ord, '' AS nm,
	         CONCAT('\n\t-- ', kind) AS line
	  FROM items GROUP BY kind
	  UNION ALL
	  SELECT FIELD(kind, 'Food', 'Water', 'Both', 'Alcohol'), 1, name,
	         CONCAT('\t[', entry, '] = {', lvl, '},  -- ', name)
	  FROM items
	) z
	ORDER BY z.grp, z.ord, z.nm;

Wowhead
	None.

wago.tools
	Build 1.15.9.70003; the file never recorded which tables.
	https://wago.tools/db2/ItemEffect?build=1.15.9.70003
	https://wago.tools/db2/SpellEffect?build=1.15.9.70003
]]
