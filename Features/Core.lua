local ADDON_NAME, ns = ...
local L = ns.L

--[[
    DESIGN NOTE -- planned Core split (deferred; do not action inline). This file
    is large. When it is time to trim it, extract two permanent feature files --
    matching the "one file per feature" model and the Auto-Vend precedent -- and
    leave Core as the state + lifecycle + dispatcher spine:
      * Eraser.lua       -- scan cache, retry machinery, GetItemDeleteReason,
                            ranking, the safety popup, PerformErase / RunEraser.
      * Bag-Warnings.lua -- CountFreeSlots, IsBagWindowOpen, CheckBagsFullNudge,
                            and the OnMailClosed handler.
    The dated migration blocks stay here; they self-remove by 2026-10-11. Full
    runnable prompt: Add-on Creation Factory / "Deferred -- Magic Eraser Core.lua
    Split.md".
]]

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local GetContainerNumFreeSlots = C_Container.GetContainerNumFreeSlots
local PickupContainerItem = C_Container.PickupContainerItem
local format, ipairs = string.format, ipairs

--------------------------------------------------------------------------------
-- Version
--------------------------------------------------------------------------------

local function GetVersion()
	local GetAddOnMetadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
	local version = GetAddOnMetadata(ADDON_NAME, "Version")
	if not version or version:find("@") then
		return "Dev"
	end
	return version
end

ns.Version = GetVersion()

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

--[[
    The ignore list is the one per-character setting. It lives inside the profile
    but keyed by character (ns.db.keys.char = "Name - Realm"), so each toon has
    its own list within whatever profile is active, and switching profiles swaps
    the whole set. The bucket is created on first use, so a brand-new toon simply
    starts empty. Returns nil only before the database exists.
]]
function ns:GetIgnoreList()
	if not ns.db then
		return nil
	end
	local ignoreLists = ns.db.profile.ignoreLists
	if type(ignoreLists) ~= "table" then
		ignoreLists = {}
		ns.db.profile.ignoreLists = ignoreLists
	end
	local charKey = ns.db.keys.char
	local list = ignoreLists[charKey]
	if not list then
		list = {}
		ignoreLists[charKey] = list
	end
	return list
end

function ns:IsIgnored(itemId)
	local ignoreList = ns:GetIgnoreList()
	return ignoreList and ignoreList[itemId]
end

function ns:ToggleIgnore(itemId)
	if not itemId then
		return
	end
	local ignoreList = ns:GetIgnoreList()
	if not ignoreList then
		return
	end
	if ignoreList[itemId] then
		ignoreList[itemId] = nil
	else
		ignoreList[itemId] = true
	end
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

function ns:ClearIgnoreList()
	local ignoreList = ns:GetIgnoreList()
	if ignoreList then
		wipe(ignoreList)
	end
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

--------------------------------------------------------------------------------
-- Scan Cache
--------------------------------------------------------------------------------

local cachedItem = nil
local isCacheValid = false

--[[
    Running totals for the tooltip's Clutter Report, populated as a side effect
    of FindItemToDelete's single bag scan so the summary shares the candidate
    cache's lifecycle -- one scan feeds both the lowest-value pick and the
    report, and both go stale together on InvalidateCache. Slots counts bag slots
    freed; items counts stacked quantity (a stack of 5 is one slot, five items).
]]
local cachedReclaimSlots = 0
local cachedReclaimItems = 0
local cachedReclaimValue = 0

--[[
    Cold item-data misses reschedule a rescan. Without a cap, an item whose
    GetItemInfo never resolves would reschedule forever; without a pending
    guard, concurrent cold-cache triggers would stack timers. So: cap the
    reschedules, allow only one pending retry, and reset the counter on every
    fresh scan trigger -- any InvalidateCache that is not itself a retry.
]]
local MAX_SCAN_RETRIES = 5
local scanRetries = 0
local retryPending = false
local inScanRetry = false

function ns:InvalidateCache()
	isCacheValid = false
	cachedItem = nil
	cachedReclaimSlots = 0
	cachedReclaimItems = 0
	cachedReclaimValue = 0
	if not inScanRetry then
		scanRetries = 0
	end
end

local function ScheduleScanRetry()
	if retryPending or scanRetries >= MAX_SCAN_RETRIES then
		return
	end
	retryPending = true
	scanRetries = scanRetries + 1
	C_Timer.After(1.0, function()
		retryPending = false
		inScanRetry = true
		ns:RefreshDisplay()
		inScanRetry = false
	end)
end

