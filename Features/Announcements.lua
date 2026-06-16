local addonName, ns = ...

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

--[[
    Player-only print. Branded colors, no target marker: the add-on name in
    C_INFO, the // separator in C_SEPARATOR, the body in C_TEXT -- all applied
    here via ns.BrandPrefix so locale strings stay clean. Magic Eraser sends no
    cross-player chat, so there is no Announce/whisper path.

    Format: |cff[INFO]Add-on Name|r |cff[SEPARATOR]//|r |cff[TEXT]Message|r
]]
function ns:PrintMessage(message)
    print(ns.BrandPrefix .. ns.GetColor("TEXT") .. message .. "|r")
end
