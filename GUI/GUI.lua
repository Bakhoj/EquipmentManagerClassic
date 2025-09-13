local GUI = EMC.GUI
local Widget = EMC.Widget
local Utils = EMC.Utils

function GUI:populateMenu(parent, updateContent)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "BackdropTemplate")
    --local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "WoWScrollBoxList")
    scrollFrame:SetSize(parent:GetWidth(), parent:GetHeight())
    scrollFrame:SetPoint("CENTER")

    scrollFrame:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    scrollFrame:SetBackdropColor(0, 0, 0, 1)

    -- TODO: look into: https://warcraft.wiki.gg/wiki/Making_scrollable_frames
    --local scrollBar = CreateFrame("EventFrame", nil, parent, "MinimalScrollBar")
    --scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT")
    --scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT")

    local scrollContentFrame = CreateFrame("Frame", nil, scrollFrame)
    scrollContentFrame:SetSize(parent:GetWidth() -10, 800)
    scrollContentFrame:SetPoint("TOP")
    scrollContentFrame:EnableMouse(true)

    local ids = C_EquipmentSet.GetEquipmentSetIDs()
    local newSetButton = Widget:MenuButton(scrollContentFrame, nil, nil, function(self) 
        updateContent(nil)
    end)
    newSetButton:SetPoint("TOP", scrollContentFrame, "TOP", 0, -10)

    
    local lastAnchor = newSetButton
    for _, setID in pairs(ids) do
        local setName, iconFileID = C_EquipmentSet.GetEquipmentSetInfo(setID)
        local btn = Widget:MenuButton(scrollContentFrame, setName, iconFileID, function(self) 
            updateContent(setID)
        end)
        btn:SetPoint("TOP", lastAnchor, "BOTTOM", 0, -10)
        lastAnchor = btn
    end

    scrollFrame:SetScrollChild(scrollContentFrame)
end

function GUI:populateContent(parent, setID)
    EMC.Temp:Clear()
    
    local itemIDs, label, dressUpModel, ignores, imageButton
    if setID then
        local getActionButton, deleteButton, macroEditBox, setName, macroText
        setName = C_EquipmentSet.GetEquipmentSetInfo(setID)
        itemIDs = C_EquipmentSet.GetItemIDs(setID)
        label = Widget:Label(parent)
        label:SetText(setName)
        label:SetPoint("TOP")

        getActionButton = Widget:Button(parent, function() 
            C_EquipmentSet.PickupEquipmentSet(setID)
        end)
        getActionButton:SetPoint("BOTTOMLEFT")
        getActionButton:SetText("Get Action Button")

        macroText = "/equipset " .. setName .. ""

        macroEditBox = Widget:EditBox(parent, function() 
            macroEditBox:SetText(macroText)
        end)
        macroEditBox:SetPoint("BOTTOMRIGHT")
        macroEditBox:SetText(macroText)
        macroEditBox:SetWidth(macroEditBox:GetWidth()*1.5)

        deleteButton = Widget:Button(parent, function() 
            C_EquipmentSet.DeleteEquipmentSet(setID)
            GUI:Show()
        end)

        deleteButton:SetPoint("TOPRIGHT")
        deleteButton:SetText("INSTANT DELETE!")
    else
        EMC.Flag.isEditingView = true
        ignores = {}
        local saveButton, editBox
        editBox = Widget:EditBox(parent, function() 
            saveButton:Click()    
        end)
        editBox:SetPoint("TOP")

        saveButton = Widget:Button(parent, function() 
            EMC.Temp.Ignores = {}
            for slot, isIgnored in pairs(ignores) do
                EMC.Temp.Ignores[slot] = isIgnored or false
            end

            EMC.Func:SaveSet(editBox:GetText())
            GUI:Show()
        end)
        saveButton:SetPoint("TOPRIGHT")
        saveButton:SetText("Save")

        imageButton = Widget:ImageButton(parent, function() 
            -- TODO Change icon for set
            EMC:Print("Icon will be last unignored item")
        end)
        imageButton.frame:SetPoint("TOPLEFT")
        imageButton:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    end
    -- model
    dressUpModel = CreateFrame("DressUpModel", nil, parent)
    dressUpModel:SetPoint("CENTER")
    dressUpModel:SetSize(6*32, 8*32)
    dressUpModel:SetUnit("player")
    --dressUpModel:Undress()

    for slot = 1, 19 do
        local itemID
        itemID = (itemIDs and itemIDs[slot]) or (setID == nil and GetInventoryItemID("player", slot)) or nil

        local itemLink, itemTexture, itemWidget
        if itemID == -1 or itemID == nil then
            -- Ignored Slot (-1) and Empty Slot (nil)
            itemTexture = Utils:GetPaperDollSlotTexture(slot)
        else
            -- Normal Slot
            _, itemLink, _, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemID)
            dressUpModel:UndressSlot(slot)
            dressUpModel:TryOn(itemLink, Utils:HandSlotNameBySlot(slot))
        end

        itemWidget = Widget:ItemSlot(parent, itemTexture, itemLink)
        itemWidget:SetPoint("CENTER", parent, "CENTER", Utils:ItemSlotMarginFromCenter(slot))
        itemWidget:Ignore(itemID == -1)
        itemWidget.tooltipAnchor = Utils:TooltipAnchorBySlot(slot)

        if EMC.Flag.isEditingView then
            itemWidget:SetScript("OnClick", function() 
                itemWidget:Ignore(not itemWidget:IsIgnored())
                ignores[slot] = itemWidget:IsIgnored()
                -- TODO remove below when proper iconChange implemented
                if not itemWidget:IsIgnored() then
                    EMC.Temp.iconFileID = itemTexture
                    imageButton:SetTexture(itemTexture)
                end
            end)
        end
    end
end

function GUI:Show()
    self:Hide()
    
    local mainFrame = Widget:MainFrame()

    local menuFrame = Widget:MenuFrame(mainFrame)
    local contentFrame = Widget:ContentFrame(mainFrame)

    self:populateMenu(menuFrame, function(setID)
        EMC.Temp.editing = (setID == nil)
        contentFrame:Hide()
        contentFrame = Widget:ContentFrame(mainFrame)
        self:populateContent(contentFrame, setID)
    end)
end

function GUI:Hide()
    if _G["EquipmentManagerClassicFrame"] then 
        _G["EquipmentManagerClassicFrame"]:Hide()
    end
end

function GUI:Clear()
    for k, v in pairs(self) do
        if type(v) ~= "function" then
            self[k] = nil
        end
    end
end

local paperButton = CreateFrame("Button", nil, PaperDollFrame, "UIPanelButtonTemplate")
paperButton:SetSize(64, 32)
paperButton:SetPoint("BOTTOMLEFT", 18, 80, 0, 0)
paperButton:SetText("EMC")
paperButton:SetScript("OnClick", function()
    GUI:Show()
end)
