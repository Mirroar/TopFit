local addonName, ns, _ = ...

-- GLOBALS: _G, INVSLOT_TABARD, INVSLOT_HEAD, INVSLOT_NECK, INVSLOT_BODY, INVSLOT_WAIST, INVSLOT_FINGER1, INVSLOT_FINGER2, INVSLOT_TRINKET1, INVSLOT_TRINKET2, INVSLOT_WRIST, INVSLOT_MAINHAND, INVSLOT_OFFHAND, INVSLOT_HAND, INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED
-- GLOBALS: CreateFrame, UnitLevel, GetProfessions, GetProfessionInfo, GetFactionInfo, GetInventoryItemLink, GetItemStats, OffhandHasWeapon, UnitName, GetRealmName, GetItemInfo, GetNumFactions, SetItemButtonTexture
-- GLOBALS: pairs, ipairs, wipe, table.insert, string.find, print

local ShoppingList = ns.Plugin()
   ns.ShoppingList = ShoppingList
local currentCharacter, db

local colorOrder = {"META", "RED", "YELLOW", "BLUE", "PRISMATIC", "COGWHEEL", "HYDRAULIC"}
local notEnchantable = {
	[INVSLOT_HEAD] = true,
	[INVSLOT_NECK] = true,
	[INVSLOT_BODY] = true,
	[INVSLOT_TABARD] = true,
	[INVSLOT_WAIST] = true,		-- buckles
	[INVSLOT_FINGER1] = true,	-- enchanters
	[INVSLOT_FINGER2] = true,	-- enchanters
	[INVSLOT_TRINKET1] = true,
	[INVSLOT_TRINKET2] = true,
}

-- creates a new plugin object
function ShoppingList:Initialize()
	self:SetName("Shopping List")
	self:SetTooltipText("Helps you remember your characters' needs")
	self:SetButtonTexture("Interface\\Icons\\INV_Enchant_FormulaSuperior_01") -- Achievement_Reputation_03, Achievement_General_100kquests
	self:RegisterConfigPanel()

	if not TopFitDB.ShoppingList then
		TopFitDB.ShoppingList = {}
	end
	local realm = GetRealmName()
	if not TopFitDB.ShoppingList[realm] then
		TopFitDB.ShoppingList[realm] = {}
	end
	db = TopFitDB.ShoppingList[realm]

	currentCharacter = UnitName("player")
	if not db[currentCharacter] then
		db[currentCharacter] = {}
	end
end

function ShoppingList:GetItemButton(i)
	local panel = self:GetConfigPanel()
	local itemButton = _G[panel:GetName().."ItemButton"..i]

	if not itemButton then
		itemButton = CreateFrame("Button", "$parentItemButton"..i, panel, "ItemButtonTemplate")
		itemButton:SetScript("OnEnter", ns.ShowTooltip)
		itemButton:SetScript("OnLeave", ns.HideTooltip)

		itemButton.label = itemButton:CreateFontString("$parentLabel", "OVERLAY", "GameFontNormal")
		itemButton.label:SetPoint("LEFT", itemButton, "RIGHT", 6, 0)
	end
	return itemButton
end

function ShoppingList:GetHeaderText(i)
	local panel = self:GetConfigPanel()
	local header = _G[panel:GetName().."HeaderText"..i]

	if not header then
		header = panel:CreateFontString("$parentHeaderText"..i, "ARTWORK", "GameFontNormal")
	end
	return header
end

local TYPE_ENCHANT = "enchant"
local TYPE_SOCKET = "socket"
local function AddMissing(itemID, what)
	local itemTable = db[currentCharacter][itemID]
	if not itemTable then
		db[currentCharacter][itemID] = {}
		itemTable = db[currentCharacter][itemID]
	end
	table.insert(itemTable, what)
end

