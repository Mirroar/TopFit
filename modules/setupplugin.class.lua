local addonName, ns, _ = ...

local SetupPlugin = ns.Plugin()
ns.SetupPlugin = SetupPlugin

-- creates a new ImportPlugin object
function SetupPlugin:Initialize()
	self:SetName(ns.locale.NoSetTitle)
	self:SetTooltipText(ns.locale.SetupWizardIntro)
	self:SetButtonTexture("Interface\\Icons\\Achievement_BG_AB_kill_in_mine")
	self.hasConfigButton = false
	self.isUIInitialized = false
	self:RegisterConfigPanel()
end

function SetupPlugin:OnShow()
	local frame = self:GetConfigPanel()
	local frameWidth = 372 -- needed for word wrapping. The info is not available at initialization time
	local presets = ns:GetPresets()

	-- helper function that enables and disables the Confirm button based on whether one of the checkboxes is set
	local function updateButtonState()
		frame.confirmButton:Disable()
		for presetID, preset in ipairs(presets) do
			if frame['presetCheckbox'..presetID]:GetChecked() then
				frame.confirmButton:Enable()
				break
			end
		end
	end

	if not self.isUIInitialized then
		self.isUIInitialized = true

		local specText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		specText:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, 0)
		specText:SetPoint('RIGHT', frame, 'RIGHT', 0, 0)
		specText:SetWordWrap(true)
		specText:SetWidth(frameWidth) -- need to have any width for wrapping to work correctly
		specText:SetJustifyH('LEFT')
		frame.specText = specText

		-- create checkboxes for all available presets
		local checkbox
		for presetID, preset in ipairs(presets) do
			local anchorTo, anchorTarget, xOffset = "BOTTOMLEFT", specText, 0
			if presetID % 2 == 0 then
				anchorTo = "TOPLEFT"
				xOffset = frameWidth / 2
				anchorTarget = frame['presetCheckbox'..(presetID - 1)]
			elseif presetID > 1 then
				anchorTarget = frame['presetCheckbox'..(presetID - 2)]
			end

			checkbox = LibStub("tekKonfig-Checkbox").new(frame, nil, preset.wizardName, "TOPLEFT", anchorTarget, anchorTo, xOffset, presetID == 1 and -10 or 0)
			--checkbox.tiptext = TopFit.locale.ShowMinimapIconTooltip
			frame['presetCheckbox'..presetID] = checkbox

			local checkSound = checkbox:GetScript("OnClick")
			checkbox:SetScript('OnClick', function(self, ...)
				checkSound(self, ...)
				updateButtonState()
			end)
		end

		-- create checkbox for auto-equipping
		checkbox = LibStub("tekKonfig-Checkbox").new(frame, nil, ns.locale.SetupWizardAutoEquip, "TOP", checkbox, "BOTTOM", 0, -5)
		checkbox:SetPoint("LEFT", frame, "LEFT")
		checkbox:SetChecked(true)
		frame.autoEquipCheckbox = checkbox

		-- detect character specialization for suggesting default sets
		local specID, specName = GetSpecializationInfo(GetSpecialization(nil, nil, 1) or 0)
		local specID2, specName2 = GetSpecializationInfo(GetSpecialization(nil, nil, 2) or 0)

		local specText = ns.locale.SetupWizardSpec0
		if specID and specID2 then
			specText = ns.locale.SetupWizardSpec2:format(specName, specName2)
		elseif specID or specID2 then
			specText = ns.locale.SetupWizardSpec1:format(specName or specName2)
		end

		specText = specText..ns.locale.SetupWizardSpecAll
		frame.specText:SetText(specText)

		-- set default sets to checked
		for presetID, preset in ipairs(presets) do
			if preset.default then
				if (not specID and not specID2) or (preset.specialization == specID or preset.specialization == specID2) then
					frame['presetCheckbox'..presetID]:SetChecked(true)
				else
					frame['presetCheckbox'..presetID]:SetChecked(false)
				end
			else
				frame['presetCheckbox'..presetID]:SetChecked(false)
			end
		end

		-- create confirmation button
		local button = CreateFrame('Button', '$parentConfirmButton', frame, 'UIPanelButtonTemplate')
		button:SetText('Confirm') --TODO: translate
		button:SetPoint('TOPLEFT', checkbox, 'BOTTOMLEFT', 0, -10)
		button:Show()
		button:SetWidth(100)

		button:SetScript('OnClick', function()
			-- create selected sets
			local autoUpdateSpecs = {}
			for presetID, preset in ipairs(presets) do
				if frame['presetCheckbox'..presetID]:GetChecked() then
					local setID = ns:AddSet(preset)

					if frame.autoEquipCheckbox:GetChecked() and preset.specialization and not autoUpdateSpecs[preset.specialization] then
						local set = ns.GetSetByID(setID, true)

						set:SetAutoEquip(true)
						set:SetAutoUpdate(true)
						autoUpdateSpecs[preset.specialization] = true
					end
				end
			end

			-- switch to weights plugin
			ns.ui.ShowPanel(ns.WeightsPlugin.configPanel)
		end)
		frame.confirmButton = button
	end

	updateButtonState()
end