local AceGUI = LibStub("AceGUI-3.0");
local Call = EMC.CallAPI;
local GUI = EMC.GUI;

function EMC:ShowGUI()
    if self.guiWindow then
        self.guiWindow:Show();
        return;
    end
    
    -- Main frame
    local frame = AceGUI:Create("Window");
    frame:SetLayout("Fill");
    frame:SetTitle("EMC - EquipmentManagerClassic");
    frame:SetWidth(500);
    frame:SetHeight(300);
    frame:EnableResize(false);

    -- Main container
    local mainContainer = AceGUI:Create("SimpleGroup");
    mainContainer:SetFullWidth(true);
    mainContainer:SetFullHeight(true);
    mainContainer:SetLayout("Flow");
    frame:AddChild(mainContainer);

    -- Menu area
    local menuArea = AceGUI:Create("SimpleGroup");
    menuArea:SetFullHeight(true);
    --menuArea:SetWidth(120);
    menuArea:SetRelativeWidth(0.3);
    menuArea:SetPoint("TOPLEFT", 0, 0);
    menuArea:SetPoint("BOTTOMRIGHT", 0, 0);
    menuArea:SetLayout("Flow");
    mainContainer:AddChild(menuArea);

    -- Content area
    local contentArea = AceGUI:Create("SimpleGroup");
    contentArea:SetFullHeight(true);
    contentArea:SetAutoAdjustHeight(false);
    contentArea:SetRelativeWidth(0.7);
    contentArea:SetPoint("BOTTOMRIGHT", 0, 0);
    contentArea:SetPoint("TOPLEFT", menuArea.frame, "TOPRIGHT", 0, 0);
    contentArea:SetLayout("Flow");
    mainContainer:AddChild(contentArea);

    self.guiWindow = frame;
    self.contentArea = contentArea;
    self.menuArea = menuArea;

    self:PopulateMenuArea();
    self:PopulateContentArea();
    self.guiWindow:DoLayout();
end

function EMC:PopulateMenuArea()
    if self.menuArea == nil then
        if self.debugMode then self:Print("Menu area is nil") end;
        return;
    end
    local frame = AceGUI:Create("InlineGroup");
    frame:SetTitle("Menu");
    frame:SetFullWidth(true);
    frame:SetFullHeight(true);
    frame:SetLayout("Fill");
    self.menuArea:AddChild(frame);

    local scroll = AceGUI:Create("ScrollFrame");
    scroll:SetLayout("Flow");
    scroll:SetFullWidth(true);
    frame:AddChild(scroll);

    scroll:AddChild(GUI:CreateEquipmentSetButton(-1, function(_) 
        self:OnCreateNewSet();
    end));

    local SetIDs = Call:GetEquipmentSetIDs();
    for _, setID in pairs(SetIDs) do
        scroll:AddChild(GUI:CreateEquipmentSetButton(setID, function(_) 
            self:OnEquipmentSetSelected(setID);
        end));
    end
end

function EMC:OnCreateNewSet()
    if self.debugMode then self:Print("OnCreateNewSet called") end;
end

function EMC:PopulateContentArea()
    if self.contentArea == nil then
        if self.debugMode then self:Print("Content area is nil") end;
        return;
    end
    local frame = AceGUI:Create("InlineGroup");
    frame:SetTitle("Content");
    frame:SetFullWidth(true);
    frame:SetFullHeight(true);
    frame:SetLayout("Fill");
    self.contentArea:AddChild(frame);
end

