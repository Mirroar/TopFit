
-- utility for rounding
function round(input, places)
    if not places then
        places = 0
    end
    if type(input) == "number" and type(places) == "number" then
        local pow = 1
        for i = 1, ceil(places) do
            pow = pow * 10
        end
        return floor(input * pow + 0.5) / pow
    else
        return input
    end
end

-- for keeping a set's icon intact when it is updated
local function GetTextureIndex(tex) -- blatantly stolen from Tekkubs EquipSetUpdate. Thanks!
    RefreshEquipmentSetIconInfo()
    tex = tex:lower()
    local numicons = GetNumMacroIcons()
    for i = INVSLOT_FIRST_EQUIPPED,INVSLOT_LAST_EQUIPPED do if GetInventoryItemTexture("player", i) then numicons = numicons + 1 end end
    for i = 1, numicons do
        local texture, index = GetEquipmentSetIconInfo(i)
        if texture:lower() == tex then return index end
    end
end

-- create Addon object
TopFit = LibStub("AceAddon-3.0"):NewAddon("TopFit", "AceConsole-3.0")

-- debug function
function TopFit:Debug(text)
    if self.db.profile.debugMode then
        TopFit:Print("Debug: "..text)
    end
end

-- debug function
function TopFit:Warning(text)
    --TODO: create table of warnings and dont print any multiples
    --TopFit:Print("|cffff0000Warning: "..text)
end

-- joins any number of tables together, one after the other. elements within the input-tables will get mixed, though
function TopFit:JoinTables(...)
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

function TopFit:EquipRecommendedItems()
    -- equip them
    TopFit.updateEquipmentCounter = 10000
    TopFit.equipRetries = 0
    TopFit.updateFrame:SetScript("OnUpdate", TopFit.onUpdateForEquipment)
end

