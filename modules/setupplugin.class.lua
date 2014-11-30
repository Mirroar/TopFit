local addonName, ns, _ = ...

local SetupPlugin = ns.Plugin()
ns.SetupPlugin = SetupPlugin

-- creates a new ImportPlugin object
function SetupPlugin:Initialize()
    self:SetName(ns.locale.NoSetTitle)
    self:SetTooltipText(ns.locale.NoSetDescription)
    self:SetButtonTexture("Interface\\Icons\\Achievement_BG_AB_kill_in_mine")
    self.hasConfigButton = false
    self:RegisterConfigPanel()
end

function SetupPlugin:OnShow()
    local frame = self:GetConfigPanel()

    if not self.itemButton then
        --[[self.itemButton = CreateFrame("Button", "$parentItemButton", frame, "ItemButtonTemplate")
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
        self.itemButton.itemLink = nil--]]
    end

    -- detect character specialization for suggesting default sets
    local specID1 = GetSpecialization(nil, nil, 1)
    local specID2 = GetSpecialization(nil, nil, 2)

    if specID1 then specID1 = GetSpecializationInfo(specID1) end
    if specID2 then specID2 = GetSpecializationInfo(specID2) end
end