TopFit.characterFrameUIcreated = false;

function TopFit:initializeCharacterFrameUI()
    if (TopFit.characterFrameUIcreated) then return end
    TopFit.characterFrameUIcreated = true;
    PaperDollSidebarTab3:SetPoint("BOTTOMRIGHT", PaperDollSidebarTabs, "BOTTOMRIGHT", -64, 0)
    PanelTemplates_SetNumTabs(CharacterFrame, 4);
    PanelTemplates_UpdateTabs(CharacterFrame);
    
    local pane = TopFitSidebarFrameScrollChild
    
    local setDropDown = TopFit:initializeSetDropdown(CharacterModelFrame)

    local addSetButton = CreateFrame("Button", "TopFitAddSetButton", CharacterModelFrame)
    addSetButton:SetPoint("RIGHT", setDropDown, "LEFT", 13, 9)
    addSetButton:SetHeight(14)
    addSetButton:SetWidth(14)
    addSetButton:SetNormalTexture("Interface\\Icons\\Spell_chargepositive")
    addSetButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

    local addSetDropDown = CreateFrame("Frame", "TopFitAddSetDropDown", addSetButton, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(addSetDropDown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        info.hasArrow = false; -- no submenu
        info.notCheckable = true;
        info.text = TopFit.locale.EmptySet
        info.value = 0
        info.func = function(self)
            TopFit:AddSet()
            TopFit:CalculateScores()
            TopFit:CreateEquipmentSet(v.name)
        end
        UIDropDownMenu_AddButton(info, level)
        
        local presets = TopFit:GetPresets()
        for k, v in pairs(presets) do
            info = UIDropDownMenu_CreateInfo()
            info.hasArrow = false; -- no submenu
            info.notCheckable = true;
            info.text = v.name
            info.value = k
            info.func = function(self)
                TopFit:AddSet(v)
                TopFit:CreateEquipmentSet(v.name)
                TopFit:CalculateScores()
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end, "MENU")
    
    addSetButton:SetScript("OnClick", function(self)
        ToggleDropDownMenu(1, nil, addSetDropDown, self, 0, 0)
    end)
    addSetButton.tipText = TopFit.locale.AddSetTooltip
    addSetButton:SetScript("OnEnter", TopFit.ShowTooltip)
    addSetButton:SetScript("OnLeave", TopFit.HideTooltip)

    local deleteSetButton = CreateFrame("Button", "TopFitDeleteSetButton", CharacterModelFrame)
    deleteSetButton:SetPoint("TOPLEFT", addSetButton, "BOTTOMLEFT", 0, -2)
    deleteSetButton:SetHeight(14)
    deleteSetButton:SetWidth(14)
    deleteSetButton:SetNormalTexture("Interface\\Icons\\Spell_chargenegative")
    deleteSetButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
    
    deleteSetButton:SetScript("OnClick", function(...)
        -- on first click: mark red
        if not deleteSetButton.firstClick then
            if not deleteSetButton.redHightlight then
                deleteSetButton.redHightlight = deleteSetButton:CreateTexture("$parent_higlightTexture")
                deleteSetButton.redHightlight:SetTexture("Interface\\Buttons\\CheckButtonHilight")
                deleteSetButton.redHightlight:SetAllPoints()
                deleteSetButton.redHightlight:SetBlendMode("ADD")
                deleteSetButton.redHightlight:SetDrawLayer("OVERLAY")
                deleteSetButton.redHightlight:SetVertexColor(1, 0, 0, 1)
            end
            deleteSetButton.redHightlight:Show();
            deleteSetButton.firstClick = true
        else
            -- on second click: delete set
            TopFit:DeleteSet(TopFit.selectedSet)
            TopFit:SetSelectedSet();
            deleteSetButton.redHightlight:Hide();
            deleteSetButton.firstClick = false
        end
    end)
    deleteSetButton.tipText = TopFit.locale.DeleteSetTooltip
    deleteSetButton:SetScript("OnEnter", TopFit.ShowTooltip)
    deleteSetButton:SetScript("OnLeave", function() TopFit.HideTooltip() if deleteSetButton.redHightlight then deleteSetButton.redHightlight:Hide(); deleteSetButton.firstClick = false end end)
    

    local calculateButton = CreateFrame("Button", "TopFitSidebarCalculateButton", CharacterModelFrame, "UIPanelButtonTemplate")
    calculateButton:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", 10, 10)
    calculateButton:SetHeight(22)
    calculateButton:SetWidth(80)
    calculateButton:SetText(TopFit.locale.Start)
    calculateButton:SetScript("OnClick", function(...)
        -- TODO: call a function for starting set calculation instead of this
        if not TopFit.isBlocked then
            if TopFit.db.profile.sets[TopFit.selectedSet] then
                TopFit.workSetList = { TopFit.selectedSet }
                TopFit:CalculateSets()
            end
        end
    end)

    local i = 1
    for statCategory, statsTable in pairs(TopFit.statList) do
        local statGroup = CreateFrame("Frame", "TopFitSidebarStatGroup"..i, pane, "TopFitStatGroupTemplate")
        if (i == 1) then
            statGroup:SetPoint("TOPLEFT", pane, "TOPLEFT")
        else
            statGroup:SetPoint("TOPLEFT", _G["TopFitSidebarStatGroup"..(i - 1)], "BOTTOMLEFT", 0, -3)
        end
        statGroup.NameText:SetText(statCategory)
        TopFit:UpdateStatGroup(statGroup)
        
        i = i + 1
    end

    TopFit:CreateEditStatPane(pane)
    TopFit:SetDefaultCollapsedStates()
end

function TopFit:initializeSetDropdown(pane)
    local paneWidth = pane:GetWidth() - 80
    
    local setDropDown = CreateFrame("Frame", "TopFitSetDropDown", pane, "UIDropDownMenuTemplate")
    setDropDown:SetPoint("TOPRIGHT", pane, "TOPRIGHT", -3, -3)
    setDropDown:SetWidth(paneWidth)
    _G["TopFitSetDropDownMiddle"]:SetWidth(paneWidth - 35)
    _G["TopFitSetDropDownButton"]:SetWidth(paneWidth - 20)
    
    UIDropDownMenu_Initialize(setDropDown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for k, v in pairs(TopFit.db.profile.sets) do
            if not TopFit.selectedSet then
                TopFit.selectedSet = k
            end
            info = UIDropDownMenu_CreateInfo()
            info.text = v.name
            info.value = k
            info.func = function(self)
                TopFit:SetSelectedSet(self.value)
            end
            UIDropDownMenu_AddButton(info, level)
        end
    end)
    UIDropDownMenu_SetSelectedID(setDropDown, 1)
    UIDropDownMenu_JustifyText(setDropDown, "LEFT")
    
    return setDropDown
end

function TopFit.StatValueEditBoxFocusLost(self)
    local statCode = self:GetParent().statCode
    self:SetText(TopFit:GetStatValue(TopFit.selectedSet, statCode))
    self:ClearFocus()
end

function TopFit:CreateEditStatPane(pane)
    local editStatPane = CreateFrame("Frame", "TopFitSidebarEditStatPane", pane)

    local capActive, _ = LibStub("tekKonfig-Checkbox").new(editStatPane, 16, nil, "TOP", editStatPane, "TOP", 0, 1)
    capActive:SetPoint("LEFT", editStatPane, "LEFT", -3, 0)
    capActive:SetHitRectInsets(0, 0, 0, 0)
    capActive:Raise()
    capActive.tiptext = "When checked, TopFit will try everything it can to reach this cap. Otherwise, this value just specifies the point at which the alternate value kicks in."
    local checksound = capActive:GetScript("OnClick")
    capActive:SetScript("OnClick", function(self)
        checksound(self)
        local stat = self:GetParent().statCode
        local value = self:GetChecked()
        TopFit:SetCapActive(TopFit.selectedSet, stat, value)
        TopFit:UpdateStatGroups()
        TopFit:CalculateScores()
    end)
    editStatPane.capActive = capActive

    local capString = editStatPane:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    --capString:SetPoint("TOPLEFT", valueString, "BOTTOMLEFT")
    capString:SetPoint("TOP", editStatPane, "TOP", 0, -2)
    capString:SetPoint("LEFT", capActive, "RIGHT")
    capString:SetPoint("RIGHT")
    capString:SetJustifyH("LEFT")
    capString:SetTextHeight(10)
    capString:SetText("Target amount:")

    local afterCapValueString = editStatPane:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    afterCapValueString:SetPoint("TOPLEFT", capString, "BOTTOMLEFT")
    afterCapValueString:SetPoint("RIGHT")
    afterCapValueString:SetJustifyH("LEFT")
    afterCapValueString:SetTextHeight(10)
    afterCapValueString:SetText("Value afterwards:")

    editStatPane:SetHeight(--[[valueString:GetHeight() +]] capString:GetHeight() --[[+ forceCapString:GetHeight()]] + afterCapValueString:GetHeight() + 10)

    local function EditBoxFocusLostCap(self)
        local stat = self:GetParent().statCode
        self:SetText(TopFit:GetCapValue(TopFit.selectedSet, stat))
        self:ClearFocus()
    end

    local capValueTextBox = CreateFrame("EditBox", "TopFitSidebarEditStatPaneStatCap", editStatPane)
    capValueTextBox:SetFrameStrata("HIGH")
    capValueTextBox:SetPoint("TOP", capString, "TOP")
    capValueTextBox:SetPoint("BOTTOM", capString, "BOTTOM")
    capValueTextBox:SetPoint("RIGHT", editStatPane, "RIGHT")
    capValueTextBox:SetWidth(50)
    capValueTextBox:SetAutoFocus(false)
    capValueTextBox:EnableMouse(true)
    capValueTextBox:SetFontObject("GameFontHighlightSmall")
    capValueTextBox:SetJustifyH("RIGHT")
    
    -- scripts
    capValueTextBox:SetScript("OnEditFocusGained", function(...) capValueTextBox.HighlightText(...) end)
    capValueTextBox:SetScript("OnEditFocusLost", EditBoxFocusLostCap)
    capValueTextBox:SetScript("OnEscapePressed", EditBoxFocusLostCap)
    capValueTextBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        local stat = self:GetParent().statCode
        if stat and value then
            TopFit:SetCapValue(TopFit.selectedSet, stat, value)
        else
            TopFit:Debug("invalid input")
        end
        EditBoxFocusLostCap(self)
        TopFit:UpdateStatGroups()
        TopFit:CalculateScores()
    end)
    
    local function EditBoxFocusLostAfterCap(self)
        local statCode = self:GetParent().statCode
        self:SetText(TopFit:GetAfterCapStatValue(TopFit.selectedSet, statCode))
        self:ClearFocus()
    end

    local afterCapStatValueTextBox = CreateFrame("EditBox", "TopFitSidebarEditStatPaneStatAfterCapValue", editStatPane)
    afterCapStatValueTextBox:SetFrameStrata("HIGH")
    afterCapStatValueTextBox:SetPoint("TOP", afterCapValueString, "TOP")
    afterCapStatValueTextBox:SetPoint("BOTTOM", afterCapValueString, "BOTTOM")
    afterCapStatValueTextBox:SetPoint("RIGHT", editStatPane, "RIGHT")
    afterCapStatValueTextBox:SetWidth(50)
    afterCapStatValueTextBox:SetAutoFocus(false)
    afterCapStatValueTextBox:EnableMouse(true)
    afterCapStatValueTextBox:SetFontObject("GameFontHighlightSmall")
    afterCapStatValueTextBox:SetJustifyH("RIGHT")
    
    -- scripts
    afterCapStatValueTextBox:SetScript("OnEditFocusGained", function(...) afterCapStatValueTextBox.HighlightText(...) end)
    afterCapStatValueTextBox:SetScript("OnEditFocusLost", EditBoxFocusLostAfterCap)
    afterCapStatValueTextBox:SetScript("OnEscapePressed", EditBoxFocusLostAfterCap)
    afterCapStatValueTextBox:SetScript("OnEnterPressed", function(self)
        local value = tonumber(self:GetText())
        local stat = self:GetParent().statCode
        if stat and value then
            if value == 0 then value = nil end  -- used for removing stats from the list
            TopFit:SetAfterCapStatValue(TopFit.selectedSet, stat, value)
        else
            TopFit:Debug("invalid input")
        end
        EditBoxFocusLostAfterCap(self)
        TopFit:UpdateStatGroups()
        TopFit:CalculateScores()
    end)
