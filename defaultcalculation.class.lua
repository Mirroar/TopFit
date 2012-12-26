local addonName, ns, _ = ...

local DefaultCalculation = ns.class(Calculation)
ns.DefaultCalculation = DefaultCalculation

-- create a new calculation object
function DefaultCalculation:construct(...)
    Calculation.init(self, ...)
end