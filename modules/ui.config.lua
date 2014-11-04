local addonName, ns, _ = ...
ns.ui = ns.ui or {}
local ui = ns.ui

-- GLOBALS: NORMAL_FONT_COLOR, GREEN_FONT_COLOR_CODE, RED_FONT_COLOR_CODE, MAX_EQUIPMENT_SETS_PER_PLAYER, EQUIPMENT_SETS_TOO_MANY, ADD_ANOTHER, _G, PANEL_INSET_LEFT_OFFSET, PANEL_INSET_TOP_OFFSET, PANEL_INSET_RIGHT_OFFSET, PANEL_INSET_BOTTOM_OFFSET, UIParent, GameTooltip, assert, hooksecurefunc, unpack, select, type, pairs, ipairs
-- GLOBALS: LoadAddOn, PlaySound, CreateFrame, ShowUIPanel, HideUIPanel, SetPortraitToTexture, GetTexCoordsForRole, ButtonFrameTemplate_HideAttic, GetNumEquipmentSets, ToggleDropDownMenu, UIDropDownMenu_CreateInfo, UIDropDownMenu_AddButton

function ui.CreateConfigPanel(isFull)
	local button = ui.GetSidebarButton()
	local id = button:GetID()
	local panel = CreateFrame("Frame", "TopFitConfigFramePlugin"..button:GetID(), _G["TopFitConfigFrameInset"].spellsScroll.child)
		  panel:Hide()

	panel.displayHeader = not isFull

	button.panel = panel
	panel.button = button

	return button, panel
end

local function SetHeaderData(scrollChild, panel)
	if panel.icon then
		SetPortraitToTexture(scrollChild.specIcon, panel.icon or "")
		scrollChild.specIcon:Show()
	else
		scrollChild.specIcon:Hide()
	end
	scrollChild.specName:SetText( panel.title or "" )
	scrollChild.description:SetText( panel.description or "" )
	scrollChild.roleName:SetText( panel.subTitle or "" )
	scrollChild.roleIcon:SetTexture( panel.subIcon or "" )
	if panel.subIconCoords and #(panel.subIconCoords) >= 4 then
		scrollChild.roleIcon:SetTexCoord( unpack(panel.subIconCoords) )
	end
end

local function DisplayScrollFramePanel(scrollFrame, panel)
	assert(scrollFrame and panel, "Missing arguments. Usage: DisplayScrollFramePanel(scrollFrame, panel)")
	local buttonID = 1
	local button = _G[scrollFrame:GetParent():GetName().."SpecButton"..buttonID]
	while button do
		ui.SetSidebarButtonState(button, button:GetID() == panel.button:GetID())
		button.selected = button:GetID() == panel.button:GetID()

		buttonID = buttonID + 1
		button = _G[scrollFrame:GetParent():GetName().."SpecButton"..buttonID]
	end

	local currentChild = scrollFrame:GetScrollChild(scrollFrame)
	if currentChild.panel then
		-- hide old panel content
		currentChild.panel:SetParent(nil)
		currentChild.panel:ClearAllPoints()
		currentChild.panel:Hide()
	else
		-- very first init
		currentChild.abilityButton1:Hide()
	end

	local scrollChild = _G[scrollFrame:GetName().."ScrollChild"]
	if not ns.selectedSet then
		-- show placeholder panel to inform the user
		currentChild:Hide()
		scrollFrame:SetScrollChild(scrollChild)
		scrollChild:Show()

		SetPortraitToTexture(scrollChild.specIcon, "Interface\\ICONS\\Achievement_BG_AB_kill_in_mine")
		scrollChild.specIcon:Show()

		scrollChild.specName:SetText(ns.locale.NoSetTitle)
		scrollChild.description:SetText(ns.locale.NoSetDescription)
		scrollChild.roleName:SetText("")
		scrollChild.roleIcon:SetTexture("")
	else
		currentChild:Show()
		if panel.displayHeader then
			if currentChild ~= scrollChild then
				-- changing fromm full mode to header mode
				currentChild:Hide()
				scrollFrame:SetScrollChild(scrollChild)
				scrollChild:Show()
			end

			SetHeaderData(scrollChild, panel)

			panel:SetParent(scrollChild)
			panel:ClearAllPoints()
			panel:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 24, -185)
			panel:SetPoint("BOTTOMRIGHT", scrollChild, "BOTTOMRIGHT", -24, 10)
			-- panel:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -24, -185)
			panel:Show()

			scrollChild.panel = panel
		else
			-- changing from header mode to full mode
			if currentChild == scrollChild then currentChild:Hide() end

			scrollFrame:SetScrollChild(panel)
			panel:SetSize(400, 400) -- totally random
			panel:SetParent(scrollFrame)
			panel:ClearAllPoints()
			panel:SetPoint("TOPLEFT")
			panel:SetPoint("BOTTOMRIGHT")
			panel:Show()
		end
	end
	ui.Update()