--------------------------------------------------------------------------------
-- Scanning & Evaluation
--------------------------------------------------------------------------------

function ns:GetItemDeleteReason(itemId, rarity, sellPrice, requiredLevel)
	local playerLevel = UnitLevel("player")
	local questItemDatabase = ns.AllowedDeleteQuestItems or {}
	local consumableDatabase = ns.AllowedDeleteConsumables or {}
	local equipmentDatabase = ns.AllowedDeleteEquipment or {}

	if questItemDatabase[itemId] then
		for _, questId in ipairs(questItemDatabase[itemId]) do
			if self:IsQuestCompleted(questId) then
				return "quest"
			end
		end
	elseif consumableDatabase[itemId] then
		if (playerLevel - (requiredLevel or 1)) >= 10 then
			return "consumable"
		end
	elseif equipmentDatabase[itemId] then
		return "equipment"
	elseif rarity == 0 and (sellPrice or 0) > 0 then
		return "gray"
	end

	return nil
end

local function isBetterDeletionCandidate(candidate, current)
	if candidate.value < current.value then
		return true
	end
	if candidate.value == current.value then
		return ns.DeletePriority[candidate.deleteReason] < ns.DeletePriority[current.deleteReason]
	end
	return false
end

function ns:FindItemToDelete()
	if isCacheValid then
		return cachedItem
	end

	local best = nil
	local reclaimSlots, reclaimItems, reclaimValue = 0, 0, 0
	local _, playerClass = UnitClass("player")
	local isDataMissing = false
	local classReagentExclusions = (ns.ClassReagentExclusions and ns.ClassReagentExclusions[playerClass]) or {}

	for bag = 0, 4 do
		local slotCount = GetContainerNumSlots(bag) or 0
		for slot = 1, slotCount do
			local itemInfo = GetContainerItemInfo(bag, slot)

			if itemInfo and itemInfo.hyperlink then
				local itemId = itemInfo.itemID

				if not ns:IsIgnored(itemId) and not classReagentExclusions[itemId] then
					local name, _, rarity, _, requiredLevel, _, _, _, _, icon, sellPrice =
						GetItemInfo(itemInfo.hyperlink)

					if not name then
						isDataMissing = true
						if C_Item and C_Item.RequestLoadItemDataByID then
							C_Item.RequestLoadItemDataByID(itemId)
						end
					else
						local count = itemInfo.stackCount or 1
						local totalValue = (sellPrice or 0) * count
						local deleteReason = self:GetItemDeleteReason(itemId, rarity, sellPrice, requiredLevel)

						if deleteReason then
							-- Slots counts one per qualifying slot; items counts stacked quantity.
							reclaimSlots = reclaimSlots + 1
							reclaimItems = reclaimItems + count
							reclaimValue = reclaimValue + totalValue
							local candidate = {
								link = itemInfo.hyperlink,
								itemId = itemId,
								count = count,
								value = totalValue,
								icon = icon,
								bag = bag,
								slot = slot,
								deleteReason = deleteReason,
							}
							if not best or isBetterDeletionCandidate(candidate, best) then
								best = candidate
							end
						end
					end
				end
			end
		end
	end

	if isDataMissing then
		ScheduleScanRetry()
	end

	cachedItem = best
	cachedReclaimSlots = reclaimSlots
	cachedReclaimItems = reclaimItems
	cachedReclaimValue = reclaimValue
	isCacheValid = true
	return best
end

--[[
    Totals for the tooltip's Clutter Report: slots freed, item quantity, and total
    value. FindItemToDelete populates these as a side effect of its scan, so
    callers must have called it first this cache cycle (the tooltip does, just
    above where it reads this).
]]
function ns:GetReclaimSummary()
	return cachedReclaimSlots or 0, cachedReclaimItems or 0, cachedReclaimValue or 0
end

--------------------------------------------------------------------------------
-- Deletion
--------------------------------------------------------------------------------

--[[
    Safety Guard. Maps each delete reason to its opt-in confirmation toggle. When
    the guard is on and the matching per-reason toggle is set, erasing that item
    pops a confirmation first. "White vendor-quality" maps to the curated
    equipment reason; the four reasons GetItemDeleteReason returns line up 1:1
    with the four toggles.
]]
local SAFETY_REASON_KEYS = {
	quest = "safetyQuest",
	consumable = "safetyConsumable",
	equipment = "safetyWhite",
	gray = "safetyGray",
}

