local addonName, ns, _ = ...

local function percentilize(ratio, noColor)
	local ratioString = string.format("%.2f%%", (ratio - 1) * 100)
	if ratio > 11 then ratioString = "> 1000%"
	elseif ratio < -11 then ratioString = "< 1000%"
	end

	if not noColor then
		local color = "ffff00"
		if ratio >= 1.1 then
			color = "00ff00"
		elseif ratio < 1 then
			color = "ff0000"
		end
		ratioString = string.format("|cff%s%s|r", color, ratioString)
	end

	return ratioString
end

--- takes a string and escapes the magic characters ^$()%.[]*+-? with a %-character for safe use in Lua patterns
local function escape(text)
	return string.gsub(text, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local function GetSecondaryCompareItem(tooltip)
	if not tooltip.shoppingTooltips then return end
	local shoppingTooltip1, shoppingTooltip2 = unpack(tooltip.shoppingTooltips)
	if not shoppingTooltip2 or not shoppingTooltip2:IsShown() then return end
	local _, itemLink = shoppingTooltip2:GetItem()
	return itemLink
end

--- New Tooltip handler code, wheeeee!
-- TODO: react to http://www.townlong-yak.com/framexml/19116/GameTooltip.lua#350
local tokenCache, tokenCacheItem = {}, nil
local tokenHandlers = {}
-- allow plugins to register their own tooltip token replacement handlers
function TopFit:RegisterTokenHandler(token, handler, allowReplace)
	if tokenHandlers[token] and not allowReplace then
		return false, 'Token handler for '..token..' is already registered.'
	end
	tokenHandlers[token] = handler
	return true
end
function TopFit:GetTokenHandler(token)
	return token and tokenHandlers[token] or nil
end

-- initialize token replacement handlers
TopFit:RegisterTokenHandler('equipped', function(base, options, itemTable, set, tooltip)
	-- whether or not the item is equipped
	for _, slotID in ipairs(itemTable.equipLocationsByType) do
		local setItem = ns:GetSetItemFromSlot(slotID, set)
		if setItem == itemTable.itemLink then
			return options or 'equipped'
		end
	end
end)
TopFit:RegisterTokenHandler('info', function(base, options, itemTable, set, tooltip)
	-- additional info, mostly used for "when also using ..."
	return tokenCache[set]['info']
end)
TopFit:RegisterTokenHandler('item', function(base, options, itemTable, set, tooltip)
	-- metadata on the item displayed in the tooltip
	if options == 'score' then
		return ('%.2f'):format(set:GetItemScore(itemTable.itemLink))
	end
end)
TopFit:RegisterTokenHandler('set', function(base, options, itemTable, set, tooltip)
	-- metadata on the TopFit equipment set that data is displayed for
	if options == 'icon' then
		return '|T'..set:GetIconTexture()..':0|t'
	elseif options == 'name' then
		return set:GetName()
	end
end)

local EQUIPPEDITEM_MH = _G.ITEM_DELTA_DUAL_WIELD_COMPARISON_MAINHAND_DESCRIPTION:sub(2, -2)
local EQUIPPEDITEM_OH = _G.ITEM_DELTA_DUAL_WIELD_COMPARISON_OFFHAND_DESCRIPTION:sub(2, -2)
TopFit:RegisterTokenHandler('delta', function(base, options, itemTable, set, tooltip)
	-- comparison for primary item
	local scoreType, scoreFormat = string.split(':', options)
	local useRaw = scoreType and scoreType == 'raw'

	-- TODO: handle scoreFormat
	-- TODO: handle non-dual-wielding (i.e. currently Y but compared set is N)
	-- '|TInterface\\PetBattles\\BattleBar-AbilityBadge-Strong-Small:0|t'
	-- '|TInterface\\PetBattles\\BattleBar-AbilityBadge-Weak-Small:0|t'
	-- http://wowinterface.com/downloads/info22536

	-- only regard one slot, needed for 1H weapons, rings, trinkets
	local slotID = itemTable.equipLocationsByType[base == 'delta' and 1 or 2]
	if not slotID then return end
	local setItem = ns:GetSetItemFromSlot(slotID, set)
	if not setItem then
		return 'unknown item'
	elseif setItem == itemTable.itemLink then
		return nil
	end

	local itemScore    = set:GetItemScore(itemTable.itemLink, useRaw) or 0
	local setItemScore = set:GetItemScore(setItem, useRaw) or 0

	local isOneHanded = TopFit:IsOnehandedWeapon(set, itemTable)
	if isOneHanded ~= nil then
		-- this is an item that's equipped in MH and/or OH
		if not isOneHanded then
			-- 2H vs. MH/OH: add other item to compare values
			local otherSlotID = itemTable.equipLocationsByType[base == 'delta' and 2 or 1]
			local otherSetItem = otherSlotID and ns:GetSetItemFromSlot(otherSlotID, set)
			if otherSetItem then
				setItemScore = setItemScore + (otherSetItem and set:GetItemScore(otherSetItem, useRaw) or 0)
			end
		elseif TopFit:IsOnehandedWeapon(set, setItem) == false then
			-- MH/OH vs. 2H: "when also using"
			local otherItem = GetSecondaryCompareItem(tooltip)
			if otherItem then
				local otherItemScore = set:GetItemScore(otherItem, useRaw)
				itemScore = itemScore + otherItemScore

				-- add info text
				local text = base == 'delta' and EQUIPPEDITEM_OH or EQUIPPEDITEM_MH
				local itemName, _, quality = GetItemInfo(otherItem)
				local _, _, _, hexColor = GetItemQualityColor(quality)
				tokenCache[set].info = tokenCache[set].info or text:format(hexColor, itemName)
			end
		end
	end

	if setItemScore > 0 then
		return percentilize(itemScore / setItemScore)
	elseif itemScore > 0 then
		return percentilize(math.huge)
	end
end)
TopFit:RegisterTokenHandler('delta2', TopFit:GetTokenHandler('delta'))

-- call this if you want to add comparison lines to a tooltip
function TopFit:AddComparisonTooltipLines(tooltip, itemLink)
	if tooltip and not itemLink then
		-- item not supplied, try to get it from tooltip
		_, itemLink = tooltip:GetItem()
	end
	if not tooltip or not itemLink then return end

	local itemTable = TopFit:GetCachedItem(itemLink)
	for _, setCode in pairs(ns.GetSetList()) do
		local set = ns.GetSetByID(setCode, true)
		if itemLink ~= tokenCacheItem and tokenCache[set] then
			wipe(tokenCache[set])
		end
		TopFit:AddTooltipItemComparisonForSet(tooltip, set, itemTable)
	end
	tokenCacheItem = itemLink
end

hooksecurefunc('GameTooltip_AdvanceSecondaryCompareItem', function(tooltip)
	-- wipe cache when user changes secondary compare item
	if not GetCVarBool('allowCompareWithToggle') then return end
	for _, setCode in pairs(ns.GetSetList()) do
		local set = ns.GetSetByID(setCode, true)
		if tokenCache[set] then
			wipe(tokenCache[set])
		end
	end
end)

-- TODO: allow complex tokens as oUF does: https://github.com/haste/oUF/blob/master/elements/tags.lua#L513
local tooltipPatternLeft, tooltipPatternRight = '[set:icon] [set:name][ (>delta:raw:percent</][delta:current:percent<)][ (>delta2:raw:percent</][delta2:current:percent<)][ (>equipped:eq.<)][|n    >info]', '[item:score]'

-- adds comparison lines for specific item set
function TopFit:AddTooltipItemComparisonForSet(tooltip, set, itemTable)
	if not set:GetDisplayInTooltip() then return end
	if not tokenCache[set] then tokenCache[set] = {} end

	local left, right = tooltipPatternLeft, tooltipPatternRight
	for component in (tooltipPatternLeft .. ' ' .. tooltipPatternRight):gmatch('(%b[])') do
		local tag, prefix, suffix = component:sub(2, -2)
		prefix, tag = strsplit('>', tag, 2)
		if not tag then tag = prefix; prefix = nil end
		tag, suffix = strsplit('<', tag, 2)

		local replacement = tokenCache[set][tag]
		if replacement == nil then -- cache stores false for n/a
			local base, options = string.split(':', tag, 2)
			replacement = tokenHandlers[base] and tokenHandlers[base](base, options, itemTable, set, tooltip) or false
			-- cache result
			tokenCache[set][tag] = replacement
			TopFit:Debug('Replacing Token', tag, 'with', replacement)
		end

		if replacement and replacement ~= '' then
			replacement = (prefix or '') .. replacement .. (suffix or '')
		end
		left  = left:gsub(escape(component), replacement or '')
		right = right:gsub(escape(component), replacement or '')
	end
	tooltip:AddDoubleLine(left, right)
end

-- WARNING: old code below
-- TODO: remove. this is only needed until we properly work with set objects
local emptySet = ns.Set()

-- TODO: this function used to be part of DefaultCalculation but has been refactored a lot by now. It needs to be retired
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

function TopFit:getComparePercentage(itemTable, setCode)
	if not itemTable or not setCode then return 0 end
	local set = ns.GetSetByID(setCode)
	if not set then return 0 end

	local rawScore, asIsScore, rawCompareScore, asIsCompareScore = 0, 0, 0, 0

	rawScore = set:GetItemScore(itemTable.itemLink, true) -- including caps, raw score
	asIsScore = set:GetItemScore(itemTable.itemLink, false) -- including caps, enchanted score

	if true then return 0 end



	if slotID == 16 then -- main hand slot
		if TopFit:IsOnehandedWeapon(emptySet, link) then
			-- is the weapon we compare to (if it exists) two-handed?
			if setItemIDs and setItemIDs[slotID] and setItemIDs[slotID] ~= 1 and setItemIDs[slotID] ~= 0 and not TopFit:IsOnehandedWeapon(emptySet, setItemIDs[slotID]) then
				-- try to find a fitting offhand for better comparison
				if set:CanDualWield() then
					-- find best offhand regardless of type
					local lTable2 = TopFit:CalculateBestInSlot(emptySet, {locationTable, compLocationTable}, false, 17, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(emptySet, locationTable.itemLink) end)
					if lTable2 then
						itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
					end
				else
					-- find best offhand that is not a weapon
					local lTable2 = TopFit:CalculateBestInSlot(emptySet, {locationTable, compLocationTable}, false, 17, setCode, function(locationTable) itemTable = TopFit:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
					if lTable2 then
						itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
					end
				end
			else
			end
		else
			if setItemIDs and setItemIDs[slotID] and setItemIDs[slotID] ~= 1 then
				-- mainhand is set
				if TopFit:IsOnehandedWeapon(emptySet, setItemIDs[slotID]) then
					-- use offhand of that set as second compare item
					if (setItemLinks[17]) then
						compareTable2 = TopFit:GetCachedItem(setItemLinks[17])
					end
				else
					-- compare normally, these are 2 two-handed weapons
				end
			else
				-- compare with offhand if appliccapble
				if (setItemLinks[17]) then
					compareTable2 = TopFit:GetCachedItem(setItemLinks[17])
				end
			end
		end
	elseif slotID == 17 then -- offhand slot
		-- find a valid mainhand to use in comparisons (only when comparing to a 2h)
		if setItemIDs and setItemIDs[16] and setItemIDs[16] ~= 1 and not TopFit:IsOnehandedWeapon(emptySet, setItemIDs[16]) then
			local lTable2 = TopFit:CalculateBestInSlot(emptySet, {locationTable, compLocationTable}, false, 16, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(emptySet, locationTable.itemLink) end)
			if lTable2 then
				itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
			end

			-- also set compareTable to the relevant MAIN HAND! since offhand is empty, obviously
			compareTable = TopFit:GetCachedItem(setItemLinks[16])

			if compareTable then
				rawCompareScore = set:GetItemScore(compareTable.itemLink, true)
				asIsCompareScore = set:GetItemScore(compareTable.itemLink, false)
			else
				compareNotCached = true
			end
		end
	end

	if itemTable2 then
		rawScore = rawScore + set:GetItemScore(itemTable2.itemLink, true)
		asIsScore = asIsScore + set:GetItemScore(itemTable2.itemLink, false)

		extraText = extraText..", if you also use "..itemTable2.itemLink
	end

	if compareTable2 then
		rawCompareScore = rawCompareScore + set:GetItemScore(compareTable2.itemLink, true)
		asIsCompareScore = asIsCompareScore + set:GetItemScore(compareTable2.itemLink, false)

		extraText = extraText..", "..compareTable2.itemLink
	end

	local ratio, rawRatio, ratioString, rawRatioString = 1, 1, "", ""
	if rawCompareScore ~= 0 then
		rawRatio = rawScore / rawCompareScore
	elseif rawScore > 0 then
		rawRatio = 20
	elseif rawScore < 0 then
		rawRatio = -20
	end
	if asIsCompareScore ~= 0 then
		ratio = asIsScore / asIsCompareScore
	elseif asIsScore > 0 then
		ratio = 20
	elseif asIsScore < 0 then
		ratio = -20
	end

	local compareItemText = ""
	if compareNotCached then
		compareItemText = "Item not in cache!|n"
	elseif not compareTable then
		compareItemText = "No item in set"
	else
		compareItemText = compareTable.itemLink
	end

	if ratio ~= rawRatio then
		tt:AddDoubleLine("["..percentilize(rawRatio).."/"..percentilize(ratio).."] - "..compareItemText..extraText, set:GetName())
	else
		tt:AddDoubleLine("["..percentilize(rawRatio).."] - "..compareItemText..extraText, set:GetName())
	end
end

-- Tooltip functions
local function TooltipAddCompareLines(tt, link)
	local itemTable = TopFit:GetCachedItem(link)

	--TopFit:Debug("Adding Compare Tooltip for "..(link or "nil"))

	-- if the item is not yet cached, no tooltip info is added
	if not itemTable then
		return
	end

	-- iterate all sets and compare with set's items
	local sets = ns.GetSetList()
	if #sets > 0 and GetNumEquipmentSets() == 0 and CanUseEquipmentSets() then
		tt:AddLine("Can't compare: Blizzard equipment sets are missing!", 1, 0, 0)
		return
	end

	tt:AddLine(" ")
	tt:AddLine("Compared with your current items for each set:")
	for _, setCode in ipairs(sets) do
		local set = ns.GetSetByID(setCode, true)
		if set:GetDisplayInTooltip() then
			-- find current item(s) from set
			local setName       = TopFit:GenerateSetName(set:GetName())
			local itemPositions = GetEquipmentSetLocations(setName)
			local itemIDs       = GetEquipmentSetItemIDs(setName)
			local itemLinks = {}
			if itemPositions then
				for slotID, itemLocation in pairs(itemPositions) do
					if itemLocation and itemLocation ~= 1 and itemLocation ~= 0 then -- 0: set to no item; 1: slot is ignored
						local itemLink = nil
						local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(itemLocation)
						if player then
							if bank then
								-- item is banked, use itemID
								local itemID = itemIDs[slotID]
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
						else
							-- item not found
						end
						itemLinks[slotID] = itemLink
					end
				end

				for _, slotID in pairs(itemTable.equipLocationsByType) do
					-- get compare items sorted out
					local itemID = nil
					local itemLink = nil
					local rawScore, asIsScore, rawCompareScore, asIsCompareScore = 0, 0, 0, 0
					local extraText = ""
					local compareTable = nil
					local itemTable2 = nil
					local compareTable2 = nil
					local compareNotCached = false

					rawScore = set:GetItemScore(itemTable.itemLink, true) -- including caps, raw score
					asIsScore = set:GetItemScore(itemTable.itemLink, false) -- including caps, enchanted score

					if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 and itemIDs[slotID] ~= 0 then
						itemID = itemIDs[slotID]
						itemLink = itemLinks[slotID]

						if itemLink then
							compareTable = TopFit:GetCachedItem(itemLink)
						end

						if compareTable then
							rawCompareScore = set:GetItemScore(compareTable.itemLink, true)
							asIsCompareScore = set:GetItemScore(compareTable.itemLink, false)
						else
							compareNotCached = true
						end
					end

					-- location tables for best-in-slot requests
					local locationTable, compLocationTable
					if (slotID == 16 or slotID == 17) then
						locationTable = {itemLink = itemTable.itemLink, slot = nil, bag = nil}
						if compareTable then
							local player, bank, bags, _, slot, bag = EquipmentManager_UnpackLocation(itemPositions[slotID])
							if player then
								if bags then
									compLocationTable = {itemLink = compareTable.itemLink, slot = slot, bag = bag}
								elseif bank then
									compLocationTable = {itemLink = compareTable.itemLink, slot = nil, bag = nil}
								else
									compLocationTable = {itemLink = compareTable.itemLink, slot = slot, bag = nil}
								end
							else
								compLocationTable = {itemLink = compareTable.itemLink, slot = nil, bag = nil}
							end
						else
							compLocationTable = {itemLink = "", slot = nil, bag = nil}
						end
					end

					if slotID == 16 then -- main hand slot
						if TopFit:IsOnehandedWeapon(emptySet, link) then
							-- is the weapon we compare to (if it exists) two-handed?
							if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 and itemIDs[slotID] ~= 0 and not TopFit:IsOnehandedWeapon(emptySet, itemIDs[slotID]) then
								-- try to find a fitting offhand for better comparison
								if set:CanDualWield() then
									-- find best offhand regardless of type
									local lTable2 = TopFit:CalculateBestInSlot(emptySet, {locationTable, compLocationTable}, false, 17, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(emptySet, locationTable.itemLink) end)
									if lTable2 then
										itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
									end
								else
									-- find best offhand that is not a weapon
									local lTable2 = TopFit:CalculateBestInSlot(emptySet, {locationTable, compLocationTable}, false, 17, setCode, function(locationTable) itemTable = TopFit:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
									if lTable2 then
										itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
									end
								end
							else
							end
						else
							if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 then
								-- mainhand is set
								if TopFit:IsOnehandedWeapon(emptySet, itemIDs[slotID]) then
									-- use offhand of that set as second compare item
									if (itemLinks[17]) then
										compareTable2 = TopFit:GetCachedItem(itemLinks[17])
									end
								else
									-- compare normally, these are 2 two-handed weapons
								end
							else
								-- compare with offhand if appliccapble
								if (itemLinks[17]) then
									compareTable2 = TopFit:GetCachedItem(itemLinks[17])
								end
							end
						end
					elseif slotID == 17 then -- offhand slot
						-- find a valid mainhand to use in comparisons (only when comparing to a 2h)
						if itemIDs and itemIDs[16] and itemIDs[16] ~= 1 and not TopFit:IsOnehandedWeapon(emptySet, itemIDs[16]) then
							local lTable2 = TopFit:CalculateBestInSlot(emptySet, {locationTable, compLocationTable}, false, 16, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(emptySet, locationTable.itemLink) end)
							if lTable2 then
								itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
							end

							-- also set compareTable to the relevant MAIN HAND! since offhand is empty, obviously
							compareTable = TopFit:GetCachedItem(itemLinks[16])

							if compareTable then
								rawCompareScore = set:GetItemScore(compareTable.itemLink, true)
								asIsCompareScore = set:GetItemScore(compareTable.itemLink, false)
							else
								compareNotCached = true
							end
						end
					end

					if itemTable2 then
						rawScore = rawScore + set:GetItemScore(itemTable2.itemLink, true)
						asIsScore = asIsScore + set:GetItemScore(itemTable2.itemLink, false)

						extraText = extraText..", if you also use "..itemTable2.itemLink
					end

					if compareTable2 then
						rawCompareScore = rawCompareScore + set:GetItemScore(compareTable2.itemLink, true)
						asIsCompareScore = asIsCompareScore + set:GetItemScore(compareTable2.itemLink, false)

						extraText = extraText..", "..compareTable2.itemLink
					end

					local ratio, rawRatio, ratioString, rawRatioString = 1, 1, "", ""
					if rawCompareScore ~= 0 then
						rawRatio = rawScore / rawCompareScore
					elseif rawScore > 0 then
						rawRatio = 20
					elseif rawScore < 0 then
						rawRatio = -20
					end
					if asIsCompareScore ~= 0 then
						ratio = asIsScore / asIsCompareScore
					elseif asIsScore > 0 then
						ratio = 20
					elseif asIsScore < 0 then
						ratio = -20
					end

					local compareItemText = ""
					if compareNotCached then
						compareItemText = "Item not in cache!|n"
					elseif not compareTable then
						compareItemText = "No item in set"
					else
						compareItemText = compareTable.itemLink
					end

					if ratio ~= rawRatio then
						tt:AddDoubleLine("["..percentilize(rawRatio).."/"..percentilize(ratio).."] - "..compareItemText..extraText, set:GetName())
					else
						tt:AddDoubleLine("["..percentilize(rawRatio).."] - "..compareItemText..extraText, set:GetName())
					end
				end
			end
		end
	end
end
ns.TooltipAddCompareLines = TooltipAddCompareLines --TODO: this is temporary

local statNames = {
	TOPFIT_ARMORTYPE_CLOTH   = 'Cloth armor',
	TOPFIT_ARMORTYPE_LEATHER = 'Leather armor',
	TOPFIT_ARMORTYPE_MAIL    = 'Mail armor',
	TOPFIT_ARMORTYPE_PLATE   = 'Plate armor',
}
local function GetStatName(statGlobal)
	return _G[statGlobal] or statNames[statGlobal] or statGlobal
end

local function TooltipAddLines(tt, link)
	local itemTable = TopFit:GetCachedItem(link)

	if not itemTable then return end

	if (TopFit.db.profile.debugMode) then
		-- item stats
		tt:AddLine("Item stats as seen by TopFit:", 0.5, 0.9, 1)
		for stat, value in pairs(itemTable["itemBonus"]) do
			if not string.find(stat, "SET: ") then
				local valueString = ""
				local first = true
				for _, setTable in pairs(TopFit.db.profile.sets) do
					local weightedValue = (setTable.weights[stat] or 0) * value
					if first then
						first = false
					else
						valueString = valueString.." / "
					end
					valueString = valueString..(tonumber(weightedValue) or "0")
				end
				local statLabel = ('  +%1$d %2$s'):format(value or 0, GetStatName(stat))
				tt:AddDoubleLine(statLabel, valueString, 0.5, 0.9, 1)
			end
		end

		-- enchantment stats
		if (itemTable["enchantBonus"]) then
			tt:AddLine("Enchant:", 1, 0.9, 0.5)
			for stat, value in pairs(itemTable["enchantBonus"]) do
				local valueString = ""
				local first = true
				for _, setTable in pairs(TopFit.db.profile.sets) do
					local weightedValue = (setTable.weights[stat] or 0) * value
					if first then
						first = false
					else
						valueString = valueString.." / "
					end
					valueString = valueString..(tonumber(weightedValue) or "0")
				end
				local statLabel = ('  +%1$d %2$s'):format(value or 0, GetStatName(stat))
				tt:AddDoubleLine(statLabel, valueString, 1, 0.9, 0.5)
			end
		end

		-- gems
		if (itemTable["gemBonus"]) then
			local first = true
			for stat, value in pairs(itemTable["gemBonus"]) do
				if first then
					first = false
					tt:AddLine("Gems:", 0.8, 0.2, 0)
				end

				local valueString = ""
				local first = true
				for _, setTable in pairs(TopFit.db.profile.sets) do
					local weightedValue = (setTable.weights[stat] or 0) * value
					if first then
						first = false
					else
						valueString = valueString.." / "
					end
					valueString = valueString..(tonumber(weightedValue) or "0")
				end
				local statLabel = ('  +%1$d %2$s'):format(value or 0, GetStatName(stat))
				tt:AddDoubleLine(statLabel, valueString, 0.8, 0.2, 0)
			end
		end
	end

	if (TopFit.db.profile.showTooltip) then
		-- scores for sets
		local first = true
		local sets = ns.GetSetList()
		for _, setCode in pairs(sets) do
			local set = ns.GetSetByID(setCode)
			if set:GetDisplayInTooltip() then
				if first then
					first = false
					tt:AddLine(' ')
					tt:AddLine("TopFit Set Values:", 0.6, 1, 0.7) --TODO: translate
				end
				tt:AddLine(string.format("  %.2f - %s", set:GetItemScore(itemTable.itemLink), set:GetName()), 0.6, 1, 0.7)
			end
		end
	end
end

local clearedSemaphores = {}
local function OnTooltipCleared(self, semaphore)
	clearedSemaphores[semaphore] = nil
end

local function OnTooltipSetItem(self, semaphore, skipCompareLines)
	if not clearedSemaphores[semaphore] then
		local name, link = self:GetItem()
		if (name) then
			local equipSlot = select(9, GetItemInfo(link))
			if IsEquippableItem(link) and equipSlot ~= 'INVTYPE_BAG' and not ns.Unfit:IsItemUnusable(link) then
				TooltipAddLines(self, link)
				if (TopFit.db.profile.showComparisonTooltip and not TopFit.isBlocked and not skipCompareLines) then
					TooltipAddCompareLines(self, link)
					TopFit:AddComparisonTooltipLines(self, link)
				end
			end
			clearedSemaphores[semaphore] = true
		end
	end
end

-- hook all tooltips that interest us
GameTooltip:HookScript("OnTooltipCleared", function(self) OnTooltipCleared(self, "item") end)
GameTooltip:HookScript("OnTooltipSetItem", function(self) OnTooltipSetItem(self, "item") end)
ItemRefTooltip:HookScript("OnTooltipCleared", function(self) OnTooltipCleared(self, "ref") end)
ItemRefTooltip:HookScript("OnTooltipSetItem", function(self) OnTooltipSetItem(self, "ref") end)
-- shopping tooltips are set to skip compare lines because usually the equipped items are identical to our set's items anyways
ShoppingTooltip1:HookScript("OnTooltipCleared", function(self) OnTooltipCleared(self, "shopping1") end)
ShoppingTooltip1:HookScript("OnTooltipSetItem", function(self) OnTooltipSetItem(self, "shopping1", true) end)
ShoppingTooltip2:HookScript("OnTooltipCleared", function(self) OnTooltipCleared(self, "shopping2") end)
ShoppingTooltip2:HookScript("OnTooltipSetItem", function(self) OnTooltipSetItem(self, "shopping2", true) end)
