local addonName, ns, _ = ...

local WeightsPlugin = ns.Plugin()
ns.WeightsPlugin = WeightsPlugin

-- TODO: keep old cap values but let the user deactivate a cap
-- TODO: statistics display, somewhere, somehow

-- GLOBALS: _G, TopFit, GREEN_FONT_COLOR, NORMAL_FONT_COLOR_CODE, ADD_ANOTHER, PAPERDOLL_SIDEBAR_STATS, PVP_RATING, SLASH_EQUIP_SET1
-- GLOBALS: PlaySound, CreateFrame, GetEquipmentSetInfoByName, UIDROPDOWNMENU_MENU_VALUE, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton, ToggleDropDownMenu, UnitClass, EditBox_ClearFocus, EditBox_HighlightText, EditBox_ClearHighlight, StaticPopup_Show
-- GLOBALS: table, string, wipe, pairs, ipairs, print, type, tonumber, tContains

local tekCheck = LibStub("tekKonfig-Checkbox")
local lineHeight = 15

-- creates a new WeightsPlugin object
function WeightsPlugin:Initialize()
    self:SetName(TopFit.locale.StatsPanelLabel)
    self:SetTooltipText(TopFit.locale.StatsTooltip)
    self:SetButtonTexture("Interface\\Icons\\Ability_Druid_BalanceofPower")
    self:RegisterConfigPanel()
end

local exposedSettings = {
    -- label, tooltip, set:get_handler, set:set_handler, shown_func
    {
        ns.locale.StatsShowTooltip, ns.locale.StatsShowTooltipTooltip,
        "GetDisplayInTooltip", "SetDisplayInTooltip"
    },
    {
        ns.locale.StatsForceArmorType, ns.locale.StatsForceArmorTypeTooltip,
        "GetForceArmorType", "SetForceArmorType", function(playerClass)
            return playerClass ~= "PRIEST" and playerClass ~= "WARLOCK" and playerClass ~= "MAGE"
        end
    },
    --[[{
        "Enable hit conversion", "Check to enable spirit to hit conversion, even if it does not apply to your current spec",
        "GetHitConversion", "SetHitConversion", function(playerClass)
            return playerClass == "DRUID" or playerClass == "MONK" or playerClass == "PALADIN" or playerClass == "PRIEST" or playerClass == "SHAMAN"
        end
    },--]]
    {
        ns.locale.StatsEnableDualWield, ns.locale.StatsEnableDualWieldTooltip,
        "IsDualWieldForced", "ForceDualWield", function(playerClass)
            return playerClass == "SHAMAN" or playerClass == "WARRIOR" or playerClass == "MONK"
        end
    },
    {
        ns.locale.StatsEnableTitansGrip, ns.locale.StatsEnableTitansGripTooltip,
        "IsTitansGripForced", "ForceTitansGrip", function(playerClass)
            return playerClass == "WARRIOR"
        end
    },
}
-- [TODO] spirit/hit conversion: Druid#33596, Monk#115070 (50% hit, 50% expertise), Paladin#112859 (flat 15% hit), Priest#122098 (flat 15% hit), Shaman#30674, Shaman#112858 (flat 15% hit)

function WeightsPlugin.InitializeExposedSettings()
    local frame = WeightsPlugin:GetConfigPanel()
    local _, playerClass = UnitClass("player")

    local button, buttonLabel, positionIndex, clickSound
    for i, setting in ipairs(exposedSettings) do
        local label, tooltip, getFunc, setFunc, showFunc = setting[1], setting[2], setting[3], setting[4], setting[5]
        if not showFunc or showFunc(playerClass) then
            button, buttonLabel = tekCheck.new(frame, nil, label or "") -- nil = use default size
            button.tiptext = tooltip

            positionIndex = (positionIndex or 0) + 1
            frame["exposedSetting"..positionIndex] = button

            if positionIndex == 1 then
                button:SetPoint("TOPLEFT", _G[frame:GetParent():GetName().."Description"], 0, 6)
            elseif positionIndex == 3 then
                -- first box in second column
                button:SetPoint("TOPLEFT", frame["exposedSetting1"], 190, 0)
            else
                button:SetPoint("TOPLEFT", frame["exposedSetting"..(positionIndex - 1)], "BOTTOMLEFT", 0, 4)
            end

            clickSound = clickSound or button:GetScript("OnClick")
            button.updateHandler = getFunc
            button:SetScript("OnClick", function(self)
                clickSound(self)
                local set = ns.GetSetByID(ns.selectedSet, true)
                set[setFunc](set, self:GetChecked())
            end)
        end
    end
