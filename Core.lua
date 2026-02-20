local addonName, Addon = ...

-------------------------------------------------------------------------
-- 1. Helpers
-------------------------------------------------------------------------
local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local PickupContainerItem  = C_Container and C_Container.PickupContainerItem  or PickupContainerItem
local format, insert, floor, ipairs = string.format, table.insert, math.floor, ipairs

function Addon:Print(message)
    DEFAULT_CHAT_FRAME:AddMessage(self.BrandPrefix .. message)
end

function Addon:FormatCommaNumber(number)
    return tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function Addon:FormatCurrency(rawValue)
    local value = math.max(rawValue or 0, 0)

    local gold   = floor(value / 10000)
    local silver = floor((value % 10000) / 100)
    local copper = value % 100
    local parts  = {}

    local goldColor   = Addon.CurrencyColors.GOLD
    local silverColor = Addon.CurrencyColors.SILVER
    local copperColor = Addon.CurrencyColors.COPPER

    if gold > 0 then
        insert(parts, format("|cffffffff%s|r|cff%sg|r", Addon:FormatCommaNumber(gold), goldColor))
    end

    if gold > 0 then
        insert(parts, format("|cffffffff%02d|r|cff%ss|r", silver, silverColor))
    elseif silver > 0 then
        insert(parts, format("|cffffffff%d|r|cff%ss|r", silver, silverColor))
    end

    if gold > 0 or silver > 0 then
        insert(parts, format("|cffffffff%02d|r|cff%sc|r", copper, copperColor))
    else
        insert(parts, format("|cffffffff%d|r|cff%sc|r", copper, copperColor))
    end

    return table.concat(parts, " ")
end

local function IsQuestCompleted(questId)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questId)
    end
    return false
end

-------------------------------------------------------------------------
-- 2. Ignore List
-------------------------------------------------------------------------
function Addon:IsIgnored(itemId)
    return MagicEraserCharDB and MagicEraserCharDB.ignoreList and MagicEraserCharDB.ignoreList[itemId]
end

function Addon:ToggleIgnore(itemId)
    if not itemId then return end
    if MagicEraserCharDB.ignoreList[itemId] then
        MagicEraserCharDB.ignoreList[itemId] = nil
    else
        MagicEraserCharDB.ignoreList[itemId] = true
    end
    Addon:InvalidateCache()
    Addon:RefreshDisplay()
end

function Addon:ClearIgnoreList()
    wipe(MagicEraserCharDB.ignoreList)
    Addon:InvalidateCache()
    Addon:RefreshDisplay()
end

-------------------------------------------------------------------------
-- 3. Scan Cache
-- FindItemToDelete is called from several code paths in the same event
-- cycle (RefreshDisplay, RefreshTooltip, OnClick). Caching the result
-- avoids redundant full bag scans. The cache is invalidated explicitly
-- whenever bag contents or the ignore list changes.
-------------------------------------------------------------------------
local cachedItem   = nil
local isCacheValid = false

function Addon:InvalidateCache()
    isCacheValid = false
    cachedItem   = nil
end

-------------------------------------------------------------------------
-- 4. Scanning
-------------------------------------------------------------------------
local function isBetterDeletionCandidate(candidate, current)
    if candidate.value < current.value then return true end
    if candidate.value == current.value then
        return Addon.DeletePriority[candidate.deleteReason] < Addon.DeletePriority[current.deleteReason]
    end
    return false
end

function Addon:FindItemToDelete()
    if isCacheValid then return cachedItem end

    local best                   = nil
    local playerLevel            = UnitLevel("player")
    local _, playerClass         = UnitClass("player")
    local isDataMissing          = false
    local questItemDatabase      = Addon.AllowedDeleteQuestItems  or {}
    local consumableDatabase     = Addon.AllowedDeleteConsumables or {}
    local equipmentDatabase      = Addon.AllowedDeleteEquipment   or {}
    local classReagentExclusions = (Addon.ClassReagentExclusions and Addon.ClassReagentExclusions[playerClass]) or {}

    for bag = 0, 4 do
        local slotCount = GetContainerNumSlots(bag) or 0
        for slot = 1, slotCount do
            local itemInfo = GetContainerItemInfo(bag, slot)

            if itemInfo and itemInfo.hyperlink then
                local itemId = itemInfo.itemID

                if not Addon:IsIgnored(itemId) and not classReagentExclusions[itemId] then
                    local name, _, rarity, _, requiredLevel, _, _, _, _, icon, sellPrice = GetItemInfo(itemInfo.hyperlink)

                    if not name then
                        isDataMissing = true
                        if C_Item and C_Item.RequestLoadItemDataByID then
                            C_Item.RequestLoadItemDataByID(itemId)
                        end
                    else
                        local count        = itemInfo.stackCount or 1
                        local totalValue   = (sellPrice or 0) * count
                        local deleteReason = nil

                        if questItemDatabase[itemId] then
                            for _, questId in ipairs(questItemDatabase[itemId]) do
                                if IsQuestCompleted(questId) then
                                    deleteReason = "quest"
                                    break
                                end
                            end
                        elseif consumableDatabase[itemId] then
                            if (playerLevel - (requiredLevel or 1)) >= 10 then
                                deleteReason = "consumable"
                            end
                        elseif equipmentDatabase[itemId] then
                            deleteReason = "equipment"
                        elseif rarity == 0 and (sellPrice or 0) > 0 then
                            deleteReason = "gray"
                        end

                        if deleteReason then
                            local candidate = {
                                link         = itemInfo.hyperlink,
                                itemId       = itemId,
                                count        = count,
                                value        = totalValue,
                                icon         = icon,
                                bag          = bag,
                                slot         = slot,
                                deleteReason = deleteReason,
                            }
                            if not best or isBetterDeletionCandidate(candidate, best) then
                                best = candidate
                            end
                        end
                    end
                end
            end
        end
    end

    if isDataMissing then
        C_Timer.After(1.0, function() Addon:RefreshDisplay() end)
    end

    cachedItem   = best
    isCacheValid = true
    return best
