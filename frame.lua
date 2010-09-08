local minimalist = [=[Interface\AddOns\TopFit\media\minimalist]=]

function TopFit:CreateProgressFrame()
    if not TopFit.ProgressFrame then
        -- actual frame
        
        --[[--
        --              Left part of Panel
        --]]--
        
        TopFit.ProgressFrame = CreateFrame("Frame", "TopFit_ProgressFrame", UIParent)
        tinsert(UISpecialFrames, "TopFit_ProgressFrame")
        TopFit.ProgressFrame:SetToplevel(true)
        TopFit.ProgressFrame:ClearAllPoints()
        TopFit.ProgressFrame:SetPoint("CENTER")
        TopFit.ProgressFrame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            tileSize = 32,
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = 1,
            edgeSize = 32,
            insets={ top = 12, right = 12, left = 11, bottom = 11}
        })
        TopFit.ProgressFrame:SetHeight(460)
        TopFit.ProgressFrame:SetWidth(344)
        TopFit.ProgressFrame:EnableMouse(true)
        local titleRegion = TopFit.ProgressFrame:CreateTitleRegion()
        titleRegion:SetAllPoints(TopFit.ProgressFrame)
        
        -- the most important thing: the close-button
        TopFit.ProgressFrame.closeButton = CreateFrame("Button", "TopFit_ProgressFrame_closeButton", TopFit.ProgressFrame, "UIPanelCloseButton")
        TopFit.ProgressFrame.closeButton:SetWidth(30)
        TopFit.ProgressFrame.closeButton:SetHeight(30)
        TopFit.ProgressFrame.closeButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPRIGHT", -4, -4)
        TopFit.ProgressFrame.closeButton:SetScript("OnClick", function(...) TopFit:HideProgressFrame() end)
        
        -- set selection
        TopFit.ProgressFrame.setDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_setDropDown", TopFit.ProgressFrame, "UIDropDownMenuTemplate")
        TopFit.ProgressFrame.setDropDown:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame, "TOPLEFT", 55-20, -100)
        TopFit.ProgressFrame.setDropDown:SetWidth(240)
        _G["TopFit_ProgressFrame_setDropDownMiddle"]:SetWidth(205)
        _G["TopFit_ProgressFrame_setDropDownButton"]:SetWidth(220)
        
        -- select set label
        TopFit.ProgressFrame.selectSetLabel = TopFit.ProgressFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        TopFit.ProgressFrame.selectSetLabel:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.setDropDown, "TOPLEFT", 20, 4)
        TopFit.ProgressFrame.selectSetLabel:SetNonSpaceWrap(true)
        TopFit.ProgressFrame.selectSetLabel:SetJustifyH("LEFT")
        TopFit.ProgressFrame.selectSetLabel:SetJustifyV("TOP")
        TopFit.ProgressFrame.selectSetLabel:SetText(TopFit.locale.SelectSet)
        
        UIDropDownMenu_Initialize(TopFit.ProgressFrame.setDropDown, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            for k, v in pairs(TopFit.db.profile.sets) do
                if not TopFit.ProgressFrame.selectedSet then
                    TopFit.ProgressFrame.selectedSet = k
                end
                info = UIDropDownMenu_CreateInfo()
                info.text = v.name
                info.value = k
                info.func = function(self)
                    TopFit.ProgressFrame:SetSelectedSet(self.value)
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end)
        UIDropDownMenu_SetSelectedID(TopFit.ProgressFrame.setDropDown, 1)
        UIDropDownMenu_JustifyText(TopFit.ProgressFrame.setDropDown, "LEFT")
        
        -- progress bar
        TopFit.ProgressFrame.progressBar = CreateFrame("StatusBar", "TopFit_ProgressFrame_StatusBar", TopFit.ProgressFrame)
        TopFit.ProgressFrame.progressBar:SetPoint("TOPLEFT", TopFit.ProgressFrame.setDropDown, 22, -5)
        TopFit.ProgressFrame.progressBar:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame.setDropDown, -4, 9)
        TopFit.ProgressFrame.progressBar:SetStatusBarTexture(minimalist)
        TopFit.ProgressFrame.progressBar:SetMinMaxValues(0, 100)
        TopFit.ProgressFrame.progressBar:SetStatusBarColor(0, 1, 0, 1)
        TopFit.ProgressFrame.progressBar:Hide()
        
        -- progress text
        TopFit.ProgressFrame.progressText = TopFit.ProgressFrame.progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        TopFit.ProgressFrame.progressText:SetAllPoints()
        TopFit.ProgressFrame.progressText:SetText("0.00%")
        
        
        -- add set button
        TopFit.ProgressFrame.addSetButton = CreateFrame("Button", "TopFit_ProgressFrame_addSetButton", TopFit.ProgressFrame)
        TopFit.ProgressFrame.addSetButton:SetPoint("LEFT", TopFit.ProgressFrame.setDropDown, "RIGHT", 2, 2)
        TopFit.ProgressFrame.addSetButton:SetHeight(24)
        TopFit.ProgressFrame.addSetButton:SetWidth(24)
        TopFit.ProgressFrame.addSetButton:SetNormalTexture("Interface\\Icons\\Spell_chargepositive")
        TopFit.ProgressFrame.addSetButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        
        -- set selection for add set button
        TopFit.ProgressFrame.addSetButton.setDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_addSetButton_setDropDown", TopFit.ProgressFrame.addSetButton, "UIDropDownMenuTemplate")
        UIDropDownMenu_Initialize(TopFit.ProgressFrame.addSetButton.setDropDown, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.hasArrow = false; -- no submenu
            info.notCheckable = true;
            info.text = TopFit.locale.EmptySet
            info.value = 0
            info.func = function(self)
                TopFit:AddSet()
                TopFit:CalculateScores()
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
                    TopFit:CalculateScores()
                    --TopFit.ProgressFrame:SetCurrentCombination()
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end, "MENU")
        
        TopFit.ProgressFrame.addSetButton:SetScript("OnClick", function(self)
            ToggleDropDownMenu(1, nil, TopFit.ProgressFrame.addSetButton.setDropDown, self, 0, 0)
        end)
        TopFit.ProgressFrame.addSetButton.tipText = TopFit.locale.AddSetTooltip
        TopFit.ProgressFrame.addSetButton:SetScript("OnEnter", TopFit.ShowTooltip)
        TopFit.ProgressFrame.addSetButton:SetScript("OnLeave", TopFit.HideTooltip)
        
        -- delete set button
        TopFit.ProgressFrame.deleteSetButton = CreateFrame("Button", "TopFit_ProgressFrame_deleteSetButton", TopFit.ProgressFrame)
        TopFit.ProgressFrame.deleteSetButton:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.addSetButton, "BOTTOMRIGHT", 4, 0)
        TopFit.ProgressFrame.deleteSetButton:SetHeight(24)
        TopFit.ProgressFrame.deleteSetButton:SetWidth(24)
        TopFit.ProgressFrame.deleteSetButton:SetNormalTexture("Interface\\Icons\\Spell_chargenegative")
        TopFit.ProgressFrame.deleteSetButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        
        TopFit.ProgressFrame.deleteSetButton:SetScript("OnClick", function(...)
            -- on first click: mark red
            if not TopFit.ProgressFrame.deleteSetButton.firstClick then
                if not TopFit.ProgressFrame.deleteSetButton.redHightlight then
                    TopFit.ProgressFrame.deleteSetButton.redHightlight = TopFit.ProgressFrame.deleteSetButton:CreateTexture("$parent_higlightTexture")
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetTexture("Interface\\Buttons\\CheckButtonHilight")
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetAllPoints()
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetBlendMode("ADD")
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetDrawLayer("OVERLAY")
                    TopFit.ProgressFrame.deleteSetButton.redHightlight:SetVertexColor(1, 0, 0, 1)
                end
                TopFit.ProgressFrame.deleteSetButton.redHightlight:Show();
                TopFit.ProgressFrame.deleteSetButton.firstClick = true
            else
                -- on second click: delete set
                TopFit:DeleteSet(TopFit.ProgressFrame.selectedSet)
                TopFit.ProgressFrame.deleteSetButton.redHightlight:Hide();
                TopFit.ProgressFrame.deleteSetButton.firstClick = false
            end
        end)
        TopFit.ProgressFrame.deleteSetButton.tipText = TopFit.locale.DeleteSetTooltip
        TopFit.ProgressFrame.deleteSetButton:SetScript("OnEnter", TopFit.ShowTooltip)
        TopFit.ProgressFrame.deleteSetButton:SetScript("OnLeave", function() TopFit.HideTooltip() if TopFit.ProgressFrame.deleteSetButton.redHightlight then TopFit.ProgressFrame.deleteSetButton.redHightlight:Hide(); TopFit.ProgressFrame.deleteSetButton.firstClick = false end end)
        
        -- abort button
        TopFit.ProgressFrame.abortButton = CreateFrame("Button", "TopFit_ProgressFrame_abortButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.abortButton:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame, "BOTTOMLEFT", 344 - 16, 16)TopFit.ProgressFrame.abortButton:SetText(TopFit.locale.Abort)
        TopFit.ProgressFrame.abortButton:SetHeight(22)
        TopFit.ProgressFrame.abortButton:SetWidth(80)
        TopFit.ProgressFrame.abortButton:Hide()
        TopFit.ProgressFrame.abortButton:SetScript("OnClick", TopFit.AbortCalculations)
        
        -- start button
        TopFit.ProgressFrame.startButton = CreateFrame("Button", "TopFit_ProgressFrame_startButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.startButton:SetAllPoints(TopFit.ProgressFrame.abortButton)
        TopFit.ProgressFrame.startButton:SetText(TopFit.locale.Start)
        TopFit.ProgressFrame.startButton:SetScript("OnClick", function(...)
            if not TopFit.isBlocked then
                if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet] then
                    TopFit.workSetList = { TopFit.ProgressFrame.selectedSet }
                    TopFit:CalculateSets()
                end
            end
        end)
        
        -- options button
        --[[TopFit.ProgressFrame.optionsButton = CreateFrame("Button", "TopFit_ProgressFrame_optionsButton", TopFit.ProgressFrame)
        TopFit.ProgressFrame.optionsButton:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame, 16, 16)
        TopFit.ProgressFrame.optionsButton:SetHeight(32)
        TopFit.ProgressFrame.optionsButton:SetWidth(32)
        TopFit.ProgressFrame.optionsButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Gear_02")
        TopFit.ProgressFrame.optionsButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")]]
        
        TopFit.ProgressFrame.optionsButton = CreateFrame("Button", "TopFit_ProgressFrame_optionsButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.optionsButton:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame, 16, 16)
        TopFit.ProgressFrame.optionsButton:SetHeight(22)
        TopFit.ProgressFrame.optionsButton:SetWidth(80)
        TopFit.ProgressFrame.optionsButton:SetText(TopFit.locale.Options)
        TopFit.ProgressFrame.optionsButton:SetScript("OnClick", function(...)
            InterfaceOptionsFrame_OpenToCategory("TopFit")
            -- TopFit.ProgressFrame:Hide()
        end)
        TopFit.ProgressFrame.optionsButton.tipText = TopFit.locale.OpenOptionsTooltip
        TopFit.ProgressFrame.optionsButton:SetScript("OnEnter", TopFit.ShowTooltip)
        TopFit.ProgressFrame.optionsButton:SetScript("OnLeave", TopFit.HideTooltip)
        
        -- expand / contract button
        TopFit.ProgressFrame.expandButton = CreateFrame("Button", "TopFit_ProgressFrame_expandButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.expandButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPLEFT", 344 - 16, -32)
        TopFit.ProgressFrame.expandButton:SetText(">>")
        TopFit.ProgressFrame.expandButton:SetHeight(22)
        TopFit.ProgressFrame.expandButton:SetWidth(80)
        TopFit.ProgressFrame.expandButton:SetScript("OnClick", function(...)
            if TopFit.ProgressFrame.isExpanded then
                TopFit.ProgressFrame.expandButton:SetText(">>")
                TopFit.ProgressFrame.isExpanded = false
                TopFit.ProgressFrame.pluginContainer:Hide()
                TopFit.ProgressFrame:SetWidth(TopFit.ProgressFrame:GetWidth() / 2)
            else
                TopFit.ProgressFrame.expandButton:SetText("<<")
                TopFit.ProgressFrame.isExpanded = true
                TopFit.ProgressFrame.pluginContainer:Show()
                TopFit.ProgressFrame:SetWidth(TopFit.ProgressFrame:GetWidth() * 2)
            end
        end)
        
        function TopFit.ProgressFrame:ResetProgress()
            TopFit.ProgressFrame.progress = nil
            TopFit.ProgressFrame.startButton:Hide()
            TopFit.ProgressFrame.setDropDown:Hide()
            TopFit.ProgressFrame.addSetButton:Hide()
            TopFit.ProgressFrame.deleteSetButton:Hide()
            TopFit.ProgressFrame.abortButton:Show()
            TopFit.ProgressFrame.progressBar:Show()
        end
        function TopFit.ProgressFrame:StoppedCalculation()
            TopFit.ProgressFrame.startButton:Show()
            TopFit.ProgressFrame.setDropDown:Show()
            TopFit.ProgressFrame.addSetButton:Show()
            TopFit.ProgressFrame.deleteSetButton:Show()
            TopFit.ProgressFrame.abortButton:Hide()
            TopFit.ProgressFrame.progressBar:Hide()
        end
        function TopFit.ProgressFrame:SetProgress(progress)
            if (TopFit.ProgressFrame.progress == nil) or (TopFit.ProgressFrame.progress < progress) then
                TopFit.ProgressFrame.progress = progress
                TopFit.ProgressFrame.progressText:SetText(round(progress * 100, 2).."%")
                TopFit.ProgressFrame.progressBar:SetValue(progress * 100)
            end
        end
        
        -- centered scrollframe for stats summary
        local scrollFrameHeight, scrollFrameWidth = 312, 230 - 20
        TopFit.ProgressFrame.statScrollFrame = CreateFrame("ScrollFrame", "TopFit_ScoreBoard", TopFit.ProgressFrame, "UIPanelScrollFrameTemplate")
        TopFit.ProgressFrame.statScrollFrame:SetWidth(scrollFrameWidth)
        TopFit.ProgressFrame.statScrollFrame:SetHeight(scrollFrameHeight)
        TopFit.ProgressFrame.statScrollFrame:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame, 55, 50)
        local statScrollFrameContent = CreateFrame("Frame", nil, TopFit.ProgressFrame.statScrollFrame)
        statScrollFrameContent:SetAllPoints()
        statScrollFrameContent:SetHeight(scrollFrameHeight)
        statScrollFrameContent:SetWidth(scrollFrameWidth)
        TopFit.ProgressFrame.statScrollFrame:SetScrollChild(statScrollFrameContent)
        
        local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            tile = true,
            tileSize = 32,
            insets = { left = 0, right = -22, top = 0, bottom = 0 }}
        TopFit.ProgressFrame.statScrollFrame:SetBackdrop(backdrop)
        TopFit.ProgressFrame.statScrollFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
        TopFit.ProgressFrame.statScrollFrame:SetBackdropColor(0.1, 0.1, 0.1)
        
        -- equipment buttons
        TopFit.ProgressFrame.equipButtons = {}
        for _, slotName in ipairs(TopFit.slotList) do
            local slotID, emptyTexture, isRelic = GetInventorySlotInfo(slotName)
            local button = CreateFrame("Button", "TopFit_"..slotName.."Button", TopFit.ProgressFrame, "ItemButtonTemplate")
            button:Raise()
            button:SetID(slotID)
            button.backgroundTextureName = emptyTexture
            button.checkRelic = isRelic
            
            -- create extra highlight texture for marking purposes
            button.highlightTexture = button:CreateTexture("$parent_higlightTexture")
            button.highlightTexture:SetTexture("Interface\\Buttons\\CheckButtonHilight")
            button.highlightTexture:SetAllPoints()
            button.highlightTexture:SetBlendMode("ADD")
            button.highlightTexture:SetDrawLayer("OVERLAY")
            button.highlightTexture:SetVertexColor(1, 1, 1, 0)
            
            button:SetScript("OnEnter", TopFit.ShowTooltip)
            button:SetScript("OnLeave", function (...)
                TopFit.HideTooltip()
                if TopFit.ProgressFrame.forceItemsFrame then
                    if not TopFit.ProgressFrame.forceItemsFrame:IsMouseOver() then
                        TopFit.ProgressFrame.forceItemsFrame:Hide()
                    end
                end
            end)
            button:SetScript("OnClick", function (self, ...)
                if not TopFit.isBlocked then
                    local slotID = self:GetID()
                    if not TopFit.ProgressFrame.forceItemsFrame then
                        -- creat frame for forced items
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
                end
            end)
            
            TopFit.ProgressFrame.equipButtons[slotID] = button
        end
        
        do  -- anchor them all like in the equipment window
            TopFit.ProgressFrame.equipButtons[1]:SetPoint("TOPRIGHT", TopFit.ProgressFrame.statScrollFrame, "TOPLEFT", -4, 0)
            TopFit.ProgressFrame.equipButtons[2]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[1], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[3]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[2], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[15]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[3], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[5]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[15], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[4]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[5], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[19]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[4], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[9]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[19], "BOTTOMLEFT", 0, -2)
            
            TopFit.ProgressFrame.equipButtons[10]:SetPoint("TOPLEFT", TopFit.ProgressFrame.statScrollFrame, "TOPRIGHT", 26, 0)
            TopFit.ProgressFrame.equipButtons[6]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[10], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[7]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[6], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[8]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[7], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[11]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[8], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[12]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[11], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[13]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[12], "BOTTOMLEFT", 0, -2)
            TopFit.ProgressFrame.equipButtons[14]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[13], "BOTTOMLEFT", 0, -2)
            
            TopFit.ProgressFrame.equipButtons[17]:SetPoint("TOP", TopFit.ProgressFrame.statScrollFrame, "BOTTOM", 10, 15)
            TopFit.ProgressFrame.equipButtons[16]:SetPoint("TOPRIGHT", TopFit.ProgressFrame.equipButtons[17], "TOPLEFT", -2, 0)
            TopFit.ProgressFrame.equipButtons[18]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[17], "TOPRIGHT", 2, 0)
        end
        
        function TopFit.ProgressFrame:SetSetName(setName)
            UIDropDownMenu_SetText(TopFit.ProgressFrame.setDropDown, setName)
            TopFit.ProgressFrame.setNameEditTextBox:SetText(setName)
        end
        -- set rename editBox
        TopFit.ProgressFrame.setNameEditTextBox = CreateFrame("EditBox", "TopFit_ProgressFrame_setNameEditBox", statScrollFrameContent)
        TopFit.ProgressFrame.setNameEditTextBox:SetPoint("TOPLEFT", 4, -4)
        TopFit.ProgressFrame.setNameEditTextBox:SetPoint("TOPRIGHT", -4, -4)
        TopFit.ProgressFrame.setNameEditTextBox:SetHeight(26)
        TopFit.ProgressFrame.setNameEditTextBox:SetAutoFocus(false)
        TopFit.ProgressFrame.setNameEditTextBox:SetFontObject("GameFontNormalHuge")
        TopFit.ProgressFrame.setNameEditTextBox:SetJustifyH("CENTER")
        
        local hoverBackground = TopFit.ProgressFrame.setNameEditTextBox:CreateTexture("$parentHover", "BACKGROUND")
        hoverBackground:SetTexture("Interface\\Buttons\\UI-ListBox-Highlight")
        hoverBackground:SetAllPoints()
        hoverBackground:Hide()
        TopFit.ProgressFrame.setNameEditTextBox:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].name)
        TopFit.ProgressFrame.setNameEditTextBox.tipText = TopFit.locale.EditSetNameTooltip
        
        TopFit.ProgressFrame.setNameEditTextBox:SetScript("OnEnter", function(self)
            TopFit.ShowTooltip(self)
            hoverBackground:Show()
        end)
        TopFit.ProgressFrame.setNameEditTextBox:SetScript("OnLeave", function(self)
            TopFit.HideTooltip(self)
            hoverBackground:Hide()
        end)
        
        -- scripts
        local function EditBoxFocusGained(self)
            if not TopFit.ProgressFrame.selectedSet then return end
            local setName = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].name
            TopFit.ProgressFrame.setNameEditTextBox:SetText(setName)
            TopFit.ProgressFrame.setNameEditTextBox:HighlightText()
        end
        TopFit.ProgressFrame.setNameEditTextBox:SetScript("OnEditFocusGained", EditBoxFocusGained)
        
        local function EditBoxFocusLost(self)   -- reset focus and display proper text
            if TopFit.ProgressFrame.selectedSet then
                local setName = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].name
                TopFit.ProgressFrame:SetSetName(setName)
                TopFit.ProgressFrame.setNameEditTextBox:SetText(setName)
            end
            TopFit.ProgressFrame.setNameEditTextBox:ClearFocus()
        end
        TopFit.ProgressFrame.setNameEditTextBox:SetScript("OnEditFocusLost", EditBoxFocusLost)
        
        local function AcceptEditBox(self)  -- save new set name
            local newSetName = TopFit.ProgressFrame.setNameEditTextBox:GetText()
            TopFit:RenameSet(TopFit.ProgressFrame.selectedSet, newSetName)
            TopFit.ProgressFrame:SetSetName(newSetName)
            EditBoxFocusLost()
        end
        TopFit.ProgressFrame.setNameEditTextBox:SetScript("OnEscapePressed", EditBoxFocusLost)
        TopFit.ProgressFrame.setNameEditTextBox:SetScript("OnEnterPressed", AcceptEditBox)
        
        -- fontsting for set value
        TopFit.ProgressFrame.setScoreFontString = statScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        TopFit.ProgressFrame.setScoreFontString:SetPoint("TOP", TopFit.ProgressFrame.setNameEditTextBox, "BOTTOM")
        TopFit.ProgressFrame.setScoreFontString:SetText(string.format(TopFit.locale.SetScore, "-"))
        
        -- List of Score contributing Texts and Bars
        statScrollFrameContent.statNameFontStrings = {}
        statScrollFrameContent.statValueFontStrings = {}
        statScrollFrameContent.statValueStatusBars = {}
        statScrollFrameContent.capNameFontStrings = {}
        statScrollFrameContent.capValueFontStrings = {}
        
       -- function for changing set name
        function TopFit.ProgressFrame:SetSelectedSet(setCode)
            if not setCode then
                -- select the first set
                local i = 1
                if TopFit.db.profile.sets and TopFit.db.profile.sets ~= {} then
                    while (not TopFit.db.profile.sets["set_"..i]) and (i < 1000) do i = i + 1 end
                    setCode = "set_"..i
                end
            end
            
            if not TopFit.db.profile.sets[setCode] then
                TopFit.ProgressFrame.selectedSet = nil
                -- disable some buttons
                TopFit.ProgressFrame.deleteSetButton:Disable()
                TopFit.ProgressFrame.startButton:Disable()
            else
                -- (re-)enable buttons
                TopFit.ProgressFrame.deleteSetButton:Enable()
                TopFit.ProgressFrame.startButton:Enable()
                
                TopFit.ProgressFrame.selectedSet = setCode
                UIDropDownMenu_SetSelectedValue(TopFit.ProgressFrame.setDropDown, setCode)
                TopFit.ProgressFrame:SetSetName(TopFit.db.profile.sets[setCode].name)
                
                -- generate pseudo equipment set to display when selecting a set
                local combination = {
                    items = {},
                    totalStats = {},
                    totalScore = 0,
                }
                local itemPositions = GetEquipmentSetLocations(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))
                --local items = GetEquipmentSetItemIDs(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))
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
                
                TopFit.ProgressFrame:SetCurrentCombination(combination)
            end
            TopFit.eventHandler:Fire("OnSetChanged", TopFit.ProgressFrame.selectedSet)
        end
        
        -- function for showing current calculated set
        function TopFit.ProgressFrame:SetCurrentCombination(combination)
            if not combination then
                combination = {
                    items = {},
                    totalScore = 0,
                    totalStats = {},
                }
            end
            
            for slotID, button in pairs(TopFit.ProgressFrame.equipButtons) do
                local button = TopFit.ProgressFrame.equipButtons[slotID]
                button.itemLink = combination.items[slotID] and combination.items[slotID].itemLink
                
                -- set highlight if forced item
                if (TopFit.ProgressFrame.selectedSet) and 
                    (TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet]) and
                    (TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].forced[slotID]) then
                    button.highlightTexture:SetVertexColor(1, 0, 0, 1)
                else
                    button.highlightTexture:SetVertexColor(1, 1, 1, 0)
                end
                
                local itemTexture
                if button.itemLink then -- an item was set
                    itemTexture = select(10, GetItemInfo(combination.items[slotID].itemLink)) or "Interface\\Icons\\Inv_misc_questionmark"
                else                    -- no item set
                    itemTexture = button.backgroundTextureName
                    if button.checkRelic and UnitHasRelicSlot("player") then
                        textureName = "Interface\\Paperdoll\\UI-PaperDoll-Slot-Relic.blp";
                    end
                    
                end
                SetItemButtonTexture(button, itemTexture)
            end
            
            TopFit.ProgressFrame.setScoreFontString:SetText(string.format(TopFit.locale.SetScore, round(combination.totalScore, 2)))
            
            -- sort stats by score contribution
            statList = {}
            scorePerStat = {}
            for key, _ in pairs(combination.totalStats) do
                tinsert(statList, key)
            end
            
            local set
            local caps
            if not TopFit.ProgressFrame.selectedSet then
                set = {}
                caps = {}
            else
                set = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights
                caps = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps
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
            
            local statTexts = statScrollFrameContent.statNameFontStrings
            local valueTexts = statScrollFrameContent.statValueFontStrings
            local statusBars = statScrollFrameContent.statValueStatusBars
            local lastStat = 0
            local maxStatValue = statList[1] and scorePerStat[statList[1]] or 0
            
            if not statScrollFrameContent.statsHeader then
                statScrollFrameContent.statsHeader = statScrollFrameContent:CreateFontString(nil, nil, "GameFontNormalLarge")
                statScrollFrameContent.statsHeader:SetPoint("TOP", TopFit.ProgressFrame.setScoreFontString, "BOTTOM", 0, -10)
                statScrollFrameContent.statsHeader:SetPoint("LEFT", statScrollFrameContent, 3, 0)
                statScrollFrameContent.statsHeader:SetText(TopFit.locale.HeadingStats)
            end
            
            for i = 1, #statList do
                if (scorePerStat[statList[i]] ~= nil) and (scorePerStat[statList[i]] > 0) then
                    lastStat = i
                    if not statTexts[i] then
                        -- create FontStrings
                        -- fontsting for stat name
                        statusBars[i] = CreateFrame("StatusBar", "TopFit_ProgressFrame_statValueBar"..i, statScrollFrameContent)
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
            local placeHolder = CreateFrame("Frame", nil, statScrollFrameContent)
            placeHolder:SetHeight(20)
            if numCaps > 0 then
                placeHolder:SetPoint("TOPLEFT", capNameTexts[numCaps], "BOTTOMLEFT")
            else
                placeHolder:SetPoint("TOPLEFT", statTexts[lastStat], "BOTTOMLEFT")
            end
            placeHolder:SetPoint("RIGHT")
        end
        
        --[[--
        --              Right part of Panel
        --]]--
        
        -- stuff for second half of the frame goes here!
        TopFit.ProgressFrame.isExpanded = false
        
        function TopFit.ProgressFrame:CreateHeaderButton(parent, name)
            local butt = CreateFrame("Button", name, parent)
            butt:SetWidth(80) butt:SetHeight(18)
            
            -- Fonts --
            butt:SetHighlightFontObject(GameFontHighlightSmall)
            butt:SetNormalFontObject(GameFontNormalSmall)
            
            -- Textures --
            --butt:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
            --butt:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
            butt:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
            butt:GetHighlightTexture():SetBlendMode("ADD")
            
            local left = butt:CreateTexture("$parentLeft")
            left:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
            left:SetTexCoord(0, 0.078125, 0, 0.59375)
            left:SetPoint("BOTTOMLEFT")
            left:SetWidth(5)
            left:SetHeight(butt:GetHeight())
            
            local right = butt:CreateTexture("$parentRight")
            right:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
            right:SetTexCoord(0.90625, 0.96875, 0, 0.59375)
            right:SetPoint("BOTTOMRIGHT")
            right:SetWidth(5)
            right:SetHeight(butt:GetHeight())
            
            local center = butt:CreateTexture("$parentCenter")
            center:SetTexture("Interface\\FriendsFrame\\WhoFrame-ColumnTabs")
            center:SetTexCoord(0.078125, 0.90625, 0, 0.59375)
            center:SetPoint("LEFT", "$parentLeft", "RIGHT")
            center:SetPoint("RIGHT", "$parentRight", "LEFT")
            --center:SetWidth(5)
            center:SetHeight(butt:GetHeight())
            
            -- Tooltip bits
            butt:SetScript("OnEnter", TopFit.ShowTooltip)
            butt:SetScript("OnLeave", TopFit.HideTooltip)
            
            return butt
        end
        
        TopFit.ProgressFrame.pluginContainer = CreateFrame("Frame", "TopFit_ProgressFrame_PluginContainer", TopFit.ProgressFrame)
        TopFit.ProgressFrame.pluginContainer:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPRIGHT", -15, -15)
        TopFit.ProgressFrame.pluginContainer:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame, "BOTTOMRIGHT", -15, 15)
        TopFit.ProgressFrame.pluginContainer:SetWidth(TopFit.ProgressFrame:GetWidth() - 30)
        TopFit.ProgressFrame.pluginContainer:Hide()
        
        -- center frame on screen
        TopFit.ProgressFrame:SetPoint("CENTER", 0, 0)
        
        -- select default set
        TopFit.ProgressFrame:SetSelectedSet()
        
        -- show plugins
        TopFit:UpdatePlugins()
    end
    
    if not TopFit.ProgressFrame:IsShown() then
        TopFit.ProgressFrame:Show()
    end
end

function TopFit:HideProgressFrame()
    TopFit.ProgressFrame:Hide()
end
