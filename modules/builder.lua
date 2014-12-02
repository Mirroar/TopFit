local addonName, ns, _ = ...

-- GLOBALS: _G, INVSLOT_TABARD, INVSLOT_HEAD, INVSLOT_NECK, INVSLOT_BODY, INVSLOT_WAIST, INVSLOT_FINGER1, INVSLOT_FINGER2, INVSLOT_TRINKET1, INVSLOT_TRINKET2, INVSLOT_WRIST, INVSLOT_MAINHAND, INVSLOT_OFFHAND, INVSLOT_HAND, INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED
-- GLOBALS: CreateFrame, UnitLevel, GetProfessions, GetProfessionInfo, GetFactionInfo, GetInventoryItemLink, GetItemStats, OffhandHasWeapon, UnitName, GetRealmName, GetItemInfo, GetNumFactions, SetItemButtonTexture
-- GLOBALS: pairs, ipairs, wipe, table.insert, string.find, print

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

	hooksecurefunc("ChatEdit_InsertLink", function(text) -- hook shift-clicks on items
		local popup = StaticPopup_FindVisible('TOPFIT_BUILDER_SETLINK')
        if popup and popup.editBox:HasFocus() then
            popup.editBox:Insert(text)
        end
    end)
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
		for gemIndex = 1, _G.MAX_NUM_SOCKETS do
			itemButton[gemIndex]:Hide()
		end

		wipe(itemStats)
		itemStats = GetItemStats(itemLink, itemStats)

		local _, enchantID = itemLink:match("item:([^:]+):([^:]+):")
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

		local texture = select(10, GetItemInfo(itemLink))
		SetItemButtonTexture(itemButton, texture or "Interface\\Icons\\Inv_Misc_Questionmark")
		itemButton.itemLink = itemLink
	else
		SetItemButtonTexture(itemButton, "Interface\\PaperDoll\\UI-Backpack-EmptySlot")
		itemButton.itemLink = nil
	end
end

local function SetSlotItem(self, itemLink)
	local slotID = self:GetID()
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
			StaticPopup_Show('TOPFIT_BUILDER_SETLINK', slotID, nil, self)
		elseif cursorType == 'item' and itemLink then
			SetSlotItem(self, itemLink)
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
			OnAccept = function(self, data)
				local item = self.editBox:GetText()
				if not item or item == '' then return end
				local _, itemLink = GetItemInfo(item)
				SetSlotItem(data, itemLink)
			end,
			OnShow = function(self, data)
				self.editBox:SetText(data.itemLink)
				self.editBox:HighlightText()
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
