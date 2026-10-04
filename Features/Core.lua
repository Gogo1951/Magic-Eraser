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
	local version = C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version")
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
	"DELETE_ITEM_CONFIRM",
	"MERCHANT_SHOW",
	"MERCHANT_CLOSED",
	"MAIL_CLOSED",
	"BANKFRAME_OPENED",
	"BANKFRAME_CLOSED",
	"PLAYER_REGEN_ENABLED",
	"UPDATE_BINDINGS",
}

local EVENT_HANDLERS = {
	PLAYER_LOGIN = "OnPlayerLogin",
	PLAYER_ENTERING_WORLD = "OnPlayerEnteringWorld",
	PLAYER_LEVEL_UP = "OnPlayerLevelUp",
	BAG_UPDATE_DELAYED = "OnBagUpdateDelayed",
	QUEST_TURNED_IN = "OnQuestTurnedIn",
	DELETE_ITEM_CONFIRM = "OnDeleteItemConfirm",
	MERCHANT_SHOW = "OnMerchantShow",
	MERCHANT_CLOSED = "OnMerchantClosed",
	MAIL_CLOSED = "OnMailClosed",
	BANKFRAME_OPENED = "OnBankframeOpened",
	BANKFRAME_CLOSED = "OnBankframeClosed",
	PLAYER_REGEN_ENABLED = "OnPlayerRegenEnabled",
	UPDATE_BINDINGS = "OnUpdateBindings",
}

local updatePending = false
local refreshAfterCombat = false

function ns:PrintWelcome()
	if not ns.db.profile.showWelcome then
		return
	end
	ns:PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end

function ns:OnPlayerLogin()
	-- MIGRATION (remove after 2026-11-30)
	-- On the raw table, before AceDB picks each character's profile.
	ns:MigrateSavedVariables()

	--[[
	    The third argument puts every character on one shared Default profile,
	    so a setting changed once applies everywhere; a player who needs a
	    one-off makes a profile by hand. Each character's own lists live in
	    char, not the profile, so they stay per-character whatever profile is
	    active (see Data/Default-Settings.lua).
	]]
	ns.db = LibStub("AceDB-3.0"):New(ns.SAVED_VARIABLES_NAME, ns.DATABASE_DEFAULTS, true)

	local _, classToken = UnitClass("player")
	ns.db.char.classToken = classToken or false

	ns:RegisterOptionsPanels()

	--[[
	    A profile holds the settings, so a reset, a switch and a Copy From all
	    mean the same thing here: the rules the erase candidate is computed from
	    may have just changed, so re-scan and repaint. None of the three touches
	    the item lists, which live in char and global, outside the profile scope
	    AceDB resets.
	]]
	for _, message in ipairs({ "OnProfileChanged", "OnProfileReset", "OnProfileCopied" }) do
		ns.db.RegisterCallback(ns, message, "ApplyProfile")
	end

	local LibDBIcon = LibStub("LibDBIcon-1.0")
	if ns.LDBObject then
		LibDBIcon:Register(ADDON_NAME, ns.LDBObject, ns.db.global.minimap)

		if ns.FLAVOR == "Camelot" or ns.FLAVOR == "Mainline" then
			LibDBIcon:SetButtonIcon(ADDON_NAME, nil, 20, "CENTER", 1, -0.35)
			local button = LibDBIcon:GetMinimapButton(ADDON_NAME)
			if button then
				local mask = button:CreateMaskTexture()
				mask:SetTexture(130924, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE") -- Interface\CharacterFrame\TempPortraitAlphaMask
				mask:SetAllPoints(button.icon)
				button.icon:AddMaskTexture(mask)
			end
		end
	end

	ns:PrintWelcome()

	--[[
	    Put another class's reagents on this character's Erase List, once, the
	    first time it plays. Ahead of the RefreshDisplay below so the first scan
	    of the session already accounts for them; the seed itself only drops the
	    cache and leaves the repaint to us. See ns:SeedEraseList.
	]]
	ns:SeedEraseList()

	--[[
	    Seed the bag-space warning baseline with the free count we log in with, so
	    the login-time BAG_UPDATE_DELAYED burst is treated as "already known" and
	    does not fire a warning on load -- only a slot lost while playing does.
	]]
	ns:SeedBagSpaceBaseline()

	--[[
	    Same reasoning for quest starters: everything already in the bags at
	    login counts as known, so the login BAG_UPDATE_DELAYED burst cannot
	    dump an alert for every one of them into chat on every load.
	]]
	ns:SeedQuestStarterAlerts()

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
    Every registered panel is repainted, so whatever is open redraws against the
    new profile's settings. The Erase List seed isn't involved: its marker lives
    in char with the list, so a profile change never re-seeds.
]]
function ns:ApplyProfile()
	ns:InvalidateCache()
	ns:RefreshDisplay()
	for _, registryName in pairs(ns.OPTIONS_REGISTRY) do
		AceConfigRegistry:NotifyChange(registryName)
	end
end

--[[
    Consumable and ammo eligibility is gated on the player's level (see
    GetConsumableEraseLevel and GetAmmoEraseLevel in Junk-Rules.lua), so leveling
    up can newly qualify outgrown food or ammo. Re-scan on level-up so the candidate reflects the new level
    immediately instead of waiting for the next bag update or quest turn-in to
    happen to fire.
]]
function ns:OnPlayerLevelUp()
	ns:InvalidateCache()
	ns:RefreshDisplay()
end

--[[
    The debounced half of BAG_UPDATE_DELAYED. Nothing can be erased in combat,
    so there the two full bag walks, the mini-map repaint and the quest-starter
    check, wait for PLAYER_REGEN_ENABLED; dropping the cache is enough meanwhile,
    because hovering the mini-map button rescans on demand.
]]
local function ProcessBagUpdate()
	updatePending = false
	ns:InvalidateCache()

	if InCombatLockdown() then
		refreshAfterCombat = true
	else
		ns:RefreshDisplay()
		ns:CheckQuestStarters()
	end

	--[[
	    Bag-space warning counts down (4, 3, 2, 1...) as the bags fill, but only
	    when no merchant, mailbox or bank window is open -- see
	    CheckBagsFullNudge and OnMerchantClosed/OnMailClosed/OnBankframeClosed,
	    which defer the check to when the window closes.
	]]
	if not ns:IsBagWindowOpen() then
		ns:CheckBagsFullNudge()
	end
end

function ns:OnBagUpdateDelayed()
	if not updatePending then
		updatePending = true
		C_Timer.After(0.1, ProcessBagUpdate)
	end
end

--[[
    PLAYER_REGEN_ENABLED. Replays the bag walks a fight held back, then lets
    Auto-Vend resume a merchant pass that combat deferred.
]]
function ns:OnPlayerRegenEnabled()
	if refreshAfterCombat then
		refreshAfterCombat = false
		ns:RefreshDisplay()
		ns:CheckQuestStarters()
	end
	ns:ResumeDeferredVend()
end

--[[
    UPDATE_BINDINGS. The root panel shows each binding's key or Not Bound, and
    the player changes them in the game's own Key Bindings list, so repaint the
    panel when they come back from it.
]]
function ns:OnUpdateBindings()
	AceConfigRegistry:NotifyChange(ns.OPTIONS_REGISTRY.General)
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
