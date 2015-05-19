local addonName, ns, _ = ...

local Set = ns.class()
ns.Set = Set

--- Create a new, empty set object.
-- @param setName The name of the set (optional)
function Set:construct(setName)
	-- initialize defaults
	self.weights = {}
	self.caps = {}
	self.forced = {}
	self.virtualItems = {}
	self.itemScoreCache = {}
	self.ignoreCapsForCalculation = false
	self.useVirtualItems = true
	self.displayInTooltip = true
	self.associatedSpec = nil
	self.preferredSpecNum = nil
	self.autoUpdate = false
	self.autoEquip = false

	self.calculationData = {} -- for use by calculation functions

	-- set some defaults
	self:SetName(setName or 'Unknown')

	-- determine if the player can dualwield
	self:ForceDualWield(false)
	self:ForceTitansGrip(false)
	self:EnableDualWield(ns:PlayerCanDualWield()) -- TODO: TopFit should enable / disable dual wielding, this is not the set's responsibility
	self:EnableTitansGrip(ns:PlayerHasTitansGrip())
end

--- Create a set object, loading data from saved variables.
-- Changes to the set will not be written to the given table.
-- @param setTable Table of variables from which to load settings
-- @param writable Whether changes to the set object should be stored in setTable
function Set.CreateFromSavedVariables(savedVariables, writable)
	Set.AssertArgumentType(savedVariables, 'table')

	local setInstance = Set(savedVariables.name)

	-- as part of the 6.0v4 database update, detect the character's spec for auto-updating if necessary
	if savedVariables._oldAutoUpdate then
		if not savedVariables.associatedSpec then
			local specID = GetSpecializationInfo(GetSpecialization(nil, nil, savedVariables._oldAutoUpdate) or 0)
			setInstance:SetAssociatedSpec(specID)
		end

		savedVariables._oldAutoUpdate = nil
	end

	-- load weights and caps
	if savedVariables.weights then
		-- initialize weights
		for stat, value in pairs(savedVariables.weights) do
			setInstance:SetStatWeight(stat, value)
		end
	end

	if savedVariables.caps then
		-- initialize caps
		for stat, cap in pairs(savedVariables.caps) do
			if cap.active then
				setInstance:SetHardCap(stat, cap.value)
			end
		end
	end

	-- load forced items
	if savedVariables.forced then
		-- initialize forced items
		for slotID, forced in pairs(savedVariables.forced) do
			for _, forcedItemID in ipairs(forced) do
				setInstance:ForceItem(slotID, forcedItemID)
			end
		end
	end

	-- load virtual items
	if savedVariables.virtualItems then
		for _, item in pairs(savedVariables.virtualItems) do
			-- TODO: use function
			tinsert(setInstance.virtualItems, item)
		end
	end

	-- load all other individual settings
	if savedVariables.associatedSpec then
		setInstance:SetAssociatedSpec(savedVariables.associatedSpec)
	end
	if savedVariables.preferredSpecNum then
		setInstance:SetPreferredSpecNumber(savedVariables.preferredSpecNum)
	end
	if savedVariables.autoUpdate then
		setInstance:SetAutoUpdate(true)
	end
	if savedVariables.autoEquip then
		setInstance:SetAutoEquip(true)
	end
	if savedVariables.simulateDualWield then
		setInstance:ForceDualWield(true)
	end
	if savedVariables.simulateTitansGrip then
		setInstance:ForceTitansGrip(true)
	end
	if savedVariables.forceArmorType then
		setInstance:SetForceArmorType(true)
	end
	if savedVariables.excludeFromTooltip then
		setInstance:SetDisplayInTooltip(false)
	end
	if savedVariables.skipVirtualItems then
		setInstance:SetUseVirtualItems(false)
	end

	if writable then
		setInstance.savedVariables = savedVariables
	end

	return setInstance
end

--- Creates a table to be used as settings table for a set.
function Set.PrepareSavedVariableTable()
	return {
		name = 'Unknown',
		weights = {},
		caps = {},
		forced = {},
	}
