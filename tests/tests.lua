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
local removeItems = {}
local maxItemID = 42
local function createMockItem(base)
	for _, tableName in pairs({"itemBonus", "totalBonus", "procBonus"}) do
		if not base[tableName] then base[tableName] = {} end
	end
	if not base.itemID then
		base.itemID = maxItemID
		maxItemID = maxItemID + 1
	end
	if not base.itemMinLevel then
		base.itemMinLevel = 1
	end
	if not base.itemLevel then
		base.itemLevel = 500
	end
	if not base.itemEquipLoc then
		base.itemEquipLoc = "INVTYPE_FOO"
	end

	-- inject into TopFit's cache
	--TODO: probably better to mock GetCachedItem function instead
	if base.itemLink then
		ns.itemsCache[base.itemLink] = base
		tinsert(removeItems, base.itemLink)
	end
	if base.itemID then
		ns.itemsCache[base.itemID] = base
		tinsert(removeItems, base.itemID)
	end
end

local items = {
	foo = {
		itemLink = "[Item FOO]",
		totalBonus = {
			STAT_FOO = 5,
		}
	},
	bar = {
		itemLink = "[Item BAR]",
		totalBonus = {
			STAT_BAR = 12,
		}
	},
	baz = {
		itemLink = "[Item BAZ]",
		totalBonus = {
			STAT_BAZ = 1,
		}
	},
	unique1 = {
		itemLink = "[Item Unique 1]",
		totalBonus = {
			STAT_FOO = 11,
			['UNIQUE: foo*2'] = 1,
		}
	},
	unique2 = {
		itemLink = "[Item Unique 2]",
		totalBonus = {
			STAT_FOO = 10,
			['UNIQUE: foo*2'] = 1,
		}
	},
	weapon = {
		itemLink = "[Item 1h-Weapon]",
		itemEquipLoc = "INVTYPE_WEAPON",
		equipLocationsByType = {INVSLOT_MAINHAND, INVSLOT_OFFHAND},
		subClass = 'Sword',
		totalBonus = {
			STAT_FOO = 2,
		}
	},
	bigweapon = {
		itemLink = "[Item 2h-Weapon]",
		itemEquipLoc = "INVTYPE_2HWEAPON",
		equipLocationsByType = {INVSLOT_MAINHAND, INVSLOT_OFFHAND},
		subClass = 'Sword',
		totalBonus = {
			STAT_FOO = 3,
		}
	},
	offhand = {
		itemLink = "[Item Off-hand]",
		totalBonus = {
			STAT_FOO = 3,
		}
	},
}

tests.setup = function()
	wipe(removeItems)

	for _, item in pairs(items) do
		createMockItem(item)
	end

	TopFit.characterLevel = UnitLevel("player") --TODO: this should not be necessary for calculating
end
tests.teardown = function()
	for _, identifier in pairs(removeItems) do
		ns.itemsCache[identifier] = nil
	end
end

--TODO: there seems to be a lot of duplication here
tests["trivial case for DefaultCalculation"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 3)
	set:SetStatWeight("STAT_BAR", 1)
	set:SetStatWeight("STAT_BAZ", 10)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.bar.itemLink, 1) -- 12 STAT_BAR for a total score of 12
	calc:AddItem(items.foo.itemLink, 1) -- 5  STAT_FOO for a total score of 15
	calc:AddItem(items.baz.itemLink, 1) -- 1  STAT_BAZ for a total score of 10

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:assert(calc.bestCombination, "There needs to be a best combination.")
		wowUnit:assert(calc.bestCombination.items, "best combination has items.")
		wowUnit:assertEquals(calc.maxScore, 15, "5 STAT_FOO with a weight of 3 should yield a total score of 15.")
		wowUnit:assertSame(calc.bestCombination.totalStats, {STAT_FOO = 5}, "The final set has 5 STAT_FOO and nothing else.")
		wowUnit:assertEquals(calc.bestCombination.items[1].itemID, items.foo.itemID, "Item FOO would be equipped into slot 1.")
	end)
	calc:Start()
end

tests["test against equipping the same item twice"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 3)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.foo.itemLink, 1) -- 5  STAT_FOO for a total score of 15
	calc:AddItem(items.foo.itemLink, 2) -- 5  STAT_FOO for a total score of 15

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		local bis = calc:CalculateBestInSlot(1)
		wowUnit:assertEquals(bis and bis, items.foo, "Best item in slot 1 is FOO")
		bis = calc:CalculateBestInSlot(1, {[2] = items.foo})
		wowUnit:assertEquals(bis and bis, nil, "If already selected, FOO will not be selected again")
		wowUnit:assertEquals(calc.maxScore, 15, "5 STAT_FOO with a weight of 3 should yield a total score of 15.")
		wowUnit:assertSame(calc.bestCombination.totalStats, {STAT_FOO = 5}, "The final set has 5 STAT_FOO and nothing else.")
		local itemID = calc.bestCombination.items[1] and calc.bestCombination.items[1].itemID or calc.bestCombination.items[2].itemID
		wowUnit:assertEquals(itemID, items.foo.itemID, "Item FOO would be equipped into slot 1 or 2.")
	end)
	calc:Start()
