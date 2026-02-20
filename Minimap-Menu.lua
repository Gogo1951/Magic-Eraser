local addonName, Addon = ...
local Colors = Addon.Colors

local format = string.format
local insert = table.insert

local LibDataBroker = LibStub("LibDataBroker-1.1", true)
local LibDBIcon     = LibStub("LibDBIcon-1.0", true)

-------------------------------------------------------------------------
-- Tooltip
-- Defined before Addon:RefreshDisplay so no forward declaration is needed.
-------------------------------------------------------------------------
local function RefreshTooltip(anchor)
    local tooltip = GameTooltip

    tooltip:SetOwner(anchor, "ANCHOR_BOTTOMLEFT")
    tooltip:ClearLines()

    -- Guard C_AddOns for compatibility across Classic Era and TBC Classic clients.
    local GetAddonMetadata = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
    local version = GetAddonMetadata(addonName, "Version") or "Dev"
    tooltip:AddDoubleLine(Colors.TITLE .. Addon.AddonTitle .. "|r", Colors.MUTED .. version .. "|r")
    tooltip:AddLine(" ")

    local item = Addon:FindItemToDelete()

    if item then
        tooltip:AddLine(" ")
        tooltip:AddLine(Colors.TITLE .. "Lowest Value Item|r")

        local iconString  = format("|T%s:14:14|t", item.icon)
        local countString = (item.count > 1) and format("%sx%d|r", Colors.TEXT, item.count) or ""

        local leftText  = iconString .. " " .. item.link .. " " .. countString
        local rightText = (item.value > 0) and Addon:FormatCurrency(item.value) or (Colors.MUTED .. "No Value|r")

        tooltip:AddDoubleLine(leftText, rightText)
        tooltip:AddDoubleLine(Colors.INFO .. "Left-Click|r",  Colors.INFO .. "Erase|r")
        tooltip:AddDoubleLine(Colors.INFO .. "Right-Click|r", Colors.INFO .. "Ignore|r")
    else
        tooltip:AddLine(" ")
        tooltip:AddLine(Colors.SUCCESS .. "Congratulations, your bags are full of good stuff!|r", 1, 1, 1, true)
        tooltip:AddLine(" ")
        tooltip:AddLine(Colors.DESCRIPTION .. "You'll have to manually erase something if you want to free up more space.|r", 1, 1, 1, true)
    end

    local hasIgnoredItems = MagicEraserCharDB
        and MagicEraserCharDB.ignoreList
        and next(MagicEraserCharDB.ignoreList) ~= nil

    if hasIgnoredItems then
        tooltip:AddLine(" ")
        tooltip:AddLine(Colors.TITLE .. "Ignore List|r")

        local sortedItems  = {}
        local loadingItems = {}

        for itemId in pairs(MagicEraserCharDB.ignoreList) do
            local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemId)
            if name then
                insert(sortedItems, { name = name, quality = quality, icon = icon })
            else
                insert(loadingItems, itemId)
                if C_Item and C_Item.RequestLoadItemDataByID then
                    C_Item.RequestLoadItemDataByID(itemId)
                end
            end
        end

        table.sort(sortedItems, function(a, b) return a.name < b.name end)

        for _, ignoredItem in ipairs(sortedItems) do
            local _, _, _, hexColor = GetItemQualityColor(ignoredItem.quality)
            tooltip:AddLine(format("|T%s:14:14|t |c%s[%s]|r", ignoredItem.icon, hexColor, ignoredItem.name))
        end

        for _, itemId in ipairs(loadingItems) do
            tooltip:AddLine(Colors.MUTED .. "Loading ID: " .. itemId .. "|r")
        end

        tooltip:AddDoubleLine(Colors.INFO .. "Middle-Click|r", Colors.INFO .. "Clear Ignore List|r")
    end

    tooltip:Show()
end

-------------------------------------------------------------------------
-- Display Refresh
-- This is the authoritative refresh point. It invalidates the scan cache
-- first, then populates the icon; subsequent FindItemToDelete calls within
-- the same cycle (e.g. RefreshTooltip) hit the warm cache at no cost.
-------------------------------------------------------------------------
function Addon:RefreshDisplay()
    if not Addon.LDBObject then return end

    Addon:InvalidateCache()
    local item = Addon:FindItemToDelete()

    if item and item.icon then
        Addon.LDBObject.icon = item.icon
    else
        Addon.LDBObject.icon = Addon.DefaultIcon
    end

    if LibDBIcon then
        local button = LibDBIcon:GetMinimapButton(addonName)
        if button then
            if button.icon then
                button.icon:SetTexture(Addon.LDBObject.icon)
            end

            if GameTooltip:GetOwner() == button then
                RefreshTooltip(button)
            end
        end
    end
end

-------------------------------------------------------------------------
-- LDB Data Object
-------------------------------------------------------------------------
if LibDataBroker then
    Addon.LDBObject = LibDataBroker:NewDataObject(addonName, {
        type = "data source",
        text = Addon.AddonTitle,
        icon = Addon.DefaultIcon,

        OnClick = function(self, button)
            if button == "LeftButton" then
                Addon:RunEraser()

            elseif button == "RightButton" then
                -- Cache is still warm from the icon update; no extra scan needed.
                local item = Addon:FindItemToDelete()
                if item then
                    Addon:ToggleIgnore(item.itemId)
                end

            elseif button == "MiddleButton" then
                Addon:ClearIgnoreList()
            end
        end,

        OnEnter = function(self) RefreshTooltip(self) end,
        OnLeave = function() GameTooltip:Hide() end,
    })
end