end

-------------------------------------------------------------------------
-- 5. Deletion
-------------------------------------------------------------------------
function Addon:RunEraser()
    if InCombatLockdown() then
        self:Print(Addon.Colors.TEXT .. "Cannot erase items while in combat.|r")
        return
    end

    local item = self:FindItemToDelete()

    if item then
        if CursorHasItem() then ClearCursor() end
        PickupContainerItem(item.bag, item.slot)

        local cursorType, cursorItemId = GetCursorInfo()
        if cursorType == "item" and cursorItemId == item.itemId then
            DeleteCursorItem()
            PlaySound(5156)

            local stackString = (item.count > 1) and format(" x%d", item.count) or ""

            -- Branch on deleteReason rather than value so that equipment and
            -- consumables with a zero sell price don't show the quest message.
            local valueString
            if item.deleteReason == "quest" then
                valueString = ", this item was associated with a quest you have completed"
            elseif item.value > 0 then
                valueString = format(", worth %s", Addon:FormatCurrency(item.value))
            else
                valueString = ""
            end

            self:Print(Addon.Colors.TEXT .. format("Erased %s%s%s.|r", item.link, stackString, valueString))

            Addon:InvalidateCache()
            C_Timer.After(0.2, function() Addon:RefreshDisplay() end)
            return
        else
            self:Print(Addon.Colors.TEXT .. "Slow down! You are clicking faster than the game can erase items.|r")
            ClearCursor()
        end
    else
        self:Print(Addon.Colors.TEXT .. "Congratulations, your bags are full of good stuff! You'll have to manually erase something if you want to free up more space.|r")
    end

    Addon:RefreshDisplay()
end

-------------------------------------------------------------------------
-- 6. Events
-------------------------------------------------------------------------
local updatePending = false

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:RegisterEvent("QUEST_TURNED_IN")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "QUEST_TURNED_IN" then
        local questId = ...

        C_Timer.After(1.0, function()
            local questItemDatabase = Addon.AllowedDeleteQuestItems or {}
            local alertedItems      = {}

            for bag = 0, 4 do
                local slotCount = GetContainerNumSlots(bag) or 0
                for slot = 1, slotCount do
                    local itemInfo = GetContainerItemInfo(bag, slot)
                    if itemInfo then
                        local itemId = itemInfo.itemID

                        if questItemDatabase[itemId] and not alertedItems[itemId] then
                            for _, trackedQuestId in ipairs(questItemDatabase[itemId]) do
                                if trackedQuestId == questId then
                                    Addon:Print(Addon.Colors.TEXT .. format("%s can now be safely erased!|r", itemInfo.hyperlink))
                                    alertedItems[itemId] = true
                                    break
                                end
                            end
                        end
                    end
                end
            end

            Addon:InvalidateCache()
            Addon:RefreshDisplay()
        end)

    elseif event == "PLAYER_LOGIN" then
        MagicEraserDB                = MagicEraserDB or {}
        MagicEraserCharDB            = MagicEraserCharDB or {}
        MagicEraserCharDB.ignoreList = MagicEraserCharDB.ignoreList or {}

        local LibDBIcon = LibStub("LibDBIcon-1.0", true)
        if LibDBIcon and Addon.LDBObject then
            LibDBIcon:Register(addonName, Addon.LDBObject, MagicEraserDB.minimap)
        end
        Addon:RefreshDisplay()
    else
        -- BAG_UPDATE_DELAYED and any future registered events.
        if not updatePending then
            updatePending = true
            C_Timer.After(0.1, function()
                Addon:InvalidateCache()
                Addon:RefreshDisplay()
                updatePending = false
            end)
        end
    end
end)