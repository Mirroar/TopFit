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
	self.capHeuristics = {}
	self.moreUniquesAvailable = {}

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

	-- cache up to which slot unique items are available
	local uniqueFound = false
	for slotID = 20, 0, -1 do
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

	self:InitializeSlots(0)
end

-- run single step of this calculation
function DefaultCalculation:Step()
	-- set counters to next combination

	-- check all nil counters from the end
	local currentSlot = 19
	local increased = false
	while (not increased) and (currentSlot > 0) do
		local currentItems = self:GetItems()
		while (self.slotCounters[currentSlot] == nil or self.slotCounters[currentSlot] == #currentItems[currentSlot]) and (currentSlot > 0) do
			self.slotCounters[currentSlot] = nil -- reset to "no item"
			currentSlot = currentSlot - 1
		end

		if (currentSlot > 0) then
			-- increase combination, starting at currentSlot
			self.slotCounters[currentSlot] = self.slotCounters[currentSlot] + 1
			if (not self:IsDuplicateItem(currentSlot)) and (self:IsOffhandValid(currentSlot)) then
				increased = true
			end
		else
			-- we're back here, and so we're done
			TopFit:Print("Finished calculation after " .. math.ceil(self.elapsed * 100) / 100 .. " seconds at " .. self:GetOperationsPerFrame() .. " operations per frame")
			self:Done()
			return
		end
	end

	currentSlot = self:InitializeSlots(currentSlot)
end

function DefaultCalculation:InitializeSlots(currentSlot)
	-- fill all further slots with first choices again - until caps are reached or unreachable
	while (not self:IsCapsReached(currentSlot) or self.moreUniquesAvailable[currentSlot]) and not self:IsCapsUnreachable(currentSlot) and not self:UniquenessViolated(currentSlot) and (currentSlot < 19) do
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
		TopFit:Debug("Invalid combination - " ..currentSlot .. ': ' .. (self:IsCapsReached(currentSlot) and "true" or "nil") .. ", " .. (self:UniquenessViolated(currentSlot) and "true" or "nil") .. ", " .. (self.moreUniquesAvailable[currentSlot] and "true" or "nil") .. ", " .. (self:IsCapsUnreachable(currentSlot) and "true" or "nil"))
	end

	return currentSlot
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
		for slot = 1, 20 do
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
			for slotID = 13, 14 do -- only need to check trinket slots
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
		for slotID = 1, currentSlot do
			local itemTable = self:GetItem(slotID, self.slotCounters[slotID])
			if self.slotCounters[slotID] ~= nil and self.slotCounters[slotID] > 0 and itemTable then
				currentValues[stat] = (currentValues[stat] or 0) + (itemTable.totalBonus[stat] or 0)
			end
		end

		for slotID = currentSlot + 1, 19 do
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
	for slotID = 1, currentSlot do
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
	for i = 1, currentSlot - 1 do
		if self.slotCounters[i] and self.slotCounters[i] > 0 then
			local item1 = self:GetItem(i, self.slotCounters[i])
			local item2 = self:GetItem(currentSlot, self.slotCounters[currentSlot])
			if item1 and item2 and item1 == item2 and ns.GetItemCount(item1.itemLink) < 2 then
				return true
			end
		end
	end
	return false
end

-- check whether the currently selected offhand is valid for this calculation
function DefaultCalculation:IsOffhandValid(currentSlot)
	if currentSlot == 17 then -- offhand slot
		if (self.slotCounters[17] ~= nil) and (self.slotCounters[17] > 0) then -- offhand is set to something
			if (self.slotCounters[16] == nil or self.slotCounters[16] == 0) or -- no Mainhand is forced
				(TopFit:IsOnehandedWeapon(self.set, self:GetItem(16, self.slotCounters[16]).itemLink)) then -- Mainhand is not a Two-Handed Weapon

				local itemTable = self:GetItem(17, self.slotCounters[17])
				if not itemTable then return false end

				if (not self.set:CanDualWield()) then
					if (string.find(itemTable.itemEquipLoc, "WEAPON")) then
						-- no weapon in offhand if you cannot dualwield
						return false
					end
				else -- player can dualwield
					if (not TopFit:IsOnehandedWeapon(self.set, itemTable.itemID)) then
						-- no 2h-weapon in offhand
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

function DefaultCalculation:SaveCurrentCombination()
	self.combinationCount = self.combinationCount + 1

	local cIC = {
		items = {},
		totalScore = 0,
		totalStats = {},
	}

	local itemsAlreadyChosen = {}

	local i
	for i = 1, 20 do
		local itemTable, locationTable = nil, nil
		local stat, slotTable

		if self.slotCounters[i] ~= nil and self.slotCounters[i] > 0 then
			locationTable = ns.itemListBySlot[i][self.slotCounters[i]]
			itemTable = ns:GetCachedItem(locationTable.itemLink)
		else
			-- choose highest valued item for otherwise empty slots, if possible
			locationTable = ns:CalculateBestInSlot(self.set, itemsAlreadyChosen, false, i)
			if locationTable then
				itemTable = ns:GetCachedItem(locationTable.itemLink)
			end

			if (itemTable) then
				-- special cases for main an offhand (to account for dualwielding and Titan's Grip)
				if (i == 16) then
					-- check if offhand is forced
					if self.slotCounters[17] then
						-- use 1H-weapon in Mainhand (or a titan's grip 2H, if applicable)
						locationTable = ns:CalculateBestInSlot(self.set, itemsAlreadyChosen, false, i, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(self.set, locationTable.itemLink) end)
						if locationTable then
							itemTable = ns:GetCachedItem(locationTable.itemLink)
						end
					else
						-- choose best main- and offhand combo
						if not ns:IsOnehandedWeapon(self.set, itemTable.itemID) then
							-- see if a combination of main and offhand would have a better score
							local bestMainScore, bestOffScore = 0, 0
							local bestOff = nil
							local bestMain = ns:CalculateBestInSlot(self.set, itemsAlreadyChosen, false, i, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(self.set, locationTable.itemLink) end)
							if bestMain ~= nil then
								bestMainScore = (self.set:GetItemScore(bestMain.itemLink) or 0)
							end
							if (self.set:CanDualWield()) then
								-- any non-two-handed offhand is fine
								bestOff = ns:CalculateBestInSlot(self.set, ns:JoinTables(itemsAlreadyChosen, {bestMain}), false, i + 1, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(self.set, locationTable.itemLink) end)
							else
								-- offhand may not be a weapon (only shield, other offhand...)
								bestOff = ns:CalculateBestInSlot(self.set, ns:JoinTables(itemsAlreadyChosen, {bestMain}), false, i + 1, ns.setCode, function(locationTable) local itemTable = ns:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
							end
							if bestOff ~= nil then
								bestOffScore = (self.set:GetItemScore(bestOff.itemLink) or 0)
							end

							-- alternatively, calculate offhand first, then mainhand
							local bestMainScore2, bestOffScore2 = 0, 0
							local bestMain2 = nil
							local bestOff2 = nil
							if (self.set:CanDualWield()) then
								-- any non-two-handed offhand is fine
								bestOff2 = ns:CalculateBestInSlot(self.set, itemsAlreadyChosen, false, i + 1, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(self.set, locationTable.itemLink) end)
							else
								-- offhand may not be a weapon (only shield, other offhand...)
								bestOff2 = ns:CalculateBestInSlot(self.set, itemsAlreadyChosen, false, i + 1, ns.setCode, function(locationTable) local itemTable = ns:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
							end
							if bestOff2 ~= nil then
								bestOffScore2 = (self.set:GetItemScore(bestOff2.itemLink) or 0)
							end

							bestMain2 = ns:CalculateBestInSlot(self.set, ns:JoinTables(itemsAlreadyChosen, {bestOff2}), false, i, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(self.set, locationTable.itemLink) end)
							if bestMain2 ~= nil then
								bestMainScore2 = (self.set:GetItemScore(bestMain2.itemLink) or 0)
							end

							local maxScore = (self.set:GetItemScore(itemTable.itemLink) or 0)
							if (maxScore < (bestMainScore + bestOffScore)) then
								-- main- + offhand is better, use the one-handed mainhand
								locationTable = bestMain
								if locationTable then
									itemTable = ns:GetCachedItem(locationTable.itemLink)
								end
								maxScore = bestMainScore + bestOffScore
								--ns:Debug("Choosing Mainhand "..itemTable.itemLink)
							end
							if (maxScore < (bestMainScore2 + bestOffScore2)) then
								-- main- + offhand is better, use the one-handed mainhand
								locationTable = bestMain2
								if locationTable then
									itemTable = ns:GetCachedItem(locationTable.itemLink)
								end
								--ns:Debug("Choosing Mainhand "..itemTable.itemLink)
							end
						end -- if mainhand would not be twohanded anyway, it can just be used
					end
				elseif (i == 17) then
					-- check if mainhand is empty or one-handed
					if (not cIC.items[i - 1]) or (ns:IsOnehandedWeapon(self.set, cIC.items[i - 1].itemLink)) then
						-- check if player can dual wield
						if self.set:CanDualWield() then
							-- only use 1H-weapons in Offhand
							locationTable = ns:CalculateBestInSlot(self.set, itemsAlreadyChosen, false, i, ns.setCode, function(locationTable) return ns:IsOnehandedWeapon(self.set, locationTable.itemLink) end)
							if locationTable then
								itemTable = ns:GetCachedItem(locationTable.itemLink)
							end
						else
							-- player cannot dualwield, only use offhands which are not weapons
							locationTable = ns:CalculateBestInSlot(self.set, itemsAlreadyChosen, false, i, ns.setCode, function(locationTable) local itemTable = ns:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
							if locationTable then
								itemTable = ns:GetCachedItem(locationTable.itemLink)
							end
						end
					else
						-- Two-handed mainhand means we leave offhand empty
						locationTable = nil
						itemTable = nil
					end
				end
			end
		end

		if locationTable and itemTable then -- slot will be filled
			tinsert(itemsAlreadyChosen, locationTable)
			cIC.items[i] = locationTable
			cIC.totalScore = cIC.totalScore + (self.set:GetItemScore(itemTable.itemLink) or 0)

			-- add total stats
			for stat, value in pairs(itemTable.totalBonus) do
				cIC.totalStats[stat] = (cIC.totalStats[stat] or 0) + value
			end
		end
	end

	-- check all caps one last time and see if all are reached
	local satisfied = true
	for stat, value in pairs(self.set:GetHardCaps()) do
		if ((not cIC.totalStats[stat]) or (cIC.totalStats[stat] < value)) then
			satisfied = false
			break
		end
	end

	-- check if any uniqueness contraints are broken
	if not self.set.calculationData.ignoreCapsForCalculation then
		for stat, value in pairs(cIC.totalStats) do
			if (string.sub(stat, 1, 8) == "UNIQUE: ") then
				local _, maxCount = strsplit("*", stat)
				maxCount = tonumber(maxCount)
				if value > maxCount then
					satisfied = false
					break
				end
			end
		end--]]
	end

	-- check if it's better than old best
	if ((satisfied) and ((self.maxScore == nil) or (self.maxScore < cIC.totalScore))) then
		self.maxScore = cIC.totalScore
		self.bestCombination = cIC
	end
end

-- now with assertion as optional parameter
function ns:CalculateBestInSlot(set, itemsAlreadyChosen, insert, sID, setCode, assertion) --TODO: make sure this doesn't break any uniqueness constraints
	if not setCode then setCode = ns.setCode end

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
