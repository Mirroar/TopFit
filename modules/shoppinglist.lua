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
	[INVSLOT_WAIST] = true,     -- buckles
	[INVSLOT_FINGER1] = true,   -- enchanters
	[INVSLOT_FINGER2] = true,   -- enchanters
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
	local _, _, primary1level, _, _, _, primary1 = GetProfessionInfo(primary1)
	local _, _, primary2level, _, _, _, primary2 = GetProfessionInfo(primary2)
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
			itemLevel = tonumber(itemLevel)

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
			local hasExtraSocket = gem4 ~= "0" or (not sockets[3] and gem3 ~= "0") or (not sockets[2] and gem2 ~= "0") or (not sockets[1] and gem1 ~= "0")

			if canHaveExtraSocket and not hasExtraSocket then
				-- TODO: can't differenciate between empty added socket or no added socket at all
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


-- --------------------------------------------------------
--  WhatIf?
-- --------------------------------------------------------
local Builder = ns.Plugin()
   ns.Builder = Builder
local currentCharacter, db2

-- GLOBALS: TopFitDB, GEM_TYPE_INFO
-- GLOBALS: LoadAddOn, SetDesaturation, GetItemGem, GetItemIcon

local colorNames = {
	['EMPTY_SOCKET_RED']		= 'Red',
	['EMPTY_SOCKET_BLUE']		= 'Blue',
	['EMPTY_SOCKET_YELLOW']		= 'Yellow',
	['EMPTY_SOCKET_HYDRAULIC']	= 'Hydraulic',
	['EMPTY_SOCKET_COGWHEEL']	= 'Cogwheel',
	['EMPTY_SOCKET_META']		= 'Meta',
	['EMPTY_SOCKET_PRISMATIC']	= 'Prismatic',
	['EMPTY_SOCKET_NO_COLOR']	= 'Prismatic',
}

local addsSocket = {
	-- TODO: ask TopFit for this data
	['5015'] = 'EMPTY_SOCKET_HYDRAULIC', -- 136213 Sha Touched Socket
	['3723'] = 'EMPTY_SOCKET_PRISMATIC', -- 55641 Blacksmithing gloves
	['3717'] = 'EMPTY_SOCKET_PRISMATIC', -- 55628 Blacksmithing bracers
	['5002'] = 'EMPTY_SOCKET_PRISMATIC', -- 131467 belt buckle (417+)
	['3729'] = 'EMPTY_SOCKET_PRISMATIC', -- 76168 belt buckle (300+), 55655 belt buckle
}

-- creates a new plugin object
function Builder:Initialize()
	self:SetName("Builder")
	self:SetTooltipText("What if you wore other gear?")
	self:SetButtonTexture("Interface\\Icons\\Achievement_Reputation_03") -- Achievement_General_100kquests
	self:RegisterConfigPanel()

	if not TopFitDB.Builder then
		TopFitDB.Builder = {}
	end
	local realm = GetRealmName()
	if not TopFitDB.Builder[realm] then
		TopFitDB.Builder[realm] = {}
	end
	db2 = TopFitDB.Builder[realm]

	currentCharacter = UnitName("player")
	if not db2[currentCharacter] then
		db2[currentCharacter] = {}
	end
end

-- --------------------------------------------------------
--  Update UI
-- --------------------------------------------------------
local function UpdateSocketInfo(socket, color)
	local gemInfo = GEM_TYPE_INFO[color]
	socket.bg:SetTexture(gemInfo.tex)
	socket.bg:SetTexCoord(gemInfo.left, gemInfo.right, gemInfo.top, gemInfo.bottom)
	if color == 'Meta' or color == 'Prismatic' then
		SetDesaturation(socket.bg, 1)
	else
		SetDesaturation(socket.bg, nil)
	end
end

local itemStats = {}
local function UpdateItemSlot(itemButton, itemLink)
	if itemLink then
		local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemLink)

		for gemIndex = 1, _G.MAX_NUM_SOCKETS do
			itemButton[gemIndex]:Hide()
		end

		wipe(itemStats)
		itemStats = GetItemStats(itemLink, itemStats)

		local _, enchantID = link:match("item:([^:]+):([^:]+):")
		if enchantID then
			local socketColor = addsSocket[enchantID]
			if socketColor then
				itemStats[socketColor] = (itemStats[socketColor] or 0) + 1
			end
		end

		local gemIndex = 1
		-- display available sockets
		for statName, amount in pairs(itemStats) do
			local dataColor = colorNames[statName]
			if dataColor then
				-- item has socket(s)
				for i = 1, amount do
					UpdateSocketInfo(itemButton[gemIndex], dataColor)
					itemButton[gemIndex]:Show()
					gemIndex = gemIndex + 1
				end
			end
		end

		-- display info on filled sockets
		for gemIndex = 1, _G.MAX_NUM_SOCKETS do
			local _, gemLink = GetItemGem(itemLink, gemIndex)
			if gemLink then
				if not itemButton[gemIndex]:IsShown() then
					-- additional gem found
					UpdateSocketInfo(itemButton[gemIndex], 'Prismatic')
					itemButton[gemIndex]:Show()
				end
				itemButton[gemIndex].itemLink = gemLink
				itemButton[gemIndex].fill:SetTexture( GetItemIcon(gemLink) )
				itemButton[gemIndex].fill:Show()
			else
				itemButton[gemIndex].itemLink = nil
				itemButton[gemIndex].fill:Hide()
			end
		end

		itemButton.itemLink = itemLink
		SetItemButtonTexture(itemButton, texture or "Interface\\Icons\\Inv_Misc_Questionmark")
	else
		itemButton.itemLink = nil
		SetItemButtonTexture(itemButton, "Interface\\PaperDoll\\UI-Backpack-EmptySlot")
	end
