local minimalist = [=[Interface\AddOns\TopFit\media\minimalist]=]

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

local function HideTooltip()
    GameTooltip:Hide()
end

function TopFit:RegisterPlugin(pluginName, tooltipText)
    -- create / register plugin-tab
    local pluginInfo = {
        name = pluginName,
        tooltipText = tooltipText,
    }
    
    tinsert(TopFit.plugins, pluginInfo)
    pluginInfo.id = #(TopFit.plugins)
    
    -- return frame for plugin UI
    pluginInfo.frame = CreateFrame("Frame", "TopFit_ProgressFrame_PluginFrame_"..(pluginInfo.id), nil)
    if pluginInfo.id > 1 then
        pluginInfo.frame:Hide()
    end
    
    TopFit:UpdatePlugins()
    
    return pluginInfo.frame
end

function TopFit:UpdatePlugins()
    if TopFit.ProgressFrame then
        local i
        for i = 1, #(TopFit.plugins) do
            local pluginInfo = TopFit.plugins[i]
            -- update parents and anchors for plugin frames
            pluginInfo.frame:SetParent(TopFit.ProgressFrame.pluginContainer)
            pluginInfo.frame:SetAllPoints()
            
            -- create tabs if necessary
            if not pluginInfo.tabButton then
                -- create plugin button and size / anchor it
                pluginInfo.tabButton = TopFit.ProgressFrame:CreateHeaderButton(TopFit.ProgressFrame.pluginContainer, "TopFit_ProgressFrame_PluginButton_"..(pluginInfo.id))
                pluginInfo.tabButton:SetPoint("BOTTOM", TopFit.ProgressFrame, "TOP", 0, -7)
                if (pluginInfo.id == 1) then
                    pluginInfo.tabButton:SetPoint("LEFT", TopFit.ProgressFrame.pluginContainer, "LEFT")
                else
                    pluginInfo.tabButton:SetPoint("LEFT", TopFit.plugins[pluginInfo.id - 1].tabButton, "RIGHT", 3, 0)
                end
                
                -- set event handlers
                pluginInfo.tabButton:SetScript("OnClick", function()
                    TopFit:SelectPluginTab(pluginInfo.id)
                end)
            end
            pluginInfo.tabButton:SetText(pluginInfo.name)
            pluginInfo.tabButton:SetWidth(pluginInfo.tabButton:GetFontString():GetStringWidth() + 10)
            pluginInfo.tabButton.tipText = pluginInfo.tooltipText
        end
    end
end

function TopFit:SelectPluginTab(id)
    local i
    for i = 1, #(TopFit.plugins) do
        if i == id then
            TopFit.plugins[i].frame:Show()
        else
            TopFit.plugins[i].frame:Hide()
        end
    end
end

