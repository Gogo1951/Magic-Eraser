local _, ns = ...
local L = ns.L

local format = string.format

local function QuestAlertsOff()
	return not (ns.db and ns.db.profile.questAlertsEnabled)
end

--[[
    Each example names a real item of the kind its alert is about: the lowest
    item id in the flavor's quest-item table for the ready alert, and in its
    quest-starting table for the unavailable one. The lowest id is a fixed
    choice that every flavor's data holds, and is looked up once.
]]
local exampleItemIds = {}

local function ExampleItemId(listName)
	if exampleItemIds[listName] == nil then
		local lowest = false
		for itemId in pairs(ns[listName] or {}) do
			if not lowest or itemId < lowest then
				lowest = itemId
			end
		end
		exampleItemIds[listName] = lowest
	end
	return exampleItemIds[listName] or nil
end

local function ExampleLink(listName)
	return ns.ExampleItemLink(ExampleItemId(listName), ns.OPTIONS_REGISTRY.AlertsTints)
end

--------------------------------------------------------------------------------
-- Quest Item Alerts Section
--------------------------------------------------------------------------------

--[[
    A fragment of the Alerts & Tints panel rather than a panel of its own: it
    adds its widgets to the args table ns.BuildAlertsTintsOptions hands it,
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
		return format(L["QUEST_ITEM_READY"], ExampleLink("ALLOWED_DELETE_QUEST_ITEMS"), "")
	end, 26, QuestAlertsOff)

	args.spacerQuestUnavailable = ns.OptionsSpacer(27.5, QuestAlertsOff)
	args.exampleQuestUnavailable = ns.OptionsExample(function()
		return format(L["QUEST_STARTER_UNAVAILABLE"], ExampleLink("ALLOWED_DELETE_QUEST_STARTING_ITEMS"), "")
	end, 28, QuestAlertsOff)
end
