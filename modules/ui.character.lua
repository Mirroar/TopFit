local addonName, ns, _ = ...
ns.ui = ns.ui or {}
local ui = ns.ui

-- GLOBALS: UIParent, StaticPopupDialogs, GameTooltip, _G, OKAY, CANCEL, CONFIRM_DELETE_EQUIPMENT_SET, EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION, NORMAL_FONT_COLOR_CODE
-- GLOBALS: hooksecurefunc, InterfaceOptionsFrame_OpenToCategory, IsShiftKeyDown, CreateFrame, GetInventoryItemLink, GetItemInfo, GetItemCount, GetEquipmentSetInfo, GetNumEquipmentSets, ModifyEquipmentSet, GetEquipmentSetInfoByName, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton, UIDropDownMenu_JustifyText, UIDropDownMenu_SetWidth, UIDropDownMenu_GetSelectedValue, SetItemButtonTexture, SetItemButtonCount
-- GLOBALS: string, table, select, pairs, wipe

-- ----------------------------------------------
-- control elements
-- ----------------------------------------------
function ui.ShowRenameDialog()
    local popup = _G["GearManagerDialogPopup"]
    popup:SetParent(UIParent)
    popup:SetFrameStrata("DIALOG")
    popup:Show()

    local set = ns.GetSetByID(ns.selectedSet, true)
    popup.setID = ns.selectedSet

    local name = set:GetName():sub(1, 12)
    local tfSetName = set:GetEquipmentSetName()
    local icon = GetEquipmentSetInfoByName(tfSetName)
    if icon then
        -- set exists, we're editing not creating
        popup.isEdit = true
        popup.origName = name
    end

    RecalculateGearManagerDialogPopup(name, icon)
