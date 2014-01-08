local addonName, ns, _ = ...

local ItemStatsPlugin = ns.Plugin()
ns.ItemStatsPlugin = ItemStatsPlugin

-- creates a new ImportPlugin object
function ItemStatsPlugin:Initialize()
    self:SetName("Item Stats")
    self:SetTooltipText("Allows you to check which stats TopFit detects on an item, as well as change those stats when necessary.")
    self:SetButtonTexture("Interface\\Icons\\INV_Glove_Mail_PVPHunter_D_01")
    self:RegisterConfigPanel()
end

--[[
function ItemStatsPlugin:GetItemButton(i)
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

function ItemStatsPlugin:GetHeaderText(i)
    while #(self.headerTexts) < i do
        local panel = self:GetConfigPanel()
        local header = panel:CreateFontString("$parentHeaderText"..i, "ARTWORK", "GameFontNormal")

        tinsert(self.headerTexts, header)
    end

    return self.headerTexts[i]
end

function ItemStatsPlugin:HideItemButtonsAfter(index)
    for i = index, #(self.itemButtons) do
        self.itemButtons[i]:Hide()
    end
end
]]--

function ItemStatsPlugin:SetActiveItem(itemLink)
    self.itemButton.itemLink = nil
    SetItemButtonTexture(self.itemButton, "Interface\\PaperDoll\\UI-PaperDoll-Slot-Bag")
    self.currentItem = nil

    if not itemLink then
        return
    end

    local item = ns:GetCachedItem(itemLink)
    if not item.itemEquipLoc or item.itemEquipLoc == '' then
        return
    end

    _, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemLink)
    self.itemButton.itemLink = itemLink
    SetItemButtonTexture(self.itemButton, texture)

    self.currentItem = item

    -- display item's stats
    local statCategories = {'itemBonus', 'procBonus', 'reforgeBonus', 'gemBonus', 'enchantBonus', 'totalBonus'}
    for _, category in ipairs(statCategories) do

    end
end

function ItemStatsPlugin:OnShow()
    local frame = self:GetConfigPanel()

    if not self.itemButton then
        self.itemButton = CreateFrame("Button", "$parentItemButton", frame, "ItemButtonTemplate")
        self.itemButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 80)

        self.itemButton:SetScript("OnEnter", ns.ShowTooltip)
        self.itemButton:SetScript("OnLeave", ns.HideTooltip)
        self.itemButton:SetScript("OnClick", function()
            local type, _, link = GetCursorInfo()
            ClearCursor()
            if type == "item" then
                self:SetActiveItem(link)
                ns.ShowTooltip(self.itemButton)
            else
                self:SetActiveItem()
                ns.HideTooltip(self.itemButton)
            end
        end)
        self.itemButton:SetScale(2)

        SetItemButtonTexture(self.itemButton, "Interface\\PaperDoll\\UI-PaperDoll-Slot-Bag")
        self.itemButton.itemLink = nil
    end


    print("Item Stats!")
end