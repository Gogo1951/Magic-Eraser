local _, ns = ...
local L = ns.L

local GetContainerItemInfo = C_Container.GetContainerItemInfo
local GetItemInfoInstant = C_Item.GetItemInfoInstant
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local min = math.min

--------------------------------------------------------------------------------
-- Tint Junk
--------------------------------------------------------------------------------

--[[
    Lays a colored square over every bag button holding junk the eraser would
    take, so the player can see it at a glance. The verdict is ns:IsJunkSlot,
    which reads the very scan the mini-map button uses, so the value cap and
    the Protect List are honored without a second set of rules. Purely visual:
    nothing here touches an item.

    Each bag window draws its own buttons, so each gets an adapter (TINT_ADAPTERS
    below) that hooks the moment it draws one and hands the button, the bag and
    slot it shows, and the item it shows to PaintButton. Carried bags are
    tinted by the eraser's own verdict, and the bank, only while it is open, by
    Bank Retrieval's (ns:IsBankJunk), since that is what comes out of it. A
    window showing another character or a bank it remembers is passed over.

    Bag windows redraw a button only when its slot changes, so a change that
    moves no item -- an Erase List edit, a level-up, a new tint color -- would
    otherwise leave the tints behind. Every button painted is remembered with
    the slot and item it showed, and ns:RefreshTints repaints them all from
    ns:RefreshDisplay and from the options. A remembered item that has since
    left its slot clears the tint until the window redraws that button.
]]
local paintedButtons = setmetatable({}, { __mode = "k" })

--[[
    Set from BANKFRAME_OPENED and BANKFRAME_CLOSED rather than read off
    BankFrame, which a bag add-on such as Baganator keeps hidden while its own
    bank window is open.
]]
local isBankOpen = false

local function IsTintOn()
	return ns.db and ns.db.profile.tintJunkEnabled
end

local function IsTintableBag(bag)
	return ns.IS_CARRIED_BAG[bag] or (isBankOpen and ns.IS_BANK_BAG[bag])
end

local function IsJunk(bag, slot, itemId, link)
	if ns.IS_CARRIED_BAG[bag] then
		return ns:IsJunkSlot(bag, slot, itemId)
	end
	return link and (ns:IsBankJunk(itemId, link))
end

local function FindIcon(button)
	local name = button:GetName()
	return button.icon or button.Icon or button.IconTexture or (name and _G[name .. "IconTexture"])
end

--[[
    One sublevel above the icon, in the icon's own layer, so the tint covers the
    picture but stays under the stack count and the quality border the bag
    window draws in the layers above it.
]]
local function CreateTint(button)
	local icon = FindIcon(button)
	local layer, subLevel = "BORDER", 0
	if icon and icon.GetDrawLayer then
		layer, subLevel = icon:GetDrawLayer()
	end
	local tint = button:CreateTexture(nil, layer, nil, min((subLevel or 0) + 1, 7))
	tint:SetAllPoints(icon or button)
	tint:Hide()
	return tint
end

--[[
    Tints or clears one button. shownItemId is the item the bag window says the
    button shows, when it says; a window drawing something other than the live
    slot (a stale frame, another character) then fails the match and gets no
    tint. A nil bag clears the button outright.
]]
local function PaintButton(button, bag, slot, shownItemId)
	local record = paintedButtons[button]
	if not record then
		record = {}
		paintedButtons[button] = record
	end

	local itemId, link
	if bag and slot and IsTintableBag(bag) then
		local info = GetContainerItemInfo(bag, slot)
		itemId, link = info and info.itemID, info and info.hyperlink
		if shownItemId and shownItemId ~= itemId then
			itemId = nil
		end
	end
	record.bag, record.slot, record.itemId = bag, slot, itemId

	if itemId and IsTintOn() and IsJunk(bag, slot, itemId, link) then
		if not record.tint then
			record.tint = CreateTint(button)
		end
		local color = ns.db.profile.tintColor
		record.tint:SetColorTexture(color.r, color.g, color.b, color.a)
		record.tint:Show()
	elseif record.tint then
		record.tint:Hide()
	end
end

local function ClearButton(button)
	PaintButton(button, nil, nil)
end

local function ItemIdFromLink(link)
	return link and GetItemInfoInstant(link) or nil
end

--------------------------------------------------------------------------------
-- Default Bags
--------------------------------------------------------------------------------

