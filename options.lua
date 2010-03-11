-- function for getting the options table at runtime, so we can change it (like adding new sets, etc.)
function TopFit:GetOptionsTable(uiType, uiName)
	return TopFit.myOptions
end

function TopFit:createCapOptions(setCode, subCat, stat)
	TopFit.myOptions.args.sets.args[setCode].args.weights.args[subCat].args.caps.args[stat.."_VALUE"] = {
		name = _G[stat].." Cap value",
		desc = "The value of the stat you want to reach. (eg. 200 Hit)\nIf there is no way to reach this cap with your equipment, it will be ignored and the stat's weight will be used normally.",
		type = "input",
		get = "GetCapValue",
		set = "SetCapValue",
	}
	TopFit.myOptions.args.sets.args[setCode].args.weights.args[subCat].args.caps.args[stat.."_SOFTCAP"] = {
		name = _G[stat].." Soft Cap",
		desc = "Toggle wether to use this stat as soft- or hardcap.\nSoft cap means you want to reach this cap, but more is still good, so use the stat's score in item value calculations. (eg. Defense cap)\nHard cap means you want to reach the cap, and not more, so the stat is not included in item value calculations. (eg. Caster Hitcap)",
		type = 'toggle',
		get = "GetIsSoftCap",
		set = "SetIsSoftCap",
	}
end

function TopFit:createWeightsOptionTable()
	weightsTable = {
		type = "group",
		name = "Weights",
		desc = "Set the value for one point of a given stat.",
		args = {},
	}
		
	for groupName, group in pairs(TopFit.statList) do
		weightsTable.args[groupName] = {
			name = groupName,
			type = "group",
			args = {},
		}
		
		for _, statCode in pairs(group) do
			weightsTable.args[groupName].args[statCode] = {
				name = _G[statCode],
				type = 'range',
				min = -10,
				max = 100,
				get = "GetWeight",
				set = "SetWeight",
			}
		end
		
		weightsTable.args[groupName].args["caps"] = {
			type = "group",
			name = "Caps",
			desc = "Set a target value to obtain for a given stat.",
			args = {},
		}
		
		for _, statCode in pairs(group) do
			weightsTable.args[groupName].args["caps"].args[statCode] = {
				name = _G[statCode],
				type = 'toggle',
				get = "GetIsCapped",
				set = "SetIsCapped",
			}
		end
	end
	
	return weightsTable
end

function TopFit:createSetOptionsTable(setName)
	return {
		type = "group",
		name = setName or "Set",
		args = {
			test = {
				type = 'execute',
				name = 'Update this Set',
				desc = 'Find the bestest of items for this set.',
				func = 'StartCalculationsForSet',
			},
			delete = {
				type = 'execute',
				name = 'Delete',
				desc = 'Delete this set. Like, Poof!\n|cffff0000Caution!|r This will also remove the associated set in the Equipment Manager.',
				func = 'DeleteSet',
				confirm = true,
			},
			rename = {
				type = 'input',
				name = 'Name this set',
				desc = 'This name will be used in the configuration and in the equipment manager.',
				get = 'GetSetName',
				set = 'SetSetName',
			},
			force = {
				type = 'group',
				name = 'Forced Items',
				desc = 'Force certain items to be worn in this set, like an insignia or specific librams.',
				args = TopFit:createForcedItemsOptionTable(),
			},
			weights = TopFit:createWeightsOptionTable(),
		},
	}
end

function TopFit:createForcedItemsOptionTable()
	forcedTable = {}
	
	-- get item list
	TopFit:collectItems()
	
	-- create selection for every slot
	for slotID, slotName in pairs(TopFit.slotNames) do
		forcedTable[slotName] = {
			type = 'select',
			name = slotName,
			get = 'GetForced',
			set = 'SetForced',
			values = { [0] = "don't force" },
		}
		if (TopFit.itemListBySlot[slotID]) then
			for _, itemTable in pairs(TopFit.itemListBySlot[slotID]) do
				forcedTable[slotName].values[itemTable.itemID] = itemTable.itemLink
			end
		end
	end
	
	return forcedTable
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
			test = {
				type = 'execute',
				name = 'Update all sets',
				desc = 'Find the bestest of items for all your sets.',
				func = 'StartCalculations',
			},
			abort = {
				type = 'execute',
				name = 'Abort Set Calculation',
				desc = 'Aborts any running set calculation if it takes too long.',
				func = 'AbortCalculations',
			},
			addset = {
				type = 'execute',
				name = 'Add a new Set',
				desc = 'Add a new equipment set for which you can set scales and calculate item values.',
				func = 'AddSet',
			},
			options = {
				order = 50,
				type = 'group',
				childGroups  = 'tree',
				name = 'Options',
				args = {
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
			},
		},
	}
    
	-- create options for all sets
	TopFit.myOptions.args.sets = {
		type = 'group',
		childGroups  = 'tree',
		name = 'Sets',
		args = {},
		order = 10,
	}
	
	for setCode, setTable in pairs(self.db.profile.sets) do
		TopFit.myOptions.args.sets.args[setCode] = TopFit:createSetOptionsTable(setTable.name)
		
		if setTable.caps then
			-- create options for all active caps
			for stat, capTable in pairs(self.db.profile.sets[setCode].caps) do
				if (capTable["active"]) then
					-- find subcat of this stat
					for subCat, catTable in pairs(TopFit.statList) do
						for _, curStat in pairs(catTable) do
							if (stat == curStat) then
								TopFit:createCapOptions(setCode, subCat, stat)
							end
						end
					end
				end
			end
		end
	end
end

