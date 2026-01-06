local addonName, ME = ...
local C = ME.COLORS

local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)

local UpdateTooltip

local function SetLastLineSmall()
    local tooltip = GameTooltip
    local lineNum = tooltip:NumLines()
    local left = _G["GameTooltipTextLeft"..lineNum]
    local right = _G["GameTooltipTextRight"..lineNum]
    if left then left:SetFontObject(GameFontNormalSmall) end
    if right then right:SetFontObject(GameFontNormalSmall) end
end

function ME:UpdateLDB()
    if not ME.LDBObj then return end

    local item = ME:FindItemToDelete()

    if item and item.icon then
        ME.LDBObj.icon = item.icon
    else
        ME.LDBObj.icon = ME.ICON_DEFAULT
    end

    if LDBIcon then
        local button = LDBIcon:GetMinimapButton(addonName)
        if button then
            if button.icon then
                button.icon:SetTexture(ME.LDBObj.icon)
            end
            
            if GameTooltip:GetOwner() == button then
                UpdateTooltip(button)
            end
        end
    end
end

UpdateTooltip = function(anchor)
    local tooltip = GameTooltip
    
    tooltip:SetOwner(anchor, "ANCHOR_BOTTOMLEFT")
    tooltip:ClearLines()

    local version = C_AddOns.GetAddOnMetadata(addonName, "Version") or "Dev"
    tooltip:AddDoubleLine(C.TITLE..ME.ADDON_TITLE.."|r", C.MUTED..version.."|r")
    tooltip:AddLine(" ")
    
    local item = ME:FindItemToDelete()

    if item then
        tooltip:AddLine(" ")
        
        tooltip:AddLine(C.TITLE.."Lowest Value Item|r")
        tooltip:AddLine(" ")
        
        local iconStr = format("|T%s:14:14|t", item.icon)
        local countStr = (item.count > 1) and format("%sx%d|r", C.TEXT, item.count) or ""
        
        local leftText = iconStr .. " " .. item.link .. " " .. countStr
        local rightText = (item.value > 0) and ME:FormatCurrency(item.value) or (C.MUTED .. "No Value|r")
        
        tooltip:AddDoubleLine(leftText, rightText)
        
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(C.INFO.."Left-Click|r", C.INFO.."Erase|r")
        
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(C.INFO.."Right-Click|r", C.INFO.."Ignore|r")
    else
        tooltip:AddLine(" ")
        tooltip:AddLine(C.SUCCESS.."Congratulations, your bags are full of good stuff!|r", 1, 1, 1, true)
        tooltip:AddLine(" ")
        tooltip:AddLine(C.DESC.."You'll have to manually erase something if you want to free up more space.|r", 1, 1, 1, true)
    end

    local hasIgnored = MagicEraserCharDB and MagicEraserCharDB.ignoreList and next(MagicEraserCharDB.ignoreList) ~= nil
    
    if hasIgnored then
        tooltip:AddLine(" ")
        tooltip:AddLine(C.TITLE.."Ignore List|r")
        tooltip:AddLine(" ")
        
        local sortedItems = {}
        local loadingItems = {}
        
        for itemID in pairs(MagicEraserCharDB.ignoreList) do
            local name, _, quality, _, _, _, _, _, _, icon = GetItemInfo(itemID)
            if name then
                table.insert(sortedItems, {
                    name = name,
                    quality = quality,
                    icon = icon
                })
            else
                table.insert(loadingItems, itemID)
                if C_Item and C_Item.RequestLoadItemDataByID then
                    C_Item.RequestLoadItemDataByID(itemID)
                end
            end
        end

        table.sort(sortedItems, function(a, b) return a.name < b.name end)

        for _, info in ipairs(sortedItems) do
            local _, _, _, hex = GetItemQualityColor(info.quality)
            tooltip:AddLine(format("|T%s:14:14|t |c%s[%s]|r", info.icon, hex, info.name))
        end

        for _, id in ipairs(loadingItems) do
             tooltip:AddLine(C.MUTED.."Loading ID: "..id.."|r")
        end
        
        tooltip:AddLine(" ")
        tooltip:AddDoubleLine(C.INFO.."Middle-Click|r", C.INFO.."Clear Ignore List|r")
    end

    tooltip:Show()
end

if LDB then
    ME.LDBObj = LDB:NewDataObject(addonName, {
        type = "data source", 
        text = ME.ADDON_TITLE, 
        icon = ME.ICON_DEFAULT,
        
        OnClick = function(self, button)
            if button == "LeftButton" then
                ME:RunEraser()
                
            elseif button == "RightButton" then
                local item = ME:FindItemToDelete()
                if item then
                    ME:ToggleIgnore(item.itemID)
                end
                
            elseif button == "MiddleButton" then
                ME:ClearIgnoreList()
            end
        end,
        
        OnEnter = function(self) UpdateTooltip(self) end,
        OnLeave = function() GameTooltip:Hide() end
    })
end