end

function TopFit:SetSelectedSet(setID)
    local i
    if not setID then
        for i = 1, 500 do
            if (TopFit.db.profile.sets["set_"..i]) then
                setID = "set_"..i
                break
            end
        end
        if not setID then return end
    end
    
    TopFit.selectedSet = setID
    
    UIDropDownMenu_SetSelectedValue(TopFitSetDropDown, TopFit.selectedSet)
    TopFit:UpdateStatGroups()
    TopFit:SetDefaultCollapsedStates()
end

function TopFit:ExpandStatGroup(statGroup)
    statGroup.collapsed = false
    statGroup.CollapsedIcon:Hide()
    statGroup.ExpandedIcon:Show()
    TopFit:UpdateStatGroup(statGroup)
    statGroup.BgMinimized:Hide()
    statGroup.BgTop:Show()
    statGroup.BgMiddle:Show()
    statGroup.BgBottom:Show()
end

function TopFit:CollapseStatGroup(statGroup)
    statGroup.collapsed = true
    statGroup.CollapsedIcon:Show()
    statGroup.ExpandedIcon:Hide()
    local i = 1;
    while (_G[statGroup:GetName().."Stat"..i]) do 
        _G[statGroup:GetName().."Stat"..i]:Hide()
        i = i + 1;
    end
    statGroup:SetHeight(18)
    statGroup.BgMinimized:Show()
    statGroup.BgTop:Hide()
    statGroup.BgMiddle:Hide()
    statGroup.BgBottom:Hide()

    TopFit:CalculateStatFrameHeight()
