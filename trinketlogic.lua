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

local function FindSpecialBonus(effectText, ...)
	if not effectText then return end

	local durSec = string.gsub(ReformatGlobalString(INT_SPELL_DURATION_SEC), "%%%.", "")
	local durMin = string.gsub(ReformatGlobalString(INT_SPELL_DURATION_MIN), "%%%.", "")

	-- on use cooldown
	local cooldown = string.match(effectText, ReformatGlobalString(ITEM_COOLDOWN_TOTAL))
	if cooldown then
		cooldown = tonumber(string.match(cooldown, durSec) or 0)
			+ (tonumber(string.match(cooldown, durMin) or 0) * 60)
	end
	-- remove matched texts to avoid confusion
	effectText = string.gsub(effectText, ReformatGlobalString(ITEM_COOLDOWN_TOTAL), "")

	-- buff duration
	local duration = tonumber(string.match(effectText, durSec) or 0)
	if duration > 0 then
		effectText = string.gsub(effectText, durSec, "", 1)
	end

	-- stat name and amount
	local amount = tonumber(string.match(effectText, "(%d+)[^%%0-9]"))

	if not cooldown then
		effectText = string.gsub(effectText, "(%d+)[^%%0-9]", "", 1)

		cooldown = (string.match(effectText, durSec) or 0)
			+ ((string.match(effectText, durMin) or 0) * 60)
	end

	local numArgs = select('#', ...)
	local searchStat
	for i = 1, numArgs do
		searchStat = select(i, ...)
		searchStatGlobal = _G[searchStat]
		if string.find(effectText, searchStatGlobal) then
			return searchStat, amount, duration, cooldown
		end
	end
end

local scanTooltip = CreateFrame("GameTooltip", "TopFitTrinketScanTooltip", UIParent, "GameTooltipTemplate")

local function FindInTooltip(searchString, scanRightText, filterFunc)
	local numLines = scanTooltip:NumLines()
	local leftLine, leftLineText, rightLine, rightLineText
	for i = 1, numLines do
		leftLine = getglobal("TopFitTrinketScanTooltipTextLeft"..i)
		leftLineText = leftLine and leftLine:GetText() or ""
		rightLine = getglobal("TopFitTrinketScanTooltipTextRight"..i)
		rightLineText = rightLine and rightLine:GetText() or ""
		
		if (string.find(leftLineText, searchString) or (scanRightText and string.find(rightLineText, searchString)))
			and (not filterFunc or filterFunc(leftLineText, rightLineText)) then
			return leftLineText, rightLineText
		end
	end
end

local function ScanTooltipFor(searchString, item, scanRightText, filterFunc)
	-- (String) searchString, (String|Int) item:ItemLink|BagSlotID, [(Boolean|Int) inBag:true|ContainerID], [(Function) filterFunc]
	if not item then return end
	scanTooltip:SetOwner(UIParent, "ANCHOR_NONE")
	scanTooltip:SetHyperlink(item)
	return FindInTooltip(searchString, scanRightText, filterFunc)
end

-- TopFit:ItemHasSpecialBonus("|cff0070dd|Hitem:55795:0:0:0:0:0:0:1945498240:85:0|h[Schlüssel zur unendlichen Kammer]|h|r", "ITEM_MOD_AGILITY_SHORT", "ITEM_MOD_HIT_RATING_SHORT")
function TopFit:ItemHasSpecialBonus(itemLink, ...)
	local itemStats = GetItemStats(itemLink)
	local effectText = ScanTooltipFor(ITEM_SPELL_TRIGGER_ONUSE, itemLink)
		or ScanTooltipFor(ITEM_SPELL_TRIGGER_ONEQUIP, itemLink, nil, 
			function(textLeft, textRight)
				for stat, value in pairs(itemStats) do
					local notShortStat = string.gsub(stat, "_SHORT", "")
					stat = ReformatGlobalString(_G[notShortStat] or _G[stat])
					stat = ITEM_SPELL_TRIGGER_ONEQUIP .. " " .. stat
					if string.match(textLeft, stat) == tostring(value) or string.match(textRight, stat) == tostring(value) then
						return nil
					end
				end
				return true
			end)
	return FindSpecialBonus(effectText, ...)
end
