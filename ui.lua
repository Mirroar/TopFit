local minimalist = [=[Interface\AddOns\TopFit\media\minimalist]=]

TopFit.characterFrameUIcreated = false;

-- utility for rounding
local function round(input, places)
    if not places then
        places = 0
    end
    if type(input) == "number" and type(places) == "number" then
        local pow = 1
        for i = 1, ceil(places) do
            pow = pow * 10
        end
        return floor(input * pow + 0.5) / pow
    else
        return input
    end
end

function TopFit:initializeCharacterFrameUI()
    if (TopFit.characterFrameUIcreated) then return end
    TopFit.characterFrameUIcreated = true;
    PaperDollSidebarTab3:SetPoint("BOTTOMRIGHT", PaperDollSidebarTabs, "BOTTOMRIGHT", -64, 0)
    
    local pane = TopFitSidebarFrameScrollChild

    TopFit:InitializeStaticPopupDialogs()
    local setDropDown = TopFit:initializeSetDropdown(CharacterModelFrame)

    local calculateButton = CreateFrame("Button", "TopFitSidebarCalculateButton", PaperDollItemsFrame, "UIPanelButtonTemplate")
    calculateButton:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", 10, 10)
    calculateButton:SetHeight(22)
    calculateButton:SetWidth(80)
    calculateButton:SetText(TopFit.locale.Start)
    calculateButton:SetScript("OnClick", function(...)
        -- TODO: call a function for starting set calculation instead of this
        if not TopFit.isBlocked then
            if not IsShiftKeyDown() then
                -- calculate selected set
                if TopFit.db.profile.sets[TopFit.selectedSet] then
                    PaperDollFrame_SetSidebar(PaperDollFrame, 4)
                    TopFit.workSetList = { TopFit.selectedSet }
                    TopFit:CalculateSets()
                end
            else
                -- calculate all sets
                TopFit.workSetList = {}
                for setID, _ in pairs(TopFit.db.profile.sets) do
                    tinsert(TopFit.workSetList, setID)
                end
                TopFit:CalculateSets()
            end
        end
    end)
    calculateButton.tipText = TopFit.locale.StartTooltip
    calculateButton:SetScript("OnEnter", TopFit.ShowTooltip);
    calculateButton:SetScript("OnLeave", TopFit.HideTooltip);

    -- progress bar
    local progressBar = CreateFrame("StatusBar", "TopFitProgressBar", CharacterModelFrame)
    progressBar:SetPoint("TOPLEFT", setDropDown, 10, -5)
    progressBar:SetPoint("BOTTOMRIGHT", setDropDown, -4, 9)
    progressBar:SetStatusBarTexture(minimalist)
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetStatusBarColor(0, 1, 0, 1)
    progressBar:Hide()

    -- progress text
    local progressText = progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    progressText:SetAllPoints()
    progressText:SetText("0.00%")
    progressBar.text = progressText

    TopFit:CreateOptionsStatFrame(pane)
    
    local i = 1
    for statCategory, statsTable in pairs(TopFit.statList) do
        local statGroup = CreateFrame("Frame", "TopFitSidebarStatGroup"..i, pane, "TopFitStatGroupTemplate")
        if (i == 1) then
            statGroup:SetPoint("TOPLEFT", TopFitSidebarOptionsStatGroup, "BOTTOMLEFT", 0, -3)
        else
            statGroup:SetPoint("TOPLEFT", _G["TopFitSidebarStatGroup"..(i - 1)], "BOTTOMLEFT", 0, -3)
        end
        statGroup.NameText:SetText(statCategory)
        TopFit:UpdateStatGroup(statGroup)
        
        i = i + 1
    end

    local statGroup = CreateFrame("Frame", "TopFitSidebarStatGroup"..i, pane, "TopFitStatGroupTemplate")
    statGroup:SetPoint("TOPLEFT", _G["TopFitSidebarStatGroup"..(i - 1)], "BOTTOMLEFT", 0, -3)
    statGroup.NameText:SetText(TopFit.locale.SetHeader)
    statGroup.isSetsGroup = true
    TopFit:UpdateStatGroup(statGroup)

    TopFit:CreateEditStatPane(pane)
    TopFit:SetDefaultCollapsedStates()
    TopFit:InitializeStatScrollFrame()

    TopFit:CreateVirtualItemsPlugin()
    TopFit:CreateUtilitiesPlugin()

    TopFit:SetSelectedSet()
end

function TopFit:InitializeStatScrollFrame()
    local scrollFrameWidth, scrollFrameHeight = CharacterModelFrame:GetWidth() - 28, CharacterModelFrame:GetHeight() - 45
    local statScrollFrame = CreateFrame("ScrollFrame", "TopFitStatScrollFrame", CharacterFrame, "UIPanelScrollFrameTemplate")
    statScrollFrame:SetWidth(scrollFrameWidth)
    statScrollFrame:SetHeight(scrollFrameHeight)
    statScrollFrame:SetPoint("TOPLEFT", CharacterModelFrame, 3, -30)
    statScrollFrame:SetPoint("BOTTOMRIGHT", CharacterModelFrame, -25, 15)
    local statScrollFrameContent = CreateFrame("Frame", "TopFitStatScrollFrameContent", statScrollFrame)
    statScrollFrameContent:SetAllPoints()
    statScrollFrameContent:SetHeight(scrollFrameHeight)
    statScrollFrameContent:SetWidth(scrollFrameWidth)
    statScrollFrame:SetScrollChild(statScrollFrameContent)
    
    -- List of Score contributing Texts and Bars
    statScrollFrameContent.statNameFontStrings = {}
    statScrollFrameContent.statValueFontStrings = {}
    statScrollFrameContent.statValueStatusBars = {}
    statScrollFrameContent.capNameFontStrings = {}
    statScrollFrameContent.capValueFontStrings = {}
    
    local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        tile = true,
        tileSize = 32,
        insets = { left = 0, right = -22, top = 0, bottom = 0 }}
    statScrollFrame:SetBackdrop(backdrop)
    statScrollFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
    statScrollFrame:SetBackdropColor(0, 0, 0, 0.5)

    statScrollFrame:Hide()

    local frame, pluginID = TopFit:RegisterPlugin(TopFit.locale.Stats, "Interface\\Icons\\Ability_Druid_BalanceofPower", TopFit.locale.StatsTooltip)
    TopFit.plugins[pluginID].frame = statScrollFrameContent
