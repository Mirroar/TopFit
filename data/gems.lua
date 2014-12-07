local addonName, ns = ...

ns.gemIDs = {
  [89873] = { -- Crystallized Dread
    colors = {"HYDRAULIC"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 31,},
    requirements = {},
  },
  [89881] = { -- Crystallized Terror
    colors = {"HYDRAULIC"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 31,},
    requirements = {},
  },
  [89882] = { -- Crystallized Horror
    colors = {"HYDRAULIC"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 31,},
    requirements = {},
  },
  [115809] = { -- Greater Critical Strike Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 50,},
    requirements = {},
  },
  [115811] = { -- Greater Haste Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 50,},
    requirements = {},
  },
  [115812] = { -- Greater Mastery Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 50,},
    requirements = {},
  },
  [115813] = { -- Greater Multistrike Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CR_MULTISTIKE_SHORT"] = 50,},
    requirements = {},
  },
  [115814] = { -- Greater Versatility Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_VERSATILITY"] = 50,},
    requirements = {},
  },
  [115815] = { -- Greater Stamina Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 50,},
    requirements = {},
  },
  [115803] = { -- Critical Strike Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 35,},
    requirements = {},
  },
  [115804] = { -- Haste Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 35,},
    requirements = {},
  },
  [115805] = { -- Mastery Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 35,},
    requirements = {},
  },
  [115806] = { -- Multistrike Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CR_MULTISTIKE_SHORT"] = 35,},
    requirements = {},
  },
  [115807] = { -- Versatility Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_VERSATILITY"] = 35,},
    requirements = {},
  },
  [115808] = { -- Stamina Taladite
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 35,},
    requirements = {},
  },
  [83141] = { -- Bold Serpent's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 10,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83147] = { -- Precise Serpent's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83150] = { -- Brilliant Serpent's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83151] = { -- Delicate Serpent's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83152] = { -- Flashing Serpent's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [76692] = { -- Delicate Primordial Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {},
  },
  [76693] = { -- Precise Primordial Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76694] = { -- Brilliant Primordial Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [76695] = { -- Flashing Primordial Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76696] = { -- Bold Primordial Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 10,},
    requirements = {},
  },
  [83144] = { -- Rigid Serpent's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83148] = { -- Solid Serpent's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 15,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83149] = { -- Sparkling Serpent's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [76636] = { -- Rigid River's Heart
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76637] = { -- Stormy River's Heart
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 10,},
    requirements = {},
  },
  [76638] = { -- Sparkling River's Heart
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 20,},
    requirements = {},
  },
  [76639] = { -- Solid River's Heart
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 15,},
    requirements = {},
  },
  [83142] = { -- Quick Serpent's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83143] = { -- Fractured Serpent's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83145] = { -- Subtle Serpent's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [83146] = { -- Smooth Serpent's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [76697] = { -- Smooth Sun's Radiance
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76698] = { -- Subtle Sun's Radiance
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76699] = { -- Quick Sun's Radiance
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76700] = { -- Fractured Sun's Radiance
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76701] = { -- Mystic Sun's Radiance
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [93408] = { -- Tense Serpent's Eye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [93409] = { -- Assassin's Serpent's Eye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [93410] = { -- Mysterious Serpent's Eye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [76680] = { -- Glinting Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76681] = { -- Accurate Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76682] = { -- Veiled Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [76683] = { -- Retaliating Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76684] = { -- Etched Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76685] = { -- Mysterious Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76686] = { -- Purified Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76687] = { -- Shifting Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76688] = { -- Guardian's Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76689] = { -- Timeless Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76690] = { -- Defender's Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76691] = { -- Sovereign Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [89674] = { -- Tense Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [89680] = { -- Assassin's Imperial Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76640] = { -- Misty Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76641] = { -- Piercing Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76642] = { -- Lightning Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76643] = { -- Sensei's Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76644] = { -- Effulgent Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76645] = { -- Zen Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76646] = { -- Balanced Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76647] = { -- Vivid Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76648] = { -- Turbid Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76649] = { -- Radiant Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76650] = { -- Shattered Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76651] = { -- Energized Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76652] = { -- Jagged Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76653] = { -- Regal Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76654] = { -- Forceful Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76655] = { -- Confounded Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76656] = { -- Puissant Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76657] = { -- Steady Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [93705] = { -- Nimble Wild Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_DODGE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [93404] = { -- Resplendent Serpent's Eye
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [93405] = { -- Lucent Serpent's Eye
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [93406] = { -- Willful Serpent's Eye
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {["jewelcrafting"] = 550,["level"] = 75,},
  },
  [76658] = { -- Deadly Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76659] = { -- Crafty Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76660] = { -- Potent Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [76661] = { -- Inscribed Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76662] = { -- Polished Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_DODGE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76663] = { -- Resolute Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76664] = { -- Stalwart Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76665] = { -- Champion's Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76666] = { -- Deft Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76667] = { -- Wicked Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76668] = { -- Reckless Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [76669] = { -- Fierce Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76670] = { -- Adept Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76671] = { -- Keen Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76672] = { -- Artful Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76673] = { -- Fine Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76674] = { -- Skillful Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76675] = { -- Lucent Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76676] = { -- Tenuous Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76677] = { -- Willful Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76678] = { -- Splendid Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76679] = { -- Resplendent Vermilion Onyx
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [95344] = { -- Indomitable Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 20,},
    requirements = {},
  },
  [95345] = { -- Courageous Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 20,},
    requirements = {},
  },
  [95346] = { -- Capacitive Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [95347] = { -- Sinister Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [95348] = { -- Tyrannical Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 42,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 48,},
    requirements = {},
  },
  [76879] = { -- Ember Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 14,},
    requirements = {},
  },
  [76884] = { -- Agile Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 14,},
    requirements = {},
  },
  [76885] = { -- Burning Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 14,},
    requirements = {},
  },
  [76886] = { -- Reverberating Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 14,},
    requirements = {},
  },
  [76887] = { -- Fleet Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 27,},
    requirements = {},
  },
  [76888] = { -- Revitalizing Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 27,},
    requirements = {},
  },
  [76890] = { -- Destructive Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 27,},
    requirements = {},
  },
  [76891] = { -- Powerful Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 20,},
    requirements = {},
  },
  [76892] = { -- Enigmatic Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 27,},
    requirements = {},
  },
  [76893] = { -- Impassive Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 27,},
    requirements = {},
  },
  [76894] = { -- Forlorn Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 14,},
    requirements = {},
  },
  [76895] = { -- Austere Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 20,},
    requirements = {},
  },
  [76896] = { -- Eternal Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 27,},
    requirements = {},
  },
  [76897] = { -- Effulgent Primal Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 20,},
    requirements = {},
  },
  [77540] = { -- Subtle Tinker's Gear
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 38,},
    requirements = {},
  },
  [77541] = { -- Smooth Tinker's Gear
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 38,},
    requirements = {},
  },
  [77542] = { -- Quick Tinker's Gear
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 38,},
    requirements = {},
  },
  [77543] = { -- Precise Tinker's Gear
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 38,},
    requirements = {},
  },
  [77544] = { -- Flashing Tinker's Gear
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 38,},
    requirements = {},
  },
  [77545] = { -- Rigid Tinker's Gear
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 38,},
    requirements = {},
  },
  [77546] = { -- Sparkling Tinker's Gear
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 38,},
    requirements = {},
  },
  [77547] = { -- Fractured Tinker's Gear
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 38,},
    requirements = {},
  },
  [76626] = { -- Perfect Delicate Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {},
  },
  [76627] = { -- Perfect Precise Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76628] = { -- Perfect Brilliant Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [76629] = { -- Perfect Flashing Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76630] = { -- Perfect Bold Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 10,},
    requirements = {},
  },
  [76570] = { -- Perfect Rigid Lapis Lazuli
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76571] = { -- Perfect Stormy Lapis Lazuli
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 10,},
    requirements = {},
  },
  [76572] = { -- Perfect Sparkling Lapis Lazuli
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 20,},
    requirements = {},
  },
  [76573] = { -- Perfect Solid Lapis Lazuli
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 15,},
    requirements = {},
  },
  [76631] = { -- Perfect Smooth Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76632] = { -- Perfect Subtle Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76633] = { -- Perfect Quick Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76634] = { -- Perfect Fractured Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76635] = { -- Perfect Mystic Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76614] = { -- Perfect Glinting Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76615] = { -- Perfect Accurate Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76616] = { -- Perfect Veiled Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [76617] = { -- Perfect Retaliating Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76618] = { -- Perfect Etched Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76619] = { -- Perfect Mysterious Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76620] = { -- Perfect Purified Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76621] = { -- Perfect Shifting Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76622] = { -- Perfect Guardian's Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76623] = { -- Perfect Timeless Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76624] = { -- Perfect Defender's Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76625] = { -- Perfect Sovereign Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [89676] = { -- Perfect Tense Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76574] = { -- Perfect Misty Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76575] = { -- Perfect Piercing Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76576] = { -- Perfect Lightning Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76577] = { -- Perfect Sensei's Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76578] = { -- Perfect Effulgent Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76579] = { -- Perfect Zen Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76580] = { -- Perfect Balanced Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76581] = { -- Perfect Vivid Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76582] = { -- Perfect Turbid Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76583] = { -- Perfect Radiant Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76584] = { -- Perfect Shattered Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76585] = { -- Perfect Energized Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [76586] = { -- Perfect Jagged Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76587] = { -- Perfect Regal Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76588] = { -- Perfect Forceful Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76589] = { -- Perfect Confounded Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76590] = { -- Perfect Puissant Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [76591] = { -- Perfect Steady Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [93707] = { -- Perfect Nimble Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_DODGE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76592] = { -- Perfect Deadly Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76593] = { -- Perfect Crafty Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76594] = { -- Perfect Potent Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [76595] = { -- Perfect Inscribed Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76596] = { -- Perfect Polished Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_DODGE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76597] = { -- Perfect Resolute Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76598] = { -- Perfect Stalwart Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76599] = { -- Perfect Champion's Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76600] = { -- Perfect Deft Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76601] = { -- Perfect Wicked Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [76602] = { -- Perfect Reckless Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [76603] = { -- Perfect Fierce Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76604] = { -- Perfect Adept Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76605] = { -- Perfect Keen Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76606] = { -- Perfect Artful Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76607] = { -- Perfect Fine Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [76608] = { -- Perfect Skillful Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76609] = { -- Perfect Lucent Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76610] = { -- Perfect Tenuous Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76611] = { -- Perfect Willful Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76612] = { -- Perfect Splendid Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [76613] = { -- Perfect Resplendent Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [76560] = { -- Delicate Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 8,},
    requirements = {},
  },
  [76561] = { -- Precise Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76562] = { -- Brilliant Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 8,},
    requirements = {},
  },
  [76563] = { -- Flashing Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76564] = { -- Bold Pandarian Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 8,},
    requirements = {},
  },
  [76502] = { -- Rigid Lapis Lazuli
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76504] = { -- Stormy Lapis Lazuli
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 8,},
    requirements = {},
  },
  [76505] = { -- Sparkling Lapis Lazuli
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 16,},
    requirements = {},
  },
  [76506] = { -- Solid Lapis Lazuli
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 12,},
    requirements = {},
  },
  [76565] = { -- Smooth Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76566] = { -- Subtle Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76567] = { -- Quick Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76568] = { -- Fractured Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76569] = { -- Mystic Sunstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [89679] = { -- Perfect Assassin's Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [76548] = { -- Glinting Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76549] = { -- Accurate Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76550] = { -- Veiled Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [76551] = { -- Retaliating Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_PARRY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76552] = { -- Etched Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [76553] = { -- Mysterious Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [76554] = { -- Purified Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [76555] = { -- Shifting Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76556] = { -- Guardian's Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76557] = { -- Timeless Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76558] = { -- Defender's Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76559] = { -- Sovereign Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [89675] = { -- Tense Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [89678] = { -- Assassin's Roguestone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [76507] = { -- Misty Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [76508] = { -- Piercing Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76509] = { -- Lightning Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76510] = { -- Sensei's Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76511] = { -- Effulgent Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [76512] = { -- Zen Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [76513] = { -- Balanced Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [76514] = { -- Vivid Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [76515] = { -- Turbid Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [76517] = { -- Radiant Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [76518] = { -- Shattered Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [76519] = { -- Energized Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [76520] = { -- Jagged Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76521] = { -- Regal Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76522] = { -- Forceful Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76523] = { -- Confounded Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76524] = { -- Puissant Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [76525] = { -- Steady Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [93706] = { -- Nimble Alexandrite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_DODGE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76526] = { -- Deadly Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76527] = { -- Crafty Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76528] = { -- Potent Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [76529] = { -- Inscribed Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [76530] = { -- Polished Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_DODGE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76531] = { -- Resolute Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76532] = { -- Stalwart Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_PARRY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76533] = { -- Champion's Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [76534] = { -- Deft Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76535] = { -- Wicked Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [76536] = { -- Reckless Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [76537] = { -- Fierce Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [76538] = { -- Adept Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76539] = { -- Keen Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76540] = { -- Artful Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76541] = { -- Fine Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,["ITEM_MOD_PARRY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [76542] = { -- Skillful Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [76543] = { -- Lucent Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [76544] = { -- Tenuous Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [76545] = { -- Willful Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [76546] = { -- Splendid Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 8,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [76547] = { -- Resplendent Tiger Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52255] = { -- Bold Chimera's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 8,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52257] = { -- Brilliant Chimera's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 8,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52258] = { -- Delicate Chimera's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 8,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52259] = { -- Flashing Chimera's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 16,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52260] = { -- Precise Chimera's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [71879] = { -- Delicate Queen's Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {},
  },
  [71880] = { -- Precise Queen's Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [71881] = { -- Brilliant Queen's Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [71882] = { -- Flashing Queen's Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [71883] = { -- Bold Queen's Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 10,},
    requirements = {},
  },
  [52206] = { -- Bold Inferno Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 8,},
    requirements = {},
  },
  [52207] = { -- Brilliant Inferno Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 8,},
    requirements = {},
  },
  [52212] = { -- Delicate Inferno Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 8,},
    requirements = {},
  },
  [52216] = { -- Flashing Inferno Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [52230] = { -- Precise Inferno Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [52261] = { -- Solid Chimera's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 12,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52262] = { -- Sparkling Chimera's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 16,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52263] = { -- Stormy Chimera's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 8,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52264] = { -- Rigid Chimera's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [71817] = { -- Rigid Deepholm Iolite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [71818] = { -- Stormy Deepholm Iolite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 20,},
    requirements = {},
  },
  [71819] = { -- Sparkling Deepholm Iolite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 20,},
    requirements = {},
  },
  [71820] = { -- Solid Deepholm Iolite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 15,},
    requirements = {},
  },
  [77140] = { -- Stormy Deepholm Iolite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 10,},
    requirements = {},
  },
  [52235] = { -- Rigid Ocean Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [52242] = { -- Solid Ocean Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 12,},
    requirements = {},
  },
  [52244] = { -- Sparkling Ocean Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 16,},
    requirements = {},
  },
  [52246] = { -- Stormy Ocean Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 8,},
    requirements = {},
  },
  [52265] = { -- Subtle Chimera's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 16,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52266] = { -- Smooth Chimera's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52267] = { -- Mystic Chimera's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 8,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52268] = { -- Quick Chimera's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [52269] = { -- Fractured Chimera's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 16,},
    requirements = {["jewelcrafting"] = 500,["level"] = 65,},
  },
  [71874] = { -- Smooth Lightstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [71875] = { -- Subtle Lightstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [71876] = { -- Quick Lightstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [71877] = { -- Fractured Lightstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [71878] = { -- Mystic Lightstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [77134] = { -- Mystic Lightstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [52219] = { -- Fractured Amberjewel
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [52226] = { -- Mystic Amberjewel
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52232] = { -- Quick Amberjewel
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [52241] = { -- Smooth Amberjewel
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [52247] = { -- Subtle Amberjewel
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [71862] = { -- Glinting Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71863] = { -- Accurate Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71864] = { -- Veiled Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [71865] = { -- Retaliating Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71866] = { -- Etched Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [71867] = { -- Mysterious Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [71868] = { -- Purified Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [71869] = { -- Shifting Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [71870] = { -- Guardian's Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [71871] = { -- Timeless Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [71872] = { -- Defender's Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [71873] = { -- Sovereign Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [77133] = { -- Mysterious Shadow Spinel
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [52203] = { -- Accurate Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52210] = { -- Defender's Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 4,},
    requirements = {},
  },
  [52213] = { -- Etched Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52217] = { -- Veiled Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [52220] = { -- Glinting Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52221] = { -- Guardian's Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [52234] = { -- Retaliating Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_PARRY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52236] = { -- Purified Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [52238] = { -- Shifting Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [52243] = { -- Sovereign Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52248] = { -- Timeless Demonseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [71822] = { -- Misty Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [71823] = { -- Piercing Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [71824] = { -- Lightning Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71825] = { -- Sensei's Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71826] = { -- Infused Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [71827] = { -- Zen Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [71828] = { -- Balanced Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [71829] = { -- Vivid Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [71830] = { -- Turbid Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [71831] = { -- Radiant Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [71832] = { -- Shattered Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [71833] = { -- Energized Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [71834] = { -- Jagged Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [71835] = { -- Regal Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [71836] = { -- Forceful Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [71837] = { -- Nimble Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_DODGE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71838] = { -- Puissant Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [71839] = { -- Steady Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [77130] = { -- Balanced Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [77131] = { -- Infused Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [77137] = { -- Shattered Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [77139] = { -- Steady Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [77142] = { -- Turbid Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [77143] = { -- Vivid Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [77154] = { -- Radiant Elven Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [52218] = { -- Forceful Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [52223] = { -- Jagged Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [52225] = { -- Lightning Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52227] = { -- Nimble Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_DODGE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52228] = { -- Piercing Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [52231] = { -- Puissant Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [52233] = { -- Regal Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [52237] = { -- Sensei's Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52245] = { -- Steady Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [52250] = { -- Zen Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [68741] = { -- Vivid Dream Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [71840] = { -- Deadly Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71841] = { -- Crafty Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71842] = { -- Potent Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [71843] = { -- Inscribed Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [71844] = { -- Polished Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_DODGE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71845] = { -- Resolute Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71846] = { -- Stalwart Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71847] = { -- Champion's Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [71848] = { -- Deft Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71849] = { -- Wicked Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71850] = { -- Reckless Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [71851] = { -- Fierce Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [71852] = { -- Adept Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71853] = { -- Keen Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71854] = { -- Artful Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71855] = { -- Fine Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [71856] = { -- Skillful Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [71857] = { -- Lucent Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [71858] = { -- Tenuous Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [71859] = { -- Willful Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [71860] = { -- Splendid Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [71861] = { -- Resplendent Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [77132] = { -- Lucent Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [77136] = { -- Resplendent Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [77138] = { -- Splendid Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [77141] = { -- Tenuous Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [77144] = { -- Willful Lava Coral
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [52204] = { -- Adept Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52205] = { -- Artful Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52208] = { -- Reckless Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [52209] = { -- Deadly Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52211] = { -- Deft Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52214] = { -- Fierce Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52215] = { -- Fine Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,["ITEM_MOD_PARRY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52222] = { -- Inscribed Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52224] = { -- Keen Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52229] = { -- Polished Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_DODGE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [52239] = { -- Potent Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [52240] = { -- Skillful Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52249] = { -- Resolute Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [68356] = { -- Willful Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [68357] = { -- Lucent Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [68358] = { -- Resplendent Ember Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52289] = { -- Fleet Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 22,},
    requirements = {},
  },
  [52291] = { -- Chaotic Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 22,},
    requirements = {},
  },
  [52292] = { -- Bracing Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [52293] = { -- Eternal Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 16,},
    requirements = {},
  },
  [52294] = { -- Austere Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 16,},
    requirements = {},
  },
  [52295] = { -- Effulgent Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 16,},
    requirements = {},
  },
  [52296] = { -- Ember Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [52297] = { -- Revitalizing Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 22,},
    requirements = {},
  },
  [52298] = { -- Destructive Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 22,},
    requirements = {},
  },
  [52299] = { -- Powerful Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 16,},
    requirements = {},
  },
  [52300] = { -- Enigmatic Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 22,},
    requirements = {},
  },
  [52301] = { -- Impassive Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 22,},
    requirements = {},
  },
  [52302] = { -- Forlorn Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [68778] = { -- Agile Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 11,},
    requirements = {},
  },
  [68779] = { -- Reverberating Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 11,},
    requirements = {},
  },
  [68780] = { -- Burning Shadowspirit Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [59477] = { -- Subtle Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 42,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [59478] = { -- Smooth Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 42,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [59479] = { -- Quick Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 42,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [59480] = { -- Fractured Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 42,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [59489] = { -- Precise Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 42,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [59491] = { -- Flashing Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 42,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [59493] = { -- Rigid Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 42,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [59496] = { -- Sparkling Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 42,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [68660] = { -- Mystic Cogwheel
    colors = {"COGWHEEL"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {["engineering"] = 525,["level"] = 65,},
  },
  [52172] = { -- Perfect Precise Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [52173] = { -- Perfect Brilliant Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 7,},
    requirements = {},
  },
  [52174] = { -- Perfect Flashing Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [52175] = { -- Perfect Delicate Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 7,},
    requirements = {},
  },
  [52176] = { -- Perfect Bold Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 7,},
    requirements = {},
  },
  [52168] = { -- Perfect Rigid Zephyrite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [52169] = { -- Perfect Stormy Zephyrite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 7,},
    requirements = {},
  },
  [52170] = { -- Perfect Sparkling Zephyrite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 14,},
    requirements = {},
  },
  [52171] = { -- Perfect Solid Zephyrite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 11,},
    requirements = {},
  },
  [52163] = { -- Perfect Fractured Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [52164] = { -- Perfect Quick Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [52165] = { -- Perfect Mystic Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52166] = { -- Perfect Smooth Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [52167] = { -- Perfect Subtle Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [52152] = { -- Perfect Accurate Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_HASTE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52153] = { -- Perfect Veiled Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [52154] = { -- Perfect Retaliating Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_PARRY_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52155] = { -- Perfect Glinting Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_CRIT_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52156] = { -- Perfect Etched Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52157] = { -- Perfect Purified Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 7,},
    requirements = {},
  },
  [52158] = { -- Perfect Guardian's Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52159] = { -- Perfect Timeless Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52160] = { -- Perfect Defender's Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52161] = { -- Perfect Shifting Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52162] = { -- Perfect Sovereign Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52129] = { -- Perfect Sensei's Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52130] = { -- Perfect Zen Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,["ITEM_MOD_SPIRIT_SHORT"] = 7,},
    requirements = {},
  },
  [52131] = { -- Perfect Puissant Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52132] = { -- Perfect Lightning Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_HASTE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52133] = { -- Perfect Forceful Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52134] = { -- Perfect Steady Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52135] = { -- Perfect Piercing Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [52136] = { -- Perfect Jagged Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52137] = { -- Perfect Nimble Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_DODGE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52138] = { -- Perfect Regal Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52139] = { -- Perfect Keen Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52140] = { -- Perfect Artful Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52141] = { -- Perfect Fine Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,["ITEM_MOD_PARRY_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52142] = { -- Perfect Adept Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52143] = { -- Perfect Skillful Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52144] = { -- Perfect Reckless Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [52145] = { -- Perfect Deft Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_HASTE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52146] = { -- Perfect Fierce Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52147] = { -- Perfect Potent Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [52148] = { -- Perfect Deadly Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52149] = { -- Perfect Inscribed Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [52150] = { -- Perfect Resolute Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 7,["ITEM_MOD_HASTE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52151] = { -- Perfect Polished Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_DODGE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [52081] = { -- Bold Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 6,},
    requirements = {},
  },
  [52082] = { -- Delicate Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 6,},
    requirements = {},
  },
  [52083] = { -- Flashing Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [52084] = { -- Brilliant Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 6,},
    requirements = {},
  },
  [52085] = { -- Precise Carnelian
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [52086] = { -- Solid Zephyrite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 9,},
    requirements = {},
  },
  [52087] = { -- Sparkling Zephyrite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 12,},
    requirements = {},
  },
  [52088] = { -- Stormy Zephyrite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 6,},
    requirements = {},
  },
  [52089] = { -- Rigid Zephyrite
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [52090] = { -- Subtle Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [52091] = { -- Smooth Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [52092] = { -- Mystic Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52093] = { -- Quick Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [52094] = { -- Fractured Alicite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [52095] = { -- Sovereign Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [52096] = { -- Shifting Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52097] = { -- Defender's Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52098] = { -- Timeless Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52099] = { -- Guardian's Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52100] = { -- Purified Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_SPIRIT_SHORT"] = 6,},
    requirements = {},
  },
  [52101] = { -- Etched Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [52102] = { -- Glinting Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_CRIT_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52103] = { -- Retaliating Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_PARRY_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52104] = { -- Veiled Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [52105] = { -- Accurate Nightstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_HASTE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52119] = { -- Regal Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52120] = { -- Nimble Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_DODGE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52121] = { -- Jagged Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52122] = { -- Piercing Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [52123] = { -- Steady Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52124] = { -- Forceful Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52125] = { -- Lightning Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_HASTE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52126] = { -- Puissant Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [52127] = { -- Zen Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,["ITEM_MOD_SPIRIT_SHORT"] = 6,},
    requirements = {},
  },
  [52128] = { -- Sensei's Jasper
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52106] = { -- Polished Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_DODGE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52107] = { -- Resolute Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 6,["ITEM_MOD_HASTE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52108] = { -- Inscribed Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [52109] = { -- Deadly Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_CRIT_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52110] = { -- Potent Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [52111] = { -- Fierce Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [52112] = { -- Deft Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_HASTE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52113] = { -- Reckless Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [52114] = { -- Skillful Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [52115] = { -- Adept Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52116] = { -- Fine Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,["ITEM_MOD_PARRY_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52117] = { -- Artful Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [52118] = { -- Keen Hessonite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_MASTERY_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [40111] = { -- Bold Cardinal Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 10,},
    requirements = {},
  },
  [40112] = { -- Delicate Cardinal Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {},
  },
  [40113] = { -- Brilliant Cardinal Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [40116] = { -- Flashing Cardinal Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [40118] = { -- Precise Cardinal Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [42142] = { -- Bold Dragon's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 10,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42143] = { -- Delicate Dragon's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42144] = { -- Brilliant Dragon's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42152] = { -- Flashing Dragon's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42154] = { -- Precise Dragon's Eye
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [45862] = { -- Bold Stormjewel
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 10,},
    requirements = {},
  },
  [45879] = { -- Delicate Stormjewel
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {},
  },
  [45882] = { -- Brilliant Stormjewel
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [45883] = { -- Brilliant Stormjewel
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [39996] = { -- Bold Scarlet Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 8,},
    requirements = {},
  },
  [39997] = { -- Delicate Scarlet Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 8,},
    requirements = {},
  },
  [39998] = { -- Brilliant Scarlet Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 8,},
    requirements = {},
  },
  [40001] = { -- Flashing Scarlet Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [40003] = { -- Precise Scarlet Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [36767] = { -- Solid Dragon's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 12,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [40119] = { -- Solid Majestic Zircon
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 12,},
    requirements = {},
  },
  [40120] = { -- Sparkling Majestic Zircon
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 20,},
    requirements = {},
  },
  [40122] = { -- Stormy Majestic Zircon
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 10,},
    requirements = {},
  },
  [40125] = { -- Rigid Majestic Zircon
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [42145] = { -- Sparkling Dragon's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42155] = { -- Stormy Dragon's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 10,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42156] = { -- Rigid Dragon's Eye
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [45880] = { -- Solid Stormjewel
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 15,},
    requirements = {},
  },
  [45881] = { -- Sparkling Stormjewel
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 20,},
    requirements = {},
  },
  [45987] = { -- Rigid Stormjewel
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [40008] = { -- Solid Sky Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 12,},
    requirements = {},
  },
  [40010] = { -- Sparkling Sky Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 16,},
    requirements = {},
  },
  [40011] = { -- Stormy Sky Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 8,},
    requirements = {},
  },
  [40014] = { -- Rigid Sky Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [40115] = { -- Subtle King's Amber
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [40124] = { -- Smooth King's Amber
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [40127] = { -- Mystic King's Amber
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40128] = { -- Quick King's Amber
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [42149] = { -- Smooth Dragon's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42150] = { -- Quick Dragon's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42151] = { -- Subtle Dragon's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 20,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [42158] = { -- Mystic Dragon's Eye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {["jewelcrafting"] = 350,["level"] = 35,},
  },
  [44066] = { -- Kharmaa's Grace
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40000] = { -- Subtle Autumn's Glow
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [40013] = { -- Smooth Autumn's Glow
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [40016] = { -- Mystic Autumn's Glow
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [40017] = { -- Quick Autumn's Glow
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [40129] = { -- Sovereign Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [40130] = { -- Shifting Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [40133] = { -- Purified Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [40135] = { -- Mysterious Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [40139] = { -- Defender's Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [40141] = { -- Guardian's Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [40143] = { -- Etched Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [40153] = { -- Veiled Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [40157] = { -- Glinting Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40162] = { -- Accurate Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40164] = { -- Timeless Dreadstone
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [40022] = { -- Sovereign Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [40023] = { -- Shifting Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [40025] = { -- Timeless Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [40026] = { -- Purified Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [40028] = { -- Mysterious Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [40032] = { -- Defender's Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [40034] = { -- Guardian's Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [40038] = { -- Etched Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [40044] = { -- Glinting Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [40049] = { -- Veiled Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [40058] = { -- Accurate Twilight Opal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [40165] = { -- Jagged Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [40166] = { -- Nimble Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_DODGE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40167] = { -- Regal Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [40168] = { -- Steady Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [40169] = { -- Forceful Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 8,},
    requirements = {},
  },
  [40171] = { -- Misty Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [40173] = { -- Turbid Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [40177] = { -- Lightning Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40179] = { -- Energized Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 5,},
    requirements = {},
  },
  [40180] = { -- Radiant Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [40182] = { -- Shattered Eye of Zul
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [40086] = { -- Jagged Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [40088] = { -- Nimble Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_DODGE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [40089] = { -- Regal Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [40090] = { -- Steady Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [40091] = { -- Forceful Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [40095] = { -- Misty Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [40098] = { -- Radiant Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [40100] = { -- Lightning Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [40102] = { -- Turbid Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [40105] = { -- Energized Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [40106] = { -- Shattered Forest Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [40142] = { -- Inscribed Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [40144] = { -- Champion's Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [40145] = { -- Resplendent Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [40146] = { -- Fierce Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [40147] = { -- Deadly Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40149] = { -- Lucent Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [40150] = { -- Deft Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40152] = { -- Potent Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [40154] = { -- Willful Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [40155] = { -- Reckless Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [40159] = { -- Deft Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40160] = { -- Stalwart Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_PARRY_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40163] = { -- Resolute Ametrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [40037] = { -- Inscribed Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [40039] = { -- Champion's Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [40040] = { -- Resplendent Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [40041] = { -- Fierce Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [40045] = { -- Lucent Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [40048] = { -- Potent Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [40050] = { -- Willful Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [40051] = { -- Reckless Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [40052] = { -- Deadly Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 6,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [40055] = { -- Deft Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [40057] = { -- Stalwart Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_PARRY_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [40059] = { -- Resolute Monarch Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [41285] = { -- Chaotic Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 21,},
    requirements = {},
  },
  [41307] = { -- Destructive Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 25,},
    requirements = {},
  },
  [41333] = { -- Ember Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [41335] = { -- Enigmatic Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 21,},
    requirements = {},
  },
  [41339] = { -- Swift Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 21,},
    requirements = {},
  },
  [41375] = { -- Tireless Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [41376] = { -- Revitalizing Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 21,},
    requirements = {},
  },
  [41377] = { -- Shielded Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 16,},
    requirements = {},
  },
  [41378] = { -- Forlorn Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [41379] = { -- Impassive Skyflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 21,},
    requirements = {},
  },
  [41380] = { -- Austere Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 16,},
    requirements = {},
  },
  [41381] = { -- Persistent Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 21,},
    requirements = {},
  },
  [41382] = { -- Trenchant Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [41385] = { -- Invigorating Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 21,},
    requirements = {},
  },
  [41389] = { -- Beaming Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 21,},
    requirements = {},
  },
  [41395] = { -- Bracing Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [41396] = { -- Eternal Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 21,},
    requirements = {},
  },
  [41397] = { -- Powerful Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 16,},
    requirements = {},
  },
  [41398] = { -- Relentless Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 11,},
    requirements = {},
  },
  [41401] = { -- Insightful Earthsiege Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 11,},
    requirements = {},
  },
  [44076] = { -- Swift Starflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 9,},
    requirements = {},
  },
  [44078] = { -- Tireless Starflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 9,},
    requirements = {},
  },
  [44081] = { -- Enigmatic Starflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 9,},
    requirements = {},
  },
  [44082] = { -- Impassive Starflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 9,},
    requirements = {},
  },
  [44084] = { -- Forlorn Starflare Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 9,},
    requirements = {},
  },
  [44087] = { -- Persistent Earthshatter Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 9,},
    requirements = {},
  },
  [44088] = { -- Powerful Earthshatter Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 13,},
    requirements = {},
  },
  [44089] = { -- Trenchant Earthshatter Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 9,},
    requirements = {},
  },
  [49110] = { -- Nightmare Tear
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 2,["ITEM_MOD_INTELLECT_SHORT"] = 2,["ITEM_MOD_SPIRIT_SHORT"] = 2,["ITEM_MOD_STAMINA_SHORT"] = 2,["ITEM_MOD_STRENGTH_SHORT"] = 2,},
    requirements = {},
  },
  [42702] = { -- Enchanted Tear
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_SPIRIT_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 3,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [34142] = { -- Infinite Sphere
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["RESISTANCE6_NAME"] = 33,["RESISTANCE2_NAME"] = 33,["RESISTANCE4_NAME"] = 33,["RESISTANCE1_NAME"] = 33,["RESISTANCE3_NAME"] = 33,["RESISTANCE5_NAME"] = 33,},
    requirements = {},
  },
  [32193] = { -- Bold Crimson Spinel
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 10,},
    requirements = {},
  },
  [32194] = { -- Delicate Crimson Spinel
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {},
  },
  [32196] = { -- Brilliant Crimson Spinel
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [32199] = { -- Flashing Crimson Spinel
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [33131] = { -- Crimson Sun
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 12,},
    requirements = {},
  },
  [33133] = { -- Don Julio's Heart
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 12,},
    requirements = {},
  },
  [33134] = { -- Kailee's Rose
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 12,},
    requirements = {},
  },
  [35487] = { -- Delicate Crimson Spinel
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {["level"] = 68,},
  },
  [35488] = { -- Brilliant Crimson Spinel
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {["level"] = 68,},
  },
  [24027] = { -- Bold Living Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 8,},
    requirements = {},
  },
  [24028] = { -- Delicate Living Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 8,},
    requirements = {},
  },
  [24030] = { -- Brilliant Living Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 8,},
    requirements = {},
  },
  [24036] = { -- Flashing Living Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [39900] = { -- Bold Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 6,},
    requirements = {},
  },
  [39905] = { -- Delicate Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 6,},
    requirements = {},
  },
  [39908] = { -- Flashing Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [39910] = { -- Precise Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [39912] = { -- Brilliant Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 6,},
    requirements = {},
  },
  [41432] = { -- Perfect Bold Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 7,},
    requirements = {},
  },
  [41434] = { -- Perfect Delicate Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 7,},
    requirements = {},
  },
  [41435] = { -- Perfect Flashing Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [41437] = { -- Perfect Precise Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [41444] = { -- Perfect Brilliant Bloodstone
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 7,},
    requirements = {},
  },
  [32200] = { -- Solid Empyrean Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 15,},
    requirements = {},
  },
  [32201] = { -- Sparkling Empyrean Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 20,},
    requirements = {},
  },
  [32203] = { -- Stormy Empyrean Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 10,},
    requirements = {},
  },
  [32206] = { -- Rigid Empyrean Sapphire
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [33135] = { -- Falling Star
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 18,},
    requirements = {},
  },
  [34256] = { -- Charmed Amani Jewel
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 15,},
    requirements = {},
  },
  [24033] = { -- Solid Star of Elune
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 12,},
    requirements = {},
  },
  [24035] = { -- Sparkling Star of Elune
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 16,},
    requirements = {},
  },
  [24039] = { -- Stormy Star of Elune
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 8,},
    requirements = {},
  },
  [24051] = { -- Rigid Star of Elune
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [34831] = { -- Eye of the Sea
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 15,},
    requirements = {},
  },
  [39915] = { -- Rigid Chalcedony
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [39919] = { -- Solid Chalcedony
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 9,},
    requirements = {},
  },
  [39927] = { -- Sparkling Chalcedony
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 12,},
    requirements = {},
  },
  [39932] = { -- Stormy Chalcedony
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 6,},
    requirements = {},
  },
  [41440] = { -- Perfect Sparkling Chalcedony
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 14,},
    requirements = {},
  },
  [41441] = { -- Perfect Solid Chalcedony
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 11,},
    requirements = {},
  },
  [41443] = { -- Perfect Stormy Chalcedony
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 7,},
    requirements = {},
  },
  [41447] = { -- Perfect Rigid Chalcedony
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [32198] = { -- Subtle Lionseye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [32205] = { -- Smooth Lionseye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [32209] = { -- Mystic Lionseye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [33140] = { -- Blood of Amber
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 24,},
    requirements = {},
  },
  [33143] = { -- Stone of Blades
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 24,},
    requirements = {},
  },
  [33144] = { -- Facet of Eternity
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 24,},
    requirements = {},
  },
  [35761] = { -- Quick Lionseye
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 20,},
    requirements = {},
  },
  [24032] = { -- Subtle Dawnstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [24048] = { -- Smooth Dawnstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [24053] = { -- Mystic Dawnstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [35315] = { -- Quick Dawnstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 16,},
    requirements = {},
  },
  [39907] = { -- Subtle Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39909] = { -- Smooth Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [39916] = { -- Subtle Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [39917] = { -- Mystic Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39918] = { -- Quick Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [41436] = { -- Perfect Smooth Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [41439] = { -- Perfect Subtle Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [41445] = { -- Perfect Mystic Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [41446] = { -- Perfect Quick Sun Crystal
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 14,},
    requirements = {},
  },
  [30546] = { -- Sovereign Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [30549] = { -- Shifting Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30552] = { -- Timeless Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30553] = { -- Glinting Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [30555] = { -- Timeless Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30556] = { -- Glinting Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [30559] = { -- Etched Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [30564] = { -- Veiled Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [30566] = { -- Defender's Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30572] = { -- Purified Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [30573] = { -- Mysterious Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [30574] = { -- Shifting Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [30583] = { -- Timeless Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30586] = { -- Purified Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 4,},
    requirements = {},
  },
  [30589] = { -- Purified Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 4,},
    requirements = {},
  },
  [30600] = { -- Purified Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 4,},
    requirements = {},
  },
  [30603] = { -- Purified Tanzanite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [31116] = { -- Timeless Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {["level"] = 70,},
  },
  [31117] = { -- Tireless Soothing Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {["level"] = 70,},
  },
  [31118] = { -- Sovereign Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {["level"] = 70,},
  },
  [32211] = { -- Sovereign Shadowsong Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [32212] = { -- Shifting Shadowsong Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 7,},
    requirements = {},
  },
  [32215] = { -- Timeless Shadowsong Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 7,},
    requirements = {},
  },
  [32220] = { -- Glinting Shadowsong Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [32221] = { -- Veiled Shadowsong Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [32225] = { -- Purified Shadowsong Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 10,},
    requirements = {},
  },
  [24054] = { -- Sovereign Nightseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [24055] = { -- Shifting Nightseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [24056] = { -- Timeless Nightseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [24061] = { -- Glinting Nightseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [24065] = { -- Purified Nightseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [31867] = { -- Veiled Nightseye
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [32634] = { -- Shifting Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [32635] = { -- Timeless Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [32636] = { -- Purified Amethyst
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 4,},
    requirements = {},
  },
  [39934] = { -- Sovereign Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [39935] = { -- Shifting Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [39939] = { -- Defender's Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [39940] = { -- Guardian's Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [39942] = { -- Glinting Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_CRIT_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39945] = { -- Mysterious Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_PVP_POWER_SHORT"] = 3,},
    requirements = {},
  },
  [39948] = { -- Etched Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [39957] = { -- Veiled Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [39966] = { -- Accurate Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_HASTE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39968] = { -- Timeless Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [39979] = { -- Purified Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_SPIRIT_SHORT"] = 6,},
    requirements = {},
  },
  [41450] = { -- Perfect Shifting Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [41451] = { -- Perfect Defender's Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [41452] = { -- Perfect Timeless Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [41453] = { -- Perfect Guardian's Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [41455] = { -- Perfect Mysterious Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [41461] = { -- Perfect Sovereign Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 5,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [41462] = { -- Perfect Glinting Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [41473] = { -- Perfect Purified Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 7,},
    requirements = {},
  },
  [41482] = { -- Perfect Accurate Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_HASTE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [41488] = { -- Perfect Etched Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [41502] = { -- Perfect Veiled Shadow Crystal
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [30548] = { -- Jagged Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30550] = { -- Misty Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [30560] = { -- Misty Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 5,["ITEM_MOD_SPIRIT_SHORT"] = 4,},
    requirements = {},
  },
  [30563] = { -- Regal Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30565] = { -- Jagged Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30575] = { -- Nimble Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_DODGE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [30590] = { -- Regal Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30592] = { -- Steady Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30594] = { -- Regal Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30601] = { -- Steady Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30602] = { -- Jagged Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [30605] = { -- Nimble Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_DODGE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [30606] = { -- Lightning Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_HASTE_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [30608] = { -- Radiant Chrysoprase
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 5,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [32223] = { -- Regal Seaspray Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 7,},
    requirements = {},
  },
  [32224] = { -- Radiant Seaspray Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_PVP_POWER_SHORT"] = 5,},
    requirements = {},
  },
  [32226] = { -- Jagged Seaspray Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STAMINA_SHORT"] = 7,},
    requirements = {},
  },
  [35758] = { -- Steady Seaspray Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 7,},
    requirements = {},
  },
  [35759] = { -- Forceful Seaspray Emerald
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 5,["ITEM_MOD_STAMINA_SHORT"] = 7,},
    requirements = {},
  },
  [24066] = { -- Radiant Talasite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [24067] = { -- Jagged Talasite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [32639] = { -- Jagged Mossjewel
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 4,},
    requirements = {},
  },
  [33782] = { -- Steady Talasite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [35318] = { -- Forceful Talasite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [35707] = { -- Regal Talasite
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [39933] = { -- Jagged Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [39975] = { -- Nimble Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_DODGE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39976] = { -- Regal Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [39977] = { -- Steady Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [39978] = { -- Forceful Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [39980] = { -- Misty Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_SPIRIT_SHORT"] = 6,},
    requirements = {},
  },
  [39981] = { -- Lightning Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_HASTE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39982] = { -- Turbid Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 3,["ITEM_MOD_SPIRIT_SHORT"] = 6,},
    requirements = {},
  },
  [39983] = { -- Energized Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_SPIRIT_SHORT"] = 6,},
    requirements = {},
  },
  [39991] = { -- Radiant Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_PVP_POWER_SHORT"] = 3,},
    requirements = {},
  },
  [39992] = { -- Shattered Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_PVP_POWER_SHORT"] = 3,},
    requirements = {},
  },
  [41464] = { -- Perfect Regal Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [41466] = { -- Perfect Forceful Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [41467] = { -- Perfect Energized Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_SPIRIT_SHORT"] = 7,},
    requirements = {},
  },
  [41468] = { -- Perfect Jagged Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [41470] = { -- Perfect Misty Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_SPIRIT_SHORT"] = 7,},
    requirements = {},
  },
  [41474] = { -- Perfect Shattered Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [41475] = { -- Perfect Lightning Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_HASTE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [41476] = { -- Perfect Steady Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 5,},
    requirements = {},
  },
  [41478] = { -- Perfect Radiant Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_PVP_POWER_SHORT"] = 4,},
    requirements = {},
  },
  [41480] = { -- Perfect Turbid Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 7,},
    requirements = {},
  },
  [41481] = { -- Perfect Nimble Dark Jade
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_DODGE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [30547] = { -- Reckless Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 4,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [30551] = { -- Reckless Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 4,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [30554] = { -- Stalwart Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 4,["ITEM_MOD_PARRY_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [30558] = { -- Stalwart Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 4,["ITEM_MOD_PARRY_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [30581] = { -- Willful Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [30582] = { -- Deadly Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [30584] = { -- Inscribed Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [30585] = { -- Polished Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_DODGE_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [30587] = { -- Champion's Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [30588] = { -- Potent Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [30591] = { -- Lucent Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [30593] = { -- Potent Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [30604] = { -- Resplendent Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [30607] = { -- Splendid Fire Opal
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_PARRY_RATING_SHORT"] = 5,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [32217] = { -- Inscribed Pyrestone
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_STRENGTH_SHORT"] = 5,},
    requirements = {},
  },
  [32218] = { -- Potent Pyrestone
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [32222] = { -- Deadly Pyrestone
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [35760] = { -- Reckless Pyrestone
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 10,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [24058] = { -- Inscribed Noble Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [24059] = { -- Potent Noble Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [24060] = { -- Reckless Noble Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 8,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [31868] = { -- Deadly Noble Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [32637] = { -- Deadly Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [32638] = { -- Reckless Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 4,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [39947] = { -- Inscribed Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [39949] = { -- Champion's Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [39950] = { -- Resplendent Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 3,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [39951] = { -- Fierce Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [39952] = { -- Deadly Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_CRIT_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39954] = { -- Lucent Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 3,},
    requirements = {},
  },
  [39955] = { -- Deft Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_HASTE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39956] = { -- Potent Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [39958] = { -- Willful Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 3,},
    requirements = {},
  },
  [39959] = { -- Reckless Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [39965] = { -- Stalwart Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 6,["ITEM_MOD_PARRY_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [39967] = { -- Resolute Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 6,["ITEM_MOD_HASTE_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [41483] = { -- Perfect Champion's Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [41484] = { -- Perfect Deadly Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_CRIT_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [41485] = { -- Perfect Deft Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_HASTE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [41486] = { -- Perfect Willful Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [41489] = { -- Perfect Fierce Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [41490] = { -- Perfect Stalwart Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 7,["ITEM_MOD_PARRY_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [41492] = { -- Perfect Inscribed Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [41493] = { -- Perfect Lucent Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,},
    requirements = {},
  },
  [41495] = { -- Perfect Potent Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 7,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [41497] = { -- Perfect Reckless Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 7,["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [41498] = { -- Perfect Resolute Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 7,["ITEM_MOD_HASTE_RATING_SHORT"] = 7,},
    requirements = {},
  },
  [41499] = { -- Perfect Resplendent Huge Citrine
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [25890] = { -- Destructive Skyfire Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 28,},
    requirements = {},
  },
  [25894] = { -- Swift Skyfire Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 24,},
    requirements = {},
  },
  [25895] = { -- Enigmatic Skyfire Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 24,},
    requirements = {},
  },
  [25896] = { -- Powerful Earthstorm Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 18,},
    requirements = {},
  },
  [25897] = { -- Bracing Earthstorm Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 12,},
    requirements = {},
  },
  [25898] = { -- Tenacious Earthstorm Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 24,},
    requirements = {},
  },
  [25899] = { -- Brutal Earthstorm Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_DAMAGE_PER_SECOND_SHORT"] = 3,},
    requirements = {},
  },
  [25901] = { -- Insightful Earthstorm Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 12,},
    requirements = {},
  },
  [28556] = { -- Swift Windfire Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [28557] = { -- Quickened Starfire Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [32409] = { -- Relentless Earthstorm Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 12,},
    requirements = {},
  },
  [32640] = { -- Tense Unstable Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [32641] = { -- Imbued Unstable Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 12,},
    requirements = {},
  },
  [34220] = { -- Chaotic Skyfire Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 19,},
    requirements = {},
  },
  [35501] = { -- Eternal Earthstorm Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 24,},
    requirements = {},
  },
  [35503] = { -- Ember Skyfire Diamond
    colors = {"META"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 12,},
    requirements = {},
  },
  [22459] = { -- Void Sphere
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["RESISTANCE6_NAME"] = 4,["RESISTANCE2_NAME"] = 4,["RESISTANCE4_NAME"] = 4,["RESISTANCE1_NAME"] = 4,["RESISTANCE3_NAME"] = 4,["RESISTANCE5_NAME"] = 4,},
    requirements = {},
  },
  [22460] = { -- Prismatic Sphere
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["RESISTANCE6_NAME"] = 3,["RESISTANCE2_NAME"] = 3,["RESISTANCE4_NAME"] = 3,["RESISTANCE1_NAME"] = 3,["RESISTANCE3_NAME"] = 3,["RESISTANCE5_NAME"] = 3,},
    requirements = {},
  },
  [42701] = { -- Enchanted Pearl
    colors = {"RED", "BLUE", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 2,["ITEM_MOD_INTELLECT_SHORT"] = 2,["ITEM_MOD_SPIRIT_SHORT"] = 2,["ITEM_MOD_STAMINA_SHORT"] = 2,["ITEM_MOD_STRENGTH_SHORT"] = 2,},
    requirements = {},
  },
  [28118] = { -- Brilliant Ornate Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 10,},
    requirements = {},
  },
  [28362] = { -- Delicate Ornate Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {},
  },
  [38545] = { -- Delicate Ornate Ruby
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 10,},
    requirements = {},
  },
  [27777] = { -- Brilliant Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 7,},
    requirements = {["faction"] = 2,},
  },
  [27812] = { -- Brilliant Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 7,},
    requirements = {["faction"] = 1,},
  },
  [28360] = { -- Delicate Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 7,},
    requirements = {["faction"] = 2,},
  },
  [28361] = { -- Delicate Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 7,},
    requirements = {["faction"] = 1,},
  },
  [30571] = { -- Don Rodrigo's Heart
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 8,},
    requirements = {["faction"] = 2,},
  },
  [30598] = { -- Don Amancio's Heart
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 8,},
    requirements = {["faction"] = 1,},
  },
  [23094] = { -- Brilliant Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 6,},
    requirements = {},
  },
  [23095] = { -- Bold Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 6,},
    requirements = {},
  },
  [23096] = { -- Brilliant Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 7,},
    requirements = {},
  },
  [23097] = { -- Delicate Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 6,},
    requirements = {},
  },
  [23113] = { -- Brilliant Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 6,},
    requirements = {},
  },
  [28595] = { -- Delicate Blood Garnet
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 6,},
    requirements = {},
  },
  [23116] = { -- Rigid Azure Moonstone
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [23118] = { -- Solid Azure Moonstone
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 9,},
    requirements = {},
  },
  [23119] = { -- Sparkling Azure Moonstone
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 12,},
    requirements = {},
  },
  [23120] = { -- Stormy Azure Moonstone
    colors = {"BLUE"},
    stats = {["ITEM_MOD_PVP_POWER_SHORT"] = 6,},
    requirements = {},
  },
  [23121] = { -- Sparkling Azure Moonstone
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 12,},
    requirements = {},
  },
  [27679] = { -- Mystic Dawnstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_RESILIENCE_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [28119] = { -- Smooth Ornate Dawnstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [28120] = { -- Smooth Ornate Dawnstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [38546] = { -- Smooth Ornate Dawnstone
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 10,},
    requirements = {},
  },
  [23114] = { -- Smooth Golden Draenite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [23115] = { -- Subtle Golden Draenite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [28290] = { -- Smooth Golden Draenite
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 12,},
    requirements = {},
  },
  [32836] = { -- Purified Shadow Pearl
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [23100] = { -- Glinting Shadow Draenite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_CRIT_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [23108] = { -- Timeless Shadow Draenite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 4,},
    requirements = {},
  },
  [23109] = { -- Purified Shadow Draenite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_SPIRIT_SHORT"] = 6,},
    requirements = {},
  },
  [23110] = { -- Shifting Shadow Draenite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_STAMINA_SHORT"] = 4,},
    requirements = {},
  },
  [23111] = { -- Sovereign Shadow Draenite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 4,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [31866] = { -- Veiled Shadow Draenite
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [32833] = { -- Purified Jaggal Pearl
    colors = {"RED", "BLUE"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 3,["ITEM_MOD_SPIRIT_SHORT"] = 6,},
    requirements = {},
  },
  [27786] = { -- Jagged Deep Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 3,},
    requirements = {["faction"] = 2,},
  },
  [27809] = { -- Jagged Deep Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 4,["ITEM_MOD_STAMINA_SHORT"] = 3,},
    requirements = {["faction"] = 1,},
  },
  [23103] = { -- Radiant Deep Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_PVP_POWER_SHORT"] = 3,},
    requirements = {},
  },
  [23104] = { -- Jagged Deep Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 4,},
    requirements = {},
  },
  [23105] = { -- Regal Deep Peridot
    colors = {"BLUE", "YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 6,["ITEM_MOD_STAMINA_SHORT"] = 4,},
    requirements = {},
  },
  [28123] = { -- Potent Ornate Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 5,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [28363] = { -- Deadly Ornate Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [38547] = { -- Deadly Ornate Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 5,["ITEM_MOD_CRIT_RATING_SHORT"] = 5,},
    requirements = {},
  },
  [38548] = { -- Potent Ornate Topaz
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 5,["ITEM_MOD_INTELLECT_SHORT"] = 5,},
    requirements = {},
  },
  [23098] = { -- Inscribed Flame Spessarite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_STRENGTH_SHORT"] = 3,},
    requirements = {},
  },
  [23099] = { -- Reckless Flame Spessarite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_HASTE_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [23101] = { -- Potent Flame Spessarite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 6,["ITEM_MOD_INTELLECT_SHORT"] = 3,},
    requirements = {},
  },
  [31869] = { -- Deadly Flame Spessarite
    colors = {"RED", "YELLOW"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 3,["ITEM_MOD_CRIT_RATING_SHORT"] = 6,},
    requirements = {},
  },
  [28458] = { -- Bold Tourmaline
    colors = {"RED"},
    stats = {["ITEM_MOD_STRENGTH_SHORT"] = 4,},
    requirements = {},
  },
  [28459] = { -- Delicate Tourmaline
    colors = {"RED"},
    stats = {["ITEM_MOD_AGILITY_SHORT"] = 4,},
    requirements = {},
  },
  [28461] = { -- Brilliant Tourmaline
    colors = {"RED"},
    stats = {["ITEM_MOD_INTELLECT_SHORT"] = 4,},
    requirements = {},
  },
  [28463] = { -- Solid Zircon
    colors = {"BLUE"},
    stats = {["ITEM_MOD_STAMINA_SHORT"] = 6,},
    requirements = {},
  },
  [28464] = { -- Sparkling Zircon
    colors = {"BLUE"},
    stats = {["ITEM_MOD_SPIRIT_SHORT"] = 8,},
    requirements = {},
  },
  [28468] = { -- Rigid Zircon
    colors = {"BLUE"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [28467] = { -- Smooth Amber
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_CRIT_RATING_SHORT"] = 8,},
    requirements = {},
  },
  [28470] = { -- Subtle Amber
    colors = {"YELLOW"},
    stats = {["ITEM_MOD_DODGE_RATING_SHORT"] = 8,},
    requirements = {},
  },
}
