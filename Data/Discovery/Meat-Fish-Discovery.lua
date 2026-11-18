local _, ns = ...

if not ns.IS_DISCOVERY then
	return
end

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
	[3173] = { 11 }, -- Bear Meat
	[3730] = { 21 }, -- Big Bear Meat
	[3172] = { 10 }, -- Boar Intestines
	[2677] = { 14 }, -- Boar Ribs
	[3404] = { 35 }, -- Buzzard Wing
	[21024] = { 60 }, -- Chimaerok Tenderloin
	[769] = { 5 }, -- Chunk of Boar Meat
	[5503] = { 14 }, -- Clam Meat
	[2673] = { 10 }, -- Coyote Meat
	[2886] = { 5 }, -- Crag Boar Rib
	[2675] = { 13 }, -- Crawler Claw
	[2674] = { 13 }, -- Crawler Meat
	[1081] = { 15 }, -- Crisp Spider Meat
	[2924] = { 14 }, -- Crocolisk Meat
	[6522] = { 15 }, -- Deviate Fish
	[4655] = { 35 }, -- Giant Clam Meat
	[12207] = { 45 }, -- Giant Egg
	[2251] = { 25 }, -- Gooey Spider Leg
	[723] = { 12 }, -- Goretusk Liver
	[731] = { 12 }, -- Goretusk Snout
	[12204] = { 35 }, -- Heavy Kodo Meat
	[5467] = { 10 }, -- Kodo Meat
	[1015] = { 19 }, -- Lean Wolf Flank
	[3731] = { 23 }, -- Lion Meat
	[12223] = { 5 }, -- Meaty Bat Wing
	[730] = { 11 }, -- Murloc Eye
	[1468] = { 16 }, -- Murloc Fin
	[12037] = { 30 }, -- Mystery Meat
	[3685] = { 22 }, -- Raptor Egg
	[12184] = { 30 }, -- Raptor Flesh
	[12203] = { 30 }, -- Red Wolf Meat
	[20424] = { 55 }, -- Sandworm Meat
	[5466] = { 8 }, -- Scorpid Stinger
	[6889] = { 5 }, -- Small Egg
	[5465] = { 5 }, -- Small Spider Leg
	[5468] = { 15 }, -- Soft Frenzy Flesh
	[3174] = { 10 }, -- Spider Ichor
	[5471] = { 23 }, -- Stag Meat
	[5469] = { 10 }, -- Strider Meat
	[729] = { 10 }, -- Stringy Vulture Meat
	[2672] = { 5 }, -- Stringy Wolf Meat
	[5504] = { 23 }, -- Tangy Clam Meat
	[12206] = { 40 }, -- Tender Crab Meat
	[3667] = { 23 }, -- Tender Crocolisk Meat
	[12208] = { 40 }, -- Tender Wolf Meat
	[5470] = { 22 }, -- Thunder Lizard Tail
	[12202] = { 30 }, -- Tiger Meat
	[1080] = { 15 }, -- Tough Condor Meat
	[3712] = { 30 }, -- Turtle Meat
	[12205] = { 40 }, -- White Spider Meat
	[7974] = { 45 }, -- Zesty Clam Meat
}

--[[
How We Got the Data

Last Validated
	2026-11-18, Season of Discovery 1.15.9.70576

Notes
	- Every item a Cooking recipe uses, from the wago.tools tables below, that is meat, fish, an egg or another animal part. These are kept by default: the Outgrown Meat & Fish kind is unchecked until the player turns it on.
	- Left out: spices, salts, flour, drinks and milk, herbs, fruit and vegetables, wood and fuel, quest-class items (item class 12), and mats other professions want too (Large Fang, Wicked Claw, Small Venom Sac, Small Flame Sac, elemental motes).
	- Edible rows are raw fish that also have a Consumables row: their level is that row's use level, and the row lives here instead of in Consumables-Discovery.lua, so they go with this kind rather than Outgrown Food & Drink.
	- Edible food no cooking recipe uses (Bloodbelly Fish, Oil Covered Fish, Darkshore Grouper) stays in Consumables-Discovery.lua.
	- Cooking Only rows can't be eaten, so their level is the item level.
	- Either way an item becomes junk ten levels past its level, or at level 5 for anything under level 5 (GetConsumableEraseLevel in Features/Junk-Rules.lua).
	- Found in the wago.tools tables below: SkillLine 185 (Cooking) and every line whose ParentSkillLineID is 185, those lines' SkillLineAbility spells, each spell's SpellReagents (Reagent_0 to Reagent_7), and each reagent's Item and ItemSparse row for its class, item level and name. A reagent is Edible when its first use spell (ItemEffect, SpellEffect) applies the eating aura.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/SkillLine?build=1.15.9.70576
	https://wago.tools/db2/SkillLineAbility?build=1.15.9.70576
	https://wago.tools/db2/SpellReagents?build=1.15.9.70576
	https://wago.tools/db2/Item?build=1.15.9.70576
	https://wago.tools/db2/ItemSparse?build=1.15.9.70576
	https://wago.tools/db2/ItemEffect?build=1.15.9.70576
	https://wago.tools/db2/SpellEffect?build=1.15.9.70576

QuestieDB
	None.
]]
