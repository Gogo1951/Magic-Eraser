local _, ns = ...
local L = ns.L

local format = string.format
local GetItemInfoInstant = C_Item.GetItemInfoInstant

--------------------------------------------------------------------------------
-- Key Bindings
--------------------------------------------------------------------------------

--[[
    WoW's binding system reads only globals, so every binding costs two:
    Bindings.xml can only call a global function, and the Key Bindings list labels
    a binding with the BINDING_NAME_<name> global matching its name attribute.
    Bindings.xml itself is found at the add-on root by the client and is never
    listed in the TOC.

    The name attribute is also what the client saves a player's key against, so
    a shipped binding keeps its name for good: a renamed one comes back unbound
    for everyone who had set it.
]]

BINDING_NAME_MAGICERASER_ERASE = L["BINDING_ERASE"]
BINDING_NAME_MAGICERASER_ADD_TO_IGNORE_LIST = L["BINDING_ADD_TO_IGNORE_LIST"]
BINDING_NAME_MAGICERASER_ADD_TO_ERASE_LIST = L["BINDING_ADD_TO_ERASE_LIST"]

--[[
    The erase handler is the mini-map button's Left-Click on a key, so it enters
    through ns:RunEraser exactly as the click does, and every gate on the click
    holds here.
]]
function MagicEraser_Erase()
	ns:RunEraser()
end

--------------------------------------------------------------------------------
-- Opening Key Bindings
--------------------------------------------------------------------------------

--[[
    The root panel's Set Key button. The clients disagree on how the game's Key
    Bindings list is reached, so the routes are tried in order, at click time
    rather than at load, since a Settings category can register after login:

      1. Settings.KEYBINDINGS_CATEGORY_ID, where the client names it outright.
      2. The Settings panel's own category list, searched for the category
         carrying the game's Key Bindings title (KEY_BINDINGS, or
         SETTINGS_KEYBINDINGS_LABEL where that's the one in use).
      3. The older standalone KeyBindingFrame, loaded on demand.

    The lookup is protected, because it walks Blizzard's own objects and a
    client that reshapes them should cost the player a chat line, not an error.
    When nothing works, the line says where to find the list by hand. The
    Diagnostic Tools API report has a row for each route, so a bug report says
    which one the client took.
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

--[[
    The fallback line names the menus by the client's own labels, so it matches
    what the player sees in every locale. All three clients label the list
    SETTINGS_KEYBINDINGS_LABEL; KEY_BINDINGS stands in where that is missing.
]]
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

--------------------------------------------------------------------------------
-- Hovered Item
--------------------------------------------------------------------------------

--[[
    The two list bindings act on whatever item the game tooltip is showing,
    which is the item under the mouse wherever the player happens to find it:
    bags, bank, a merchant, the loot window, the character sheet. The read goes
    through ns.GetDisplayedItem in Features/Utilities.lua, which picks WoW
    Forever's TooltipUtil or the Classic GameTooltip:GetItem once at load.
]]

--[[
    The item id and link under the mouse, or nil when the tooltip on screen is
    not an item's. IsShown comes first, so a key pressed after the tooltip has
    gone can never act on the last item it showed.
]]
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
    The rules live with the lists: ns:AddToIgnoreList and ns:AddToEraseList
    decide what a press does and hand back what happened, and this file turns
    that into one complete sentence around the item's link. Every outcome
    speaks, the ones that change nothing included, so a press is never met with
    silence.

    The tooltip line catches up on its own. The client re-sets a hovered bag
    item's tooltip every TOOLTIP_UPDATE_TIME through the button's UpdateTooltip
    (ContainerFrameItemButton_OnEnter on Classic Era and TBC Anniversary,
    ContainerFrameItemButtonMixin.OnUpdate on WoW Forever), and every re-set
    runs the Item-Tooltips.lua hook again, so the new line lands while the
    player is still hovering. Nothing here forces a repaint: calling Blizzard's
    OnEnter from add-on code would taint the bag button to save a fifth of a
    second.

    Neither binding checks for combat. A list edit calls nothing protected, so
    protecting an item mid-fight works exactly as it does anywhere else.
]]
local IGNORE_LIST_MESSAGE_KEYS = {
	added = "IGNORE_LIST_ADDED",
	moved = "IGNORE_LIST_MOVED",
	already = "IGNORE_LIST_ALREADY",
}

--[[
    Protect one item on this character and say so, exactly as the binding does.
    The Your Current Bags panel's Protect button comes through here too, so a
    click and a key press print the same sentence.
]]
function ns:ProtectItemWithMessage(itemId, link)
	local outcome = ns:AddToIgnoreList(itemId)
	if outcome then
		ns:PrintMessage(format(L[IGNORE_LIST_MESSAGE_KEYS[outcome]], link))
	end
end

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
