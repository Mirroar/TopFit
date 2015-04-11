local addonName, ns, _ = ...

local DefaultCalculation = ns.class(ns.Calculation)
ns.DefaultCalculation = DefaultCalculation

--- Run steps needed for initializing the calculation process.
function DefaultCalculation:Initialize()
	self.combinationCount = 0
	self.slotCounters = {}
	self.bestCombination = nil
	self.maxScore = nil

	self:InitializeCapHeuristics()
	self:InitializeAvailableUniqueItems()
	self:InitializeSlots(INVSLOT_FIRST_EQUIPPED)
end

--- Find out how much of a given capped stat can be contributed by any slot
function DefaultCalculation:InitializeCapHeuristics()
	self.capHeuristics = {}
	self.maximumCapRemaining = {}

	-- create maximum values for each cap and item slot
	for statCode, _ in pairs(self.set:GetHardCaps()) do
		self.capHeuristics[statCode] = {}
		self.maximumCapRemaining[statCode] = {}

		local capSum = 0
		for slotID = INVSLOT_LAST_EQUIPPED, INVSLOT_FIRST_EQUIPPED, -1 do
			self.maximumCapRemaining[statCode][slotID] = capSum
			local maxValue = 0
			local items = self:GetItems(slotID)

			-- get maximum value contributed to cap in this slot
			if items then
				for _, itemTable in pairs(items) do
					local statValue = itemTable.totalBonus[statCode] or 0

					if statValue > maxValue then
						maxValue = statValue
					end
				end
			end

			self.capHeuristics[statCode][slotID] = maxValue
			capSum = capSum + maxValue
		end
	end
end

--- Find out until which slot unique items might be equipped
function DefaultCalculation:InitializeAvailableUniqueItems()
	self.moreUniquesAvailable = {}

	-- cache up to which slot unique items are available
	local uniqueFound = false
	for slotID = INVSLOT_LAST_EQUIPPED + 1, INVSLOT_FIRST_EQUIPPED - 1, -1 do --TODO: why INVSLOT_FIRST_EQUIPPED - 1?
		if uniqueFound then
			self.moreUniquesAvailable[slotID] = true
		else
			self.moreUniquesAvailable[slotID] = false
			local items = self:GetItems(slotID)

			if items then
				for _, itemTable in pairs(items) do
					for statCode, _ in pairs(itemTable.totalBonus) do
						if (string.sub(statCode, 1, 8) == "UNIQUE: ") then
							uniqueFound = true
							break
						end
					end
				end
			end
		end
	end
end

-- TODO: this needs a logic check
function DefaultCalculation:InitializeSlots(currentSlot)
	self:ChooseFirstItem(currentSlot)
	-- fill all further slots with first choices again - until caps are reached or unreachable
	while (not self:IsCapsReached(currentSlot) or self.moreUniquesAvailable[currentSlot]) and not self:IsCapsUnreachable(currentSlot) and not self:UniquenessViolated(currentSlot) and (currentSlot < INVSLOT_LAST_EQUIPPED) do
		currentSlot = currentSlot + 1
		self:ChooseFirstItem(currentSlot)
	end

	if self:IsCapsReached(currentSlot) and not self:UniquenessViolated(currentSlot) then
		-- valid combination, save
		self:SaveCurrentCombination()
	else
		TopFit:Debug("Invalid combination - " ..currentSlot .. ': ' .. (self:IsCapsReached(currentSlot) and "true" or "nil"), (self:UniquenessViolated(currentSlot) and "true" or "nil"), (self.moreUniquesAvailable[currentSlot] and "true" or "nil"), (self:IsCapsUnreachable(currentSlot) and "true" or "nil"))
	end

	return currentSlot
end

--- initialize the current item for the given slot with the first valid choice
function DefaultCalculation:ChooseFirstItem(slotID)
	self.slotCounters[slotID] = 0
	self:ChooseNextItem(slotID)
