local ADDON_NAME, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local ipairs = ipairs

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

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
	"BANKFRAME_OPENED",
	"BANKFRAME_CLOSED",
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
	BANKFRAME_OPENED = "OnBankOpened",
	BANKFRAME_CLOSED = "OnBankClosed",
	PLAYER_REGEN_ENABLED = "OnCombatEnded",
}

local updatePending = false

function ns:OnPlayerLogin()
	--[[
        MIGRATION (remove after 2026-08-15): the pre-AceDB build kept two raw
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

	ns.db = LibStub("AceDB-3.0"):New("MagicEraserDB", ns.DATABASE_DEFAULTS)

	local global = ns.db.global
	local profile = ns.db.profile
	local charKey = ns.db.keys.char

	--[[
	    Apply the captured pre-AceDB values to their current homes: settings are
	    account-wide now, so they go to global, and the minimap seed goes to
	    global.minimap. The per-character ignore list is folded in by the
	    per-character profile migration below.
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
	    MIGRATION (remove after 2026-08-15): the first AceDB build kept every
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
		"bankRetrievalEnabled",
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

	--[[
	    MIGRATION (remove after 2026-08-15): Magic Eraser moved from one shared
	    "Default" profile -- every toon's ignore list keyed by ns.db.keys.char
	    inside it -- to a real per-character AceDB profile per toon (AceDB:New above
	    now omits the shared-Default flag). Put THIS toon on its own profile with a
	    flat profile.ignoreList, then drop the obsolete keyed table. Runs once per
	    toon; a no-op afterward.

	    The first AceDB builds merged every toon's list into one flat
	    Default.ignoreList and seeded the keyed buckets from that merged pool, so
	    both are unreliable; that flat list still sitting on the old "Default" is
	    the marker to discard the keyed buckets and fall back to the pre-AceDB
	    per-toon list captured above.
	]]
	local gathered = {}
	if
		ns.db:GetCurrentProfile() == "Default"
		and type(profile.ignoreList) == "table"
		and next(profile.ignoreList) ~= nil
	then
		profile.ignoreLists = nil
		profile.ignoreList = nil
	end
	if type(profile.ignoreLists) == "table" and type(profile.ignoreLists[charKey]) == "table" then
		for itemId in pairs(profile.ignoreLists[charKey]) do
			gathered[itemId] = true
		end
		profile.ignoreLists[charKey] = nil
	end
	if legacyIgnoreList then
		for itemId in pairs(legacyIgnoreList) do
			gathered[itemId] = true
		end
	end

	if ns.db:GetCurrentProfile() ~= charKey then
		ns.db:SetProfile(charKey)
	end

	local ignoreList = ns.db.profile.ignoreList
	if type(ignoreList) ~= "table" then
		ignoreList = {}
		ns.db.profile.ignoreList = ignoreList
	end
	for itemId in pairs(gathered) do
		ignoreList[itemId] = true
	end
	ns.db.profile.ignoreLists = nil

	--[[
	    MIGRATION (remove after 2026-08-15): the Verbose/Summary rollout forces
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
	    MIGRATION (remove after 2026-08-15): the removed Delete Macro feature left an
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
	    A profile holds exactly one thing -- this character's ignore list -- so a
	    reset, a switch and a Copy From all mean the same thing here: the list the
	    erase candidate is computed from just changed, so re-scan. None of the
	    three touches the account-wide settings, which live in global, outside the
	    profile scope AceDB resets.
	]]
	for _, message in ipairs({ "OnProfileChanged", "OnProfileReset", "OnProfileCopied" }) do
		ns.db.RegisterCallback(ns, message, "OnProfileSwitched")
	end

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

function ns:OnProfileSwitched()
	ns:RefreshDisplay()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.IgnoreList)
end

--[[
    Consumable eligibility is gated on the player's level (see
    GetConsumableEraseLevel in Eraser.lua), so leveling up can newly qualify
    outgrown food. Re-scan on level-up so the candidate reflects the new level
    immediately instead of waiting for the next bag update or quest turn-in to
    happen to fire.
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
                but only when no merchant, mailbox or bank window is open -- see
                CheckBagsFullNudge and OnMerchantClosed/OnMailClosed/OnBankClosed,
                which defer the check to when the window closes.
            ]]
			if not ns:IsBagWindowOpen() then
				ns:CheckBagsFullNudge()
			end
		end)
	end
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
