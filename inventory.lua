local addonName, ns, _ = ...

--[[ inventory management and caching

interesting variables:
TopFit.itemsCache - item Tables, indexed by itemLink
TopFit.scoresCache - scores, indexed by itemLink and setCode

]]--

-- FIXME: this should not be used
-- GLOBALS: TopFit, TOPFIT_ARMORTYPE_CLOTH, TOPFIT_ARMORTYPE_LEATHER, TOPFIT_ARMORTYPE_MAIL, TOPFIT_ARMORTYPE_PLATE

-- GLOBALS: _G, UIParent, MAX_PLAYER_LEVEL_TABLE, ITEM_BIND_ON_EQUIP, SPEED, MAX_NUM_SOCKETS
-- GLOBALS: GetEquipmentSetLocations, EquipmentManager_UnpackLocation, GetEquipmentSetItemIDs, GetEquipmentSetInfo, GetNumEquipmentSets, GetAuctionItemSubClasses, UnitLevel, UnitClass, GetItemInfo, GetContainerNumSlots, GetContainerItemID, GetContainerItemLink, GetInventoryItemLink, GetItemStats, GetInventoryItemsForSlot, GetItemGem, GetItemUniqueness, GetSpecialization
-- GLOBALS: string, math, select, pairs, tonumber, wipe, unpack

local tinsert = table.insert

local function tinsertonce(table, data)
	local found = false
	for _, v in pairs(table) do
		if v == data then
			found = true
			break
		end
	end
	if not found then
		tinsert(table, data)
	end
end

ns.enhancementWarnings = {
	show = false,
	gems = {},
	enchants = {},
}

function TopFit:ClearCache()
	TopFit.itemsCache = {}
	TopFit.scoresCache = {}
end

function TopFit:GetSetItemFromSlot(slotID, setCode)
	local itemPositions = GetEquipmentSetLocations(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))
	if itemPositions then
		local itemLocation = itemPositions[slotID]
		if itemLocation and itemLocation ~= 1 and itemLocation ~= 0 then
			local itemLink = nil
			local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(itemLocation)
			if player then
				if bank then
					-- item is banked, use itemID
					local itemID = GetEquipmentSetItemIDs(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))[slotID]
					if itemID and itemID ~= 1 then
						_, itemLink = GetItemInfo(itemID)
					end
				elseif bags then
					-- item is in player's bags
					itemLink = GetContainerItemLink(bag, slot)
				else
					-- item is equipped
					itemLink = GetInventoryItemLink("player", slot)
				end

				return itemLink
			end
		end
	end
	return nil
end

-- gather all items from inventory and bags, save their info to cache
function ns:collectItems(bag)
	ns.characterLevel = UnitLevel("player")

	if bag and bag >= 0 and bag <= 4 then
		-- only check a specific bag (used on BAG_UPDATE)
		for slot = 1, GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag, slot)

			ns:UpdateCache(item)
		end
	else
		-- check bags
		for bag = 0, 4 do
			for slot = 1, GetContainerNumSlots(bag) do
				local item = GetContainerItemLink(bag, slot)

				ns:UpdateCache(item)
			end
		end

		-- check equipped items
		for _, invSlot in pairs(ns.slots) do
			local item = GetInventoryItemLink("player", invSlot)

			ns:UpdateCache(item)
		end
	end
end

-- collect item information if necessary
function ns:UpdateCache(item)
	if item and (not ns.itemsCache[item]) then
		-- check if it's equipment
		--if IsEquippableItem(item) then --TODO: check if removing this breaks anything; it causes problems with gems
			local itemTable = ns:GetItemInfoTable(item)

			if itemTable then
				-- save in cache
				ns.itemsCache[item] = itemTable
			end
		--end
	end
end

