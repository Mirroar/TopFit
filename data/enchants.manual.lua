local addonName, ns = ...

-- slot IDs for better readability
local NECK     =  2
local SHOULDER =  3
local CHEST    =  5
local LEGS     =  7
local FEET     =  8
local WRISTS   =  9
local HANDS    = 10
local RING     = 11
local BACK     = 15
local WEAPON   = 16
local OFFHAND  = 17



-- handle enchants that could not be parsed completely, but have no applicable stats anyway
ns.enchantIDs[  BACK][2621].couldNotParse = nil -- Enchant Cloak - Subtlety
ns.enchantIDs[WEAPON][4443].couldNotParse = nil -- Enchant Weapon - Elemental Force
ns.enchantIDs[WEAPON][4445].couldNotParse = nil -- Enchant Weapon - Colossus
ns.enchantIDs[WEAPON][4066].couldNotParse = nil -- Enchant Weapon - Mending



-- handle enchants with special effects
ns.enchantIDs[WEAPON][5331].couldNotParse = nil -- Enchant Weapon - Mark of the Shattered Hand
ns.enchantIDs[WEAPON][5331].stats = {ITEM_MOD_DAMAGE_PER_SECOND_SHORT = 350} --Deals 1500 Bleed damage, plus an additional 750 Bleed damage every 1 sec for 6 sec.; 3.5*Haste RPPM +USP - probably weaker than 350 DPS because it does not benefit from weapon skills

ns.enchantIDs[WEAPON][4441].couldNotParse = nil -- Enchant Weapon - Windsong
ns.enchantIDs[WEAPON][4441].stats = {ITEM_MOD_CRIT_RATING_SHORT = 10, ITEM_MOD_HASTE_RATING_SHORT = 10, ITEM_MOD_MASTERY_RATING_SHORT = 10} -- sometimes increase your critical strike, haste, or mastery by 75 for 12 - 2 RPPM

ns.enchantIDs[WEAPON][4444].couldNotParse = nil -- Enchant Weapon - Dancing Steel
ns.enchantIDs[WEAPON][4444].stats = {ITEM_MOD_AGILITY_SHORT = 47.38, ITEM_MOD_STRENGTH_SHORT = 47.38}
-- sometimes increase your Strength or Agility by 103 for 12 sec. Your highest stat is always chosen. - 2.3 RPPM



