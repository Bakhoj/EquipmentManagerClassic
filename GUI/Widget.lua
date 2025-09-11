local Widget = EMC.Widget

local ICON_SIZE = 32
local ICON_BUTTON_SIZE = 24
local WINDOW_WIDTH = 600
local WINDOW_HEIGHT = 420

function Widget:MainFrame()
    local frameName = "EquipmentManagerClassicFrame"
    local frame = CreateFrame("Frame", frameName, UIParent, "BackdropTemplate")
    _G[frameName] = frame
    tinsert(UISpecialFrames, frame:GetName())

    frame:SetSize(WINDOW_WIDTH, WINDOW_HEIGHT)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    frame:SetFrameStrata("HIGH")
    return frame
end

function Widget:EditBox(parent, onEnter, onClick)
    local editBox = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    editBox:SetSize(150, 40)
    editBox:SetAutoFocus(false)
    editBox:SetTextInsets(4, 4, 4, 4)
    editBox:SetMaxLetters(30) -- TODO figure out max length for equipmentset name
    editBox:SetMultiLine(false)
    editBox:SetText("PLACEHOLDER")
    editBox:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    editBox:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
        if onEnter then onEnter(self) end
    end)

    if onClick then
        editBox.frame = CreateFrame("Button", "OVERLAY", editBox)
        editBox.frame:SetAllPoints(editBox)
        editBox.frame:EnableMouse(true)
        editBox.frame:SetScript("OnClick", onClick)
    end
    editBox:SetPoint("CENTER")
    return editBox
end

function Widget:Label(parent)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("CENTER")
    label:SetSize(150, 30)
    label:SetJustifyH("CENTER")
    label:SetText("PLACEHOLDER")

    return label
end

function Widget:ItemSlot(parent, itemTexture, itemLink, onIgnore)
    local slotFrame = CreateFrame("Button", "Widget.ItemSlot", parent)
    slotFrame:SetSize(ICON_SIZE, ICON_SIZE)
    slotFrame:EnableMouse(true)

    slotFrame.tooltipAnchor = nil

    local image = parent:CreateTexture("Widget.ItemSlot.image", "ARTWORK")
    image:SetAllPoints(slotFrame)
    slotFrame.image = image

    image:SetTexture(itemTexture or "Interface\\Icons\\INV_Misc_QuestionMark")
    image:SetAlpha(1)
    image:SetDesaturated(false)
    image:SetDesaturation(1)

    local ignoreOverlay = parent:CreateTexture(nil, "OVERLAY")
    ignoreOverlay:SetAllPoints(image)
    ignoreOverlay:SetColorTexture(1, 0, 0, 0.2)
    ignoreOverlay:Hide()

    function slotFrame:Ignore(ignore)
        image:SetDesaturated(ignore)
        if ignore then
            ignoreOverlay:Show()
        else
            ignoreOverlay:Hide()
        end
    end

    function slotFrame:IsIgnored()
        return ignoreOverlay:IsShown()
    end

    if itemLink then
        slotFrame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, slotFrame.tooltipAnchor or "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(itemLink)
            GameTooltip:Show()
        end)

        slotFrame:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)
    end

    return slotFrame
end

function Widget:Button(parent, onClick)
    local BUTTON_WIDTH = 75
    local BUTTON_HEIGHT = 30
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetPoint("CENTER")
    button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
    button:SetText("PLACEHOLDER")
    
    button:SetScript("OnClick", onClick)
    return button
end

function Widget:ImageButton(parent, onClick)
    local BUTTON_SIZE = 32
    local button = parent:CreateTexture(nil, "ARTWORK")
    button.frame = CreateFrame("Button", nil, parent)
    button.frame:SetSize(BUTTON_SIZE, BUTTON_SIZE)
    button.frame:SetPoint("CENTER")
    button.frame:EnableMouse(true)
    button:SetAllPoints(button.frame)

    button.frame:SetScript("OnClick", onClick)

    return button
end

function Widget:MenuButton(parent, setName, iconFileID, onClick)
    local BUTTON_WIDTH = 150
    local BUTTON_HEIGHT = 40
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)

    local iconTexture = button:CreateTexture(nil, "ARTWORK")
    iconTexture:SetTexture(iconFileID or "Interface\\Icons\\INV_Misc_QuestionMark")
    iconTexture:SetSize(ICON_BUTTON_SIZE, ICON_BUTTON_SIZE)
    iconTexture:SetPoint("LEFT", button, "LEFT", -5, 0)
    button.icon = iconTexture
    button:SetText("  " .. (setName or "NEW?"))

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        if setName then 
            GameTooltip:SetEquipmentSet(setName) 
            GameTooltip:AddLine("EMC: Ignored might be incorrect", 0.7, 0.8, 0.2, true)
        end
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    button:SetScript("OnClick", onClick)

    return button
end

function Widget:MenuFrame(parent)
    local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    frame:SetSize((WINDOW_WIDTH * 0.4) -24, WINDOW_HEIGHT-24)
    frame:SetPoint("LEFT", parent, "LEFT", 12, 0)

    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0.1, 0.1, 0.1, 1)
    return frame
end

function Widget:ContentFrame(parent)
    local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    frame:SetSize(WINDOW_WIDTH * 0.6, WINDOW_HEIGHT-24)
    frame:SetPoint("RIGHT", parent, "RIGHT", -12, 0)

    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0.05, 0.05, 0.05, 1)
    return frame
end
