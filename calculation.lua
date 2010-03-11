
function TopFit:StartCalculations(info, input)
    -- generate table of set codes
    TopFit.workSetList = {}
    for setCode, _ in pairs(self.db.profile.sets) do
	tinsert(TopFit.workSetList, setCode)
    end
    
    TopFit:CalculateSets()
end

function TopFit:AbortCalculations(info, input)
    if TopFit.isBlocked then
	TopFit.abortCalculation = true
    end
end

function TopFit:StartCalculationsForSet(info, input)
    setCode = info[#info - 1]
    TopFit.workSetList = {}
    tinsert(TopFit.workSetList, setCode)
    
    TopFit:CalculateSets()
end

function TopFit:CalculateSets()
    HideUIPanel(InterfaceOptionsFrame)
    local setCode = tremove(TopFit.workSetList)

    TopFit.characterLevel = UnitLevel("player")
    TopFit.setCode = setCode

    TopFit:Debug("Calculating items for "..setCode)

    if (not TopFit.isBlocked) then
	-- set as working to prevent any further calls from "interfering"
	TopFit.isBlocked = true
	
	-- check if any "caps" have been set
	TopFit.Utopia = {} -- I'm not just setting this to self.db.profile.sets[setCode].caps to prevent overwriting of user preferences
	for statCode, preferences in pairs(self.db.profile.sets[setCode].caps) do
	    if (preferences["active"]) then
		TopFit.Utopia[statCode] = {
		    value = preferences["value"],
		    soft = preferences["soft"],
		    active = true
		}
	    end
	end
	
	-- do the actual work
	TopFit:collectItems()
	TopFit:CalculateScores(self.db.profile.sets[setCode].weights, TopFit.Utopia)
	TopFit:CalculateRecommendations(self.db.profile.sets[setCode].name)
    end
end

--start calculation for setName
function TopFit:CalculateRecommendations(setName)
    TopFit.itemRecommendations = {}
    TopFit.currentItemCombination = {}
    TopFit.itemCombinations = {}
    TopFit.currentSetName = setName
    
    -- determine if the player can dualwield
    TopFit.playerCanDualWield = false
    TopFit.playerCanTitansGrip = false
    if (select(2, UnitClass("player")) == "ROGUE") or (((select(2, UnitClass("player")) == "WARRIOR") or (select(2, UnitClass("player")) == "HUNTER")) and (UnitLevel("player") > 20)) or
	((select(2, UnitClass("player")) == "SHAMAN") and (select(5, GetTalentInfo(2, 20)) > 0)) then
        TopFit.playerCanDualWield = true
    end
    if ((select(2, UnitClass("player")) == "WARRIOR") and (select(5, GetTalentInfo(2, 27)) > 0)) then
        TopFit.playerCanTitansGrip = true
    end
    
    TopFit:Print("Yes, master. I shall immediately gather your \""..setName.."\" items...")

    --TopFit:CalculateItemTablesRecursively(slotsDone)
    TopFit:InitSemiRecursiveCalculations()
end

function TopFit:InitSemiRecursiveCalculations()
    TopFit:ReduceItemList()
    
    TopFit.slotCounters = {}
    TopFit.currentSlotCounter = 0
    TopFit.operationsPerFrame = 500
    TopFit.goingUp = true
    TopFit.combinationCount = 0
    TopFit.bestCombination = nil
    TopFit.maxScore = nil
    
    TopFit.capHeuristics = {}
    TopFit.maxRestStat = {}
    TopFit.currentCapValues = {}
    -- create maximum values for each cap and item slot
    for statCode, preferences in pairs(TopFit.Utopia) do
	TopFit.capHeuristics[statCode] = {}
	TopFit.maxRestStat[statCode] = {}
	for _, slotID in pairs(TopFit.slots) do
	    if (TopFit.itemListBySlot[slotID]) then
		-- get maximum value contributed to cap in this slot
		local maxStat = nil
		for _, itemTable in pairs(TopFit.itemListBySlot[slotID]) do
		    local thisStat = itemTable["totalBonus"][statCode] or 0
		    
		    if ((thisStat > 0) and ((maxStat == nil) or (thisStat > maxStat))) then
			maxStat = thisStat
		    end
		end
		
		TopFit.capHeuristics[statCode][slotID] = maxStat
	    end
	end
	
	for i = 0, 20 do
	    TopFit.maxRestStat[statCode][i] = 0
	    if (TopFit.capHeuristics[statCode][i]) then
		for j = 0, i do
		    TopFit.maxRestStat[statCode][j] = TopFit.maxRestStat[statCode][j] + TopFit.capHeuristics[statCode][i]
		end
	    end
	end
    end
    
    TopFit.calculationsFrame = CreateFrame("Frame");
    TopFit.calculationsFrame:SetScript("OnUpdate", TopFit.SemiRecursiveCalculation)
    
    -- show progress frame
    TopFit:CreateProgressFrame()
    TopFit.ProgressFrame:SetSetName(TopFit.currentSetName)
    TopFit.ProgressFrame:ResetProgress()
end

function TopFit:SemiRecursiveCalculation()
    local operation
    local done = false
    for operation = 1, TopFit.operationsPerFrame do
	if ((not done) and (not TopFit.abortCalculation)) then
	    -- traverse slots in current direction
	    if (TopFit.goingUp) then
		TopFit.currentSlotCounter = TopFit.currentSlotCounter + 1
	    else
		TopFit.currentSlotCounter = TopFit.currentSlotCounter - 1
	    end
	    
	    -- check if currentSlot is invalid or can not contribute to caps
	    if (TopFit.itemListBySlot[TopFit.currentSlotCounter]) then
		local stat, slotTable
		local useful = false
		for stat, slotTable in pairs(TopFit.capHeuristics) do
		    if ((slotTable[TopFit.currentSlotCounter]) and (slotTable[TopFit.currentSlotCounter] > 0)) then
			useful = true
			break
		    end
		end
		
		if (useful) then
		    -- check if we are going down (backwards through slots) and find a valid counter to increase
		    if ((TopFit.slotCounters[TopFit.currentSlotCounter] ~= nil) and (not TopFit.goingUp)) then
			-- increase current slot's counter, go up again
			TopFit.goingUp = true
			TopFit.slotCounters[TopFit.currentSlotCounter] = TopFit.slotCounters[TopFit.currentSlotCounter] + 1
			
			-- do that until we reach an item that has not been used yet in another slot and is equippable
			TopFit:CheckCurrentSlotForDuplicates()
			
			-- if there are no more items in this slot, reset this counter and keep going down instead
			if (not TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
			    TopFit.goingUp = false
			    TopFit.slotCounters[TopFit.currentSlotCounter] = nil
			end
		    -- we are going up and found a new counter to start incrementing
		    elseif TopFit.goingUp then
			TopFit.slotCounters[TopFit.currentSlotCounter] = 1
			
			-- make sure the item has not been used in another slot, otherwise keep incrementing, 
			TopFit:CheckCurrentSlotForDuplicates()
			
			-- set to nil if there is no available item
			if (not TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
			    TopFit.slotCounters[TopFit.currentSlotCounter] = nil
			end
		    end
		end
	    end
	    
	    -- find current values towards caps
	    for stat, preferences in pairs(TopFit.Utopia) do
		if (not TopFit.currentCapValues[stat]) then
		    TopFit.currentCapValues[stat] = {[-1] = 0, [0] = 0, [1] = 0, } 
		end
		
		-- same value as counter - 1, plus whatever current item provides
		TopFit.currentCapValues[stat][TopFit.currentSlotCounter] = TopFit.currentCapValues[stat][TopFit.currentSlotCounter - 1]
		
		if (TopFit.slotCounters[TopFit.currentSlotCounter]) then
		    local itemTable = TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]
		    
		    -- add up stat
		    if (itemTable.totalBonus[stat]) then
			TopFit.currentCapValues[stat][TopFit.currentSlotCounter] = TopFit.currentCapValues[stat][TopFit.currentSlotCounter] + itemTable.totalBonus[stat]
		    end
		end
	    end
	    
	    if (TopFit.goingUp) then
		-- check if any cap is not reachable anymore with current item combination
		local notReachable = false
		for stat, preferences in pairs(TopFit.Utopia) do
		    if (TopFit.currentSlotCounter < 20) then
			if ((TopFit.currentCapValues[stat][TopFit.currentSlotCounter] +
			    TopFit.maxRestStat[stat][TopFit.currentSlotCounter]) <
			    tonumber(preferences["value"])) then
			    -- in that case, stop here and go down again to find alternatives
			    --TopFit:Debug("Cap not reachable - cur: "..(TopFit.currentCapValues[stat][TopFit.currentSlotCounter] or "nil")..", rest: "..(TopFit.maxRestStat[stat][TopFit.currentSlotCounter] or "nil")..", cap: "..(tonumber(preferences.value) or "nil"))
			    notReachable = true
			end
		    end
		end
		if (notReachable) then
		    --TopFit.currentSlotCounter = TopFit.currentSlotCounter + 1
		    TopFit.goingUp = false
		else
		    -- check if all caps have been reached already with current item combination
		    local capReached = true
		    for stat, preferences in pairs(TopFit.Utopia) do
			if (TopFit.currentSlotCounter < 20) then
			    if (TopFit.currentCapValues[stat][TopFit.currentSlotCounter] <
				tonumber(preferences["value"])) then
				--TopFit:Debug("Cap not reached: "..(TopFit.currentCapValues[stat][TopFit.currentSlotCounter] or "nil"))
				
				capReached = false
			    end
			end
		    end
		    if (capReached) then
			-- in that case, get best in slot for the other applicable slots, save, increase currentSlotCounter and go down again (to consider next alternative)
			TopFit:SaveCurrentCombination()
			
			TopFit.currentSlotCounter = TopFit.currentSlotCounter + 1
			TopFit.goingUp = false
		    end
		end
	    end
	    
	    -- if we reached the bottom, we are done, yes!!!
	    if (TopFit.currentSlotCounter < 0) then
		TopFit:Debug("DONE!")
		done = true
		TopFit.calculationsFrame:SetScript("OnUpdate", nil)
		operation = TopFit.operationsPerFrame
		
		-- save a default set of only best-in-slot items
		TopFit:SaveCurrentCombination()
		
		TopFit:Print("Calculations are done. I tried a total of "..TopFit.combinationCount.." combinations.")
		
		-- find best combination that satisfies ALL caps
		if (TopFit.bestCombination) then
		    -- caps are reached, save and equip best combination
		    local itemsAlreadyChosen = {}
		    for slotID, itemTable in pairs(TopFit.bestCombination.items) do
			TopFit.itemRecommendations[slotID] = {
			    ["itemTable"] = itemTable,
			}
			tinsert(itemsAlreadyChosen, itemTable)
		    end
		else
		    -- caps could not all be reached, calculate without caps instead
		    TopFit:Print("I am very sorry, but you conditions could not all be fulfilled. I will however give you the items best suited to your tastes.")
		    TopFit.Utopia = {}
		    TopFit:collectItems()
		    TopFit:CalculateScores(TopFit.db.profile.sets[TopFit.setCode].weights, TopFit.Utopia)
		    TopFit:CalculateRecommendations(TopFit.currentSetName)
		    return
		end
		
		TopFit:EquipRecommendedItems()
		--TopFit:HideProgressFrame()
	    end
	end
    end
    
    -- update progress
    if not done then
	local progress = 0
	local impact = 1
	local slot
	for slot = 1, 20 do
	    -- check if slot has items for calculation
	    if TopFit.itemListBySlot[slot] then
		-- calculate current progress towards finish
		local numItemsInSlot = #(TopFit.itemListBySlot[slot]) or 1
		local selectedItem = TopFit.slotCounters[slot] or 1
		if numItemsInSlot == 0 then numItemsInSlot = 1 end
		if selectedItem == 0 then selectedItem = 1 end
		
		-- TopFit:Debug("(Slot "..slot..") - numItems: "..numItemsInSlot.."; selected: "..selectedItem.."; old Progress: "..progress.."; old impact: "..impact)
		
		impact = impact / numItemsInSlot
		progress = progress + impact * (selectedItem - 1)
	    end
	end
	
	TopFit:Debug("Progress: "..(progress * 100).."%");
	TopFit.ProgressFrame:SetProgress(progress)
    else
	TopFit.ProgressFrame:SetProgress(1) -- done
    end
    
    -- update icons and statistics
    if TopFit.bestCombination then
	TopFit.ProgressFrame:SetCurrentCombination(TopFit.bestCombination)
    end
    
    if TopFit.abortCalculation then
	TopFit.calculationsFrame:SetScript("OnUpdate", nil)
	TopFit:Print("Calculation aborted.")
	TopFit.abortCalculation = nil
	TopFit.isBlocked = false
	TopFit.ProgressFrame:StoppedCalculation()
    end
    
    TopFit:Debug("Current combination count: "..TopFit.combinationCount)
end

function TopFit:CheckCurrentSlotForDuplicates()
    while true do
	local wasFound = false
	if (TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
	    for i = 1, TopFit.currentSlotCounter - 1 do
		if (TopFit.slotCounters[i]) then
		    if (TopFit.itemListBySlot[i][TopFit.slotCounters[i]] == TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
			TopFit.slotCounters[TopFit.currentSlotCounter] = TopFit.slotCounters[TopFit.currentSlotCounter] + 1
			wasFound = true
		    end
		end
	    end
	    
	    -- if it's offhand, make sure it can be worn
	    if (not wasFound) and (TopFit.currentSlotCounter == 17) then
		if (TopFit.slotCounters[16] == nil) or -- no Mainhand is forced
			(TopFit:IsOnehandedWeapon(TopFit.itemListBySlot[16][TopFit.slotCounters[16]].itemID)) then -- Mainhand is not a Two-Handed Weapon
		    if (not TopFit.playerCanDualWield) then
			if (string.find(TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]].itemEquipLoc, "WEAPON")) then
			    -- no weapon in offhand if you cannot dualwield
			    TopFit.slotCounters[TopFit.currentSlotCounter] = TopFit.slotCounters[TopFit.currentSlotCounter] + 1
			    wasFound = true
			end
		    else -- player can dualwield
			if (not TopFit:IsOnehandedWeapon(TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]].itemID)) then -- no 2h-weapon in offhand
			    -- no 2h-weapon in offhand if you do not have Titan's Grip
			    TopFit.slotCounters[TopFit.currentSlotCounter] = TopFit.slotCounters[TopFit.currentSlotCounter] + 1
			    wasFound = true
			end
		    end
		else
		    -- a 2H-Mainhand is set
		    TopFit.slotCounters[TopFit.currentSlotCounter] = TopFit.slotCounters[TopFit.currentSlotCounter] + 1
		    wasFound = true
		    --TopFit:Debug("("..TopFit.itemListBySlot[16][TopFit.slotCounters[16]].itemLink..") - SC --> "..TopFit.slotCounters[TopFit.currentSlotCounter])
		end
	    end
	end
	
	if (not wasFound) or (not TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
	    return
	end
    end
end

function TopFit:SaveCurrentCombination()
    TopFit.combinationCount = TopFit.combinationCount + 1
    TopFit.goingUp = false
    
    local cIC = {
	items = {},
	totalScore = 0,
	totalStats = {},
    }
    
    local itemsAlreadyChosen = {}
    
    local i
    for i = 1, 20 do
	local itemTable = nil
	local stat, slotTable
	
	if TopFit.slotCounters[i] then
	    itemTable = TopFit.itemListBySlot[i][TopFit.slotCounters[i]]
	else
	    -- choose highest valued item for otherwise empty slots, if possible
	    itemTable = TopFit:CalculateBestInSlot(itemsAlreadyChosen, false, i)
	    
	    if (itemTable) then
		-- special cases for main an offhand (to accound for dualwielding and Titan's Grip)
		if (i == TopFit.slots["MainHandSlot"]) then
		    -- check if offhand is forced
		    if TopFit.slotCounters[i + 1] then
			-- use 1H-weapon in Mainhand (or a titan's grip 2H, if applicable)
			itemTable = TopFit:CalculateBestInSlotWithCondition(itemsAlreadyChosen, i, function(itemTable) return TopFit:IsOnehandedWeapon(itemTable.itemID) end)
		    else
			-- choose best main- and offhand combo
			if not TopFit:IsOnehandedWeapon(itemTable.itemID) then
			    -- see if a combination of main and offhand would have a better score
			    local bestMainScore, bestOffScore = 0, 0
			    local bestOff = nil
			    local bestMain = TopFit:CalculateBestInSlotWithCondition(itemsAlreadyChosen, i, function(itemTable) return TopFit:IsOnehandedWeapon(itemTable.itemID) end)
			    if bestMain ~= nil then
				bestMainScore = bestMain.itemScore
			    end
			    if (TopFit.playerCanDualWield) then
				-- any non-two-handed offhand is fine
				bestOff = TopFit:CalculateBestInSlotWithCondition(TopFit:JoinTables(itemsAlreadyChosen, {bestMain}), i + 1, function(itemTable) return TopFit:IsOnehandedWeapon(itemTable.itemID) end)
			    else
				-- offhand may not be a weapon (only shield, other offhand...)
				bestOff = TopFit:CalculateBestInSlotWithCondition(TopFit:JoinTables(itemsAlreadyChosen, {bestMain}), i + 1, function(itemTable) if string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
			    end
			    if bestOff ~= nil then
				bestOffScore = bestOff.itemScore
			    end
			    
			    -- alternatively, calculate offhand first, then mainhand
			    local bestMainScore2, bestOffScore2 = 0, 0
			    local bestMain2 = nil
			    local bestOff2 = nil
			    if (TopFit.playerCanDualWield) then
				-- any non-two-handed offhand is fine
				bestOff2 = TopFit:CalculateBestInSlotWithCondition(itemsAlreadyChosen, i + 1, function(itemTable) return TopFit:IsOnehandedWeapon(itemTable.itemID) end)
			    else
				-- offhand may not be a weapon (only shield, other offhand...)
				bestOff2 = TopFit:CalculateBestInSlotWithCondition(itemsAlreadyChosen, i + 1, function(itemTable) if string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
			    end
			    if bestOff2 ~= nil then
				bestOffScore2 = bestOff2.itemScore
			    end
			    
			    bestMain2 = TopFit:CalculateBestInSlotWithCondition(TopFit:JoinTables(itemsAlreadyChosen, {bestOff2}), i, function(itemTable) return TopFit:IsOnehandedWeapon(itemTable.itemID) end)
			    if bestMain2 ~= nil then
				bestMainScore2 = bestMain2.itemScore
			    end
			    
			    local maxScore = itemTable.itemScore
			    --TopFit:Debug("2H: "..itemTable.itemScore.."; Main: "..bestMainScore.."; Off: "..bestOffScore)
			    if (maxScore < (bestMainScore + bestOffScore)) then
				-- main- + offhand is better, use the one-handed mainhand
				itemTable = bestMain
				maxScore = bestMainScore + bestOffScore
				--TopFit:Debug("Choosing Mainhand "..itemTable.itemLink)
			    end
			    if (maxScore < (bestMainScore2 + bestOffScore2)) then
				-- main- + offhand is better, use the one-handed mainhand
				itemTable = bestMain2
				--TopFit:Debug("Choosing Mainhand "..itemTable.itemLink)
			    end
			end -- if mainhand would not be twohanded anyway, it can just be used
		    end
		elseif (i == TopFit.slots["SecondaryHandSlot"]) then
		    -- check if mainhand is empty or one-handed
		    if (not cIC.items[i - 1]) or (TopFit:IsOnehandedWeapon(cIC.items[i - 1].itemID)) then
			-- check if player can dual wield
			if TopFit.playerCanDualWield then
			    -- player doesn't have Titan's grip, only use 1H-weapons in Offhand
			    itemTable = TopFit:CalculateBestInSlotWithCondition(itemsAlreadyChosen, i, function(itemTable) return TopFit:IsOnehandedWeapon(itemTable.itemID) end)
			else
			    -- player cannot dualwield, only use offhands which are not weapons
			    itemTable = TopFit:CalculateBestInSlotWithCondition(itemsAlreadyChosen, i, function(itemTable) if string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
			end
		    else
			-- Two-handed mainhand and no Titan's Grip means we leave offhand empty
			itemTable = nil
		    end
		end
	    end
	end
	
	if itemTable then -- slot will be filled
	    tinsert(itemsAlreadyChosen, itemTable)
	    cIC.items[i] = itemTable
	    cIC.totalScore = cIC.totalScore + itemTable["itemScore"]
	    
	    -- add total stats
	    local stat, value
	    for stat, value in pairs(itemTable["totalBonus"]) do
		if (cIC.totalStats[stat]) then
		    cIC.totalStats[stat] = cIC.totalStats[stat] + value
		else
		    cIC.totalStats[stat] = value
		end
	    end
	end
    end
    
    -- check if it's better than old best
    local satisfied = true
    for stat, preferences in pairs(TopFit.Utopia) do
	if ((not cIC.totalStats[stat]) or (cIC.totalStats[stat] < tonumber(preferences["value"]))) then
	    satisfied = false
	end
    end
    
    if ((satisfied) and ((TopFit.maxScore == nil) or (TopFit.maxScore < cIC.totalScore))) then
	TopFit.maxScore = cIC.totalScore
	TopFit.bestCombination = cIC
	
	--[[TopFit.debugSlotCounters = {} -- save slot counters for best combination
	for i = 1, 20 do
	    TopFit.debugSlotCounters[i] = TopFit.slotCounters[i]
	end]]
    end
end

function TopFit:CalculateBestInSlot(itemsAlreadyChosen, insert, sID)
    -- get best item(s) for each equipment slot
    local bis = {}
    for slotID, itemsTable in pairs(TopFit.itemListBySlot) do
	if ((not sID) or (sID == slotID)) then -- use single slot if sID is set, or all slots
	    bis[slotID] = {}
	    local maxScore = nil
	    
	    -- iterate all items of given location
	    for _, itemTable in pairs(itemsTable) do
		if (((maxScore == nil) or (maxScore < itemTable["itemScore"])) -- score
		    and (itemTable["itemMinLevel"] <= TopFit.characterLevel)) then -- character level
		    -- also check if item has been chosen already (so we don't get the same ring / trinket twice)
		    local found = false
		    if (itemsAlreadyChosen) then
			for _, iTable in pairs(itemsAlreadyChosen) do
			    if (iTable == itemTable) then
				found = true
			    end
			end
		    end
		    
		    if not found then
			bis[slotID]["itemTable"] = itemTable
			maxScore = itemTable["itemScore"]
		    end
		end
	    end
	    
	    if (not bis[slotID]["itemTable"]) then
		-- remove dummy table if no item has been found
		bis[slotID] = nil
	    else
		-- mark this item as used
		if (itemsAlreadyChosen and insert) then
		    tinsert(itemsAlreadyChosen, bis[slotID]["itemTable"])
		end
	    end
	end
    end
    
    if (not sID) then
	return bis
    else
	-- return only the slot item's table (if it exists)
	if (bis[sID]) then
	    return bis[sID]["itemTable"]
	else
	    return nil
	end
    end
end

function TopFit:CalculateBestInSlotWithCondition(itemsAlreadyChosen, slotID, assertion)
    -- create a copy of itemsAlreadyChosen
    local iAC2 = {}
    for _, item in pairs(itemsAlreadyChosen) do
	tinsert(iAC2, item)
    end
    
    while true do
	itemTable = TopFit:CalculateBestInSlot(iAC2, false, slotID)
	if (not itemTable) or (assertion(itemTable)) then
	    return itemTable
	end
	tinsert(iAC2, itemTable)
    end
end

function TopFit:ReduceItemList()
    -- remove all non-forced items from item list
    for slotID, forceID in pairs(self.db.profile.sets[TopFit.setCode].forced) do
	for i = #(TopFit.itemListBySlot[slotID]), 1, -1 do
	    if (TopFit.itemListBySlot[slotID][i].itemID ~= forceID) then
		tremove(TopFit.itemListBySlot[slotID], i)
	    end
	end
    end
    
    -- remove all items with score <= 0 that are neither forced nor contribute to caps
    for slotID, itemList in pairs(TopFit.itemListBySlot) do
	if #itemList >= 1 then
	    for i = #itemList, 1, -1 do
		if (itemList[i].itemScore <= 0) then
		    if not (self.db.profile.sets[TopFit.setCode].forced[slotID]) then
			-- check caps
			local hasCap = false
			for statCode, preferences in pairs(TopFit.Utopia) do
			    if (itemList[i].totalBonus[statCode] or -1) > 0 then
				hasCap = true
				break
			    end
			end
			
			if not hasCap then
			    tremove(itemList, i)
			end
		    end
		end
	    end
	end
    end

    -- reduce item list: remove items with < cap and < score
    for slotID, itemList in pairs(TopFit.itemListBySlot) do
	if #itemList > 1 then
	    for i = #itemList, 1, -1 do
		-- try to see if an item exists which is definitely better
		local betterItemExists = 0
		local numBetterItemsNeeded = 1
		
		-- For items that can be used in 2 slots, we also need at least 2 better items to declare an item useless
		if (slotID == 17) -- offhand
		    or (slotID == 12) -- ring 2
		    or (slotID == 14) -- trinket 2
		    then
		    
		    numBetterItemsNeeded = 2
		end
		
		for j = 1, #itemList do
		    if i ~= j then
			if (itemList[i].itemScore < itemList[j].itemScore) and
			    (itemList[i].itemEquipLoc == itemList[j].itemEquipLoc) then -- especially important for weapons, we do not want to compare 2h and 1h weapons
			    -- score is greater, see if caps are also better
			    local allStats = true
			    for statCode, preferences in pairs(TopFit.Utopia) do
				if (itemList[i].totalBonus[statCode] or 0) > (itemList[j].totalBonus[statCode] or 0) then
				    allStats = false
				    break
				end
			    end
			    
			    if allStats then
				betterItemExists = betterItemExists + 1
				if (betterItemExists >= numBetterItemsNeeded) then
				    break
				end
			    end
			end
		    end
		end
		
		if betterItemExists >= numBetterItemsNeeded then
		    -- remove this item
		    tremove(itemList, i)
		end
	    end
	end
    end
end

function TopFit:IsOnehandedWeapon(itemID)
    _, _, _, _, _, class, subclass, _, equipSlot, _, _ = GetItemInfo(itemID)
    if string.find(equipSlot, "2HWEAPON") then
	if (TopFit.playerCanTitansGrip) then
	    local GAISC = GetAuctionItemSubClasses(1)
	    if (subclass == GAISC[7]) or -- Polearms
		    (subclass == GAISC[10]) or -- Staves
		    (subclass == GAISC[17]) then -- Fishing Poles
		return false
	    end
	else
	    return false
	end
    end
    return true
end