function EMC:ShowGUI2()
    if self.guiWindow then
        self.guiWindow:Show();
        return;
    end
    -- Main frame
    local frame = AceGUI:Create("Frame");
    frame:SetTitle("EquipmentManagerClassic");
    frame:SetStatusText("Manage your equipment sets");
    frame:SetCallback("OnClose", function(widget) 
        AceGUI:Release(widget);
        self.guiWindow = nil;
    end);
    frame:SetLayout("Fill");
    frame:SetWidth(600);
    frame:SetHeight(400);

    -- Main container
    local mainContainer = AceGUI:Create("SimpleGroup");
    mainContainer:SetFullWidth(true);
    mainContainer:SetFullHeight(true);
    mainContainer:SetLayout("Flow");
    frame:AddChild(mainContainer);

    -- Left panel
    local leftPanel = AceGUI:Create("InlineGroup");
    leftPanel:SetTitle("Equipment Sets");
    leftPanel:SetLayout("List");
    leftPanel:SetPoint("TOPLEFT", 10, -30);
    leftPanel:SetPoint("BOTTOMLEFT", 10, 10);
    leftPanel:SetRelativeWidth(0.3);
    --leftPanel:SetWidth(200);
    leftPanel:SetFullHeight(true);
    mainContainer:AddChild(leftPanel);

    
    
    --- Add "New Set" button
    local newSetButton = AceGUI:Create("InteractiveLabel");
    newSetButton:SetText("New Set");
    newSetButton:SetCallback("OnClick", function() 
        EMC:OnCreateNewSet()
    end);
    newSetButton:SetImage(135769);
    leftPanel:AddChild(newSetButton);

    --- Add equipment set buttons
    local setButtons = self:CreateEquipmentSetButtons();
    for _, btn in pairs(setButtons) do
        leftPanel:AddChild(btn);
    end

    -- Content area
    local contentArea = AceGUI:Create("SimpleGroup");
    contentArea:SetFullHeight(true);
    --contentArea:SetWidth(380);
    contentArea:SetRelativeWidth(0.7);
    contentArea:SetPoint("TOPRIGHT", -10, -30);
    contentArea:SetPoint("BOTTOMRIGHT", -10, 10);
    contentArea:SetPoint("LEFT", leftPanel.frame, "RIGHT", 10, 0);
    contentArea:SetLayout("Flow");

    mainContainer:AddChild(contentArea);

    local label = AceGUI:Create("Label");
    label:SetText("Select an equipment set from the left.");
    label:SetFullWidth(true);
    label:SetFullHeight(true);
    contentArea:AddChild(label);

    if self.debugMode then 
        EMC:Print("ContentArea width:", contentArea.frame:GetWidth());
        EMC:Print("ContentArea height:", contentArea.frame:GetHeight());
        EMC:Print("LeftPanel width:", leftPanel.frame:GetWidth());
        EMC:Print("LeftPanel height:", leftPanel.frame:GetHeight());
    end;

    self.guiWindow = frame;
    self.contentArea = contentArea;
end

function EMC:OnCreateNewSet()
    if self.debugMode then self:Print("OnCreateNewSet called") end;
end

---@return list<frame>
function EMC:CreateEquipmentSetButtons()
    local buttons = {};
    local setIDs = Call:GetEquipmentSetIDs();
    for _, setID in pairs(setIDs) do
        local name, icon = select(1, Call:GetEquipmentSetInfo(setID));
        local button = AceGUI:Create("InteractiveLabel");
        button:SetText(name);
        button:SetImage(icon);
        button:SetCallback("OnClick", function() 
            self:OnEquipmentSetSelected(setID)
        end);
        table.insert(buttons, button);
    end
    return buttons;
end

function EMC:OnEquipmentSetSelected(setID)
    if self.debugMode then self:Print("OnEquipmentSetSelected called with setID:", setID) end;
    if self.contentArea == nil then
        if self.debugMode then self:Print("Content area is nil") end;
        return;
    end
    self.contentArea:ReleaseChildren();

    local contentWidget = AceGUI:Create("Heading");
    contentWidget:SetText("Set ID: " .. setID);
    contentWidget:SetFullWidth(true);
    self.contentArea:AddChild(contentWidget);

    local contentWidget = AceGUI:Create("EquipmentSetContentArea");
    if not contentWidget then
        if self.debugMode then self:Print("Failed to create content widget") end;
        return;
    end
    if self.debugMode then self:Print(table.concat(contentWidget, ", ")) end;
    contentWidget:SetTitle("Set ID: " .. setID);
    if self.debugMode then self:Print("Created content widget for setID:", setID) end;
    self.contentArea:AddChild(contentWidget);
    if self.debugMode then self:Print("Added content widget to content area") end;
end