local addonName, ns, _ = ...

local ShoppingList = ns.class(ns.Plugin)
ns.ShoppingList = ShoppingList

local colorOrder = {"META", "RED", "YELLOW", "BLUE", "PRISMATIC", "COGWHEEL", "HYDRAULIC"}

-- creates a new ImportPlugin object
function ShoppingList:Initialize()
    self:SetName("Shopping List")
    self:SetTooltipText("Helps you remember your character's needs")
    self:SetButtonTexture("Interface\\Icons\\INV_Glove_Mail_PVPHunter_D_01")
    self:RegisterConfigPanel()

    self.itemButtons = {}
    self.headerTexts = {}
end

function ShoppingList:GetItemButton(i)
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

function ShoppingList:GetHeaderText(i)
    while #(self.headerTexts) < i do
        local panel = self:GetConfigPanel()
        local header = panel:CreateFontString("$parentHeaderText"..i, "ARTWORK", "GameFontNormal")

        tinsert(self.headerTexts, header)
    end

    return self.headerTexts[i]
end

local function ScanCharacterEquipment(self, btn)
    -- local gem1, gem2, gem3 = GetInventoryItemGems(slotID)
    -- local itemLink = GetInventoryItemLink('player', slotID)

    -- Enchanting: Encha Ring1, Ench Ring2
    -- Blacksmithing: Socket Bracers, Socket Gloves
    -- Sha-Touched / iLvl >= ToT: Socket Weapon
    -- Socket Belt
    -- Unenchantable: Head, Ring, Trinket
end
function ShoppingList:OnShow()
    local set = ns.GetSetByID(ns.selectedSet, true)
    local panel = self:GetConfigPanel()

    local scanButton = CreateFrame("Button", "$parentScanButton", panel, "UIPanelButtonTemplate");
    scanButton:SetText("Scan this character")
    scanButton:SetPoint("TOPLEFT", panel:GetParent():GetName().."Description", "TOPLEFT", 0, 0)
    scanButton:SetScript("OnClick", ScanCharacterEquipment)
end

ShoppingList()