function TopFit:GetForced(info)
	--TopFit:Debug("GetForced - slot: "..info[#info].."; set: "..info[#info-2])
	return self.db.profile.sets[info[#info-2]].forced[TopFit.slots[info[#info]]] or 0
end

function TopFit:SetForced(info, value)
	TopFit:Debug("SetForced - slot: "..info[#info].."; set: "..info[#info-2].."; value: "..value)
	if value == 0 then value = nil end
	self.db.profile.sets[info[#info-2]].forced[TopFit.slots[info[#info]]] = value
end

function TopFit:GetWeight(info)
	--TopFit:Debug("GetWeight - stat: "..info[#info].."; set: "..info[#info-3])
	if (self.db.profile.sets[info[#info-3]].weights[info[#info]]) then
		return self.db.profile.sets[info[#info-3]].weights[info[#info]]
	else
		return 0
	end
end

function TopFit:SetWeight(info, value)
	--TopFit.Weights[info[#info]] = value
	--TopFit:Debug("SetWeight("..info[#info]..", "..value..")")
	self.db.profile.sets[info[#info-3]].weights[info[#info]] = value
end

function TopFit:AddSet(info, input)
	i = 1
	added = false
	while (not added) do
		-- check if set i exists
		if (not TopFit.myOptions.args.sets.args["set_"..i]) then
			TopFit.myOptions.args.sets.args["set_"..i] = TopFit:createSetOptionsTable("Set "..i)
			self.db.profile.sets["set_"..i] = {
				name = "Set "..i,
				weights = {},
				caps = {},
				forced = {},
			}
			added = true
		end
		i = i + 1
	end
end

function TopFit:DeleteSet(info, input)
	setCode = info[#info - 1]
	setName = TopFit:GenerateSetName(self.db.profile.sets[setCode]["name"])
	
	-- remove from options
	TopFit.myOptions.args.sets.args[setCode] = nil
	
	-- remove from saved variables
	self.db.profile.sets[setCode] = nil
	
	-- remove from equipment manager
	if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(setName)) then
		DeleteEquipmentSet(setName)
	end
	
	if (TopFit.ProgressFrame) then
		-- update setname if it is selected
		if UIDropDownMenu_GetSelectedValue(TopFit.ProgressFrame.setDropDown) == setCode then
			UIDropDownMenu_SetSelectedID(TopFit.ProgressFrame.setDropDown, 1)
		end
	end
end

function TopFit:GetSetName(info, input)
	setCode = info[#info - 1]
	
	return self.db.profile.sets[setCode]["name"]
end

function TopFit:SetSetName(info, input)
	setCode = info[#info - 1]
	oldSetName = TopFit:GenerateSetName(self.db.profile.sets[setCode]["name"])
	newSetName = TopFit:GenerateSetName(input)
	
	-- rename in saved variables
	self.db.profile.sets[setCode]["name"] = input
	
	-- rename in options table
	TopFit.myOptions.args.sets.args[setCode]["name"] = input
	
	-- rename equipment set if it exists
	if (CanUseEquipmentSets() and GetEquipmentSetInfoByName(oldSetName)) then
		RenameEquipmentSet(oldSetName, newSetName)
	end
	
	if (TopFit.ProgressFrame) then
		-- update setname if it is selected
		if UIDropDownMenu_GetSelectedValue(TopFit.ProgressFrame.setDropDown) == setCode then
			UIDropDownMenu_SetSelectedName(TopFit.ProgressFrame.setDropDown, input)
		end
	end
end

function TopFit:GetIsCapped(info, input)
	setCode = info[#info - 4]
	stat = info[#info]
	if (self.db.profile.sets[setCode].caps[stat]) then
		return self.db.profile.sets[setCode].caps[stat]["active"] or false
	else
		return false
	end
end

function TopFit:SetIsCapped(info, input)
	setCode = info[#info - 4]
	subCat = info[#info - 2]
	stat = info[#info]
	if (self.db.profile.sets[setCode].caps[stat]) then
		self.db.profile.sets[setCode].caps[stat]["active"] = input
	else
		self.db.profile.sets[setCode].caps[stat] = {
			active = input,
			value = 0,
			soft = false,
		}
	end
	
	-- also show / hide options
	if input then
		TopFit:createCapOptions(setCode, subCat, stat)
	else
		TopFit.myOptions.args.sets.args[setCode].args.weights.args[subCat].args.caps.args[stat.."_VALUE"] = nil
		TopFit.myOptions.args.sets.args[setCode].args.weights.args[subCat].args.caps.args[stat.."_SOFTCAP"] = nil
	end
end

function TopFit:GetCapValue(info, input)
	setCode = info[#info - 4]
	stat = string.sub(info[#info], 1, -7)
	--TopFit:Debug("Value for "..stat.." cap in set "..setCode.." is "..(self.db.profile.sets[setCode].caps[stat]["value"] or "nil"))
	
	return self.db.profile.sets[setCode].caps[stat]["value"]
end

function TopFit:SetCapValue(info, input)
	setCode = info[#info - 4]
	stat = string.sub(info[#info], 1, -7)
	--TopFit:Debug("Setting "..stat.." cap in set "..setCode.." to "..input)
	
	if (tonumber(input) == nil) then
		input = "0"
	else
		input = tostring(tonumber(input))
	end
	
	self.db.profile.sets[setCode].caps[stat]["value"] = input
end

function TopFit:GetIsSoftCap(info, input)
	setCode = info[#info - 4]
	stat = string.sub(info[#info], 1, -9)
	
	return self.db.profile.sets[setCode].caps[stat]["soft"]
end

function TopFit:SetIsSoftCap(info, input)
	setCode = info[#info - 4]
	stat = string.sub(info[#info], 1, -9)
	
	self.db.profile.sets[setCode].caps[stat]["soft"] = input
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

