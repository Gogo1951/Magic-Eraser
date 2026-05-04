local addonName, ns = ...
local L = ns.L
local Colors = ns.Colors

local format = string.format
local insert = table.insert

local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibDBIcon = LibStub("LibDBIcon-1.0")

--------------------------------------------------------------------------------
-- Tooltip
--------------------------------------------------------------------------------

local function RefreshTooltip(anchor)
    local tooltip = GameTooltip

    tooltip:SetOwner(anchor, "ANCHOR_BOTTOMLEFT")
    tooltip:ClearLines()

    tooltip:AddDoubleLine(
        Colors.TITLE .. ns.AddonTitle .. "|r",
        Colors.MUTED .. ns.Version .. "|r"
    )
    tooltip:AddLine(" ")
    tooltip:AddLine(" ")

    local item = ns:FindItemToDelete()

    if item then
        -- Lowest Value Item
        tooltip:AddLine(Colors.TITLE .. L["LOWEST_VALUE_ITEM"] .. "|r")

        local iconString = format("|T%s:14:14|t", item.icon)
        local countString = (item.count > 1) and format("%sx%d|r", Colors.TEXT, item.count) or ""

        local leftText = iconString .. " " .. item.link .. " " .. countString
        local rightText = (item.value > 0)
            and ns:FormatCurrency(item.value)
            or (Colors.MUTED .. L["NO_VALUE"] .. "|r")

        tooltip:AddDoubleLine(leftText, rightText)

        tooltip:AddDoubleLine(Colors.INFO .. L["LEFT_CLICK"] .. "|r", Colors.INFO .. L["ACTION_ERASE"] .. "|r")
        tooltip:AddDoubleLine(Colors.INFO .. L["RIGHT_CLICK"] .. "|r", Colors.INFO .. L["ACTION_IGNORE"] .. "|r")
    else
        -- Clean Bags
        tooltip:AddLine(Colors.SUCCESS .. L["BAGS_CLEAN_SHORT"] .. "|r", 1, 1, 1, true)
        tooltip:AddLine(" ")
        tooltip:AddLine(Colors.DESC .. L["BAGS_CLEAN_HINT"] .. "|r", 1, 1, 1, true)
    end

    -- Auto-Vend
    tooltip:AddLine(" ")
    local autoVendStatus = (MagicEraserCharDB and MagicEraserCharDB.autoVendEnabled)
        and (Colors.SUCCESS .. L["ENABLED"] .. "|r")
        or (Colors.DISABLED .. L["DISABLED"] .. "|r")
    tooltip:AddDoubleLine(L["AUTO_VEND"], autoVendStatus)
    tooltip:AddLine(Colors.DESC .. L["AUTO_VEND_DESC"] .. "|r", 1, 1, 1, true)

    tooltip:AddDoubleLine(
        Colors.INFO .. L["SHIFT_RIGHT_CLICK"] .. "|r",
        Colors.INFO .. L["ACTION_TOGGLE"] .. "|r"
    )

    -- Ignore List
    local hasIgnoredItems =
        MagicEraserCharDB and MagicEraserCharDB.ignoreList and next(MagicEraserCharDB.ignoreList) ~= nil

    if hasIgnoredItems then
        tooltip:AddLine(" ")
        tooltip:AddLine(Colors.TITLE .. L["IGNORE_LIST"] .. "|r")

        local sortedItems = {}
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

        table.sort(sortedItems, function(a, b)
            return a.name < b.name
        end)

        for _, ignoredItem in ipairs(sortedItems) do
            local _, _, _, hexColor = GetItemQualityColor(ignoredItem.quality)
            tooltip:AddLine(format("|T%s:14:14|t |c%s[%s]|r", ignoredItem.icon, hexColor, ignoredItem.name))
        end

        for _, itemId in ipairs(loadingItems) do
            tooltip:AddLine(Colors.MUTED .. format(L["LOADING_ITEM"], itemId) .. "|r")
        end

        tooltip:AddDoubleLine(
            Colors.INFO .. L["MIDDLE_CLICK"] .. "|r",
            Colors.INFO .. L["ACTION_CLEAR_IGNORE"] .. "|r"
        )
    end

    -- Hint
    tooltip:AddLine(" ")
    tooltip:AddLine(Colors.DESC .. L["TOOLTIP_HINT"] .. "|r", 1, 1, 1, true)

    tooltip:Show()
end

--------------------------------------------------------------------------------
-- Display Refresh
--------------------------------------------------------------------------------

function ns:RefreshDisplay()
    if not ns.LDBObject then
        return
    end

    ns:InvalidateCache()
    local item = ns:FindItemToDelete()

    if item and item.icon then
        ns.LDBObject.icon = item.icon
    else
        ns.LDBObject.icon = ns.DefaultIcon
    end

    if LibDBIcon then
        local button = LibDBIcon:GetMinimapButton(addonName)
        if button then
            if button.icon then
                button.icon:SetTexture(ns.LDBObject.icon)
            end

            if GameTooltip:GetOwner() == button then
                RefreshTooltip(button)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- LDB Data Object
--------------------------------------------------------------------------------

if LibDataBroker then
    ns.LDBObject = LibDataBroker:NewDataObject(addonName, {
        type = "data source",
        text = ns.AddonTitle,
        icon = ns.DefaultIcon,

        OnClick = function(self, button)
            if IsShiftKeyDown() and button == "RightButton" then
                MagicEraserCharDB.autoVendEnabled = not MagicEraserCharDB.autoVendEnabled
                RefreshTooltip(self)
                return
            end

            if button == "LeftButton" then
                ns:RunEraser()
            elseif button == "RightButton" then
                local item = ns:FindItemToDelete()
                if item then
                    ns:ToggleIgnore(item.itemId)
                end
            elseif button == "MiddleButton" then
                ns:ClearIgnoreList()
            end
        end,

        OnEnter = function(self)
            RefreshTooltip(self)
        end,

        OnLeave = function()
            GameTooltip:Hide()
        end,
    })
end