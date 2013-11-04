local addonName, ns, _ = ...

local function percentilize(ratio, noColor)
    local ratioString = string.format("%.2f%%", (ratio - 1) * 100)
    if ratio > 11 then ratioString = "> 1000%"
    elseif ratio < -11 then ratioString = "< 1000%"
    end

    if not noColor then
        local color = "ffff00"
        if ratio >= 1.1 then
            color = "00ff00"
        elseif ratio < 1 then
            color = "ff0000"
        end
        ratioString = string.format("|cff%s%s|r", color, ratioString)
    end

    return ratioString
end

-- takes a string and escapes the magic characters ^$()%.[]*+-? with a %-character for safe use in Lua patterns
local function noPattern(text)
    return string.gsub(text, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

-- Tooltip formatter
function TopFit:getComparisonTooltipLines(item)
    local lines = {}
    --compareItem = TopFit:GetCachedItem(12345)

    local tooltipFormat = {
        {" "},
        {"##############TopFit Tooltip!################"},
        {"Comparing with your items for {{[setlist]||, }}:"},
        {"[setpercentages:nocolor]"},
    }

    for lineNumber = 1, #tooltipFormat do
        local lineTable = tooltipFormat[lineNumber]
        local tooltipLine = {}
        for columnNumber = 1, 2 do
            local lineText = lineTable[columnNumber] or ""

            lineText = TopFit:replaceTokensInString(lineText, item)

            tinsert(tooltipLine, lineText)
        end
        tinsert(lines, tooltipLine)
    end

    return lines
end

function TopFit:replaceTokensInString(text, item)
    local findOffset = 1
    local setIDs = ns.GetSetList()

    -- only keep sets that should be shown in tooltip
    for i = #setIDs, 1, -1 do
        if not ns.GetSetByID(setIDs[i], true):GetDisplayInTooltip() then
            tremove(setIDs, i)
        end
    end

    repeat
        local findStart, findEnd, findString = string.find(text, "%[(.-)%]", findOffset)

        if findStart then
            local parts = TopFit:getTokenAndArguments(findString)
            local token = string.lower(parts[1])

            replaceText = "[" .. findString .. "]"

            if token == "setlist" then
                local namesString = ''
                for i = 1, #setIDs do
                    local setName = ns.GetSetByID(setIDs[i], true):GetName();
                    if namesString ~= '' then
                        namesString = namesString..', '
                    end
                    namesString = namesString..setName
                end
                replaceText = namesString
            elseif token == "setpercentages" then
                local noColor = false
                for i = 2, #parts do
                    local modifier = parts[i]
                    if string.lower(modifier) == 'nocolor' then
                        noColor = true
                    end
                end

                local percentagesString = ''
                for i = 1, #setIDs do
                    local setID = setIDs[i]

                    local percentage = TopFit:getComparePercentage(item, setID)

                    if percentagesString ~= '' then
                        percentagesString = percentagesString..', '
                    end
                    percentagesString = percentagesString..percentilize(percentage, noColor)..'%'
                end
                replaceText = percentagesString
            else
                findOffset = findStart + 1 -- keep looking behind this unknown token
            end
            text = string.gsub(text, "%["..noPattern(findString).."%]", replaceText)
        end
    until not findStart

    return text
end

function TopFit:getTokenAndArguments(token)
    local parts = {string.split(':', token)}

    return parts
end

-- calculates the items that the given item should be compared to in a tooltip
function TopFit:getCompareItems(itemTable, setCode)
    local compareSets = {}

    if itemTable and setCode then
        -- find current item(s) from set
        local setItemPositions = GetEquipmentSetLocations(TopFit:GenerateSetName(setTable.name))
        local setItemIDs = GetEquipmentSetItemIDs(TopFit:GenerateSetName(setTable.name))
        local setItemLinks = {}
        if not setItemPositions then return end

        for slotID, setItemLocation in pairs(setItemPositions) do
            if setItemLocation and setItemLocation ~= 1 and setItemLocation ~= 0 then -- 0: no item; 1: slot is ignored
                local setItemLink = nil
                local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(setItemLocation)
                if player then
                    if bank then
                        -- item is banked, use itemID
                        local itemID = GetEquipmentSetItemIDs(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))[slotID]
                        if itemID and itemID ~= 1 then
                            _, setItemLink = GetItemInfo(itemID)
                        end
                    elseif bags then
                        -- item is in player's bags
                        setItemLink = GetContainerItemLink(bag, slot)
                    else
                        -- item is equipped
                        setItemLink = GetInventoryItemLink("player", slot)
                    end
                else
                    -- item not found
                end
                setItemLinks[slotID] = setItemLink
            end
        end

        for _, slotID in pairs(itemTable.equipLocationsByType) do
            -- for each slot the item can be equipped in
            local setItemID = nil
            local setItemLink = nil
            local extraText = ""
            local compareTable = nil
            local itemTable2 = nil
            local compareTable2 = nil
            local compareNotCached = false

            if setItemIDs and setItemIDs[slotID] and setItemIDs[slotID] ~= 1 and setItemIDs[slotID] ~= 0 then
                setItemID = setItemIDs[slotID]
                setItemLink = setItemLinks[slotID]

                if setItemLink then
                    setItemTable = TopFit:GetCachedItem(setItemLink)
                end

                if not setItemTable then
                    compareNotCached = true
                end
            end

            -- location tables for best-in-slot requests
            local locationTable, compLocationTable
            if (slotID == 16 or slotID == 17) then
                locationTable = {itemLink = itemTable.itemLink, slot = nil, bag = nil}
                if setItemTable then
                    local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(setItemPositions[slotID])
                    if player then
                        if bags then
                            compLocationTable = {itemLink = setItemTable.itemLink, slot = slot, bag = bag}
                        elseif bank then
                            compLocationTable = {itemLink = setItemTable.itemLink, slot = nil, bag = nil}
                        else
                            compLocationTable = {itemLink = setItemTable.itemLink, slot = slot, bag = nil}
                        end
                    else
                        compLocationTable = {itemLink = setItemTable.itemLink, slot = nil, bag = nil}
                    end
                else
                    compLocationTable = {itemLink = "", slot = nil, bag = nil}
                end
            end


            tinsert(compareSets, {
                setItemTable
            })
        end
    end

    return compareSets
