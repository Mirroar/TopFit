local addonName, ns, _ = ...

local OptimizerPlugin = ns.class(ns.Plugin)
ns.OptimizerPlugin = OptimizerPlugin

-- creates a new ImportPlugin object
function OptimizerPlugin:Initialize()
    self:SetName("Gear Optimizer")
    self:SetTooltipText("Helps you select the best gems, enchants and reforge options.")
    self:SetButtonTexture("Interface\\Icons\\INV_Glove_Mail_PVPHunter_D_01")
    self:RegisterConfigPanel()
end

function OptimizerPlugin:GetItemButton(i)
    if not self.itemButtons then self.itemButtons = {} end

    while #(self.itemButtons) < i do
        local panel = self:GetConfigPanel()
        local itemButton = CreateFrame("Button", "$parentItemButton"..i, panel, "ItemButtonTemplate")
        --itemButton:SetSize(20, 20)
        itemButton:SetScript("OnEnter", ns.ShowTooltip)
        itemButton:SetScript("OnLeave", ns.HideTooltip)

        tinsert(self.itemButtons, itemButton)
    end

    return self.itemButtons[i]
end

function OptimizerPlugin:HideItemButtonsAfter(index)
    for i = index, #(self.itemButtons) do
        self.itemButtons[i]:Hide()
    end
end

function OptimizerPlugin:OnShow()
    local set = ns.GetSetByID(ns.selectedSet, true)

    -- collect the "best" gems for this set
    local bestGems = {}
    for gemID, gemTable in pairs(ns.gemIDs) do
        for _, color in pairs(gemTable.colors) do
            if not bestGems[color] then bestGems[color] = {} end

            tinsert(bestGems[color], ns:GetCachedItem(gemID))
        end
    end

    ns.ReduceGemList(set, bestGems)

    ns.debugGems = bestGems

    -- report num gems
    for color, gemTable in pairs(bestGems) do
        local sum=0
        for _, _ in pairs(bestGems[color]) do sum = sum + 1 end
        TopFit:Print(color..' gems: '..sum)
    end

    -- show suggested gems
    local panel = self:GetConfigPanel()
    local i = 1
    for color, subTable in pairs(bestGems) do
        for _, gemTable in pairs(subTable) do
            local itemButton = self:GetItemButton(i)
            local texture = select(10, GetItemInfo(gemTable.itemID))
            if not texture then texture = "Interface\\Icons\\Inv_Misc_Questionmark" end
            SetItemButtonTexture(itemButton, texture)

            itemButton.itemLink = gemTable.itemLink

            if i == 1 then
                itemButton:SetPoint("TOPLEFT", panel, "TOPLEFT")
            elseif i == 2 then
                itemButton:SetPoint("TOPLEFT", self:GetItemButton(i - 1), "TOPLEFT", panel:GetWidth() / 2, 0)
            else
                itemButton:SetPoint("TOPLEFT", self:GetItemButton(i - 2), "TOPLEFT", 0, -(itemButton:GetHeight() + 5))
            end
            itemButton:Show()

            i = i + 1
        end
    end
    self:HideItemButtonsAfter(i)
end

OptimizerPlugin()