local statTable, sockets = {}, {}
local function ScanCharacterEquipment(self, btn)
	wipe(db[currentCharacter])
	local playerLevel = UnitLevel("player")

	local smithingSkill, enchantingSkill = 0, 0
	local primary1, primary2 = GetProfessions()
	local _, _, primary1level, _, _, primary1 = GetProfessionInfo(primary1)
	local _, _, primary2level, _, _, primary2 = GetProfessionInfo(primary2)
	if primary1 == 164 then smithingSkill = primary1level end
	if primary2 == 164 then smithingSkill = primary2level end
	if primary1 == 333 then enchantingSkill = primary1level end
	if primary2 == 333 then enchantingSkill = primary2level end

	local princeReputation = 0
	for factionIndex = 1, GetNumFactions() do
		local _, _, standingID, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
		if factionID == 1359 then princeReputation = standingID; break end
	end

	for slotID = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemLink = GetInventoryItemLink("player", slotID)
		if itemLink then
			local itemID, enchant, gem1, gem2, gem3, gem4, itemLevel = itemLink:match("item:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):.-:.-:(%d+)")

			-- enchants
			if enchant == "0" and not notEnchantable[slotID] then
				AddMissing(itemID, TYPE_ENCHANT)
			elseif enchant == "0" and enchantingSkill >= 360
				and (slotID == INVSLOT_FINGER1 or slotID == INVSLOT_FINGER2) then
				AddMissing(itemID, TYPE_ENCHANT)
			end

			-- regular gems
			wipe(statTable)
			GetItemStats(itemLink, statTable)

			wipe(sockets)
			for stat, amount in pairs(statTable) do
				local _, _, color = string.find(stat, "EMPTY_SOCKET_(.+)")
				if color then
					for i=1, amount do
						table.insert(sockets, color)
					end
				end
			end

			-- local gemID1, gemID2, gemID3 = GetInventoryItemGems(slotID)
			if sockets[1] and gem1 == "0" then AddMissing(itemID, sockets[1]) end
			if sockets[2] and gem2 == "0" then AddMissing(itemID, sockets[2]) end
			if sockets[3] and gem3 == "0" then AddMissing(itemID, sockets[3]) end
			-- question: if i had an unsocketed belt, but added a buckle, what would the string look like?

			-- extra sockets
			local beltBuckle = playerLevel >= 70 and slotID == INVSLOT_WAIST
			local blackPrince = princeReputation >= 7 and (IsQuestFlaggedCompleted(32390) or IsQuestFlaggedCompleted(32432))
				and (slotID == INVSLOT_MAINHAND or (slotID == INVSLOT_OFFHAND and OffhandHasWeapon()))
				and (statTable["EMPTY_SOCKET_HYDRAULIC"] or (itemLevel >= 502 and itemLevel <= 541))
			local blacksmithing = smithingSkill >= 400 and (slotID == INVSLOT_WRIST or slotID == INVSLOT_HAND)

			local canHaveExtraSocket = beltBuckle or blackPrince or blacksmithing
			local hasExtraSocket = (not sockets[1] and gem1 ~= "0")
				or (not sockets[2] and gem2 ~= "0")
				or (not sockets[3] and gem3 ~= "0")
				or (not sockets[2] and gem4 ~= "0")

			if canHaveExtraSocket and not hasExtraSocket then
				AddMissing(itemID, TYPE_SOCKET)
				AddMissing(itemID, "PRISMATIC")
			end
		end
	end
end

local function tEmpty(object)
	for k,v in pairs(object) do
		return false
	end
	return true
end

function ShoppingList:OnShow()
	local set = ns.GetSetByID(ns.selectedSet, true)
	local panel = self:GetConfigPanel()

	--[[ local scanButton = _G[panel:GetName().."ScanButton"]
	if not scanButton then
		scanButton = CreateFrame("Button", "$parentScanButton", panel, "UIPanelButtonTemplate")
		scanButton:SetSize(150, 30)
		scanButton:SetText("Scan this character")
		scanButton:SetPoint("TOPLEFT", panel:GetParent():GetName().."RoleIcon", "TOPLEFT", 0, 0)
		scanButton:SetScript("OnClick", ScanCharacterEquipment)
	end --]]

	ScanCharacterEquipment()

	local characterCounter = 1
	local numItemButtons = 1
	for character, items in pairs(db) do
		if not tEmpty(items) then
			-- show character header
			local header = self:GetHeaderText(characterCounter)
				  header:SetText(character)
				  header:Show()

			if characterCounter == 1 then
				header:SetPoint("TOPLEFT", panel, "TOPLEFT")
			else
				header:SetPoint("TOPLEFT", self:GetItemButton(numItemButtons - 1), "BOTTOMLEFT", 0, -20)
			end

			local itemCounter = 1
			for itemID, issues in pairs(items) do
				-- show item icon
				local _, itemLink, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
				local itemButton = self:GetItemButton(numItemButtons)
				itemButton.itemLink = itemLink
				itemButton:Show()
				SetItemButtonTexture(itemButton, texture or "Interface\\Icons\\Inv_Misc_Questionmark")

				if itemCounter == 1 then
					itemButton:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)
				else
					itemButton:SetPoint("TOPLEFT", self:GetItemButton(numItemButtons - 1), "BOTTOMLEFT", 0, -6)
				end

				--[[-- TODO
				for i, thing in pairs(issues) do
					-- show issues
				end --]]
				itemButton.label:SetText(table.concat(issues, ", "))

				itemCounter = itemCounter + 1
				numItemButtons = numItemButtons + 1
			end
			characterCounter = characterCounter + 1
		end
	end

	-- hide unused stuff
	while _G[panel:GetName()..'ItemButton'..numItemButtons] do
		_G[panel:GetName()..'ItemButton'..numItemButtons]:Hide()
		numItemButtons = numItemButtons + 1
	end
	while _G[panel:GetName()..'HeaderText'..characterCounter] do
		_G[panel:GetName()..'HeaderText'..characterCounter]:Hide()
		characterCounter = characterCounter + 1
	end
end
