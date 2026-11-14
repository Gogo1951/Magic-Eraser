local _, ns = ...

--[[
    Empty for now: retail cooking spreads its recipes over a skill line per
    expansion and reads many reagents through crafting slots rather than
    SpellReagents, so the Classic query doesn't carry over. Until this table
    is built, raw fish on this client stay in Consumables-Mainline.lua and
    count as Outgrown Food & Drink. The table exists so every flavor folder
    has the same files and Validate Data finds it.
]]
-- [itemId] = {Level}, -- Item Name
ns.ALLOWED_DELETE_MEAT_FISH = {}