end

function WeightsPlugin.InitializeHeaderActions()
    local frame = WeightsPlugin:GetConfigPanel()
    local parent = frame:GetParent()

    -- rename a set
    local changeName = CreateFrame("Button", nil, frame)
          changeName:SetPoint("TOPLEFT", parent.roleIcon, "TOPLEFT", -2, 2)
          changeName:SetPoint("BOTTOMLEFT", parent.roleIcon, "BOTTOMLEFT", -2, -2)
          changeName:SetPoint("RIGHT", parent.roleName, "RIGHT", 10, 0)
          changeName:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

    changeName:SetScript("OnClick", ns.ui.ShowRenameDialog)

    -- delete a set
    local delete = CreateFrame("Button", nil, frame)
          delete:SetSize(16, 16)
          delete:SetPoint("LEFT", changeName, "RIGHT", 6, 0)
          delete:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
          delete:SetAlpha(.5)
          delete.tipText = ns.locale.DeleteSetTooltip
    delete:SetScript("OnEnter", function(self) self:SetAlpha(1); ns.ShowTooltip(self) end)
    delete:SetScript("OnLeave", function(self) self:SetAlpha(.5); ns.HideTooltip() end)
    delete:SetScript("OnClick", function(self, btn)
        ns.currentlyDeletingSetID = ns.selectedSet
        StaticPopup_Show("TOPFIT_DELETESET", ns.db.profile.sets[ ns.selectedSet ].name)
    end)

    -- assign a specialization
    --[[local dropDown = CreateFrame("Frame", "TopFitWeightsPluginSpecDropdown", frame, "UIDropDownMenuTemplate")
          dropDown:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
          dropDown:SetPoint("TOP", changeName, "TOP", 0, 0)
    _G[dropDown:GetName().."Button"]:SetPoint("LEFT", dropDown, "LEFT", 20, 0) -- makes the whole dropdown react to mouseover
    UIDropDownMenu_SetWidth(dropDown, 60)
    UIDropDownMenu_JustifyText(dropDown, "LEFT")

    local function assignSpec(button)
        ns:Debug(button.value)
        UIDropDownMenu_SetSelectedValue(dropDown, button.value)

        local set = ns.GetSetByID(ns.selectedSet, true)
        if button.value ~= 'none' then
            set:SetAssociatedSpec(button.value)
            ns:Debug(GetSpecializationInfoByID(button.value))
            local _, _, _, icon = GetSpecializationInfoByID(button.value)
            if icon then
                --UIDropDownMenu_SetText(dropDown, '|T'..icon..':0|t')
            end
        else
            set:SetAssociatedSpec(nil)
        end
    end

    dropDown.initialize = function(self, level)
        if level == 1 then
            local info = UIDropDownMenu_CreateInfo()

            -- add header
            info.text = ns.locale.SelectSpecHeader
            info.value = 'selectspecheader'
            info.isTitle = true
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, level)

            -- set defaults for following items
            info.hasArrow = nil
            info.isTitle = nil
            info.disabled = nil
            info.notCheckable = nil
            info.icon = nil

            -- add a "select none" item
            info.text = ns.locale.NoSpecSelected
            info.value = 'none'
            info.checked = UIDROPDOWNMENU_MENU_VALUE == 'none'
            info.func = assignSpec
            UIDropDownMenu_AddButton(info, level)

            -- list all specs
            for k, v in pairs(ns.specInfo) do
                info.text = v.name
                info.value = v.globalID
                info.icon = v.icon
                info.checked = UIDROPDOWNMENU_MENU_VALUE == v.globalID
                info.func = assignSpec
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end

    UIDropDownMenu_Initialize(dropDown, dropDown.initialize)--]]
end

function WeightsPlugin.ShowEditLine(statLine, btn)
    local isCap = false
    if statLine.isCap then
        statLine = statLine:GetParent()
        isCap = true
    end
    local editLine = _G[statLine:GetParent():GetName() .. "EditStat"]
    local _, oldStatLine = editLine:GetPoint()

    if oldStatLine then
        oldStatLine:SetHeight(lineHeight)
        oldStatLine.value:Show()
        oldStatLine.capValue:Show()
        if oldStatLine == statLine and editLine:IsShown() then
            editLine:ClearAllPoints()
            editLine:Hide()
            return
        end
    end

    --[[ statLine:SetHeight(lineHeight*2 + 2)
    editLine:SetPoint("TOPLEFT", statLine, "LEFT")
    editLine:SetPoint("TOPRIGHT", statLine, "RIGHT") --]]
    editLine.stat = statLine.stat
    editLine:SetAllPoints(statLine)
    editLine:Show()
    if not isCap then
        statLine.value:Hide()

        editLine.value:SetText( tonumber(statLine.value:GetText()) ) -- %.3f
        editLine.value:Show()
        editLine.value:SetFocus()
    else
        statLine.capValue:Hide()

        local set = ns.GetSetByID(ns.selectedSet, true)
        local capValue = set:GetHardCap(statLine.stat)

        if capValue then
            editLine.capValue:SetText( tonumber(statLine.capValue:GetText()) ) -- %.3f
        else
            editLine.capValue:SetText(0)
        end
        editLine.capValue:Show()
        editLine.capValue:SetFocus()
    end
