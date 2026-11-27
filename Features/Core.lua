local ADDON_NAME, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Locals
--------------------------------------------------------------------------------

local ipairs = ipairs

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
    The dispatcher and the Diagnostic Tools panel both read this list. An event
    here without an EVENT_HANDLERS row is registered and logged but never handled.
]]
ns.EVENT_NAMES = {
	"ADDON_LOADED",
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
	"PLAYERBANKSLOTS_CHANGED",
	"PLAYER_REGEN_ENABLED",
	"UPDATE_BINDINGS",
}

local EVENT_HANDLERS = {
	ADDON_LOADED = "OnAddonLoaded",
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
	PLAYERBANKSLOTS_CHANGED = "OnPlayerbankslotsChanged",
	PLAYER_REGEN_ENABLED = "OnPlayerRegenEnabled",
	UPDATE_BINDINGS = "OnUpdateBindings",
}

local updatePending = false
local refreshAfterCombat = false

-- Repair first, then Auto-Vend sells.
function ns:OnMerchantShow()
	ns:RepairAtMerchant()
	ns:VendAtMerchant()
end

function ns:PrintWelcome()
	if not ns.db.profile.showWelcome then
		return
	end
	ns:PrintMessage(L["CHAT_LOADED"]:format(ns.Version))
end

--------------------------------------------------------------------------------
-- Other-Client Characters
--------------------------------------------------------------------------------

--[[
    Characters from another game version, dropped without a word. AceDB keys
    a character "Name - Realm" on realm clients and "First Last" on the
    realm-free ones (WoW Forever), so a saved key shaped the other way from
    the one being played came from a copied WTF folder: its char section,
    its profile choice and, unless someone still uses it, its own profile go.
]]
local REALM_KEY_SEPARATOR = " - "

---@param characterKey any
---@param realmClient boolean
---@return boolean
local function IsOtherClientKey(characterKey, realmClient)
	if type(characterKey) ~= "string" then
		return true
	end
	return (characterKey:find(REALM_KEY_SEPARATOR, 1, true) ~= nil) ~= realmClient
end

---@param sv table # the saved table, or one of its namespaces
---@param realmClient boolean
---@param profilesInUse table<string, boolean>
---@return nil
local function PruneSavedTable(sv, realmClient, profilesInUse)
	local pruned = {}
	for _, section in ipairs({ "char", "profileKeys" }) do
		local characters = sv[section]
		if type(characters) == "table" then
			for characterKey in pairs(characters) do
				if IsOtherClientKey(characterKey, realmClient) then
					characters[characterKey] = nil
					pruned[characterKey] = true
				end
			end
		end
	end
	if type(sv.profiles) == "table" then
		for characterKey in pairs(pruned) do
			if not profilesInUse[characterKey] then
				sv.profiles[characterKey] = nil
			end
		end
	end
end

---@return nil
local function PruneOtherClientCharacters()
	local currentKey = ns.db.keys and ns.db.keys.char
	local sv = ns.db.sv
	if type(currentKey) ~= "string" or type(sv) ~= "table" then
		return
	end
	local realmClient = currentKey:find(REALM_KEY_SEPARATOR, 1, true) ~= nil
	local profilesInUse = { [ns.db.keys.profile or ""] = true }
	for characterKey, profileName in pairs(sv.profileKeys or {}) do
		if not IsOtherClientKey(characterKey, realmClient) then
			profilesInUse[profileName] = true
		end
	end
	PruneSavedTable(sv, realmClient, profilesInUse)
	for _, namespace in pairs(sv.namespaces or {}) do
		if type(namespace) == "table" then
			PruneSavedTable(namespace, realmClient, profilesInUse)
		end
	end
end

--------------------------------------------------------------------------------
-- Login
--------------------------------------------------------------------------------

