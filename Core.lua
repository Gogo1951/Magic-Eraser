local addonName, ME = ...
_G["MagicEraser"] = ME

-------------------------------------------------------------------------
-- 1. Constants & Branding
-------------------------------------------------------------------------
ME.ADDON_TITLE = "Magic Eraser"
ME.ICON_DEFAULT = "Interface\\Icons\\inv_misc_bag_07_green"

local C_TITLE    = "FFD100" -- Gold
local C_INFO     = "00BBFF" -- Blue
local C_BODY     = "CCCCCC" -- Silver
local C_TEXT     = "FFFFFF" -- White
local C_SUCCESS  = "33CC33" -- Green
local C_DISABLED = "CC3333" -- Red
local C_SEP      = "AAAAAA" -- Gray
local C_MUTED    = "808080" -- Dark Gray
local COLOR_PREFIX = "|cff"

ME.COLORS = {
    TITLE    = COLOR_PREFIX .. C_TITLE,
    INFO     = COLOR_PREFIX .. C_INFO,
    DESC     = COLOR_PREFIX .. C_BODY,
    TEXT     = COLOR_PREFIX .. C_TEXT,
    SUCCESS  = COLOR_PREFIX .. C_SUCCESS,
    DISABLED = COLOR_PREFIX .. C_DISABLED,
    SEP      = COLOR_PREFIX .. C_SEP,
    MUTED    = COLOR_PREFIX .. C_MUTED
}

ME.BRAND_PREFIX = string.format("%s%s|r %s//|r ", ME.COLORS.INFO, ME.ADDON_TITLE, ME.COLORS.SEP)

-------------------------------------------------------------------------
-- 2. Variables & Helpers
-------------------------------------------------------------------------
local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local PickupContainerItem = C_Container and C_Container.PickupContainerItem or PickupContainerItem
local format, insert, floor, ipairs = string.format, table.insert, math.floor, ipairs

function ME:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(self.BRAND_PREFIX .. msg)
end

function ME:FormatCommaNumber(n)
    return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function ME:FormatCurrency(value)
    local val = value or 0
    if val < 0 then val = 0 end

    local gold = floor(val / 10000)
    local silver = floor((val % 10000) / 100)
    local copper = val % 100
    local parts = {}

    local HEX_GOLD, HEX_SILVER, HEX_COPPER = "FFD700", "C7C7CF", "EDA55F"

    if gold > 0 then insert(parts, format("|cffffffff%s|r|cff%sg|r", ME:FormatCommaNumber(gold), HEX_GOLD)) end
    
    if gold > 0 then
        insert(parts, format("|cffffffff%02d|r|cff%ss|r", silver, HEX_SILVER))
    elseif silver > 0 then
        insert(parts, format("|cffffffff%d|r|cff%ss|r", silver, HEX_SILVER))
    end
    
    if gold > 0 or silver > 0 then
        insert(parts, format("|cffffffff%02d|r|cff%sc|r", copper, HEX_COPPER))
    else
        insert(parts, format("|cffffffff%d|r|cff%sc|r", copper, HEX_COPPER))
    end

    return table.concat(parts, " ")
end

local function IsQuestCompleted(questID)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questID)
    end
    return false
end

-------------------------------------------------------------------------
-- 3. Ignore List Logic
-------------------------------------------------------------------------
function ME:IsIgnored(itemID)
    return MagicEraserCharDB and MagicEraserCharDB.ignoreList and MagicEraserCharDB.ignoreList[itemID]
end

function ME:ToggleIgnore(itemID)
    if not itemID then return end
    
    if MagicEraserCharDB.ignoreList[itemID] then
        MagicEraserCharDB.ignoreList[itemID] = nil
    else
        MagicEraserCharDB.ignoreList[itemID] = true
    end
    ME:UpdateLDB()
end

function ME:ClearIgnoreList()
    wipe(MagicEraserCharDB.ignoreList)
    ME:UpdateLDB()
end