end

function WeightsPlugin.ShowDummyCap(statLine)
    if statLine.isCap then
        statLine = statLine:GetParent()
        statLine:LockHighlight()
    end
    local set = ns.GetSetByID(ns.selectedSet, true)
    local capValue = set:GetHardCap(statLine.stat)

    if not capValue or capValue == 0 then
        statLine.capValue:SetText("|TInterface\\PaperDollInfoFrame\\Character-Plus:0|t")
    else
        statLine.capValue:SetText(set:GetHardCap(statLine.stat))
    end
end
function WeightsPlugin.HideDummyCap(statLine)
    if statLine.isCap then
        statLine = statLine:GetParent()
        statLine:UnlockHighlight()
    end
    local set = ns.GetSetByID(ns.selectedSet, true)
    statLine.capValue:SetText(set:GetHardCap(statLine.stat) or "")
end

function WeightsPlugin:SetStatLine(i, stat, value, capValue)
    local frame = self:GetConfigPanel()
    local statLine = _G[frame:GetName().."StatLine"..i]
    if not statLine then
        statLine = CreateFrame("Button", "$parentStatLine"..i, frame)
        statLine:SetID(i)

        if i == 0 then -- header
            statLine:SetPoint("TOPLEFT")
            statLine:SetPoint("TOPRIGHT")
        else
            statLine:SetPoint("TOPLEFT", "$parentStatLine"..(i-1), "BOTTOMLEFT")
            statLine:SetPoint("TOPRIGHT", "$parentStatLine"..(i-1), "BOTTOMRIGHT")

            statLine:SetScript("OnClick", WeightsPlugin.ShowEditLine)
            statLine:SetScript("OnEnter", WeightsPlugin.ShowDummyCap)
            statLine:SetScript("OnLeave", WeightsPlugin.HideDummyCap)
            statLine:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
            -- blue-ish: "Interface\\Buttons\\UI-Common-MouseHilight"

            statLine.capButton = CreateFrame("Button", "$parentStatLine"..i.."CapButton", statLine)
            statLine.capButton.isCap = true
            statLine.capButton:SetScript("OnClick", WeightsPlugin.ShowEditLine)
            statLine.capButton:SetScript("OnEnter", WeightsPlugin.ShowDummyCap)
            statLine.capButton:SetScript("OnLeave", WeightsPlugin.HideDummyCap)
            statLine.capButton:SetPoint("TOPRIGHT", -80, 0)
            statLine.capButton:SetPoint("BOTTOMLEFT", statLine, "BOTTOMRIGHT", -180, 0)
        end

        if i%2 ~= 0 then
            -- statLine:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background"})
            local bgTex = statLine:CreateTexture(nil, "BACKGROUND")
                  bgTex:SetTexture(1, 1, 1, 0.15)
                  bgTex:SetHorizTile(true)
                  bgTex:SetVertTile(true)
                  bgTex:SetAllPoints()
        end

        statLine:SetHeight(lineHeight) -- GameTooltipHeaderText, GameFontHighlightMedium, GameFontDisable
        statLine.name = statLine:CreateFontString("$parentName", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontNormal")
        statLine.name:SetPoint("TOPLEFT", 2, -2)
        statLine.value = statLine:CreateFontString("$parentValue", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontNormal")
        statLine.value:SetPoint("TOPRIGHT", -2, -2)
        statLine.capValue = statLine:CreateFontString("$parentCapValue", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontHighlight")
        -- [TODO] T.T
        -- statLine.capValue = CreateFrame("Button", "$parentCapValue", statLine)
        -- statLine.capValue:SetSize(60, lineHeight-4)
        statLine.capValue:SetPoint("TOPRIGHT", -80, -2)

    end

    statLine.stat = stat

    statLine.name:SetText(_G[stat] or stat)
    statLine.name:Show()
    statLine.value:SetText(value or 0)
    statLine.value:Show()
    statLine.capValue:SetText(capValue or "")
    statLine.capValue:Show()
    statLine:Show()
end

local function AddStatDropDownFunc(self)
    local currentSet = ns.GetSetByID(ns.selectedSet, true)
    currentSet:SetStatWeight(self.value, 0)
    -- update display
    WeightsPlugin:OnShow()
end
local function InitializeAddStatDropDown(self, level)
    local set = TopFit.db.profile.sets[ TopFit.selectedSet ]

    local info = UIDropDownMenu_CreateInfo()
    if level == 1 then
        -- stat groups (melee, ranged, hybrid etc)
        info.hasArrow = true
        info.notCheckable = true
        info.keepShownOnClick = true
        info.colorCode = NORMAL_FONT_COLOR_CODE
        for group, stats in pairs(TopFit.statList) do
            local showGroup = false
            for _, stat in pairs(stats) do
                if not set.weights[stat] then
                    showGroup = true
                    break
                end
            end
            if showGroup then
                info.text = group
                info.value = group
                UIDropDownMenu_AddButton(info, level)
            end
        end

        local itemSets = ns:GetAvailableItemSetNames()
        if itemSets and #itemSets > 0 then
            info.text = string.gsub(SLASH_EQUIP_SET1, "/", "")
            info.value = SLASH_EQUIP_SET1
            UIDropDownMenu_AddButton(info, level)
        end
    else
        info.func = AddStatDropDownFunc
        if UIDROPDOWNMENU_MENU_VALUE == SLASH_EQUIP_SET1 then
            -- euipment set bonusses
            local itemSets = ns:GetAvailableItemSetNames()
            for i, setName in ipairs(itemSets or {}) do
                info.text = string.gsub(setName, "SET: ", "")
                info.value = setName
                UIDropDownMenu_AddButton(info, level)
            end
        else
            -- actual stats (intellect, stamina etc)
            for i, stat in ipairs( ns.statList[UIDROPDOWNMENU_MENU_VALUE] or {} ) do
                if not set.weights[stat] then
                    info.text = _G[stat]
                    info.value = stat
                    UIDropDownMenu_AddButton(info, level)
                end
            end
        end
    end
end

-- initializes this plugin's UI elements
function WeightsPlugin:InitializeUI()
    local frame = self:GetConfigPanel()

    -- set up basic set settings
    ns.ui.SetHeaderDescription(frame, nil) -- we need that space!
    self.InitializeExposedSettings()

    self.InitializeHeaderActions()

    -- edit stat weights
    local editLine = CreateFrame("Frame", "$parentEditStat", frame)
          -- editLine:SetFrameStrata("HIGH")
          editLine:SetHeight(lineHeight)
          -- editLine:EnableMouse(true)
          editLine:Hide()
    --[[
        local text = editLine:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
        text:Raise()
        text:SetFormattedText("Reach at least %1$s points, worth %2$s each.", "|T:120:0|t", "|T:120:0|t")
        text:SetJustifyH("LEFT")
        text:SetPoint("TOPLEFT", 2, -2)
        text:SetPoint("TOPRIGHT", -2, -2)
        editLine.text = text
    --]]
    local value = CreateFrame("EditBox", "$parentValue", editLine) -- , "InputBoxTemplate")
        value:SetFontObject("ChatFontNormal")
        value:SetJustifyH("RIGHT")
        value:SetAutoFocus(false)
        value:SetSize(60, lineHeight-4)
        value:SetPoint("TOPRIGHT", -2, -2)

        value:SetScript("OnEditFocusGained", EditBox_HighlightText)
        value:SetScript("OnEditFocusLost", function(self)
            EditBox_ClearHighlight(self)
            self:Hide()
        end)
        value:SetScript("OnEscapePressed", function(self)
            EditBox_ClearFocus(self)
            WeightsPlugin:OnShow()
        end)
        value:SetScript("OnEnterPressed", function(self)
            local value = tonumber( self:GetText() )
            local set = ns.GetSetByID(ns.selectedSet, true)
            set:SetStatWeight(self:GetParent().stat, value ~= 0 and value or nil)

            EditBox_ClearFocus(self)
            WeightsPlugin:OnShow()
        end)
        value:Hide()
    editLine.value = value

    local capValue = CreateFrame("EditBox", "$parentCapValue", editLine)
        capValue:SetFontObject("ChatFontNormal")
        capValue:SetJustifyH("RIGHT")
        capValue:SetAutoFocus(false)
        capValue:SetSize(60, lineHeight-4)
        capValue:SetPoint("TOPRIGHT", -2 - 80, -2)

        capValue:SetScript("OnEditFocusGained", EditBox_HighlightText)
        capValue:SetScript("OnEditFocusLost", function(self)
            EditBox_ClearHighlight(self)
            self:Hide()
        end)
        capValue:SetScript("OnEscapePressed", function(self)
            EditBox_ClearFocus(self)
            WeightsPlugin:OnShow()
        end)
        capValue:SetScript("OnEnterPressed", function(self)
            local value = tonumber( self:GetText() )
            local set = ns.GetSetByID(ns.selectedSet, true)
            set:SetHardCap(self:GetParent().stat, value ~= 0 and value or nil)

            EditBox_ClearFocus(self)
            WeightsPlugin:OnShow()
        end)
        capValue:Hide()
    editLine.capValue = capValue

    -- add new stats button
    local newStat = CreateFrame("Button", "$parentAddStat", frame)
    local dropDown = CreateFrame("Frame", "$parentDropDown", newStat, "UIDropDownMenuTemplate")
          dropDown:SetAllPoints()
          dropDown:Hide()
          dropDown.displayMode = "MENU"
          dropDown.initialize = InitializeAddStatDropDown

    newStat:SetScript("OnClick", function(self, btn)
        ToggleDropDownMenu(nil, nil, dropDown)
    end)
    local newStatText = newStat:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
          newStatText:SetPoint("TOPLEFT")
          newStatText:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
          newStatText:SetText("|TInterface\\PaperDollInfoFrame\\Character-Plus:0|t "..ADD_ANOTHER)
    newStat:SetSize( newStatText:GetWidth(), newStatText:GetHeight() )
end

local function SortStats(a, b)
    local set = TopFit.db.profile.sets[TopFit.selectedSet]
    local cappedA, cappedB = set.caps[a] and set.caps[a].value or 0, set.caps[b] and set.caps[b].value or 0
    local weightA, weightB = set.weights[a] or 0, set.weights[b] or 0

    if (_G[a] and 1 or 0) ~= (_G[b] and 1 or 0) then
        -- put sets and other pseude-stats at the end
        return (_G[a] and true or false)
    elseif weightA ~= weightB then
        return weightA > weightB
    elseif cappedA ~= cappedB then
        return cappedA > cappedB
    else
        return a < b
    end
end

local setStats = {}
function WeightsPlugin:OnShow()
    local panel = self:GetConfigPanel()
    local set = ns.GetSetByID(ns.selectedSet, true)

    ns.ui.SetHeaderSubTitle(panel, set:GetName())
    ns.ui.SetHeaderSubTitleIcon(panel, set:GetIconTexture(), 0, 1, 0, 1)

    local index, func = 1, nil
    while panel["exposedSetting"..index] do
        func = panel["exposedSetting"..index].updateHandler
        if func and set[func] then
            panel["exposedSetting"..index]:SetChecked( set[func](set) )
        end
        index = index + 1
    end

    panel.stats = panel.stats or {}
    wipe(panel.stats)

    for stat, _ in pairs(set:GetStatWeights(setStats)) do
        table.insert(panel.stats, stat)
    end
    for stat, _ in pairs(set:GetHardCaps(setStats)) do
        if not tContains(panel.stats, stat) then
            table.insert(panel.stats, stat)
        end
    end
    table.sort(panel.stats, SortStats)

    self:SetStatLine(0, PAPERDOLL_SIDEBAR_STATS, string.gsub(PVP_RATING, ":", ""), "Cap")
    for i, stat in ipairs(panel.stats) do
        self:SetStatLine(i, stat, set:GetStatWeight(stat), set:GetHardCap(stat))
    end
    local i = #(panel.stats) + 1
    while _G[panel:GetName().."StatLine"..i] do
        _G[panel:GetName().."StatLine"..i]:Hide()
        i = i + 1
    end

    -- position add button at the end
    local newStat = _G[panel:GetName().."AddStat"]
    newStat:SetPoint("TOPLEFT", "$parentStatLine"..#(panel.stats), "BOTTOMLEFT", 0, -10)
    newStat:SetBackdropColor(1, 0, 0)

    -- update selected specialization
    --[[local spec = set:GetAssociatedSpec()
    if spec then
        UIDropDownMenu_SetSelectedValue(TopFitWeightsPluginSpecDropdown, spec)
    else
        UIDropDownMenu_SetSelectedValue(TopFitWeightsPluginSpecDropdown, 'none')
    end--]]
end
