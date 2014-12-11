local addonName, addon, _ = ...

-- GLOBALS: _G, ITEM_COOLDOWN_TOTAL, DECIMAL_SEPERATOR, LARGE_NUMBER_SEPERATOR, ITEM_SPELL_TRIGGER_ONUSE, ITEM_SPELL_TRIGGER_ONEQUIP, UIParent
-- GLOBALS: GetItemInfo, GetItemStats
-- GLOBALS: string, tonumber, tostring, select, pairs

--[[
scan "On Use" & "Equip" bonuses and try to parse amount, stat, duration and cooldown of trinket procs
examples:
  "Benutzen: Gewährt Euch 15 Sek. lang 1.060 Vielseitigkeit. (1 Min. 30 Sek. Abklingzeit)"
  "Anlegen: Eure Angriffe haben eine Chance, 10 Sek. lang 1.383 Mehrfachschlag zu gewähren. (Ungefähr 0,92 Auslösungen pro Minute)"
--]]

local function ReformatGlobalString(globalString)
	if not globalString then return "" end

	local returnString = globalString
	returnString = string.gsub(returnString, "%(", "%%(")
	returnString = string.gsub(returnString, "%)", "%%)")
	returnString = string.gsub(returnString, "%.", "%%.")
	returnString = string.gsub(returnString, "%%[1-9]?$?s", "(.+)")
	returnString = string.gsub(returnString, "%%[1-9]?$?c", "([+-]?)")
	returnString = string.gsub(returnString, "%%[1-9]?$?d", "(%%d+)")
	return returnString
end

local procsPerMinute = '(%(.*'..MINUTES:match('\1244([^:;]+)')..'.*%))$'
local onUseCooldown  = ReformatGlobalString(ITEM_COOLDOWN_TOTAL)
local durSec = ReformatGlobalString(INT_SPELL_DURATION_SEC):gsub('%%%.', '')
local durMin = ReformatGlobalString(INT_SPELL_DURATION_MIN):gsub('%%%.', '')
local statAmount = '(%d[%d%.]+)[^%%]'

local function FindSpecialBonus(effectText, ...)
	if not effectText then return end
	-- deDE uses "." here which messes up patterns
	effectText = effectText:gsub('%'..LARGE_NUMBER_SEPERATOR, '')
	-- convert separator to "." which we know how to handle
	effectText = effectText:gsub('%'..DECIMAL_SEPERATOR, '%.')

	local cooldown = effectText:match(onUseCooldown)
	if cooldown then
		-- on use cooldown
		cooldown   = (cooldown:match(durMin) or 0)*60 + (cooldown:match(durSec) or 0)*1
		effectText = effectText:gsub(onUseCooldown, '')
		-- print('cooldown: on use', cooldown)
	else
		cooldown = effectText:match(procsPerMinute)
		if cooldown then
			-- procs per minute
			cooldown = 60 / (cooldown:match('([0-9.]+)') * 1)
			effectText = effectText:gsub(procsPerMinute, '')
			-- print('cooldown: ppm', cooldown)
		else
			-- cooldown within main description
			cooldown = (effectText:match(durMin) or 0) * 60 + (effectText:match(durSec) or 0) * 1
			-- print('cooldown: misc', cooldown)
		end
	end

	-- buff duration
	local duration = tonumber(string.match(effectText, durSec) or 0)
	if duration > 0 then
		effectText = effectText:gsub(durSec, '', 1)
	end

	-- stat amount
	local amount = tonumber(effectText:match(statAmount) or 0)
	effectText = effectText:gsub(statAmount, '', 1)

	-- stat name
	for i = 1, select('#', ...) do
		local stat = select(i, ...)
		if string.find(effectText, _G[stat] or addonName) then
			return stat, amount, duration, cooldown
		end
	end
end

local function ScanTooltipFor(searchString, itemLink, filterFunc)
	if not itemLink then return end
	local itemStats = filterFunc and GetItemStats(itemLink) or nil
	addon.scanTooltip:SetOwner(UIParent, 'ANCHOR_NONE')
	addon.scanTooltip:SetHyperlink(itemLink)

	local tooltip = addon.scanTooltip
	for i = 1, tooltip:NumLines() do
		local left = _G[tooltip:GetName()..'TextLeft'..i]
		local leftText  = left and left:GetText() or ''
		if leftText:find(searchString) and (not filterFunc or filterFunc(itemStats, leftText)) then
			return leftText
		end
	end
end

local function FilterOnEquipLine(itemStats, textLeft)
	for stat, value in pairs(itemStats) do
		local notShortStat = stat:gsub('_SHORT', '')
		stat = ReformatGlobalString(_G[notShortStat] or _G[stat])
		stat = ITEM_SPELL_TRIGGER_ONEQUIP .. ' ' .. stat
		if textLeft:match(stat) == tostring(value) then
			return nil
		end
	end
	return true
end

-- TopFit:ItemHasSpecialBonus("|cff0070dd|Hitem:55795:0:0:0:0:0:0:1945498240:85:0|h[Schlüssel zur unendlichen Kammer]|h|r", "ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_HIT_RATING_SHORT")
function addon:ItemHasSpecialBonus(itemLink, ...)
	-- we only need to scan equipment items!
	local equipSlot = select(9, GetItemInfo(itemLink))
	if not equipSlot or equipSlot == '' or equipSlot == 'INVTYPE_BAG' then return end

	local effectText = ScanTooltipFor(ITEM_SPELL_TRIGGER_ONUSE, itemLink)
		or ScanTooltipFor(ITEM_SPELL_TRIGGER_ONEQUIP, itemLink, FilterOnEquipLine)
	if not effectText then return end

	local stat, amount, duration, cooldown = FindSpecialBonus(effectText, ...)
	-- print(itemLink, effectText, 'parsed for stats', stat, amount, duration, cooldown, '\n', '--------------')
	return stat, amount, duration, cooldown
end