--[[
    Classic Era and TBC Anniversary redraw a bag through the global
    ContainerFrame_Update, its buttons named after the frame. WoW Forever's
    Mainline-style bags redraw through each frame's own UpdateItems instead,
    the combined backpack included, and hand their buttons out through
    EnumerateValidItems. Whichever the client has is hooked; a client with
    both would only paint twice.

    The bank's own slots are drawn apart from those, its bank bags opening in
    the same container frames. Classic Era and TBC Anniversary draw the slots
    through the global BankFrameItemButton_Update, which also draws the bank
    bag buttons, flagged isBag. WoW Forever's bank panel draws each pooled
    button through its mixin's Refresh, copied onto a button when the pool
    makes it; the pool makes none before the bank first opens, after this hook.
]]
local function PaintClassicContainer(frame)
	local bag, name = frame:GetID(), frame:GetName()
	for index = 1, frame.size or 0 do
		local button = _G[name .. "Item" .. index]
		if button then
			PaintButton(button, bag, button:GetID())
		end
	end
end

local function PaintModernContainer(frame)
	for _, button in frame:EnumerateValidItems() do
		PaintButton(button, button:GetBagID(), button:GetID())
	end
end

local function PaintClassicBankButton(button)
	if not button.isBag then
		PaintButton(button, button:GetParent():GetID(), button:GetID())
	end
end

local function PaintModernBankButton(button)
	PaintButton(button, button:GetBankTabID(), button:GetContainerSlotID())
end

