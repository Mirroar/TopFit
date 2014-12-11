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
	TopFit.db.profile.sets[setID] = {
		name = setName,
		weights = {},
		caps = {},
		forced = {},
	}

	local set = ns.Set.CreateWritableFromSavedVariables(setID)
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
	for setCode, setTable in pairs(TopFit.db.profile.sets) do
		if (setTable.name == setName) then
			return true
		end
	end
	return false
end

function TopFit:DeleteSet(setCode)
	local setName = TopFit:GenerateSetName(self.db.profile.sets[setCode].name)

	-- remove from equipment manager
	if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(setName)) then
		DeleteEquipmentSet(setName)
	end

	-- remove from saved variables
	self.db.profile.sets[setCode] = nil

	-- remove automatic update set if necessary
	if self.db.profile.defaultUpdateSet == setCode then
		self.db.profile.defaultUpdateSet = nil
	end
	if self.db.profile.defaultUpdateSet2 == setCode then
		self.db.profile.defaultUpdateSet2 = nil
	end

	if self.setObjectCache then
		self.setObjectCache[setCode] = nil
	end

	TopFit:SetSelectedSet()
end

function TopFit:RenameSet(setCode, newName)
	oldSetName = TopFit:GenerateSetName(self.db.profile.sets[setCode].name)

	-- check if set name is already taken, generate a unique one in that case
	if (TopFit:HasSet(newName) and not newName == TopFit.db.profile.sets[setCode].name) then
		local newSetName = "2-"..newName --TODO: wut?
		local k = 2
		while TopFit:HasSet(newSetName) do
			k = k + 1
			newSetName = k.."-"..newName
		end
		newName = newSetName
	end

	newSetName = TopFit:GenerateSetName(newName)

	-- rename in saved variables
	self.db.profile.sets[setCode].name = newName

	-- rename equipment set if it exists
	if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(oldSetName)) then
		ModifyEquipmentSet(oldSetName, newSetName)
	end

	TopFit:SetSelectedSet(TopFit.selectedSet)

	--TODO: remove when progress frame is removed
	if (TopFit.ProgressFrame) then
		-- update setname if it is selected
		if UIDropDownMenu_GetSelectedValue(TopFit.ProgressFrame.setDropDown) == setCode then
			UIDropDownMenu_SetSelectedName(TopFit.ProgressFrame.setDropDown, newName)
		end
	end
end



function TopFit:GetStatValue(setCode, statCode)
	if not setCode or not statCode then return 0 end
	local result = TopFit.db.profile.sets[setCode].weights[statCode] or 0
	return result
end

function TopFit:GetCapValue(setCode, statCode)
	if not setCode or not statCode then return 0 end
	if TopFit.db.profile.sets[setCode].caps[statCode] then
		return TopFit.db.profile.sets[setCode].caps[statCode].value or 0
	else
		return 0
	end
end

function TopFit:GetAfterCapStatValue(setCode, statCode)
	if not setCode or not statCode then return 0 end
	if TopFit.db.profile.sets[setCode].caps[statCode] then
		return TopFit.db.profile.sets[setCode].caps[statCode].statValueAfter or 0
	else
		return 0
	end
end

function TopFit:IsCapActive(setCode, statCode)
	if not setCode or not statCode then return false end
	if TopFit.db.profile.sets[setCode].caps[statCode] then
		return TopFit.db.profile.sets[setCode].caps[statCode].active or false
	else
		return false
	end
end

function TopFit:SetStatValue(setCode, statCode, value)
	TopFit.db.profile.sets[setCode].weights[statCode] = value
end

function TopFit:SetCapValue(setCode, statCode, value)
	TopFit:InitializeCapTable(setCode, statCode)
	TopFit.db.profile.sets[setCode].caps[statCode].value = value
end

function TopFit:SetAfterCapStatValue(setCode, statCode, value)
	TopFit:InitializeCapTable(setCode, statCode)
	TopFit.db.profile.sets[setCode].caps[statCode].statValueAfter = value
end

function TopFit:SetCapActive(setCode, statCode, value)
	TopFit:InitializeCapTable(setCode, statCode)
	TopFit.db.profile.sets[setCode].caps[statCode].active = value
end

function TopFit:InitializeCapTable(setCode, statCode)
	if not TopFit.db.profile.sets[setCode].caps[statCode] then
		TopFit.db.profile.sets[setCode].caps[statCode] = {
			value = 0,
			active = false,
			statValueAfter = 0
		}
	end
end

function TopFit:GetForcedItems(setCode, slotID)
	if not TopFit.db.profile.sets[setCode].forced then
		return {}
	elseif not TopFit.db.profile.sets[setCode].forced[slotID] then
		return {}
	elseif type(TopFit.db.profile.sets[setCode].forced[slotID]) ~= "table" then
		TopFit.db.profile.sets[setCode].forced[slotID] = {TopFit.db.profile.sets[setCode].forced[slotID]}
	end
	return TopFit.db.profile.sets[setCode].forced[slotID]
end

function TopFit:AddForcedItem(setCode, slotID, itemID)
	if not TopFit.db.profile.sets[setCode].forced then
		TopFit.db.profile.sets[setCode].forced = {}
	end
	if not TopFit.db.profile.sets[setCode].forced[slotID] then
		TopFit.db.profile.sets[setCode].forced[slotID] = {itemID}
	else
		tinsert(TopFit.db.profile.sets[setCode].forced[slotID], itemID)
	end
end

function TopFit:RemoveForcedItem(setCode, slotID, itemID)
	if TopFit.db.profile.sets[setCode].forced then
		if TopFit.db.profile.sets[setCode].forced[slotID] then
			for i, forcedItem in ipairs(TopFit.db.profile.sets[setCode].forced[slotID]) do
				if forcedItem == itemID then
					tremove(TopFit.db.profile.sets[setCode].forced[slotID], i)
					break
				end
			end
		end
	end
end

