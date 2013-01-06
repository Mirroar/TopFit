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

            calculation.OnUpdate = ns.UpdateUIWithCalculationProgress
            calculation.OnComplete = ns.CalculationHasCompleted

            -- save equippable items
            ns.itemListBySlot = ns:GetEquippableItems() --TODO: replace with Calculation:AddItem(item, slot) mechanic
            ns.ReduceItemList(calculation.set, ns.itemListBySlot) --TODO: should not happen in calculation but before it

            ns:ResetProgress()

            calculation:Start()
        end
    end
end

function ns.UpdateUIWithCalculationProgress(calculation) --TODO: don't interact directly with calculation internals
    -- update progress
    local set = calculation.set
    local progress = calculation:GetCurrentProgress()
    ns:SetProgress(progress)

    -- update icons and statistics
    if calculation.bestCombination then
        ns:SetCurrentCombination(calculation.bestCombination)
    end

    if ns.abortCalculation then
        ns:Print("Calculation aborted.")
        ns.abortCalculation = nil
        ns.isBlocked = false
        ns:StoppedCalculation()
    end

    ns:Debug("Current combination count: "..calculation.combinationCount)
end

function ns.CalculationHasCompleted(calculation) --TODO: don't interact directly with calculation internals
    local set = calculation.set

    -- find best combination that satisfies ALL caps
    if (calculation.bestCombination) then
        ns:Print("Total Score: " .. math.ceil(calculation.bestCombination.totalScore))
        -- caps are reached, save and equip best combination
        for slotID, locationTable in pairs(calculation.bestCombination.items) do
            ns.itemRecommendations[slotID] = {
                locationTable = locationTable,
            }
        end

        ns.EquipRecommendedItems(set)
    else
        -- caps could not all be reached, calculate without caps instead
        if not set.calculationData.silentCalculation then
            ns:Print(ns.locale.ErrorCapNotReached)
        end

        -- start over without hard caps
        set:ClearAllHardCaps()
        set.calculationData.ignoreCapsForCalculation = true
        calculation:Start()
    end
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

-- remove all other items in slots that have forced items in them
function ns.RemoveNonForcedItemsFromItemList(set, itemList)
    for slotID, _ in pairs(ns.slotNames) do
        local forcedItems = ns:GetForcedItems(ns.setCode, slotID) --TODO: ask the set for its forced items
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
end

-- if enabled, remove armor that is not part of armor specialization
function ns.RemoveWrongArmorTypesFromItemList(set, itemList)
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
end

--remove items that are marked as bind on equip
function ns.RemoveBindOnEquipItemsFromItemList(set, itemList)
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
end

function ns.RemoveItemsBelowThresholdFromItemList(set, subList)
    if #subList >= 1 then
        for i = #subList, 1, -1 do
            if (ns:GetItemScore(subList[i].itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) <= 0) then --TODO: get score from set
                -- check caps
                local hasCap = false

                local itemStats = nil
                if subList[i].stats then
                    itemStats = subList[i].stats
                elseif subList[i].itemLink then
                    local itemTable = ns:GetCachedItem(subList[i].itemLink)
                    itemStats = itemTable and itemTable.totalBonus
                end

                for statCode, _ in pairs(set:GetHardCaps()) do
                    if itemStats and (itemStats[statCode] or -1) > 0 then
                        hasCap = true
                        break
                    end
                end

                if not hasCap then
                    tremove(subList, i)
                    --itemList[i].reason = itemList[i].reason.."score <= 0, no cap contribution and not forced; "
                end
            end
        end
    end
end

function ns.RemoveLowScoreItemsFromItemList(set, subList, numBetterItemsNeeded, problematicUniqueness)
    if #subList > 1 then
        for i = #subList, 1, -1 do
            local itemStats, itemTable
            if subList[i].stats then
                itemStats = subList[i].stats
            elseif subList[i].itemLink then
                itemTable = ns:GetCachedItem(subList[i].itemLink)
                itemStats = itemTable and itemTable.totalBonus
            end
            if not itemTable then
                tremove(subList, i)
            else
                -- try to see if an item exists which is definitely better
                local betterItemExists = 0
                for j = 1, #subList do
                    if i ~= j then
                        local compareStats, compareTable
                        if subList[j].stats then
                            compareStats = subList[i].stats
                        elseif subList[j].itemLink then
                            compareTable = ns:GetCachedItem(subList[j].itemLink)
                            compareStats = compareTable and compareTable.totalBonus
                        end
                        if compareTable and
                            (ns:GetItemScore(itemTable.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation) <= ns:GetItemScore(compareTable.itemLink, ns.setCode, set.calculationData.ignoreCapsForCalculation)) and
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
                                for stat, _ in pairs(compareTable.totalBonus) do
                                    if (string.sub(stat, 1, 8) == "UNIQUE: ") and problematicUniqueness and problematicUniqueness == "all" or problematicUniqueness[stat] then
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
                    tremove(subList, i)
                    --subList[i].reason = subList[i].reason..betterItemExists.." better items found (setCode: "..(ns.setCode or "nil").."; relevantScore: "..(set.calculationData.ignoreCapsForCalculation or "nil").."); "
                end
            end
        end
    end
end

function ns.ReduceGemList(set, gemList)
    for _, subList in pairs(gemList) do
        ns.RemoveItemsBelowThresholdFromItemList(set, subList)
        ns.RemoveLowScoreItemsFromItemList(set, subList, 1, "all")
    end
end

function ns.ReduceItemList(set, itemList)
    ns.RemoveNonForcedItemsFromItemList(set, itemList)
    ns.RemoveWrongArmorTypesFromItemList(set, itemList)
    ns.RemoveBindOnEquipItemsFromItemList(set, itemList)

    -- remove all items with score <= 0 that are neither forced nor contribute to caps
    for slotID, subList in pairs(itemList) do
        if #(ns:GetForcedItems(ns.setCode, slotID)) == 0 then --TODO: Get forced items from set
            ns.RemoveItemsBelowThresholdFromItemList(set, subList)
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
    for slotID, subList in pairs(itemList) do
        local numBetterItemsNeeded = 1

        -- For items that can be used in 2 slots, we also need at least 2 better items to declare an item useless
        if (slotID == 17) -- offhand
            or (slotID == 12) -- ring 2
            or (slotID == 14) -- trinket 2
            then

            numBetterItemsNeeded = 2
        end

        ns.RemoveLowScoreItemsFromItemList(set, subList, numBetterItemsNeeded, problematicUniqueness)
    end
end
