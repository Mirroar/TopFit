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



-- handle enchants that could not be parsed completely and have no applicable stats anyway
ns.enchantIDs[  BACK][2621].couldNotParse = nil -- Enchant Cloak - Subtlety
ns.enchantIDs[WEAPON][4443].couldNotParse = nil -- Enchant Weapon - Elemental Force
ns.enchantIDs[WEAPON][4445].couldNotParse = nil -- Enchant Weapon - Colossus
ns.enchantIDs[WEAPON][4066].couldNotParse = nil -- Enchant Weapon - Mending
ns.enchantIDs[WEAPON][5331].couldNotParse = nil -- Enchant Weapon - Mark of the Shattered Hand
ns.enchantIDs[WEAPON][4067].couldNotParse = nil -- Enchant Weapon - Avalanche
ns.enchantIDs[WEAPON][4074].couldNotParse = nil -- Enchant Weapon - Elemental Slayer
ns.enchantIDs[WEAPON][3239].couldNotParse = nil -- Enchant Weapon - Icebreaker
ns.enchantIDs[WEAPON][3241].couldNotParse = nil -- Enchant Weapon - Lifeward
ns.enchantIDs[WEAPON][3247].couldNotParse = nil -- Enchant 2H Weapon - Scourgebane
ns.enchantIDs[WEAPON][3251].couldNotParse = nil -- Enchant Weapon - Giant Slayer
ns.enchantIDs[WEAPON][3273].couldNotParse = nil -- Enchant Weapon - Deathfrost
ns.enchantIDs[WEAPON][2671].couldNotParse = nil -- Enchant Weapon - Sunfire
ns.enchantIDs[WEAPON][2672].couldNotParse = nil -- Enchant Weapon - Soulfrost
ns.enchantIDs[WEAPON][2674].couldNotParse = nil -- Enchant Weapon - Spellsurge
ns.enchantIDs[WEAPON][2675].couldNotParse = nil -- Enchant Weapon - Battlemaster
ns.enchantIDs[WEAPON][ 249].couldNotParse = nil -- Enchant Weapon - Minor Beastslayer
ns.enchantIDs[WEAPON][ 250].couldNotParse = nil -- Enchant Weapon - Minor Striking
ns.enchantIDs[WEAPON][ 853].couldNotParse = nil -- Enchant Weapon - Lesser Beastslayer
ns.enchantIDs[WEAPON][ 854].couldNotParse = nil -- Enchant Weapon - Lesser Elemental Slayer
ns.enchantIDs[WEAPON][ 803].couldNotParse = nil -- Enchant Weapon - Fiery Weapon
ns.enchantIDs[WEAPON][ 912].couldNotParse = nil -- Enchant Weapon - Demonslaying
ns.enchantIDs[WEAPON][1894].couldNotParse = nil -- Enchant Weapon - Icy Chill
ns.enchantIDs[WEAPON][1898].couldNotParse = nil -- Enchant Weapon - Lifestealing
ns.enchantIDs[WEAPON][1899].couldNotParse = nil -- Enchant Weapon - Unholy Weapon
ns.enchantIDs[WEAPON][2443].couldNotParse = nil -- Enchant Weapon - Winter's Might
ns.enchantIDs[WEAPON][3869].couldNotParse = nil -- Enchant Weapon - Blade Ward -- this grants parry, but difficult to say how much on average
ns.enchantIDs[WEAPON][3870].couldNotParse = nil -- Enchant Weapon - Blood Draining

-- handle enchants that could not be parsed automatically but still have useful stats
ns.enchantIDs[WEAPON][4441].couldNotParse = nil -- Enchant Weapon - Windsong
ns.enchantIDs[WEAPON][4441].stats = {ITEM_MOD_CRIT_RATING_SHORT = 10, ITEM_MOD_HASTE_RATING_SHORT = 10, ITEM_MOD_MASTERY_RATING_SHORT = 10} -- sometimes increase your critical strike, haste, or mastery by 75 for 12 - 2 RPPM