end

function TopFit:InitializeStaticPopupDialogs()
    StaticPopupDialogs["TOPFIT_RENAMESET"] = {
        text = "Rename set \"%s\" to:",
        button1 = "OK",
        button2 = "Cancel",
        OnAccept = function(self)
            local newName = self.editBox:GetText()
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

    StaticPopupDialogs["TOPFIT_DELETESET"] = {
        text = "Do you really want to delete the set \"%s\"? The associated set in the equipment manager will also be lost.",
        button1 = "OK",
        button2 = "Cancel",
        OnAccept = function(self)
            TopFit:DeleteSet(TopFit.currentlyDeletingSetID)
            TopFit:SetSelectedSet()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true
    }
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
            info.value = 'rename_'..UIDROPDOWNMENU_MENU_VALUE
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
            info.value = 'delete_'..UIDROPDOWNMENU_MENU_VALUE
            info.notCheckable = true
            info.func = function()
                TopFit.currentlyDeletingSetID = UIDROPDOWNMENU_MENU_VALUE
                StaticPopup_Show("TOPFIT_DELETESET", TopFit.db.profile.sets[UIDROPDOWNMENU_MENU_VALUE].name)
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
    capActive.tiptext = TopFit.locale.capActiveTooltip
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
    end
    
    TopFit.selectedSet = setID
    
    if not setID then
        if TopFitSidebarCalculateButton then
            TopFitSidebarCalculateButton:Disable()
        end
    else
        if TopFitSidebarCalculateButton then
            TopFitSidebarCalculateButton:Enable()
        end
        TopFit:SetCurrentCombinationFromEquipmentSet(setID)
        UIDropDownMenu_SetSelectedValue(TopFitSetDropDown, TopFit.selectedSet)
        UIDropDownMenu_SetText(TopFitSetDropDown, TopFit.db.profile.sets[TopFit.selectedSet].name)
        TopFit:UpdateStatGroups()
        TopFit:SetDefaultCollapsedStates()
    end
end

function TopFit:SetCurrentCombinationFromEquipmentSet(setCode)
    -- generate pseudo equipment set to display when selecting a set
    local combination = {
        items = {},
        totalStats = {},
        totalScore = 0,
    }
    local itemPositions = GetEquipmentSetLocations(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))
    if itemPositions then
        for slotID, itemLocation in pairs(itemPositions) do
            if itemLocation and itemLocation ~= 1 and itemLocation ~= 0 then
                local itemLink = nil
                local player, bank, bags, slot, bag = EquipmentManager_UnpackLocation(itemLocation)
                if player then
                    if bank then
                        -- item is banked, use itemID
                        local itemID = GetEquipmentSetItemIDs(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))[slotID]
                        if itemID and itemID ~= 1 then
                            _, itemLink = GetItemInfo(itemID)
                        end
                    elseif bags then
                        -- item is in player's bags
                        itemLink = GetContainerItemLink(bag, slot)
                    else
                        -- item is equipped
                        itemLink = GetInventoryItemLink("player", slot)
                    end
                else
                    -- item not found
                end
                
                if itemLink then
                    itemTable = TopFit:GetCachedItem(itemLink)
                    if itemTable then
                        combination.items[slotID] = {
                            itemLink = itemLink,
                            bag = bag,
                            slot = slot
                        }
                        
                        -- add to total stats and score
                        for statName, statValue in pairs(itemTable.totalBonus) do
                            combination.totalStats[statName] = (combination.totalStats[statName] or 0) + statValue
                        end
                        combination.totalScore = combination.totalScore + TopFit:GetItemScore(itemTable.itemLink, setCode)
                    end
                end
            end
        end
    end
    
    TopFit:SetCurrentCombination(combination)
end

function TopFit:ResetProgress()
    TopFit.progress = nil
    if not TopFitSidebarCalculateButton then return end
    TopFitSidebarCalculateButton:Hide()
    TopFitSetDropDown:Hide()

    TopFitProgressBar:Show()
end

function TopFit:StoppedCalculation()
    if not TopFitSidebarCalculateButton then return end
    TopFitSidebarCalculateButton:Show()
    TopFitSetDropDown:Show()

    TopFitProgressBar:Hide()
end

function TopFit:SetProgress(progress)
    if (TopFit.progress == nil) or (TopFit.progress < progress) then
        TopFit.progress = progress
        if not TopFitSidebarCalculateButton then return end
        TopFitProgressBar.text:SetText(round(progress * 100, 2).."%")
        TopFitProgressBar:SetValue(progress * 100)
    end
end

function TopFit:ExpandStatGroup(statGroup)
    if not statGroup then return end
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
    if not statGroup then return end
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
    TopFit:UpdateStatGroup(TopFitSidebarOptionsStatGroup)
    local i = 1
    while (_G["TopFitSidebarStatGroup"..i]) do
        TopFit:UpdateStatGroup(_G["TopFitSidebarStatGroup"..i])
        i = i + 1
    end
end

function TopFit:UpdateStatGroup(statGroup)
    if not statGroup then return end
    local STRIPE_COLOR = {r = 0.9, g = 0.9, b = 1}
    local subStats
    if statGroup.isSetsGroup then
        subStats = TopFit:GetAvailableItemSetNames()
    else
        subStats = TopFit.statList[statGroup.NameText:GetText()]
    end
    local i = 1
    local totalHeight = statGroup.NameText:GetHeight() + 10
    if subStats then
        for i = 1, #subStats do
            local statCode = subStats[i]
            local statFrame = _G[statGroup:GetName().."Stat"..i]
            
            if not statFrame then
                statFrame = CreateFrame("Button", statGroup:GetName().."Stat"..i, statGroup, "TopFitStatFrameTemplate")
                statFrame:SetPoint("TOPLEFT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMLEFT", 0, 0)
                statFrame:SetPoint("TOPRIGHT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMRIGHT", 0, 0)
            end
            
            statFrame.statCode = statCode
            _G[statGroup:GetName().."Stat"..i.."Label"]:SetText((_G[statCode] or string.gsub(statCode, "SET: ", ""))..":")
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
    else
        -- options stat group
        local i = 1
        while(_G[statGroup:GetName().."Stat"..i]) do
            local statFrame = _G[statGroup:GetName().."Stat"..i]

            if statGroup.collapsed then
                statFrame:Hide()
            else
                statFrame:Show()
                statFrame:updateData()
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

            i = i + 1
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

