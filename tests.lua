TopFit.title = "TopFit";

TopFit.tests = {
    ["Utility Stuff"] = {
        ["GenerateSetName"] = function()
            wowUnit:assertEquals(TopFit:GenerateSetName("Test"), "Test (TF)", "Simple set naming works")
            wowUnit:assertEquals(TopFit:GenerateSetName("ReallyLongSetName"), "ReallyLongSe(TF)", "Long names get cropped")
        end
    },
    ["Calculation"] = {
        setup = function()
        end,
        teardown = function()
        end,
        ["trivial case"] = function()
            local set = TopFit.Set("test")
            local calc = TopFit.SmartCalculation(set)

            local testID = wowUnit:pauseTesting()
            calc:SetCallback(function()
                wowUnit:resumeTesting(testID)
            end)
            calc:Start()
        end
    }
}