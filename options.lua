function TopFit:createOptions()
    if not TopFit.InterfaceOptionsFrame then
        TopFit.InterfaceOptionsFrame = CreateFrame("Frame", "TopFit_InterfaceOptionsFrame", InterfaceOptionsFramePanelContainer)
        TopFit.InterfaceOptionsFrame.name = "TopFit"
        TopFit.InterfaceOptionsFrame:Hide()
        
        local title, subtitle = LibStub("tekKonfig-Heading").new(TopFit.InterfaceOptionsFrame, "TopFit", TopFit.locale.SubTitle)
        
        -- Show Tooltip Checkbox
        local showTooltip = LibStub("tekKonfig-Checkbox").new(TopFit.InterfaceOptionsFrame, nil, TopFit.locale.ShowTooltipScores, "TOPLEFT", subtitle, "BOTTOMLEFT", -2, 0)
        showTooltip.tiptext = TopFit.locale.ShowTooltipScoresTooltip
        showTooltip:SetChecked(TopFit.db.profile.showTooltip)
        local checksound = showTooltip:GetScript("OnClick")
        showTooltip:SetScript("OnClick", function(self)
            checksound(self)
            TopFit.db.profile.showTooltip = not TopFit.db.profile.showTooltip
        end)
        
        -- Show Comparison Tooltip Checkbox
        local showComparisonTooltip = LibStub("tekKonfig-Checkbox").new(TopFit.InterfaceOptionsFrame, nil, TopFit.locale.ShowTooltipComparison, "TOPLEFT", showTooltip, "BOTTOMLEFT", 0, 0)
        showComparisonTooltip.tiptext = TopFit.locale.ShowTooltipComparisonTooltip
        showComparisonTooltip:SetChecked(TopFit.db.profile.showComparisonTooltip)
        local checksound = showComparisonTooltip:GetScript("OnClick")
        showComparisonTooltip:SetScript("OnClick", function(self)
            checksound(self)
            TopFit.db.profile.showComparisonTooltip = not TopFit.db.profile.showComparisonTooltip
        end)
        
        -- Auto Update Set Dropdown
        local autoUpdateSet, autoUpdateSetText, autoUpdateSetContainer = LibStub("tekKonfig-Dropdown").new(TopFit.InterfaceOptionsFrame, TopFit.locale.AutoUpdateSet, "TOPLEFT", showComparisonTooltip, "BOTTOMLEFT", 0, 0)
        if (TopFit.db.profile.defaultUpdateSet) and (TopFit.db.profile.sets[TopFit.db.profile.defaultUpdateSet]) then
            autoUpdateSetText:SetText(TopFit.db.profile.sets[TopFit.db.profile.defaultUpdateSet].name)
        else
            autoUpdateSetText:SetText(TopFit.locale.None)
        end
        autoUpdateSet.tiptext = TopFit.locale.AutoUpdateSetTooltip
        
        UIDropDownMenu_Initialize(autoUpdateSet, function()
            local info = UIDropDownMenu_CreateInfo()
            info.text = TopFit.locale.None
            info.notCheckable = true
            info.value = "none"
            info.func = function(self)
                UIDropDownMenu_SetSelectedValue(autoUpdateSet, self.value)
                autoUpdateSetText:SetText(TopFit.locale.None)
                TopFit.db.profile.defaultUpdateSet = nil
            end
            UIDropDownMenu_AddButton(info)
            
            for setCode, setTable in pairs(TopFit.db.profile.sets or {}) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = setTable.name
                info.value = setCode
                info.notCheckable = true
                info.func = function(self)
                    UIDropDownMenu_SetSelectedValue(autoUpdateSet, self.value)
                    autoUpdateSetText:SetText(TopFit.db.profile.sets[self.value].name)
                    TopFit.db.profile.defaultUpdateSet = self.value
                end
                UIDropDownMenu_AddButton(info)
            end
        end)
        
        -- Auto Update Set 2 Dropdown
        local autoUpdateSet2, autoUpdateSetText2, autoUpdateSetContainer2 = LibStub("tekKonfig-Dropdown").new(TopFit.InterfaceOptionsFrame, TopFit.locale.AutoUpdateSet.." 2", "TOPLEFT", autoUpdateSetContainer, "BOTTOMLEFT", 0, 0)
        if (TopFit.db.profile.defaultUpdateSet2) and (TopFit.db.profile.sets[TopFit.db.profile.defaultUpdateSet2]) then
            autoUpdateSetText2:SetText(TopFit.db.profile.sets[TopFit.db.profile.defaultUpdateSet2].name)
        else
            autoUpdateSetText2:SetText(TopFit.locale.None)
        end
        autoUpdateSet2.tiptext = TopFit.locale.AutoUpdateSetTooltip
        
        UIDropDownMenu_Initialize(autoUpdateSet2, function()
            local info = UIDropDownMenu_CreateInfo()
            info.text = TopFit.locale.None
            info.value = "none"
            info.notCheckable = true
            info.func = function(self)
                UIDropDownMenu_SetSelectedValue(autoUpdateSet2, self.value)
                autoUpdateSetText2:SetText(TopFit.locale.None)
                TopFit.db.profile.defaultUpdateSet2 = nil
            end
            UIDropDownMenu_AddButton(info)
            
            for setCode, setTable in pairs(TopFit.db.profile.sets or {}) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = setTable.name
                info.value = setCode
                info.notCheckable = true
                info.func = function(self)
                    UIDropDownMenu_SetSelectedValue(autoUpdateSet2, self.value)
                    autoUpdateSetText2:SetText(TopFit.db.profile.sets[self.value].name)
                    TopFit.db.profile.defaultUpdateSet2 = self.value
                end
                UIDropDownMenu_AddButton(info)
            end
        end)
        
        -- Debug Mode Checkbox
        local debugMode = LibStub("tekKonfig-Checkbox").new(TopFit.InterfaceOptionsFrame, nil, TopFit.locale.Debug, "TOPLEFT", showComparisonTooltip, "BOTTOMLEFT", 0, -130)
        debugMode.tiptext = TopFit.locale.DebugTooltip
        debugMode:SetChecked(TopFit.db.profile.debugMode)
        local checksound = debugMode:GetScript("OnClick")
        debugMode:SetScript("OnClick", function(self)
            checksound(self)
            TopFit.db.profile.debugMode = not TopFit.db.profile.debugMode
        end)
        
        InterfaceOptions_AddCategory(TopFit.InterfaceOptionsFrame)
        LibStub("tekKonfig-AboutPanel").new("TopFit", "TopFit")
        
        TopFit.InterfaceOptionsFrame:SetScript("OnShow", function()
            showTooltip:SetChecked(TopFit.db.profile.showTooltip)
            if (TopFit.db.profile.defaultUpdateSet) and (TopFit.db.profile.sets[TopFit.db.profile.defaultUpdateSet]) then
                autoUpdateSetText:SetText(TopFit.db.profile.sets[TopFit.db.profile.defaultUpdateSet].name)
            else
                autoUpdateSetText:SetText(TopFit.locale.None)
            end
            debugMode:SetChecked(TopFit.db.profile.debugMode)
        end)
    end
