local addonName, ns, _ = ...

-- GLOBALS: TopFit, _G, LibStub, INVSLOT_LAST_EQUIPPED
-- GLOBALS: CreateFrame, GetItemInfo, SetItemButtonTexture
-- GLOBALS: string, pairs, tinsert, select, tremove, hooksecurefunc

local VirtualItems = ns.Plugin()
ns.VirtualItems = VirtualItems

local function tinsertonce(table, data)
    local found = false
    for _, v in pairs(table) do
        if v == data then
            found = true
            break
        end
    end
    if not found then
        tinsert(table, data)
    end
end

function VirtualItems:GetItemButton(i)
    local frame = self:GetConfigPanel()

    if not frame.itemsFrame.buttons[i] then
        local button = CreateFrame("Button", "$parentItemButton"..i, frame.itemsFrame.content, "ItemButtonTemplate")

        button:RegisterForClicks("RightButtonUp")
        button:SetScript("OnEnter", TopFit.ShowTooltip)
        button:SetScript("OnLeave", TopFit.HideTooltip)
        button:SetScript("OnClick", function(self)
            -- remove item from list
            if (TopFit.selectedSet and TopFit.db.profile.sets[TopFit.selectedSet].virtualItems) then
                -- find item and remove it
                local i
                for i = 1, #(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems) do
                    if (self.itemLink == TopFit.db.profile.sets[TopFit.selectedSet].virtualItems[i]) then
                        tremove(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems, i)
                    end
                end

                self:RefreshItems()
            end
        end)
        frame.itemsFrame.buttons[i] = button
    end
    local button = frame.itemsFrame.buttons[i]
end

-- [TODO] cleanup
function VirtualItems:RefreshItems()
    local frame = self:GetConfigPanel()
    local set = ns.GetSetByID(ns.selectedSet, true)

    local lastLine, totalWidth = 1, 0
    local numUsedButtons = 0
    if set then
        if (TopFit.db.profile.sets[TopFit.selectedSet].virtualItems) then
            for i = 1, #(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems) do
                numUsedButtons = numUsedButtons + 1
                local button = self:GetItemButton(i)


                button.itemLink = TopFit.db.profile.sets[TopFit.selectedSet].virtualItems[i]

                local texture = select(10, GetItemInfo(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems[i]))
                if not texture then texture = "Interface\\Icons\\Inv_Misc_Questionmark" end
                SetItemButtonTexture(button, texture)
                button:Show()

                if i == 1 then
                    -- anchor to top left of frame
                    button:SetPoint("TOPLEFT", frame.itemsFrame.content, "TOPLEFT", 2, -2)
                    totalWidth = totalWidth + button:GetWidth() + 2*4    -- padding needs to be added
                else
                    -- anchor to previous item, or beginning of next line
                    if (totalWidth + button:GetWidth()) <= frame.itemsFrame:GetWidth() then
                        button:SetPoint("TOPLEFT", frame.itemsFrame.buttons[i - 1], "TOPRIGHT", 2, 0)
                        totalWidth = totalWidth + button:GetWidth() + 2
                    else
                        button:SetPoint("TOPLEFT", frame.itemsFrame.buttons[lastLine], "BOTTOMLEFT", 0, -2)
                        totalWidth = button:GetWidth() + 2*4
                        lastLine = i
                    end
                end
            end
        end
    end

    -- hide unused buttons
    for i = numUsedButtons + 1, #(frame.itemsFrame.buttons) do
        frame.itemsFrame.buttons[i]:Hide()
    end
end

function VirtualItems:AddItem(link)
    local invSlot = select(9, GetItemInfo(link))
    if TopFit.selectedSet and invSlot and invSlot:find("INVTYPE_") and not invSlot:find("INVTYPE_BAG") then

        if not TopFit.db.profile.sets[TopFit.selectedSet].virtualItems then
            TopFit.db.profile.sets[TopFit.selectedSet].virtualItems = {}
        end
        tinsertonce(TopFit.db.profile.sets[TopFit.selectedSet].virtualItems, link)
    else
        if TopFit.selectedSet then
            TopFit:Print(string.format(TopFit.locale.VIErrorNotEquippable, link))
        else
            TopFit:Print(TopFit.locale.VIErrorNoSet)
        end
    end
    self:RefreshItems()
end

function VirtualItems:Initialize()
    self:SetName(ns.locale.VirtualItems)
    self:SetTooltipText(ns.locale.VirtualItemsTooltip)
    self:SetButtonTexture("Interface\\Icons\\Achievement_Arena_3v3_7")

    self:RegisterConfigPanel()
end

