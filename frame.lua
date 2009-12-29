function TopFit:CreateProgressFrame()
    if not TopFit.ProgressFrame then
        -- actual frame
        TopFit.ProgressFrame = CreateFrame("Frame")
        TopFit.ProgressFrame:ClearAllPoints()
        TopFit.ProgressFrame:SetBackdrop(StaticPopup1:GetBackdrop())
        TopFit.ProgressFrame:SetHeight(100)
        TopFit.ProgressFrame:SetWidth(200)
        
        -- progress text
        TopFit.ProgressFrame.progressText = TopFit.ProgressFrame:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
        TopFit.ProgressFrame.progressText:SetPoint("TOPLEFT", 20, -20)
        TopFit.ProgressFrame.progressText:SetPoint("TOPRIGHT", -20, -20)
        TopFit.ProgressFrame.progressText:SetText("0.00%")
        
        function TopFit.ProgressFrame:SetProgress(progress)
            TopFit.ProgressFrame.progressText:SetText(round(progress * 100, 2).."%")
        end
        
        -- abort button
        TopFit.ProgressFrame.abortButton = CreateFrame("Button", "TopFit_ProgressFrame_abortButton", TopFit.ProgressFrame, "UIPanelButtonTemplate")
        TopFit.ProgressFrame.abortButton:SetPoint("TOPLEFT", TopFit.ProgressFrame.progressText, "BOTTOMLEFT")
        TopFit.ProgressFrame.abortButton:SetPoint("TOPRIGHT", TopFit.ProgressFrame.progressText, "BOTTOMRIGHT")
        TopFit.ProgressFrame.abortButton:SetText("Abort")
        TopFit.ProgressFrame.abortButton:SetHeight(20)
        
        TopFit.ProgressFrame.abortButton:SetScript("OnClick", TopFit.AbortCalculations)
        
        -- center frame on screen
        TopFit.ProgressFrame:SetPoint("CENTER", 0, 0)
    end
    
    TopFit.ProgressFrame:Show()
end

function TopFit:HideProgressFrame()
    TopFit.ProgressFrame:Hide()
end
