local addonName, ns, _ = ...

local SetOptionsPlugin = ns.Plugin()
ns.SetOptionsPlugin = SetOptionsPlugin

local tekCheck = LibStub("tekKonfig-Checkbox")

-- creates a new SetOptionsPlugin object
function SetOptionsPlugin:Initialize()
	self:SetName(TopFit.locale.StatsPanelLabel)
	self:SetTooltipText(TopFit.locale.StatsTooltip)
	self:SetButtonTexture("Interface\\Icons\\Ability_Druid_BalanceofPower")
	self:RegisterConfigPanel()
end

local exposedSettings = {
	-- label, tooltip, set:get_handler, set:set_handler, shown_func
	{
		ns.locale.StatsShowTooltip, ns.locale.StatsShowTooltipTooltip,
		"GetDisplayInTooltip", "SetDisplayInTooltip"
	},
	{
		ns.locale.StatsForceArmorType, ns.locale.StatsForceArmorTypeTooltip,
		"GetForceArmorType", "SetForceArmorType", function(playerClass)
			return playerClass ~= "PRIEST" and playerClass ~= "WARLOCK" and playerClass ~= "MAGE"
		end
	},
	--[[{
		"Enable hit conversion", "Check to enable spirit to hit conversion, even if it does not apply to your current spec",
		"GetHitConversion", "SetHitConversion", function(playerClass)
			return playerClass == "DRUID" or playerClass == "MONK" or playerClass == "PALADIN" or playerClass == "PRIEST" or playerClass == "SHAMAN"
		end
	},--]]
	{
		ns.locale.StatsEnableDualWield, ns.locale.StatsEnableDualWieldTooltip,
		"IsDualWieldForced", "ForceDualWield", function(playerClass)
			return playerClass == "SHAMAN" or playerClass == "WARRIOR" or playerClass == "MONK"
		end
	},
	{
		ns.locale.StatsEnableTitansGrip, ns.locale.StatsEnableTitansGripTooltip,
		"IsTitansGripForced", "ForceTitansGrip", function(playerClass)
			return playerClass == "WARRIOR"
		end
	},
}

function SetOptionsPlugin:InitializeExposedSettings()
	local frame = self:GetConfigPanel()
	local _, playerClass = UnitClass("player")

	local button, buttonLabel, positionIndex, clickSound
	for i, setting in ipairs(exposedSettings) do
		local label, tooltip, getFunc, setFunc, showFunc = setting[1], setting[2], setting[3], setting[4], setting[5]
		if not showFunc or showFunc(playerClass) then
			button, buttonLabel = tekCheck.new(frame, nil, label or "") -- nil = use default size
			button.tiptext = tooltip

			positionIndex = (positionIndex or 0) + 1
			frame["exposedSetting"..positionIndex] = button

			if positionIndex == 1 then
				button:SetPoint("TOPLEFT", _G[frame:GetParent():GetName().."Description"], 0, 6)
			elseif positionIndex == 3 then
				-- first box in second column
				button:SetPoint("TOPLEFT", frame["exposedSetting1"], 190, 0)
			else
				button:SetPoint("TOPLEFT", frame["exposedSetting"..(positionIndex - 1)], "BOTTOMLEFT", 0, 4)
			end

			clickSound = clickSound or button:GetScript("OnClick")
			button.updateHandler = getFunc
			button:SetScript("OnClick", function(self)
				clickSound(self)
				local set = ns.GetSetByID(ns.selectedSet, true)
				set[setFunc](set, self:GetChecked())
			end)
		end
	end
end

function SetOptionsPlugin:InitializeUI()
	self:InitializeExposedSettings()
end

function SetOptionsPlugin:OnShow()
	local panel = self:GetConfigPanel()
	local set = ns.GetSetByID(ns.selectedSet, true)

	local index, func = 1, nil
	while panel["exposedSetting"..index] do
		func = panel["exposedSetting"..index].updateHandler
		if func and set[func] then
			panel["exposedSetting"..index]:SetChecked(set[func](set))
		end
		index = index + 1
	end
end