function TopFit:onUpdateForEquipment()
    -- don't try equipping in combat or while dead
    if UnitAffectingCombat("player") or UnitIsDeadOrGhost("player") then
        return
    end

    -- see if all items already fit
    allDone = true
    for slotID, recTable in pairs(TopFit.itemRecommendations) do
        if (TopFit:GetItemScore(recTable.locationTable.itemLink, TopFit.setCode, TopFit.ignoreCapsForCalculation) > 0) then
            slotItemLink = GetInventoryItemLink("player", slotID)
            if (slotItemLink ~= recTable.locationTable.itemLink) then
                allDone = false
            end
        end
    end
    
    TopFit.updateEquipmentCounter = TopFit.updateEquipmentCounter + 1
    
    -- try equipping the items every 100 frames (some weird ring positions might stop us from correctly equipping items on the first try, for example)
    if (TopFit.updateEquipmentCounter > 100) then
        for slotID, recTable in pairs(TopFit.itemRecommendations) do
            slotItemLink = GetInventoryItemLink("player", slotID)
            if (slotItemLink ~= recTable.locationTable.itemLink) then
                -- find itemLink in bags
                local itemTable = nil
                local found = false
                local foundBag, foundSlot
                for bag = 0, 4 do
                    for slot = 1, GetContainerNumSlots(bag) do
                        local itemLink = GetContainerItemLink(bag,slot)
                        
                        if itemLink == recTable.locationTable.itemLink then
                            foundBag = bag
                            foundSlot = slot
                            found = true
                            break
                        end
                    end
                end
                
                if not found then
                    -- try to find item in equipped items
                    for _, invSlot in pairs(TopFit.slots) do
                        local itemLink = GetInventoryItemLink("player", invSlot)
                        
                        if itemLink == recTable.locationTable.itemLink then
                            foundBag = nil
                            foundSlot = invSlot
                            found = true
                            break
                        end
                    end
                end
                
                if not found then
                    TopFit:Print(recTable.locationTable.itemLink.." could not be found in your inventory for equipping! Did you remove it during calculation?")
                    TopFit.itemRecommendations[slotID] = nil
                else
                    -- try equipping the item again
                    --TODO: if we try to equip offhand, and mainhand is two-handed, and no titan's grip, unequip mainhand first
                    ClearCursor()
                    if foundBag then
                        PickupContainerItem(foundBag, foundSlot)
                    else
                        PickupInventoryItem(foundSlot)
                    end
                    EquipCursorItem(slotID)
                end
            end
        end
        
        TopFit.updateEquipmentCounter = 0
        TopFit.equipRetries = TopFit.equipRetries + 1
    end
    
    -- if all items have been equipped, save equipment set and unregister script
    -- also abort if it takes to long, just save the items that _have_ been equipped
    if ((allDone) or (TopFit.equipRetries > 5)) then
        if (not allDone) then
            TopFit:Print("Oh. I am sorry, but I must have made a mistake. I cannot equip all the items I chose:")
            
            for slotID, recTable in pairs(TopFit.itemRecommendations) do
                slotItemLink = GetInventoryItemLink("player", slotID)
                if (slotItemLink ~= recTable.locationTable.itemLink) then
                    TopFit:Print("  "..recTable.locationTable.itemLink.." into Slot "..slotID.." ("..TopFit.slotNames[slotID]..")")
                    TopFit.itemRecommendations[slotID] = nil
                end
            end
        end
        
        TopFit:Debug("All Done!")
        TopFit.updateFrame:SetScript("OnUpdate", nil)
        TopFit.ProgressFrame:StoppedCalculation()
        
        EquipmentManagerClearIgnoredSlotsForSave()
        for _, slotID in pairs(TopFit.slots) do
            if (not TopFit.itemRecommendations[slotID]) then
                TopFit:Debug("Ignoring slot "..slotID)
                EquipmentManagerIgnoreSlotForSave(slotID)
            end
        end
        
        -- save equipment set
        if (CanUseEquipmentSets()) then
            setName = TopFit:GenerateSetName(TopFit.currentSetName)
            -- check if a set with this name exists
            if (GetEquipmentSetInfoByName(setName)) then
                texture = GetEquipmentSetInfoByName(setName)
                texture = "Interface\\Icons\\"..texture
                
                textureIndex = GetTextureIndex(texture)
            else
                textureIndex = GetTextureIndex("Interface\\Icons\\Spell_Holy_EmpowerChampion")
            end
            
            TopFit:Debug("Trying to save set: "..setName..", "..(textureIndex or "nil"))
            SaveEquipmentSet(setName, textureIndex)
        end
    
        -- we are done with this set
        TopFit.isBlocked = false
        
        -- reset relevant score field
        TopFit.ignoreCapsForCalculation = nil
        
        --TopFit.itemListBySlot = nil
        
        -- initiate next calculation if necessary
        if (#TopFit.workSetList > 0) then
            TopFit:CalculateSets()
        end
    end
end

function TopFit:GenerateSetName(name)
    -- using substr because blizzard interface only allows 16 characters
    -- although technically SaveEquipmentSet & co allow more ;)
    return (((name ~= nil) and string.sub(name.." ", 1, 12).."(TF)") or "TopFit")
end

function TopFit:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory("TopFit")
    else
        if input:trim():lower() == "show" then
            TopFit:CreateProgressFrame()
        elseif input:trim():lower() == "options" then
            InterfaceOptionsFrame_OpenToCategory("TopFit")
        else
            TopFit:Print("Available Options:\n  show - shows the calculations frame\n  options - shows TopFit's options")
        end
    end
end

