local _, ns = ...

if ns.IS_DISCOVERY then
	return
end

-- CLASS_TOKEN = { [itemId] = true }, -- Item Name
ns.CLASS_REAGENTS = {
	DRUID = {
		[17036] = true, -- Ashwood Seed
		[17037] = true, -- Hornbeam Seed
		[17038] = true, -- Ironwood Seed
		[17021] = true, -- Wild Berries
		[17026] = true, -- Wild Thornroot
	},
	MAGE = {
		[17020] = true, -- Arcane Powder
		[17032] = true, -- Rune of Portals
		[17031] = true, -- Rune of Teleportation
	},
	PALADIN = {
		[17033] = true, -- Symbol of Divinity
		[21177] = true, -- Symbol of Kings
	},
	PRIEST = {
		[17028] = true, -- Holy Candle
		[17029] = true, -- Sacred Candle
	},
	ROGUE = {
		[5530] = true, -- Blinding Powder
		[5173] = true, -- Deathweed
		[2928] = true, -- Dust of Decay
		[8924] = true, -- Dust of Deterioration
		[8923] = true, -- Essence of Agony
		[2930] = true, -- Essence of Pain
		[5140] = true, -- Flash Powder
	},
	SHAMAN = {
		[17030] = true, -- Ankh
		[17058] = true, -- Fish Oil
		[17057] = true, -- Shiny Fish Scales
	},
	WARLOCK = {
		[16583] = true, -- Demonic Figurine
		[5565] = true, -- Infernal Stone
	},
}

--[[
How We Got the Data

Last Validated
	2026-10-16, Classic Era 1.15.9.70003

Notes
	- Items one class needs and every other class can throw away, listed under the class token UnitClass returns.
	- Shiny Fish Scales and Fish Oil are the Shaman's Water Breathing and Water Walking reagents, added by hand. Every other row came from the wago.tools tables below.
	- A reagent a profession also uses is left out, because any class can learn the profession: Maple Seed (Minor Wizard Oil, Minor Mana Oil) and Stranglethorn Seed (Lesser Wizard Oil) are Enchanting reagents as well as the Druid's Rebirth reagents. Found by checking each class reagent's SpellReagents uses against SkillLine category 7 (class skills).
	- A reagent that binds when picked up and only its own class can get is left out, because no other class ever carries one: Soul Shard (6265), which only a Warlock's Drain Soul makes. It's the one class reagent with an ItemSparse Bonding.
	- Only ns:SeedEraseList in Features/Erase-List.lua acts on this table: it puts other classes' reagents on a character's Erase List once, the first time that character plays. Diagnostics/Manifests.lua also reads it, for the Eraser Context count and Validate Data.
	- Nothing filters on it while scanning bags, so a Shaman who puts Fish Oil on their own Erase List on purpose is obeyed, not overridden.
	- Hand-maintained, and never merged into the regenerated tables beside it (Consumables, Quest-Items and Quest-Starting-Items come from SQL, Ammo from wago.tools): a hand-added row wouldn't survive the next regeneration, so an ID no query can find belongs in a file nothing regenerates.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/SkillLineAbility?build=1.15.9.70003
	https://wago.tools/db2/SkillRaceClassInfo?build=1.15.9.70003
	https://wago.tools/db2/SpellReagents?build=1.15.9.70003
	https://wago.tools/db2/SkillLine?build=1.15.9.70003

QuestieDB
	None.
]]
