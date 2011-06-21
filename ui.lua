TopFit.characterFrameUIcreated = false;

function TopFit:initializeCharacterFrameUI()
    if (TopFit.characterFrameUIcreated) then return end
    TopFit.characterFrameUIcreated = true;
    PaperDollSidebarTab3:SetPoint("BOTTOMRIGHT", PaperDollSidebarTabs, "BOTTOMRIGHT", -64, 0)
    PanelTemplates_SetNumTabs(CharacterFrame, 4);
    PanelTemplates_UpdateTabs(CharacterFrame);
    
    local pane = TopFitSidebarFrameScrollChild
    
    local setDropDown = TopFit:initializeSetDropdown(CharacterModelFrame)

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

    --TopFit:CreateItemButtons()

    TopFit:CreateEditStatPane(pane)
    TopFit:SetDefaultCollapsedStates()
end

function TopFit:initializeSetDropdown(pane)
    local paneWidth = pane:GetWidth() - 70
    
    local setDropDown = CreateFrame("Frame", "TopFitSetDropDown", pane, "UIDropDownMenuTemplate")
    setDropDown:SetPoint("TOPRIGHT", pane, "TOPRIGHT", -3, -3)
    setDropDown:SetWidth(paneWidth)
    _G["TopFitSetDropDownMiddle"]:SetWidth(paneWidth - 35)
    _G["TopFitSetDropDownButton"]:SetWidth(paneWidth - 20)
    
    UIDropDownMenu_Initialize(setDropDown, function(self, level)
        if level == 1 then
            local info = UIDropDownMenu_CreateInfo()
            info.text = TopFit.locale.SelectSetDropDown
            info.value = 'selectsettitle'
            info.isTitle = true
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, level)

            for k, v in pairs(TopFit.db.profile.sets) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = v.name
                info.value = k
                info.hasArrow = true
                info.func = function(self)
                    TopFit:SetSelectedSet(self.value)
                end
                UIDropDownMenu_AddButton(info, level)
                if not TopFit.selectedSet then
                    TopFit:SetSelectedSet(k)
                end
            end

            local info = UIDropDownMenu_CreateInfo()
            info.text = ''
            info.value = 'newline'
            info.isTitle = true
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, level)

            local info = UIDropDownMenu_CreateInfo()
            info.text = TopFit.locale.AddSetDropDown
            info.value = 'addsettitle'
            info.isTitle = true
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, level)

            local info = UIDropDownMenu_CreateInfo()
            info.text = TopFit.locale.EmptySet
            info.value = 'addemptyset'
            info.func = function(self)
                TopFit:AddSet()
                TopFit:CalculateScores()
                TopFit:CreateEquipmentSet(v.name)
            end
            UIDropDownMenu_AddButton(info, level)
            
            local presets = TopFit:GetPresets()
            for k, v in pairs(presets) do
                info = UIDropDownMenu_CreateInfo()
                info.text = v.name
                info.value = 'add_'..k
                info.func = function(self)
                    TopFit:AddSet(v)
                    TopFit:CreateEquipmentSet(v.name)
                    TopFit:CalculateScores()
                end
                UIDropDownMenu_AddButton(info, level)
            end
        elseif level == 2 then
            local info = UIDropDownMenu_CreateInfo()
            info.text = TopFit.locale.ModifySetSelectText
            info.value = 'select_'..UIDROPDOWNMENU_MENU_VALUE
            info.notCheckable = true
            info.func = function()
                TopFit:SetSelectedSet(UIDROPDOWNMENU_MENU_VALUE)
                ToggleDropDownMenu(1, nil, setDropDown)
            end
            UIDropDownMenu_AddButton(info, level)

            local info = UIDropDownMenu_CreateInfo()
            info.text = TopFit.locale.ModifySetRenameText
            info.value = 'select_'..UIDROPDOWNMENU_MENU_VALUE
            info.notCheckable = true
            info.func = function()
            TopFit.currentlyRenamingSetID = UIDROPDOWNMENU_MENU_VALUE
                StaticPopup_Show("TOPFIT_RENAMESET", TopFit.db.profile.sets[UIDROPDOWNMENU_MENU_VALUE].name)
                ToggleDropDownMenu(1, nil, setDropDown)
            end
            UIDropDownMenu_AddButton(info, level)

            local info = UIDropDownMenu_CreateInfo()
            info.text = TopFit.locale.ModifySetDeleteText
            info.value = 'select_'..UIDROPDOWNMENU_MENU_VALUE
            info.notCheckable = true
            info.func = function()
                TopFit:DeleteSet(UIDROPDOWNMENU_MENU_VALUE)
                TopFit:SetSelectedSet()
                ToggleDropDownMenu(1, nil, setDropDown)
            end
            UIDropDownMenu_AddButton(info, level)

        end
    end)
    -- UIDropDownMenu_SetSelectedID(setDropDown, 2)
    UIDropDownMenu_JustifyText(setDropDown, "LEFT")
    
    for k, v in pairs(TopFit.db.profile.sets) do
        if not TopFit.selectedSet then
            UIDropDownMenu_SetText(setDropDown, v.name)
            TopFit:SetSelectedSet(k)
            break
        end
    end

    StaticPopupDialogs["TOPFIT_RENAMESET"] = {
        text = "Rename set \"%s\" to:",
        button1 = "OK",
        button2 = "Cancel",
        OnAccept = function(self)
            local newName = self.editBox:GetText()
            TopFit:Print(newName)
            TopFit:RenameSet(TopFit.currentlyRenamingSetID, newName)
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        hasEditBox = true,
        enterClicksFirstButton = true,
        OnShow = function(self)
            self.editBox:SetText(TopFit.db.profile.sets[TopFit.currentlyRenamingSetID].name)
        end
    }
    
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
    UIDropDownMenu_SetText(TopFitSetDropDown, TopFit.db.profile.sets[TopFit.selectedSet].name)
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
        
        statFrame.statCode = statCode
        _G[statGroup:GetName().."Stat"..i.."Label"]:SetText(_G[statCode]..":")
        _G[statGroup:GetName().."Stat"..i.."StatText"]:SetText(TopFit:GetStatValue(TopFit.selectedSet, statCode))
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

