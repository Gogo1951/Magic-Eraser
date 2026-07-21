local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetTime = GetTime

-- Blizzard's count of equippable bag slots; bag 0 is the backpack.
local BAG_SLOTS = NUM_BAG_SLOTS or 4

--------------------------------------------------------------------------------
-- Bag-Space Warnings
--------------------------------------------------------------------------------

--[[
    Free-slot count at the last bag-space warning, so we don't reprint the same
    number twice in a row. BAG_UPDATE_DELAYED can fire more than once for a single
    purchase, and the 0.1s debounce only coalesces ones close together; this keeps
    the countdown to one line per slot lost. Reset when free climbs back above the
    threshold so re-entering the warning zone warns again. Runtime-only.

    Primed at login to the free count we log in with via ns:SeedBagSpaceBaseline
    (from Core's OnPlayerLogin), so the login-time BAG_UPDATE_DELAYED burst is
    "already known" and does not warn about bag space you arrived with -- only a
    slot lost while playing does.
]]
local lastNudgeFree = nil

--[[
    Bag-space warnings stay quiet until GetTime() reaches this deadline, set on
    every PLAYER_ENTERING_WORLD (see ns:OnEnteringWorld). Secondary to the
    unknown-vs-zero guard in CountFreeSlots: it simply keeps the check idle for a
    moment after each loading screen, while the client repopulates the containers.
]]
local BAG_SETTLE_SECONDS = 2
local bagWarningsHeldUntil = 0

--[[
    Free general-purpose bag slots, or nil when the container API has no data yet.

    Specialty bags -- soul bags, quivers, ammo pouches, profession bags -- are
    excluded: ordinary loot can't go there, so their free slots are useless to
    this warning. GogoLoot's Speedy-Loot budget is deliberately conservative in
    exactly the same way.

    The nil return is what fixes the reported bug. The shipped version summed
    "(bagFree or 0)" for every bag, which silently turned "the API has no data
    yet" into "this bag has zero free slots". Mid-loading-screen every container
    reads nil, so the total came out 0 and printed "Your bags are full!" to a
    player with 41 slots open -- and it repeated on every zone, because the
    correct read in between (free > threshold) re-armed the dedup each time.
    Reporting "unknown" instead lets the caller skip rather than cry full.

    Readiness is judged from the data itself: the backpack always has slots and
    always answers once the inventory is loaded, so a zero slot total, or no bag
    answering at all, means nothing is loaded yet.
]]
local function CountFreeSlots()
	local free, totalSlots, answered = 0, 0, 0
	for bag = 0, BAG_SLOTS do
		totalSlots = totalSlots + (GetContainerNumSlots(bag) or 0)

		local bagFree, bagFamily = GetContainerNumFreeSlots(bag)
		-- 0 is truthy in Lua, so this rejects only a missing reading, never a full bag.
		if bagFree then
			answered = answered + 1
			if bagFamily == 0 or bagFamily == nil then
				free = free + bagFree
			end
		end
	end

	if totalSlots == 0 or answered == 0 then
		return nil
	end
	return free
end

--[[
    A merchant or mailbox visit is exactly when bags churn hardest -- selling
    junk frees slots, buying and looting mail fills them -- so the countdown
    would fire a burst of noise that is stale the moment the window closes. We
    suppress it while either window is open (checked live rather than via a
    tracked flag so it stays correct even if a SHOW event is missed) and re-check
    once on close, so the warning reflects where the bags actually landed. Core's
    OnBagUpdateDelayed gates the nudge on this, so it is exposed on ns.
]]
function ns:IsBagWindowOpen()
	return (MerchantFrame and MerchantFrame:IsShown()) or (MailFrame and MailFrame:IsShown()) or false
end

--[[
    Seed the bag-space warning baseline with the free count we log in with, so the
    login-time BAG_UPDATE_DELAYED burst is treated as "already known" and does not
    fire a warning on load -- only a slot lost while playing does. Called from
    ns:OnPlayerLogin in Core. A nil count (containers not ready) simply leaves the
    baseline armed, which is the same state we start in.
]]
function ns:SeedBagSpaceBaseline()
	lastNudgeFree = CountFreeSlots()
end

--[[
    Hold the warning briefly on every PLAYER_ENTERING_WORLD -- loading-screen zone
    change, initial login, or /reload -- so the container repopulation that
    follows is never mistaken for slots lost in play. A fresh deadline each time
    means rapid back-to-back loading screens just extend the hold.
]]
function ns:OnEnteringWorld()
	bagWarningsHeldUntil = GetTime() + BAG_SETTLE_SECONDS
end

--[[
    Bag-space warning. Purely a free-space alert -- it never deletes and does not
    care whether there is anything erasable. Shared by the debounced bag update
    (which gates it on no bag window being open) and the merchant/mailbox close
    handlers (which fire it once the churn has settled). The lastNudgeFree dedup
    means the close-fire only prints when the count actually changed from the
    last line shown, so opening and closing a window without touching the bags
    stays quiet.
]]
function ns:CheckBagsFullNudge()
	if not (ns.db and ns.db.global.bagsFullNudgeEnabled) then
		return
	end

	-- Idle for a moment after each loading screen while the bags repopulate.
	if GetTime() < bagWarningsHeldUntil then
		return
	end

	local free = CountFreeSlots()
	if not free then
		-- Containers have no data yet: the answer is unknown, not full.
		return
	end

	if free > ns.db.global.bagsFullThreshold then
		lastNudgeFree = nil
	elseif free ~= lastNudgeFree then
		lastNudgeFree = free
		local message
		if free == 0 then
			message = L["BAGS_FULL"]
		elseif free == 1 then
			message = L["BAGS_FULL_NUDGE_ONE"]
		else
			message = string.format(L["BAGS_FULL_NUDGE"], free)
		end
		ns:PrintMessage(message)
	end
end

--[[
    Closing the mailbox is the counterpart to the merchant-close nudge in
    Auto-Vend's OnMerchantClosed: bag-space warnings are held while the window is
    open (see Core's OnBagUpdateDelayed), so re-check once it closes to warn if
    looting mail left the bags at or below the threshold.
]]
function ns:OnMailClosed()
	ns:CheckBagsFullNudge()
end
