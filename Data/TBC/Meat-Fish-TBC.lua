local _, ns = ...

-- [itemId] = {Level}, -- Item Name
ns.ALLOWED_DELETE_MEAT_FISH = {
	-- Edible: raw fish you can eat as caught. Level is the use level.
	[13888] = { 45 }, -- Darkclaw Lobster
	[13893] = { 45 }, -- Large Raw Mightfish
	[6291] = { 1 }, -- Raw Brilliant Smallfish
	[6308] = { 15 }, -- Raw Bristle Whisker Catfish
	[13754] = { 35 }, -- Raw Glossy Mightfish
	[21153] = { 30 }, -- Raw Greater Sagefish
	[6317] = { 5 }, -- Raw Loch Frenzy
	[6289] = { 5 }, -- Raw Longjaw Mud Snapper
	[8365] = { 25 }, -- Raw Mithril Head Trout
	[13759] = { 35 }, -- Raw Nightfin Snapper
	[6361] = { 5 }, -- Raw Rainbow Fin Albacore
	[13758] = { 35 }, -- Raw Redgill
	[6362] = { 25 }, -- Raw Rockscale Cod
	[21071] = { 10 }, -- Raw Sagefish
	[6303] = { 1 }, -- Raw Slitherskin Mackerel
	[4603] = { 35 }, -- Raw Spotted Yellowtail
	[13756] = { 35 }, -- Raw Summer Bass
	[13760] = { 35 }, -- Raw Sunscale Salmon
	[13889] = { 45 }, -- Raw Whitescale Salmon
	[13755] = { 35 }, -- Winter Squid

	-- Cooking Only: meat, fish, eggs and other animal parts. Level is the item level.
	[27422] = { 60 }, -- Barbed Gill Trout
	[27669] = { 5 }, -- Bat Flesh
	[35562] = { 50 }, -- Bear Flank
	[3173] = { 11 }, -- Bear Meat
	[3730] = { 21 }, -- Big Bear Meat
	[33823] = { 65 }, -- Bloodfin Catfish
	[3172] = { 10 }, -- Boar Intestines
	[2677] = { 14 }, -- Boar Ribs
	[27671] = { 60 }, -- Buzzard Meat
	[3404] = { 35 }, -- Buzzard Wing
	[21024] = { 60 }, -- Chimaerok Tenderloin
	[27677] = { 60 }, -- Chunk o' Basilisk
	[769] = { 5 }, -- Chunk of Boar Meat
	[5503] = { 14 }, -- Clam Meat
	[27678] = { 60 }, -- Clefthoof Meat
	[2673] = { 10 }, -- Coyote Meat
	[2886] = { 5 }, -- Crag Boar Rib
	[2675] = { 13 }, -- Crawler Claw
	[2674] = { 13 }, -- Crawler Meat
	[33824] = { 65 }, -- Crescent-Tail Skullfish
	[1081] = { 15 }, -- Crisp Spider Meat
	[2924] = { 14 }, -- Crocolisk Meat
	[22644] = { 15 }, -- Crunchy Spider Leg
	[6522] = { 15 }, -- Deviate Fish
	[27516] = { 60 }, -- Enormous Barbed Gill Trout
	[27435] = { 60 }, -- Figluster's Mudfish
	[27439] = { 60 }, -- Furious Crawdad
	[4655] = { 35 }, -- Giant Clam Meat
	[12207] = { 45 }, -- Giant Egg
	[27438] = { 60 }, -- Golden Darter
	[2251] = { 25 }, -- Gooey Spider Leg
	[723] = { 12 }, -- Goretusk Liver
	[731] = { 12 }, -- Goretusk Snout
	[12204] = { 35 }, -- Heavy Kodo Meat
	[27515] = { 60 }, -- Huge Spotted Feltail
	[27437] = { 60 }, -- Icefin Bluefish
	[24477] = { 65 }, -- Jaggal Clam Meat
	[5467] = { 10 }, -- Kodo Meat
	[1015] = { 19 }, -- Lean Wolf Flank
	[13757] = { 45 }, -- Lightning Eel
	[3731] = { 23 }, -- Lion Meat
	[27668] = { 5 }, -- Lynx Meat
	[12223] = { 5 }, -- Meaty Bat Wing
	[23676] = { 1 }, -- Moongraze Stag Tenderloin
	[730] = { 11 }, -- Murloc Eye
	[1468] = { 16 }, -- Murloc Fin
	[12037] = { 30 }, -- Mystery Meat
	[3685] = { 22 }, -- Raptor Egg
	[12184] = { 30 }, -- Raptor Flesh
	[31670] = { 60 }, -- Raptor Ribs
	[27674] = { 60 }, -- Ravager Flesh
	[12203] = { 30 }, -- Red Wolf Meat
	[20424] = { 55 }, -- Sandworm Meat
	[5466] = { 8 }, -- Scorpid Stinger
	[31671] = { 60 }, -- Serpent Flesh
	[6889] = { 5 }, -- Small Egg
	[5465] = { 5 }, -- Small Spider Leg
	[5468] = { 15 }, -- Soft Frenzy Flesh
	[3174] = { 10 }, -- Spider Ichor
	[27425] = { 60 }, -- Spotted Feltail
	[5471] = { 23 }, -- Stag Meat
	[5469] = { 10 }, -- Strider Meat
	[729] = { 10 }, -- Stringy Vulture Meat
	[2672] = { 5 }, -- Stringy Wolf Meat
	[27682] = { 60 }, -- Talbuk Venison
	[5504] = { 23 }, -- Tangy Clam Meat
	[12206] = { 40 }, -- Tender Crab Meat
	[3667] = { 23 }, -- Tender Crocolisk Meat
	[12208] = { 40 }, -- Tender Wolf Meat
	[5470] = { 22 }, -- Thunder Lizard Tail
	[12202] = { 30 }, -- Tiger Meat
	[1080] = { 15 }, -- Tough Condor Meat
	[3712] = { 30 }, -- Turtle Meat
	[27681] = { 60 }, -- Warped Flesh
	[12205] = { 40 }, -- White Spider Meat
	[27429] = { 60 }, -- Zangarian Sporefish
	[7974] = { 45 }, -- Zesty Clam Meat
}

