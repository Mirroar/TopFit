local _, ns = ...

function ns:GetPresets(class)
	class = class or select(2, UnitClass("player"))
	return ns.presets[class]
end

-- TODO: handle armorbonus

ns.presets = {
	WARRIOR = {
		{
			name = "Arms",
			weights = {
				ITEM_MOD_HASTE_RATING_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 6.8,
				ITEM_MOD_STRENGTH_SHORT = 6.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.8
			}
		},
		{
			name = "Fury",
			weights = {
				ITEM_MOD_MASTERY_RATING_SHORT = 10.0,
				ITEM_MOD_HASTE_RATING_SHORT = 9.2,
				ITEM_MOD_CRIT_RATING_SHORT = 9.0,
				ITEM_MOD_STRENGTH_SHORT = 8.4
			}
		},
		{
			name = "Protection",
			weights = {
				ITEM_MOD_STRENGTH_SHORT = 10.0,
				armorbonus = 9.0,
				ITEM_MOD_STAMINA_SHORT = 7.1,
				ITEM_MOD_CRIT_RATING_SHORT = 6.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.1
			}
		}
	},
	PALADIN = {
		{
			name = "Holy",
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10.0,
				ITEM_MOD_SPELL_POWER_SHORT = 8.0,
				ITEM_MOD_CRIT_RATING_SHORT = 7.5,
				ITEM_MOD_SPIRIT_SHORT = 7.0,
				ITEM_MOD_HASTE_RATING_SHORT = 5.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.0
			}
		},
		{
			name = "Protection",
			weights = {
				ITEM_MOD_MASTERY_RATING_SHORT = 10.0,
				ITEM_MOD_STAMINA_SHORT = 9.6,
				armorbonus = 9.5,
				ITEM_MOD_HASTE_RATING_SHORT = 7.4,
				ITEM_MOD_CRIT_RATING_SHORT = 7.1,
				RESISTANCE0_NAME = 5.9,
				ITEM_MOD_STRENGTH_SHORT = 4.9,
				ITEM_MOD_ATTACK_POWER_SHORT = 3.6
			}
		},
		{
			name = "Retribution",
			weights = {
				ITEM_MOD_STRENGTH_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 9.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.8,
				ITEM_MOD_HASTE_RATING_SHORT = 2.7
			}
		}
	},
	HUNTER = {
		{
			name = "Beastmastery",
			weights = {
				ITEM_MOD_AGILITY_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 8.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 6.3,
				ITEM_MOD_HASTE_RATING_SHORT = 5.6
			}
		},
		{
			name = "Marksmanship",
			weights = {
				ITEM_MOD_AGILITY_SHORT = 10.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.9,
				ITEM_MOD_CRIT_RATING_SHORT = 6.9,
				ITEM_MOD_HASTE_RATING_SHORT = 5.8
			}
		},
		{
			name = "Survival",
			weights = {
				ITEM_MOD_AGILITY_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 6.9,
				ITEM_MOD_HASTE_RATING_SHORT = 6.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.0
			}
		}
	},
	ROGUE = {
		{
			name = "Assassination",
			weights = {
				ITEM_MOD_AGILITY_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 8.4,
				ITEM_MOD_HASTE_RATING_SHORT = 7.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.9
			}
		},
		{
			name = "Combat",
			weights = {
				ITEM_MOD_AGILITY_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 9.9,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.6,
				ITEM_MOD_HASTE_RATING_SHORT = 5.7
			}
		},
		{
			name = "Subtlety",
			weights = {
				ITEM_MOD_AGILITY_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 8.4,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.9,
				ITEM_MOD_HASTE_RATING_SHORT = 6.4
			}
		}
	},
	PRIEST = {
		{
			name = "Discipline",
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10.0,
				ITEM_MOD_SPELL_POWER_SHORT = 8.1,
				ITEM_MOD_SPIRIT_SHORT = 8.0,
				ITEM_MOD_CRIT_RATING_SHORT = 6.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 6.0,
				ITEM_MOD_HASTE_RATING_SHORT = 3.0
			}
		},
		{
			name = "Holy",
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10.0,
				ITEM_MOD_SPELL_POWER_SHORT = 8.5,
				ITEM_MOD_SPIRIT_SHORT = 8.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.5,
				ITEM_MOD_HASTE_RATING_SHORT = 6.2,
				ITEM_MOD_CRIT_RATING_SHORT = 4.3
			}
		},
		{
			name = "Shadow",
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10.0,
				ITEM_MOD_SPELL_POWER_SHORT = 9.9,
				ITEM_MOD_CRIT_RATING_SHORT = 9.1,
				ITEM_MOD_MASTERY_RATING_SHORT = 8.7,
				ITEM_MOD_HASTE_RATING_SHORT = 8.4
			}
		}
	},
	DEATHKNIGHT = {
		{
			name = "Blood",
			weights = {
				ITEM_MOD_STRENGTH_SHORT = 10.0,
				armorbonus = 9.9,
				ITEM_MOD_MASTERY_RATING_SHORT = 8.5,
				ITEM_MOD_HASTE_RATING_SHORT = 8.0,
				ITEM_MOD_CRIT_RATING_SHORT = 7.0
			}
		},
		{
			name = "Frost",
			weights = {
				ITEM_MOD_STRENGTH_SHORT = 10.0,
				ITEM_MOD_HASTE_RATING_SHORT = 8.7,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.9,
				ITEM_MOD_CRIT_RATING_SHORT = 6.7
			}
		},
		{
			name = "Unholy",
			weights = {
				ITEM_MOD_MASTERY_RATING_SHORT = 10.0,
				ITEM_MOD_STRENGTH_SHORT = 9.3,
				ITEM_MOD_HASTE_RATING_SHORT = 7.7,
				ITEM_MOD_CRIT_RATING_SHORT = 6.6
			}
		}
	},
	SHAMAN = {
		{
			name = "Elemental",
			weights = {
				ITEM_MOD_CRIT_RATING_SHORT = 10.0,
				ITEM_MOD_HASTE_RATING_SHORT = 10.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 9.7,
				ITEM_MOD_INTELLECT_SHORT = 9.5,
				ITEM_MOD_SPELL_POWER_SHORT = 9.3
			}
		},
		{
			name = "Enhancement",
			weights = {
				ITEM_MOD_AGILITY_SHORT = 10.0,
				TOPFIT_MELEE_DPS = 9.9,
				ITEM_MOD_CRIT_RATING_SHORT = 7.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.0,
				ITEM_MOD_HASTE_RATING_SHORT = 6.4
			}
		},
		{
			name = "Restoration",
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10.0,
				ITEM_MOD_SPELL_POWER_SHORT = 7.5,
				ITEM_MOD_SPIRIT_SHORT = 6.5,
				ITEM_MOD_CRIT_RATING_SHORT = 6.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 5.8,
				ITEM_MOD_HASTE_RATING_SHORT = 5.0
			}
		}
	},
	MAGE = {
		{
			name = "Arcane",
			weights = {
				ITEM_MOD_HASTE_RATING_SHORT = 10.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 9.9,
				ITEM_MOD_INTELLECT_SHORT = 9.5,
				ITEM_MOD_SPELL_POWER_SHORT = 9.4,
				ITEM_MOD_CRIT_RATING_SHORT = 9.3
			}
		},
		{
			name = "Fire",
			weights = {
				ITEM_MOD_CRIT_RATING_SHORT = 10.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 8.7,
				ITEM_MOD_HASTE_RATING_SHORT = 8.1,
				ITEM_MOD_SPELL_POWER_SHORT = 7.0,
				ITEM_MOD_INTELLECT_SHORT = 7.0
			}
		},
		{
			name = "Frost",
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10.0,
				ITEM_MOD_SPELL_POWER_SHORT = 9.9,
				ITEM_MOD_MASTERY_RATING_SHORT = 8.3,
				ITEM_MOD_CRIT_RATING_SHORT = 7.2,
				ITEM_MOD_HASTE_RATING_SHORT = 6.7
			}
		}
	},
	WARLOCK = {
		{
			name = "Affliction",
			weights = {
				ITEM_MOD_MASTERY_RATING_SHORT = 10.0,
				ITEM_MOD_INTELLECT_SHORT = 7.8,
				ITEM_MOD_SPELL_POWER_SHORT = 7.7,
				ITEM_MOD_HASTE_RATING_SHORT = 7.7,
				ITEM_MOD_CRIT_RATING_SHORT = 7.5
			}
		},
		{
			name = "Demonology",
			weights = {
				ITEM_MOD_MASTERY_RATING_SHORT = 10.0,
				ITEM_MOD_INTELLECT_SHORT = 9.0,
				ITEM_MOD_SPELL_POWER_SHORT = 8.9,
				ITEM_MOD_CRIT_RATING_SHORT = 8.2,
				ITEM_MOD_HASTE_RATING_SHORT = 6.5
			}
		},
		{
			name = "Destruction",
			weights = {
				ITEM_MOD_HASTE_RATING_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 9.7,
				ITEM_MOD_INTELLECT_SHORT = 8.9,
				ITEM_MOD_SPELL_POWER_SHORT = 8.8,
				ITEM_MOD_MASTERY_RATING_SHORT = 8.4
			}
		}
	},
	MONK = {
		{
			name = "Brewmaster",
			weights = {
				RESISTANCE0_NAME = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 9.5,
				armorbonus = 9.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 7.8,
				ITEM_MOD_HASTE_RATING_SHORT = 6.3,
				ITEM_MOD_AGILITY_SHORT = 4.8
			}
		},
		{
			name = "Mistweaver",
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10.0,
				ITEM_MOD_SPELL_POWER_SHORT = 8.5,
				ITEM_MOD_CRIT_RATING_SHORT = 8.0,
				ITEM_MOD_SPIRIT_SHORT = 7.5,
				ITEM_MOD_HASTE_RATING_SHORT = 6.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 4.0
			}
		},
		{
			name = "Windwalker",
			weights = {
				ITEM_MOD_AGILITY_SHORT = 10.0,
				ITEM_MOD_HASTE_RATING_SHORT = 9.8,
				ITEM_MOD_CRIT_RATING_SHORT = 7.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 3.9
			}
		}
	},
	DRUID = {
		{
			name = "Balance",
			weights = {
				ITEM_MOD_HASTE_RATING_SHORT = 10.0,
				ITEM_MOD_MASTERY_RATING_SHORT = 9.5,
				ITEM_MOD_INTELLECT_SHORT = 9.5,
				ITEM_MOD_SPELL_POWER_SHORT = 9.3,
				ITEM_MOD_CRIT_RATING_SHORT = 9.1
			}
		},
		{
			name = "Feral",
			weights = {
				TOPFIT_MELEE_DPS = 11.3,
				ITEM_MOD_AGILITY_SHORT = 10.0,
				ITEM_MOD_CRIT_RATING_SHORT = 3.8,
				ITEM_MOD_MASTERY_RATING_SHORT = 3.0,
				ITEM_MOD_HASTE_RATING_SHORT = 2.7
			}
		},
		{
			name = "Guardian",
			weights = {
				armorbonus = 10.0,
				ITEM_MOD_AGILITY_SHORT = 9.6,
				RESISTANCE0_NAME = 9.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 8.0,
				ITEM_MOD_HASTE_RATING_SHORT = 7.0,
				ITEM_MOD_CRIT_RATING_SHORT = 6.0
			}
		},
		{
			name = "Restoration",
			weights = {
				ITEM_MOD_INTELLECT_SHORT = 10.0,
				ITEM_MOD_SPELL_POWER_SHORT = 8.5,
				ITEM_MOD_SPIRIT_SHORT = 8.0,
				ITEM_MOD_HASTE_RATING_SHORT = 7.5,
				ITEM_MOD_MASTERY_RATING_SHORT = 6.5,
				ITEM_MOD_CRIT_RATING_SHORT = 6.0
			}
		}
	}
}

-- add some universal stats to every spec at very low scores for leveling
for class, presets in pairs(ns.presets) do
	for _, preset in pairs(presets) do
		preset.weights.RESISTANCE0_NAME = preset.weights.RESISTANCE0_NAME or 0.001
		preset.weights.ITEM_MOD_STAMINA_SHORT = preset.weights.ITEM_MOD_STAMINA_SHORT or 0.01
		preset.weights.ITEM_MOD_CRIT_RATING_SHORT = preset.weights.ITEM_MOD_CRIT_RATING_SHORT or 0.01
		preset.weights.ITEM_MOD_MASTERY_RATING_SHORT = preset.weights.ITEM_MOD_MASTERY_RATING_SHORT or 0.01
		preset.weights.ITEM_MOD_HASTE_RATING_SHORT = preset.weights.ITEM_MOD_HASTE_RATING_SHORT or 0.01
	end
end