end

tests["test for equipping 2 of the same item"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 3)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.foo.itemLink, 1) -- 5  STAT_FOO for a total score of 15
	calc:AddItem(items.foo.itemLink, 2) -- 5  STAT_FOO for a total score of 15

	calc:SetItemCount(items.foo.itemLink, 2)

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		local bis = calc:CalculateBestInSlot(1)
		wowUnit:assertEquals(bis and bis, items.foo, "Best item in slot 1 is FOO")
		bis = calc:CalculateBestInSlot(1, {[2] = items.foo})
		wowUnit:assertEquals(bis and bis, items.foo, "Best item in slot 1 is FOO, even if already selected")
		wowUnit:assertEquals(calc.maxScore, 30, "10 STAT_FOO with a weight of 3 should yield a total score of 30.")
		wowUnit:assertSame(calc.bestCombination.totalStats, {STAT_FOO = 10}, "The final set has 10 STAT_FOO and nothing else.")
		wowUnit:assertEquals(calc.bestCombination.items[1].itemID, items.foo.itemID, "Item FOO would be equipped into slot 1.")
		wowUnit:assertEquals(calc.bestCombination.items[2].itemID, items.foo.itemID, "Item FOO would be equipped into slot 2.")
	end)
	calc:Start()
end

tests["test hard caps that can be reached"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 3)
	set:SetStatWeight("STAT_BAR", 1)
	set:SetStatWeight("STAT_BAZ", 10)
	set:SetHardCap("STAT_BAR", 5)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.foo.itemLink, 1) -- 5  STAT_FOO for a total score of 15
	calc:AddItem(items.bar.itemLink, 1) -- 12 STAT_BAR for a total score of 12, but is neede for cap
	calc:AddItem(items.baz.itemLink, 2) -- 1  STAT_BAZ for a total score of 10

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:assertEquals(calc.maxScore, 22, "12 STAT_BAR and 1 STAT_BAZ should yield a total score of 22.")
		wowUnit:assertSame(calc.bestCombination.totalStats, {STAT_BAR = 12, STAT_BAZ = 1}, "The final set has 12 STAT_BAR and nothing else.")
		wowUnit:assertEquals(calc.bestCombination.items[1].itemID, items.bar.itemID, "Item BAR would be equipped into slot 1.")
		wowUnit:assertEquals(calc.bestCombination.items[2].itemID, items.baz.itemID, "Item BAZ would be equipped into slot 2.")
	end)
	calc:Start()
end

tests["test hard caps that cannot be reached"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 3)
	set:SetStatWeight("STAT_BAR", 1)
	set:SetStatWeight("STAT_BAZ", 200)
	set:SetHardCap("STAT_BAR", 20)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.foo.itemLink, 1) -- 5  STAT_FOO for a total score of 15
	calc:AddItem(items.bar.itemLink, 1) -- 12 STAT_BAR for a total score of 12, but is neede for cap
	calc:AddItem(items.baz.itemLink, 2) -- 1  STAT_BAZ for a total score of 500

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:isNil(calc.maxScore, "Failing to reach caps yields no score.")
		wowUnit:isEmpty(calc.bestCombination, "The final set has no stats.")
	end)
	calc:Start()
end

tests["test uniqueness"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 1)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.unique1.itemLink, 1) -- 11 STAT_FOO
	calc:AddItem(items.unique1.itemLink, 2) -- 11 STAT_FOO
	calc:AddItem(items.unique2.itemLink, 3) -- 10 STAT_FOO
	calc:SetItemCount(items.unique1.itemLink, 2)

	--TODO: We're adding alternatives to each slot because there is currently a bug that causes calculations to crash when there is no alternative to unique items
	calc:AddItem(items.bar.itemLink, 1)
	calc:AddItem(items.bar.itemLink, 2)
	calc:AddItem(items.bar.itemLink, 3)
	calc:SetItemCount(items.bar.itemLink, 3)

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:assertEquals(calc.maxScore, 22, "22 STAT_FOO with a weight of 1 should yield a total score of 22.")
		--wowUnit:assertSame(calc.bestCombination.totalStats, {STAT_FOO = 22, ['UNIQUE: foo*2'] = 2}, "The final set has 22 STAT_FOO and nothing else.")
		wowUnit:assertSame(calc.bestCombination.totalStats, {STAT_FOO = 22, STAT_BAR = 12, ['UNIQUE: foo*2'] = 2}, "TEMP: The final set has 22 STAT_FOO and some other stuff.")
		wowUnit:assertEquals(calc.bestCombination.items[1].itemID, items.unique1.itemID, "Item 1 would be equipped into slot 1.")
		wowUnit:assertEquals(calc.bestCombination.items[2].itemID, items.unique1.itemID, "Item 1 would be equipped into slot 2.")
		--wowUnit:isNil(calc.bestCombination.items[3], "No item would be equipped into slot 3.")
		wowUnit:assertEquals(calc.bestCombination.items[3].itemID, items.bar.itemID, "TEMP: Item BAR would be equipped into slot 3.")
	end)
	calc:Start()