-- MIGRATION (remove after 2026-12-14)
--[[
    Copies global.minimap into every profile, then clears it from global. Lives
    here and keys on global.minimap rather than storageVersion, so it outlives
    Migrations.lua's earlier date.
]]
local function MoveMinimapToProfiles(sv)
	local saved = sv.global.minimap
	sv.global.minimap = nil
	if type(saved) ~= "table" or next(saved) == nil then
		return
	end

	local names = { Default = true }
	for name in pairs(sv.profiles) do
		names[name] = true
	end
	for _, name in pairs(sv.profileKeys or {}) do
		if type(name) == "string" then
			names[name] = true
		end
	end

	for name in pairs(names) do
		local profile = sv.profiles[name]
		if profile == nil then
			profile = {}
			sv.profiles[name] = profile
		end
		if type(profile) == "table" and profile.minimap == nil then
			local copy = {}
			for key, value in pairs(saved) do
				copy[key] = value
			end
			profile.minimap = copy
		end
	end
end

function ns:OnPlayerLogin()
	-- MIGRATION (remove after 2026-11-30)
	-- On the raw table, before AceDB picks each character's profile.
	ns:MigrateSavedVariables()
	-- MIGRATION (remove after 2026-12-14)
	local sv = MagicEraserDB
	if type(sv) == "table" and type(sv.global) == "table" and sv.global.minimap ~= nil then
		sv.profiles = sv.profiles or {}
		MoveMinimapToProfiles(sv)
	end

	-- One shared Default profile; each character's lists live in char, outside it (README-Notes.md).
	ns.db = LibStub("AceDB-3.0"):New(ns.SAVED_VARIABLES_NAME, ns.DATABASE_DEFAULTS, true)
	PruneOtherClientCharacters()

	local _, classToken = UnitClass("player")
	ns.db.char.classToken = classToken or false

	ns:RegisterOptionsPanels()

	-- Reset, switch and Copy From all may change the rules, so all three re-scan and repaint.
	for _, message in ipairs({ "OnProfileChanged", "OnProfileReset", "OnProfileCopied" }) do
		ns.db.RegisterCallback(ns, message, "ApplyProfile")
	end

	ns:RegisterMinimapButton()

	ns:PrintWelcome()

	-- Ahead of RefreshDisplay, so the session's first scan sees the seeded rows.
	ns:SeedEraseList()

	-- Baselines, so the login BAG_UPDATE_DELAYED burst fires no warning or alert.
	ns:SeedBagSpaceBaseline()

	ns:SeedQuestStarterAlerts()

	ns:RefreshDisplay()

	-- One frame after login, so a bag add-on's own PLAYER_LOGIN setup has finished.
	C_Timer.After(0, ns.SetupTintHooks)
end

function ns:OnAddonLoaded()
	if ns.db then
		ns.SetupTintHooks()
	end
end

function ns:ApplyProfile()
	ns:InvalidateCache()
	ns:ApplyMinimapButton()
	ns:RefreshDisplay()
	ns.RefreshSettings()
end

--[[
    In combat only the tints repaint (one bag walk), so loot is marked as it
    lands; everything else waits for PLAYER_REGEN_ENABLED.
]]
local function ProcessBagUpdate()
	updatePending = false
	ns:InvalidateCache()

	if InCombatLockdown() then
		refreshAfterCombat = true
		ns:RefreshTints()
	else
		ns:RefreshDisplay()
		ns:CheckQuestStarters()
		ns:RedrawTintWindows()
	end

	-- Held while a merchant, mailbox or bank is open; each close re-checks.
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

-- A change to one of the bank's own slots, which needs the same debounced repaint for the bank tints.
function ns:OnPlayerbankslotsChanged()
	ns:OnBagUpdateDelayed()
end

function ns:RefreshWhenOutOfCombat()
	ns:InvalidateCache()
	if InCombatLockdown() then
		refreshAfterCombat = true
	else
		ns:RefreshDisplay()
	end
end

function ns:OnPlayerRegenEnabled()
	if refreshAfterCombat then
		refreshAfterCombat = false
		ns:RefreshDisplay()
		ns:CheckQuestStarters()
		ns:RedrawTintWindows()
	end
	ns:ResumeDeferredVend()
end

-- Handlers resolve by name at fire time, so feature files loaded after Core supply their own.
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
