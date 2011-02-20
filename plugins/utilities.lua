-- ------------------------------------------------------------
-- Plugin for TopFit that does various tiny bits and pieces
--  * show GearScore value of this set
--  * TODO: scan bank and inventory for items not recognized by TopFit
--  * TODO: scan for onUse effects
--  * import Pawn strings
-- ------------------------------------------------------------

-- ------------------------------------------------------------
--  GearScore   :: parts of the code, full formulas, taken from GearScoreLite by Mirrikat45
-- ------------------------------------------------------------
local GearScoreQuality = {
    [6000] = {
        ["R"] = {0.94, 5000, 0.00006, 1},
        ["G"] = {0, 0, 0, 0},
        ["B"] = {0.47, 5000, 0.00047, -1},
        ["Description"] = ITEM_QUALITY5_DESC
    },
    [5000] = {
        ["R"] = {0.69, 4000, 0.00025, 1},
        ["G"] = {0.97, 4000, 0.00096, -1},
        ["B"] = {0.28, 4000, 0.00019, 1},
        ["Description"] = ITEM_QUALITY4_DESC
    },
    [4000] = {
        ["R"] = {0.0, 3000, 0.00069, 1},
        ["G"] = {1, 3000, 0.00003, -1},
        ["B"] = {0.5, 3000, 0.00022, -1},
        ["Description"] = ITEM_QUALITY3_DESC
    },
    [3000] = {
        ["R"] = {0.12, 2000, 0.00012, -1},
        ["G"] = {0, 2000, 0.001, 1},
        ["B"] = {1, 2000, 0.00050, -1},
        ["Description"] = ITEM_QUALITY2_DESC
    },
    [2000] = {
        ["R"] = {1, 1000, 0.00088, -1},
        ["G"] = {1, 1000, 0.001, -1},
        ["B"] = {1, 000, 0.00000, 0},
        ["Description"] = ITEM_QUALITY1_DESC
    },
    [1000] = {
        ["R"] = {0.55, 0, 0.00045, 1},
        ["G"] = {0.55, 0, 0.00045, 1},
        ["B"] = {0.55, 0, 0.00045, 1},
        ["Description"] = ITEM_QUALITY0_DESC
    }
}
local GearScoreItemSlots = {
    ["INVTYPE_RELIC"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false},
    ["INVTYPE_TRINKET"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 33, ["Enchantable"] = false },
    ["INVTYPE_2HWEAPON"] = { ["SlotMOD"] = 2.000, ["ItemSlot"] = 16, ["Enchantable"] = true },
    ["INVTYPE_WEAPONMAINHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 16, ["Enchantable"] = true },
    ["INVTYPE_WEAPONOFFHAND"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
    ["INVTYPE_RANGED"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = true },
    ["INVTYPE_THROWN"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
    ["INVTYPE_RANGEDRIGHT"] = { ["SlotMOD"] = 0.3164, ["ItemSlot"] = 18, ["Enchantable"] = false },
    ["INVTYPE_SHIELD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = true },
    ["INVTYPE_WEAPON"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 36, ["Enchantable"] = true },
    ["INVTYPE_HOLDABLE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 17, ["Enchantable"] = false },
    ["INVTYPE_HEAD"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 1, ["Enchantable"] = true },
    ["INVTYPE_NECK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 2, ["Enchantable"] = false },
    ["INVTYPE_SHOULDER"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 3, ["Enchantable"] = true },
    ["INVTYPE_CHEST"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
    ["INVTYPE_ROBE"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 5, ["Enchantable"] = true },
    ["INVTYPE_WAIST"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 6, ["Enchantable"] = false },
    ["INVTYPE_LEGS"] = { ["SlotMOD"] = 1.0000, ["ItemSlot"] = 7, ["Enchantable"] = true },
    ["INVTYPE_FEET"] = { ["SlotMOD"] = 0.75, ["ItemSlot"] = 8, ["Enchantable"] = true },
    ["INVTYPE_WRIST"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 9, ["Enchantable"] = true },
    ["INVTYPE_HAND"] = { ["SlotMOD"] = 0.7500, ["ItemSlot"] = 10, ["Enchantable"] = true },
    ["INVTYPE_FINGER"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 31, ["Enchantable"] = false },
    ["INVTYPE_CLOAK"] = { ["SlotMOD"] = 0.5625, ["ItemSlot"] = 15, ["Enchantable"] = true },
    ["INVTYPE_BODY"] = { ["SlotMOD"] = 0, ["ItemSlot"] = 4, ["Enchantable"] = false }
}

local function GetGearScoreEnchantInfo(ItemLink, ItemEquipLoc)
    local found, _, ItemSubString = string.find(ItemLink, "^|c%x+|H(.+)|h%[.*%]");
    local ItemSubStringTable = {}
    
    for v in string.gmatch(ItemSubString, "[^:]+") do
        tinsert(ItemSubStringTable, v)
    end
    ItemSubString = ItemSubStringTable[2] .. ":" .. ItemSubStringTable[3], ItemSubStringTable[2]
    local StringStart, StringEnd = string.find(ItemSubString, ":")
    ItemSubString = string.sub(ItemSubString, StringStart + 1)
    if ItemSubString == "0" and GearScoreItemSlots[ItemEquipLoc]["Enchantable"] then
        local percent = ( floor((-2 * ( GearScoreItemSlots[ItemEquipLoc]["SlotMOD"] )) * 100) / 100 );
        return (1 + (percent/100))
    else
        return 1
    end
end

local function GetGearScoreQuality(ItemScore)
    if ItemScore > 5999 then ItemScore = 5999 end
    if not ItemScore then return 0, 0, 0, ITEM_QUALITY0_DESC end
    
    local Red, Green, Blue = 0.1, 0.1, 0.1
    for i = 0, 6 do
        local j = (i + 1) * 1000
        if ItemScore > i * 1000 and ItemScore <= j then
            Red = GearScoreQuality[j].R[1] + (ItemScore - GearScoreQuality[j].R[2]) * GearScoreQuality[j].R[3] * GearScoreQuality[j].R[4]
            Green = GearScoreQuality[j].G[1] + (ItemScore - GearScoreQuality[j].G[2]) * GearScoreQuality[j].G[3] * GearScoreQuality[j].G[4]
            Blue = GearScoreQuality[j].B[1] + (ItemScore - GearScoreQuality[j].B[2]) * GearScoreQuality[j].B[3] * GearScoreQuality[j].B[4]
            
            return Red, Green, Blue, GearScoreQuality[j].Description
        end
    end
    return Red, Green, Blue
end

function TopFit:GetItemGearScore(ItemLink)
        if not ItemLink then return 0, 0 end
        local QualityScale, PVPScale = 1, 1
        local PVPScore, GearScore = 0, 0
        
        local _, ItemLink, ItemRarity, ItemLevel, _, _, _, _, ItemEquipLoc, _ = GetItemInfo(ItemLink)
        local Scale = 1.8618
        if ItemRarity == 5 then 
            QualityScale = 1.3
            ItemRarity = 4
        elseif ItemRarity == 1 then
            QualityScale = 0.005
            ItemRarity = 2
        elseif ItemRarity == 0 then
            QualityScale = 0.005
            ItemRarity = 2
        end
    if ItemRarity == 7 then
            ItemRarity = 3
            ItemLevel = 187.05
        end
    if GearScoreItemSlots[ItemEquipLoc] then
        local Table
        if ItemLevel > 120 then
            Table = {nil, {73.0000, 1.0000}, {81.3750, 0.8125}, {91.4500, 0.6500}}
        else 
            Table = {{0.0000, 2.2500}, {8.0000, 2.0000}, {0.7500, 1.8000}, {26.0000, 1.2000}}
        end
        if ItemRarity >= 2 and ItemRarity <= 4 then
            local Red, Green, Blue = GetGearScoreQuality((floor(((ItemLevel - Table[ItemRarity][1]) / Table[ItemRarity][2]) * Scale)) * 11.25 )
            GearScore = floor(((ItemLevel - Table[ItemRarity][1]) / Table[ItemRarity][2]) * GearScoreItemSlots[ItemEquipLoc].SlotMOD * Scale * QualityScale)
            if ItemLevel == 187.05 then
                ItemLevel = 0
            end
            if GearScore < 0 then
                GearScore = 0
                Red, Green, Blue = GetGearScoreQuality(1)
            end
            if PVPScale == 0.75 then
                PVPScore = 1
                GearScore = GearScore * 1
            else
                PVPScore = GearScore * 0
            end
            local percent = GetGearScoreEnchantInfo(ItemLink, ItemEquipLoc) or 1
            GearScore = floor(GearScore * percent)
            PVPScore = floor(PVPScore)
            
            return GearScore, ItemLevel, GearScoreItemSlots[ItemEquipLoc].ItemSlot, Red, Green, Blue, PVPScore, ItemEquipLoc, percent
        end
    end
    return -1, ItemLevel, 50, 1, 1, 1, PVPScore, ItemEquipLoc, 1
end

-- takes a setCode and returns the set's GearScore + avg. itemLevel
function TopFit:CalculateGearScore(setCode)
    if not setCode then
        -- check what set is selected, otherwise take the first available set in the saved variables
        if TopFit.ProgressFrame and TopFit.ProgressFrame.selectedSet then
            setCode = TopFit.ProgressFrame.selectedSet
        else
            for setCode2, _ in pairs(TopFit.db.profile.sets) do
                setCode = setCode2
                break;
            end
        end
        if not setCode then return end
    end
    
    local _, PlayerEnglishClass = UnitClass("player");
    local GearScore = 0
    local ItemCount, LevelTotal = 0, 0
    local TitanGrip = 1

    local mainHand, offHand = TopFit:GetSetItemFromSlot(16, setCode), TopFit:GetSetItemFromSlot(17, setCode)
    if mainHand and offHand then
        if select(9, GetItemInfo(mainHand)) == "INVTYPE_2HWEAPON" then
            TitanGrip = 0.5
        end
    end

    if offHand then
        local _, _, _, ItemLevel, _, _, _, _, ItemEquipLoc, _ = GetItemInfo(offHand)
        if ItemEquipLoc == "INVTYPE_2HWEAPON" then
            TitanGrip = 0.5
        end
        TempScore, ItemLevel = TopFit:GetItemGearScore(offHand)
        if PlayerEnglishClass == "HUNTER" then 
            TempScore = TempScore * 0.3164
        end
        
        GearScore = GearScore + TempScore * TitanGrip
        ItemCount = ItemCount + 1
        LevelTotal = LevelTotal + ItemLevel
    end

    for i = 1, 18 do
        if i ~= 4 and i ~= 17 then
            ItemLink = TopFit:GetSetItemFromSlot(i, setCode)
            if ItemLink then
                local _, ItemLink, _, ItemLevel, _, _, _, _, _, _ = GetItemInfo(ItemLink)
                TempScore = TopFit:GetItemGearScore(ItemLink)
                if i == 16 and PlayerEnglishClass == "HUNTER" then
                    TempScore = TempScore * 0.3164
                end
                if i == 18 and PlayerEnglishClass == "HUNTER" then
                    TempScore = TempScore * 5.3224
                end
                if i == 16 then
                    TempScore = TempScore * TitanGrip
                end
                GearScore = GearScore + TempScore
                ItemCount = ItemCount + 1
                LevelTotal = LevelTotal + ItemLevel
            end
        end
    end
    if GearScore <= 0 then GearScore = 0 end
    if ItemCount == 0 then LevelTotal = 0 end
    
    return floor(GearScore), floor(LevelTotal/ItemCount)
end

-- ------------------------------------------------------------
--  Pawn :: parts of the code taken from Pawn by VGer
-- ------------------------------------------------------------
local globalString = {  -- insert all known strings in here
    ["Strength"] = "ITEM_MOD_STRENGTH_SHORT",
    ["Agility"] = "ITEM_MOD_AGILITY_SHORT",
    ["Stamina"] = "ITEM_MOD_STAMINA_SHORT",
    ["Intellect"] = "ITEM_MOD_INTELLECT_SHORT",
    ["Spirit"] = "ITEM_MOD_SPIRIT_SHORT",

    ["RedSocket"] = nil,    -- empty red socket
    ["YellowSocket"] = nil, -- empty yellow socket
    ["BlueSocket"] = nil,   -- empty blue socket
    ["MetaSocket"] = nil,   -- empty meta socket
    ["MetaSocketEffect"] = nil, -- value of "the" meta gem's effect (e.g. +3% critical heal is worth 40 points)
    
    ["Dps"] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",  -- weapon damage per second
    ["Speed"] = nil,           -- weapon speed, in seconds per swing; fast weapons -> use negative score!
    
    ["HitRating"] = "ITEM_MOD_HIT_RATING_SHORT",
    ["CritRating"] = "ITEM_MOD_CRIT_RATING_SHORT",
    ["HasteRating"] = "ITEM_MOD_HASTE_RATING_SHORT",
    ["MasteryRating"] = "ITEM_MOD_MASTERY_RATING_SHORT",
    
    ["Ap"] = "ITEM_MOD_ATTACK_POWER_SHORT", -- basic attack power. not derived values (agility, strength, feral)
    ["Rap"] = nil,          -- ranged attack power
    ["FeralAp"] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT", -- use this -or- weapon dps for useful results
    ["ExpertiseRating"] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
    ["ArmorPenetration"] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",

    ["SpellPower"] = "ITEM_MOD_SPELL_POWER_SHORT",
    ["Mp5"] = "ITEM_MOD_MANA_REGENERATION_SHORT",
    ["SpellPenetration"] = "ITEM_MOD_SPELL_PENETRATION_SHORT",

    ["Armor"] = "RESISTANCE0_NAME",  -- regardless of item type.  classes with abilties that give armor bonuses should assign a value to base and bonus armor instead
    ["BaseArmor"] = nil,       -- regular items (cloth, leather, mail, plate) [included for +x% armor]
    ["BonusArmor"] = nil,      -- weapons, trinkets, rings [excluded for +x% armor]
    ["BlockValue"] = "ITEM_MOD_BLOCK_VALUE_SHORT",      -- increases amount of damage blocked
    ["BlockRating"] = "ITEM_MOD_BLOCK_RATING_SHORT",     -- increases chance to block
    ["DefenseRating"] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
    ["DodgeRating"] = "ITEM_MOD_DODGE_RATING_SHORT",
    ["ParryRating"] = "ITEM_MOD_PARRY_RATING_SHORT",
    ["ResilienceRating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
    
    ["FireSpellDamage"] = nil,      -- exclusive with spell power
    ["ShadowSpellDamage"] = nil,
    ["NatureSpellDamage"] = nil,
    ["ArcaneSpellDamage"] = nil,
    ["FrostSpellDamage"] = nil,
    ["HolySpellDamage"] = nil,
    -- ["AllResist"]
    ["HolyResist"] = "RESISTANCE1_NAME",
    ["FireResist"] = "RESISTANCE2_NAME",
    ["NatureResist"] = "RESISTANCE3_NAME",
    ["FrostResist"] = "RESISTANCE4_NAME",
    ["ShadowResist"] = "RESISTANCE5_NAME",
    ["ArcaneResist"] = "RESISTANCE6_NAME",
    ["Hp5"] = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
    ["Health"] = "ITEM_MOD_HEALTH_SHORT",
    ["Mana"] = "ITEM_MOD_MANA_SHORT",            -- mana as supplied by enchantments
    
    ["IsAxe"] = nil,
    ["IsBow"] = nil,
    ["IsCrossbow"] = nil,
    ["IsDagger"] = nil,
    ["IsFist"] = nil,
    ["IsGun"] = nil,
    ["IsMace"] = nil,
    ["IsPolearm"] = nil,
    ["IsStaff"] = nil,
    ["IsSword"] = nil,
    ["IsThrown"] = nil,
    ["IsWand"] = nil,

    ["IsCloth"] = nil,
    ["IsLeather"] = nil,
    ["IsMail"] = nil,
    ["IsPlate"] = nil,
    ["IsShield"] = nil,

    ["MinDamage"] = nil,
    ["MaxDamage"] = nil,
    ["MeleeDps"] = nil,
    ["MeleeMinDamage"] = nil,
    ["MeleeMaxDamage"] = nil,
    ["MeleeSpeed"] = nil,
    ["RangedDps"] = nil,
    ["RangedMinDamage"] = nil,
    ["RangedMaxDamage"] = nil,
    ["RangedSped"] = nil,
    ["MainHandDps"] = nil,
    ["MainHandMinDamage"] = nil,
    ["MainHandMaxDamage"] = nil,
    ["MainHandSpeed"] = nil,
    ["OffHandDps"] = nil,
    ["OffHandMinDamage"] = nil,
    ["OffHandMaxDamage"] = nil,
    ["OffHandSpeed"] = nil,
    ["OneHandDps"] = nil,
    ["OneHandMinDamage"] = nil,
    ["OneHandMaxDamage"] = nil,
    ["OneHandSpeed"] = nil,
    ["TwoHandDps"] = nil,
    ["TwoHandMinDamage"] = nil,
    ["TwoHandMaxDamage"] = nil,
    ["TwoHandSpeed"] = nil,
    ["SpeedBaseline"] = nil,        -- this number is subtracted from the Speed stat before multiplying it by the scale value
}

-- takes a string and filteres any stats + stat weights it finds; e.g.( Pawn: v1: "SetName": Intellect=A, RangedDps=B, CritRating=C )
local function ParsePawn(importString)
    -- Read the scale and perform basic validation.
    local found, _, Version, Name, ValuesString = strfind(importString, "^%s*%(%s*Pawn%s*:%s*v(%d+)%s*:%s*\"([^\"]+)\"%s*:%s*(.+)%s*%)%s*$")
    Version = tonumber(Version)
    if (not found) or (not Version) or (not Name) or (Name == "") or (not ValuesString) or (ValuesString == "") then return end
    
    -- Now, parse the values string for stat names and values.
    local scaleTable = {}
    local function SplitStatValuePair(Pair)
        local found, _, Stat, Value = strfind(Pair, "^%s*([%a%d]+)%s*=%s*(%-?[%d%.]+)%s*,$")
        Value = tonumber(Value)
        if found and Stat and (Stat ~= "") and Value then
            scaleTable[Stat] = Value
        end
    end
    gsub(ValuesString .. ",", "[^,]*,", SplitStatValuePair)
    
    -- Looks like everything worked.
    return Name, scaleTable
end

-- e.g. ( TopFit: v1: "SetName": Intellect=A, RangedDps=B, CritRating=C : HitRating=<value>; <isSoftCap>, DefenseRating=[...] )
local function ParseTopFit(importString)
    local found, _, version, setName, weights, caps = strfind(importString, "^%s*%(%s*TopFit%s*:%s*v(%d+)%s*:%s*\"([^\"]+)\"%s*:%s*(.+)%s*%:?%s*(.*)%s*%)%s*$")
    version = tonumber(version)
    if (not found) or (not version) or (not setName) or (setName == "") or (not weights) or (weights == "") then
        return
    end
    
    -- parse simple stat values
    local scaleTable = {}
    local function ParseStats(statString)
        local found, _, statName, statValue = strfind(statString, "^%s*([%a%d]+)%s*=%s*(%-?[%d%.]+)%s*,$")
        statValue = tonumber(statValue)
        if found and statName and statName ~= "" and statValue then
            scaleTable[statName] = statValue
        end
    end
    gsub(weights .. ",", "[^,]*,", ParseStats)
    
    local capTable = {}
    local function ParseCaps(statString)
        local found, _, statName, statValue, isSoftCap = strfind(statString, "^%s*([%a%d]+)%s*=%s*(%-?[%d%.]+)%s*;%s*([SoftHard]+)%s*,$")
        statValue = tonumber(statValue)
        statName = globalString[statName]
        isSoftCap = isSoftCap == "Soft"
        
        if found and statName and statName ~= "" and statValue then
            capTable[statName] = {
                ["value"] = statValue,
                ["soft"] = isSoftCap,
                ["active"] = true,
            }
        end
    end
    gsub(caps .. ",", "[^,]*,", ParseCaps)
    
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
            TopFit:Print(TopFit.locale.UtilitiesErrorStringParse)
            return nil
        end
    if false and TopFit:HasSet(setName) then
        TopFit:Print(TopFit.locale.UtilitiesErrorSetExists)
        return nil
    end
        
    local tempName = string.sub(tostring(GetTime()), 1, 5) or "?"
    local setCode = TopFit:AddSet({                                     -- TODO!
        name = setName or "Import"..tempName,
        weights = SanitizeScales(setScores),
        caps = setCaps or {},
    })
    TopFit:Print(string.format(TopFit.locale.UtilitiesNoticeImported, setName))
    return setCode
end

local function GetInverseStat(stat)
    for pawnStat, globalStat in pairs(globalString) do
        if globalStat == stat then
            return pawnStat
        end
    end
    return nil
end

-- ( TopFit: v1: "SetName": Intellect=A, RangedDps=B, CritRating=C : HitRating=<value>; <isSoftCap>; <active>, DefenseRating=[...] )
local function GenerateExportString(addon, version)
    local export = " ( "..addon..": v"..version..": "
    local statWeightTable = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].weights
    local first = true
    for stat, value in pairs(statWeightTable) do
        local statName = GetInverseStat(stat)
        if statName then
            export = export .. (first and "" or ", ") .. statName .. "=" .. value
            first = false
        end
    end
    if addon == "TopFit" then
        local statCapTable = TopFit.db.profile.sets[TopFit.ProgressFrame.selectedSet].caps
        first = true
        for stat, data in pairs(statCapTable) do
            local statName = GetInverseStat(stat)
            local value = data.value
            local softCap = data.soft and "Soft" or "Hard"
            local active = data.active
            if statName and active == "true" then
                if first then
                    export = export .. " : "
                end
                export = export .. (first and "" or ", ") .. statName .. "=" .. value .. "; " .. softCap
                first = false
            end
        end
    end
    
    return export .. " )"
end

-- function that handles displaying stuff
function TopFit:CreateUtilitiesPlugin()
    local frame, pluginId = TopFit:RegisterPlugin(TopFit.locale.Utilities, "Interface\\Icons\\INV_Pet_RatCage", TopFit.locale.UtilitiesTooltip) -- "Interface\\Icons\\INV_Misc_Toy_07", "Interface\\Icons\\Ability_Hunter_BeastTraining", "Interface\\Icons\\INV_Crate_03"
    local function FocusGained(self)
        self:HighlightText()
    end
    local function Reset(self)
        self:SetText(TopFit.locale.UtilitiesDefaultText)
        self:ClearFocus()
    end
    local function Accept(self)
        local text = self:GetText()
        if text and text ~= "" and text ~= TopFit.locale.UtilitiesDefaultText then
            -- try importing this string
            ImportString(text)
        end
        self:SetText(TopFit.locale.UtilitiesDefaultText)
        self:ClearFocus()
    end
    
    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -4)
    title:SetText(TopFit.locale.Utilities)
    
    local explain = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    explain:SetPoint("TOPLEFT", title, "BOTTOMLEFT", -10, -8)
    explain:SetPoint("RIGHT", frame, -4, 0)
    explain:SetHeight(55)
    explain:SetNonSpaceWrap(true)
    explain:SetJustifyH("LEFT")
    explain:SetJustifyV("TOP")
    explain:SetText(TopFit.locale.UtilitiesTooltip)     -- TODO: offer more useful text
    
    local importBox = CreateFrame("EditBox", "TopFitUtilities_importBox", frame)
    importBox:SetPoint("TOPLEFT", explain, "BOTTOMLEFT", 0, -4)
    importBox:SetPoint("BOTTOMRIGHT", explain, "RIGHT", 0, -80)
    importBox:SetFontObject(GameFontNormalSmall)
    importBox:SetTextInsets(8, 8, 8, 8)
    importBox:SetMultiLine(true)
    importBox:SetAutoFocus(false)
    importBox:SetText(TopFit.locale.UtilitiesDefaultText)
    importBox:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    importBox:SetBackdropColor(.1, .1, .1, .8)
    importBox:SetBackdropBorderColor(.5, .5, .5)
    local importBoxLabel = importBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    importBoxLabel:SetPoint("BOTTOMLEFT", importBox, "TOPLEFT", 16, 0)
    importBoxLabel:SetText("Import")
    
    importBox:SetScript("OnEditFocusGained", FocusGained)
    importBox:SetScript("OnEnterPressed", Accept)
    importBox:SetScript("OnEscapePressed", Reset)
    
    local exportBox = CreateFrame("EditBox", "TopFitUtilities_exportBox", frame)
    exportBox:SetPoint("TOPLEFT", importBox, "BOTTOMLEFT", 0, -10)
    exportBox:SetPoint("BOTTOMRIGHT", explain, "RIGHT", 0, -200)
    exportBox:SetFontObject(GameFontNormalSmall)
    exportBox:SetTextInsets(8, 8, 8, 8)
    exportBox:SetMultiLine(true)
    exportBox:SetAutoFocus(false)
    exportBox:SetText(TopFit.locale.UtilitiesDefaultText)
    exportBox:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    exportBox:SetBackdropColor(.1, .1, .1, .8)
    exportBox:SetBackdropBorderColor(.5, .5, .5)
    local exportBoxLabel = exportBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    exportBoxLabel:SetPoint("BOTTOMLEFT", exportBox, "TOPLEFT", 16, 0)
    exportBoxLabel:SetText("Export")
    
    exportBox:SetScript("OnEditFocusGained", FocusGained)
    exportBox:SetScript("OnEnterPressed", Accept)
    exportBox:SetScript("OnEscapePressed", Reset)

    local pwned = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    pwned:SetPoint("TOPLEFT", exportBox, "BOTTOMLEFT", 0, -10)
    pwned:SetPoint("RIGHT", frame, -4, 0)
    pwned:SetHeight(55)
    pwned:SetNonSpaceWrap(true)
    pwned:SetJustifyH("LEFT")
    pwned:SetJustifyV("TOP")

    -- register events
    TopFit.RegisterCallback("TopFit_utilities", "OnShow", function(event, id)
        if (id == pluginId) then
            exportBox:SetText(GenerateExportString("TopFit", "1"))
            pwned:SetText(string.format(TopFit.locale.GearScore, TopFit:CalculateGearScore() or "?"))
        end
    end)
    
    TopFit.RegisterCallback("TopFit_utilities", "OnSetChanged", function(event, setId)
        if (setId) then
            exportBox:SetText(GenerateExportString("TopFit", "1"))
            pwned:SetText(string.format(TopFit.locale.GearScore, TopFit:CalculateGearScore() or "?"))
        else
            -- no set selected, disable inputs
        end
    end)
end