function TopFit:CreateOptionsStatFrame(parent)
    local statGroup = CreateFrame("Frame", "TopFitSidebarOptionsStatGroup", parent, "TopFitStatGroupTemplate")
    local playerClass = select(2, UnitClass("player"))
    statGroup:SetPoint("TOPLEFT", parent, "TOPLEFT")
    statGroup.NameText:SetText("Options")

    local i = 1
    local showInTooltip = _G[statGroup:GetName().."Stat1"]
    _G[showInTooltip:GetName().."Label"]:SetText(TopFit.locale.StatsShowTooltip)
    _G[showInTooltip:GetName().."StatText"]:Hide()
    local showInTooltipCheckBox, _ = LibStub("tekKonfig-Checkbox").new(showInTooltip, 16, nil, "TOP", showInTooltip, "TOP", 0, 1)
    showInTooltipCheckBox:SetPoint("RIGHT", showInTooltip, "RIGHT")
    showInTooltipCheckBox:SetHitRectInsets(0, 0, 0, 0)
    showInTooltipCheckBox:Raise()
    showInTooltipCheckBox.tiptext = TopFit.locale.StatsShowTooltipTooltip
    local checksound = showInTooltipCheckBox:GetScript("OnClick")
    showInTooltipCheckBox:SetScript("OnClick", function(self)
        checksound(self)
        local value = self:GetChecked()
        if (TopFit.selectedSet) then
            TopFit.db.profile.sets[TopFit.selectedSet].excludeFromTooltip = not TopFit.db.profile.sets[TopFit.selectedSet].excludeFromTooltip
        end
        TopFit:UpdateStatGroups()
    end)
    showInTooltip.updateData = function(self)
        if TopFit.selectedSet then
            showInTooltipCheckBox:SetChecked(not TopFit.db.profile.sets[TopFit.selectedSet].excludeFromTooltip)
        end
    end

    if playerClass == "SHAMAN" or playerClass == "WARRIOR" then
        i = i + 1
        local dualWield = CreateFrame("Button", statGroup:GetName().."Stat"..i, statGroup, "TopFitStatFrameTemplate")
        dualWield:SetPoint("TOPLEFT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMLEFT", 0, 0)
        dualWield:SetPoint("TOPRIGHT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMRIGHT", 0, 0)
        _G[dualWield:GetName().."Label"]:SetText(TopFit.locale.StatsEnableDualWield)
        _G[dualWield:GetName().."StatText"]:Hide()
        local dualWieldCheckBox, _ = LibStub("tekKonfig-Checkbox").new(dualWield, 16, nil, "TOP", dualWield, "TOP", 0, 1)
        dualWieldCheckBox:SetPoint("RIGHT", dualWield, "RIGHT")
        dualWieldCheckBox:SetHitRectInsets(0, 0, 0, 0)
        dualWieldCheckBox:Raise()
        dualWieldCheckBox.tiptext = TopFit.locale.StatsEnableDualWieldTooltip
        local checksound = dualWieldCheckBox:GetScript("OnClick")
        dualWieldCheckBox:SetScript("OnClick", function(self)
            checksound(self)
            local value = self:GetChecked()
            if (TopFit.selectedSet) then
                TopFit.db.profile.sets[TopFit.selectedSet].simulateDualWield = not TopFit.db.profile.sets[TopFit.selectedSet].simulateDualWield
            end
            TopFit:UpdateStatGroups()
        end)
        dualWield.updateData = function(self)
            if TopFit.selectedSet then
                dualWieldCheckBox:SetChecked(TopFit.db.profile.sets[TopFit.selectedSet].simulateDualWield)
            end
        end
    end
    if playerClass == "WARRIOR" then
        i = i + 1
        local titansGrip = CreateFrame("Button", statGroup:GetName().."Stat"..i, statGroup, "TopFitStatFrameTemplate")
        titansGrip:SetPoint("TOPLEFT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMLEFT", 0, 0)
        titansGrip:SetPoint("TOPRIGHT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMRIGHT", 0, 0)
        _G[titansGrip:GetName().."Label"]:SetText(TopFit.locale.StatsEnableTitansGrip)
        _G[titansGrip:GetName().."StatText"]:Hide()
        local titansGripCheckBox, _ = LibStub("tekKonfig-Checkbox").new(titansGrip, 16, nil, "TOP", titansGrip, "TOP", 0, 1)
        titansGripCheckBox:SetPoint("RIGHT", titansGrip, "RIGHT")
        titansGripCheckBox:SetHitRectInsets(0, 0, 0, 0)
        titansGripCheckBox:Raise()
        titansGripCheckBox.tiptext = TopFit.locale.StatsEnableTitansGripTooltip
        local checksound = titansGripCheckBox:GetScript("OnClick")
        titansGripCheckBox:SetScript("OnClick", function(self)
            checksound(self)
            local value = self:GetChecked()
            if (TopFit.selectedSet) then
                TopFit.db.profile.sets[TopFit.selectedSet].simulateTitansGrip = not TopFit.db.profile.sets[TopFit.selectedSet].simulateTitansGrip
            end
            TopFit:UpdateStatGroups()
        end)
        titansGrip.updateData = function(self)
            if TopFit.selectedSet then
                titansGripCheckBox:SetChecked(TopFit.db.profile.sets[TopFit.selectedSet].simulateTitansGrip)
            end
        end
    end
    if playerClass ~= "PRIEST" and playerClass ~= "WARLOCK" and playerClass ~= "MAGE" then
        i = i + 1
        local forceArmorType = CreateFrame("Button", statGroup:GetName().."Stat"..i, statGroup, "TopFitStatFrameTemplate")
        forceArmorType:SetPoint("TOPLEFT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMLEFT", 0, 0)
        forceArmorType:SetPoint("TOPRIGHT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMRIGHT", 0, 0)
        _G[forceArmorType:GetName().."Label"]:SetText(TopFit.locale.StatsForceArmorType)
        _G[forceArmorType:GetName().."StatText"]:Hide()
        local forceArmorTypeCheckBox, _ = LibStub("tekKonfig-Checkbox").new(forceArmorType, 16, nil, "TOP", forceArmorType, "TOP", 0, 1)
        forceArmorTypeCheckBox:SetPoint("RIGHT", forceArmorType, "RIGHT")
        forceArmorTypeCheckBox:SetHitRectInsets(0, 0, 0, 0)
        forceArmorTypeCheckBox:Raise()
        forceArmorTypeCheckBox.tiptext = TopFit.locale.StatsForceArmorTypeTooltip
        local checksound = forceArmorTypeCheckBox:GetScript("OnClick")
        forceArmorTypeCheckBox:SetScript("OnClick", function(self)
            checksound(self)
            local value = self:GetChecked()
            if (TopFit.selectedSet) then
                TopFit.db.profile.sets[TopFit.selectedSet].forceArmorType = not TopFit.db.profile.sets[TopFit.selectedSet].forceArmorType
            end
            TopFit:UpdateStatGroups()
        end)
        forceArmorType.updateData = function(self)
            if TopFit.selectedSet then
                forceArmorTypeCheckBox:SetChecked(TopFit.db.profile.sets[TopFit.selectedSet].forceArmorType)
            end
        end
    end