-- find out all we need to know about an item. and maybe even more
-- this does not return information which might change, only things you can get from the item link
function TopFit:GetItemInfoTable(item)
	local itemName, itemLink, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture = GetItemInfo(item)
	if not itemLink then
		return nil
	end

	-- generate item info
	local itemID = string.gsub(itemLink, ".*|Hitem:([0-9]*):.*", "%1")
	itemID = tonumber(itemID)

	local enchantID = string.gsub(itemLink, ".*|Hitem:[0-9]*:([0-9]*):.*", "%1")
	enchantID = tonumber(enchantID)

	-- item stats
	local itemBonus = GetItemStats(itemLink)

	-- item stats for gems from our database
	if ns.gemIDs[itemID] then
		itemBonus = ns.gemIDs[itemID].stats

		local skillReq = ns.gemIDs[itemID].skill
		if skillReq then
			local skill, req = string.split("-", skillReq)
			itemBonus["SKILL: " .. skill] = req
		end
	end

	-- gems
	local gemBonus = {}
	local gems = {}
	for i = 1, MAX_NUM_SOCKETS do
		local _, gem = GetItemGem(item, i) -- name, itemlink
		if gem then
			gems[i] = gem

			local gemID = string.gsub(gem, ".*|Hitem:([0-9]*):.*", "%1")
			gemID = tonumber(gemID)

			-- add gem uniqueness
			local uniqueFamily, maxEquipped = GetItemUniqueness(gem)
			local uniqueStat
			if uniqueFamily then
				if uniqueFamily == -1 then
					-- single unique item
					uniqueStat = "UNIQUE: item-"..gemID.."*"..maxEquipped
				else
					-- item belongs to a unique family
					uniqueStat = "UNIQUE: family-"..uniqueFamily.."*"..maxEquipped
				end
				gemBonus[uniqueStat] = (gemBonus[uniqueStat] or 0) + 1
			end

			if (TopFit.gemIDs[gemID]) then
				-- collect stats
				for stat, value in pairs(TopFit.gemIDs[gemID].stats) do
					gemBonus[stat] = (gemBonus[stat] or 0) + value
				end

				local skillReq = TopFit.gemIDs[gemID].skill
				if skillReq then
					local skill, req = string.split("-", skillReq)
					gemBonus["SKILL: " .. skill] = req
				end
			else
				-- unknown gem, tell the user
				if not ns.enhancementWarnings.gems[gemID] then
					ns.enhancementWarnings.show = true
					ns.enhancementWarnings.gems[gemID] = {
						itemID = gemID,
						itemLink = gem,
						hostItemLink = itemLink,
					}
				end
			end
		end
	end

	-- try to find socket bonus and some other info by scanning item tooltip (though I hoped to avoid that entirely)
	local tooltip = TopFit.scanTooltip
	tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	tooltip:SetHyperlink(itemLink)
	local numLines = tooltip:NumLines()

	if #gems > 0 then
		--TODO: this will have to be rewritten to be calculated on the fly at some point. meta gem requirements will not always work this way

		local socketBonusString = _G["ITEM_SOCKET_BONUS"] -- "Socket Bonus: %s" in enUS client, for example
		socketBonusString = string.gsub(socketBonusString, "%%s", "(.*)")

		local socketBonusIsActive = false
		local socketBonus = nil
		for i = 1, numLines do
			local leftLine = _G[tooltip:GetName()..'TextLeft'..i]
			local leftLineText = leftLine:GetText()
			if string.find(leftLineText, socketBonusString) then
				-- This line is the socket bonus.
				if leftLine.GetTextColor then
					socketBonusIsActive = (leftLine:GetTextColor() == 0) -- green's red component is 0, but grey's red component is .5
				else
					socketBonusIsActive = true -- we can't get the text color, so we assume the bonus is active
				end

				socketBonus = string.gsub(leftLineText, "^"..socketBonusString.."$", "%1")
				break
			end
		end

		if (socketBonusIsActive) then
			-- go through our stats to find the bonus
			for _, sTable in pairs(TopFit.statList) do
				for _, statCode in pairs(sTable) do
					if (string.find(socketBonus, _G[statCode])) then -- simple short stat codes like "Intellect", "Hit Rating"
						local bonusValue = string.gsub(socketBonus, _G[statCode], "")

						bonusValue = (tonumber(bonusValue) or 0)

						gemBonus[statCode] = (gemBonus[statCode] or 0) + bonusValue
					end
				end
			end
		end
	end

	-- scan for siege of Orgrimmar %-based Trinkets
	if itemEquipLoc == 'INVTYPE_TRINKET' then
		for i = 1, numLines do
			local leftLine = _G[tooltip:GetName()..'TextLeft'..i]
			local leftLineText = leftLine:GetText()
			if string.find(leftLineText, TopFit.locale.ItemScan.PercentBonusTrigger) then
				-- SoO Percent bonus, figure out percentage
				local percentBonus = string.gsub(leftLineText, "^.*(%d+)%%.*$", "%1")
				if percentBonus then
					itemBonus['TOPFIT_SECONDARY_PERCENT'] = tonumber(percentBonus)
					break
				end
			end
		end
	end

	-- enchantment
	local enchantBonus = {}
	if enchantID > 0 then
		local found = false
		for _, slotID in pairs(TopFit.slots) do
			if (TopFit.enchantIDs[slotID] and TopFit.enchantIDs[slotID][enchantID]) then
				enchantBonus = TopFit.enchantIDs[slotID][enchantID].stats
				if TopFit.enchantIDs[slotID][enchantID].couldNotParse then
					local enchantItemID = TopFit.enchantIDs[slotID][enchantID].itemID
					local _, enchantLink = GetItemInfo(enchantItemID)

					if not ns.enhancementWarnings.enchants[enchantID] then
						ns.enhancementWarnings.show = true
						ns.enhancementWarnings.enchants[enchantID] = {
							enchantID = enchantID,
							itemID = enchantItemID,
							itemLink = enchantLink,
							hostItemLink = itemLink,
						}
					end
				end
				found = true
			end
		end

		if not found then
			-- unknown enchant, tell the user
			if not ns.enhancementWarnings.enchants[enchantID] then
				ns.enhancementWarnings.show = true
				ns.enhancementWarnings.enchants[enchantID] = {
					enchantID = enchantID,
					hostItemLink = itemLink,
				}
			end
		end
	end

	-- scan for setname
	local setName = nil
	for i = 1, numLines do
		local textLeft = _G[tooltip:GetName()..'TextLeft'..i]:GetText()
		if string.find(textLeft, "(.*)%s%([0-9]+/[0-9+]%)") then
			setName = select(3, string.find(textLeft, "(.*)%s%([0-9]+/[0-9+]%)"))
			break
		end
	end

	-- add set name
	if setName then
		itemBonus["SET: "..setName] = 1
	end

	-- add item uniqueness
	local uniqueFamily, maxEquipped = GetItemUniqueness(item)
	if uniqueFamily then
		if uniqueFamily == -1 then
			-- single unique item
			itemBonus["UNIQUE: item-"..itemID.."*"..maxEquipped] = 1
		else
			-- item belongs to a unique family
			itemBonus["UNIQUE: family-"..uniqueFamily.."*"..maxEquipped] = 1
		end
	end

	-- add armor type
	if itemSubType == TOPFIT_ARMORTYPE_CLOTH then
		itemBonus["TOPFIT_ARMORTYPE_CLOTH"] = 1
	elseif itemSubType == TOPFIT_ARMORTYPE_LEATHER then
		itemBonus["TOPFIT_ARMORTYPE_LEATHER"] = 1
	elseif itemSubType == TOPFIT_ARMORTYPE_MAIL then
		itemBonus["TOPFIT_ARMORTYPE_MAIL"] = 1
	elseif itemSubType == TOPFIT_ARMORTYPE_PLATE then
		itemBonus["TOPFIT_ARMORTYPE_PLATE"] = 1
	end

	-- for weapons, add melee/ranged dps
	if string.find(itemEquipLoc, "RANGED") or string.find(itemEquipLoc, "THROWN") then
		itemBonus["TOPFIT_RANGED_DPS"] = itemBonus["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or nil
	end
	if string.find(itemEquipLoc, "WEAPON") then
		itemBonus["TOPFIT_MELEE_DPS"] = itemBonus["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] or nil
	end

	-- add weapon speeds
	if string.find(itemEquipLoc, "RANGED") or string.find(itemEquipLoc, "THROWN") or string.find(itemEquipLoc, "WEAPON") then
		local speedString = SPEED.." ([0-9.]*)";

		for i = 1, numLines do
			local rightLine = _G[tooltip:GetName()..'TextRight'..i]
			local rightLineText = rightLine:GetText()

			if (rightLineText and string.find(rightLineText, speedString)) then
				TopFit:Debug("SPEED FOUND!")
				local speed = string.gsub(rightLineText, "^"..speedString.."$", "%1")
				speed = tonumber(speed)

				if (string.find(itemEquipLoc, "RANGED") or string.find(itemEquipLoc, "THROWN")) then
					itemBonus["TOPFIT_RANGED_WEAPON_SPEED"] = speed
				end
				if (string.find(itemEquipLoc, "WEAPON")) then
					itemBonus["TOPFIT_MELEE_WEAPON_SPEED"] = speed
				end
			end
		end
		TopFit.scanTooltip:Hide()
	end

	-- done scanning the tooltip
	tooltip:Hide()

	-- dirty little mana regen fix
	itemBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] = ((itemBonus["ITEM_MOD_POWER_REGEN0_SHORT"] or 0) + (itemBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] or 0))
	itemBonus["ITEM_MOD_POWER_REGEN0_SHORT"] = nil
	if (itemBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] == 0) then itemBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] = nil end

	gemBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] = ((gemBonus["ITEM_MOD_POWER_REGEN0_SHORT"] or 0) + (gemBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] or 0))
	gemBonus["ITEM_MOD_POWER_REGEN0_SHORT"] = nil
	if (gemBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] == 0) then gemBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] = nil end

	enchantBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] = ((enchantBonus["ITEM_MOD_POWER_REGEN0_SHORT"] or 0) + (enchantBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] or 0))
	enchantBonus["ITEM_MOD_POWER_REGEN0_SHORT"] = nil
	if (enchantBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] == 0) then enchantBonus["ITEM_MOD_MANA_REGENERATION_SHORT"] = nil end

	-- also check proc / on-use effects for score calculation
	-- TODO: clean up this mess!
	if not TopFit.allStatsInATable then
		TopFit.allStatsInATable = {}
		for _, statsTable in pairs(TopFit.statList) do
			for _, stat in pairs(statsTable) do
				tinsert(TopFit.allStatsInATable, stat)
			end
		end
	end

	local procBonus = {}
	local procUptime = 0.5
	local searchStat, amount, duration, cooldown = TopFit:ItemHasSpecialBonus(itemLink, unpack(TopFit.allStatsInATable))
	if searchStat and amount and amount > 0 then
		if not cooldown or cooldown <= 0 then cooldown = 45 end
		procBonus[searchStat] = procUptime * amount * duration / cooldown
	end

	-- calculate total values
	local totalBonus = {}
	for _, bonusTable in pairs({itemBonus, gemBonus, enchantBonus, procBonus}) do
		for stat, value in pairs(bonusTable) do
			totalBonus[stat] = (totalBonus[stat] or 0) + value
		end
	end

	-- generate result
	local result = {
		itemLink = itemLink,
		itemID = itemID,
		itemQuality = itemQuality,
		itemMinLevel = itemMinLevel,
		itemLevel = itemLevel,
		itemEquipLoc = itemEquipLoc,
		equipLocationsByType = TopFit:GetEquipLocationsByInvType(itemEquipLoc, true),
		gems = gems,
		itemBonus = itemBonus,
		enchantBonus = enchantBonus,
		gemBonus = gemBonus,
		totalBonus = totalBonus,
		procBonus = procBonus
	}

	-- allow plugins to modify result
	ns.InvokeAll('OnGetItemStats', result)

	return result
