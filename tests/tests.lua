local addonName, ns = ...

ns.title = addonName;
ns.testsLoaded = true;

ns.tests = {
	["Utility Stuff"] = {
		["GenerateSetName"] = function()
			wowUnit:assertEquals(ns:GenerateSetName("Test"), "Test (TF)", "Simple set naming works.")
			wowUnit:assertEquals(ns:GenerateSetName("ReallyLongSetName"), "ReallyLongSe(TF)", "Long names get cropped.")
		end
	},
	["Sets"] = {
		["default values"] = function()
			local set = ns.Set()

			wowUnit:assertEquals(set:GetName(), "Unknown", "New sets are named 'Unknown'.")
			wowUnit:assertEquals(set:GetEquipmentSetName(), "Unknown (TF)", "Sets have an appropriate equipment set name.")

			wowUnit:isString(set:GetIconTexture(), "A default icon is provided.")
			wowUnit:assert(set:GetIconTexture():sub(1, 16) == "Interface\\Icons\\", "Default icon has the correct texture path.")

			wowUnit:isEmpty(set:GetHardCaps(), "A new set has no hard caps set.")
			wowUnit:isTable(set:GetHardCaps(), "Set:GetHardCaps always returns a table.")
			wowUnit:isNil(set:GetHardCap('FOO'), "Trying to get a non-existant cap returns nil.")

			set = ns.Set("AName")
			wowUnit:assertEquals(set:GetName(), "AName", "Constructor can take a set name.")
		end,
		["setting values and saved variables"] = function()
			local vars = ns.Set.PrepareSavedVariableTable()

			wowUnit:isTable(vars, "Prepared saved variables are a table of some sorts.")
		end,
	},
	["Calculation"] = {
		setup = function()
		end,
		teardown = function()
		end,
		["trivial case"] = function()
			local set = ns.Set("test")
			local calc = ns.SmartCalculation(set)

			local testID = wowUnit:pauseTesting()
			calc:SetCallback(function()
				wowUnit:resumeTesting(testID)
			end)
			calc:Start()
		end
	}
}