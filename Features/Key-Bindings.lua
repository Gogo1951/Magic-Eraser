local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

--[[
    WoW's binding system reads only globals, so these two are globals:
    Bindings.xml can only call a global function, and the Key Bindings list labels
    a binding with the BINDING_NAME_<name> global matching its name attribute.
    Bindings.xml itself is found at the add-on root by the client and is never
    listed in the TOC.

    The handler is the mini-map button's Left-Click on a key, so it enters through
    ns:RunEraser exactly as the click does, and every gate on the click holds here.
]]

BINDING_NAME_MAGICERASER_ERASE = L["BINDING_ERASE"]

function MagicEraser_Erase()
	ns:RunEraser()
end
