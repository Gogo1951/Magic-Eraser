-------------------------------------------------------------------------
-- 1. Header & Namespace
-------------------------------------------------------------------------
local addonName, ME = ...
_G["MagicEraser"] = ME

-------------------------------------------------------------------------
-- 2. Constants & Branding
-------------------------------------------------------------------------
local ADDON_TITLE = "Magic Eraser"
local ICON_DEFAULT = "Interface\\Icons\\inv_misc_bag_07_green"
local UPDATE_THROTTLE = 0.1

local HEX_BLUE = "00BBFF"
local HEX_GOLD = "FFD100"
local HEX_SEPARATOR = "AAAAAA"
local HEX_TEXT = "FFFFFF"
local HEX_SUCCESS = "00FF00"
local HEX_WARNING = "FF0000"
local COLOR_PREFIX = "|cff"

ME.COLORS = {
    NAME = COLOR_PREFIX .. HEX_BLUE,
    TITLE = COLOR_PREFIX .. HEX_GOLD,
    SEPARATOR = COLOR_PREFIX .. HEX_SEPARATOR,
    TEXT = COLOR_PREFIX .. HEX_TEXT,
    SUCCESS = COLOR_PREFIX .. HEX_SUCCESS,
    WARNING = COLOR_PREFIX .. HEX_WARNING
}

ME.BRAND_PREFIX = string.format("%s%s|r %s//|r ", ME.COLORS.NAME, ADDON_TITLE, ME.COLORS.SEPARATOR)

-------------------------------------------------------------------------
-- 3. Library Loading
-------------------------------------------------------------------------
local LibStub = _G.LibStub
local LDB = LibStub and LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub("LibDBIcon-1.0", true)

-------------------------------------------------------------------------
-- 4. Initialization & Variables
-------------------------------------------------------------------------
local UnitLevel, InCombatLockdown = UnitLevel, InCombatLockdown
local CursorHasItem, ClearCursor, DeleteCursorItem = CursorHasItem, ClearCursor, DeleteCursorItem
local GetItemInfo, C_Timer, C_QuestLog, C_Item = GetItemInfo, C_Timer, C_QuestLog, C_Item
local GetCursorInfo = GetCursorInfo
local format, insert, floor, ipairs = string.format, table.insert, math.floor, ipairs

local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local PickupContainerItem = C_Container and C_Container.PickupContainerItem or PickupContainerItem

-------------------------------------------------------------------------
-- 5. Helper Functions
-------------------------------------------------------------------------
local function FormatCurrency(value)
    if value == 0 then
        return ""
    end
    local g = floor(value / 10000)
    local s = floor((value % 10000) / 100)
    local c = value % 100
    local parts = {}

    if g > 0 then
        insert(parts, format("|cffffffff%d|r|cffffd700g|r", g))
    end
    if s > 0 then
        insert(parts, format("|cffffffff%d|r|cffc7c7cfs|r", s))
    end
    if c > 0 or #parts == 0 then
        insert(parts, format("|cffffffff%d|r|cffeda55fc|r", c))
    end

    return table.concat(parts, " ")
end

local function IsQuestCompleted(questID)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    end
    return false
end

function ME:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(self.BRAND_PREFIX .. msg)
end

-------------------------------------------------------------------------
-- 6. Core Logic
-------------------------------------------------------------------------
function ME:FindItemToDelete()
    local lowestValue, lowestItem = nil, nil
    local playerLevel = UnitLevel("player")
    local dataMissing = false

    local questDB = ME.AllowedDeleteQuestItems or {}
    local consumDB = ME.AllowedDeleteConsumables or {}
    local equipDB = ME.AllowedDeleteEquipment or {}

    for bag = 0, 4 do
        local numSlots = GetContainerNumSlots(bag) or 0
        for slot = 1, numSlots do
            local itemInfo = GetContainerItemInfo(bag, slot)

            if itemInfo and itemInfo.hyperlink then
                local itemID = itemInfo.itemID
                local name, _, rarity, _, requiredLevel, _, _, _, _, icon, sellPrice = GetItemInfo(itemInfo.hyperlink)

                if not name then
                    dataMissing = true
                    if C_Item and C_Item.RequestLoadItemDataByID then
                        C_Item.RequestLoadItemDataByID(itemID)
                    end
                else
                    local count = itemInfo.stackCount or 1
                    local totalValue = (sellPrice or 0) * count
                    local isDeletable = false

                    if questDB[itemID] then
                        for _, qid in ipairs(questDB[itemID]) do
                            if IsQuestCompleted(qid) then
                                isDeletable = true
                                break
                            end
                        end
                    elseif consumDB[itemID] then
                        if (playerLevel - (requiredLevel or 1)) >= 10 then
                            isDeletable = true
                        end
                    elseif equipDB[itemID] then
                        isDeletable = true
                    elseif rarity == 0 and (sellPrice or 0) > 0 then
                        isDeletable = true
                    end

                    if isDeletable then
                        if not lowestValue or totalValue < lowestValue then
                            lowestValue = totalValue
                            lowestItem = {
                                link = itemInfo.hyperlink,
                                itemID = itemID,
                                count = count,
                                value = totalValue,
                                icon = icon,
                                bag = bag,
                                slot = slot
                            }
                        end
                    end
                end
            end
        end
    end

    if dataMissing then
        C_Timer.After(
            1.0,
            function()
                ME:UpdateLDB()
            end
        )
    end

    return lowestItem
