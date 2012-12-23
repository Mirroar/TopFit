local addonName, ns, _ = ...

local fName = "TestFrame"
local f = _G[fName]
if not f then
	f = CreateFrame("Frame", fName, UIParent, "ButtonFrameTemplate") -- PortraitFrameTemplate SpecializationFrameTemplate
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

	local z = CreateFrame("Frame", "$parentSpecialization", f.Inset, "SpecializationFrameTemplate")
	z:ClearAllPoints()
	z:SetAllPoints()
	z:SetFrameLevel(0) -- put below parent
	z:SetFrameLevel(1) -- and then raise again!

	z.MainHelpButton:Hide()
	z.learnButton:Hide()
	z.MainHelpButton = nil
	z.learnButton = nil


	local function ButtonOnClick(self) -- [TODO]
		PlaySound("igMainMenuOptionCheckBoxOn")
		-- self:GetParent().spellsScroll.ScrollBar:SetValue(0)
		GameTooltip:Hide()
	end
	local function ButtonOnEnter(self)
		if not self.selected then
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:AddLine(self.tooltip, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
			-- if self.displayTrainerTooltip and not self:GetParent().isPet then
			-- 	GameTooltip:AddLine(TALENT_SPEC_CHANGE_AT_CLASS_TRAINER, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
			-- end
			-- GameTooltip:SetMinimumWidth(300, true)
			GameTooltip:Show()
		end
	end
	local function ButtonOnLeave(self)
		-- GameTooltip:SetMinimumWidth(0, 0)
		GameTooltip:Hide()
	end
	for i = 1, 5 do
		local btn = _G[z:GetName() .. "SpecButton" .. i] or CreateFrame("Button", "$parentSpecButton"..i, z, "PlayerSpecButtonTemplate")
		btn:SetScript("OnClick", ButtonOnClick)
		btn:SetScript("OnEnter", ButtonOnEnter)
		btn:SetScript("OnLeave", ButtonOnLeave)
		btn:SetID(i)
		btn:Show()

		SetPortraitToTexture(btn.specIcon, "Interface\\Icons\\Achievement_BG_trueAVshutout")
		btn.tooltip = "TestButton"..i
		btn.specName:SetText("SpecButton"..i)
    	btn.roleIcon:SetTexCoord(GetTexCoordsForRole("DAMAGER"))
    	btn.roleName:SetText(_G["DAMAGER"])

		-- when changing height (default: 60 frame/80 borders):
		-- 		:SetHeight(30)
		-- 		.bg:SetHeight(50)
		-- 		.selectedTex:SetHeight(50)
		-- 		:GetHighlightTexture():SetHeight(50)
		-- 		.Glow:SetHeight(30+8)

		-- ring icon (default: 100)
		-- 		.ring:SetSize(50, 50)
		-- 		.ring:SetPoint("LEFT", "$parent", "LEFT", -6, -1)

		btn:ClearAllPoints()
		if i == 1 then
			btn:SetPoint("TOPLEFT", 6, -56)

			btn.selected = true
      		btn.selectedTex:Show()
      		btn.learnedTex:Show()
		else
			btn:SetPoint("TOP", "$parentSpecButton"..(i-1), "BOTTOM", 0, -10)
		end
	end
end
-- /run ShowUIPanel(TestFrame)

-- 188.192.49.81:9987 / egal