function ns:NeedsSafetyConfirm(item)
	if not (item and ns.db and ns.db.global.safetyEnabled) then
		return false
	end
	local key = SAFETY_REASON_KEYS[item.deleteReason]
	return (key and ns.db.global[key]) and true or false
end

--[[
    Confirmation dialog for guarded erases. The candidate is passed as the
    dialog's data so each showing acts on the exact item the player saw, and
    PerformErase re-validates the slot before deleting. preferredIndex = 3 avoids
    tainting the shared dialog stack.
]]
StaticPopupDialogs["MAGICERASER_CONFIRM_ERASE"] = {
	text = L["CONFIRM_ERASE"],
	button1 = YES,
	button2 = NO,
	OnAccept = function(_, data)
		if data then
			ns:PerformErase(data)
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	showAlert = true,
	preferredIndex = 3,
}

--[[
    Actually erase the item: pick it up and delete it from the cursor. The
    cursor's item id is re-checked against the candidate so a slot that shifted
    (e.g. while a confirmation was open) aborts instead of deleting the wrong
    thing. Re-guards combat because a safety confirmation can span the moment
    combat begins.
]]
function ns:PerformErase(item)
	if InCombatLockdown() then
		self:PrintMessage(L["COMBAT_LOCKOUT"])
		return
	end

	if CursorHasItem() then
		ClearCursor()
	end
	PickupContainerItem(item.bag, item.slot)

	local cursorType, cursorItemId = GetCursorInfo()
	if cursorType == "item" and cursorItemId == item.itemId then
		DeleteCursorItem()
		PlaySound(5156)

		local stackString = (item.count > 1) and format(" x%d", item.count) or ""

		local valueString
		if item.deleteReason == "quest" then
			valueString = L["ERASED_QUEST_SUFFIX"]
		elseif item.value > 0 then
			valueString = format(L["ERASED_VALUE_SUFFIX"], ns:FormatCurrency(item.value))
		else
			valueString = ""
		end

		self:PrintMessage(format(L["ERASED_ITEM"], item.link, stackString, valueString))

		ns:InvalidateCache()
		C_Timer.After(0.2, function()
			ns:RefreshDisplay()
		end)
		return
	else
		self:PrintMessage(L["CURSOR_TOO_FAST"])
		ClearCursor()
	end

	ns:RefreshDisplay()
end

function ns:RunEraser()
	if InCombatLockdown() then
		self:PrintMessage(L["COMBAT_LOCKOUT"])
		return
	end

	local item = self:FindItemToDelete()

	if not item then
		self:PrintMessage(L["BAGS_CLEAN_SHORT"] .. " " .. L["BAGS_CLEAN_HINT"])
		ns:RefreshDisplay()
		return
	end

	if ns:NeedsSafetyConfirm(item) then
		local stackString = (item.count > 1) and format(" x%d", item.count) or ""
		StaticPopup_Show("MAGICERASER_CONFIRM_ERASE", item.link, stackString, item)
	else
		ns:PerformErase(item)
	end
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

--[[
    The add-on's complete event surface and the single source the dispatcher
    registers from -- add an event here and it is registered, dispatched, and
    covered by the Diagnostic Tools panel automatically, with no second list to
    keep in sync. Feature files own their handlers (Auto-Vend.lua defines
    ns:OnMerchantShow / ns:OnMerchantClosed); the dispatcher routes each event to
    its handler so every event passes through one point, which is what makes the
    diagnostics event log complete.
]]
ns.EVENT_NAMES = {
	"PLAYER_LOGIN",
	"PLAYER_LEVEL_UP",
	"BAG_UPDATE_DELAYED",
	"QUEST_TURNED_IN",
	"MERCHANT_SHOW",
	"MERCHANT_CLOSED",
	"MAIL_CLOSED",
	"PLAYER_REGEN_ENABLED",
}

local EVENT_HANDLERS = {
	PLAYER_LOGIN = "OnPlayerLogin",
	PLAYER_LEVEL_UP = "OnPlayerLevelUp",
	BAG_UPDATE_DELAYED = "OnBagUpdateDelayed",
	QUEST_TURNED_IN = "OnQuestTurnedIn",
	MERCHANT_SHOW = "OnMerchantShow",
	MERCHANT_CLOSED = "OnMerchantClosed",
	MAIL_CLOSED = "OnMailClosed",
	PLAYER_REGEN_ENABLED = "OnCombatEnded",
}

local updatePending = false

