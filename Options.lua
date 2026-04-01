local addonName, Addon = ...
local L = Addon.L

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local function GetColor(key)
    return Addon:GetColor(key)
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

function Addon:OpenOptions()
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(Addon.AddonTitle)
    elseif InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(Addon.AddonTitle)
        InterfaceOptionsFrame_OpenToCategory(Addon.AddonTitle)
    end
end

--------------------------------------------------------------------------------
-- Options Table
--------------------------------------------------------------------------------

local options = {
    type = "group",
    name = Addon.AddonTitle,
    args = {
        spacerIntro0 = Spacer(1),
        headerIntro = Header(Addon.AddonTitle, 2),
        descIntro = Desc(L["OPTIONS_DESC"], 3),

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
                return MagicEraserDB and MagicEraserDB.autoVendEnabled
            end,
            set = function(_, value)
                MagicEraserDB.autoVendEnabled = value
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
                Addon:ClearIgnoreList()
            end,
        },
        resetAll = {
            type = "execute",
            name = L["OPTIONS_RESET_ALL"],
            order = 54,
            confirm = true,
            confirmText = L["OPTIONS_RESET_ALL_CONFIRM"],
            func = function()
                MagicEraserDB.autoVendEnabled = false
                Addon:ClearIgnoreList()
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
            get = function() return Addon.Links.CURSEFORGE end,
            set = function() end,
        },
        linkGitHub = {
            type = "input",
            name = L["OPTIONS_GITHUB"],
            width = "double",
            order = 94,
            get = function() return Addon.Links.GITHUB end,
            set = function() end,
        },
        linkDiscord = {
            type = "input",
            name = L["OPTIONS_DISCORD"],
            width = "double",
            order = 95,
            get = function() return Addon.Links.DISCORD end,
            set = function() end,
        },
    },
}

--------------------------------------------------------------------------------
-- Registration
--------------------------------------------------------------------------------

LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, Addon.AddonTitle)