--[[



    [5337] = { -- Enchant Weapon - Mark of Warsong
      itemID = 112164,
      spellID = 159671,
      couldNotParse = true,
      stats = {},
    },
    [5334] = { -- Enchant Weapon - Mark of the Frostwolf
      itemID = 112165,
      spellID = 159672,
      couldNotParse = true,
      stats = {},
    },
    [5355] = { -- Enchant Weapon - Glory of the Warsong
      itemID = 115977,
      spellID = 170630,
      couldNotParse = true,
      stats = {},
    },
    [5356] = { -- Enchant Weapon - Glory of the Frostwolf
      itemID = 115978,
      spellID = 170631,
      couldNotParse = true,
      stats = {},
    },
    [5125] = { -- Enchant Weapon - Bloody Dancing Steel
      itemID = 98163,
      spellID = 142468,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [4067] = { -- Enchant Weapon - Avalanche
      itemID = 52748,
      spellID = 74197,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [4074] = { -- Enchant Weapon - Elemental Slayer
      itemID = 52755,
      spellID = 74211,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [3225] = { -- Enchant Weapon - Executioner
      itemID = 38948,
      spellID = 42974,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },

    [3239] = { -- Enchant Weapon - Icebreaker
      itemID = 38965,
      spellID = 44524,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [3241] = { -- Enchant Weapon - Lifeward
      itemID = 38972,
      spellID = 44576,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [3247] = { -- Enchant 2H Weapon - Scourgebane
      itemID = 38981,
      spellID = 44595,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [3251] = { -- Enchant Weapon - Giant Slayer
      itemID = 38988,
      spellID = 44621,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [3273] = { -- Enchant Weapon - Deathfrost
      itemID = 38998,
      spellID = 46578,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2671] = { -- Enchant Weapon - Sunfire
      itemID = 38923,
      spellID = 27981,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2672] = { -- Enchant Weapon - Soulfrost
      itemID = 38924,
      spellID = 27982,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2674] = { -- Enchant Weapon - Spellsurge
      itemID = 38926,
      spellID = 28003,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2675] = { -- Enchant Weapon - Battlemaster
      itemID = 38927,
      spellID = 28004,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [249] = { -- Enchant Weapon - Minor Beastslayer
      itemID = 38779,
      spellID = 7786,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [250] = { -- Enchant Weapon - Minor Striking
      itemID = 38780,
      spellID = 7788,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [853] = { -- Enchant Weapon - Lesser Beastslayer
      itemID = 38813,
      spellID = 13653,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [854] = { -- Enchant Weapon - Lesser Elemental Slayer
      itemID = 38814,
      spellID = 13655,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [803] = { -- Enchant Weapon - Fiery Weapon
      itemID = 38838,
      spellID = 13898,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [912] = { -- Enchant Weapon - Demonslaying
      itemID = 38840,
      spellID = 13915,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [1894] = { -- Enchant Weapon - Icy Chill
      itemID = 38868,
      spellID = 20029,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [1898] = { -- Enchant Weapon - Lifestealing
      itemID = 38871,
      spellID = 20032,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [1899] = { -- Enchant Weapon - Unholy Weapon
      itemID = 38872,
      spellID = 20033,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2443] = { -- Enchant Weapon - Winter's Might
      itemID = 38876,
      spellID = 21931,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [3869] = { -- Enchant Weapon - Blade Ward
      itemID = 46026,
      spellID = 64441,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [3870] = { -- Enchant Weapon - Blood Draining
      itemID = 46098,
      spellID = 64579,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },








    [2483] = { -- Flame Mantle of the Dawn
      itemID = 18169,
      spellID = 22593,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2484] = { -- Frost Mantle of the Dawn
      itemID = 18170,
      spellID = 22594,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2485] = { -- Arcane Mantle of the Dawn
      itemID = 18171,
      spellID = 22598,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2486] = { -- Nature Mantle of the Dawn
      itemID = 18172,
      spellID = 22597,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2487] = { -- Shadow Mantle of the Dawn
      itemID = 18173,
      spellID = 22596,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },




    [2583] = { -- Presence of Might
      itemID = 19782,
      spellID = 24149,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2584] = { -- Syncretist's Sigil
      itemID = 19783,
      spellID = 24160,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [3754] = { -- Falcon's Call
      itemID = 19785,
      spellID = 24162,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2590] = { -- Prophetic Aura
      itemID = 19789,
      spellID = 24167,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2591] = { -- Animist's Caress
      itemID = 19790,
      spellID = 24168,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2681] = { -- Savage Guard
      itemID = 22635,
      spellID = 28161,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2682] = { -- Ice Guard
      itemID = 22636,
      spellID = 28163,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2683] = { -- Shadow Guard
      itemID = 22638,
      spellID = 28165,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },





    [10] = { -- Enchant Chest - Minor Absorption
      itemID = 38767,
      spellID = 7426,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [25] = { -- Enchant Chest - Lesser Absorption
      itemID = 38798,
      spellID = 13538,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [4428] = { -- Enchant Boots - Blurred Speed
      itemID = 74717,
      spellID = 104409,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [4429] = { -- Enchant Boots - Pandaren's Step
      itemID = 74718,
      spellID = 104414,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },








    [2658] = { -- Enchant Boots - Surefooted
      itemID = 38910,
      spellID = 27954,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },




    [2613] = { -- Enchant Gloves - Threat
      itemID = 38885,
      spellID = 25072,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2614] = { -- Enchant Gloves - Shadow Power
      itemID = 38886,
      spellID = 25073,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2615] = { -- Enchant Gloves - Frost Power
      itemID = 38887,
      spellID = 25074,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },
    [2616] = { -- Enchant Gloves - Fire Power
      itemID = 38888,
      spellID = 25078,
      couldNotParse = true,
      stats = {},
      requirements = {["max_ilevel"] = 600,},
    },


    + unknowns

--]]