--[[
    Free-slot count at the last bag-space warning, so we don't reprint the same
    number twice in a row. BAG_UPDATE_DELAYED can fire more than once for a single
    purchase, and the 0.1s debounce only coalesces ones close together; this keeps
    the countdown to one line per slot lost. Reset when free climbs back above the
    threshold so re-entering the warning zone warns again. Runtime-only.

    Primed to the current free count at login (see OnPlayerLogin): the client
    fires a BAG_UPDATE_DELAYED burst as it populates bags on load, and we don't
    want that to warn about bag space you arrived with -- only about slots lost
    while playing. Seeding the baseline makes the login burst a no-op (free is
    unchanged from the seed) so the first real warning waits for a real change.
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
    once on close, so the warning reflects where the bags actually landed.
]]
local function IsBagWindowOpen()
	return (MerchantFrame and MerchantFrame:IsShown()) or (MailFrame and MailFrame:IsShown()) or false
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

function ns:OnPlayerLogin()
	--[[
        MIGRATION (remove after 2026-10-08): the pre-AceDB build kept two raw
        saved tables -- account-wide MagicEraserDB (showWelcome, minimap, and, on
        the oldest builds, an account-level autoVendEnabled) and per-character
        MagicEraserCharDB (autoVendEnabled, autoVendMessagesEnabled, ignoreList).
        Capture those legacy values before AceDB adopts MagicEraserDB, fold them
        into the profile once the database exists, then clear the legacy keys.
        autoVendEnabled prefers the per-character value and falls back to the old
        account-level one, folding in the previous account->character migration.
    ]]
	local legacyAccount = MagicEraserDB
	local legacyChar = MagicEraserCharDB
	local hasLegacyAccount = type(legacyAccount) == "table"
	local hasLegacyChar = type(legacyChar) == "table"

	--[[
        Read each legacy value only inside its table guard so a fresh install
        leaves every capture nil. Folding the guard into the expression (e.g.
        `hasLegacyAccount and legacyAccount.showWelcome`) would yield false, not
        nil, when no legacy table exists -- and the ~= nil checks below would then
        overwrite a correct default (true) with that false.
    ]]
	local legacyShowWelcome, legacyMinimap
	local legacyAutoVend, legacyAutoVendMessages, legacyIgnoreList
	if hasLegacyAccount then
		legacyShowWelcome = legacyAccount.showWelcome
		if type(legacyAccount.minimap) == "table" then
			legacyMinimap = legacyAccount.minimap
		end
	end
	if hasLegacyChar then
		legacyAutoVendMessages = legacyChar.autoVendMessagesEnabled
		if type(legacyChar.ignoreList) == "table" then
			legacyIgnoreList = legacyChar.ignoreList
		end
	end

	if hasLegacyChar and legacyChar.autoVendEnabled ~= nil then
		legacyAutoVend = legacyChar.autoVendEnabled
	elseif hasLegacyAccount and legacyAccount.autoVendEnabled ~= nil then
		legacyAutoVend = legacyAccount.autoVendEnabled
	end

	ns.db = LibStub("AceDB-3.0"):New("MagicEraserDB", ns.DATABASE_DEFAULTS, true)

	local global = ns.db.global
	local profile = ns.db.profile
	local charKey = ns.db.keys.char

	--[[
	    Apply the captured pre-AceDB values to their current homes: settings are
	    account-wide now, so they go to global; the minimap seed goes to
	    global.minimap; the per-character ignore list is folded in by the
	    per-toon seeding below.
	]]
	if legacyShowWelcome ~= nil then
		global.showWelcome = legacyShowWelcome
	end
	if legacyAutoVend ~= nil then
		global.autoVendEnabled = legacyAutoVend
	end
	if legacyAutoVendMessages ~= nil then
		global.autoVendMessagesEnabled = legacyAutoVendMessages
	end
	if legacyMinimap then
		for key, value in pairs(legacyMinimap) do
			global.minimap[key] = value
		end
	end

	-- Clear the pre-AceDB keys now that their values live in global.
	MagicEraserDB.showWelcome = nil
	MagicEraserDB.minimap = nil
	MagicEraserDB.autoVendEnabled = nil
	MagicEraserCharDB = nil

	--[[
	    MIGRATION (remove after 2026-10-11): the first AceDB build kept every
	    setting on one shared "Default" profile. They are account-wide now, so
	    move any a user actually changed up to global. These keys are no longer in
	    the profile defaults, so a non-nil raw read means the user set it; clear it
	    after. Idempotent across toons -- the first toon moves the shared value,
	    later toons find it already gone.
	]]
	local rehomeKeys = {
		"showWelcome",
		"tooltipWarningEnabled",
		"autoVendEnabled",
		"autoVendMessagesEnabled",
		"autoVendSummaryEnabled",
		"bagsFullNudgeEnabled",
		"bagsFullThreshold",
		"safetyEnabled",
		"safetyQuest",
		"safetyConsumable",
		"safetyWhite",
		"safetyGray",
	}
	for _, key in ipairs(rehomeKeys) do
		if profile[key] ~= nil then
			global[key] = profile[key]
			profile[key] = nil
		end
	end

	if type(profile.ignoreLists) ~= "table" then
		profile.ignoreLists = {}
	end

	--[[
	    ONE-TIME RESET (remove after 2026-10-11): the first AceDB builds put every
	    toon on one shared "Default" profile, merging all their ignore lists into a
	    single flat profile.ignoreList. That pollution can't be unmerged, so the
	    mere presence of that flat list marks an affected profile -- zero every
	    per-character bucket in it (including any that an earlier build already
	    seeded from the shared pool) and delete the flat list. Self-disabling once
	    the flat list is gone, and scoped to the one profile that carried it. A
	    pre-AceDB install never had a flat list, so it skips this entirely.
	]]
	if type(profile.ignoreList) == "table" then
		wipe(profile.ignoreLists)
		profile.ignoreList = nil
	end

	--[[
	    MIGRATION (remove after 2026-10-11): seed this toon's bucket once, from its
	    OWN pre-AceDB per-character list (MagicEraserCharDB) only -- one character's
	    data, never the shared pool. A toon with no legacy list starts empty.
	]]
	if profile.ignoreLists[charKey] == nil then
		local seeded = {}
		if legacyIgnoreList then
			for itemId in pairs(legacyIgnoreList) do
				seeded[itemId] = true
			end
		end
		profile.ignoreLists[charKey] = seeded
	end

	--[[
	    MIGRATION (remove after 2026-10-11): the Verbose/Summary rollout forces
	    Auto-Vend messages on once for everyone -- including users who had turned
	    them off under the old per-item behavior. The marker has no default entry,
	    so AceDB never strips it and the reset cannot re-fire. Messages are
	    account-wide now, so both the marker and the target live in global.
	]]
	if not global.autoVendSummaryMigrated then
		global.autoVendSummaryMigrated = true
		global.autoVendMessagesEnabled = true
	end

	--[[
	    CLEANUP (remove after 2026-10-11): the removed Delete Macro feature left an
	    account-wide "- Eraser" macro on anyone who had enabled it. Delete that
	    stray once so no broken macro lingers. Guarded on combat (DeleteMacro is
	    protected) and marked done only after a real pass, so login-in-combat
	    retries next time; the marker keeps it to a single pass so it can never
	    clobber a same-named macro a user makes later.
	]]
	if not global.deleteMacroCleanupDone and not InCombatLockdown() then
		if GetMacroIndexByName("- Eraser") > 0 then
			DeleteMacro("- Eraser")
		end
		global.deleteMacroCleanupDone = true
	end

	ns:RegisterOptionsPanels()

	--[[
	    Reset Profile (AceDBOptions) resets only the profile scope, which now holds
	    just the per-character ignore lists. Every other setting lives in global,
	    which the profile reset never touches, so the button would leave all the
	    real settings unchanged. Hook OnProfileReset to also restore the global
	    settings to their defaults, so "Reset Profile" behaves like a full reset.
	]]
	ns.db.RegisterCallback(ns, "OnProfileReset", "OnDatabaseReset")

	-- The erase candidate comes from the active profile's ignore lists, so a profile switch must re-scan immediately.
	ns.db.RegisterCallback(ns, "OnProfileChanged", "OnProfileSwitched")
	ns.db.RegisterCallback(ns, "OnProfileCopied", "OnProfileSwitched")

	local LibDBIcon = LibStub("LibDBIcon-1.0")
	if LibDBIcon and ns.LDBObject then
		LibDBIcon:Register(ADDON_NAME, ns.LDBObject, ns.db.global.minimap)
	end

	if ns.db.global.showWelcome then
		ns:PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
	end

	--[[
	    Seed the bag-space warning baseline with the free count we log in with, so
	    the login-time BAG_UPDATE_DELAYED burst is treated as "already known" and
	    does not fire a warning on load -- only a slot lost while playing does.
	]]
	lastNudgeFree = CountFreeSlots()

	ns:RefreshDisplay()

	--[[
	    Install the tooltip hooks after every other add-on has set up its own, not
	    at file load. Two reasons: (1) another add-on may install
	    TooltipDataProcessor on a client that lacks it natively (so it must exist
	    by the time we check), and (2) our secure hook must wrap the outermost
	    layer other add-ons installed, or a heavier tooltip add-on's
	    post-processing rebuilds the tooltip after us and clears our line.
	    PLAYER_LOGIN fires once all add-ons are loaded; the extra C_Timer.After(0)
	    lets every add-on's own PLAYER_LOGIN setup finish first.
	]]
	C_Timer.After(0, ns.SetupTooltipHooks)
