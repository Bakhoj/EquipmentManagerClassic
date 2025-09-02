local AceGUI = LibStub("AceGUI-3.0");

local LeftMenuButtonType, LeftMenuButtonVersion = "LeftMenuButton", 1;

local function LeftMenuButtonConstructor()
    local frame = AceGUI:Create("InteractiveLabel");
    --local frame = CreateFrame("Button", nil, UIParent, "BackdropTemplate");
    --frame:SetSize(180, 40);
    frame:SetHeight(40);
    frame:SetImage(nil); -- Plus icon
    frame:SetImageSize(32, 32);

    --local icon = frame:CreateTexture(nil, "ARTWORK");
    --icon:SetSize(32, 32);
    --icon:SetPoint("LEFT", 5, 0);

    --local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    --label:SetPoint("LEFT", icon, "RIGHT", 10, 0);
    --label:SetText("Default");
    frame:SetText("Default");

    local widget = {
        frame = frame,
        icon = icon,
        label = label,
        type = LeftMenuButtonType
    };

    function widget:SetText(text)
        --self.label:SetText(text);
        self.frame:SetText(text);
    end

    function widget:SetImage(texture)
        self.frame:SetImage(texture);
    end

    function widget:SetCallback(event, func)
        if event == "OnClick" then
            self.frame:SetCallback("OnClick", func);
            --self.frame:SetScript("OnClick", func);
        end 
    end

    

    frame.obj = widget;
    return AceGUI:RegisterAsWidget(widget);
end

AceGUI:RegisterWidgetType(LeftMenuButtonType, LeftMenuButtonConstructor, LeftMenuButtonVersion);


local EquipmentSetContentAreaType, EquipmentSetContentAreaVersion = "EquipmentSetContentArea", 1;

local function EquipmentSetContentAreaConstructor()
    local frame = AceGUI:Create("SimpleGroup");
    --local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate");
    --frame:SetSize(400, 300);
    frame:SetLayout("Flow");
    frame:SetHeight(300);
    frame:SetWidth(400);

    local title = AceGUI:Create("Heading");
    title:SetText("Equipment Set Details");
    title:SetFullWidth(true);
    frame:AddChild(title);

    --local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge");
    --title:SetPoint("TOP", 0, -10);
    title:SetText("Equipment Set Details");

    local widget = {
        frame = frame,
        title = title,
        type = EquipmentSetContentAreaType
    };

    function widget:SetTitle(text)
        self.title:SetText(text);
    end

    function widget:OnAcquire()
        self:SetTitle("Equipment Set Details");
        if self.debugMode then
            EMC:Print("EquipmentSetContentArea acquired");
        end
    end

    frame.obj = widget;
    return AceGUI:RegisterAsWidget(widget);
end

AceGUI:RegisterWidgetType(EquipmentSetContentAreaType, EquipmentSetContentAreaConstructor, EquipmentSetContentAreaVersion);