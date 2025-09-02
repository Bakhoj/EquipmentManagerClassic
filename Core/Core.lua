    -- https://www.townlong-yak.com/framexml/9.0.2/Constants.lua#192
    -- _G["INVSLOT_FIRST_EQUIPPED"]
    -- _G["INVSLOT_LAST_EQUIPPED"]
    -- _G["INVSLOTS_EQUIPABLE_IN_COMBAT"]
    -- _G["MAX_EQUIPMENT_SETS_PER_PLAYER"]
    -- _G["EQUIPMENT_SET_EMPTY_SLOT"]
    -- _G["EQUIPMENT_SET_IGNORED_SLOTS"]
    -- _G["EQUIPMENT_SET_ITEM_MISSING"]

EMC = LibStub("AceAddon-3.0"):NewAddon("EquipmentManagerClassic", "AceConsole-3.0", "AceEvent-3.0");
EMC.debugMode = true;

local GUI = {};
EMC.GUI = GUI;

EMC._InventoryTypes = function(slot)
    if slot == _G["INVSLOT_AMMO"] then
        return _G["INVTYPE_AMMO"];
    elseif slot == _G["INVSLOT_HEAD"] then
        return _G["INVTYPE_HEAD"];
    elseif slot == _G["INVSLOT_NECK"] then
        return _G["INVTYPE_NECK"];
    elseif slot == _G["INVSLOT_SHOULDER"] then
        return _G["INVTYPE_SHOULDER"];
    elseif slot == _G["INVSLOT_BODY"] then
        return _G["INVTYPE_BODY"];
    elseif slot == _G["INVSLOT_CHEST"] then
        return _G["INVTYPE_CHEST"];
    elseif slot == _G["INVSLOT_WAIST"] then
        return _G["INVTYPE_WAIST"];
    elseif slot == _G["INVSLOT_LEGS"] then
        return _G["INVTYPE_LEGS"];
    elseif slot == _G["INVSLOT_FEET"] then  
        return _G["INVTYPE_FEET"];
    elseif slot == _G["INVSLOT_WRIST"] then
        return _G["INVTYPE_WRIST"];
    elseif slot == _G["INVSLOT_HAND"] then
        return _G["INVTYPE_HAND"];
    elseif slot == _G["INVSLOT_FINGER1"] then
        return _G["INVTYPE_FINGER"] .. "1";
    elseif slot == _G["INVSLOT_FINGER2"] then
        return _G["INVTYPE_FINGER"] .. "2";
    elseif slot == _G["INVSLOT_TRINKET1"] then
        return _G["INVTYPE_TRINKET"] .. "1";
    elseif slot == _G["INVSLOT_TRINKET2"] then
        return _G["INVTYPE_TRINKET"] .. "2";
    elseif slot == _G["INVSLOT_BACK"] then
        return _G["INVTYPE_CLOAK"];
    elseif slot == _G["INVSLOT_MAINHAND"] then
        return _G["INVTYPE_WEAPONMAINHAND"];
    elseif slot == _G["INVSLOT_OFFHAND"] then
        return _G["INVTYPE_WEAPONOFFHAND"];
    elseif slot == _G["INVSLOT_RANGED"] then
        return _G["INVTYPE_RANGED"];
    elseif slot == _G["INVSLOT_TABARD"] then
        return _G["INVTYPE_TABARD"];
    else
        return _G["INVTYPE_NON_EQUIP"];
    end
end

EMC.Utils = {};

---@return boolean list contains obj
---@param obj any
---@param list table
function EMC.Utils:ListContains(obj, list)
    if list == nil then
        return false;
    end
    for _, v in pairs(list) do
        if v == obj then
            return true;
        end
    end
    return false;
end

---@return string name of inventory slot
---@param slot number inventory slot ID (1-19)
function EMC.Utils:InventorySlotToString(slot)
    if tonumber(slot) ~= nil then
        return EMC._InventoryTypes(slot);
    elseif slot:match("^INVTYPE_") then
        return _G[slot];
    end
end

EMC.CallAPI = {};

---@return number[] equipmentSetIDs
function EMC.CallAPI:GetEquipmentSetIDs()
    return C_EquipmentSet.GetEquipmentSetIDs();
end

---@return string name, string icon, number setID, boolean isEquipped, boolean isVisible, number numItems, number numEquipped, number numInInventory, number numLost, number numIgnored
---@param setID number
function EMC.CallAPI:GetEquipmentSetInfo(setID)
    return C_EquipmentSet.GetEquipmentSetInfo(setID);
end

---@return string itemName, string itemLink, string itemRarity, number itemLevel, number itemMinLevel, string itemType, string itemSubType, string itemStackCount, string itemEquipLoc, string iconFileDataID
---@param itemID number
function EMC.CallAPI:GetItemInfo(itemID)
    return GetItemInfo(itemID);
end

---@return boolean[] slotIgnored - indexed by inventory slot ID (1-19)
---@param setID number
function EMC.CallAPI:GetIgnoredSlots(setID)
    return C_EquipmentSet.GetIgnoredSlots(setID);
end

---@return number[] itemIDs - indexed by inventory slot ID (1-19), nil for empty slots
---@param setID number
function EMC.CallAPI:GetItemIDs(setID)
    local items = C_EquipmentSet.GetItemIDs(setID);
    for key, value in pairs(items) do
        if value == -1 then
            items[key] = nil;
        end
    end
    return items;
end

---@return string name
---@param setID number
function EMC.CallAPI:GetEquipmentSetName(setID)
    local name = C_EquipmentSet.GetEquipmentSetInfo(setID);
    return name;
end
