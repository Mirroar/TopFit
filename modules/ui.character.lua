local addonName, ns, _ = ...
ns.ui = ns.ui or {}
local ui = ns.ui

-- ----------------------------------------------
-- control elements
-- ----------------------------------------------
function ui.ShowRenameDialog()
    local popup = GearManagerDialogPopup
    popup:SetParent(UIParent)
    popup:SetFrameStrata("DIALOG")
    popup:Show()

    local set = ns.GetSetByID(ns.selectedSet, true)
    popup.setID = ns.selectedSet

    local name = set:GetName()
    local tfSetName = set:GetEquipmentSetName()
    local icon = GetEquipmentSetInfoByName(tfSetName)
    if icon then
        -- set exists, we're editing not creating
        popup.isEdit = true
        popup.origName = name
    end

    RecalculateGearManagerDialogPopup(name, icon)
end
function ui.InitializeStaticPopupDialogs()
    StaticPopupDialogs["TOPFIT_DELETESET"] = {
        text = CONFIRM_DELETE_EQUIPMENT_SET,
        button1 = OKAY,
        button2 = CANCEL,
        OnAccept = function(self)
            ns:DeleteSet(ns.currentlyDeletingSetID)
            ns:SetSelectedSet()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3
    }

    GearManagerDialogPopup:HookScript("OnShow", function(self)
        self.setID = nil
    end)

    hooksecurefunc("GearSetPopupButton_OnClick", function(self, button)
        local popup = GearManagerDialogPopup
        local texture = self:GetNormalTexture():GetTexture()
        popup.setIconTexture = string.sub(texture or "", 17)
    end)

    hooksecurefunc("GearManagerDialogPopupOkay_OnClick", function(self, button, pushed)
        local popup = GearManagerDialogPopup
        if not popup.setID then return end

        local set = ns.GetSetByID(popup.setID, true)
        local tfSetName, eqSetName = set:GetName(), set:GetEquipmentSetName()
        local newName = PaperDollEquipmentManagerPane.selectedSetName

        if not newName then
            -- new eq set was created
            newName = GetEquipmentSetInfo( GetNumEquipmentSets() )
            eqSetName = newName
        end

        set:SetName(newName)
        ModifyEquipmentSet(eqSetName, set:GetEquipmentSetName(), popup.setIconTexture)

        ui.Update()
    end)
end

function ui.InitializeSetDropdown()
    local dropDown = CreateFrame("Frame", "TopFitSetDropDown", PaperDollItemsFrame, "UIDropDownMenuTemplate")
          dropDown:SetPoint("TOP", CharacterModelFrame, "TOP", 0, 17)
          dropDown:SetFrameStrata( CharacterModelFrame:GetFrameStrata() )
    _G[dropDown:GetName().."Button"]:SetPoint("LEFT", dropDown, "LEFT", 20, 0) -- makes the whole dropdown react to mouseover
    UIDropDownMenu_SetWidth(dropDown, CharacterModelFrame:GetWidth() - 100)
    UIDropDownMenu_JustifyText(dropDown, "LEFT")

    ns:SetSelectedSet()

    local function DropDownAddSet(self)
        local preset
        if self.value and self.value ~= "" then
            preset = ns:GetPresets()[self.value]
        end
        local setCode = ns:AddSet(preset) -- [TODO] rewrite for set objects
        local setName = ns.db.profile.sets[setCode].name
        ns:CreateEquipmentSet(setName)

        ToggleDropDownMenu(nil, nil, dropDown)
    end
    dropDown.initialize = function(self, level)
        local info = UIDropDownMenu_CreateInfo()

        if level == 1 then
            info.text = ns.locale.SelectSetDropDown
            info.value = 'selectsettitle'
            info.isTitle = true
            info.notCheckable = true
            UIDropDownMenu_AddButton(info, level)


            info.hasArrow = true
            info.isTitle = nil
            info.disabled = nil
            info.notCheckable = nil

            -- list all existing sets
            for k, v in pairs(ns.db.profile.sets) do
                info.text = v.name
                info.value = k
                info.checked = UIDROPDOWNMENU_MENU_VALUE == k
                info.func = function(self) ns:SetSelectedSet(self.value) end
                UIDropDownMenu_AddButton(info, level)

                if not ns.selectedSet then ns:SetSelectedSet(k) end
            end

            info.checked = nil
            info.notCheckable = true
            info.colorCode = NORMAL_FONT_COLOR_CODE

            info.text = ns.locale.AddSetDropDown
            info.value = 'addset'
            UIDropDownMenu_AddButton(info, level)

        elseif level == 2 then
            info.checked = nil
            info.notCheckable = true

            if UIDROPDOWNMENU_MENU_VALUE == 'addset' then
                -- list options for creating new sets
                info.func = DropDownAddSet

                info.text = ns.locale.EmptySet
                info.value = ''
                UIDropDownMenu_AddButton(info, level)

                local presets = ns:GetPresets()
                for k, v in pairs(presets or {}) do
                    info.text = v.name
                    info.value = k
                    UIDropDownMenu_AddButton(info, level)
                end
            else
                -- list options for editing existing sets
                info.value = UIDROPDOWNMENU_MENU_VALUE

                info.text = ns.locale.ModifySetSelectText
                info.func = function(self)
                    ns:SetSelectedSet(self.value)
                    ToggleDropDownMenu(nil, nil, dropDown)
                end
                UIDropDownMenu_AddButton(info, level)

                info.text = ns.locale.ModifySetRenameText
                info.func = function(self)
                    ns.currentlyRenamingSetID = self.value
                    ui.ShowRenameDialog()
                    ToggleDropDownMenu(nil, nil, dropDown)
                end
                UIDropDownMenu_AddButton(info, level)

                info.text = ns.locale.ModifySetDeleteText
                info.func = function(self)
                    ns.currentlyDeletingSetID = self.value
                    StaticPopup_Show("TOPFIT_DELETESET", ns.db.profile.sets[ self.value ].name)
                    ToggleDropDownMenu(nil, nil, dropDown)
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end
    return dropDown
