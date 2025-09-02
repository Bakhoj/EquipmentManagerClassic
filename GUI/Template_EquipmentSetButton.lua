local AceGUI = LibStub("AceGUI-3.0");
local GUI = EMC.GUI;
local Call = EMC.CallAPI;

--local Type, Version = "LeftMenuButton", 1;


function GUI:CreateEquipmentSetButton(setID, onClick)
    local f = AceGUI:Create("SimpleGroup");
    f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
    f:SetCallback("OnClick", function(widget) onClick(setID); end);
    f:SetLayout("Flow");
    f:SetFullWidth(true);
    f:SetHeight(42);

    local icon = AceGUI:Create("Icon");
    icon:SetImage(136430); -- Plus icon
    icon:SetImageSize(32, 32);
    icon:SetWidth(32);
    icon:SetHeight(32);
    icon:SetPoint("TOPLEFT", 5, 0);
    f:AddChild(icon);

    local label = AceGUI:Create("Label");
    label:SetHeight(32);
    label:SetWidth(80);
    if setID == -1 then
        label:SetText("Create New Set");
    else
        local _name, _icon = Call:GetEquipmentSetInfo(setID);
        if _name == nil then
            label:SetText("Unknown Set");
        else
            label:SetText(_name);
            icon:SetImage(_icon);
        end
    end
    label:SetPoint("TOPLEFT", 5, 20);
    f:AddChild(label);


    return f;
end
