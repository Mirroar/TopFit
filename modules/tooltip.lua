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

-- takes a string and escapes the magic characters ^$()%.[]*+-? with a %-character for safe use in Lua patterns
local function escape(text)
	return string.gsub(text, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
end

local function GetSecondaryCompareItem(tooltip)
	-- TODO: how to react when comparison is not already shown => item n/a
	if not tooltip.shoppingTooltips then return end
	local shoppingTooltip1, shoppingTooltip2 = unpack(tooltip.shoppingTooltips)
	if not shoppingTooltip2 or not shoppingTooltip2:IsShown() then return end
	local _, itemLink = shoppingTooltip2:GetItem()
	return itemLink
end

-- caches token replacements so we do not recalculate every frame
-- format: tokenCache[tooltip][set][token] = 'replacement'
local tokenCache    = setmetatable({}, {__mode = 'kv'})
local tokenHandlers = {}

-- allow plugins to register their own tooltip token replacement handlers
function TopFit:RegisterTokenHandler(token, handler, override)
	if tokenHandlers[token] and not override then
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
		local setItem = set:GetItemInSlot(slotID)
		if setItem == itemTable.itemLink then
			return options or 'equipped'
		end
	end
end)
TopFit:RegisterTokenHandler('info', function(base, options, itemTable, set, tooltip)
	-- additional info, mostly used for "when also using ..."
	return tokenCache[tooltip][set].info
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

-- TODO: maybe find better (shorter) texts
local EQUIPPEDITEM_MH = _G.ITEM_DELTA_DUAL_WIELD_COMPARISON_MAINHAND_DESCRIPTION:sub(2, -2)
local EQUIPPEDITEM_OH = _G.ITEM_DELTA_DUAL_WIELD_COMPARISON_OFFHAND_DESCRIPTION:sub(2, -2)
TopFit:RegisterTokenHandler('delta', function(base, options, itemTable, set, tooltip)
	-- relative item score comparison
	-- shopping tooltips usually compare to an already equipped item
	if tooltip:GetName():find('^ShoppingTooltip') then return end
	-- show compare values only when actually comparing
	-- TODO: make this a setting: only show compare values when actually comparing
	-- if tooltip.shoppingTooltips and not tooltip.shoppingTooltips[1]:IsShown() then return end

	local scoreType, scoreFormat = string.split(':', options)
	local useRaw = scoreType and scoreType == 'raw'

	-- TODO: handle scoreFormat
	-- TODO: handle comparing to empty slots
	-- TODO: do not compare 2h if shield is forced
	-- '|TInterface\\PetBattles\\BattleBar-AbilityBadge-Strong-Small:0|t'
	-- '|TInterface\\PetBattles\\BattleBar-AbilityBadge-Weak-Small:0|t'
	-- http://wowinterface.com/downloads/info22536

	-- only regard one slot, needed for 1H weapons, rings, trinkets
	local slotID = itemTable.equipLocationsByType[base == 'delta' and 1 or 2]
	if not slotID or not set:CanItemGoInSlot(itemTable, slotID) then return end
	local setItem = set:GetItemInSlot(slotID)
	if not setItem or setItem == itemTable.itemLink then return end

	local itemScore    = set:GetItemScore(itemTable.itemLink, useRaw) or 0
	local setItemScore = set:GetItemScore(setItem, useRaw) or 0

	-- comparison cases: 1H => 1:MH/2:OH, 2H => 1:MH+OH, MH => 1:MH, OH => 1:OH
	local isOneHanded = set:IsOnehandedWeapon(itemTable)
	if isOneHanded ~= nil then
		-- this is an item that's equipped in MH and/or OH
		if not isOneHanded then
			-- 2H vs. MH/OH: add other item to compare values
			local otherSlotID = itemTable.equipLocationsByType[base == 'delta' and 2 or 1]
			local otherSetItem = otherSlotID and set:GetItemInSlot(otherSlotID)
			if otherSetItem then
				setItemScore = setItemScore + (otherSetItem and set:GetItemScore(otherSetItem, useRaw) or 0)
			end
		elseif set:IsOnehandedWeapon(setItem) == false then
			-- MH/OH vs. 2H: "when also using"
			local otherItem = GetSecondaryCompareItem(tooltip)
			if otherItem then
				local otherItemScore = set:GetItemScore(otherItem, useRaw)
				itemScore = itemScore + otherItemScore

				-- add info text. this gets called twice, once per scoreType
				local text = base == 'delta' and EQUIPPEDITEM_OH or EQUIPPEDITEM_MH
				local itemName, _, quality = GetItemInfo(otherItem)
				local _, _, _, hexColor = GetItemQualityColor(quality)
				tokenCache[tooltip][set].info = text:format(hexColor, itemName)
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

local function AddComparisonTooltipIntro(tooltip)
	tooltip:AddLine(' ')
	-- don't use a full line's height as spacer
	_G[tooltip:GetName()..'TextLeft'..tooltip:NumLines()]:SetText(nil)

	if GetNumEquipmentSets() == 0 and CanUseEquipmentSets() then
		tooltip:AddLine('Can\'t compare: Blizzard equipment sets are missing!', 1, 0, 0)
		return false
	else
		-- tooltip:AddLine('TopFit item comparison:')
		return true
	end
end

-- call this function if you want to add comparison lines to a tooltip
function TopFit:AddComparisonTooltipLines(tooltip, itemLink)
	if tooltip and not itemLink then
		-- item not supplied, try to get it from tooltip
		_, itemLink = tooltip:GetItem()
	end
	if not tooltip or not itemLink then return end
	if not tokenCache[tooltip] then tokenCache[tooltip] = {} end

	local itemTable = TopFit:GetCachedItem(itemLink)
	if not itemTable or itemTable.itemEquipLoc == 'INVTYPE_BAG' then return end

	local cache = tokenCache[tooltip]
	if cache.itemLink ~= itemLink then
		for set, data in pairs(cache) do
			if type(data) == 'table' then
				wipe(data)
			end
		end
		cache.itemLink = itemLink
	end

	local hasData = false
	for _, setCode in pairs(ns.GetSetList()) do
		local set = ns.GetSetByID(setCode, true)
		if set:GetDisplayInTooltip() then
			if not hasData then
				hasData = AddComparisonTooltipIntro(tooltip)
				if not hasData then return end
			end
			TopFit:AddTooltipItemComparisonForSet(tooltip, set, itemTable)
		end
	end
end
-- temporary so hooking addons still work
ns.TooltipAddCompareLines = ns.AddComparisonTooltipLines

-- GameTooltip_ShowCompareItem
hooksecurefunc('GameTooltip_AdvanceSecondaryCompareItem', function(tooltip)
	-- wipe cache for main tooltip when user changes secondary compare item
	if not GetCVarBool('allowCompareWithToggle') then return end
	if tokenCache[tooltip] then
		local itemLink = tokenCache[tooltip].itemLink
		wipe(tokenCache[tooltip])
		tokenCache[tooltip].itemLink = itemLink
	end
end)

-- allow complex tokens as oUF does: https://github.com/haste/oUF/blob/master/elements/tags.lua#L513
-- TODO: make this a setting
local tooltipPatternLeft, tooltipPatternRight = '[set:icon] [set:name][ (>delta:raw:percent</][delta:current:percent<)][ (>delta2:raw:percent</][delta2:current:percent<)][ (>equipped:eq.<)][|n     >info]', '[item:score]'

-- adds comparison lines for specific item set
function TopFit:AddTooltipItemComparisonForSet(tooltip, set, itemTable)
	if not tokenCache[tooltip] then tokenCache[tooltip] = {} end
	if not tokenCache[tooltip][set] then tokenCache[tooltip][set] = {} end
	local cache = tokenCache[tooltip][set]

	local left, right = tooltipPatternLeft, tooltipPatternRight
	for component in (tooltipPatternLeft .. ' ' .. tooltipPatternRight):gmatch('(%b[])') do
		local tag, prefix, suffix = component:sub(2, -2)
		prefix, tag = strsplit('>', tag, 2)
		if not tag then tag = prefix; prefix = nil end
		tag, suffix = strsplit('<', tag, 2)

		local replacement = cache[tag]
		if replacement == false then
			-- cache stores false for n/a
			replacement = ''
		elseif not replacement then
			local base, options = string.split(':', tag, 2)
			replacement = tokenHandlers[base] and tokenHandlers[base](base, options, itemTable, set, tooltip) or false
			if replacement then
				-- this is used in a pattern
				replacement = escape(replacement)
			end
			-- cache result
			cache[tag] = replacement
			-- TopFit:Debug('Replacing Token', tag, 'with', replacement, tooltip:GetName(), set:GetName())
		end

		if replacement and replacement ~= '' then
			replacement = (prefix or '') .. replacement .. (suffix or '')
		end
		left  = left:gsub(escape(component), replacement or '')
		right = right:gsub(escape(component), replacement or '')
	end
	tooltip:AddDoubleLine(left, right)
end

local function OnTooltipSetItem(self)
	local _, link = self:GetItem()
	local equipSlot = link and select(9, GetItemInfo(link))
	if equipSlot and equipSlot ~= 'INVTYPE_BAG'
		and IsEquippableItem(link) and not ns.Unfit:IsItemUnusable(link) then
		-- TooltipAddLines(self, link)
		if TopFit.db.profile.showComparisonTooltip and not TopFit.isBlocked then
			TopFit:AddComparisonTooltipLines(self, link)
		end
	end
end

-- hook all tooltips that interest us
for _, tooltip in pairs({GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2}) do
	tooltip:HookScript('OnTooltipSetItem', OnTooltipSetItem)
end
