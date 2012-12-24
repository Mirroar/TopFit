local addonName, ns, _ = ...
ns.ui = ns.ui or {}
local ui = ns.ui

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
function ui.GetSidebarButton(index, z)
	-- [TODO] define z
	local button = _G[z:GetName() .. "SpecButton" .. index] or CreateFrame("Button", "$parentSpecButton"..index, z, "PlayerSpecButtonTemplate")
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
	button.ring:SetPoint("LEFT", "$parent", "LEFT", 4, -1)
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

local fName = "TopFitConfigFrame"
local f = _G[fName]
if not f then
	f = CreateFrame("Frame", fName, UIParent, "ButtonFrameTemplate")
	ButtonFrameTemplate_HideAttic(f)
	f:SetSize(646, 468)

	-- when changing panel size, also adjust:
	-- 		f:SetSize(550, 468)
	-- 		TestFrameInsetSpecialization.bg:SetWidth(646-217)
	-- 		TestFrameInsetSpecializationSpellScrollFrame:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", 0, 0)
	-- 		TestFrameInsetSpecializationSpellScrollFrameScrollChild:SetAllPoints()

	SetPortraitToTexture(f:GetName().."Portrait", "Interface\\Icons\\Achievement_BG_trueAVshutout")
	f.TitleText:SetText("TopFit")

	UIPanelWindows[fName] = { area = "left", pushable = 3, whileDead = 1, width = 666, height = 488 }
	table.insert(UISpecialFrames, f:GetName())

	local z = CreateFrame("Frame", f:GetName().."Specialization", f.Inset, "SpecializationFrameTemplate")
	z:ClearAllPoints()
	z:SetAllPoints()
	z:SetFrameLevel(0) -- put below parent
	z:SetFrameLevel(1) -- and then raise again!

	z.MainHelpButton:Hide()
	z.learnButton:Hide()
	z.MainHelpButton = nil
	z.learnButton = nil

	for i = 1, 6 do
		local btn = ui.GetSidebarButton(i, z)
		ui.SetSidebarButtonData(btn, "Interface\\Icons\\Achievement_BG_trueAVshutout", "SpecButton"..i, "TestButton"..i) -- "DAMAGER")
		ui.SetSidebarButtonHeight(btn, 40)
		ui.SetSidebarButtonState(btn, i==1)
	end
end
