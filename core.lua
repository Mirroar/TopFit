local addonName, ns = ...

-- create global Addon object
TopFit = ns

SLASH_TopFit1 = "/topfit"
SLASH_TopFit2 = "/tf"
SLASH_TopFit3 = "/fit"

ns.initialized = false

-- class function - enables pseudo-oop with inheritance using metatables
function ns.class(baseClass)
    local classObject = {}

    -- create copies of the base class' methods
    if type(baseClass) == 'table' then
        for key, value in pairs(baseClass) do
            classObject[key] = value
        end
        classObject._base = baseClass
    end

    -- expose a constructor which can be called by <classname>(<args>)
    local metaTable = {}
    metaTable.__call = function(self, ...)
        local classInstance = {}
        setmetatable(classInstance, classObject)
        if self.construct then
            self.construct(classInstance, ...)
        else
            -- at least call the base class' constructor
            if baseClass and baseClass.construct then
                baseClass.construct(classInstance, ...)
            end
        end

        return classInstance
    end

    classObject.IsInstanceOf = function(self, compareClass)
        local metaTable = getmetatable(self)
        while metaTable do
            if metaTable == compareClass then return true end
            metaTable = metaTable._base
        end
        return false
    end

    classObject.AssertArgumentType = function(argValue, argType)
        if (type(argType) == 'table') and type(argType.IsInstanceOf) == 'function' then
            assert((type(argValue) == 'table') and type(argValue.IsInstanceOf) == 'function' and argValue:IsInstanceOf(argType), 'argument is not an instance of the expected class')
        elseif type(argType) == 'string' then
            assert(type(argValue) == argType, argType..' expected, got '..type(argValue))
        else
            error("AssertArgumentType: argType is expected to be a string or class object")
        end
    end

    -- prepare metatable for lookup of our instance's functions
    classObject.__index = classObject
    setmetatable(classObject, metaTable)
    return classObject
end

function ns:Print(message)
    DEFAULT_CHAT_FRAME:AddMessage(addonName..': '..(message or "")) --TODO: add a pretty color!
end

-- debug function
function ns:Debug(...)
    if self.db.profile.debugMode then
        local text = ''
        for i = 1, select('#', ...) do
            if text ~= '' then text = text..', ' end
            local arg = select(i, ...)
            if type(arg) == 'boolean' then
                text = text .. (arg and "<true>" or "<false>")
            elseif type(arg) == 'string' or type(arg) == 'number' then
                text = text .. arg
            else
                text = text .. type(arg)
            end
        end
        ns:Print("Debug: "..text)
    end
end

-- debug function
function ns:Warning(text)
    if not ns.warningsCache then
        ns.warningsCache = {}
    end

    if not ns.warningsCache[text] then
        ns.warningsCache[text] = true
        ns:Print("|cffff0000Warning: "..text)
    end
end

-- joins any number of tables together, one after the other. elements within the input-tables will get mixed, though
function ns:JoinTables(...)
    local result = {}
    local tab

    for i = 1, select("#", ...) do
        tab = select(i, ...)
        if tab then
            for index, value in pairs(tab) do
                tinsert(result, value)
            end
        end
    end

    return result
end

function TopFit.ShowTooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    if self.tipText then
        GameTooltip:SetText(self.tipText, nil, nil, nil, nil, true)
    elseif self.itemLink then
        GameTooltip:SetHyperlink(self.itemLink)
    end
    GameTooltip:Show()
end

function TopFit.HideTooltip()
    GameTooltip:Hide()
end

function TopFit:GenerateSetName(name)
    -- using substr because blizzard interface only allows 16 characters
    -- although technically SaveEquipmentSet & co allow more
    return (((name ~= nil) and string.sub(name.." ", 1, 12).."(TF)") or "TopFit")
end

