local _, ns = ...

--[[
    Empty on purpose: Cataclysm removed ammunition, so this client has no
    arrows or bullets to outgrow. The table exists so every flavor folder has
    the same files and Validate Data finds it.
]]
-- [itemId] = { Item Use Level, Next Tier Use Level }, -- Item Name
ns.ALLOWED_DELETE_AMMO = {}
