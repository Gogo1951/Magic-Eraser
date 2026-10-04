local _, ns = ...

--------------------------------------------------------------------------------
-- Saved-Data Migrations
--------------------------------------------------------------------------------

-- MIGRATION (remove after 2026-11-30)
--[[
    Brings a MagicEraserDB saved before storage version 2 into the current
    shape. It runs on the raw saved table, from ns:OnPlayerLogin, before
    AceDB-3.0 opens it, because the profile a character lands on is decided
    the moment AceDB opens the table, and the old per-character profiles have
    to be gone by then.

    The old shape: every character had its own AceDB profile ("Name - Realm")
    holding only its two item lists and the Erase List seed marker, and every
    setting lived in global. The new shape:

      - Settings live in the profile, and every character shares Default, so a
        setting changed once applies everywhere and a new profile is a one-off.
      - Each character's own lists and seed marker live in char, AceDB's
        per-character scope, so they stay per-character whatever profile is
        active.
      - The All Characters lists and the mini-map button stay in global.

    Steps, in order:

      1. Copy each character's lists out of the profile it was on into its char
         entry. profileKeys says which profile each character used, so a
         character on a shared profile gets that profile's lists.
      2. Move every setting out of global into Default. The global value wins:
         before this, global was the only place a setting was read from, so
         it is the value the player actually had.
      3. Turn the old confirmation switch (safetyEnabled over four per-kind
         toggles) into Erase Confirmation when any kind asked. A missing
         safetyQuest means its old default, true.
      4. Clear the lists out of every profile, drop the profiles that are now
         empty, and point every character at Default.
]]
local LEGACY_SAFETY_KEYS = { "safetyQuest", "safetyConsumable", "safetyWhite", "safetyGray" }

local function CopyList(from, to)
	if type(from) ~= "table" then
		return
	end
	for itemId, value in pairs(from) do
		to[itemId] = value
	end
end

local function MoveListsToCharacters(sv)
	for charKey, profileName in pairs(sv.profileKeys or {}) do
		local profile = sv.profiles[profileName]
		if type(profile) == "table" then
			local charData = sv.char[charKey] or {}
			sv.char[charKey] = charData

			for _, listKey in ipairs({ "ignoreList", "eraseList" }) do
				if type(profile[listKey]) == "table" then
					charData[listKey] = charData[listKey] or {}
					CopyList(profile[listKey], charData[listKey])
				end
			end
			if profile.eraseListSeeded then
				charData.eraseListSeeded = true
			end
		end
	end
end

local function MoveSettingsToDefault(sv)
	local default = sv.profiles.Default or {}
	sv.profiles.Default = default

	for key in pairs(ns.DATABASE_DEFAULTS.profile) do
		if sv.global[key] ~= nil then
			default[key] = sv.global[key]
			sv.global[key] = nil
		end
	end

	local settings = sv.global
	if settings.safetyEnabled and default.eraseConfirmEnabled == nil then
		for _, key in ipairs(LEGACY_SAFETY_KEYS) do
			local asked = settings[key]
			if asked == nil then
				asked = (key == "safetyQuest")
			end
			if asked then
				default.eraseConfirmEnabled = true
				break
			end
		end
	end
	settings.safetyEnabled = nil
	for _, key in ipairs(LEGACY_SAFETY_KEYS) do
		settings[key] = nil
	end
end

local function RetireCharacterProfiles(sv)
	for _, profile in pairs(sv.profiles) do
		if type(profile) == "table" then
			profile.ignoreList = nil
			profile.eraseList = nil
			profile.eraseListSeeded = nil
		end
	end

	for profileName, profile in pairs(sv.profiles) do
		if profileName ~= "Default" and type(profile) == "table" and next(profile) == nil then
			sv.profiles[profileName] = nil
		end
	end

	for charKey, profileName in pairs(sv.profileKeys or {}) do
		if not sv.profiles[profileName] then
			sv.profileKeys[charKey] = "Default"
		end
	end
end

local function MigrateToVersion2(sv)
	MoveListsToCharacters(sv)
	MoveSettingsToDefault(sv)
	RetireCharacterProfiles(sv)
end

-- MIGRATION (remove after 2026-11-03)
--[[
    Storage version 3: the per-kind erase action ("erase", "ask" or "keep" in
    profile.eraseActions) became a junkKinds checkbox per kind plus one
    eraseConfirmEnabled switch. Every profile is converted, a player's own
    one-offs included: a kind set to Keep comes in unchecked, and any kind set
    to Ask First turns Erase Confirmation on, so nobody loses a confirmation
    they chose. AceDB stores only values that differ from the defaults, so
    eraseActions holds nothing but "ask" and "keep" rows.
]]
local function MigrateToVersion3(sv)
	for _, profile in pairs(sv.profiles or {}) do
		if type(profile) == "table" and type(profile.eraseActions) == "table" then
			for reason, action in pairs(profile.eraseActions) do
				if action == "keep" then
					profile.junkKinds = profile.junkKinds or {}
					profile.junkKinds[reason] = false
				elseif action == "ask" then
					profile.eraseConfirmEnabled = true
				end
			end
			profile.eraseActions = nil
		end
	end
end

-- MIGRATION (remove after 2026-11-30)
--[[
    storageVersion marks which steps have run. It is needed rather than
    inferred: once settings live in profiles, a player's own one-off profile
    that happens to hold only defaults is stored empty, and version 2's last
    step would otherwise send its characters back to Default on every login. A
    fresh install, with no saved table yet, is stamped current rather than
    migrated, so its second login never runs the steps either.
]]
local STORAGE_VERSION = 3

function ns:MigrateSavedVariables()
	local sv = MagicEraserDB
	if type(sv) ~= "table" then
		MagicEraserDB = { global = { storageVersion = STORAGE_VERSION } }
		return
	end
	sv.global = sv.global or {}
	local version = sv.global.storageVersion or 0
	if version >= STORAGE_VERSION then
		return
	end

	sv.profiles = sv.profiles or {}
	sv.char = sv.char or {}

	if version < 2 then
		MigrateToVersion2(sv)
	end
	-- MIGRATION (remove after 2026-11-03)
	if version < 3 then
		MigrateToVersion3(sv)
	end

	sv.global.storageVersion = STORAGE_VERSION
end
