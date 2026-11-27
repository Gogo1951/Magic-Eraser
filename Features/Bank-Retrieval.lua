local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local UseContainerItem = C_Container.UseContainerItem
local GetItemInfo = C_Item.GetItemInfo

-- The bank reads empty for a moment after opening; one move per tick, since the server drops bursts.
local BANK_SETTLE_SECONDS = 0.5
local MOVE_INTERVAL_SECONDS = 0.1

local MAX_SCAN_RETRIES = 5
local SCAN_RETRY_SECONDS = 0.5
local scanRetries = 0

local moveQueue = {}
local moveIndex = 0
local moveBudget = 0
local isRetrieving = false
local pendingMove = nil

-- Every timer carries its generation; isRetrieving alone can't stop a stale chain after a reopen.
local passGeneration = 0

-- Confirmed moves only, so a dropped call is never reported.
local movedCount = 0
local movedSlots = 0
local movedValue = 0

-- From the events, never BankFrame, which Baganator keeps hidden while its bank window is open.
local isBankOpen = false

function ns:IsBankOpen()
	return isBankOpen
end

--------------------------------------------------------------------------------
-- Budget
--------------------------------------------------------------------------------

--[[
    The cushion applies only while Bag-Space Warnings are on: its slider is
    hidden otherwise. A nil free count means no pass.
]]
local function GetMoveBudget()
	local free = ns:CountFreeBagSlots()
	if not free then
		return 0
	end
	if not (ns.db and ns.db.profile.bagsFullNudgeEnabled) then
		return free
	end
	return free - (ns.db.profile.bagsFullThreshold or 0)
end

function ns:GetBankMoveBudget()
	return GetMoveBudget()
end

function ns:IsBankRetrieving()
	return isRetrieving
end

--------------------------------------------------------------------------------
-- Pass Lifecycle
--------------------------------------------------------------------------------

-- The single exit. Resets everything, so a second call stays silent.
local function FinishPass()
	isRetrieving = false
	wipe(moveQueue)
	moveIndex = 0
	moveBudget = 0
	pendingMove = nil

	if movedSlots > 0 then
		local message
		if movedCount == 1 then
			message = string.format(L["BANK_RETRIEVED_ONE_ITEM"], ns:FormatCurrency(movedValue))
		elseif movedSlots == 1 then
			message = string.format(
				L["BANK_RETRIEVED_ONE_SLOT"],
				ns:FormatCommaNumber(movedCount),
				ns:FormatCurrency(movedValue)
			)
		else
			message = string.format(
				L["BANK_RETRIEVED"],
				ns:FormatCommaNumber(movedCount),
				ns:FormatCommaNumber(movedSlots),
				ns:FormatCurrency(movedValue)
			)
		end
		ns:PrintMessage(message)

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

-- A move counts once its bank slot no longer holds the item; one extra tick checks the last.
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

	-- Ends rather than defers: unlike a merchant, there is nothing to come back to.
	if InCombatLockdown() or not isBankOpen then
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

	-- Slots shift as items leave; a mismatch is skipped and costs no budget.
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

-- Shared with the tint so the two never disagree. A cold item answers only the third value, true.
function ns:IsBankJunk(itemId, hyperlink, bag, slot)
	if ns:IsIgnored(itemId) then
		return nil
	end
	local name, _, rarity, _, _, _, _, _, _, _, sellPrice = GetItemInfo(hyperlink)
	if not name then
		C_Item.RequestLoadItemDataByID(itemId)
		return nil, nil, true
	end
	return ns:GetItemDeleteReason(itemId, rarity, sellPrice, bag, slot), sellPrice
end

local function ScanBank(generation)
	if not isRetrieving or generation ~= passGeneration then
		return
	end

	local isDataMissing = false

	wipe(moveQueue)
	moveIndex = 0

	for _, bag in ipairs(ns.BANK_CONTAINERS) do
		local slotCount = GetContainerNumSlots(bag) or 0
		for slot = 1, slotCount do
			local itemInfo = GetContainerItemInfo(bag, slot)
			if itemInfo and itemInfo.hyperlink then
				local itemId = itemInfo.itemID
				local deleteReason, sellPrice, isItemDataMissing = ns:IsBankJunk(itemId, itemInfo.hyperlink, bag, slot)

				if isItemDataMissing then
					isDataMissing = true
				elseif deleteReason then
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

	-- Most valuable first: the budget may run out, so what stays behind should matter least.
	table.sort(moveQueue, function(a, b)
		return a.value > b.value
	end)

	ProcessMoveQueue(generation)
end

local function StartPass(generation)
	if not isRetrieving or generation ~= passGeneration then
		return
	end

	if InCombatLockdown() or not isBankOpen then
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

function ns:OnBankframeOpened()
	-- The bank tints go ahead whether or not Bank Retrieval is on, once the slots have settled.
	isBankOpen = true
	ns:RefreshTints()
	C_Timer.After(BANK_SETTLE_SECONDS, function()
		ns:RefreshTints()
	end)

	if not (ns.db and ns.db.profile.bankRetrievalEnabled) then
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

function ns:OnBankframeClosed()
	-- Through FinishPass, so a pass cut short still reports what it moved.
	FinishPass()
	isBankOpen = false
	ns:RefreshTints()

	ns:CheckBagsFullNudge()
end
