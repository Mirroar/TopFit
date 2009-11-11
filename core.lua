--[[
TODO:
[] zusammenstellung als gear-set speichern
[] automatisch anlegen
[] match socket colors

softcap, hardcap
set bonus (2 T9, 4 T8, ...)

resistances as stats
sockets

check whole addon for variables that should really be local!

pawn support, etc.

order ace options tables

detect socket bonus

ranged slot enchants check only for hunter or something like that

duplicate sets (to adjust for pvp or something)
]]--

local function GetTextureIndex(tex) -- blatantly stolen from Tekkubs EquipSetUpdate. Thanks!
	RefreshEquipmentSetIconInfo()
	tex = tex:lower()
	local numicons = GetNumMacroIcons()
	for i=INVSLOT_FIRST_EQUIPPED,INVSLOT_LAST_EQUIPPED do if GetInventoryItemTexture("player", i) then numicons = numicons + 1 end end
	for i=1,numicons do
		local texture, index = GetEquipmentSetIconInfo(i)
		if texture:lower() == tex then return index end
	end
end

-- create Addon object
TopFit = LibStub("AceAddon-3.0"):NewAddon("TopFit", "AceConsole-3.0")

-- debug function
function TopFit:Debug(text)
    if self.db.profile.debugMode then
		TopFit:Print("Debug: "..text);
    end
end

