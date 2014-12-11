local addonName, ns, _ = ...

local SetOptionsPlugin = ns.Plugin()
ns.SetOptionsPlugin = SetOptionsPlugin

local tekCheck = LibStub("tekKonfig-Checkbox")

--Possible Icons
--INV_Gizmo_Pipe_03
--INV_Misc_Wrench_01
--INV_Misc_Blizzcon09_GraphicsCard
--INV_Misc_EngGizmos_30
--INV_Misc_EngGizmos_37
--INV_Misc_EngGizmos_swissArmy
--INV_Misc_Gear_01 - 08

-- creates a new SetOptionsPlugin object
function SetOptionsPlugin:Initialize()
	self:SetName(ns.locale.OptionsPanelTitle)
	self:SetTooltipText(ns.locale.OptionsPanelTooltip)
	self:SetButtonTexture("Interface\\Icons\\INV_Misc_EngGizmos_swissArmy")
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
				button:SetPoint("TOPLEFT", frame, 0, 0)
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
	local frame = self:GetConfigPanel()
	local set = ns.GetSetByID(ns.selectedSet, true)

	local index, func = 1, nil
	while frame["exposedSetting"..index] do
		func = frame["exposedSetting"..index].updateHandler
		if func and set[func] then
			frame["exposedSetting"..index]:SetChecked(set[func](set))
		end
		index = index + 1
	end
end