--[[
    statFrame = CreateFrame("Button", statGroup:GetName().."Stat"..i, statGroup, "TopFitStatFrameTemplate")
    statFrame:SetPoint("TOPLEFT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMLEFT", 0, 0)
    statFrame:SetPoint("TOPRIGHT", _G[statGroup:GetName().."Stat"..(i - 1)], "BOTTOMRIGHT", 0, 0)
    
    statFrame.statCode = statCode
    _G[statGroup:GetName().."Stat"..i.."Label"]:SetText(_G[statCode]..":")
    _G[statGroup:GetName().."Stat"..i.."StatText"]:SetText(TopFit:GetStatValue(TopFit.selectedSet, statCode))
]]
    TopFit:UpdateStatGroup(statGroup)
end

function TopFit:CalculateStatFrameHeight()
    local totalHeight = 0
    local i = 1

    while (_G["TopFitSidebarStatGroup"..i]) do
        totalHeight = totalHeight + _G["TopFitSidebarStatGroup"..i]:GetHeight() + 3
        i = i + 1
    end
    totalHeight = totalHeight + TopFitSidebarOptionsStatGroup:GetHeight() + 3

    TopFitSidebarFrameScrollChild:SetHeight(totalHeight)
end

function TopFit:SetDefaultCollapsedStates()
    local i = 1
    while (_G["TopFitSidebarStatGroup"..i]) do
        local statGroup = _G["TopFitSidebarStatGroup"..i]

        local subStats
        if statGroup.isSetsGroup then
            subStats = TopFit:GetAvailableItemSetNames()
        else
            subStats = TopFit.statList[statGroup.NameText:GetText()]
        end
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

    TopFit:CollapseStatGroup(TopFitSidebarOptionsStatGroup)
end

function TopFit:ToggleStatFrame(statFrame)
    if not statFrame.statCode then return end
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

