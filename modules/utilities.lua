-- ------------------------------------------------------------
--  * show GearScore value of this set
--  * TODO: scan bank and inventory for items not recognized by TopFit
--  * TODO: scan for onUse effects
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
    local TempScore

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

function TopFit:PlayerCanDualWield()
    local playerClass = select(2, UnitClass("player"))
    local specialization = GetSpecialization()

    if (playerClass == "ROGUE")
        or (playerClass == "DEATHKNIGHT")
        or (playerClass == "HUNTER" and UnitLevel("player") >= 20)
        or (playerClass == "WARRIOR" and specialization == 2)
        or (playerClass == "SHAMAN" and specialization == 2)
        or (playerClass == "MONK" and specialization ~= 2) then
        return true
    end
end
function TopFit:PlayerHasTitansGrip()
    local playerClass = select(2, UnitClass("player"))
    local specialization = GetSpecialization()

    if (playerClass == "WARRIOR") and (UnitLevel("player") >= 38) and (specialization == 2) then
        return true
    end
end