function TopFit.ChatCommand(input)
    if not input or input:trim() == "" or input:trim():lower() == "options" or input:trim():lower() == "conf" or input:trim():lower() == "config" then
        InterfaceOptionsFrame_OpenToCategory("TopFit")
    elseif input:trim():lower() == "show" then
        --TODO: TopFit:CreateProgressFrame() is outdated
    else
        TopFit:Print(TopFit.locale.SlashHelp)
    end
end
SlashCmdList["TopFit"] = TopFit.ChatCommand

function ns:OnInitialize()
    -- load saved variables
    local profileName = GetUnitName('player')..' - '..GetRealmName('player')
    local selectedProfile = profileName
    if TopFitDB then
        selectedProfile = TopFitDB.profileKeys[profileName]
        if not selectedProfile then
            -- initialize profile for this character
            TopFitDB.profileKeys[profileName] = profileName
            TopFitDB.profiles[profileName] = {}
        end
    else
        -- initialize saved variables
        TopFitDB = {
            profileKeys = {
                [profileName] = profileName
            },
            profiles = {
                [profileName] = {}
            }
        }
    end
    ns.db = {profile = TopFitDB.profiles[selectedProfile]}

    ns.emptySet = ns.Set() --TODO: remove; used by tooltip.lua until specific set objects are used there

    -- set callback handler
    ns.eventHandler = ns.eventHandler or LibStub("CallbackHandler-1.0"):New(ns)

    -- create gametooltip for scanning
    ns.scanTooltip = CreateFrame('GameTooltip', 'TFScanTooltip', UIParent, 'GameTooltipTemplate')

    -- check if any set is saved already, if not, create default
    if (not ns.db.profile.sets) then
        ns.db.profile.sets = {
            set_1 = {
                name = "Default Set",
                weights = {},
                caps = {},
                forced = {},
            },
        }
    end

    -- for savedvariable updates: check if each set has a forced table
    for set, table in pairs(ns.db.profile.sets) do
        if table.forced == nil then
            table.forced = {}
        end

        -- also set if all stat and cap values are numbers
        for stat, value in pairs(table.weights) do
            table.weights[stat] = tonumber(value) or nil
        end
        for _, capTable in pairs(table.caps) do
            capTable.value = tonumber(capTable.value)
        end
    end

    -- list of weight categories and stats
    ns.statList = {
        -- STAT_CATEGORY_RANGED
        [STAT_CATEGORY_ATTRIBUTES] = {
            [1] = "ITEM_MOD_AGILITY_SHORT",
            [2] = "ITEM_MOD_INTELLECT_SHORT",
            [3] = "ITEM_MOD_SPIRIT_SHORT",
            [4] = "ITEM_MOD_STAMINA_SHORT",
            [5] = "ITEM_MOD_STRENGTH_SHORT",
        },
        [STAT_CATEGORY_MELEE] = {
            [1] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
            [2] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
            -- [3] = "ITEM_MOD_ATTACK_POWER_SHORT",
            [3] = "ITEM_MOD_MELEE_ATTACK_POWER_SHORT",
            [4] = "ITEM_MOD_RANGED_ATTACK_POWER_SHORT",
            [5] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
            [6] = "TOPFIT_MELEE_DPS",
            [7] = "TOPFIT_RANGED_DPS",
            [8] = "TOPFIT_MELEE_WEAPON_SPEED",
            [9] = "TOPFIT_RANGED_WEAPON_SPEED",
        },
        [STAT_CATEGORY_SPELL] = {
            [1] = "ITEM_MOD_SPELL_PENETRATION_SHORT",
            [2] = "ITEM_MOD_SPELL_POWER_SHORT",
        },
        [STAT_CATEGORY_DEFENSE] = {
            [1] = "ITEM_MOD_BLOCK_RATING_SHORT",
            [2] = "ITEM_MOD_DODGE_RATING_SHORT",
            [3] = "ITEM_MOD_PARRY_RATING_SHORT",
            [4] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
            [5] = "RESISTANCE0_NAME",                   -- armor
        },
        [STAT_CATEGORY_GENERAL] = {
            [1] = "ITEM_MOD_CRIT_RATING_SHORT",
            [2] = "ITEM_MOD_HASTE_RATING_SHORT",
            [3] = "ITEM_MOD_HIT_RATING_SHORT",
            [4] = "ITEM_MOD_MASTERY_RATING_SHORT",
        },
        [STAT_CATEGORY_RESISTANCE] = {
            [1] = "RESISTANCE1_NAME",                   -- holy
            [2] = "RESISTANCE2_NAME",                   -- fire
            [3] = "RESISTANCE3_NAME",                   -- nature
            [4] = "RESISTANCE4_NAME",                   -- frost
            [5] = "RESISTANCE5_NAME",                   -- shadow
            [6] = "RESISTANCE6_NAME",                   -- arcane
        },
        --[[ [ns.locale.StatsCategoryArmorTypes] = {
            [1] = "TOPFIT_ARMORTYPE_CLOTH",
            [2] = "TOPFIT_ARMORTYPE_LEATHER",
            [3] = "TOPFIT_ARMORTYPE_MAIL",
            [4] = "TOPFIT_ARMORTYPE_PLATE",
        }]]
    }

    TOPFIT_ARMORTYPE_CLOTH = select(2, GetAuctionItemSubClasses(2));
    TOPFIT_ARMORTYPE_LEATHER = select(3, GetAuctionItemSubClasses(2));
    TOPFIT_ARMORTYPE_MAIL = select(4, GetAuctionItemSubClasses(2));
    TOPFIT_ARMORTYPE_PLATE = select(5, GetAuctionItemSubClasses(2));

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

    ns.armoredSlots = {
        [1] = true,
        [3] = true,
        [5] = true,
        [6] = true,
        [7] = true,
        [8] = true,
        [9] = true,
        [10] = true,
    }

    -- create list of slot names with corresponding slot IDs
    ns.slots = {}
    ns.slotNames = {}
    for _, slotName in pairs(ns.slotList) do
        local slotID, _, _ = GetInventorySlotInfo(slotName)
        ns.slots[slotName] = slotID;
        ns.slotNames[slotID] = slotName;
    end

    -- create frame for OnUpdate
    ns.updateFrame = CreateFrame("Frame")

    -- create options
    ns:createOptions()

    -- cache tables
    ns.itemsCache = {}
    ns.scoresCache = {}

    -- table for equippable item list
    ns.equippableItems = {}
    ns:collectEquippableItems()
    ns.loginDelay = 150

    -- register needed events
    ns.eventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
    ns.eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
    ns.eventFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    ns.eventFrame:RegisterEvent("PLAYER_TALENT_UPDATE")
    ns.eventFrame:SetScript("OnUpdate", ns.delayCalculationOnLogin)

    -- frame for calculation function
    ns.calculationsFrame = CreateFrame("Frame");

    -- heirloom info
    local isPlateWearer, isMailWearer = false, false
    if (select(2, UnitClass("player")) == "WARRIOR") or (select(2, UnitClass("player")) == "PALADIN") or (select(2, UnitClass("player")) == "DEATHKNIGHT") then
        isPlateWearer = true
    end
    if (select(2, UnitClass("player")) == "SHAMAN") or (select(2, UnitClass("player")) == "HUNTER") then
        isMailWearer = true
    end

    -- tables of itemIDs for heirlooms which change armor type
    -- 1: head, 3: shoulder, 5: chest
    ns.heirloomInfo = {
        plateHeirlooms = {
            [1] = {
                [1] = 69887,
                [2] = 61931,
             },
            [3] = {
                [1] = 42949,
                [2] = 44100,
                [3] = 44099,
                [4] = 69890,
            },
            [5] = {
                [1] = 48685,
                [2] = 69889,
            },
        },
        mailHeirlooms = {
            [1] = {
                [1] = 61936,
                [2] = 61935,
            },
            [3] = {
                [1] = 44102,
                [2] = 42950,
                [3] = 42951,
                [4] = 44101,
            },
            [5] = {
                [1] = 48677,
                [2] = 48683,
            },
        },
        isPlateWearer = isPlateWearer,
        isMailWearer = isMailWearer
    }

    -- container for plugin information and frames
    ns.plugins = {}

    ns:collectItems()

    -- we're done initializing
    ns.initialized = true

    -- initialize all registered plugins
    if not ns.currentPlugins then ns.currentPlugins = {} end
    for _, plugin in pairs(ns.currentPlugins) do
        plugin:Initialize()
    end