function TopFit:GetItemInfoTable(item, location)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(item)
    local itemID = string.gsub(itemLink, ".*|Hitem:([0-9]*):.*", "%1")
    itemID = tonumber(itemID)

    local enchantID = string.gsub(itemLink, ".*|Hitem:[0-9]*:([0-9]*):.*", "%1")
	enchantID = tonumber(enchantID)
	
    -- gems
	local gemBonus = nil
	local gems = nil
    for i = 1,3 do
		local _, gem = GetItemGem(item, i) -- name, itemlink
		if gem then
			if gems then
				gems[i] = gem
			else
				gems = {
					[i] = gem,
				}
			end
			
			local gemID = string.gsub(gem, ".*|Hitem:([0-9]*):.*", "%1")
			gemID = tonumber(gemID)
			if (TopFit.gemIDs[gemID]) then
				-- collect stats
				if not gemBonus then
					gemBonus = {}
				end
				
				for stat, value in pairs(TopFit.gemIDs[gemID].stats) do
					if (gemBonus[stat]) then
						gemBonus[stat] = gemBonus[stat] + value
					else
						gemBonus[stat] = value
					end
				end
			end
		end
	end
	
	if gems then
		-- REFERENCE: Pawn.lua line ~1000
		--TODO: check killLines
		
		-- try to find socket bonus by scanning item tooltip (though I hoped to avoid that entirely)
		TopFit.scanTooltip:SetOwner(UIParent, 'ANCHOR_NONE')
		TopFit.scanTooltip:SetHyperlink(itemLink)
		local numLines = TopFit.scanTooltip:NumLines()
		
		local socketBonusString = _G["ITEM_SOCKET_BONUS"] -- "Socket Bonus: %s" in enUS client, for example
		socketBonusString = string.gsub(socketBonusString, "%%s", "(.*)")
		
		--TopFit:Debug("Socket Bonus String: "..socketBonusString)
		
		local socketBonusIsValid = false
		local socketBonus = nil
		for i = 1, numLines do
			local leftLine = getglobal("TFScanTooltip".."TextLeft"..i)
			local leftLineText = leftLine:GetText()
			
			if string.find(leftLineText, socketBonusString) then
				-- This line is the socket bonus.
				if leftLine.GetTextColor then
					socketBonusIsValid = (leftLine:GetTextColor() == 0) -- green's red component is 0, but grey's red component is .5	
				else
					socketBonusIsValid = true -- we can't get the text color, so we assume the bonus is valid
				end
				
				--TopFit:Debug("Socket Bonus Found! It is "..(socketBonusIsValid and "" or "in").."active. Bonus: "..string.gsub(leftLineText, "^"..socketBonusString.."$", "%1"))
				socketBonus = string.gsub(leftLineText, "^"..socketBonusString.."$", "%1")
			end
		end
		
		if (socketBonusIsValid) then
			-- go through our stats to find the bonus
			for _, sTable in pairs(TopFit.statList) do
				for _, statCode in pairs(sTable) do
					if (string.find(socketBonus, _G[statCode])) then -- sinple short stat codes like "Intellect", "Hit Rating"
						local bonusValue = string.gsub(socketBonus, _G[statCode], "")
						--TopFit:Debug("Value: \""..bonusValue.."\"")
						--TopFit:Debug("ToNumber: "..(tonumber(bonusValue) or "nil"))
						
						bonusValue = (tonumber(bonusValue) or 0)
						
						if not gemBonus then
							gemBonus = {}
						end
						
						if (gemBonus[statCode]) then
							gemBonus[statCode] = gemBonus[statCode] + bonusValue
						else
							gemBonus[statCode] = bonusValue
						end
					end
				end
			end
		end
		
		TopFit.scanTooltip:Hide()
	end
    
    --equippable slots
    locations = {}
    for slotName, slotID in pairs(TopFit.slots) do
		slotAvailableItems = GetInventoryItemsForSlot(slotID)
		if (slotAvailableItems) then
			for availableLocation, availableItemID in pairs(slotAvailableItems) do
				if (itemID == availableItemID) then
					--TopFit:Debug(itemLink.." is equippable in Slot "..slotID.." ("..slotName..")")
					tinsert(locations, slotID)
					if not location then
						location = availableLocation
					end
				end
			end
		end
    end
    
	local enchantBonus = nil
	if enchantID > 0 then
		for _, slotID in pairs(locations) do
			if (TopFit.enchantIDs[slotID] and TopFit.enchantIDs[slotID][enchantID]) then
				-- TopFit:Debug("Enchant found! ID: "..enchantID)
				enchantBonus = TopFit.enchantIDs[slotID][enchantID]
			end
		end
	end
    
	local result = {
		["itemLink"] = itemLink,
		["itemID"] = itemID,
		["itemMinLevel"] = itemMinLevel,
		["itemEquipLoc"] = itemEquipLoc,
		["itemBonus"] = GetItemStats(itemLink),
		["gems"] = gems,
		["enchantBonus"] = enchantBonus,
		["gemBonus"] = gemBonus,
		["equipLocations"] = locations,
		["itemLocation"] = location,
    }
	
	if (result["itemBonus"]["ITEM_MOD_POWER_REGEN0_SHORT"]) then  -- dirty little mana regen fix!
		if (result["itemBonus"]["ITEM_MOD_MANA_REGENERATION_SHORT"]) then
			result["itemBonus"]["ITEM_MOD_MANA_REGENERATION_SHORT"] = result["itemBonus"]["ITEM_MOD_MANA_REGENERATION_SHORT"] + result["itemBonus"]["ITEM_MOD_POWER_REGEN0_SHORT"]
		else
			result["itemBonus"]["ITEM_MOD_MANA_REGENERATION_SHORT"] = result["itemBonus"]["ITEM_MOD_POWER_REGEN0_SHORT"]
		end
		result["itemBonus"]["ITEM_MOD_POWER_REGEN0_SHORT"] = nil
	end
	
	return result
end

-- collect items
function TopFit:AddToAvailableItems(item, bag, slot, invSlot, location)
    if item then
		-- check if it's equipment
		if IsEquippableItem(item) then
			itemTable = TopFit:GetItemInfoTable(item, location)
			
			itemTable["bag"] = bag
			itemTable["slot"] = slot
			itemTable["invSlot"] = invSlot
			
			-- new table with slot ids
			for _, slotID in pairs(itemTable["equipLocations"]) do
				if not TopFit.itemListBySlot[slotID] then
					TopFit.itemListBySlot[slotID] = {}
				end
				
				tinsert(TopFit.itemListBySlot[slotID], itemTable)
			end
		end
    end
end

