local _, ns = ...

-- [itemId] = { questId, ... }, -- Item Name
ns.ALLOWED_DELETE_QUEST_ITEMS = {
	--------------------------------------------------------------------------------
	-- 01. World of Warcraft
	--------------------------------------------------------------------------------

	[1358] = { 138 }, -- A Clue to Sander's Treasure
	[18513] = { 7508 }, -- A Dull and Flat Elven Blade
	[2839] = { 361 }, -- A Letter to Yvette
	[11116] = { 3884 }, -- A Mangled Journal
	[11107] = { 3845 }, -- A Small Pack
	[3317] = { 460 }, -- A Talking Head
	[4881] = { 830 }, -- Aged Envelope
	[20402] = { 8301 }, -- Agent of Nozdormu
	[11231] = { 4024 }, -- Altered Black Dragonflight Molt
	[5623] = { 934 }, -- Amethyst Phial
	[18152] = { 7383 }, -- Amethyst Phial
	[4843] = { 717 }, -- Amethyst Runestone
	[16787] = { 6570 }, -- Amulet of Draconic Subversion
	[17757] = { 7067 }, -- Amulet of Spirits
	[2794] = { 337 }, -- An Old History Book
	[2874] = { 373 }, -- An Unsent Letter
	[5338] = { 957 }, -- Ancient Moonstone Seal
	[1361] = { 139 }, -- Another Clue to Sander's Treasure
	[21136] = { 8729 }, -- Arcanite Buoy
	[18706] = { 7838 }, -- Arena Master
	[12846] = { 5213 }, -- Argent Dawn Commission
	[3668] = { 522 }, -- Assassin's Contract
	[12564] = { 4881 }, -- Assassination Note
	[12650] = { 105, 211 }, -- Attuned Dampener
	[11955] = { 4513 }, -- Bag of Empty Ooze Containers
	[12301] = { 2969 }, -- Bamboo Cage Key
	[21986] = { 9015, 9018 }, -- Banner of Provocation
	[15044] = { 6389, 6390 }, -- Barrel of Plagueland Termites
	[6929] = { 1712 }, -- Bath'rah's Parchment
	[12815] = { 5097, 5098 }, -- Beacon Torch
	[16408] = { 1918 }, -- Befouled Water Globe
	[4650] = { 736 }, -- Bel'dugur's Note
	[10575] = { 4024 }, -- Black Dragonflight Molt
	[16786] = { 6569 }, -- Black Dragonspawn Eye
	[18987] = { 7761 }, -- Blackhand's Command
	[11467] = { 4283 }, -- Blackrock Medallion
	[12341] = { 4763 }, -- Blackwood Fruit Sample
	[12342] = { 4763 }, -- Blackwood Grain Sample
	[12343] = { 4763 }, -- Blackwood Nut Sample
	[13523] = { 5384 }, -- Blood of Innocents
	[13140] = { 5202 }, -- Blood Red Key
	[12848] = { 5127 }, -- Blood Stained Pike
	[14650] = { 5844 }, -- Bloodhoof Village Gift Voucher
	[22094] = { 8970 }, -- Bloodkelp
	[11316] = { 4141, 4142 }, -- Bloodpetal
	[7668] = { 2201, 2339 }, -- Bloodstained Journal
	[6928] = { 1689 }, -- Bloodstone Choker
	[9282] = { 2930 }, -- Blue Punch Card
	[12558] = { 4882 }, -- Blue-feathered Necklace
	[13159] = { 5206 }, -- Bone Dust
	[4649] = { 735 }, -- Bonegrip's Note
	[11169] = { 4005 }, -- Book of Aquor
	[5352] = { 968 }, -- Book: The Powers Below
	[10695] = { 3568 }, -- Box of Empty Vials
	[20460] = { 8308 }, -- Brann Bronzebeard's Lost Letter
	[20461] = { 8308 }, -- Brann Bronzebeard's Lost Letter
	[22056] = { 8996 }, -- Brazier of Beckoning
	[14651] = { 5847 }, -- Brill Gift Voucher
	[5085] = { 899 }, -- Bristleback Quilboar Tusk
	[16783] = { 6543 }, -- Bundle of Reports
	[3499] = { 498 }, -- Burnished Gold Key
	[21776] = { 8887 }, -- Captain Kelisendra's Lost Rutters
	[15710] = { 6002 }, -- Cenarion Lunardust
	[15208] = { 6001 }, -- Cenarion Moondust
	[7907] = { 2282 }, -- Certificate of Thievery
	[18950] = { 7704 }, -- Chambermaid Pillaclencher's Pillow
	[19881] = { 8201 }, -- Channeler's Head
	[18749] = { 7647 }, -- Charger's Lost Soul
	[6839] = { 1701 }, -- Charred Horn
	[4926] = { 819 }, -- Chen's Empty Keg
	[7247] = { 1960, 1920 }, -- Chest of Containment Coffers
	[17693] = { 7029, 7041 }, -- Coated Cerulean Vial
	[5088] = { 894 }, -- Control Console Operating Manual
	[5585] = { 1058 }, -- Courser Eye
	[5738] = { 1079, 1080 }, -- Covert Ops Pack
	[5851] = { 1182 }, -- Cozzle's Key
	[5877] = { 1148 }, -- Cracked Silithid Carapace
	[7846] = { 2258, 2500 }, -- Crag Coyote Fang
	[12842] = { 5123 }, -- Crudely-written Log
	[5185] = { 921 }, -- Crystal Phial
	[11482] = { 4285, 4288, 4287 }, -- Crystal Pylon User's Manual
	[15826] = { 6124, 6129 }, -- Curative Animal Salve
	[12738] = { 5059 }, -- Dalson Outhouse Key
	[16790] = { 6564 }, -- Damp Note
	[11468] = { 4286 }, -- Dark Iron Fanny Pack
	[5462] = { 1029, 1030, 1045 }, -- Dartol's Rod of Transformation
	[12368] = { 4771 }, -- Dawn's Gambit
	[6783] = { 1667 }, -- Dead-tooth's Key
	[20741] = { 8470 }, -- Deadwood Ritual Totem
	[5570] = { 1069 }, -- Deepmoss Egg
	[5397] = { 166, 373 }, -- Defias Gunpowder
	[7269] = { 1944 }, -- Deino's Flask
	[14523] = { 5381 }, -- Demon Pick
	[22432] = { 9051 }, -- Devilsaur Barb
	[4845] = { 717 }, -- Diamond Runestone
	[4851] = { 781 }, -- Dirt-stained Map
	[18746] = { 7668, 8258 }, -- Divination Scryer
	[5456] = { 1016 }, -- Divining Scroll
	[6626] = { 1513 }, -- Dogran's Pendant
	[14648] = { 5842 }, -- Dolanaar Gift Voucher
	[7131] = { 1846 }, -- Dragonmaw Shinbone
	[10445] = { 3461 }, -- Drawing Kit
	[5068] = { 877 }, -- Dried Seeds
	[3467] = { 498 }, -- Dull Iron Key
	[7970] = { 2381 }, -- E.C.A.C.
	[6635] = { 1517, 1520 }, -- Earth Sapta
	[8432] = { 2609 }, -- Eau de Mixilpixil
	[13289] = { 5282 }, -- Egan's Blaster
	[10465] = { 3528 }, -- Egg of Hakkar
	[12144] = { 4735 }, -- Eggscilloscope
	[12286] = { 4734 }, -- Eggscilloscope Prototype
	[7767] = { 1534 }, -- Empty Blue Waterskin
	[7766] = { 1535 }, -- Empty Brown Waterskin
	[12922] = { 5157 }, -- Empty Canteen
	[12346] = { 4763 }, -- Empty Cleansing Bowl
	[15844] = { 6122 }, -- Empty Cliffspring Falls Sampler
	[15842] = { 6127 }, -- Empty Dreadmist Peak Sampler
	[12771] = { 5083 }, -- Empty Firewater Flask
	[9283] = { 2926 }, -- Empty Leaden Collection Phial
	[7768] = { 1536 }, -- Empty Red Waterskin
	[12350] = { 4762 }, -- Empty Sampling Tube
	[14338] = { 4812 }, -- Empty Water Tube
	[16974] = { 5247 }, -- Empty Water Vial
	[12262] = { 4729 }, -- Empty Worg Pup Cage
	[12288] = { 4642 }, -- Encased Corrupt Ooze
	[4529] = { 696 }, -- Enchanted Agate
	[16603] = { 6481 }, -- Enchanted Resonite Crystal
	[20023] = { 8235 }, -- Encoded Fragment
	[3706] = { 551 }, -- Ensorcelled Parchment
	[11617] = { 4005 }, -- Eridan's Supplies
	[11682] = { 4441 }, -- Eridan's Vial
	[10454] = { 3373 }, -- Essence of Eranikus
	[10663] = { 3528 }, -- Essence of Hakkar
	[11129] = { 3911, 7201 }, -- Essence of the Elements
	[5867] = { 1195 }, -- Etched Phial
	[11020] = { 3785, 3786, 3791 }, -- Evergreen Pouch
	[5021] = { 849 }, -- Explosive Stick of Gann
	[22115] = { 8977, 8978 }, -- Extra-Dimensional Ghost Revealer
	[4903] = { 832 }, -- Eye of Burning Shadow
	[11108] = { 3844 }, -- Faded Photograph
	[20938] = { 8547 }, -- Falconwing Square Gift Voucher
	[18626] = { 7603 }, -- Fel Fire
	[10834] = { 3602 }, -- Felhound Tracker Kit
	[18501] = { 5526 }, -- Felvine Shard
	[13157] = { 5206 }, -- Fetid Skull
	[8523] = { 654 }, -- Field Testing Kit
	[12347] = { 4763 }, -- Filled Cleansing Bowl
	[5868] = { 1197 }, -- Filled Etched Phial
	[1362] = { 140 }, -- Final Clue to Sander's Treasure
	[19036] = { 7843 }, -- Final Message to the Wildhammer
	[8066] = { 2458 }, -- Fizzule's Whistle
	[12814] = { 5096 }, -- Flame in a Bottle
	[8051] = { 2458 }, -- Flare Gun
	[20310] = { 1480 }, -- Flayed Demon Skin
	[6766] = { 1480 }, -- Flayed Demon Skin (old2)
	[11668] = { 939 }, -- Flute of Xavaric
	[11266] = { 4061 }, -- Fractured Elemental Shard
	[5810] = { 1136 }, -- Fresh Carcass
	[10338] = { 882 }, -- Fresh Zhevra Carcass
	[6842] = { 1701 }, -- Furen's Instructions
	[9323] = { 2937 }, -- Gadrin's Parchment
	[9978] = { 3161 }, -- Gahz'ridian Detector
	[5687] = { 1089 }, -- Gatekeeper's Key
	[17765] = { 7067 }, -- Gem of the Fifth Khan
	[17761] = { 7067 }, -- Gem of the First Khan
	[17764] = { 7067 }, -- Gem of the Fourth Khan
	[17762] = { 7067 }, -- Gem of the Second Khan
	[17763] = { 7067 }, -- Gem of the Third Khan
	[12337] = { 4742 }, -- Gemstone of Bloodaxe
	[12335] = { 4742 }, -- Gemstone of Smolderthorn
	[12336] = { 4742 }, -- Gemstone of Spirestone
	[12780] = { 5089 }, -- General Drakkisath's Command
	[11405] = { 4201 }, -- Giant Silver Vein
	[1962] = { 178 }, -- Glowing Shadowhide Pendant
	[10441] = { 6981 }, -- Glowing Shard
	[20464] = { 8315 }, -- Glyphs of Calling
	[7464] = { 1504 }, -- Glyphs of Summoning
	[8049] = { 2459 }, -- Gnarlpine Necklace
	[1307] = { 123 }, -- Gold Pickup Schedule
	[14646] = { 5805 }, -- Goldshire Gift Voucher
	[12721] = { 5051 }, -- Good Luck Half-Charm
	[12722] = { 5051 }, -- Good Luck Other-Half-Charm
	[11079] = { 3825 }, -- Gor'tesh's Lopped Off Head
	[9370] = { 2978 }, -- Gordunni Scroll
	[11833] = { 4507 }, -- Gorishi Queen Lure
	[22435] = { 9052 }, -- Gorishi Sting
	[9326] = { 2945 }, -- Grime-Encrusted Ring
	[9460] = { 2974 }, -- Grimtotem Horn
	[19851] = { 8150 }, -- Grom's Tribute
	[7442] = { 2078 }, -- Gyromast's Key
	[15883] = { 30, 272 }, -- Half Pendant of Aquatic Agility
	[15882] = { 30, 272 }, -- Half Pendant of Aquatic Endurance
	[12566] = { 4505 }, -- Hardened Flasket
	[5138] = { 897 }, -- Harvester's Head
	[13250] = { 5262 }, -- Head of Balnazzar
	[6913] = { 1739 }, -- Heartswood Core
	[9472] = { 2994 }, -- Hexx's Key
	[8095] = { 2480 }, -- Hinott's Oil
	[5099] = { 883 }, -- Hoof of Lakota'mani
	[10327] = { 881 }, -- Horn of Echeyakee
	[9530] = { 3062 }, -- Horn of Hatetalon
	[18598] = { 171 }, -- Human Orphan Whistle
	[20765] = { 8482 }, -- Incriminating Documents
	[20798] = { 8489 }, -- Intact Arcane Converter
	[12220] = { 1016 }, -- Intact Elemental Bracer
	[11269] = { 4063 }, -- Intact Elemental Core
	[9369] = { 2973 }, -- Iridescent Sprite Darter Wing
	[5619] = { 929 }, -- Jade Phial
	[12891] = { 5245 }, -- Jaron's Pick
	[7207] = { 1861 }, -- Jennea's Flask
	[6996] = { 1654 }, -- Jordan's Weapon Notes
	[10622] = { 3514 }, -- Kadrak's Flag
	[8046] = { 2359 }, -- Kearnen's Journal
	[14647] = { 5841 }, -- Kharanos Gift Voucher
	[5838] = { 1136 }, -- Kodo Skin Scroll
	[12472] = { 974 }, -- Krakle's Thermometer
	[14542] = { 5762 }, -- Kravel's Crate
	[21984] = { 8989, 8990, 8991, 8992 }, -- Left Piece of Lord Valthalak's Amulet
	[3898] = { 578 }, -- Library Scrip
	[14544] = { 5727 }, -- Lieutenant's Insignia
	[11136] = { 3913 }, -- Linken's Tempered Sword
	[15447] = { 6022 }, -- Living Rot
	[21378] = { 8804 }, -- Logistics Task Briefing I
	[21379] = { 8805 }, -- Logistics Task Briefing II
	[21380] = { 8806 }, -- Logistics Task Briefing III
	[21382] = { 8807 }, -- Logistics Task Briefing V
	[21514] = { 8829 }, -- Logistics Task Briefing XI
	[18804] = { 7647 }, -- Lord Grayson's Satchel
	[8047] = { 17, 2202 }, -- Magenta Fungus Cap
	[21112] = { 8620 }, -- Magical Book Binding
	[20949] = { 8575 }, -- Magical Ledger
	[10000] = { 3181 }, -- Margol's Horn
	[8524] = { 654 }, -- Model 4711-FTZ Power Source
	[18818] = { 7631 }, -- Mor'zul's Instructions
	[15454] = { 6022 }, -- Mortar and Pestle
	[5179] = { 927 }, -- Moss-twined Heart
	[11412] = { 4201 }, -- Nagmara's Vial
	[21042] = { 8606 }, -- Narain's Special Kit
	[15876] = { 6146 }, -- Nathanos' Chest
	[5695] = { 1079 }, -- NG-5 Explosives (Blue)
	[5694] = { 1079 }, -- NG-5 Explosives (Red)
	[15002] = { 2932 }, -- Nimboya's Pike
	[10792] = { 3638 }, -- Nixx's Pledge of Secrecy
	[6196] = { 1392 }, -- Noboru's Cudgel
	[11143] = { 3922 }, -- Nugget Slug
	[10794] = { 3642 }, -- Oglethorpe's Pledge of Secrecy
	[12534] = { 4867 }, -- Omokk's Head
	[8704] = { 485 }, -- OOX-09/HL Distress Beacon
	[8623] = { 351 }, -- OOX-17/TN Distress Beacon
	[8705] = { 2766 }, -- OOX-22/FE Distress Beacon
	[4844] = { 717 }, -- Opal Runestone
	[12300] = { 4743 }, -- Orb of Draconic Energy
	[18597] = { 5502 }, -- Orcish Orphan Whistle
	[10793] = { 3640 }, -- Overspark's Pledge of Secrecy
	[5102] = { 884 }, -- Owatanka's Tailspike
	[11912] = { 4512 }, -- Package of Empty Ooze Containers
	[12886] = { 5149 }, -- Pamela's Doll's Head
	[12887] = { 5149 }, -- Pamela's Doll's Left Side
	[12888] = { 5149 }, -- Pamela's Doll's Right Side
	[4614] = { 635 }, -- Pendant of Myzrael
	[18708] = { 7636 }, -- Petrified Bark
	[5251] = { 944 }, -- Phial of Scrying
	[13174] = { 5212 }, -- Plagued Flesh Sample
	[15043] = { 5901, 5903 }, -- Plagueland Termites
	[10590] = { 3482 }, -- Pocked Black Box
	[21211] = { 8746, 8762 }, -- Pouch of Reindeer Dust
	[9316] = { 2930 }, -- Prismatic Punch Card
	[5938] = { 1258 }, -- Pristine Crawler Leg
	[4702] = { 746 }, -- Prospector's Pick
	[6286] = { 1474 }, -- Pure Hearts
	[12906] = { 5165 }, -- Purified Moonwell Water
	[14649] = { 5843 }, -- Razor Hill Gift Voucher
	[9281] = { 2930 }, -- Red Punch Card
	[15209] = { 5721 }, -- Relic Bundle
	[18539] = { 5526 }, -- Reliquary of Purity
	[5693] = { 1079 }, -- Remote Detonator (Blue)
	[5692] = { 1079 }, -- Remote Detonator (Red)
	[22046] = { 8989, 8990, 8991, 8992 }, -- Right Piece of Lord Valthalak's Amulet
	[9309] = { 2928 }, -- Robo-mechanical Guts
	[15875] = { 6146 }, -- Rotten Apple
	[20613] = { 8421 }, -- Rotting Wood
	[12533] = { 4867 }, -- Roughshod Pike
	[10621] = { 3513 }, -- Runed Scroll
	[6284] = { 1471 }, -- Runes of Summoning
	[19883] = { 8201 }, -- Sacred Cord
	[12733] = { 5056 }, -- Sacred Frostsaber Meat
	[11147] = { 3924 }, -- Samophlange Manual Cover
	[11148] = { 3924 }, -- Samophlange Manual Page
	[5866] = { 1194 }, -- Sample of Indurium Ore
	[16333] = { 6395 }, -- Samuel's Remains
	[16784] = { 6563 }, -- Sapphire of Aku'Mai
	[8155] = { 2520 }, -- Sathrah's Sacrifice
	[19423] = { 7937 }, -- Sayge's Fortune #23
	[19424] = { 7938 }, -- Sayge's Fortune #24
	[19452] = { 7945 }, -- Sayge's Fortune #27
	[6838] = { 1701 }, -- Scorched Spider Fang
	[12807] = { 5096 }, -- Scourge Banner
	[4472] = { 656 }, -- Scroll of Myzrael
	[16304] = { 24 }, -- Shadumbra's Head
	[16305] = { 2 }, -- Sharptalon's Claw
	[7666] = { 2198 }, -- Shattered Necklace
	[9250] = { 2876 }, -- Ship Schedule
	[15877] = { 28, 29 }, -- Shrine Bauble
	[1532] = { 582 }, -- Shrunken Head
	[4450] = { 640 }, -- Sigil Fragment
	[5058] = { 868 }, -- Silithid Egg
	[17345] = { 1126 }, -- Silithid Goo
	[11172] = { 4084 }, -- Silvery Claws
	[14644] = { 5801, 5802 }, -- Skeleton Key Mold
	[13853] = { 5544 }, -- Slab of Carrion Worm Meat
	[17008] = { 6522 }, -- Small Scroll
	[15736] = { 6041 }, -- Smokey's Special Compound
	[21315] = { 8746, 8762 }, -- Smokywood Satchel
	[15874] = { 6142 }, -- Soft-shelled Clam
	[11725] = { 4450 }, -- Solid Crystal Leg Shaft
	[3912] = { 592 }, -- Soul Gem
	[13624] = { 5466 }, -- Soulbound Keepsake
	[13752] = { 5466 }, -- Soulbound Keepsake
	[12530] = { 4862 }, -- Spire Spider Egg
	[11804] = { 4491 }, -- Spraggle's Canteen
	[17115] = { 6661 }, -- Squirrel Token
	[17116] = { 6662 }, -- Squirrel Token
	[10444] = { 3449 }, -- Standard Issue Flare Gun
	[20604] = { 8373 }, -- Stink Bomb Cleaner
	[16782] = { 6922 }, -- Strange Water Globe
	[4506] = { 682 }, -- Stromgarde Badge
	[5165] = { 905 }, -- Sunscale Feather
	[20474] = { 8330 }, -- Sunstrider Book Satchel
	[6866] = { 1785, 1788, 9600 }, -- Symbol of Life
	[7516] = { 1948 }, -- Tabetha's Instructions
	[21751] = { 8536 }, -- Tactical Task Briefing III
	[20946] = { 8536 }, -- Tactical Task Briefing III
	[20943] = { 8498 }, -- Tactical Task Briefing X
	[20483] = { 8338 }, -- Tainted Arcane Sliver
	[8050] = { 2459 }, -- Tallonkai's Jewel
	[7667] = { 2201 }, -- Talvash's Phial of Scrying
	[7208] = { 1858 }, -- Tazan's Key
	[7209] = { 1963 }, -- Tazan's Satchel
	[5505] = { 1023 }, -- Teronis' Journal
	[7586] = { 2118 }, -- Tharnariun's Hope
	[7870] = { 2203, 2501 }, -- Thaumaturgy Vessel Lockbox
	[17781] = { 7067 }, -- The Pariah's Instructions
	[2154] = { 227 }, -- The Story of Morgan Ladimore
	[20415] = { 8303 }, -- The War of the Shifting Sands
	[17684] = { 7028 }, -- Theradric Crystal Carving
	[11286] = { 4121 }, -- Thorium Shackles
	[7587] = { 1838 }, -- Thun'grim's Instructions
	[5415] = { 758 }, -- Thunderhorn Cleansing Totem
	[5168] = { 918, 922 }, -- Timberling Seed
	[6775] = { 1642 }, -- Tome of Divinity
	[6916] = { 1646 }, -- Tome of Divinity
	[6999] = { 1795 }, -- Tome of the Cabal
	[6776] = { 1649 }, -- Tome of Valor
	[22047] = { 9015 }, -- Top Piece of Lord Valthalak's Amulet
	[10515] = { 3463 }, -- Torch of Retribution
	[11568] = { 4292 }, -- Torwa's Pouch
	[5621] = { 933 }, -- Tourmaline Phial
	[5638] = { 1086 }, -- Toxic Fogger
	[3248] = { 253 }, -- Translated Letter from The Embalmer
	[16991] = { 6622, 6624 }, -- Triage Bandage
	[9523] = { 3042 }, -- Troll Temper
	[9263] = { 2879 }, -- Troyas' Stave
	[12219] = { 4742 }, -- Unadorned Seal of Ascension
	[11463] = { 4281 }, -- Undelivered Parcel
	[12323] = { 4743 }, -- Unforged Seal of Ascension
	[5884] = { 1206 }, -- Unpopped Darkmist Eye
	[8584] = { 992 }, -- Untapped Dowsing Widget
	[7886] = { 2338 }, -- Untranslated Journal
	[11132] = { 3883 }, -- Unused Scraping Vial
	[16303] = { 23 }, -- Ursangous's Paw
	[19850] = { 8149 }, -- Uther's Tribute
	[12339] = { 4743 }, -- Vaelan's Gift
	[4904] = { 812 }, -- Venomtail Antidote
	[19016] = { 7785 }, -- Vessel of Rebirth
	[8149] = { 2561 }, -- Voodoo Charm
	[6074] = { 1380, 1381 }, -- War Horn Mouthpiece
	[12563] = { 4903 }, -- Warlord Goretooth's Command
	[12730] = { 4867 }, -- Warosh's Scroll
	[5103] = { 885 }, -- Washte Pawne's Feather
	[4823] = { 772 }, -- Water of the Seers
	[4433] = { 637 }, -- Waterlogged Envelope
	[1972] = { 184 }, -- Westfall Deed
	[9279] = { 2930 }, -- White Punch Card
	[5416] = { 760 }, -- Wildmane Cleansing Totem
	[12565] = { 4506 }, -- Winna's Kitten Carrier
	[20742] = { 8471 }, -- Winterfall Ritual Totem
	[5411] = { 754 }, -- Winterhoof Cleansing Totem
	[9320] = { 2932 }, -- Witherbark Skull
	[7273] = { 1948 }, -- Witherbark Totem Stick
	[5475] = { 1026 }, -- Wooden Key
	[13158] = { 5083 }, -- Words of the High Chief
	[9280] = { 2930 }, -- Yellow Punch Card
	[18904] = { 7003 }, -- Zorbin's Ultra-Shrinker

	--------------------------------------------------------------------------------
	-- 02. World of Warcraft : The Burning Crusade
	--------------------------------------------------------------------------------

	[37571] = { 12278 }, -- "Brew of the Month" Club Membership Form
	[37599] = { 12306 }, -- "Brew of the Month" Club Membership Form
	[37736] = { 12420 }, -- "Brew of the Month" Club Membership Form
	[37737] = { 12421 }, -- "Brew of the Month" Club Membership Form
	[33978] = { 11400 }, -- "Honorary Brewer" Hand Stamp
	[34028] = { 11419 }, -- "Honorary Brewer" Hand Stamp
	[22970] = { 9301 }, -- A Bloodstained Envelope
	[22972] = { 9299 }, -- A Careworn Note
	[22973] = { 9302 }, -- A Crumpled Missive
	[24132] = { 9672 }, -- A Letter from the Admiral
	[22723] = { 9247 }, -- A Letter from the Keeper of the Rolls
	[28552] = { 10229 }, -- A Mysterious Tome
	[22974] = { 9300 }, -- A Ragged Page
	[22975] = { 9304 }, -- A Smudged Document
	[22977] = { 9295 }, -- A Torn Letter
	[32567] = { 10980 }, -- Aether Ray Eye
	[23249] = { 9360 }, -- Amani Invasion Plans
	[28786] = { 10256 }, -- Apex's Crystal Focus
	[22796] = { 9275 }, -- Apothecary's Poison
	[23706] = { 9487 }, -- Arcane Fragment
	[28455] = { 10174, 10188, 10192, 10209, 10301 }, -- Archmage Vargoth's Staff
	[31955] = { 9374 }, -- Arelion's Knapsack
	[32454] = { 11001 }, -- Arthorn's Research
	[31946] = { 10946 }, -- Ashtongue Cowl
	[23580] = { 9418 }, -- Avruu's Orb
	[23566] = { 9403 }, -- Azure Phial
	[22888] = { 9278 }, -- Azure Watch Gift Voucher
	[28336] = { 10305 }, -- Belmara's Tome
	[29234] = { 10305 }, -- Belmara's Tome
	[30425] = { 10538 }, -- Bleeding Hollow Blood
	[31347] = { 10792 }, -- Bleeding Hollow Torch
	[25817] = { 10021 }, -- Blessed Vial
	[23910] = { 9616 }, -- Blood Elf Communication
	[30639] = { 10577 }, -- Blood Elf Disguise
	[31880] = { 10967 }, -- Blood Elf Orphan Whistle
	[24414] = { 9798 }, -- Blood Elf Plans
	[24223] = { 9692 }, -- Bloodvalor's Notes
	[30808] = { 10649 }, -- Book of Fel Names
	[30854] = { 10692 }, -- Book of Fel Names
	[29429] = { 10221 }, -- Boom's Doom
	[25490] = { 9923 }, -- Boulderfist Key
	[23801] = { 9544 }, -- Bristlelimb Key
	[30616] = { 10570 }, -- Bundle of Bloodthistle
	[24221] = { 9689 }, -- Bundle of Dragon Bones
	[29588] = { 10395 }, -- Burning Legion Missive
	[29590] = { 10393 }, -- Burning Legion Missive
	[31707] = { 10880 }, -- Cabal Orders
	[31536] = { 10821 }, -- Camp Anger Key
	[23693] = { 9472 }, -- Carinda's Scroll of Retribution
	[31702] = { 10876 }, -- Challenge from the Horde
	[25648] = { 9955 }, -- Cho'war's Key
	[24289] = { 10297 }, -- Chrono-beacon
	[28353] = { 10307 }, -- Cohlien's Cap
	[29236] = { 10307 }, -- Cohlien's Cap
	[30426] = { 10522 }, -- Coilskar Chest Key
	[29207] = { 10173 }, -- Conjuring Powder
	[25459] = { 9911 }, -- "Count" Ungula's Mandible
	[25766] = { 10009 }, -- "Creatures That Owe Sal'salabim Golds"
	[29476] = { 10134 }, -- Crimson Crystal Shard
	[23191] = { 9169 }, -- Crystal Controlling Orb
	[31736] = { 10833 }, -- Crystal of Deep Shadows
	[31384] = { 10810 }, -- Damaged Mask
	[28351] = { 10182 }, -- Dathric's Blade
	[29233] = { 10182 }, -- Dathric's Blade
	[30688] = { 10586, 10603 }, -- Deathforge Key
	[28513] = { 10144, 10208 }, -- Demonic Rune Stone
	[30650] = { 10566 }, -- Dertrok's Wand Case
	[23777] = { 9520 }, -- Diabolical Plans
	[23797] = { 9535 }, -- Diabolical Plans
	[38280] = { 12491 }, -- Direbrew's Dire Brew
	[38281] = { 12492 }, -- Direbrew's Dire Brew
	[31812] = { 10923, 10925 }, -- Doom Skull
	[24084] = { 9666 }, -- Draenei Banner
	[31881] = { 10966 }, -- Draenei Orphan Whistle
	[24330] = { 9731 }, -- Drain Schematics
	[31763] = { 10912 }, -- Druid Signal
	[23485] = { 9397 }, -- Empty Birdcage
	[23749] = { 9504 }, -- Empty Bota Bag
	[31279] = { 10769, 10776 }, -- Enchanted Illidari Tabard
	[23338] = { 9373 }, -- Eroded Leather Case
	[29482] = { 10385 }, -- Ethereum Essence
	[25840] = { 10029 }, -- Extract of the Afterlife
	[23678] = { 9455 }, -- Faintly Glowing Crystal
	[23695] = { 9475 }, -- Featherbeard's Map
	[25770] = { 10011 }, -- Fel Cannon Activator
	[25771] = { 10011 }, -- Fel Cannon Activator
	[31366] = { 10819 }, -- Felsworn Gas Mask
	[24184] = { 9685 }, -- Filled Shimmering Vessel
	[24336] = { 9467 }, -- Fireproof Satchel
	[23184] = { 9332 }, -- Flame of Darnassus
	[23183] = { 9331 }, -- Flame of Ironforge
	[23179] = { 9324 }, -- Flame of Orgrimmar
	[35568] = { 11935 }, -- Flame of Silvermoon
	[23182] = { 9330 }, -- Flame of Stormwind
	[35569] = { 11933 }, -- Flame of the Exodar
	[23181] = { 9326 }, -- Flame of the Undercity
	[23180] = { 9325 }, -- Flame of Thunder Bluff
	[28550] = { 10233 }, -- Flaming Torch
	[24278] = { 9711 }, -- Flare Gun
	[33106] = { 11164 }, -- Forest Troll Tusk
	[30875] = { 10679 }, -- Forged Illidari-Bane Blade
	[22727] = { 9250 }, -- Frame of Atiesh
	[30850] = { 10641 }, -- Freshly Drawn Blood
	[24475] = { 9821 }, -- Gordawg's Imprint
	[31363] = { 10797 }, -- Gorgrom's Favor
	[23735] = { 9494 }, -- Grand Warlock's Amulet
	[25866] = { 10045 }, -- Greatmother's List of Herbs
	[33061] = { 11145 }, -- Grimtotem Key
	[33050] = { 11144, 11201 }, -- Grimtotem Note
	[31754] = { 10723, 10802 }, -- Grisly Totem
	[23850] = { 9564 }, -- Gurf's Dignity
	[24504] = { 9861 }, -- Howling Wind
	[31350] = { 10721 }, -- Huffer's Whistle
	[32823] = { 11089 }, -- Illidari Lord Balthas' Instructions
	[30579] = { 10623 }, -- Illidari-Bane Shard
	[30756] = { 10621 }, -- Illidari-Bane Shard
	[22693] = { 8490 }, -- Infused Crystal
	[30655] = { 10566 }, -- Infused Vekh'nir Crystal
	[29206] = { 10173 }, -- Inquisitor's Crest - Bottom Half
	[29205] = { 10173 }, -- Inquisitor's Crest - Top Half
	[32523] = { 11021 }, -- Ishaal's Almanac
	[24277] = { 9723, 64141 }, -- Items for Magister Astalor Bloodsworn
	[25684] = { 9975, 9976 }, -- Kokorek's Talisman
	[31108] = { 10769 }, -- Kor'kron Flare Gun
	[31698] = { 10883 }, -- Letter from Shattrath
	[25705] = { 9984 }, -- Luanga's Orders
	[25706] = { 9985 }, -- Luanga's Orders
	[28352] = { 10306 }, -- Luminrath's Mantle
	[29235] = { 10306 }, -- Luminrath's Mantle
	[31120] = { 10719 }, -- Meeting Note
	[31678] = { 10857 }, -- Mental Interference Rod
	[32462] = { 11001 }, -- Morthis' Materials
	[32726] = { 11081 }, -- Murkblood Escape Plans
	[24558] = { 9872 }, -- Murkblood Invasion Plans
	[24559] = { 9871 }, -- Murkblood Invasion Plans
	[24470] = { 9816 }, -- Murloc Cage
	[31387] = { 10812 }, -- Mystery Mask
	[31124] = { 10712 }, -- Nether-weather Vane
	[22955] = { 9294 }, -- Neutralizing Agent
	[28664] = { 10252 }, -- Nitrin's Instructions
	[23847] = { 9561 }, -- Nolkai's Band
	[25509] = { 9924 }, -- Northwind Cleft Key
	[23228] = { 8474 }, -- Old Whitebark's Pendant
	[25745] = { 9993, 9992 }, -- Olemba Seed
	[22719] = { 9233 }, -- Omarion's Handbook
	[23890] = { 9587 }, -- Ominous Letter
	[23892] = { 9588 }, -- Ominous Letter
	[31489] = { 10825 }, -- Orb of the Grishna
	[24367] = { 9764 }, -- Orders from Lady Vashj
	[25853] = { 10283 }, -- Pack of Incendiary Bombs
	[32621] = { 11041 }, -- Partially Digested Hand
	[30858] = { 10238 }, -- Peon Sleep Potion
	[29778] = { 10438 }, -- Phase Disruptor
	[30529] = { 10555 }, -- Plucked Lashh'an Feather
	[23871] = { 9501 }, -- Potion of Water Breathing
	[25539] = { 9773, 9774, 9780, 9781, 9834, 9845, 9902, 9903, 9904, 9905 }, -- Potion of Water Breathing
	[34862] = { 11731, 11922 }, -- Practice Torches
	[31522] = { 10831 }, -- Primal Mooncloth Supplies
	[31239] = { 10754 }, -- Primed Key Mold
	[31241] = { 10755 }, -- Primed Key Mold
	[23248] = { 9361 }, -- Purified Helboar Meat
	[33306] = { 11122, 11318, 11409, 11412 }, -- Ram Racing Reins
	[33070] = { 11147 }, -- Raptor Bait
	[23925] = { 9582 }, -- Ravager Cage Key
	[34130] = { 1456 }, -- Recovery Diver's Potion
	[23870] = { 9576 }, -- Red Crystal Pendant
	[33045] = { 11140 }, -- Renn's Supplies
	[33040] = { 11140 }, -- Repaired Diving Gear
	[31372] = { 10804 }, -- Rocknail Flayer Carcass
	[31373] = { 10804 }, -- Rocknail Flayer Giblets
	[23759] = { 9514 }, -- Rune Covered Tablet
	[30704] = { 10567 }, -- Ruuan'ok Claw
	[23417] = { 9383 }, -- Sanctified Crystal
	[30811] = { 10637, 10688 }, -- Scroll of Demonic Unbanishing
	[33114] = { 11185 }, -- Sealed Letter
	[33115] = { 11186 }, -- Sealed Letter
	[35723] = { 11972 }, -- Shards of Ahune
	[24157] = { 9684 }, -- Shimmering Vessel
	[23358] = { 9370 }, -- Signaling Gem
	[31739] = { 10895 }, -- Smoke Beacon
	[29699] = { 10410 }, -- Socrethar's Teleportation Stone
	[29796] = { 10507 }, -- Socrethar's Teleportation Stone
	[30721] = { 10633, 10644 }, -- Spectrecles
	[31663] = { 10853 }, -- Spirit Calling Totems
	[31524] = { 10831 }, -- Square of Imbued Netherweave
	[23818] = { 9538 }, -- Stillpine Furbolg Language Primer
	[23270] = { 9361 }, -- Tainted Helboar Meat
	[30540] = { 10710 }, -- Tally's Waiver (Unsigned)
	[33009] = { 11129 }, -- Tender Strider Meat
	[30712] = { 10606, 10611 }, -- The Doctor's Key
	[29912] = { 10446, 10447 }, -- The Final Code
	[24099] = { 9667 }, -- The High Chief's Key
	[31345] = { 10793 }, -- The Journal of Val'zareq
	[22597] = { 9175 }, -- The Lady's Necklace
	[32888] = { 10098 }, -- The Relics of Terokk
	[29742] = { 10422 }, -- The Warden's Key
	[30431] = { 10524 }, -- Thunderlord Clan Artifact
	[35828] = { 11886 }, -- Totemic Beacon
	[23355] = { 9361 }, -- Toxic Helboar Meat
	[30618] = { 10035, 10036 }, -- Trachela's Carcass
	[23788] = { 9526, 10771 }, -- Tree Seedlings
	[23900] = { 9594 }, -- Tzerak's Armor Plate
	[31360] = { 10782 }, -- Unfinished Headpiece
	[31251] = { 10758, 10764 }, -- Unfired Key Mold
	[34833] = { 11657, 11923 }, -- Unlit Torches
	[31655] = { 10852 }, -- Veil Skith Prison Key
	[30561] = { 10565 }, -- Vekh'nir Crystal
	[31525] = { 10831 }, -- Vial of Primal Reagents
	[29738] = { 10413 }, -- Vial of Void Horror Ooze
	[29161] = { 10294 }, -- Void Ridge Soul Shard
	[23732] = { 9619 }, -- Voidstone
	[30260] = { 10507 }, -- Voren'thal's Package
	[28113] = { 10130 }, -- Warboss Nekrogg's Orders
	[28114] = { 10152 }, -- Warboss Nekrogg's Orders
	[25604] = { 9948 }, -- Warmaul Prison Key
	[24502] = { 9853 }, -- Warmaul Skull
	[31813] = { 10924 }, -- Warp Chaser Blood
	[24318] = { 9748 }, -- Water Sample Flask
	[23837] = { 9550 }, -- Weathered Treasure Map
	[31310] = { 10776 }, -- Wildhammer Flare Gun
	[24483] = { 9827 }, -- Withered Basidium
	[24484] = { 9828 }, -- Withered Basidium
	[33082] = { 11152 }, -- Wreath
	[31755] = { 10724 }, -- Wyvern Cage Key
	[33163] = { 11207, 11208 }, -- Zeppelin Cargo
	[31664] = { 10866, 10872 }, -- Zuluhed's Key
}

