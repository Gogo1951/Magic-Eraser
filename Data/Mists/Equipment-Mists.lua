local _, ns = ...

--[[
    The white gear the equipment rule would erase and must not. White weapons
    and armor are decided by rule in Features/Junk-Rules.lua, the way grays are, so
    this file lists no trash at all: only the exceptions no structural signal
    can see, which the rule checks before anything else. A kept item is left
    alone by the eraser, Auto-Vend and Bank Retrieval alike. A player who wants
    one gone anyway lists it on the Erase List, which is checked ahead of every
    rule.

    Two kinds of row, one section each:

      FORMAL WEAR AND EFFECTS  Real armor values and nothing else to go on, or
                               an Equip: effect GetItemSpell does not report,
                               like the Lucky Fishing Hat's fishing bonus.
                               Borrowed Broom needs no row: its on-use spell
                               already keeps it.
      QUEST TURN-INS           The rule cannot see quest data, so a white a
                               quest takes back would be erased, or sold, before
                               the player hands it in. A row here keeps it for
                               good. One Quest-Items also lists still goes once
                               its quest is done: that branch runs first, so
                               this table never sees it.
]]

--[[
Source: QUEST TURN-INS rows are Wowhead's white quest turn-in gear with a sell
price for this client, read 2026-10-02:
https://www.wowhead.com/mop-classic/items/quality:1/slot:16:5:8:10:1:23:7:21:2:22:13:15:26:14:3:17:6:9?filter=85%3A195%3A64%3B1%3A1%3A1%3B0%3A0%3A1
]]
-- [itemId] = true, -- Item Name
ns.KEEP_EQUIPMENT = {
	--------------------------------------------------------------------------------
	-- FORMAL WEAR AND EFFECTS
	--------------------------------------------------------------------------------

	[30760] = true, -- Formal Draenic Robe
	[38277] = true, -- Haliscan Jacket
	[38278] = true, -- Haliscan Pantaloons
	[7996] = true, -- Lucky Fishing Hat
	[10035] = true, -- Tuxedo Pants
	[10040] = true, -- White Wedding Dress

	--------------------------------------------------------------------------------
	-- QUEST TURN-INS
	--------------------------------------------------------------------------------

	[44802] = true, -- Borrowed Egg Basket
	[2845] = true, -- Copper Axe
	[2851] = true, -- Copper Chain Belt
	[23553] = true, -- Living Branch
	[7297] = true, -- Morbent's Bane
	[11522] = true, -- Silver Totem of Aquementas
	[76391] = true, -- Trainee's Axe
	[76393] = true, -- Trainee's Book of Prayers
	[73211] = true, -- Trainee's Crossbow
	[73208] = true, -- Trainee's Dagger
	[73212] = true, -- Trainee's Dagger
	[76392] = true, -- Trainee's Hand Fan
	[77278] = true, -- Trainee's Handwrap
	[77279] = true, -- Trainee's Handwrap
	[73207] = true, -- Trainee's Mace
	[73213] = true, -- Trainee's Shield
	[76390] = true, -- Trainee's Spellblade
	[73209] = true, -- Trainee's Staff
	[73210] = true, -- Trainee's Sword
}