end

function ns.IsInitialized()
    return ns.initialized
end

function TopFit:collectEquippableItems()
    local newItem = {}

    -- check bags
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local item = GetContainerItemLink(bag, slot)

            if IsEquippableItem(item) then
                local found = false
                for _, link in pairs(TopFit.equippableItems) do
                    if link == item then
                        found = true
                        break
                    end
                end

                if not found then
                    tinsert(TopFit.equippableItems, item)
                    tinsert(newItem, {
                        itemLink = item,
                        bag = bag,
                        slot = slot
                    })
                end
            end
        end
    end

    -- check equipment (mostly so your set doesn't get recalculated just because you unequip an item)
    for _, invSlot in pairs(TopFit.slots) do
        local item = GetInventoryItemLink("player", invSlot)
        if IsEquippableItem(item) then
            local found = false
            for _, link in pairs(TopFit.equippableItems) do
                if link == item then
                    found = true
                    break
                end
            end

            if not found then
                tinsert(TopFit.equippableItems, item)
                tinsert(newItem, {
                    itemLink = item,
                    slot = invSlot
                })
            end
        end
    end

    if (#newItem == 0) then return false end
    return newItem
end

function TopFit:delayCalculationOnLogin()
    if TopFit.loginDelay then
        TopFit.loginDelay = TopFit.loginDelay - 1
        if TopFit.loginDelay <= 0 then
            TopFit.loginDelay = nil
            TopFit.eventFrame:SetScript("OnUpdate", nil)
            TopFit:collectEquippableItems()
        end
    end
end

function TopFit.FrameOnEvent(frame, event, arg1, ...)
    if event == 'ADDON_LOADED' and arg1 == addonName then
        TopFit:OnInitialize()
    elseif (event == "BAG_UPDATE_DELAYED") then
        -- update item list
        if TopFit.loginDelay then return end
        --TODO: only update affected bag
        TopFit:collectItems()

        -- check inventory for new equippable items
        local newEquip = TopFit:collectEquippableItems()
        if newEquip and not TopFit.loginDelay and
            ((TopFit.db.profile.defaultUpdateSet and GetActiveSpecGroup() == 1) or
            (TopFit.db.profile.defaultUpdateSet2 and GetActiveSpecGroup() == 2))
        then
            -- new equippable item in inventory, check if it is actually better than anything currently available
            for _, newItem in pairs(newEquip) do
                -- skip BoE items
                if not newItem.bag or not TopFit:IsItemBoE(newItem.bag, newItem.slot) then
                    TopFit:Debug("New Item: "..newItem.itemLink)
                    local itemTable = TopFit:GetCachedItem(newItem.itemLink)
                    local setCode = (GetActiveSpecGroup() == 1) and TopFit.db.profile.defaultUpdateSet or TopFit.db.profile.defaultUpdateSet2
                    local set = ns.GetSetByID(setCode, true)

                    for _, slotID in pairs(itemTable.equipLocationsByType) do
                        -- try to get the currently used item from the player's equipment set
                        local setItem = TopFit:GetSetItemFromSlot(slotID, setCode)
                        local setItemTable = TopFit:GetCachedItem(setItem)
                        if setItem and setItemTable then
                            -- if either score or any cap is higher than currently equipped, calculate
                            if set:GetItemScore(newItem.itemLink) > set:GetItemScore(setItem) then
                                TopFit:Debug('Higher Score!')
                                TopFit:RunAutoUpdate(true)
                                return
                            else
                                -- check caps
                                for stat, cap in pairs(TopFit.db.profile.sets[setCode].caps) do
                                    if cap.active and (itemTable.totalBonus[stat] or 0) > (setItemTable.totalBonus[stat] or 0) then
                                        TopFit:Debug('Higher Cap!')
                                        TopFit:RunAutoUpdate(true)
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif (event == "PLAYER_LEVEL_UP") then
        --[[ remove cache info for heirlooms so they are rescanned
        for itemLink, itemTable in pairs(TopFit.itemsCache) do
            if itemTable.itemQuality == 7 then
                TopFit.itemsCache[itemLink] = nil
                TopFit.scoresCache[itemLink] = nil
            end
        end--]]

        -- if an auto-update-set is set, update that as well
        TopFit:ClearCache()
        TopFit:RunAutoUpdate()
    elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
        TopFit:ClearCache()
        if not TopFit.db.profile.preventAutoUpdateOnRespec then
            TopFit:RunAutoUpdate()
        end
    end
end

function TopFit:RunAutoUpdate(skipDelay)
    if not TopFit.workSetList then
        TopFit.workSetList = {}
    end
    local runUpdate = false;
    if (TopFit.db.profile.defaultUpdateSet and GetActiveSpecGroup() == 1) then
        tinsert(TopFit.workSetList, TopFit.db.profile.defaultUpdateSet)
        runUpdate = true;
    end
    if (TopFit.db.profile.defaultUpdateSet2 and GetActiveSpecGroup() == 2) then
        tinsert(TopFit.workSetList, TopFit.db.profile.defaultUpdateSet2)
        runUpdate = true;
    end
    if runUpdate then
        if not TopFit.autoUpdateTimerFrame then
            TopFit.autoUpdateTimerFrame = CreateFrame("Frame")
        end
        -- because right on level up there seem to be problems finding the items for equipping, delay the actual update
        if not skipDelay then
            TopFit.delayCalculation = 0.5 -- delay in seconds until update
        else
            TopFit.delayCalculation = 0
        end
        TopFit.autoUpdateTimerFrame:SetScript("OnUpdate", function(self, delay)
            if (TopFit.delayCalculation > 0) then
                TopFit.delayCalculation = TopFit.delayCalculation - delay
            else
                TopFit.autoUpdateTimerFrame:SetScript("OnUpdate", nil)
                TopFit:CalculateSets(true) -- calculate silently
            end
        end)
    end
end

function ns:CreateEquipmentSet(set)
    if (CanUseEquipmentSets()) then
        setName = ns:GenerateSetName(set)
        -- check if a set with this name exists
        if (GetEquipmentSetInfoByName(setName)) then
            texture = GetEquipmentSetInfoByName(setName)
        else
            texture = "Spell_Holy_EmpowerChampion"
        end

        ns:Debug("Trying to create set: "..setName..", "..(texture or "nil"))
        SaveEquipmentSet(setName, texture)
    end
end

-- frame for eventhandling
ns.eventFrame = CreateFrame("Frame")
ns.eventFrame:SetScript("OnEvent", ns.FrameOnEvent)
ns.eventFrame:RegisterEvent("ADDON_LOADED")

-----------------------------------------------------
-- database access functions
-----------------------------------------------------

-- get a list of all set IDs in the database
function ns.GetSetList(useTable)
    local setList = useTable and wipe(useTable) or {}
    for setName, _ in pairs(ns.db.profile.sets) do
        tinsert(setList, setName)
    end
    return setList
end

-- get a set object from the database
function ns.GetSetByID(setID, useGlobalInstance)
    assert(type(ns.db.profile.sets[setID]) ~= nil, "GetSetByID: invalid set ID given")

    if not useGlobalInstance then
        return ns.Set.CreateFromSavedVariables(ns.db.profile.sets[setID])
    else
        if not ns.setObjectCache then
            ns.setObjectCache = {}
        end
        if not ns.setObjectCache[setID] then
            ns.setObjectCache[setID] = ns.Set.CreateWritableFromSavedVariables(setID)
        end

        return ns.setObjectCache[setID]
    end
end
