local _, ns = ...

if not ns.IS_DISCOVERY then
	return
end

-- [itemId] = { Item Use Level, Next Tier Use Level }, -- Item Name
ns.ALLOWED_DELETE_AMMO = {
	-- Arrows
	[12654] = { 54 }, -- Doomshot
	[223648] = { 44 }, -- Dream Imbued Arrow
	[10579] = { 37, 40 }, -- Explosive Arrow
	[3464] = { 30, 40 }, -- Feathered Arrow
	[19316] = { 51 }, -- Ice Threaded Arrow
	[11285] = { 40 }, -- Jagged Arrow
	[9399] = { 35, 40 }, -- Precision Arrow
	[3030] = { 25, 40 }, -- Razor Arrow
	[2512] = { 1, 10 }, -- Rough Arrow
	[231806] = { 60 }, -- Searing Arrow
	[2515] = { 10, 25 }, -- Sharp Arrow
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
	[13377] = { 56 }, -- Miniature Cannon Balls
	[10513] = { 44 }, -- Mithril Gyro-Shot
	[11630] = { 47 }, -- Rockshard Pellets
	[231807] = { 60 }, -- Searing Shot
	[5568] = { 13, 25 }, -- Smooth Pebble
	[3033] = { 25, 40 }, -- Solid Shot
	[15997] = { 52 }, -- Thorium Shells
}

--[[
How We Got the Data

Last Validated
	2026-10-09, Season of Discovery 1.15.9.70003

Notes
	- Every arrow and bullet on this client, leaving out test, monster, deprecated and placeholder items.
	- Season of Discovery's own ammo (IDs 200000 and up) is included, since only this folder loads on Season of Discovery realms.
	- Item Use Level is the level a hunter can use it. Where the game lists none, it's the item level minus 5, where every other arrow and bullet sits, kept between 1 and the level cap of 60. It's carried for Validate Data; the junk rule doesn't read it.
	- Next Tier Use Level is the use level of the next better arrow or bullet a vendor sells, which is the level this ammo becomes junk (GetAmmoEraseLevel in Features/Junk-Rules.lua). Ammo with nothing better at a vendor has none, and is never junk on this client.
	- The vendor line is hand-listed, because the game data can't tell vendor ammo from crafted or dropped ammo, and only vendor ammo is a replacement every hunter can buy. Arrows: 2512 Rough, 2515 Sharp, 3030 Razor, 11285 Jagged, 28053 Wicked, 28056 Blackflight, 41586 Terrorshaft. Bullets: 2516 Light, 2519 Heavy, 3033 Solid, 11284 Accurate, 28060 Impact, 28061 Ironbite, 41584 Frostbite. Only the ones this client has count.
	- Found in the wago.tools tables below: Item.ClassID 6 (Projectile) with SubclassID 2 (Arrow) or 3 (Bullet), an ItemSparse row, and ItemSparse.Flags_0 bit 0x10 (deprecated) clear.

SQL (CMaNGOS)
	TODO: Add SQL Query

Wowhead
	None.

wago.tools
	https://wago.tools/db2/Item?build=1.15.9.70003
	https://wago.tools/db2/ItemSparse?build=1.15.9.70003
]]