end

function ME:RunEraser()
    if InCombatLockdown() then
        self:Print(ME.COLORS.WARNING .. "Cannot erase items while in combat.|r")
        return
    end

    local item = self:FindItemToDelete()

    if item then
        if CursorHasItem() then
            ClearCursor()
        end
        PickupContainerItem(item.bag, item.slot)

        local infoType, infoID = GetCursorInfo()
        if infoType == "item" and infoID == item.itemID then
            DeleteCursorItem()

            local stackStr = (item.count > 1) and format(" x%d", item.count) or ""
            local valStr = (item.value > 0) and format(", worth %s", FormatCurrency(item.value)) or " (Quest Item)"

            self:Print(ME.COLORS.TEXT .. format("Erased %s%s%s.|r", item.link, stackStr, valStr))
        else
            self:Print(ME.COLORS.WARNING .. "Safety Abort: Cursor item did not match target. Item returned to bag.|r")
            ClearCursor()
        end
    else
        self:Print(ME.COLORS.TEXT .. "You'll have to manually erase something if you need to free up more space.|r")
    end

    self:UpdateLDB()
end

-------------------------------------------------------------------------
-- 7. UI & Tooltip
-------------------------------------------------------------------------
local OnEnter

function ME:UpdateLDB()
    if not self.LDBObj then
        return
    end
    local item = self:FindItemToDelete()

    if item and item.icon then
        self.LDBObj.icon = item.icon
    else
        self.LDBObj.icon = ICON_DEFAULT
    end

    if LDBIcon then
        local button = LDBIcon:GetMinimapButton(addonName)
        if button and GameTooltip:GetOwner() == button then
            OnEnter(button)
        end
    end
end

OnEnter = function(anchor)
    local tooltip = GameTooltip
    tooltip:SetOwner(anchor, "ANCHOR_BOTTOMLEFT")
    tooltip:ClearLines()

    local version = C_AddOns and C_AddOns.GetAddOnMetadata(addonName, "Version") or "Dev"
    if version:find("@") then
        version = "Dev"
    end

    tooltip:AddDoubleLine(ME.COLORS.TITLE .. ADDON_TITLE .. "|r", ME.COLORS.SEPARATOR .. version .. "|r")
    tooltip:AddLine(" ")

    local item = ME:FindItemToDelete()

    if item then
        local stackStr = (item.count > 1) and format("%s x%d|r", ME.COLORS.TITLE, item.count) or ""

        tooltip:AddDoubleLine(item.link .. stackStr, FormatCurrency(item.value))
        tooltip:AddLine(" ")

        tooltip:AddDoubleLine(ME.COLORS.NAME .. "Left-Click|r", ME.COLORS.TEXT .. "Erase Lowest Value Item|r")
    else
        tooltip:AddLine(ME.COLORS.SUCCESS .. "Congratulations, your bags are full of good stuff!|r", 1, 1, 1, true)
        tooltip:AddLine(" ")
        tooltip:AddLine(
            ME.COLORS.SEPARATOR .. "You'll have to manually erase something if you need to free up more space.|r",
            1,
            1,
            1,
            true
        )
    end
    tooltip:Show()
end

-------------------------------------------------------------------------
-- 8. Event Registration
-------------------------------------------------------------------------
if LDB then
    ME.LDBObj =
        LDB:NewDataObject(
        addonName,
        {
            type = "data source",
            text = ADDON_TITLE,
            icon = ICON_DEFAULT,
            OnClick = function(_, button)
                if button == "LeftButton" then
                    ME:RunEraser()
                end
            end,
            OnEnter = function(self)
                OnEnter(self)
            end,
            OnLeave = function()
                GameTooltip:Hide()
            end
        }
    )
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:RegisterEvent("LOOT_READY")
eventFrame:RegisterEvent("QUEST_TURNED_IN")

local updateScheduled = false
eventFrame:SetScript(
    "OnEvent",
    function(self, event)
        if event == "PLAYER_LOGIN" then
            MagicEraserDB = MagicEraserDB or {}
            MagicEraserDB.minimap = MagicEraserDB.minimap or {}

            ME.DB = MagicEraserDB

            if LDBIcon and ME.LDBObj then
                LDBIcon:Register(addonName, ME.LDBObj, MagicEraserDB.minimap)
            end
            ME:UpdateLDB()
        elseif event ~= "PLAYER_LOGIN" then
            if not updateScheduled then
                updateScheduled = true
                C_Timer.After(
                    UPDATE_THROTTLE,
                    function()
                        ME:UpdateLDB()
                        updateScheduled = false
                    end
                )
            end
        end
    end
)