function TopFit:OnInitialize()
    -- load saved variables
    self.db = LibStub("AceDB-3.0"):New("TopFitDB")
    
    -- create gametooltip for scanning
    TopFit.scanTooltip = CreateFrame('GameTooltip', 'TFScanTooltip', UIParent, 'GameTooltipTemplate')

    -- check if any set is saved already, if not, create default
    if (not self.db.profile.sets) then
        self.db.profile.sets = {
            set_1 = {
                name = "Default Set",
                weights = {},
                caps = {},
                forced = {},
            },
        }
    end
    
    -- for savedvariable updates: check if each set has a forced table
    for set, table in pairs(self.db.profile.sets) do
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
    TopFit.statList = {
        ["Basic Attributes"] = {
            [1] = "ITEM_MOD_AGILITY_SHORT",
            [2] = "ITEM_MOD_INTELLECT_SHORT",
            [3] = "ITEM_MOD_SPIRIT_SHORT",
            [4] = "ITEM_MOD_STAMINA_SHORT",
            [5] = "ITEM_MOD_STRENGTH_SHORT",
        },
        ["Melee"] = {
            [1] = "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT",
            [2] = "ITEM_MOD_ATTACK_POWER_SHORT",
            [3] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
            [4] = "ITEM_MOD_FERAL_ATTACK_POWER_SHORT",
        },
        ["Caster"] = {
            [1] = "ITEM_MOD_SPELL_PENETRATION_SHORT",
            [2] = "ITEM_MOD_SPELL_POWER_SHORT",
            [3] = "ITEM_MOD_MANA_REGENERATION_SHORT",
        },
        ["Defensive"] = {
            [1] = "ITEM_MOD_BLOCK_RATING_SHORT",
            [2] = "ITEM_MOD_BLOCK_VALUE_SHORT",
            [3] = "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT",
            [4] = "ITEM_MOD_DODGE_RATING_SHORT",
            [5] = "ITEM_MOD_PARRY_RATING_SHORT",
            [6] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
            [7] = "RESISTANCE0_NAME",                   -- armor
        },
        ["Hybrid"] = {
            [1] = "ITEM_MOD_CRIT_RATING_SHORT",
            [2] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT",
            [3] = "ITEM_MOD_HASTE_RATING_SHORT",
            [4] = "ITEM_MOD_HIT_RATING_SHORT",
        },
        ["Misc."] = {
            [1] = "ITEM_MOD_HEALTH_SHORT",
            [2] = "ITEM_MOD_MANA_SHORT",
            [3] = "ITEM_MOD_HEALTH_REGENERATION_SHORT",
        },
        ["Resistances"] = {
            [1] = "RESISTANCE1_NAME",                   -- holy
            [2] = "RESISTANCE2_NAME",                   -- fire
            [3] = "RESISTANCE3_NAME",                   -- nature
            [4] = "RESISTANCE4_NAME",                   -- frost
            [5] = "RESISTANCE5_NAME",                   -- shadow
            [6] = "RESISTANCE6_NAME",                   -- arcane
        },
    }
    
    -- list of inventory slot names
    TopFit.slotList = {
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
        "RangedSlot",
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
    TopFit.slots = {}
    TopFit.slotNames = {}
    for _, slotName in pairs(TopFit.slotList) do
        local slotID, _, _ = GetInventorySlotInfo(slotName)
        TopFit.slots[slotName] = slotID;
        TopFit.slotNames[slotID] = slotName;
    end
    
    -- create frame for OnUpdate
    TopFit.updateFrame = CreateFrame("Frame")
    
    -- create options
    TopFit:createOptions()

    -- register Slash command
    self:RegisterChatCommand("topfit", "ChatCommand")
    self:RegisterChatCommand("tf", "ChatCommand")
    
    -- cache tables
    TopFit.itemsCache = {}
    TopFit.scoresCache = {}
    
    -- table for equippable item list
    TopFit.equippableItems = {}
    TopFit:collectEquippableItems()
    TopFit.loginDelay = 150
    
    -- frame for eventhandling
    TopFit.eventFrame = CreateFrame("Frame")
    TopFit.eventFrame:RegisterEvent("BAG_UPDATE")
    TopFit.eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
    TopFit.eventFrame:SetScript("OnEvent", TopFit.FrameOnEvent)
    TopFit.eventFrame:SetScript("OnUpdate", TopFit.delayCalculationOnLogin)
    
    -- frame for calculation function
    TopFit.calculationsFrame = CreateFrame("Frame");
    
    -- heirloom info
    local isPlateWearer, isMailWearer = false, false
    if (select(2, UnitClass("player")) == "WARRIOR") or (select(2, UnitClass("player")) == "PALADIN") or (select(2, UnitClass("player")) == "DEATHKNIGHT") then
        isPlateWearer = true
    end
    if (select(2, UnitClass("player")) == "SHAMAN") or (select(2, UnitClass("player")) == "HUNTER") then
        isMailWearer = true
    end
    
    -- tables of itemIDs for heirlooms which change armor type
    TopFit.heirloomInfo = {
        plateHeirlooms = {
            [3] = {
                [1] = 42949,
                [2] = 44100,
                [3] = 44099,
            },
            [5] = {
                [1] = 48685,
            },
        },
        mailHeirlooms = {
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
    TopFit.plugins = {}
    
    -- button to open frame
    hooksecurefunc("ToggleCharacter", function (...)
        if not TopFit.toggleProgressFrameButton then
            TopFit.toggleProgressFrameButton = CreateFrame("Button", "TopFit_toggleProgressFrameButton", PaperDollFrame)
            TopFit.toggleProgressFrameButton:SetWidth(30)
            TopFit.toggleProgressFrameButton:SetHeight(32)
            TopFit.toggleProgressFrameButton:SetPoint("RIGHT", GearManagerToggleButton, "LEFT")
            
            local normalTexture = TopFit.toggleProgressFrameButton:CreateTexture()
            local pushedTexture = TopFit.toggleProgressFrameButton:CreateTexture()
            local highlightTexture = TopFit.toggleProgressFrameButton:CreateTexture()
            normalTexture:SetTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Up")
            pushedTexture:SetTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Down")
            highlightTexture:SetTexture("Interface\\Buttons\\UI-MicroButton-Hilight")
            normalTexture:SetTexCoord(0, 25/64, 0, 63/64, 1, 25/64, 1, 62/64)
            normalTexture:SetAllPoints()
            pushedTexture:SetTexCoord(0, 25/64, 0, 63/64, 1, 25/64, 1, 62/64)
            pushedTexture:SetAllPoints()
            highlightTexture:SetTexCoord(0, 25/64, 0, 63/64, 1, 25/64, 1, 62/64)
            highlightTexture:SetAllPoints()
            TopFit.toggleProgressFrameButton:SetNormalTexture(normalTexture)
            TopFit.toggleProgressFrameButton:SetPushedTexture(pushedTexture)
            TopFit.toggleProgressFrameButton:SetHighlightTexture(highlightTexture)
            local iconTexture = TopFit.toggleProgressFrameButton:CreateTexture()
            iconTexture:SetTexture("Interface\\Icons\\Achievement_BG_trueAVshutout") -- golden sword
            iconTexture:SetTexCoord(9/64, 4/64, 9/64, 61/64, 55/64, 4/64, 55/64, 61/64)
            iconTexture:SetDrawLayer("OVERLAY")
            iconTexture:SetBlendMode("ADD")
            iconTexture:SetPoint("TOPLEFT", TopFit.toggleProgressFrameButton, "TOPLEFT", 6, -4)
            iconTexture:SetPoint("BOTTOMRIGHT", TopFit.toggleProgressFrameButton, "BOTTOMRIGHT", -6, 4)
            
            TopFit.toggleProgressFrameButton:SetScript("OnClick", function(...)
                if (not TopFit.ProgressFrame) or (not TopFit.ProgressFrame:IsShown()) then
                    TopFit:CreateProgressFrame()
                else
                    TopFit:HideProgressFrame()
                end
            end)
            
            TopFit.toggleProgressFrameButton:SetScript("OnMouseDown", function(...)
                iconTexture:SetVertexColor(0.5, 0.5, 0.5)
            end)
            TopFit.toggleProgressFrameButton:SetScript("OnMouseUp", function(...)
                iconTexture:SetVertexColor(1, 1, 1)
            end)
            
            -- tooltip
            TopFit.toggleProgressFrameButton:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText("Open TopFit", nil, nil, nil, nil, true)
                GameTooltip:Show()
            end)
            TopFit.toggleProgressFrameButton:SetScript("OnLeave", function(...)
                GameTooltip:Hide()
            end)
        end
        if GearManagerToggleButton:IsShown() then
            TopFit.toggleProgressFrameButton:SetPoint("RIGHT", GearManagerToggleButton, "LEFT", 4, 0)
        else
            TopFit.toggleProgressFrameButton:SetPoint("RIGHT", GearManagerToggleButton, "RIGHT")
        end
    end)
    
    TopFit:collectItems()
end

function TopFit:collectEquippableItems()
    local newItem = false
    
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
                    newItem = true
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
                newItem = true
            end
        end
    end
    
    return newItem
end

function TopFit:delayCalculationOnLogin()
    if TopFit.loginDelay then
        TopFit.loginDelay = TopFit.loginDelay - 1
        if TopFit.loginDelay <= 0 then
            TopFit.loginDelay = nil
            TopFit.eventFrame:SetScript("OnUpdate", nil)
        end
    end
end

function TopFit:FrameOnEvent(event, ...)
    if (event == "BAG_UPDATE") then
        -- update item list
        --TODO: only update affected bag
        TopFit:collectItems()
        
        -- check inventory for new equippable items
        if TopFit:collectEquippableItems() and not TopFit.loginDelay then
            -- new equippable item in inventory!!!!
            -- calculate set silently if player wishes
            if TopFit.db.profile.defaultUpdateSet then
                if not TopFit.workSetList then
                    TopFit.workSetList = {}
                end
                tinsert(TopFit.workSetList, TopFit.db.profile.defaultUpdateSet)
                
                TopFit:CalculateSets(true) -- calculate silently
            end
        end
    elseif (event == "PLAYER_LEVEL_UP") then
        -- remove cache info for heirlooms so they are rescanned
        for itemLink, itemTable in pairs(TopFit.itemsCache) do
            if itemTable.itemQuality == 7 then
                TopFit.itemsCache[itemLink] = nil
                TopFit.scoresCache[itemLink] = nil
            end
        end
        
        -- if an auto-update-set is set, update that as well
        if TopFit.db.profile.defaultUpdateSet then
            if not TopFit.workSetList then
                TopFit.workSetList = {}
            end
            tinsert(TopFit.workSetList, TopFit.db.profile.defaultUpdateSet)
            
            TopFit:CalculateSets(true) -- calculate silently
        end
    end
end

function TopFit:OnEnable()
    -- Called when the addon is enabled
end

function TopFit:OnDisable()
    -- Called when the addon is disabled
end

-- Tooltip functions
local cleared = true
local refCleared = true
local s1Cleared = true
local s2Cleared = true

local function TooltipAddCompareLines(tt, link)
    local itemTable = TopFit:GetCachedItem(link)
    
    TopFit:Debug("Adding Compare Tooltip for "..(link or "nil"))
    
    -- if the item is not yet cached, no tooltip info is added
    if not itemTable then
        return
    end
    
    -- iterate all sets and compare with set's items
    tt:AddLine(" ")
    tt:AddLine("Compared with your current items for each set:")
    for setCode, setTable in pairs(TopFit.db.profile.sets) do
        if not TopFit.db.profile.sets[setCode].excludeFromTooltip then
            -- find current item(s) from set
            local itemPositions = GetEquipmentSetLocations(TopFit:GenerateSetName(setTable.name))
            local itemIDs = GetEquipmentSetItemIDs(TopFit:GenerateSetName(setTable.name))
            local itemLinks = {}
            if itemPositions then
                for slotID, itemLocation in pairs(itemPositions) do
                    if itemLocation and itemLocation ~= 1 and itemLocation ~= 0 then -- 0: set to no item; 1: slot is ignored
                        local itemLink = nil
                        local player, bank, bags, slot, bag = EquipmentManager_UnpackLocation(itemLocation)
                        if player then
                            if bank then
                                -- item is banked, use itemID
                                local itemID = GetEquipmentSetItemIDs(TopFit:GenerateSetName(TopFit.db.profile.sets[setCode].name))[slotID]
                                if itemID and itemID ~= 1 then
                                    _, itemLink = GetItemInfo(itemID)
                                end
                            elseif bags then
                                -- item is in player's bags
                                itemLink = GetContainerItemLink(bag, slot)
                            else
                                -- item is equipped
                                itemLink = GetInventoryItemLink("player", slot)
                            end
                        else
                            -- item not found
                        end
                        itemLinks[slotID] = itemLink
                    end
                end
                
                for _, slotID in pairs(itemTable.equipLocationsByType) do
                    -- get compare items sorted out
                    local itemID = nil
                    local itemLink = nil
                    local rawScore, asIsScore, rawCompareScore, asIsCompareScore = 0, 0, 0, 0
                    local extraText = ""
                    local compareTable = nil
                    local itemTable2 = nil
                    local compareTable2 = nil
                    local compareNotCached = false
                    
                    rawScore = TopFit:GetItemScore(itemTable.itemLink, setCode, false, true) -- including caps, raw score
                    asIsScore = TopFit:GetItemScore(itemTable.itemLink, setCode, false, false) -- including caps, enchanted score
                    
                    if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 and itemIDs[slotID] ~= 0 then
                        itemID = itemIDs[slotID]
                        itemLink = itemLinks[slotID]
                        
                        if itemLink then
                            compareTable = TopFit:GetCachedItem(itemLink)
                        end
                        
                        if compareTable then
                            rawCompareScore = TopFit:GetItemScore(compareTable.itemLink, setCode, false, true)
                            asIsCompareScore = TopFit:GetItemScore(compareTable.itemLink, setCode, false, false)
                        else
                            compareNotCached = true
                        end
                    end
                    
                    -- location tables for best-in-slot requests
                    local locationTable, compLocationTable
                    if (slotID == 16 or slotID == 17) then
                        locationTable = {itemLink = itemTable.itemLink, slot = nil, bag = nil}
                        if compareTable then
                            local player, bank, bags, slot, bag = EquipmentManager_UnpackLocation(itemPositions[slotID])
                            if player then
                                if bags then
                                    compLocationTable = {itemLink = compareTable.itemLink, slot = slot, bag = bag}
                                elseif bank then
                                    compLocationTable = {itemLink = compareTable.itemLink, slot = nil, bag = nil}
                                else
                                    compLocationTable = {itemLink = compareTable.itemLink, slot = slot, bag = nil}
                                end
                            else
                                compLocationTable = {itemLink = compareTable.itemLink, slot = nil, bag = nil}
                            end
                        else
                            compLocationTable = {itemLink = "", slot = nil, bag = nil}
                        end
                    end
                    
                    if slotID == 16 then -- main hand slot
                        if TopFit:IsOnehandedWeapon(link) then
                            -- is the weapon we compare to (if it exists) two-handed?
                            if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 and itemIDs[slotID] ~= 0 and not TopFit:IsOnehandedWeapon(itemIDs[slotID]) then
                                -- try to find a fitting offhand for better comparison
                                if TopFit.playerCanDualwield then
                                    -- find best offhand regardless of type
                                    local lTable2 = TopFit:CalculateBestInSlot({locationTable, compLocationTable}, false, 17, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(locationTable.itemLink) end)
                                    if lTable2 then
                                        itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
                                    end
                                else
                                    -- find best offhand that is not a weapon
                                    local lTable2 = TopFit:CalculateBestInSlot({locationTable, compLocationTable}, false, 17, setCode, function(locationTable) itemTable = TopFit:GetCachedItem(locationTable.itemLink); if not itemTable or string.find(itemTable.itemEquipLoc, "WEAPON") then return false else return true end end)
                                    if lTable2 then
                                        itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
                                    end
                                end
                            else
                            end
                        else
                            if itemIDs and itemIDs[slotID] and itemIDs[slotID] ~= 1 then
                                -- mainhand is set
                                if TopFit:IsOnehandedWeapon(itemIDs[slotID]) then
                                    -- use offhand of that set as second compare item
                                    if (itemLinks[17]) then
                                        compareTable2 = TopFit:GetCachedItem(itemLinks[17])
                                    end
                                else
                                    -- compare normally, these are 2 two-handed weapons
                                end
                            else
                                -- compare with offhand if appliccapble
                                if (itemLinks[17]) then
                                    compareTable2 = TopFit:GetCachedItem(itemLinks[17])
                                end
                            end
                        end
                    elseif slotID == 17 then -- offhand slot
                        -- find a valid mainhand to use in comparisons (only when comparing to a 2h)
                        if itemIDs and itemIDs[16] and itemIDs[16] ~= 1 and not TopFit:IsOnehandedWeapon(itemIDs[16]) then
                            local lTable2 = TopFit:CalculateBestInSlot({locationTable, compLocationTable}, false, 16, setCode, function(locationTable) return TopFit:IsOnehandedWeapon(locationTable.itemLink) end)
                            if lTable2 then
                                itemTable2 = TopFit:GetCachedItem(lTable2.itemLink)
                            end
                            
                            -- also set compareTable to the relevant MAIN HAND! since offhand is empty, obviously
                            compareTable = TopFit:GetCachedItem(itemLinks[16])
                            
                            if compareTable then
                                rawCompareScore = TopFit:GetItemScore(compareTable.itemLink, setCode, false, true)
                                asIsCompareScore = TopFit:GetItemScore(compareTable.itemLink, setCode, false, false)
                            else
                                compareNotCached = true
                            end
                        end
                    end
                    
                    if itemTable2 then
                        rawScore = rawScore + TopFit:GetItemScore(itemTable2.itemLink, setCode, false, true)
                        asIsScore = asIsScore + TopFit:GetItemScore(itemTable2.itemLink, setCode, false, false)
                        
                        extraText = extraText..", if you also use "..itemTable2.itemLink
                    end
                    
                    if compareTable2 then
                        rawCompareScore = rawCompareScore + TopFit:GetItemScore(compareTable2.itemLink, setCode, false, true)
                        asIsCompareScore = asIsCompareScore + TopFit:GetItemScore(compareTable2.itemLink, setCode, false, false)
                        
                        extraText = extraText..", "..compareTable2.itemLink
                    end
                    
                    local ratio, rawRatio, ratioString, rawRatioString = 1, 1, "", ""
                    if rawCompareScore ~= 0 then
                        rawRatio = rawScore / rawCompareScore
                    elseif rawScore > 0 then
                        rawRatio = 20
                    elseif rawScore < 0 then
                        rawRatio = -20
                    end
                    if asIsCompareScore ~= 0 then
                        ratio = asIsScore / asIsCompareScore
                    elseif asIsScore > 0 then
                        ratio = 20
                    elseif asIsScore < 0 then
                        ratio = -20
                    end
                    
                    local function percentilize(ratio)
                        local ratioString
                        if ratio > 11 then
                            ratioString = "|cff00ff00> 1000%|r"
                        elseif ratio > 1.1 then
                            ratioString = "|cff00ff00"..round((ratio - 1) * 100, 2).."%|r"
                        elseif ratio >= 1 then
                            ratioString = "|cffffff00"..round((ratio - 1) * 100, 2).."%|r"
                        elseif ratio < -9 then
                            ratioString = "|cffff0000< -1000%|r"
                        else -- ratio < 1
                            ratioString = "|cffff0000"..round((ratio - 1) * 100, 2).."%|r"
                        end
                        return ratioString
                    end
                    
                    local compareItemText = ""
                    if compareNotCached then
                        compareItemText = "Item not in cache!|n"
                    elseif not compareTable then
                        compareItemText = "No item in set"
                    else
                        compareItemText = compareTable.itemLink
                    end
                    
                    if ratio ~= rawRatio then
                        tt:AddDoubleLine("["..percentilize(rawRatio).."/"..percentilize(ratio).."] - "..compareItemText..extraText, setTable.name)
                    else
                        tt:AddDoubleLine("["..percentilize(rawRatio).."] - "..compareItemText..extraText, setTable.name)
                    end
                end
            end
        end
    end
end

local function TooltipAddLines(tt, link)
    local itemTable = TopFit:GetCachedItem(link)
    
    if not itemTable then return end
    
    if (TopFit.db.profile.debugMode) then
        -- item stats
        tt:AddLine("Item stats as seen by TopFit:", 0.5, 0.9, 1)
        for stat, value in pairs(itemTable["itemBonus"]) do
            if not string.find(stat, "SET: ") then
                local valueString = ""
                local first = true
                for _, setTable in pairs(TopFit.db.profile.sets) do
                    local weightedValue = (setTable.weights[stat] or 0) * value
                    if first then
                        first = false
                    else
                        valueString = valueString.." / "
                    end
                    valueString = valueString..(tonumber(weightedValue) or "0")
                end
                tt:AddDoubleLine("  +"..value.." ".._G[stat], valueString, 0.5, 0.9, 1)
            end
        end
        
        -- enchantment stats
        if (itemTable["enchantBonus"]) then
            tt:AddLine("Enchant:", 1, 0.9, 0.5)
            for stat, value in pairs(itemTable["enchantBonus"]) do
                local valueString = ""
                local first = true
                for _, setTable in pairs(TopFit.db.profile.sets) do
                    local weightedValue = (setTable.weights[stat] or 0) * value
                    if first then
                        first = false
                    else
                        valueString = valueString.." / "
                    end
                    valueString = valueString..(tonumber(weightedValue) or "0")
                end
                tt:AddDoubleLine("  +"..value.." ".._G[stat], valueString, 1, 0.9, 0.5)
            end
        end
        
        -- gems
        if (itemTable["gemBonus"]) then
            local first = true
            for stat, value in pairs(itemTable["gemBonus"]) do
                if first then
                    first = false
                    tt:AddLine("Gems:", 0.8, 0.2, 0)
                end
                
                local valueString = ""
                local first = true
                for _, setTable in pairs(TopFit.db.profile.sets) do
                    local weightedValue = (setTable.weights[stat] or 0) * value
                    if first then
                        first = false
                    else
                        valueString = valueString.." / "
                    end
                    valueString = valueString..(tonumber(weightedValue) or "0")
                end
                tt:AddDoubleLine("  +"..value.." ".._G[stat], valueString, 0.8, 0.2, 0)
            end
        end
    end
    
    if (TopFit.db.profile.showTooltip) then
        -- scores for sets
        local first = true
        for setCode, setTable in pairs(TopFit.db.profile.sets) do
            if not TopFit.db.profile.sets[setCode].excludeFromTooltip then
                if first then
                    first = false
                    tt:AddLine("Set Values:", 0.6, 1, 0.7)
                end
                
                tt:AddLine("  "..round(TopFit:GetItemScore(itemTable.itemLink, setCode), 2).." - "..setTable.name, 0.6, 1, 0.7)
            end
        end
    end
end

local function OnTooltipCleared(self)
    cleared = true   
end

local function OnTooltipSetItem(self)
    if cleared then
        local name, link = self:GetItem()
        if (name) then
            local equippable = IsEquippableItem(link)
            if (not equippable) then
                -- Do nothing
            else
                TooltipAddLines(self, link)
                if (TopFit.db.profile.showComparisonTooltip and not TopFit.isBlocked) then
                    TooltipAddCompareLines(self, link)
                end
            end
            cleared = false
        end
    end
end

local function OnRefTooltipCleared(self)
    refCleared = true   
end

local function OnRefTooltipSetItem(self)
    if refCleared then
        local name, link = self:GetItem()
        if (name) then
            local equippable = IsEquippableItem(link)
            if (not equippable) then
                -- Do nothing
            else
                TooltipAddLines(self, link)
                if (TopFit.db.profile.showComparisonTooltip and not TopFit.isBlocked) then
                    TooltipAddCompareLines(self, link)
                end
            end
            refCleared = false
        end
    end
end

local function OnShoppingTooltip1Cleared(self)
    s1Cleared = true   
end

local function OnShoppingTooltip1SetItem(self)
    if s1Cleared then
        local name, link = self:GetItem()
        if (name) then
            local equippable = IsEquippableItem(link)
            if (not equippable) then
                -- Do nothing
            else
                TooltipAddLines(self, link)
            end
            s1Cleared = false
        end
    end
end

local function OnShoppingTooltip2Cleared(self)
    s2Cleared = true   
end

local function OnShoppingTooltip2SetItem(self)
    if s2Cleared then
        local name, link = self:GetItem()
        if (name) then
            local equippable = IsEquippableItem(link)
            if (not equippable) then
                -- Do nothing
            else
                TooltipAddLines(self, link)
            end
            s2Cleared = false
        end
    end
end

GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipCleared", OnRefTooltipCleared)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnRefTooltipSetItem)
ShoppingTooltip1:HookScript("OnTooltipCleared", OnShoppingTooltip1Cleared)
ShoppingTooltip1:HookScript("OnTooltipSetItem", OnShoppingTooltip1SetItem)
ShoppingTooltip2:HookScript("OnTooltipCleared", OnShoppingTooltip2Cleared)
ShoppingTooltip2:HookScript("OnTooltipSetItem", OnShoppingTooltip2SetItem)
