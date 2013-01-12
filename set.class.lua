local addonName, ns, _ = ...

local Set = ns.class()
ns.Set = Set

-- create a new, empty set object using the given name
function Set:construct(setName)
    -- initialize member variables
    self.weights = {}
    self.caps = {}
    self.forced = {}
    self.itemScoreCache = {}
    self.ignoreCapsForCalculation = false

    self.calculationData = {} -- for use by calculation functions

    -- set some defaults
    self:SetName(setName or 'Unknown')

    -- determine if the player can dualwield
    self:ForceDualWield(false)
    self:ForceTitansGrip(false)
    self:EnableDualWield(ns:PlayerCanDualWield()) -- TODO: instead of initializing once, get capability from namespaced variable (which should be updated on spec change)
    self:EnableTitansGrip(ns:PlayerHasTitansGrip())
end

-- create a new set object using data from saved variables
function Set.CreateFromSavedVariables(setTable)
    Set.AssertArgumentType(setTable, 'table')

    local setInstance = Set(setTable.name)

    if setTable.caps then
        -- initialize caps
        for stat, cap in pairs(setTable.caps) do
            if cap.active then
                setInstance:SetHardCap(stat, cap.value)
            end
        end
    end

    if setTable.weights then
        -- initialize weights
        for stat, value in pairs(setTable.weights) do
            setInstance:SetStatWeight(stat, value)
        end
    end

    if setTable.forced then
        -- initialize forced items
        for slotID, forced in pairs(setTable.forced) do
            for _, forcedItemID in ipairs(forced) do
                setInstance:ForceItem(slotID, forcedItemID)
            end
        end
    end

    if setTable.simulateDualWield then
        setInstance:ForceDualWield(true)
    end
    if setTable.simulateTitansGrip then
        setInstance:ForceTitansGrip(true)
    end
    if not setTable.excludeFromTooltip then
        setInstance:SetDisplayInTooltip(true)
    end

    return setInstance
end

function Set.CreateWritableFromSavedVariables(setID)
    if not setID or not ns.db.profile.sets[setID] then return nil end
    local setInstance = Set.CreateFromSavedVariables(ns.db.profile.sets[setID])
    setInstance.setID = setID

    return setInstance
end

-- set the set's name
function Set:SetName(setName)
    self.AssertArgumentType(setName, 'string')

    self.name = setName
    if self.setID and ns.db.profile.sets[self.setID] then
        ns.db.profile.sets[self.setID].name = setName
    end
end

-- get the set's name
function Set:GetName()
    return self.name
end

-- get the set's icon texture used for its equipment set
function Set:GetIconTexture()
    return "Interface\\Icons\\" .. (GetEquipmentSetInfoByName(self:GetEquipmentSetName()) or "Spell_Holy_EmpowerChampion")
end

function Set:GetEquipmentSetName()
    return ns:GenerateSetName(self:GetName()) -- TODO: move code here and maybe get rid of global function
end

-- set a hard cap for any stat
-- use value = nil to unset a cap
function Set:SetHardCap(stat, value)
    self.AssertArgumentType(stat, 'string')
    if type(value) ~= 'nil' then
        self.AssertArgumentType(value, 'number')
        if self.setID and ns.db.profile.sets[self.setID] then
            ns.db.profile.sets[self.setID].caps[stat] = {
                active = 1,
                value = value
            }
        end
    else
        if self.setID and ns.db.profile.sets[self.setID] then
            ns.db.profile.sets[self.setID].caps[stat] = nil
        end
    end

    wipe(self.itemScoreCache)
    self.caps[stat] = value
end

-- get the defined hard cap for any stat
function Set:GetHardCap(stat)
    self.AssertArgumentType(stat, 'string')

    return self.caps[stat]
end

-- get a list of all configured hard caps and their values, keyed by stat
function Set:GetHardCaps(useTable)
    local caps = useTable and wipe(useTable) or {}
    for stat, value in pairs(self.caps) do
        caps[stat] = value
    end
    return caps
end

-- set a hard cap for any stat
-- use value = nil to unset a cap
function Set:SetStatWeight(stat, value)
    self.AssertArgumentType(stat, 'string')
    if type(value) ~= 'nil' then
        self.AssertArgumentType(value, 'number')
    end

    wipe(self.itemScoreCache)
    self.weights[stat] = value
    if self.setID and ns.db.profile.sets[self.setID] then
        ns.db.profile.sets[self.setID].weights[stat] = value
    end
end

-- get the defined hard cap for any stat
function Set:GetStatWeight(stat)
    self.AssertArgumentType(stat, 'string')

    return self.weights[stat]
end

-- get a list of all configured hard caps and their values, keyed by stat
function Set:GetStatWeights()
    local weights = useTable and wipe(useTable) or {}
    for stat, value in pairs(self.weights) do
        weights[stat] = value
    end
    return weights
end

-- remove all hard caps from this set
function Set:ClearAllHardCaps()
    wipe(self.itemScoreCache)
    wipe(self.caps)
end

-- add an item to this set's forced items
function Set:ForceItem(slotID, itemID)
    if not slotID or not itemID then return end

    if not self.forced[slotID] then
        self.forced[slotID] = {}
    end
    tinsert(self.forced[slotID], itemID)

    if self.setID and ns.db.profile.sets[self.setID] then
        if not ns.db.profile.sets[self.setID].forced then
            ns.db.profile.sets[self.setID].forced = {}
        end
        if not ns.db.profile.sets[self.setID].forced[slotID] then
            ns.db.profile.sets[self.setID].forced[slotID] = {}
        end
        tinsert(ns.db.profile.sets[self.setID].forced[slotID], itemID)
    end