function TopFit:CalculateItemTableScore(itemTable, set, caps)
	local bonuses = itemTable["itemBonus"]
	local enchants = itemTable["enchantBonus"]
	local gems = itemTable["gemBonus"]
	
	-- calculate item score
	itemScore = 0
	-- iterate given weights
	for stat, statValue in pairs(set) do
		if bonuses[stat] then
			-- check for hard cap on this stat
			if ((not caps) or (not caps[stat]) or (caps[stat]["soft"])) then
				itemScore = itemScore + statValue * bonuses[stat]
			end
		end
		
		-- do the same for enchants
		if (enchants) and (enchants[stat]) then
			-- check for hard cap on this stat
			if ((not caps) or (not caps[stat]) or (not caps[stat]["active"]) or (caps[stat]["soft"])) then
				itemScore = itemScore + statValue * enchants[stat]
			end
		end
		
		-- and gems...
		if (gems) and (gems[stat]) then
			-- check for hard cap on this stat
			if ((not caps) or (not caps[stat]) or (not caps[stat]["active"]) or (caps[stat]["soft"])) then
				itemScore = itemScore + statValue * gems[stat]
			end
		end
	end
	
	itemTable["itemScore"] = itemScore
end

-- calculate item scores
function TopFit:CalculateScores(set, caps)
    -- iterate all equipment locations
    for slotID, itemsTable in pairs(TopFit.itemListBySlot) do
		-- iterate all items of given location
		for _, itemTable in pairs(itemsTable) do
			TopFit:CalculateItemTableScore(itemTable, set, caps)
		end
    end
end

