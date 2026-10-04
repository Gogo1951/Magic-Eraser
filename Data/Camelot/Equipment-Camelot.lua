local _, ns = ...

-- [itemId] = true, -- Item Name
ns.KEEP_EQUIPMENT = {
	--------------------------------------------------------------------------------
	-- FORMAL WEAR AND EFFECTS
	--------------------------------------------------------------------------------

	[7996] = true, -- Worn Fishing Hat
	[10035] = true, -- Tuxedo Pants
	[10040] = true, -- White Wedding Dress

	--------------------------------------------------------------------------------
	-- QUEST TURN-INS
	--------------------------------------------------------------------------------

	[5092] = true, -- Charred Razormane Wand
	[2845] = true, -- Copper Axe
	[5093] = true, -- Razormane Backstabber
	[5094] = true, -- Razormane War Shield
	[4616] = true, -- Ryedol's Lucky Pick
	[3421] = true, -- Simple Wildflowers
	[2314] = true, -- Toughened Leather Armor
	[10036] = true, -- Tuxedo Jacket
}

--[[
How We Got the Data

Last Validated
	2026-10-04, WoW Forever 1.60.1.70205

Notes
	- White weapons and armor are judged by rule in Features/Junk-Rules.lua, the way grays are, so this file lists no junk at all: only the white gear that rule would wrongly erase. The rule checks this table before anything else.
	- A kept item is left alone by the eraser, Auto-Vend and Bank Retrieval alike. A player who wants one gone anyway puts it on the Erase List, which is checked ahead of every rule.
	- FORMAL WEAR AND EFFECTS: gear with real armor and nothing else to go on, or an Equip: effect GetItemSpell doesn't report, like the Worn Fishing Hat's fishing bonus. Borrowed Broom needs no row: its on-use spell already keeps it.
	- QUEST TURN-INS: the rule can't see quest data, so a white item a quest takes back would be erased or sold before the player hands it in. A row here keeps it for good. One Quest-Items also lists still goes once its quest is done: that check runs first, so this table never sees it.
	- The QUEST TURN-INS rows are Wowhead's white quest turn-in gear with a sell price for this client, from the listing below, read 2026-10-02.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	https://www.wowhead.com/forever/items/quality:1/slot:16:5:8:10:1:23:7:21:2:22:13:15:26:14:3:17:6:9?filter=85%3A1

wago.tools
	None.
]]
