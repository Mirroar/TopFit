local addonName, ns, _ = ...

TOPFIT_ARMORTYPE_CLOTH = GetItemSubClassInfo(LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_CLOTH)
TOPFIT_ARMORTYPE_LEATHER = GetItemSubClassInfo(LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_LEATHER)
TOPFIT_ARMORTYPE_MAIL = GetItemSubClassInfo(LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_MAIL)
TOPFIT_ARMORTYPE_PLATE = GetItemSubClassInfo(LE_ITEM_CLASS_ARMOR, LE_ITEM_ARMOR_PLATE)

TOPFIT_MELEE_WEAPON_SPEED  = MELEE.." "..WEAPON_SPEED
TOPFIT_RANGED_WEAPON_SPEED = RANGED.." "..WEAPON_SPEED
TOPFIT_MELEE_DPS           = MELEE.." "..ITEM_MOD_DAMAGE_PER_SECOND_SHORT
TOPFIT_RANGED_DPS          = RANGED.." "..ITEM_MOD_DAMAGE_PER_SECOND_SHORT
TOPFIT_SECONDARY_PERCENT   = ns.locale.SecondaryPercentBonus

TOPFIT_ITEM_MOD_MAINHAND = _G.INVTYPE_WEAPONMAINHAND
TOPFIT_ITEM_MOD_OFFHAND  = _G.INVTYPE_WEAPONOFFHAND

TOPFIT_PRIMARY_STAT = _G.SPEC_FRAME_PRIMARY_STAT:gsub(':.+', '')

-- list of inventory slot names
ns.slotList = {
	--"AmmoSlot",
	"BackSlot",
	"ChestSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"HandsSlot",
	"HeadSlot",
	"LegsSlot",
	"MainHandSlot",
	"NeckSlot",
	-- "RangedSlot",
	"SecondaryHandSlot",
	"ShirtSlot",
	"ShoulderSlot",
	"TabardSlot",
	"Trinket0Slot",
	"Trinket1Slot",
	"WaistSlot",
	"WristSlot",
}

-- create list of slot names with corresponding slot IDs
ns.slots = {}
ns.slotNames = {}
for _, slotName in pairs(ns.slotList) do
	local slotID, _, _ = GetInventorySlotInfo(slotName)
	ns.slots[slotName] = slotID;
	ns.slotNames[slotID] = slotName;
end

ns.armoredSlots = {
	[_G.INVSLOT_HEAD] = true,
	[_G.INVSLOT_SHOULDER] = true,
	[_G.INVSLOT_CHEST] = true,
	[_G.INVSLOT_WAIST] = true,
	[_G.INVSLOT_LEGS] = true,
	[_G.INVSLOT_FEET] = true,
	[_G.INVSLOT_WRIST] = true,
	[_G.INVSLOT_HAND] = true,
}

-- list of weight categories and stats
ns.statList = {
	-- STAT_CATEGORY_RANGED
	[_G.STAT_CATEGORY_ATTRIBUTES] = {
		"ITEM_MOD_AGILITY_SHORT",
		"ITEM_MOD_INTELLECT_SHORT",
		"ITEM_MOD_STAMINA_SHORT",
		"ITEM_MOD_STRENGTH_SHORT",
	},
	[_G.STAT_CATEGORY_MELEE] = {
		-- "ITEM_MOD_ATTACK_POWER_SHORT",
		-- "ITEM_MOD_EXPERTISE_RATING_SHORT",
		"ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
		"ITEM_MOD_MELEE_ATTACK_POWER_SHORT",
		"ITEM_MOD_RANGED_ATTACK_POWER_SHORT",
		"ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
		"TOPFIT_MELEE_DPS",
		"TOPFIT_RANGED_DPS",
		"TOPFIT_MELEE_WEAPON_SPEED",
		"TOPFIT_RANGED_WEAPON_SPEED",
	},
	[_G.STAT_CATEGORY_SPELL] = {
		"ITEM_MOD_SPELL_PENETRATION_SHORT",
		"ITEM_MOD_SPELL_POWER_SHORT",
	},
	[_G.STAT_CATEGORY_DEFENSE] = {
		-- "ITEM_MOD_BLOCK_RATING_SHORT",
		-- "ITEM_MOD_DODGE_RATING_SHORT",
		-- "ITEM_MOD_PARRY_RATING_SHORT",
		"ITEM_MOD_CR_AVOIDANCE_SHORT",
		"RESISTANCE0_NAME", -- armor
		"ITEM_MOD_EXTRA_ARMOR_SHORT",
		"ITEM_MOD_RESILIENCE_RATING_SHORT",
	},
	[_G.STAT_CATEGORY_GENERAL] = {
		"ITEM_MOD_CRIT_RATING_SHORT",
		"ITEM_MOD_HASTE_RATING_SHORT",
		"ITEM_MOD_MASTERY_RATING_SHORT",
		"ITEM_MOD_PVP_POWER_SHORT",
		"ITEM_MOD_VERSATILITY",
		"ITEM_MOD_CR_LIFESTEAL_SHORT",
		"ITEM_MOD_CR_STURDINESS_SHORT",
		"ITEM_MOD_CR_SPEED_SHORT",
	},
	[_G.STAT_CATEGORY_RESISTANCE] = {
		"RESISTANCE1_NAME", -- holy
		"RESISTANCE2_NAME", -- fire
		"RESISTANCE3_NAME", -- nature
		"RESISTANCE4_NAME", -- frost
		"RESISTANCE5_NAME", -- shadow
		"RESISTANCE6_NAME", -- arcane
	},
	--[[ [ns.locale.StatsCategoryArmorTypes] = {
		"TOPFIT_ARMORTYPE_CLOTH",
		"TOPFIT_ARMORTYPE_LEATHER",
		"TOPFIT_ARMORTYPE_MAIL",
		"TOPFIT_ARMORTYPE_PLATE",
	}]]
	-- TODO: empty sockets
	-- TODO: mainhand / offhand dps + speed
	-- @todo Weapon types (e.g. fist, 2h, 1h+shield)
}
