local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetTime = GetTime

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
    unknown-vs-zero guard in ns:CountFreeBagSlots: it simply keeps the check idle
    for a moment after each loading screen, while the client repopulates the
    containers.
]]
local BAG_SETTLE_SECONDS = 2
local bagWarningsHeldUntil = 0

--[[
    A merchant, mailbox or bank visit is exactly when bags churn hardest --
    selling junk and pulling items out of the bank move whole stacks, buying and
    looting mail fill slots back up -- so the countdown would fire a burst of
    noise that is stale the moment the window closes. We suppress it while any of
    those windows is open (checked live rather than via a tracked flag so it
    stays correct even if a SHOW event is missed) and re-check once on close, so
    the warning reflects where the bags actually landed. Core's
    OnBagUpdateDelayed gates the nudge on this, so it is exposed on ns.
]]
function ns:IsBagWindowOpen()
	return (MerchantFrame and MerchantFrame:IsShown())
		or (MailFrame and MailFrame:IsShown())
		or (BankFrame and BankFrame:IsShown())
		or false
end

--[[
    Seed the bag-space warning baseline with the free count we log in with, so the
    login-time BAG_UPDATE_DELAYED burst is treated as "already known" and does not
    fire a warning on load -- only a slot lost while playing does. Called from
    ns:OnPlayerLogin in Core. A nil count (containers not ready) simply leaves the
    baseline armed, which is the same state we start in.
]]
function ns:SeedBagSpaceBaseline()
	lastNudgeFree = ns:CountFreeBagSlots()
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
    (which gates it on no bag window being open) and the merchant, mailbox and
    bank close handlers (which fire it once the churn has settled). The
    lastNudgeFree dedup means the close-fire only prints when the count actually
    changed from the last line shown, so opening and closing a window without
    touching the bags stays quiet.
]]
function ns:CheckBagsFullNudge()
	if not (ns.db and ns.db.global.bagsFullNudgeEnabled) then
		return
	end

	-- Idle for a moment after each loading screen while the bags repopulate.
	if GetTime() < bagWarningsHeldUntil then
		return
	end

	local free = ns:CountFreeBagSlots()
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