end

--- Set the set's name.
-- @param setName The new set's name
function Set:SetName(setName)
	self.AssertArgumentType(setName, 'string')

	self.name = setName
	if self.savedVariables then
		self.savedVariables.name = setName
	end
end

--- Get the set's name.
function Set:GetName()
	return self.name
end

--- Get the set's icon texture used for its equipment set.
function Set:GetIconTexture()
	local icon = GetEquipmentSetInfoByName(self:GetEquipmentSetName())
	if icon then
		return "Interface\\Icons\\" .. icon
	end

	local spec = self:GetAssociatedSpec()
	if spec then
		icon = select(4, GetSpecializationInfoByID(spec))
		icon = icon:gsub('[iI][nN][tT][eE][rR][fF][aA][cC][eE]\\[iI][cC][oO][nN][sS]\\', 'Interface\\Icons\\')
	end
	return icon or "Interface\\Icons\\Spell_Holy_EmpowerChampion"
end

--- Gets the name of the equipment manager set associated with this set.
function Set:GetEquipmentSetName()
	--TODO: save equipment set name in saved variables so it can better be decoupled from TopFit
	return ns:GenerateSetName(self:GetName()) -- TODO: move code here and get rid of global function in favor of class function Set.GenerateEquipmenSetName
end

--- Set a hard cap for any stat.
-- @param stat The identifier of the stat (usually a global string name)
-- @param value The new cap value for the given stat - use nil to remove a current cap
function Set:SetHardCap(stat, value)
	self.AssertArgumentType(stat, 'string')
	if type(value) ~= 'nil' then
		self.AssertArgumentType(value, 'number')
		if self.savedVariables then
			self.savedVariables.caps[stat] = {
				active = 1,
				value = value
			}
		end
	else
		if self.savedVariables then
			self.savedVariables.caps[stat] = nil
		end
	end

	wipe(self.itemScoreCache)
	self.caps[stat] = value
end

--- Get the defined hard cap for any stat.
-- @param stat The identifier of the stat (usually a global string name)
function Set:GetHardCap(stat)
	self.AssertArgumentType(stat, 'string')

	return self.caps[stat]
end

--- Get a list of all configured hard caps and their values, keyed by stat.
-- @param useTable A table to write the requested data into (optional)
function Set:GetHardCaps(useTable)
	if useTable then wipe(useTable) end
	local caps = useTable or {}
	for stat, value in pairs(self.caps) do
		caps[stat] = value
	end
	return caps
end

--- Set a stat weight for any stat.
-- @param stat The identifier of the stat (usually a global string name)
-- @param value The new weight value for the given stat - use nil to remove a current stat
function Set:SetStatWeight(stat, value)
	self.AssertArgumentType(stat, 'string')
	if type(value) ~= 'nil' then
		self.AssertArgumentType(value, 'number')
	end

	wipe(self.itemScoreCache)
	self.weights[stat] = value
	if self.savedVariables then
		self.savedVariables.weights[stat] = value
	end
end

--- Get the defined stat weight for any stat.
-- @param stat The identifier of the stat (usually a global string name)
function Set:GetStatWeight(stat)
	self.AssertArgumentType(stat, 'string')

	return self.weights[stat] or 0
end

--- Get a list of all configured stat weights and their values, keyed by stat.
-- @param useTable A table to write the requested data into (optional)
function Set:GetStatWeights(useTable)
	local weights = useTable and wipe(useTable) or {}
	for stat, value in pairs(self.weights) do
		weights[stat] = value
	end
	return weights
end

local secondaryStats = {
	'ITEM_MOD_CRIT_RATING_SHORT',
	'ITEM_MOD_HASTE_RATING_SHORT',
	'ITEM_MOD_MASTERY_RATING_SHORT',
	'ITEM_MOD_VERSATILITY',
}
function Set:GetBestSecondaryStat()
	local statName, weight
	for _, stat in pairs(secondaryStats) do
		local value = self:GetStatWeight(stat)
		if not weight or value > weight then
			statName = stat
			weight = value
		end
	end
	return statName, weight
