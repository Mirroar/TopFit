local addonName, ns, _ = ...

local Set = ns.class()
ns.Set = Set

-- create a new, empty set object using the given name
function Set:construct(setName)
    -- initialize member variables
    self.weights = {}
    self.caps = {}
    self.forced = {}
    self.ignoreCapsForCalculation = false

    self.calculationData = {} -- for use by calculation functions

    -- set some defaults
    self:SetName(setName or 'Unknown')
    self:SetOperationsPerFrame(50) -- sensible default that is somewhat easy on the CPU

    -- determine if the player can dualwield
    self:EnableDualWield(ns:PlayerCanDualWield())
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

    if (setTable.simulateDualWield) then
        setInstance:EnableDualWield(true)
    end
    if (setTable.simulateTitansGrip) then
        setInstance:EnableTitansGrip(true)
    end

    return setInstance
end

-- set the set's name
function Set:SetName(setName)
    self.AssertArgumentType(setName, 'string')

    self.name = type(setName) == 'string' and setName or 'Unnamed'
end

-- get the set's name
function Set:GetName()
    return self.name
end

-- set the number of combinations to check each frame
function Set:SetOperationsPerFrame(ops)
    self.AssertArgumentType(ops, 'number')

    self.operationsPerFrame = ops
end

-- get the number of combinations being checked each frame
function Set:GetOperationsPerFrame()
    return self.operationsPerFrame
end

function Set:SetHardCap(stat, value)
    self.AssertArgumentType(stat, 'string')
    if type(value) ~= 'nil' then
        self.AssertArgumentType(value, 'number')
    end

    self.caps[stat] = value
end

function Set:GetHardCap(stat)
    self.AssertArgumentType(stat, 'string')

    return self.caps[stat]
end

function Set:GetHardCaps()
    return self.caps
end

function Set:ClearAllHardCaps()
    wipe(self.caps)
end

function Set:EnableDualWield(value)
    self.canDualWield = value and true or false
end

function Set:CanDualWield()
    return self.canDualWield
end

function Set:EnableTitansGrip(value)
    self.canTitansGrip = value and true or false
end

function Set:CanTitansGrip()
    return self.canTitansGrip
end
