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

local CLOSE_CONFIRM_SECONDS = 0.4
local visitGeneration = 0

--[[
    Slots already announced this merchant visit. A retry pass can re-sell a slot
    whose first UseContainerItem was silently dropped, but the player only needs
    to hear about that sale once. Wiped per visit in BeginVisit -- never per
    pass, and never on the combat resume, which continues the same visit rather
    than opening a new one.
]]

local announcedSales = {}

--[[
    Attempted-but-unconfirmed sales, keyed bag:slot:itemId -> the data needed to
    announce the sale later (count, value, link). ProcessSellQueue fills this;
    ConfirmSales drains it as items are confirmed gone from their slots. Visit
    scoped alongside announcedSales, which is what lets a sale attempted just
    before combat interrupted the pass still be confirmed and announced once the
    pass restarts.
]]

local pendingSales = {}

--[[
    Per-visit totals for summary mode. Accrued for every newly announced sale
    regardless of the Verbose/Summary setting, so flipping the dropdown
    mid-visit still produces a correct closing line. summarySlots counts one per
    sale (each sold stack empties one bag slot). Visit scoped alongside
    announcedSales, and flushed in OnMerchantClosed.
]]

local summaryCount = 0
local summarySlots = 0
local summaryValue = 0

--[[
    Single guard for all Auto-Vend chat output. Disabling Auto-Vend messages
    silences the deferred-combat notice, the per-item sale lines, and the
    per-visit summary line alike.
]]

local function PrintVendMessage(message)
	if ns.db and ns.db.global.autoVendMessagesEnabled then
		ns:PrintMessage(message)
	end
end

--------------------------------------------------------------------------------
-- Sale Confirmation
--------------------------------------------------------------------------------

--[[
    A sale is only real once the item actually leaves its slot. UseContainerItem
    is optimistic: a merchant that cannot complete the transaction -- e.g. a
    "dead" corpse vendor that still opens a merchant frame -- accepts the call
    silently, so announcing at send time would report phantom sales. Instead
    ProcessSellQueue records each attempt in pendingSales and we confirm here:
    any slot that no longer holds the attempted item has sold, and is announced
    and counted exactly once. An item still sitting in its slot did not sell --
    it stays pending for a later pass, and an unsellable-but-flagged item is
    simply never announced.

    Runs at the top of each ScanAndVend re-scan (0.3s after a pass -- long enough
    for the sell round-trip to empty the slot) and once more shortly after the
    merchant window closes, on the deferred flush in ns:OnMerchantClosed.
]]

local function ConfirmSales()
	for saleKey, sale in pairs(pendingSales) do
		local currentItemInfo = GetContainerItemInfo(sale.bag, sale.slot)
		if not currentItemInfo or currentItemInfo.itemID ~= sale.itemId then
			-- Slot no longer holds the attempted item: the sale went through.
			pendingSales[saleKey] = nil
			if not announcedSales[saleKey] then
				announcedSales[saleKey] = true
				summaryCount = summaryCount + sale.count
				summarySlots = summarySlots + 1
				summaryValue = summaryValue + sale.value
				if not (ns.db and ns.db.global.autoVendSummaryEnabled) then
					local stackString = (sale.count > 1) and string.format(" x%d", sale.count) or ""
					PrintVendMessage(
						string.format(L["SOLD_ITEM"], sale.link, stackString, ns:FormatCurrency(sale.value))
					)
				end
			end
		end
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
        entered combat mid-queue, stop now; OnCombatEnded starts a fresh pass
        once PLAYER_REGEN_ENABLED fires, rebuilding the queue from live bag state
        because slots may have shifted. Only the queue is dropped: pendingSales
        keeps the already-attempted sales so the resumed pass can still confirm
        and announce them.
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

		--[[
		    Record the attempt but do not announce yet: ConfirmSales counts this
		    sale only once it sees the item leave the slot, so a merchant that
		    silently accepts the call without buying (a dead corpse vendor) never
		    produces a phantom "Sold" line. Skip a slot already confirmed on an
		    earlier pass; a re-attempt of a still-present item just refreshes it.
		]]
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

	C_Timer.After(0.1, ProcessSellQueue)
end

--------------------------------------------------------------------------------
-- Scanner
--------------------------------------------------------------------------------

