local addonName, ns = ...

ns.title = addonName;
ns.testsLoaded = true;

ns.tests = {
	["Utility Stuff"] = {
		["GenerateSetName"] = function()
			wowUnit:assertEquals(ns:GenerateSetName("Test"), "Test (TF)", "Simple set naming works")
			wowUnit:assertEquals(ns:GenerateSetName("ReallyLongSetName"), "ReallyLongSe(TF)", "Long names get cropped")
		end
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