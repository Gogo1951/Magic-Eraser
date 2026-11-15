local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

local function QuestAlertsOff()
	return not (ns.db and ns.db.profile.questAlertsEnabled)
end

--[[
    The Example names a real quest item: the lowest item id in the flavor's
    quest-item table, a fixed choice that every flavor's data holds, looked
    up once.
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

    One Example line, the ready alert: the unavailable-starter alert is the
    same message with a different reason, so a second line would only repeat
    it.
]]
function ns.BuildQuestItemAlertsOptions(args)
	Kit.Section(args, "QuestAlerts", 20, L["OPTIONS_QUEST_ALERTS_HEADER"], L["OPTIONS_QUEST_ALERTS_DESCRIPTION"])
	args.toggleQuestAlerts = Kit.FeatureSwitch("questAlertsEnabled", 25)

	args.exampleQuestAlerts = Kit.Example(26, QuestAlertsOff, function()
		return ns.ExampleLine(format(L["QUEST_ITEM_READY"], ExampleLink("ALLOWED_DELETE_QUEST_ITEMS"), ""))
	end)
end
