local addonName, ns, _ = ...
local ui = {}
ns.ui = ui

-- ----------------------------------------------
-- control elements
-- ----------------------------------------------
function ui.InitializeStaticPopupDialogs()
	StaticPopupDialogs["TOPFIT_RENAMESET"] = {
		text = "Rename set \"%s\" to:",
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
		text = "Do you really want to delete the set \"%s\"? The associated set in the equipment manager will also be lost.",
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

local function DropDownAddSet(self)
	local preset
	if self.value and self.value ~= "" then
		preset = ns:GetPresets()[self.value]
	end

	local setCode = ns:AddSet(preset)
	local setName = ns.db.profile.sets[setCode].name
	ns:CreateEquipmentSet(setName)
	ns:CalculateScores()
end
function ui.InitializeSetDropdown()
	local dropDown = CreateFrame("Frame", "TopFitSetDropDown", CharacterFrame, "UIDropDownMenuTemplate")
		  dropDown:SetPoint("TOP", CharacterModelFrame, "TOP", 0, 17)
		  dropDown:SetFrameStrata("HIGH")
	_G[dropDown:GetName().."Button"]:SetPoint("LEFT", dropDown, "LEFT", 20, 0) -- makes the while dropdown react to mouseover
	UIDropDownMenu_SetWidth(dropDown, CharacterModelFrame:GetWidth() - 100)
	UIDropDownMenu_JustifyText(dropDown, "LEFT")

	ns:SetSelectedSet()

	dropDown.initialize = function(self, level)
		local info = UIDropDownMenu_CreateInfo()

		if level == 1 then
			info.text = ns.locale.SelectSetDropDown
			info.value = 'selectsettitle'
			info.isTitle = true
			info.notCheckable = true
			UIDropDownMenu_AddButton(info, level)

			-- list all existing sets
			for k, v in pairs(ns.db.profile.sets) do
				info.text = v.name
				info.value = k
				info.isTitle = nil
				info.disabled = nil
				info.checked = UIDROPDOWNMENU_MENU_VALUE == k
				info.notCheckable = nil
				info.hasArrow = true
				info.func = function(self) ns:SetSelectedSet(self.value) end
				UIDropDownMenu_AddButton(info, level)

				if not ns.selectedSet then ns:SetSelectedSet(k) end
			end

			info.isTitle = true
			info.checked = nil
			info.notCheckable = true
			info.hasArrow = nil

			info.text = ''
			UIDropDownMenu_AddButton(info, level)
			info.text = ns.locale.AddSetDropDown
			info.value = 'addsettitle'
			UIDropDownMenu_AddButton(info, level)

			-- list options for creating new sets
			info.text = ns.locale.EmptySet
			info.value = ''
			info.func = dropDownAddSet
			info.isTitle = nil
			info.disabled = nil
			info.leftPadding = 6
			UIDropDownMenu_AddButton(info, level)

			local presets = ns:GetPresets()
			if presets then
				for k, v in pairs(presets) do
					info.text = v.name
					info.value = k
					info.func = dropDownAddSet
					UIDropDownMenu_AddButton(info, level)
				end
			end

		elseif level == 2 then
			info.value = UIDROPDOWNMENU_MENU_VALUE
			info.checked = nil
			info.notCheckable = true

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
	return dropDown
end

function ui.InitializeSetProgressBar()
	-- progress bar
    local progressBar = CreateFrame("StatusBar", "TopFitProgressBar", TopFitSetDropDown)
    progressBar:SetAllPoints()
    progressBar:SetStatusBarTexture(minimalist)
    progressBar:SetMinMaxValues(0, 100)
    progressBar:SetStatusBarColor(0, 1, 0, 1)
    progressBar:Hide()

    -- progress text
    local progressText = progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    progressText:SetAllPoints()
    progressText:SetText("0.00%")
    progressBar.text = progressText
end

function ui.InitializeMultiButton()
	local button = CreateFrame("Button", "TopFitSidebarCalculateButton", CharacterFrame)
	button:SetPoint("LEFT", TopFitSetDropDown, "RIGHT", -16, 4)
	button:SetFrameStrata("HIGH")
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
	local button = CreateFrame("Button", "TopFitConfigButton", CharacterFrame)
	button:SetPoint("RIGHT", TopFitSetDropDown, "LEFT", 16, 4)
	button:SetFrameStrata("HIGH")
	button:SetSize(24, 24)
	button.tipText = CHAT_CONFIGURATION
	button:SetScript("OnEnter", ns.ShowTooltip)
	button:SetScript("OnLeave", ns.HideTooltip)
	button:SetNormalTexture("Interface\\CURSOR\\Interact") -- Interface\\Vehicles\\UI-VEHICLES-RAID-ICON
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

	button:SetScript("OnClick", function(...)
		InterfaceOptionsFrame_OpenToCategory(addonName)
	end)
	return button
end

function ui.Initialize()
	ui.InitializeStaticPopupDialogs()
	ui.InitializeSetDropdown()
	ui.InitializeSetProgressBar()
	ui.InitializeMultiButton()
	ui.InitializeConfigButton()

	TopFit:initializeCharacterFrameUI() -- [TODO] remove when done

	ui.Initialize = nil
end
hooksecurefunc("ToggleCharacter", ui.Initialize)

-- ----------------------------------------------
-- mini slot icons
-- ----------------------------------------------
-- [TODO]
