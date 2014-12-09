local addonName, ns, _ = ...

function ns:PlayerCanDualWield()
	local _, playerClass = UnitClass('player')
	local specID = GetSpecializationInfo(GetSpecialization() or 0)
	local canDualWield =
		   playerClass == 'DEATHKNIGHT'
		or playerClass == 'ROGUE'
		or specID == 72  -- fury warrior
		or specID == 263 -- enhancement shaman
		or specID == 268 or specID == 269 -- brewmaster/windwalker monk

	return canDualWield
end

function ns:PlayerHasTitansGrip()
	return IsSpellKnown(46917)
end

function ns:GetLinkID(link)
	if not link or type(link) ~= "string" then return end
	local linkType, id = link:match("\124H([^:]+):([^:\124]+)")
	if not linkType then
		linkType, id = link:match("([^:\124]+):([^:\124]+)")
	end
	return tonumber(id), linkType
end

-- helper function that wraps GetItemUniqueness and adds data where Blizzard failed
local specialUniqueness = {
	[118300] = "solium,1", -- Spellbound Solium Band of Sorcerous Strength
	[118301] = "solium,1", -- Spellbound Solium Band of the Kirin-Tor
	[118302] = "solium,1", -- Spellbound Solium Band of Fatal Strikes
	[118303] = "solium,1", -- Spellbound Solium Band of Sorcerous Invincibility
	[118304] = "solium,1", -- Spellbound Solium Band of the Immortal Spirit
	[118295] = "solium,1", -- Timeless Solium Band of Brutality
	[118296] = "solium,1", -- Timeless Solium Band of the Archmage
	[118297] = "solium,1", -- Timeless Solium Band of the Assassin
	[118298] = "solium,1", -- Timeless Solium Band of the Bulwark
	[118299] = "solium,1", -- Timeless Solium Band of Lifegiving
	[118290] = "solium,1", -- Solium Band of Might
	[118291] = "solium,1", -- Solium Band of Wisdom
	[118292] = "solium,1", -- Solium Band of Dexterity
	[118293] = "solium,1", -- Solium Band of Endurance
	[118294] = "solium,1", -- Solium Band of Mending
}
function ns:GetItemUniqueness(item)
	local itemID
	if type(item) == 'number' then
		itemID = item
	elseif type(item) == 'string' then
		itemID = ns:GetLinkID(select(2, GetItemInfo(item)))
	end

	if itemID and specialUniqueness[itemID] then
		local family, count = string.split(',', specialUniqueness[itemID])
		return family, tonumber(count)
	end

	return GetItemUniqueness(item)
end