end

function TopFit:UpdateStatGroups()
    local i = 1
    while (_G["TopFitSidebarStatGroup"..i]) do
        TopFit:UpdateStatGroup(_G["TopFitSidebarStatGroup"..i])
        i = i + 1
    end
end

function TopFit:UpdateStatGroup(statGroup)
    local STRIPE_COLOR = {r = 0.9, g = 0.9, b = 1}
    local subStats = TopFit.statList[statGroup.NameText:GetText()]
    local i = 1
    local totalHeight = statGroup.NameText:GetHeight() + 10
    for i = 1, #subStats do
        local statCode = subStats[i]
        local statFrame = _G[statGroup:GetName().."Stat"..i]
        
        if not statFrame then
            statFrame = CreateFrame("Button", statGroup:GetName().."Stat"..i, statGroup, "TopFitStatFrameTemplate")
            statFrame:SetPoint("TOPLEFT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMLEFT", 0, 0)
            statFrame:SetPoint("TOPRIGHT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMRIGHT", 0, 0)
        end
        
        --statFrame.statID = i
        --statFrame.statGroup = statGroup:GetName()
        statFrame.statCode = statCode
        _G[statGroup:GetName().."Stat"..i.."Label"]:SetText(_G[statCode]..":")
        _G[statGroup:GetName().."Stat"..i.."StatText"]:SetText(TopFit.db.profile.sets[TopFit.selectedSet].weights[statCode] or "0")
        if statGroup.collapsed then
            statFrame:Hide()
        else
            statFrame:Show()
        end
        
        totalHeight = totalHeight + statFrame:GetHeight()
        
        if (i % 2 == 0) then
            if (not statFrame.Bg) then
                statFrame.Bg = statFrame:CreateTexture(statFrame:GetName().."Bg", "BACKGROUND")
                statFrame.Bg:SetPoint("LEFT", statGroup, "LEFT", 1, 0)
                statFrame.Bg:SetPoint("RIGHT", statGroup, "RIGHT", 0, 0)
                statFrame.Bg:SetPoint("TOP")
                statFrame.Bg:SetPoint("BOTTOM")
                statFrame.Bg:SetTexture(STRIPE_COLOR.r, STRIPE_COLOR.g, STRIPE_COLOR.b)
                statFrame.Bg:SetAlpha(0.1)
            end
        end
    end

    if not statGroup.collapsed then
        statGroup:SetHeight(totalHeight)
    end
    
    -- fix for groups with only 1 item
    if (totalHeight < 44) then
        statGroup.BgBottom:SetHeight(totalHeight - 2)
    else
        statGroup.BgBottom:SetHeight(46)
    end

    TopFit:CalculateStatFrameHeight()
