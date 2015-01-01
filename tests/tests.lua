local addonName, ns = ...

ns.title = addonName;
ns.testsLoaded = true;

ns.tests = {}
local tests

local function AddCategory(name)
	ns.tests[name] = {}
	tests = ns.tests[name]
end



AddCategory("Utility Stuff")
tests["GenerateSetName"] = function()
	wowUnit:assertEquals(ns:GenerateSetName("Test"), "Test (TF)", "Simple set naming works.")
	wowUnit:assertEquals(ns:GenerateSetName("ReallyLongSetName"), "ReallyLongSe(TF)", "Long names get cropped.")
end



AddCategory("Sets")
tests["set data integrity"] = function()
	local set = ns.Set()

	wowUnit:isTable(set:GetHardCaps(), "Set:GetHardCaps always returns a table.")
	wowUnit:isNil(set:GetHardCap('FOO'), "Trying to get a non-existant hard cap returns nil.")

	wowUnit:isTable(set:GetStatWeights(), "Set:GetStatWeights always returns a table.")
	wowUnit:isNil(set:GetStatWeight('FOO'), "Trying to get a non-existant stat weight returns nil.")

	wowUnit:isTable(set:GetForcedItems(), "Set:GetForcedItems always returns a table.")
	wowUnit:assert(not set:IsForcedItem('FOO'), "A non-existant item is not forced.")

	wowUnit:isTable(set:GetVirtualItems(), "Set:GetVirtualItems always returns a table.")
end

local function testDefaultSettings(set)
	wowUnit:assertEquals(set:GetName(), "Unknown", "New sets are named 'Unknown'.")
	wowUnit:assertEquals(set:GetEquipmentSetName(), "Unknown (TF)", "Sets have an appropriate equipment set name.")

	wowUnit:isString(set:GetIconTexture(), "A default icon is provided.")
	wowUnit:assert(set:GetIconTexture():sub(1, 16) == "Interface\\Icons\\", "Default icon has the correct texture path.")

	wowUnit:isEmpty(set:GetHardCaps(), "A new set has no hard caps set.")
	wowUnit:isEmpty(set:GetStatWeights(), "A new set has no stat weights set.")
	wowUnit:isEmpty(set:GetForcedItems(), "No items should be forced in a new set.")
	wowUnit:isEmpty(set:GetVirtualItems(), "No virtual items should be available in a new set.")

	wowUnit:assert(not set:IsDualWieldForced(), "A new set does not enforce dual wielding.")
	wowUnit:assert(not set:IsTitansGripForced(), "A new set does not enforce titan's grip.")
	wowUnit:assert(set:GetDisplayInTooltip(), "A new set is displayed in tooltips by default.")
	wowUnit:assert(not set:GetForceArmorType(), "A new set does not enfoce armor types by default.")
	wowUnit:assert(set:GetUseVirtualItems(), "A new set allows using virtual items by default.")
	wowUnit:isNil(set:GetAssociatedSpec(), "A new set does not have a spec associated.")
	wowUnit:isNil(set:GetPreferredSpecNumber(), "A new set does not have a spec number associated.")
	wowUnit:assert(not set:GetAutoUpdate(), "A new set does not automatically update.")
	wowUnit:assert(not set:GetAutoEquip(), "A new set does not automatically equip.")
end

tests["default values for sets created through constuctor"] = function()
	local set = ns.Set()

	testDefaultSettings(set)
	set = ns.Set("AName")
	wowUnit:assertEquals(set:GetName(), "AName", "Constructor can take a set name.")
end

tests["default values for sets created through empty saved variables"] = function()
	local set = ns.Set.CreateFromSavedVariables(ns.Set.PrepareSavedVariableTable())

	testDefaultSettings(set)
end

local function testChangedValues(set)
	wowUnit:assertEquals(set:GetName(), "Test Set", "Changing the set name sticks.")

	wowUnit:assertEquals(set:GetHardCap("FOO"), 42, "Changing a hard cap works.")
	wowUnit:isNil(set:GetHardCap("BAR"), "Removing a hard cap works.")
	wowUnit:assertSame(set:GetHardCaps(), {FOO = 42, BAZ = 789}, "Changing hard caps works.")

	wowUnit:assertEquals(set:GetStatWeight("FOOO"), 41, "Changing a stat weight works.")
	wowUnit:isNil(set:GetStatWeight("BAR"), "Removing a stat weight works.")
	wowUnit:assertSame(set:GetStatWeights(), {FOOO = 41, BAZ = 788}, "Changing stat weights works.")
end

tests["setting values and saved variables"] = function()
	local vars = ns.Set.PrepareSavedVariableTable()

	wowUnit:isTable(vars, "Prepared saved variables are a table of some sorts.")

	-- create a set from these saved variables
	local set = ns.Set.CreateFromSavedVariables(vars, true)

	-- change all kinds of settings
	set:SetName("Test Set")

	set:SetHardCap("FOO", 42)
	set:SetHardCap("BAR", 123)
	set:SetHardCap("BAR", nil)
	set:SetHardCap("BAZ", 789)

	set:SetStatWeight("FOOO", 41)
	set:SetStatWeight("BAR", 122)
	set:SetStatWeight("BAR", nil)
	set:SetStatWeight("BAZ", 788)

	--TODO: change all other values

	-- check whether the changes were saved correctly
	testChangedValues(set)

	-- create another set from the same variables and check whether the changes stuck
	set = ns.Set.CreateFromSavedVariables(vars)
	testChangedValues(set)
end



AddCategory("Calculation")
local calculationClasses = {"Calculation", "DefaultCalculation", "SmartCalculation"}

local function createMockItem(base)
	for _, tableName in pairs({"itemBonus", "totalBonus"}) do
		if not base[tableName] then base[tableName] = {} end
	end

	-- inject into TopFit's cache
	--TODO: probably better to mock GetCachedItem function instead
	if base.itemLink then
		ns.itemsCache[base.itemLink] = base
	end
	if base.itemID then
		ns.itemsCache[base.itemID] = base
	end
end

tests.setup = function()
	createMockItem({
		itemLink = "[Item FOO]",
		itemID = 42,
		itemBonus = {
			STAT_FOO = 5,
		},
		totalBonus = {
			STAT_FOO = 5,
		}
	})
end
tests.teardown = function()
	ns.itemsCache["[Item FOO]"] = nil
	ns.itemsCache[42] = nil
end

for _, calculationClassName in ipairs(calculationClasses) do
	local calculationClass = ns[calculationClassName]
	tests["trivial case for "..calculationClassName] = function()
		local set = ns.Set("test")
		set:SetStatWeight("STAT_FOO", 3)

		local calc = calculationClass(set)

		calc:AddItem("[Item FOO]", 1)

		local testID = wowUnit:pauseTesting()
		calc:SetCallback(function()
			wowUnit:resumeTesting(testID)

			wowUnit:assertEquals(calc.maxScore, 15, "5 STAT_FOO with a weight of 3 should yield a total score of 15.")
		end)
		calc:Start()

		TESTFOO = calc
	end
end

--TODO: test against wearing the same item twice
--TODO: test to make sure its possible to wear the same item twice if you have it more than once
