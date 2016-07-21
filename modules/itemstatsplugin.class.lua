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

	local statOrder = {}

	-- display item's stats
	local panel = self:GetConfigPanel()
	local statCategories = {
		{'itemBonus', ''},
		{'procBonus', ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON].hex},
		{'reforgeBonus', ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_UNCOMMON].hex},
		{'gemBonus', ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_RARE].hex},
		{'enchantBonus', ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_EPIC].hex},
		-- {'totalBonus', 'Total '},
	}

	if not self.statFrames then self.statFrames = {} end
	for categoryIndex, categoryInfo in ipairs(statCategories) do
		local category, prefix = unpack(categoryInfo)

		-- get a container for stats of this category
		local frame = self.statFrames[category]
		if not frame then
			frame = CreateFrame("Frame", "$parent"..category.."StatFrame", panel)
			frame:SetSize(panel:GetWidth(), 1)
			frame.statNames = {}
			frame.statValues = {}

			local anchor = categoryIndex == 1 and panel
				or self.statFrames[statCategories[categoryIndex - 1][1]]
			local anchorPoint = categoryIndex == 1 and "TOPLEFT" or "BOTTOMLEFT"
			frame:SetPoint("TOPLEFT", anchor, anchorPoint)
			frame:Hide()
			self.statFrames[category] = frame
		end

		-- collect and display current stats
		local lineHeight = 20
		if item[category] then
			-- Use a consistent stat order.
			wipe(statOrder)
			for stat in pairs(item[category]) do
				table.insert(statOrder, stat)
			end
			table.sort(statOrder)

			if #statOrder > 0 then
				for statIndex, stat in ipairs(statOrder) do
					local value = item[category][stat]

					-- get the controls for this stat
					if #frame.statNames < statIndex then
						local yOffset = -1 *lineHeight * (statIndex - 1)
						local nameText = frame:CreateFontString("$parentNameText"..statIndex, "ARTWORK", "GameFontNormal")
						nameText:SetPoint("TOPLEFT", "$parent", "TOPLEFT", 0, yOffset)
						tinsert(frame.statNames, nameText)

						local valueText = frame:CreateFontString("$parentNameText"..statIndex, "ARTWORK", "GameFontNormal")
						valueText:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", 0, yOffset)
						tinsert(frame.statValues, valueText)
					end
					local nameText = frame.statNames[statIndex]
					nameText:SetText(prefix .. (_G[stat] or stat))
					nameText:Show()

					local valueText = frame.statValues[statIndex]
					valueText:SetText(value)
					valueText:Show()
				end

				-- hide unused elements
				for i = #statOrder + 1, #frame.statNames do
					frame.statNames[i]:Hide()
					frame.statValues[i]:Hide()
				end

				frame:Show()
				frame:SetHeight(#statOrder * lineHeight)
			end
		end
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
end
