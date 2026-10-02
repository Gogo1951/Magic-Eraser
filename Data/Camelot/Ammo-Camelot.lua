local _, ns = ...

--[[
Source: wago.tools DB2 exports of Item and ItemSparse for wow_cn_beta build
1.60.1.70094, until Validate Data passes on this client.

  Rows       Item.ClassID 6 (Projectile), SubclassID 2 (Arrow) or 3 (Bullet),
             with an ItemSparse row, ItemSparse.Flags_0 bit 0x10 (deprecated)
             clear, and no Test, Monster, Deprecated or [PH] in the name.
  Use level  ItemSparse.RequiredLevel; where that is 0, ItemLevel minus 5
             (every other arrow and bullet sits exactly 5 under its item
             level), never below 1 or above the level cap of 60.
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
	[10579] = { 37, 40 }, -- Explosive Arrow
	[3464] = { 30, 40 }, -- Feathered Arrow
	[19316] = { 51 }, -- Ice Threaded Arrow
	[11285] = { 40 }, -- Jagged Arrow
	[3030] = { 25, 40 }, -- Razor Arrow
	[2512] = { 1, 10 }, -- Rough Arrow
	[2515] = { 10, 25 }, -- Sharp Arrow
	[274387] = { 60 }, -- Swiftfeather Arrow
	[18042] = { 52 }, -- Thorium Headed Arrow

	-- Bullets
	[11284] = { 40 }, -- Accurate Slugs
	[8068] = { 15, 25 }, -- Crafted Heavy Shot
	[8067] = { 5, 10 }, -- Crafted Light Shot
	[8069] = { 30, 40 }, -- Crafted Solid Shot
	[3465] = { 31, 40 }, -- Exploding Shot
	[4960] = { 2, 10 }, -- Flash Pellet
	[2519] = { 10, 25 }, -- Heavy Shot
	[10512] = { 37, 40 }, -- Hi-Impact Mithril Slugs
	[19317] = { 51 }, -- Ice Threaded Bullet
	[2516] = { 1, 10 }, -- Light Shot
	[10513] = { 44 }, -- Mithril Gyro-Shot
	[5568] = { 13, 25 }, -- Smooth Pebble
	[3033] = { 25, 40 }, -- Solid Shot
	[274388] = { 60 }, -- Swiftstrike Shot
	[15997] = { 52 }, -- Thorium Shells
}
