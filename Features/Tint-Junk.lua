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
    Bag windows redraw a button only when its slot changes, so every painted
    button is remembered and ns:RefreshTints repaints them for changes that
    move no item (a list edit, a level-up, a new color).
]]
local paintedButtons = setmetatable({}, { __mode = "k" })

local function IsTintOn()
	return ns.db and ns.db.profile.tintJunkEnabled
end

local function IsTintableBag(bag)
	return ns.IS_CARRIED_BAG[bag] or (ns:IsBankOpen() and ns.IS_BANK_BAG[bag])
end

local function IsJunk(bag, slot, itemId, link)
	if ns.IS_CARRIED_BAG[bag] then
		return ns:IsJunkSlot(bag, slot, itemId)
	end
	return link and (ns:IsBankJunk(itemId, link, bag, slot))
end

local function FindIcon(button)
	local name = button:GetName()
	return button.icon or button.Icon or button.IconTexture or (name and _G[name .. "IconTexture"])
end

-- One sublevel above the icon: over the picture, under the count and border.
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

-- A window drawing anything but the live slot fails the shownItemId match and gets no tint.
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

-- Forever's bank hook works only because the pool copies the mixin when it makes buttons, after this hook.
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
    An invisible corner widget that never claims its corner, first in the top
    left so no icon ahead of it stops it being asked. Removing it in Baganator's
    settings turns the tint off there; its OnHide clears the tint.
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

-- Rebuilds every Baganator button, so only after bag changes.
local function RefreshBaganator()
	local reasons = Baganator.Constants and Baganator.Constants.RefreshReason
	Baganator.API.RequestItemButtonsRefresh(reasons and { reasons.ItemWidgets } or nil)
end

--------------------------------------------------------------------------------
-- Bagnon
--------------------------------------------------------------------------------

-- Guild and vault windows are refused by id: a guild button's GetBag answers a tab number that passes for a bag.
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

local function GetAceAddon(name)
	local aceAddon = LibStub("AceAddon-3.0", true)
	return aceAddon and aceAddon:GetAddon(name, true)
end

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

-- The tint goes on BetterBags' decoration button, where the icon is, not the one taking clicks.
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

-- Its ids are ArkInventory's window ids, so the Blizzard bag comes off the button.
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

-- { name, folder (nil for the default bags), install, redraw }. An install that hooked nothing is retried.
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

function ns:GetTintAdapterNames()
	local names = {}
	for _, adapter in ipairs(TINT_ADAPTERS) do
		if installedAdapters[adapter[1]] then
			names[#names + 1] = adapter[1]
		end
	end
	return names
end

-- Bank buttons drawn before the open flag was set were remembered with no item, so all repaint.
function ns:RefreshTints()
	for button, record in pairs(paintedButtons) do
		if record.itemId or ns.IS_BANK_BAG[record.bag] then
			PaintButton(button, record.bag, record.slot, record.itemId)
		end
	end
end

-- Never with the tint off: the redraw rebuilds every button for nothing.
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
