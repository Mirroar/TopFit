local addonName, ns, _ = ...

local ImportPlugin = ns.Plugin()
ns.ImportPlugin = ImportPlugin

-- GLOBALS: TopFit, GameFontNormalSmall, GameFontHighlightSmall, GameFontNormalLarge
-- GLOBALS: CreateFrame, GetTime
-- GLOBALS: string, tostring, pairs, gsub, tonumber, strfind


--[[ THERE BE DRAGONS! ]]--
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
        caps = caps or {},
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
    local statWeightTable = TopFit.db.profile.sets[TopFit.selectedSet].weights
    local first = true
    for stat, value in pairs(statWeightTable) do
        local statName = GetInverseStat(stat)
        if statName then
            export = export .. (first and "" or ", ") .. statName .. "=" .. value
            first = false
        end
    end
    if addon == "TopFit" then
        local statCapTable = TopFit.db.profile.sets[TopFit.selectedSet].caps
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
--[[ Back to safe lands! ]]--



-- creates a new ImportPlugin object
function ImportPlugin:Initialize()
    self:SetName(TopFit.locale.Utilities)
    self:SetTooltipText(TopFit.locale.UtilitiesTooltip)
    self:SetButtonTexture("Interface\\Icons\\INV_Pet_RatCage")
    self:RegisterConfigPanel()
end

-- initializes this plugin's UI elements
function ImportPlugin:InitializeUI()
    local frame = self:GetConfigPanel()

    local function Accept(self)
        local text = self:GetText()
        if text and text ~= "" and text ~= TopFit.locale.UtilitiesDefaultText then
            -- try importing this string
            ImportString(text)
        end
        self:ClearFocus()
    end
    local backdrop = {
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        insets = {left = 4, right = 4, top = 4, bottom = 4},
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
    }

    local importBox = CreateFrame("EditBox", "TopFitUtilities_importBox", frame)
    importBox:SetPoint("TOPLEFT")
    importBox:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 0, -80)
    importBox:SetFontObject(GameFontNormalSmall)
    importBox:SetTextInsets(8, 8, 8, 8)
    importBox:SetMultiLine(true)
    importBox:SetAutoFocus(false)
    importBox:SetText(TopFit.locale.UtilitiesDefaultText)
    importBox:SetBackdrop(backdrop)
    importBox:SetBackdropColor(.1, .1, .1, .8)
    importBox:SetBackdropBorderColor(.5, .5, .5)
    local importBoxLabel = importBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    importBoxLabel:SetPoint("BOTTOMLEFT", importBox, "TOPLEFT", 16, 0)
    importBoxLabel:SetText("Import")

    importBox:SetScript("OnEditFocusGained", EditBox_HighlightText)
    importBox:SetScript("OnEscapePressed", EditBox_ClearFocus)
    importBox:SetScript("OnEnterPressed", Accept)

    local exportBox = CreateFrame("EditBox", "TopFitUtilities_exportBox", frame)
    self.exportBox = exportBox
    exportBox:SetPoint("TOPLEFT", importBox, "BOTTOMLEFT", 0, -30)
    exportBox:SetPoint("BOTTOMRIGHT", importBox, "BOTTOMRIGHT", 0, -150-30)
    exportBox:SetFontObject(GameFontNormalSmall)
    exportBox:SetTextInsets(8, 8, 8, 8)
    exportBox:SetMultiLine(true)
    exportBox:SetAutoFocus(false)
    exportBox:SetText(TopFit.locale.UtilitiesDefaultText)
    exportBox:SetBackdrop(backdrop)
    exportBox:SetBackdropColor(.1, .1, .1, .8)
    exportBox:SetBackdropBorderColor(.5, .5, .5)
    local exportBoxLabel = exportBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    exportBoxLabel:SetPoint("BOTTOMLEFT", exportBox, "TOPLEFT", 16, 0)
    exportBoxLabel:SetText("Export")

    exportBox:SetScript("OnEditFocusGained", EditBox_HighlightText)
    exportBox:SetScript("OnEscapePressed", EditBox_ClearFocus)
    exportBox:SetScript("OnEnterPressed", Accept)

--[[
    local pwned = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    self.pwned = pwned
    pwned:SetPoint("TOPLEFT", exportBox, "BOTTOMLEFT", 0, -10)
    pwned:SetPoint("RIGHT", frame, -4, 0)
    pwned:SetHeight(55)
    pwned:SetNonSpaceWrap(true)
    pwned:SetJustifyH("LEFT")
    pwned:SetJustifyV("TOP")
--]]
end

function ImportPlugin:OnShow()
    self.exportBox:SetText(GenerateExportString("TopFit", "1"))
end
