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

    Hand-maintained, and never added to one of the four tables beside it that
    carry SQL queries: those files are regenerated from their queries, and a
    hand-added row does not survive the next regeneration. An id no query can
    express belongs in a file no query rewrites.
]]
-- CLASS_TOKEN = { [itemId] = true }, -- Item Name
ns.CLASS_REAGENTS = {
	SHAMAN = {
		[17057] = true, -- Shiny Fish Scales
		[17058] = true, -- Fish Oil
	},
}