function ScanAndVend()
	if not isSelling then
		return
	end

	--[[
	    Confirm the previous pass before rebuilding the queue. This runs 0.3s
	    after that pass's last UseContainerItem (the hand-off below), long enough
	    for sold slots to have emptied.
	]]
	ConfirmSales()

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
					local name, _, rarity, _, _, _, _, _, _, _, sellPrice = GetItemInfo(itemInfo.hyperlink)

					if not name then
						isDataMissing = true
						if C_Item and C_Item.RequestLoadItemDataByID then
							C_Item.RequestLoadItemDataByID(itemId)
						end
					elseif sellPrice and sellPrice > 0 then
						local deleteReason = ns:GetItemDeleteReason(itemId, rarity, sellPrice)

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

--[[
    Open a visit: clear the sale accounting the visit owns. MERCHANT_SHOW starts
    a visit whether or not a pass can run right now, so this fires even when the
    pass is deferred to the end of combat -- otherwise the resumed pass would
    inherit the previous merchant's announced slots.
]]
local function BeginVisit()
	visitGeneration = visitGeneration + 1
	wipe(announcedSales)
	wipe(pendingSales)
	summaryCount = 0
	summarySlots = 0
	summaryValue = 0
end

--[[
    Everything a fresh pass needs and nothing the visit owns, so a pass can be
    restarted mid-visit without disturbing the books. That is what lets a sale
    attempted moments before combat interrupted us survive: it is still sitting
    in pendingSales, and the ConfirmSales at the top of the resumed ScanAndVend
    is what finally announces and counts it.
]]
local function StartPass()
	isSelling = true
	sellIndex = 0
	scanRetries = 0
	vendPasses = 0
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
	if not (ns.db and ns.db.global.autoVendEnabled) then
		return
	end

	BeginVisit()

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

	StartPass()
end

function ns:OnMerchantClosed()
	isSelling = false
	vendPending = false
	wipe(sellQueue)

	--[[
	    Final confirmation, deferred so the last sells have time to leave their
	    slots. A pass that hit the retry cap, or whose last sells landed after the
	    final re-scan, can still have entries in pendingSales; reading those slots
	    the instant the window closes would check them before the bags update and
	    drop real sales from the count. A dead merchant's never-sold items are
	    still in their slots, so they confirm nothing and stay silent. The
	    generation check drops this flush when a new visit has already begun.
	]]
	local generation = visitGeneration
	C_Timer.After(CLOSE_CONFIRM_SECONDS, function()
		if generation ~= visitGeneration then
			return
		end

		ConfirmSales()

		--[[
		    The per-visit summary prints one closing line whenever anything sold,
		    in both message modes: Summary Only shows it alone, and Line Item
		    shows it beneath the per-item lines. This deferred flush is the flush
		    point. Routed through PrintVendMessage so the Enable Auto-Vend
		    Messages toggle silences it like all other vend output.
		]]
		if summaryCount > 0 then
			PrintVendMessage(
				string.format(
					L["SOLD_SUMMARY"],
					ns:FormatCommaNumber(summaryCount),
					ns:FormatCommaNumber(summarySlots),
					ns:FormatCurrency(summaryValue)
				)
			)
		end
		summaryCount = 0
		summarySlots = 0
		summaryValue = 0
		wipe(pendingSales)

		--[[
		    Bag-space warnings are suppressed while the merchant window is open
		    (see OnBagUpdateDelayed in Core), since selling churns free slots.
		    Re-check here so the warning reflects where the bags landed after this
		    visit.
		]]
		ns:CheckBagsFullNudge()
	end)
end

--[[
    PLAYER_REGEN_ENABLED. Selling is deferred while in combat (UseContainerItem
    is protected), so once combat ends we resume the deferred pass -- but only if
    the merchant window is still open. Fires on every combat end, so the
    vendPending guard keeps it free when nothing is waiting.

    A pass, not a visit: the merchant window never closed, so the sales already
    attempted are still this visit's and are still owed an announcement.
]]
function ns:OnCombatEnded()
	if not vendPending then
		return
	end
	vendPending = false

	if ns.db and ns.db.global.autoVendEnabled and MerchantFrame and MerchantFrame:IsShown() then
		StartPass()
	end
end
