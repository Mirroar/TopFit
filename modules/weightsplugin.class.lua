local addonName, ns, _ = ...

local WeightsPlugin = ns.Plugin()
-- local WeightsPlugin = ns.class(ns.Plugin)
ns.WeightsPlugin = WeightsPlugin

-- GLOBALS: _G, TopFit, GREEN_FONT_COLOR, NORMAL_FONT_COLOR_CODE, ADD_ANOTHER, PAPERDOLL_SIDEBAR_STATS, PVP_RATING, SLASH_EQUIP_SET1
-- GLOBALS: CreateFrame, GetEquipmentSetInfoByName, UIDROPDOWNMENU_MENU_VALUE, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton, ToggleDropDownMenu
-- GLOBALS: table, string, wipe, pairs, ipairs, print

local lineHeight = 15

-- creates a new WeightsPlugin object
function WeightsPlugin:Initialize()
	self:SetName(TopFit.locale.StatsPanelLabel)
	self:SetTooltipText(TopFit.locale.StatsTooltip)
	self:SetButtonTexture("Interface\\Icons\\Ability_Druid_BalanceofPower")
	self:RegisterConfigPanel()
end

function WeightsPlugin.ShowEditLine(statLine, btn)
	local editLine = _G[statLine:GetParent():GetName() .. "EditStat"]
	local _, oldStatLine = editLine:GetPoint()

	if oldStatLine then oldStatLine:SetHeight(lineHeight) end
	if oldStatLine and oldStatLine == statLine then
		editLine:ClearAllPoints()
		editLine:Hide()
	else
		statLine:SetHeight(lineHeight*2 + 2)
		editLine:SetPoint("TOPLEFT", statLine, "LEFT")
		editLine:SetPoint("TOPRIGHT", statLine, "RIGHT")
		editLine:Show()
	end
end

