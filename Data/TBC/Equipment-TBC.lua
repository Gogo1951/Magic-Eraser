local _, ns = ...

-- [itemId] = true, -- Item Name
ns.KEEP_EQUIPMENT = {
	--------------------------------------------------------------------------------
	-- FORMAL WEAR AND EFFECTS
	--------------------------------------------------------------------------------

	[30760] = true, -- Formal Draenic Robe
	[38277] = true, -- Haliscan Jacket
	[38278] = true, -- Haliscan Pantaloons
	[7996] = true, -- Worn Fishing Hat
	[10035] = true, -- Tuxedo Pants
	[10040] = true, -- White Wedding Dress

	--------------------------------------------------------------------------------
	-- QUEST TURN-INS
	--------------------------------------------------------------------------------

	[5739] = true, -- Barbaric Harness
	[7958] = true, -- Bronze Battle Axe
	[7957] = true, -- Bronze Greatsword
	[7956] = true, -- Bronze Warhammer
	[5092] = true, -- Charred Razormane Wand
	[2845] = true, -- Copper Axe
	[2851] = true, -- Copper Chain Belt
	[2310] = true, -- Embossed Leather Cloak
	[4239] = true, -- Embossed Leather Gloves
	[6040] = true, -- Golden Scale Bracers
	[3835] = true, -- Green Iron Bracers
	[6214] = true, -- Heavy Copper Maul
	[3719] = true, -- Hillman's Cloak
	[23553] = true, -- Living Branch
	[5093] = true, -- Razormane Backstabber
	[5094] = true, -- Razormane War Shield
	[2857] = true, -- Runed Copper Belt
	[4616] = true, -- Ryedol's Lucky Pick
	[3421] = true, -- Simple Wildflowers
	[7922] = true, -- Steel Plate Helm
	[2314] = true, -- Toughened Leather Armor
}

--[[
How We Got the Data

Last Validated
	2026-10-09, TBC Anniversary 2.5.6.69795

Notes
	- White weapons and armor are judged by rule in Features/Junk-Rules.lua, the way grays are, so this file lists no junk at all: only the white gear that rule would wrongly erase. The rule checks this table before anything else.
	- A kept item is left alone by the eraser, Auto-Vend and Bank Retrieval alike. A player who wants one gone anyway puts it on the Erase List, which is checked ahead of every rule.
	- FORMAL WEAR AND EFFECTS: gear with real armor and nothing else to go on, or an Equip: effect GetItemSpell doesn't report, like the Worn Fishing Hat's fishing bonus. Borrowed Broom needs no row: its on-use spell already keeps it.
	- QUEST TURN-INS: the rule can't see quest data, so a white item a quest takes back would be erased or sold before the player hands it in. A row here keeps it for good. One Quest-Items also lists still goes once its quest is done: that check runs first, so this table never sees it.
	- The QUEST TURN-INS rows are Wowhead's white quest turn-in gear with a sell price for this client, from the listing below, read 2026-10-02.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	https://www.wowhead.com/tbc/items/quality:1/slot:16:5:8:10:1:23:7:21:2:22:13:15:26:14:3:17:6:9?filter=85%3A1

wago.tools
	None.
]]
