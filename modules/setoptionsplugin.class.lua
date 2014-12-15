local addonName, ns, _ = ...

local SetOptionsPlugin = ns.Plugin()
ns.SetOptionsPlugin = SetOptionsPlugin

local tekCheck = LibStub("tekKonfig-Checkbox")

-- creates a new SetOptionsPlugin object
function SetOptionsPlugin:Initialize()
	self:SetName(ns.locale.OptionsPanelTitle)
	self:SetTooltipText(ns.locale.OptionsPanelTooltip)
	self:SetButtonTexture("Interface\\Icons\\INV_Misc_EngGizmos_swissArmy")
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
	{
		ns.locale.StatsEnableDualWield, ns.locale.StatsEnableDualWieldTooltip,
		"IsDualWieldForced", "ForceDualWield", function(playerClass)
			return playerClass == "SHAMAN" or playerClass == "WARRIOR" or playerClass == "MONK"
		end
	},
	{ -- TODO: remove, since this is now included in fury's regular dual wield
		ns.locale.StatsEnableTitansGrip, ns.locale.StatsEnableTitansGripTooltip,
		"IsTitansGripForced", "ForceTitansGrip", function(playerClass)
			return playerClass == "WARRIOR"
		end
	},
}

function SetOptionsPlugin:InitializeExposedSettings()
	local frame = self:GetConfigPanel()
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
				button:SetPoint("TOPLEFT", frame, 0, 0)
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

	return button
end

function SetOptionsPlugin:InitializeUI()
	local frame = self:GetConfigPanel()
	local lastCheckbox = self:InitializeExposedSettings()

	-- assign a specialization
	local specText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	specText:SetPoint('TOPLEFT', lastCheckbox, 'BOTTOMLEFT', 0, -10)
	specText:SetPoint('RIGHT', frame, 'RIGHT', 0, 0)
	specText:SetJustifyH('LEFT')
	specText:SetText(ns.locale.SpecDropDownLabel)
	frame.specText = specText

	local dropDown = CreateFrame("Frame", "$parentSpecDropdown", frame, "UIDropDownMenuTemplate")
		  dropDown:SetPoint("TOPLEFT", specText, "BOTTOMLEFT", -10, -5)
	frame.specDropDown = dropDown
	_G[dropDown:GetName().."Button"]:SetPoint("LEFT", dropDown, "LEFT", 20, 0) -- makes the whole dropdown react to mouseover
	_G[dropDown:GetName().."Button"].tipText = ns.locale.SpecDropDownTooltip
	_G[dropDown:GetName().."Button"]:SetScript('OnEnter', ns.ShowTooltip)
	_G[dropDown:GetName().."Button"]:SetScript('OnLeave', ns.HideTooltip)
	UIDropDownMenu_SetWidth(dropDown, 150)
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
		self:OnShow()
	end

	--TODO: add specialization twice if player has the same spec twice
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
			for index = 1, GetNumSpecializations() do
				local specID, name, _, icon, _, role = GetSpecializationInfo(index)
				info.text = name
				info.value = specID
				info.icon = icon
				info.checked = UIDROPDOWNMENU_MENU_VALUE == specID
				info.func = assignSpec
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end

	-- spec-based options
	-- create checkbox for auto-updating
	local checkbox = LibStub("tekKonfig-Checkbox").new(frame, nil, ns.locale.AutoUpdateSet, "TOP", dropDown, "BOTTOM", 0, -5)
	checkbox:SetPoint("LEFT", frame, "LEFT")
	checkbox.tipText = ns.locale.AutoUpdateSetTooltip
	checkbox:SetScript('OnEnter', ns.ShowTooltip)
	checkbox:SetScript('OnLeave', ns.HideTooltip)
	local checksound = checkbox:GetScript('OnClick')
	checkbox:SetScript('OnClick', function(self)
		checksound(self)
		local set = ns.GetSetByID(ns.selectedSet, true)
		set:SetAutoUpdate(not set:GetAutoUpdate())
	end)
	frame.autoUpdateCheckbox = checkbox

	-- create checkbox for auto-equipping
	checkbox = LibStub("tekKonfig-Checkbox").new(frame, nil, ns.locale.AutoUpdateOnRespec, "TOP", checkbox, "BOTTOM", 0, 4)
	checkbox:SetPoint("LEFT", frame, "LEFT")
	checkbox.tipText = ns.locale.AutoUpdateOnRespecTooltip
	checkbox:SetScript('OnEnter', ns.ShowTooltip)
	checkbox:SetScript('OnLeave', ns.HideTooltip)
	checksound = checkbox:GetScript('OnClick')
	checkbox:SetScript('OnClick', function(self)
		checksound(self)
		local set = ns.GetSetByID(ns.selectedSet, true)
		set:SetAutoEquip(not set:GetAutoEquip())
	end)
	frame.autoEquipCheckbox = checkbox
end

function SetOptionsPlugin:OnShow()
	local frame = self:GetConfigPanel()
	local set = ns.GetSetByID(ns.selectedSet, true)

	local index, func = 1, nil
	while frame["exposedSetting"..index] do
		func = frame["exposedSetting"..index].updateHandler
		if func and set[func] then
			frame["exposedSetting"..index]:SetChecked(set[func](set))
		end
		index = index + 1
	end

	-- update selected specialization
	local spec = set:GetAssociatedSpec()
	if spec then
		UIDropDownMenu_SetSelectedValue(frame.specDropDown, spec)
		local _, specName = GetSpecializationInfoByID(spec)
		UIDropDownMenu_SetText(frame.specDropDown, specName)

		-- enable spec-based options
		frame.autoEquipCheckbox:SetEnabled(true)
		frame.autoUpdateCheckbox:SetEnabled(true)
	else
		UIDropDownMenu_SetSelectedValue(frame.specDropDown, 'none')
		UIDropDownMenu_SetText(frame.specDropDown, ns.locale.NoSpecSelected)

		-- disable spec-based options
		frame.autoEquipCheckbox:SetEnabled(false)
		frame.autoUpdateCheckbox:SetEnabled(false)
	end

	frame.autoUpdateCheckbox:SetChecked(set:GetAutoUpdate())
	frame.autoEquipCheckbox:SetChecked(set:GetAutoEquip())
end