end

-- used by tooltip to decide which item slots to compare to
local compareToSlots = {}
function TopFit:GetEquipLocationsByInvType(itemEquipLoc, createTable)
	local slots = createTable and {} or compareToSlots
	wipe(slots)

	if itemEquipLoc == "INVTYPE_HEAD" then
		tinsert(slots, 1)
	elseif itemEquipLoc == "INVTYPE_NECK" then
		tinsert(slots, 2)
	elseif itemEquipLoc == "INVTYPE_SHOULDER" then
		tinsert(slots, 3)
	elseif itemEquipLoc == "INVTYPE_BODY" then
		tinsert(slots, 4)
	elseif itemEquipLoc == "INVTYPE_CHEST" or itemEquipLoc == "INVTYPE_ROBE" then
		tinsert(slots, 5)
	elseif itemEquipLoc == "INVTYPE_WAIST" then
		tinsert(slots, 6)
	elseif itemEquipLoc == "INVTYPE_LEGS" then
		tinsert(slots, 7)
	elseif itemEquipLoc == "INVTYPE_FEET" then
		tinsert(slots, 8)
	elseif itemEquipLoc == "INVTYPE_WRIST" then
		tinsert(slots, 9)
	elseif itemEquipLoc == "INVTYPE_HAND" then
		tinsert(slots, 10)
	elseif itemEquipLoc == "INVTYPE_FINGER" then
		tinsert(slots, 11)
		tinsert(slots, 12)
	elseif itemEquipLoc == "INVTYPE_TRINKET" then
		tinsert(slots, 13)
		tinsert(slots, 14)
	elseif itemEquipLoc == "INVTYPE_CLOAK" then
		tinsert(slots, 15)
	elseif itemEquipLoc == "INVTYPE_2HWEAPON" then
		--TODO: check weapon type
		tinsert(slots, 16)
	elseif itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" or itemEquipLoc == "INVTYPE_THROWN" then
		tinsert(slots, 16)
	elseif itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then
		tinsert(slots, 16)
	elseif itemEquipLoc == "INVTYPE_WEAPON" then
		tinsert(slots, 16)
		tinsert(slots, 17)
	elseif itemEquipLoc == "INVTYPE_WEAPONOFFHAND" then
		tinsert(slots, 17)
	elseif itemEquipLoc == "INVTYPE_HOLDABLE" or itemEquipLoc == "INVTYPE_SHIELD" then
		tinsert(slots, 17)
	elseif itemEquipLoc == "INVTYPE_TABARD" then
		tinsert(slots, 19)
	end
	-- default / invalid location
	return slots
