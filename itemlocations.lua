--- Code in this file is responsible for keeping track of the player's equippable items,
-- how many he has and where he has them. Only items in bags and equipped on the player interest us.

local addonName, ns = ...

--- This table stores which items are in which inventory slot or bag slot
local equipment = {
    [_G.EQUIPMENT_CONTAINER] = {},
}
for i = 0, NUM_BAG_SLOTS do
    equipment[i] = {}
end

--- This table stores locations that equippable items can be found in, for easy lookups
local equipmentLocations = {}

local ItemLocations = LibStub('LibItemLocations')

-- Events: PLAYER_EQUIPMENT_CHANGED, BAG_UPDATE, BAG_UPDATE_DELAYED


--TODO: record changed items
--[[
tinsert(newItems, {
    itemLink = itemLink,
    slot = invSlot,
})
tinsert(newItems, {
    itemLink = itemLink,
    bag = bagID,
    slot = slot,
})
--]]
local function AddEquipLocation(itemLink, location)
    if not equipmentLocations[itemLink] then
        equipmentLocations[itemLink] = {}
    end
    tinsert(equipmentLocations[itemLink], location)
end

local function RemoveEquipLocation(itemLink, location)
    for i = #equipmentLocations[itemLink], 1, -1 do
        if location == equipmentLocations[itemLink][i] then
            tremove(equipmentLocations[itemLink], 1)
            break
        end
    end
end

local function UpdateEquipLocation(container, slot, itemLink)
    local location = ItemLocations:GetLocation(container, slot)

    if equipment[container][slot] then
        -- there was an item previously equipped in this slot
        RemoveEquipLocation(equipment[container][slot], location)
    end
    if itemLink and IsEquippableItem(itemLink) and not ns.Unfit:IsItemUnusable(itemLink) and (container == _G.EQUIPMENT_CONTAINER or ns:CanUseItemBinding(container, slot)) then
        AddEquipLocation(itemLink, location)
        equipment[container][slot] = itemLink
    else
        equipment[container][slot] = nil
    end
end

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

function ns.CheckBagItems(bagID)
    if not bagID then
        for i = 0, NUM_BAG_SLOTS do
            ns.CheckBagItems(i)
        end
        return
    end

    for slot = 1, GetContainerNumSlots(bagID) do
        local itemLink = GetContainerItemLink(bagID, slot)
        UpdateEquipLocation(bagID, slot, itemLink)
    end
end

-- "API"
function ns.GetItemLocations(itemLink)
    if equipmentLocations[itemLink] then
        return equipmentLocations[itemLink]
    end
    return {}
end

function ns.GetItemCount(itemLink)
    return #(ns.GetItemLocations(itemLink))
end
