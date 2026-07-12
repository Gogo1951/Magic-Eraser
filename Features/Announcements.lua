local _, ns = ...
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

--[[
    Player-only branded print via ns.BrandPrefix (built in Utilities, so locale
    strings stay clean). Magic Eraser sends no cross-player chat, so there is no
    Announce/whisper path.
]]
function ns:PrintMessage(message)
	print(ns.BrandPrefix .. GetColor("TEXT") .. message .. "|r")
end
