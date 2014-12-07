local addonName, ns, _ = ...

-- GLOBALS: TopFit, GameFontNormalSmall, GameFontHighlightSmall, GameFontNormalLarge
-- GLOBALS: CreateFrame, GetTime
-- GLOBALS: string, tostring, pairs, gsub, tonumber, strfind

--[[
	TODO: Parse caps from AMR
		CriticalStrike < 33.33%   2.70
		CriticalStrike 33.33% +   2.00
--]]

-- this table maps Pawn/AMR stat names to topfit stats
local globalString = {
	-- primary stats
	Agility           = 'ITEM_MOD_AGILITY_SHORT',
	Intellect         = 'ITEM_MOD_INTELLECT_SHORT',
	Stamina           = 'ITEM_MOD_STAMINA_SHORT',
	Strength          = 'ITEM_MOD_STRENGTH_SHORT',

	-- secondary stats
	BonusArmor        = 'ITEM_MOD_EXTRA_ARMOR_SHORT',
	CriticalStrike    = 'ITEM_MOD_CRIT_RATING_SHORT', -- AMR
	CritRating        = 'ITEM_MOD_CRIT_RATING_SHORT', -- Pawn
	Haste             = 'ITEM_MOD_HASTE_RATING_SHORT', -- AMR
	HasteRating       = 'ITEM_MOD_HASTE_RATING_SHORT', -- Pawn
	Mastery           = 'ITEM_MOD_MASTERY_RATING_SHORT', -- AMR
	MasteryRating     = 'ITEM_MOD_MASTERY_RATING_SHORT', -- Pawn
	Multistrike       = 'ITEM_MOD_CR_MULTISTRIKE_SHORT',
	Spirit            = 'ITEM_MOD_SPIRIT_SHORT',
	Versatility       = 'ITEM_MOD_VERSATILITY',

	-- tertiary stats
	Amplify           = 'ITEM_MOD_CR_AMPLIFY_SHORT', -- nyi by pawn
	Avoidance         = 'ITEM_MOD_CR_AVOIDANCE_SHORT',
	Cleave            = 'ITEM_MOD_CR_CLEAVE_SHORT', -- nyi by pawn
	Indestructible    = 'ITEM_MOD_CR_STURDINESS_SHORT',
	Leech             = 'ITEM_MOD_CR_LIFESTEAL_SHORT',
	MovementSpeed     = 'ITEM_MOD_CR_SPEED_SHORT',

	-- meta stats
	MainHandDps       = 'TOPFIT_MELEE_DPS', -- AMR
	-- OffHandDps        = 'TOPFIT_MELEE_DPS', -- AMR
	MeleeDps          = 'TOPFIT_MELEE_DPS',
	RangedDps         = 'TOPFIT_RANGED_DPS',
	Dps               = 'ITEM_MOD_DAMAGE_PER_SECOND_SHORT',
	Ap                = 'ITEM_MOD_ATTACK_POWER_SHORT', -- Pawn
	AttackPower       = 'ITEM_MOD_ATTACK_POWER_SHORT', -- AMR
	SpellPower        = 'ITEM_MOD_SPELL_POWER_SHORT',
	Armor             = 'RESISTANCE0_NAME',
	Speed             = nil, -- weapon speed, in seconds per swing; fast weapons -> use negative score!
	Health            = 'ITEM_MOD_HEALTH_SHORT',
	Mana              = 'ITEM_MOD_MANA_SHORT',

	-- pvp
	SpellPenetration  = 'ITEM_MOD_SPELL_PENETRATION_SHORT',
	ResilienceRating  = 'ITEM_MOD_RESILIENCE_RATING_SHORT',

	-- deprecated
	ArmorPenetration  = 'ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT',
	Hp5               = 'ITEM_MOD_HEALTH_REGENERATION_SHORT',
	Mp5               = 'ITEM_MOD_MANA_REGENERATION_SHORT',
	Rap               = nil, -- ranged attack power
	FeralAp           = 'ITEM_MOD_FERAL_ATTACK_POWER_SHORT',
	HitRating         = 'ITEM_MOD_HIT_RATING_SHORT',
	ExpertiseRating   = 'ITEM_MOD_EXPERTISE_RATING_SHORT',
	IsThrown          = nil,
	BlockValue        = 'ITEM_MOD_BLOCK_VALUE_SHORT',
	BlockRating       = 'ITEM_MOD_BLOCK_RATING_SHORT',
	DefenseRating     = 'ITEM_MOD_DEFENSE_SKILL_RATING_SHORT',
	DodgeRating       = 'ITEM_MOD_DODGE_RATING_SHORT',
	ParryRating       = 'ITEM_MOD_PARRY_RATING_SHORT',

	-- sockets
	RedSocket         = nil,
	YellowSocket      = nil,
	BlueSocket        = nil,
	MetaSocket        = nil,
	MetaSocketEffect  = nil,

	-- AllResist
	FireSpellDamage   = nil,
	ShadowSpellDamage = nil,
	NatureSpellDamage = nil,
	ArcaneSpellDamage = nil,
	FrostSpellDamage  = nil,
	HolySpellDamage   = nil,
	HolyResist        = 'RESISTANCE1_NAME',
	FireResist        = 'RESISTANCE2_NAME',
	NatureResist      = 'RESISTANCE3_NAME',
	FrostResist       = 'RESISTANCE4_NAME',
	ShadowResist      = 'RESISTANCE5_NAME',
	ArcaneResist      = 'RESISTANCE6_NAME',

	-- armor types
	IsCloth           = 'TOPFIT_ARMORTYPE_CLOTH',
	IsLeather         = 'TOPFIT_ARMORTYPE_LEATHER',
	IsMail            = 'TOPFIT_ARMORTYPE_MAIL',
	IsPlate           = 'TOPFIT_ARMORTYPE_PLATE',

	-- item types
	IsShield          = nil,
	IsAxe             = nil,
	Is2HAxe           = nil,
	IsBow             = nil,
	IsCrossbow        = nil,
	IsDagger          = nil,
	IsFist            = nil,
	IsGun             = nil,
	IsMace            = nil,
	Is2HMace          = nil,
	IsPolearm         = nil,
	IsStaff           = nil,
	IsSword           = nil,
	Is2HSword         = nil,
	IsWand            = nil,
	IsOffHand         = nil,
	IsFrill           = nil,

	-- advanced but unused stats
	BaseArmor         = nil,
	MinDamage         = nil,
	MaxDamage         = nil,
	MeleeMinDamage    = nil,
	MeleeMaxDamage    = nil,
	MeleeSpeed        = nil,
	RangedMinDamage   = nil,
	RangedMaxDamage   = nil,
	RangedSpeed       = nil,
	MainHandDps       = nil,
	MainHandMinDamage = nil,
	MainHandMaxDamage = nil,
	MainHandSpeed     = nil,
	OffHandDps        = nil,
	OffHandMinDamage  = nil,
	OffHandMaxDamage  = nil,
	OffHandSpeed      = nil,
	OneHandDps        = nil,
	OneHandMinDamage  = nil,
	OneHandMaxDamage  = nil,
	OneHandSpeed      = nil,
	TwoHandDps        = nil,
	TwoHandMinDamage  = nil,
	TwoHandMaxDamage  = nil,
	TwoHandSpeed      = nil,
	SpeedBaseline     = nil, -- this number is subtracted from the Speed stat before multiplying it by the scale value
}
local function GetInverseStat(stat)
	for pawnStat, globalStat in pairs(globalString) do
		if globalStat == stat then
			return pawnStat
		end
	end
