local addonName, ns, _ = ...

-- class function - enables pseudo-oop with inheritance using metatables
function ns.class(baseClass)
	local classObject = {}

	-- create copies of the base class' methods
	if type(baseClass) == 'table' then
		for key, value in pairs(baseClass) do
			classObject[key] = value
		end
		classObject._base = baseClass
	end

	-- expose a constructor which can be called by <classname>(<args>)
	local metaTable = {}
	metaTable.__call = function(self, ...)
		local classInstance = {}
		setmetatable(classInstance, classObject)
		if self.construct then
			self.construct(classInstance, ...)
		else
			-- at least call the base class' constructor
			if baseClass and baseClass.construct then
				baseClass.construct(classInstance, ...)
			end
		end

		return classInstance
	end

	classObject.IsInstanceOf = function(self, compareClass)
		local metaTable = getmetatable(self)
		while metaTable do
			if metaTable == compareClass then return true end
			metaTable = metaTable._base
		end
		return false
	end

	classObject.AssertArgumentType = function(argValue, argType)
		if (type(argType) == 'table') and type(argType.IsInstanceOf) == 'function' then
			assert((type(argValue) == 'table') and type(argValue.IsInstanceOf) == 'function' and argValue:IsInstanceOf(argType), 'argument is not an instance of the expected class')
		elseif type(argType) == 'string' then
			assert(type(argValue) == argType, argType..' expected, got '..type(argValue))
		else
			error("AssertArgumentType: argType is expected to be a string or class object")
		end
	end

	-- prepare metatable for lookup of our instance's functions
	classObject.__index = classObject
	setmetatable(classObject, metaTable)
	return classObject
end

function ns:Print(...)
	DEFAULT_CHAT_FRAME:AddMessage(addonName..': '..(string.join(", ", tostringall(...)))) --TODO: add a pretty color!
end

-- debug function
function ns:Debug(...)
	if self.db.profile.debugMode then
		local text = ''
		for i = 1, select('#', ...) do
			if text ~= '' then text = text..', ' end
			local arg = select(i, ...)
			if type(arg) == 'boolean' then
				text = text .. (arg and "<true>" or "<false>")
			elseif type(arg) == 'string' or type(arg) == 'number' then
				text = text .. arg
			else
				text = text .. type(arg)
			end
		end
		ns:Print("Debug: "..text)
	end
end

function ns.MergeAssocInto(target, ...)
	for i = 1, select("#", ...) do
		local tab = select(i, ...)
		if tab then
			for index, value in pairs(tab) do
				target[index] = value
			end
		end
	end

	return target
end

function ns.IsEmpty(table)
	if table and next(table) then return false end
	return true
end

function ns.ShowTooltip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
	if frame.tipText then
		GameTooltip:SetText(frame.tipText, nil, nil, nil, nil, true)
	elseif frame.itemLink then
		GameTooltip:SetHyperlink(frame.itemLink)
	end
	GameTooltip:Show()
end

function ns.HideTooltip()
	GameTooltip:Hide()
end

function ns:PlayerCanDualWield()
	local _, playerClass = UnitClass('player')
	local specID = GetSpecializationInfo(GetSpecialization() or 0)
	local canDualWield =
		   playerClass == 'DEATHKNIGHT'
		or playerClass == 'ROGUE'
		or playerClass == 'DEMONHUNTER'
		or specID == 72  -- fury warrior
		or specID == 263 -- enhancement shaman
		or specID == 268 or specID == 269 -- brewmaster/windwalker monk

	return canDualWield
end

function ns:PlayerHasTitansGrip()
	return IsSpellKnown(46917)
end

function ns:GetPlayerDoubleSpec()
	-- find out if the player currently has the same spec twice, and return that spec
	if GetSpecialization(nil, nil, 1) and GetSpecialization(nil, nil, 1) == GetSpecialization(nil, nil, 2) then
		return GetSpecializationInfo(GetSpecialization(nil, nil, 1) or 0)
	end

	return false
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
