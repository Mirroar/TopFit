local function CreateHeaderButton(text, name, parent)
    local button = CreateFrame("Button", name, parent)
    button:SetFrameLevel(button:GetFrameLevel() + 4)

    button.left = button:CreateTexture("$parentLeft", "BACKGROUND")
    button.left:SetWidth(5) button.left:SetHeight(19)
    button.left:SetPoint("TOPLEFT", 0, 5)
    button.left:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
    button.left:SetTexCoord(0, 0.078125, 0, 0.59375)

    button.right = button:CreateTexture("$parentRight", "BACKGROUND")
    button.right:SetWidth(4) button.right:SetHeight(19)
    button.right:SetPoint("TOPRIGHT", 0, 5)
    button.right:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
    button.right:SetTexCoord(0.90625, 0.96875, 0, 0.59375)

    button.middle = button:CreateTexture("$parentMiddle", "BACKGROUND")
    button.middle:SetWidth(10) button.middle:SetHeight(19)
    button.middle:SetPoint("LEFT", "$parentLeft", "RIGHT")
    button.middle:SetPoint("RIGHT", "$parentRight", "LEFT")
    button.middle:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
    button.middle:SetTexCoord(0.078125, 0.90625, 0, 0.59375)
    
    button.text = button:CreateFontString("$parentText", nil, "GameFontHighlightSmall")
    button.text:SetPoint("LEFT", 8, 0)
    button.text:SetText(text)
    
    button.arrow = button:CreateTexture("$parentArrow")
    button.arrow:SetWidth(9) button.arrow:SetHeight(8)
    button.arrow:SetPoint("LEFT", "$parentText", "RIGHT", 3, -2)
    button.arrow:SetTexture("Interface\\Buttons\\UI-SortArrow")
    button.arrow:SetTexCoord(0, 0.5625, 0, 1.0)
    button.arrow:Hide()
    
    button:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight", "ADD")
    local hilite = button:GetHighlightTexture()
    hilite:ClearAllPoints()
    hilite:SetPoint("LEFT", 0, 0)
    hilite:SetPoint("RIGHT", 4, 0)
    hilite:SetWidth(5) hilite:SetHeight(24)
    
    return button
end