end


-- takes a string and filteres any stats + stat weights it finds
-- e.g.( Pawn: v1: "SetName": Intellect=A, RangedDps=B )
local function ParsePawn(importString)
	local found, _, version, setName, weights = importString:find('^%s*%(%s*Pawn%s*:%s*v(%d+)%s*:%s*"([^"]+)"%s*:%s*(.+)%s*%)%s*$')
	if not found or not version or (setName or '') == '' or (weights or '') == '' then return end

	local scaleTable = {}
	weights:gsub('([^ =]+)=([^ ,]+)', function(stat, weight)
		scaleTable[stat] = tonumber(weight)
	end)
	return setName, scaleTable
end
local function ParseAMR(importString)
	local weights, setName = importString:trim()
	local scaleTable = {}
	weights:gsub('([^ \n]+) -([%d.]+)', function(stat, weight)
		setName = setName or stat
		scaleTable[stat] = tonumber(weight)
	end)
	return setName, scaleTable
end
-- e.g. ( TopFit: v1: "SetName": Intellect=A, RangedDps=B : HitRating=<value>; <isSoftCap>, DefenseRating=[...] )
local function ParseTopFit(importString)
	local found, _, version, setName, weights, caps = importString:find('^%s*%(%s*TopFit%s*:%s*v(%d+)%s*:%s*"([^"]+)"%s*:%s*(.+)%s*%:?%s*(.*)%s*%)%s*$')
	if not found or not version or (setName or '') == '' or (weights or '') == '' then return end

	-- parse simple stat values
	local scaleTable = {}
	weights:gsub('([^ =]+)=([^ ,]+)', function(stat, weight)
		scaleTable[stat] = tonumber(weight)
	end)

	-- parse stat caps
	local capTable = {}
	caps:gsub('([^ =]+)=([^ ,;]+)'..'%s*;%s([^ ,;]+)%s', function(stat, amount, capType)
		local statName = globalString[stat]
		if not statName then print('Error parsing import string cap for', stat); return end
		capTable[statName] = {
			value  = tonumber(amount),
			soft   = capTable:lower() == 'soft',
			active = true
		}
	end)

	return setName, scaleTable, capTable
