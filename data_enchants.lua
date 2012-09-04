-- this table matches enchant ids on items to their corresponding stat.
-- CAUTION: this is not the item-id of an enchant item, nor the same id that is used in tradeskills
-- the enchant ID is the number that appears in the item's itemLink

TopFit.enchantIDs = {
    -- Head
    [1] = {
        -- level 85, heirloom
        [4208] = {                                                      -- Arcanum of the Highlands (Dragonmaw / Wildhammer)
            ["ITEM_MOD_STRENGTH_SHORT"] = 60,
            ["ITEM_MOD_MASTERY_RATING_SHORT"] = 35,
        },
        [4209] = {                                                      -- Arcanum of Ramkahen
            ["ITEM_MOD_AGILITY_SHORT"] = 60,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 35,
        },
        [4207] = {                                                      -- Arcanum of Hyjal
            ["ITEM_MOD_INTELLECT_SHORT"] = 60,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 35,
        },
        [4206] = {                                                      -- Arcanum of the Earthern Ring
            ["ITEM_MOD_STAMINA_SHORT"] = 90,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 35,
        },

        -- level 85, rare
        [4245] = {                                                      -- Arcanum of Vicious Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 60,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 35,
        },
        [4246] = {                                                      -- Arcanum of Vicious Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 60,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 35,
        },
        [4247] = {                                                      -- Arcanum of Vicious Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 60,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 35,
        },
        
        -- level 80, heirloom
        [3819] = {                                                      -- Arcanum of Blissful Mending
            ["ITEM_MOD_INTELLECT_SHORT"] = 26,
            ["ITEM_MOD_SPIRIT_SHORT"] = 20,
        },
        [3820] = {                                                      -- Arcanum of Burning Mysteries
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 30,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 20,
        },
        [3817] = {                                                      -- Arcanum of Torment
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 20
        },
        [3842] = {                                                      -- Arcanum of the Savage Gladiator
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 25,
        },
        [3818] = {                                                      -- Arcanum of the Stalwart Protector
            ["ITEM_MOD_STAMINA_SHORT"] = 37,
            ["ITEM_MOD_DODGE_SKILL_RATING_SHORT"] = 20,
        },
        
        -- level 80, rare
        [3797] = {                                                      -- Arcanum of Dominance
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 29,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 20,
        },
        [3813] = {                                                      -- Arcanum of Toxic Warding
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            ["RESISTANCE3_NAME"] = 25,
        },
        [3795] = {                                                      -- Arcanum of Triumph
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 20,
        },
        [3815] = {                                                      -- Arcanum of the Eclipsed Moon
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            ["RESISTANCE6_NAME"] = 25,
        },
        [3816] = {                                                      -- Arcanum of the Flame's Soul
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            ["RESISTANCE2_NAME"] = 25,
        },
        [3814] = {                                                      -- Arcanum of the Fleeing Shadow
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            ["RESISTANCE5_NAME"] = 25,
        },
        [3812] = {                                                      -- Arcanum of the Frosty Soul
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            ["RESISTANCE4_NAME"] = 25,
        },

        -- level 80 armor kit
        [4120] = {                                                      -- Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 36,
        },
        [4121] = {                                                      -- Heavy Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 44,
        },
        
        -- level 70, uncommon
        [3006] = {                                                      -- Arcanum of Arcane Warding
            ["RESISTANCE6_NAME"] = 20,
        },
        [3003] = {                                                      -- Arcanum of Ferocity
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 34,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 16,
        },
        [3007] = {                                                      -- Arcanum of Fire Warding
            ["RESISTANCE2_NAME"] = 20,
        },
        [3008] = {                                                      -- Arcanum of Frost Warding
            ["RESISTANCE4_NAME"] = 20,
        },
        [3005] = {                                                      -- Arcanum of Nature Warding
            ["RESISTANCE3_NAME"] = 20,
        },
        [3002] = {                                                      -- Arcanum of Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 22,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 14,
        },
        [3001] = {                                                      -- Arcanum of Renewal
            ["ITEM_MOD_INTELLECT_SHORT"] = 16,
            ["ITEM_MOD_SPIRIT_SHORT"] = 18,
        },
        [3009] = {                                                      -- Arcanum of Shadow Warding
            ["RESISTANCE5_NAME"] = 20,
        },
        [2999] = {                                                      -- Arcanum of the Defender
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 16,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 17,
        },
        [3004] = {                                                      -- Arcanum of the Gladiator
            ["ITEM_MOD_STAMINA_SHORT"] = 18,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 20,
        },
        [3096] = {                                                      -- Arcanum of the Outcast
            ["ITEM_MOD_STRENGTH_SHORT"] = 17,
            ["ITEM_MOD_INTELLECT_SHORT"] = 16,
        },
        
        -- level 70 armor kits
        [3330] = {                                                      -- Heavy Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 18,
        },
        [3329] = {                                                      -- Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 12,
        },
        
        -- level 60, Zul'Gurub rare
        [2591] = {                                                      -- Animist's Caress
            ["ITEM_MOD_INTELLECT_SHORT"] = 10,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 12,
        },
        [3755] = {                                                      -- Death's Embrace
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 28,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 12,
        },
        [3752] = {                                                      -- Falcon's Call
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 24,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 10,
        },
        [2589] = {                                                      -- Hoodoo Hex
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 18,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
        },
        [2583] = {                                                      -- Presence of Might
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 10,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 10,
        },
        [2588] = {                                                      -- Presence of Sight
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 18,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 8,
        },
        [2590] = {                                                      -- Prophetic Aura
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 13,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_SPIRIT_SHORT"] = 10, -- there is still mana reg on this item, but it is usually converted into double the amount in spirit everywhere
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 5,
        },
        [2584] = {                                                      -- Syncretist's Sigil
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 10,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_INTELLECT_SHORT"] = 10,
        },
        [2587] = {                                                      -- Vodouisant's Vigilant Embrace
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 13,
            ["ITEM_MOD_INTELLECT_SHORT"] = 15,
        },
        
        -- level 60 armor kit
        [2841] = {                                                      -- Heavy Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
        },
        
        -- level 55, rare
        [2682] = {                                                      -- Ice Guard
            ["RESISTANCE4_NAME"] = 10,
        },
        [2681] = {                                                      -- Savage Guard
            ["RESISTANCE3_NAME"] = 10,
        },
        [2683] = {                                                      -- Shadow Guard
            ["RESISTANCE5_NAME"] = 10,
        },
        
        -- level 50, uncommon
        [2544] = {                                                      -- Arcanum of Focus
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 8,
        },
        [2545] = {                                                      -- Arcanum of Protection
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 12,
        },
        [2543] = {                                                      -- Arcanum of Rapidity
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 10,
        },
        
        [1503] = {                                                      -- Lesser Arcanum of Constitution
            ["ITEM_MOD_HEALTH_SHORT"] = 100,
        },
        [1505] = {                                                      -- Lesser Arcanum of Resilience
            ["RESISTANCE2_NAME"] = 20,
        },
        [1483] = {                                                      -- Lesser Arcanum of Rumination
            ["ITEM_MOD_MANA_SHORT"] = 150,
        },
        [1504] = {                                                      -- Lesser Arcanum of Tenacity
            ["RESISTANCE0_NAME"] = 125,
        },
        [1508] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_AGILITY_SHORT"] = 8,
        },
        [1509] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_INTELLECT_SHORT"] = 8,
        },
        [1510] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_SPIRIT_SHORT"] = 8,
        },
        [1507] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_STAMINA_SHORT"] = 8,
        },
        [1506] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_STRENGTH_SHORT"] = 8,
        },
    },
    
    -- Shoulders
    [3] = {
        -- level 85, epic
        [4200] = {                                                      -- Greater Inscription of Charged Lodestone
            ["ITEM_MOD_INTELLECT_SHORT"] = 50,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 25,
        },
        [4202] = {                                                      -- Greater Inscription of Jagged Stone
            ["ITEM_MOD_STRENGTH_SHORT"] = 50,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 25,
        },
        [4204] = {                                                      -- Greater Inscription of Shattered Crystal
            ["ITEM_MOD_AGILITY_SHORT"] = 50,
            ["ITEM_MOD_MASTERY_RATING_SHORT"] = 25,
        },
        [4198] = {                                                      -- Greater Inscription of Unbreakable Quartz
            ["ITEM_MOD_STAMINA_SHORT"] = 75,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 25,
        },
        [4250] = {                                                      -- Greater Inscription of Vicious Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 50,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 25,
        },
        [4248] = {                                                      -- Greater Inscription of Vicious Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 50,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 25,
        },
        [4249] = {                                                      -- Greater Inscription of Vicious Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 50,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 25,
        },
        
        -- level 85, rare
        [4199] = {                                                      -- Lesser Inscription of Charged Lodestone
            ["ITEM_MOD_INTELLECT_SHORT"] = 30,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 20,
        },
        [4201] = {                                                      -- Lesser Inscription of Jagged Stone
            ["ITEM_MOD_STRENGTH_SHORT"] = 30,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 20,
        },
        [4205] = {                                                      -- Lesser Inscription of Shattered Crystal
            ["ITEM_MOD_AGILITY_SHORT"] = 30,
            ["ITEM_MOD_MASTERY_RATING_SHORT"] = 20,
        },
        [4197] = {                                                      -- Lesser Inscription of Unbreakable Quartz
            ["ITEM_MOD_STAMINA_SHORT"] = 45,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 20,
        },
        
        -- level 80, heirloom
        [3808] = {                                                      -- Greater Inscription of the Axe
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 15,
        },
        [3809] = {                                                      -- Greater Inscription of the Crag
            ["ITEM_MOD_INTELLECT_SHORT"] = 21,
            ["ITEM_MOD_SPIRIT_SHORT"] = 16,
        },
        [3811] = {                                                      -- Greater Inscription of the Pinnacle
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 20,
            ["ITEM_MOD_STAMINA_SHORT"] = 22,
        },
        [3810] = {                                                      -- Greater Inscription of the Storm
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 24,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 15,
        },
        
        -- level 80, rare
        [3794] = {                                                      -- Inscription of Dominance
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 23,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 15,
        },
        [3793] = {                                                      -- Inscription of Triumph
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 15,
        },
        [3875] = {                                                      -- Lesser Inscription of the Axe
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 10,
        },
        [3807] = {                                                      -- Lesser Inscription of the Crag
            ["ITEM_MOD_INTELLECT_SHORT"] = 15,
            ["ITEM_MOD_SPIRIT_SHORT"] = 10,
        },
        [3876] = {                                                      -- Lesser Inscription of the Pinnacle
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 15,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 10,
        },
        [3806] = {                                                      -- Lesser Inscription of the Storm 
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 18,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 10,
        },

        -- level 80 armor kits
        [4120] = {                                                      -- Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 36,
        },
        [4121] = {                                                      -- Heavy Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 44,
        },
        
        -- level 70, epic
        [3852] = {                                                      -- Greater Inscription of the Gladiator
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 15,
        },
        
        -- level 70, rare
        [2982] = {                                                      -- Greater Inscription of Discipline
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 18,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 10,
        },
        [2980] = {                                                      -- Greater Inscription of Faith
            ["ITEM_MOD_INTELLECT_SHORT"] = 15,
            ["ITEM_MOD_SPIRIT_SHORT"] = 10,
        },
        [2986] = {                                                      -- Greater Inscription of Vengeance
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 10,
        },
        [2978] = {                                                      -- Greater Inscription of Warding
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 15,
            ["ITEM_MOD_STAMINA_SHORT"] = 15,
        },
        [2997] = {                                                      -- Greater Inscription of the Blade
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 15,
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 20,
        },
        [2991] = {                                                      -- Greater Inscription of the Knight
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 15,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 10,
        },
        [2993] = {                                                      -- Greater Inscription of the Oracle
            ["ITEM_MOD_INTELLECT_SHORT"] = 10,
            ["ITEM_MOD_SPIRIT_SHORT"] = 16,
        },
        [2995] = {                                                      -- Greater Inscription of the Orb
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 15,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 12,
        },
        
        -- level 70 armor kits
        [3330] = {                                                      -- Heavy Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 18,
        },
        [3329] = {                                                      -- Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 12,
        },
        
        -- level 70, uncommon
        [2998] = {                                                      -- Inscription of Endurance
            ["RESISTANCE1_NAME"] = 7,
            ["RESISTANCE2_NAME"] = 7,
            ["RESISTANCE3_NAME"] = 7,
            ["RESISTANCE4_NAME"] = 7,
            ["RESISTANCE5_NAME"] = 7,
            ["RESISTANCE6_NAME"] = 7,
        },
        
        -- level 64, uncommon
        [2981] = {                                                      -- Inscription of Discipline
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 15,
        },
        [2979] = {                                                      -- Inscription of Faith
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 15,
        },
        [2983] = {                                                      -- Inscription of Vengeance
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 26,
        },
        [2977] = {                                                      -- Inscription of Warding
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 13,
        },
        [2996] = {                                                      -- Inscription of the Blade
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 13,
        },
        [2990] = {                                                      -- Inscription of the Knight
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 13,
        },
        [2992] = {                                                      -- Inscription of the Oracle
            ["ITEM_MOD_SPIRIT_SHORT"] = 12,
        },
        [2994] = {                                                      -- Inscription of the Orb
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 13,
        },
        
        -- level 60 armor kit
        [2841] = {                                                      -- Heavy Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
        },
        
        -- level 55, rare
        [2606] = {                                                      -- Zandalar Signet of Might
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 30,
        },
        [2605] = {                                                      -- Zandalar Signet of Mojo
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 18,
        },
        [2604] = {                                                      -- Zandalar Signet of Serenity
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 18,
        },
        
        -- level 50, uncommon
        [2485] = {                                                      -- Arcane Mantle of the Dawn
            ["RESISTANCE6_NAME"] = 5,
        },
        [2488] = {                                                      -- Chromatic Mantle of the Dawn
            ["RESISTANCE1_NAME"] = 5,
            ["RESISTANCE2_NAME"] = 5,
            ["RESISTANCE3_NAME"] = 5,
            ["RESISTANCE4_NAME"] = 5,
            ["RESISTANCE5_NAME"] = 5,
            ["RESISTANCE6_NAME"] = 5,
        },
        [2483] = {                                                      -- Flame Mantle of the Dawn
            ["RESISTANCE2_NAME"] = 5,
        },
        [2484] = {                                                      -- Frost Mantle of the Dawn
            ["RESISTANCE4_NAME"] = 5,
        },
        [2486] = {                                                      -- Nature Mantle of the Dawn
            ["RESISTANCE3_NAME"] = 5,
        },
        [2487] = {                                                      -- Shadow Mantle of the Dawn
            ["RESISTANCE5_NAME"] = 5,
        },
        
        -- inscription 400
        [3835] = {                                                      -- Master's Inscription of the Axe
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 120,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 15,
            -- inscription 400
        },
        [3836] = {                                                      -- Master's Inscription of the Crag
            ["ITEM_MOD_INTELLECT_SHORT"] = 60,
            ["ITEM_MOD_SPIRIT_SHORT"] = 15,
            -- inscription 400
        },
        [3837] = {                                                      -- Master's Inscription of the Pinnacle
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 60,
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 15,
            -- inscription 400
        },
        [3838] = {                                                      -- Master's Inscription of the Storm
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 70,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 15,
            -- inscription 400
        },
        
        -- inscription 500
        [4196] = {                                                      -- Felfire Inscription
            ["ITEM_MOD_INTELLECT_SHORT"] = 130,
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 25,
            -- inscription 400
        },
        [4195] = {                                                      -- Inscription of the Earth Prince
            ["ITEM_MOD_STAMINA_SHORT"] = 195,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 25,
            -- inscription 400
        },
        [4194] = {                                                      -- Lionsmane Inscription
            ["ITEM_MOD_STRENGTH_SHORT"] = 130,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 25,
            -- inscription 400
        },
        [4193] = {                                                      -- Swiftsteel Inscription
            ["ITEM_MOD_AGILITY_SHORT"] = 130,
            ["ITEM_MOD_MASTERY_RATING_SHORT"] = 25,
            -- inscription 400
        },
    },
    
    -- Back
    [15] = {
        -- cataclysm
        [4100] = {                                                      -- Enchant Cloak - Greater Critical Strike
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 65,
            -- iLvl 300+
        },
        [4096] = {                                                      -- Enchant Cloak - Greater Intellect
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4090] = {                                                      -- Enchant Cloak - Protection
            ["RESISTANCE0_NAME"] = 250,
            -- iLvl 300+
        },
        [4087] = {                                                      -- Enchant Cloak - Critical Strike
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4072] = {                                                      -- Enchant Cloak - Intellect
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 30,
            -- iLvl 300+
        },
        
        -- level 85
        [3831] = {                                                      -- Enchant Cloak - Greater Speed
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 23,
            -- 60+
        },
        [3258] = {                                                      -- Enchant Cloak - Shadow Armor
            ["ITEM_MOD_AGILITY_SHORT"] = 10,
            ["RESISTANCE0_NAME"] = 40,
            -- + stealth
            -- 60+
        },
        [1951] = {                                                      -- Enchant Cloak - Titanweave
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 16,
            -- 60+
        },
        [3296] = {                                                      -- Enchant Cloak - Wisdom
            ["ITEM_MOD_SPIRIT_SHORT"] = 10,
            -- + 2% aggro reduce
            -- 60+
        },
        
        -- level 80
        [983] = {                                                       -- Enchant Cloak - Superior Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 16,
            -- 60+
        },
        [1262] = {                                                      -- Enchant Cloak - Superior Arcane Resistance
            ["RESISTANCE6_NAME"] = 20,
            -- 60+
        },
        [1354] = {                                                      -- Enchant Cloak - Superior Fire Resistance
            ["RESISTANCE2_NAME"] = 20,
            -- 60+
        },
        [3230] = {                                                      -- Enchant Cloak - Superior Frost Resistance
            ["RESISTANCE4_NAME"] = 20,
            -- 60+
        },
        [1400] = {                                                      -- Enchant Cloak - Superior Nature Resistance
            ["RESISTANCE3_NAME"] = 20,
            -- 60+
        },
        [1446] = {                                                      -- Enchant Cloak - Superior Shadow Resistance
            ["RESISTANCE5_NAME"] = 20,
            -- 60+
        },
        
        -- level 79
        [3243] = {                                                      -- Enchant Cloak - Spell Piercing
            ["ITEM_MOD_SPELL_PENETRATION_SHORT"] = 35,
            -- 60+
        },
        
        -- level 75
        [1099] = {                                                      -- Enchant Cloak - Major Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 22,
            -- 60+
        },
        [3825] = {                                                      -- Enchant Cloak - Speed
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 15,
            -- 60+
        },
        [2648] = {                                                      -- Enchant Cloak - Steelweave
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 12,
            -- 35+
        },
        
        -- level 71
        [3294] = {                                                      -- Enchant Cloak - Mighty Armor
            ["RESISTANCE0_NAME"] = 225,
            -- 60+
        },
        
        -- level 70
        [2622] = {                                                      -- Enchant Cloak - Dodge
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 12,
            -- 35+
        },
        [1257] = {                                                      -- Enchant Cloak - Greater Arcane Resistance
            ["RESISTANCE6_NAME"] = 15,
            -- 35+
        },
        [2619] = {                                                      -- Enchant Cloak - Greater Fire Resistance
            ["RESISTANCE2_NAME"] = 15,
        },
        [2620] = {                                                      -- Enchant Cloak - Greater Nature Resistance
            ["RESISTANCE3_NAME"] = 15,
        },
        [1441] = {                                                      -- Enchant Cloak - Greater Shadow Resistance
            ["RESISTANCE5_NAME"] = 15,
        },
        [910] = {                                                       -- Enchant Cloak - Stealth
            -- + stealth
        },
        [2621] = {                                                      -- Enchant Cloak - Subtlety
            -- + 2% aggro reuduce
        },
        
        -- level 66
        [2664] = {                                                      -- Enchant Cloak - Major Resistance
            ["RESISTANCE1_NAME"] = 7,
            ["RESISTANCE2_NAME"] = 7,
            ["RESISTANCE3_NAME"] = 7,
            ["RESISTANCE4_NAME"] = 7,
            ["RESISTANCE5_NAME"] = 7,
            ["RESISTANCE6_NAME"] = 7,
            -- 35+
        },
        
        -- level 65
        [2938] = {                                                      -- Enchant Cloak - Spell Penetration
            ["ITEM_MOD_SPELL_PENETRATION_SHORT"] = 20,
            -- 35+
        },
        
        -- level 62
        [368] = {                                                       -- Enchant Cloak - Greater Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 12,
            -- 35+
        },
        [2662] = {                                                      -- Enchant Cloak - Major Armor
            ["RESISTANCE0_NAME"] = 120,
            -- 35+
        },
        
        -- level 57
        [1889] = {                                                      -- Enchant Cloak - Superior Defense
            ["RESISTANCE0_NAME"] = 70,
        },
        
        -- level 53
        [1888] = {                                                      -- Enchant Cloak - Greater Resistance
            ["RESISTANCE1_NAME"] = 5,
            ["RESISTANCE2_NAME"] = 5,
            ["RESISTANCE3_NAME"] = 5,
            ["RESISTANCE4_NAME"] = 5,
            ["RESISTANCE5_NAME"] = 5,
            ["RESISTANCE6_NAME"] = 5,
        },
        
        -- level 45
        [849] = {                                                       -- Enchant Cloak - Lesser Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 3,
        },
        
        -- level 41
        [884] = {                                                       -- Enchant Cloak - Greater Defense
            ["RESISTANCE0_NAME"] = 50,
        },
        [903] = {                                                       -- Enchant Cloak - Resistance
            ["RESISTANCE1_NAME"] = 3,
            ["RESISTANCE2_NAME"] = 3,
            ["RESISTANCE3_NAME"] = 3,
            ["RESISTANCE4_NAME"] = 3,
            ["RESISTANCE5_NAME"] = 3,
            ["RESISTANCE6_NAME"] = 3,
        },
        
        -- level 35
        [2463] = {                                                      -- Enchant Cloak - Fire Resistance
            ["RESISTANCE2_NAME"] = 7,
        },
        
        -- level 31
        [848] = {                                                       -- Enchant Cloak - Defense
            ["RESISTANCE0_NAME"] = 30,
        },
        
        -- level 27
        [804] = {                                                       -- Enchant Cloak - Lesser Shadow Resistance
            ["RESISTANCE5_NAME"] = 10,
        },
        
        -- level 25
        [256] = {                                                       -- Enchant Cloak - Lesser Fire Resistance
            ["RESISTANCE2_NAME"] = 5,
        },
        
        -- level 23
        [744] = {                                                       -- Enchant Cloak - Lesser Protection
            ["RESISTANCE0_NAME"] = 20,
        },
        
        -- level 22
        [247] = {                                                       -- Enchant Cloak - Minor Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 1,
        },
        
        -- level 18
        [783] = {                                                       -- Enchant Cloak - Minor Protection
            ["RESISTANCE0_NAME"] = 10,
        },
        
        -- level 15
        [65] = {                                                        -- Enchant Cloak - Minor Resistance
            ["RESISTANCE1_NAME"] = 1,
            ["RESISTANCE2_NAME"] = 1,
            ["RESISTANCE3_NAME"] = 1,
            ["RESISTANCE4_NAME"] = 1,
            ["RESISTANCE5_NAME"] = 1,
            ["RESISTANCE6_NAME"] = 1,
        },
        
        -- tailoring 420
        [3728] = {                                                      -- Darkglow Embroidery
            ["ITEM_MOD_SPIRIT_SHORT"] = 66, -- again, double the amount of old mp5
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 33,
            -- 400, 35% proc, 60 seconds CD ~ 25 mana per 5 sec.
            -- tailoring 400
        },
        [3722] = {                                                      -- Lightweave Embroidery
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 95,
            -- 285 spp for 15sec, 50% proc, 45 seconds CD
            -- tailoring 400
        },
        [3730] = {                                                      -- Swordguard Embroidery
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 100,
            -- 400 ap for 15sec, 25% proc, 45 seconds CD (?)
            -- tailoring 400
        },
        
        -- tailoring 500
        [4116] = {                                                      -- Darkglow Embroidery
            ["ITEM_MOD_SPIRIT_SHORT"] = 132, -- again, double the amount of old mp5
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 66,
            -- 800, 35% proc, 60 seconds CD ~ 25 mana per 5 sec.
            -- tailoring 500
        },
        [4115] = {                                                      -- Lightweave Embroidery
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 190,
            -- 580 spp for 15sec, 50% proc, 45 seconds CD (unconfirmed)
            -- tailoring 500
        },
        [4118] = {                                                      -- Swordguard Embroidery
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 250,
            -- 1000 ap for 15sec, 25% proc, 45 seconds CD (?)
            -- tailoring 500
        },
        
        -- engineering 380
        [3605] = {                                                      -- Flexweave Underlay
            -- parachute 1/min
            -- engineering 350
        },
        [3859] = {                                                      -- Springy Arachnoweave
            -- parachute 1/min
            -- engineering 350
        },
    },
    
    -- Chest
    [5] = {
        -- level 80 armor kits
        [4120] = {                                                      -- Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 36,
        },
        [4121] = {                                                      -- Heavy Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 44,
        },
        
        -- level 70 armor kits
        [3330] = {                                                      -- Heavy Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 18,
        },
        [3329] = {                                                      -- Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 12,
        },
        
        -- level 65 armor kits
        [2989] = {                                                      -- Arcane Armor Kit
            ["RESISTANCE6_NAME"] = 8,
        },
        [2985] = {                                                      -- Flame Armor Kit
            ["RESISTANCE2_NAME"] = 8,
        },
        [2987] = {                                                      -- Frost Armor Kit
            ["RESISTANCE4_NAME"] = 8,
        },
        [2988] = {                                                      -- Nature Armor Kit
            ["RESISTANCE3_NAME"] = 8,
        },
        [2984] = {                                                      -- Shadow Armor Kit
            ["RESISTANCE5_NAME"] = 8,
        },
        
        -- level 60 armor kit
        [2841] = {                                                      -- Heavy Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            -- 60+
        },
        
        -- level 55 armor kits
        [2794] = {                                                      -- Magister's Armor Kit
            ["ITEM_MOD_SPIRIT_SHORT"] = 8,
        },
        [2793] = {                                                      -- Vindicator's Armor Kit
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 8,
        },
        
        -- level 50 armor kits
        [2503] = {                                                      -- Core Armor Kit
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 5,
        },
        [2792] = {                                                      -- Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 8,
            -- 55+
        },
        
        -- level 40 armor kit
        [1843] = {                                                      -- Rugged Armor Kit
            ["RESISTANCE0_NAME"] = 40,
            -- 35+
        },
        
        -- level 30 armor kit
        [18] = {                                                        -- Thick Armor Kit
            ["RESISTANCE0_NAME"] = 32,
            -- 25+
        },
        
        -- level 20 armor kit
        [17] = {                                                        -- Heavy Armor Kit
            ["RESISTANCE0_NAME"] = 24,
            -- 15+
        },
        
        -- level 5 armor kit
        [16] = {                                                        -- Medium Armor Kit
            ["RESISTANCE0_NAME"] = 16,
        },
        
        -- level 0 armor kit
        [15] = {                                                        -- Light Armor Kit
            ["RESISTANCE0_NAME"] = 8,
        },
        
        -- enchants
        -- cataclysm
        [4103] = {                                                      -- Enchant Chest - Greater Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 75,
            -- iLvl 300+
        },
        [4102] = {                                                      -- Enchant Chest - Peerless Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 20,
            ["ITEM_MOD_INTELLECT_SHORT"] = 20,
            ["ITEM_MOD_SPIRIT_SHORT"] = 20,
            ["ITEM_MOD_STAMINA_SHORT"] = 20,
            ["ITEM_MOD_STRENGTH_SHORT"] = 20,
            -- iLvl 300+
        },
        [4088] = {                                                      -- Enchant Chest - Exceptional Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 40,
            -- iLvl 300+
        },
        [4077] = {                                                      -- Enchant Chest - Mighty Resilience
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 40,
            -- iLvl 300+
        },
        [4070] = {                                                      -- Enchant Chest - Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 55,
            -- iLvl 300+
        },
        
        -- level 85
        [3297] = {                                                      -- Enchant Chest - Super Health
            ["ITEM_MOD_HEALTH_SHORT"] = 275,
            -- 60+
        },
        [3252] = {                                                      -- Enchant Chest - Super Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 8,
            ["ITEM_MOD_INTELLECT_SHORT"] = 8,
            ["ITEM_MOD_SPIRIT_SHORT"] = 8,
            ["ITEM_MOD_STAMINA_SHORT"] = 8,
            ["ITEM_MOD_STRENGTH_SHORT"] = 8,
            -- 60+
        },
        
        -- level 82
        [3245] = {                                                      -- Enchant Chest - Exceptional Resilience
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 20,
            -- 60+
        },
        
        --level 80
        [1953] = {                                                      -- Enchant Chest - Greater Defense
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 22,
            -- 60+
        },
        
        -- level 79
        [3236] = {                                                      -- Enchant Chest - Mighty Health
            ["ITEM_MOD_HEALTH_SHORT"] = 200,
            -- 60+
        },
        [3832] = {                                                      -- Enchant Chest - Powerful Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 10,
            ["ITEM_MOD_INTELLECT_SHORT"] = 10,
            ["ITEM_MOD_SPIRIT_SHORT"] = 10,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_STRENGTH_SHORT"] = 10,
            -- 60+
        },
        
        -- level 75
        [2381] = {                                                      -- Enchant Chest - Greater Mana Restoration
            ["ITEM_MOD_SPIRIT_SHORT"] = 20, -- again, twice the amount of mp5
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 10,
            -- 60+
        },
        
        -- level 72
        [1951] = {                                                      -- Enchant Chest - Defense
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 16,
            -- 35+
        },
        
        -- level 71
        [3233] = {                                                      -- Enchant Chest - Exceptional Mana
            ["ITEM_MOD_MANA_SHORT"] = 250,
            -- 60+
        },
        
        [2661] = {                                                      -- Enchant Chest - Exceptional Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 6,
            ["ITEM_MOD_INTELLECT_SHORT"] = 6,
            ["ITEM_MOD_SPIRIT_SHORT"] = 6,
            ["ITEM_MOD_STAMINA_SHORT"] = 6,
            ["ITEM_MOD_STRENGTH_SHORT"] = 6,
            -- 35+
        },
        -- level 69
        [2933] = {                                                      -- Enchant Chest - Major Resilience
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 15,
            -- 35+
        },
        
        -- level 64
        [1144] = {                                                      -- Enchant Chest - Major Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 15,
        },
        
        -- level 63
        [2659] = {                                                      -- Enchant Chest - Exceptional Health
            ["ITEM_MOD_HEALTH_SHORT"] = 150,
            -- 35+
        },
        
        -- level 62
        [1891] = {                                                      -- Enchant Chest - Greater Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 4,
            ["ITEM_MOD_INTELLECT_SHORT"] = 4,
            ["ITEM_MOD_SPIRIT_SHORT"] = 4,
            ["ITEM_MOD_STAMINA_SHORT"] = 4,
            ["ITEM_MOD_STRENGTH_SHORT"] = 4,
        },
        
        -- level 60
        [3150] = {                                                      -- Enchant Chest - Restore Mana Prime
            ["ITEM_MOD_SPIRIT_SHORT"] = 14, -- double the amount of mp5
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 7,
            -- 35+
        },
        
        -- level 58
        [1893] = {                                                      -- Enchant Chest - Major Mana
            ["ITEM_MOD_MANA_SHORT"] = 100,
        },
        
        -- level 55
        [1892] = {                                                      -- Enchant Chest - Major Health
            ["ITEM_MOD_HEALTH_SHORT"] = 100,
        },
        
        -- level 49
        [928] = {                                                       -- Enchant Chest - Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 3,
            ["ITEM_MOD_INTELLECT_SHORT"] = 3,
            ["ITEM_MOD_SPIRIT_SHORT"] = 3,
            ["ITEM_MOD_STAMINA_SHORT"] = 3,
            ["ITEM_MOD_STRENGTH_SHORT"] = 3,
        },
        
        -- level 46
        [913] = {                                                       -- Enchant Chest - Superior Mana
            ["ITEM_MOD_MANA_SHORT"] = 65,
        },
        
        -- level 44
        [908] = {                                                       -- Enchant Chest - Superior Health
            ["ITEM_MOD_HEALTH_SHORT"] = 50,
        },
        
        -- level 40
        [866] = {                                                       -- Enchant Chest - Lesser Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 2,
            ["ITEM_MOD_INTELLECT_SHORT"] = 2,
            ["ITEM_MOD_SPIRIT_SHORT"] = 2,
            ["ITEM_MOD_STAMINA_SHORT"] = 2,
            ["ITEM_MOD_STRENGTH_SHORT"] = 2,
        },
        
        -- level 37
        [857] = {                                                       -- Enchant Chest - Greater Mana
            ["ITEM_MOD_MANA_SHORT"] = 50,
        },
        
        -- level 32
        [850] = {                                                       -- Enchant Chest - Greater Health
            ["ITEM_MOD_HEALTH_SHORT"] = 35,
        },
        
        -- level 30
        [847] = {                                                       -- Enchant Chest - Minor Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 1,
            ["ITEM_MOD_INTELLECT_SHORT"] = 1,
            ["ITEM_MOD_SPIRIT_SHORT"] = 1,
            ["ITEM_MOD_STAMINA_SHORT"] = 1,
            ["ITEM_MOD_STRENGTH_SHORT"] = 1,
        },
        
        -- level 29
        [843] = {                                                       -- Enchant Chest - Mana
            ["ITEM_MOD_MANA_SHORT"] = 30,
        },
        
        -- level 28
        [63] = {                                                        -- Enchant Chest - Lesser Absorption
            -- Enchant a piece of chest armor so it has a 5% chance per hit of giving you 25 points of damage absorption.
        },
        
        -- level 24
        [254] = {                                                       -- Enchant Chest - Health
            ["ITEM_MOD_HEALTH_SHORT"] = 25,
        },
        
        -- level 19
        [246] = {                                                       -- Enchant Chest - Lesser Mana
            ["ITEM_MOD_MANA_SHORT"] = 20,
        },
        
        -- level 17
        [242] = {                                                       -- Enchant Chest - Lesser Health
            ["ITEM_MOD_HEALTH_SHORT"] = 15,
        },
        
        -- level 14
        [44] = {                                                        -- Enchant Chest - Minor Absorption
            -- Enchant a piece of chest armor so it has a 2% chance per hit of giving you 10 points of damage absorption
        },
        
        -- level 12
        [24] = {                                                        -- Enchant Chest - Minor Mana
            ["ITEM_MOD_MANA_SHORT"] = 5,
        },
        
        -- level 10
        [41] = {                                                        -- Enchant Chest - Minor Health
            ["ITEM_MOD_HEALTH_SHORT"] = 5,
        },
    },
    
    -- Waist
    [6] = {
        [3729] = {                                                      -- Eternal Belt Buckle
            -- adds a prismatic socket
        },
        [3599] = {                                                      -- Personal Electromagnetic Pulse Generator
            -- Use: Confuse nearby mechanical units
            -- engineering 390
        },
        [3601] = {                                                      -- Frag Belt
            -- Attach a miniaturized explosive assembly to your belt, allowing you to detach and throw a Cobalt Frag Bomb every 6 minutes.
            -- engineering 380
        },
    },
    
    -- Wrist
    [9] = {
        -- level 80 leatherworking
        [3763] = {                                                      -- Fur Lining - Arcane Resist
            ["RESISTANCE6_NAME"] = 70,
            -- leatherworking 400
        },
        [3759] = {                                                      -- Fur Lining - Fire Resist
            ["RESISTANCE2_NAME"] = 70,
            -- leatherworking 400
        },
        [3760] = {                                                      -- Fur Lining - Frost Resist
            ["RESISTANCE4_NAME"] = 70,
            -- leatherworking 400
        },
        [3762] = {                                                      -- Fur Lining - Nature Resist
            ["RESISTANCE3_NAME"] = 70,
            -- leatherworking 400
        },
        [3761] = {                                                      -- Fur Lining - Shadow Resist
            ["RESISTANCE5_NAME"] = 70,
            -- leatherworking 400
        },
        
        [3756] = {                                                      -- Fur Lining - Attack Power
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 130,
            -- leatherworking 400
        },
        [3758] = {                                                      -- Fur Lining - Spell Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 76,
            -- leatherworking 400
        },
        [3757] = {                                                      -- Fur Lining - Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 102,
        },
        
        -- blacksmithing
        [3717] = {                                                      -- Socket Bracer
            -- adds a prismatic socket to your bracers
            -- 60+
            -- blacksmithing 400
        },
        
        -- enchanting
        -- cataclysm
        [4101] = {                                                      -- Enchant Bracer - Greater Critical Strike
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 65,
            -- iLvl 300+
        },
        [4108] = {                                                      -- Enchant Bracer - Greater Speed
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 65,
            -- iLvl 300+
        },
        [4095] = {                                                      -- Enchant Bracer - Greater Expertise
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4093] = {                                                      -- Enchant Bracer - Exceptional Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 50,
            -- iLvl 300+
        },
        [4089] = {                                                      -- Enchant Bracer - Precision
            ["ITEM_MOD_HIT_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4086] = {                                                      -- Enchant Bracer - Dodge
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4071] = {                                                      -- Enchant Bracer - Critical Strike
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        
        -- level 85
        [2326] = {                                                      -- Enchant Bracers - Greater Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 23,
            -- 60+
        },
        
        -- level 84
        [3231] = {                                                      -- Enchant Bracers - Expertise
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 15,
            -- 60+
        },
        
        -- level 80
        [3850] = {                                                      -- Enchant Bracers - Major Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 40,
            -- 60+
        },
        [2661] = {                                                       -- Enchant Bracers - Greater Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 6,
            ["ITEM_MOD_INTELLECT_SHORT"] = 6,
            ["ITEM_MOD_SPIRIT_SHORT"] = 6,
            ["ITEM_MOD_STAMINA_SHORT"] = 6,
            ["ITEM_MOD_STRENGTH_SHORT"] = 6,
            -- 60+
        },
        [1147] = {                                                      -- Enchant Bracers - Major Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 18,
            -- 60+
        },
        
        -- level 75
        [1119] = {                                                      -- Enchant Bracers - Exceptional Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 16,
            -- 60+
        },
        
        -- level 72
        [2650] = {                                                      -- Enchant Bracers - Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 15,
            -- 60+
        },
        
        -- level 71
        [2332] = {                                                      -- Enchant Bracers - Superior Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 30,
            -- 60+
        },
        [3845] = {                                                      -- Enchant Bracers - Greater Assault
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50,
            -- 60+
        },
        [1600] = {                                                      -- Enchant Bracers - Striking
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 38,
            -- 60+
        },
        
        -- level 70
        [2649] = {                                                      -- Enchant Bracers - Fortitude
            ["ITEM_MOD_STAMINA_SHORT"] = 12,
            -- 35+
        },
        
        -- level 67
        [2679] = {                                                      -- Enchant Bracers - Restore Mana Prime
            ["ITEM_MOD_SPIRIT_SHORT"] = 16, -- double mp5, as always
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 8,
            -- 35+
        },
        
        -- level 65
        [2650] = {                                                      -- Enchant Bracers - Superior Healing / Healing Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 15,
            -- 35+
        },
        
        -- level 64
        [2648] = {                                                      -- Enchant Bracers - Major Defense
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 12,
            -- 35+
        },
        
        -- level 63
        [1891] = {                                                       -- Enchant Bracers - Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 4,
            ["ITEM_MOD_INTELLECT_SHORT"] = 4,
            ["ITEM_MOD_SPIRIT_SHORT"] = 4,
            ["ITEM_MOD_STAMINA_SHORT"] = 4,
            ["ITEM_MOD_STRENGTH_SHORT"] = 4,
            -- 35+
        },
        
        -- level 61
        [2647] = {                                                      -- Enchant Bracers - Brawn
            ["ITEM_MOD_STRENGTH_SHORT"] = 12,
            -- 35+
        },
        [369] = {                                                      -- Enchant Bracers - Major Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 12,
            -- 35+
        },
        
        -- level 60
        [1593] = {                                                      -- Enchant Bracers - Assault
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 24,
            -- 35+
        },
        [1886] = {                                                      -- Enchant Bracers - Superior Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 9,
        },
        
        -- level 59
        [1885] = {                                                      -- Enchant Bracers - Superior Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 9,
        },
        
        -- level 58
        [2565] = {                                                      -- Enchant Bracers - Mana Regeneration
            ["ITEM_MOD_SPIRIT_SHORT"] = 10, -- again, doubled mp5
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 5,
        },
        
        -- level 54
        [1884] = {                                                      -- Enchant Bracers - Superior Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 9,
        },
        
        -- level 51
        [1883] = {                                                      -- Enchant Bracers - Greater Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 7,
        },
        
        -- level 49
        [929] = {                                                      -- Enchant Bracers - Greater Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 7,
        },
        
        -- level 48
        [927] = {                                                      -- Enchant Bracers - Greater Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 7,
        },
        
        -- level 47
        [923] = {                                                      -- Enchant Bracers - Deflection
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 5,
        },
        
        -- level 44
        [907] = {                                                      -- Enchant Bracers - GreaterSpirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 7,
        },
        
        -- level 42
        [905] = {                                                      -- Enchant Bracers - Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 5,
        },
        
        -- level 36
        [856] = {                                                      -- Enchant Bracers - Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 5,
        },
        
        -- level 34
        [925] = {                                                      -- Enchant Bracers - Lesser Deflection
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 3,
        },
        [852] = {                                                      -- Enchant Bracers - Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 5,
        },
        
        -- level 33
        [851] = {                                                      -- Enchant Bracers - Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 5,
        },
        
        -- level 30
        [723] = {                                                      -- Enchant Bracers - Lesser Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 3,
        },
        
        -- level 28
        [823] = {                                                      -- Enchant Bracers - Lesser Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 3,
        },
        
        -- level 26
        [724] = {                                                      -- Enchant Bracers - Lesser Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 3,
        },
        
        -- level 24
        [255] = {                                                      -- Enchant Bracers - Lesser Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 3,
        },
        
        -- level 19
        [247] = {                                                      -- Enchant Bracers - Minor Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 1,
        },
        [248] = {                                                      -- Enchant Bracers - Minor Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 1,
        },
        
        -- level 17
        [243] = {                                                      -- Enchant Bracers - Minor Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 1,
        },
        
        -- level 16
        [66] = {                                                      -- Enchant Bracers - Minor Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 1,
        },
        
        -- level 12
        [924] = {                                                      -- Enchant Bracers - Minor Deflection
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 2,
        },
        
        -- level 1
        [41] = {                                                      -- Enchant Bracers - Minor Health
            ["ITEM_MOD_HEALTH_SHORT"] = 5,
        },
    },
    
    -- Ring #1
    [11] = {
        -- enchanting 475
        [4079] = {                                                      -- Enchant Ring - Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 40,
            -- enchanting 475
        },
        [4081] = {                                                      -- Enchant Ring - Greater Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 60,
            -- enchanting 475
        },
        [4080] = {                                                      -- Enchant Ring - Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 40,
            -- enchanting 475
        },
        [4078] = {                                                      -- Enchant Ring - Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 40,
            -- enchanting 475
        },
        
        -- enchanting 360
        [2928] = {                                                      -- Enchant Ring - Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 12,
            -- enchanting 360
            -- 35+
        },
        [2929] = {                                                      -- Enchant Ring - Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2/WeaponSpeed
            -- enchanting 360
            -- 35+
        },
        
        -- enchanting 370
        [2930] = {                                                      -- Enchant Ring - Healing Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 12,
            -- enchanting 370
            -- 35+
        },
        
        -- enchanting 375
        [2931] = {                                                      -- Enchant Ring - Stats
            ["ITEM_MOD_AGILITY_SHORT"] = 4,
            ["ITEM_MOD_INTELLECT_SHORT"] = 4,
            ["ITEM_MOD_SPIRIT_SHORT"] = 4,
            ["ITEM_MOD_STAMINA_SHORT"] = 4,
            ["ITEM_MOD_STRENGTH_SHORT"] = 4,
            -- 35+
            -- enchanting 375
        },
        
        -- enchanting 400
        [3839] = {                                                      -- Enchant Ring - Assault
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40,
            -- enchanting 400
        },
        [3840] = {                                                      -- Enchant Ring - Greater Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 23,
            -- enchanting 400
        },
        [3791] = {                                                      -- Enchant Ring - Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            -- enchanting 400
        },
        
        -- enchanting 475
        [4079] = {                                                      -- Enchant Ring - Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 40,
            -- enchanting 475
        },
        [4081] = {                                                      -- Enchant Ring - Greater Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 60,
            -- enchanting 475
        },
        [4080] = {                                                      -- Enchant Ring - Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 40,
            -- enchanting 475
        },
        [4078] = {                                                      -- Enchant Ring - Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 40,
            -- enchanting 475
        },
    },
    
    -- Ranged Slot
    [18] = {
        -- level 80 scopes
        [4175] = {                                                      -- Gnomish X-Ray Scope
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 100, -- just a low estimate for 1/8 uptime, unconfirmed
            -- Sometimes increases ranged AP by 800 for 10 sec.
            -- ranged only
        },
        [4176] = {                                                      -- R19 Threatfinder
            ["ITEM_MOD_HIT_RATING_SHORT"] = 88,
            -- ranged only
        },
        [4177] = {                                                      -- Safety Catch Removal Kit
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 88,
            -- ranged only
        },
        [4267] = {                                                      -- Flintlocke's Woodchucker
            ["ITEM_MOD_AGILITY_SHORT"] = 50, -- 300 AGI for 10 sec., ICD of about 40 sec.
            -- ranged only
        },
        
        -- level 70 scopes
        [3608] = {                                                      -- Heartseeker Scope
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 40,
            -- ranged only
        },
        [3607] = {                                                      -- Sun Scope
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 40,
            -- ranged only
        },
        [3843] = {                                                      -- Diamond-cut Refractor Scope
            --["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 15/WeaponSpeed
            -- ranged only
        },
        
        -- level 60 scope
        [2724] = {                                                      -- Stabilized Eternium Scope
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 28,
            -- ranged only
        },
        
        -- level 55 scopes
        [2723] = {                                                      -- Khorium Scope
            --["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 12/WeaponSpeed
            -- ranged only
        },
        [2722] = {                                                      -- Adamantite Scope
            --["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 10/WeaponSpeed
            -- ranged only
        },
        
        -- level 50 scrope
        [2523] = {                                                      -- Biznicks 247x128 Accurascope
            ["ITEM_MOD_HIT_RATING_SHORT"] = 30,
            -- ranged only
        },
        
        -- level 40 scope
        [664] = {                                                       -- Sniper Scope
            --["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7/WeaponSpeed
            -- ranged only
        },
        
        -- level 30 scope
        [663] = {                                                       -- Deadly Scope
            --["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5/WeaponSpeed
            -- ranged only
        },
        
        -- level 20 scope
        [33] = {                                                        -- Accurate Scope
            --["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3/WeaponSpeed
            -- ranged only
        },
        
        -- level 10 scope
        [32] = {                                                        -- Standard Scope
            --["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2/WeaponSpeed
            -- ranged only
        },
        
        -- level 5 scope
        [30] = {                                                        -- Crude Scope
            --["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 1/WeaponSpeed
            -- ranged only
        },
    },
    
    -- Offhand
    [17] = {
        -- Shields
        -- blacksmithing
        [4216] = {                                                      -- Pyrium Shield Spike
            -- deals 210-350 damage sometimes when you block
        },
        [4215] = {                                                      -- Elementium Shield Spike
            -- deals 90-133 damage every time you block
        },
        [3748] = {                                                      -- Titanium Shield Spike
            -- deals 45-67 damage every time you block
        },
        [2714] = {                                                      -- Felsteel Shield Spike
            -- deals 26-38 damage every time you block
        },
        [1704] = {                                                      -- Thorium Shield Spike
            -- deals 20-30 damage every time you block
        },
        [463] = {                                                       -- Mithril Shield Spike
            -- deals 16-20 damage every time you block
        },
        [43] = {                                                        -- Iron Shield Spike
            -- deals 8-12 damage every time you block
        },
        [3849] = {                                                      -- Titanium Plating
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 26,
            -- disarm duration -50%
        },
        
        -- enchanting
        -- cataclysm
        [4091] = {                                                      -- Enchant Off-Hand - Superior Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 40,
            -- iLvl 300+
        },
        [4085] = {                                                      -- Enchant Shield - Blocking
            ["ITEM_MOD_BLOCK_RATING_SHORT"] = 40,
            -- iLvl 300+
        },
        [4073] = {                                                      -- Enchant Shield - Protection
            ["RESISTANCE0_NAME"] = 160,
            -- iLvl 300+
        },
        
        -- level 75
        [1128] = {                                                      -- Enchant Shield - Greater Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 25,
            -- 60+
        },
        
        -- level 72
        [1888] = {                                                      -- Enchant Shield - Resistance
            ["RESISTANCE1_NAME"] = 5,
            ["RESISTANCE2_NAME"] = 5,
            ["RESISTANCE3_NAME"] = 5,
            ["RESISTANCE4_NAME"] = 5,
            ["RESISTANCE5_NAME"] = 5,
            ["RESISTANCE6_NAME"] = 5,
            -- 35+
        },
        
        -- level 71
        [1952] = {                                                      -- Enchant Shield - Defense
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 20,
            -- 60+
        },
        
        -- level 68
        [2655] = {                                                      -- Enchant Shield - Shield Block
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 15,
            -- 35+
        },
        
        -- level 66
        [3229] = {                                                      -- Enchant Shield - Resilience
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 12,
            -- 35+
        },
        
        -- level 65
        [2654] = {                                                      -- Enchant Shield - Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 12,
            -- 35+
        },
        [1071] = {                                                      -- Enchant Shield - Major Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 18,
        },
        
        -- level 62
        [2653] = {                                                      -- Enchant Shield - Tough Shield
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 36,
            -- 35+
        },
        
        -- level 56
        [1890] = {                                                      -- Enchant Shield - Vitality
            ["ITEM_MOD_SPIRIT_SHORT"] = 8, -- again, replaces double the mp5
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 4,
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 4,
        },
        
        -- level 53
        [929] = {                                                       -- Enchant Shield - Greater Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 7,
        },
        
        -- level 47
        [926] = {                                                       -- Enchant Shield - Frost Resistance
            ["RESISTANCE4_NAME"] = 8,
        },
        
        -- level 46
        [907] = {                                                       -- Enchant Shield - Greater Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 7,
        },
        
        -- level 42
        [852] = {                                                       -- Enchant Shield - Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 5,
        },
        
        -- level 39
        [863] = {                                                       -- Enchant Shield - Lesser Block
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 10,
        },
        
        -- level 36
        [851] = {                                                       -- Enchant Shield - Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 5,
        },
        
        -- level 31
        [724] = {                                                       -- Enchant Shield - Lesser Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 3,
        },
        
        -- level 26
        [255] = {                                                       -- Enchant Shield - Lesser Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 3,
        },
        
        -- level 23
        [848] = {                                                       -- Enchant Shield - Lesser Protection
            ["RESISTANCE0_NAME"] = 30,
        },
        
        -- level 21
        [66] = {                                                        -- Enchant Shield - Minor Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 1,
        },
        
        -- One-Hand
        -- DK runesforging
        -- level 72
        [3883] = {                                                      -- Rune of the Nerubian Carapace
            -- +2% armo
            -- +1% stamina
            -- runeforging
        },
        
        -- level 70
        [3368] = {                                                      -- Rune of the Fallen Crusader
            -- proc: 3% maxhp heal
            -- strength + 15%
            -- runeforging
        },
        
        -- level 63
        [3594] = {                                                      -- Rune of Swordbreaking
            -- parry +2%
            -- disarm duration -50%
            -- runeforging
        },
        
        -- level 60
        [3366] = {                                                      -- Rune of Lichbane
            -- 2% extra weapon damage as Fire damage or 4% versus Undead targets
            -- runeforging
        },
        
        -- level 57
        [3595] = {                                                      -- Rune of Spellbreaking
            -- spell damage: deflect 2%
            -- silence duration -50%
            -- runeforging
        },
        
        -- level 55
        [3369] = {                                                      -- Rune of Cinderglacier
            -- chance to increase the damage by 20% for your next 2 attacks that deal Frost or Shadow damage
            -- runeforging
        },
        [3370] = {                                                      -- Rune of Razorice
            --  2% extra weapon damage as Frost damage and has a chance to increase vulnerability to your Frost attacks
            -- runeforging
        },
        
        -- blacksmithing
        [4217] = {                                                      -- Pyrium Weapon Chain
            ["ITEM_MOD_HIT_RATING_SHORT"] = 40,
            -- disarm duration -50%
        },
        [3731] = {                                                      -- Titanium Weapon Chain
            ["ITEM_MOD_HIT_RATING_SHORT"] = 28,
            -- disarm duration -50%
        },
        [3223] = {                                                      -- Adamantite Weapon Chain
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 15,
            -- disarm duration -50%
        },
        [37] = {                                                        -- Steel Weapon Chain
            -- disarm duration -50%
        },
        
        -- enchanting
        -- cataclysm
        [4099] = {                                                      -- Enchant Weapon - Landslide
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 200, -- (assuming 60 sec. internal CD)
            -- sometimes increases AP by 1000 for 12 sec
            -- iLvl 300+
        },
        [4097] = {                                                      -- Enchant Weapon - Power Torrent
            ["ITEM_MOD_INTELLECT_SHORT"] = 100, -- (assuming 60 sec. internal CD)
            -- sometimes increases Intellect by 500 for 12 sec
            -- iLvl 300+
        },
        [4098] = {                                                      -- Enchant Weapon - Windwalk
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 100, -- (assuming 60 sec. internal CD)
            -- sometimes increases dodge rating by 600 for 10 sec
            -- and 15% movement speed
            -- iLvl 300+
        },
        [4084] = {                                                      -- Enchant Weapon - Heartsong
            ["ITEM_MOD_SPIRIT_SHORT"] = 50, -- (assuming 60 sec. internal CD)
            -- sometimes increases spirit by 200 for 15 sec
            -- iLvl 300+
        },
        [4083] = {                                                      -- Enchant Weapon - Hurricane
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 90, -- (assuming 60 sec. internal CD)
            -- sometimes increases spirit by 450 for 12 sec
            -- iLvl 300+
        },
        [4074] = {                                                      -- Enchant Weapon - Elemental Slayer
            -- sometimes disrupt elementals when struck by your melee attacks, dealing Arcane damage and silencing them for 5 sec.
            -- iLvl 300+
        },
        [4067] = {                                                      -- Enchant Weapon - Avalanche
            -- often deals 463 to 537 Nature damage to an enemy struck by your melee attacks (~5 procs per minute)
            -- iLvl 300+
        },
        [4066] = {                                                      -- Enchant Weapon - Mending
            -- sometimes heals you when damaging an enemy with spells and melee attacks
            -- iLvl 300+
        },
        
        -- level 85
        [3790] = {                                                      -- Enchant Weapon - Black Magic
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 25, -- conservative 10% uptime (unconfirmed)
            -- sometimes increases haste rating by 250
            -- 60+
        },
        [3830] = {                                                      -- Enchant Weapon - Exceptional Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 50,
            -- 60+
        },
        [3241] = {                                                      -- Enchant Weapon - Lifeward
            -- hps depends too much on your weapon / attacks :( TODO
            -- 60+
        },
        [3834] = {                                                      -- Enchant Weapon - Mighty Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 63,
            -- 60+
        },
        
        -- level 84
        [1103] = {                                                      -- Enchant Weapon - Exceptional Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 26,
            -- 60+
        },
        [3239] = {                                                      -- Enchant Weapon - Icebreaker
            -- sometimes inflicts fire damage
            -- 60+
        },
        
        -- level 82
        [3251] = {                                                      -- Enchant Weapon - Giant Slayer
            -- chance of reducing movement speed and doing additional damage against giants
            -- 60+
        },
        
        -- level 80
        [3869] = {                                                      -- Enchant Weapon - Blade Ward
            -- sometimes gives you 200 parry rating and 600-800 damage on your next parry
            -- wielder must be 75+
        },
        [3870] = {                                                      -- Enchant Weapon - Blood Draining
            -- sometimes gives you a stack of blood reserve on hit or doing damage with bleed attacks
            -- up to 5 stacks, when you fall under 33% health, restores 360 to 440 health per stack
            -- wielder must be 75+
        },
        [3844] = {                                                      -- Enchant Weapon - Exceptional Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 45,
            -- 60+
        },
        
        -- level 79
        [3789] = {                                                      -- Enchant Weapon - Berserking
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 100,
            ["RESISTANCE0_NAME"] = -150,    -- TODO: actually, it's -5%
            -- sometimes gives 400 AP and reduced armor
            -- 60+
        },
        [3833] = {                                                      -- Enchant Weapon - Superior Potency
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 65,
            -- 60+
        },
        
        -- level 75
        [3225] = {                                                      -- Enchant Weapon - Executioner
            -- sometimes grants 120 crit rating
            -- 60+
        },
        [2673] = {                                                      -- Enchant Weapon - Mongoose
            -- sometimes 120 agility and some attack speed
            -- 35+
        },
        [2672] = {                                                      -- Enchant Weapon - Soulfrost
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 54,
            -- actually it's only shadow and frost spell power
            -- 35+
        },
        [2671] = {                                                      -- Enchant Weapon - Sunfire
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 50,
            -- only fire and arcane
            -- 35+
        },
        
        -- level 73
        [3788] = {                                                      -- Enchant Weapon - Accuracy
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 25,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 25,
            -- 60+
        },
        [3273] = {                                                      -- Enchant Weapon - Deathfrost
            --  cause your damaging spells and melee weapon hits to occasionally inflict additional Frost damage and slow the target
            -- 60+
        },
        
        -- level 72
        [2675] = {                                                      -- Enchant Weapon - Battlemaster
            -- melee attack occasionally heals nearby party by 180 to 300
            -- 35+
        },
        [2674] = {                                                      -- Enchant Weapon - Spellsurge
            -- spells occasionally grant 100 mana to nearby party members
            -- 35+
        },
        
        -- level 71
        [1606] = {                                                      -- Enchant Weapon - Greater Potency
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50,
            -- 60+
        },
        
        -- level 70
        [3222] = {                                                      -- Enchant Weapon - Greater Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 20,
            -- 35+
        },
        [3846] = {                                                      -- Enchant Weapon - Major Healing
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 40,
            -- 35+
        },
        [2669] = {                                                      -- Enchant Weapon - Major Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 40,
            -- 35+
        },
        [2568] = {                                                      -- Enchant Weapon - Mighty Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 22,
        },
        [2668] = {                                                      -- Enchant Weapon - Potency
            ["ITEM_MOD_STRENGTH_SHORT"] = 20,
            -- 35+
        },
        
        -- level 68
        [2666] = {                                                      -- Enchant Weapon - Major Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 30,
            -- 35+
        },
        [963] = {                                                       -- Enchant Weapon - Major Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7/WeaponSpeed
            -- 35+
        },
        
        -- level 66
        [2567] = {                                                      -- Enchant Weapon - Mighty Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 20,
        },
        
        -- level 62
        [1898] = {                                                      -- Enchant Weapon - Lifestealing
            -- often steal life from the enemy and give it to the wielder
            -- reduced effect for players above level 60
        },
        
        -- level 61
        [1900] = {                                                      -- Enchant Weapon - Crusader
            -- heal for 75 to 125 and increase Strength by 100 for 15 sec. when attacking in melee
            -- reduced effect for players above level 60
        },
        
        -- level 60
        [2505] = {                                                      -- Enchant Weapon - Healing Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 29,
        },
        [2504] = {                                                      -- Enchant Weapon - Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 30,
        },
        [1897] = {                                                      -- Enchant Weapon - Superior Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5/WeaponSpeed
        },
        
        -- level 59
        [1899] = {                                                      -- Enchant Weapon - Unholy Weapon
            -- often inflict a curse on the target, inflicting shadow damage and reducing their melee damage
        },
        
        -- level 58
        [2564] = {                                                      -- Enchant Weapon - Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 15,
        },
        [2563] = {                                                      -- Enchant Weapon - Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 15,
        },
        
        -- level 57
        [1894] = {                                                      -- Enchant Weapon - Icy Chill
            -- often chill the target, reducing their movement and attack speed
            -- reduced effect for players above level 60
        },
        
        -- level 53
        [803] = {                                                       -- Enchant Weapon - Fiery Weapon
            -- often strikes for 40 additional fire damage
        },
        
        -- level 49
        [805] = {                                                       -- Enchant Weapon - Greater Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 4/WeaponSpeed
        },
        
        -- level 46
        [912] = {                                                       -- Enchant Weapon - Demonslaying
            -- chance of stunning and doing additional damage against demons
            -- and a nice red glow
        },
        
        -- level 39
        [943] = {                                                       -- Enchant Weapon - Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3/WeaponSpeed
        },
        
        -- level 38
        [2443] = {                                                      -- Enchant Weapon - Winter's Might
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 7,
            -- frost only
        },
        
        -- level 35
        [853] = {                                                       -- Enchant Weapon - Lesser Beastslayer
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 6/WeaponSpeed against beasts
        },
        [854] = {                                                       -- Enchant Weapon - Lesser Elemental Slayer
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 6/WeaponSpeed against elementals
        },
        
        -- level 28
        [241] = {                                                       -- Enchant Weapon - Lesser Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2/WeaponSpeed
        },
        
        -- level 20
        [249] = {                                                       -- Enchant Weapon - Minor Beastslayer
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2/WeaponSpeed against beasts
        },
        [250] = {                                                       -- Enchant Weapon - Minor Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 1/WeaponSpeed
        },
        
        -- from badlands
        [36] = {                                                        -- Fiery Blaze Enchantment
            -- 15% chance to inflict 9 to 13 Fire damage to all enemies within 3 yards
        },
        
        -- Two-Hand enchantments as below, minus staves (for titan's grip warriors)
        -- cataclysm
        [4227] = {                                                      -- Enchant 2H Weapon - Mighty Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 130,
            -- iLvl 300+
        },
        
        -- level 82
        [3828] = {                                                      -- Enchant 2H Weapon - Greater Savagery
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 85,
            -- 60+
        },
        
        -- level 80
        [3247] = {                                                      -- Enchant 2H Weapon - Scourgebane
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 140 --against undead
            -- 60+
        },
        
        -- level 79
        [3827] = {                                                      -- Enchant 2H Weapon - Massacre
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 110,
            -- 60+
        },
        
        -- level 72
        [2670] = {                                                      -- Enchant 2H Weapon - Major Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 35,
            -- 35+
        },
        
        -- level 70
        [2667] = {                                                      -- Enchant 2H Weapon - Savagery
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 70,
            -- 35+
        },
        
        -- level 62
        [1903] = {                                                      -- Enchant 2H Weapon - Major Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 9,
        },
        
        -- level 60
        [1904] = {                                                      -- Enchant 2H Weapon - Major Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 9,
        },
        
        -- level 59
        [1896] = {                                                      -- Enchant 2H Weapon - Superior Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 9/WeaponSpeed,
        },
        
        -- level 58
        [2646] = {                                                      -- Enchant 2H Weapon - Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 25,
        },
        
        -- level 48
        [963] = {                                                       -- Enchant 2H Weapon - Greater Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7/WeaponSpeed,
        },
        
        -- level 40
        [1897] = {                                                      -- Enchant 2H Weapon - Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5/WeaponSpeed,
        },
        
        -- level 29
        [943] = {                                                       -- Enchant 2H Weapon - Lesser Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3/WeaponSpeed,
        },
        
        -- level 22
        [255] = {                                                       -- Enchant 2H Weapon - Lesser Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 3,
        },
        
        -- level 20
        [723] = {                                                       -- Enchant 2H Weapon - Lesser Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 3,
        },
        [241] = {                                                       -- Enchant 2H Weapon - Minor Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2/WeaponSpeed,
        },
    },
    
    -- Main Hand
    [16] = {
        -- one-handed enchants copied from above!
        -- DK runesforging
        -- level 72
        [3883] = {                                                      -- Rune of the Nerubian Carapace
            -- +2% armo
            -- +1% stamina
            -- runeforging
        },
        
        -- level 70
        [3368] = {                                                      -- Rune of the Fallen Crusader
            -- proc: 3% maxhp heal
            -- strength + 15%
            -- runeforging
        },
        
        -- level 63
        [3594] = {                                                      -- Rune of Swordbreaking
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 2*45.25018692,
            -- parry +2% [~90]
            -- disarm duration -50%
            -- runeforging
        },
        
        -- level 60
        [3366] = {                                                      -- Rune of Lichbane
            -- 2% extra weapon damage as Fire damage or 4% versus Undead targets
            -- runeforging
        },
        
        -- level 57
        [3595] = {                                                      -- Rune of Spellbreaking
            -- spell damage: deflect 2%
            -- silence duration -50%
            -- runeforging
        },
        
        -- level 55
        [3369] = {                                                      -- Rune of Cinderglacier
            -- chance to increase the damage by 20% for your next 2 attacks that deal Frost or Shadow damage
            -- runeforging
        },
        [3370] = {                                                      -- Rune of Razorice
            --  2% extra weapon damage as Frost damage and has a chance to increase vulnerability to your Frost attacks
            -- runeforging
        },
        
        -- blacksmithing
        [4217] = {                                                      -- Pyrium Weapon Chain
            ["ITEM_MOD_HIT_RATING_SHORT"] = 40,
            -- disarm duration -50%
        },
        [3731] = {                                                      -- Titanium Weapon Chain
            ["ITEM_MOD_HIT_RATING_SHORT"] = 28,
            -- disarm duration -50%
        },
        [3223] = {                                                      -- Adamantite Weapon Chain
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 15,
            -- disarm duration -50%
        },
        [37] = {                                                        -- Steel Weapon Chain
            -- disarm duration -50%
        },
        
        -- enchanting
        -- cataclysm
        [4099] = {                                                      -- Enchant Weapon - Landslide
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 200, -- (assuming 60 sec. internal CD)
            -- sometimes increases AP by 1000 for 12 sec
            -- iLvl 300+
        },
        [4097] = {                                                      -- Enchant Weapon - Power Torrent
            ["ITEM_MOD_INTELLECT_SHORT"] = 100, -- (assuming 60 sec. internal CD)
            -- sometimes increases Intellect by 500 for 12 sec
            -- iLvl 300+
        },
        [4098] = {                                                      -- Enchant Weapon - Windwalk
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 100, -- (assuming 60 sec. internal CD)
            -- sometimes increases dodge rating by 600 for 10 sec
            -- and 15% movement speed
            -- iLvl 300+
        },
        [4084] = {                                                      -- Enchant Weapon - Heartsong
            ["ITEM_MOD_SPIRIT_SHORT"] = 50, -- (assuming 60 sec. internal CD)
            -- sometimes increases spirit by 200 for 15 sec
            -- iLvl 300+
        },
        [4083] = {                                                      -- Enchant Weapon - Hurricane
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 90, -- (assuming 60 sec. internal CD)
            -- sometimes increases spirit by 450 for 12 sec
            -- iLvl 300+
        },
        [4074] = {                                                      -- Enchant Weapon - Elemental Slayer
            -- sometimes disrupt elementals when struck by your melee attacks, dealing Arcane damage and silencing them for 5 sec.
            -- iLvl 300+
        },
        [4067] = {                                                      -- Enchant Weapon - Avalanche
            -- often deals 463 to 537 Nature damage to an enemy struck by your melee attacks (~5 procs per minute)
            -- iLvl 300+
        },
        [4066] = {                                                      -- Enchant Weapon - Mending
            -- sometimes heals you when damaging an enemy with spells and melee attacks
            -- iLvl 300+
        },
        
        -- level 85
        [3790] = {                                                      -- Enchant Weapon - Black Magic
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 25, -- conservative 10% uptime (unconfirmed)
            -- sometimes increases haste rating by 250
            -- 60+
        },
        [3830] = {                                                      -- Enchant Weapon - Exceptional Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 50,
            -- 60+
        },
        [3241] = {                                                      -- Enchant Weapon - Lifeward
            -- hps depends too much on your weapon / attacks :( TODO
            -- 60+
        },
        [3834] = {                                                      -- Enchant Weapon - Mighty Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 63,
            -- 60+
        },
        
        -- level 84
        [1103] = {                                                      -- Enchant Weapon - Exceptional Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 26,
            -- 60+
        },
        [3239] = {                                                      -- Enchant Weapon - Icebreaker
            -- sometimes inflicts fire damage
            -- 60+
        },
        
        -- level 82
        [3251] = {                                                      -- Enchant Weapon - Giant Slayer
            -- chance of reducing movement speed and doing additional damage against giants
            -- 60+
        },
        
        -- level 80
        [3869] = {                                                      -- Enchant Weapon - Blade Ward
            -- sometimes gives you 200 parry rating and 600-800 damage on your next parry
            -- wielder must be 75+
        },
        [3870] = {                                                      -- Enchant Weapon - Blood Draining
            -- sometimes gives you a stack of blood reserve on hit or doing damage with bleed attacks
            -- up to 5 stacks, when you fall under 33% health, restores 360 to 440 health per stack
            -- wielder must be 75+
        },
        [3844] = {                                                      -- Enchant Weapon - Exceptional Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 45,
            -- 60+
        },
        
        -- level 79
        [3789] = {                                                      -- Enchant Weapon - Berserking
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 100,
            ["RESISTANCE0_NAME"] = -150,    -- TODO: actually, it's -5%
            -- sometimes gives 400 AP and reduced armor
            -- 60+
        },
        [3833] = {                                                      -- Enchant Weapon - Superior Potency
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 65,
            -- 60+
        },
        
        -- level 75
        [3225] = {                                                      -- Enchant Weapon - Executioner
            -- sometimes grants 120 crit rating
            -- 60+
        },
        [2673] = {                                                      -- Enchant Weapon - Mongoose
            -- sometimes 120 agility and some attack speed
            -- 35+
        },
        [2672] = {                                                      -- Enchant Weapon - Soulfrost
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 54,
            -- actually it's only shadow and frost spell power
            -- 35+
        },
        [2671] = {                                                      -- Enchant Weapon - Sunfire
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 50,
            -- only fire and arcane
            -- 35+
        },
        
        -- level 73
        [3788] = {                                                      -- Enchant Weapon - Accuracy
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 25,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 25,
            -- 60+
        },
        [3273] = {                                                      -- Enchant Weapon - Deathfrost
            --  cause your damaging spells and melee weapon hits to occasionally inflict additional Frost damage and slow the target
            -- 60+
        },
        
        -- level 72
        [2675] = {                                                      -- Enchant Weapon - Battlemaster
            -- melee attack occasionally heals nearby party by 180 to 300
            -- 35+
        },
        [2674] = {                                                      -- Enchant Weapon - Spellsurge
            -- spells occasionally grant 100 mana to nearby party members
            -- 35+
        },
        
        -- level 71
        [1606] = {                                                      -- Enchant Weapon - Greater Potency
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50,
            -- 60+
        },
        
        -- level 70
        [3222] = {                                                      -- Enchant Weapon - Greater Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 20,
            -- 35+
        },
        [3846] = {                                                      -- Enchant Weapon - Major Healing
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 40,
            -- 35+
        },
        [2669] = {                                                      -- Enchant Weapon - Major Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 40,
            -- 35+
        },
        [2568] = {                                                      -- Enchant Weapon - Mighty Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 22,
        },
        [2668] = {                                                      -- Enchant Weapon - Potency
            ["ITEM_MOD_STRENGTH_SHORT"] = 20,
            -- 35+
        },
        
        -- level 68
        [2666] = {                                                      -- Enchant Weapon - Major Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 30,
            -- 35+
        },
        [963] = {                                                       -- Enchant Weapon - Major Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7/WeaponSpeed
            -- 35+
        },
        
        -- level 66
        [2567] = {                                                      -- Enchant Weapon - Mighty Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 20,
        },
        
        -- level 62
        [1898] = {                                                      -- Enchant Weapon - Lifestealing
            -- often steal life from the enemy and give it to the wielder
            -- reduced effect for players above level 60
        },
        
        -- level 61
        [1900] = {                                                      -- Enchant Weapon - Crusader
            -- heal for 75 to 125 and increase Strength by 100 for 15 sec. when attacking in melee
            -- reduced effect for players above level 60
        },
        
        -- level 60
        [2505] = {                                                      -- Enchant Weapon - Healing Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 29,
        },
        [2504] = {                                                      -- Enchant Weapon - Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 30,
        },
        [1897] = {                                                      -- Enchant Weapon - Superior Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5/WeaponSpeed
        },
        
        -- level 59
        [1899] = {                                                      -- Enchant Weapon - Unholy Weapon
            -- often inflict a curse on the target, inflicting shadow damage and reducing their melee damage
        },
        
        -- level 58
        [2564] = {                                                      -- Enchant Weapon - Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 15,
        },
        [2563] = {                                                      -- Enchant Weapon - Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 15,
        },
        
        -- level 57
        [1894] = {                                                      -- Enchant Weapon - Icy Chill
            -- often chill the target, reducing their movement and attack speed
            -- reduced effect for players above level 60
        },
        
        -- level 53
        [803] = {                                                       -- Enchant Weapon - Fiery Weapon
            -- often strikes for 40 additional fire damage
        },
        
        -- level 49
        [805] = {                                                       -- Enchant Weapon - Greater Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 4/WeaponSpeed
        },
        
        -- level 46
        [912] = {                                                       -- Enchant Weapon - Demonslaying
            -- chance of stunning and doing additional damage against demons
            -- and a nice red glow
        },
        
        -- level 39
        [943] = {                                                       -- Enchant Weapon - Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3/WeaponSpeed
        },
        
        -- level 38
        [2443] = {                                                      -- Enchant Weapon - Winter's Might
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 7,
            -- frost only
        },
        
        -- level 35
        [853] = {                                                       -- Enchant Weapon - Lesser Beastslayer
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 6/WeaponSpeed against beasts
        },
        [854] = {                                                       -- Enchant Weapon - Lesser Elemental Slayer
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 6/WeaponSpeed against elementals
        },
        
        -- level 28
        [241] = {                                                       -- Enchant Weapon - Lesser Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2/WeaponSpeed
        },
        
        -- level 20
        [249] = {                                                       -- Enchant Weapon - Minor Beastslayer
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2/WeaponSpeed against beasts
        },
        [250] = {                                                       -- Enchant Weapon - Minor Striking
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 1/WeaponSpeed
        },
        
        -- from badlands
        [36] = {                                                        -- Fiery Blaze Enchantment
            -- 15% chance to inflict 9 to 13 Fire damage to all enemies within 3 yards
        },
        
        
        -- Two-Hand
        -- cataclysm
        [4227] = {                                                      -- Enchant 2H Weapon - Mighty Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 130,
            -- iLvl 300+
        },
        
        -- level 85
        [3854] = {                                                      -- Enchant Staff - Greater Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 81,
            -- 60+
        },
        
        -- level 82
        [3828] = {                                                      -- Enchant 2H Weapon - Greater Savagery
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 85,
            -- 60+
        },
        
        -- level 80
        [3247] = {                                                      -- Enchant 2H Weapon - Scourgebane
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 140 --against undead
            -- 60+
        },
        [3855] = {                                                      -- Enchant Staff - Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 69,
            -- 60+
        },
        
        -- level 79
        [3827] = {                                                      -- Enchant 2H Weapon - Massacre
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 110,
            -- 60+
        },
        
        -- level 72
        [2670] = {                                                      -- Enchant 2H Weapon - Major Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 35,
            -- 35+
        },
        
        -- level 70
        [2667] = {                                                      -- Enchant 2H Weapon - Savagery
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 70,
            -- 35+
        },
        
        -- level 62
        [1903] = {                                                      -- Enchant 2H Weapon - Major Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 9,
        },
        
        -- level 60
        [1904] = {                                                      -- Enchant 2H Weapon - Major Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 9,
        },
        
        -- level 59
        [1896] = {                                                      -- Enchant 2H Weapon - Superior Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 9/WeaponSpeed,
        },
        
        -- level 58
        [2646] = {                                                      -- Enchant 2H Weapon - Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 25,
        },
        
        -- level 48
        [963] = {                                                       -- Enchant 2H Weapon - Greater Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 7/WeaponSpeed,
        },
        
        -- level 40
        [1897] = {                                                      -- Enchant 2H Weapon - Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 5/WeaponSpeed,
        },
        
        -- level 29
        [943] = {                                                       -- Enchant 2H Weapon - Lesser Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3/WeaponSpeed,
        },
        
        -- level 22
        [255] = {                                                       -- Enchant 2H Weapon - Lesser Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 3,
        },
        
        -- level 20
        [723] = {                                                       -- Enchant 2H Weapon - Lesser Intellect
            ["ITEM_MOD_INTELLECT_SHORT"] = 3,
        },
        [241] = {                                                       -- Enchant 2H Weapon - Minor Impact
            -- ["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 2/WeaponSpeed,
        },
        
        -- 2H-DK-Runes
        [3367] = {                                                      -- Rune of the Stoneskin Gargoyle
            -- +4% armor
            -- +2% stamina
            -- runeforging
        },
        [3365] = {                                                      -- Rune of Swordshattering
            -- parry +4%
            -- disarm duration -50%
            -- runeforging
        },
        [3367] = {                                                      -- Rune of Spellshattering
            -- spell damage: deflect 4%
            -- silence duration -50%
            -- runeforging
        },
    },
    
    -- Hands
    [10] = {
        -- armor kits
        [4120] = {                                                      -- Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 36,
        },
        [4121] = {                                                      -- Heavy Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 44,
        },
        [3330] = {                                                      -- Heavy Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 18,
            -- 70+
        },
        [3329] = {                                                      -- Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 12,
            -- 70+
        },
        [2841] = {                                                      -- Heavy Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            -- 60+
        },
        [2792] = {                                                      -- Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 8,
            -- 55+
        },
        [1843] = {                                                      -- Rugged Armor Kit
            ["RESISTANCE0_NAME"] = 40,
            -- 35+
        },
        [18] = {                                                        -- Thick Armor Kit
            ["RESISTANCE0_NAME"] = 32,
            -- 25+
        },
        [17] = {                                                        -- Heavy Armor Kit
            ["RESISTANCE0_NAME"] = 24,
            -- 15+
        },
        [16] = {                                                        -- Medium Armor Kit
            ["RESISTANCE0_NAME"] = 16,
        },
        [15] = {                                                        -- Light Armor Kit
            ["RESISTANCE0_NAME"] = 8,
        },
        [2793] = {                                                      -- Vindicator's Armor Kit
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 8,
        },
        [2503] = {                                                      -- Core Armor Kit
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 5,
        },
        [2794] = {                                                      -- Magister's Armor Kit
            ["ITEM_MOD_SPIRIT_SHORT"] = 8,
        },
        [3260] = {                                                      -- Glove Reinforcements
            ["RESISTANCE0_NAME"] = 240,
        },
        [2989] = {                                                      -- Arcane Armor Kit
            ["RESISTANCE6_NAME"] = 8,
        },
        [2985] = {                                                      -- Flame Armor Kit
            ["RESISTANCE2_NAME"] = 8,
        },
        [2987] = {                                                      -- Frost Armor Kit
            ["RESISTANCE4_NAME"] = 8,
        },
        [2988] = {                                                      -- Nature Armor Kit
            ["RESISTANCE3_NAME"] = 8,
        },
        [2984] = {                                                      -- Shadow Armor Kit
            ["RESISTANCE5_NAME"] = 8,
        },
        
        -- enchanting
        -- cataclysm
        [4107] = {                                                      -- Enchant Gloves - Greater Mastery
            ["ITEM_MOD_MASTERY_RATING_SHORT"] = 65,
            -- iLvl 300+
        },
        [4106] = {                                                      -- Enchant Gloves - Mighty Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 50,
            -- iLvl 300+
        },
        [4082] = {                                                      -- Enchant Gloves - Greater Expertise
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4075] = {                                                      -- Enchant Gloves - Exceptional Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 35,
            -- iLvl 300+
        },
        [4068] = {                                                      -- Enchant Gloves - Haste
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4061] = {                                                      -- Enchant Gloves - Mastery
            ["ITEM_MOD_MASTERY_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        
        -- level 85
        [3253] = {                                                      -- Enchant Gloves - Armsman
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 10,
            -- +2% Threat
            -- 60+
        },
        [1603] = {                                                      -- Enchant Gloves - Crusher
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 44,
            -- 60+
        },
        [3246] = {                                                      -- Enchant Gloves - Exceptional Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 28,
            -- 60+
        },
        [3222] = {                                                      -- Enchant Gloves - Major Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 20,
            -- 60+
        },
        
        -- level 84
        [3829] = {                                                      -- Enchant Gloves - Greater Assault
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 35,
            -- 60+
        },
        
        -- level 77
        [3234] = {                                                      -- Enchant Gloves - Precision
            ["ITEM_MOD_HIT_RATING_SHORT"] = 20,
            -- 60+
        },
        
        -- level 75
        [3238] = {                                                      -- Enchant Gloves - Gatherer
            -- mining, herbalism, skinning +5
            -- 60+
        },
        
        -- level 73
        [3231] = {                                                      -- Enchant Gloves - Expertise
            ["ITEM_MOD_EXPERTISE_RATING_SHORT"] = 15,
            -- 60+
        },
        
        -- level 72
        [2937] = {                                                      -- Enchant Gloves - Major Spellpower
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 20,
            -- 35+
        },
        [2935] = {                                                      -- Enchant Gloves - Precise Strikes
            ["ITEM_MOD_HIT_RATING_SHORT"] = 15,
            -- 35+
        },
        
        -- level 70
        [846] = {                                                       -- Enchant Gloves - Angler
            -- fishing +5
        },
        [2616] = {                                                      -- Enchant Gloves - Fire Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 20,
            -- fire spell power
        },
        [2615] = {                                                      -- Enchant Gloves - Frost Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 20,
            -- frost spell power
        },
        [2617] = {                                                      -- Enchant Gloves - Healing Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 16,
        },
        [2322] = {                                                      -- Enchant Gloves - Major Healing
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 19,
            -- 35+
        },
        [2614] = {                                                      -- Enchant Gloves - Shadow Power
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 20,
            -- shadow spell power
        },
        [2564] = {                                                      -- Enchant Gloves - Superior Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 15,
        },
        [2613] = {                                                      -- Enchant Gloves - Threat
            -- +2% Threat
        },
        
        -- level 68
        [684] = {                                                       -- Enchant Gloves - Major Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 15,
            -- 35+
        },
        
        -- level 62
        [1594] = {                                                      -- Enchant Gloves - Assault
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 26,
            -- 35+
        },
        
        -- level 61
        [2934] = {                                                      -- Enchant Gloves - Blasting
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 10,
            -- 35+
        },
        
        -- level 59
        [927] = {                                                       -- Enchant Gloves - Greater Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 7,
        },
        
        -- level 54
        [1887] = {                                                      -- Enchant Gloves - Greater Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 7,
        },
        
        -- level 50
        [931] = {                                                       -- Enchant Gloves - Minor Haste
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 10,
        },
        [930] = {                                                       -- Enchant Gloves - Riding Skill
            -- increase mount speed by 2%
            -- player level <= 70
        },
        
        -- level 45
        [909] = {                                                       -- Enchant Gloves - Advanced Herbalism
            -- herbalism +5
        },
        [856] = {                                                       -- Enchant Gloves - Strength
            ["ITEM_MOD_STRENGTH_SHORT"] = 5,
        },
        
        -- level 43
        [906] = {                                                       -- Enchant Gloves - Advanced Mining
            -- mining +5
        },
        
        -- level 42
        [904] = {                                                       -- Enchant Gloves - Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 5,
        },
        
        -- level 40
        [865] = {                                                       -- Enchant Gloves - Skinning
            -- skinning +5
        },
        
        -- level 29
        [846] = {                                                       -- Enchant Gloves - Fishing
            -- fishing +2
        },
        [845] = {                                                       -- Enchant Gloves - Herbalism
            -- herbalism +2
        },
        [844] = {                                                       -- Enchant Gloves - Mining
            -- mining +2
        },
        
        [3603] = {                                                      -- Hand-Mounted Pyro Rocket
            -- deal 1654 to 2020 Fire damage (45 yards range!), 45sec CD
            -- engineering 400
        },
        [3604] = {                                                      -- Hyperspeed Accelerators
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 48, -- 240 haste rating for 12 sec every minute
            -- engineering 400
        },
        [3860] = {                                                      -- Reticulated Armor Webbing
            ["RESISTANCE0_NAME"] = 163, -- 700 armor for 14 secs every minute
            -- engineering 400
        },
        [3723] = {                                                      -- Socket Gloves
            -- adds a prismatic socket to your gloves
            -- blacksmithing 400
        },
    },
    
    -- Legs
    [7] = {
        -- normal armor kits
        [3330] = {                                                      -- Heavy Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 18,
            -- 70+
        },
        [3329] = {                                                      -- Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 12,
            -- 70+
        },
        [2841] = {                                                      -- Heavy Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            -- 60+
        },
        [2792] = {                                                      -- Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 8,
            -- 55+
        },
        [1843] = {                                                      -- Rugged Armor Kit
            ["RESISTANCE0_NAME"] = 40,
            -- 35+
        },
        [18] = {                                                        -- Thick Armor Kit
            ["RESISTANCE0_NAME"] = 32,
            -- 25+
        },
        [17] = {                                                        -- Heavy Armor Kit
            ["RESISTANCE0_NAME"] = 24,
            -- 15+
        },
        [16] = {                                                        -- Medium Armor Kit
            ["RESISTANCE0_NAME"] = 16,
        },
        [15] = {                                                        -- Light Armor Kit
            ["RESISTANCE0_NAME"] = 8,
        },
        
        -- special kits
        [2793] = {                                                      -- Vindicator's Armor Kit
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 8,
        },
        [2794] = {                                                      -- Magister's Armor Kit
            ["ITEM_MOD_SPIRIT_SHORT"] = 8,
        },
        [2503] = {                                                      -- Core Armor Kit
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 5,
        },
        
        -- lesser arcanums
        [1503] = {                                                      -- Lesser Arcanum of Constitution
            ["ITEM_MOD_HEALTH_SHORT"] = 100,
        },
        [1505] = {                                                      -- Lesser Arcanum of Resilience
            ["RESISTANCE2_NAME"] = 20,
        },
        [1483] = {                                                      -- Lesser Arcanum of Rumination
            ["ITEM_MOD_MANA_SHORT"] = 150,
        },
        [1504] = {                                                      -- Lesser Arcanum of Tenacity
            ["RESISTANCE0_NAME"] = 125,
        },
        [1507] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_STAMINA_SHORT"] = 8,
        },
        [1506] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_STRENGTH_SHORT"] = 8,
        },
        [1508] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_AGILITY_SHORT"] = 8,
        },
        [1509] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_INTELLECT_SHORT"] = 8,
        },
        [1510] = {                                                      -- Lesser Arcanum of Voracity
            ["ITEM_MOD_SPIRIT_SHORT"] = 8,
        },
        
        [2544] = {                                                      -- Arcanum of Focus
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 8,
        },
        [2545] = {                                                      -- Arcanum of Protection
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 12,
        },
        [2543] = {                                                      -- Arcanum of Rapidity
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 10,
        },
        
        [3822] = {                                                      -- Frosthide Leg Armor
            ["ITEM_MOD_STAMINA_SHORT"] = 55,
            ["ITEM_MOD_AGILITY_SHORT"] = 22,
            -- 80+
        },
        [3325] = {                                                      -- Jormungar Leg Armor
            ["ITEM_MOD_STAMINA_SHORT"] = 45,
            ["ITEM_MOD_AGILITY_SHORT"] = 15,
            -- 70+
        },
        [3013] = {                                                      -- Nethercleft Leg Armor
            ["ITEM_MOD_STAMINA_SHORT"] = 40,
            ["ITEM_MOD_AGILITY_SHORT"] = 12,
            -- 60+
        },
        [3011] = {                                                      -- Clefthide Leg Armor
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            ["ITEM_MOD_AGILITY_SHORT"] = 10,
            -- 50+
        },
        
        [2989] = {                                                      -- Arcane Armor Kit
            ["RESISTANCE6_NAME"] = 8,
            -- 60+
        },
        [2985] = {                                                      -- Flame Armor Kit
            ["RESISTANCE2_NAME"] = 8,
            -- 65+
        },
        [2987] = {                                                      -- Frost Armor Kit
            ["RESISTANCE4_NAME"] = 8,
            -- 65+
        },
        [2988] = {                                                      -- Nature Armor Kit
            ["RESISTANCE3_NAME"] = 8,
            -- 65+
        },
        [2984] = {                                                      -- Shadow Armor Kit
            ["RESISTANCE5_NAME"] = 8,
            -- 65+
        },
        
        [2682] = {                                                      -- Ice Guard
            ["RESISTANCE4_NAME"] = 10,
            -- 55+
        },
        [2681] = {                                                      -- Savage Guard
            ["RESISTANCE3_NAME"] = 10,
            -- 55+
        },
        [2683] = {                                                      -- Shadow Guard
            ["RESISTANCE5_NAME"] = 10,
            -- 55+
        },
        
        [3853] = {                                                      -- Earthen Leg Armor
            ["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 40,
            ["ITEM_MOD_STAMINA_SHORT"] = 28,
            -- 80+
        },
        [3823] = {                                                      -- Icescale Leg Armor
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 75,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 22,
            -- 80+
        },
        [3326] = {                                                      -- Nerubian Leg Armor
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 55,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 15,
            -- 70+
        },
        [3012] = {                                                      -- Nethercobra Leg Armor
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 50,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 12,
            -- 60+
        },
        [3010] = {                                                      -- Cobrahide Leg Armor
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 40,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 10,
            -- 50+
        },
        
        -- tailoring spellthreads
        [4112] = {                                                      -- Powerful Enchanted Spellthread
            ["ITEM_MOD_INTELLECT_SHORT"] = 95,
            ["ITEM_MOD_STAMINA_SHORT"] = 80,
            -- player 85+
        },
        [4110] = {                                                      -- Powerful Ghostly Spellthread
            ["ITEM_MOD_INTELLECT_SHORT"] = 95,
            ["ITEM_MOD_SPIRIT_SHORT"] = 55,
            -- player 85+
        },
        [4111] = {                                                      -- Enchanted Spellthread
            ["ITEM_MOD_INTELLECT_SHORT"] = 55,
            ["ITEM_MOD_STAMINA_SHORT"] = 65,
            -- player 80+
        },
        [4109] = {                                                      -- Ghostly Spellthread
            ["ITEM_MOD_INTELLECT_SHORT"] = 55,
            ["ITEM_MOD_SPIRIT_SHORT"] = 45,
            -- player 80+
        },
        [3719] = {                                                      -- Brilliant Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 50,
            ["ITEM_MOD_SPIRIT_SHORT"] = 20,
            -- 70+
        },
        [3718] = {                                                      -- Shining Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 35,
            ["ITEM_MOD_SPIRIT_SHORT"] = 12,
            -- 70+
        },
        [3721] = {                                                      -- Sapphire Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 50,
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            -- 70+
        },
        [3720] = {                                                      -- Azure Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 35,
            ["ITEM_MOD_STAMINA_SHORT"] = 20,
            -- 70+
        },
        [2746] = {                                                      -- Golden Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 35,
            ["ITEM_MOD_STAMINA_SHORT"] = 20,
            -- 60+
        },
        [2748] = {                                                      -- Runic Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 35,
            ["ITEM_MOD_STAMINA_SHORT"] = 20,
            -- 60+
        },
        [2745] = {                                                      -- Silver Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 25,
            ["ITEM_MOD_STAMINA_SHORT"] = 15,
            -- 50+
        },
        [2747] = {                                                      -- Mystic Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 25,
            ["ITEM_MOD_STAMINA_SHORT"] = 15,
            -- 50+
        },
        
        -- level 60, Zul'Gurub rare
        [2591] = {                                                      -- Animist's Caress
            ["ITEM_MOD_INTELLECT_SHORT"] = 10,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 12,
        },
        [3755] = {                                                      -- Death's Embrace
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 28,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 12,
        },
        [3752] = {                                                      -- Falcon's Call
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 24,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 10,
        },
        [2589] = {                                                      -- Hoodoo Hex
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 18,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
        },
        [2583] = {                                                      -- Presence of Might
            ["ITEM_MOD_PARRY_RATING_SHORT"] = 10,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 10,
        },
        [2588] = {                                                      -- Presence of Sight
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 18,
            ["ITEM_MOD_HIT_RATING_SHORT"] = 8,
        },
        [2590] = {                                                      -- Prophetic Aura
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 13,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_SPIRIT_SHORT"] = 10, -- there is still mana reg on this item, but it is usually converted into double the amount in spirit everywhere else
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 5,
        },
        [2584] = {                                                      -- Syncretist's Sigil
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 10,
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            ["ITEM_MOD_INTELLECT_SHORT"] = 10,
        },
        [2587] = {                                                      -- Vodouisant's Vigilant Embrace
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 13,
            ["ITEM_MOD_INTELLECT_SHORT"] = 15,
        },
        
        [4126] = {                                                      -- Dragonscale Leg Armor
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 190,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 55,
            -- leatherworking ???
        },
        [4270] = {                                                      -- Drakehide Leg Armor
            ["ITEM_MOD_STAMINA_SHORT"] = 145,
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 55,
            -- leatherworking ???
        },
        [4127] = {                                                      -- Charscale Leg Reinforcements aka Charscale Leg Armor
            ["ITEM_MOD_STAMINA_SHORT"] = 145,
            ["ITEM_MOD_AGILITY_SHORT"] = 55,
            -- leatherworking ???
        },
        [4122] = {                                                      -- Dragonscale Leg Reinforcements aka Scorched Leg Armor
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 110,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 45,
            -- leatherworking ???
        },
        [4124] = {                                                      -- Charscale Leg Reinforcements aka Twilight Leg Armor
            ["ITEM_MOD_STAMINA_SHORT"] = 85,
            ["ITEM_MOD_AGILITY_SHORT"] = 45,
            -- leatherworking ???
        },
        [3328] = {                                                      -- Nerubian Leg Reinforcements
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 75,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 22,
            -- leatherworking 400
        },
        [3327] = {                                                      -- Jormungar Leg Reinforcements
            ["ITEM_MOD_STAMINA_SHORT"] = 55,
            ["ITEM_MOD_AGILITY_SHORT"] = 22,
            -- leatherworking 400
        },
        
        [4114] = {                                                      -- Sanctified Spellthread Rank 2
            ["ITEM_MOD_INTELLECT_SHORT"] = 95,
            ["ITEM_MOD_SPIRIT_SHORT"] = 55,
            -- tailoring 405
        },
        [4113] = {                                                      -- Master's Spellthread Rank 2
            ["ITEM_MOD_INTELLECT_SHORT"] = 95,
            ["ITEM_MOD_STAMINA_SHORT"] = 80,
            -- tailoring 405
        },
        [3872] = {                                                      -- Sanctified Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 50,
            ["ITEM_MOD_SPIRIT_SHORT"] = 20,
            -- tailoring 405
        },
        [3873] = {                                                      -- Master's Spellthread
            ["ITEM_MOD_SPELL_POWER_SHORT"] = 50,
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            -- tailoring 405
        },

        [4120] = {                                                      -- Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 36,
        },
        [4121] = {                                                      -- Heavy Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 44,
        },
    },
    
    -- Feet
    [8] = {
        [4120] = {                                                      -- Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 36,
        },
        [4121] = {                                                      -- Heavy Savage Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 44,
        },
        [3330] = {                                                      -- Heavy Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 18,
            -- 70+
        },
        [3329] = {                                                      -- Borean Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 12,
            -- 70+
        },
        [2841] = {                                                      -- Heavy Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 10,
            -- 60+
        },
        [2792] = {                                                      -- Knothide Armor Kit
            ["ITEM_MOD_STAMINA_SHORT"] = 8,
            -- 55+
        },
        [1843] = {                                                      -- Rugged Armor Kit
            ["RESISTANCE0_NAME"] = 40,
            -- 35+
        },
        [18] = {                                                        -- Thick Armor Kit
            ["RESISTANCE0_NAME"] = 32,
            -- 25+
        },
        [17] = {                                                        -- Heavy Armor Kit
            ["RESISTANCE0_NAME"] = 24,
            -- 15+
        },
        [16] = {                                                        -- Medium Armor Kit
            ["RESISTANCE0_NAME"] = 16,
        },
        [15] = {                                                        -- Light Armor Kit
            ["RESISTANCE0_NAME"] = 8,
        },
        
        [2793] = {                                                      -- Vindicator's Armor Kit
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 8,
        },
        [2503] = {                                                      -- Core Armor Kit
            ["ITEM_MOD_DODGE_RATING_SHORT"] = 5,
        },
        [2794] = {                                                      -- Magister's Armor Kit
            ["ITEM_MOD_SPIRIT_SHORT"] = 8,
        },
        
        [2989] = {                                                      -- Arcane Armor Kit
            ["RESISTANCE6_NAME"] = 8,
        },
        [2985] = {                                                      -- Flame Armor Kit
            ["RESISTANCE2_NAME"] = 8,
        },
        [2987] = {                                                      -- Frost Armor Kit
            ["RESISTANCE4_NAME"] = 8,
        },
        [2988] = {                                                      -- Nature Armor Kit
            ["RESISTANCE3_NAME"] = 8,
        },
        [2984] = {                                                      -- Shadow Armor Kit
            ["RESISTANCE5_NAME"] = 8,
        },
        
        -- enchanting
        -- cataclysm
        [4105] = {                                                      -- Enchant Boots - Assassin's Step
            ["ITEM_MOD_AGILITY_SHORT"] = 25,
            -- slight movement speed increase
            -- iLvl 300+
        },
        [4104] = {                                                      -- Enchant Boots - Lavawalker
            ["ITEM_MOD_MASTERY_RATING_SHORT"] = 35,
            -- slight movement speed increase
            -- iLvl 300+
        },
        [4094] = {                                                      -- Enchant Boots - Mastery
            ["ITEM_MOD_MASTERY_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4092] = {                                                      -- Enchant Boots - Precision
            ["ITEM_MOD_HIT_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        [4076] = {                                                      -- Enchant Boots - Major Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 35,
            -- iLvl 300+
        },
        [4069] = {                                                      -- Enchant Boots - Haste
            ["ITEM_MOD_HASTE_RATING_SHORT"] = 50,
            -- iLvl 300+
        },
        
        -- level 85
        [3826] = {                                                      -- Enchant Boots - Icewalker
            ["ITEM_MOD_HIT_RATING_SHORT"] = 12,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 12,
            -- 60+
        },
        [3232] = {                                                      -- Enchant Boots - Tuskarr's Vitality
            ["ITEM_MOD_STAMINA_SHORT"] = 15,
            -- minor speed
            -- 60+
        },
        
        [4062] = {                                                      -- Enchant Boots - Earthen Vitality
            ["ITEM_MOD_STAMINA_SHORT"] = 30,
            -- minor speed
            -- iLvl 300+
        },
        
        -- level 82
        [983] = {                                                       -- Enchant Boots - Superior Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 16,
            -- 60+
        },
        
        -- level 75
        [1075] = {                                                      -- Enchant Boots - Greater Fortitude
            ["ITEM_MOD_STAMINA_SHORT"] = 22,
            -- 60+
        },
        
        -- level 74
        [2658] = {                                                      -- Enchant Boots - Surefooted
            ["ITEM_MOD_HIT_RATING_SHORT"] = 10,
            ["ITEM_MOD_CRIT_RATING_SHORT"] = 10,
            -- 35+
        },
        
        -- level 73
        [3244] = {                                                      -- Enchant Boots - Greater Vitality
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 7,
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 7,
            ["ITEM_MOD_SPIRIT_SHORT"] = 14, -- again, double old mp5
            -- 60+
        },
        
        -- level 72
        [2940] = {                                                      -- Enchant Boots - Boar's Speed
            ["ITEM_MOD_STAMINA_SHORT"] = 9,
            -- minor speed
            -- 35+
        },
        [2939] = {                                                      -- Enchant Boots - Cat's Swiftness
            ["ITEM_MOD_AGILITY_SHORT"] = 6,
            -- minor speed
            -- 35+
        },
        [1597] = {                                                      -- Enchant Boots - Greater Assault
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 32,
            -- 60+
        },
        
        -- level 71
        [3824] = {                                                      -- Enchant Boots - Assault
            ["ITEM_MOD_ATTACK_POWER_SHORT"] = 24,
            -- 60+
        },
        [1147] = {                                                      -- Enchant Boots - Greater Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 18,
            -- 60+
        },
        
        -- level 68
        [2657] = {                                                      -- Enchant Boots - Dexterity
            ["ITEM_MOD_AGILITY_SHORT"] = 12,
            -- 35+
        },
        
        -- level 64
        [2649] = {                                                      -- Enchant Boots - Fortitude
            ["ITEM_MOD_STAMINA_SHORT"] = 12,
            -- 35+
        },
        
        -- level 61
        [2656] = {                                                      -- Enchant Boots - Vitality
            ["ITEM_MOD_HEALTH_REGENERATION_SHORT"] = 5,
            --["ITEM_MOD_MANA_REGENERATION_SHORT"] = 5,
            ["ITEM_MOD_SPIRIT_SHORT"] = 10, -- again, double old mp5
            -- 35+
        },
        
        -- level 59
        [1887] = {                                                      -- Enchant Boots - Greater Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 7,
        },
        
        -- level 55
        [851] = {                                                       -- Enchant Boots - Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 5,
        },
        
        -- level 52
        [929] = {                                                       -- Enchant Boots - Greater Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 7,
        },
        
        -- level 47
        [904] = {                                                       -- Enchant Boots - Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 5,
        },
        
        -- level 45
        [3858] = {                                                      -- Enchant Boots - Lesser Accuracy
            ["ITEM_MOD_HIT_RATING_SHORT"] = 5,
        },
        [911] = {                                                       -- Enchant Boots - Minor Speed
            -- minor speed
        },
        
        -- level 43
        [852] = {                                                       -- Enchant Boots - Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 5,
        },
        
        -- level 38
        [255] = {                                                       -- Enchant Boots - Lesser Spirit
            ["ITEM_MOD_SPIRIT_SHORT"] = 3,
        },
        
        -- level 34
        [724] = {                                                       -- Enchant Boots - Lesser Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 3,
        },
        
        -- level 32
        [849] = {                                                       -- Enchant Boots - Lesser Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 3,
        },
        
        -- level 25
        [247] = {                                                       -- Enchant Boots - Minor Agility
            ["ITEM_MOD_AGILITY_SHORT"] = 1,
        },
        [66] = {                                                        -- Enchant Boots - Minor Stamina
            ["ITEM_MOD_STAMINA_SHORT"] = 1,
        },
        
        
        
        [464] = {                                                       -- Mithril Spurs
            -- +4% Mount Speed
            -- player level <= 70
        },
    },
}

TopFit.enchantIDs[12] = TopFit.enchantIDs[11] -- set ring 2 enchants to the same as ring 1