function VirtualItems:InitializeUI()
    local frame = self:GetConfigPanel()
    local set = ns.GetSetByID(ns.selectedSet, true)

    local info = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    info:SetJustifyH("LEFT")
    info:SetNonSpaceWrap(true)
    info:SetPoint("TOPLEFT")
    info:SetPoint("TOPRIGHT")
    info:SetText(ns.locale.VIExplanation)

    -- option for disabling virtual items calculation
    local enable = LibStub("tekKonfig-Checkbox").new(frame, nil, TopFit.locale.IncludeVI, "TOPLEFT", info, "BOTTOMLEFT", 10, -4)
          enable.tiptext = TopFit.locale.IncludeVITooltip

    -- [TODO]
    if set then
        enable:SetChecked(not TopFit.db.profile.sets[TopFit.selectedSet].skipVirtualItems)
    end
    local checksound = enable:GetScript("OnClick")
    enable:SetScript("OnClick", function(self)
        checksound(self)
        if (TopFit.selectedSet) then
            TopFit.db.profile.sets[TopFit.selectedSet].skipVirtualItems = not TopFit.db.profile.sets[TopFit.selectedSet].skipVirtualItems
        end
    end)
    frame.includeVirtualItemsCheckButton = enable

    -- label for item text box
    local addItemLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    addItemLabel:SetNonSpaceWrap(true)
    addItemLabel:SetJustifyH("LEFT")
    addItemLabel:SetPoint("TOPLEFT", enable, "BOTTOMLEFT", -10, -4)
    addItemLabel:SetPoint("RIGHT", frame, -4, 2)
    addItemLabel:SetHeight(33)
    addItemLabel:SetText(TopFit.locale.VIUsage)

    -- create text box for items
    local addItemTextBox = CreateFrame("EditBox", "$parentAddItemTextBox", frame)
    addItemTextBox:SetFontObject("GameFontNormalSmall")
    addItemTextBox:SetJustifyH("LEFT")
    addItemTextBox:SetAutoFocus(false)
    addItemTextBox:SetTextInsets(6, 6, 0, 0)
    addItemTextBox:SetHeight(24)
    addItemTextBox:SetPoint("TOPLEFT", addItemLabel, "BOTTOMLEFT", 0, -4)
    addItemTextBox:SetPoint("TOPRIGHT", frame, "RIGHT", -4, 0)
    addItemTextBox:SetText(TopFit.locale.VIAddItem)
    addItemTextBox:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        insets = {left = 4, right = 4, top = 4, bottom = 4}
    })
    addItemTextBox:SetBackdropColor(.1, .1, .1, .8)
    addItemTextBox:SetBackdropBorderColor(.5, .5, .5)

    -- scripts
    addItemTextBox:SetScript("OnEditFocusGained", addItemTextBox.HighlightText)
    addItemTextBox:SetScript("OnEscapePressed", function (self)
        self:SetText(TopFit.locale.VIAddItem)
        self:ClearFocus()
    end)
    addItemTextBox:SetScript("OnEnterPressed", function (self)
        -- check if input is itemLink or itemID
        local text = self:GetText()
        local link = (text ~= TopFit.locale.VIAddItem) and select(2, GetItemInfo(text))

        self:ClearFocus()
        self:SetText(TopFit.locale.VIAddItem)

        if not link then
            TopFit:Print(TopFit.locale.VIItemNotFound)
        else
            TopFit:Debug("Adding "..link.." to virtual items")
            self:AddItem(link)
        end
    end)
    frame.addItemTextBox = addItemTextBox

    hooksecurefunc("ChatEdit_InsertLink", function(text)    -- hook shift-clicks on items
        if addItemTextBox:HasFocus() then
            addItemTextBox:Insert(text)
        end
    end)

    frame.panel = LibStub("tekKonfig-Group").new(frame, "Your virtual items")
    frame.panel:SetPoint("TOPLEFT", frame.addItemTextBox, "BOTTOMLEFT", 0, -14)
    frame.panel:SetPoint("RIGHT", frame, -2, 2)
    frame.panel:SetHeight(150)

    local itemScrollFrame = CreateFrame("ScrollFrame", "$parentItemsScrollFrame", frame.panel, "UIPanelScrollFrameTemplate")
    itemScrollFrame:SetPoint("TOPLEFT", frame.panel, "TOPLEFT", 6, -6)
    itemScrollFrame:SetPoint("BOTTOMRIGHT", frame.panel, "BOTTOMRIGHT", -27, 4)
    --itemScrollFrame:SetHeight(150)

    itemScrollFrame.content = CreateFrame("Frame", "$parentContent", itemScrollFrame)
    itemScrollFrame.content:SetHeight(100)
    itemScrollFrame.content:SetWidth(300)
    itemScrollFrame.content:SetAllPoints()
    itemScrollFrame:SetScrollChild(itemScrollFrame.content)
    frame.itemsFrame = itemScrollFrame

    frame.itemsFrame.buttons = {}
end

function VirtualItems:OnShow()
    self:RefreshItems()
end