end

-- items are deemed interesting if any of these conditions are true:
-- it is currently part of a set
-- there is no item with a higher score for the item's slot(s)
-- it contributes more to a set's cap than any item with a higher score
--
-- in case of errors or weird input, this function will return true
function TopFit:IsInterestingItem(itemID, setID)
	if not itemID then return true, "no itemID given" end

	local item = TopFit:GetCachedItem(itemID)
	if not item then return true, "invalid itemID or no item info available" end

	if not setID then
		-- check if item is part of any current equipment set
		for i = 1, GetNumEquipmentSets() do
			local name, _, _ = GetEquipmentSetInfo(i)
			local itemIDs = GetEquipmentSetItemIDs(name)

			for _, iID in pairs(itemIDs) do
				if iID == item.itemID then return true, "part of current set" end
			end
		end

		-- check for all sets
		for set, _ in pairs(TopFit.db.profile.sets) do
			local isInteresting, reason = TopFit:IsInterestingItem(itemID, set)
			if (isInteresting) then
				return isInteresting, reason
			end
		end
		return false, "item is not interesting for any set"
	end

	local set = ns.GetSetByID(setID, true)

	-- get items available from the same slot(s)
	for _, slotID in pairs(item.equipLocationsByType) do
		if set:IsForcedItem(itemID) then
			return true, "item is forced in a set"
		end

		-- try to see if an item exists which is definitely better
		-- TODO: this is similar to what happens in ReduceItemList and should be reused
		local betterItemExists = 0
		local numBetterItemsNeeded = 1

		-- For items that can be used in 2 slots, we also need at least 2 better items to declare an item useless
		if (slotID == 17) -- offhand
			or (slotID == 12) -- ring 2
			or (slotID == 14) -- trinket 2
			then

			numBetterItemsNeeded = 2
		end

		local otherItems = TopFit:GetEquippableItems(slotID)
		for _, otherItem in pairs(otherItems) do
			local compareTable = TopFit:GetCachedItem(otherItem.itemLink)
			if compareTable and (item.itemID ~= compareTable.itemID) and
				(set:GetItemScore(item.itemLink) < set:GetItemScore(compareTable.itemLink)) and
				(item.itemEquipLoc == compareTable.itemEquipLoc) then -- especially important for weapons, we do not want to compare 2h and 1h weapons

				-- score is greater, see if caps are also better
				local allStats = true
				for statCode, preferences in pairs(TopFit.db.profile.sets[setID].caps) do
					if preferences.active then
						if (item.totalBonus[statCode] or 0) > (compareTable.totalBonus[statCode] or 0) then
							allStats = false
							break
						end
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

		if betterItemExists < numBetterItemsNeeded then
			-- there are not enough better alternatives, it is indeed an interesting item
			return true, "one of the best items for this slot"
		end
	end

	return false, "item is not interesting for this set"
