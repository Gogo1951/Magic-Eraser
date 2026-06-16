local addonName, ns = ...

--------------------------------------------------------------------------------
-- Shared Options Helpers
--------------------------------------------------------------------------------

--[[
    Widget constructors shared by every options panel file. Dot-defined (no
    self), so callers use dot invocation -- ns.OptionsHeader(...) -- matching the
    panel builders.
]]
local GetColor = ns.GetColor

function ns.OptionsHeader(text, order)
    return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order }
end

function ns.OptionsDesc(text, order)
    return { type = "description", name = text, fontSize = "medium", order = order }
end

function ns.OptionsSpacer(order)
    return { type = "description", name = " ", order = order }
end
