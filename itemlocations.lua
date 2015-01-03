--- Code in this file is responsible for keeping track of the player's equippable items,
-- how many he has and where he has them. Only items in bags and equipped on the player interest us.

local addonName, ns = ...

--- This table stores which items are in which inventory slot or bag slot
local equipment = {}

--- This table stores locations that equippable items can be found in, for easy lookups
local equipmentLocations = {}

--- This table stores which items are added or removed over time
local itemCountChanges = {}

local ItemLocations = LibStub('LibItemLocations')

--- Internal function that records the fact that an item is available at a certain location
-- @param itemLink The item's item link
-- @param location The location the item is available at
local function AddEquipLocation(itemLink, location)
    if not equipmentLocations[itemLink] then
        equipmentLocations[itemLink] = {}
    end
    tinsert(equipmentLocations[itemLink], location)
    itemCountChanges[itemLink] = (itemCountChanges[itemLink] or 0) + 1
end

--- Internal function that records the fact that an item is no longer available at a certain location
-- @param itemLink The item's item link
-- @param location The location the item was available at
local function RemoveEquipLocation(itemLink, location)
    for i = #equipmentLocations[itemLink], 1, -1 do
        if location == equipmentLocations[itemLink][i] then
            tremove(equipmentLocations[itemLink], 1)
            break
        end
    end
    itemCountChanges[itemLink] = (itemCountChanges[itemLink] or 0) - 1
end

--- Internal function that updates what item is available in a certain slot
-- @param container The container that needs updating. Either a bag ID or EQUIPMENT_CONTAINER for equipped items
-- @param slot The container's slot that needs updating
-- @param itemLink The item's item link, or nil if no item is currently in the given slot
local function UpdateEquipLocation(container, slot, itemLink)
    local location = ItemLocations:GetLocation(container, slot)

    if not equipment[container] then equipment[container] = {} end

    if equipment[container][slot] then
        -- there was an item previously equipped in this slot
        RemoveEquipLocation(equipment[container][slot], location)
        equipment[container][slot] = nil
    end
    -- TODO: we might actually want to include monitoring BoE items
    -- by removing the check to ns:CanUseItemBinding and just remove them when calculating
    -- careful: this will affect ns.GetNewItems
    if itemLink and IsEquippableItem(itemLink) and not ns.Unfit:IsItemUnusable(itemLink) and (container == _G.EQUIPMENT_CONTAINER or ns:CanUseItemBinding(container, slot)) then
        AddEquipLocation(itemLink, location)
        equipment[container][slot] = itemLink
    end
end

--- Update information about available items from equipment.
-- @param slotID Slot number to check, or nil to check all equipment slots
function ns.CheckInventoryItems(slotID)
    if not slotID then
        for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
            ns.CheckInventoryItems(i)
        end
        return
    end

    local itemLink = GetInventoryItemLink('player', slotID)
    UpdateEquipLocation(_G.EQUIPMENT_CONTAINER, slotID, itemLink)
end

--- Update information about available items from bags.
-- @param bagID Bag ID to check, or nil to check all bags
function ns.CheckBagItems(bagID)
    for bag = 0, NUM_BAG_SLOTS do
        if not bagID or bag == bagID then
            for slot = 1, GetContainerNumSlots(bag) do
                local itemLink = GetContainerItemLink(bag, slot)
                UpdateEquipLocation(bag, slot, itemLink)
            end
        end
    end
end

--- Get all locations a given item is available at.
-- @param itemLink The item's item link
-- TODO: actually write an iterator that parses the internal location data into something more usable
function ns.GetItemLocations(itemLink)
    if not equipmentLocations[itemLink] then
        equipmentLocations[itemLink] = {}
    end
    return equipmentLocations[itemLink]
end

--- Get the number of times a given item is available to the player
-- @param itemLink The item's item link
function ns.GetItemCount(itemLink)
    return #(ns.GetItemLocations(itemLink))
end

--- Mark all current items as known again
function ns.ResetNewItems()
    wipe(itemCountChanges)
end

--- Get a list of all equipment items that the player has acquired since the last time ns.ResetNewItems was called
function ns.GetNewItems()
    local result = {}

    for itemLink, count in pairs(itemCountChanges) do
        if count > 0 then
            tinsert(result, itemLink)
        end
    end

    return result
end