end

-- checks whether an item is BoE by given bag and slot number
function TopFit:IsItemBoE(bag, slot)
	TopFit.scanTooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	TopFit.scanTooltip:SetBagItem(bag, slot)
	local numLines = TopFit.scanTooltip:NumLines()
	for i = 1, numLines do
		local leftLine = _G[TopFit.scanTooltip:GetName().."TextLeft"..i]
		local leftLineText = leftLine:GetText()

		if string.find(leftLineText, ITEM_BIND_ON_EQUIP) then
			return true
		end
	end

	return false
end

-- returns all equippable items, limited by slot, if given
local slotAvailableItems = {}
function TopFit:GetEquippableItems(requestedSlotID)
	local itemListBySlot = {}
	local availableSlots = {}
	for i = 1, 20 do
		itemListBySlot[i] = {}
	end

	-- find available item ids for each slot
	for slotName, slotID in pairs(TopFit.slots) do
		itemListBySlot[slotID] = {}

		wipe(slotAvailableItems)
		GetInventoryItemsForSlot(slotID, slotAvailableItems)

		for availableLocation, availableItemID in pairs(slotAvailableItems) do
			if (not availableSlots[availableItemID]) then
				availableSlots[availableItemID] = { slotID }
			else
				tinsertonce(availableSlots[availableItemID], slotID)
			end
		end

		-- special handling for plate heirlooms
		if (TopFit.heirloomInfo.isPlateWearer and (slotID == 3 or slotID == 5) and UnitLevel("player") < 40) then
			for i = 1, #(TopFit.heirloomInfo.plateHeirlooms[slotID]) do
				if (not availableSlots[TopFit.heirloomInfo.plateHeirlooms[slotID][i]]) then
					availableSlots[TopFit.heirloomInfo.plateHeirlooms[slotID][i]] = { slotID }
				else
					tinsertonce(availableSlots[TopFit.heirloomInfo.plateHeirlooms[slotID][i]], slotID)
				end
			end
		end

		-- special handling for mail heirlooms
		if (TopFit.heirloomInfo.isMailWearer and (slotID == 3 or slotID == 5) and UnitLevel("player") < 40) then
			for i = 1, #(TopFit.heirloomInfo.mailHeirlooms[slotID]) do
				if (not availableSlots[TopFit.heirloomInfo.mailHeirlooms[slotID][i]]) then
					availableSlots[TopFit.heirloomInfo.mailHeirlooms[slotID][i]] = { slotID }
				else
					tinsertonce(availableSlots[TopFit.heirloomInfo.mailHeirlooms[slotID][i]], slotID)
				end
			end
		end
	end

	-- check player's bags
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			if itemLink then
				local itemID = string.gsub(itemLink, ".*|Hitem:([0-9]*):.*", "%1")
				itemID = tonumber(itemID)

				if (availableSlots[itemID]) then
					-- check if item is BoE
					local isBoE = TopFit:IsItemBoE(bag, slot)

					for _, slotID in pairs(availableSlots[itemID]) do
						tinsert(itemListBySlot[slotID], {
							itemLink = itemLink,
							isBoE = isBoE,
							bag = bag,
							slot = slot
						})
					end
				end
			end
		end
	end

	-- check player's inventory
	for _, invSlot in pairs(TopFit.slots) do
		local itemLink = GetInventoryItemLink("player", invSlot)
		if itemLink then
			local itemID = string.gsub(itemLink, ".*|Hitem:([0-9]*):.*", "%1")
			itemID = tonumber(itemID)

			if (availableSlots[itemID]) then
				for _, slotID in pairs(availableSlots[itemID]) do
					tinsert(itemListBySlot[slotID], {
						itemLink = itemLink,
						isBoE = false, -- it is already equipped
						slot = invSlot
					})
				end
			end
		end
	end

	if (TopFit.setCode) then
		-- add virtual items
		if (TopFit.setCode and TopFit.db.profile.sets[TopFit.setCode].virtualItems and not TopFit.db.profile.sets[TopFit.setCode].skipVirtualItems) then
			for _, itemLink in pairs(TopFit.db.profile.sets[TopFit.setCode].virtualItems) do
				local item = TopFit:GetCachedItem(itemLink)
				if item then    -- in case weird items end up in our cache
					local equipSlots = TopFit:GetEquipLocationsByInvType(item.itemEquipLoc)
					for _, slotID in pairs(equipSlots) do
						tinsert(itemListBySlot[slotID], {
							itemLink = itemLink,
							isBoE = false, -- if it's in virtual items, we want to include it
							isVirtual = true
						})
					end
				end
			end
		end
	end

	if (requestedSlotID) then
		return itemListBySlot[requestedSlotID]
	else
		return itemListBySlot
	end