end
local function ButtonOnClick(self)
	GameTooltip:Hide()
	PlaySound("igMainMenuOptionCheckBoxOn")
	ui.ShowPanel(self.panel)
end
local function ButtonOnEnter(self)
	if self.selected then return end
	if self.tooltip and self.tooltip ~= "" then
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(self.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		GameTooltip:Show()
	end
end
local function ButtonOnLeave(self)
	GameTooltip:Hide()
end

function ui.GetSidebarButton(index)
	local frame = _G["TopFitConfigFrameInset"]
	assert(frame, "TopFitConfigFrame has not been initialized properly.")

	-- allow calling this function without knowing the next id to create a new button every time
	if not index then
		index = 1
		while _G[frame:GetName() .. "SpecButton" .. index] and not frame["specButton"..index] do
			index = index + 1
		end
	end

	local button = _G[frame:GetName() .. "SpecButton" .. index]
	if not button or frame["specButton"..index] then
		if not button then
			button = CreateFrame("Button", "$parentSpecButton"..index, frame, "PlayerSpecButtonTemplate", index)
		end

		button:SetScript("OnClick", ButtonOnClick)
		button:SetScript("OnEnter", ButtonOnEnter)
		button:SetScript("OnLeave", ButtonOnLeave)

		button:ClearAllPoints()
		if index == 1 then
			button:SetPoint("TOPLEFT", 6, -65) -- -56
		else
			button:SetPoint("TOP", "$parentSpecButton"..(index-1), "BOTTOM", 0, -10)
		end

		button.roleIcon:Hide()
		button.roleName:Hide()
		button.ring:SetTexture("Interface\\TalentFrame\\spec-filagree") 			-- Interface\\TalentFrame\\talent-main
		button.ring:SetTexCoord(0.00390625, 0.27734375, 0.48437500, 0.75781250) 	-- 0.50000000, 0.91796875, 0.00195313, 0.21093750
		button.specIcon:SetSize(100-14, 100-14) 									-- 100/66 (filagree is 70/56)

		ui.SetSidebarButtonHeight(button, 40)
		if frame["specButton"..index] then
			frame["specButton"..index] = nil
		end
	end
	button:Show()

	return button
end
function ui.SetSidebarButtonState(button, active)
	if active then
		button.selected = true
		button.selectedTex:Show()
		button.learnedTex:Show()
	else
		button.selected = nil
		button.selectedTex:Hide()
		button.learnedTex:Hide()
	end
end
function ui.SetSidebarButtonHeight(button, height)
	button:SetHeight(height) 							-- 60
	button.bg:SetHeight(height+20) 						-- 80
	button.selectedTex:SetHeight(height+20) 			-- 80
	button.learnedTex:SetHeight(2*height+8) 			-- 128
	button:GetHighlightTexture():SetHeight(height+20) 	-- 80

	local ringSize = 80/60 * height 					-- 100
	button.specIcon:SetSize(ringSize*4/5, ringSize*4/5) -- 2/3
	button.ring:SetSize(ringSize, ringSize)
	button.ring:ClearAllPoints()
	button.ring:SetPoint("LEFT", "$parent", "LEFT", 4, 0)
end
function ui.SetSidebarButtonData(button, name, tooltip, texture, role)
	if texture then
		SetPortraitToTexture(button.specIcon, texture)
		button.ring:Show()
	else
		button.ring:Hide()
	end
	button.specName:SetText(name)
	button.tooltip = tooltip
	if role then
		button.roleIcon:SetTexCoord(GetTexCoordsForRole(role))
		button.roleName:SetText(_G[role])
		button.roleIcon:Show()
		button.roleName:Show()

		button.specName:ClearAllPoints()
		button.specName:SetPoint("BOTTOMLEFT", "$parentRing", "RIGHT", 0, 0)
	else
		button.roleIcon:Hide()
		button.roleName:Hide()

		button.specName:ClearAllPoints()
		button.specName:SetPoint("LEFT", "$parentRing", "RIGHT", 0, 0)
	end
end

function ui.SetActivePanel(mixed) -- button, panel, id
	if type(mixed) == "table" then mixed = mixed:GetID() end
	local button = _G["TopFitConfigFrameInsetSpecButton"..mixed]
	assert(button, "Button/panel with id "..mixed.." does not exist.")

	ui.ShowPanel(button.panel)
end
function ui.GetActivePanel()
	return _G["TopFitConfigFrame"].activePanel
end

function ui.SetHeaderTitle(panel, title)
	panel.title = title or ""
	if panel:IsShown() then
		panel:GetParent().specName:SetText(title or "")
	end
end
function ui.SetHeaderIcon(panel, texture)
	panel.icon = texture
	if panel:IsShown() then
		local scrollChild = panel:GetParent()
		if texture and texture ~= "" then
			SetPortraitToTexture(scrollChild.specIcon, texture)
			scrollChild.specIcon:Show()
		else
			scrollChild.specIcon:Hide()
		end
	end
end
function ui.SetHeaderSubTitle(panel, subTitle)
	panel.subTitle = subTitle or ""
	if panel:IsShown() then
		panel:GetParent().roleName:SetText(subTitle)
	end
end
function ui.SetHeaderSubTitleIcon(panel, texture, ...)
	panel.subIcon = texture
	if select('#', ...) >= 4 then
		panel.subIconCoords = { ... }
	end
	if panel:IsShown() then
		local scrollChild = panel:GetParent()
		scrollChild.roleIcon:SetTexture(texture)
		if select('#', ...) >= 4 then
			scrollChild.roleIcon:SetTexCoord( ... )
		end

	end
end
function ui.SetHeaderDescription(panel, text)
	panel.description = text or ""
	if panel:IsShown() then
		panel:GetParent().description:SetText( text or "" )
	end
end
function ui.SetPanelDisplayHeader(panel, displayHeader)
	local oldState = panel.displayHeader
	panel.displayHeader = displayHeader
	if panel:IsShown() and oldState ~= displayHeader then
		ui.ShowPanel(panel)
	end
end

function ui.ShowPanel(panel)
	_G["TopFitConfigFrame"].activePanel = panel
	DisplayScrollFramePanel(_G["TopFitConfigFrameInsetSpellScrollFrame"], panel)
end

function ui.Update(rebuildPanel)
	local frame = _G["TopFitConfigFrameInsetSpellScrollFrame"]
	if not frame then return end

	ui.UpdateSetTabs()

	if rebuildPanel and TopFitConfigFrame.activePanel then
		ui.ShowPanel(TopFitConfigFrame.activePanel)
	end

	-- ScrollFrame_OnScrollRangeChanged(frame, 0, 0)
	frame:SetVerticalScroll(0)

	local panel = ui.GetActivePanel()
	if panel and panel.OnUpdate and not ns.IsEmpty(ns.db.profile.sets) then
		panel:OnUpdate()
	end
end

local function CreateSideTab(index)
	local tab = CreateFrame("CheckButton", "$parentTab"..index, _G["TopFitConfigFrame"], "PlayerSpecTabTemplate")
	tab:SetID(index)
	tab:RegisterForClicks("AnyUp")
	tab:SetScript("OnEnter", ButtonOnEnter)
	tab:SetScript("OnLeave", ButtonOnLeave)
	tab:SetScript("OnClick", function(self, btn)
		PlaySound("igCharacterInfoTab")

		if self.setID then
			ns:SetSelectedSet(self.setID)
		else -- new set tab
			if GetNumEquipmentSets() >= MAX_EQUIPMENT_SETS_PER_PLAYER then return end
			if btn == "RightButton" then
				ToggleDropDownMenu(nil, nil, _G["TopFitConfigFrameInsetAddFromPreset"], "cursor")
			else
				ns:AddSet()
			end
			ui.Update()
		end
	end)

	if index == 1 then
		tab:SetPoint("TOPLEFT", "$parent", "TOPRIGHT", 0, -50)
	else
		tab:SetPoint("TOPLEFT", "$parentTab"..(index-1), "BOTTOMLEFT", 0, -22)
	end

	return tab
end

local gearSets = {}
function ui.UpdateSetTabs()
	local tab, set
	local gearSets = ns.GetSetList(gearSets)
	for index, setID in ipairs(gearSets) do
		set = ns.GetSetByID(setID)

		tab = _G["TopFitConfigFrameTab"..index] or CreateSideTab(index)
		tab.tooltip = set:GetName()
		tab.setID = setID

		tab:GetNormalTexture():SetTexture( set:GetIconTexture() )
		tab:SetChecked( setID == ns.selectedSet )
		tab:Show()
	end

	-- "add another set" button
	local numSets = #(gearSets) + 1
	tab = _G["TopFitConfigFrameTab"..numSets] or CreateSideTab(numSets)
	tab.setID = nil
	tab:GetNormalTexture():SetTexture("Interface\\GuildBankFrame\\UI-GuildBankFrame-NewTab") -- "Interface\\PaperDollInfoFrame\\Character-Plus"
	if GetNumEquipmentSets() >= MAX_EQUIPMENT_SETS_PER_PLAYER then
		tab:GetNormalTexture():SetDesaturated(true)
		tab.tooltip = RED_FONT_COLOR_CODE..EQUIPMENT_SETS_TOO_MANY
	else
		tab:GetNormalTexture():SetDesaturated(false)
		tab.tooltip = GREEN_FONT_COLOR_CODE..ADD_ANOTHER
	end
	tab:SetChecked(nil)
	tab:Show()

	-- hide unused
	numSets = numSets + 1
	while _G["TopFitConfigFrameTab"..numSets] do
		_G["TopFitConfigFrameTab"..numSets]:Hide()
		numSets = numSets + 1
	end
end

function ui.IsConfigFrameInitialized()
	return _G["TopFitConfigFrame"] and true or false
end
function ui.ToggleTopFitConfigFrame()
	local frame = _G["TopFitConfigFrame"]
	if not frame then
		LoadAddOn("Blizzard_TalentUI") -- won't double init

		frame = CreateFrame("Frame", "TopFitConfigFrame", UIParent, "PortraitFrameTemplate")
		frame:EnableMouse(true)
		-- TalentFrame size: 646, 468
		-- PVEFrame width: 563, 424
		frame:SetWidth(646)
		frame:Hide()

		frame:SetAttribute("UIPanelLayout-defined", true)
		frame:SetAttribute("UIPanelLayout-enabled", true)
		frame:SetAttribute("UIPanelLayout-whileDead", true)
		frame:SetAttribute("UIPanelLayout-area", "left")
		frame:SetAttribute("UIPanelLayout-pushable", 5) 	-- when competing for space, lower numbers get closed first
		frame:SetAttribute("UIPanelLayout-width", 646) 		-- width + 20
		frame:SetAttribute("UIPanelLayout-height", 468) 	-- height + 20

		SetPortraitToTexture(frame:GetName().."Portrait", "Interface\\Icons\\Achievement_BG_trueAVshutout")
		frame.TitleText:SetText("TopFit")

		local frameContent = CreateFrame("Frame", "$parentInset", frame, "SpecializationFrameTemplate")
		frame.Inset = frameContent
		frameContent:SetPoint("TOPLEFT", PANEL_INSET_LEFT_OFFSET, PANEL_INSET_TOP_OFFSET)
		frameContent:SetPoint("BOTTOMRIGHT", PANEL_INSET_RIGHT_OFFSET, PANEL_INSET_BOTTOM_OFFSET)
		-- fix portrait icon being overlaid by Inset
		frameContent:SetFrameLevel(0) -- put below parent
		frameContent:SetFrameLevel(1) -- and then raise again

		frameContent.MainHelpButton:Hide()
		frameContent.learnButton:Hide()
		frameContent.bg:SetPoint("BOTTOMRIGHT")
		frameContent.bg:SetTexCoord(0, 0.75, 0, 0.86)
		local sidebarBg = frameContent:GetRegions()
		sidebarBg:SetHeight(400)
		local sidebarFrame = select(7, frameContent:GetChildren())
		local _, sidebarBR, sidebarBL, sidebarSeperator, sidebarLineL, sidebarLineR, sidebarLineB = sidebarFrame:GetRegions()
		sidebarSeperator:SetHeight(400)
		sidebarBL:SetPoint("BOTTOMLEFT", 3, 0)
		sidebarBR:SetPoint("BOTTOMLEFT", 147, 0)

		local scrollFrame = frameContent.spellsScroll
		scrollFrame:SetHeight(410-18) -- Blizzard_TalentUI is taller than we are
		scrollFrame.scrollBarHideable = true
		-- alternative offsets: -15, -14 / -15, 10
		scrollFrame.ScrollBar:SetPoint("TOPLEFT", "$parent", "TOPRIGHT", -18, -16)
		scrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", "$parent", "BOTTOMRIGHT", -18, 16)

		-- reanchor textures so they don't scroll later on
		local scrollChild = scrollFrame.child
		scrollChild:SetAllPoints(scrollFrame)
		scrollChild.scrollwork_topleft:SetParent(frameContent)
		scrollChild.scrollwork_topleft:ClearAllPoints()
		scrollChild.scrollwork_topleft:SetPoint("TOPLEFT", 217, 0)
		scrollChild.scrollwork_topright:SetParent(frameContent)
		scrollChild.scrollwork_topright:ClearAllPoints()
		scrollChild.scrollwork_topright:SetPoint("TOPRIGHT", 0, 0)
		scrollChild.scrollwork_bottomleft:SetParent(frameContent)
		scrollChild.scrollwork_bottomleft:ClearAllPoints()
		scrollChild.scrollwork_bottomleft:SetPoint("BOTTOMLEFT", 217, 8)
		scrollChild.scrollwork_bottomright:SetParent(frameContent)
		scrollChild.scrollwork_bottomright:ClearAllPoints()
		scrollChild.scrollwork_bottomright:SetPoint("BOTTOMRIGHT", 0, 8)
		scrollChild.gradient:SetParent(frameContent)
		scrollChild.gradient:SetPoint("TOPLEFT", 217-9, 0)
		scrollChild.gradient:SetPoint("BOTTOMRIGHT", "$parent", "TOPRIGHT", 0, -200)

		local index = 1
		while frameContent["specButton"..index] do
			frameContent["specButton"..index]:Hide()
			index = index + 1
		end

		-- initialize set tabs
		local dropDown = CreateFrame("Frame", "$parentAddFromPreset", frameContent, "UIDropDownMenuTemplate")
			  dropDown:Hide()
			  dropDown.displayMode = "MENU"
		local function DropDownAddSet(self)
			local preset = (self.value and self.value ~= "") and ns:GetPresets()[self.value] or nil
			local setCode = ns:AddSet(preset) -- [TODO] rewrite for set objects
			ns:CreateEquipmentSet(ns.db.profile.sets[setCode].name)
			ToggleDropDownMenu(nil, nil, dropDown)
			ui.Update()
		end
		dropDown.initialize = function(self, level)
			local info = UIDropDownMenu_CreateInfo()
			info.func = DropDownAddSet
			info.text = ns.locale.EmptySet
			info.value = ''
			UIDropDownMenu_AddButton(info, level)

			local presets = ns:GetPresets()
			for k, v in pairs(presets or {}) do
				info.text = v.name
				info.value = k
				UIDropDownMenu_AddButton(info, level)
			end
		end
		ui.UpdateSetTabs()

		-- initialize plugin config panels
		for _, plugin in pairs(ns.currentPlugins) do
			plugin:CreateConfigPanel(plugin.fullPanel)
		end

		ui.SetActivePanel(1)

		-- initialize calculate button
		local button = CreateFrame('Button', '$parentCalculateButton', frame, 'UIPanelButtonTemplate')
		button:SetText('Calculate')
		button:SetPoint('BOTTOM', sidebarFrame, 'BOTTOMLEFT', 108, 20)
		button:Show()
		button:SetWidth(100)

		button:SetScript('OnClick', function()
			if ns.isBlocked then
				ns:AbortCalculations()
			else
				ns:StartCalculations(not IsShiftKeyDown() and ns.selectedSet or nil)
			end
		end)

		local barScale = 180
		local progressBarBorder = CreateFrame('StatusBar', '$parentCalculationProgressBarFrame', frame)
		progressBarBorder:SetBackdrop({
			bgFile = 'Interface\\UnitPowerBarAlt\\MetalEternium_Horizontal_Frame',
			tile = false,
			insets = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0,
			},
		})
		progressBarBorder:SetSize(barScale, barScale / 4)
		progressBarBorder:SetPoint('BOTTOM', sidebarFrame, 'BOTTOMLEFT', 108, 10)
		progressBarBorder:Hide()
		local progressBar = CreateFrame('StatusBar', '$parentCalculationProgressBar', frame)
		progressBar:SetStatusBarTexture('Interface\\UnitPowerBarAlt\\Generic1_Horizontal_Fill')
		progressBar:SetStatusBarColor(0, 1, 0, 1)
		progressBar:SetMinMaxValues(0, 100)
		progressBar:SetPoint('CENTER', progressBarBorder, 'CENTER')
		progressBar:SetSize(barScale, barScale / 4)
		progressBar:SetMinMaxValues(-18, 118) -- compensates for texture borders so values from 0 to 100 look correct
		progressBar:Hide()

		-- progress text
		local progressText = progressBar:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		progressText:SetAllPoints()
		progressText:SetText("0.00%")
		progressBar.text = progressText

		-- initialize "unknown enhancements" warning
		local warning = CreateFrame('Button', nil, frame)
		warning:SetSize(32, 32)
		warning:SetNormalTexture('Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew')
		warning:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		warning:SetPoint('TOP', sidebarFrame, 'TOPLEFT', 60, -20)
		warning:SetHitRectInsets(0, -104, 0, 0)
		local warningText = warning:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		warningText:SetText(ns.locale.unknownEnhancementsNotification)
		warningText:SetPoint('TOPLEFT', warning, 'TOPRIGHT', 4, 0)
		warningText:SetSize(100, 32)
		warningText:SetWordWrap(true)
		warningText:SetJustifyV('MIDDLE')
		warningText:SetJustifyH('LEFT')
		frame.warning = warning

		warning:SetScript('OnEnter', function(frame)
			GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")

			GameTooltip:AddLine('Warning')
			for _, gem in pairs(ns.enhancementWarnings.gems) do
				GameTooltip:AddLine(ns.locale.unknownGemNotification:format(gem.itemLink))
			end
			for _, enchant in pairs(ns.enhancementWarnings.enchants) do
				GameTooltip:AddLine(ns.locale.unknownEnchantNotification:format(enchant.itemLink or enchant.itemID or ('enchant ID '..enchant.enchantID), enchant.hostItemLink))
			end

			GameTooltip:Show()
		end)
		warning:SetScript('OnLeave', ns.HideTooltip)

		--FIXME: readjust roleName until Spec is displayed below it
		frame.Inset.spellsScroll.child.roleName:ClearAllPoints()
		frame.Inset.spellsScroll.child.roleName:SetPoint("LEFT", frame.Inset.spellsScroll.child.roleIcon, "RIGHT", 3, 0)
	end

	-- toggle warning text if necessary
	frame.warning:SetShown(ns.enhancementWarnings.show)

	if frame:IsShown() then
		HideUIPanel(frame)
	else
		ShowUIPanel(frame)
	end
end
