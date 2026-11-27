local _, ns = ...
local L = ns.L

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local UseContainerItem = C_Container.UseContainerItem
local GetItemInfo = C_Item.GetItemInfo

local sellQueue = {}
local isSelling = false
local sellIndex = 0

local vendPending = false

local MAX_SCAN_RETRIES = 5
local scanRetries = 0

-- The server drops some bulk sells, so passes repeat from live bags, capped so an unsellable item can't loop.

local MAX_VEND_PASSES = 4
local vendPasses = 0

function ns:GetAutoVendState()
	return isSelling, vendPending, vendPasses, MAX_VEND_PASSES
end

local CLOSE_CONFIRM_SECONDS = 0.4

--[[
    Every timer carries the generation it started under and drops out once it's
    stale. isSelling alone can't: a reopened merchant sets it true again.
]]

local visitGeneration = 0

-- Per visit, never per pass: a retry can re-sell a slot, and the player hears it once.

local announcedSales = {}

-- Visit-scoped, so a sale attempted just before combat still confirms after the resume.

local pendingSales = {}

-- Accrued whatever the chat report, so changing it mid-visit still closes right.

local saleLines = {}

local summaryCount = 0
local summarySlots = 0
local summaryValue = 0

local function PrintVendMessage(message)
	if ns.db and ns.db.profile.autoVendMessagesEnabled then
		ns:PrintMessage(message)
	end
end

--------------------------------------------------------------------------------
-- Sale Confirmation
--------------------------------------------------------------------------------

--[[
    UseContainerItem is optimistic (a dead vendor accepts it silently), so a
    sale counts only once its slot no longer holds the item.
]]

local function ConfirmSales()
	for saleKey, sale in pairs(pendingSales) do
		local currentItemInfo = GetContainerItemInfo(sale.bag, sale.slot)
		if not currentItemInfo or currentItemInfo.itemID ~= sale.itemId then
			pendingSales[saleKey] = nil
			if not announcedSales[saleKey] then
				announcedSales[saleKey] = true
				summaryCount = summaryCount + sale.count
				summarySlots = summarySlots + 1
				summaryValue = summaryValue + sale.value
				local stackString = (sale.count > 1) and string.format(" x%d", sale.count) or ""
				table.insert(
					saleLines,
					string.format(L["SOLD_ITEM"], sale.link, stackString, ns:FormatCurrency(sale.value))
				)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Queue Processor
--------------------------------------------------------------------------------

local ScanAndVend

local function ProcessSellQueue(generation)
	-- A stale tick must not touch sellQueue: the wipe below would empty the live pass's queue.

	if generation ~= visitGeneration then
		return
	end

	if not (ns.db and ns.db.profile.autoVendEnabled) then
		isSelling = false
	end

	if not isSelling then
		wipe(sellQueue)
		return
	end

	-- UseContainerItem is protected. Only the queue drops; pendingSales still confirms after the resume.

	if InCombatLockdown() then
		isSelling = false
		wipe(sellQueue)
		if not vendPending then
			vendPending = true
			PrintVendMessage(L["AUTO_VEND_COMBAT_DEFERRED"])
		end
		return
	end

	sellIndex = sellIndex + 1

	if sellIndex > #sellQueue then
		if vendPasses < MAX_VEND_PASSES then
			vendPasses = vendPasses + 1
			C_Timer.After(0.3, function()
				ScanAndVend(generation)
			end)
		else
			isSelling = false
			wipe(sellQueue)
		end
		return
	end

	local item = sellQueue[sellIndex]

	local currentItemInfo = GetContainerItemInfo(item.bag, item.slot)

	if currentItemInfo and currentItemInfo.itemID == item.itemId and not ns:IsIgnored(item.itemId) then
		UseContainerItem(item.bag, item.slot)

		-- Recorded, not announced: ConfirmSales counts it once the slot empties.
		local saleKey = string.format("%d:%d:%d", item.bag, item.slot, item.itemId)
		if not announcedSales[saleKey] then
			pendingSales[saleKey] = {
				bag = item.bag,
				slot = item.slot,
				itemId = item.itemId,
				count = item.count,
				value = item.value,
				link = item.link,
			}
		end
	end

	C_Timer.After(0.1, function()
		ProcessSellQueue(generation)
	end)
end

--------------------------------------------------------------------------------
-- Scanner
--------------------------------------------------------------------------------

