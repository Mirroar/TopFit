--- This is a base class containing the interface that is necessary for communicating with TopFit.
-- Calculation classes that actually calculate sets should inherit from this class to ensure correct functionality

local addonName, ns, _ = ...

local Calculation = ns.class()
ns.Calculation = Calculation

-- create a new, empty calculation object
-- not advised, this class is meant to be inherited from by different calculation methods
function Calculation:construct(set)
	self.running = false
	self.started = false
	self:UseSet(set)
	self.elapsed = 0
	self.availableItems = {}
	self.itemCounts = {}
	for slotID, _ in pairs(ns.slotNames) do
		self.availableItems[slotID] = {}
	end
	self:SetOperationsPerFrame(50) -- sensible default that is somewhat easy on the CPU
end

function Calculation:UseSet(set)
	self.AssertArgumentType(set, ns.Set)

	self.set = set
end

function Calculation:GetUsedSet()
	return self.set
end

--- Add an item to be available for the current calculation in the given slot (or all applicable slots if none is provided).
function Calculation:AddItem(item, slotID)
	-- accepts item IDs, links and tables
	assert(item, "Usage: calculation:AddItem(itemLink or itemID or itemTable[, slotID])")
	if type(item) == 'table' then
		if item.itemLink then item = item.itemLink
		elseif item.itemID then item = item.itemID
		else error("Usage: calculation:AddItem(itemLink or itemID or itemTable[, slotID])") end
	end
	local itemTable = ns:GetCachedItem(item)

	if slotID then
		assert(self.availableItems[slotID], "calculation:AddItem() - invalid slotID given: "..(slotID or "nil"))

		tinsert(self.availableItems[slotID], itemTable)
	else
		for _, slotID in pairs(itemTable.equipLocationsByType) do
			tinsert(self.availableItems[slotID], itemTable)
		end
	end
end

--- Removes all currently available items from this calculation.
function Calculation:ClearItems()
	for _, slotTable in pairs(self.availableItems) do
		wipe(slotTable)
	end
	wipe(self.itemCounts)
end

--- Get available items for a slot.
function Calculation:GetItems(slotID)
	if not slotID then
		return self.availableItems --TODO: copy tables or use provided table
	elseif self.availableItems[slotID] then
		--TODO: this assert makes no sense. remove it or the elseif-condition above
		assert(self.availableItems[slotID], "calculation:GetItems() - invalid slotID given: "..(slotID or "nil"))
		return self.availableItems[slotID] --TODO: copy tables or use provided table
	end
end

--- Get a single item for a slot.
function Calculation:GetItem(slotID, itemNum)
	assert(slotID and self.availableItems[slotID], "calculation:GetItem(slotID, itemNum) - invalid slotID given: "..(slotID or "nil"))
	assert(itemNum and self.availableItems[slotID][itemNum], "calculation:GetItem(slotID, itemNum) - invalid itemNum given: "..(itemNum or "nil"))
	return self.availableItems[slotID][itemNum]
end

function Calculation:SetItemCount(itemLink, count)
	self.itemCounts[itemLink] = count
end

function Calculation:GetItemCount(itemLink)
	return self.itemCounts[itemLink] or 1
end

--- Set a callback to be called when the calculation completes.
function Calculation:SetCallback(callback)
	if callback then
		self.AssertArgumentType(callback, "function")
	end
	self.callback = callback
end

--- Check whether the calculation is currently running.
-- Even if it is not running, it might be in progress but paused.
-- @see Calculation:IsStarted
function Calculation:IsRunning()
	return self.running
end

--- Check whether the calculation has been started and is not finished yet.
-- It might be paused, however
-- @see Calculation:IsRunning
function Calculation:IsStarted()
	return self.started
end

--- Start or resume this calculation.
function Calculation:Start()
	if not self:IsRunning() then
		if not self:IsStarted() then
			-- init and run
			self.elapsed = 0 -- for performance testing
			self:Initialize()
		end
		Calculation._RunCalculation(self)
		self.running = true
		self.started = true
	end
end
Calculation.Resume = Calculation.Start

--- Pause the current calculation so it can be resumed later.
function Calculation:Pause()
	if self:IsRunning() then
		self.running = false
	end
end

--- Abort the current calculation completely.
function Calculation:Abort()
	if self:IsStarted() then
		self.running = false
		self.started = false
	end
end
Calculation.Stop = Calculation.Abort
Calculation.Cancel = Calculation.Abort

--- Set the number of combinations to check each frame.
-- @param ops
function Calculation:SetOperationsPerFrame(ops)
	self.AssertArgumentType(ops, 'number')

	self.operationsPerFrame = ops
end

--- Get the number of combinations being checked each frame.
function Calculation:GetOperationsPerFrame()
	return self.operationsPerFrame
end

--- Run steps needed for initializing the calculation process.
function Calculation:Initialize()
	-- empty and intended to be overridden
end

--- Run a single step of this calculation.
function Calculation:Step()
	-- empty and intended to be overridden
	self:Done()
end

--- Run final operations for this calculation and get ready to return a result.
function Calculation:Finalize()
	-- empty and intended to be overridden
end

--- Mark the current calculation as finished.
function Calculation:Done()
	self.running = false
	self.started = false
	self:Finalize()

	if type(self.OnComplete) == 'function' then
		self:OnComplete()
	end
	if type(self.callback) == 'function' then
		self.callback() --TODO: also send results
	end
end

-- run steps consecutively
function Calculation:RunSteps()
	local operation = 0
	while self.running and operation < self.operationsPerFrame do
		self:Step()
		operation = operation + 1
	end

	if type(self.OnUpdate) == 'function' then
		self:OnUpdate() --TODO: we should also provide the current combination and/or progress (configurable?)
	end
end

-- returns a value between 0 and 1 indicating how far along the calculation is
function Calculation:GetCurrentProgress()
	return 0 -- this should be overridden
end

local calculationsFrame = CreateFrame("Frame")
function Calculation._RunCalculation(calculation)
	if not ns.activeCalculations then
		ns.activeCalculations = {}
	end
	tinsert(ns.activeCalculations, calculation)
	calculationsFrame:SetScript("OnUpdate", Calculation._ContinueActiveCalculations)
end

function Calculation._ContinueActiveCalculations(frame, elapsed)
	ns:Debug("Continue")
	if #(ns.activeCalculations) < 1 then
		calculationsFrame:SetScript("OnUpdate", nil)
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
