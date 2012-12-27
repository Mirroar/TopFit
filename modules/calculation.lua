local addonName, ns, _ = ...

function ns:StartCalculations()
    -- generate table of set codes
    ns.workSetList = {}
    for setCode, _ in pairs(self.db.profile.sets) do
        tinsert(ns.workSetList, setCode)
    end

    ns:CalculateSets()
end

function ns:AbortCalculations()
    if ns.isBlocked then
        ns.abortCalculation = true
    end
end

function ns:CalculateSets(silent)
    if (not ns.isBlocked) then
        local setCode = tremove(ns.workSetList)
        while not ns.db.profile.sets[setCode] and #(ns.workSetList) > 0 do
            setCode = tremove(ns.workSetList)
        end

        if ns.db.profile.sets[setCode] then
            ns.setCode = setCode -- globally save the current set that is being calculated

            local set = ns.Set.CreateFromSavedVariables(ns.db.profile.sets[setCode])
            local calculation = ns.DefaultCalculation(set)
            calculation:SetOperationsPerFrame(500)

            ns:Debug("Calculating items for "..set:GetName())

            -- set as working to prevent any further calls from "interfering" --TODO: remove
            ns.isBlocked = true

            -- copy caps
            set.calculationData.ignoreCapsForCalculation = false
            set.calculationData.silentCalculation = silent

            -- do the actual work
            ns:collectItems() -- TODO: change so it just adds all available items to the calculation

            calculation:Start()
        end
    end
end

--start calculation for setName
function ns.CalculateRecommendations(set)
    ns.itemRecommendations = {}
    ns.currentItemCombination = {}
    ns.itemCombinations = {}
    ns.currentSetName = set:GetName() -- TODO: remove; currently used by core.lua:OnUpdateForEquipment

    -- save equippable items
    ns.itemListBySlot = ns:GetEquippableItems()
    ns.ReduceItemList(set, ns.itemListBySlot)

    set.calculationData.slotCounters = {}
    set.calculationData.combinationCount = 0
    set.calculationData.bestCombination = nil
    set.calculationData.maxScore = nil

    set.calculationData.capHeuristics = {}
    -- create maximum values for each cap and item slot
    for statCode, _ in pairs(set:GetHardCaps()) do
        set.calculationData.capHeuristics[statCode] = {}
        for _, slotID in pairs(ns.slots) do
            if (ns.itemListBySlot[slotID]) then
                -- get maximum value contributed to cap in this slot
                local maxStat = 0
                for _, locationTable in pairs(ns.itemListBySlot[slotID]) do
                    local itemTable = ns:GetCachedItem(locationTable.itemLink)
                    if itemTable then
                        local thisStat = itemTable.totalBonus[statCode] or 0

                        if thisStat > maxStat then
                            maxStat = thisStat
                        end
                    end
                end

                set.calculationData.capHeuristics[statCode][slotID] = maxStat
            end
        end
    end

    -- cache up to which slot unique items are available
    ns.moreUniquesAvailable = {}
    local uniqueFound = false
    for slotID = 20, 0, -1 do
        if uniqueFound then
            ns.moreUniquesAvailable[slotID] = true
        else
            ns.moreUniquesAvailable[slotID] = false
            if (ns.itemListBySlot[slotID]) then
                for _, locationTable in pairs(ns.itemListBySlot[slotID]) do
                    local itemTable = ns:GetCachedItem(locationTable.itemLink)
                    if itemTable then
                        for statCode, _ in pairs(itemTable.totalBonus) do
                            if (string.sub(statCode, 1, 8) == "UNIQUE: ") then
                                uniqueFound = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    ns:ResetProgress()
end

