local _, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots

--------------------------------------------------------------------------------
-- Bag-Space Warnings
--------------------------------------------------------------------------------

--[[
    Free-slot count at the last bag-space warning, so we don't reprint the same
    number twice in a row. BAG_UPDATE_DELAYED can fire more than once for a single
    purchase, and the 0.1s debounce only coalesces ones close together; this keeps
    the countdown to one line per slot lost. Reset when free climbs back above the
    threshold so re-entering the warning zone warns again. Runtime-only.

    Primed to the current free count at login via ns:SeedBagSpaceBaseline (called
    from Core's OnPlayerLogin): the client fires a BAG_UPDATE_DELAYED burst as it
    populates bags on load, and we don't want that to warn about bag space you
    arrived with -- only about slots lost while playing. Seeding the baseline
    makes the login burst a no-op (free is unchanged from the seed) so the first
    real warning waits for a real change.
]]
local lastNudgeFree = nil

local function CountFreeSlots()
	local free = 0
	for bag = 0, 4 do
		-- Specialty bags (quiver, soul, profession) are excluded: ordinary loot can't go there.
		local bagFree, bagFamily = GetContainerNumFreeSlots(bag)
		if (bagFamily or 0) == 0 then
			free = free + (bagFree or 0)
		end
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
    Seed the bag-space warning baseline with the free count we log in with, so
    the login-time BAG_UPDATE_DELAYED burst is treated as "already known" and
    does not fire a warning on load -- only a slot lost while playing does. Called
    from ns:OnPlayerLogin in Core.
]]
function ns:SeedBagSpaceBaseline()
	lastNudgeFree = CountFreeSlots()
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

	local free = CountFreeSlots()
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
