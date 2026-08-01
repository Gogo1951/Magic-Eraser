local _, ns = ...

--------------------------------------------------------------------------------
-- Shared Options Helpers
--------------------------------------------------------------------------------

--[[
    Widget constructors shared by every options panel file. Dot-defined (no
    self), so callers use dot invocation -- ns.OptionsHeader(...) -- matching the
    panel builders.
]]
local GetColor = ns.GetColor

function ns.OptionsHeader(text, order, hidden)
	return { type = "header", name = GetColor("TITLE") .. text .. "|r", order = order, hidden = hidden }
end

function ns.OptionsDesc(text, order)
	return { type = "description", name = text, fontSize = "medium", order = order }
end

function ns.OptionsSpacer(order)
	return { type = "description", name = " ", order = order }
end

--------------------------------------------------------------------------------
-- Item Cache Warming
--------------------------------------------------------------------------------

--[[
    GetItemInfo answers nil for an item the client has not cached yet, which is
    the normal state for a list of item ids on a fresh login -- nothing has put
    those items in front of the player, so nothing has pulled their data. A panel
    that lists items renders those rows as L["LOADING_ITEM"] and hands the cold
    ids here.

    RequestLoadItemDataByID asks the server for each one, then a bounded poll
    repaints the panel as answers land. NotifyChange fires only when the cold
    count actually drops, so a repaint always means a row changed; the attempt
    cap means an id the server never answers for (a removed item) stops polling
    instead of spinning forever. One chain per registry name at a time: the
    repaint re-enters this function with the still-cold ids, and the pending flag
    keeps that from stacking a second chain of timers on top of the first.
]]
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

local WARM_RETRY_SECONDS = 0.5
local WARM_MAX_ATTEMPTS = 10

local warmingPending = {}

function ns.WarmItemCache(itemIds, registryName)
	if not (itemIds and itemIds[1] and registryName) then
		return
	end

	for _, itemId in ipairs(itemIds) do
		if C_Item and C_Item.RequestLoadItemDataByID then
			C_Item.RequestLoadItemDataByID(itemId)
		end
	end

	if warmingPending[registryName] then
		return
	end
	warmingPending[registryName] = true

	local coldCount = #itemIds
	local attempts = 0

	local function Poll()
		attempts = attempts + 1

		local stillCold = 0
		for _, itemId in ipairs(itemIds) do
			if not GetItemInfo(itemId) then
				stillCold = stillCold + 1
			end
		end

		if stillCold < coldCount then
			coldCount = stillCold
			AceConfigRegistry:NotifyChange(registryName)
		end

		if stillCold > 0 and attempts < WARM_MAX_ATTEMPTS then
			C_Timer.After(WARM_RETRY_SECONDS, Poll)
		else
			warmingPending[registryName] = nil
		end
	end

	C_Timer.After(WARM_RETRY_SECONDS, Poll)
end
