local function tinsertonce(table, data)
    local found = false
    for _, v in pairs(table) do
        if v == data then
            found = true
            break
        end
    end
    if not found then
        tinsert(table, data)
    end
end

function TopFit:CreateVirtualItemsPlugin()
    local frame, pluginId = TopFit:RegisterPlugin(TopFit.locale.VirtualItems, "Interface\\Icons\\Achievement_Arena_3v3_7", TopFit.locale.VirtualItemsTooltip)
    frame.initialized = false
    
    -- register events
    TopFit.RegisterCallback("TopFit_vitualItems", "OnShow", function(event, id)
        if (id == pluginId) then
            if (not frame.initialized) then
                -- initialize interface when shown the first time
                local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
                title:SetPoint("TOPLEFT", 16, -4)
                title:SetText(TopFit.locale.VirtualItems)
                
                local explain = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
                explain:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -10, -8)
                explain:SetPoint("RIGHT", frame, -4, 0)
                explain:SetHeight(77)
                explain:SetNonSpaceWrap(true)
                explain:SetJustifyH("LEFT")
                explain:SetJustifyV("TOP")
                explain:SetText(TopFit.locale.VIExplanation)
                
                -- option for disabling virtual items calculation
                local enable = LibStub("tekKonfig-Checkbox").new(frame, nil, TopFit.locale.IncludeVI, "TOPLEFT", explain, "BOTTOMLEFT", 10, -4)
                enable.tiptext = TopFit.locale.IncludeVITooltip
                if TopFit.selectedSet then
                    enable:SetChecked(not TopFit.db.profile.sets[TopFit.selectedSet].skipVirtualItems)
                end
                local checksound = enable:GetScript("OnClick")
                enable:SetScript("OnClick", function(self)
                    checksound(self)
                    if (TopFit.selectedSet) then
                        TopFit.db.profile.sets[TopFit.selectedSet].skipVirtualItems = not TopFit.db.profile.sets[TopFit.selectedSet].skipVirtualItems
                    end
                end)
                frame.includeVirtualItemsCheckButton = enable
                
                -- label for item text box
                frame.addItemLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
                frame.addItemLabel:SetNonSpaceWrap(true)
                frame.addItemLabel:SetJustifyH("LEFT")
                frame.addItemLabel:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", -10, -4)
                frame.addItemLabel:SetPoint("RIGHT", frame, -4, 2)
                frame.addItemLabel:SetHeight(33)
                frame.addItemLabel:SetText(TopFit.locale.VIUsage)
                
                -- create text box for items
                frame.addItemTextBox = CreateFrame("EditBox", "$parent_AddItemTextBox", frame)
                frame.addItemTextBox:SetFontObject("GameFontNormalSmall")
                frame.addItemTextBox:SetJustifyH("LEFT")
                frame.addItemTextBox:SetAutoFocus(false)
                frame.addItemTextBox:SetTextInsets(6, 6, 0, 0)
                frame.addItemTextBox:SetHeight(24)
                frame.addItemTextBox:SetPoint("TOPLEFT", frame.addItemLabel, "BOTTOMLEFT", 0, -4)
                frame.addItemTextBox:SetPoint("TOPRIGHT", frame, "RIGHT", -4, 0)
                frame.addItemTextBox:SetText(TopFit.locale.VIAddItem)
                frame.addItemTextBox:SetBackdrop({
					bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
					edgeSize = 16,
					insets = {left = 4, right = 4, top = 4, bottom = 4}
				})
                frame.addItemTextBox:SetBackdropColor(.1, .1, .1, .8)
				frame.addItemTextBox:SetBackdropBorderColor(.5, .5, .5)
                
                -- scripts
                frame.addItemTextBox:SetScript("OnEditFocusGained", frame.addItemTextBox.HighlightText)
                frame.addItemTextBox:SetScript("OnEscapePressed", function (self)
                    frame.addItemTextBox:SetText(TopFit.locale.VIAddItem)
                    frame.addItemTextBox:ClearFocus()
                end)
                frame.addItemTextBox:SetScript("OnEnterPressed", function (self)
                    -- check if input is itemLink or itemID
                    local text = self:GetText()
                    if text == "" or text == TopFit.locale.VIAddItem then
                        frame.addItemTextBox:SetText(TopFit.locale.VIAddItem)
                        frame.addItemTextBox:ClearFocus()
                    end
                    local link = select(2, GetItemInfo(text))
                    frame.addItemTextBox:ClearFocus()
                    frame.addItemTextBox:SetText(TopFit.locale.VIAddItem)
                    
                    if not link then
                        TopFit:Print(TopFit.locale.VIItemNotFound)
                    else
                        TopFit:Debug("Adding "..link.." to virtual items")
                        frame.itemsFrame:AddItem(link)
                    end
                end)
                hooksecurefunc("ChatEdit_InsertLink", function(text)    -- hook shift-clicks on items
                    if frame.addItemTextBox:HasFocus() then
                        frame.addItemTextBox:Insert(text)
                    end
                end)
                
                frame.panel = LibStub("tekKonfig-Group").new(frame, "Your virtual items")
                frame.panel:SetPoint("TOPLEFT", frame.addItemTextBox, "BOTTOMLEFT", 0, -14)
                frame.panel:SetPoint("BOTTOMRIGHT", frame, -2, 2)
                
                frame.itemsFrame = CreateFrame("ScrollFrame", "TopFit_VirtualItemsScrollFrame", frame.panel, "UIPanelScrollFrameTemplate")
                frame.itemsFrame:SetPoint("TOPLEFT", 6, -6)
                frame.itemsFrame:SetPoint("RIGHT", -27, 4)
                frame.itemsFrame:SetHeight(150)
                frame.itemsFrame.content = CreateFrame("Frame", nil, frame.itemsFrame)
                frame.itemsFrame.content:SetHeight(225)
                frame.itemsFrame.content:SetWidth(280)
                frame.itemsFrame.content:SetAllPoints()
                frame.itemsFrame:SetScrollChild(frame.itemsFrame.content)
                
                frame.itemsFrame.buttons = {}
                function frame.itemsFrame:AddItem(link)
                    local invSlot = select(9, GetItemInfo(link))
                    if TopFit.selectedSet and invSlot and 
                        string.find(invSlot, "INVTYPE") and not string.find(invSlot, "BAG") then
                        
                        if not TopFit.db.profile.sets[TopFit.selectedSet].virtualItems then 
                            TopFit.db.profile.sets[TopFit.selectedSet].virtualItems = {}
                        end
                        tinsertonce(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems, link)
                    else
                        if TopFit.selectedSet then
                            TopFit:Print(string.format(TopFit.locale.VIErrorNotEquippable, link))
                        else
                            TopFit:Print(TopFit.locale.VIErrorNoSet)
                        end
                    end
                    frame.itemsFrame:RefreshItems()
                end
                
                function frame.itemsFrame:RefreshItems()
                    local lastLine, totalWidth = 1, 0
                    local numUsedButtons = 9
                    if (TopFit.selectedSet) then
                        if (TopFit.db.profile.sets[TopFit.selectedSet].virtualItems) then
                            for i = 1, #(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems) do
                                numUsedButtons = numUsedButtons + 1
                                if not frame.itemsFrame.buttons[i] then
                                    local button = CreateFrame("Button", "$parent_ItemButton"..i, frame.itemsFrame.content, "ItemButtonTemplate")
                                    
                                    button:RegisterForClicks("RightButtonUp")
                                    button:SetScript("OnEnter", TopFit.ShowTooltip)
                                    button:SetScript("OnLeave", TopFit.HideTooltip)
                                    button:SetScript("OnClick", function(self)
                                        -- remove item from list
                                        if (TopFit.selectedSet and TopFit.db.profile.sets[TopFit.selectedSet].virtualItems) then
                                            -- find item and remove it
                                            local i
                                            for i = 1, #(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems) do
                                                if (self.itemLink == TopFit.db.profile.sets[TopFit.selectedSet].virtualItems[i]) then
                                                    tremove(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems, i)
                                                end
                                            end
                                            
                                            frame.itemsFrame:RefreshItems()
                                        end
                                    end)
                                    frame.itemsFrame.buttons[i] = button
                                end
                                local button = frame.itemsFrame.buttons[i]
                                button.itemLink = TopFit.db.profile.sets[TopFit.selectedSet].virtualItems[i]
                                
                                local texture = select(10, GetItemInfo(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems[i]))
                                if not texture then texture = "Interface\\Icons\\Inv_Misc_Questionmark" end
                                SetItemButtonTexture(button, texture)
                                button:Show()
                                
                                if i == 1 then
                                    -- anchor to top left of frame
                                    button:SetPoint("TOPLEFT", frame.itemsFrame.content, "TOPLEFT", 2, -2)
                                    totalWidth = totalWidth + button:GetWidth() + 2*4    -- padding needs to be added
                                else
                                    -- anchor to previous item, or beginning of next line
                                    if (totalWidth + button:GetWidth()) <= frame.itemsFrame:GetWidth() then
                                        button:SetPoint("TOPLEFT", frame.itemsFrame.buttons[i - 1], "TOPRIGHT", 2, 0)
                                        totalWidth = totalWidth + button:GetWidth() + 2
                                    else
                                        button:SetPoint("TOPLEFT", frame.itemsFrame.buttons[lastLine], "BOTTOMLEFT", 0, -2)
                                        totalWidth = button:GetWidth() + 2*4
                                        lastLine = i
                                    end
                                end
                            end
                        end
                    end
                    
                    -- hide unused buttons
                    for i = numUsedButtons + 1, #(frame.itemsFrame.buttons) do
                        frame.itemsFrame.buttons[i]:Hide()
                    end
                end
                frame.initialized = true
            end
            
            
            frame.itemsFrame:RefreshItems()
        end
    end)
    
    TopFit.RegisterCallback("TopFit_vitualItems", "OnSetChanged", function(event, setId)
        if (setId) then
            -- enable inputs
        else
            -- no set selected, disable inputs
        end
        if (frame.initialized) then
            frame.itemsFrame:RefreshItems()
        end
    end)
end