end

function TopFit:AddSet(preset)
    local i = 1
    while  TopFit.db.profile.sets["set_"..i] do i = i + 1 end
    
    local setName
    local weights = {}
    local caps = {}
    if preset then
        TopFit.debug = preset
        setName = preset.name
        for key, value in pairs(preset.weights) do
            weights[key] = value
        end
        for key, value in pairs(preset.caps) do
            caps[key] = {}
            for key2, value2 in pairs(value) do
                caps[key][key2] = value2
            end
        end
    else
        setName = "Set "..i
    end
    
    -- check if set name is already taken, generate a unique one in that case
    if (TopFit:HasSet(setName)) then
        local newSetName = "2-"..setName
        local k = 2
        while TopFit:HasSet(newSetName) do
            k = k + 1
            newSetName = k.."-"..setName
        end
        setName = newSetName
    end
    
    TopFit.db.profile.sets["set_"..i] = {
        name = setName,
        weights = weights,
        caps = caps,
        forced = {}
    }
    
    if TopFit.ProgressFrame then
        TopFit.ProgressFrame:SetSelectedSet("set_"..i)
    end
    
    -- precalculate item scores for this set
    TopFit:CalculateScores()
    
    return "set_"..i
end

function TopFit:HasSet(setName)
    for setCode, setTable in pairs(TopFit.db.profile.sets) do
        if (setTable.name == setName) then
            return true
        end
    end
    return false
end

function TopFit:DeleteSet(setCode)
    local setName = TopFit:GenerateSetName(self.db.profile.sets[setCode].name)
    
    -- remove from equipment manager
    if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(setName)) then
        DeleteEquipmentSet(setName)
    end
    
    -- remove from saved variables
    self.db.profile.sets[setCode] = nil
    
    -- remove automatic update set if necessary
    if self.db.profile.defaultUpdateSet == setCode then
        self.db.profile.defaultUpdateSet = nil
    end
    if self.db.profile.defaultUpdateSet2 == setCode then
        self.db.profile.defaultUpdateSet2 = nil
    end
    
    if (TopFit.ProgressFrame) then
        TopFit.ProgressFrame:SetSelectedSet()
        TopFit.ProgressFrame:SetCurrentCombination()
        TopFit.ProgressFrame:SetSetName(TopFit.locale.SetName)
    end
end