end

-- gets an item's info from the cache
function TopFit:GetCachedItem(itemLink)
	if not itemLink then return nil end
	TopFit:UpdateCache(itemLink)

	return TopFit.itemsCache[itemLink]
end

-- check whether a weapon can be equipped in one hand (takes titan's grip into account)
local POLEARMS, _, _, STAVES, _, _, _, _, _, WANDS, FISHINGPOLES = select(7, GetAuctionItemSubClasses(1))
function TopFit:IsOnehandedWeapon(set, itemID)
	local _, _, _, _, _, _, subclass, _, equipSlot, _, _ = GetItemInfo(itemID)
	if equipSlot and string.find(equipSlot, "2HWEAPON") then
		if (set:CanTitansGrip()) then
			if subclass == POLEARMS or subclass == STAVES or subclass == FISHINGPOLES then
				return false
			end
		else
			return false
		end
	elseif equipSlot and string.find(equipSlot, "RANGED") then
		if subclass == WANDS then
			return true
		end
		return false
	end
	return true
end


-- --------------------------------------------------------
--  Add missing items to Blizzard's GetInventoryItemsForSlot
-- --------------------------------------------------------
local Unfit = LibStub('Unfit-1.0')
local ItemLocations = LibStub('LibItemLocations')
local equipLocation = {
	INVTYPE_HEAD            =  1,
	INVTYPE_NECK            =  2,
	INVTYPE_SHOULDER        =  3,
	INVTYPE_BODY            =  4,
	INVTYPE_CHEST           =  5,
	INVTYPE_ROBE            =  5,
	INVTYPE_WAIST           =  6,
	INVTYPE_LEGS            =  7,
	INVTYPE_FEET            =  8,
	INVTYPE_WRIST           =  9,
	INVTYPE_HAND            = 10,
	INVTYPE_FINGER          = 11,
	INVTYPE_TRINKET         = 13,
	INVTYPE_CLOAK           = 15,
	INVTYPE_WEAPON          = 16,
	INVTYPE_SHIELD          = 17,
	INVTYPE_2HWEAPON        = 16,
	INVTYPE_RANGED          = 16,
	INVTYPE_RANGEDRIGHT     = 16,
	INVTYPE_WEAPONMAINHAND  = 16,
	INVTYPE_WEAPONOFFHAND   = 17,
	INVTYPE_HOLDABLE        = 17,
	INVTYPE_TABARD          = 19,
}
local equippableCache = {}
local function PassesTooltipRequirements(link)
	if equippableCache[link] ~= nil then
		return equippableCache[link]
	end

	local scanTooltip = ns.scanTooltip
	scanTooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	scanTooltip:SetHyperlink(link)
	local numLines = scanTooltip:NumLines()
	if numLines < 1 then return false end
	for line = 1, numLines do
		-- if tooltip contains red text lines, item is unusable
		local fontString = _G[scanTooltip:GetName()..'TextLeft'..line]
		local r, g, b, a = fontString:GetTextColor()
		if math.abs(r*255 - 255) < 1 and math.abs(g*255 - 32) < 1 and math.abs(b*255 - 32) < 1 and math.abs(a*255 - 255) < 1 then
			equippableCache[link] = false
			return false
		end
		fontString = _G[scanTooltip:GetName()..'TextRight'..line]
		r, g, b, a = fontString:GetTextColor()
		if math.abs(r*255 - 255) < 1 and math.abs(g*255 - 32) < 1 and math.abs(b*255 - 32) < 1 and math.abs(a*255 - 255) < 1 then
			equippableCache[link] = false
			return false
		end
	end
	equippableCache[link] = true
	return true
end
local function AddEquippableItem(useTable, inventorySlot, container, slot)
	local itemID, link
	if not container then
		slot   = inventorySlot
		itemID = GetInventoryItemID('player', slot)
		link   = GetInventoryItemLink('player', slot)
	else
		itemID = GetContainerItemID(container, slot)
		link   = GetContainerItemLink(container, slot)
	end
	if not link then return end -- even when there's an id, without the link we can't do anything

	local isBags   = container and container >= _G.BACKPACK_CONTAINER and container <= _G.NUM_BAG_SLOTS+_G.NUM_BANKBAGSLOTS
	local isBank   = container and container == _G.BANK_CONTAINER or (isBags and container > _G.NUM_BAG_SLOTS)
	local isPlayer = not isBank
	if not isBags then container = nil end

	local location = ItemLocations:PackInventoryLocation(container, slot, isPlayer, isBank, isBags)

	local _, _, _, _, _, _, subClass, _, equipSlot = GetItemInfo(link)
	if inventorySlot == 14 then inventorySlot = 13 end -- trinket
	if inventorySlot == 12 then inventorySlot = 11 end -- ring
	-- maybe also use IsUsableItem()?
	if not useTable[location] and equipLocation[equipSlot] == inventorySlot
		and not Unfit:IsClassUnusable(subClass, equipSlot) and PassesTooltipRequirements(link) then
		useTable[location] = itemID
	end
end

local partnerSlots = {
	[11] = 12, -- Trinket
	[12] = 11,
	[13] = 14, -- Finger
	[14] = 13,
	[16] = 17, -- Main Hand / Off Hand
	[17] = 16,
}
hooksecurefunc('GetInventoryItemsForSlot', function(inventorySlot, useTable, transmog)
	if UnitLevel('player') >= MAX_PLAYER_LEVEL_TABLE[#MAX_PLAYER_LEVEL_TABLE] then return end
	-- scan equipped items
	AddEquippableItem(useTable, inventorySlot)
	if partnerSlots[inventorySlot] then
		AddEquippableItem(useTable, partnerSlots[inventorySlot])
	end

	-- scan bag containers
	for container = 1, _G.NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) or 0 do
			AddEquippableItem(useTable, inventorySlot, container, slot)
		end
	end
	-- scan bank main frame (data is only available when bank is opened)
	for slot = 1, _G.NUM_BANKGENERIC_SLOTS do
		AddEquippableItem(useTable, inventorySlot, _G.BANK_CONTAINER, slot)
	end
	-- scan bank containers
	for bankContainer = 1, _G.NUM_BANKBAGSLOTS do
		local container = _G.ITEM_INVENTORY_BANK_BAG_OFFSET + bankContainer
		for slot = 1, GetContainerNumSlots(container) or 0 do
			AddEquippableItem(useTable, inventorySlot, container, slot)
		end
	end
end)
