TopFit.title = "TopFit";

TopFit.tests = {
    ["Utility Stuff"] = {
        ["GenerateSetName"] = function()
            wowUnit:assertEquals(TopFit:GenerateSetName("Test"), "Test (TF)", "Simple set naming works")
            wowUnit:assertEquals(TopFit:GenerateSetName("ReallyLongSetName"), "ReallyLongSe(TF)", "Long names get cropped")
        end
    }
}