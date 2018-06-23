local addonName, ns = ...

ns.presets = {}

local function BuildPresets(class)
	local stats = {
		[_G.LE_UNIT_STAT_STRENGTH]  = 'ITEM_MOD_STRENGTH_SHORT',
		[_G.LE_UNIT_STAT_AGILITY]   = 'ITEM_MOD_AGILITY_SHORT',
		[_G.LE_UNIT_STAT_INTELLECT] = 'ITEM_MOD_INTELLECT_SHORT',
	}

	ns.presets[class] = {}
	for i = 1, GetNumSpecializations() do
		local specID, specName, description, icon, role, primaryStat = GetSpecializationInfo(i)
		ns.presets[class][i] = {
			name = specName,
			wizardName = specName,
			specialization = specID,
			default = true,
			weights = {
				[ stats[primaryStat] ] = 10,
				ITEM_MOD_MASTERY_RATING_SHORT = 5,
				ITEM_MOD_CRIT_RATING_SHORT = 5,
				ITEM_MOD_HASTE_RATING_SHORT = 5,
				ITEM_MOD_VERSATILITY = 3,
			},
		}

		if primaryStat ~= ITEM_MOD_INTELLECT_SHORT then
			ns.presets[class][i].weights[ITEM_MOD_MELEE_ATTACK_POWER_SHORT] = 1
			ns.presets[class][i].weights[ITEM_MOD_DAMAGE_PER_SECOND_SHORT] = 2
		end
		if role == 'TANK' then
			ns.presets[class][i].weights[ITEM_MOD_STAMINA_SHORT] = 5
			ns.presets[class][i].weights[ITEM_MOD_CR_AVOIDANCE_SHORT] = 3
			ns.presets[class][i].weights[RESISTANCE0_NAME] = 0.5
			ns.presets[class][i].weights[ITEM_MOD_EXTRA_ARMOR_SHORT] = 0.5
		end
	end

	-- add some universal stats to every spec at very low scores for leveling if character is low level
	if UnitLevel('player') < _G.MAX_PLAYER_LEVEL_TABLE[_G.LE_EXPANSION_CLASSIC] then
		for class, presets in pairs(ns.presets) do
			for _, preset in pairs(presets) do
				preset.weights.RESISTANCE0_NAME = preset.weights.RESISTANCE0_NAME or 0.001
				preset.weights.ITEM_MOD_STAMINA_SHORT = preset.weights.ITEM_MOD_STAMINA_SHORT or 0.01
			end
		end
	end
end

function ns:GetPresets(class)
	class = class or select(2, UnitClass('player'))
	if not ns.presets[class] then
		BuildPresets(class)
	end
	return ns.presets[class]
end
