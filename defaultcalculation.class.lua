--TODO: split into multiple files
local addonName, ns, _ = ...

local DefaultCalculation = ns.class(ns.Calculation)
ns.DefaultCalculation = DefaultCalculation

-- run steps needed for initializing the calculation process
function DefaultCalculation:Initialize()
	ns.itemRecommendations = {}

	self.combinationCount = 0
	self.slotCounters = {}
	self.bestCombination = nil
	self.maxScore = nil

	self:InitializeCapHeuristics()
	self:InitializeAvailableUniqueItems()

	self:InitializeSlots(INVSLOT_FIRST_EQUIPPED - 1) --TODO: why INVSLOT_FIRST_EQUIPPED - 1?
end

--- Find out how much of a given capped stat can be contributed by any slot
function DefaultCalculation:InitializeCapHeuristics()
	self.capHeuristics = {}

	-- create maximum values for each cap and item slot
	for statCode, _ in pairs(self.set:GetHardCaps()) do
		self.capHeuristics[statCode] = {}
		for _, slotID in pairs(ns.slots) do
			local items = self:GetItems(slotID)

			-- get maximum value contributed to cap in this slot
			local maxStat = 0
			for _, itemTable in pairs(items) do
				local thisStat = itemTable.totalBonus[statCode] or 0

				if thisStat > maxStat then
					maxStat = thisStat
				end
			end

			self.capHeuristics[statCode][slotID] = maxStat
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

