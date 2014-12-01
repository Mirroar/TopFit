local addonName, ns, _ = ...

local SetupPlugin = ns.Plugin()
ns.SetupPlugin = SetupPlugin

-- creates a new ImportPlugin object
function SetupPlugin:Initialize()
    self:SetName(ns.locale.NoSetTitle)
    self:SetTooltipText(ns.locale.NoSetDescription)
    self:SetButtonTexture("Interface\\Icons\\Achievement_BG_AB_kill_in_mine")
    self.hasConfigButton = false
    self.isUIInitialized = false
    self:RegisterConfigPanel()
end

function SetupPlugin:InitializePresetDropdown(dropDown)
    _G[dropDown:GetName().."Button"]:SetPoint("LEFT", dropDown, "LEFT", 20, 0) -- makes the whole dropdown react to mouseover
    UIDropDownMenu_SetWidth(dropDown, 150)
    UIDropDownMenu_JustifyText(dropDown, "LEFT")

    local presets = ns:GetPresets()

    local SelectSet = function(self, ...)
        UIDropDownMenu_SetSelectedValue(dropDown, self.value)
    end
    dropDown.initialize = function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()
        info.func = SelectSet

        if level == 1 then
            info.text         = ns.locale.SetupWizardCreateNoSet
            info.value        = 'none'
            info.isTitle      = false
            info.checked = false
            UIDropDownMenu_AddButton(info, level)

            -- list all applicable presets
            for presetID, preset in pairs(presets) do
                info.text     = preset.name or "Unknown"
                info.value    = presetID
                info.menuList = presetID
                info.checked = false
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end
end

function SetupPlugin:OnShow()
    local frame = self:GetConfigPanel()

    if not self.isUIInitialized then
        self.isUIInitialized = true

        local introText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        introText:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 0)
        introText:SetPoint('RIGHT', frame, 'RIGHT', 0, 0)
        introText:SetWordWrap(true)
        introText:SetWidth(frame:GetWidth()) -- need to have any width for wrapping to work correctly
        introText:SetJustifyH('LEFT')
        introText:SetText(ns.locale.SetupWizardIntro)

        local specText1 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        specText1:SetPoint('TOPLEFT', introText, 'BOTTOMLEFT', 0, -10)
        specText1:SetPoint('RIGHT', introText, 'RIGHT', 0, -10)
        specText1:SetWordWrap(true)
        specText1:SetWidth(frame:GetWidth()) -- need to have any width for wrapping to work correctly
        specText1:SetJustifyH('LEFT')
        frame.specText1 = specText1

        local dropDown = CreateFrame("Frame", "SpecDropDown1", frame, "UIDropDownMenuTemplate")
        dropDown:SetPoint("TOPLEFT", specText1, "BOTTOMLEFT", -15, -5)
        dropDown:SetFrameStrata(frame:GetFrameStrata())
        self:InitializePresetDropdown(dropDown)
        frame.SpecDropDown1 = dropDown

        local specText2 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        specText2:SetPoint('TOPLEFT', specText1, 'BOTTOMLEFT', 0, -50)
        specText2:SetPoint('RIGHT', specText1, 'RIGHT', 0, 0)
        specText2:SetWordWrap(true)
        specText2:SetWidth(frame:GetWidth()) -- need to have any width for wrapping to work correctly
        specText2:SetJustifyH('LEFT')
        frame.specText2 = specText2

        dropDown = CreateFrame("Frame", "SpecDropDown2", frame, "UIDropDownMenuTemplate")
        dropDown:SetPoint("TOPLEFT", specText2, "BOTTOMLEFT", -15, -5)
        dropDown:SetFrameStrata(frame:GetFrameStrata())
        self:InitializePresetDropdown(dropDown)
        frame.SpecDropDown2 = dropDown
    end

    local presets = ns:GetPresets()
    for i = 1, 2 do
    -- detect character specialization for suggesting default sets
        local specID, specName = GetSpecialization(nil, nil, i)
        if specID then specID, specName = GetSpecializationInfo(specID) end

        frame['specText'..i]:SetFormattedText(ns.locale['SetupWizardSpec'..i], specName or _G.NONE)

        if specID then
            local found = false
            for presetID, preset in pairs(presets) do
                if preset.defaultForSpec == specID then
                    UIDropDownMenu_SetSelectedValue(frame['SpecDropDown'..i], presetID)
                    UIDropDownMenu_SetText(frame['SpecDropDown'..i], preset.name)
                    found = true
                end
            end

            if not found then specID = nil end
        end

        if not specID then
            UIDropDownMenu_SetSelectedValue(frame['SpecDropDown'..i], 'none')
            UIDropDownMenu_SetText(frame['SpecDropDown'..i], ns.locale.SetupWizardCreateNoSet)
        end
    end
end