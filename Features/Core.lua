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
	ns.db = LibStub("AceDB-3.0"):New("MagicEraserDB", ns.DATABASE_DEFAULTS)

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

			ns:CheckQuestStarters()

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
