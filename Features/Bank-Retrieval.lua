local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local UseContainerItem = C_Container.UseContainerItem

--[[
    The bank on both flavors this add-on ships on is BANK_CONTAINER plus the
    purchasable bank bags, which sit directly above the carried bags in the
    container index space. There is no reagent bank on Classic Era or TBC
    Anniversary, so nothing else is scanned. Built once at load, starting one
    past the shared carried-bag range (ns.LAST_BAG_INDEX in Data/Data.lua) and
    falling back on the bank's own constants the same way, so a missing global
    can never quietly scan nothing.
]]
local BANK_CONTAINERS = {}
do
	local carriedBags = ns.LAST_BAG_INDEX
	BANK_CONTAINERS[1] = BANK_CONTAINER or -1
	for bag = carriedBags + 1, carriedBags + (NUM_BANKBAGSLOTS or 6) do
		BANK_CONTAINERS[#BANK_CONTAINERS + 1] = bag
	end
end

--[[
    The bank containers read empty for a moment after BANKFRAME_OPENED while the
    client populates them, so the pass waits before its first scan. The move
    pacing matches Auto-Vend's: one protected call per 0.1s tick rather than a
    burst the server may partly drop.
]]
local BANK_SETTLE_SECONDS = 0.5
local MOVE_INTERVAL_SECONDS = 0.1

-- Bounded retry for cold item-data misses; reset on each BANKFRAME_OPENED.
local MAX_SCAN_RETRIES = 5
local SCAN_RETRY_SECONDS = 0.5
local scanRetries = 0

local moveQueue = {}
local moveIndex = 0
local moveBudget = 0
local isRetrieving = false
local pendingMove = nil

--[[
    Bumped on every BANKFRAME_OPENED. Each timer this file sets carries the
    generation it was scheduled under and drops out when a newer pass has begun
    since, so closing and reopening the bank inside the settle window cannot
    leave two chains walking the same queue. isRetrieving alone would not catch
    it: the second open sets that flag back to true, and the first pass's stale
    timer would sail straight through the check.
]]
local passGeneration = 0

--[[
    Totals for the closing summary, accrued only for moves ConfirmPendingMove has
    seen leave their bank slot, so a call the server drops is never reported.
    movedSlots counts one per moved stack (each one empties a bank slot and fills
    a bag slot); movedCount counts stacked quantity, so a stack of five is one
    slot and five items.
]]
local movedCount = 0
local movedSlots = 0
local movedValue = 0

local function IsBankOpen()
	return (BankFrame and BankFrame:IsShown()) or false
end

--------------------------------------------------------------------------------
-- Budget
--------------------------------------------------------------------------------

--[[
    How many bank slots this pass may empty into the bags: every free
    general-purpose bag slot, less the cushion the player set as their Free-Slot
    Threshold -- but only while Bag-Space Warnings are actually on.

    The cushion exists for one reason, to stop retrieval walking the bags into
    the bag-space warning it would otherwise cause. With that warning switched
    off there is no warning to stop short of and nothing to reserve, and the
    Free-Slot Threshold slider is a sub-option of the Bag-Space Warnings toggle
    that is hidden while the toggle is off -- so reserving there would let a
    setting the player cannot see hold back a feature they can.

    A nil count means the container API has not answered yet, which is not the
    same as zero free slots (see ns:CountFreeBagSlots), so it yields no budget
    and the pass simply does not run.
]]
local function GetMoveBudget()
	local free = ns:CountFreeBagSlots()
	if not free then
		return 0
	end
	if not (ns.db and ns.db.global.bagsFullNudgeEnabled) then
		return free
	end
	return free - (ns.db.global.bagsFullThreshold or 0)
end

--------------------------------------------------------------------------------
-- Pass Lifecycle
--------------------------------------------------------------------------------

--[[
    The single end of a pass, however it ended: budget spent, queue exhausted,
    combat, or the bank window closing. Prints one summary line when anything was
    confirmed moved and nothing at all when nothing was, then resets the totals
    and drops any still-unconfirmed move so a second call (the pass finishing and
    then BANKFRAME_CLOSED arriving) stays silent and nothing leaks into the next
    pass. A pass cut short by combat or the window closing therefore leaves its
    last move uncounted rather than claiming one it could not verify.
]]
local function FinishPass()
	isRetrieving = false
	wipe(moveQueue)
	moveIndex = 0
	moveBudget = 0
	pendingMove = nil

	if movedSlots > 0 then
		ns:PrintMessage(
			string.format(
				L["BANK_RETRIEVED"],
				ns:FormatCommaNumber(movedCount),
				ns:FormatCommaNumber(movedSlots),
				ns:FormatCurrency(movedValue)
			)
		)

		ns:InvalidateCache()
		ns:RefreshDisplay()
	end

	movedCount = 0
	movedSlots = 0
	movedValue = 0
end

--------------------------------------------------------------------------------
-- Queue Processor
--------------------------------------------------------------------------------

--[[
    UseContainerItem is optimistic: the server can drop the call, so a move only
    counts once the bank slot it came from no longer holds that item. The next
    tick makes that check, and the exhaustion branch below schedules one extra
    tick so the last move of a pass gets the same chance.
]]
local function ConfirmPendingMove()
	if not pendingMove then
		return
	end

	local currentItemInfo = GetContainerItemInfo(pendingMove.bag, pendingMove.slot)
	if not currentItemInfo or currentItemInfo.itemID ~= pendingMove.itemId then
		movedCount = movedCount + pendingMove.count
		movedSlots = movedSlots + 1
		movedValue = movedValue + pendingMove.value
	end

	pendingMove = nil
end

local function ProcessMoveQueue(generation)
	if not isRetrieving or generation ~= passGeneration then
		return
	end

	--[[
	    UseContainerItem is protected and forbidden in combat, and the bank
	    window does not survive combat either, so there is nothing to come back
	    to: end the pass outright rather than deferring and resuming the way
	    Auto-Vend does at a merchant.
	]]
	if InCombatLockdown() or not IsBankOpen() then
		FinishPass()
		return
	end

	moveIndex = moveIndex + 1

	if moveIndex > #moveQueue or moveBudget <= 0 then
		if pendingMove then
			C_Timer.After(MOVE_INTERVAL_SECONDS, function()
				if generation ~= passGeneration then
					return
				end
				ConfirmPendingMove()
				FinishPass()
			end)
			return
		end
		FinishPass()
		return
	end

	ConfirmPendingMove()

	local item = moveQueue[moveIndex]

	--[[
	    Re-check the slot before every call: items leaving the bank shift the
	    ones behind them, so the slot this entry was queued from may now hold
	    something else entirely. A slot that no longer matches is skipped rather
	    than moved, and costs no budget.
	]]
	local currentItemInfo = GetContainerItemInfo(item.bag, item.slot)

	if currentItemInfo and currentItemInfo.itemID == item.itemId then
		UseContainerItem(item.bag, item.slot)

		moveBudget = moveBudget - 1
		pendingMove = item
	end

	C_Timer.After(MOVE_INTERVAL_SECONDS, function()
		ProcessMoveQueue(generation)
	end)
end

--------------------------------------------------------------------------------
-- Scanner
--------------------------------------------------------------------------------

--[[
    Exactly the eraser's predicate, run over the bank containers instead of the
    bags: skip anything on either ignore list, resolve the item, and keep
    whatever ns:GetItemDeleteReason flags, Erase List entries included. Cold item
    data reschedules the whole scan behind the same cap Eraser.lua and
    Auto-Vend.lua use, so an item whose data never resolves cannot loop forever.

    Maximum Value to Erase is not consulted here at all, so it needs no Erase
    List carve-out: retrieval moves an item rather than destroying it.
]]
local function ScanBank(generation)
	if not isRetrieving or generation ~= passGeneration then
		return
	end

	local isDataMissing = false

	wipe(moveQueue)
	moveIndex = 0

	for _, bag in ipairs(BANK_CONTAINERS) do
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
						if C_Item and C_Item.RequestLoadItemDataByID then
							C_Item.RequestLoadItemDataByID(itemId)
						end
					else
						local deleteReason = ns:GetItemDeleteReason(itemId, rarity, sellPrice)

						if deleteReason then
							local count = itemInfo.stackCount or 1
							moveQueue[#moveQueue + 1] = {
								bag = bag,
								slot = slot,
								itemId = itemId,
								count = count,
								value = (sellPrice or 0) * count,
							}
						end
					end
				end
			end
		end
	end

	if isDataMissing and scanRetries < MAX_SCAN_RETRIES then
		scanRetries = scanRetries + 1
		C_Timer.After(SCAN_RETRY_SECONDS, function()
			ScanBank(generation)
		end)
		return
	end

	if #moveQueue == 0 then
		FinishPass()
		return
	end

	--[[
	    Most valuable first, the opposite of Auto-Vend's ascending sell order.
	    Auto-Vend has the whole merchant visit to work through its queue, so it
	    starts with the cheapest clutter; this pass is capped by however many bag
	    slots happen to be free, so when the budget runs out mid-queue what gets
	    left in the bank should be the gold that mattered least.
	]]
	table.sort(moveQueue, function(a, b)
		return a.value > b.value
	end)

	ProcessMoveQueue(generation)
end

local function StartPass(generation)
	if not isRetrieving or generation ~= passGeneration then
		return
	end

	if InCombatLockdown() or not IsBankOpen() then
		FinishPass()
		return
	end

	moveBudget = GetMoveBudget()
	if moveBudget <= 0 then
		FinishPass()
		return
	end

	ScanBank(generation)
end

--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------

--[[
    Registered and dispatched by Core's central event frame (see ns.EVENT_NAMES
    in Core.lua). This file owns the bank handlers and has no event frame of its
    own, so the diagnostics event log -- which taps the one dispatcher --
    captures BANKFRAME_OPENED and BANKFRAME_CLOSED too.
]]

function ns:OnBankOpened()
	if not (ns.db and ns.db.global.bankRetrievalEnabled) then
		return
	end

	passGeneration = passGeneration + 1
	local generation = passGeneration

	scanRetries = 0
	movedCount = 0
	movedSlots = 0
	movedValue = 0
	isRetrieving = true

	C_Timer.After(BANK_SETTLE_SECONDS, function()
		StartPass(generation)
	end)
end

function ns:OnBankClosed()
	--[[
	    Ending through FinishPass rather than clearing the state here is what
	    lets a pass cut short by the player closing the window still report what
	    it moved: BANKFRAME_CLOSED lands before the queue's next tick notices the
	    window is gone.
	]]
	FinishPass()

	--[[
	    Bag-space warnings are held while the bank window is open (see
	    ns:IsBagWindowOpen), because retrieval churns free slots. Re-check on
	    close so the warning reflects where the bags landed, the counterpart to
	    ns:OnMailClosed and Auto-Vend's merchant-close nudge.
	]]
	ns:CheckBagsFullNudge()
end