function ScanAndVend(generation)
	if not isSelling or generation ~= visitGeneration then
		return
	end

	if not (ns.db and ns.db.profile.autoVendEnabled) then
		isSelling = false
		return
	end

	ConfirmSales()

	local isDataMissing = false

	wipe(sellQueue)
	sellIndex = 0

	for _, bag in ipairs(ns.CARRIED_BAGS) do
		local slotCount = GetContainerNumSlots(bag) or 0
		for slot = 1, slotCount do
			local itemInfo = GetContainerItemInfo(bag, slot)
			if itemInfo and itemInfo.hyperlink then
				local itemId = itemInfo.itemID

				-- Ignore List first, so it wins over any Erase List entry.
				if not ns:IsIgnored(itemId) then
					local name, _, rarity, _, _, _, _, _, _, _, sellPrice = GetItemInfo(itemInfo.hyperlink)

					if not name then
						isDataMissing = true
						C_Item.RequestLoadItemDataByID(itemId)
					elseif sellPrice and sellPrice > 0 then
						local deleteReason = ns:GetItemDeleteReason(itemId, rarity, sellPrice, bag, slot)

						if deleteReason then
							local count = itemInfo.stackCount or 1
							local totalValue = sellPrice * count
							table.insert(sellQueue, {
								bag = bag,
								slot = slot,
								itemId = itemId,
								count = count,
								value = totalValue,
								link = itemInfo.hyperlink,
							})
						end
					end
				end
			end
		end
	end

	if isDataMissing and scanRetries < MAX_SCAN_RETRIES then
		scanRetries = scanRetries + 1
		C_Timer.After(0.5, function()
			ScanAndVend(generation)
		end)
	elseif #sellQueue > 0 then
		table.sort(sellQueue, function(a, b)
			return a.value < b.value
		end)
		ProcessSellQueue(generation)
	else
		isSelling = false
	end
end

-- Runs even when combat defers the pass, so the resume never inherits the last merchant's books.
local function BeginVisit()
	visitGeneration = visitGeneration + 1
	wipe(announcedSales)
	wipe(pendingSales)
	wipe(saleLines)
	summaryCount = 0
	summarySlots = 0
	summaryValue = 0
end

-- Nothing the visit owns, so the combat resume restarts a pass without touching the books.
local function StartPass()
	isSelling = true
	sellIndex = 0
	scanRetries = 0
	vendPasses = 0

	local generation = visitGeneration
	ScanAndVend(generation)
end

--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------

function ns:VendAtMerchant()
	if not (ns.db and ns.db.profile.autoVendEnabled) then
		return
	end

	-- Shift skips the visit. Returning before BeginVisit leaves nothing to resume or flush.

	if IsShiftKeyDown() then
		return
	end

	BeginVisit()

	if InCombatLockdown() then
		if not vendPending then
			vendPending = true
			PrintVendMessage(L["AUTO_VEND_COMBAT_DEFERRED"])
		end
		return
	end

	StartPass()
end

function ns:OnMerchantClosed()
	-- Bump first so pending timers retire; the flush captures the new value.

	visitGeneration = visitGeneration + 1

	isSelling = false
	vendPending = false
	wipe(sellQueue)

	-- Deferred: read at the instant of closing, the last sells' slots haven't emptied yet.
	local generation = visitGeneration
	C_Timer.After(CLOSE_CONFIRM_SECONDS, function()
		if generation ~= visitGeneration then
			return
		end

		ConfirmSales()

		-- Summary first, then the held sale lines under Every Sale, so the visit reads total on top.
		if summaryCount > 0 then
			local message
			if summaryCount == 1 then
				message = string.format(L["SOLD_SUMMARY_ONE_ITEM"], ns:FormatCurrency(summaryValue))
			elseif summarySlots == 1 then
				message = string.format(
					L["SOLD_SUMMARY_ONE_SLOT"],
					ns:FormatCommaNumber(summaryCount),
					ns:FormatCurrency(summaryValue)
				)
			else
				message = string.format(
					L["SOLD_SUMMARY"],
					ns:FormatCommaNumber(summaryCount),
					ns:FormatCommaNumber(summarySlots),
					ns:FormatCurrency(summaryValue)
				)
			end
			PrintVendMessage(message .. " " .. L["AUTO_VEND_SHIFT_HINT"])
			if not (ns.db and ns.db.profile.autoVendSummaryEnabled) then
				for _, line in ipairs(saleLines) do
					PrintVendMessage(line)
				end
			end
		end
		wipe(saleLines)
		summaryCount = 0
		summarySlots = 0
		summaryValue = 0
		wipe(pendingSales)

		ns:CheckBagsFullNudge()
	end)
end

-- A pass, not a visit: the window never closed, so attempted sales are still owed their lines.
function ns:ResumeDeferredVend()
	if not vendPending then
		return
	end
	vendPending = false

	if ns.db and ns.db.profile.autoVendEnabled and MerchantFrame and MerchantFrame:IsShown() then
		StartPass()
	end
end
