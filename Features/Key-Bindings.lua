local _, ns = ...
local L = ns.L

local format = string.format
local GetItemInfoInstant = C_Item.GetItemInfoInstant

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

-- A shipped binding keeps its name for good: the client saves keys against it.

BINDING_NAME_MAGICERASER_ERASE = L["BINDING_ERASE"]
BINDING_NAME_MAGICERASER_ADD_TO_IGNORE_LIST = L["BINDING_ADD_TO_PROTECT_LIST"]
BINDING_NAME_MAGICERASER_ADD_TO_ERASE_LIST = L["BINDING_ADD_TO_ERASE_LIST"]

-- Synchronous, so the key press stays the hardware event.
function MagicEraser_Erase()
	ns:RunEraser()
end

--------------------------------------------------------------------------------
-- Opening Key Bindings
--------------------------------------------------------------------------------

--[[
    Routes tried at click time, since a Settings category can register after
    login. The search is pcall'd: a client that reshapes Blizzard's objects
    should cost a chat line, not an error.
]]
local function FindKeyBindingsCategoryID()
	if Settings and Settings.KEYBINDINGS_CATEGORY_ID then
		return Settings.KEYBINDINGS_CATEGORY_ID
	end

	if not (SettingsPanel and SettingsPanel.GetCategoryList) then
		return nil
	end

	local ok, categoryId = pcall(function()
		local list = SettingsPanel:GetCategoryList()
		local categories = list and list.GetAllCategories and list:GetAllCategories()
		for _, category in ipairs(categories or {}) do
			local name = category.GetName and category:GetName()
			if name and (name == KEY_BINDINGS or name == SETTINGS_KEYBINDINGS_LABEL) and category.GetID then
				return category:GetID()
			end
		end
		return nil
	end)

	return ok and categoryId or nil
end

-- The client's own labels, so the line matches every locale.
local KEY_BINDINGS_LABEL = SETTINGS_KEYBINDINGS_LABEL ~= nil and SETTINGS_KEYBINDINGS_LABEL or KEY_BINDINGS

function ns:OpenKeyBindings()
	if InCombatLockdown() then
		ns:PrintMessage(L["CHAT_KEY_BINDINGS_IN_COMBAT"])
		return
	end

	local categoryId = FindKeyBindingsCategoryID()
	if categoryId and Settings and Settings.OpenToCategory then
		Settings.OpenToCategory(categoryId)
		return
	end

	if not KeyBindingFrame and type(KeyBindingFrame_LoadUI) == "function" then
		KeyBindingFrame_LoadUI()
	end
	if type(KeyBindingFrame) == "table" and type(ShowUIPanel) == "function" then
		ShowUIPanel(KeyBindingFrame)
		return
	end

	ns:PrintMessage(format(L["KEY_BINDINGS_LOCATION"], GAMEMENU_OPTIONS, KEY_BINDINGS_LABEL))
end

function ns:OnUpdateBindings()
	ns.RefreshSettings()
end

--------------------------------------------------------------------------------
-- Hovered Item
--------------------------------------------------------------------------------

-- IsShown first, so a press after the tooltip is gone never acts on the last item it showed.
local function GetHoveredItem()
	if not GameTooltip:IsShown() then
		return nil
	end

	local _, link = ns.GetDisplayedItem(GameTooltip)
	local itemId = link and GetItemInfoInstant(link)
	if not itemId then
		return nil
	end

	return itemId, link
end

--------------------------------------------------------------------------------
-- List Bindings
--------------------------------------------------------------------------------

--[[
    Every outcome speaks, so a press is never met with silence. No combat
    check: a list edit calls nothing protected. Shared with the menu's Protect row.
]]
local IGNORE_LIST_MESSAGE_KEYS = {
	added = "PROTECT_LIST_ADDED",
	moved = "PROTECT_LIST_MOVED",
	already = "PROTECT_LIST_ALREADY",
}
ns.IGNORE_LIST_MESSAGE_KEYS = IGNORE_LIST_MESSAGE_KEYS

local ERASE_LIST_MESSAGE_KEYS = {
	added = "ERASE_LIST_ADDED",
	already = "ERASE_LIST_ALREADY",
	protected = "ERASE_LIST_PROTECTED",
}

local function AddHoveredItem(addToList, messageKeys)
	local itemId, link = GetHoveredItem()
	if not itemId then
		ns:PrintMessage(L["NO_HOVERED_ITEM"])
		return
	end

	-- nil only before the database exists, when there is no list to report on.
	local outcome = addToList(ns, itemId)
	if outcome then
		ns:PrintMessage(format(L[messageKeys[outcome]], link))
	end
end

function MagicEraser_AddToIgnoreList()
	AddHoveredItem(ns.AddToIgnoreList, IGNORE_LIST_MESSAGE_KEYS)
end

function MagicEraser_AddToEraseList()
	AddHoveredItem(ns.AddToEraseList, ERASE_LIST_MESSAGE_KEYS)
end
