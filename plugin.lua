function TopFit:RegisterPlugin(pluginName, icon, tooltipText)
    -- create / register plugin-tab
    local pluginInfo = {
        name = pluginName,
        tooltipText = tooltipText,
        icon = icon,
    }
    
    tinsert(TopFit.plugins, pluginInfo)
    pluginInfo.id = #(TopFit.plugins)
    
    -- return frame for plugin UI
    pluginInfo.frame = CreateFrame("Frame", "TopFit_ProgressFrame_PluginFrame_"..(pluginInfo.id), nil)
    if pluginInfo.id > 1 then
        pluginInfo.frame:Hide()
    end
    
    TopFit:UpdatePlugins()
    
    return pluginInfo.frame, pluginInfo.id
end

local function CreateSideTab(tabTexture, tabName, parent)
    local button = CreateFrame("CheckButton", tabName, parent, "SpellBookSkillLineTabTemplate")
    button:SetNormalTexture(tabTexture or "Interface\\Icons\\INV_Misc_QuestionMark")
    button:Hide()
    return button
end

function TopFit:UpdatePlugins()
    if TopFit.ProgressFrame then
        for pluginID, pluginInfo in ipairs(TopFit.plugins) do
            -- update parents and anchors for plugin frames
            pluginInfo.frame:SetParent(TopFit.ProgressFrame.pluginContainer)
            pluginInfo.frame:SetAllPoints()
            
            -- create tabs if necessary
            if not pluginInfo.tabButton then
                pluginInfo.tabButton = CreateSideTab(pluginInfo.icon, "TopFit_ProgressFrame_PluginButton_"..pluginID, TopFit.ProgressFrame.pluginContainer)
                pluginInfo.tabButton:SetID(pluginID)
                if (pluginID == 1) then
                    pluginInfo.tabButton:SetPoint("TOPLEFT", TopFit.ProgressFrame.pluginContainer, "TOPRIGHT", 14, -4)
                    pluginInfo.tabButton:SetChecked(true)
                else
                    pluginInfo.tabButton:SetPoint("TOPLEFT", TopFit.plugins[pluginID - 1].tabButton, "BOTTOMLEFT", 0, -16)
                end
                pluginInfo.tabButton:Show()
                
                -- set event handlers
                pluginInfo.tabButton:SetScript("OnClick", function(self)
                    local id = self:GetID()
                    for i = 1, #(TopFit.plugins) do
                        if i == id then
                            TopFit.plugins[i].frame:Show()
                            TopFit.eventHandler:Fire("OnShow", id)
                        else
                            TopFit.plugins[i].tabButton:SetChecked(false)
                            TopFit.plugins[i].frame:Hide()
                        end
                    end
                end)
            end
            pluginInfo.tabButton.tipText = pluginInfo.name .. (pluginInfo.tooltipText and "\n"..HIGHLIGHT_FONT_COLOR_CODE..pluginInfo.tooltipText..FONT_COLOR_CODE_CLOSE or "")
            pluginInfo.tabButton:SetScript("OnEnter", TopFit.ShowTooltip)
            pluginInfo.tabButton:SetScript("OnLeave", TopFit.HideTooltip)
        end
    end
end

--[[function TopFit:SelectPluginTab(self)
    local id = self:GetID()
    for i = 1, #(TopFit.plugins) do
        if i == id then
            TopFit.plugins[i].frame:Show()
            TopFit.eventHandler:Fire("OnShow", id)
        else
            TopFit.plugins[i].tabButton:SetChecked(false)
            TopFit.plugins[i].frame:Hide()
        end
    end
end]]
