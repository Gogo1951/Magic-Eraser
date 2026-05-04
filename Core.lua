local addonName, ns = ...
local L = ns.L

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local PickupContainerItem = C_Container and C_Container.PickupContainerItem or PickupContainerItem
local format, insert, floor, ipairs = string.format, table.insert, math.floor, ipairs

function ns:Print(message)
    DEFAULT_CHAT_FRAME:AddMessage(self.BrandPrefix .. ns.Colors.TEXT .. message .. "|r")
end

function ns:FormatCommaNumber(number)
    return tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function ns:FormatCurrency(rawValue)
    local value = math.max(rawValue or 0, 0)

    local gold = floor(value / 10000)
    local silver = floor((value % 10000) / 100)
    local copper = value % 100
    local parts = {}

    local goldColor = ns.CurrencyColors.GOLD
    local silverColor = ns.CurrencyColors.SILVER
    local copperColor = ns.CurrencyColors.COPPER

    if gold > 0 then
        insert(parts, format(ns.Colors.TEXT .. "%s|r|cff%sg|r", ns:FormatCommaNumber(gold), goldColor))
    end

    if gold > 0 then
        insert(parts, format(ns.Colors.TEXT .. "%02d|r|cff%ss|r", silver, silverColor))
    elseif silver > 0 then
        insert(parts, format(ns.Colors.TEXT .. "%d|r|cff%ss|r", silver, silverColor))
    end

    if gold > 0 or silver > 0 then
        insert(parts, format(ns.Colors.TEXT .. "%02d|r|cff%sc|r", copper, copperColor))
    else
        insert(parts, format(ns.Colors.TEXT .. "%d|r|cff%sc|r", copper, copperColor))
    end

    return table.concat(parts, " ")
end

function ns:IsQuestCompleted(questId)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questId)
    end
    return false
end

--------------------------------------------------------------------------------
-- Ignore List
--------------------------------------------------------------------------------

function ns:IsIgnored(itemId)
    return MagicEraserCharDB and MagicEraserCharDB.ignoreList and MagicEraserCharDB.ignoreList[itemId]
end

function ns:ToggleIgnore(itemId)
    if not itemId then
        return
    end
    if MagicEraserCharDB.ignoreList[itemId] then
        MagicEraserCharDB.ignoreList[itemId] = nil
    else
        MagicEraserCharDB.ignoreList[itemId] = true
    end
    ns:InvalidateCache()
    ns:RefreshDisplay()
end

function ns:ClearIgnoreList()
    wipe(MagicEraserCharDB.ignoreList)
    ns:InvalidateCache()
    ns:RefreshDisplay()
end

--------------------------------------------------------------------------------
-- Scan Cache
--------------------------------------------------------------------------------

local cachedItem = nil
local isCacheValid = false

function ns:InvalidateCache()
    isCacheValid = false
    cachedItem = nil
end

--------------------------------------------------------------------------------
-- Scanning & Evaluation
--------------------------------------------------------------------------------

function ns:GetItemDeleteReason(itemId, rarity, sellPrice, requiredLevel)
    local playerLevel = UnitLevel("player")
    local questItemDatabase = ns.AllowedDeleteQuestItems or {}
    local consumableDatabase = ns.AllowedDeleteConsumables or {}
    local equipmentDatabase = ns.AllowedDeleteEquipment or {}

    if questItemDatabase[itemId] then
        for _, questId in ipairs(questItemDatabase[itemId]) do
            if self:IsQuestCompleted(questId) then
                return "quest"
            end
        end
    elseif consumableDatabase[itemId] then
        if (playerLevel - (requiredLevel or 1)) >= 10 then
            return "consumable"
        end
    elseif equipmentDatabase[itemId] then
        return "equipment"
    elseif rarity == 0 and (sellPrice or 0) > 0 then
        return "gray"
    end

    return nil
end

local function isBetterDeletionCandidate(candidate, current)
    if candidate.value < current.value then
        return true
    end
    if candidate.value == current.value then
        return ns.DeletePriority[candidate.deleteReason] < ns.DeletePriority[current.deleteReason]
    end
    return false
end

