local addonName, ns, _ = ...

local DefaultCalculation = ns.class(ns.Calculation)
ns.DefaultCalculation = DefaultCalculation

-- create a new calculation object
function DefaultCalculation:construct(...)
    ns.Calculation.construct(self, ...)
end