end

local function SetSlotItem(itemLink)
	-- TODO: prettify
	local _, _, _, _, _, _, _, _, equipSlot = GetItemInfo(itemLink)
	local slots = ns:GetEquipLocationsByInvType(equipSlot)
	local suitable = false
	for i, slot in ipairs(slots) do
		if slot == slotID then
			suitable = true
			break
		end
	end

	if suitable then
		-- if db2[slotID] and db2[slotID] == itemLink then
		-- 	db2[slotID] = nil
		-- else
			db2[slotID] = itemLink
		-- end
		PickupItem(self.itemLink)
		UpdateItemSlot(self, itemLink)
	end
end

local function GetSlotOptions( ... )
	-- enchant
	-- socket enchant
	-- reforge
end
-- --------------------------------------------------------
--  Initialize UI
-- --------------------------------------------------------
local function ItemButtonOnClick(self, button, up)
	local slotID = self:GetID()
	if IsModifiedClick() then
		if not self.itemLink then return end
		if HandleModifiedItemClick(self.itemLink) then return end
		if IsModifiedClick("SOCKETITEM") then SocketInventoryItem(slotID) end
	elseif button == 'RightButton' then
		print('right clicked', 'show enchant options')
	else
		local cursorType, itemID, itemLink = GetCursorInfo()
		if not cursorType then
			StaticPopup_Show('TOPFIT_BUILDER_SETLINK', slotID)
		elseif cursorType == 'item' and itemLink then
			SetSlotItem(itemLink)
		end
	end
end
local function ItemButtonOnDrag(self)
	ItemButtonOnClick(self, 'LeftButton')
end
local function SocketOnClick(self)
	if not self.itemLink then return end
	HandleModifiedItemClick(self.itemLink)
end

function Builder:OnShow()
	LoadAddOn('Blizzard_ItemSocketingUI')
	local set = ns.GetSetByID(ns.selectedSet, true)
	local panel = self:GetConfigPanel()

	-- initialize display
	if not panel.buttons then
		StaticPopupDialogs["TOPFIT_BUILDER_SETLINK"] = {
			text = 'Insert item link for slot %d',
			button1 = _G.OKAY,
			button2 = _G.CANCEL,
			hasEditBox = true,
			OnAccept = function(self)
				local item = self.editBox:GetText()
				print('okay!', self, item)
			end,
			OnShow = function(self)
				print('show', self.data)
				-- self.text:SetFormattedText()
			end,
			OnHide = function (self) self.data = nil end,
			EditBoxOnEscapePressed = function(self)
				self:GetParent().button2:Click()
			end,
			EditBoxOnEnterPressed = function(self)
				self:GetParent().button1:Click()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3
		}

		panel.buttons = {}

		local index = 0
		for slotID = _G.INVSLOT_FIRST_EQUIPPED, _G.INVSLOT_LAST_EQUIPPED do
			if slotID ~= _G.INVSLOT_BODY and slotID ~= _G.INVSLOT_RANGED and slotID ~= _G.INVSLOT_TABARD then
				index = index + 1
				local _, itemLink, _, _, _, _, _, _, _, texture -- = GetItemInfo(itemID)

				local itemButton = CreateFrame('Button', '$parentItemButton'..slotID, panel, 'ItemButtonTemplate', slotID)
					  itemButton:SetScript('OnEnter', ns.ShowTooltip)
					  itemButton:SetScript('OnLeave', ns.HideTooltip)
					  itemButton:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
					  itemButton:SetScript('OnClick', ItemButtonOnClick)
					  itemButton:SetScript('OnReceiveDrag', ItemButtonOnDrag)
				panel.buttons[index] = itemButton

				for socketIndex = 1, _G.MAX_NUM_SOCKETS do
					local socket = CreateFrame('Frame', nil, itemButton)
						  socket:SetSize(12, 12)
						  socket:SetScript('OnEnter', ns.ShowTooltip)
						  socket:SetScript('OnLeave', ns.HideTooltip)
						  socket:SetScript('OnMouseDown', SocketOnClick)
						  socket:Hide()
					itemButton[socketIndex] = socket

					local bg = socket:CreateTexture(nil, 'BACKGROUND')
						  bg:SetAllPoints()
					socket.bg = bg
					local fill = socket:CreateTexture(nil, 'ARTWORK')
						  fill:SetPoint('CENTER', socket, 'CENTER')
						  fill:SetSize(10, 10)
						  fill:Hide()
					socket.fill = fill

					if socketIndex == 1 then
						socket:SetPoint('TOPLEFT', itemButton, 'BOTTOMLEFT', 0, -4)
					else
						socket:SetPoint('TOPLEFT', itemButton[socketIndex - 1], 'TOPRIGHT', 0, 0)
					end
				end

				if index == 1 then
					itemButton:SetPoint('TOPLEFT', 16, 0)
				elseif index % 9 == 0 then -- new row
					itemButton:SetPoint('TOPLEFT', panel.buttons[index - 8], 'BOTTOMLEFT', 0, -26)
				else
					itemButton:SetPoint('TOPLEFT', panel.buttons[index - 1], 'TOPRIGHT', 6, 0)
				end
			end
		end
	end

	-- update display
	local index = 0
	for slotID = _G.INVSLOT_FIRST_EQUIPPED, _G.INVSLOT_LAST_EQUIPPED do
		if slotID ~= _G.INVSLOT_BODY and slotID ~= _G.INVSLOT_RANGED and slotID ~= _G.INVSLOT_TABARD then
			index = index + 1
			local itemButton = panel.buttons[index]
			local itemLink = db2[slotID] or GetInventoryItemLink('player', slotID)
			UpdateItemSlot(itemButton, itemLink)
		end
	end
end