function TopFit:CreateStatsPlugin()
    local statsFrame, pluginId = TopFit:RegisterPlugin(TopFit.locale.Stats, "Interface\\Icons\\Ability_Druid_BalanceofPower", TopFit.locale.StatsTooltip)
    
    local title = statsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -4)
    title:SetText(TopFit.locale.Stats)
    
    local explain = statsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    explain:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -10, -8)
    explain:SetPoint("RIGHT", statsFrame, -4, 0)
    explain:SetHeight(55)
    explain:SetNonSpaceWrap(true)
    explain:SetJustifyH("LEFT")
    explain:SetJustifyV("TOP")
    explain:SetText(TopFit.locale.StatsExplanation)
    
    -- set options
    local enable = LibStub("tekKonfig-Checkbox").new(statsFrame, nil, TopFit.locale.StatsShowTooltip, "TOPLEFT", explain, "BOTTOMLEFT", 10, -4)
    enable.tiptext = TopFit.locale.StatsShowTooltipTooltip
    if (TopFit.ProgressFrame and TopFit.ProgressFrame.selectedSet) then
        enable:SetChecked(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].excludeFromTooltip)
    end
    local checksound = enable:GetScript("OnClick")
    enable:SetScript("OnClick", function(self)
        checksound(self)
        if (TopFit.ProgressFrame.selectedSet) then
            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].excludeFromTooltip = not TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].excludeFromTooltip
        end
    end)
    statsFrame.includeInTooltipCheckButton = enable
    
    -- option to simulate dualwielding / titan's grip
    local extraButton
    if select(2, UnitClass("player")) == "SHAMAN" then
        extraButton = LibStub("tekKonfig-Checkbox").new(statsFrame, nil, TopFit.locale.StatsEnableDualWield, "TOPLEFT", enable, "BOTTOMLEFT", 0, -2)
        extraButton.tiptext = TopFit.locale.StatsEnableDualWieldTooltip
        if TopFit.ProgressFrame and TopFit.ProgressFrame.selectedSet then
            extraButton:SetChecked(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].simulateDualWield)
        end
        local checksound = extraButton:GetScript("OnClick")
        extraButton:SetScript("OnClick", function(self)
            checksound(self)
            if (TopFit.ProgressFrame.selectedSet) then
                TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].simulateDualWield = not TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].simulateDualWield
            end
        end)
        statsFrame.simulateDualWieldCheckButton = extraButton
    elseif select(2, UnitClass("player")) == "WARRIOR" then
        extraButton = LibStub("tekKonfig-Checkbox").new(statsFrame, nil, TopFit.locale.StatsEnableTitansGrip, "TOPLEFT", enable, "BOTTOMLEFT", 0, -2)
        extraButton.tiptext = TopFit.locale.StatsEnableTitansGripTooltip
        if TopFit.ProgressFrame and TopFit.ProgressFrame.selectedSet then
            extraButton:SetChecked(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].simulateTitansGrip)
        end
        local checksound = extraButton:GetScript("OnClick")
        extraButton:SetScript("OnClick", function(self)
            checksound(self)
            if (TopFit.ProgressFrame.selectedSet) then
                TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].simulateTitansGrip = not TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].simulateTitansGrip
            end
        end)
        statsFrame.simulateTitansGripCheckButton = extraButton
    end
    
    local usage = statsFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    usage:SetPoint("TOPLEFT", extraButton or enable, "BOTTOMLEFT", -10, -4)
    usage:SetPoint("RIGHT", statsFrame, -4, 0)
    usage:SetHeight(55)
    usage:SetNonSpaceWrap(true)
    usage:SetJustifyH("LEFT")
    usage:SetJustifyV("TOP")
    usage:SetText(TopFit.locale.StatsUsage)
    
    statsFrame.panel = LibStub("tekKonfig-Group").new(statsFrame, TopFit.locale.StatsPanelLabel)
    statsFrame.panel:SetPoint("BOTTOMRIGHT", statsFrame, -2, 2)
    statsFrame.panel:SetPoint("TOPLEFT", usage, "BOTTOMLEFT", 0, -10)
    statsFrame.panel:SetHeight(250)
    
    statsFrame.statDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_statDropDown", statsFrame, "UIDropDownMenuTemplate")
    UIDropDownMenu_Initialize(statsFrame.statDropDown, function(self, level)
        level = level or 1
        local info = UIDropDownMenu_CreateInfo()
        if (level == 1) then
            TopFit:collectItems()
            local info = UIDropDownMenu_CreateInfo();
            info.hasArrow = false; -- no submenu
            info.notCheckable = true;
            info.text = "Add stat...";
            info.isTitle = true;
            UIDropDownMenu_AddButton(info, level);
            
            for categoryName, statTable in pairs(TopFit.statList) do
                local info = UIDropDownMenu_CreateInfo();
                info.hasArrow = true;
                info.notCheckable = true;
                info.text = categoryName;
                info.isTitle = false;
                info.value = categoryName
                UIDropDownMenu_AddButton(info, level);
            end
            
            -- submenu for set pieces
            local info = UIDropDownMenu_CreateInfo();
            info.hasArrow = true;
            info.notCheckable = true;
            info.text = TopFit.locale.StatsSetPiece;
            info.isTitle = false;
            info.value = "setpieces"
            UIDropDownMenu_AddButton(info, level);
        elseif level == 2 then
            local parentValue = UIDROPDOWNMENU_MENU_VALUE
            
            if parentValue == "setpieces" then
                -- check all items' set names
                local setnames = {}
                for _, itemList in pairs(TopFit:GetEquippableItems()) do
                    for _, locationTable in pairs(itemList) do
                        local itemTable = TopFit:GetCachedItem(locationTable.itemLink)
                        if itemTable then
                            for stat, _ in pairs(itemTable.itemBonus) do
                                if (string.find(stat, "SET: ")) then
                                    local setname = string.gsub(stat, "SET: (.*)", "%1")
                                    
                                    -- check if set was added already
                                    local found = false
                                    for _, setname2 in pairs(setnames) do
                                        if setname == setname2 then found = true break end
                                    end
                                    
                                    if not found then tinsert(setnames, setname) end
                                end
                            end
                        end
                    end
                end
                
                table.sort(setnames)
                local i
                for i = 1, #setnames do
                    local info = UIDropDownMenu_CreateInfo();
                    info.hasArrow = false;
                    info.notCheckable = true;
                    info.text = setnames[i];
                    info.isTitle = false;
                    info.isChecked = false;
                    info.value = setnames[i]
                    info.func = function(...)
                        TopFit:Debug("Adding stat: "..info.value)
                        if (TopFit.ProgressFrame.selectedSet) then
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights["SET: "..setnames[i]] = 0
                        end
                        statsFrame:UpdateSetStats()
                        TopFit:CalculateScores()
                    end
                    UIDropDownMenu_AddButton(info, level);
                end
            else
                -- normal values
                for key, value in pairs(TopFit.statList[parentValue]) do
                    local info = UIDropDownMenu_CreateInfo();
                    info.hasArrow = false;
                    info.notCheckable = true;
                    info.text = _G[value];
                    info.isTitle = false;
                    info.isChecked = false;
                    info.value = value
                    info.func = function(...)
                        TopFit:Debug("Adding stat: "..value)
                        if (TopFit.ProgressFrame.selectedSet) then
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[value] = 0
                        end
                        statsFrame:UpdateSetStats()
                        TopFit:CalculateScores()
                    end
                    UIDropDownMenu_AddButton(info, level);
                end
            end
        end
    end, "MENU")
    UIDropDownMenu_JustifyText(statsFrame.statDropDown, "LEFT")
    
    statsFrame.addStatButton = CreateFrame("Button", nil, statsFrame, "UIPanelButtonTemplate")
    statsFrame.addStatButton:SetPoint("BOTTOMRIGHT", statsFrame.panel, "TOPRIGHT", -2, 0)
    statsFrame.addStatButton:SetText(TopFit.locale.StatsAdd)
    statsFrame.addStatButton:SetHeight(22)
    statsFrame.addStatButton:SetWidth(80)
    statsFrame.addStatButton:RegisterForClicks("AnyUp")
    statsFrame.addStatButton:SetScript("OnClick", function(self, button)
        ToggleDropDownMenu(1, nil, statsFrame.statDropDown, self, -20, 0)
    end)
    
    local headerName = CreateHeaderButton(TopFit.locale.StatsHeaderName, "TopFit_StatsHeader_Name", statsFrame.panel)
    headerName.width = 185
    headerName:SetPoint("TOPLEFT", 2, -7)
    headerName:SetWidth(headerName.width); headerName:SetHeight(10)
    TopFit.db.profile.statSortOrder = "NameAsc"
    
    local headerValue = CreateHeaderButton(TopFit.locale.StatsHeaderValue, "TopFit_StatsHeader_Value", statsFrame.panel)
    headerValue.width = 55
    headerValue:SetPoint("TOPLEFT", headerName, "TOPRIGHT")
    headerValue:SetWidth(headerValue.width); headerValue:SetHeight(10)
    
    local headerCap = CreateHeaderButton(TopFit.locale.StatsHeaderCap, "TopFit_StatsHeader_Cap", statsFrame.panel)
    headerCap.width = 44
    headerCap:SetPoint("TOPLEFT", headerValue, "TOPRIGHT")
    headerCap:SetWidth(headerCap.width); headerCap:SetHeight(10)
    
    local function SortStats(self)
        local order = TopFit.db.profile.statSortOrder
        local orderBy
        if self == headerCap then
            orderBy = "Cap"
        elseif self == headerValue then
            orderBy = "Value"
        else
            orderBy = "Name"
        end
        
        if order == orderBy.."Asc" then
            TopFit.db.profile.statSortOrder = orderBy.."Desc"
        else
            TopFit.db.profile.statSortOrder = orderBy.."Asc"
        end
        
        statsFrame:UpdateSetStats()
    end
    headerName:SetScript("OnClick", SortStats)
    headerValue:SetScript("OnClick", SortStats)
    headerCap:SetScript("OnClick", SortStats)
    
    statsFrame.scrollFrame = CreateFrame("ScrollFrame", "TopFit_EditScrollFrame", statsFrame, "UIPanelScrollFrameTemplate")
    statsFrame.scrollFrame:SetPoint("TOPLEFT", headerName, "BOTTOMLEFT", 4, -4)
    statsFrame.scrollFrame:SetPoint("BOTTOMRIGHT", statsFrame.panel, -27, 4)
    statsFrame.scrollFrame.content = CreateFrame("Frame", nil, statsFrame.scrollFrame)
    statsFrame.scrollFrame.content:SetHeight(225)
    statsFrame.scrollFrame.content:SetWidth(280)
    statsFrame.scrollFrame.content:SetAllPoints()
    statsFrame.scrollFrame:SetScrollChild(statsFrame.scrollFrame.content)
    
    -- containers for stat list
    statsFrame.statEntry = {}
    
    function statsFrame:UpdateSetStats()
        local sortableStatWeightTable = {}
        if TopFit.ProgressFrame.selectedSet then
            -- little fix: set values for active caps to 0 if they are nil, so they are always shown
            for stat, capTable in pairs(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps) do
                if capTable.active and TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[stat] == nil then
                    TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[stat] = 0
                end
            end
            
            for stat, value in pairs(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights) do
                table.insert(sortableStatWeightTable, {stat, value})
            end
        end
        
        table.sort(sortableStatWeightTable, function(a,b)
            local order = TopFit.db.profile.statSortOrder
            
            local nameA = _G[a[1]] or a[1]
            local nameB = _G[b[1]] or b[1]
            
            if order == "NameAsc" then
                return nameA < nameB
            elseif order == "NameDesc" then
                return nameA > nameB
                
            elseif order == "ValueAsc" then
                return a[2] < b[2]
            elseif order == "ValueDesc" then
                return a[2] > b[2]
                
            elseif order == "CapAsc" then
                -- capped stats first, then ordered by name
                local a_capped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[a[1]]
                local b_capped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[b[1]]
                if (a_capped and a_capped.active) and (b_capped and b_capped.active) then
                    return nameA < nameB
                elseif a_capped and a_capped.active then
                    return true
                elseif b_capped and b_capped.active then
                    return false
                else
                    return nameA < nameB
                end
            elseif order == "CapDesc" then
                -- capped stats last, then ordered by name
                local a_capped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[a[1]]
                local b_capped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[b[1]]
                if (a_capped and a_capped.active) and (b_capped and b_capped.active) then
                    return nameA < nameB
                elseif a_capped and a_capped.active then
                    return false
                elseif b_capped and b_capped.active then
                    return true
                else
                    return nameA < nameB
                end
            else
                return a[1] < b[1]
            end
        end)
        
        local lineHeight = 14
        for i, data in ipairs(sortableStatWeightTable) do
            local stat = data[1]
            local value = data[2]
            local isCapped = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat] and TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].active
            
            if not statsFrame.statEntry[i] then
                -- create new stat line
                local entry = CreateFrame("Frame", "TopFit_StatEntry"..i, statsFrame.scrollFrame.content)
                entry:EnableMouse(true)
                
                local hoverBackground = entry:CreateTexture("$parentHover", "BACKGROUND")
                hoverBackground:SetTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                hoverBackground:SetPoint("TOPLEFT")
                hoverBackground:SetPoint("BOTTOMRIGHT", entry, "TOPRIGHT", 0, -lineHeight)
                hoverBackground:Hide()
                entry:SetScript("OnEnter", function(self) hoverBackground:Show() end)
                entry:SetScript("OnLeave", function(self) hoverBackground:Hide() end)
                
                entry.statName = entry:CreateFontString(nil, nil, "GameFontNormalSmall")
                entry.statName:SetJustifyH("LEFT")
                entry.statName:SetPoint("TOPLEFT")
                entry.statName:SetPoint("BOTTOMRIGHT", entry, "TOPLEFT", headerName.width - 4, -lineHeight)
                
                entry.statValue = CreateFrame("EditBox", nil, entry)
                entry.statValue:SetPoint("TOPLEFT")
                entry.statValue:SetPoint("BOTTOMRIGHT", entry, "TOPLEFT", headerName.width + headerValue.width - 8, -lineHeight)
                entry.statValue:SetAutoFocus(false)
                entry.statValue:SetFontObject("GameFontHighlightSmall")
                entry.statValue:SetJustifyH("RIGHT")
                
                -- scripts
                entry.statValue:SetScript("OnEnter", function(self) _G[self:GetParent():GetName().."Hover"]:Show() end)
                entry.statValue:SetScript("OnLeave", function(self) _G[self:GetParent():GetName().."Hover"]:Hide() end)
                entry.statValue:SetScript("OnEditFocusGained", entry.statValue.HighlightText)
                local function EditBoxFocusLost(self)
                    local stat = self:GetParent().stat
                    if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[stat] then
                        self:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[stat])
                    end
                    self:ClearFocus()
                end
                entry.statValue:SetScript("OnEditFocusLost", EditBoxFocusLost)
                entry.statValue:SetScript("OnEscapePressed", EditBoxFocusLost)
                entry.statValue:SetScript("OnEnterPressed", function(self)
                    local value = tonumber(self:GetText())  -- save new stat value if it is numeric
                    local stat = self:GetParent().stat
                    if stat and value then
                        if value == 0 then value = nil end  -- used for removing stats from the list
                        TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[stat] = value
                    else
                        TopFit:Debug("invalid input")
                    end
                    EditBoxFocusLost(self)
                    statsFrame:UpdateSetStats()
                    TopFit:CalculateScores()
                end)
                
                entry.statCapped = CreateFrame("CheckButton", nil, entry, "UICheckButtonTemplate")
                entry.statCapped:SetWidth(lineHeight+4); entry.statCapped:SetHeight(lineHeight+4)
                entry.statCapped:SetPoint("CENTER", entry, "TOPLEFT", headerName.width + headerValue.width - 4 + headerCap.width/2, -lineHeight/2)
                
                entry.statCapped:SetScript("OnClick", function(self)
                    local stat = self:GetParent().stat
                    if not TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat] then
                        -- create new cap
                        TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat] = {
                            active = true,
                            soft = false,
                            value = 0,
                        }
                    else
                        if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].active then
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].active = false
                        else
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].active = true
                        end
                    end
                    
                    statsFrame:UpdateSetStats()
                    TopFit:CalculateScores()
                end)
                
                if i == 1 then
                    entry:SetPoint("TOPLEFT", statsFrame.scrollFrame.content, 0, -2)
                else
                    entry:SetPoint("TOPLEFT", statsFrame.statEntry[i - 1], "BOTTOMLEFT", 0, 0)
                end
                entry:SetPoint("RIGHT", statsFrame.scrollFrame.content)
                
                statsFrame.statEntry[i] = entry
            end
            
            local entry = statsFrame.statEntry[i]
            -- update with new data
            entry.stat = stat
            entry.statName:SetText(_G[stat] or string.gsub(stat, "SET: ", TopFit.locale.StatsSet))
            entry.statValue:SetText(value)
            entry.statCapped:SetChecked(isCapped)
            
            if isCapped then
                entry:SetHeight(2*lineHeight)
                if not entry.capValue then
                    -- add an extra line for cap settings
                    entry.capValue = CreateFrame("EditBox", nil, entry)
                    entry.capValue:SetAutoFocus(false)
                    entry.capValue:SetFontObject("GameFontHighlightSmall")
                    entry.capValue:SetJustifyH("RIGHT")
                    entry.capValue:SetPoint("TOPLEFT", headerName.width, -lineHeight)
                    entry.capValue:SetPoint("BOTTOMRIGHT", entry, "TOPLEFT", headerName.width + headerValue.width - 8, -2*lineHeight)
                    entry.capValue.bg = entry.capValue:CreateTexture(nil, "BACKGROUND")
                    entry.capValue.bg:SetTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                    entry.capValue.bg:SetAllPoints()
                    entry.capValue.bg:Hide()
                    entry.capValue:SetScript("OnEnter", function(self) self.bg:Show() end)
                    entry.capValue:SetScript("OnLeave", function(self) self.bg:Hide() end)
                    entry.capValue:SetScript("OnEditFocusGained", entry.capValue.HighlightText)
                    local function EditBox2FocusLost(self)
                        local stat = self:GetParent().stat
                        local value = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].value
                        self:SetText(value)
                        self:ClearFocus()
                    end
                    entry.capValue:SetScript("OnEditFocusLost", EditBox2FocusLost)
                    entry.capValue:SetScript("OnEscapePressed", EditBox2FocusLost)
                    entry.capValue:SetScript("OnEnterPressed", function(self)
                        local value = tonumber(self:GetText())  -- save new stat value if it is numeric
                        local stat = self:GetParent().stat
                        if stat and value then
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].value = value
                        end
                        EditBox2FocusLost(self)
                        statsFrame:UpdateSetStats()
                        TopFit:CalculateScores()
                    end)
                    
                    entry.capType = CreateFrame("Button", nil, entry)
                    entry.capType:SetPoint("TOPLEFT", headerName.width + headerValue.width, -lineHeight)
                    entry.capType:SetPoint("BOTTOMRIGHT")
                    
                    entry.capType.bg = entry.capType:CreateTexture(nil, "BACKGROUND")
                    entry.capType.bg:SetTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                    entry.capType.bg:SetAllPoints()
                    entry.capType.bg:Hide()
                    entry.capType:SetScript("OnEnter", function(self)
                        TopFit.ShowTooltip(self)
                        entry.capType.bg:Show()
                    end)
                    entry.capType:SetScript("OnLeave", function(self)
                        TopFit.HideTooltip(self)
                        entry.capType.bg:Hide()
                    end)
                    entry.capType:SetScript("OnClick", function(self)
                        local stat = self:GetParent().stat
                        if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].soft then
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].soft = false
                        else
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].soft = true
                        end
                        statsFrame:UpdateSetStats()
                    end)
                    entry.capTypeText = entry.capType:CreateFontString(nil, nil, "GameFontHighlightSmall")
                    entry.capTypeText:SetAllPoints()
                    entry.capTypeText:SetJustifyH("CENTER")
                end
                entry.capValue:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].value)
                entry.capValue:Show()
                
                entry.capTypeText:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].soft and TopFit.locale.StatsCapSoft or TopFit.locale.StatsCapHard)
                entry.capType:Show()
            else
                entry:SetHeight(lineHeight)
                if entry.capValue then
                    entry.capValue:Hide()
                    entry.capType:Hide()
                end
            end
            
            entry:Show()
        end
        
        -- hide excess entries
        for i = #sortableStatWeightTable+1, #statsFrame.statEntry do
            statsFrame.statEntry[i]:Hide()
        end
    end
    
    -- event handlers
    TopFit.RegisterCallback("TopFit_stats", "OnShow", function(event, id)
        if (id == pluginId) then
            statsFrame:UpdateSetStats()
        end
    end)
    
    TopFit.RegisterCallback("TopFit_stats", "OnSetChanged", function(event, setId)
        if (setId) then
            -- enable inputs
            statsFrame.addStatButton:Enable()
            statsFrame.includeInTooltipCheckButton:Enable()
            statsFrame.includeInTooltipCheckButton:SetChecked(not TopFit.db.profile.sets[setId].excludeFromTooltip)
            if (statsFrame.simulateDualWieldCheckButton) then
                statsFrame.simulateDualWieldCheckButton:Enable()
                statsFrame.simulateDualWieldCheckButton:SetChecked(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].simulateDualWield)
            end
            if (statsFrame.simulateTitansGripCheckButton) then
                statsFrame.simulateTitansGripCheckButton:Enable()
                statsFrame.simulateTitansGripCheckButton:SetChecked(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].simulateTitansGrip)
            end
        else
            -- no set selected, disable inputs
            statsFrame.addStatButton:Disable()
            statsFrame.includeInTooltipCheckButton:Disable()
            if (StatsFrame.simulateDualWieldCheckButton) then
                statsFrame.simulateDualWieldCheckButton:Disable()
            end
            if (statsFrame.simulateTitansGripCheckButton) then
                statsFrame.simulateTitansGripCheckButton:Disable()
            end
        end
        statsFrame:UpdateSetStats()
    end)
end
