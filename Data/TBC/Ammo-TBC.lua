local _, ns = ...

--[[
Source: wago.tools DB2 exports of Item and ItemSparse for wow_anniversary build
2.5.6.69795, until Validate Data passes on this client.

  Rows       Item.ClassID 6 (Projectile), SubclassID 2 (Arrow) or 3 (Bullet),
             with an ItemSparse row, ItemSparse.Flags_0 bit 0x10 (deprecated)
             clear, and no Test, Monster, Deprecated or [PH] in the name.
  Use level  ItemSparse.RequiredLevel; where that is 0, ItemLevel minus 5
             (every other arrow and bullet sits exactly 5 under its item
             level), never below 1 or above the level cap of 70.
  Next tier  The lowest use level above this row's among the vendor line of
             the same kind, as present in this build: arrows 2512 Rough,
             2515 Sharp, 3030 Razor, 11285 Jagged, 28053 Wicked, 28056
             Blackflight, 41586 Terrorshaft; bullets 2516 Light, 2519 Heavy,
             3033 Solid, 11284 Accurate, 28060 Impact, 28061 Ironbite, 41584
             Frostbite. Omitted when nothing in the line is higher, which
             leaves the row never outgrown on this client.

The vendor line is hand-listed because DB2 cannot tell a vendor's ammo from a
crafted or dropped white, and only vendor ammo is a replacement every hunter
can buy. The next tier level is the player level the row becomes junk at
(GetAmmoEraseLevel in Features/Junk-Rules.lua); the use level is carried for
Validate Data.
]]
-- [itemId] = { Item Use Level, Next Tier Use Level }, -- Item Name
ns.ALLOWED_DELETE_AMMO = {
	-- Arrows
	[33803] = { 62, 65 }, -- Adamantite Stinger
	[28056] = { 65 }, -- Blackflight Arrow
	[12654] = { 54, 55 }, -- Doomshot
	[10579] = { 37, 40 }, -- Explosive Arrow
	[3464] = { 30, 40 }, -- Feathered Arrow
	[30611] = { 66 }, -- Halaani Razorshaft
	[19316] = { 51, 55 }, -- Ice Threaded Arrow
	[11285] = { 40, 55 }, -- Jagged Arrow
	[34581] = { 70 }, -- Mysterious Arrow
	[30319] = { 70 }, -- Nether Spike
	[9399] = { 35, 40 }, -- Precision Arrow
	[3030] = { 25, 40 }, -- Razor Arrow
	[2512] = { 1, 10 }, -- Rough Arrow
	[24417] = { 61, 65 }, -- Scout's Arrow
	[2515] = { 10, 25 }, -- Sharp Arrow
	[32760] = { 70 }, -- The Macho Gnome's Arrow
	[18042] = { 52, 55 }, -- Thorium Headed Arrow
	[31737] = { 70 }, -- Timeless Arrow
	[31949] = { 68 }, -- Warden's Arrow
	[28053] = { 55, 65 }, -- Wicked Arrow

	-- Bullets
	[11284] = { 40, 55 }, -- Accurate Slugs
	[23773] = { 62, 65 }, -- Adamantite Shells
	[8068] = { 15, 25 }, -- Crafted Heavy Shot
	[8067] = { 5, 10 }, -- Crafted Light Shot
	[8069] = { 30, 40 }, -- Crafted Solid Shot
	[3465] = { 31, 40 }, -- Exploding Shot
	[23772] = { 57, 65 }, -- Fel Iron Shells
	[32883] = { 68 }, -- Felbane Slugs
	[4960] = { 2, 10 }, -- Flash Pellet
	[30612] = { 66 }, -- Halaani Grimshot
	[2519] = { 10, 25 }, -- Heavy Shot
	[32882] = { 68 }, -- Hellfire Shot
	[10512] = { 37, 40 }, -- Hi-Impact Mithril Slugs
	[19317] = { 51, 55 }, -- Ice Threaded Bullet
	[28060] = { 55, 65 }, -- Impact Shot
	[28061] = { 65 }, -- Ironbite Shell
	[2516] = { 1, 10 }, -- Light Shot
	[13377] = { 56, 65 }, -- Miniature Cannon Balls
	[10513] = { 44, 55 }, -- Mithril Gyro-Shot
	[34582] = { 70 }, -- Mysterious Shell
	[11630] = { 47, 55 }, -- Rockshard Pellets
	[5568] = { 13, 25 }, -- Smooth Pebble
	[3033] = { 25, 40 }, -- Solid Shot
	[32761] = { 70 }, -- The Sarge's Bullet
	[15997] = { 52, 55 }, -- Thorium Shells
	[31735] = { 70 }, -- Timeless Shell
}