end

function ui.InitializeSetProgressBar()
    -- progress bar
    local progressBar = CreateFrame("StatusBar", "TopFitProgressBar", PaperDollItemsFrame)
    progressBar:SetPoint("TOPLEFT", TopFitSetDropDown, "TOPLEFT", 22, -6)
    progressBar:SetPoint("BOTTOMRIGHT", TopFitSetDropDown, "BOTTOMRIGHT", -20, 10)
    progressBar:SetFrameStrata( TopFitSetDropDown:GetFrameStrata() )
    progressBar:SetStatusBarTexture("Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill")
    progressBar:SetStatusBarColor(0, 1, 0, 1)
    progressBar:SetMinMaxValues(0, 100)
    progressBar:Hide()

    -- progress text
    local progressText = progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    progressText:SetAllPoints()
    progressText:SetText("0.00%")
    progressBar.text = progressText

    return progressBar
end

function ui.ShowProgress()
    if TopFitSetDropDown then
        TopFitSetDropDown:Hide()
    end
    if TopFitProgressBar then
        TopFitProgressBar:Show()
    end

    if TopFitConfigFrameCalculationProgressBar then
        TopFitConfigFrameCalculationProgressBar:Show()
        TopFitConfigFrameCalculationProgressBarFrame:Show()
    end
end
function ui.HideProgress()
    if TopFitSetDropDown then
        TopFitSetDropDown:Show()
    end
    if TopFitProgressBar then
        TopFitProgressBar:Hide()
    end

    if TopFitConfigFrameCalculationProgressBar then
        TopFitConfigFrameCalculationProgressBar:Hide()
        TopFitConfigFrameCalculationProgressBarFrame:Hide()
    end
end
function ui.SetProgress(progress)
    progress = progress or 0
    if TopFitProgressBar then
        TopFitProgressBar.text:SetFormattedText("%.2f%%", progress * 100)
        TopFitProgressBar:SetValue(progress * 100)
    end

    if TopFitConfigFrameCalculationProgressBar then
        TopFitConfigFrameCalculationProgressBar:SetValue(progress * 100)
        TopFitConfigFrameCalculationProgressBar.text:SetFormattedText("%.2f%%", progress * 100)
    end
end

function ui.SetButtonState(state)
    if not state then
        state = 'idle'
    end

    if TopFitConfigFrameCalculateButton then
        if state == 'idle' then
            TopFitConfigFrameCalculateButton:Show()
        else
            TopFitConfigFrameCalculateButton:Hide()
        end
    end

    if TopFitSidebarCalculateButton then
        local button = TopFitSidebarCalculateButton

        button.state = state

        if button.state == 'idle' then
            button:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
            button.tipText = ns.locale.StartTooltip
        else
            button:SetNormalTexture("Interface\\TimeManager\\PauseButton")
            button.tipText = CANCEL
        end
    end
end