-------------------------------------------------------------------------
-- 4. Scanning Logic
-------------------------------------------------------------------------
function ME:FindItemToDelete()
    local lowestValue, lowestItem = nil, nil
    local playerLevel = UnitLevel("player")
    local _, playerClass = UnitClass("player") -- GET PLAYER CLASS
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
                
                local isShamanReagent = (playerClass == "SHAMAN") and (itemID == 17057 or itemID == 17058)

                if not ME:IsIgnored(itemID) and not isShamanReagent then 
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
                                if IsQuestCompleted(qid) then isDeletable = true; break end
                            end
                        elseif consumDB[itemID] then
                            if (playerLevel - (requiredLevel or 1)) >= 10 then isDeletable = true end
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
    end

    if dataMissing then
        C_Timer.After(1.0, function() ME:UpdateLDB() end)
    end

    return lowestItem
end

-------------------------------------------------------------------------
-- 5. Deletion Logic
-------------------------------------------------------------------------
function ME:RunEraser()
    if InCombatLockdown() then
        self:Print(ME.COLORS.TEXT .. "Cannot erase items while in combat.|r")
        return
    end

    local item = self:FindItemToDelete()

    if item then
        if CursorHasItem() then ClearCursor() end
        PickupContainerItem(item.bag, item.slot)

        local infoType, infoID = GetCursorInfo()
        if infoType == "item" and infoID == item.itemID then
            DeleteCursorItem()
            PlaySound(5156)

            local stackStr = (item.count > 1) and format(" x%d", item.count) or ""
            
            local valStr = (item.value > 0) and format(", worth %s", ME:FormatCurrency(item.value)) or
                ", this item was associated with a quest you have completed"
            
            self:Print(ME.COLORS.TEXT .. format("Erased %s%s%s.|r", item.link, stackStr, valStr))
            
            C_Timer.After(0.2, function() ME:UpdateLDB() end)
        else
            self:Print(ME.COLORS.TEXT .. "Slow down! You are clicking faster than the game can erase items.|r")
            ClearCursor()
        end
    else
        self:Print(ME.COLORS.TEXT .. "Congratulations, your bags are full of good stuff! You'll have to manually erase something if you want to free up more space.|r")
    end
    
    ME:UpdateLDB()
end

-------------------------------------------------------------------------
-- 6. Events
-------------------------------------------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:RegisterEvent("QUEST_TURNED_IN")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "QUEST_TURNED_IN" then
        local questID = ...
        
        C_Timer.After(1.0, function()
            local questDB = ME.AllowedDeleteQuestItems or {}
            local alertedItems = {}

            for bag = 0, 4 do
                local numSlots = GetContainerNumSlots(bag) or 0
                for slot = 1, numSlots do
                    local itemInfo = GetContainerItemInfo(bag, slot)
                    if itemInfo then
                        local itemID = itemInfo.itemID
                        
                        if questDB[itemID] and not alertedItems[itemID] then
                            for _, qid in ipairs(questDB[itemID]) do
                                if qid == questID then
                                    ME:Print(ME.COLORS.TEXT .. format("%s can be now be safely erased!|r", itemInfo.hyperlink))
                                    alertedItems[itemID] = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            ME:UpdateLDB()
        end)

    elseif event == "PLAYER_LOGIN" then
        MagicEraserDB = MagicEraserDB or {}
        MagicEraserCharDB = MagicEraserCharDB or {}
        MagicEraserCharDB.ignoreList = MagicEraserCharDB.ignoreList or {}
        ME.DB = MagicEraserDB
        
        local LDBIcon = LibStub("LibDBIcon-1.0", true)
        if LDBIcon and ME.LDBObj then
            LDBIcon:Register(addonName, ME.LDBObj, MagicEraserDB.minimap)
        end
        ME:UpdateLDB()
    else
        if not self.updateScheduled then
            self.updateScheduled = true
            C_Timer.After(0.1, function() 
                ME:UpdateLDB() 
                self.updateScheduled = false
            end)
        end
    end
end)