end

--[[
    Restore the account-wide (global) settings to their DATABASE_DEFAULTS values.
    Fired from the AceDB OnProfileReset callback so the Reset Profile button
    resets the whole add-on, not just the ignore lists. Scalar settings are set
    back to their defaults; the minimap button is re-enabled (its default) but
    left where it is, since its saved position is not a "setting" a reset should
    move. Refreshes the display and repaints the options panel afterward.
]]
function ns:OnDatabaseReset()
	local defaults = ns.DATABASE_DEFAULTS.global
	local global = ns.db.global

	for key, value in pairs(defaults) do
		if type(value) ~= "table" then
			global[key] = value
		end
	end

	if type(global.minimap) == "table" then
		global.minimap.hide = nil
	end
	local LibDBIcon = LibStub("LibDBIcon-1.0")
	if LibDBIcon then
		LibDBIcon:Show(ADDON_NAME)
	end

	ns:RefreshDisplay()

	local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.General)
end

function ns:OnProfileSwitched()
	ns:RefreshDisplay()
end

--[[
    Consumable eligibility is gated on the player's level
    (playerLevel - requiredLevel >= 10 in GetItemDeleteReason), so leveling up
    can newly qualify outgrown food. Re-scan on level-up so the candidate
    reflects the new level immediately instead of waiting for the next bag
    update or quest turn-in to happen to fire.
]]
function ns:OnPlayerLevelUp()
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