end

-- remove all hard caps from this set
function Set:ClearAllHardCaps()
	--TODO: this should be handled with care and should modify saved variables, too
	wipe(self.itemScoreCache)
	wipe(self.caps)
end

-- add an item to this set's forced items
function Set:ForceItem(slotID, itemID)
	if not slotID or not itemID then return end

	if not self.forced[slotID] then
		self.forced[slotID] = {}
	end
	tinsert(self.forced[slotID], itemID)

	if self.savedVariables then
		if not self.savedVariables.forced then
			self.savedVariables.forced = {} --TODO: check if this is really necessary still, should be enforced in an update hook
		end
		if not self.savedVariables.forced[slotID] then
			self.savedVariables.forced[slotID] = {}
		end
		tinsert(self.savedVariables.forced[slotID], itemID)
	end
end

-- remove an item from this set's forced items
function Set:UnforceItem(slotID, itemID)
	if not slotID or not itemID then return end

	if not self.forced[slotID] then return end
	for i = #(self.forced[slotID]), 1, -1 do
		local forcedItemID = self.forced[slotID][i]
		if forcedItemID == itemID then
			tremove(self.forced[slotID], i)
		end
	end

	if self.savedVariables and self.savedVariables.forced and self.savedVariables.forced[slotID] then
		for i = #(self.savedVariables.forced[slotID]), 1, -1 do
			local forcedItemID = self.savedVariables.forced[slotID][i]
			if forcedItemID == itemID then
				tremove(self.savedVariables.forced[slotID], i)
			end
		end
	end
end

-- determine whether the given item is part of this set's forced items
function Set:IsForcedItem(item, slotID)
	if not item then return false end

	local itemTable = ns:GetCachedItem(item)
	if not itemTable or not itemTable.itemID then return false end

	local itemID = itemTable.itemID

	if not slotID then
		for slotID, _ in pairs(ns.slotNames) do
			if self:IsForcedItem(itemID, slotID) then return true end
		end

		return false
	end
	if not self.forced[slotID] then
		return false
	else
		for _, forcedItemID in ipairs(self.forced[slotID]) do
			if forcedItemID == itemID then
				return true
			end
		end
	end
end

-- get a list of all of this set's forced items for the given slot
function Set:GetForcedItems(slotID, useTable)
	local items = useTable or {}
	if slotID then
		if self.forced[slotID] then
			for _, forcedItemID in ipairs(self.forced[slotID]) do
				tinsert(items, forcedItemID)
			end
		end
	else
		-- collect results for all slots
		for slotID, _ in pairs(ns.slotNames) do
			local subForced = self:GetForcedItems(slotID)
			if #subForced > 0 then
				items[slotID] = subForced
			end
		end
	end
	return items
end

-- add a virtual item to be included in this set's calculations
function Set:AddVirtualItem(item)
	if not item then return end

	tinsert(self.virtualItems, item)

	if self.savedVariables then
		if not self.savedVariables.virtualItems then
			self.savedVariables.virtualItems = {} -- TODO: this should be enforced in an update hook
		end
		tinsert(self.savedVariables.virtualItems, item)
	end
end

-- remove a virtual item from this set's calculations
function Set:RemoveVirtualItem(item)
	if not item then return end

	for i = #(self.virtualItems), 1, -1 do
		local virtualItem = self.virtualItems[i]
		if virtualItem == item then
			tremove(self.virtualItems, i)
		end
	end

	if self.savedVariables and self.savedVariables.virtualItems then
		for i = #(self.savedVariables.virtualItems), 1, -1 do
			local virtualItem = self.savedVariables.virtualItems[i]
			if virtualItem == item then
				tremove(self.savedVariables.virtualItems, i)
			end
		end
	end
end

-- get a list of all of this set's virtual items
function Set:GetVirtualItems(useTable)
	local items = useTable or {}

	for _, item in ipairs(self.virtualItems) do
		tinsert(items, item)
	end

	return items
