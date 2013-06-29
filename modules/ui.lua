local _, ns = ...

-- TODO: integrate this code into appropriate files

function TopFit:SetSelectedSet(setID)
    local i

    -- select current auto-update set by default
    if not setID then
        if (TopFit.db.profile.defaultUpdateSet and GetActiveSpecGroup() == 1) then
            setID = TopFit.db.profile.defaultUpdateSet
        end
        if (TopFit.db.profile.defaultUpdateSet2 and GetActiveSpecGroup() == 2) then
            setID = TopFit.db.profile.defaultUpdateSet2
        end
    end

    -- if still no set is selected, select first available set instead
    if not setID then
        for setID, _ in pairs(TopFit.db.profile.sets) do
            break
        end
    end

    if not setID then
        if TopFitSidebarCalculateButton then
            TopFitSidebarCalculateButton:Disable()
        end
    else
        TopFit.selectedSet = setID
        if TopFitSidebarCalculateButton then
            TopFitSidebarCalculateButton:Enable()
        end
        -- TopFit:SetCurrentCombinationFromEquipmentSet(setID)
        if TopFitSetDropDown then
            UIDropDownMenu_SetSelectedValue(TopFitSetDropDown, TopFit.selectedSet)
            UIDropDownMenu_SetText(TopFitSetDropDown, TopFit.db.profile.sets[TopFit.selectedSet].name)
        end
    end

    TopFit.ui.Update()
end

function TopFit:ResetProgress()
    TopFit.progress = nil
    if not TopFitSidebarCalculateButton then return end
    TopFitSidebarCalculateButton.state = 'busy'
    ns.ui.ShowProgress()
end

function TopFit:StoppedCalculation()
    if not TopFitSidebarCalculateButton then return end
    TopFitSidebarCalculateButton.state = 'idle'
    ns.ui.HideProgress()
end

function TopFit:SetProgress(progress)
    if (TopFit.progress == nil) or (TopFit.progress < progress) then
        TopFit.progress = progress
        if not TopFitSidebarCalculateButton then return end
        ns.ui.SetProgress(progress)
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

    -- TopFit.ProgressFrame.setScoreFontString:SetFormattedText(TopFit.locale.SetScore, combination.totalScore)

    -- sort stats by score contribution
    -- TODO: find new place for top stats & caps info
    --[[local statList = {}
    local scorePerStat = {}
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
    local maxStatValue = statList[1] and scorePerStat[ statList[1] ] or 0

    if not statScrollFrameContent.statsHeader then
        statScrollFrameContent.statsHeader = statScrollFrameContent:CreateFontString(nil, nil, "GameFontNormalLarge")
        statScrollFrameContent.statsHeader:SetPoint("TOP", TopFitStatScrollFrame:GetScrollChild(), "TOP", 0, -5)
        statScrollFrameContent.statsHeader:SetPoint("LEFT", statScrollFrameContent, "LEFT", 3, 0)
        statScrollFrameContent.statsHeader:SetText(TopFit.locale.HeadingStats)
    end

    for i = 1, #statList do
        if (scorePerStat[ statList[i] ] ~= nil) and (scorePerStat[ statList[i] ] > 0) then
            lastStat = i
            if not statTexts[i] then
                -- create FontStrings
                -- fontsting for stat name
                statusBars[i] = CreateFrame("StatusBar", "TopFitStatValueBar"..i, statScrollFrameContent)
                statusBars[i]:SetHeight(14)
                statusBars[i]:SetStatusBarTexture("Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill")

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
            statTexts[i]:SetText(_G[ statList[i] ])
            valueTexts[i]:SetFormattedText("%.1f", combination.totalStats[ statList[i] ])
            statusBars[i]:SetMinMaxValues(0, maxStatValue)
            statusBars[i]:SetValue(scorePerStat[ statList[i] ])
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
    statScrollFrameContent.placeHolder:SetPoint("RIGHT") --]]
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
            button.overlay:Show()
            button.overlay:SetVertexColor(1, 1, 1, 0) -- transparent

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
            button.overlay:SetVertexColor(1, 0, 0, 1)
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
