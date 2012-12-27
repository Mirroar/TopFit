local addonName, ns, _ = ...

local WeightsPlugin = ns.class(ns.Plugin)
ns.WeightsPlugin = WeightsPlugin

-- GLOBALS: _G, TopFit, GREEN_FONT_COLOR, NORMAL_FONT_COLOR_CODE
-- GLOBALS: CreateFrame, GetEquipmentSetInfoByName, UIDROPDOWNMENU_MENU_VALUE, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton, ToggleDropDownMenu
-- GLOBALS: table, string, wipe, pairs, ipairs, print

-- creates a new WeightsPlugin object
function WeightsPlugin:Initialize()
	self:SetName(TopFit.locale.StatsPanelLabel)
	self:SetTooltipText(TopFit.locale.StatsTooltip)
	self:SetButtonTexture("Interface\\Icons\\Ability_Druid_BalanceofPower")
	self:RegisterConfigPanel()
end

function WeightsPlugin:SetStatLine(i, stat, value, capValue)
	local frame = self:GetConfigPanel()
	local statLine = _G[frame:GetName().."StatLine"..i]
	if not statLine then
		statLine = CreateFrame("Frame", "$parentStatLine"..i, frame)
		-- [TODO] add line highlights!
		if i == 0 then -- header
			statLine:SetPoint("TOPLEFT", 0, 15)
			statLine:SetPoint("TOPRIGHT", 0, 15)
		else
			statLine:SetPoint("TOPLEFT", "$parentStatLine"..(i-1), "BOTTOMLEFT", 0, -2)
			statLine:SetPoint("TOPRIGHT", "$parentStatLine"..(i-1), "BOTTOMRIGHT", 0, -2)
		end

		if i%2 ~= 0 then
			statLine:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background"})
		end

		statLine:SetHeight(15) -- GameTooltipHeaderText, GameFontHighlightMedium, GameFontDisable
		statLine.name = statLine:CreateFontString("$parentName", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontNormal")
		statLine.name:SetPoint("LEFT", 2, -1)
		statLine.value = statLine:CreateFontString("$parentValue", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontNormal")
		statLine.value:SetPoint("RIGHT", -2, -1)
		statLine.capValue = statLine:CreateFontString("$parentCapValue", "ARTWORK", i==0 and "GameFontHighlight" or "GameFontHighlight")
		statLine.capValue:SetPoint("RIGHT", -80, -1)
	end

	statLine.name:SetText(_G[stat] or stat)
	statLine.value:SetText(value)
	statLine.capValue:SetText(capValue or "")
end

local function AddStatDropDownFunc(self)
	print("click", self.value) -- [TODO]
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

		-- [TODO] add item sets
	else
		-- actual stats (intellect, stamina etc)
		info.func = AddStatDropDownFunc
		for i, stat in ipairs( TopFit.statList[UIDROPDOWNMENU_MENU_VALUE] ) do
			if not set.weights[stat] then
				info.text = _G[stat]
				info.value = stat
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end
end

-- initializes this plugin's UI elements
function WeightsPlugin:InitializeUI()
	local frame = self:GetConfigPanel()
	local set = TopFit.db.profile.sets[ TopFit.selectedSet ]
	ns.ui.SetHeaderSubTitle(frame, set.name)

	local setName = TopFit:GenerateSetName(set.name)
	local texture = "Interface\\Icons\\" .. (GetEquipmentSetInfoByName(setName) or "Spell_Holy_EmpowerChampion")
	ns.ui.SetHeaderSubTitleIcon(frame, texture, 0, 1, 0, 1)

	frame.stats = frame.stats or {}
	wipe(frame.stats)

	-- [TODO] handle "SET: foo" etc
	for stat, weight in pairs(set.weights) do
		table.insert(frame.stats, stat)
	end
	table.sort(frame.stats, function(a, b)
		local cappedA, cappedB = set.caps[a] and set.caps[a].value or 0, set.caps[b] and set.caps[b].value or 0
		local weightA, weightB = set.weights[a], set.weights[b]

		if (_G[a] and 1 or 0) ~= (_G[b] and 1 or 0) then
			return (_G[a] and true or false)
		elseif weightA ~= weightB then
			return weightA > weightB
		elseif cappedA ~= cappedB then
			return cappedA > cappedB
		else
			return a < b
		end
	end)

	self:SetStatLine(0, STAT_CATEGORY_ATTRIBUTES, string.gsub(PVP_RATING, ":", ""), "Cap")
	for i, stat in ipairs(frame.stats) do
		self:SetStatLine(i, stat, set.weights[stat], set.caps[stat] and set.caps[stat].value or nil)
	end

	-- add new stats
	local newStat = CreateFrame("Button", frame:GetName().."AddStat", frame)
	newStat:SetPoint("TOPLEFT", "$parentStatLine"..#(frame.stats), "BOTTOMLEFT", 0, -10)

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

function WeightsPlugin:OnShow()
	print("show weights")
	-- self.pwned:SetText(string.format(TopFit.locale.GearScore, TopFit:CalculateGearScore() or "?"))
end

function WeightsPlugin:OnSetChanged()
	-- self.pwned:SetText(string.format(TopFit.locale.GearScore, TopFit:CalculateGearScore() or "?"))
end

-- create plugin and register with TopFit
WeightsPlugin()
