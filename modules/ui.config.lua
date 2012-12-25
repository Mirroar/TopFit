local addonName, ns, _ = ...
ns.ui = ns.ui or {}
local ui = ns.ui

-- GLOBALS: NORMAL_FONT_COLOR, _G, UIParent, GameTooltip
-- GLOBALS: PlaySound, CreateFrame, ShowUIPanel, HideUIPanel, SetPortraitToTexture, GetTexCoordsForRole, ButtonFrameTemplate_HideAttic

local function ButtonOnClick(self) -- [TODO]
	PlaySound("igMainMenuOptionCheckBoxOn")
	ui.SetSidebarButtonState(self, not self.selected)
	-- self:GetParent().spellsScroll.ScrollBar:SetValue(0)
	GameTooltip:Hide()
end
local function ButtonOnEnter(self)
	if not self.selected then
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(self.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		GameTooltip:Show()
	end
end
local function ButtonOnLeave(self)
	GameTooltip:Hide()
end
function ui.GetSidebarButton(index)
	local frame = _G["TopFitConfigFrameSpecialization"]
	assert(frame, "TopFitConfigFrame has not been initialized properly.")

	local button = _G[frame:GetName() .. "SpecButton" .. index]
		or CreateFrame("Button", "$parentSpecButton"..index, frame, "PlayerSpecButtonTemplate")
	button:SetID(index)
	button:Show()

	button:ClearAllPoints()
	if index == 1 then
		button:SetPoint("TOPLEFT", 6, -56)
	else
		button:SetPoint("TOP", "$parentSpecButton"..(index-1), "BOTTOM", 0, -10)
	end

	button:SetScript("OnClick", ButtonOnClick)
	button:SetScript("OnEnter", ButtonOnEnter)
	button:SetScript("OnLeave", ButtonOnLeave)
	button.roleIcon:Hide()
	button.roleName:Hide()
	button.ring:SetTexture("Interface\\TalentFrame\\spec-filagree") 			-- Interface\\TalentFrame\\talent-main
	button.ring:SetTexCoord(0.00390625, 0.27734375, 0.48437500, 0.75781250) 	-- 0.50000000, 0.91796875, 0.00195313, 0.21093750
	button.specIcon:SetSize(100-14, 100-14) 									-- 100/66 (filagree is 70/56)

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
function ui.SetSidebarButtonData(button, texture, name, tooltip, role)
	SetPortraitToTexture(button.specIcon, texture)
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
function ui.ToggleTopFitConfigFrame()
	local frame = _G["TopFitConfigFrame"]
	if not frame then
		frame = CreateFrame("Frame", "TopFitConfigFrame", UIParent, "ButtonFrameTemplate")
		frame:SetSize(646, 468)

		frame:SetAttribute("UIPanelLayout-defined", true)
		frame:SetAttribute("UIPanelLayout-enabled", true)
		frame:SetAttribute("UIPanelLayout-whileDead", true)
		frame:SetAttribute("UIPanelLayout-area", "left")
		frame:SetAttribute("UIPanelLayout-pushable", 5) 	-- when competing for space, lower numbers get closed first
		frame:SetAttribute("UIPanelLayout-width", 666) 		-- width + 20
		frame:SetAttribute("UIPanelLayout-height", 488) 	-- height + 20

		-- when changing panel size, also adjust:
		-- 		frame:SetSize(550, 468)
		-- 		TestFrameInsetSpecialization.bg:SetWidth(646-217)
		-- 		TestFrameInsetSpecializationSpellScrollFrame:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", 0, 0)
		-- 		TestFrameInsetSpecializationSpellScrollFrameScrollChild:SetAllPoints()

		ButtonFrameTemplate_HideAttic(frame)
		SetPortraitToTexture(frame:GetName().."Portrait", "Interface\\Icons\\Achievement_BG_trueAVshutout")
		frame.TitleText:SetText("TopFit")

		local frameContent = CreateFrame("Frame", frame:GetName().."Specialization", frame.Inset, "SpecializationFrameTemplate")
		frameContent:ClearAllPoints()
		frameContent:SetAllPoints()
		frameContent:SetFrameLevel(0) -- put below parent
		frameContent:SetFrameLevel(1) -- and then raise again!

		frameContent.MainHelpButton:Hide()
		frameContent.learnButton:Hide()

		-- example code
		for i = 1, 6 do
			local btn = ui.GetSidebarButton(i)
			ui.SetSidebarButtonData(btn, "Interface\\Icons\\Achievement_BG_trueAVshutout", "SpecButton"..i, "TestButton"..i) -- "DAMAGER")
			ui.SetSidebarButtonHeight(btn, 40)
			ui.SetSidebarButtonState(btn, i==1)
		end

		frame:Hide()
	end

	if frame:IsShown() then
		HideUIPanel(frame)
	else
		ShowUIPanel(frame)
	end
end