function TopFit:SetCurrentCombination(combination)
    if not TopFitStatScrollFrame then return end

    if not combination then
        combination = {
            items = {},
            totalScore = 0,
            totalStats = {},
        }
    end

    TopFit:UpdateVirtualItemButtons(combination);

    --TopFit.ProgressFrame.setScoreFontString:SetText(string.format(TopFit.locale.SetScore, round(combination.totalScore, 2)))
    
    -- sort stats by score contribution
    statList = {}
    scorePerStat = {}
    for key, _ in pairs(combination.totalStats) do
        tinsert(statList, key)
    end
    
    local set
    local caps
    if not TopFit.selectedSet then
        set = {}
        caps = {}
    else
        set = TopFit.db.profile.sets[TopFit.selectedSet].weights
        caps = TopFit.db.profile.sets[TopFit.selectedSet].caps
    end
    
    table.sort(statList, function(a, b)
        local score1, score2 = 0, 0
        if set[a] and ((not caps) or (not caps[a]) or (not caps[a]["active"]) or (caps[a]["soft"])) then
            score1 = combination.totalStats[a] * set[a]
        end
        if set[b] and ((not caps) or (not caps[b]) or (not caps[b]["active"]) or (caps[b]["soft"])) then
            score2 = combination.totalStats[b] * set[b]
        end
        
        scorePerStat[a] = score1
        scorePerStat[b] = score2
        
        return score1 > score2
    end)
    
    local statScrollFrameContent = TopFitStatScrollFrameContent

    local statTexts = statScrollFrameContent.statNameFontStrings
    local valueTexts = statScrollFrameContent.statValueFontStrings
    local statusBars = statScrollFrameContent.statValueStatusBars
    local lastStat = 0
    local maxStatValue = statList[1] and scorePerStat[statList[1]] or 0
    
    if not statScrollFrameContent.statsHeader then
        statScrollFrameContent.statsHeader = statScrollFrameContent:CreateFontString(nil, nil, "GameFontNormalLarge")
        statScrollFrameContent.statsHeader:SetPoint("TOP", TopFitStatScrollFrame:GetScrollChild(), "TOP", 0, -5)
        statScrollFrameContent.statsHeader:SetPoint("LEFT", statScrollFrameContent, "LEFT", 3, 0)
        statScrollFrameContent.statsHeader:SetText(TopFit.locale.HeadingStats)
    end
    
    for i = 1, #statList do
        if (scorePerStat[statList[i]] ~= nil) and (scorePerStat[statList[i]] > 0) then
            lastStat = i
            if not statTexts[i] then
                -- create FontStrings
                -- fontsting for stat name
                statusBars[i] = CreateFrame("StatusBar", "TopFitStatValueBar"..i, statScrollFrameContent)
                statusBars[i]:SetHeight(14)
                statusBars[i]:SetStatusBarTexture(minimalist)
                
                statTexts[i] = statusBars[i]:CreateFontString(nil, nil, "GameFontHighlight")
                valueTexts[i] = statusBars[i]:CreateFontString(nil, nil, "NumberFontNormal")
                valueTexts[i]:SetPoint("RIGHT", statusBars[i])
                valueTexts[i]:SetPoint("LEFT", statusBars[i], "RIGHT", -40, 0)
                valueTexts[i]:SetJustifyH("RIGHT")
                statTexts[i]:SetPoint("LEFT", statusBars[i])
                statTexts[i]:SetPoint("RIGHT", valueTexts[i], "LEFT")
                statTexts[i]:SetJustifyH("LEFT")
                
                statusBars[i]:SetPoint("TOPLEFT", statusBars[i - 1] or statScrollFrameContent.statsHeader, "BOTTOMLEFT")
                statusBars[i]:SetPoint("RIGHT")
            end
            statTexts[i]:Show()
            valueTexts[i]:Show()
            statusBars[i]:Show()
            statTexts[i]:SetText(_G[statList[i]])
            valueTexts[i]:SetText(round(combination.totalStats[statList[i]], 1))
            statusBars[i]:SetMinMaxValues(0, maxStatValue)
            statusBars[i]:SetValue(scorePerStat[statList[i]])
            statusBars[i]:SetStatusBarColor(0.3, 1, 0.5, 0.5)
        end
    end
    for i = lastStat + 1, #statTexts do
        statTexts[i]:Hide()
        valueTexts[i]:Hide()
        statusBars[i]:Hide()
    end
    
    -- list for caps
    local i = 0
    local capNameTexts = statScrollFrameContent.capNameFontStrings
    local capValueTexts = statScrollFrameContent.capValueFontStrings
    
    if not statScrollFrameContent.capHeader then
        statScrollFrameContent.capHeader = statScrollFrameContent:CreateFontString(nil, nil, "GameFontNormalLarge")
        statScrollFrameContent.capHeader:SetText(TopFit.locale.HeadingCaps)
    end
    statScrollFrameContent.capHeader:Hide()
    
    for stat, capTable in pairs(caps) do
        if capTable.active then
            i = i + 1
            if not capNameTexts[i] then
                capNameTexts[i] = statScrollFrameContent:CreateFontString(nil, nil, "GameFontHighlight")
                capValueTexts[i] = statScrollFrameContent:CreateTexture()
                capValueTexts[i]:SetWidth(14)
                capValueTexts[i]:SetHeight(14)
                if i == 1 then
                    capNameTexts[i]:SetPoint("TOPLEFT", statScrollFrameContent.capHeader, "BOTTOMLEFT")
                    capValueTexts[i]:SetPoint("TOP", statScrollFrameContent.capHeader, "BOTTOM", 0, 2)
                    capValueTexts[i]:SetPoint("RIGHT", statScrollFrameContent, "RIGHT")
                else
                    capNameTexts[i]:SetPoint("TOPLEFT", capNameTexts[i - 1], 0, -12)
                    capValueTexts[i]:SetPoint("TOPRIGHT", capValueTexts[i - 1], 0, -12)
                end
            end
            capNameTexts[i]:SetText((_G[stat] or string.gsub(stat, "SET: ", "")))
            if (combination.totalStats[stat]) and (combination.totalStats[stat] >= capTable.value) then
                capValueTexts[i]:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready")
            else
                capValueTexts[i]:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady")
            end
            capNameTexts[i]:Show()
            capValueTexts[i]:Show()
            statScrollFrameContent.capHeader:Show()
        end
    end
    -- anchor to bottom of stat list
    if capNameTexts[1] then
        statScrollFrameContent.capHeader:SetPoint("TOPLEFT", statTexts[lastStat], "BOTTOMLEFT", 0, -20)
    end
    
    -- hide unused cap texts
    local numCaps = i
    for i = numCaps + 1, #capNameTexts do
        capNameTexts[i]:Hide()
        capValueTexts[i]:Hide()
    end
    
    -- creates a 20px spacing to the bottom, so all caps are always readable!
    if not statScrollFrameContent.placeHolder then
        statScrollFrameContent.placeHolder = CreateFrame("Frame", nil, statScrollFrameContent)
        statScrollFrameContent.placeHolder:SetHeight(20)
    end

    if numCaps > 0 then
        statScrollFrameContent.placeHolder:SetPoint("TOPLEFT", capNameTexts[numCaps], "BOTTOMLEFT")
    else
        statScrollFrameContent.placeHolder:SetPoint("TOPLEFT", statTexts[lastStat], "BOTTOMLEFT")
    end
    statScrollFrameContent.placeHolder:SetPoint("RIGHT")
end

function TopFit:UpdateVirtualItemButtons(combination)
    if not combination then
        combination = {
            items = {},
        }
    end

    for slotID, slotName in pairs(TopFit.slotNames) do
        local button = _G["TopFit"..slotName.."Button"]
        if not button then
            button = CreateFrame("Button", "TopFit"..slotName.."Button", TopFitStatScrollFrame, "TopFitVirtualItemButtonTemplate")
            button:SetPoint("TOPLEFT", "Character"..slotName, "TOPLEFT", -5, 5)
            button.itemButton = _G["Character"..slotName]
            _G["TopFit"..slotName.."ButtonNormalTexture"]:Hide()

            button.overlay:SetBlendMode("ADD")
            button.overlay:Hide()

            button.UpdateTooltip = function ()
                if button.itemLink then
                    GameTooltip:SetOwner(button, "ANCHOR_RIGHT", 6, -6)
                    GameTooltip:SetHyperlink(button.itemLink)
                    GameTooltip:Show()
                end
            end
        end

        button.itemLink = combination.items[slotID] and combination.items[slotID].itemLink
        
        -- set highlight if forced item
        if (TopFit.selectedSet) and 
            (TopFit.db.profile.sets[TopFit.selectedSet]) and
            #(TopFit:GetForcedItems(TopFit.selectedSet, slotID)) > 0 then
            button.overlay:SetVertexColor(0, 0.5, 1, 1)
            button.isForced = true
        else
            button.overlay:SetVertexColor(1, 1, 1, 0) -- transparent
            button.isForced = false
        end
        
        local itemTexture
        if button.itemLink and (button.isForced or true --[[or button.itemLink ~= button.itemButton.item]]) then -- an item was set, and there is information to show to the user
            --TODO: find a way to check if calculated and equipped item are the same, also update when equipping items
            itemTexture = select(10, GetItemInfo(combination.items[slotID].itemLink)) or "Interface\\Icons\\Inv_misc_questionmark"
            SetItemButtonTexture(button, itemTexture)
            button:Show()
        else                    -- no item set
            button:Hide()
        end
    end