end

tests["test 2 weapons without dual-wielding"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 1)
	set:EnableDualWield(false) -- necessary, because the currently logged in player might be able to dual wield while this test runs
	set:EnableTitansGrip(false)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.weapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.weapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.weapon.itemLink, 2)

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:assertEquals(calc.maxScore, 2, "Only one weapon should be equipped.")
		wowUnit:assertEquals(calc.bestCombination.items[INVSLOT_MAINHAND].itemID, items.weapon.itemID, "The weapon should be equipped in the player's main hand.")
		wowUnit:isNil(calc.bestCombination.items[INVSLOT_OFFHAND], "The player's off hand should be empty.")
	end)
	calc:Start()
end

tests["test 2 weapons without dual-wielding with 2h-alternative"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 1)
	set:EnableDualWield(false) -- necessary, because the currently logged in player might be able to dual wield while this test runs
	set:EnableTitansGrip(false)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.weapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.weapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.weapon.itemLink, 2)
	calc:AddItem(items.bigweapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.bigweapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.bigweapon.itemLink, 2)

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:assertEquals(calc.maxScore, 3, "Only one 2h-weapon should be equipped.")
		wowUnit:assertEquals(calc.bestCombination.items[INVSLOT_MAINHAND].itemID, items.bigweapon.itemID, "The weapon should be equipped in the player's main hand.")
		wowUnit:isNil(calc.bestCombination.items[INVSLOT_OFFHAND], "The player's off hand should be empty.")
	end)
	calc:Start()
end

tests["test 2 weapons without dual-wielding with 2h- and offhand-alternative"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 1)
	set:EnableDualWield(false) -- necessary, because the currently logged in player might be able to dual wield while this test runs
	set:EnableTitansGrip(false)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.weapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.weapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.weapon.itemLink, 2)
	calc:AddItem(items.bigweapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.bigweapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.bigweapon.itemLink, 2)
	calc:AddItem(items.offhand.itemLink, INVSLOT_OFFHAND)

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:assertEquals(calc.maxScore, 5, "1h-weapon and off-hand should be equipped.")
		wowUnit:assertEquals(calc.bestCombination.items[INVSLOT_MAINHAND].itemID, items.weapon.itemID, "The weapon should be equipped in the player's main hand.")
		wowUnit:assertEquals(calc.bestCombination.items[INVSLOT_OFFHAND].itemID, items.offhand.itemID, "The other item should be equipped in the player's off hand.")
	end)
	calc:Start()
end

tests["test 2 weapons with dual-wielding"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 1)
	set:EnableDualWield(true) -- necessary, because the currently logged in player might be able to dual wield while this test runs
	set:EnableTitansGrip(false)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.weapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.weapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.weapon.itemLink, 2)
	calc:AddItem(items.bigweapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.bigweapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.bigweapon.itemLink, 2)

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:assertEquals(calc.maxScore, 4, "Two weapons should be equipped.")
		wowUnit:assertEquals(calc.bestCombination.items[INVSLOT_MAINHAND].itemID, items.weapon.itemID, "The weapon should be equipped in the player's main hand.")
		wowUnit:assertEquals(calc.bestCombination.items[INVSLOT_OFFHAND].itemID, items.weapon.itemID, "The weapon should be equipped in the player's off hand.")
	end)
	calc:Start()
end

tests["test 2 2h-weapons with dual-wielding"] = function()
	local set = ns.Set("test")
	set:SetStatWeight("STAT_FOO", 1)
	set:EnableDualWield(true) -- necessary, because the currently logged in player might be able to dual wield while this test runs
	set:EnableTitansGrip(true)

	local calc = ns.DefaultCalculation(set)

	calc:AddItem(items.weapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.weapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.weapon.itemLink, 2)
	calc:AddItem(items.bigweapon.itemLink, INVSLOT_MAINHAND)
	calc:AddItem(items.bigweapon.itemLink, INVSLOT_OFFHAND)
	calc:SetItemCount(items.bigweapon.itemLink, 2)

	local testID = wowUnit:pauseTesting()
	calc:SetCallback(function()
		wowUnit:resumeTesting(testID)

		wowUnit:assertEquals(calc.maxScore, 6, "Two 2h-weapons should be equipped.")
		wowUnit:assertEquals(calc.bestCombination.items[INVSLOT_MAINHAND].itemID, items.bigweapon.itemID, "The weapon should be equipped in the player's main hand.")
		wowUnit:assertEquals(calc.bestCombination.items[INVSLOT_OFFHAND].itemID, items.bigweapon.itemID, "The weapon should be equipped in the player's off hand.")
	end)
	calc:Start()
end