-- run single step of this calculation
function DefaultCalculation:Step()
	-- set counters to next combination

	-- check all nil counters from the end
	local currentSlot = INVSLOT_LAST_EQUIPPED
	local increased = false
	while (not increased) and (currentSlot > 0) do
		local currentItems = self:GetItems()
		while (self.slotCounters[currentSlot] == nil or self.slotCounters[currentSlot] == #currentItems[currentSlot]) and (currentSlot > 0) do
			self.slotCounters[currentSlot] = nil -- reset to "no item"
			currentSlot = currentSlot - 1
		end

		if (currentSlot >= INVSLOT_FIRST_EQUIPPED) then
			-- increase combination, starting at currentSlot
			self.slotCounters[currentSlot] = self.slotCounters[currentSlot] + 1
			if (not self:IsDuplicateItem(currentSlot)) and (self:IsOffhandValid(currentSlot)) then
				increased = true
			end
		else
			-- we're back here, and so we're done
			TopFit:Debug("Finished calculation after " .. math.ceil(self.elapsed * 100) / 100 .. " seconds at " .. self:GetOperationsPerFrame() .. " operations per frame")
			self:Done()
			return
		end
	end

	currentSlot = self:InitializeSlots(currentSlot)
end

function DefaultCalculation:InitializeSlots(currentSlot)
	-- fill all further slots with first choices again - until caps are reached or unreachable
	while (not self:IsCapsReached(currentSlot) or self.moreUniquesAvailable[currentSlot]) and not self:IsCapsUnreachable(currentSlot) and not self:UniquenessViolated(currentSlot) and (currentSlot < INVSLOT_LAST_EQUIPPED) do
		currentSlot = currentSlot + 1
		local currentItems = self:GetItems(currentSlot)
		if #currentItems > 0 then
			self.slotCounters[currentSlot] = 1
			while self:IsDuplicateItem(currentSlot) or self:UniquenessViolated(currentSlot) or (not self:IsOffhandValid(currentSlot)) do
				self.slotCounters[currentSlot] = self.slotCounters[currentSlot] + 1
			end
			if self.slotCounters[currentSlot] > #currentItems then
				self.slotCounters[currentSlot] = 0
			end
		else
			self.slotCounters[currentSlot] = 0
		end
	end

	if self:IsCapsReached(currentSlot) and not self:UniquenessViolated(currentSlot) then
		-- valid combination, save
		self:SaveCurrentCombination()
	else
		TopFit:Debug("Invalid combination - " ..currentSlot .. ': ' .. (self:IsCapsReached(currentSlot) and "true" or "nil"), (self:UniquenessViolated(currentSlot) and "true" or "nil"), (self.moreUniquesAvailable[currentSlot] and "true" or "nil"), (self:IsCapsUnreachable(currentSlot) and "true" or "nil"))
	end

	return currentSlot
end

--- Returns the item currently selected for a slot
function DefaultCalculation:GetCurrentItem(slotID)
	if self.slotCounters[slotID] and self.slotCounters[slotID] > 0 then
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
	if not self.done then --TODO: variable has been removed, replace with new way of checking whether calculation has finished
		local progress = 0
		local impact = 1
		for slot = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED + 1 do
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
	else
		return 1
	end
end

local secondaryStats = {'ITEM_MOD_SPIRIT_SHORT', 'ITEM_MOD_CRIT_RATING_SHORT', 'ITEM_MOD_HASTE_RATING_SHORT', --[['ITEM_MOD_HIT_RATING_SHORT', ]]'ITEM_MOD_MASTERY_RATING_SHORT'}
function DefaultCalculation:ApplySecondaryPercentBonus(stat, value)
	-- TODO: this is probably slow to check evey time and should be cached
	for j = 1, #secondaryStats do
		if secondaryStats[j] == stat then
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

-- check whether the selected items up to currentSlot already fulfill all hard cap requirements
function DefaultCalculation:IsCapsReached(currentSlot)
	local currentValues = {}
	for slotID = 1, currentSlot do
		if self.slotCounters[slotID] ~= nil and self.slotCounters[slotID] > 0 then
			for stat, _ in pairs(self.set:GetHardCaps()) do
				local itemTable = self:GetItem(slotID, self.slotCounters[slotID])
				if itemTable then
					currentValues[stat] = (currentValues[stat] or 0) + (itemTable.totalBonus[stat] or 0)
				end
			end
		end
	end

	for stat, value in pairs(self.set:GetHardCaps()) do
		if (self:ApplySecondaryPercentBonus(stat, currentValues[stat] or 0)) < value then
			return false
		end
	end
	return true
end

-- check whether the selected items up to currentSlot make it impossible to fulfill any hard cap requirements
function DefaultCalculation:IsCapsUnreachable(currentSlot)
	local currentValues = {}
	local restValues = {}
	for stat, value in pairs(self.set:GetHardCaps()) do
		for slotID = INVSLOT_FIRST_EQUIPPED, currentSlot do
			local itemTable = self:GetItem(slotID, self.slotCounters[slotID])
			if self.slotCounters[slotID] ~= nil and self.slotCounters[slotID] > 0 and itemTable then
				currentValues[stat] = (currentValues[stat] or 0) + (itemTable.totalBonus[stat] or 0)
			end
		end

		for slotID = currentSlot + 1, INVSLOT_LAST_EQUIPPED do
			restValues[stat] = (restValues[stat] or 0) + (self.capHeuristics[stat][slotID] or 0)
		end

		if (currentValues[stat] or 0) + (restValues[stat] or 0) < value then
			TopFit:Debug("|cffff0000Caps unreachable - "..stat.." reached "..(currentValues[stat] or 0).." + "..(restValues[stat] or 0).." / "..value)
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
		if self.slotCounters[slotID] and self.slotCounters[slotID] ~= 0 then
			local itemTable = self:GetItem(slotID, self.slotCounters[slotID])
			if itemTable then
				for stat, amount in pairs(itemTable.totalBonus) do
					if stat:find('^UNIQUE: ') then
						currentValues[stat] = (currentValues[stat] or 0) + (amount or 0)
					end
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
	--TODO: do not rely on global funciton to determine item count, it should by apparent by how ofthen the item has been added to the calculation
	for i = INVSLOT_FIRST_EQUIPPED, currentSlot - 1 do
		if self.slotCounters[i] and self.slotCounters[i] > 0 then
			local item1 = self:GetItem(i, self.slotCounters[i])
			local item2 = self:GetItem(currentSlot, self.slotCounters[currentSlot])
			if item1 and item2 and item1 == item2 and self:GetItemCount(item1.itemLink) < 2 then
				return true
			end
		end
	end
	return false
end

-- assertion functions for CalculateBestInSlot
local function FilterOneHanded(calculation, itemTable)
	return ns:IsOnehandedWeapon(calculation.set, itemTable.itemLink)
end
local function FilterNoWeapon(calculation, itemTable)
	return not itemTable.itemEquipLoc:find("WEAPON")
end

-- check whether the currently selected offhand is valid for this calculation
function DefaultCalculation:IsOffhandValid(currentSlot)
	if currentSlot == INVSLOT_OFFHAND then -- offhand slot
		if (self.slotCounters[INVSLOT_OFFHAND] ~= nil) and (self.slotCounters[INVSLOT_OFFHAND] > 0) then -- offhand is set to something
			if (self.slotCounters[INVSLOT_MAINHAND] == nil or self.slotCounters[INVSLOT_MAINHAND] == 0) or -- no Mainhand is forced
				(TopFit:IsOnehandedWeapon(self.set, self:GetItem(INVSLOT_MAINHAND, self.slotCounters[INVSLOT_MAINHAND]).itemLink)) then -- Mainhand is not a Two-Handed Weapon

				local itemTable = self:GetItem(INVSLOT_OFFHAND, self.slotCounters[INVSLOT_OFFHAND])
				if not itemTable then return false end

				if self.set:CanDualWield() then
					-- off hand may be a one-handed weapon
					if not FilterOneHanded(self, itemTable) then
						return false
					end
				else
					-- no weapons allowed in off hand
					if not FilterNoWeapon(self, itemTable) then
						return false
					end
				end
			else
				-- a 2H-Mainhand is set, there can be no offhand!
				return false
			end
		end
	end
	return true
end

--TODO: use INVSLOT_-constants
function DefaultCalculation:SaveCurrentCombination()
	self.combinationCount = self.combinationCount + 1

	local currentCombination = { --TODO: reuse tables
		items = {},
		totalScore = 0,
		totalStats = {},
	}

	local itemsAlreadyChosen = {}

	local i
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED + 1 do
		local itemTable = nil
		local stat, slotTable

		if self.slotCounters[i] ~= nil and self.slotCounters[i] > 0 then
			itemTable = self:GetItem(i, self.slotCounters[i])
		else
			-- choose highest valued item for otherwise empty slots, if possible
			itemTable = self:CalculateBestInSlot(itemsAlreadyChosen, i)

			if itemTable then
				-- special cases for main an offhand (to account for dual wielding and Titan's Grip)
				if i == INVSLOT_MAINHAND then
					-- check if off hand is forced
					if self.slotCounters[INVSLOT_OFFHAND] then
						-- use 1H-weapon in main hand (or a titan's grip 2H, if applicable)
						itemTable = self:CalculateBestInSlot(itemsAlreadyChosen, i, FilterOneHanded)
					else
						-- choose best main- and offhand combo
						if not ns:IsOnehandedWeapon(self.set, itemTable.itemID) then
							-- see if a combination of main and offhand would have a better score
							local bestMainScore, bestOffScore = 0, 0
							local bestOff = nil
							local bestMain = self:CalculateBestInSlot(itemsAlreadyChosen, i, FilterOneHanded)
							if bestMain then
								bestMainScore = (self.set:GetItemScore(bestMain.itemLink) or 0)
							end
							if (self.set:CanDualWield()) then
								-- any non-two-handed offhand is fine
								bestOff = self:CalculateBestInSlot(ns:JoinTables(itemsAlreadyChosen, bestMain and {bestMain.itemLink}), i + 1, FilterOneHanded)
							else
								-- offhand may not be a weapon (only shield, other offhand...)
								bestOff = self:CalculateBestInSlot(ns:JoinTables(itemsAlreadyChosen, bestMain and {bestMain.itemLink}), i + 1, FilterNoWeapon)
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
								bestOff2 = self:CalculateBestInSlot(itemsAlreadyChosen, i + 1, FilterOneHanded)
							else
								-- offhand may not be a weapon (only shield, other offhand...)
								bestOff2 = self:CalculateBestInSlot(itemsAlreadyChosen, i + 1, FilterNoWeapon)
							end
							if bestOff2 then
								bestOffScore2 = (self.set:GetItemScore(bestOff2.itemLink) or 0)
							end

							bestMain2 = self:CalculateBestInSlot(ns:JoinTables(itemsAlreadyChosen, bestOff2 and {bestOff2.itemLink}), i, FilterOneHanded)
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
				elseif (i == INVSLOT_OFFHAND) then
					-- check if mainhand is empty or one-handed
					if (not currentCombination.items[i - 1]) or (ns:IsOnehandedWeapon(self.set, currentCombination.items[i - 1].itemLink)) then
						-- check if player can dual wield
						if self.set:CanDualWield() then
							-- only use 1H-weapons in Offhand
							itemTable = self:CalculateBestInSlot(itemsAlreadyChosen, i, FilterOneHanded)
						else
							-- player cannot dualwield, only use offhands which are not weapons
							itemTable = self:CalculateBestInSlot(itemsAlreadyChosen, i, FilterNoWeapon)
						end
					else
						-- Two-handed mainhand means we leave offhand empty
						itemTable = nil
					end
				end
			end
		end

		if itemTable then -- slot will be filled
			tinsert(itemsAlreadyChosen, itemTable.itemLink)
			currentCombination.items[i] = itemTable
			currentCombination.totalScore = currentCombination.totalScore + (self.set:GetItemScore(itemTable.itemLink) or 0)

			-- add total stats
			for stat, value in pairs(itemTable.totalBonus) do
				currentCombination.totalStats[stat] = (currentCombination.totalStats[stat] or 0) + value
			end
		end
	end

	-- check all caps one last time and see if all are reached
	local satisfied = true
	for stat, value in pairs(self.set:GetHardCaps()) do
		if ((not currentCombination.totalStats[stat]) or (currentCombination.totalStats[stat] < value)) then
			satisfied = false
			break
		end
	end

	-- check if any uniqueness constraints are broken
	if not self.set.calculationData.ignoreCapsForCalculation then
		for stat, value in pairs(currentCombination.totalStats) do
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
	if ((satisfied) and ((self.maxScore == nil) or (self.maxScore < currentCombination.totalScore))) then
		self.maxScore = currentCombination.totalScore
		self.bestCombination = currentCombination
	end
end

-- replacement of old function that no longer uses locationTables
function DefaultCalculation:CalculateBestInSlot(itemsAlreadyChosen, slotID, assertion)
	--TODO: make sure this doesn't break any uniqueness constraints
	-- get best item(s) for each equipment slot
	local set = self.set
	local bis = {}
	local itemListBySlot = self:GetItems()
	for slot, itemsTable in pairs(itemListBySlot) do
		if not slotID or slotID == slot then
			local maxScore = nil

			-- iterate all items of given location
			for _, itemTable in pairs(itemsTable) do
				if (itemTable and ((maxScore == nil) or (maxScore < set:GetItemScore(itemTable.itemLink)))) -- score
					and (not assertion or assertion(self, itemTable)) then -- optional assertion is true
					-- also check if item has been chosen already (so we don't get the same ring / trinket twice)
					local itemAvailable = true
					if itemsAlreadyChosen then
						for _, itemLink in pairs(itemsAlreadyChosen) do
							if itemLink == itemTable.itemLink and self:GetItemCount(itemLink) < 2 then
								itemAvailable = false
								break
							end
						end
					end

					if itemAvailable then
						bis[slot] = itemTable
						maxScore = set:GetItemScore(itemTable.itemLink)
					end
				end
			end
		end
	end

	if not slotID then
		return bis
	else
		-- return only the slot item's table (if it exists)
		return bis[slotID]
	end
end

-- now with assertion as optional parameter
function ns:CalculateBestInSlot(set, itemsAlreadyChosen, insert, sID, setCode, assertion) --TODO: make sure this doesn't break any uniqueness constraints
	-- get best item(s) for each equipment slot
	local bis = {}
	local itemListBySlot = ns.itemListBySlot or ns:GetEquippableItems()
	for slotID, itemsTable in pairs(itemListBySlot) do
		if ((not sID) or (sID == slotID)) then -- use single slot if sID is set, or all slots
			bis[slotID] = {}
			local maxScore = nil

			-- iterate all items of given location
			for _, locationTable in pairs(itemsTable) do
				local itemTable = ns:GetCachedItem(locationTable.itemLink)

				if (itemTable and ((maxScore == nil) or (maxScore < set:GetItemScore(itemTable.itemLink))) -- score
					and (itemTable.itemMinLevel <= ns.characterLevel or locationTable.isVirtual)) -- character level
					and (not assertion or assertion(locationTable)) then -- optional assertion is true
					-- also check if item has been chosen already (so we don't get the same ring / trinket twice)
					local found = false
					if (itemsAlreadyChosen) then
						for _, lTable in pairs(itemsAlreadyChosen) do
							if ((not lTable.bag and not lTable.slot) or ((lTable.bag == locationTable.bag) and (lTable.slot == locationTable.slot))) and (lTable.itemLink == locationTable.itemLink) then
								found = true
							end
						end
					end

					if not found then
						bis[slotID].locationTable = locationTable
						maxScore = set:GetItemScore(itemTable.itemLink)
					end
				end
			end

			if (not bis[slotID].locationTable) then
				-- remove dummy table if no item has been found
				bis[slotID] = nil
			else
				-- mark this item as used
				if (itemsAlreadyChosen and insert) then
					tinsert(itemsAlreadyChosen, bis[slotID].locationTable)
				end
			end
		end
	end

	if (not sID) then
		return bis
	else
		-- return only the slot item's table (if it exists)
		if (bis[sID]) then
			return bis[sID].locationTable
		else
			return nil
		end
	end
end
