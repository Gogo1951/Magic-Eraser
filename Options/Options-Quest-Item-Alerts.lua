local _, ns = ...
local L = ns.L

local format = string.format

local Kit = ns.OptionsKit

local function QuestAlertsOff()
	return not (ns.db and ns.db.profile.questAlertsEnabled)
end

-- The flavor's lowest quest-item id: a real item every flavor's data holds.
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

-- One Example line: the unavailable-starter alert is the same message with another reason.
function ns.BuildQuestItemAlertsOptions(args)
	Kit.Section(args, "QuestAlerts", 20, L["OPTIONS_QUEST_ALERTS_HEADER"], L["OPTIONS_QUEST_ALERTS_DESCRIPTION"])
	args.toggleQuestAlerts = Kit.FeatureSwitch("questAlertsEnabled", 25)

	args.exampleQuestAlerts = Kit.Example(26, QuestAlertsOff, function()
		return ns.ExampleLine(format(L["QUEST_ITEM_READY"], ExampleLink("ALLOWED_DELETE_QUEST_ITEMS"), ""))
	end)
end
