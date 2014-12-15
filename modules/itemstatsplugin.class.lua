local addonName, ns, _ = ...

local ItemStatsPlugin = ns.Plugin()
ns.ItemStatsPlugin = ItemStatsPlugin

-- creates a new ImportPlugin object
function ItemStatsPlugin:Initialize()
	self:SetName("Item Stats")
	self:SetTooltipText("Allows you to check which stats TopFit detects on an item, as well as change those stats when necessary.")
	self:SetButtonTexture("Interface\\Icons\\INV_Enchant_FormulaSuperior_01")
	self:RegisterConfigPanel()
end

--[[
function ItemStatsPlugin:GetItemButton(i)
	while #(self.itemButtons) < i do
		local panel = self:GetConfigPanel()
		local itemButton = CreateFrame("Button", "$parentItemButton"..i, panel, "ItemButtonTemplate")
		--itemButton:SetSize(20, 20)
		itemButton:SetScript("OnEnter", ns.ShowTooltip)
		itemButton:SetScript("OnLeave", ns.HideTooltip)

		tinsert(self.itemButtons, itemButton)
	end

	return self.itemButtons[i]
end

function ItemStatsPlugin:GetHeaderText(i)
	while #(self.headerTexts) < i do
		local panel = self:GetConfigPanel()
		local header = panel:CreateFontString("$parentHeaderText"..i, "ARTWORK", "GameFontNormal")

		tinsert(self.headerTexts, header)
	end

	return self.headerTexts[i]
end

function ItemStatsPlugin:HideItemButtonsAfter(index)
	for i = index, #(self.itemButtons) do
		self.itemButtons[i]:Hide()
	end
end
]]--

function ItemStatsPlugin:SetActiveItem(itemLink)
	self.itemButton.itemLink = nil
	SetItemButtonTexture(self.itemButton, "Interface\\PaperDoll\\UI-PaperDoll-Slot-Bag")
	self.currentItem = nil

	if not itemLink then
		return
	end

	local item = ns:GetCachedItem(itemLink)
	if not item.itemEquipLoc or item.itemEquipLoc == '' then
		return
	end

	_, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemLink)
	self.itemButton.itemLink = itemLink
	SetItemButtonTexture(self.itemButton, texture)

	self.currentItem = item

	-- display item's stats
	local panel = self:GetConfigPanel()
	local statCategories = {'itemBonus', 'procBonus', 'reforgeBonus', 'gemBonus', 'enchantBonus', 'totalBonus'}
	if not self.statFrames then self.statFrames = {} end
	for frameNum, category in ipairs(statCategories) do
		-- get a container for stats of this category
		if not self.statFrames[category] then
			local frame = CreateFrame("Frame", "$parent"..category.."StatFrame", panel)
			self.statFrames[category] = frame

			frame.statNames = {}
			frame.statValues = {}

			if frameNum == 1 then
				-- anchor to panel
				frame:SetPoint("TOPLEFT", panel, "TOPLEFT")
				frame:SetPoint("TOPRIGHT", panel, "TOPRIGHT")
			else
				-- anchor to previous frame
				frame:SetPoint("TOPLEFT", self.statFrames[statCategories[frameNum - 1]], "BOTTOMLEFT")
				frame:SetPoint("TOPRIGHT", self.statFrames[statCategories[frameNum - 1]], "BOTTOMRIGHT")
			end
		end
		local frame = self.statFrames[category]

		-- collect and display current stats
		local statCount = 0
		local lineHeight = 20
		if item[category] then
			for stat, value in pairs(item[category]) do
				statCount = statCount + 1

				-- get the controls for this stat
				if #frame.statNames < statCount then
					local nameText = panel:CreateFontString("$parentNameText"..statCount, "ARTWORK", "GameFontNormal")
					tinsert(frame.statNames, nameText)
					nameText:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, lineHeight * (statCount - 1) * -1)

					local valueText = panel:CreateFontString("$parentNameText"..statCount, "ARTWORK", "GameFontNormal")
					tinsert(frame.statValues, valueText)
					valueText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, lineHeight * (statCount - 1) * -1)
				end
				local nameText = frame.statNames[statCount]
				local valueText = frame.statValues[statCount]
				nameText:Show()
				nameText:SetText(_G[stat] or stat)
				valueText:Show()
				valueText:SetText(value)
			end

			-- hide unused elements
			for i = statCount + 1, #frame.statNames do
				frame.statNames[i]:Hide()
				frame.statValues[i]:Hide()
			end
		end

		frame:Show()
		frame:SetHeight(0.01 + statCount * lineHeight)
	end
end

function ItemStatsPlugin:OnShow()
	local frame = self:GetConfigPanel()

	if not self.itemButton then
		self.itemButton = CreateFrame("Button", "$parentItemButton", frame, "ItemButtonTemplate")
		self.itemButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 80)

		self.itemButton:SetScript("OnEnter", ns.ShowTooltip)
		self.itemButton:SetScript("OnLeave", ns.HideTooltip)
		self.itemButton:SetScript("OnClick", function()
			local type, _, link = GetCursorInfo()
			ClearCursor()
			if type == "item" then
				self:SetActiveItem(link)
				ns.ShowTooltip(self.itemButton)
			else
				self:SetActiveItem()
				ns.HideTooltip(self.itemButton)
			end
		end)
		self.itemButton:SetScale(2)

		SetItemButtonTexture(self.itemButton, "Interface\\PaperDoll\\UI-PaperDoll-Slot-Bag")
		self.itemButton.itemLink = nil
	end


	print("Item Stats!")
end