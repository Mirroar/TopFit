local addonName, ns, _ = ...

local OptimizerPlugin = ns.Plugin()
ns.OptimizerPlugin = OptimizerPlugin

local colorOrder = {"META", "RED", "YELLOW", "BLUE", "PRISMATIC", "COGWHEEL", "HYDRAULIC"}

-- creates a new ImportPlugin object
function OptimizerPlugin:Initialize()
	self:SetName("Gear Optimizer")
	self:SetTooltipText("Helps you select the best gems, enchants and reforge options.")
	self:SetButtonTexture("Interface\\Icons\\INV_Glove_Mail_PVPHunter_D_01")
	self:RegisterConfigPanel()

	self.itemButtons = {}
	self.headerTexts = {}
end

function OptimizerPlugin:GetItemButton(i)
	while #(self.itemButtons) < i do
		local panel = self:GetConfigPanel()
		local itemButton = CreateFrame("Button", "$parentItemButton"..i, panel, "ItemButtonTemplate")
		itemButton:SetScript("OnEnter", ns.ShowTooltip)
		itemButton:SetScript("OnLeave", ns.HideTooltip)

		tinsert(self.itemButtons, itemButton)
	end

	return self.itemButtons[i]
end

function OptimizerPlugin:GetHeaderText(i)
	while #(self.headerTexts) < i do
		local panel = self:GetConfigPanel()
		local header = panel:CreateFontString("$parentHeaderText"..i, "ARTWORK", "GameFontNormal")

		tinsert(self.headerTexts, header)
	end

	return self.headerTexts[i]
end

function OptimizerPlugin:HideItemButtonsAfter(index)
	for i = index, #(self.itemButtons) do
		self.itemButtons[i]:Hide()
	end
end

function OptimizerPlugin:OnShow()
	local set = ns.GetSetByID(ns.selectedSet, true)

	-- collect the "best" gems for this set
	local bestGems = {}
	for gemID, gemTable in pairs(ns.gemIDs) do
		for _, color in pairs(gemTable.colors) do
			if not bestGems[color] then bestGems[color] = {} end

			tinsert(bestGems[color], ns:GetCachedItem(gemID))

			if color == "RED" or color == "BLUE" or color == "YELLOW" then
				if not bestGems["PRISMATIC"] then bestGems["PRISMATIC"] = {} end
				tinsert(bestGems["PRISMATIC"], ns:GetCachedItem(gemID))
			end
		end
	end

	ns.ReduceGemList(set, bestGems)

	-- sort gems by score, descending
	for _, subTable in pairs(bestGems) do
		table.sort(subTable, function(a, b)
			local scoreA, scoreB = set:GetItemScore(a.itemLink), set:GetItemScore(b.itemLink)
			return scoreB < scoreA
		end)
	end

	ns.debugGems = bestGems

	-- report num gems
	for color, gemTable in pairs(bestGems) do
		local sum=0
		for _, _ in pairs(bestGems[color]) do sum = sum + 1 end
		TopFit:Print(color..' gems: '..sum)
	end

	-- show suggested gems
	local panel = self:GetConfigPanel()
	local i = 1
	local headerNum = 1
	local categoryButtonCounter
	local width = panel:GetWidth()
	ns:Print(width)
	if not width or width == 0 then
		width = 355
	end
	for _, color in ipairs(colorOrder) do
		local subTable = bestGems[color]
		local header = self:GetHeaderText(headerNum)
		header:SetText(_G["EMPTY_SOCKET_"..color])
		if headerNum == 1 then
			header:SetPoint("TOPLEFT", panel, "TOPLEFT")
		else
			header:SetPoint("TOPLEFT", self:GetItemButton(i - 1 - (categoryButtonCounter % 2)), "BOTTOMLEFT", 0, -20)
		end
		categoryButtonCounter = 1
		for _, gemTable in pairs(subTable) do
			local itemButton = self:GetItemButton(i)
			local texture = select(10, GetItemInfo(gemTable.itemID))
			if not texture then texture = "Interface\\Icons\\Inv_Misc_Questionmark" end
			SetItemButtonTexture(itemButton, texture)

			itemButton.itemLink = gemTable.itemLink

			if categoryButtonCounter == 1 then
				itemButton:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
			elseif categoryButtonCounter == 2 then
				itemButton:SetPoint("TOPLEFT", self:GetItemButton(i - 1), "TOPLEFT", width / 2, 0)
			else
				itemButton:SetPoint("TOPLEFT", self:GetItemButton(i - 2), "TOPLEFT", 0, -(itemButton:GetHeight() + 5))
			end
			itemButton:Show()

			i = i + 1
			categoryButtonCounter = categoryButtonCounter + 1
		end
		headerNum = headerNum + 1
	end
	self:HideItemButtonsAfter(i)
end