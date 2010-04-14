-- function for getting the options table at runtime, so we can change it (like adding new sets, etc.)
function TopFit:GetOptionsTable(uiType, uiName)
	return TopFit.myOptions
end

function TopFit:createOptionsTable()
	-- list of weight categories and stats
	TopFit.statList = {
		["Basic Attributes"] = {
			[1] = "ITEM_MOD_AGILITY_SHORT",
			[2] = "ITEM_MOD_INTELLECT_SHORT",
			[3] = "ITEM_MOD_SPIRIT_SHORT",
			[4] = "ITEM_MOD_STAMINA_SHORT",
			[5] = "ITEM_MOD_STRENGTH_SHORT",
		},
		["Melee"] = {
			[1] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
			[2] = "ITEM_MOD_ATTACK_POWER_SHORT",
			[3] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
			[4] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
		},
		["Caster"] = {
			[1] = "ITEM_MOD_SPELL_PENETRATION_SHORT",
			[2] = "ITEM_MOD_SPELL_POWER_SHORT",
			[3] = "ITEM_MOD_MANA_REGENERATION_SHORT",
		},
		["Defensive"] = {
			[1] = "ITEM_MOD_BLOCK_RATING_SHORT",
			[2] = "ITEM_MOD_BLOCK_VALUE_SHORT",
			[3] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
			[4] = "ITEM_MOD_DODGE_RATING_SHORT",
			[5] = "ITEM_MOD_PARRY_RATING_SHORT",
			[6] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
			[7] = "RESISTANCE0_NAME",			-- armor
		},
		["Hybrid"] = {
			[1] = "ITEM_MOD_CRIT_RATING_SHORT",
			[2] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
			[3] = "ITEM_MOD_HASTE_RATING_SHORT",
			[4] = "ITEM_MOD_HIT_RATING_SHORT",
		},
		["Misc."] = {
			[1] = "ITEM_MOD_HEALTH_SHORT",
			[2] = "ITEM_MOD_MANA_SHORT",
			[3] = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
		},
		["Resistances"] = {
			[1] = "RESISTANCE1_NAME",			-- holy
			[2] = "RESISTANCE2_NAME",			-- fire
			[3] = "RESISTANCE3_NAME",			-- nature
			[4] = "RESISTANCE4_NAME",			-- frost
			[5] = "RESISTANCE5_NAME",			-- shadow
			[6] = "RESISTANCE6_NAME",			-- arcane
		},
	}
     
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
	
	-- add profile management to options
	--TopFit.myOptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
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
	
	if (TopFit.ProgressFrame) then
		TopFit.ProgressFrame:SetSelectedSet()
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

