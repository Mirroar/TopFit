local addonName, ns = ...

function TopFit:createOptions()
	if not TopFit.InterfaceOptionsFrame then
		TopFit.InterfaceOptionsFrame = CreateFrame("Frame", "TopFit_InterfaceOptionsFrame", InterfaceOptionsFramePanelContainer)
		TopFit.InterfaceOptionsFrame.name = addonName
		TopFit.InterfaceOptionsFrame:Hide()

		local title, subtitle = LibStub("tekKonfig-Heading").new(TopFit.InterfaceOptionsFrame, addonName, TopFit.locale.SubTitle)

		-- Show Minimap Icon Checkbox
		local showMinimapIcon = LibStub("tekKonfig-Checkbox").new(TopFit.InterfaceOptionsFrame, nil, TopFit.locale.ShowMinimapIcon, "TOPLEFT", subtitle, "BOTTOMLEFT", -2, 0)
		showMinimapIcon.tiptext = TopFit.locale.ShowMinimapIconTooltip
		showMinimapIcon:SetChecked(not TopFit.db.profile.minimapIcon.hide)
		local checksound = showMinimapIcon:GetScript("OnClick")
		showMinimapIcon:SetScript("OnClick", function(self)
			checksound(self)
			TopFit.db.profile.minimapIcon.hide = not TopFit.db.profile.minimapIcon.hide
			if TopFit.db.profile.minimapIcon.hide then
				TopFit.minimapIcon:Hide(addonName)
			else
				TopFit.minimapIcon:Show(addonName)
			end
		end)

		-- Show Tooltip Checkbox
		local showTooltip = LibStub("tekKonfig-Checkbox").new(TopFit.InterfaceOptionsFrame, nil, TopFit.locale.ShowTooltipScores, "TOPLEFT", showMinimapIcon, "BOTTOMLEFT", 0, 0)
		showTooltip.tiptext = TopFit.locale.ShowTooltipScoresTooltip
		showTooltip:SetChecked(TopFit.db.profile.showTooltip)
		local checksound = showTooltip:GetScript("OnClick")
		showTooltip:SetScript("OnClick", function(self)
			checksound(self)
			TopFit.db.profile.showTooltip = not TopFit.db.profile.showTooltip
		end)

		-- Show Comparison Tooltip Checkbox
		local showComparisonTooltip = LibStub("tekKonfig-Checkbox").new(TopFit.InterfaceOptionsFrame, nil, TopFit.locale.ShowTooltipComparison, "TOPLEFT", showTooltip, "BOTTOMLEFT", 0, 0)
		showComparisonTooltip.tiptext = TopFit.locale.ShowTooltipComparisonTooltip
		showComparisonTooltip:SetChecked(TopFit.db.profile.showComparisonTooltip)
		local checksound = showComparisonTooltip:GetScript("OnClick")
		showComparisonTooltip:SetScript("OnClick", function(self)
			checksound(self)
			TopFit.db.profile.showComparisonTooltip = not TopFit.db.profile.showComparisonTooltip
		end)

		-- Debug Mode Checkbox
		local debugMode = LibStub("tekKonfig-Checkbox").new(TopFit.InterfaceOptionsFrame, nil, TopFit.locale.Debug, "TOPLEFT", showComparisonTooltip, "BOTTOMLEFT", 0, -30)
		debugMode.tiptext = TopFit.locale.DebugTooltip
		debugMode:SetChecked(TopFit.db.profile.debugMode)
		local checksound = debugMode:GetScript("OnClick")
		debugMode:SetScript("OnClick", function(self)
			checksound(self)
			TopFit.db.profile.debugMode = not TopFit.db.profile.debugMode
		end)

		-- auto-test checkbox
		if IsAddOnLoaded('wowUnit') and ns.testsLoaded then
			local autoRunTests = LibStub("tekKonfig-Checkbox").new(TopFit.InterfaceOptionsFrame, nil, TopFit.locale.AutoRunTests, "TOPLEFT", debugMode, "BOTTOMLEFT", 0, 0)
			autoRunTests.tiptext = TopFit.locale.AutoRunTestsTooltip
			autoRunTests:SetChecked(TopFit.db.profile.autoRunTests)
			local checksound = autoRunTests:GetScript("OnClick")
			autoRunTests:SetScript("OnClick", function(self)
				checksound(self)
				TopFit.db.profile.autoRunTests = not TopFit.db.profile.autoRunTests
			end)
		end

		InterfaceOptions_AddCategory(TopFit.InterfaceOptionsFrame)
		LibStub("tekKonfig-AboutPanel").new(addonName, addonName)

		TopFit.InterfaceOptionsFrame:SetScript("OnShow", function()
			showTooltip:SetChecked(TopFit.db.profile.showTooltip)
			debugMode:SetChecked(TopFit.db.profile.debugMode)
		end)
	end