function ns.ReduceItemList(set, itemList)
    -- remove all non-forced items from item list
    for slotID, _ in pairs(ns.slotNames) do
        local forcedItems = ns:GetForcedItems(ns.setCode, slotID)
        if itemList[slotID] and #forcedItems > 0 then
            for i = #(itemList[slotID]), 1, -1 do
                local itemTable = ns:GetCachedItem(itemList[slotID][i].itemLink)
                if not itemTable then
                    tremove(itemList[slotID], i)
                else
                    local found = false
                    for _, forceID in pairs(forcedItems) do
                        if forceID == itemTable.itemID then
                            found = true
                            break
                        end
                    end

                    if not found then
                        tremove(itemList[slotID], i)
                    end
                end
            end
        end

        if (slotID == 17 and #forcedItems > 0) then -- offhand
            --TODO: check if forced item is a weapon and remove all weapons from mainhand if player cannot dualwield
            -- always remove all 2H-weapons from mainhand
            for i = #(itemList[16]), 1, -1 do
                if (not ns:IsOnehandedWeapon(set, itemList[16][i].itemLink)) then
                    tremove(itemList[16], i)
                end
            end
        end
    end

    -- if enabled, remove armor that is not part of armor specialization
    if ns.db.profile.sets[ns.setCode].forceArmorType and ns.characterLevel >= 50 then
        local playerClass = select(2, UnitClass("player"))
        for slotID, _ in pairs(ns.armoredSlots) do
            if itemList[slotID] and #(ns:GetForcedItems(ns.setCode, slotID)) == 0 then
                for i = #(itemList[slotID]), 1, -1 do
                    local itemTable = ns:GetCachedItem(itemList[slotID][i].itemLink)
                    if playerClass == "DRUID" or playerClass == "ROGUE" or playerClass == "MONK" then
                        if not itemTable or not itemTable.totalBonus["TOPFIT_ARMORTYPE_LEATHER"] then
                            tremove(itemList[slotID], i)
                        end
                    elseif playerClass == "HUNTER" or playerClass == "SHAMAN" then
                        if not itemTable or not itemTable.totalBonus["TOPFIT_ARMORTYPE_MAIL"] then
                            tremove(itemList[slotID], i)
                        end
                    elseif playerClass == "WARRIOR" or playerClass == "DEATHKNIGHT" or playerClass == "PALADIN" then
                        if not itemTable or not itemTable.totalBonus["TOPFIT_ARMORTYPE_PLATE"] then
                            tremove(itemList[slotID], i)
                        end
                    end
                end
            end
        end
    end

    -- remove all items with score <= 0 that are neither forced nor contribute to caps
    for slotID, itemList in pairs(itemList) do
        if #itemList >= 1 then
            for i = #itemList, 1, -1 do
                if (ns:GetItemScore(itemList[i].itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) <= 0) then
                    if #(ns:GetForcedItems(ns.setCode, slotID)) == 0 then
                        -- check caps
                        local hasCap = false
                        for statCode, _ in pairs(set:GetHardCaps()) do
                            local itemTable = ns:GetCachedItem(itemList[i].itemLink)
                            if itemTable and (itemTable.totalBonus[statCode] or -1) > 0 then
                                hasCap = true
                                break
                            end
                        end

                        if not hasCap then
                            tremove(itemList, i)
                            --itemList[i].reason = itemList[i].reason.."score <= 0, no cap contribution and not forced; "
                        end
                    end
                end
            end
        end
    end

    -- remove BoE items
    for slotID, itemList in pairs(itemList) do
        if #itemList > 0 then
            for i = #itemList, 1, -1 do
                if itemList[i].isBoE then
                    tremove(itemList, i)
                    --itemList[i].reason = itemList[i].reason.."BoE item; "
                end
            end
        end
    end

    -- preprocess unique items - so we are able to remove items when uniqueness doesn't matter in the next step
    -- step 1: sum up the number of unique items for each uniqueness family
    local preprocessUniqueness = {}
    for slotID, itemList in pairs(itemList) do
        if #itemList > 1 then
            for i = #itemList, 1, -1 do
                local itemTable = TopFit:GetCachedItem(itemList[i].itemLink)
                if itemTable then
                    for stat, value in pairs(itemTable.totalBonus) do
                        if (string.sub(stat, 1, 8) == "UNIQUE: ") then
                            preprocessUniqueness[stat] = (preprocessUniqueness[stat] or 0) + value
                        end
                    end
                end
            end
        end
    end

    -- step 2: remember all uniqueness families where uniqueness could actually be violated
    local problematicUniqueness = {}
    for stat, value in pairs(preprocessUniqueness) do
        local _, maxCount = strsplit("*", stat)
        maxCount = tonumber(maxCount)
        if value > maxCount then
            problematicUniqueness[stat] = true
        end
    end

    -- reduce item list: remove items with < cap and < score
    for slotID, itemList in pairs(itemList) do
        if #itemList > 1 then
            for i = #itemList, 1, -1 do
                local itemTable = ns:GetCachedItem(itemList[i].itemLink)
                if not itemTable then
                    tremove(itemList, i)
                else
                    -- try to see if an item exists which is definitely better
                    local betterItemExists = 0
                    local numBetterItemsNeeded = 1

                    -- For items that can be used in 2 slots, we also need at least 2 better items to declare an item useless
                    if (slotID == 17) -- offhand
                        or (slotID == 12) -- ring 2
                        or (slotID == 14) -- trinket 2
                        then

                        numBetterItemsNeeded = 2
                    end

                    for j = 1, #itemList do
                        if i ~= j then
                            local compareTable = ns:GetCachedItem(itemList[j].itemLink)
                            if compareTable and
                                (ns:GetItemScore(itemTable.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) < ns:GetItemScore(compareTable.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation)) and
                                (itemTable.itemEquipLoc == compareTable.itemEquipLoc) then -- especially important for weapons, we do not want to compare 2h and 1h weapons

                                --ns:Debug("score: "..ns:GetItemScore(itemTable.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation).."; compareScore: "..ns:GetItemScore(compareTable.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation)..
                                --    " when comparing "..itemTable.itemLink.." with "..compareTable.itemLink)

                                -- score is greater, see if caps are also better
                                local allStats = true
                                for statCode, _ in pairs(set:GetHardCaps()) do
                                    if (itemTable.totalBonus[statCode] or 0) > (compareTable.totalBonus[statCode] or 0) then
                                        allStats = false
                                        break
                                    end
                                end

                                if allStats then
                                    -- items with a problematic uniqueness are special and don't count as a better item
                                    for stat, _ in pairs(itemTable.totalBonus) do
                                        if (string.sub(stat, 1, 8) == "UNIQUE: ") and problematicUniqueness[stat] then
                                            allStats = false
                                        end
                                    end

                                    if allStats then
                                        betterItemExists = betterItemExists + 1
                                        if (betterItemExists >= numBetterItemsNeeded) then
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if betterItemExists >= numBetterItemsNeeded then
                        -- remove this item
                        --ns:Debug(itemTable.itemLink.." removed because "..betterItemExists.." better items found.")
                        tremove(itemList, i)
                        --itemList[i].reason = itemList[i].reason..betterItemExists.." better items found (setCode: "..(ns.setCode or "nil").."; relevantScore: "..(set.calculationData.ignoreCapsForCalculation or "nil").."); "
                    end
                end
            end
        end
    end
end

function TopFit:IsCapsReached(set, currentSlot)
    local currentValues = {}
    local i
    for i = 1, currentSlot do
        if set.calculationData.slotCounters[i] ~= nil and set.calculationData.slotCounters[i] > 0 and TopFit.itemListBySlot[i][set.calculationData.slotCounters[i]] then
            for stat, _ in pairs(set:GetHardCaps()) do
                local itemTable = TopFit:GetCachedItem(TopFit.itemListBySlot[i][set.calculationData.slotCounters[i]].itemLink)
                if itemTable then
                    currentValues[stat] = (currentValues[stat] or 0) + (itemTable.totalBonus[stat] or 0)
                end
            end
        end
    end

    for stat, value in pairs(set:GetHardCaps()) do
        if (currentValues[stat] or 0) < value then
            return false
        end
    end
    return true
end

function TopFit:IsCapsUnreachable(set, currentSlot)
    local currentValues = {}
    local restValues = {}
    local i
    for stat, value in pairs(set:GetHardCaps()) do
        for i = 1, currentSlot do
            if set.calculationData.slotCounters[i] ~= nil and set.calculationData.slotCounters[i] > 0 and TopFit.itemListBySlot[i][set.calculationData.slotCounters[i]] then
                local itemTable = TopFit:GetCachedItem(TopFit.itemListBySlot[i][set.calculationData.slotCounters[i]].itemLink)
                if itemTable then
                    currentValues[stat] = (currentValues[stat] or 0) + (itemTable.totalBonus[stat] or 0)
                end
            end
        end

        for i = currentSlot + 1, 19 do
            restValues[stat] = (restValues[stat] or 0) + (set.calculationData.capHeuristics[stat][i] or 0)
        end

        if (currentValues[stat] or 0) + (restValues[stat] or 0) < value then
            TopFit:Debug("|cffff0000Caps unreachable - "..stat.." reached "..(currentValues[stat] or 0).." + "..(restValues[stat] or 0).." / "..value)
            return true
        end
    end
    return false
end

function TopFit:UniquenessViolated(set, currentSlot)
    local currentValues = {}
    local i
    for i = 1, currentSlot do
        if set.calculationData.slotCounters[i] ~= nil and set.calculationData.slotCounters[i] > 0 and TopFit.itemListBySlot[i][set.calculationData.slotCounters[i]] then
            for stat, _ in pairs(set:GetHardCaps()) do
                local itemTable = TopFit:GetCachedItem(TopFit.itemListBySlot[i][set.calculationData.slotCounters[i]].itemLink)
                if itemTable then
                    currentValues[stat] = (currentValues[stat] or 0) + (itemTable.totalBonus[stat] or 0)
                end
            end
        end
    end

    for stat, value in pairs(currentValues) do
        if (string.sub(stat, 1, 8) == "UNIQUE: ") then
            local _, maxCount = strsplit("*", stat)
            maxCount = tonumber(maxCount)
            if value > maxCount then
                return true
            end
        end
    end
    return false
end

function TopFit:MoreUniquesAvailable(currentSlot)
    return TopFit.moreUniquesAvailable[currentSlot]
end

function TopFit:IsDuplicateItem(set, currentSlot)
    -- check if the item is already equipped in another slot
    local i
    for i = 1, currentSlot - 1 do
        if set.calculationData.slotCounters[i] and set.calculationData.slotCounters[i] > 0 then
            local lTable1 = TopFit.itemListBySlot[i][set.calculationData.slotCounters[i]]
            local lTable2 = TopFit.itemListBySlot[currentSlot][set.calculationData.slotCounters[currentSlot]]
            if lTable1 and lTable2 and lTable1.itemLink == lTable2.itemLink and lTable1.bag == lTable2.bag and lTable1.slot == lTable2.slot then
                return true
            end
        end
    end
    return false
end

function TopFit:IsOffhandValid(set, currentSlot)
    if currentSlot == 17 then -- offhand slot
        if (set.calculationData.slotCounters[17] ~= nil) and (set.calculationData.slotCounters[17] > 0) and (set.calculationData.slotCounters[17] <= #(TopFit.itemListBySlot[17])) then -- offhand is set to something
            if (set.calculationData.slotCounters[16] == nil or set.calculationData.slotCounters[16] == 0) or -- no Mainhand is forced
                (TopFit:IsOnehandedWeapon(set, TopFit.itemListBySlot[16][set.calculationData.slotCounters[16]].itemLink)) then -- Mainhand is not a Two-Handed Weapon

                local itemTable = TopFit:GetCachedItem(TopFit.itemListBySlot[17][set.calculationData.slotCounters[17]].itemLink)
                if not itemTable then return false end

                if (not set:CanDualWield()) then
                    if (string.find(itemTable.itemEquipLoc, "WEAPON")) then
                        -- no weapon in offhand if you cannot dualwield
                        return false
                    end
                else -- player can dualwield
                    if (not TopFit:IsOnehandedWeapon(set, itemTable.itemID)) then
                        -- no 2h-weapon in offhand
                        return false
                    end
                end
            else
                -- a 2H-Mainhand is set, there can be no offhand!
                return false
            end
        end
    end
    return true
end

function ns:SaveCurrentCombination(set)
    set.calculationData.combinationCount = set.calculationData.combinationCount + 1

    local cIC = {
        items = {},
        totalScore = 0,
        totalStats = {},
    }

    local itemsAlreadyChosen = {}

    local i
    for i = 1, 20 do
        local itemTable, locationTable = nil, nil
        local stat, slotTable

        if set.calculationData.slotCounters[i] ~= nil and set.calculationData.slotCounters[i] > 0 then
            locationTable = ns.itemListBySlot[i][set.calculationData.slotCounters[i]]
            itemTable = ns:GetCachedItem(locationTable.itemLink)
        else
            -- choose highest valued item for otherwise empty slots, if possible
            locationTable = ns:CalculateBestInSlot(set, itemsAlreadyChosen, false, i)
            if locationTable then
                itemTable = ns:GetCachedItem(locationTable.itemLink)
            end

            if (itemTable) then
                -- special cases for main an offhand (to account for dualwielding and Titan's Grip)
                if (i == 16) then
                    -- check if offhand is forced
                    if set.calculationData.slotCounters[17] then
                        -- use 1H-weapon in Mainhand (or a titan's grip 2H, if applicable)
                        locationTable = ns:CalculateBestInSlot(set, itemsAlreadyChosen, false, i, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(set, locationTable.itemLink) end)
                        if locationTable then
                            itemTable = ns:GetCachedItem(locationTable.itemLink)
                        end
                    else
                        -- choose best main- and offhand combo
                        if not ns:IsOnehandedWeapon(set, itemTable.itemID) then
                            -- see if a combination of main and offhand would have a better score
                            local bestMainScore, bestOffScore = 0, 0
                            local bestOff = nil
                            local bestMain = ns:CalculateBestInSlot(set, itemsAlreadyChosen, false, i, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(set, locationTable.itemLink) end)
                            if bestMain ~= nil then
                                bestMainScore = (ns:GetItemScore(bestMain.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) or 0)
                            end
                            if (set:CanDualWield()) then
                                -- any non-two-handed offhand is fine
                                bestOff = ns:CalculateBestInSlot(set, ns:JoinTables(itemsAlreadyChosen, {bestMain}), false, i + 1, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(set, locationTable.itemLink) end)
                            else
                                -- offhand may not be a weapon (only shield, other offhand...)
                                bestOff = ns:CalculateBestInSlot(set, ns:JoinTables(itemsAlreadyChosen, {bestMain}), false, i + 1, ns.setCode, function(locationTable) local itemTable = ns:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
                            end
                            if bestOff ~= nil then
                                bestOffScore = (ns:GetItemScore(bestOff.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) or 0)
                            end

                            -- alternatively, calculate offhand first, then mainhand
                            local bestMainScore2, bestOffScore2 = 0, 0
                            local bestMain2 = nil
                            local bestOff2 = nil
                            if (set:CanDualWield()) then
                                -- any non-two-handed offhand is fine
                                bestOff2 = ns:CalculateBestInSlot(set, itemsAlreadyChosen, false, i + 1, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(set, locationTable.itemLink) end)
                            else
                                -- offhand may not be a weapon (only shield, other offhand...)
                                bestOff2 = ns:CalculateBestInSlot(set, itemsAlreadyChosen, false, i + 1, ns.setCode, function(locationTable) local itemTable = ns:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
                            end
                            if bestOff2 ~= nil then
                                bestOffScore2 = (ns:GetItemScore(bestOff2.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) or 0)
                            end

                            bestMain2 = ns:CalculateBestInSlot(set, ns:JoinTables(itemsAlreadyChosen, {bestOff2}), false, i, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(set, locationTable.itemLink) end)
                            if bestMain2 ~= nil then
                                bestMainScore2 = (ns:GetItemScore(bestMain2.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) or 0)
                            end

                            local maxScore = (ns:GetItemScore(itemTable.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) or 0)
                            if (maxScore < (bestMainScore + bestOffScore)) then
                                -- main- + offhand is better, use the one-handed mainhand
                                locationTable = bestMain
                                if locationTable then
                                    itemTable = ns:GetCachedItem(locationTable.itemLink)
                                end
                                maxScore = bestMainScore + bestOffScore
                                --ns:Debug("Choosing Mainhand "..itemTable.itemLink)
                            end
                            if (maxScore < (bestMainScore2 + bestOffScore2)) then
                                -- main- + offhand is better, use the one-handed mainhand
                                locationTable = bestMain2
                                if locationTable then
                                    itemTable = ns:GetCachedItem(locationTable.itemLink)
                                end
                                --ns:Debug("Choosing Mainhand "..itemTable.itemLink)
                            end
                        end -- if mainhand would not be twohanded anyway, it can just be used
                    end
                elseif (i == 17) then
                    -- check if mainhand is empty or one-handed
                    if (not cIC.items[i - 1]) or (ns:IsOnehandedWeapon(set, cIC.items[i - 1].itemLink)) then
                        -- check if player can dual wield
                        if set:CanDualWield() then
                            -- only use 1H-weapons in Offhand
                            locationTable = ns:CalculateBestInSlot(set, itemsAlreadyChosen, false, i, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(set, locationTable.itemLink) end)
                            if locationTable then
                                itemTable = ns:GetCachedItem(locationTable.itemLink)
                            end
                        else
                            -- player cannot dualwield, only use offhands which are not weapons
                            locationTable = ns:CalculateBestInSlot(set, itemsAlreadyChosen, false, i, ns.setCode, function(locationTable) local itemTable = ns:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
                            if locationTable then
                                itemTable = ns:GetCachedItem(locationTable.itemLink)
                            end
                        end
                    else
                        -- Two-handed mainhand means we leave offhand empty
                        locationTable = nil
                        itemTable = nil
                    end
                end
            end
        end

        if locationTable and itemTable then -- slot will be filled
            tinsert(itemsAlreadyChosen, locationTable)
            cIC.items[i] = locationTable
            cIC.totalScore = cIC.totalScore + (ns:GetItemScore(itemTable.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) or 0)

            -- add total stats
            for stat, value in pairs(itemTable.totalBonus) do
                cIC.totalStats[stat] = (cIC.totalStats[stat] or 0) + value
            end
        end
    end

    -- check all caps one last time and see if all are reached
    local satisfied = true
    for stat, value in pairs(set:GetHardCaps()) do
        if ((not cIC.totalStats[stat]) or (cIC.totalStats[stat] < value)) then
            satisfied = false
            break
        end
    end

    -- check if any uniqueness contraints are broken
    if not set.calculationData.ignoreCapsForCalculation then
        for stat, value in pairs(cIC.totalStats) do
            if (string.sub(stat, 1, 8) == "UNIQUE: ") then
                local _, maxCount = strsplit("*", stat)
                maxCount = tonumber(maxCount)
                if value > maxCount then
                    satisfied = false
                    break
                end
            end
        end--]]
    end

    -- check if it's better than old best
    if ((satisfied) and ((set.calculationData.maxScore == nil) or (set.calculationData.maxScore < cIC.totalScore))) then
        set.calculationData.maxScore = cIC.totalScore
        set.calculationData.bestCombination = cIC

        ns.debugSlotCounters = {} -- save slot counters for best combination
        for i = 1, 20 do
            ns.debugSlotCounters[i] = set.calculationData.slotCounters[i]
        end
    end
end

-- now with assertion as optional parameter
function ns:CalculateBestInSlot(set, itemsAlreadyChosen, insert, sID, setCode, assertion)
    if not setCode then setCode = ns.setCode end

    -- get best item(s) for each equipment slot
    local bis = {}
    local itemListBySlot = ns.itemListBySlot or ns:GetEquippableItems()
    for slotID, itemsTable in pairs(itemListBySlot) do
        if ((not sID) or (sID == slotID)) then -- use single slot if sID is set, or all slots
            bis[slotID] = {}
            local maxScore = nil

            -- iterate all items of given location
            for _, locationTable in pairs(itemsTable) do
                local itemTable = ns:GetCachedItem(locationTable.itemLink)

                if (itemTable and ((maxScore == nil) or (maxScore < ns:GetItemScore(itemTable.itemLink, setCode, set.calculationData.ignoreCapsForCalculation))) -- score
                    and (itemTable.itemMinLevel <= ns.characterLevel or locationTable.isVirtual)) -- character level
                    and (not assertion or assertion(locationTable)) then -- optional assertion is true
                    -- also check if item has been chosen already (so we don't get the same ring / trinket twice)
                    local found = false
                    if (itemsAlreadyChosen) then
                        for _, lTable in pairs(itemsAlreadyChosen) do
                            if ((not lTable.bag and not lTable.slot) or ((lTable.bag == locationTable.bag) and (lTable.slot == locationTable.slot))) and (lTable.itemLink == locationTable.itemLink) then
                                found = true
                            end
                        end
                    end

                    if not found then
                        bis[slotID].locationTable = locationTable
                        maxScore = ns:GetItemScore(itemTable.itemLink, setCode, set.calculationData.ignoreCapsForCalculation)
                    end
                end
            end

            if (not bis[slotID].locationTable) then
                -- remove dummy table if no item has been found
                bis[slotID] = nil
            else
                -- mark this item as used
                if (itemsAlreadyChosen and insert) then
                    tinsert(itemsAlreadyChosen, bis[slotID].locationTable)
                end
            end
        end
    end

    if (not sID) then
        return bis
    else
        -- return only the slot item's table (if it exists)
        if (bis[sID]) then
            return bis[sID].locationTable
        else
            return nil
        end
    end
end

function TopFit:IsOnehandedWeapon(set, itemID)
    _, _, _, _, _, class, subclass, _, equipSlot, _, _ = GetItemInfo(itemID)
    if equipSlot and string.find(equipSlot, "2HWEAPON") then
        if (set:CanTitansGrip()) then
            local polearms = select(7, GetAuctionItemSubClasses(1))
            local staves = select(10, GetAuctionItemSubClasses(1))
            local fishingPoles = select(17, GetAuctionItemSubClasses(1))
            if (subclass == polearms) or -- Polearms
                (subclass == staves) or -- Staves
                (subclass == fishingPoles) then -- Fishing Poles

                return false
            end
        else
            return false
        end
    elseif equipSlot and string.find(equipSlot, "RANGED") then
        local wands = select(16, GetAuctionItemSubClasses(1))
        if (subclass == wands) then
            return true
        end
        return false
    end
    return true
end

function TopFit.EquipRecommendedItems(set)
    -- skip equipping if virtual items were included
    if (not TopFit.db.profile.sets[TopFit.setCode].skipVirtualItems) and TopFit.db.profile.sets[TopFit.setCode].virtualItems and #(TopFit.db.profile.sets[TopFit.setCode].virtualItems) > 0 then
        TopFit:Print(TopFit.locale.NoticeVirtualItemsUsed)

        -- reenable options and quit
        TopFit:StoppedCalculation()
        TopFit.isBlocked = false

        -- reset relevant score field
        set.calculationData.ignoreCapsForCalculation = nil

        -- initiate next calculation if necessary
        if (#TopFit.workSetList > 0) then
            TopFit:CalculateSets()
        end
        return
    end

    -- equip them
    TopFit.updateEquipmentCounter = 10000
    TopFit.equipRetries = 0
    TopFit.updateFrame.currentlyEquippingSet = set
    TopFit.updateFrame:SetScript("OnUpdate", TopFit.onUpdateForEquipment)
end

function TopFit.onUpdateForEquipment(frame, elapsed)
    local set = frame.currentlyEquippingSet

    -- don't try equipping in combat or while dead
    if UnitAffectingCombat("player") or UnitIsDeadOrGhost("player") then
        return
    end

    -- see if all items already fit
    allDone = true
    for slotID, recTable in pairs(TopFit.itemRecommendations) do
        if (TopFit:GetItemScore(recTable.locationTable.itemLink, TopFit.setCode, set.calculationData.ignoreCapsForCalculation) > 0) then
            slotItemLink = GetInventoryItemLink("player", slotID)
            if (slotItemLink ~= recTable.locationTable.itemLink) then
                allDone = false
            end
        end
    end

    TopFit.updateEquipmentCounter = TopFit.updateEquipmentCounter + elapsed

    -- try equipping the items every 100 frames (some weird ring positions might stop us from correctly equipping items on the first try, for example)
    if (TopFit.updateEquipmentCounter > 1) then
        for slotID, recTable in pairs(TopFit.itemRecommendations) do
            slotItemLink = GetInventoryItemLink("player", slotID)
            if (slotItemLink ~= recTable.locationTable.itemLink) then
                -- find itemLink in bags
                local itemTable = nil
                local found = false
                local foundBag, foundSlot
                for bag = 0, 4 do
                    for slot = 1, GetContainerNumSlots(bag) do
                        local itemLink = GetContainerItemLink(bag,slot)

                        if itemLink == recTable.locationTable.itemLink then
                            foundBag = bag
                            foundSlot = slot
                            found = true
                            break
                        end
                    end
                end

                if not found then
                    -- try to find item in equipped items
                    for _, invSlot in pairs(TopFit.slots) do
                        local itemLink = GetInventoryItemLink("player", invSlot)

                        if itemLink == recTable.locationTable.itemLink then
                            foundBag = nil
                            foundSlot = invSlot
                            found = true
                            break
                        end
                    end
                end

                if not found then
                    TopFit:Print(string.format(TopFit.locale.ErrorItemNotFound, recTable.locationTable.itemLink))
                    TopFit.itemRecommendations[slotID] = nil
                else
                    -- try equipping the item again
                    --TODO: if we try to equip offhand, and mainhand is two-handed, and no titan's grip, unequip mainhand first
                    ClearCursor()
                    if foundBag then
                        PickupContainerItem(foundBag, foundSlot)
                    else
                        PickupInventoryItem(foundSlot)
                    end
                    EquipCursorItem(slotID)
                end
            end
        end

        TopFit.updateEquipmentCounter = 0
        TopFit.equipRetries = TopFit.equipRetries + 1
    end

    -- if all items have been equipped, save equipment set and unregister script
    -- also abort if it takes to long, just save the items that _have_ been equipped
    if ((allDone) or (TopFit.equipRetries > 5)) then
        frame.currentlyEquippingSet = nil

        if (not allDone) then
            TopFit:Print(TopFit.locale.NoticeEquipFailure)

            for slotID, recTable in pairs(TopFit.itemRecommendations) do
                slotItemLink = GetInventoryItemLink("player", slotID)
                if (slotItemLink ~= recTable.locationTable.itemLink) then
                    TopFit:Print(string.format(TopFit.locale.ErrorEquipFailure, recTable.locationTable.itemLink, slotID, TopFit.slotNames[slotID]))
                    TopFit.itemRecommendations[slotID] = nil
                end
            end
        end

        TopFit:Debug("All Done!")
        TopFit.updateFrame:SetScript("OnUpdate", nil)
        TopFit:StoppedCalculation()

        EquipmentManagerClearIgnoredSlotsForSave()
        for _, slotID in pairs(TopFit.slots) do
            if (not TopFit.itemRecommendations[slotID]) then
                TopFit:Debug("Ignoring slot "..slotID)
                EquipmentManagerIgnoreSlotForSave(slotID)
            end
        end

        -- save equipment set
        if (CanUseEquipmentSets()) then
            local texture
            setName = TopFit:GenerateSetName(TopFit.currentSetName)
            -- check if a set with this name exists
            if (GetEquipmentSetInfoByName(setName)) then
                texture = GetEquipmentSetInfoByName(setName)
            else
                texture = "Spell_Holy_EmpowerChampion"
            end

            TopFit:Debug("Trying to save set: "..setName..", "..(texture or "nil"))
            SaveEquipmentSet(setName, texture)
        end

        -- we are done with this set
        TopFit.isBlocked = false

        -- reset relevant score field
        set.calculationData.ignoreCapsForCalculation = nil

        -- initiate next calculation if necessary
        if (#TopFit.workSetList > 0) then
            TopFit:CalculateSets()
        end
    end
end