function ns:FindItemToDelete()
    if isCacheValid then
        return cachedItem
    end

    local best = nil
    local _, playerClass = UnitClass("player")
    local isDataMissing = false
    local classReagentExclusions = (ns.ClassReagentExclusions and ns.ClassReagentExclusions[playerClass]) or {}

    for bag = 0, 4 do
        local slotCount = GetContainerNumSlots(bag) or 0
        for slot = 1, slotCount do
            local itemInfo = GetContainerItemInfo(bag, slot)

            if itemInfo and itemInfo.hyperlink then
                local itemId = itemInfo.itemID

                if not ns:IsIgnored(itemId) and not classReagentExclusions[itemId] then
                    local name, _, rarity, _, requiredLevel, _, _, _, _, icon, sellPrice =
                        GetItemInfo(itemInfo.hyperlink)

                    if not name then
                        isDataMissing = true
                        if C_Item and C_Item.RequestLoadItemDataByID then
                            C_Item.RequestLoadItemDataByID(itemId)
                        end
                    else
                        local count = itemInfo.stackCount or 1
                        local totalValue = (sellPrice or 0) * count
                        local deleteReason = self:GetItemDeleteReason(itemId, rarity, sellPrice, requiredLevel)

                        if deleteReason then
                            local candidate = {
                                link = itemInfo.hyperlink,
                                itemId = itemId,
                                count = count,
                                value = totalValue,
                                icon = icon,
                                bag = bag,
                                slot = slot,
                                deleteReason = deleteReason
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
        C_Timer.After(
            1.0,
            function()
                ns:RefreshDisplay()
            end
        )
    end

    cachedItem = best
    isCacheValid = true
    return best
end

--------------------------------------------------------------------------------
-- Deletion
--------------------------------------------------------------------------------

function ns:RunEraser()
    if InCombatLockdown() then
        self:Print(L["COMBAT_LOCKOUT"])
        return
    end

    local item = self:FindItemToDelete()

    if item then
        if CursorHasItem() then
            ClearCursor()
        end
        PickupContainerItem(item.bag, item.slot)

        local cursorType, cursorItemId = GetCursorInfo()
        if cursorType == "item" and cursorItemId == item.itemId then
            DeleteCursorItem()
            PlaySound(5156)

            local stackString = (item.count > 1) and format(" x%d", item.count) or ""

            local valueString
            if item.deleteReason == "quest" then
                valueString = L["ERASED_QUEST_SUFFIX"]
            elseif item.value > 0 then
                valueString = format(L["ERASED_VALUE_SUFFIX"], ns:FormatCurrency(item.value))
            else
                valueString = ""
            end

            self:Print(format(L["ERASED_ITEM"], item.link, stackString, valueString))

            ns:InvalidateCache()
            C_Timer.After(
                0.2,
                function()
                    ns:RefreshDisplay()
                end
            )
            return
        else
            self:Print(L["CURSOR_TOO_FAST"])
            ClearCursor()
        end
    else
        self:Print(L["BAGS_CLEAN"])
    end

    ns:RefreshDisplay()
end

--------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------

local updatePending = false

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
eventFrame:RegisterEvent("QUEST_TURNED_IN")

eventFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        if event == "QUEST_TURNED_IN" then
            local questId = ...

            C_Timer.After(
                1.0,
                function()
                    local questItemDatabase = ns.AllowedDeleteQuestItems or {}
                    local alertedItems = {}

                    for bag = 0, 4 do
                        local slotCount = GetContainerNumSlots(bag) or 0
                        for slot = 1, slotCount do
                            local itemInfo = GetContainerItemInfo(bag, slot)
                            if itemInfo then
                                local itemId = itemInfo.itemID

                                if questItemDatabase[itemId] and not alertedItems[itemId] then
                                    for _, trackedQuestId in ipairs(questItemDatabase[itemId]) do
                                        if trackedQuestId == questId then
                                            ns:Print(format(L["QUEST_ITEM_READY"], itemInfo.hyperlink))
                                            alertedItems[itemId] = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end

                    ns:InvalidateCache()
                    ns:RefreshDisplay()
                end
            )
        elseif event == "PLAYER_LOGIN" then
            MagicEraserDB = MagicEraserDB or {}
            MagicEraserDB.minimap = MagicEraserDB.minimap or {}
            if MagicEraserDB.showWelcome == nil then MagicEraserDB.showWelcome = true end

            MagicEraserCharDB = MagicEraserCharDB or {}
            MagicEraserCharDB.ignoreList = MagicEraserCharDB.ignoreList or {}

            -- The first character to log in after upgrade inherits the
            -- legacy account-wide autoVendEnabled; the legacy field is then cleared.
            if MagicEraserCharDB.autoVendEnabled == nil and MagicEraserDB.autoVendEnabled ~= nil then
                MagicEraserCharDB.autoVendEnabled = MagicEraserDB.autoVendEnabled
            end
            if MagicEraserDB.autoVendEnabled ~= nil then
                MagicEraserDB.autoVendEnabled = nil
            end
            if MagicEraserCharDB.autoVendEnabled == nil then
                MagicEraserCharDB.autoVendEnabled = false
            end

            local LibDBIcon = LibStub("LibDBIcon-1.0")
            if LibDBIcon and ns.LDBObject then
                LibDBIcon:Register(addonName, ns.LDBObject, MagicEraserDB.minimap)
            end

            if MagicEraserDB.showWelcome then
                ns:Print(L["CHAT_LOADED"])
            end

            ns:RefreshDisplay()
        else
            if not updatePending then
                updatePending = true
                C_Timer.After(
                    0.1,
                    function()
                        ns:InvalidateCache()
                        ns:RefreshDisplay()
                        updatePending = false
                    end
                )
            end
        end
    end
)