end

function TopFit:GetAvailableItemSetNames()
    local setnames = {}
    for _, itemList in pairs(TopFit:GetEquippableItems()) do
        for _, locationTable in pairs(itemList) do
            local itemTable = TopFit:GetCachedItem(locationTable.itemLink)
            if itemTable then
                for stat, _ in pairs(itemTable.itemBonus) do
                    if (string.find(stat, "SET: ")) then
                        TopFit:InsertIntoItemSetNames(stat, setnames)
                    end
                end
            end
        end
    end

    -- also add sets that might have been added in one of the player's TopFit sets
    for _, setTable in pairs(TopFit.db.profile.sets) do
        for statCode, _ in pairs(setTable.weights) do
            if (string.find(statCode, "SET: ")) then
                TopFit:InsertIntoItemSetNames(statCode, setnames)
            end
        end
        for statCode, _ in pairs(setTable.caps) do
            if (string.find(statCode, "SET: ")) then
                TopFit:InsertIntoItemSetNames(statCode, setnames)
            end
        end
    end

    return setnames
end

function TopFit:InsertIntoItemSetNames(statCode, setNames)
    --local setname = string.gsub(statCode, "SET: (.*)", "%1")
    local setname = statCode
    
    -- check if set was added already
    local found = false
    for _, setname2 in pairs(setNames) do
        if setname == setname2 then found = true break end
    end
    
    if not found then tinsert(setNames, setname) end
end

function TopFit:ShowItemPopoutButtons()
    for slotID, slotName in pairs(TopFit.slotNames) do
        local popoutButton = _G['TopFit'..slotName..'PoupoutButton'];
        if not popoutButton then
            popoutButton = CreateFrame('Button', 'TopFit'..slotName..'PoupoutButton', _G['Character'..slotName], 'TopFitItemPopoutButtonTemplate')

            if ( _G['Character'..slotName].verticalFlyout ) then
                popoutButton:SetHeight(16);
                popoutButton:SetWidth(38);

                popoutButton:GetNormalTexture():SetTexCoord(0.15625, 0.84375, 0.5, 0);
                popoutButton:GetHighlightTexture():SetTexCoord(0.15625, 0.84375, 1, 0.5);
                popoutButton:ClearAllPoints();
                popoutButton:SetPoint("TOP", _G['Character'..slotName], "BOTTOM", 0, 4);
            else
                popoutButton:SetHeight(38);
                popoutButton:SetWidth(16);

                popoutButton:GetNormalTexture():SetTexCoord(0.15625, 0.5, 0.84375, 0.5, 0.15625, 0, 0.84375, 0);
                popoutButton:GetHighlightTexture():SetTexCoord(0.15625, 1, 0.84375, 1, 0.15625, 0.5, 0.84375, 0.5);
                popoutButton:ClearAllPoints();
                popoutButton:SetPoint("LEFT", _G['Character'..slotName], "RIGHT", -8, 0);
            end

            _G['Character'..slotName].topFitPopoutButton = popoutButton

            popoutButton:RegisterForClicks("LeftButtonUp");
            popoutButton:SetScript("OnClick", function()
                if TopFitItemFlyout:IsShown() and TopFitItemFlyout.button == _G['Character'..slotName] then
                    TopFit:HideFlyout()
                else
                    if TopFitItemFlyout.button then
                        TopFit:ReversePopoutButton(TopFitItemFlyout.button.topFitPopoutButton, false)
                    end
                    TopFit:ShowFlyout(_G['Character'..slotName], slotID)
                end
            end)
        end
        popoutButton:Show()
    end
end

function TopFit:HideItemPopoutButtons()
    for slotID, slotName in pairs(TopFit.slotNames) do
        local popoutButton = _G['TopFit'..slotName..'PoupoutButton'];
        if popoutButton then popoutButton:Hide() end
    end
end

function TopFit:ReversePopoutButton(button, reverse)
    if not button then return end
    if (button:GetParent().verticalFlyout) then
        if (reverse) then
            button:GetNormalTexture():SetTexCoord(0.15625, 0.84375, 0, 0.5)
            button:GetHighlightTexture():SetTexCoord(0.15625, 0.84375, 0.5, 1)
        else
            button:GetNormalTexture():SetTexCoord(0.15625, 0.84375, 0.5, 0)
            button:GetHighlightTexture():SetTexCoord(0.15625, 0.84375, 1, 0.5)
        end
    else
        if (reverse) then
            button:GetNormalTexture():SetTexCoord(0.15625, 0, 0.84375, 0, 0.15625, 0.5, 0.84375, 0.5)
            button:GetHighlightTexture():SetTexCoord(0.15625, 0.5, 0.84375, 0.5, 0.15625, 1, 0.84375, 1)
        else
            button:GetNormalTexture():SetTexCoord(0.15625, 0.5, 0.84375, 0.5, 0.15625, 0, 0.84375, 0)
            button:GetHighlightTexture():SetTexCoord(0.15625, 1, 0.84375, 1, 0.15625, 0.5, 0.84375, 0.5)
        end
    end
end