function ui.InitializeMultiButton()
    local button = CreateFrame("Button", "TopFitSidebarCalculateButton", PaperDollItemsFrame)
    button:SetPoint("LEFT", TopFitSetDropDown, "RIGHT", -16, 4)
    button:SetFrameStrata( TopFitSetDropDown:GetFrameStrata() )
    button:SetSize(24, 24)
    button:SetScript("OnEnter", ns.ShowTooltip)
    button:SetScript("OnLeave", ns.HideTooltip)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

    if TopFit.isBlocked then
        ui.SetButtonState('busy')
    else
        ui.SetButtonState()
    end

    button:SetScript("OnClick", function(...)
        -- TODO: call a function for starting set calculation instead of this
        if ns.isBlocked then
            ns:AbortCalculations()
        else
            if IsShiftKeyDown() then
                ns:CalculateAllSets()
            else
                ns:CalculateSelectedSet()
            end
        end
    end)
    return button
end

function ui.InitializeConfigButton()
    local button = CreateFrame("Button", "TopFitConfigButton", PaperDollItemsFrame)
    button:SetPoint("RIGHT", TopFitSetDropDown, "LEFT", 14, 2)
    button:SetFrameStrata( TopFitSetDropDown:GetFrameStrata() )
    button:SetAlpha(0.8)
    button:SetSize(16, 16)
    button.tipText = CHAT_CONFIGURATION
    button:SetScript("OnEnter", ns.ShowTooltip)
    button:SetScript("OnLeave", ns.HideTooltip)
    local confTexture = button:CreateTexture('$parentConfigTexture')
          confTexture:SetTexture("Interface\\MINIMAP\\ObjectIcons")
          confTexture:SetTexCoord(1/8, 2/8, 4/8, 5/8)
          confTexture:SetAllPoints()
    button:SetNormalTexture(confTexture)
    local confHilightTexture = button:CreateTexture('$parentConfigHighlight')
          confHilightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
          confHilightTexture:SetPoint('TOPLEFT', -4, 4)
          confHilightTexture:SetPoint('BOTTOMRIGHT', 4, -4)
    button:SetHighlightTexture(confHilightTexture)

    -- button:SetNormalTexture('Interface\\WorldMap\\GEAR_64GREY')
    -- button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

    button:RegisterForClicks("AnyUp")
    button:SetScript("OnClick", function(self, btn)
        if btn == "RightButton" then
            InterfaceOptionsFrame_OpenToCategory(addonName)
        else
            ui.ToggleTopFitConfigFrame()
        end
    end)
    return button
end

local initialized
function ui.Initialize()
    if initialized then return end
    ui.InitializeStaticPopupDialogs()
    ui.InitializeSetDropdown()
    ui.InitializeSetProgressBar()
    ui.InitializeMultiButton()
    ui.InitializeConfigButton()

    initialized = true
end
hooksecurefunc("ToggleCharacter", ui.Initialize)

-- ----------------------------------------------
-- mini slot icons
-- ----------------------------------------------
-- [TODO]

-- ----------------------------------------------
-- slot has forced items indicator
-- ----------------------------------------------
local forcedItemsInSlot = {}
local function UpdateForcedSlotIndicator(slotButton)
    local slotID = slotButton:GetID()
    if not slotButton or not slotID then return end
    wipe(forcedItemsInSlot)

    local set = ns.GetSetByID(ns.selectedSet, true)
    set:GetForcedItems(slotID, forcedItemsInSlot)

    local indicator = _G[slotButton:GetName() .. "ForcedItemIndicator"]
    if #forcedItemsInSlot > 0 then
        if not indicator then
            indicator = CreateFrame("Frame", "$parentForcedItemIndicator", slotButton)
            indicator:SetPoint("BOTTOMLEFT", -2, 0)
            indicator:SetSize(14, 14)
            local tex = indicator:CreateTexture()
            tex:SetDrawLayer("OVERLAY")
            tex:SetTexture("Interface\\PetBattles\\PetBattle-LockIcon") -- "Interface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon"
            tex:SetAllPoints()
        end
        indicator:Show()
    elseif indicator then
        indicator:Hide()
    end
end
hooksecurefunc("PaperDollItemSlotButton_OnShow", function(self, isBag)
    if not isBag then
        UpdateForcedSlotIndicator(self)
    end
end)

