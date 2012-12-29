local addonName, ns, _ = ...

local Calculation = ns.class()
ns.Calculation = Calculation

-- create a new, empty calculation object
-- not advised, this class is meant to be inherited from by different calculation methods
function Calculation:construct(set)
    self.AssertArgumentType(set, ns.Set)

    self.running = false
    self.started = false
    self.set = set
    self.elapsed = 0
    self:SetOperationsPerFrame(50) -- sensible default that is somewhat easy on the CPU
end

function Calculation:UseSet(set)
    self.AssertArgumentType(set, ns.Set)

    self.set = set
end

function Calculation:GetUsedSet()
    return self.set
end

-- add an item to be available for the current calculation
function Calculation:AddItem()
end

-- check whether the calculation is currently running
-- even if it is not running, it might be in progress but paused - check Calculation:IsStarted() for that
function Calculation:IsRunning()
    return self.running
end

-- check whether the calculation has been started and is not finished yet
-- it might be paused, though - check Calculation:IsRunning() for that
function Calculation:IsStarted()
    return self.started
end

-- start or resume this calculation
function Calculation:Start()
    if not self:IsRunning() then
        if not self:IsStarted() then
            -- init and run
            self.elapsed = 0 -- for performance testing
            self:Initialize()
        end
        Calculation._RunCalculation(self)
        self.running = true
    end
end
Calculation.Resume = Calculation.Start

-- pause the current calculation so it can be resumed later
function Calculation:Pause()
    if self:IsRunning() then
        self.running = false
    end
end

-- abort the current calculation completely
function Calculation:Abort()
    if self:IsStarted() then
        self.running = false
        self.started = false
    end
end
Calculation.Stop = Calculation.Abort
Calculation.Cancel = Calculation.Abort

-- set the number of combinations to check each frame
function Calculation:SetOperationsPerFrame(ops)
    self.AssertArgumentType(ops, 'number')

    self.operationsPerFrame = ops
end

-- get the number of combinations being checked each frame
function Calculation:GetOperationsPerFrame()
    return self.operationsPerFrame
end

-- run steps needed for initializing the calculation process
function Calculation:Initialize()
    -- empty and intended to be overridden
end

-- run single step of this calculation
function Calculation:Step()
    -- empty and intended to be overridden
end

-- run final operation of this calculation and get ready to return a result
function Calculation:Finalize()
    -- empty and intended to be overridden
end

-- mark the current calculation as finished
function Calculation:Done()
    self.running = false
    self.started = false
    self:Finalize()

    if type(self.OnComplete == 'function') then
        self:OnComplete()
    end
end

-- run steps consecutively
function Calculation:RunSteps()
    local operation = 0
    while self.running and operation < self.operationsPerFrame do
        self:Step()
        operation = operation + 1
    end

    if type(self.OnUpdate == 'function') then
        self:OnUpdate() --TODO: we should also provide the current combination and/or progress (configurable?)
    end
end

-- returns a value between 0 and 1 indicating how far along the calculation is
function Calculation:GetCurrentProgress()
    return 0 -- this should be overridden
end

function Calculation._RunCalculation(calculation)
    if not ns.activeCalculations then
        ns.activeCalculations = {}
    end
    tinsert(ns.activeCalculations, calculation)
    ns.calculationsFrame:SetScript("OnUpdate", Calculation._ContinueActiveCalculations)
end

function Calculation._ContinueActiveCalculations(frame, elapsed)
    ns:Debug("Continue")
    if #(ns.activeCalculations) < 1 then
        ns.calculationsFrame:SetScript("OnUpdate", nil)
    else
        for i = #(ns.activeCalculations), 1, -1 do
            ns:Debug("Continue "..i)
            local calculation = ns.activeCalculations[i]
            if not calculation:IsRunning() then
                tremove(ns.activeCalculations, i)
            else
                calculation.elapsed = calculation.elapsed + elapsed
                calculation:RunSteps()
            end
        end
    end
end