ns.enchantIDs[WEAPON][4444].couldNotParse = nil -- Enchant Weapon - Dancing Steel
ns.enchantIDs[WEAPON][4444].stats = {ITEM_MOD_AGILITY_SHORT = 47.38, ITEM_MOD_STRENGTH_SHORT = 47.38} -- sometimes increase your Strength or Agility by 103 for 12 sec. Your highest stat is always chosen. - 2.3 RPPM

ns.enchantIDs[WEAPON][5125].couldNotParse = nil -- Enchant Weapon - Bloody Dancing Steel
ns.enchantIDs[WEAPON][5125].stats = {ITEM_MOD_AGILITY_SHORT = 47.38, ITEM_MOD_STRENGTH_SHORT = 47.38} -- sometimes increase your Strength or Agility by 103 for 12 sec. Your highest stat is always chosen. - 2.3 RPPM

ns.enchantIDs[WEAPON][5337].couldNotParse = nil -- Enchant Weapon - Mark of Warsong
ns.enchantIDs[WEAPON][5337].stats = {ITEM_MOD_HASTE_RATING_SHORT = 210.83} -- sometimes increase haste by (100 * 10), diminishing by 10% every 2 sec. - 1.15 RPPM

ns.enchantIDs[WEAPON][5355].couldNotParse = nil -- Enchant Weapon - Glory of Warsong
ns.enchantIDs[WEAPON][5355].stats = {ITEM_MOD_HASTE_RATING_SHORT = 210.83} -- sometimes increase haste by (100 * 10), diminishing by 10% every 2 sec. - 1.15 RPPM

ns.enchantIDs[WEAPON][5334].couldNotParse = nil -- Enchant Weapon - Mark of the Frostwolf
ns.enchantIDs[WEAPON][5334].stats = {ITEM_MOD_CR_MULTISTRIKE_SHORT = 150} -- sometimes increases multistrike by 500 for 6 sec - 3 RPPM +USP

ns.enchantIDs[WEAPON][5356].couldNotParse = nil -- Enchant Weapon - Glory of the Frostwolf
ns.enchantIDs[WEAPON][5356].stats = {ITEM_MOD_CR_MULTISTRIKE_SHORT = 150} -- sometimes increases multistrike by 500 for 6 sec - 3 RPPM +USP

ns.enchantIDs[WEAPON][3225].couldNotParse = nil -- Enchant Weapon - Glory of the Frostwolf
ns.enchantIDs[WEAPON][3225].stats = {ITEM_MOD_CRIT_RATING_SHORT = 15} -- occasionally grant you 60 critical strike - assuming 15s and 1PPM

ns.enchantIDs[SHOULDER][2483].couldNotParse = nil -- Flame Mantle of the Dawn
ns.enchantIDs[SHOULDER][2483].stats = {RESISTANCE2_NAME = 5}

ns.enchantIDs[SHOULDER][2484].couldNotParse = nil -- Frost Mantle of the Dawn
ns.enchantIDs[SHOULDER][2484].stats = {RESISTANCE4_NAME = 5}

ns.enchantIDs[SHOULDER][2485].couldNotParse = nil -- Arcane Mantle of the Dawn
ns.enchantIDs[SHOULDER][2485].stats = {RESISTANCE6_NAME = 5}

ns.enchantIDs[SHOULDER][2486].couldNotParse = nil -- Nature Mantle of the Dawn
ns.enchantIDs[SHOULDER][2486].stats = {RESISTANCE3_NAME = 5}

ns.enchantIDs[SHOULDER][2487].couldNotParse = nil -- Shadow Mantle of the Dawn
ns.enchantIDs[SHOULDER][2487].stats = {RESISTANCE5_NAME = 5}

--[[

4882 - 27 sta, 10 dodge
3368 - DK Rune of Crusader
4881 - 18str, 10 crit on legs




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