end
function ui.InitializeGearManagerHooks()
    _G["GearManagerDialogPopup"]:HookScript("OnShow", function(self)
        self.setID = nil
    end)

    hooksecurefunc("GearSetPopupButton_OnClick", function(self, button)
        local popup = self:GetParent()
        local texture = self:GetNormalTexture():GetTexture()
        popup.setIconTexture = string.sub(texture or "", 17)
    end)

    hooksecurefunc("GearManagerDialogPopupOkay_OnClick", function(self, button, pushed)
        local popup = self:GetParent()
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

local function DropDownImportSet()
	StaticPopup_Show("TOPFIT_IMPORT", ns.locale.UtilitiesDefaultText)
end
local function DropDownAddSet(self)
    local preset
    if self.value and self.value ~= "" then
        preset = ns:GetPresets()[self.value]
    end
    local setCode = ns:AddSet(preset) -- [TODO] rewrite for set objects
    local setName = ns.db.profile.sets[setCode].name
    ns:CreateEquipmentSet(setName)
end

-- reused in ui.config.lua
function ui.NewSetDropDown(self, level, menuList)
	local info = UIDropDownMenu_CreateInfo()
	info.notCheckable = true

	-- preset
	local presets = ns:GetPresets()
	for k, v in pairs(presets or {}) do
		info.func = DropDownAddSet
		info.text = v.name
		info.value = k
		UIDropDownMenu_AddButton(info, level)
	end

	-- empty set
	info.func = DropDownAddSet
	info.text = NORMAL_FONT_COLOR_CODE..ns.locale.EmptySet
	info.value = ''
	UIDropDownMenu_AddButton(info, level)

	-- import
	info.func = DropDownImportSet
	info.text = NORMAL_FONT_COLOR_CODE..ns.locale.ImportLabel
	info.value = nil
	UIDropDownMenu_AddButton(info, level)
end

function ui.InitializeSetDropdown()
    local anchorFrame = _G["CharacterModelFrame"]
    local dropDown = CreateFrame("Frame", "TopFitSetDropDown", PaperDollItemsFrame, "UIDropDownMenuTemplate")
          dropDown:SetPoint("TOP", anchorFrame, "TOP", 0, 17)
          dropDown:SetFrameStrata(anchorFrame:GetFrameStrata())
    _G[dropDown:GetName().."Button"]:SetPoint("LEFT", dropDown, "LEFT", 20, 0) -- makes the whole dropdown react to mouseover
    UIDropDownMenu_SetWidth(dropDown, anchorFrame:GetWidth() - 100)
    UIDropDownMenu_JustifyText(dropDown, "LEFT")

    ns:SetSelectedSet()

    local function DropDownRenameSet(self)
        ns.currentlyRenamingSetID = self.value
        ui.ShowRenameDialog()
    end
    local function DropDownDeleteSet(self)
        ns.currentlyDeletingSetID = self.value
        StaticPopup_Show("TOPFIT_DELETESET", ns.db.profile.sets[ self.value ].name or "Unknown")
    end
    local function DropDownSelectSet(self)
        ns:SetSelectedSet(self.value)
    end
    dropDown.initialize = function(self, level, menuList)
        local info = UIDropDownMenu_CreateInfo()

        if level == 1 then
            if not ns.IsEmpty(ns.db.profile.sets) then
                info.text         = ns.locale.SelectSetDropDown
                info.value        = 'selectsettitle'
                info.isTitle      = true
                info.notCheckable = true
                UIDropDownMenu_AddButton(info, level)
            end

            info.hasArrow     = true
            info.isTitle      = nil
            info.disabled     = nil
            info.notCheckable = nil

            -- list all existing sets
            local selected = UIDropDownMenu_GetSelectedValue(self)
            info.func = DropDownSelectSet
            for k, v in pairs(ns.db.profile.sets) do
                info.text     = v.name or "Unknown"
                info.value    = k
                info.menuList = k
                info.checked  = k == selected
                UIDropDownMenu_AddButton(info, level)
            end

            info.checked      = nil
            info.notCheckable = true
            info.colorCode    = NORMAL_FONT_COLOR_CODE

            info.text         = ns.locale.AddSetDropDown
            info.value        = 'addset'
            info.menuList     = 'addset'
            info.func         = nil
            UIDropDownMenu_AddButton(info, level)
        elseif level == 2 then
            info.checked = nil
            info.notCheckable = true

            if menuList == 'addset' then
                -- list options for creating new sets
                ui.NewSetDropDown(self, level, menuList)
            else
                -- list options for editing existing sets
                info.value = menuList

                info.text = ns.locale.ModifySetSelectText
                info.func = DropDownSelectSet
                UIDropDownMenu_AddButton(info, level)

                info.text = ns.locale.ModifySetRenameText
                info.func = DropDownRenameSet
                UIDropDownMenu_AddButton(info, level)

                info.text = ns.locale.ModifySetDeleteText
                info.func = DropDownDeleteSet
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end
    return dropDown
end

function ui.InitializeSetProgressBar()
    local progressBar = CreateFrame("StatusBar", "TopFitProgressBar", PaperDollItemsFrame)
    progressBar:SetPoint("TOPLEFT", "TopFitSetDropDown", "TOPLEFT", 22, -6)
    progressBar:SetPoint("BOTTOMRIGHT", "TopFitSetDropDown", "BOTTOMRIGHT", -20, 10)
    progressBar:SetStatusBarTexture("Interface\\RAIDFRAME\\Raid-Bar-Hp-Fill")
    progressBar:SetStatusBarColor(0, 1, 0, 1)
    progressBar:SetMinMaxValues(0, 100)
    progressBar:Hide()

    local progressText = progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    progressText:SetAllPoints()
    progressText:SetText("0.00%")
    progressBar.text = progressText

    return progressBar
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
    state = state or 'idle'

    -- ui.config frame
    if TopFitConfigFrameCalculateButton then
        TopFitConfigFrameCalculateButton:SetShown(state == 'idle')
        TopFitConfigFrameCalculationProgressBar:SetShown(state ~= 'idle')
        TopFitConfigFrameCalculationProgressBarFrame:SetShown(state ~= 'idle')
    end

    -- ui.character frame
    if TopFitSidebarCalculateButton then
        local button = TopFitSidebarCalculateButton
              button.state = state

        if button.state == 'idle' then
            TopFitSetDropDown:Show()
            TopFitProgressBar:Hide()
            button:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
            button.tipText = ns.locale.StartTooltip
        else
            TopFitSetDropDown:Hide()
            TopFitProgressBar:Show()
            button:SetNormalTexture("Interface\\TimeManager\\PauseButton")
            button.tipText = CANCEL
        end
    end
end

function ui.InitializeMultiButton()
    local button = CreateFrame("Button", "TopFitSidebarCalculateButton", PaperDollItemsFrame)
    button:SetPoint("LEFT", "TopFitSetDropDown", "RIGHT", -16, 4)
    button:SetSize(24, 24)
    button:SetScript("OnEnter", ns.ShowTooltip)
    button:SetScript("OnLeave", ns.HideTooltip)
    button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

    if ns.isBlocked then
        ui.SetButtonState('busy')
    else
        ui.SetButtonState()
    end

    button:SetScript("OnClick", function()
        if ns.isBlocked then
            ns:AbortCalculations()
        else
            ns:StartCalculations(not IsShiftKeyDown() and ns.selectedSet or nil)
        end
    end)
    return button
end

function ui.InitializeConfigButton()
    local button = CreateFrame("Button", "TopFitConfigButton", PaperDollItemsFrame)
    button:SetPoint("RIGHT", "TopFitSetDropDown", "LEFT", 14, 3)
    button:SetAlpha(0.8)
    button:SetSize(14, 14)
    button.tipText = addonName .. '|n|cFFFFFFFF'
    	.. ns.locale.OpenSetConfigTooltip .. '|n'
    	.. ns.locale.OpenAddonConfigTooltip
    button:SetScript("OnEnter", ns.ShowTooltip)
    button:SetScript("OnLeave", ns.HideTooltip)
    button:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
    local confHilightTexture = button:CreateTexture('$parentConfigHighlight')
          confHilightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
          confHilightTexture:SetPoint('TOPLEFT', -4, 4)
          confHilightTexture:SetPoint('BOTTOMRIGHT', 4, -4)
    button:SetHighlightTexture(confHilightTexture)

    button:RegisterForClicks("AnyUp")
    button:SetScript("OnClick", function(self, btn)
        CloseMenus() -- prevent oddities when ui.config gets initialized
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
    ui.InitializeGearManagerHooks()
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
    if not slotButton or not slotID or not ns.selectedSet then return end
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
    local flyoutFrame = EquipmentFlyoutFrame.buttonFrame

    local texture = select(10, GetItemInfo(itemID)) or "Interface\\Icons\\INV_Misc_QuestionMark"
    SetItemButtonTexture(button, texture)
    SetItemButtonCount(button, nil)
    button.UpdateTooltip = function ()
        GameTooltip:SetOwner(flyoutFrame, "ANCHOR_RIGHT", 6, - flyoutFrame:GetHeight() - 6)
        GameTooltip:SetText(ns.locale.missingForcedItemTooltip, 1.0, 1.0, 1.0)
        GameTooltip:Show()
    end
    SetItemButtonTextureVertexColor(button, 1, 0, 0)
    SetItemButtonNormalTextureVertexColor(button, 1, 1, 1)
end
hooksecurefunc("EquipmentFlyout_DisplaySpecialButton", UpdateSpecialFlyoutButton)
