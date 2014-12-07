local addonName, ns, _ = ...

-- GLOBALS: TopFit, _G, LibStub, INVSLOT_LAST_EQUIPPED
-- GLOBALS: CreateFrame, GetItemInfo, SetItemButtonTexture
-- GLOBALS: string, pairs, tinsert, select, tremove, hooksecurefunc

local VirtualItems = ns.Plugin()
ns.VirtualItems = VirtualItems

function VirtualItems:GetItemButton(i)
	local frame = self:GetConfigPanel()

	if not frame.itemsFrame.buttons[i] then
		local button = CreateFrame("Button", "$parentItemButton"..i, frame.itemsFrame.content, "ItemButtonTemplate")

		button:RegisterForClicks("RightButtonUp") -- removing is only triggered on right click
		button:SetScript("OnEnter", TopFit.ShowTooltip)
		button:SetScript("OnLeave", TopFit.HideTooltip)
		button:SetScript("OnClick", function(clickedButton)
			local set = ns.GetSetByID(ns.selectedSet, true)
			set:RemoveVirtualItem(clickedButton.itemLink)
			self:RefreshItems()
		end)
		frame.itemsFrame.buttons[i] = button
	end
	local button = frame.itemsFrame.buttons[i]

	return button
end

function VirtualItems:RefreshItems()
	local frame = self:GetConfigPanel()
	local set = ns.GetSetByID(ns.selectedSet, true)
	local virtualItems = set:GetVirtualItems()

	local rowFirstButtonID, totalWidth = 1, 0
	if set and virtualItems then
		for i, item in ipairs(virtualItems) do
			local button = self:GetItemButton(i)

			button.itemLink = item

			local texture = select(10, GetItemInfo(item))
			if not texture then texture = "Interface\\Icons\\Inv_Misc_Questionmark" end
			SetItemButtonTexture(button, texture)

			button:Show()

			if i == 1 then
				-- anchor to top left of frame
				button:SetPoint("TOPLEFT", frame.itemsFrame.content, "TOPLEFT", 2, -2)
				totalWidth = totalWidth + button:GetWidth() + 2 * 4    -- padding needs to be added
			else
				-- anchor to previous item, or beginning of next line
				if (totalWidth + button:GetWidth()) <= frame.itemsFrame:GetWidth() then
					button:SetPoint("TOPLEFT", frame.itemsFrame.buttons[i - 1], "TOPRIGHT", 2, 0)
					totalWidth = totalWidth + button:GetWidth() + 2
				else
					button:SetPoint("TOPLEFT", frame.itemsFrame.buttons[rowFirstButtonID], "BOTTOMLEFT", 0, -2)
					totalWidth = button:GetWidth() + 2 * 4
					rowFirstButtonID = i
				end
			end
		end
	end

	-- hide unused buttons
	for i = #virtualItems + 1, #(frame.itemsFrame.buttons) do
		frame.itemsFrame.buttons[i]:Hide()
	end
end

function VirtualItems:AddItem(link)
	local set = ns.GetSetByID(ns.selectedSet, true)
	local invSlot = select(9, GetItemInfo(link))
	if set and invSlot and invSlot:find("INVTYPE_") and not invSlot:find("INVTYPE_BAG") then
		set:AddVirtualItem(link)
	else
		-- show an error message
		if ns.selectedSet then
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

	local info = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	info:SetJustifyH("LEFT")
	info:SetNonSpaceWrap(true)
	info:SetPoint("TOPLEFT")
	info:SetPoint("TOPRIGHT")
	info:SetText(ns.locale.VIExplanation)

	-- option for disabling virtual items calculation
	local enable = LibStub("tekKonfig-Checkbox").new(frame, nil, TopFit.locale.IncludeVI, "TOPLEFT", info, "BOTTOMLEFT", 10, -4)
	enable.tiptext = TopFit.locale.IncludeVITooltip
	local checksound = enable:GetScript("OnClick")
	enable:SetScript("OnClick", function(self)
		local set = ns.GetSetByID(ns.selectedSet, true)
		checksound(self)
		if set then
			set:SetUseVirtualItems(not set:GetUseVirtualItems())
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
	addItemTextBox:SetScript("OnEscapePressed", function (text)
		text:SetText(TopFit.locale.VIAddItem)
		text:ClearFocus()
	end)
	addItemTextBox:SetScript("OnEnterPressed", function (frame)
		-- check if input is itemLink or itemID
		local text = frame:GetText()
		local link = (text ~= TopFit.locale.VIAddItem) and select(2, GetItemInfo(text))

		frame:ClearFocus()
		frame:SetText(TopFit.locale.VIAddItem)

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

	-- update checkboxes
	local frame = self:GetConfigPanel()
	if ns.selectedSet then
		local set = ns.GetSetByID(ns.selectedSet, true)
		frame.includeVirtualItemsCheckButton:SetChecked(set:GetUseVirtualItems())
	end
end