end
-- renames <oldstat> to <newstat>, e.g. spell haste -> haste, <keep> when set will not delete the <oldstat> data
local function RenameStat(scaleTable, oldStat, newStat, keep)
	if scaleTable[oldStat] then
		if not scaleTable[newStat] then scaleTable[newStat] = scaleTable[oldStat] end
		if not keep then scaleTable[oldStat] = nil end
	end
end
-- combines <oldstat> and <newstat> and saves the higher value in <newstat>
local function CombineStat(scaleTable, newStat, oldStat)
	if scaleTable[oldStat] then
		if scaleTable[newStat] and scaleTable[oldStat] and scaleTable[newStat] < scaleTable[oldStat] then
			scaleTable[newStat] = scaleTable[oldStat]
		end
		scaleTable[oldStat] = nil
	end
end
-- some "fixing" needed, as well as getting global strings for pawn scores
local function SanitizeScales(scaleTable)
	------------------ Pawn specific fixes --------------------
	-- Some versions of Pawn call resilience rating Resilience and some call it ResilienceRating.
	RenameStat(scaleTable, "Resilience", "ResilienceRating")

	-- Early versions of Pawn 0.7.x had a typo in the configuration UI so that none of the special DPS stats worked.
	RenameStat(scaleTable, "MeleeDPS", "MeleeDps")
	RenameStat(scaleTable, "RangedDPS", "RangedDps")
	RenameStat(scaleTable, "MainHandDPS", "MainHandDps")
	RenameStat(scaleTable, "OffHandDPS", "OffHandDps")
	RenameStat(scaleTable, "OneHandDPS", "OneHandDps")
	RenameStat(scaleTable, "TwoHandDPS", "TwoHandDps")

	-- combine +healing and +damage into spell power
	CombineStat(scaleTable, "SpellPower", "SpellDamage")
	CombineStat(scaleTable, "SpellPower", "Healing")

	-- Combine melee/ranged/spell hit, crit, and haste ratings into the hybrid stats that work for all.
	CombineStat(scaleTable, "HitRating", "SpellHitRating")
	CombineStat(scaleTable, "CritRating", "SpellCritRating")
	CombineStat(scaleTable, "HasteRating", "SpellHasteRating")

	------------------ Get things to work with TopFit --------------------
	-- turn "resist all" into "resist this and that and that and ..."
	RenameStat(scaleTable, "AllResist", "FireResist", true)
	RenameStat(scaleTable, "AllResist", "ShadowResist", true)
	RenameStat(scaleTable, "AllResist", "HolyResist", true)
	RenameStat(scaleTable, "AllResist", "NatureResist", true)
	RenameStat(scaleTable, "AllResist", "ArcaneResist", true)
	RenameStat(scaleTable, "AllResist", "FrostResist")

	CombineStat(scaleTable, "Armor", "BonusArmor")
	CombineStat(scaleTable, "Armor", "BaseArmor")

	local returnTable = {}
	for stat, score in pairs(scaleTable) do
		if globalString[stat] then
			returnTable[globalString[stat]] = score
		end
	end

	return returnTable
