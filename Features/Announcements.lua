local _, ns = ...
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

ns.BRAND_PREFIX = string.format("%s%s|r %s//|r ", GetColor("INFO"), ns.ADDON_TITLE, GetColor("SEPARATOR"))

--[[
    Player-only branded print. ns.BRAND_PREFIX carries the name and separator, so
    locale strings stay clean. Magic Eraser sends no cross-player chat, so there
    is no Announce/whisper path.
]]
function ns:PrintMessage(message)
	print(ns.BRAND_PREFIX .. GetColor("TEXT") .. message .. "|r")
end
