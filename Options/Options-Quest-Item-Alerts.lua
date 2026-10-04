local _, ns = ...
local L = ns.L

local format = string.format

local function QuestAlertsOff()
	return not (ns.db and ns.db.profile.questAlertsEnabled)
end

--------------------------------------------------------------------------------
-- Quest Item Alerts Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Alerts & Tooltips panel rather than a panel of its own: it
    adds its widgets to the args table ns.BuildAlertsTooltipsOptions hands it,
    and its order numbers are what place the section on that panel. See
    Features/Quest-Item-Alerts.lua for the behavior this setting drives. Its
    switch is also in the root panel's Features section.

    Two examples, one per alert, since the two sentences say different things.
]]
function ns.BuildQuestItemAlertsOptions(args)
	args.spacerQuestAlerts0 = ns.OptionsSpacer(20)
	args.headerQuestAlerts = ns.OptionsHeader(L["OPTIONS_QUEST_ALERTS_HEADER"], 21)
	args.spacerQuestAlerts1 = ns.OptionsSpacer(22)
	args.descQuestAlerts = ns.OptionsDesc(L["OPTIONS_QUEST_ALERTS_DESCRIPTION"], 23)
	args.spacerQuestAlerts2 = ns.OptionsSpacer(24)

	args.toggleQuestAlerts = ns.OptionsFeatureToggle(
		"questAlertsEnabled",
		"OPTIONS_ENABLE_QUEST_ALERTS",
		"OPTIONS_ENABLE_QUEST_ALERTS_DESCRIPTION",
		25
	)

	-- One example per kind, a blank line above each.
	args.spacerQuestReady = ns.OptionsSpacer(25.5, QuestAlertsOff)
	args.exampleQuestReady = ns.OptionsExample(function()
		return format(L["QUEST_ITEM_READY"], ns.EXAMPLE_ITEM_LINK, "")
	end, 26, QuestAlertsOff)

	args.spacerQuestUnavailable = ns.OptionsSpacer(27.5, QuestAlertsOff)
	args.exampleQuestUnavailable = ns.OptionsExample(function()
		return format(L["QUEST_STARTER_UNAVAILABLE"], ns.EXAMPLE_ITEM_LINK, "")
	end, 28, QuestAlertsOff)
end