function WeightsPlugin:SetStatLine(i, stat, value, capValue)
	-- [TODO] set stats / caps
	local frame = self:GetConfigPanel()
	local statLine = _G[frame:GetName().."StatLine"..i]
	if not statLine then
		statLine = CreateFrame("Button", "$parentStatLine"..i, frame)
		statLine:SetID(i)

		if i == 0 then -- header
			statLine:SetPoint("TOPLEFT", 0, lineHeight)
			statLine:SetPoint("TOPRIGHT", 0, lineHeight)
		else
			statLine:SetPoint("TOPLEFT", "$parentStatLine"..(i-1), "BOTTOMLEFT", 0, -2)
			statLine:SetPoint("TOPRIGHT", "$parentStatLine"..(i-1), "BOTTOMRIGHT", 0, -2)

			statLine:SetScript("OnClick", WeightsPlugin.ShowEditLine)
			statLine:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			-- blue-ish: "Interface\\Buttons\\UI-Common-MouseHilight"
		end

		if i%2 ~= 0 then
			statLine:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background"})
		end

		statLine:SetHeight(lineHeight) -- GameTooltipHeaderText, GameFontHighlightMedium, GameFontDisable
		statLine.name = statLine:CreateFontString("$parentName", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontNormal")
		statLine.name:SetPoint("TOPLEFT", 2, -2)
		statLine.value = statLine:CreateFontString("$parentValue", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontNormal")
		statLine.value:SetPoint("TOPRIGHT", -2, -2)
		statLine.capValue = statLine:CreateFontString("$parentCapValue", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontHighlight")
		statLine.capValue:SetPoint("TOPRIGHT", -80, -2)
	end

	statLine.name:SetText(_G[stat] or stat)
	statLine.value:SetText(value)
	statLine.capValue:SetText(capValue or "")
	statLine:Show()
end

local function AddStatDropDownFunc(self)
	local currentSet = ns.GetSetByID(ns.selectedSet, true)
	currentSet:SetStatWeight(self.value, 0)

	-- update display
	WeightsPlugin:OnShow()
end
local function InitializeAddStatDropDown(self, level)
	local set = TopFit.db.profile.sets[ TopFit.selectedSet ]

	local info = UIDropDownMenu_CreateInfo()
	if level == 1 then
		-- stat groups (melee, ranged, hybrid etc)
		info.hasArrow = true
		info.notCheckable = true
		info.keepShownOnClick = true
		info.colorCode = NORMAL_FONT_COLOR_CODE
		for group, stats in pairs(TopFit.statList) do
			local showGroup = false
			for _, stat in pairs(stats) do
				if not set.weights[stat] then
					showGroup = true
					break
				end
			end
			if showGroup then
				info.text = group
				info.value = group
				UIDropDownMenu_AddButton(info, level)
			end
		end

		local itemSets = ns:GetAvailableItemSetNames()
		if itemSets and #itemSets > 0 then
			info.text = string.gsub(SLASH_EQUIP_SET1, "/", "")
			info.value = SLASH_EQUIP_SET1
			UIDropDownMenu_AddButton(info, level)
		end
	else
		info.func = AddStatDropDownFunc
		if UIDROPDOWNMENU_MENU_VALUE == SLASH_EQUIP_SET1 then
			-- euipment set bonusses
			local itemSets = ns:GetAvailableItemSetNames()
			for i, setName in ipairs(itemSets or {}) do
				info.text = string.gsub(setName, "SET: ", "")
				info.value = setName
				UIDropDownMenu_AddButton(info, level)
			end
		else
			-- actual stats (intellect, stamina etc)
			for i, stat in ipairs( ns.statList[UIDROPDOWNMENU_MENU_VALUE] or {} ) do
				if not set.weights[stat] then
					info.text = _G[stat]
					info.value = stat
					UIDropDownMenu_AddButton(info, level)
				end
			end
		end
	end
end

-- initializes this plugin's UI elements
function WeightsPlugin:InitializeUI()
	local frame = self:GetConfigPanel()

	-- edit stat weights
	local editLine = CreateFrame("Frame", "$parentEditStat", frame)
		  editLine:SetHeight(lineHeight)
		  editLine:Hide()

	-- add new stats button
	local newStat = CreateFrame("Button", "$parentAddStat", frame)
	local dropDown = CreateFrame("Frame", "$parentDropDown", newStat, "UIDropDownMenuTemplate")
		  dropDown:SetAllPoints()
		  dropDown:Hide()
		  dropDown.displayMode = "MENU"
		  dropDown.initialize = InitializeAddStatDropDown

	newStat:SetScript("OnClick", function(self, btn)
		ToggleDropDownMenu(nil, nil, dropDown)
	end)
	local newStatText = newStat:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
		  newStatText:SetPoint("TOPLEFT")
		  newStatText:SetTextColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
		  newStatText:SetText("|TInterface\\PaperDollInfoFrame\\Character-Plus:0|t "..ADD_ANOTHER)
	newStat:SetSize( newStatText:GetWidth(), newStatText:GetHeight() )
end

local function SortStats(a, b)
	local set = TopFit.db.profile.sets[ TopFit.selectedSet ]
	local cappedA, cappedB = set.caps[a] and set.caps[a].value or 0, set.caps[b] and set.caps[b].value or 0
	local weightA, weightB = set.weights[a], set.weights[b]

	if (_G[a] and 1 or 0) ~= (_G[b] and 1 or 0) then
		-- put sets and other pseude-stats at the end
		return (_G[a] and true or false)
	elseif weightA ~= weightB then
		return weightA > weightB
	elseif cappedA ~= cappedB then
		return cappedA > cappedB
	else
		return a < b
	end
end

local setStats = {}
function WeightsPlugin:OnShow()
	local frame = self:GetConfigPanel()
	local set = ns.GetSetByID( ns.selectedSet )

	ns.ui.SetHeaderSubTitle(frame, set:GetName())
	ns.ui.SetHeaderSubTitleIcon(frame, set:GetIconTexture(), 0, 1, 0, 1)

	frame.stats = frame.stats or {}
	wipe(frame.stats)

	for stat, weight in pairs(set:GetStatWeights(setStats)) do
		table.insert(frame.stats, stat)
	end
	table.sort(frame.stats, SortStats)

	self:SetStatLine(0, PAPERDOLL_SIDEBAR_STATS, string.gsub(PVP_RATING, ":", ""), "Cap")
	for i, stat in ipairs(frame.stats) do
		self:SetStatLine(i, stat, set:GetStatWeight(stat), set:GetHardCap(stat))
	end
	local i = #(frame.stats) + 1
	while _G[frame:GetName().."StatLine"..i] do
		_G[frame:GetName().."StatLine"..i]:Hide()
		i = i + 1
	end

	-- position add button at the end
	_G[frame:GetName().."AddStat"]:SetPoint("TOPLEFT", "$parentStatLine"..#(frame.stats), "BOTTOMLEFT", 0, -10)
end

-- create plugin and register with TopFit
-- WeightsPlugin()