--[[
How We Got the Data

Last Validated
	2026-11-13, TBC Anniversary 2.5.6.70577

Notes
	- Every item a Cooking recipe uses, from the wago.tools tables below, that is meat, fish, an egg or another animal part. These are kept by default: the Outgrown Meat & Fish kind is unchecked until the player turns it on.
	- Left out: spices, salts, flour, drinks and milk, herbs, fruit and vegetables, wood and fuel, quest-class items (item class 12), and mats other professions want too (Large Fang, Wicked Claw, Small Venom Sac, Small Flame Sac, elemental motes).
	- Edible rows are raw fish that also have a Consumables row: their level is that row's use level, and the row lives here instead of in Consumables-TBC.lua, so they go with this kind rather than Outgrown Food & Drink.
	- Edible food no cooking recipe uses (Bloodbelly Fish, Oil Covered Fish, Darkshore Grouper) stays in Consumables-TBC.lua.
	- Cooking Only rows can't be eaten, so their level is the item level.
	- Either way an item becomes junk ten levels past its level, or at level 5 for anything under level 5 (GetConsumableEraseLevel in Features/Junk-Rules.lua).

Tables (wago.tools build 2.5.6.70577)
	SkillLine: 185 (Cooking) and any line whose ParentSkillLineID is 185.
	SkillLineAbility: Spell where SkillLine is one of those lines.
	SpellReagents: Reagent_0 to Reagent_7 for those spells.
	Item and ItemSparse: ClassID, ItemLevel and name for each reagent.
]]