function TopFit:CreateProgressFrame()
    if not TopFit.ProgressFrame then
        -- actual frame
        
        --[[--
        --              Left part of Panel
        --]]--
        
        TopFit.ProgressFrame = CreateFrame("Frame", "TopFit_ProgressFrame", nil) -- change nil to UIParent if the frame should be affected by UIScale
        tinsert(UISpecialFrames, "TopFit_ProgressFrame")
        TopFit.ProgressFrame:SetToplevel(true)
        TopFit.ProgressFrame:ClearAllPoints()
        TopFit.ProgressFrame:SetBackdrop({
            bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
            tileSize=32,
            edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
            tile=1,
            edgeSize=32,
            insets={
                top=12,
                right=12,
                left=11,
                bottom=11
            }
        })
        TopFit.ProgressFrame:SetHeight(32 * 8 + 16 + 70 + 20 * 2)
        TopFit.ProgressFrame:SetWidth(32 * 5 + 48 * 2 + 20 * 2)
        TopFit.ProgressFrame:EnableMouse(true)
        --TopFit.ProgressFrame:SetScale(GetCVar("uiScale"))
        local titleRegion = TopFit.ProgressFrame:CreateTitleRegion()
        titleRegion:SetAllPoints(TopFit.ProgressFrame)
        
        -- the most important thing: the close-button
        TopFit.ProgressFrame.closeButton = CreateFrame("Button", "TopFit_ProgressFrame_closeButton", TopFit.ProgressFrame, "UIPanelCloseButton")
        TopFit.ProgressFrame.closeButton:SetWidth(30)
        TopFit.ProgressFrame.closeButton:SetHeight(30)
        TopFit.ProgressFrame.closeButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPRIGHT")
        TopFit.ProgressFrame.closeButton:SetScript("OnClick", function(...) TopFit:HideProgressFrame() end)
        
        -- select set label
        TopFit.ProgressFrame.selectSetLabel = TopFit.ProgressFrame:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        TopFit.ProgressFrame.selectSetLabel:SetPoint("TOPLEFT", TopFit.ProgressFrame, "TOPLEFT", 20, -30)
        --TopFit.ProgressFrame.selectSetLabel:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPRIGHT", -20, -20)
        TopFit.ProgressFrame.selectSetLabel:SetWidth(TopFit.ProgressFrame:GetWidth() - 40)
        TopFit.ProgressFrame.selectSetLabel:SetText("Select set to calculate:")
        TopFit.ProgressFrame.selectSetLabel:SetJustifyH("LEFT")
        
        -- abort button
        TopFit.ProgressFrame.abortButton = CreateFrame("Button", "TopFit_ProgressFrame_abortButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.abortButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMRIGHT", 0, 0)
        TopFit.ProgressFrame.abortButton:SetText("Abort")
        TopFit.ProgressFrame.abortButton:SetHeight(22)
        TopFit.ProgressFrame.abortButton:SetWidth(80)
        TopFit.ProgressFrame.abortButton:Hide()
        
        TopFit.ProgressFrame.abortButton:SetScript("OnClick", TopFit.AbortCalculations)
        
        -- start button
        TopFit.ProgressFrame.startButton = CreateFrame("Button", "TopFit_ProgressFrame_startButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
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
        --TopFit.ProgressFrame.progressBar:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame.abortButton, "BOTTOMLEFT", -2, 2)
        TopFit.ProgressFrame.progressBar:SetWidth(170)
        TopFit.ProgressFrame.progressBar:SetHeight(20)
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
        TopFit.ProgressFrame.setDropDown:SetPoint("TOPLEFT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMLEFT", -20, 2)
        TopFit.ProgressFrame.setDropDown:SetWidth(150)
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
        
        -- add set button
        TopFit.ProgressFrame.addSetButton = CreateFrame("Button", "TopFit_ProgressFrame_addSetButton", TopFit.ProgressFrame)
        TopFit.ProgressFrame.addSetButton:SetPoint("LEFT", TopFit.ProgressFrame.setDropDown, "RIGHT", 0, 8)
        TopFit.ProgressFrame.addSetButton:SetHeight(12)
        TopFit.ProgressFrame.addSetButton:SetWidth(12)
        TopFit.ProgressFrame.addSetButton:SetNormalTexture("Interface\\Icons\\Spell_chargepositive")
        TopFit.ProgressFrame.addSetButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        
        -- set selection for add set button
        TopFit.ProgressFrame.addSetButton.setDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_addSetButton_setDropDown", TopFit.ProgressFrame.addSetButton, "UIDropDownMenuTemplate")
        UIDropDownMenu_Initialize(TopFit.ProgressFrame.addSetButton.setDropDown, function(self, level)
            local info = UIDropDownMenu_CreateInfo()
            info.hasArrow = false; -- no submenu
            info.notCheckable = true;
            info.text = "Empty Set"
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
        TopFit.ProgressFrame.addSetButton.tipText = "Add a new equipment set\n|cffffffffAftewards, you can adjust this set's weights and caps in the right frame, or force items by clicking on any equipment slots below."
        TopFit.ProgressFrame.addSetButton:SetScript("OnEnter", ShowTooltip)
        TopFit.ProgressFrame.addSetButton:SetScript("OnLeave", HideTooltip)
        
        -- delete set button
        TopFit.ProgressFrame.deleteSetButton = CreateFrame("Button", "TopFit_ProgressFrame_deleteSetButton", TopFit.ProgressFrame)
        TopFit.ProgressFrame.deleteSetButton:SetPoint("TOP", TopFit.ProgressFrame.addSetButton, "BOTTOM", 0, 0)
        TopFit.ProgressFrame.deleteSetButton:SetHeight(12)
        TopFit.ProgressFrame.deleteSetButton:SetWidth(12)
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
                --TopFit.ProgressFrame:SetCurrentCombination()
                TopFit:DeleteSet(TopFit.ProgressFrame.selectedSet)
                --TopFit:CalculateScores()
                TopFit.ProgressFrame.deleteSetButton.redHightlight:Hide();
                TopFit.ProgressFrame.deleteSetButton.firstClick = false
            end
        end)
        TopFit.ProgressFrame.deleteSetButton.tipText = "Delete the selected set\n|cffffffffYou will have to click this button a second time to confirm the deletion.\n\n|cffff0000WARNING|cffffffff: The associated set in the equipment manager will also be deleted! If you want to keep it, create a copy in Blizzard's equipment manager first!"
        TopFit.ProgressFrame.deleteSetButton:SetScript("OnEnter", ShowTooltip)
        TopFit.ProgressFrame.deleteSetButton:SetScript("OnLeave", function() HideTooltip() if TopFit.ProgressFrame.deleteSetButton.redHightlight then TopFit.ProgressFrame.deleteSetButton.redHightlight:Hide(); TopFit.ProgressFrame.deleteSetButton.firstClick = false end end)
        
        -- expand / contract button
        TopFit.ProgressFrame.expandButton = CreateFrame("Button", "TopFit_ProgressFrame_expandButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.expandButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame.selectSetLabel, "BOTTOMRIGHT", 0, 30)
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
        
        -- equipment buttons
        TopFit.ProgressFrame.equipButtons = {}
        for slotID, _ in pairs(TopFit.slotNames) do
            TopFit.ProgressFrame.equipButtons[slotID] = CreateFrame("Button", "TopFit_ProgressFrame_slot"..slotID.."Button", TopFit.ProgressFrame)
            TopFit.ProgressFrame.equipButtons[slotID]:SetHeight(32)
            TopFit.ProgressFrame.equipButtons[slotID]:SetWidth(32)
            TopFit.ProgressFrame.equipButtons[slotID]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
            
            -- create extra highlight texture for marking purposes
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture = TopFit.ProgressFrame.equipButtons[slotID]:CreateTexture("$parent_higlightTexture")
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetTexture("Interface\\Buttons\\CheckButtonHilight")
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetAllPoints()
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetBlendMode("ADD")
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetDrawLayer("OVERLAY")
            TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetVertexColor(1, 1, 1, 0)
        end
        -- anchor them all like in the equipment window
        TopFit.ProgressFrame.equipButtons[1]:SetPoint("LEFT", TopFit.ProgressFrame.selectSetLabel, "LEFT")
        TopFit.ProgressFrame.equipButtons[1]:SetPoint("TOP", TopFit.ProgressFrame.abortButton, "BOTTOM", 0, -15)
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
        for slotID, button in pairs(TopFit.ProgressFrame.equipButtons) do
            button:SetNormalTexture(button.emptyTexture)
            -- also set tooltip functions
            button.slotID = slotID
            button:SetScript("OnEnter", ShowTooltip)
            button:SetScript("OnLeave", function (...)
                HideTooltip()
                if TopFit.ProgressFrame.forceItemsFrame then
                    if not TopFit.ProgressFrame.forceItemsFrame:IsMouseOver() then
                        TopFit.ProgressFrame.forceItemsFrame:Hide()
                    end
                end
            end)
            button:SetScript("OnClick", function (self, ...)
                if not TopFit.isBlocked then
                    if not TopFit.ProgressFrame.forceItemsFrame then
                        -- creat frame for forced items
                        TopFit.ProgressFrame.forceItemsFrame = CreateFrame("Frame", "TopFit_ProgressFrame_forceItemsFrame", UIParent)
                        --TopFit.ProgressFrame.forceItemsFrame:SetBackdrop(StaticPopup1:GetBackdrop())
                        TopFit.ProgressFrame.forceItemsFrame:SetBackdrop({
                            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                            tile = true,
                            tileSize = 16,
                            edgeSize = 16,
                            -- distance from the edges of the frame to those of the background texture (in pixels)
                            insets = {
                                left = 4,
                                right = 4,
                                top = 4,
                                bottom = 4
                            }
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
                    TopFit.ProgressFrame.forceItemsFrame.slotLabel:SetText("Force Item for "..TopFit.slotNames[self.slotID]..":")
                    
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
                        
                        itemButtons[1].itemLabel:SetText("Do not force")
                        itemButtons[1].itemTexture:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
                        
                        itemButtons[1]:SetScript("OnClick", function(self)
                            TopFit:Debug("Cleared forced item for slot "..self.slotID)
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].forced[self.slotID] = nil
                            TopFit.ProgressFrame.equipButtons[self.slotID].highlightTexture:SetVertexColor(1, 1, 1, 0)
                            TopFit.ProgressFrame.forceItemsFrame:Hide()
                        end)
                    end
                    itemButtons[1].slotID = self.slotID
                    
                    -- create buttons for all items
                    TopFit:collectItems()
                    local i = 2
                    local maxWidth = 200
                    
                    local itemListBySlot = TopFit:GetEquippableItems(self.slotID)
                    
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
                            itemButtons[i].slotID = self.slotID
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
        end
        
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
        local boxHeight = 32 * 8 - 16
        local boxWidth = 32 * 3 + 48 * 2 - 22
        TopFit.ProgressFrame.statScrollFrame = CreateFrame("ScrollFrame", "TopFit_StatScrollFrame", TopFit.ProgressFrame, "UIPanelScrollFrameTemplate")
        TopFit.ProgressFrame.statScrollFrame:SetPoint("TOPLEFT", TopFit.ProgressFrame.equipButtons[1], "TOPRIGHT")
        TopFit.ProgressFrame.statScrollFrame:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame.equipButtons[14], "LEFT", -22, 0)
        --TopFit.ProgressFrame.statScrollFrame:SetHeight(boxHeight)
        --TopFit.ProgressFrame.statScrollFrame:SetWidth(boxWidth)
        local statScrollFrameContent = CreateFrame("Frame", nil, TopFit.ProgressFrame.statScrollFrame)
        statScrollFrameContent:SetAllPoints()
        statScrollFrameContent:SetHeight(boxHeight)
        statScrollFrameContent:SetWidth(boxWidth)
        TopFit.ProgressFrame.statScrollFrame:SetScrollChild(statScrollFrameContent)
        
        local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            tile = true,
            tileSize = 32,
            insets = { left = 0, right = -22, top = 0, bottom = 0 }}
        TopFit.ProgressFrame.statScrollFrame:SetBackdrop(backdrop)
        TopFit.ProgressFrame.statScrollFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
        TopFit.ProgressFrame.statScrollFrame:SetBackdropColor(0.1, 0.1, 0.1)
        
        -- Button for set renaming
        TopFit.ProgressFrame.renameSetButton = CreateFrame("Button", "TopFit_ProgressFrame_renameSetButton", statScrollFrameContent)
        TopFit.ProgressFrame.renameSetButton:SetPoint("TOPLEFT", statScrollFrameContent, "TOPLEFT", 3, 0)
        TopFit.ProgressFrame.renameSetButton:SetPoint("RIGHT", statScrollFrameContent, "RIGHT")
        TopFit.ProgressFrame.renameSetButton:SetHeight(32)
        TopFit.ProgressFrame.renameSetButton:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
        TopFit.ProgressFrame.renameSetButton:SetAlpha(0.5)
        TopFit.ProgressFrame.renameSetButton:SetScript("OnClick", function(self)
            -- hide Button and Text
            TopFit.ProgressFrame.renameSetButton:Hide()
            TopFit.ProgressFrame.setNameFontString:Hide()
            
            -- show edit box
            if not TopFit.ProgressFrame.setNameEditTextBox then
                -- create box
                TopFit.ProgressFrame.setNameEditTextBox = CreateFrame("EditBox", "TopFit_ProgressFrame_statEditTextBox", statScrollFrameContent)
                TopFit.ProgressFrame.setNameEditTextBox:SetPoint("TOPLEFT", TopFit.ProgressFrame.renameSetButton, "TOPLEFT")
                TopFit.ProgressFrame.setNameEditTextBox:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame.renameSetButton, "BOTTOMRIGHT")
                TopFit.ProgressFrame.setNameEditTextBox:SetAutoFocus(false)
                TopFit.ProgressFrame.setNameEditTextBox:SetFontObject("GameFontNormalHuge")
                TopFit.ProgressFrame.setNameEditTextBox:SetJustifyH("CENTER")
                
                -- background textures
                local left = TopFit.ProgressFrame.setNameEditTextBox:CreateTexture(nil, "BACKGROUND")
                left:SetWidth(12) left:SetHeight(32)
                left:SetPoint("LEFT", -5, 0)
                left:SetTexture("Interface\\Common\\Common-Input-Border")
                left:SetTexCoord(0, 0.0625, 0, 0.625)
                local right = TopFit.ProgressFrame.setNameEditTextBox:CreateTexture(nil, "BACKGROUND")
                right:SetWidth(12) right:SetHeight(32)
                right:SetPoint("RIGHT", 0, 0)
                right:SetTexture("Interface\\Common\\Common-Input-Border")
                right:SetTexCoord(0.9375, 1, 0, 0.625)
                local center = TopFit.ProgressFrame.setNameEditTextBox:CreateTexture(nil, "BACKGROUND")
                center:SetHeight(32)
                center:SetPoint("RIGHT", right, "LEFT", 0, 0)
                center:SetPoint("LEFT", left, "RIGHT", 0, 0)
                center:SetTexture("Interface\\Common\\Common-Input-Border")
                center:SetTexCoord(0.0625, 0.9375, 0, 0.625)
                
                -- scripts
                TopFit.ProgressFrame.setNameEditTextBox:SetScript("OnEscapePressed", function (self)
                    TopFit.ProgressFrame.setNameEditTextBox:Hide()
                    TopFit.ProgressFrame.renameSetButton:Show()
                    TopFit.ProgressFrame.setNameFontString:Show()
                end)
                
                TopFit.ProgressFrame.setNameEditTextBox:SetScript("OnEnterPressed", function (self)
                    -- save new set name
                    local value = TopFit.ProgressFrame.setNameEditTextBox:GetText()
                    TopFit:RenameSet(TopFit.ProgressFrame.selectedSet, value)
                    TopFit.ProgressFrame.setNameEditTextBox:Hide()
                    TopFit.ProgressFrame.renameSetButton:Show()
                    TopFit.ProgressFrame.setNameFontString:SetText(value)
                    TopFit.ProgressFrame.setNameFontString:Show()
                end)
            end
            TopFit.ProgressFrame.setNameEditTextBox:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].name)
            TopFit.ProgressFrame.setNameEditTextBox:Show()
            TopFit.ProgressFrame.setNameEditTextBox:HighlightText()
            TopFit.ProgressFrame.setNameEditTextBox:SetFocus()
        end)
        
        -- fontstrings for set name
        TopFit.ProgressFrame.setNameFontString = statScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
        TopFit.ProgressFrame.setNameFontString:SetHeight(32)
        TopFit.ProgressFrame.setNameFontString:SetPoint("TOP", statScrollFrameContent, "TOP")
        TopFit.ProgressFrame.setNameFontString:SetText("Set Name")
        
        -- fontsting for set value
        TopFit.ProgressFrame.setScoreFontString = statScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        TopFit.ProgressFrame.setScoreFontString:SetHeight(32)
        TopFit.ProgressFrame.setScoreFontString:SetPoint("TOP", TopFit.ProgressFrame.setNameFontString, "BOTTOM")
        TopFit.ProgressFrame.setScoreFontString:SetText("Total Score: -")
        
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
                TopFit.ProgressFrame.addStatButton:Disable()
                TopFit.ProgressFrame.renameSetButton:Disable()
                TopFit.ProgressFrame.includeInTooltipCheckButton:Disable()
            else
                -- (re-)enable buttons
                TopFit.ProgressFrame.deleteSetButton:Enable()
                TopFit.ProgressFrame.startButton:Enable()
                TopFit.ProgressFrame.addStatButton:Enable()
                TopFit.ProgressFrame.renameSetButton:Enable()
                TopFit.ProgressFrame.includeInTooltipCheckButton:Enable()
                
                TopFit.ProgressFrame.selectedSet = setCode
                UIDropDownMenu_SetSelectedValue(TopFit.ProgressFrame.setDropDown, setCode)
                UIDropDownMenu_SetText(TopFit.ProgressFrame.setDropDown, TopFit.db.profile.sets[setCode].name)
                TopFit.ProgressFrame:SetSetName(TopFit.db.profile.sets[setCode].name)
                
                TopFit.ProgressFrame.includeInTooltipCheckButton:SetChecked(not TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].excludeFromTooltip)
                TopFit.ProgressFrame:UpdateSetStats()
                
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
        end
        
        function TopFit.ProgressFrame:SetSetName(text)
            TopFit.ProgressFrame.setNameFontString:SetText(text)
        end
        
        -- function for showing current calculated set
        function TopFit.ProgressFrame:SetCurrentCombination(combination)
            -- default: empty
            if not combination then
                combination = {
                    items = {},
                    totalScore = 0,
                    totalStats = {},
                }
            end
            
            -- reset to default icon
            for slotID, button in pairs(TopFit.ProgressFrame.equipButtons) do
                button:SetNormalTexture(button.emptyTexture)
                button.itemLink = nil
                -- set highlight if forced item
                if (TopFit.ProgressFrame.selectedSet) and (TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet]) and
                        (TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].forced[slotID]) then
                    TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetVertexColor(1, 0, 0, 1)
                else
                    TopFit.ProgressFrame.equipButtons[slotID].highlightTexture:SetVertexColor(1, 1, 1, 0)
                end
            end
            for slotID, locationTable in pairs(combination.items) do
                -- set to item icon
                _, _, _, _, _, _, _, _, _, texture, _ = GetItemInfo(locationTable.itemLink)
                if not texture then texture = "Interface\\Icons\\Inv_misc_questionmark" end
                TopFit.ProgressFrame.equipButtons[slotID]:SetNormalTexture(texture)
                TopFit.ProgressFrame.equipButtons[slotID].itemLink = locationTable.itemLink
            end
            
            TopFit.ProgressFrame.setScoreFontString:SetText("Total Score: "..round(combination.totalScore, 2))
            
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
            local maxStatValue = scorePerStat[statList[1]]
            for i = 1, #statList do
                if (scorePerStat[statList[i]] ~= nil) and (scorePerStat[statList[i]] > 0) then
                    lastStat = i
                    if not statTexts[i] then
                        -- create FontStrings
                        -- fontsting for stat name
                        statusBars[i] = CreateFrame("StatusBar", "TopFit_ProgressFrame_statValueBar"..i, statScrollFrameContent)
                        statTexts[i] = statusBars[i]:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                        valueTexts[i] = statusBars[i]:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                        statTexts[i]:SetTextHeight(11)
                        valueTexts[i]:SetTextHeight(11)
                        --statTexts[i]:SetHeight(32)
                        if i == 1 then
                            statTexts[i]:SetPoint("TOP", TopFit.ProgressFrame.setScoreFontString, "BOTTOM", 0, -10)
                            valueTexts[i]:SetPoint("TOP", TopFit.ProgressFrame.setScoreFontString, "BOTTOM", 0, -10)
                            statTexts[i]:SetPoint("LEFT", statScrollFrameContent, "LEFT", 3, 0)
                            valueTexts[i]:SetPoint("RIGHT", statScrollFrameContent, "RIGHT", -3, 0)
                        else
                            statTexts[i]:SetPoint("TOPLEFT", statTexts[i - 1], "BOTTOMLEFT")
                            valueTexts[i]:SetPoint("TOPRIGHT", valueTexts[i - 1], "BOTTOMRIGHT")
                        end
                        statusBars[i]:SetPoint("TOPLEFT", statTexts[i], "TOPLEFT")
                        statusBars[i]:SetPoint("BOTTOMRIGHT", valueTexts[i], "BOTTOMRIGHT", 0, 1)
                        statusBars[i]:SetStatusBarTexture(minimalist)
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
            local i = 1
            local capNameTexts = statScrollFrameContent.capNameFontStrings
            local capValueTexts = statScrollFrameContent.capValueFontStrings
            
            if not statScrollFrameContent.capHeader then
                statScrollFrameContent.capHeader = statScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                statScrollFrameContent.capHeader:SetTextHeight(15)
                statScrollFrameContent.capHeader:SetText("Caps")
            end
            statScrollFrameContent.capHeader:Hide()
            
            for stat, capTable in pairs(caps) do
                if capTable.active then
                    if not capNameTexts[i] then
                        capNameTexts[i] = statScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                        capValueTexts[i] = statScrollFrameContent:CreateTexture()
                        capValueTexts[i]:SetWidth(11)
                        capValueTexts[i]:SetHeight(11)
                        if i == 1 then
                            capNameTexts[i]:SetPoint("TOPLEFT", statScrollFrameContent.capHeader, "BOTTOMLEFT")
                            capValueTexts[i]:SetPoint("TOP", statScrollFrameContent.capHeader, "BOTTOM")
                            capValueTexts[i]:SetPoint("RIGHT", statScrollFrameContent, "RIGHT")
                        else
                            capNameTexts[i]:SetPoint("TOPLEFT", capNameTexts[i - 1], "BOTTOMLEFT")
                            capValueTexts[i]:SetPoint("TOPRIGHT", capValueTexts[i - 1], "BOTTOMRIGHT")
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
                    
                    i = i + 1
                end
            end
            -- anchor to bottom of stat list
            if capNameTexts[1] then
                statScrollFrameContent.capHeader:SetPoint("TOPLEFT", statTexts[lastStat], "BOTTOMLEFT", 0, -20)
            end
            
            -- hide unused cap texts
            local numCaps = i
            for i = numCaps, #capNameTexts do
                capNameTexts[i]:Hide()
                capValueTexts[i]:Hide()
            end
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
            butt:SetScript("OnEnter", ShowTooltip)
            butt:SetScript("OnLeave", HideTooltip)
            
            return butt
        end
        
        TopFit.ProgressFrame.pluginContainer = CreateFrame("Frame", "TopFit_ProgressFrame_PluginContainer", TopFit.ProgressFrame)
        TopFit.ProgressFrame.pluginContainer:SetPoint("TOPRIGHT", TopFit.ProgressFrame, "TOPRIGHT", -15, -15)
        TopFit.ProgressFrame.pluginContainer:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame, "BOTTOMRIGHT", -15, 15)
        TopFit.ProgressFrame.pluginContainer:SetWidth(TopFit.ProgressFrame:GetWidth() - 30)
        TopFit.ProgressFrame.pluginContainer:Hide()
        
        TopFit.ProgressFrame.rightFrame = TopFit:RegisterPlugin("Weights & Caps", "Use this tab to set weights and caps for your sets, defining their basic behavior.")
        
        -- options button
        TopFit.ProgressFrame.optionsButton = CreateFrame("Button", "TopFit_ProgressFrame_optionsButton", TopFit.ProgressFrame.rightFrame)
        TopFit.ProgressFrame.optionsButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame.rightFrame, "TOPRIGHT", -15, -5)
        TopFit.ProgressFrame.optionsButton:SetHeight(32)
        TopFit.ProgressFrame.optionsButton:SetWidth(32)
        TopFit.ProgressFrame.optionsButton:SetNormalTexture("Interface\\Icons\\INV_Misc_Gear_02")
        TopFit.ProgressFrame.optionsButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        
        -- set options
        TopFit.ProgressFrame.includeInTooltipCheckButton = LibStub("tekKonfig-Checkbox").new(TopFit.ProgressFrame.rightFrame, nil, "Include set in tooltip", "TOPLEFT", TopFit.ProgressFrame.rightFrame, "TOPLEFT", 15, -15)
        TopFit.ProgressFrame.includeInTooltipCheckButton.tiptext = "|cffffffffCheck to show this set in item comparison tooltips when that option is enabled."
        TopFit.ProgressFrame.includeInTooltipCheckButton:SetChecked(TopFit.db.profile.debugMode)
        local checksound = TopFit.ProgressFrame.includeInTooltipCheckButton:GetScript("OnClick")
        TopFit.ProgressFrame.includeInTooltipCheckButton:SetScript("OnClick", function(self)
            checksound(self)
            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].excludeFromTooltip = not TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].excludeFromTooltip
        end)
        
        TopFit.ProgressFrame.optionsButton:SetScript("OnClick", function(...)
            InterfaceOptionsFrame_OpenToCategory("TopFit")
            TopFit.ProgressFrame:Hide()
        end)
        TopFit.ProgressFrame.optionsButton.tipText = "Open TopFit's options"
        TopFit.ProgressFrame.optionsButton:SetScript("OnEnter", ShowTooltip)
        TopFit.ProgressFrame.optionsButton:SetScript("OnLeave", HideTooltip)
        
        TopFit.ProgressFrame.statDropDown = CreateFrame("Frame", "TopFit_ProgressFrame_statDropDown", TopFit.ProgressFrame.rightFrame, "UIDropDownMenuTemplate")
        --TopFit.ProgressFrame.statDropDown:SetPoint("TOPLEFT", TopFit.ProgressFrame.rightFrame, "TOPLEFT", 20, -20)
        UIDropDownMenu_Initialize(TopFit.ProgressFrame.statDropDown, function(self, level)
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
                info.text = "Set Piece";
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
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights["SET: "..setnames[i]] = 0
                            TopFit.ProgressFrame:UpdateSetStats()
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
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[value] = 0
                            TopFit.ProgressFrame:UpdateSetStats()
                            TopFit:CalculateScores()
                        end
                        UIDropDownMenu_AddButton(info, level);
                    end
                end
            end
        end, "MENU")
        UIDropDownMenu_JustifyText(TopFit.ProgressFrame.statDropDown, "LEFT")
        
        TopFit.ProgressFrame.addStatButton = CreateFrame("Button", "TopFit_ProgressFrame_expandButton", TopFit.ProgressFrame.rightFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.addStatButton:SetPoint("TOPLEFT", TopFit.ProgressFrame.rightFrame, "TOPLEFT", 5, -45)
        TopFit.ProgressFrame.addStatButton:SetText("Add stat...")
        TopFit.ProgressFrame.addStatButton:SetHeight(22)
        TopFit.ProgressFrame.addStatButton:SetWidth(80)
        TopFit.ProgressFrame.addStatButton:RegisterForClicks("AnyUp")
        
        TopFit.ProgressFrame.addStatButton:SetScript("OnClick", function(self, button)
            ToggleDropDownMenu(1, nil, TopFit.ProgressFrame.statDropDown, self, -20, 0)
        end)
        
        TopFit.ProgressFrame.editStatScrollFrame = CreateFrame("ScrollFrame", "TopFit_EditStatScrollFrame", TopFit.ProgressFrame.rightFrame, "UIPanelScrollFrameTemplate")
        TopFit.ProgressFrame.editStatScrollFrame:SetPoint("TOPLEFT", TopFit.ProgressFrame.addStatButton, "BOTTOMLEFT", 0, -25)
        TopFit.ProgressFrame.editStatScrollFrame:SetPoint("BOTTOMRIGHT", TopFit.ProgressFrame, "BOTTOMRIGHT", -25, 5)
        TopFit.ProgressFrame.editStatScrollFrame:SetHeight(boxHeight)
        TopFit.ProgressFrame.editStatScrollFrame:SetWidth(boxWidth)
        local editStatScrollFrameContent = CreateFrame("Frame", nil, TopFit.ProgressFrame.editStatScrollFrame)
        editStatScrollFrameContent:SetAllPoints()
        editStatScrollFrameContent:SetHeight(boxHeight)
        editStatScrollFrameContent:SetWidth(235)
        TopFit.ProgressFrame.editStatScrollFrame:SetScrollChild(editStatScrollFrameContent)
        TopFit.ProgressFrame.editStatScrollFrame:SetBackdrop(backdrop)
        TopFit.ProgressFrame.editStatScrollFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
        TopFit.ProgressFrame.editStatScrollFrame:SetBackdropColor(0.1, 0.1, 0.1)
        
        -- containers for stat list
        TopFit.ProgressFrame.rightFrame.menuHeaders = {}
        TopFit.ProgressFrame.rightFrame.statCapCheckboxes = {}
        TopFit.ProgressFrame.rightFrame.editStatNameTexts = {}
        TopFit.ProgressFrame.rightFrame.editStatValueTexts = {}
        TopFit.ProgressFrame.rightFrame.editStatButtons = {}
        TopFit.ProgressFrame.rightFrame.statCapTexts = {}
        TopFit.ProgressFrame.rightFrame.statCapValueTexts = {}
        TopFit.ProgressFrame.rightFrame.statCapButtons = {}
        TopFit.ProgressFrame.rightFrame.capTypeTexts = {}
        TopFit.ProgressFrame.rightFrame.capTypeButtons = {}
        
        function TopFit.ProgressFrame:UpdateSetStats()
            local menuHeaders = TopFit.ProgressFrame.rightFrame.menuHeaders
            local statTexts = TopFit.ProgressFrame.rightFrame.editStatNameTexts
            local valueTexts = TopFit.ProgressFrame.rightFrame.editStatValueTexts
            local capBoxes = TopFit.ProgressFrame.rightFrame.statCapCheckboxes
            local statButtons = TopFit.ProgressFrame.rightFrame.editStatButtons
            local capTexts = TopFit.ProgressFrame.rightFrame.statCapTexts
            local capValueTexts = TopFit.ProgressFrame.rightFrame.statCapValueTexts
            local capButtons = TopFit.ProgressFrame.rightFrame.statCapButtons
            local capTypeTexts = TopFit.ProgressFrame.rightFrame.capTypeTexts
            local capTypeButtons = TopFit.ProgressFrame.rightFrame.capTypeButtons
            
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
            
            -- headers
            local headerTitles = {{"Name", 165}, {"Value", 40}, {"Cap", 35}}
            if not menuHeaders[1] then
                local prefix = "TopFit_ProgressFrame_MenuHeader_"
                for i = 1, #headerTitles do
                    menuHeaders[i] = TopFit.ProgressFrame:CreateHeaderButton(TopFit.ProgressFrame.rightFrame, prefix .. headerTitles[i][1])
                    if i == 1 then
                        menuHeaders[i]:SetPoint("BOTTOMLEFT", TopFit.ProgressFrame.editStatScrollFrame, "TOPLEFT")
                    else
                        menuHeaders[i]:SetPoint("TOPLEFT", menuHeaders[i-1], "TOPRIGHT")
                    end
                    menuHeaders[i]:SetText(headerTitles[i][1])
                    menuHeaders[i].tiptext = headerTitles[i][1]
                    menuHeaders[i]:SetWidth(headerTitles[i][2])
                    menuHeaders[i]:SetScript("OnClick", function(self)
                        if TopFit.db.profile.statSortOrder == headerTitles[i][1].."Asc" then
                            TopFit.db.profile.statSortOrder = headerTitles[i][1].."Desc"
                        else
                            TopFit.db.profile.statSortOrder = headerTitles[i][1].."Asc"
                        end
                        
                        TopFit.ProgressFrame:UpdateSetStats()
                    end)
                    menuHeaders[i]:Show()
                end
            end
            
            -- actual stat entries
            local stat, value
            local actualStatCount = 1
            for i = 1, #sortableStatWeightTable do
                stat = sortableStatWeightTable[i][1]
                value = sortableStatWeightTable[i][2]
                
                if not statTexts[i] then
                    statButtons[i] = CreateFrame("Button", "TopFit_ProgressFrame_editStatButton"..i, editStatScrollFrameContent)
                    statTexts[i] = editStatScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                    valueTexts[i] = editStatScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                    capBoxes[i] = CreateFrame("CheckButton", "TopFit_ProgressFrame_CapCheckBox"..i, editStatScrollFrameContent, "UICheckButtonTemplate")
                    capButtons[i] = CreateFrame("Button", "TopFit_ProgressFrame_editCapButton"..i, editStatScrollFrameContent)
                    capTexts[i] = editStatScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                    capValueTexts[i] = editStatScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                    capTypeButtons[i] = CreateFrame("Button", "TopFit_ProgressFrame_editCapTypeButton"..i, editStatScrollFrameContent)
                    capTypeTexts[i] = editStatScrollFrameContent:CreateFontString(nil, "ARTWORK", "GameFontHighlightExtraSmall")
                    
                    statTexts[i]:SetTextHeight(11)
                    valueTexts[i]:SetTextHeight(11)
                    capTexts[i]:SetTextHeight(11)
                    capValueTexts[i]:SetTextHeight(11)
                    capTypeTexts[i]:SetTextHeight(11)
                    if i == 1 then
                        statTexts[i]:SetPoint("TOPLEFT", editStatScrollFrameContent, "TOPLEFT", 3, -3)
                    else
                        statTexts[i]:SetPoint("TOPLEFT", capTexts[i - 1], "BOTTOMLEFT")
                    end
                    valueTexts[i]:SetPoint("RIGHT", statTexts[i], "LEFT", headerTitles[1][2] + headerTitles[2][2] - 4, 0)
                    capTexts[i]:SetPoint("TOPLEFT", statTexts[i], "BOTTOMLEFT")
                    capValueTexts[i]:SetPoint("RIGHT", capTexts[i], "LEFT", headerTitles[1][2] + headerTitles[2][2] - 4, 0)
                    capTypeTexts[i]:SetPoint("LEFT", capBoxes[i], "LEFT")
                    capTypeTexts[i]:SetPoint("RIGHT", editStatScrollFrameContent, "RIGHT")
                    capTypeTexts[i]:SetPoint("TOP", capValueTexts[i], "TOP")
                    statButtons[i].i = i
                    statButtons[i]:SetPoint("TOPLEFT", statTexts[i], "TOPLEFT")
                    statButtons[i]:SetPoint("BOTTOMRIGHT", valueTexts[i], "BOTTOMRIGHT")
                    --statButtons[i]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
                    statButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                    statButtons[i]:SetAlpha(0.5)
                    statButtons[i]:SetScript("OnClick", function(self)
                        TopFit.ProgressFrame:HideStatEditTextBox()
                        TopFit.ProgressFrame:ShowStatEditTextBox(self.i)
                    end)
                    capButtons[i].i = i
                    capButtons[i]:SetPoint("TOPLEFT", capTexts[i], "TOPLEFT")
                    capButtons[i]:SetPoint("BOTTOMRIGHT", capValueTexts[i], "BOTTOMRIGHT")
                    --statButtons[i]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
                    capButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                    capButtons[i]:SetAlpha(0.5)
                    capButtons[i]:SetScript("OnClick", function(self)
                        TopFit.ProgressFrame:HideStatEditTextBox()
                        TopFit.ProgressFrame:ShowStatEditTextBox(self.i, true)
                    end)
                    capTypeButtons[i].i = i
                    capTypeButtons[i]:SetPoint("TOPLEFT", capTypeTexts[i], "TOPLEFT")
                    capTypeButtons[i]:SetPoint("BOTTOMRIGHT", capTypeTexts[i], "BOTTOMRIGHT")
                    --statButtons[i]:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
                    capTypeButtons[i]:SetHighlightTexture("Interface\\Buttons\\UI-ListBox-Highlight")
                    capTypeButtons[i]:SetAlpha(0.5)
                    capTypeButtons[i]:SetScript("OnClick", function(self)
                        local stat = TopFit.ProgressFrame.rightFrame.editStatButtons[self.i].myStat
                        if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].soft then
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].soft = false
                        else
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].soft = true
                        end
                        TopFit.ProgressFrame:UpdateSetStats()
                    end)
                    
                    capBoxes[i].i = i
                    capBoxes[i]:SetHeight(12); capBoxes[i]:SetWidth(12)
                    capBoxes[i]:SetPoint("LEFT", valueTexts[i], "RIGHT")
                    capBoxes[i]:SetScript("OnClick", function(self)
                        local stat = TopFit.ProgressFrame.rightFrame.editStatButtons[self.i].myStat
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
                        
                        TopFit.ProgressFrame:UpdateSetStats()
                        TopFit:CalculateScores()
                    end)
                end
                statButtons[i]:Show()
                statTexts[i]:Show()
                valueTexts[i]:Show()
                statTexts[i]:SetText(_G[stat] or string.gsub(stat, "SET: ", "Set: "))
                valueTexts[i]:SetText(value)
                if TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat] and TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].active then
                    capBoxes[i]:SetChecked(true)
                    capTexts[i]:SetText("   Cap")
                    capValueTexts[i]:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].value)
                    capTypeTexts[i]:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].soft and "Soft" or "Hard")
                    capValueTexts[i]:Show()
                    capTypeTexts[i]:Show()
                    capButtons[i]:Show()
                    capTypeButtons[i]:Show()
                else
                    capBoxes[i]:SetChecked(false)
                    capTexts[i]:SetText("")
                    capValueTexts[i]:Hide()
                    capTypeTexts[i]:Hide()
                    capButtons[i]:Hide()
                    capTypeButtons[i]:Hide()
                end
                capBoxes[i]:Show()
                statButtons[i].myStat = stat
                actualStatCount = actualStatCount + 1
            end
            
            -- hide any texts not in use
            for i = actualStatCount, #statTexts do
                statTexts[i]:Hide()
                valueTexts[i]:Hide()
                statButtons[i]:Hide()
                capBoxes[i]:Hide()
                capTexts[i]:SetText("")
                capValueTexts[i]:Hide()
                capTypeTexts[i]:Hide()
                capButtons[i]:Hide()
                capTypeButtons[i]:Hide()
            end
        end
        
        function TopFit.ProgressFrame:ShowStatEditTextBox(statID, isCap)
            if not TopFit.ProgressFrame.statEditTextBox then
                -- create box
                TopFit.ProgressFrame.statEditTextBox = CreateFrame("EditBox", "TopFit_ProgressFrame_statEditTextBox", editStatScrollFrameContent)
                TopFit.ProgressFrame.statEditTextBox:SetWidth(50)
                TopFit.ProgressFrame.statEditTextBox:SetHeight(11)
                TopFit.ProgressFrame.statEditTextBox:SetAutoFocus(false)
                TopFit.ProgressFrame.statEditTextBox:SetFontObject("GameFontHighlightSmall")
                TopFit.ProgressFrame.statEditTextBox:SetJustifyH("RIGHT")
                
                -- background textures
                local left = TopFit.ProgressFrame.statEditTextBox:CreateTexture(nil, "BACKGROUND")
                left:SetWidth(8) left:SetHeight(20)
                left:SetPoint("LEFT", -5, 0)
                left:SetTexture("Interface\\Common\\Common-Input-Border")
                left:SetTexCoord(0, 0.0625, 0, 0.625)
                local right = TopFit.ProgressFrame.statEditTextBox:CreateTexture(nil, "BACKGROUND")
                right:SetWidth(8) right:SetHeight(20)
                right:SetPoint("RIGHT", 0, 0)
                right:SetTexture("Interface\\Common\\Common-Input-Border")
                right:SetTexCoord(0.9375, 1, 0, 0.625)
                local center = TopFit.ProgressFrame.statEditTextBox:CreateTexture(nil, "BACKGROUND")
                center:SetHeight(20)
                center:SetPoint("RIGHT", right, "LEFT", 0, 0)
                center:SetPoint("LEFT", left, "RIGHT", 0, 0)
                center:SetTexture("Interface\\Common\\Common-Input-Border")
                center:SetTexCoord(0.0625, 0.9375, 0, 0.625)
                
                -- scripts
                TopFit.ProgressFrame.statEditTextBox:SetScript("OnEscapePressed", function (self)
                    TopFit.ProgressFrame:HideStatEditTextBox()
                    TopFit.ProgressFrame:UpdateSetStats()
                end)
                
                TopFit.ProgressFrame.statEditTextBox:SetScript("OnEnterPressed", function (self)
                    -- save new stat value if it is numeric
                    local value = tonumber(TopFit.ProgressFrame.statEditTextBox:GetText())
                    local stat = TopFit.ProgressFrame.rightFrame.editStatButtons[TopFit.ProgressFrame.statEditTextBox.statID].myStat
                    local isCap = TopFit.ProgressFrame.statEditTextBox.isCap
                    if value and stat then -- otherwise, the text was probably not a number
                        if not isCap then
                            if value == 0 then value = nil end
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[stat] = value
                        else
                            TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[stat].value = value
                        end
                    else
                        TopFit:Debug("invalid input")
                    end
                    TopFit.ProgressFrame:HideStatEditTextBox()
                    TopFit.ProgressFrame:UpdateSetStats()
                    TopFit:CalculateScores()
                end)
            end
            if not isCap then
                TopFit.ProgressFrame.statEditTextBox:SetPoint("RIGHT", TopFit.ProgressFrame.rightFrame.editStatValueTexts[statID], "RIGHT")
                TopFit.ProgressFrame.statEditTextBox:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights[TopFit.ProgressFrame.rightFrame.editStatButtons[statID].myStat])
                TopFit.ProgressFrame.rightFrame.editStatValueTexts[statID]:Hide()
            else
                TopFit.ProgressFrame.statEditTextBox:SetPoint("RIGHT", TopFit.ProgressFrame.rightFrame.statCapValueTexts[statID], "RIGHT")
                TopFit.ProgressFrame.statEditTextBox:SetText(TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps[TopFit.ProgressFrame.rightFrame.editStatButtons[statID].myStat].value)
                TopFit.ProgressFrame.rightFrame.statCapValueTexts[statID]:Hide()
            end
            TopFit.ProgressFrame.statEditTextBox:Show()
            TopFit.ProgressFrame.statEditTextBox:HighlightText()
            TopFit.ProgressFrame.statEditTextBox:SetFocus()
            TopFit.ProgressFrame.statEditTextBox.statID = statID
            TopFit.ProgressFrame.statEditTextBox.isCap = isCap
        end
        
        function TopFit.ProgressFrame:HideStatEditTextBox()
            if TopFit.ProgressFrame.statEditTextBox then
                TopFit.ProgressFrame.statEditTextBox:Hide()
                TopFit.ProgressFrame.statEditTextBox:ClearFocus()
            end
        end
        
        -- create plugin frame for virtual items
        TopFit:CreateVirtualItemsPlugin()
        
        -- center frame on screen
        TopFit.ProgressFrame:SetPoint("CENTER", 0, 0)
        
        -- select default set
        TopFit.ProgressFrame:SetSelectedSet()
    end
    
    if not TopFit.ProgressFrame:IsShown() then
        TopFit.ProgressFrame:Show()
        TopFit.ProgressFrame:UpdateSetStats()
    end
