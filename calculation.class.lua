local addonName, ns, _ = ...

local Calculation = ns.class()
ns.Calculation = Calculation

-- create a new, empty calculation object
-- not advised, this class is meant to be inherited from by different calculation methods
function Calculation:init(set)
    self.running = false
    self.started = false
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
        else
            -- continue
        end
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