function TopFit:ShowFlyout(itemButton, slotID)

    local flyout = TopFitItemFlyout
    local buttons = flyout.buttons
    local buttonAnchor = flyout.buttonFrame
    flyout.button = itemButton

    local popoutButton = itemButton.topFitPopoutButton
    if popoutButton.flyoutLocked then
        popoutButton.flyoutLocked = false
        PaperDollFrameItemPopoutButton_SetReversed(popoutButton, false)
    end

    TopFit:ReversePopoutButton(TopFitItemFlyout.button.topFitPopoutButton, true)

    local itemList = TopFit:GetEquippableItems(slotID)

    local numNormalItems = #itemList;

    --check for forced items that are not in itemList - they'll need a button, too
    local forcedItems = TopFit:GetForcedItems(TopFit.selectedSet, slotID)
    local missingForcedItems = {}
    for _, itemID in pairs(forcedItems) do
        local found = false
        for _, item in pairs(itemList) do
            local cachedItem = TopFit:GetCachedItem(item.itemLink);
            if (cachedItem.itemID == itemID) then
                found = true
                break
            end
        end

        if not found then
            tinsert(missingForcedItems, itemID)
        end
    end

    local numMissingForcedItems = #missingForcedItems
    local numItems = numNormalItems + numMissingForcedItems

    while #buttons < numItems do -- Create any buttons we need.
        TopFit:CreateFlyoutButton()
    end

    if (numItems == 0) then
        flyout:Hide()
        return
    end

    for i, button in ipairs(buttons) do
        if (i <= numNormalItems) then
            button.id = slotID
            button.item = itemList[i]
            button:Show()
            button:GetNormalTexture():SetDesaturated(false)
            button.isForced:Hide()

            local cachedItem = TopFit:GetCachedItem(button.item.itemLink)
            button.itemID = cachedItem.itemID
            for _, forcedItem in pairs(forcedItems) do
                if cachedItem.itemID == forcedItem then
                    button.isForced:Show()
                end
            end

            TopFit:DisplayFlyoutButton(button)
        elseif (i <= numItems) then
            button.id = slotID
            button.item = nil
            button:Show()
            button:GetNormalTexture():SetDesaturated(true)
            button.isForced:Show()
            button.itemID = missingForcedItems[i - numNormalItems]

            TopFit:DisplayFlyoutButton(button)
        else
            button:Hide();
        end
    end

    flyout:ClearAllPoints();
    flyout:SetFrameLevel(itemButton:GetFrameLevel() - 1);
    flyout.button = itemButton;
    flyout:SetPoint("TOPLEFT", itemButton, "TOPLEFT", -EQUIPMENTFLYOUT_BORDERWIDTH, EQUIPMENTFLYOUT_BORDERWIDTH);
    local horizontalItems = min(numItems, EQUIPMENTFLYOUT_ITEMS_PER_ROW);
    if itemButton.verticalFlyout then
        buttonAnchor:SetPoint("TOPLEFT", itemButton.topFitPopoutButton, "BOTTOMLEFT", 0, -EQUIPMENTFLYOUT_BORDERWIDTH);
    else
        buttonAnchor:SetPoint("TOPLEFT", itemButton.topFitPopoutButton, "TOPRIGHT", 0, 0);
    end
    buttonAnchor:SetWidth((horizontalItems * EFITEM_WIDTH) + ((horizontalItems - 1) * EFITEM_XOFFSET) + EQUIPMENTFLYOUT_BORDERWIDTH);
    buttonAnchor:SetHeight(EQUIPMENTFLYOUT_HEIGHT + (math.floor((numItems - 1)/EQUIPMENTFLYOUT_ITEMS_PER_ROW) * (EFITEM_HEIGHT - EFITEM_YOFFSET)));

    local function _createFlyoutBG (buttonAnchor)
        local numBGs = buttonAnchor["numBGs"];
        numBGs = numBGs + 1;
        local texture = buttonAnchor:CreateTexture(nil, nil, "EquipmentFlyoutTexture");
        buttonAnchor["bg" .. numBGs] = texture;
        buttonAnchor["numBGs"] = numBGs;
        return texture;
    end

    if flyout.numItems ~= numItems then
        local texturesUsed = 0;
        if numItems == 1 then
            local bgTex, lastBGTex;
            bgTex = buttonAnchor.bg1;
            bgTex:ClearAllPoints();
            bgTex:SetTexCoord(unpack(EQUIPMENTFLYOUT_ONESLOT_LEFT_COORDS));
            bgTex:SetWidth(EQUIPMENTFLYOUT_ONESLOT_LEFTWIDTH);
            bgTex:SetHeight(EQUIPMENTFLYOUT_ONEROW_HEIGHT);
            bgTex:SetPoint("TOPLEFT", -5, 4);
            bgTex:Show();
            texturesUsed = texturesUsed + 1;
            lastBGTex = bgTex;

            bgTex = buttonAnchor.bg2 or _createFlyoutBG(buttonAnchor);
            bgTex:ClearAllPoints();
            bgTex:SetTexCoord(unpack(EQUIPMENTFLYOUT_ONESLOT_RIGHT_COORDS));
            bgTex:SetWidth(EQUIPMENTFLYOUT_ONESLOT_RIGHTWIDTH);
            bgTex:SetHeight(EQUIPMENTFLYOUT_ONEROW_HEIGHT);
            bgTex:SetPoint("TOPLEFT", lastBGTex, "TOPRIGHT");
            bgTex:Show();
            texturesUsed = texturesUsed + 1;
            lastBGTex = bgTex;
        elseif ( numItems <= EQUIPMENTFLYOUT_ITEMS_PER_ROW ) then
            local bgTex, lastBGTex;
            bgTex = buttonAnchor.bg1;
            bgTex:ClearAllPoints();
            bgTex:SetTexCoord(unpack(EQUIPMENTFLYOUT_ONEROW_LEFT_COORDS));
            bgTex:SetWidth(EQUIPMENTFLYOUT_ONEROW_LEFT_WIDTH);
            bgTex:SetHeight(EQUIPMENTFLYOUT_ONEROW_HEIGHT);
            bgTex:SetPoint("TOPLEFT", -5, 4);
            bgTex:Show();
            texturesUsed = texturesUsed + 1;
            lastBGTex = bgTex;
            for i = texturesUsed + 1, numItems - 1 do
                bgTex = buttonAnchor["bg"..i] or _createFlyoutBG(buttonAnchor);
                bgTex:ClearAllPoints();
                bgTex:SetTexCoord(unpack(EQUIPMENTFLYOUT_ONEROW_CENTER_COORDS));
                bgTex:SetWidth(EQUIPMENTFLYOUT_ONEROW_CENTER_WIDTH);
                bgTex:SetHeight(EQUIPMENTFLYOUT_ONEROW_HEIGHT);
                bgTex:SetPoint("TOPLEFT", lastBGTex, "TOPRIGHT");
                bgTex:Show();
                texturesUsed = texturesUsed + 1;
                lastBGTex = bgTex;
            end

            bgTex = buttonAnchor["bg"..numItems] or _createFlyoutBG(buttonAnchor);
            bgTex:ClearAllPoints();
            bgTex:SetTexCoord(unpack(EQUIPMENTFLYOUT_ONEROW_RIGHT_COORDS));
            bgTex:SetWidth(EQUIPMENTFLYOUT_ONEROW_RIGHT_WIDTH);
            bgTex:SetHeight(EQUIPMENTFLYOUT_ONEROW_HEIGHT);
            bgTex:SetPoint("TOPLEFT", lastBGTex, "TOPRIGHT");
            bgTex:Show();
            texturesUsed = texturesUsed + 1;
        elseif ( numItems > EQUIPMENTFLYOUT_ITEMS_PER_ROW ) then
            local numRows = math.ceil(numItems/EQUIPMENTFLYOUT_ITEMS_PER_ROW);
            local bgTex, lastBGTex;
            bgTex = buttonAnchor.bg1;
            bgTex:ClearAllPoints();
            bgTex:SetTexCoord(unpack(EQUIPMENTFLYOUT_MULTIROW_TOP_COORDS));
            bgTex:SetWidth(EQUIPMENTFLYOUT_MULTIROW_WIDTH);
            bgTex:SetHeight(EQUIPMENTFLYOUT_MULTIROW_TOP_HEIGHT);
            bgTex:SetPoint("TOPLEFT", -5, 4);
            bgTex:Show();
            texturesUsed = texturesUsed + 1;
            lastBGTex = bgTex;
            for i = 2, numRows - 1 do -- Middle rows
                bgTex = buttonAnchor["bg"..i] or _createFlyoutBG(buttonAnchor);
                bgTex:ClearAllPoints();
                bgTex:SetTexCoord(unpack(EQUIPMENTFLYOUT_MULTIROW_MIDDLE_COORDS));
                bgTex:SetWidth(EQUIPMENTFLYOUT_MULTIROW_WIDTH);
                bgTex:SetHeight(EQUIPMENTFLYOUT_MULTIROW_MIDDLE_HEIGHT);
                bgTex:SetPoint("TOPLEFT", lastBGTex, "BOTTOMLEFT");
                bgTex:Show();
                texturesUsed = texturesUsed + 1;
                lastBGTex = bgTex;
            end

            bgTex = buttonAnchor["bg"..numRows] or _createFlyoutBG(buttonAnchor);
            bgTex:ClearAllPoints();
            bgTex:SetTexCoord(unpack(EQUIPMENTFLYOUT_MULTIROW_BOTTOM_COORDS));
            bgTex:SetWidth(EQUIPMENTFLYOUT_MULTIROW_WIDTH);
            bgTex:SetHeight(EQUIPMENTFLYOUT_MULTIROW_BOTTOM_HEIGHT);
            bgTex:SetPoint("TOPLEFT", lastBGTex, "BOTTOMLEFT");
            bgTex:Show();
            texturesUsed = texturesUsed + 1;
            lastBGTex = bgTex;
        end

        for i = texturesUsed + 1, buttonAnchor["numBGs"] do
            buttonAnchor["bg" .. i]:Hide();
        end
        flyout.numItems = numItems;
    end

    flyout:Show();
