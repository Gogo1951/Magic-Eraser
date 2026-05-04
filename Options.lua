local addonName, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function GetColor(key)
    return ns:GetColor(key)
end

local function Header(text, order)
    return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order }
end

local function Desc(text, order)
    return { type = "description", name = text, fontSize = "medium", order = order }
end

local function Spacer(order)
    return { type = "description", name = " ", order = order }
end

--------------------------------------------------------------------------------
-- Open Options
--------------------------------------------------------------------------------

function ns:OpenOptions()
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(ns.AddonTitle)
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(ns.AddonTitle)
        InterfaceOptionsFrame_OpenToCategory(ns.AddonTitle)
    end
end

--------------------------------------------------------------------------------
-- Options Table
--------------------------------------------------------------------------------

local options = {
    type = "group",
    name = ns.AddonTitle,
    args = {
        spacerIntro0 = Spacer(1),
        headerIntro = Header(ns.AddonTitle, 2),
        descIntro = Desc(L["OPTIONS_DESC"], 3),
        spacerIntro1 = Spacer(4),
        toggleWelcome = {
            type = "toggle",
            name = L["OPTIONS_WELCOME"],
            width = "full",
            order = 5,
            get = function()
                return MagicEraserDB and MagicEraserDB.showWelcome
            end,
            set = function(_, value)
                MagicEraserDB.showWelcome = value
            end,
        },
        spacerWelcome1 = Spacer(6),

        spacerAutoVend0 = Spacer(10),
        headerAutoVend = Header(L["AUTO_VEND"], 11),
        descAutoVend = Desc(L["OPTIONS_AUTO_VEND_DESC"], 12),
        spacerAutoVend1 = Spacer(13),
        toggleAutoVend = {
            type = "toggle",
            name = L["AUTO_VEND"],
            width = "full",
            order = 14,
            get = function()
                return MagicEraserCharDB and MagicEraserCharDB.autoVendEnabled
            end,
            set = function(_, value)
                MagicEraserCharDB.autoVendEnabled = value
            end,
        },

        spacerReset0 = Spacer(50),
        headerReset = Header(L["OPTIONS_RESET"], 51),
        spacerReset1 = Spacer(52),
        resetIgnoreList = {
            type = "execute",
            name = L["OPTIONS_RESET_IGNORE"],
            order = 53,
            confirm = true,
            confirmText = L["OPTIONS_RESET_IGNORE_CONFIRM"],
            func = function()
                ns:ClearIgnoreList()
            end,
        },
        resetAll = {
            type = "execute",
            name = L["OPTIONS_RESET_ALL"],
            width = "double",
            order = 54,
            confirm = true,
            confirmText = L["OPTIONS_RESET_ALL_CONFIRM"],
            func = function()
                MagicEraserCharDB.autoVendEnabled = false
                ns:ClearIgnoreList()
            end,
        },

        spacerFeedback0 = Spacer(90),
        headerFeedback = Header(L["OPTIONS_FEEDBACK"], 91),
        spacerFeedback1 = Spacer(92),
        linkCurseForge = {
            type = "input",
            name = L["OPTIONS_CURSEFORGE"],
            width = "double",
            order = 93,
            get = function() return ns.Links.CURSEFORGE end,
            set = function() end,
        },
        linkGitHub = {
            type = "input",
            name = L["OPTIONS_GITHUB"],
            width = "double",
            order = 94,
            get = function() return ns.Links.GITHUB end,
            set = function() end,
        },
        linkDiscord = {
            type = "input",
            name = L["OPTIONS_DISCORD"],
            width = "double",
            order = 95,
            get = function() return ns.Links.DISCORD end,
            set = function() end,
        },

        versionLine = {
            type = "description",
            name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
            fontSize = "medium",
            order = 999,
        },
    },
}

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, ns.AddonTitle)