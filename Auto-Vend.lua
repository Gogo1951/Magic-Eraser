local addonName, Addon = ...

local GetContainerNumSlots = C_Container and C_Container.GetContainerNumSlots or GetContainerNumSlots
local GetContainerItemInfo = C_Container and C_Container.GetContainerItemInfo or GetContainerItemInfo
local UseContainerItem = C_Container and C_Container.UseContainerItem or UseContainerItem

local sellQueue = {}
local isSelling = false
local sellIndex = 0

-------------------------------------------------------------------------
-- Queue Processor
-------------------------------------------------------------------------
local function ProcessSellQueue()
    -- Stop if we are done or if the merchant window was closed
    if not isSelling then
        wipe(sellQueue)
        return
    end

    sellIndex = sellIndex + 1

    -- If we have reached the end of the queue, stop selling
    if sellIndex > #sellQueue then
        isSelling = false
        wipe(sellQueue)
        return
    end

    local item = sellQueue[sellIndex]

    -- Double-check the slot before selling to ensure items haven't shifted
    local currentItemInfo = GetContainerItemInfo(item.bag, item.slot)

    if currentItemInfo and currentItemInfo.itemID == item.itemId and not Addon:IsIgnored(item.itemId) then
        UseContainerItem(item.bag, item.slot)

        local stackString = (item.count > 1) and string.format(" x%d", item.count) or ""

        Addon:Print(
            Addon.Colors.TEXT ..
                string.format("Sold %s%s, worth %s.|r", item.link, stackString, Addon:FormatCurrency(item.value))
        )
    end

    -- Process the next item in the queue matching the AutoSellGrey 0.25s standard
    C_Timer.After(0.25, ProcessSellQueue)
end

-------------------------------------------------------------------------
-- Scanner Logic
-------------------------------------------------------------------------
local function ScanAndVend()
    if not isSelling then
        return
    end

    local isDataMissing = false
    local _, playerClass = UnitClass("player")
    local classReagentExclusions = (Addon.ClassReagentExclusions and Addon.ClassReagentExclusions[playerClass]) or {}

    wipe(sellQueue)
    sellIndex = 0

    for bag = 0, 4 do
        local slotCount = GetContainerNumSlots(bag) or 0
        for slot = 1, slotCount do
            local itemInfo = GetContainerItemInfo(bag, slot)
            if itemInfo and itemInfo.hyperlink then
                local itemId = itemInfo.itemID

                if not Addon:IsIgnored(itemId) and not classReagentExclusions[itemId] then
                    local name, _, rarity, _, requiredLevel, _, _, _, _, _, sellPrice = GetItemInfo(itemInfo.hyperlink)

                    if not name then
                        isDataMissing = true
                        if C_Item and C_Item.RequestLoadItemDataByID then
                            C_Item.RequestLoadItemDataByID(itemId)
                        end
                    elseif sellPrice and sellPrice > 0 then
                        local deleteReason = Addon:GetItemDeleteReason(itemId, rarity, sellPrice, requiredLevel)

                        if deleteReason then
                            local count = itemInfo.stackCount or 1
                            local totalValue = sellPrice * count
                            -- Store the itemId and count so we can verify and print it accurately
                            table.insert(
                                sellQueue,
                                {
                                    bag = bag,
                                    slot = slot,
                                    itemId = itemId,
                                    count = count,
                                    value = totalValue,
                                    link = itemInfo.hyperlink
                                }
                            )
                        end
                    end
                end
            end
        end
    end

    if isDataMissing then
        -- Wait a moment for server item data to load, then try again
        C_Timer.After(0.5, ScanAndVend)
    elseif #sellQueue > 0 then
        ProcessSellQueue()
    else
        isSelling = false
    end
end

-------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("MERCHANT_SHOW")
eventFrame:RegisterEvent("MERCHANT_CLOSED")

eventFrame:SetScript(
    "OnEvent",
    function(self, event)
        if event == "MERCHANT_SHOW" then
            if MagicEraserDB and MagicEraserDB.autoVendEnabled then
                isSelling = true
                sellIndex = 0
                ScanAndVend()
            end
        elseif event == "MERCHANT_CLOSED" then
            isSelling = false
            wipe(sellQueue)
        end
    end
)