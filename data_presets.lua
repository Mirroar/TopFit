function TopFit:GetPresets()
        local playerClass = select(2,UnitClass("player"))
        local playerRace = select(2,UnitRace("player"))
        
        if not TopFit.presets then -- don't want to create new tables every time this function is called
                --[[local spellCap = math.ceil(26.23 * (17 - (playerRace == "Draenei" and 1 or 0) - ((playerClass == "PRIEST" or playerClass == "DRUID") and 3 or 0)))
                local spellCapMinus3 = math.ceil(26.23 * (14 - (playerRace == "Draenei" and 1 or 0) - ((playerClass == "PRIEST" or playerClass == "DRUID") and 3 or 0)))
                local spellCapMinus6 = math.ceil(26.23 * (11 - (playerRace == "Draenei" and 1 or 0) - ((playerClass == "PRIEST" or playerClass == "DRUID") and 3 or 0)))
                local meleeCap = math.ceil(32.79 * ((TopFit.playerCanDualWield and 27 or 8) - (playerRace == "Draenei" and 1 or 0)))
                local meleeCapMinus3 = math.ceil(32.79 * (((TopFit.playerCanDualWield and playerClass ~= "HUNTER") and 24 or 5) - (playerRace == "Draenei" and 1 or 0)))
                local meleeCapDW = math.ceil(32.79 * 24)]]
        
                TopFit.presets = {
                        ["DEATHKNIGHT"] = {
                                [1] = {
                                        name = "Blood",
                                        weights = {
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,
                                                ["ITEM_MOD_PARRY_RATING_SHORT"] = 8.3,
                                                ["ITEM_MOD_DODGE_RATING_SHORT"] = 8.3,
                                                ["ITEM_MOD_STAMINA_SHORT"] = 5.4,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.3,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 2.4,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 1.7,
                                                ["RESISTANCE0_NAME"] = 1.3,

                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 1,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Frost",
                                        weights = {
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 36.0,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 10,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 6.9,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 5.6,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 4.5,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 4.3,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 3.4,
                                                ["RESISTANCE0_NAME"] = 0.1,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Unholy",
                                        weights = {
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 18.2,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 10,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 8.2,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 5.1,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 4.1,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.9,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 2.5,
                                                ["RESISTANCE0_NAME"] = 0.1,
                                        },
                                        caps = {
                                        },
                                },
                        },
                        ["DRUID"] = {
                                [1] = {
                                        name = "Feral Tank",
                                        weights = {
                                                ["ITEM_MOD_AGILITY_SHORT"] = 10,
                                                ["ITEM_MOD_DODGE_RATING_SHORT"] = 8.8,
                                                ["RESISTANCE0_NAME"] = 7.1,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 4.8,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.8,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 1.5,
                                                ["ITEM_MOD_STAMINA_SHORT"] = 1.3,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.2,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.4,
                                                ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 0.4,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Feral DPS",
                                        weights = {
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 15.6,
                                                ["ITEM_MOD_AGILITY_SHORT"] = 10,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 3.8,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 3.7,
                                                ["ITEM_MOD_FERAL_ATTACK_POWER_SHORT"] = 3.7,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 3.3,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.2,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 3.2,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 3.1,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 3.1,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Balance",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 8.1,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 7.7,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 7.2,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 4.9,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.9,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [4] = {
                                        name = "Restoration",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 8.5,
                                                ["ITEM_MOD_SPIRIT_SHORT"] = 7.5,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 6.5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 5.0,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {},
                                },
                        },
                        ["HUNTER"] = {
                                [1] = {
                                        name = "Beast Mastery",
                                        weights = {
                                                ["TOPFIT_RANGED_DPS"] = 15.9,
                                                ["ITEM_MOD_AGILITY_SHORT"] = 10,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 8.1,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 7.3,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 4.3,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 3.8,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 2.3,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Marksmanship",
                                        weights = {
                                                ["TOPFIT_RANGED_WEAPON_SPEED"] = 10,
                                                ["TOPFIT_RANGED_DPS"] = 8.1,
                                                ["ITEM_MOD_AGILITY_SHORT"] = 4,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 2.9,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.9,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.6,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.3,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 1.3,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Survival",
                                        weights = {
                                                ["TOPFIT_RANGED_WEAPON_SPEED"] = 10,
                                                ["TOPFIT_RANGED_DPS"] = 7,
                                                ["ITEM_MOD_AGILITY_SHORT"] = 4.4,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 3.5,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 2.9,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.4,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.3,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 1.2,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                        },
                        ["MAGE"] = {
                                [1] = {
                                        name = "Arcane",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 6.2,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 5.4,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 2.7,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.6,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 2.5,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Fire",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 7.9,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 7.5,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 4.6,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 4.5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 3.8,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Frost",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 9.4,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 8.2,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 4.4,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 4.2,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 4.1,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                        },
                        ["PALADIN"] = {
                                [1] = {
                                        name = "Holy",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 8,
                                                ["ITEM_MOD_SPIRIT_SHORT"] = 7.5,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 4,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 3,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {},
                                },
                                [2] = {
                                        name = "Retribution",
                                        weights = {
                                                ["TOPFIT_MELEE_WEAPON_SPEED"] = 10,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 4.8,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 1.2,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 0.8,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.7,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 0.6,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 0.5,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 0.5,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 0.4,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Protection",
                                        weights = {
                                                ["ITEM_MOD_DODGE_RATING_SHORT"] = 10,
                                                ["ITEM_MOD_PARRY_RATING_SHORT"] = 10,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 8.1,
                                                ["ITEM_MOD_STAMINA_SHORT"] = 4.9,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 2.8,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.8,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 0.4,
                                                ["RESISTANCE0_NAME"] = 0.01,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                        },
                        ["PRIEST"] = {
                                [1] = {
                                        name = "Shadow",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 7.7,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 5.6,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 5.4,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 5.2,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 4.7,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Holy",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPIRIT_SHORT"] = 8,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 7.5,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 7.5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 5,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {},
                                },
                                [3] = {
                                        name = "Discipline",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPIRIT_SHORT"] = 8,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 7.5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 5,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 4,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {},
                                },
                        },
                        ["ROGUE"] = {
                                [1] = {
                                        name = "Assassination",
                                        weights = {
                                                ["TOPFIT_MELEE_WEAPON_SPEED"] = 10,
                                                ["TOPFIT_MELEE_DPS"] = 3.7,
                                                ["ITEM_MOD_AGILITY_SHORT"] = 2.9,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 1.4,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.3,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.3,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.2,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 1.2,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 1,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Combat",
                                        weights = {
                                                ["TOPFIT_MELEE_DPS"] = 12.4,
                                                ["TOPFIT_MELEE_WEAPON_SPEED"] = 10,
                                                ["ITEM_MOD_AGILITY_SHORT"] = 6.7,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 4.1,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 4.1,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 3.8,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 3.1,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 3,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 2.3,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Subtlety",
                                        weights = {
                                                ["TOPFIT_MELEE_WEAPON_SPEED"] = 10,
                                                ["TOPFIT_MELEE_DPS"] = 4.4,
                                                ["ITEM_MOD_AGILITY_SHORT"] = 4,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 1.5,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 1.4,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 1.3,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 1.3,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 1.2,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 1,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                        },
                        ["SHAMAN"] = {
                                [1] = {
                                        name = "Enhancement",
                                        weights = {
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 12.4,
                                                ["ITEM_MOD_AGILITY_SHORT"] = 10,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 6.1,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 6.1,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 4.9,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 4,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 3.8,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.6,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 3,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 2.9,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Elemental",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 8,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 6,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 5.5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 4.6,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.5,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Restoration",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPIRIT_SHORT"] = 9,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 7.5,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 6,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 5.5,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 4,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {},
                                },
                        },
                        ["WARLOCK"] = {
                                [1] = {
                                        name = "Affliction",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 8.5,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 5.3,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 4.5,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.7,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 3.7,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Demonology",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 8,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 8,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 4.6,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.9,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Destruction",
                                        weights = {
                                                ["ITEM_MOD_INTELLECT_SHORT"] = 10,
                                                ["ITEM_MOD_SPELL_POWER_SHORT"] = 7.8,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 7.6,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 4.2,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 3.9,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 3.6,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                        },
                        ["WARRIOR"] = {
                                [1] = {
                                        name = "Arms",
                                        weights = {
                                                ["TOPFIT_MELEE_DPS"] = 37,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 10,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 7.4,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 5,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 4.5,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 3.3,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 2,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [2] = {
                                        name = "Fury",
                                        weights = {
                                                ["TOPFIT_MELEE_DPS"] = 10.4,
                                                ["ITEM_MOD_CRIT_RATING_SHORT"] = 10,
                                                ["ITEM_MOD_ATTACK_POWER_SHORT"] = 8,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 6.5,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 6.4,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 4.6,
                                                ["ITEM_MOD_HASTE_RATING_SHORT"] = 2.7,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 2.5,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                                ["RESISTANCE0_NAME"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                                [3] = {
                                        name = "Protection",
                                        weights = {
                                                ["ITEM_MOD_PARRY_RATING_SHORT"] = 10,
                                                ["ITEM_MOD_DODGE_RATING_SHORT"] = 9.7,
                                                ["ITEM_MOD_MASTERY_RATING_SHORT"] = 6.5,
                                                ["ITEM_MOD_STAMINA_SHORT"] = 3.9,
                                                ["ITEM_MOD_STRENGTH_SHORT"] = 2.8,
                                                ["RESISTANCE0_NAME"] = 1,
                                                ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 0.6,
                                                ["ITEM_MOD_HIT_RATING_SHORT"] = 0.3,
                                                ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 0.001,
                                        },
                                        caps = {
                                        },
                                },
                        },
                }
        end
        
        return TopFit.presets[playerClass]
end
