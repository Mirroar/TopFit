local addonName, ns, _ = ...
ns.ui = ns.ui or {}
local ui = ns.ui

-- ----------------------------------------------
-- control elements
-- ----------------------------------------------
function ui.InitializeStaticPopupDialogs()
    StaticPopupDialogs["TOPFIT_RENAMESET"] = {
        text = GEARSETS_POPUP_TEXT,
        button1 = OKAY,
        button2 = CANCEL,
        OnAccept = function(self)
            local newName = self.editBox:GetText()
            ns:RenameSet(ns.currentlyRenamingSetID, newName)
        end,
        OnShow = function(self)
            self.editBox:SetText(ns.db.profile.sets[ ns.currentlyRenamingSetID ].name)
        end,
        whileDead = true,
        hasEditBox = true,
        enterClicksFirstButton = true,
        hideOnEscape = true,
        preferredIndex = 3
    }
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
                    StaticPopup_Show("TOPFIT_RENAMESET", ns.db.profile.sets[ self.value ].name)
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
    progressBar:SetAllPoints(TopFitSetDropDown)
    progressBar:SetStatusBarTexture("Interface\\AddOns\\TopFit\\media\\minimalist")
    progressBar:SetFrameStrata( TopFitSetDropDown:GetFrameStrata() )
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetStatusBarColor(0, 1, 0, 1)
    progressBar:Hide()

    -- progress text
    local progressText = progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    progressText:SetAllPoints()
    progressText:SetText("0.00%")
    progressBar.text = progressText

    return progressBar
end

function ui.InitializeMultiButton()
    local button = CreateFrame("Button", "TopFitSidebarCalculateButton", PaperDollItemsFrame)
    button:SetPoint("LEFT", TopFitSetDropDown, "RIGHT", -16, 4)
    button:SetFrameStrata( TopFitSetDropDown:GetFrameStrata() )
    button:SetSize(24, 24)
    button:SetScript("OnEnter", ns.ShowTooltip)
    button:SetScript("OnLeave", ns.HideTooltip)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

    if not button.state then
        button.state = 'idle'
    end
    if button.state == 'idle' then
        button:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
        button.tipText = ns.locale.StartTooltip
    elseif button.state == 'busy' then
        button:SetNormalTexture("Interface\\TimeManager\\PauseButton")
        button.tipText = CANCEL
    else
        -- Interface\\BUTTONS\\UI-Panel-HideButton-Up
        -- Interface\\BUTTONS\\CancelButton-Up
        button:SetNormalTexture("Interface\\TimeManager\\ResetButton")
        button.tipText = HIDE
    end

    button:SetScript("OnClick", function(...)
        -- TODO: call a function for starting set calculation instead of this
        if ns.isBlocked then
            ns:AbortCalculations()
        else
            if IsShiftKeyDown() then
                -- calculate all sets
                ns.workSetList = {}
                for setID, _ in pairs(ns.db.profile.sets) do
                    tinsert(ns.workSetList, setID)
                end
                ns:CalculateSets()
            else
                -- calculate selected set
                if ns.db.profile.sets[ns.selectedSet] then
                    PaperDollFrame_SetSidebar(PaperDollFrame, 4)
                    ns.workSetList = { ns.selectedSet }
                    ns:CalculateSets()
                end
            end
        end
    end)
    return button
end

function ui.InitializeConfigButton()
    local button = CreateFrame("Button", "TopFitConfigButton", PaperDollItemsFrame)
    button:SetPoint("RIGHT", TopFitSetDropDown, "LEFT", 16, 2)
    button:SetFrameStrata( TopFitSetDropDown:GetFrameStrata() )
    button:SetSize(16, 16)
    button.tipText = CHAT_CONFIGURATION
    button:SetScript("OnEnter", ns.ShowTooltip)
    button:SetScript("OnLeave", ns.HideTooltip)
    button:SetNormalTexture("Interface\\Vehicles\\UI-VEHICLES-RAID-ICON") -- Interface\\CURSOR\\Interact
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

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

    ns:initializeCharacterFrameUI() -- [TODO] remove when done
    initialized = true
end
hooksecurefunc("ToggleCharacter", ui.Initialize)

-- ----------------------------------------------
-- mini slot icons
-- ----------------------------------------------
-- [TODO]

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
    end)

    itemButton.TopFitCheckBox = button
    return button
end
local function UpdateFlyoutCheckBox(button, paperDollItemSlot)
    local itemID
    local checkbox, slotID = button.TopFitCheckBox, button.id or paperDollItemSlot:GetID()
    if button.location and button.location == EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION + 2 then
        -- "put into bag" button, used for current equip
        local itemLink = GetInventoryItemLink("player", slotID)
        local itemTable = ns:GetCachedItem(itemLink)
        itemID = itemTable.itemID
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