--[[
How We Got the Data

Last Validated
	2026-10-09, TBC Anniversary 2.5.6.69795

Notes
	- Quest items the player can still be holding once the quest is done, each keyed to the quest whose completion makes it safe to erase. The row fires on the first listed quest flagged complete (Features/Junk-Rules.lua); Features/Quest-Item-Alerts.lua reads it too.
	- Key each row to the LATEST quest that could still need the item. Erasing an item the player still needs can't be undone, while erasing it a few minutes late costs nothing.
		- In a chain, that's the quest that takes the item at turn-in, never the one that hands it out.
		- Where the item belongs to a quest series, wait for the series' final quest, even past the step that uses it: Symbol of Life (6866) is keyed to 1785 and 1788, the last Tome of Divinity steps, not 1783 and 1786, where it resurrects Narm and Henze Faulk.
		- Where sibling quests that exclude each other meet in a final quest, key to the final quest and list no sibling, so one ID covers every branch. Black Dragonflight Molt (10575) is keyed to 4024, not its sibling 4023: finishing 4023 is what spawns the dragon the molt drops from.
		- Where the quest that hands the item out is itself the last step, key to it, not the step before, which would erase the item as it's handed over.
		- Never key to a quest that hands the item out while a later quest still needs it. Divination Scryer comes from both 7647 Judgment and Redemption and 7668 The Darkreaver Menace; keyed to 7647, it would be erased before Scholomance.
		- Two different quests in one chain on one row still erase at the first one done.
	- Quest IDs don't show chain order (4121 comes after 4122). Confirm the order on each quest's own page, never from the ID sequence or a previous/next widget.
	- A row earns its place only if the item can still be in the bag after its quest is done. An item the turn-in takes is gone by the time the quest is flagged complete, so its row could never fire: Ol' Sooty's Head, Crown of Will and Karnitol's Satchel are real turn-ins and rightly absent. That's why the table is a small hand-picked slice of what the queries find, never a paste of them.
	- Three kinds of item pass that test:
		- Surplus: it drops in multiples and the turn-in takes a fixed count, so you finish with spares. Need 20, they drop 2 or 3 at a time, you end up holding 21. The first query finds these; its lingers column marks them.
		- Items no quest ever takes back, found by the second query: signal gear you fire to call someone (Standard Issue Flare Gun, Brave's Flare, Horn of Kamagua; in a group only one player fires, and everyone else keeps theirs), read-me props handed over just to say where to go (Crafty's Shopping List, Greatmother's List of Herbs, Nitrin's Instructions), and tools used on the world while something else is the turn-in (Empty Cleansing Bowl, Divination Scryer, Arcanometer).
		- Superseded items, which neither query finds: an item no quest takes, retired by a better one a quest pays out. Argent Dawn Commission (12846) is keyed to 5213 The Active Agent, which neither hands it out nor takes it, but pays Seal of the Dawn or Rune of the Dawn; both collect scourgestones in its place and carry real stats. The quests that hand the Commission out (5401, 5405, 5503) are repeatable, so erasing one early costs little: the player takes another. Rows like this are keyed by hand, so an audit against either query reports them as orphans, and that's expected.
	- Containers holding a quest's payload stay in (Covert Ops Pack, Smokywood Satchel, Box of Empty Vials): the row fires only once the quest is done, when their contents are spent too, and in a group only one player's container ever gets opened. A real bag stays out, because it holds the player's own loot, and so does anything the game won't let you destroy.
	- An item that starts a quest belongs in Quest-Starting-Items-TBC.lua, whose rows also carry the race and class limits that make a wrong-faction starter erasable with no quest state. Every starter the second query found started the same quest that hands it out, so its row would only repeat that quest without the limits, and GetQuestStarterReason in Features/Junk-Rules.lua answers for it first anyway. The overlap already in the two tables is deliberate and stays; the second query just doesn't propose new duplicates.
	- Matching item names against quest text finds nothing useful. Short names swamp it (Boulder hits 44 quests, Stick 21, Holy Water 6), and the names that matter never match, because quest text abbreviates: Xiggs says "toss the flare gun", never "Standard Issue Flare Gun".
	- Check every row from the second query on Wowhead before adding it. Nothing there proves the item is spent: use_quests is the only evidence, present for a minority of rows, and the rest are keyed to their lone granting quest as a guess. A row with more than one granting quest is never keyed without reading it.

SQL (CMaNGOS)
	CMaNGOS WotLK world DB (wotlk-db), MySQL 8. Two queries that find candidates; they never produce rows to paste.

	-- Roles in quest_template:
	--   SrcItemId        handed to you when you ACCEPT
	--   ReqSourceId1..4  extra items handed to you when you ACCEPT
	--   ReqItemId1..6    taken from you when you TURN IN (the usual key)
	--
	-- late_handin = 1 marks a turn-in quest that isn't also the granting quest. A row with 2+
	-- hand-in quests needs an eye: the same title repeated is usually a faction or class variant,
	-- safe to list in full, but it's also what converging siblings look like (A Taste of Flame
	-- is 4022, 4023 and 4024), so check the chain before listing them all.
	--
	-- To audit the table instead of regenerating it, wrap this file's rows as a leading CTE and
	-- diff against the result:
	--   WITH me_current (item, quests, name) AS (
	--               SELECT 10445,'3461','Drawing Kit'
	--     UNION ALL SELECT ... ),
	--   ...

	-- FIRST QUERY: items a turn-in consumes, with the surplus that can linger marked.

	SET SESSION group_concat_max_len = 16384;

	WITH granted AS (
	      SELECT SrcItemId AS item, entry AS quest FROM quest_template WHERE SrcItemId     > 0 AND Method <> 0
	  UNION SELECT ReqSourceId1, entry FROM quest_template WHERE ReqSourceId1 > 0 AND Method <> 0
	  UNION SELECT ReqSourceId2, entry FROM quest_template WHERE ReqSourceId2 > 0 AND Method <> 0
	  UNION SELECT ReqSourceId3, entry FROM quest_template WHERE ReqSourceId3 > 0 AND Method <> 0
	  UNION SELECT ReqSourceId4, entry FROM quest_template WHERE ReqSourceId4 > 0 AND Method <> 0
	),
	handed_in AS (
	      SELECT ReqItemId1 AS item, entry AS quest FROM quest_template WHERE ReqItemId1 > 0 AND Method <> 0
	  UNION SELECT ReqItemId2, entry FROM quest_template WHERE ReqItemId2 > 0 AND Method <> 0
	  UNION SELECT ReqItemId3, entry FROM quest_template WHERE ReqItemId3 > 0 AND Method <> 0
	  UNION SELECT ReqItemId4, entry FROM quest_template WHERE ReqItemId4 > 0 AND Method <> 0
	  UNION SELECT ReqItemId5, entry FROM quest_template WHERE ReqItemId5 > 0 AND Method <> 0
	  UNION SELECT ReqItemId6, entry FROM quest_template WHERE ReqItemId6 > 0 AND Method <> 0
	),
	needed AS (
	  -- How many the turn-in actually takes. UNION ALL, not UNION: we only MAX it.
	      SELECT ReqItemId1 AS item, ReqItemCount1 AS need FROM quest_template WHERE ReqItemId1 > 0 AND Method <> 0
	  UNION ALL SELECT ReqItemId2, ReqItemCount2 FROM quest_template WHERE ReqItemId2 > 0 AND Method <> 0
	  UNION ALL SELECT ReqItemId3, ReqItemCount3 FROM quest_template WHERE ReqItemId3 > 0 AND Method <> 0
	  UNION ALL SELECT ReqItemId4, ReqItemCount4 FROM quest_template WHERE ReqItemId4 > 0 AND Method <> 0
	  UNION ALL SELECT ReqItemId5, ReqItemCount5 FROM quest_template WHERE ReqItemId5 > 0 AND Method <> 0
	  UNION ALL SELECT ReqItemId6, ReqItemCount6 FROM quest_template WHERE ReqItemId6 > 0 AND Method <> 0
	),
	n_agg AS (
	  SELECT item, MAX(need) AS max_need FROM needed GROUP BY item
	),
	g_agg AS (
	  SELECT item, GROUP_CONCAT(DISTINCT quest ORDER BY quest) AS grant_quests
	  FROM granted GROUP BY item
	),
	h_agg AS (
	  SELECT item, GROUP_CONCAT(DISTINCT quest ORDER BY quest) AS handin_quests,
	         COUNT(DISTINCT quest) AS n_handin
	  FROM handed_in GROUP BY item
	)
	SELECT
	  -- The only reason a turn-in item is ever still in the bag: the drop comes in
	  -- multiples and the turn-in takes a fixed count, so you overshoot. Anything
	  -- marked consumed-clean is gone the moment its quest completes and can never
	  -- fire a row. See the header.
	  CASE WHEN n.max_need > 1 AND (it.maxcount = 0 OR it.maxcount > n.max_need)
	       THEN '1 surplus possible' ELSE '2 consumed clean' END  AS lingers,
	  CASE WHEN it.entry < 22500 THEN '01 WoW'
	       WHEN it.entry < 33117 THEN '02 TBC'
	       ELSE '03 WotLK' END                                AS section,
	  (EXISTS (SELECT 1 FROM handed_in h2
	            WHERE h2.item = it.entry
	              AND NOT EXISTS (SELECT 1 FROM granted g2
	                               WHERE g2.item = h2.item AND g2.quest = h2.quest)))  AS late_handin,
	  it.entry AS item, it.name, g.grant_quests, h.handin_quests, h.n_handin,
	  NULLIF(it.startquest, 0) AS starts_quest, it.Quality AS quality, it.class,
	  n.max_need AS taken_per_turnin, it.maxcount AS stack_cap,
	  (SELECT GROUP_CONCAT(CONCAT(h2.quest, '=', qt.Title) ORDER BY h2.quest SEPARATOR ' | ')
	     FROM handed_in h2 JOIN quest_template qt ON qt.entry = h2.quest
	    WHERE h2.item = it.entry)                             AS handin_titles,
	  CONCAT('\t[', it.entry, '] = { ', REPLACE(h.handin_quests, ',', ', '),
	         ' }, -- ', it.name)                              AS lua_line
	FROM h_agg h
	JOIN g_agg g          ON g.item  = h.item
	JOIN n_agg n          ON n.item  = h.item
	JOIN item_template it ON it.entry = h.item
	WHERE it.name NOT LIKE '%Test%'
	  AND it.name NOT LIKE '%[PH]%'
	  AND it.name NOT LIKE '%UNUSED%'
	  AND it.name NOT LIKE '%DEPRECATED%'
	  AND it.name NOT LIKE 'OLD %'
	ORDER BY lingers, late_handin DESC, section, it.name;

	-- SECOND QUERY: items a quest hands out that no quest ever takes back (the anti-join).
	-- Openables (Flags & 4, ITEM_FLAG_HAS_LOOT) are deliberately not filtered. Flags & 32 is
	-- NO_USER_DESTROY. If a column is named differently on your schema, check with
	--   SHOW COLUMNS FROM quest_template LIKE '%Spell%';
	--   SHOW COLUMNS FROM item_template LIKE '%ontainer%';

	SET SESSION group_concat_max_len = 16384;

	WITH granted AS (
	      SELECT SrcItemId    AS item, entry AS quest FROM quest_template WHERE SrcItemId    > 0 AND Method <> 0
	  UNION SELECT ReqSourceId1,       entry          FROM quest_template WHERE ReqSourceId1 > 0 AND Method <> 0
	  UNION SELECT ReqSourceId2,       entry          FROM quest_template WHERE ReqSourceId2 > 0 AND Method <> 0
	  UNION SELECT ReqSourceId3,       entry          FROM quest_template WHERE ReqSourceId3 > 0 AND Method <> 0
	  UNION SELECT ReqSourceId4,       entry          FROM quest_template WHERE ReqSourceId4 > 0 AND Method <> 0
	),
	taken AS (
	  -- Protective exclusion, so deliberately no Method <> 0 filter: a disabled quest still shields its item.
	      SELECT ReqItemId1 AS item FROM quest_template WHERE ReqItemId1 > 0
	  UNION SELECT ReqItemId2        FROM quest_template WHERE ReqItemId2 > 0
	  UNION SELECT ReqItemId3        FROM quest_template WHERE ReqItemId3 > 0
	  UNION SELECT ReqItemId4        FROM quest_template WHERE ReqItemId4 > 0
	  UNION SELECT ReqItemId5        FROM quest_template WHERE ReqItemId5 > 0
	  UNION SELECT ReqItemId6        FROM quest_template WHERE ReqItemId6 > 0
	),
	item_spells AS (
	      SELECT entry AS item, spellid_1 AS spell FROM item_template WHERE spellid_1 > 0
	  UNION SELECT entry,       spellid_2          FROM item_template WHERE spellid_2 > 0
	  UNION SELECT entry,       spellid_3          FROM item_template WHERE spellid_3 > 0
	  UNION SELECT entry,       spellid_4          FROM item_template WHERE spellid_4 > 0
	  UNION SELECT entry,       spellid_5          FROM item_template WHERE spellid_5 > 0
	),
	cast_on AS (
	      SELECT ReqSpellCast1 AS spell, entry AS quest FROM quest_template WHERE ReqSpellCast1 > 0 AND Method <> 0
	  UNION SELECT ReqSpellCast2,        entry          FROM quest_template WHERE ReqSpellCast2 > 0 AND Method <> 0
	  UNION SELECT ReqSpellCast3,        entry          FROM quest_template WHERE ReqSpellCast3 > 0 AND Method <> 0
	  UNION SELECT ReqSpellCast4,        entry          FROM quest_template WHERE ReqSpellCast4 > 0 AND Method <> 0
	),
	g_agg AS (
	  SELECT g.item,
	         GROUP_CONCAT(DISTINCT g.quest ORDER BY g.quest) AS grant_quests,
	         COUNT(DISTINCT g.quest)                         AS n_grant,
	         MAX((q.SpecialFlags &     1) <> 0
	          OR (q.QuestFlags   &  4096) <> 0
	          OR (q.QuestFlags   & 32768) <> 0)              AS any_repeatable
	  FROM granted g
	  JOIN quest_template q ON q.entry = g.quest
	  GROUP BY g.item
	),
	u_agg AS (
	  SELECT s.item, GROUP_CONCAT(DISTINCT c.quest ORDER BY c.quest) AS use_quests
	  FROM item_spells s
	  JOIN cast_on c ON c.spell = s.spell
	  GROUP BY s.item
	)
	SELECT
	  -- 1 keys on a spell some quest actually requires, 2 on a lone granting
	  -- quest, 3 is the multi-grant pile that must never be keyed unread.
	  CASE WHEN u.use_quests IS NOT NULL THEN '1 use-linked'
	       WHEN g.n_grant = 1            THEN '2 single-grant'
	       ELSE                               '3 MULTI-GRANT, read before using'
	  END                                                    AS confidence,
	  CASE WHEN it.entry < 22500 THEN '01 WoW'
	       WHEN it.entry < 33117 THEN '02 TBC'
	       ELSE '03 WotLK' END                               AS section,
	  it.entry AS item, it.name,
	  g.grant_quests, g.n_grant, u.use_quests,
	  (SELECT GROUP_CONCAT(CONCAT(g2.quest, '=', qt.Title) ORDER BY g2.quest SEPARATOR ' | ')
	     FROM granted g2 JOIN quest_template qt ON qt.entry = g2.quest
	    WHERE g2.item = it.entry)                            AS grant_titles,
	  (SELECT GROUP_CONCAT(CONCAT(c2.quest, '=', qt.Title) ORDER BY c2.quest SEPARATOR ' | ')
	     FROM item_spells s2
	     JOIN cast_on c2        ON c2.spell = s2.spell
	     JOIN quest_template qt ON qt.entry = c2.quest
	    WHERE s2.item = it.entry)                            AS use_titles,
	  (SELECT GROUP_CONCAT(DISTINCT qt.NextQuestInChain ORDER BY qt.NextQuestInChain)
	     FROM granted g3 JOIN quest_template qt ON qt.entry = g3.quest
	    WHERE g3.item = it.entry AND qt.NextQuestInChain > 0) AS next_in_chain,
	  it.Quality AS quality, it.class, it.Bonding AS bind, it.Flags AS flags,
	  it.ContainerSlots AS bag_slots,
	  it.maxcount AS max_count, it.spellcharges_1 AS charges,
	  CONCAT('\t[', it.entry, '] = { ',
	         REPLACE(COALESCE(u.use_quests, g.grant_quests), ',', ', '),
	         ' }, -- ', it.name)                             AS lua_line
	FROM g_agg g
	JOIN item_template it ON it.entry = g.item
	LEFT JOIN u_agg u     ON u.item   = g.item
	WHERE NOT EXISTS (SELECT 1 FROM taken t WHERE t.item = g.item)
	  AND g.any_repeatable = 0            -- a completed flag proves nothing there
	  AND it.Quality <= 1                 -- a granted blue is a keeper, not clutter
	  AND (it.class = 12 OR it.Bonding IN (1, 4))
	  AND it.ContainerSlots = 0           -- a real bag holds the player's own loot
	  AND (it.Flags & 32) = 0             -- client refuses to destroy these anyway
	  AND it.startquest = 0               -- Quest-Starting-Items-TBC.lua owns these
	  AND it.name NOT LIKE '%Test%'
	  AND it.name NOT LIKE '%[PH]%'
	  AND it.name NOT LIKE '%UNUSED%'
	  AND it.name NOT LIKE '%DEPRECATED%'
	  AND it.name NOT LIKE 'OLD %'
	  AND it.name NOT LIKE '%(old%'
	ORDER BY confidence, section, it.name;

Wowhead
	None.

wago.tools
	None.
]]
