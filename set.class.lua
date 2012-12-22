local addonName, ns, _ = ...

local Set = ns.class()
ns.Set = Set

function Set:construct(setName)
    self:setName(setName or '<Unknown>')
    self:setOperationsPerFrame(50) -- sensible default that is somewhat easy on the CPU
end

function Set:setName(setName)
    self.assertArgumentType(setName, 'string')
    self.name = type(setName) == 'string' and setName or 'Unnamed'
end

function Set:getName()
    return self.name
end

function Set:setOperationsPerFrame(ops)
    self.assertArgumentType(ops, 'number')
    self.operationsPerFrame = ops
end

function Set:getOperationsPerFrame()
    return self.operationsPerFrame
end