end










function TopFit:getComparePercentage(itemTable, setCode)
    if not itemTable or not setCode then return 0 end
    local set = ns.GetSetByID(setCode)
    if not set then return 0 end

    local rawScore, asIsScore, rawCompareScore, asIsCompareScore = 0, 0, 0, 0

    rawScore = set:GetItemScore(itemTable.itemLink, true) -- including caps, raw score
    asIsScore = set:GetItemScore(itemTable.itemLink, false) -- including caps, enchanted score

    if true then return 0 end



    if slotID == 16 then -- main hand slot
        if TopFit:IsOnehandedWeapon(ns.emptySet, link) then
            -- is the weapon we compare to (if it exists) two-handed?
            if setItemIDs and setItemIDs[slotID] and setItemIDs[slotID] ~= 1 and setItemIDs[slotID] ~= 0 and not TopFit:IsOnehandedWeapon(ns.emptySet, setItemIDs[slotID]) then
                -- try to find a fitting offhand for better comparison
                if TopFit.playerCanDualwield then
                    -- find best offhand regardless of type
                    local lTable2 = TopFit:CalculateBestInSlot(ns.emptySet, {locationTable, compLocationTable}, false, 17, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(ns.emptySet, locationTable.itemLink) end)
                    if lTable2 then
                        itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
                    end
                else
                    -- find best offhand that is not a weapon
                    local lTable2 = TopFit:CalculateBestInSlot(ns.emptySet, {locationTable, compLocationTable}, false, 17, setCode, function(locationTable) itemTable = TopFit:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
                    if lTable2 then
                        itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
                    end
                end
            else
            end
        else
            if setItemIDs and setItemIDs[slotID] and setItemIDs[slotID] ~= 1 then
                -- mainhand is set
                if TopFit:IsOnehandedWeapon(ns.emptySet, setItemIDs[slotID]) then
                    -- use offhand of that set as second compare item
                    if (setItemLinks[17]) then
                        compareTable2 = TopFit:GetCachedItem(setItemLinks[17])
                    end
                else
                    -- compare normally, these are 2 two-handed weapons
                end
            else
                -- compare with offhand if appliccapble
                if (setItemLinks[17]) then
                    compareTable2 = TopFit:GetCachedItem(setItemLinks[17])
                end
            end
        end
    elseif slotID == 17 then -- offhand slot
        -- find a valid mainhand to use in comparisons (only when comparing to a 2h)
        if setItemIDs and setItemIDs[16] and setItemIDs[16] ~= 1 and not TopFit:IsOnehandedWeapon(ns.emptySet, setItemIDs[16]) then
            local lTable2 = TopFit:CalculateBestInSlot(ns.emptySet, {locationTable, compLocationTable}, false, 16, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(ns.emptySet, locationTable.itemLink) end)
            if lTable2 then
                itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
            end

            -- also set compareTable to the relevant MAIN HAND! since offhand is empty, obviously
            compareTable = TopFit:GetCachedItem(setItemLinks[16])

            if compareTable then
                rawCompareScore = set:GetItemScore(compareTable.itemLink, true)
                asIsCompareScore = set:GetItemScore(compareTable.itemLink, false)
            else
                compareNotCached = true
            end
        end
    end

    if itemTable2 then
        rawScore = rawScore + set:GetItemScore(itemTable2.itemLink, true)
        asIsScore = asIsScore + set:GetItemScore(itemTable2.itemLink, false)

        extraText = extraText..", if you also use "..itemTable2.itemLink
    end

    if compareTable2 then
        rawCompareScore = rawCompareScore + set:GetItemScore(compareTable2.itemLink, true)
        asIsCompareScore = asIsCompareScore + set:GetItemScore(compareTable2.itemLink, false)

        extraText = extraText..", "..compareTable2.itemLink
    end

    local ratio, rawRatio, ratioString, rawRatioString = 1, 1, "", ""
    if rawCompareScore ~= 0 then
        rawRatio = rawScore / rawCompareScore
    elseif rawScore > 0 then
        rawRatio = 20
    elseif rawScore < 0 then
        rawRatio = -20
    end
    if asIsCompareScore ~= 0 then
        ratio = asIsScore / asIsCompareScore
    elseif asIsScore > 0 then
        ratio = 20
    elseif asIsScore < 0 then
        ratio = -20
    end

    local compareItemText = ""
    if compareNotCached then
        compareItemText = "Item not in cache!|n"
    elseif not compareTable then
        compareItemText = "No item in set"
    else
        compareItemText = compareTable.itemLink
    end

    if ratio ~= rawRatio then
        tt:AddDoubleLine("["..percentilize(rawRatio).."/"..percentilize(ratio).."] - "..compareItemText..extraText, set:GetName())
    else
        tt:AddDoubleLine("["..percentilize(rawRatio).."] - "..compareItemText..extraText, set:GetName())
    end
end

-- Tooltip functions
local function TooltipAddCompareLines(tt, link)
    local itemTable = TopFit:GetCachedItem(link)

    --TopFit:Debug("Adding Compare Tooltip for "..(link or "nil"))

    -- if the item is not yet cached, no tooltip info is added
    if not itemTable then
        return
    end

    -- iterate all sets and compare with set's items
    tt:AddLine(" ")
    tt:AddLine("Compared with your current items for each set:")
    local sets = ns.GetSetList()
    for _, setCode in ipairs(sets) do
        local set = ns.GetSetByID(setCode, true)
        if not TopFit.db.profile.sets[setCode].excludeFromTooltip then
            -- find current item(s) from set
            local itemPositions = GetEquipmentSetLocations(TopFit:GenerateSetName(set:GetName()))
            local itemIDs = GetEquipmentSetItemIDs(TopFit:GenerateSetName(set:GetName()))
            local itemLinks = {}
            if itemPositions then
                for slotID, itemLocation in pairs(itemPositions) do
                    if itemLocation and itemLocation ~= 1 and itemLocation ~= 0 then -- 0: set to no item; 1: slot is ignored
                        local itemLink = nil
                        local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(itemLocation)
                        if player then
                            if bank then
                                -- item is banked, use itemID
                                local itemID = GetEquipmentSetItemIDs(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))[slotID]
                                if itemID and itemID ~= 1 then
                                    _, itemLink = GetItemInfo(itemID)
                                end
                            elseif bags then
                                -- item is in player's bags
                                itemLink = GetContainerItemLink(bag, slot)
                            else
                                -- item is equipped
                                itemLink = GetInventoryItemLink("player", slot)
                            end
                        else
                            -- item not found
                        end
                        itemLinks[slotID] = itemLink
                    end
                end

                for _, slotID in pairs(itemTable.equipLocationsByType) do
                    -- get compare items sorted out
                    local itemID = nil
                    local itemLink = nil
                    local rawScore, asIsScore, rawCompareScore, asIsCompareScore = 0, 0, 0, 0
                    local extraText = ""
                    local compareTable = nil
                    local itemTable2 = nil
                    local compareTable2 = nil
                    local compareNotCached = false

                    rawScore = set:GetItemScore(itemTable.itemLink, true) -- including caps, raw score
                    asIsScore = set:GetItemScore(itemTable.itemLink, false) -- including caps, enchanted score

                    if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 and itemIDs[slotID] ~= 0 then
                        itemID = itemIDs[slotID]
                        itemLink = itemLinks[slotID]

                        if itemLink then
                            compareTable = TopFit:GetCachedItem(itemLink)
                        end

                        if compareTable then
                            rawCompareScore = set:GetItemScore(compareTable.itemLink, true)
                            asIsCompareScore = set:GetItemScore(compareTable.itemLink, false)
                        else
                            compareNotCached = true
                        end
                    end

                    -- location tables for best-in-slot requests
                    local locationTable, compLocationTable
                    if (slotID == 16 or slotID == 17) then
                        locationTable = {itemLink = itemTable.itemLink, slot = nil, bag = nil}
                        if compareTable then
                            local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(itemPositions[slotID])
                            if player then
                                if bags then
                                    compLocationTable = {itemLink = compareTable.itemLink, slot = slot, bag = bag}
                                elseif bank then
                                    compLocationTable = {itemLink = compareTable.itemLink, slot = nil, bag = nil}
                                else
                                    compLocationTable = {itemLink = compareTable.itemLink, slot = slot, bag = nil}
                                end
                            else
                                compLocationTable = {itemLink = compareTable.itemLink, slot = nil, bag = nil}
                            end
                        else
                            compLocationTable = {itemLink = "", slot = nil, bag = nil}
                        end
                    end

                    if slotID == 16 then -- main hand slot
                        if TopFit:IsOnehandedWeapon(ns.emptySet, link) then
                            -- is the weapon we compare to (if it exists) two-handed?
                            if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 and itemIDs[slotID] ~= 0 and not TopFit:IsOnehandedWeapon(ns.emptySet, itemIDs[slotID]) then
                                -- try to find a fitting offhand for better comparison
                                if TopFit.playerCanDualwield then
                                    -- find best offhand regardless of type
                                    local lTable2 = TopFit:CalculateBestInSlot(ns.emptySet, {locationTable, compLocationTable}, false, 17, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(ns.emptySet, locationTable.itemLink) end)
                                    if lTable2 then
                                        itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
                                    end
                                else
                                    -- find best offhand that is not a weapon
                                    local lTable2 = TopFit:CalculateBestInSlot(ns.emptySet, {locationTable, compLocationTable}, false, 17, setCode, function(locationTable) itemTable = TopFit:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
                                    if lTable2 then
                                        itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
                                    end
                                end
                            else
                            end
                        else
                            if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 then
                                -- mainhand is set
                                if TopFit:IsOnehandedWeapon(ns.emptySet, itemIDs[slotID]) then
                                    -- use offhand of that set as second compare item
                                    if (itemLinks[17]) then
                                        compareTable2 = TopFit:GetCachedItem(itemLinks[17])
                                    end
                                else
                                    -- compare normally, these are 2 two-handed weapons
                                end
                            else
                                -- compare with offhand if appliccapble
                                if (itemLinks[17]) then
                                    compareTable2 = TopFit:GetCachedItem(itemLinks[17])
                                end
                            end
                        end
                    elseif slotID == 17 then -- offhand slot
                        -- find a valid mainhand to use in comparisons (only when comparing to a 2h)
                        if itemIDs and itemIDs[16] and itemIDs[16] ~= 1 and not TopFit:IsOnehandedWeapon(ns.emptySet, itemIDs[16]) then
                            local lTable2 = TopFit:CalculateBestInSlot(ns.emptySet, {locationTable, compLocationTable}, false, 16, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(ns.emptySet, locationTable.itemLink) end)
                            if lTable2 then
                                itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
                            end

                            -- also set compareTable to the relevant MAIN HAND! since offhand is empty, obviously
                            compareTable = TopFit:GetCachedItem(itemLinks[16])

                            if compareTable then
                                rawCompareScore = set:GetItemScore(compareTable.itemLink, true)
                                asIsCompareScore = set:GetItemScore(compareTable.itemLink, false)
                            else
                                compareNotCached = true
                            end
                        end
                    end

                    if itemTable2 then
                        rawScore = rawScore + set:GetItemScore(itemTable2.itemLink, true)
                        asIsScore = asIsScore + set:GetItemScore(itemTable2.itemLink, false)

                        extraText = extraText..", if you also use "..itemTable2.itemLink
                    end

                    if compareTable2 then
                        rawCompareScore = rawCompareScore + set:GetItemScore(compareTable2.itemLink, true)
                        asIsCompareScore = asIsCompareScore + set:GetItemScore(compareTable2.itemLink, false)

                        extraText = extraText..", "..compareTable2.itemLink
                    end

                    local ratio, rawRatio, ratioString, rawRatioString = 1, 1, "", ""
                    if rawCompareScore ~= 0 then
                        rawRatio = rawScore / rawCompareScore
                    elseif rawScore > 0 then
                        rawRatio = 20
                    elseif rawScore < 0 then
                        rawRatio = -20
                    end
                    if asIsCompareScore ~= 0 then
                        ratio = asIsScore / asIsCompareScore
                    elseif asIsScore > 0 then
                        ratio = 20
                    elseif asIsScore < 0 then
                        ratio = -20
                    end

                    local compareItemText = ""
                    if compareNotCached then
                        compareItemText = "Item not in cache!|n"
                    elseif not compareTable then
                        compareItemText = "No item in set"
                    else
                        compareItemText = compareTable.itemLink
                    end

                    if ratio ~= rawRatio then
                        tt:AddDoubleLine("["..percentilize(rawRatio).."/"..percentilize(ratio).."] - "..compareItemText..extraText, set:GetName())
                    else
                        tt:AddDoubleLine("["..percentilize(rawRatio).."] - "..compareItemText..extraText, set:GetName())
                    end
                end
            end
        end
    end
end

local function TooltipAddNewLines(tt, link)
    if not (TopFit.db.profile.debugMode) then return end

    local itemTable = TopFit:GetCachedItem(link)
    local lines = TopFit:getComparisonTooltipLines(itemTable)

    for _, line in ipairs(lines) do
        if (#line == 1) then
            tt:AddLine(line[1], 0.5, 0.9, 1)
        else
            tt:AddDoubleLine(line[1], line[2], 0.5, 0.9, 1)
        end
    end
end

local function TooltipAddLines(tt, link)
    local itemTable = TopFit:GetCachedItem(link)

    if not itemTable then return end

    if (TopFit.db.profile.debugMode) then
        -- item stats
        tt:AddLine("Item stats as seen by TopFit:", 0.5, 0.9, 1)
        for stat, value in pairs(itemTable["itemBonus"]) do
            if not string.find(stat, "SET: ") then
                local valueString = ""
                local first = true
                for _, setTable in pairs(TopFit.db.profile.sets) do
                    local weightedValue = (setTable.weights[stat] or 0) * value
                    if first then
                        first = false
                    else
                        valueString = valueString.." / "
                    end
                    valueString = valueString..(tonumber(weightedValue) or "0")
                end
                tt:AddDoubleLine("  +"..(value or 0).." "..(_G[stat] or "Unknown stat"), valueString, 0.5, 0.9, 1)
            end
        end

        -- enchantment stats
        if (itemTable["enchantBonus"]) then
            tt:AddLine("Enchant:", 1, 0.9, 0.5)
            for stat, value in pairs(itemTable["enchantBonus"]) do
                local valueString = ""
                local first = true
                for _, setTable in pairs(TopFit.db.profile.sets) do
                    local weightedValue = (setTable.weights[stat] or 0) * value
                    if first then
                        first = false
                    else
                        valueString = valueString.." / "
                    end
                    valueString = valueString..(tonumber(weightedValue) or "0")
                end
                tt:AddDoubleLine("  +"..(value or 0).." "..(_G[stat] or "Unknown stat"), valueString, 1, 0.9, 0.5)
            end
        end

        -- gems
        if (itemTable["gemBonus"]) then
            local first = true
            for stat, value in pairs(itemTable["gemBonus"]) do
                if first then
                    first = false
                    tt:AddLine("Gems:", 0.8, 0.2, 0)
                end

                local valueString = ""
                local first = true
                for _, setTable in pairs(TopFit.db.profile.sets) do
                    local weightedValue = (setTable.weights[stat] or 0) * value
                    if first then
                        first = false
                    else
                        valueString = valueString.." / "
                    end
                    valueString = valueString..(tonumber(weightedValue) or "0")
                end
                tt:AddDoubleLine("  +"..(value or 0).." "..(_G[stat] or "Unknown stat"), valueString, 0.8, 0.2, 0)
            end
        end

        -- reforging
        if (itemTable["reforgeBonus"]) then
            local first = true
            for stat, value in pairs(itemTable["reforgeBonus"]) do
                if first then
                    first = false
                    tt:AddLine("Reforging:", 0.8, 0.8, 0)
                end

                local valueString = ""
                local first = true
                for _, setTable in pairs(TopFit.db.profile.sets) do
                    local weightedValue = (setTable.weights[stat] or 0) * value
                    if first then
                        first = false
                    else
                        valueString = valueString.." / "
                    end
                    valueString = valueString..(tonumber(weightedValue) or "0")
                end
                tt:AddDoubleLine("  +"..(value or 0).." "..(_G[stat] or "Unknown stat"), valueString, 0.8, 0.8, 0)
            end
        end
    end

    if (TopFit.db.profile.showTooltip) then
        -- scores for sets
        local first = true
        local sets = ns.GetSetList()
        for _, setCode in pairs(sets) do
            local set = ns.GetSetByID(setCode)
            if set:GetDisplayInTooltip() then
                if first then
                    first = false
                    tt:AddLine("Set Values:", 0.6, 1, 0.7)
                end

                tt:AddLine(string.format("  %.2f - %s", set:GetItemScore(itemTable.itemLink), set:GetName()), 0.6, 1, 0.7)
            end
        end
    end
end

local clearedSemaphores = {}
local function OnTooltipCleared(self, semaphore)
    clearedSemaphores[semaphore] = nil
end

local function OnTooltipSetItem(self, semaphore, skipCompareLines)
    if not clearedSemaphores[semaphore] then
        local name, link = self:GetItem()
        if (name) then
            if IsEquippableItem(link) and not ns.Unfit:IsItemUnusable(link) then
                TooltipAddLines(self, link)
                if (TopFit.db.profile.showComparisonTooltip and not TopFit.isBlocked and not skipCompareLines) then
                    TooltipAddCompareLines(self, link)
                end
                TooltipAddNewLines(self, link)
            end
            clearedSemaphores[semaphore] = true
        end
    end
end

-- hook all tooltips that interest us
GameTooltip:HookScript("OnTooltipCleared", function(self) OnTooltipCleared(self, "item") end)
GameTooltip:HookScript("OnTooltipSetItem", function(self) OnTooltipSetItem(self, "item") end)
ItemRefTooltip:HookScript("OnTooltipCleared", function(self) OnTooltipCleared(self, "ref") end)
ItemRefTooltip:HookScript("OnTooltipSetItem", function(self) OnTooltipSetItem(self, "ref") end)
-- shopping tooltips are set to skip compare lines because usually the equipped items are identical to our set's items anyways
ShoppingTooltip1:HookScript("OnTooltipCleared", function(self) OnTooltipCleared(self, "shopping1") end)
ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self) OnTooltipSetItem(self, "shopping1", true) end)
ShoppingTooltip2:HookScript("OnTooltipCleared", function(self) OnTooltipCleared(self, "shopping2") end)
ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self) OnTooltipSetItem(self, "shopping2", true) end)
