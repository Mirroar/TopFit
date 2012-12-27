local addonName, ns, _ = ...

local DefaultCalculation = ns.class(ns.Calculation)
ns.DefaultCalculation = DefaultCalculation

function DefaultCalculation:Initialize()
    ns.CalculateRecommendations(self:GetUsedSet())
    self.firstCombination = true
    self.done = false
end

function DefaultCalculation:Step()
    local set = self.set
    -- set counters to next combination

    -- check all nil counters from the end
    local currentSlot = 19
    local increased = false
    while (not increased) and (currentSlot > 0) do
        while (set.calculationData.slotCounters[currentSlot] == nil or set.calculationData.slotCounters[currentSlot] == #(TopFit.itemListBySlot[currentSlot])) and (currentSlot > 0) do
            set.calculationData.slotCounters[currentSlot] = nil -- reset to "no item"
            currentSlot = currentSlot - 1
        end

        if (currentSlot > 0) then
            -- increase combination, starting at currentSlot
            set.calculationData.slotCounters[currentSlot] = set.calculationData.slotCounters[currentSlot] + 1
            if (not TopFit:IsDuplicateItem(set, currentSlot)) and (TopFit:IsOffhandValid(set, currentSlot)) then
                increased = true
            end
        else
            if self.firstCombination then
                self.firstCombination = false
            else
                -- we're back here, and so we're done
                TopFit:Print("Finished calculation after " .. math.round(self.elapsed * 100) / 100 .. " seconds at " .. self:GetOperationsPerFrame() .. " operations per frame")
                self.done = true
                self:Done()
            end
        end
    end

    if not self.done then
        -- fill all further slots with first choices again - until caps are reached or unreachable
        while (not TopFit:IsCapsReached(set, currentSlot) or TopFit:MoreUniquesAvailable(currentSlot)) and not TopFit:IsCapsUnreachable(set, currentSlot) and not TopFit:UniquenessViolated(set, currentSlot) and (currentSlot < 19) do
            currentSlot = currentSlot + 1
            if #(TopFit.itemListBySlot[currentSlot]) > 0 then
                set.calculationData.slotCounters[currentSlot] = 1
                while TopFit:IsDuplicateItem(set, currentSlot) or TopFit:UniquenessViolated(set, currentSlot) or (not TopFit:IsOffhandValid(set, currentSlot)) do
                    set.calculationData.slotCounters[currentSlot] = set.calculationData.slotCounters[currentSlot] + 1
                end
                if set.calculationData.slotCounters[currentSlot] > #(TopFit.itemListBySlot[currentSlot]) then
                    set.calculationData.slotCounters[currentSlot] = 0
                end
            else
                set.calculationData.slotCounters[currentSlot] = 0
            end
        end

        if TopFit:IsCapsReached(set, currentSlot) and not TopFit:UniquenessViolated(set, currentSlot) then
            -- valid combination, save
            TopFit:SaveCurrentCombination(set)
        end
    end
end

function DefaultCalculation:Finalize()
    local set = self.set
    -- save a default set of only best-in-slot items
    TopFit:SaveCurrentCombination(set)

    -- find best combination that satisfies ALL caps
    if (set.calculationData.bestCombination) then
        TopFit:Print("Total Score: " .. math.round(set.calculationData.bestCombination.totalScore))
        -- caps are reached, save and equip best combination
        for slotID, locationTable in pairs(set.calculationData.bestCombination.items) do
            TopFit.itemRecommendations[slotID] = {
                locationTable = locationTable,
            }
        end

        --TODO: this is something that should be done by the caller of this calculation
        TopFit.EquipRecommendedItems(set)
    else
        -- caps could not all be reached, calculate without caps instead
        if not set.calculationData.silentCalculation then
            TopFit:Print(TopFit.locale.ErrorCapNotReached)
        end
        set:ClearAllHardCaps()
        set.calculationData.ignoreCapsForCalculation = true

        -- TODO: start over
        --tinsert(ns.activeCoroutines, {coroutine.create(ns.CalculateRecommendations), set})
        return
        self:Done()
    end
end