end

function TopFit:CreateFlyoutButton()
    local buttons = TopFitItemFlyout.buttons
    local buttonAnchor = TopFitItemFlyoutButtons
    local numButtons = #buttons

    local button = CreateFrame("BUTTON", "TopFitItemFlyoutButtons" .. numButtons + 1, buttonAnchor, "TopFitItemFlyoutButtonTemplate")

    local pos = numButtons / EQUIPMENTFLYOUT_ITEMS_PER_ROW
    if (math.floor(pos) == pos) then
        -- This is the first button in a row.
        button:SetPoint("TOPLEFT", buttonAnchor, "TOPLEFT", EQUIPMENTFLYOUT_BORDERWIDTH, -EQUIPMENTFLYOUT_BORDERWIDTH - (EFITEM_HEIGHT - EFITEM_YOFFSET) * pos)
    else
        button:SetPoint("TOPLEFT", buttons[numButtons], "TOPRIGHT", EFITEM_XOFFSET, 0)
    end
    button.isForced:SetBlendMode("ADD")
    button.isForced:SetVertexColor(0, 1, 0)

    tinsert(buttons, button)
    return button
end

function TopFit:DisplayFlyoutButton(button)
    local itemTable = button.item
    local textureName
    if (not itemTable) then
        textureName = select(10, GetItemInfo(button.itemID))
    else
        textureName = select(10, GetItemInfo(itemTable.itemLink))
    end

    SetItemButtonTexture(button, textureName);

    button.UpdateTooltip = function ()
        GameTooltip:SetOwner(TopFitItemFlyoutButtons, "ANCHOR_RIGHT", 6, -TopFitItemFlyoutButtons:GetHeight() - 6)
        if (button.item) then
            GameTooltip:SetHyperlink(button.item.itemLink)
        else
            GameTooltip:SetText(TopFit.locale.missingForcedItemTooltip);
        end
        GameTooltip:Show()
    end

    if button:IsMouseOver() then
        button.UpdateTooltip()
    end
end

function TopFit:HideFlyout()
    TopFitItemFlyout:Hide()
    if TopFitItemFlyout.button then
        TopFit:ReversePopoutButton(TopFitItemFlyout.button.topFitPopoutButton, false)
    end
end