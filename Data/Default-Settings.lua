local _, ns = ...

--------------------------------------------------------------------------------
-- Default Configuration
--------------------------------------------------------------------------------

--[[
    One key per setting. Applied as an additive merge in Features/Core.lua
    (ns:OnPlayerLogin): fill only nil fields, never overwrite an explicit user
    value. Account settings live in MagicEraserDB, per-character settings in
    MagicEraserCharDB. Table-valued defaults (minimap, ignoreList) seed a fresh
    empty table per scope rather than sharing this one.
]]
ns.DEFAULT_CONFIGURATION = {
    account = {
        showWelcome = true,
        minimap = {}
    },
    character = {
        autoVendEnabled = false,
        ignoreList = {}
    }
}