end

function TopFit:HideProgressFrame()
    TopFit.ProgressFrame:Hide()
end

function TopFit:CreateVirtualItemsPlugin()
    local frame = TopFit:RegisterPlugin("Vir(tu)al Items", "Use this tab to include items you currently do not have in your inventory in the calculation.")
    
    -- label for item text box
    frame.addItemLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    frame.addItemLabel:SetWordWrap(true)
    frame.addItemLabel:SetHeight(30)
    frame.addItemLabel:SetPoint("TOPLEFT")
    frame.addItemLabel:SetPoint("TOPRIGHT")
    frame.addItemLabel:SetText("Paste an item link or an item ID in this edit box and press <Enter> to add that item to your virtual items.")
    
    -- create text box for items
    frame.addItemTextBox = CreateFrame("EditBox", "$parent_AddItemTextBox", frame)
    frame.addItemTextBox:SetWidth(50)
    frame.addItemTextBox:SetHeight(11)
    frame.addItemTextBox:SetAutoFocus(false)
    frame.addItemTextBox:SetFontObject("GameFontHighlightSmall")
    frame.addItemTextBox:SetJustifyH("LEFT")
    
    frame.addItemTextBox:SetPoint("LEFT")
    frame.addItemTextBox:SetPoint("RIGHT")
    frame.addItemTextBox:SetPoint("TOP", frame.addItemLabel, "BOTTOM", 0, -10)
    
    -- background textures
    local left = frame.addItemTextBox:CreateTexture(nil, "BACKGROUND")
    left:SetWidth(8) left:SetHeight(20)
    left:SetPoint("LEFT", -5, 0)
    left:SetTexture("Interface\\Common\\Common-Input-Border")
    left:SetTexCoord(0, 0.0625, 0, 0.625)
    local right = frame.addItemTextBox:CreateTexture(nil, "BACKGROUND")
    right:SetWidth(8) right:SetHeight(20)
    right:SetPoint("RIGHT", 0, 0)
    right:SetTexture("Interface\\Common\\Common-Input-Border")
    right:SetTexCoord(0.9375, 1, 0, 0.625)
    local center = frame.addItemTextBox:CreateTexture(nil, "BACKGROUND")
    center:SetHeight(20)
    center:SetPoint("RIGHT", right, "LEFT", 0, 0)
    center:SetPoint("LEFT", left, "RIGHT", 0, 0)
    center:SetTexture("Interface\\Common\\Common-Input-Border")
    center:SetTexCoord(0.0625, 0.9375, 0, 0.625)
    
    -- scripts
    frame.addItemTextBox:SetScript("OnEscapePressed", function (self)
        frame.addItemTextBox:SetText("")
        frame.addItemTextBox:ClearFocus()
    end)
    
    frame.addItemTextBox:SetScript("OnEnterPressed", function (self)
        -- check if input is itemLink or itemID
        name, link = GetItemInfo(self:GetText())
        
        if not link then
            TopFit:Print("Item not found.")
        else
            TopFit:Print("Adding "..link.." to virtual items...")
        end
    end)
    
    -- hook shift-clicks on items
    -- Hook the container buttons
    local containerFunc = function(button)
        if IsShiftKeyDown() and frame.addItemTextBox:HasFocus() then
            frame.addItemTextBox:Insert(GetContainerItemLink(button:GetParent():GetID(), button:GetID()))
        end
    end
    hooksecurefunc("ContainerFrameItemButton_OnModifiedClick", containerFunc)

    -- Hook the bank buttons
    local bankFunc = function(button)
        if IsShiftKeyDown() and frame.addItemTextBox:HasFocus() then
            frame.addItemTextBox:Insert(GetContainerItemLink(BANK_CONTAINER, button:GetID()))
        end
    end
    hooksecurefunc("BankFrameItemButtonGeneric_OnModifiedClick", bankFunc)

    -- Hook the paper doll frame buttons
    local dollFunc = function(button)
        if IsShiftKeyDown() and frame.addItemTextBox:HasFocus() then
            frame.addItemTextBox:Insert(GetInventoryItemLink("player", button:GetID()))
        end
    end
    hooksecurefunc("PaperDollItemSlotButton_OnModifiedClick", dollFunc)
    
    -- item list
    local backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        tile = true,
        tileSize = 32,
        insets = { left = 0, right = -22, top = 0, bottom = 0 }}
    
    frame.itemsFrame = CreateFrame("ScrollFrame", "$parent_ItemsFrame", frame, "UIPanelScrollFrameTemplate")
    frame.itemsFrame:SetPoint("TOPLEFT", frame.addItemTextBox, "BOTTOMLEFT", 0, -25)
    frame.itemsFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -25, 0)
    frame.itemsFrame:SetHeight(frame.itemsFrame:GetHeight())
    frame.itemsFrame:SetWidth(frame.itemsFrame:GetWidth())
    local itemsFrameContent = CreateFrame("Frame", nil, frame.itemsFrame)
    itemsFrameContent:SetAllPoints()
    --itemsFrameContent:SetHeight(boxHeight)
    --itemsFrameContent:SetWidth(235)
    frame.itemsFrame:SetScrollChild(editStatScrollFrameContent)
    frame.itemsFrame:SetBackdrop(backdrop)
    frame.itemsFrame:SetBackdropBorderColor(0.4, 0.4, 0.4)
    frame.itemsFrame:SetBackdropColor(0.1, 0.1, 0.1)
    
end
