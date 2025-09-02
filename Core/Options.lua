local options = {
    name = "EquipmentManagerClassic",
    handler = EMC,
    type = 'group',
    args = {
        debug = {
            type = 'toggle',
            name = 'Debug Mode',
            desc = 'Toggle debug mode',
            get = function() return EMC.debugMode; end,
            set = function(_, val) EMC.debugMode = val; end,
        },
    },
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("EquipmentManagerClassic", options);
EMC.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("EquipmentManagerClassic", "EquipmentManagerClassic");