function TopFit:CreateItemButtons()
    local itemButtons = {}
    for _, slotName in ipairs(TopFit.slotList) do
        local slotID, emptyTexture, isRelic = GetInventorySlotInfo(slotName)
        local button = CreateFrame("Button", "TopFit"..slotName.."Button", CharacterModelFrame, "ItemButtonTemplate")
        button:Raise()
        button:SetID(slotID)
        button.backgroundTextureName = emptyTexture
        button.checkRelic = isRelic
        
        -- create extra highlight texture for marking purposes
        button.highlightTexture = button:CreateTexture("$parentHiglightTexture")
        button.highlightTexture:SetTexture("Interface\\Buttons\\CheckButtonHilight")
        button.highlightTexture:SetAllPoints()
        button.highlightTexture:SetBlendMode("ADD")
        button.highlightTexture:SetDrawLayer("OVERLAY")
        button.highlightTexture:SetVertexColor(1, 1, 1, 0)
        
        button:SetScript("OnEnter", TopFit.ShowTooltip)
        button:SetScript("OnLeave", function (...)
            TopFit.HideTooltip()
            --[[if TopFit.ProgressFrame.forceItemsFrame then
                                        if not TopFit.ProgressFrame.forceItemsFrame:IsMouseOver() then
                                            TopFit.ProgressFrame.forceItemsFrame:Hide()
                                        end
                                    end]]
        end)
        button:SetScript("OnClick", function (self, ...)
            --[[if not TopFit.isBlocked then
                                        local slotID = self:GetID()
                                        if not TopFit.ProgressFrame.forceItemsFrame then
                                            -- create frame for forced items
                                            TopFit.ProgressFrame.forceItemsFrame = CreateFrame("Frame", "TopFit_ProgressFrame_forceItemsFrame", UIParent)
                                            TopFit.ProgressFrame.forceItemsFrame:SetBackdrop({
                                                bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                                                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                                                tile = true,
                                                tileSize = 16,
                                                edgeSize = 16,
                                                -- distance from the edges of the frame to those of the background texture (in pixels)
                                                insets = {left = 4, right = 4, top = 4, bottom = 4}
                                            })
                                            TopFit.ProgressFrame.forceItemsFrame:SetBackdropColor(0, 0, 0)
                                            TopFit.ProgressFrame.forceItemsFrame:SetWidth(300)
                                            TopFit.ProgressFrame.forceItemsFrame:EnableMouse(true)
                                            TopFit.ProgressFrame.forceItemsFrame:SetScript("OnLeave", function (self, ...)
                                                if not self:IsMouseOver() then
                                                    self:Hide()
                                                end
                                            end)
                                            
                                            -- label
                                            TopFit.ProgressFrame.forceItemsFrame.slotLabel = TopFit.ProgressFrame.forceItemsFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
                                            TopFit.ProgressFrame.forceItemsFrame.slotLabel:SetPoint("TOPLEFT", TopFit.ProgressFrame.forceItemsFrame, "TOPLEFT", 10, -10)
                                            
                                            TopFit.ProgressFrame.forceItemsFrame.itemButtons = {}
                                            --TopFit.ProgressFrame.forceItemsFrame.itemLabels = {}
                                        end
                                        TopFit.ProgressFrame.forceItemsFrame.slotLabel:SetText(string.format(TopFit.locale.ForceItem, TopFit.slotNames[slotID]))
                                        
                                        local itemButtons = TopFit.ProgressFrame.forceItemsFrame.itemButtons
                                        -- create "Force none" button
                                        if not itemButtons[1] then
                                            itemButtons[1] = CreateFrame("Button", "TopFit_ProgressFrame_forceItemsFrame_itemButton1", TopFit.ProgressFrame.forceItemsFrame)
                                            itemButtons[1]:SetWidth(280)
                                            itemButtons[1]:SetHeight(24)
                                            itemButtons[1]:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                                            itemButtons[1]:SetPoint("TOPLEFT", TopFit.ProgressFrame.forceItemsFrame.slotLabel, "BOTTOMLEFT", 0, -5)
                                            
                                            itemButtons[1].itemTexture = itemButtons[1]:CreateTexture()
                                            itemButtons[1].itemTexture:SetWidth(24)
                                            itemButtons[1].itemTexture:SetHeight(24)
                                            itemButtons[1].itemTexture:SetPoint("TOPLEFT")
                                            
                                            itemButtons[1].itemLabel = itemButtons[1]:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
                                            itemButtons[1].itemLabel:SetPoint("LEFT", itemButtons[1].itemTexture, "RIGHT", 3)
                                            
                                            itemButtons[1].itemLabel:SetText(TopFit.locale.ForceItemNone)
                                            itemButtons[1].itemTexture:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
                                            
                                            itemButtons[1]:SetScript("OnClick", function(self)
                                                TopFit:Debug("Cleared forced item for slot "..self.slotID)
                                                TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].forced[self.slotID] = nil
                                                TopFit.ProgressFrame.equipButtons[self.slotID].highlightTexture:SetVertexColor(1, 1, 1, 0)
                                                TopFit.ProgressFrame.forceItemsFrame:Hide()
                                            end)
                                        end
                                        itemButtons[1].slotID = slotID
                                        
                                        -- create buttons for all items
                                        TopFit:collectItems()
                                        local i = 2
                                        local maxWidth = 200
                                        
                                        local itemListBySlot = TopFit:GetEquippableItems(self:GetID())
                                        
                                        if itemListBySlot then
                                            for _, locationTable in pairs(itemListBySlot) do
                                                if not itemButtons[i] then
                                                    itemButtons[i] = CreateFrame("Button", "TopFit_ProgressFrame_forceItemsFrame_itemButton"..i, TopFit.ProgressFrame.forceItemsFrame)
                                                    itemButtons[i]:SetWidth(280)
                                                    itemButtons[i]:SetHeight(24)
                                                    itemButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                                                    itemButtons[i]:SetPoint("TOPLEFT", itemButtons[i - 1], "BOTTOMLEFT")
                                                    
                                                    itemButtons[i].itemTexture = itemButtons[i]:CreateTexture()
                                                    itemButtons[i].itemTexture:SetWidth(24)
                                                    itemButtons[i].itemTexture:SetHeight(24)
                                                    itemButtons[i].itemTexture:SetPoint("TOPLEFT")
                                                    
                                                    itemButtons[i].itemLabel = itemButtons[i]:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
                                                    itemButtons[i].itemLabel:SetPoint("LEFT", itemButtons[i].itemTexture, "RIGHT", 3)
                                                    
                                                    -- script handlers
                                                    itemButtons[i]:SetScript("OnClick", function(self)
                                                        TopFit:Debug("Forced item "..select(2, GetItemInfo(self.itemID)).." for slot "..self.slotID)
                                                        TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].forced[self.slotID] = self.itemID
                                                        TopFit.ProgressFrame.equipButtons[self.slotID].highlightTexture:SetVertexColor(1, 0, 0, 1)
                                                        TopFit.ProgressFrame.forceItemsFrame:Hide()
                                                    end)
                                                end
                                                
                                                local itemTable = TopFit:GetCachedItem(locationTable.itemLink)
                                                
                                                if itemTable then
                                                    itemButtons[i].itemID = itemTable.itemID
                                                end
                                                itemButtons[i].slotID = slotID
                                                itemButtons[i]:Show()
                                                itemButtons[i].itemLabel:SetText(locationTable.itemLink)
                                                
                                                if itemButtons[i].itemLabel:GetWidth() > maxWidth then
                                                    maxWidth = itemButtons[i].itemLabel:GetWidth()
                                                end
                                                
                                                local tex = select(10, GetItemInfo(locationTable.itemLink))
                                                if not tex then tex = "Interface\\Icons\\Inv_misc_questionmark" end
                                                itemButtons[i].itemTexture:SetTexture(tex)
                                                
                                                i = i + 1
                                            end
                                        end
                                        
                                        TopFit.ProgressFrame.forceItemsFrame:SetHeight(25 + (i - 1) * 24 + TopFit.ProgressFrame.forceItemsFrame.slotLabel:GetHeight())
                                        TopFit.ProgressFrame.forceItemsFrame:SetWidth(maxWidth + 24 + 20)
                                        for j = 1, i - 1 do
                                            itemButtons[j]:SetWidth(maxWidth + 24)
                                        end
                                        
                                        -- hide unused buttons
                                        for i = i, #itemButtons do
                                            itemButtons[i]:Hide()
                                        end
                                        
                                        TopFit.ProgressFrame.forceItemsFrame:Show()
                                        TopFit.ProgressFrame.forceItemsFrame:ClearAllPoints()
                                        TopFit.ProgressFrame.forceItemsFrame:SetParent(self) -- so "OnLeave" will fire when the mouse leaves this frame or the button
                                        TopFit.ProgressFrame.forceItemsFrame:SetPoint("RIGHT", self, "RIGHT")
                                    end]]
        end)
        
        itemButtons[slotID] = button
    end
    
    do  -- anchor them all like in the equipment window
        local i = 1
        for i = 1, 19 do
            itemButtons[i]:SetPoint("TOPLEFT", _G["Character"..TopFit.slotList[i]], "TOPLEFT")
        end
    end
end