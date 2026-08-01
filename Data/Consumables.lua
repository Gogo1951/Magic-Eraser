local _, ns = ...

--[[ 

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

]]

ns.AllowedDeleteConsumables = {

	-- [itemId] = {Item Use Level}, -- Item Name

	-- Food
	[33254] = { 65 }, -- Afrazi Forest Strider Drumstick
	[44607] = { 75 }, -- Aged Dalaran Sharp
	[44722] = { 75 }, -- Aged Yolk
	[8932] = { 45 }, -- Alterac Swiss
	[42350] = { 1 }, -- Bag of Peanuts
	[42342] = { 1 }, -- Bag of Popcorn
	[13935] = { 45 }, -- Baked Salmon
	[16166] = { 1 }, -- Bean Soup
	[18635] = { 35 }, -- Bellara's Nutterbar
	[42432] = { 65 }, -- Berry Pie Slice
	[41751] = { 55 }, -- Black Mushroom
	[27661] = { 55 }, -- Blackened Trout
	[29449] = { 65 }, -- Bladespire Bagel
	[13546] = { 25 }, -- Bloodbelly Fish
	[1119] = { 15 }, -- Bottled Spirits
	[38706] = { 75 }, -- Bowels 'n' Brains
	[6290] = { 1 }, -- Brilliant Smallfish
	[35952] = { 75 }, -- Briny Hardcheese
	[4593] = { 15 }, -- Bristle Whisker Catfish
	[21031] = { 45 }, -- Cabbage Kimchi
	[17344] = { 1 }, -- Candy Cane
	[46690] = { 1 }, -- Candy Skull
	[42428] = { 65 }, -- Carrot Cupcake
	[2679] = { 1 }, -- Charred Wolf Meat
	[42433] = { 65 }, -- Chocolate Cake Slice
	[5526] = { 10 }, -- Clam Chowder
	[29451] = { 65 }, -- Clefthoof Ribs
	[1113] = { 5 }, -- Conjured Bread
	[22895] = { 55 }, -- Conjured Cinnamon Roll
	[22019] = { 65 }, -- Conjured Croissant
	[5349] = { 1 }, -- Conjured Muffin
	[1487] = { 25 }, -- Conjured Pumpernickel
	[1114] = { 15 }, -- Conjured Rye
	[8075] = { 35 }, -- Conjured Sourdough
	[8076] = { 45 }, -- Conjured Sweet Roll
	[34770] = { 70 }, -- Cooked Northrend Fish 12
	[44940] = { 75 }, -- Corn-Breaded Sausage
	[44854] = { 1 }, -- Cranberries
	[43087] = { 75 }, -- Crisp Dalaran Apple
	[19306] = { 35 }, -- Crunchy Frog
	[42778] = { 75 }, -- Crusader's Rations
	[33449] = { 65 }, -- Crusty Flatbread
	[4599] = { 35 }, -- Cured Ham Steak
	[42431] = { 75 }, -- Dalaran Brownie
	[42430] = { 65 }, -- Dalaran Doughnut
	[414] = { 5 }, -- Dalaran Sharp
	[44608] = { 65 }, -- Dalaran Swiss
	[13888] = { 45 }, -- Darkclaw Lobster
	[19223] = { 1 }, -- Darkmoon Dog
	[2070] = { 1 }, -- Darnassian Bleu
	[21030] = { 35 }, -- Darnassus Kimchi Pie
	[19225] = { 45 }, -- Deep Fried Candybar
	[8953] = { 45 }, -- Deep Fried Plantains
	[17119] = { 5 }, -- Deeprun Rat Kabob
	[35710] = { 70 }, -- Delicious Baked Ham
	[4607] = { 25 }, -- Delicious Cave Mold
	[1321] = { 5 }, -- Deprecated Broiled Sunfish
	[4418] = { 35 }, -- Deprecated Creeper Cakes
	[761] = { 1 }, -- Deprecated Elwynn Trout
	[29393] = { 55 }, -- Diamond Berries
	[5478] = { 10 }, -- Dig Rat Stew
	[8948] = { 45 }, -- Dried King Bolete
	[422] = { 15 }, -- Dwarven Mild
	[37452] = { 65 }, -- Fatty Bluefin
	[13930] = { 35 }, -- Filet of Redgill
	[33451] = { 65 }, -- Fillet of Icefin
	[3927] = { 35 }, -- Fine Aged Cheddar
	[5066] = { 5 }, -- Fissure Plant
	[5845] = { 15 }, -- Flank of Meat
	[4604] = { 1 }, -- Forest Mushroom Cap
	[43646] = { 65 }, -- Fountain Goldfish
	[44609] = { 65 }, -- Fresh Dalaran Bread Slice
	[40359] = { 65 }, -- Fresh Eagle Meat
	[4541] = { 5 }, -- Freshly Baked Bread
	[44049] = { 75 }, -- Freshly-Speared Emperor Salmon
	[23160] = { 45 }, -- Friendship Bread
	[6807] = { 25 }, -- Frog Leg Stew
	[37252] = { 65 }, -- Frostberries
	[33246] = { 55 }, -- Funnel Cake
	[27857] = { 55 }, -- Garadar Sharp
	[35285] = { 60 }, -- Giant Sunfish
	[4539] = { 25 }, -- Goldenbark Apple
	[17407] = { 25 }, -- Graccu's Homemade Meat Pie
	[9681] = { 35 }, -- Grilled King Crawler Legs
	[32563] = { 1 }, -- Grilled Picnic Treat
	[30355] = { 65 }, -- Grilled Shadowmoon Tuber
	[11444] = { 45 }, -- Grim Guzzler Boar
	[40356] = { 65 }, -- Grizzleberries
	[2287] = { 5 }, -- Haunch of Meat
	[961] = { 1 }, -- Healing Herb
	[16168] = { 35 }, -- Heaven Peach
	[24338] = { 45 }, -- Hellfire Spineleaf
	[17406] = { 5 }, -- Holiday Cheesewheel
	[8950] = { 45 }, -- Homemade Cherry Pie
	[45901] = { 70 }, -- Homemade Fish Fry
	[20857] = { 1 }, -- Honey Bread
	[33452] = { 65 }, -- Honey-Spiced Lichen
	[29412] = { 55 }, -- Jessen's Special Slop
	[13893] = { 45 }, -- Large Raw Mightfish
	[7097] = { 1 }, -- Leg Meat
	[13933] = { 45 }, -- Lobster Stew
	[6316] = { 5 }, -- Loch Frenzy Delight
	[4592] = { 5 }, -- Longjaw Mud Snapper
	[42434] = { 75 }, -- Lovely Cake Slice
	[29394] = { 65 }, -- Lyribread
	[27855] = { 55 }, -- Mag'har Grainbread
	[29448] = { 65 }, -- Mag'har Mild Cheese
	[35953] = { 75 }, -- Mead Basted Caribou
	[8364] = { 25 }, -- Mithril Head Trout
	[11415] = { 45 }, -- Mixed Berries
	[4542] = { 15 }, -- Moist Cornbread
	[4602] = { 35 }, -- Moon Harvest Pumpkin
	[18632] = { 25 }, -- Moonbrook Riot Taffy
	[28486] = { 55 }, -- Moser's Magnificent Muffin
	[4544] = { 25 }, -- Mulgore Spice Bread
	[46797] = { 1 }, -- Mulgore Sweet Potato
	[3770] = { 15 }, -- Mutton Chop
	[34747] = { 70 }, -- Northern Stew
	[32685] = { 65 }, -- Ogri'la Chicken Fingers
	[6458] = { 5 }, -- Oil Covered Fish
	[38427] = { 55 }, -- Pickled Egg
	[19305] = { 15 }, -- Pickled Kodo Foot
	[35951] = { 75 }, -- Poached Emperor Salmon
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
	[40358] = { 65 }, -- Raw Tallhorn Chunk
	[13889] = { 45 }, -- Raw Whitescale Salmon
	[19224] = { 25 }, -- Red Hot Wings
	[42429] = { 75 }, -- Red Velvet Cupcake
	[4605] = { 5 }, -- Red-speckled Mushroom
	[46784] = { 1 }, -- Ripe Elwynn Pumpkin
	[46796] = { 1 }, -- Ripe Tirisfal Pumpkin
	[5057] = { 1 }, -- Ripe Watermelon
	[2681] = { 1 }, -- Roasted Boar Meat
	[44072] = { 75 }, -- Roasted Mystery Beast
	[8952] = { 45 }, -- Roasted Quail
	[38428] = { 65 }, -- Rock-Salted Pretzel
	[4594] = { 25 }, -- Rockscale Cod
	[18255] = { 45 }, -- Runn Tum Tuber
	[33454] = { 65 }, -- Salted Venison
	[44749] = { 65 }, -- Salted Yeti Cheese
	[24072] = { 5 }, -- Sand Pear Pie
	[1326] = { 5 }, -- Sauteed Sunfish
	[35948] = { 75 }, -- Savory Snowplum
	[43571] = { 70 }, -- Sewer Carp
	[43647] = { 70 }, -- Shimmering Minnow
	[16171] = { 45 }, -- Shinsollo
	[4536] = { 1 }, -- Shiny Red Apple
	[6299] = { 1 }, -- Sickly Looking Fish
	[35794] = { 65 }, -- Silvercoat Stag Meat
	[40202] = { 75 }, -- Sizzling Grizzly Flank
	[27856] = { 55 }, -- Skethyl Berries
	[787] = { 1 }, -- Slitherskin Mackerel
	[44071] = { 75 }, -- Slow-Roasted Eel
	[4656] = { 1 }, -- Small Pumpkin
	[6890] = { 5 }, -- Smoked Bear Meat
	[30610] = { 55 }, -- Smoked Black Bear Meat
	[27854] = { 55 }, -- Smoked Talbuk Venison
	[4538] = { 15 }, -- Snapvine Watermelon
	[4601] = { 35 }, -- Soft Banana Bread
	[33443] = { 65 }, -- Sour Goat Cheese
	[35947] = { 75 }, -- Sparkling Frostcap
	[11109] = { 1 }, -- Special Chicken Feed
	[30816] = { 1 }, -- Spice Bread
	[19304] = { 5 }, -- Spiced Beef Jerky
	[17408] = { 35 }, -- Spicy Beefstick
	[8957] = { 45 }, -- Spinefin Halibut
	[4606] = { 15 }, -- Spongy Morel
	[29453] = { 65 }, -- Sporeggar Mushroom
	[6887] = { 35 }, -- Spotted Yellowtail
	[23495] = { 1 }, -- Springpaw Appetizer
	[16170] = { 15 }, -- Steamed Mandu
	[41729] = { 75 }, -- Stewed Drakeflesh
	[33048] = { 65 }, -- Stewed Trout
	[36831] = { 65 }, -- Stolen Ribs
	[1707] = { 25 }, -- Stormwind Brie
	[21552] = { 35 }, -- Striped Yellowtail
	[30458] = { 55 }, -- Stromgarde Muenster
	[18633] = { 5 }, -- Styleen's Sour Suckerpop
	[2685] = { 10 }, -- Succulent Pork Ribs
	[27858] = { 55 }, -- Sunspring Carp
	[35950] = { 75 }, -- Sweet Potato Bread
	[46793] = { 1 }, -- Tangy Southfury Cranberries
	[4537] = { 5 }, -- Tel'Abim Banana
	[29450] = { 65 }, -- Telaari Grapes
	[7228] = { 15 }, -- Tigule and Foror's Strawberry Ice Cream
	[4540] = { 1 }, -- Tough Hunk of Bread
	[117] = { 1 }, -- Tough Jerky
	[35949] = { 65 }, -- Tundra Berries
	[12763] = { 45 }, -- Un'Goro Etherfruit
	[16766] = { 35 }, -- Undermine Clam Chowder
	[8543] = { 25 }, -- Underwater Mushroom Cap
	[16167] = { 5 }, -- Versicolor Treat
	[733] = { 5 }, -- Westfall Stew
	[3771] = { 25 }, -- Wild Hog Shank
	[16169] = { 25 }, -- Wild Ricecake
	[22324] = { 45 }, -- Winter Kimchi
	[13755] = { 35 }, -- Winter Squid
	[44855] = { 1 }, -- Yam
	[27859] = { 55 }, -- Zangar Caps
	[29452] = { 65 }, -- Zangar Trout

	-- Water
	[38698] = { 70 }, -- Bitter Plasma
	[33042] = { 65 }, -- Black Coffee
	[38431] = { 65 }, -- Blackrock Fortified Water
	[38430] = { 60 }, -- Blackrock Mineral Water
	[38429] = { 45 }, -- Blackrock Spring Water
	[17404] = { 5 }, -- Blended Bean Brew
	[19300] = { 35 }, -- Bottled Winterspring Water
	[9451] = { 15 }, -- Bubbling Water
	[8079] = { 55 }, -- Conjured Crystal Water
	[2288] = { 5 }, -- Conjured Fresh Water
	[22018] = { 65 }, -- Conjured Glacier Water
	[8077] = { 35 }, -- Conjured Mineral Water
	[30703] = { 60 }, -- Conjured Mountain Spring Water
	[2136] = { 15 }, -- Conjured Purified Water
	[8078] = { 45 }, -- Conjured Sparkling Water
	[3772] = { 25 }, -- Conjured Spring Water
	[5350] = { 1 }, -- Conjured Water
	[42777] = { 75 }, -- Crusader's Waterskin
	[2071] = { 1 }, -- Deprecated Mountain Spring Water
	[3773] = { 35 }, -- Deprecated Murkwood Sap
	[32668] = { 65 }, -- Dos Ogris
	[4791] = { 25 }, -- Enchanted Water
	[29395] = { 65 }, -- Ethermead
	[28399] = { 60 }, -- Filtered Draenic Water
	[19299] = { 15 }, -- Fizzy Faire Drink
	[33236] = { 60 }, -- Fizzy Faire Drink "Classic"
	[24007] = { 45 }, -- Footman's Waterskin
	[43086] = { 70 }, -- Fresh Apple Juice
	[44941] = { 70 }, -- Fresh-Squeezed Limeade
	[23161] = { 45 }, -- Freshly-Squeezed Lemonade
	[37253] = { 65 }, -- Frostberry Juice
	[30457] = { 65 }, -- Gilneas Sparkling Water
	[10841] = { 25 }, -- Goldthorn Tea
	[40357] = { 65 }, -- Grizzleberry Juice
	[24006] = { 45 }, -- Grunt's Waterskin
	[33445] = { 75 }, -- Honeymint Tea
	[18300] = { 55 }, -- Hyjal Nectar
	[1179] = { 5 }, -- Ice Cold Milk
	[1205] = { 15 }, -- Melon Juice
	[1645] = { 35 }, -- Moonberry Juice
	[8766] = { 45 }, -- Morning Glory Dew
	[44750] = { 65 }, -- Mountain Water
	[33444] = { 70 }, -- Pungent Seal Whey
	[27860] = { 65 }, -- Purified Draenic Water
	[159] = { 1 }, -- Refreshing Spring Water
	[29454] = { 60 }, -- Silverwine
	[29401] = { 65 }, -- Sparkling Southshore Cider
	[32455] = { 55 }, -- Star's Lament
	[43236] = { 75 }, -- Star's Sorrow
	[32453] = { 65 }, -- Star's Tears
	[23585] = { 45 }, -- Stouthammer Lite
	[1708] = { 25 }, -- Sweet Nectar
	[35954] = { 65 }, -- Sweetened Goat's Milk
	[41731] = { 75 }, -- Yeti Milk

	-- Both
	[19301] = { 50 }, -- Alterac Manna Biscuit
	[20062] = { 45 }, -- Arathi Basin Enriched Ration
	[20063] = { 25 }, -- Arathi Basin Field Ration
	[20064] = { 35 }, -- Arathi Basin Iron Ration
	[45932] = { 80 }, -- Black Jelly
	[34062] = { 65 }, -- Conjured Mana Biscuit
	[43518] = { 74 }, -- Conjured Mana Pie
	[43523] = { 80 }, -- Conjured Mana Strudel
	[2682] = { 5 }, -- Cooked Crab Claw
	[20222] = { 45 }, -- Defiler's Enriched Ration
	[20223] = { 25 }, -- Defiler's Field Ration
	[20224] = { 35 }, -- Defiler's Iron Ration
	[13724] = { 45 }, -- Enriched Manna Biscuit
	[32722] = { 55 }, -- Enriched Terocone Juice
	[20031] = { 55 }, -- Essence Mango
	[34760] = { 70 }, -- Grilled Bonescale
	[20225] = { 45 }, -- Highlander's Enriched Ration
	[20226] = { 25 }, -- Highlander's Field Ration
	[20227] = { 35 }, -- Highlander's Iron Ration
	[33053] = { 65 }, -- Hot Buttered Trout
	[34780] = { 65 }, -- Naaru Ration
	[13931] = { 35 }, -- Nightfin Soup
	[21153] = { 30 }, -- Raw Greater Sagefish
	[21071] = { 10 }, -- Raw Sagefish
	[34761] = { 70 }, -- Sauteed Goby
	[3448] = { 5 }, -- Senggin Root
	[34759] = { 70 }, -- Smoked Rockfin
	[28112] = { 60 }, -- Underspore Pod
	[19060] = { 45 }, -- Warsong Gulch Enriched Ration
	[19062] = { 25 }, -- Warsong Gulch Field Ration
	[19061] = { 35 }, -- Warsong Gulch Iron Ration

	-- Alcohol
	[23586] = { 1 }, -- Aerie Peak Pale Ale
	[32667] = { 65 }, -- Bash Ale
	[32424] = { 15 }, -- Blade's Edge Ogre Brew
	[2723] = { 1 }, -- Bottle of Pinot Noir
	[44571] = { 5 }, -- Bottle of Silvermoon Port
	[33929] = { 1 }, -- Brewfest Brew
	[40042] = { 15 }, -- Caraway Burnwine
	[29112] = { 1 }, -- Cenarion Spirits
	[19222] = { 1 }, -- Cheap Beer
	[4600] = { 25 }, -- Cherry Grog
	[44573] = { 15 }, -- Cup of Frog Venom Brew
	[19221] = { 1 }, -- Darkmoon Special Reserve
	[28284] = { 1 }, -- Don Carlos Tequila
	[18287] = { 1 }, -- Evermurky
	[23704] = { 1 }, -- Eversong Port
	[2594] = { 15 }, -- Flagon of Mead
	[44575] = { 5 }, -- Flask of Bitter Cactus Cider
	[2593] = { 5 }, -- Flask of Port
	[44618] = { 60 }, -- Glass of Aged Dalaran Red
	[44617] = { 1 }, -- Glass of Dalaran Red
	[44616] = { 60 }, -- Glass of Dalaran White
	[44570] = { 1 }, -- Glass of Eversong Wine
	[44619] = { 60 }, -- Glass of Peaked Dalaran Red
	[44620] = { 1 }, -- Glass of Vintage Dalaran Red
	[17402] = { 25 }, -- Greatfather's Winter Ale
	[43696] = { 1 }, -- Half Empty Bottle of Prison Moonshine
	[43695] = { 1 }, -- Half Full Bottle of Prison Moonshine
	[33956] = { 1 }, -- Harkor's Home Brew
	[17196] = { 1 }, -- Holiday Spirits
	[40035] = { 1 }, -- Honey Mead
	[2595] = { 25 }, -- Jug of Bourbon
	[4595] = { 1 }, -- Junglevine Wine
	[39520] = { 75 }, -- Kungaloosh
	[23584] = { 1 }, -- Loch Modan Lager
	[18288] = { 1 }, -- Molasses Firewater
	[23848] = { 35 }, -- Nethergarde Bitter
	[38432] = { 15 }, -- Plugger's Blackrock Ale
	[2596] = { 5 }, -- Skin of Dwarven Stout
	[44574] = { 25 }, -- Skin of Mulgore Firewater
	[40036] = { 5 }, -- Snowplum Brandy
	[17403] = { 5 }, -- Steamwheedle Fizzy Spirits
	[30309] = { 15 }, -- Stonebreaker Brew
	[23492] = { 1 }, -- Suntouched Special Reserve
	[46319] = { 1 }, -- Tournament Brew
	[38350] = { 1 }, -- Winterfin "Depth Charge"
}