end

-- allow dual wielding for this set
function Set:EnableDualWield(value)
	self.canDualWield = value and true or false
end

-- get the current setting for dual wielding for this set
--TODO: needs tests once it is deterministic
function Set:CanDualWield()
	return self.canDualWield or self.forceDualWield
end

function Set:ForceDualWield(force)
	self.forceDualWield = force and true or false
	if self.savedVariables then
		self.savedVariables.simulateDualWield = force and true or false
	end
end

--- Check whether dual wielding is forced for this set.
function Set:IsDualWieldForced()
	return self.forceDualWield
end

-- allow titan's grip for this set
function Set:EnableTitansGrip(value)
	self.canTitansGrip = value and true or false
end

-- get the current setting for titan's grip for this set
function Set:CanTitansGrip()
	return self.canTitansGrip or self.forceTitansGrip
end

function Set:ForceTitansGrip(force)
	self.forceTitansGrip = force and true or false
	if self.savedVariables then
		self.savedVariables.simulateTitansGrip = force and true or false
	end
end
function Set:IsTitansGripForced()
	return self.forceTitansGrip
end

-- check whether a weapon can be equipped in one hand (takes titan's grip into account)
local POLEARMS, _, _, STAVES, _, _, _, _, _, WANDS, FISHINGPOLES = select(7, GetAuctionItemSubClasses(1))
-- returns true:item is weapon wielded in one hand, false:item is weapon wielded in two hands, nil:no item/does not go in weapon slots
function Set:IsOnehandedWeapon(item)
	local itemTable = type(item) == 'table' and item or TopFit:GetCachedItem(item)
	if not itemTable then return nil end

	-- item might not have been a weapon at all
	if not itemTable.itemEquipLoc or itemTable.itemEquipLoc == ''
		or (not tContains(itemTable.equipLocationsByType, INVSLOT_MAINHAND)
		and not tContains(itemTable.equipLocationsByType, INVSLOT_OFFHAND)) then
		return nil
	end

	if itemTable.itemEquipLoc:find('2HWEAPON') then
		return self:CanTitansGrip() and not (itemTable.subclass == POLEARMS or itemTable.subclass == STAVES or itemTable.subclass == FISHINGPOLES)
	elseif itemTable.itemEquipLoc:find('RANGED') then
		return itemTable.subClass == WANDS
	end
	return true
end

function Set:CanItemGoInSlot(item, slotID)
	local itemTable = type(item) == 'table' and item or TopFit:GetCachedItem(item)
	if not itemTable then return nil end

	local canGoInSlot = tContains(itemTable.equipLocationsByType, slotID)
		and not ns.Unfit:IsClassUnusable(itemTable.subClass, itemTable.itemEquipLoc)
	if canGoInSlot and slotID == INVSLOT_OFFHAND and self:IsOnehandedWeapon(itemTable) then
		-- check offhand item type
		canGoInSlot = self:CanDualWield() -- weapons only work with dual wield
			or itemTable.itemEquipLoc == 'INVTYPE_HOLDABLE'
			or itemTable.itemEquipLoc == 'INVTYPE_SHIELD'
	end
	-- TODO: check for forced types, e.g. OH:shield or MH:dagger
	return canGoInSlot
end

function Set:GetItemInSlot(slotID)
	local locationBySlot = GetEquipmentSetLocations(self:GetEquipmentSetName())
	local location = locationBySlot and locationBySlot[slotID]
	if location and location <= 0 then location = nil end
	if location and slotID == INVSLOT_OFFHAND then
		-- can't use OH when MH item is wielded 2H
		if self:IsOnehandedWeapon(locationBySlot[INVSLOT_MAINHAND]) == false then
			location = nil
		end
	end
	return location and select(3, ns.ItemLocations:GetLocationItemInfo(location)) or nil
end

function Set:SetDisplayInTooltip(enable)
	self.displayInTooltip = enable and true or false
	if self.savedVariables then
		self.savedVariables.excludeFromTooltip = (not enable) and true or false
	end
end
function Set:GetDisplayInTooltip()
	return self.displayInTooltip
end

function Set:SetForceArmorType(enable)
	self.forceArmorType = enable and true or false
	if self.savedVariables then
		self.savedVariables.forceArmorType = enable and true or false
	end
end
function Set:GetForceArmorType()
	return self.forceArmorType
end

function Set:SetUseVirtualItems(enable)
	self.useVirtualItems = enable and true or false
	if self.savedVariables then
		self.savedVariables.skipVirtualItems = (not enable) and true or false
	end
end
function Set:GetUseVirtualItems()
	return self.useVirtualItems
end

function Set:SetAssociatedSpec(spec)
	self.associatedSpec = spec
	if self.savedVariables then
		self.savedVariables.associatedSpec = spec
	end
end
function Set:GetAssociatedSpec()
	return self.associatedSpec
end

function Set:SetPreferredSpecNumber(specNum)
	self.preferredSpecNum = specNum
	if self.savedVariables then
		self.savedVariables.preferredSpecNum = specNum
	end
end
function Set:GetPreferredSpecNumber()
	return self.preferredSpecNum
end

function Set:SetAutoUpdate(enable)
	self.autoUpdate = enable and true or false
	if self.savedVariables then
		self.savedVariables.autoUpdate = enable and true or false
	end
end
function Set:GetAutoUpdate()
	return self.autoUpdate
end

function Set:SetAutoEquip(enable)
	self.autoEquip = enable and true or false
	if self.savedVariables then
		self.savedVariables.autoEquip = enable and true or false
	end
end
function Set:GetAutoEquip()
	return self.autoEquip
end

-- TODO: allow using an item table to make this testable
function Set:GetItemScore(item, useRaw)
	assert(item and (type(item) == "string" or type(item) == "number"), "Usage: setObject:GetItemScore(itemLink or itemID[, useRaw])")

	if not self.itemScoreCache[item] then
		local itemTable = TopFit:GetCachedItem(item)
		if not itemTable then return end

		-- calculate item score
		local itemScore = 0
		local capsModifier = 0
		-- iterate given weights
		for stat, statValue in pairs(self.weights) do
			if itemTable.totalBonus[stat] then
				-- check for hard cap on this stat
				-- if not self.caps[stat] then -- [TODO] capped stats are still valuable! don't ignore their weights
					itemScore = itemScore + statValue * itemTable.totalBonus[stat]
				-- end
			end
		end

		-- also calculate raw item score
		local rawScore = 0
		local rawModifier = 0
		-- iterate given weights
		for stat, statValue in pairs(self.weights) do
			if itemTable.itemBonus[stat] then
				-- check for hard cap on this stat
				if not self.caps[stat] then
					rawScore = rawScore + statValue * itemTable.itemBonus[stat]
				end
			end
			if itemTable.procBonus[stat] then
				-- check for hard cap on this stat
				if not self.caps[stat] then
					rawScore = itemScore + statValue * itemTable.procBonus[stat]
				end
			end
		end

		-- dirty quick fix for socket raw values
		if itemTable.itemLevel >= 500 and itemTable.itemBonus['EMPTY_SOCKET_PRISMATIC'] then
			-- TODO: consider gem min item level requirements
			local _, weight = self:GetBestSecondaryStat()
			if weight then
				-- TODO: add set setting for gem tier/quality
				local gemSize = (itemTable.itemQuality >= _G.LE_ITEM_QUALITY_EPIC or itemTable.itemLevel >= GetAverageItemLevel()) and 50 or 35
				rawScore = rawScore + itemTable.itemBonus['EMPTY_SOCKET_PRISMATIC'] * gemSize * weight
			end
		end

		self.itemScoreCache[item] = {
			itemScore = itemScore,
			rawScore = rawScore,
		}
	end

	if useRaw then
		return self.itemScoreCache[item].rawScore
	else
		return self.itemScoreCache[item].itemScore
	end
end
