local minimalist = [=[Interface\AddOns\TopFit\media\minimalist]=]

function TopFit:CreateProgressFrame()
    if not TopFit.ProgressFrame then
        -- actual frame
        TopFit.ProgressFrame = CreateFrame("Frame", "TopFit_ProgressFrame")
        tinsert(UISpecialFrames, "TopFit_ProgressFrame")
        TopFit.ProgressFrame:ClearAllPoints()
        TopFit.ProgressFrame:SetBackdrop(StaticPopup1:GetBackdrop())
        TopFit.ProgressFrame:SetHeight(32 * 8 + 16 + 60 + 20 * 2)
        TopFit.ProgressFrame:SetWidth(32 * 5 + 48 * 2 + 20 * 2)
        TopFit.ProgressFrame:EnableMouse(true)
        local titleRegion = TopFit.ProgressFrame:CreateTitleRegion()
        titleRegion:SetAllPoints(TopFit.ProgressFrame)
        
        -- the most important thing: the close-button
        TopFit.ProgressFrame.closeButton = CreateFrame("Button", "TopFit_ProgressFrame_closeButton", TopFit.ProgressFrame, "UIPanelCloseButton")
        TopFit.ProgressFrame.closeButton:SetWidth(30)
        TopFit.ProgressFrame.closeButton:SetHeight(30)
        TopFit.ProgressFrame.closeButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPRIGHT")
        TopFit.ProgressFrame.closeButton:SetScript("OnClick", function(...) TopFit:HideProgressFrame() end)
        
        -- tooltip functions for equipment buttons
	local function ShowTooltip(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if self.tipText then
                GameTooltip:SetText(self.tipText, nil, nil, nil, nil, true)
            elseif self.itemLink then
                GameTooltip:SetHyperlink(self.itemLink)
            end
            GameTooltip:Show()
	end
	local function HideTooltip() GameTooltip:Hide() end
        
        -- equipment buttons
        TopFit.ProgressFrame.equipButtons = {}
        for slotID, _ in pairs(TopFit.slotNames) do
            TopFit.ProgressFrame.equipButtons[slotID] = CreateFrame("Button", "TopFit_ProgressFrame_slot"..slotID.."Button", TopFit.ProgressFrame)
            TopFit.ProgressFrame.equipButtons[slotID]:SetHeight(32)
            TopFit.ProgressFrame.equipButtons[slotID]:SetWidth(32)
            TopFit.ProgressFrame.equipButtons[slotID]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        end
        -- anchor them all like in the equipment window
        TopFit.ProgressFrame.equipButtons[1]:SetPoint("TOPLEFT", 20, -20)
        TopFit.ProgressFrame.equipButtons[2]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[1], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[3]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[2], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[15]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[3], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[5]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[15], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[4]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[5], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[19]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[4], "BOTTOMLEFT")
        TopFit.ProgressFrame.equipButtons[9]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[19], "BOTTOMLEFT")
        
        TopFit.ProgressFrame.equipButtons[16]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[9], "BOTTOMRIGHT", 48, 16)
        TopFit.ProgressFrame.equipButtons[17]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[16], "TOPRIGHT")
        TopFit.ProgressFrame.equipButtons[18]:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[17], "TOPRIGHT")
        
        TopFit.ProgressFrame.equipButtons[14]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[18], "TOPRIGHT", 48, -16)
        TopFit.ProgressFrame.equipButtons[13]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[14], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[12]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[13], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[11]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[12], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[8]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[11], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[7]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[8], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[6]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[7], "TOPLEFT")
        TopFit.ProgressFrame.equipButtons[10]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.equipButtons[6], "TOPLEFT")
        
        -- set their default (empty) textures
        TopFit.ProgressFrame.equipButtons[1].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Head"
        TopFit.ProgressFrame.equipButtons[2].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Neck"
        TopFit.ProgressFrame.equipButtons[3].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Shoulder"
        TopFit.ProgressFrame.equipButtons[15].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest"
        TopFit.ProgressFrame.equipButtons[5].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest"
        TopFit.ProgressFrame.equipButtons[4].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Shirt"
        TopFit.ProgressFrame.equipButtons[19].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Tabard"
        TopFit.ProgressFrame.equipButtons[9].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Wrists"
        TopFit.ProgressFrame.equipButtons[16].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-MainHand"
        TopFit.ProgressFrame.equipButtons[17].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-SecondaryHand"
        TopFit.ProgressFrame.equipButtons[18].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Ranged"
        TopFit.ProgressFrame.equipButtons[14].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket"
        TopFit.ProgressFrame.equipButtons[13].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket"
        TopFit.ProgressFrame.equipButtons[12].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-RFinger"
        TopFit.ProgressFrame.equipButtons[11].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-RFinger"
        TopFit.ProgressFrame.equipButtons[8].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Feet"
        TopFit.ProgressFrame.equipButtons[7].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Legs"
        TopFit.ProgressFrame.equipButtons[6].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Waist"
        TopFit.ProgressFrame.equipButtons[10].emptyTexture = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Hands"
        for _, button in pairs(TopFit.ProgressFrame.equipButtons) do
            button:SetNormalTexture(button.emptyTexture)
            -- also set tooltip functions
            button:SetScript("OnEnter", ShowTooltip)
            button:SetScript("OnLeave", HideTooltip)
        end
        
        -- select set label
        TopFit.ProgressFrame.selectSetLabel = TopFit.ProgressFrame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        TopFit.ProgressFrame.selectSetLabel:SetPoint("TOP", TopFit.ProgressFrame.equipButtons[16], "BOTTOM", 0, -10)
        TopFit.ProgressFrame.selectSetLabel:SetPoint("LEFT", TopFit.ProgressFrame.equipButtons[1], "LEFT")
        TopFit.ProgressFrame.selectSetLabel:SetPoint("RIGHT", TopFit.ProgressFrame.equipButtons[10], "RIGHT")
        TopFit.ProgressFrame.selectSetLabel:SetText("Select set to calculate:")
        TopFit.ProgressFrame.selectSetLabel:SetJustifyH("LEFT")
        
        -- abort button
        TopFit.ProgressFrame.abortButton = CreateFrame("Button", "TopFit_ProgressFrame_abortButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.abortButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMRIGHT")
        TopFit.ProgressFrame.abortButton:SetText("Abort")
        TopFit.ProgressFrame.abortButton:SetHeight(22)
        TopFit.ProgressFrame.abortButton:SetWidth(80)
        TopFit.ProgressFrame.abortButton:Hide()
        
        TopFit.ProgressFrame.abortButton:SetScript("OnClick", TopFit.AbortCalculations)
        
        -- start button
        TopFit.ProgressFrame.startButton = CreateFrame("Button", "TopFit_ProgressFrame_abortButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.startButton:SetAllPoints(TopFit.ProgressFrame.abortButton)
        TopFit.ProgressFrame.startButton:SetText("Start")
        --TopFit.ProgressFrame.startButton:Hide()
        
        TopFit.ProgressFrame.startButton:SetScript("OnClick", function(...)
            if not TopFit.isBlocked then
                if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet] then
                    TopFit.workSetList = { TopFit.ProgressFrame.selectedSet }
                    TopFit:CalculateSets()
                end
            end
        end)
        
        -- progress bar
        TopFit.ProgressFrame.progressBar = CreateFrame("StatusBar", "TopFit_ProgressFrame_StatusBar", TopFit.ProgressFrame)
        TopFit.ProgressFrame.progressBar:SetPoint("TOPLEFT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMLEFT", 2, -2)
        TopFit.ProgressFrame.progressBar:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame.abortButton, "BOTTOMLEFT", -2, 2)
        TopFit.ProgressFrame.progressBar:SetStatusBarTexture(minimalist)
        TopFit.ProgressFrame.progressBar:SetMinMaxValues(0, 100)
        TopFit.ProgressFrame.progressBar:SetStatusBarColor(0, 1, 0, 0.8)
        TopFit.ProgressFrame.progressBar:Hide()
        
        -- progress text
        TopFit.ProgressFrame.progressText = TopFit.ProgressFrame.progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        TopFit.ProgressFrame.progressText:SetAllPoints()
        TopFit.ProgressFrame.progressText:SetText("0.00%")
        
        -- set selection
                TopFit.ProgressFrame.setDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_setDropDown", TopFit.ProgressFrame, "UIDropDownMenuTemplate")
        TopFit.ProgressFrame.setDropDown:SetPoint("TOPLEFT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMLEFT", 0, 2)
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
                    UIDropDownMenu_SetSelectedID(TopFit.ProgressFrame.setDropDown, self:GetID())
                    TopFit.ProgressFrame.selectedSet = self.value
                    --TopFit:Debug("ID: "..self:GetID().."; value: "..self.value)
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end)
        UIDropDownMenu_SetSelectedID(TopFit.ProgressFrame.setDropDown, 1)
        UIDropDownMenu_JustifyText(TopFit.ProgressFrame.setDropDown, "LEFT")
        
        function TopFit.ProgressFrame:ResetProgress()
            TopFit.ProgressFrame.progress = nil
            TopFit.ProgressFrame.startButton:Hide()
            TopFit.ProgressFrame.setDropDown:Hide()
            TopFit.ProgressFrame.abortButton:Show()
            TopFit.ProgressFrame.progressBar:Show()
        end
        function TopFit.ProgressFrame:StoppedCalculation()
            TopFit.ProgressFrame.startButton:Show()
            TopFit.ProgressFrame.setDropDown:Show()
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
        local boxHeight = 32 * 8 - 16
        local boxWidth = 32 * 3 + 48 * 2 - 22
	TopFit.ProgressFrame.statScrollFrame = CreateFrame("ScrollFrame", "TopFit_StatScrollFrame", TopFit.ProgressFrame, "UIPanelScrollFrameTemplate")
	TopFit.ProgressFrame.statScrollFrame:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[1], "TOPRIGHT")
	TopFit.ProgressFrame.statScrollFrame:SetHeight(boxHeight)
	TopFit.ProgressFrame.statScrollFrame:SetWidth(boxWidth)
	local group2 = CreateFrame("Frame", nil, TopFit.ProgressFrame.statScrollFrame)
	group2:SetAllPoints()
	group2:SetHeight(boxHeight)
	group2:SetWidth(boxWidth)
	TopFit.ProgressFrame.statScrollFrame:SetScrollChild(group2)
	
	local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            tile = true,
            tileSize = 32,
            insets = { left = 0, right = -22, top = 0, bottom = 0 }}
	TopFit.ProgressFrame.statScrollFrame:SetBackdrop(backdrop)
	TopFit.ProgressFrame.statScrollFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
	TopFit.ProgressFrame.statScrollFrame:SetBackdropColor(0.1, 0.1, 0.1)
        
        -- fontstrings for set name
        TopFit.ProgressFrame.setNameFontString = group2:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        TopFit.ProgressFrame.setNameFontString:SetHeight(32)
        TopFit.ProgressFrame.setNameFontString:SetPoint("TOP", TopFit.ProgressFrame.statScrollFrame, "TOP")
        TopFit.ProgressFrame.setNameFontString:SetText("Set Name")
        
        -- fontsting for set value
        TopFit.ProgressFrame.setScoreFontString = group2:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        TopFit.ProgressFrame.setScoreFontString:SetHeight(32)
        TopFit.ProgressFrame.setScoreFontString:SetPoint("TOP", TopFit.ProgressFrame.setNameFontString, "BOTTOM")
        TopFit.ProgressFrame.setScoreFontString:SetText("Total Score: -")
        
        -- List of Score contributing Texts and Bars
        TopFit.ProgressFrame.statNameFontStrings = {}
        TopFit.ProgressFrame.statValueFontStrings = {}
        TopFit.ProgressFrame.statValueStatusBars = {}
        
        -- function for changing set name
        function TopFit.ProgressFrame:SetSetName(text)
            TopFit.ProgressFrame.setNameFontString:SetText(text)
        end
        
        -- function for showing current calculated set
        function TopFit.ProgressFrame:SetCurrentCombination(combination)
            -- reset to default icon
            for _, button in pairs(TopFit.ProgressFrame.equipButtons) do
                button:SetNormalTexture(button.emptyTexture)
                button.itemLink = nil
            end
            for slotID, itemTable in pairs(combination.items) do
                -- set to item icon
                _, _, _, _, _, _, _, _, _, texture, _ = GetItemInfo(itemTable.itemID)
                TopFit.ProgressFrame.equipButtons[slotID]:SetNormalTexture(texture)
                TopFit.ProgressFrame.equipButtons[slotID].itemLink = itemTable.itemLink
            end
            
            TopFit.ProgressFrame.setScoreFontString:SetText("Total Score: "..round(combination.totalScore, 2))
            
            -- sort stats by score contribution
            statList = {}
            scorePerStat = {}
            for key, _ in pairs(combination.totalStats) do
                tinsert(statList, key)
            end
            table.sort(statList, function(a, b)
                local set = TopFit.db.profile.sets[TopFit.setCode].weights
                local caps = TopFit.db.profile.sets[TopFit.setCode].caps
                
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
            
            local statTexts = TopFit.ProgressFrame.statNameFontStrings
            local valueTexts = TopFit.ProgressFrame.statValueFontStrings
            local statusBars = TopFit.ProgressFrame.statValueStatusBars
            local lastStat = 0
            local maxStatValue = scorePerStat[statList[1]]
            for i = 1, #statList do
                if (scorePerStat[statList[i]] ~= nil) and (scorePerStat[statList[i]] > 0) then
                    lastStat = i
                    if not statTexts[i] then
                        -- create FontStrings
                        -- fontsting for stat name
                        statusBars[i] = CreateFrame("StatusBar", "TopFit_ProgressFrame_statValueBar"..i, group2)
                        statTexts[i] = statusBars[i]:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                        valueTexts[i] = statusBars[i]:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                        statTexts[i]:SetTextHeight(10)
                        valueTexts[i]:SetTextHeight(10)
                        --statTexts[i]:SetHeight(32)
                        if i == 1 then
                            statTexts[i]:SetPoint("TOP", TopFit.ProgressFrame.setScoreFontString, "BOTTOM", 0, -10)
                            valueTexts[i]:SetPoint("TOP", TopFit.ProgressFrame.setScoreFontString, "BOTTOM", 0, -10)
                            statTexts[i]:SetPoint("LEFT", group2, "LEFT")
                            valueTexts[i]:SetPoint("RIGHT", group2, "RIGHT")
                        else
                            statTexts[i]:SetPoint("TOPLEFT", statTexts[i - 1], "BOTTOMLEFT")
                            valueTexts[i]:SetPoint("TOPRIGHT", valueTexts[i - 1], "BOTTOMRIGHT")
                        end
                        statusBars[i]:SetPoint("TOPLEFT", statTexts[i], "TOPLEFT", 0, -1)
                        statusBars[i]:SetPoint("BOTTOMRIGHT", valueTexts[i], "BOTTOMRIGHT")
                        statusBars[i]:SetStatusBarTexture(minimalist)
                        statTexts[i]:SetText("aaaaaaaaaaaaa")
                        valueTexts[i]:SetText("000")
                    end
                    statTexts[i]:Show()
                    valueTexts[i]:Show()
                    statusBars[i]:Show()
                    statTexts[i]:SetText(_G[statList[i]])
                    valueTexts[i]:SetText(round(combination.totalStats[statList[i]], 1))
                    statusBars[i]:SetMinMaxValues(0, maxStatValue)
                    statusBars[i]:SetValue(scorePerStat[statList[i]])
                    statusBars[i]:SetStatusBarColor(0.3, 1, 0.5, 0.5)
                    --TopFit:Debug(_G[statList[i]]..": "..combination.totalStats[statList[i]].." ("..scorePerStat[statList[i]]..")")
                end
            end
            for i = lastStat + 1, #statTexts do
                statTexts[i]:Hide()
                valueTexts[i]:Hide()
                statusBars[i]:Hide()
            end
        end
        
        -- center frame on screen
        TopFit.ProgressFrame:SetPoint("CENTER", 0, 0)
    end
    
    TopFit.ProgressFrame:Show()
end

function TopFit:HideProgressFrame()
    TopFit.ProgressFrame:Hide()
end
