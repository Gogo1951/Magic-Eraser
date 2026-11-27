local _, ns = ...
local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- Messaging
--------------------------------------------------------------------------------

ns.BRAND_PREFIX = string.format("%s%s|r %s//|r ", GetColor("INFO"), ns.ADDON_TITLE, GetColor("SEPARATOR"))

-- Player-only: Magic Eraser sends no cross-player chat. Links keep their brackets, as loot prints.
function ns:FormatMessage(message)
	return ns.BRAND_PREFIX .. GetColor("TEXT") .. message .. "|r"
end

-- The options' Example lines draw this same finished line (ns.ExampleLine), so they match chat exactly.
function ns:PrintMessage(message)
	print(ns:FormatMessage(message))
end