function ns:OnBagUpdateDelayed()
	if not updatePending then
		updatePending = true
		C_Timer.After(0.1, function()
			ns:InvalidateCache()
			ns:RefreshDisplay()
			updatePending = false

			--[[
                Bag-space warning counts down (4, 3, 2, 1...) as the bags fill,
                but only when no merchant or mailbox window is open -- see
                CheckBagsFullNudge and OnMerchantClosed/OnMailClosed, which
                defer the check to when the window closes.
            ]]
			if not IsBagWindowOpen() then
				ns:CheckBagsFullNudge()
			end
		end)
	end
end

--[[
    Closing the mailbox is the counterpart to the merchant-close nudge in
    Auto-Vend's OnMerchantClosed: bag-space warnings are held while the window is
    open (see OnBagUpdateDelayed), so re-check once it closes to warn if looting
    mail left the bags at or below the threshold.
]]
function ns:OnMailClosed()
	ns:CheckBagsFullNudge()
end

function ns:OnQuestTurnedIn(questId)
	C_Timer.After(1.0, function()
		local questItemDatabase = ns.AllowedDeleteQuestItems or {}
		local alertedItems = {}

		for bag = 0, 4 do
			local slotCount = GetContainerNumSlots(bag) or 0
			for slot = 1, slotCount do
				local itemInfo = GetContainerItemInfo(bag, slot)
				if itemInfo then
					local itemId = itemInfo.itemID

					if questItemDatabase[itemId] and not alertedItems[itemId] then
						for _, trackedQuestId in ipairs(questItemDatabase[itemId]) do
							if trackedQuestId == questId then
								ns:PrintMessage(format(L["QUEST_ITEM_READY"], itemInfo.hyperlink))
								alertedItems[itemId] = true
								break
							end
						end
					end
				end
			end
		end

		ns:InvalidateCache()
		ns:RefreshDisplay()
	end)
end

--[[
    Central dispatcher. Every registered event routes through here: it taps the
    diagnostics event log first (a single boolean check when logging is off, so
    it costs nothing) and then calls the event's handler, resolved by name at
    fire time so feature files loaded after Core can supply their own.
]]
local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if ns.diagnostics and ns.diagnostics.logging then
		ns:LogEvent(event, ...)
	end

	local handlerName = EVENT_HANDLERS[event]
	local handler = handlerName and ns[handlerName]
	if handler then
		handler(ns, ...)
	end
end)

for _, event in ipairs(ns.EVENT_NAMES) do
	eventFrame:RegisterEvent(event)
end