end

function TopFit:AddSet(preset)
	local i = 1
	while  TopFit.db.profile.sets["set_"..i] do i = i + 1 end

	local setName
	local weights = {}
	local caps = {}
	if preset then
		setName = preset.name
		if preset.weights then
			for key, value in pairs(preset.weights) do
				weights[key] = value
			end
		end
		if preset.caps then
			for key, value in pairs(preset.caps) do
				caps[key] = {}
				for key2, value2 in pairs(value) do
					caps[key][key2] = value2
				end
			end
		end
	else
		setName = "Set "..i
	end

	-- check if set name is already taken, generate a unique one in that case
	if (TopFit:HasSet(setName)) then
		local newSetName = "2-"..setName
		local k = 2
		while TopFit:HasSet(newSetName) do
			k = k + 1
			newSetName = k.."-"..setName
		end
		setName = newSetName
	end

	local setID = "set_"..i
	TopFit.db.profile.sets[setID] = TopFit.Set.PrepareSavedVariableTable()

	local set = ns.GetSetByID(setID, true)
	set:SetName(setName)
	for key, value in pairs(weights) do
		set:SetStatWeight(key, value)
	end

	for key, value in pairs(caps) do
		set:SetHardCap(key, value)
	end

	if preset and preset.specialization then
		set:SetAssociatedSpec(preset.specialization)
	end

	if not GetEquipmentSetInfoByName(ns:GenerateSetName(set:GetName())) then
		TopFit:CreateEquipmentManagerSet(set)
	end

	TopFit:SetSelectedSet(setID)

	return setID
end

function TopFit:HasSet(setName)
	for _, setCode in pairs(ns.GetSetList()) do
		local set = ns.GetSetByID(setCode, true)
		if (set:GetName() == setName) then
			return true
		end
	end
	return false
end

function TopFit:DeleteSet(setCode)
	local set = ns.GetSetByID(setCode, true)
	local setName = set:GetEquipmentSetName()

	-- remove from equipment manager
	if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(setName)) then
		DeleteEquipmentSet(setName)
	end

	-- remove from saved variables
	self.db.profile.sets[setCode] = nil

	if self.setObjectCache then
		self.setObjectCache[setCode] = nil
	end

	TopFit:SetSelectedSet()
end

function TopFit:RenameSet(setCode, newName)
	local set = ns.GetSetByID(setCode, true)
	oldSetName = set:GetEquipmentSetName()

	-- check if set name is already taken, generate a unique one in that case
	if (TopFit:HasSet(newName) and not newName == set:GetName()) then
		-- prefix numbers to set name until a unique name is generated
		local k = 2
		while TopFit:HasSet(k.."-"..newName) do
			k = k + 1
		end
		newName = k.."-"..newName
	end

	local newSetName = TopFit:GenerateSetName(newName)

	-- rename in saved variables
	set:SetName(newName)

	-- rename equipment set if it exists
	if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(oldSetName)) then
		ModifyEquipmentSet(oldSetName, newSetName)
	end

	-- trigger UI update
	TopFit:SetSelectedSet(TopFit.selectedSet)
end
