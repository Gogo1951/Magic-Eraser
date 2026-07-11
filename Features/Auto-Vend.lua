local _, ns = ...
local L = ns.L

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local UseContainerItem = C_Container.UseContainerItem

local sellQueue = {}
local isSelling = false
local sellIndex = 0

--[[
    Set when a vend pass is deferred because we are in combat (UseContainerItem
    is protected). OnCombatEnded resumes it once PLAYER_REGEN_ENABLED fires.
]]

local vendPending = false

-- Bounded retry for cold item-data misses; reset on each MERCHANT_SHOW.
local MAX_SCAN_RETRIES = 5
local scanRetries = 0

--[[
    After a sell pass finishes we re-scan and run another pass, because the
    server silently drops some UseContainerItem sells when many arrive in quick
    succession (leaving one or two junk items behind on large batches). Each
    re-scan rebuilds the queue from the live bag state, so only items that did
    not actually sell get re-queued. Bounded so a genuinely unsellable-but-
    flagged item can never loop forever; reset on each MERCHANT_SHOW.
]]

local MAX_VEND_PASSES = 4
local vendPasses = 0

--[[
    Slots already announced this merchant visit. A retry pass can re-sell a slot
    whose first UseContainerItem was silently dropped, but the player only needs
    to hear about that sale once. Wiped per visit in StartVending, not per pass.
]]

local announcedSales = {}

--[[
    Single guard for all Auto-Vend chat output. Disabling Auto-Vend messages
    silences the deferred-combat notice and the per-item sale lines alike.
]]

local function PrintVendMessage(message)
	if ns.db and ns.db.profile.autoVendMessagesEnabled then
		ns:PrintMessage(message)
	end
end

--------------------------------------------------------------------------------
-- Queue Processor
--------------------------------------------------------------------------------

--[[
    Forward declaration: ProcessSellQueue re-scans between passes, but the scanner
    is defined below it.
]]

local ScanAndVend

local function ProcessSellQueue()
	-- Stop if we are done or if the merchant window was closed
	if not isSelling then
		wipe(sellQueue)
		return
	end

	--[[
        UseContainerItem below is protected and forbidden in combat. If we
        entered combat mid-queue, stop now; OnCombatEnded re-scans and resumes
        from scratch once PLAYER_REGEN_ENABLED fires (slots may have shifted).
    ]]

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

	--[[
        If we have reached the end of the queue, re-scan and run another pass to
        catch any sells the server silently dropped. If nothing sellable remains
        (the common case) ScanAndVend stops cleanly; the pass cap prevents a loop.
    ]]

	if sellIndex > #sellQueue then
		if vendPasses < MAX_VEND_PASSES then
			vendPasses = vendPasses + 1
			C_Timer.After(0.3, ScanAndVend)
		else
			isSelling = false
			wipe(sellQueue)
		end
		return
	end

	local item = sellQueue[sellIndex]

	-- Double-check the slot before selling to ensure items have not shifted
	local currentItemInfo = GetContainerItemInfo(item.bag, item.slot)

	if currentItemInfo and currentItemInfo.itemID == item.itemId and not ns:IsIgnored(item.itemId) then
		UseContainerItem(item.bag, item.slot)

		local saleKey = string.format("%d:%d:%d", item.bag, item.slot, item.itemId)
		if not announcedSales[saleKey] then
			announcedSales[saleKey] = true
			local stackString = (item.count > 1) and string.format(" x%d", item.count) or ""
			PrintVendMessage(string.format(L["SOLD_ITEM"], item.link, stackString, ns:FormatCurrency(item.value)))
		end
	end

	C_Timer.After(0.1, ProcessSellQueue)
end

--------------------------------------------------------------------------------
-- Scanner
--------------------------------------------------------------------------------

function ScanAndVend()
	if not isSelling then
		return
	end

	local isDataMissing = false
	local _, playerClass = UnitClass("player")
	local classReagentExclusions = (ns.ClassReagentExclusions and ns.ClassReagentExclusions[playerClass]) or {}

	wipe(sellQueue)
	sellIndex = 0

	for bag = 0, 4 do
		local slotCount = GetContainerNumSlots(bag) or 0
		for slot = 1, slotCount do
			local itemInfo = GetContainerItemInfo(bag, slot)
			if itemInfo and itemInfo.hyperlink then
				local itemId = itemInfo.itemID

				if not ns:IsIgnored(itemId) and not classReagentExclusions[itemId] then
					local name, _, rarity, _, requiredLevel, _, _, _, _, _, sellPrice = GetItemInfo(itemInfo.hyperlink)

					if not name then
						isDataMissing = true
						if C_Item and C_Item.RequestLoadItemDataByID then
							C_Item.RequestLoadItemDataByID(itemId)
						end
					elseif sellPrice and sellPrice > 0 then
						local deleteReason = ns:GetItemDeleteReason(itemId, rarity, sellPrice, requiredLevel)

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
		C_Timer.After(0.5, ScanAndVend)
	elseif #sellQueue > 0 then
		table.sort(sellQueue, function(a, b)
			return a.value < b.value
		end)
		ProcessSellQueue()
	else
		isSelling = false
	end
end

local function StartVending()
	isSelling = true
	sellIndex = 0
	scanRetries = 0
	vendPasses = 0
	wipe(announcedSales)
	ScanAndVend()
end

--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------

--[[
    Registered and dispatched by Core's central event frame (see ns.EVENT_NAMES
    in Core.lua). This file owns the merchant handlers and has no event frame of
    its own, so the diagnostics event log -- which taps the one dispatcher --
    captures MERCHANT_SHOW and MERCHANT_CLOSED too.
]]

function ns:OnMerchantShow()
	if not (ns.db and ns.db.profile.autoVendEnabled) then
		return
	end

	--[[
        Vendoring relies on UseContainerItem, a protected call the client blocks
        in combat. If the merchant opened during combat, defer the whole pass
        until combat ends rather than tripping ADDON_ACTION_FORBIDDEN.
    ]]

	if InCombatLockdown() then
		if not vendPending then
			vendPending = true
			PrintVendMessage(L["AUTO_VEND_COMBAT_DEFERRED"])
		end
		return
	end

	StartVending()
end

function ns:OnMerchantClosed()
	isSelling = false
	vendPending = false
	wipe(sellQueue)
end

--[[
    PLAYER_REGEN_ENABLED. Selling is deferred while in combat (UseContainerItem
    is protected), so once combat ends we resume the deferred pass -- but only if
    the merchant window is still open. Fires on every combat end, so the
    vendPending guard keeps it free when nothing is waiting.
]]
function ns:OnCombatEnded()
	if not vendPending then
		return
	end
	vendPending = false

	if ns.db and ns.db.profile.autoVendEnabled and MerchantFrame and MerchantFrame:IsShown() then
		StartVending()
	end
end