local function InstallDefaultBags()
	local isHooked = false

	if type(ContainerFrame_Update) == "function" then
		hooksecurefunc("ContainerFrame_Update", PaintClassicContainer)
		isHooked = true
	end

	if type(BankFrameItemButton_Update) == "function" then
		hooksecurefunc("BankFrameItemButton_Update", PaintClassicBankButton)
		isHooked = true
	end

	local bankButtonMixin = CamelotBankPanelItemButtonMixin
	if type(bankButtonMixin) == "table" and type(bankButtonMixin.Refresh) == "function" then
		hooksecurefunc(bankButtonMixin, "Refresh", PaintModernBankButton)
		isHooked = true
	end

	local frames = { ContainerFrameCombinedBags }
	for index = 1, NUM_CONTAINER_FRAMES or 0 do
		frames[#frames + 1] = _G["ContainerFrame" .. index]
	end
	for _, frame in pairs(frames) do
		if type(frame.UpdateItems) == "function" and type(frame.EnumerateValidItems) == "function" then
			hooksecurefunc(frame, "UpdateItems", PaintModernContainer)
			isHooked = true
		end
	end

	return isHooked
end

--------------------------------------------------------------------------------
-- Baganator
--------------------------------------------------------------------------------

--[[
    Baganator's own plugin route: a corner widget, which Baganator builds once
    per button (onInit) and asks about on every redraw (onUpdate), handing over
    the item and, for the live bags and open bank only, its itemLocation. The widget itself
    is an invisible marker that never claims its corner (onUpdate returns
    false), so the item-level and other corner icons draw as before; the tint
    sits on the button. It goes first in the top-left corner so a corner icon
    shown ahead of it can't stop it being asked. A player who drops it from
    Baganator's corner settings turns the tint off in Baganator.

    Baganator hides every widget before it redraws a button, so the marker's
    OnHide clears the tint and the onUpdate that follows puts it back. Hidden
    along with the closed bag window doesn't count: the marker is still shown
    in its own right then.
]]
local BAGANATOR_WIDGET_ID = "magic_eraser_tint_junk"

local baganatorButtons = setmetatable({}, { __mode = "k" })

local function OnBaganatorMarkerHide(marker)
	if not marker:IsShown() then
		ClearButton(baganatorButtons[marker])
	end
end

local function InitBaganatorMarker(itemButton)
	local marker = CreateFrame("Frame", nil, itemButton)
	marker:SetSize(1, 1)
	marker:SetScript("OnHide", OnBaganatorMarkerHide)
	baganatorButtons[marker] = itemButton
	return marker
end

local function UpdateBaganatorMarker(marker, details)
	local location = details and details.itemLocation
	if location then
		PaintButton(baganatorButtons[marker], location.bagID, location.slotIndex, details.itemID)
		marker:Show()
	end
	return false
end

local function InstallBaganator()
	local api = Baganator and Baganator.API
	if
		not (api and type(api.RegisterCornerWidget) == "function" and type(api.RequestItemButtonsRefresh) == "function")
	then
		return false
	end
	api.RegisterCornerWidget(
		L["TINT_BAGANATOR_WIDGET_LABEL"],
		BAGANATOR_WIDGET_ID,
		UpdateBaganatorMarker,
		InitBaganatorMarker,
		{ corner = "top_left", priority = 1 },
		true
	)
	return true
end

--[[
    Baganator re-lays out a moved stack on the button it already had without
    asking the widgets again, so the remembered slots can't follow it; asking
    for a widget refresh can. That refresh rebuilds every button Baganator
    shows, so it is asked for only after the bags change (ns:RedrawTintWindows).
]]
local function RefreshBaganator()
	local reasons = Baganator.Constants and Baganator.Constants.RefreshReason
	Baganator.API.RequestItemButtonsRefresh(reasons and { reasons.ItemWidgets } or nil)
end

--------------------------------------------------------------------------------
-- Bagnon
--------------------------------------------------------------------------------

--[[
    Bagnon and Bagnonium each carry their own copy of the shared BagBrother
    core under a global named after the add-on, so each is hooked on its own.
    Item.Update draws every bag and bank button: the container buttons reach it
    through a Super call that looks it up on the class at call time, so a hook
    on the class covers buttons that already exist. IsCached is true for
    another character's bags and for a bank the window only remembers. The
    guild bank and void storage buttons inherit the same Update, and a guild
    button's GetBag answers its tab number, which would pass for a carried bag,
    so both windows are turned away by their id.
]]
local BAGNON_OTHER_WINDOWS = { guild = true, vault = true }

local function PaintBagnonItem(button)
	local window = button.frame
	if (window and BAGNON_OTHER_WINDOWS[window.id]) or (button.IsCached and button:IsCached()) then
		ClearButton(button)
		return
	end
	local info = button.info
	PaintButton(button, button:GetBag(), button:GetID(), info and info.itemID)
end

local function InstallBagnon(folder)
	local addon = _G[folder]
	local item = type(addon) == "table" and addon.Item
	if not (item and type(item.Update) == "function") then
		return false
	end
	hooksecurefunc(item, "Update", PaintBagnonItem)
	return true
end

--------------------------------------------------------------------------------
-- AdiBags and BetterBags
--------------------------------------------------------------------------------

--[[
    Both are AceAddon add-ons with no dependable global, so they are reached
    through the AceAddon-3.0 each one loads for itself, asked silently so a
    missing piece answers nil rather than erroring.
]]
local function GetAceAddon(name)
	local aceAddon = LibStub("AceAddon-3.0", true)
	return aceAddon and aceAddon:GetAddon(name, true)
end

--[[
    AdiBags draws every button through its ItemButton class's Update, which
    each button finds through its metatable, so a hook on the prototype covers
    buttons that already exist; the bank buttons' subclass inherits it. A
    virtual stack draws one of its slots on a real button, and every slot in
    it holds the same item. AdiBags only ever shows live bags and the open bank.
]]
local function PaintAdiBagsButton(button)
	PaintButton(button, button.bag, button.slot, button.itemId)
end

local function InstallAdiBags()
	local addon = GetAceAddon("AdiBags")
	local class = addon and addon.GetClass and addon:GetClass("ItemButton")
	local prototype = class and class.prototype
	if not (prototype and type(prototype.Update) == "function") then
		return false
	end
	hooksecurefunc(prototype, "Update", PaintAdiBagsButton)
	return true
end

--[[
    BetterBags draws each item on a decoration button (icon, count, border)
    under a separate button that takes the clicks, so the tint goes on the
    decoration, which is where the icon is. Its own Events module says when an
    item is drawn and when its button is let go. A redraw that changes nothing
    and an emptied slot send no message; the remembered slot covers both. It
    has no view of another character, and its free-slot buttons sit in a
    virtual bag that is neither carried nor bank, so it is never tinted.
]]
local function PaintBetterBagsItem(_, item, decoration)
	local data = item and item.currentData
	if not (decoration and data) or data.isItemEmpty then
		if decoration then
			ClearButton(decoration)
		end
		return
	end
	local itemInfo = data.itemInfo
	PaintButton(decoration, data.bagid, data.slotid, itemInfo and itemInfo.itemID)
end

local function ClearBetterBagsItem(_, _, decoration)
	if decoration then
		ClearButton(decoration)
	end
end

local function InstallBetterBags()
	local addon = GetAceAddon("BetterBags")
	local events = addon and addon.GetModule and addon:GetModule("Events", true)
	if not (events and type(events.RegisterMessage) == "function") then
		return false
	end
	events:RegisterMessage("item/Updated", PaintBetterBagsItem)
	events:RegisterMessage("item/Clearing", ClearBetterBagsItem)
	return true
end

--------------------------------------------------------------------------------
-- ArkInventory
--------------------------------------------------------------------------------

--[[
    ArkInventory.API.ItemFrameUpdated is an empty function ArkInventory calls
    after drawing any item button, there for other add-ons to hook. Its ids are
    ArkInventory's own window ids, so the Blizzard bag comes off the button.
    The offline check covers another character and a remembered bank.
]]
local function PaintArkInventoryItem(frame, locationId)
	local api = ArkInventory.API
	local data = frame.ARK_Data
	if not data or api.LocationIsOffline(locationId) then
		ClearButton(frame)
		return
	end
	local item = api.ItemFrameItemTableGet(frame)
	PaintButton(frame, data.blizzard_id, data.slot_id, ItemIdFromLink(item and item.h))
end

local function InstallArkInventory()
	local api = ArkInventory and ArkInventory.API
	if
		not (
			api
			and type(api.ItemFrameUpdated) == "function"
			and type(api.LocationIsOffline) == "function"
			and type(api.ItemFrameItemTableGet) == "function"
		)
	then
		return false
	end
	hooksecurefunc(api, "ItemFrameUpdated", PaintArkInventoryItem)
	return true
end

--------------------------------------------------------------------------------
-- ElvUI
--------------------------------------------------------------------------------

--[[
    ElvUI's Bags module draws every slot through B:UpdateSlot, called on the
    module table, with real Blizzard bag ids. It has no offline view, and its
    bank frame only ever shows the open bank. Skipped when the player has
    ElvUI's bags turned off, since the default bags are then the ones on screen.
]]
local function PaintElvUISlot(_, frame, bag, slot)
	local bagSlots = frame and frame.Bags and frame.Bags[bag]
	local button = bagSlots and bagSlots[slot]
	if button then
		PaintButton(button, bag, slot, button.itemID)
	end
end

local function InstallElvUI()
	local engine = ElvUI and ElvUI[1]
	local bags = engine and engine.Bags
	if not (bags and bags.Initialized and type(bags.UpdateSlot) == "function") then
		return false
	end
	hooksecurefunc(bags, "UpdateSlot", PaintElvUISlot)
	return true
end

--------------------------------------------------------------------------------
-- Setup and Refresh
--------------------------------------------------------------------------------

--[[
    { name, add-on folder (nil for the default bags), install, redraw }.
    install is handed the folder and returns whether it hooked anything. One
    that didn't is tried again on every later ADDON_LOADED, which catches a bag
    add-on loaded on demand; one that sets itself up during its own
    PLAYER_LOGIN is caught by the one-frame delay in ns:OnPlayerLogin. redraw,
    where present, asks that window to draw its buttons again.
]]
local TINT_ADAPTERS = {
	{ "Default Bags", nil, InstallDefaultBags },
	{ "Baganator", "Baganator", InstallBaganator, RefreshBaganator },
	{ "Bagnon", "Bagnon", InstallBagnon },
	{ "Bagnonium", "Bagnonium", InstallBagnon },
	{ "AdiBags", "AdiBags", InstallAdiBags },
	{ "BetterBags", "BetterBags", InstallBetterBags },
	{ "ArkInventory", "ArkInventory", InstallArkInventory },
	{ "ElvUI", "ElvUI", InstallElvUI },
}

local installedAdapters = {}

function ns.SetupTintHooks()
	for _, adapter in ipairs(TINT_ADAPTERS) do
		local name, folder, install = adapter[1], adapter[2], adapter[3]
		if not installedAdapters[name] and (not folder or IsAddOnLoaded(folder)) and install(folder) then
			installedAdapters[name] = adapter
		end
	end
end

-- The installed adapters by name, for the Diagnostic Tools Eraser Context.
function ns:GetTintAdapterNames()
	local names = {}
	for _, adapter in ipairs(TINT_ADAPTERS) do
		if installedAdapters[adapter[1]] then
			names[#names + 1] = adapter[1]
		end
	end
	return names
end

--[[
    A bank button drawn while the bank was shut, or in the moment before
    BANKFRAME_OPENED reached this add-on, was remembered with no item, so every
    remembered bank button is repainted along with the ones that showed an item.
]]
function ns:RefreshTints()
	for button, record in pairs(paintedButtons) do
		if record.itemId or ns.IS_BANK_BAG[record.bag] then
			PaintButton(button, record.bag, record.slot, record.itemId)
		end
	end
end

-- From the bank handlers in Features/Bank-Retrieval.lua; opening or closing repaints the bank's buttons.
function ns:SetTintBankOpen(isOpen)
	isBankOpen = isOpen
	ns:RefreshTints()
end

--[[
    After the bags change, for the windows whose buttons can show a new slot
    without drawing it again. Never with the tint off: the redraw costs the bag
    window a rebuild of every button to show nothing of ours.
]]
function ns:RedrawTintWindows()
	if not IsTintOn() then
		return
	end
	for _, adapter in pairs(installedAdapters) do
		if adapter[4] then
			adapter[4]()
		end
	end
end
