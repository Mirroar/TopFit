-- function for getting the options table at runtime, so we can change it (like adding new sets, etc.)
function TopFit:GetOptionsTable(uiType, uiName)
	return TopFit.myOptions
end

function TopFit:createOptionsTable()
	-- create options table
	TopFit.myOptions = {
		name = 'TopFit',
		handler = TopFit,
		type = 'group',
		childGroups  = 'tab',
		args = {
			-- TopFit:CreateProgressFrame()
			show = {
				type = 'execute',
				name = 'Show the Calculation Frame',
				desc = 'no desc',
				func = 'CreateProgressFrame',
			},
			defaultupdate = TopFit:AddDefaultUpdateSetOptions(),
			tooltip = {
				type = 'toggle',
				name = 'Show set values',
				desc = 'Shows the calculated item values for your sets in the game tooltip.',
				set = 'SetShowTooltip',
				get = 'GetShowTooltip',
			},
			debug = {
				type = 'toggle',
				name = 'Debug Mode',
				desc = 'Show Debug messages and item stats as seen by TopFit in item tooltips. Attention: Spams you chatframe. A lot.',
				set = 'SetDebugMode',
				get = 'GetDebugMode',
			},
		},
	}
end

function TopFit:AddDefaultUpdateSetOptions()
	result = {
		type = 'select',
		name = 'Automatic Update set',
		get = 'GetDefaultUpdateSet',
		set = 'SetDefaultUpdateSet',
		values = { [0] = 'None' },
		desc = "Select a set to automatically update when you get new equipment. This is helpful while leveling, if you don't want to manually start set calculation whenever you get a new quest reward or a nice drop.",
	}
	for key, value in pairs(TopFit.db.profile.sets) do
		local newkey = string.gsub(key, "set_", "")
		newkey = tonumber(newkey)
		result.values[newkey] = value.name
	end
	
	return result
end

function TopFit:GetDefaultUpdateSet(info)
	--TopFit:Debug("GetForced - slot: "..info[#info].."; set: "..info[#info-2])
	local newkey = nil
	if TopFit.db.profile.defaultUpdateSet then
		newkey = string.gsub(TopFit.db.profile.defaultUpdateSet, "set_", "")
		newkey = tonumber(newkey)
	end
	return newkey or 0
end

function TopFit:SetDefaultUpdateSet(info, value)
	TopFit:Debug("SetDefaultUpdateSet - "..info[#info].."; value: "..value)
	
	if value == 0 then
		TopFit.db.profile.defaultUpdateSet = nil
	else
		TopFit.db.profile.defaultUpdateSet = "set_"..value
	end
end

function TopFit:AddSet(preset)
	local i = 1
	while  TopFit.db.profile.sets["set_"..i] do i = i + 1 end
	
	local setName
	local weights = {}
	local caps = {}
	if preset then
		TopFit.debug = preset
		setName = preset.name
		for key, value in pairs(preset.weights) do
			weights[key] = value
		end
		for key, value in pairs(preset.caps) do
			caps[key] = {}
			for key2, value2 in pairs(value) do
				caps[key][key2] = value2
			end
		end
	else
		setName = "Set "..i
	end
	--TODO: check if set name is taken
	
	TopFit.db.profile.sets["set_"..i] = {
		name = setName,
		weights = weights,
		caps = caps,
		forced = {}
	}
	
	if TopFit.ProgressFrame then
		TopFit.ProgressFrame:SetSelectedSet("set_"..i)
	end
	TopFit:createOptionsTable()
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
	
	if (TopFit.ProgressFrame) then
		TopFit.ProgressFrame:SetSelectedSet()
		TopFit.ProgressFrame:SetCurrentCombination()
		TopFit.ProgressFrame:SetSetName("Set Name")
	end
	TopFit:createOptionsTable()
end

function TopFit:RenameSet(setCode, newName)
	oldSetName = TopFit:GenerateSetName(self.db.profile.sets[setCode]["name"])
	newSetName = TopFit:GenerateSetName(newName)

	-- rename in saved variables
	self.db.profile.sets[setCode]["name"] = newName
	
	-- rename equipment set if it exists
	if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(oldSetName)) then
		RenameEquipmentSet(oldSetName, newSetName)
	end
	
	if (TopFit.ProgressFrame) then
		-- update setname if it is selected
		if UIDropDownMenu_GetSelectedValue(TopFit.ProgressFrame.setDropDown) == setCode then
			UIDropDownMenu_SetSelectedName(TopFit.ProgressFrame.setDropDown, newName)
		end
	end
	TopFit:createOptionsTable()
end

function TopFit:GetDebugMode(info, input)
	return self.db.profile.debugMode
end

function TopFit:SetDebugMode(info, input)
	self.db.profile.debugMode = input
end

function TopFit:SetShowTooltip(info, input)
	self.db.profile.showTooltip = input
end

function TopFit:GetShowTooltip(info, input)
	return self.db.profile.showTooltip
end

