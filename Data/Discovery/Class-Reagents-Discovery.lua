local _, ns = ...

if not ns.IS_DISCOVERY then
	return
end

--[[
    Items one class needs and every other class can throw away, keyed by the
    class token UnitClass returns. Shiny Fish Scales and Fish Oil are the
    Shaman's Water Breathing and Water Walking reagents.

    Only ns:SeedEraseList in Features/Erase-List.lua acts on this table, putting
    another class's reagents on a character's Erase List once, the first time it
    plays; Features/Diagnostics.lua also reads it, for the Eraser Context count
    and Validate Data. Nothing filters on it at scan time, so a Shaman who
    deliberately adds Fish Oil to their own list is obeyed instead of silently
    overridden.

    Hand-maintained, and never added to the regenerated tables beside it
    (Consumables, Quest-Items and Quest-Starting-Items from SQL queries, Ammo
    from DB2 exports): a hand-added row does not survive the next
    regeneration. An id no source can express belongs in a file nothing
    regenerates.
]]
-- CLASS_TOKEN = { [itemId] = true }, -- Item Name
ns.CLASS_REAGENTS = {
	SHAMAN = {
		[17057] = true, -- Shiny Fish Scales
		[17058] = true, -- Fish Oil
	},
}
