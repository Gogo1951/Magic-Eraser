local addonName, ns = ...
local L = ns.L

local GetColor = ns.GetColor

--------------------------------------------------------------------------------
-- General Panel
--------------------------------------------------------------------------------

function ns.BuildGeneralOptions()
    return {
        type = "group",
        name = ns.AddonTitle,
        args = {
            descIntro = ns.OptionsDesc(L["OPTIONS_DESC"], 1),

            spacerWelcome0 = ns.OptionsSpacer(5),
            toggleWelcome = {
                type = "toggle",
                name = L["OPTIONS_WELCOME"],
                width = "full",
                order = 6,
                get = function()
                    return MagicEraserDB and MagicEraserDB.showWelcome
                end,
                set = function(_, value)
                    MagicEraserDB.showWelcome = value
                end,
            },

            spacerAutoVend0 = ns.OptionsSpacer(10),
            headerAutoVend = ns.OptionsHeader(L["AUTO_VEND"], 11),
            descAutoVend = ns.OptionsDesc(L["OPTIONS_AUTO_VEND_DESC"], 12),
            spacerAutoVend1 = ns.OptionsSpacer(13),
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

            spacerReset0 = ns.OptionsSpacer(50),
            headerReset = ns.OptionsHeader(L["OPTIONS_RESET"], 51),
            spacerReset1 = ns.OptionsSpacer(52),
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

            spacerFeedback0 = ns.OptionsSpacer(90),
            headerFeedback = ns.OptionsHeader(L["OPTIONS_FEEDBACK"], 91),
            spacerFeedback1 = ns.OptionsSpacer(92),
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

            spaceVersion0 = {
                type = "description",
                name = " ",
                width = "full",
                order = 998,
            },
            versionLine = {
                type = "description",
                name = GetColor("MUTED") .. "Version " .. ns.Version .. "|r",
                fontSize = "medium",
                order = 999,
            },
        },
    }
end