end

-- remove an item from this set's forced items
function Set:UnforceItem(slotID, itemID)
    if not slotID or not itemID then return end

    if not self.forced[slotID] then return end
    for i = #(self.forced[slotID]), 1, -1 do
        local forcedItemID = self.forced[slotID][i]
        if forcedItemID == itemID then
            tremove(self.forced[slotID], i)
        end
    end

    if self.setID and ns.db.profile.sets[self.setID] and ns.db.profile.sets[self.setID].forced and ns.db.profile.sets[self.setID].forced[slotID] then
        for i = #(ns.db.profile.sets[self.setID].forced[slotID]), 1, -1 do
            local forcedItemID = ns.db.profile.sets[self.setID].forced[slotID][i]
            if forcedItemID == itemID then
                tremove(ns.db.profile.sets[self.setID].forced[slotID], i)
            end
        end
    end
end

-- determine whether the given item is part of this set's forced items
function Set:IsForcedItem(slotID, itemID) -- TODO: explicitly get the given item's item ID for comparison so this funciton works with both item links and item IDs
    if not slotID or not itemID then return false end
    if not self.forced[slotID] then
        return false
    else
        for _, forcedItemID in ipairs(self.forced[slotID]) do
            if forcedItemID == itemID then
                return true
            end
        end
    end
end

-- get a list of all of this set's forced items for the given slot
function Set:GetForcedItems(slotID)
    local forced = {}
    if slotID then
        if self.forced[slotID] then
            for _, forcedItemID in ipairs(self.forced[slotID]) do
                tinsert(forced, forcedItemID)
            end
        end
    else
        -- collect results for all slots
        for slotID, _ in pairs(ns.slotNames) do
            local subForced = self:GetForcedItems(slotID)
            if #subForced > 0 then
                forced[slotID] = subForced
            end
        end
    end
    return forced
end

-- allow dual wielding for this set
function Set:EnableDualWield(value)
    self.canDualWield = value and true or false
end

-- get the current setting for dual wielding for this set
function Set:CanDualWield()
    return self.canDualWield or self.forceDualWield
end

function Set:ForceDualWield(force)
    self.forceDualWield = force and true or false
    if self.setID and ns.db.profile.sets[self.setID] then
        ns.db.profile.sets[self.setID].simulateDualWield = force and true or false
    end
end

function Set:IsDualWieldForced()
    return self.forceDualWield
end

-- allow titan's grip for this set
function Set:EnableTitansGrip(value)
    self.canTitansGrip = value and true or false
end

-- get the current setting for titan's grip for this set
function Set:CanTitansGrip()
    return self.canTitansGrip or self.forceTitansGrip
end

function Set:ForceTitansGrip(force)
    self.forceTitansGrip = force and true or false
    if self.setID and ns.db.profile.sets[self.setID] then
        ns.db.profile.sets[self.setID].simulateTitansGrip = force and true or false
    end
end

function Set:IsTitansGripForced()
    return self.forceTitansGrip
end

function Set:SetDisplayInTooltip(enable) -- [TODO]
    self.displayInTooltip = enable and true or false
    if self.setID and ns.db.profile.sets[self.setID] then
        ns.db.profile.sets[self.setID].excludeFromTooltip = (not enable) and true or false
    end
end
function Set:GetDisplayInTooltip() -- [TODO]
    return self.displayInTooltip
end

function Set:SetForceArmorType(enable) -- [TODO]
    self.forceArmorType = enable and true or false
end
function Set:GetForceArmorType() -- [TODO]
    return self.forceArmorType
end

function Set:SetHitConversion(enable) -- [TODO]
    self.hitConversion = enable and true or false
end
function Set:GetHitConversion() -- [TODO]
    return self.hitConversion
end

function Set:GetItemScore(item, useRaw)
    assert(item and (type(item) == "string" or type(item) == "number"), "Usage: setObject:GetItemScore(itemLink or itemID[, useRaw])")

    if not self.itemScoreCache[item] then
        local itemTable = TopFit:GetCachedItem(item)
        if not itemTable then return end

        --local set = setTable.weights
        --local caps = setTable.caps

        -- calculate item score
        local itemScore = 0
        local capsModifier = 0
        -- iterate given weights
        for stat, statValue in pairs(self.weights) do
            if itemTable.totalBonus[stat] then
                -- check for hard cap on this stat
                if not self.caps[stat] then
                    itemScore = itemScore + statValue * itemTable.totalBonus[stat]
                end
            end
        end

        -- also calculate raw item score
        local rawScore = 0
        local rawModifier = 0
        -- iterate given weights
        for stat, statValue in pairs(self.weights) do
            if itemTable.itemBonus[stat] then
                -- check for hard cap on this stat
                if not self.caps[stat] then
                    rawScore = rawScore + statValue * itemTable.itemBonus[stat]
                end
            end
            if itemTable.procBonus[stat] then
                -- check for hard cap on this stat
                if not self.caps[stat] then
                    rawScore = itemScore + statValue * itemTable.procBonus[stat]
                end
            end
        end

        self.itemScoreCache[item] = {
            itemScore = itemScore,
            rawScore = rawScore,
        }
    end

    if useRaw then
        return self.itemScoreCache[item].rawScore
    else
        return self.itemScoreCache[item].itemScore
    end
end