function TopFit:SemiRecursiveCalculation()
	local operation
	local done = false
	for operation = 1, TopFit.operationsPerFrame do
		if (not done) then
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
					end
				end
				
				if (useful) then
					-- check if we are going down (backwards through slots) and find a valid counter to increase
					if ((TopFit.slotCounters[TopFit.currentSlotCounter] ~= nil) and (not TopFit.goingUp)) then
						-- increase current slot's counter, go up again
						TopFit.goingUp = true
						TopFit.slotCounters[TopFit.currentSlotCounter] = TopFit.slotCounters[TopFit.currentSlotCounter] + 1
						
						-- do that until we reach an item that has not been used yet in another slot
						local doTest = true
						while doTest do
							local wasFound = false
							for i = 1, TopFit.currentSlotCounter - 1 do
								if (TopFit.slotCounters[i]) then
									if (TopFit.itemListBySlot[i][TopFit.slotCounters[i]] == TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
										TopFit.slotCounters[TopFit.currentSlotCounter] = TopFit.slotCounters[TopFit.currentSlotCounter] + 1
										wasFound = true
									end
								end
							end
							
							if not wasFound or (not TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
								doTest = false
							end
						end
						
						-- if there are no more items in this slot, reset this counter and keep going down instead
						if (not TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
							TopFit.goingUp = false
							TopFit.slotCounters[TopFit.currentSlotCounter] = nil
						end
					-- we are going up and found a new counter to start incrementing
					else
						TopFit.slotCounters[TopFit.currentSlotCounter] = 1
						
						-- make sure the item has not been used in another slot, otherwise keep incrementing, 
						local doTest = true
						while doTest do
							local wasFound = false
							for i = 1, TopFit.currentSlotCounter - 1 do
								if (TopFit.slotCounters[i]) then
									if (TopFit.itemListBySlot[i][TopFit.slotCounters[i]] == TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
										TopFit.slotCounters[TopFit.currentSlotCounter] = TopFit.slotCounters[TopFit.currentSlotCounter] + 1
										wasFound = true
									end
								end
							end
							
							if not wasFound or (not TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
								doTest = false
							end
						end
						
						-- set to nil if there is no available item
						if (not TopFit.itemListBySlot[TopFit.currentSlotCounter][TopFit.slotCounters[TopFit.currentSlotCounter]]) then
							TopFit.slotCounters[TopFit.currentSlotCounter] = nil
						end
					end
				end
			end
			
			--TODO: find current values towards caps
			for i = 1, TopFit.currentSlotCounter do
				if (TopFit.slotCounters[i]) then
					local itemTable = TopFit.itemListBySlot[i][TopFit.slotCounters[i]]
					-- add up stat
				end
			end
			
			--TODO: check if any cap is not reachable anymore with current item combination
			-- in that case, stop here and go down again to find alternatives
			
			--TODO: check if all caps have been reached already with current item combination
			-- in that case, get best in slot for the other applicable slots, save, increase currentSlotCounter and go down again (to consider next alternative)
			
			-- if we reached the top, save current item combination
			if (TopFit.currentSlotCounter >= 20) then
				TopFit.combinationCount = TopFit.combinationCount + 1
				TopFit.goingUp = false
				
				local cIC = {
					items = {},
					totalScore = 0,
					totalStats = {},
				}
				
				local i
				for i = 1, 20 do
					if (TopFit.slotCounters[i]) then
						local itemTable = TopFit.itemListBySlot[i][TopFit.slotCounters[i]]
						-- remove offhand if mainhand is 2h and (TODO:) no titan's grip
						if ((slotID == TopFit.slots["SecondaryHandSlot"]) and
							(TopFit.itemListBySlot[TopFit.slotCounters[TopFit.slots["MainHandSlot"]]]) and
							(TopFit.itemListBySlot[TopFit.slotCounters[TopFit.slots["MainHandSlot"]]]["itemEquipLoc"] == "INVTYPE_2HWEAPON")) then
							-- do nothing
						else
							cIC.items[i] = itemTable
							cIC.totalScore = cIC.totalScore + itemTable["itemScore"]
							
							-- add total stats
							local stat, value
							for stat, value in pairs(itemTable["itemBonus"]) do
								if (cIC.totalStats[stat]) then
									cIC.totalStats[stat] = cIC.totalStats[stat] + value
								else
									cIC.totalStats[stat] = value
								end
							end
							
							-- enchants
							if (itemTable["enchantBonus"]) then
								for stat, value in pairs(itemTable["enchantBonus"]) do
									if (cIC.totalStats[stat]) then
										cIC.totalStats[stat] = cIC.totalStats[stat] + value
									else
										cIC.totalStats[stat] = value
									end
								end
							end
							
							-- gems
							if (itemTable["gemBonus"]) then
								for stat, value in pairs(itemTable["gemBonus"]) do
									if (cIC.totalStats[stat]) then
										cIC.totalStats[stat] = cIC.totalStats[stat] + value
									else
										cIC.totalStats[stat] = value
									end
								end
							end
						end
					end
				end
				
				-- save combination
				tinsert(TopFit.itemCombinations, cIC)
			end
			
			-- if we reached the bottom, we are done, yes!!!
			if (TopFit.currentSlotCounter < 0) then
				TopFit:Debug("DONE!")
				done = true
				TopFit.calculationsFrame:SetScript("OnUpdate", nil)
				operation = TopFit.operationsPerFrame
	
	
	
				TopFit:Print("Calculations are done. I tried a total of "..#TopFit.itemCombinations.." combinations.")
				
				-- find best combination that satisfies ALL caps
				local maxScore = nil
				local bestCombination = nil
				for _, itemCombination in pairs(TopFit.itemCombinations) do
					local satisfied = true
					for stat, preferences in pairs(TopFit.Utopia) do
						if ((not itemCombination.totalStats[stat]) or (itemCombination.totalStats[stat] < tonumber(preferences["value"]))) then
							satisfied = false
						end
					end
					
					if ((satisfied) and ((maxScore == nil) or (maxScore < itemCombination.totalScore))) then
						maxScore = itemCombination.totalScore
						bestCombination = itemCombination
					end
				end
				
				if (bestCombination) then
					TopFit.bestCombination = bestCombination
					-- caps are reached, save and equip best combination
					local itemsAlreadyChosen = {}
					for slotID, itemTable in pairs(bestCombination.items) do
						TopFit.itemRecommendations[slotID] = {
							["itemTable"] = itemTable,
						}
						tinsert(itemsAlreadyChosen, itemTable)
					end
					
					-- fill all other slots with the best-in-slot items for that slot
					for slotID, itemTables in pairs(TopFit.itemListBySlot) do
						if (not TopFit.itemRecommendations[slotID]) then
							local best = TopFit:CalculateBestInSlot(itemsAlreadyChosen, true, slotID)
							if best then
								TopFit.itemRecommendations[slotID] = {
									["itemTable"] = best,
								}
							end
						end
					end
				else
					-- caps could not all be reached, calculate without caps instead
					TopFit:Print("I am very sorry, but you conditions could not all be fulfilled. I will however give you the items best suited to your tastes.")
					TopFit:CalculateRecommendationsSimple(setName)
				end



				TopFit:EquipRecommendedItems()

	
	
			end
		end
	end
	
	TopFit:Debug("Current combination count: "..TopFit.combinationCount)
end

function TopFit:InitSemiRecursiveCalculations()
	-- TODO: reduce item list: only best non-cap-item; remove items with < cap and < score, and whatever...
	TopFit.slotCounters = {}
	TopFit.currentSlotCounter = 0
	TopFit.operationsPerFrame = 10000
	TopFit.goingUp = true
	TopFit.combinationCount = 0
	
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
					local thisStat = 0
					if (itemTable["itemBonus"][statCode]) then
						thisStat = thisStat + itemTable["itemBonus"][statCode]
					end
					if (itemTable["enchantBonus"] and itemTable["enchantBonus"][statCode]) then
						thisStat = thisStat + itemTable["enchantBonus"][statCode]
					end
					if (itemTable["gemBonus"] and itemTable["gemBonus"][statCode]) then
						thisStat = thisStat + itemTable["gemBonus"][statCode]
					end
					
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
	
	-- save all best in slot items for fast use
	TopFit.bestInSlot = TopFit:CalculateBestInSlot(nil, nil, nil)
	
	TopFit.calculationsFrame = CreateFrame("Frame");
	TopFit.calculationsFrame:SetScript("OnUpdate", TopFit.SemiRecursiveCalculation)
end

function TopFit:CalculateRecommendations(setName)
    TopFit.itemRecommendations = {}
	TopFit.currentItemCombination = {}
	TopFit.itemCombinations = {}
	TopFit.currentSetName = setName
    local characterLevel = UnitLevel("player")
	
	TopFit:Print("Yes, master. This might take a while, so brace yourself, if you please.")

	-- get all combinations of items and their summed up scores and reached caps
	local slotsDone = {}
	--TopFit:CalculateItemTablesRecursively(slotsDone)
	TopFit:InitSemiRecursiveCalculations()
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

function TopFit:CalculateRecommendationsSimple(setName)
    TopFit.itemRecommendations = {}
	TopFit.currentSetName = setName
	
	TopFit:Print("Yes, master, I will take a quick look for you.")

    itemsAlreadyChosen = {}
	TopFit.itemRecommendations = TopFit:CalculateBestInSlot(itemsAlreadyChosen, true, nil)
    
    -- check whether to use 2h- oder main-offhand combo
    recommendedMainHand = TopFit.itemRecommendations[TopFit.slots["MainHandSlot"]]
    recommendedOffHand = TopFit.itemRecommendations[TopFit.slots["SecondaryHandSlot"]]
    if (recommendedMainHand and recommendedOffHand) then
		TopFit:Debug("main and off found")
		
		-- load item tables
		recommendedMainHand = TopFit.itemRecommendations[TopFit.slots["MainHandSlot"]]["itemTable"]
		recommendedOffHand = TopFit.itemRecommendations[TopFit.slots["SecondaryHandSlot"]]["itemTable"]
		
		if (recommendedMainHand["itemEquipLoc"] == "INVTYPE_2HWEAPON") then --TODO: check for titan's grip!!
			useTwohand = true
			TopFit:Debug("main is 2H!")
			
			-- check 2h-score vs. best main- / offhand combo
			twohandScore = recommendedMainHand["itemScore"]
			
			-- find best non-twohanded mainhand
			oneHand = nil
			comboScore = nil
			for _, itemTable in pairs(TopFit.itemListBySlot[TopFit.slots["MainHandSlot"]]) do
				TopFit:Debug("checking for other mainhand...")
				if (itemTable["itemEquipLoc"] ~= "INVTYPE_2HWEAPON") then
					found = false
					for _, iTable in pairs(itemsAlreadyChosen) do
						if (iTable == itemTable) then
							found = true
						end
					end
					
					if (not found) then
						TopFit:Debug("2H Main Hand found with offhand recommendation")
						if ((not comboScore) or (comboScore < itemTable["itemScore"])) then
						comboScore = itemTable["itemScore"]
						oneHand = itemTable
						end
					end
				end
			end
				
			if (comboScore) then
				comboScore = comboScore + recommendedOffHand["itemScore"]
				
				if (comboScore > twohandScore) then
					useTwohand = false
					TopFit.itemRecommendations[TopFit.slots["MainHandSlot"]]["itemTable"] = oneHand
				end
			end
				
			if (useTwohand) then
				-- remove offhand recommendation, as it must be empty
				TopFit.itemRecommendations[TopFit.slots["SecondaryHandSlot"]] = nil
			end
			--TODO: for main- / offhand combos, make sure mainhand is the better weapon if they can both go in both slots
		end
    end
	
	recommendedMainHand = TopFit.itemRecommendations[TopFit.slots["MainHandSlot"]]
    recommendedOffHand = TopFit.itemRecommendations[TopFit.slots["SecondaryHandSlot"]]
    if (recommendedMainHand and recommendedOffHand) then
		-- make sure better weapon is in mainhand
		--TODO: but add option for specific weaontype per hand etc. (Rogues, damn you! - Ambush and such)
		if (recommendedMainHand["itemTable"]["itemScore"] < recommendedOffHand["itemTable"]["itemScore"]) then
			-- check if weapons can be swapped
			local valid = true
			local found = false
			for _, itemTable in pairs(TopFit.itemListBySlot[TopFit.slots["MainHandSlot"]]) do
				if (itemTable == recommendedOffHand) then
					found = true
				end
			end
			if not found then valid = false end
			for _, itemTable in pairs(TopFit.itemListBySlot[TopFit.slots["SecondaryHandSlot"]]) do
				if (itemTable == recommendedMainHand) then
					found = true
				end
			end
			if not found then valid = false end
			
			if valid then
				temp = TopFit.itemRecommendations[TopFit.slots["MainHandSlot"]]
				TopFit.itemRecommendations[TopFit.slots["MainHandSlot"]] = TopFit.itemRecommendations[TopFit.slots["SecondaryHandSlot"]]
				TopFit.itemRecommendations[TopFit.slots["SecondaryHandSlot"]] = temp
			end
		end
	end
end

function TopFit:EquipRecommendedItems()
    -- equip them
    for slotID, recTable in pairs(TopFit.itemRecommendations) do
		itemTable = recTable["itemTable"]
		TopFit:Debug("Recommend "..itemTable["itemLink"].." for Slot "..slotID)
		
		if ((itemTable["bag"]) and (itemTable["slot"])) then
			PickupContainerItem(itemTable["bag"], itemTable["slot"])
		elseif (itemTable["invSlot"]) then
			PickupInventoryItem(itemTable["invSlot"])
		end
		EquipCursorItem(slotID)
    end
    
	TopFit.updateFrame:SetScript("OnUpdate", TopFit.onUpdateForEquipment)
end

function TopFit:onUpdateForEquipment()
	allDone = true
	for slotID, recTable in pairs(TopFit.itemRecommendations) do
		slotItemID = GetInventoryItemID("player", slotID)
		if (slotItemID ~= recTable["itemTable"]["itemID"]) then
			allDone = false
		end
	end
	
	-- if all items have been equipped, save equipment set and unregister script
	if (allDone) then
		TopFit:Debug("All Done!")
		TopFit.updateFrame:SetScript("OnUpdate", nil)
		
		EquipmentManagerClearIgnoredSlotsForSave()
		for _, slotID in pairs(TopFit.slots) do
			if (not TopFit.itemRecommendations[slotID]) then
				TopFit:Debug("Ignoring slot "..slotID)
				EquipmentManagerIgnoreSlotForSave(slotID)
			end
		end
		
		-- save equipment set
		if (CanUseEquipmentSets()) then
			setName = TopFit:GenerateSetName(TopFit.currentSetName)
			-- check if a set with this name exists
			if (GetEquipmentSetInfoByName(setName)) then
				texture = GetEquipmentSetInfoByName(setName)
				texture = "Interface\\Icons\\"..texture
				
				textureIndex = GetTextureIndex(texture)
			else
				textureIndex = GetTextureIndex("Interface\\Icons\\Spell_Holy_EmpowerChampion")
			end
			
			TopFit:Debug("Trying to save set: "..setName..", "..(textureIndex or "nil"))
			SaveEquipmentSet(setName, textureIndex)
		end
	
		-- we are done with this set
		TopFit.isBlocked = false
		
		TopFit:Print("Here you are, master. All nice and spiffy looking, just as you like it.")
		
		-- initiate next round if necessary
		if (#TopFit.workSetList > 0) then
			TopFit:CalculateSets()
		end
	end
end

function TopFit:GenerateSetName(name)
	-- using substr because blizzard interface only allows 16 characters
	-- although technically SaveEquipmentSet & co allow more ;)
	return (((name ~= nil) and string.sub(name.." ", 1, 12).."(TF)") or "TopFit")
end

function TopFit:ChatCommand(input)
    if not input or input:trim() == "" then
		InterfaceOptionsFrame_OpenToCategory(TopFit.optionsFrame)
    else
		LibStub("AceConfigCmd-3.0").HandleCommand(TopFit, "tf", "TopFit", input)
    end
end

function TopFit:OnInitialize()
    -- load saved variables
    self.db = LibStub("AceDB-3.0"):New("TopFitDB")
	
	-- create gametooltip for scanning
	TopFit.scanTooltip = CreateFrame('GameTooltip', 'TFScanTooltip', UIParent, 'GameTooltipTemplate')


    -- check if any set is saved already, if not, create default
    if (not self.db.profile.sets) then
		self.db.profile.sets = {
			set_1 = {
				name = "Default Set",
				weights = {},
				caps = {},
			},
		}
    end
	
    -- list of inventory slot names
    TopFit.slotList = {
		--"AmmoSlot",
		"BackSlot",
		"ChestSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"HandsSlot",
		"HeadSlot",
		"LegsSlot",
		"MainHandSlot",
		"NeckSlot",
		"RangedSlot",
		"SecondaryHandSlot",
		"ShirtSlot",
		"ShoulderSlot",
		"TabardSlot",
		"Trinket0Slot",
		"Trinket1Slot",
		"WaistSlot",
		"WristSlot",
    }
    
    -- create list of slot names with corresponding slot IDs
    TopFit.slots = {}
	TopFit.slotNames = {}
    for _, slotName in pairs(TopFit.slotList) do
		slotID, _, _ = GetInventorySlotInfo(slotName)
		TopFit.slots[slotName] = slotID;
		TopFit.slotNames[slotID] = slotName;
    end
    
	-- create frame for OnUpdate
	TopFit.updateFrame = CreateFrame("Frame")
    
	-- create Ace3 options table
	TopFit:createOptionsTable()

    -- add profile management to options
    TopFit.myOptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	
    -- register Slash command
    LibStub("AceConfig-3.0"):RegisterOptionsTable("TopFit", TopFit.GetOptionsTable)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TopFit", "TopFit")
    self:RegisterChatCommand("topfit", "ChatCommand")
    self:RegisterChatCommand("tf", "ChatCommand")
end

function TopFit:OnEnable()
    -- Called when the addon is enabled
end

function TopFit:OnDisable()
    -- Called when the addon is disabled
end

function TopFit:collectItems()
	-- collect items
	TopFit.itemList = {}
	TopFit.itemListBySlot = {}
	-- check bags
	for bag = 0,4 do
		for slot = 1, GetContainerNumSlots(bag) do
		local item = GetContainerItemLink(bag,slot)
		
		TopFit:AddToAvailableItems(item, bag, slot, nil, nil)
		end
	end
	
	-- check equipped items
	for _, invSlot in pairs(TopFit.slots) do
		local item = GetInventoryItemLink("player", invSlot)
		
		TopFit:AddToAvailableItems(item, nil, nil, invSlot, nil)
	end
end

function TopFit:StartCalculations(info, input)
	-- generate table of set codes
	TopFit.workSetList = {}
	for setCode, _ in pairs(self.db.profile.sets) do
		tinsert(TopFit.workSetList, setCode)
	end
	
	TopFit:CalculateSets()
end

function TopFit:StartCalculationsForSet(info, input)
	setCode = info[#info - 1]
	TopFit.workSetList = {}
	tinsert(TopFit.workSetList, setCode)
	
	TopFit:CalculateSets()
end

function TopFit:CalculateSets()
	local setCode = tremove(TopFit.workSetList)

    TopFit.characterLevel = UnitLevel("player")

	TopFit:Debug("Calculating items for "..setCode)
    -- Process the slash command ('input' contains whatever follows the slash command)
    --TopFit:Debug("Teste "..input);

    if (not TopFit.isBlocked) then
		-- set as working to prevent any further calls from "interfering"
		TopFit.isBlocked = true
		
		-- check if any "caps" have been set
		TopFit.Utopia = {} -- I'm not just setting this to self.db.profile.sets[setCode].caps to prevent overwriting of user preferences
		hasCap = false
		for statCode, preferences in pairs(self.db.profile.sets[setCode].caps) do
			if (preferences["active"]) then
				hasCap = true
				TopFit.Utopia[statCode] = {
					value = preferences["value"],
					soft = preferences["soft"],
				}
			end
		end
		
		-- do the actual work
		TopFit:collectItems()
		TopFit:CalculateScores(self.db.profile.sets[setCode]["weights"], TopFit.Utopia)
		if hasCap then
			TopFit:CalculateRecommendations(self.db.profile.sets[setCode]["name"])
		else
			TopFit:CalculateRecommendationsSimple(self.db.profile.sets[setCode]["name"])
			
			TopFit:EquipRecommendedItems()
		end
	end
end


-- Tooltip functions
local cleared = true
local function OnTooltipCleared(self)
	cleared = true   
end

local function OnTooltipSetItem(self)
	if cleared then
		local name, link = self:GetItem()
		if (name) then
			local equippable = IsEquippableItem(link)
			--local item = link:match("Hitem:(%d+)")
			--	item = tonumber(item)
			if (not equippable) then
				-- Do nothing
			else
				-- GameTooltip:AddLine("Item not in an equipment set", 1, 0.2, 0.2)
				local itemTable = TopFit:GetItemInfoTable(link, nil)
				
				if (TopFit.db.profile.debugMode) then
					-- item stats
					GameTooltip:AddLine("Item stats as seen by TopFit:", 0.5, 0.9, 1)
					for stat, value in pairs(itemTable["itemBonus"]) do
						GameTooltip:AddLine("  +"..value.." ".._G[stat], 0.5, 0.9, 1)
					end
					
					-- enchantment stats
					if (itemTable["enchantBonus"]) then
						GameTooltip:AddLine("Enchant:", 1, 0.9, 0.5)
						for stat, value in pairs(itemTable["enchantBonus"]) do
							GameTooltip:AddLine("  +"..value.." ".._G[stat], 1, 0.9, 0.5)
						end
					end
					
					-- gems
					if (itemTable["gemBonus"]) then
						local first = true
						for stat, value in pairs(itemTable["gemBonus"]) do
							if first then
								first = false
								GameTooltip:AddLine("Gems:", 0.8, 0.2, 0)
							end
							
							GameTooltip:AddLine("  +"..value.." ".._G[stat], 0.8, 0.2, 0)
						end
					end
				end
				
				if (TopFit.db.profile.showTooltip) then
					-- scores for sets
					local first = true
					for _, setTable in pairs(TopFit.db.profile.sets) do
						if first then
							first = false
							GameTooltip:AddLine("Set Values:", 0.6, 1, 0.7)
						end
						
						-- TopFit:Debug("Calculating Score for set "..setTable.name)
						TopFit:CalculateItemTableScore(itemTable, setTable.weights, setTable.caps)
						GameTooltip:AddLine("  "..itemTable.itemScore.." - "..setTable.name, 0.6, 1, 0.7)
					end
				end
			end
			cleared = false
		end
	end
end

GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)