end

function TopFit:CalculateStatFrameHeight()
    local totalHeight = 0
    local i = 1

    while (_G["TopFitSidebarStatGroup"..i]) do
        totalHeight = totalHeight + _G["TopFitSidebarStatGroup"..i]:GetHeight() + 3
        i = i + 1
    end

    TopFitSidebarFrameScrollChild:SetHeight(totalHeight)
end

function TopFit:SetDefaultCollapsedStates()
    local i = 1
    while (_G["TopFitSidebarStatGroup"..i]) do
        local statGroup = _G["TopFitSidebarStatGroup"..i]

        local subStats = TopFit.statList[statGroup.NameText:GetText()]
        local j = 1
        local foundActiveStat = false
        for j = 1, #subStats do
            local statCode = subStats[j]
            
            if (TopFit:GetStatValue(TopFit.selectedSet, statCode) > 0 or TopFit:GetCapValue(TopFit.selectedSet, statCode) > 0 or TopFit:GetAfterCapStatValue(TopFit.selectedSet, statCode) > 0) then
                foundActiveStat = true
                break
            end
        end

        if foundActiveStat then
            TopFit:ExpandStatGroup(statGroup)
        else
            TopFit:CollapseStatGroup(statGroup)
        end

        i = i + 1
    end
end

function TopFit:ToggleStatFrame(statFrame)
    if (statFrame:GetHeight() > 20) then
        statFrame:SetHeight(13)
        TopFitSidebarEditStatPane:Hide()
    else
        TopFit:CollapseAllStatGroups()
        TopFitSidebarEditStatPane:SetPoint("TOPLEFT", statFrame, "TOPLEFT", 0, -13)
        TopFitSidebarEditStatPane:SetPoint("TOPRIGHT", statFrame, "TOPRIGHT", 0, -13)
        TopFitSidebarEditStatPane:SetParent(statFrame)
        TopFitSidebarEditStatPane:Show()
        TopFitSidebarEditStatPane.statCode = statFrame.statCode
        statFrame:SetHeight(13 + TopFitSidebarEditStatPane:GetHeight())

        local statInSet = TopFit:GetStatValue(TopFit.selectedSet, statFrame.statCode)
        --TopFitSidebarEditStatPaneStatValue:SetText(statInSet)
        local capInSet = TopFit:GetCapValue(TopFit.selectedSet, statFrame.statCode)
        TopFitSidebarEditStatPaneStatCap:SetText(capInSet)
        local capActive = TopFit:IsCapActive(TopFit.selectedSet, statFrame.statCode)
        TopFitSidebarEditStatPane.capActive:SetChecked(capActive)
        local afterCap = TopFit:GetAfterCapStatValue(TopFit.selectedSet, statFrame.statCode)
        TopFitSidebarEditStatPaneStatAfterCapValue:SetText(afterCap)
        --TopFitSidebarEditStatPaneStatValue:Raise()
    end
    
    TopFit:UpdateStatGroups()
end

function TopFit:CollapseAllStatGroups()
    local i = 1
    local statGroup = _G["TopFitSidebarStatGroup"..i]
    while (statGroup) do
        local j = 1
        local statFrame = _G[statGroup:GetName().."Stat"..j]
        while (statFrame) do
            if (statFrame:GetHeight() > 20) then
                statFrame:SetHeight(13)
            end

            j = j + 1
            statFrame = _G[statGroup:GetName().."Stat"..j]
        end

        i = i + 1
        statGroup = _G["TopFitSidebarStatGroup"..i]
    end
end