-- ----------------------------------------------
-- item flyout forcing
-- ----------------------------------------------
local tekCheck = LibStub("tekKonfig-Checkbox")
local function CreateFlyoutCheckBox(itemButton)
    local button = tekCheck.new(itemButton, 20, "", "BOTTOMLEFT", -4, -4)
    button:SetHitRectInsets(0, 0, 0, 0)
    button.tiptext = ns.locale.FlyoutTooltip -- [TODO] inform user when checkbox displayed for current item?

    local clickSound = button:GetScript("OnClick")
    button:SetScript("OnClick", function(self, btn)
        clickSound(self)
        local flyoutButton = self:GetParent()
        local set = ns.GetSetByID(ns.selectedSet, true)
        if self:GetChecked() then
            set:ForceItem(flyoutButton.id, flyoutButton.TopFitItemID)
        else
            set:UnforceItem(flyoutButton.id, flyoutButton.TopFitItemID)
        end

        local _, paperDollItemSlot = flyoutButton:GetParent():GetParent():GetPoint()
        UpdateForcedSlotIndicator(paperDollItemSlot)
    end)

    itemButton.TopFitCheckBox = button
    return button
end
local function UpdateFlyoutCheckBox(button, paperDollItemSlot)
    if paperDollItemSlot:GetParent():GetName() ~= "PaperDollItemsFrame" then
        if button.TopFitCheckBox then
            button.TopFitCheckBox:Hide()
        end
        return
    end

    local itemID
    local checkbox, slotID = button.TopFitCheckBox, button.id or paperDollItemSlot:GetID()
    if button.location and button.location == EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION + 2 then
        -- "put into bag" button, used for current equip
        local itemLink = GetInventoryItemLink("player", slotID)
        local itemTable = ns:GetCachedItem(itemLink)
        itemID = itemTable and itemTable.itemID
    elseif not button.location or (button.location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION and button.location <= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION + 10) then
        -- special buttons that we don't care about
        if checkbox then checkbox:Hide() end
        return
    else
        -- regular item button
        itemID = EquipmentManager_GetItemInfoByLocation(button.location) or button.location - EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION - 10
    end
    button.TopFitItemID = itemID

    local set = ns.GetSetByID(ns.selectedSet, true)
    local isForced = set:IsForcedItem(itemID, slotID)
    local checkbox = checkbox or CreateFlyoutCheckBox(button)
          checkbox:SetChecked(isForced)
          checkbox:Show()
end
hooksecurefunc("EquipmentFlyout_DisplayButton", UpdateFlyoutCheckBox)

local _PostGetItemsFunc = PaperDollItemsFrame.flyoutSettings.postGetItemsFunc -- PaperDollFrameItemFlyout_PostGetItems
local function PostGetItemsFunc(itemButton, itemDisplayTable, numItems)
    if _PostGetItemsFunc then
        numItems = _PostGetItemsFunc(itemButton, itemDisplayTable, numItems)
    end

    local set = ns.GetSetByID(ns.selectedSet, true)
    local forcedItems = set:GetForcedItems( itemButton.id or itemButton:GetID() )
    local index = 0
    for _, itemID in pairs(forcedItems) do
        if GetItemCount(itemID) == 0 then -- add <, true> to also check bank
            index = index + 1
            table.insert(itemDisplayTable, EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION + 10 + itemID) -- 10 > 3 special buttons Blizz uses
        end
    end

    return numItems + index
end
PaperDollItemsFrame.flyoutSettings.postGetItemsFunc = PostGetItemsFunc

local function UpdateSpecialFlyoutButton(button, paperDollItemSlot)
    if button.location <= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION + 10 then return end
    local itemID = button.location - (EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION + 10)
    button.TopFitItemID = itemID

    local texture = select(10, GetItemInfo(itemID)) or "Interface\\Icons\\INV_Misc_QuestionMark"
    SetItemButtonTexture(button, texture)
    SetItemButtonCount(button, nil)
    button.UpdateTooltip = function ()
        GameTooltip:SetOwner(EquipmentFlyoutFrame.buttonFrame, "ANCHOR_RIGHT", 6, -EquipmentFlyoutFrame.buttonFrame:GetHeight() - 6)
        GameTooltip:SetText(ns.locale.missingForcedItemTooltip, 1.0, 1.0, 1.0)
        GameTooltip:Show()
    end
    SetItemButtonTextureVertexColor(button, 1, 0, 0)
    SetItemButtonNormalTextureVertexColor(button, 1, 1, 1)
end
hooksecurefunc("EquipmentFlyout_DisplaySpecialButton", UpdateSpecialFlyoutButton)
