local _, ns = ...
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

ns.BRAND_PREFIX = string.format("%s%s|r %s//|r ", GetColor("INFO"), ns.ADDON_TITLE, GetColor("SEPARATOR"))

--[[
    Player-only branded print. ns.BRAND_PREFIX carries the name and separator, so
    locale strings stay clean. Magic Eraser sends no cross-player chat, so there
    is no Announce/whisper path. Item links keep their brackets here, the way
    the game prints loot.
]]
function ns:FormatMessage(message)
	return ns.BRAND_PREFIX .. GetColor("TEXT") .. message .. "|r"
end

-- The options' Example lines draw this same finished line (ns.ExampleLine), so they match chat exactly.
function ns:PrintMessage(message)
	print(ns:FormatMessage(message))
end
