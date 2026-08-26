local _, ns = ...
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

ns.BrandPrefix = string.format("%s%s|r %s//|r ", GetColor("INFO"), ns.AddonTitle, GetColor("SEPARATOR"))

--[[
    Player-only branded print. ns.BrandPrefix carries the name and separator, so
    locale strings stay clean. Magic Eraser sends no cross-player chat, so there
    is no Announce/whisper path.
]]
function ns:PrintMessage(message)
	print(ns.BrandPrefix .. GetColor("TEXT") .. message .. "|r")
end
