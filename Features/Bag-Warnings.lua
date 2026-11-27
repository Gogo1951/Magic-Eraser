local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetTime = GetTime

--------------------------------------------------------------------------------
-- Bag-Space Warnings
--------------------------------------------------------------------------------

-- The warning fires only on a drop below this reading; seeded at login.
local lastSeenFree = nil

-- Idle until this time after each loading screen, while the containers repopulate.
local BAG_SETTLE_SECONDS = 2
local bagWarningsHeldUntil = 0

function ns:GetBagWarningState()
	return lastSeenFree, bagWarningsHeldUntil
end

--[[
    Bags churn hardest at these windows, so the warning holds until they close.
    The bank reads ns:IsBankOpen, not BankFrame, which Baganator keeps hidden.
]]
function ns:IsBagWindowOpen()
	return (MerchantFrame and MerchantFrame:IsShown())
		or (MailFrame and MailFrame:IsShown())
		or ns:IsBankOpen()
		or false
end

function ns:SeedBagSpaceBaseline()
	lastSeenFree = ns:CountFreeBagSlots()
end

function ns:OnPlayerEnteringWorld()
	bagWarningsHeldUntil = GetTime() + BAG_SETTLE_SECONDS
end

-- Full bags name the slots junk holds, so an Erase is the obvious next move.
local function FullMessage()
	ns:FindItemToDelete()
	local junkSlots = ns:GetReclaimSummary()
	if junkSlots == 1 then
		return L["BAGS_FULL_JUNK_ONE"]
	elseif junkSlots > 1 then
		return string.format(L["BAGS_FULL_JUNK"], junkSlots)
	end
	return L["BAGS_FULL"]
end

--[[
    Warns only on a drop at or under the threshold, so making room is silent.
    The baseline updates before every other guard, so a silent tick can't leave
    a stale reading for a phantom drop later.
]]
function ns:CheckBagsFullNudge()
	local free = ns:CountFreeBagSlots()
	if not free then
		-- Containers have no data yet: the answer is unknown, not full.
		return
	end

	local previousFree = lastSeenFree
	lastSeenFree = free

	if not (ns.db and ns.db.profile.bagsFullNudgeEnabled) then
		return
	end

	-- Idle for a moment after each loading screen while the bags repopulate.
	if GetTime() < bagWarningsHeldUntil then
		return
	end

	if free > ns.db.profile.bagsFullThreshold then
		return
	end

	if previousFree == nil or free >= previousFree then
		return
	end

	local message
	if free == 0 then
		message = FullMessage()
	elseif free == 1 then
		message = L["BAGS_FULL_NUDGE_ONE"]
	else
		message = string.format(L["BAGS_FULL_NUDGE"], free)
	end
	ns:PrintMessage(message)
end

function ns:OnMailClosed()
	ns:CheckBagsFullNudge()
end