end
-- Imports a Pawn/TopFit string and creates a set according to its data
local function ImportString(importString)
	local setName, setScores, caps = ParsePawn(importString)
	if not setName then
		setName, setScores, caps = ParseTopFit(importString)
	end
	if not setName then
		setName, setScores = ParseAMR(importString)
	end
	if not setName then
		TopFit:Print(TopFit.locale.UtilitiesErrorStringParse)
		return nil
	end

	local tempName = string.sub(tostring(GetTime()), 1, 5) or "?"
	local setCode = TopFit:AddSet({                                     -- TODO!
		name = setName or "Import"..tempName,
		weights = SanitizeScales(setScores),
		caps = caps or {},
	})
	TopFit:Print(string.format(TopFit.locale.UtilitiesNoticeImported, setName))
	return setCode
end
-- ( TopFit: v1: "SetName": Intellect=A, RangedDps=B : HitRating=<value>; <isSoftCap>, DefenseRating=[...] )
local function GenerateExportString(addon, version)
	local set = TopFit.db.profile.sets[TopFit.selectedSet]

	local stats
	for stat, value in pairs(set.weights) do
		local statName = GetInverseStat(stat)
		if statName then
			stats = (stats and stats .. ', ' or '') .. statName..'='..value
		end
	end

	if addon == addonName then
		local caps
		for stat, data in pairs(set.caps) do
			local statName = GetInverseStat(stat)
			if statName and data.active then
				caps = (caps and caps .. ', ' or '') .. statName..'='..data.value..'; '..(data.soft and 'Soft' or 'Hard')
			end
		end
		if caps then stats = stats .. ': ' .. caps end
	end

	return (' ( %s: v%s: "%s": %s ) '):format(addon, version, set.name, stats or '')
end

StaticPopupDialogs['TOPFIT_IMPORT'] = {
	text = '%s',
	button1 = 'Import',
	button2 = _G.CANCEL,
	OnShow = function(self, data)
		_G[self:GetName()..'AlertIcon']:SetTexture('Interface\\Icons\\INV_Pet_RatCage')
		if data then
			-- TODO/FIXME: is this the version number we want?
			local export = GenerateExportString(addonName, _G[addonName..'DB'].version)
			self.editBox:SetText(export)
			self.editBox:HighlightText()
			self.button1:Disable()
		end
		self.editBox:SetFocus()
	end,
	OnAccept = function(self, data)
		local text = self.editBox:GetText()
		if data then
			-- do nothing, this is an export
		elseif text and text ~= '' then
			ImportString(text)
		end
	end,
	EditBoxOnEnterPressed = function(self)
		local popup = self:GetParent()
		StaticPopupDialogs['TOPFIT_IMPORT'].OnAccept(popup, popup.data)
		popup:Hide()
	end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
	hasEditBox = true,
	editBoxWidth = 260,
	showAlert = true,
}
