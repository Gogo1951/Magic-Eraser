local _, ns = ...
local L = ns.L

local SubRow, SubLabel = ns.OptionsSubRow, ns.OptionsSubLabel

--[[
    Sub-row control widths, sized to their captions with room to spare rather
    than to the row budget -- see ns.OptionsSubRow on why an exact fit is the one
    thing these must not do. This row carries its message-mode dropdown beside
    the toggle, so the two share the line with the indent.
]]
local AUTO_VEND_MESSAGES_WIDTH = 1.3
local AUTO_VEND_MESSAGE_MODE_WIDTH = 1.0

local function AutoVendOff()
	return not (ns.db and ns.db.global.autoVendEnabled)
end

--------------------------------------------------------------------------------
-- Auto-Vend Section
--------------------------------------------------------------------------------

--[[
    A fragment of the General panel rather than a panel of its own: it adds its
    widgets to the args table ns.BuildGeneralOptions hands it, keeping the
    section's order numbers so the panel renders in one fixed sequence. See
    Features/Auto-Vend.lua for the behavior these settings drive.

    The one feature section left on the root panel. Auto-Vend is the add-on's
    second headline feature, named in the tagline and toggled from the
    mini-map button, so it stays where a player meets it first; everything
    that governs how careful erasing is lives on the Safety panel.
]]
function ns.BuildAutoVendOptions(args)
	args.spacerAutoVend0 = ns.OptionsSpacer(30)
	args.headerAutoVend = ns.OptionsHeader(L["AUTO_VEND"], 31)
	args.spacerAutoVend1 = ns.OptionsSpacer(32)
	args.descAutoVend = ns.OptionsDesc(L["AUTO_VEND_DESCRIPTION"], 33)
	args.spacerAutoVend2 = ns.OptionsSpacer(34)

	args.toggleAutoVend = {
		type = "toggle",
		name = L["OPTIONS_ENABLE_AUTO_VEND"],
		width = "full",
		order = 35,
		get = function()
			return ns.db and ns.db.global.autoVendEnabled
		end,
		set = function(_, value)
			ns.db.global.autoVendEnabled = value
		end,
	}

	args.rowAutoVendMessages = SubRow(36, AutoVendOff, {
		{
			type = "toggle",
			name = SubLabel(L["OPTIONS_ENABLE_AUTO_VEND_MESSAGES"]),
			width = AUTO_VEND_MESSAGES_WIDTH,
			get = function()
				return ns.db and ns.db.global.autoVendMessagesEnabled
			end,
			set = function(_, value)
				ns.db.global.autoVendMessagesEnabled = value
			end,
		},
		{
			type = "select",
			name = "",
			width = AUTO_VEND_MESSAGE_MODE_WIDTH,
			values = {
				verbose = L["OPTIONS_AUTO_VEND_LINE_ITEM"],
				summary = L["OPTIONS_AUTO_VEND_SUMMARY"],
			},
			sorting = { "verbose", "summary" },
			disabled = function()
				return not (ns.db and ns.db.global.autoVendMessagesEnabled)
			end,
			get = function()
				return (ns.db and ns.db.global.autoVendSummaryEnabled) and "summary" or "verbose"
			end,
			set = function(_, value)
				ns.db.global.autoVendSummaryEnabled = (value == "summary")
			end,
		},
	})
end