function TopFit:RenameSet(setCode, newName)
    oldSetName = TopFit:GenerateSetName(self.db.profile.sets[setCode].name)
    
    -- check if set name is already taken, generate a unique one in that case
    if (TopFit:HasSet(newName) and not newName == TopFit.db.profile.sets[setCode].name) then
        local newSetName = "2-"..newName
        local k = 2
        while TopFit:HasSet(newSetName) do
            k = k + 1
            newSetName = k.."-"..newName
        end
        newName = newSetName
    end
    
    newSetName = TopFit:GenerateSetName(newName)

    -- rename in saved variables
    self.db.profile.sets[setCode].name = newName
    
    -- rename equipment set if it exists
    if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(oldSetName)) then
        ModifyEquipmentSet(oldSetName, newSetName)
    end
    
    TopFit:SetSelectedSet(TopFit.selectedSet)

    --TODO: remove when progress frame is removed
    if (TopFit.ProgressFrame) then
        -- update setname if it is selected
        if UIDropDownMenu_GetSelectedValue(TopFit.ProgressFrame.setDropDown) == setCode then
            UIDropDownMenu_SetSelectedName(TopFit.ProgressFrame.setDropDown, newName)
        end
    end
end



function TopFit:GetStatValue(setCode, statCode)
    if not setCode or not statCode then return 0 end
    local result = TopFit.db.profile.sets[setCode].weights[statCode] or 0
    return result
end

function TopFit:GetCapValue(setCode, statCode)
    if not setCode or not statCode then return 0 end
    if TopFit.db.profile.sets[setCode].caps[statCode] then
        return TopFit.db.profile.sets[setCode].caps[statCode].value or 0
    else
        return 0
    end
end

function TopFit:GetAfterCapStatValue(setCode, statCode)
    if not setCode or not statCode then return 0 end
    if TopFit.db.profile.sets[setCode].caps[statCode] then
        return TopFit.db.profile.sets[setCode].caps[statCode].statValueAfter or 0
    else
        return 0
    end
end

function TopFit:IsCapActive(setCode, statCode)
    if not setCode or not statCode then return false end
    if TopFit.db.profile.sets[setCode].caps[statCode] then
        return TopFit.db.profile.sets[setCode].caps[statCode].active or false
    else
        return false
    end
end

function TopFit:SetStatValue(setCode, statCode, value)
    TopFit.db.profile.sets[setCode].weights[statCode] = value
end

function TopFit:SetCapValue(setCode, statCode, value)
    TopFit:InitializeCapTable(setCode, statCode)
    TopFit.db.profile.sets[setCode].caps[statCode].value = value
end

function TopFit:SetAfterCapStatValue(setCode, statCode, value)
    TopFit:InitializeCapTable(setCode, statCode)
    TopFit.db.profile.sets[setCode].caps[statCode].statValueAfter = value
end

function TopFit:SetCapActive(setCode, statCode, value)
    TopFit:InitializeCapTable(setCode, statCode)
    TopFit.db.profile.sets[setCode].caps[statCode].active = value
end

function TopFit:InitializeCapTable(setCode, statCode)
    if not TopFit.db.profile.sets[setCode].caps[statCode] then
        TopFit.db.profile.sets[setCode].caps[statCode] = {
            value = 0,
            active = false,
            statValueAfter = 0
        }
    end
end

function TopFit:GetForcedItems(setCode, slotID)
    if not TopFit.db.profile.sets[setCode].forced then
        return {}
    elseif not TopFit.db.profile.sets[setCode].forced[slotID] then
        return {}
    elseif type(TopFit.db.profile.sets[setCode].forced[slotID]) ~= "table" then
        TopFit.db.profile.sets[setCode].forced[slotID] = {TopFit.db.profile.sets[setCode].forced[slotID]}
    end
    return TopFit.db.profile.sets[setCode].forced[slotID]
end

function TopFit:AddForcedItem(setCode, slotID, itemID)
    if not TopFit.db.profile.sets[setCode].forced then
        TopFit.db.profile.sets[setCode].forced = {}
    end
    if not TopFit.db.profile.sets[setCode].forced[slotID] then
        TopFit.db.profile.sets[setCode].forced[slotID] = {itemID}
    else
        tinsert(TopFit.db.profile.sets[setCode].forced[slotID], itemID)
    end
end

function TopFit:RemoveForcedItem(setCode, slotID, itemID)
    if TopFit.db.profile.sets[setCode].forced then
        if TopFit.db.profile.sets[setCode].forced[slotID] then
            for i, forcedItem in ipairs(TopFit.db.profile.sets[setCode].forced[slotID]) do
                if forcedItem == itemID then
                    tremove(TopFit.db.profile.sets[setCode].forced[slotID], i)
                    break
                end
            end
        end
    end
end

