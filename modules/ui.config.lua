local addonName, ns, _ = ...

--[[
local f = _G["TestFrame"] or CreateFrame("Frame", "TestFrame", UIParent, "ButtonFrameTemplate") -- SpecializationFrameTemplate
f:SetSize(646, 468)

SetPortraitToTexture(f:GetName().."Portrait", "Interface\\Icons\\Achievement_BG_trueAVshutout")

UIPanelWindows["TestFrame"] = { area = "left", pushable = 1, whileDead = 1, width = 666, height = 488 }
table.insert(UISpecialFrames, f:GetName())
ShowUIPanel(f) --]]


local fName = "TestFrame"
local f = _G[fName]
if not f then
	f = CreateFrame("Frame", fName, UIParent, "ButtonFrameTemplate") -- SpecializationFrameTemplate
	f:SetSize(646, 468)

	SetPortraitToTexture(f:GetName().."Portrait", "Interface\\Icons\\Achievement_BG_trueAVshutout")

	UIPanelWindows[fName] = { area = "left", pushable = 1, whileDead = 1, width = 666, height = 488 }
	table.insert(UISpecialFrames, f:GetName())
end
ShowUIPanel(f)
