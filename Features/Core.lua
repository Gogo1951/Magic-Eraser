local ADDON_NAME, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
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
	"PLAYER_ENTERING_WORLD",
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
	PLAYER_ENTERING_WORLD = "OnEnteringWorld",
	PLAYER_LEVEL_UP = "OnPlayerLevelUp",
	BAG_UPDATE_DELAYED = "OnBagUpdateDelayed",
	QUEST_TURNED_IN = "OnQuestTurnedIn",
	MERCHANT_SHOW = "OnMerchantShow",
	MERCHANT_CLOSED = "OnMerchantClosed",
	MAIL_CLOSED = "OnMailClosed",
	PLAYER_REGEN_ENABLED = "OnCombatEnded",
}

local updatePending = false

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
	ns:SeedBagSpaceBaseline()

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
			if not ns:IsBagWindowOpen() then
				ns:CheckBagsFullNudge()
			end
		end)
	end
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