end

--- choose the next current item for the given slot while making sure it's a valid choice
function DefaultCalculation:ChooseNextItem(slotID)
	local currentItems = self:GetItems(slotID)
	if #currentItems > 0 then
		self.slotCounters[slotID] = self.slotCounters[slotID] + 1
		while self.slotCounters[slotID] <= #currentItems and (self:IsDuplicateItem(slotID) or self:UniquenessViolated(slotID) or (not self:IsOffhandValid(slotID))) do
			self.slotCounters[slotID] = self.slotCounters[slotID] + 1
		end
		if self.slotCounters[slotID] > #currentItems then
			self.slotCounters[slotID] = nil
		end
	else
		self.slotCounters[slotID] = nil
	end
end

--- runs a single step of this calculation by checking the next combination of items
function DefaultCalculation:Step()
	-- set counters to next combination
	-- check all nil counters from the end
	local currentSlot = INVSLOT_LAST_EQUIPPED
	local increased = false
	while (not increased) and (currentSlot > 0) do
		local currentItems = self:GetItems()
		while (not self.slotCounters[currentSlot] or self.slotCounters[currentSlot] == #currentItems[currentSlot]) and (currentSlot >= INVSLOT_FIRST_EQUIPPED) do
			self.slotCounters[currentSlot] = nil -- reset to "no item"
			currentSlot = currentSlot - 1
		end

		if (currentSlot >= INVSLOT_FIRST_EQUIPPED) then
			-- increase combination, starting at currentSlot
			self:ChooseNextItem(currentSlot)
			if self.slotCounters[currentSlot] then
				-- a new item was chosen for the current slot
				increased = true
			end
		else
			-- if we could not switch to a new item in any slot we're done
			ns:Debug("Finished calculation after " .. math.ceil(self.elapsed * 100) / 100 .. " seconds at " .. self:GetOperationsPerFrame() .. " operations per frame")
			self:Done()
			return
		end
	end

	currentSlot = self:InitializeSlots(currentSlot + 1)
end

--- Returns the item currently selected for a slot
function DefaultCalculation:GetCurrentItem(slotID)
	if self.slotCounters[slotID] then
		return self:GetItem(slotID, self.slotCounters[slotID])
	end
end

-- run final operation of this calculation and get ready to return a result
function DefaultCalculation:Finalize()
	-- save a default set of only best-in-slot items
	self:SaveCurrentCombination()
end

-- returns a value between 0 and 1 indicating how far along the calculation is
function DefaultCalculation:GetCurrentProgress()
	if self.done then return 1 end --TODO: variable has been removed, replace with new way of checking whether calculation has finished

	local progress = 0
	local impact = 1
	for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		-- check if slot has items for calculation
		local items = self:GetItems(slot)
		if items and #items > 0 then
			-- calculate current progress towards finish
			local numItemsInSlot = #items
			local selectedItem = (self.slotCounters[slot] == 0) and #items or (self.slotCounters[slot] or 1)
			if selectedItem == 0 then selectedItem = 1 end

			impact = impact / numItemsInSlot
			progress = progress + impact * (selectedItem - 1)
		end
	end

	return progress
end

local secondaryStats = {'ITEM_MOD_SPIRIT_SHORT', 'ITEM_MOD_CRIT_RATING_SHORT', 'ITEM_MOD_HASTE_RATING_SHORT', --[['ITEM_MOD_HIT_RATING_SHORT', ]]'ITEM_MOD_MASTERY_RATING_SHORT'}
function DefaultCalculation:ApplySecondaryPercentBonus(stat, value)
	-- TODO: this is probably slow to check evey time and should be cached
	for _, secondaryStat in ipairs(secondaryStats) do
		if stat == secondaryStat then
			-- check if percent bonus is active until now
			for slotID = INVSLOT_TRINKET1, INVSLOT_TRINKET2 do
				if self.slotCounters[slotID] ~= nil and self.slotCounters[slotID] > 0 then
					local itemTable = self:GetItem(slotID, self.slotCounters[slotID])
					if itemTable then
						value = value * (1 + (itemTable.totalBonus['TOPFIT_SECONDARY_PERCENT'] or 0) / 100)
					end
				end
			end
		end
	end
	return value
end

--- determine whether the selected items up to currentSlot already fulfill all hard cap requirements
function DefaultCalculation:IsCapsReached(currentSlot)
	for stat, value in pairs(self.set:GetHardCaps()) do
		local currentValue = 0
		for slotID = INVSLOT_FIRST_EQUIPPED, currentSlot do
			local itemTable = self:GetCurrentItem(slotID)
			if itemTable then
				currentValue = currentValue + (itemTable.totalBonus[stat] or 0)
			end
		end

		if (self:ApplySecondaryPercentBonus(stat, currentValue)) < value then
			return false
		end
	end
	return true
end

--- determine whether the selected items up to currentSlot make it impossible to fulfill all hard cap requirements
function DefaultCalculation:IsCapsUnreachable(currentSlot)
	for stat, value in pairs(self.set:GetHardCaps()) do
		local currentValue = 0
		for slotID = INVSLOT_FIRST_EQUIPPED, currentSlot do
			local itemTable = self:GetCurrentItem(slotID)
			if itemTable then
				currentValue = currentValue + (itemTable.totalBonus[stat] or 0)
			end
		end

		if currentValue + self.maximumCapRemaining[stat][currentSlot] < value then
			ns:Debug("|cffff0000Caps unreachable|r: "..stat.." reached "..currentValue.." + "..self.maximumCapRemaining[stat][currentSlot].." / "..value, 'checking slot '..currentSlot)
			return true
		end
	end
	return false
end

-- check whether the selected items up to currentSlot violate any uniqueness constraints
local weights = {}
function DefaultCalculation:UniquenessViolated(currentSlot)
	local currentValues = {}
	for slotID = INVSLOT_FIRST_EQUIPPED, currentSlot do
		local itemTable = self:GetCurrentItem(slotID)
		if itemTable then
			for stat, amount in pairs(itemTable.totalBonus) do
				if stat:find('^UNIQUE: ') then
					currentValues[stat] = (currentValues[stat] or 0) + (amount or 0)
				end
			end
		end
	end

	for stat, value in pairs(currentValues) do
		local uniqueness, maxCount = stat:match('^UNIQUE: (.-)*(%d+)')
		if value > maxCount*1 then
			return true
		end
	end
	return false
end

-- check whether the selected items up to currentSlot already contain the item in currentSlot itself
function DefaultCalculation:IsDuplicateItem(currentSlot)
	local currentItem = self:GetCurrentItem(currentSlot)
	for i = INVSLOT_FIRST_EQUIPPED, currentSlot - 1 do
		local otherItem = self:GetCurrentItem(i)
		if otherItem and currentItem and otherItem == currentItem and self:GetItemCount(currentItem.itemLink) < 2 then
			return true
		end
	end
	return false
end

-- assertion functions for CalculateBestInSlot
local function FilterOneHanded(calculation, itemTable)
	return calculation.set:IsOnehandedWeapon(itemTable.itemLink)
end
local function FilterNoWeapon(calculation, itemTable)
	return not itemTable.itemEquipLoc:find("WEAPON")
end

--- check whether the currently selected offhand is valid for this calculation
function DefaultCalculation:IsOffhandValid(currentSlot)
	local offHand = self:GetCurrentItem(INVSLOT_OFFHAND)
	if offHand then -- offhand is set to something
		local mainHand = self:GetCurrentItem(INVSLOT_MAINHAND)
		if mainHand and not self.set:IsOnehandedWeapon(mainHand.itemLink) then
			-- a 2H-Mainhand is set, there can be no offhand!
			return false
		end

		if self.set:CanDualWield() then
			-- off hand may only be a one-handed weapon or other item
			if not FilterOneHanded(self, offHand) then
				return false
			end
		else
			-- no weapons allowed in off hand
			if not FilterNoWeapon(self, offHand) then
				return false
			end
		end
	end

	-- no problems detected
	return true
end

--TODO: refactor
function DefaultCalculation:SaveCurrentCombination()
	self.combinationCount = self.combinationCount + 1

	local totalScore = 0
	local selectedItems = {} -- indexed by slot
	local totalStats = {}

	for slotID = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED + 1 do --TODO: why INVSLOT_LAST_EQUIPPED + 1
		local stat, slotTable
		local itemTable = self:GetCurrentItem(slotID) or self:ChooseDefaultItem(slotID, selectedItems)

		if itemTable then -- slot will be filled
			selectedItems[slotID] = itemTable
			totalScore = totalScore + (self.set:GetItemScore(itemTable.itemLink) or 0)

			-- add total stats
			for stat, value in pairs(itemTable.totalBonus) do
				totalStats[stat] = (totalStats[stat] or 0) + value
			end
		end
	end

	-- check all caps one last time and see if all are reached
	local satisfied = true
	for stat, value in pairs(self.set:GetHardCaps()) do
		if ((not totalStats[stat]) or (totalStats[stat] < value)) then
			satisfied = false
			break
		end
	end

	-- check if any uniqueness constraints are broken
	if not self.set.calculationData.ignoreCapsForCalculation then
		for stat, value in pairs(totalStats) do
			if (string.sub(stat, 1, 8) == "UNIQUE: ") then
				local _, maxCount = strsplit("*", stat)
				maxCount = tonumber(maxCount)
				if value > maxCount then
					satisfied = false
					break
				end
			end
		end
	end

	-- check if it's better than old best
	if ((satisfied) and ((self.maxScore == nil) or (self.maxScore < totalScore))) then
		self.maxScore = totalScore
		self.bestCombination = {
			items = selectedItems,
			totalStats = totalStats,
			totalScore = totalScore,
		}
	end
end

--- determine the best item for a given slot
-- beware, this function expects the main hand choice to be final when calculating a corresponding off hand
function DefaultCalculation:ChooseDefaultItem(slotID, selectedItems)
	-- choose highest valued item for otherwise empty slots, if possible
	local itemTable = self:CalculateBestInSlot(slotID, selectedItems)

	if not itemTable then return end

	-- special cases for main an offhand (to account for dual wielding and Titan's Grip)
	if slotID == INVSLOT_MAINHAND then
		-- check if off hand is forced
		if self.slotCounters[INVSLOT_OFFHAND] then
			-- use 1H-weapon in main hand (or a titan's grip 2H, if applicable)
			return self:CalculateBestInSlot(INVSLOT_MAINHAND, selectedItems, FilterOneHanded)
		else
			-- choose best main- and offhand combo
			if not self.set:IsOnehandedWeapon(itemTable.itemID) then
				-- see if a combination of main and offhand would have a better score
				local bestMainScore, bestOffScore = 0, 0
				local bestOff = nil
				local bestMain = self:CalculateBestInSlot(INVSLOT_MAINHAND, selectedItems, FilterOneHanded)
				if bestMain then
					bestMainScore = (self.set:GetItemScore(bestMain.itemLink) or 0)
				end
				local withMainhand = ns.MergeAssocInto({}, selectedItems, {[INVSLOT_MAINHAND] = bestMain})
				if (self.set:CanDualWield()) then
					-- any non-two-handed offhand is fine
					bestOff = self:CalculateBestInSlot(INVSLOT_OFFHAND, withMainhand, FilterOneHanded)
				else
					-- offhand may not be a weapon (only shield, other offhand...)
					bestOff = self:CalculateBestInSlot(INVSLOT_OFFHAND, withMainhand, FilterNoWeapon)
				end
				if bestOff then
					bestOffScore = (self.set:GetItemScore(bestOff.itemLink) or 0)
				end

				-- alternatively, calculate offhand first, then mainhand
				local bestMainScore2, bestOffScore2 = 0, 0
				local bestMain2 = nil
				local bestOff2 = nil
				if (self.set:CanDualWield()) then
					-- any non-two-handed offhand is fine
					bestOff2 = self:CalculateBestInSlot(INVSLOT_OFFHAND, selectedItems, FilterOneHanded)
				else
					-- offhand may not be a weapon (only shield, other offhand...)
					bestOff2 = self:CalculateBestInSlot(INVSLOT_OFFHAND, selectedItems, FilterNoWeapon)
				end
				if bestOff2 then
					bestOffScore2 = (self.set:GetItemScore(bestOff2.itemLink) or 0)
				end

				local withOffhand = ns.MergeAssocInto({}, selectedItems, {[INVSLOT_OFFHAND] = bestOff2})
				bestMain2 = self:CalculateBestInSlot(INVSLOT_MAINHAND, withOffhand, FilterOneHanded)
				if bestMain2 then
					bestMainScore2 = (self.set:GetItemScore(bestMain2.itemLink) or 0)
				end

				local maxScore = (self.set:GetItemScore(itemTable.itemLink) or 0)
				if (maxScore < (bestMainScore + bestOffScore)) then
					-- main- + offhand is better, use the one-handed mainhand
					itemTable = bestMain
					maxScore = bestMainScore + bestOffScore
					--ns:Debug("Choosing Mainhand "..itemTable.itemLink)
				end
				if (maxScore < (bestMainScore2 + bestOffScore2)) then
					-- main- + offhand is better, use the one-handed mainhand
					itemTable = bestMain2
					--ns:Debug("Choosing Mainhand "..itemTable.itemLink)
				end
			end -- if mainhand would not be twohanded anyway, it can just be used
		end
	elseif (slotID == INVSLOT_OFFHAND) then
		-- check if mainhand is empty or one-handed
		if (not selectedItems[INVSLOT_MAINHAND]) or (self.set:IsOnehandedWeapon(selectedItems[INVSLOT_MAINHAND].itemLink)) then
			-- check if player can dual wield
			if self.set:CanDualWield() then
				-- only use 1H-weapons in Offhand
				itemTable = self:CalculateBestInSlot(INVSLOT_OFFHAND, selectedItems, FilterOneHanded)
			else
				-- player cannot dualwield, only use offhands which are not weapons
				itemTable = self:CalculateBestInSlot(INVSLOT_OFFHAND, selectedItems, FilterNoWeapon)
			end
		else
			-- Two-handed mainhand means we leave offhand empty
			itemTable = nil
		end
	end

	return itemTable
end

-- replacement of old function that no longer uses locationTables
function DefaultCalculation:CalculateBestInSlot(slotID, selectedItems, assertion)
	--TODO: make sure this doesn't break any uniqueness constraints
	-- get best item(s) for each equipment slot
	local availableItems = self:GetItems(slotID)
	if not availableItems then return end

	local bis, maxScore

	-- iterate all items of given location
	for _, itemTable in pairs(availableItems) do
		if (itemTable and ((maxScore or 0) < self.set:GetItemScore(itemTable.itemLink))) -- score
			and (not assertion or assertion(self, itemTable)) then -- optional assertion is true
			-- also check if item has been chosen already (so we don't get the same ring / trinket twice)
			local itemAvailable = true
			if selectedItems then
				for _, item in pairs(selectedItems) do
					if item.itemLink == itemTable.itemLink and self:GetItemCount(item.itemLink) < 2 then
						itemAvailable = false
						break
					end
				end
			end

			if itemAvailable then
				bis = itemTable
				maxScore = self.set:GetItemScore(itemTable.itemLink)
			end
		end
	end

	return bis
end
