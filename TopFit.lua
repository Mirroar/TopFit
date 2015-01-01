local addonName, ns = ...
LibStub('AceAddon-3.0'):NewAddon(ns, addonName, 'AceEvent-3.0')

-- create global Addon object
_G[addonName] = ns

-- TODO: this should not be
-- GLOBALS: TopFit, TopFitDB

-- GLOBALS: _G, LibStub, C_Timer, SLASH_TopFit1, SLASH_TopFit2, SLASH_TopFit3, GameTooltip, DEFAULT_CHAT_FRAME, UIParent, NUM_BAG_SLOTS, InterfaceOptionsFrame_OpenToCategory, CreateFrame, ToggleFrame
-- GLOBALS: TOPFIT_ARMORTYPE_CLOTH, TOPFIT_ARMORTYPE_LEATHER, TOPFIT_ARMORTYPE_MAIL, TOPFIT_ARMORTYPE_PLATE, TOPFIT_ITEM_MOD_MAINHAND, TOPFIT_ITEM_MOD_OFFHAND
-- GLOBALS: GetEquipmentSetInfoByName, SaveEquipmentSet, GetRealmName, GetActiveSpecGroup, GetSpecializationInfo, GetAuctionItemSubClasses, CanUseEquipmentSets, UseEquipmentSet, IsEquippableItem, GetContainerNumSlots, GetContainerItemLink, GetInventoryItemLink, GetInventorySlotInfo
-- GLOBALS: setmetatable, getmetatable, type, pairs, assert, error, wipe, tinsert, next, select, tonumber, tContains

--TODO: replace old ugly set_i set IDs with simple numbers - in profile.sets

function ns:GenerateSetName(name) --TODO: ideally move this function into set class
	-- using substr because blizzard interface only allows 16 characters
	-- although technically SaveEquipmentSet & co allow more
	return (((name ~= nil) and (name.." "):sub(1, 12).."(TF)") or "TopFit") --TODO: clean up
end

function TopFit.ChatCommand(input)
	if not input or input:trim() == "" or input:trim():lower() == "show" then
		ns.ui.ToggleTopFitConfigFrame()
	elseif input:trim():lower() == "options" or input:trim():lower() == "conf" or input:trim():lower() == "config" then
		InterfaceOptionsFrame_OpenToCategory(addonName)
		InterfaceOptionsFrame_OpenToCategory(addonName)
	else
		TopFit:Print(TopFit.locale.SlashHelp)
	end
end
SLASH_TopFit1 = "/topfit"
SLASH_TopFit2 = "/tf"
SLASH_TopFit3 = "/fit"
SlashCmdList["TopFit"] = TopFit.ChatCommand

function ns:OnEnable()
	ns:PrepareDatabase()

	-- load Unfit-1.0
	ns.Unfit = LibStub('Unfit-1.0')

	-- create gametooltip for scanning
	ns.scanTooltip = CreateFrame('GameTooltip', addonName..'ScanTooltip', UIParent, 'GameTooltipTemplate')

	-- launcher ldb
	local ldb = LibStub('LibDataBroker-1.1'):NewDataObject(addonName, {
		type  = 'launcher',
		icon  = 'Interface\\Icons\\Achievement_BG_trueAVshutout',
		label = addonName,

		OnClick = function(button, btn, up)
			if btn == 'RightButton' then
				InterfaceOptionsFrame_OpenToCategory(addonName)
				InterfaceOptionsFrame_OpenToCategory(addonName)
			else
				ns.ui.ToggleTopFitConfigFrame()
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(addonName)
			local c = GRAY_FONT_COLOR
			tooltip:AddLine(ns.locale.OpenSetConfigTooltip, c.r, c.g, c.b)
			tooltip:AddLine(ns.locale.OpenAddonConfigTooltip, c.r, c.g, c.b)
		end
	})
	ns.minimapIcon = LibStub('LibDBIcon-1.0')
	ns.minimapIcon:Register(addonName, ldb, self.db.profile.minimapIcon)

	-- select current auto-update set by default
	ns:SetSelectedSet()

	-- create frame for OnUpdate
	ns.updateFrame = CreateFrame("Frame")

	-- create options
	ns:createOptions()

	-- cache tables
	ns.itemsCache = {}
	ns.scoresCache = {}

	-- table for equippable item list
	ns.equippableItems = {}

	-- register needed events
	ns:RegisterEvent('PLAYER_LEVEL_UP')
	ns:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	ns:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
	ns:RegisterEvent('BAG_UPDATE')
	ns:RegisterEvent('BAG_UPDATE_DELAYED')
	-- self:RegisterEvent('PLAYER_TALENT_UPDATE') -- TODO: currently unused
	-- wait 50ms until we do our first calculation
	C_Timer.After(0.05, function()
		ns:updateItemsCache()
		ns:collectEquippableItems()

		ns.CheckInventoryItems()
		ns.CheckBagItems()

		ns.canAutoCalculate = true
	end)

	-- container for plugin information and frames
	ns.plugins = {}

	-- initialize delete set popup
	StaticPopupDialogs["TOPFIT_DELETESET"] = {
		text = CONFIRM_DELETE_EQUIPMENT_SET,
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function(self)
			ns:DeleteSet(ns.currentlyDeletingSetID)
			ns:SetSelectedSet()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	}

	-- we're done initializing
	ns.initialized = true

	-- initialize all registered plugins
	if not ns.currentPlugins then ns.currentPlugins = {} end
	for _, plugin in pairs(ns.currentPlugins) do
		plugin:Initialize()
	end

	-- if enabled, automatically run tests
	if ns.db.profile.autoRunTests and ns.testsLoaded then
		wowUnit:StartTests(ns)
	end
end

function ns.IsInitialized()
	return ns.initialized
end

local newItems = {}
function ns:collectEquippableItems(bagID) --TODO: rename into something more fitting
	wipe(newItems)
	-- check bags
	for bag = 0, NUM_BAG_SLOTS do
		if not bagID or bag == bagID then
			for slot = 1, GetContainerNumSlots(bag) do
				local itemLink = GetContainerItemLink(bag, slot)
				if itemLink and not tContains(ns.equippableItems, itemLink) then
					if IsEquippableItem(itemLink) and not ns.Unfit:IsItemUnusable(itemLink) and ns:CanUseItemBinding(bag, slot) then
						tinsert(ns.equippableItems, itemLink)
						tinsert(newItems, {
							itemLink = itemLink,
							bag = bag,
							slot = slot,
						})
					end
				end
			end
		end
	end

	-- check equipment (mostly so your set doesn't get recalculated just because you unequip an item)
	for _, invSlot in pairs(ns.slots) do
		local itemLink = GetInventoryItemLink('player', invSlot)
		if itemLink and not tContains(ns.equippableItems, itemLink) and IsEquippableItem(itemLink) and not ns.Unfit:IsItemUnusable(itemLink) then
			tinsert(ns.equippableItems, itemLink)
			tinsert(newItems, {
				itemLink = itemLink,
				slot = invSlot,
			})
		end
	end

	return #newItems > 0 and newItems or false
end

local function EvaluateNewItems(newItems)
	local set = ns.GetCurrentAutoUpdateSet()
	if not set then return end

	-- new equippable item in inventory, check if it is actually better than anything currently available
	for _, newItem in pairs(newItems) do
		ns:Debug("New Item: "..newItem.itemLink)
		local itemTable = ns:GetCachedItem(newItem.itemLink)
		for _, slotID in pairs(itemTable.equipLocationsByType) do
			-- try to get the currently used item from the player's equipment set
			local setItem = ns:GetSetItemFromSlot(slotID, set)
			local setItemTable = ns:GetCachedItem(setItem)
			if setItem and setItemTable then
				-- if either score or any cap is higher than currently equipped, calculate
				if set:GetItemScore(newItem.itemLink) > set:GetItemScore(setItem) then
					ns:Debug('Higher Score!')
					ns:RunAutoUpdate(true)
					return
				else
					-- check caps
					for stat, cap in pairs(set:GetHardCaps()) do
						if (itemTable.totalBonus[stat] or 0) > (setItemTable.totalBonus[stat] or 0) then
							ns:Debug('Higher Cap!')
							ns:RunAutoUpdate(true)
							return
						end
					end
				end
			else
				-- no item found in set, good reason to upgrade!
				TopFit:Debug('No Item in base set found!')
				TopFit:RunAutoUpdate(true)
				return
			end
		end
	end
end

function ns:PLAYER_EQUIPMENT_CHANGED(event, ...)
	ns.CheckInventoryItems(...)
end

function ns:BAG_UPDATE(event, ...)
	print(event, ...)
	ns.CheckBagItems(...)
end

function ns:BAG_UPDATE_DELAYED(event, ...)
	if not ns.canAutoCalculate then return end
	-- update item list
	ns:updateItemsCache()

	-- check inventory for new equippable items
	local newEquip = ns:collectEquippableItems()
	if newEquip then
		EvaluateNewItems(newEquip)
	end
end

function ns:PLAYER_LEVEL_UP(event, ...)
	--[[ remove cache info for heirlooms so they are rescanned
	for itemLink, itemTable in pairs(ns.itemsCache) do
		if itemTable.itemQuality == 7 then
			ns.itemsCache[itemLink] = nil
			ns.scoresCache[itemLink] = nil
		end
	end--]]

	-- if an auto-update-set is set, update that as well
	ns:ClearCache()
	ns:RunAutoUpdate()
end

function ns:ACTIVE_TALENT_GROUP_CHANGED(event, ...)
	ns:ClearCache()
	ns:AutoEquipSet()
end

function ns:RunAutoUpdate(skipDelay)
	local set = ns.GetCurrentAutoUpdateSet(true)
	if not set then return end

	ns.workSetList = ns.workSetList or {}
	tinsert(ns.workSetList, set)
	if not ns.autoUpdateTimerFrame then
		ns.autoUpdateTimerFrame = CreateFrame("Frame")
	end
	-- because right on level up there seem to be problems finding the items for equipping, delay the actual update
	if not skipDelay then
		ns.delayCalculation = 0.5 -- delay in seconds until update
	else
		ns.delayCalculation = 0
	end
	ns.autoUpdateTimerFrame:SetScript("OnUpdate", function(self, delay)
		if (ns.delayCalculation > 0) then
			ns.delayCalculation = ns.delayCalculation - delay
		else
			ns.autoUpdateTimerFrame:SetScript("OnUpdate", nil)
			ns:CalculateSets(true) -- calculate silently
		end
	end)
end

function ns:AutoEquipSet()
	local set, setID = ns.GetCurrentAutoEquipSet()
	if setID then
		ns:SetSelectedSet(setID)
		local equipSet = set:GetEquipmentSetName()
		UseEquipmentSet(equipSet)
	end
end

function ns:CreateEquipmentManagerSet(set)
	if (CanUseEquipmentSets()) then
		local setName = ns:GenerateSetName(set:GetName())
		local texture = set:GetIconTexture():gsub("Interface\\Icons\\", "")

		ns:Debug("Trying to create set: "..setName..", "..(texture or "nil"))
		SaveEquipmentSet(setName, texture)
	end
end

-----------------------------------------------------
-- database access functions
-----------------------------------------------------
function ns:SetSelectedSet(setID)
	-- select current auto-equip set by default
	if not setID then
		local set, setCode = ns.GetCurrentAutoEquipSet(true)
		if setCode then
			setID = setCode
		end
	end

	if not setID then
		-- if still no set is selected, select first available set instead
		for _, id in pairs(ns.GetSetList()) do
			setID = id
			break
		end
	end

	ns.selectedSet = setID
	if TopFitSetDropDown then
		UIDropDownMenu_SetSelectedValue(TopFitSetDropDown, ns.selectedSet)
		if ns.selectedSet then
			local set = ns.GetSetByID(ns.selectedSet, true)
			UIDropDownMenu_SetText(TopFitSetDropDown, set:GetName())
		else
			UIDropDownMenu_SetText(TopFitSetDropDown, ns.locale.NoSetTitle)
		end
	end
	if TopFitSidebarCalculateButton then
		if not setID then
			TopFitSidebarCalculateButton:Disable()
		else
			TopFitSidebarCalculateButton:Enable()
		end
	end

	ns.ui.Update(true)
end

-- get a list of all set IDs in the database
function ns.GetSetList(useTable)
	local setList = useTable and wipe(useTable) or {}
	for setID, _ in pairs(ns.db.profile.sets) do
		tinsert(setList, setID)
	end
	return setList
end

ns.setObjectCache = {}

-- get a set object from the database
function ns.GetSetByID(setID, useGlobalInstance)
	assert(setID and type(ns.db.profile.sets[setID]) ~= "nil", "GetSetByID: invalid set ID given")

	if not useGlobalInstance then
		return ns.Set.CreateFromSavedVariables(ns.db.profile.sets[setID])
	else
		if not ns.setObjectCache[setID] then
			ns.setObjectCache[setID] = ns.Set.CreateFromSavedVariables(ns.db.profile.sets[setID], true)
		end

		return ns.setObjectCache[setID]
	end
end

-- get the current auto-update-set
function ns.GetCurrentAutoUpdateSet(useGlobalInstance)
	local currentSpec = GetSpecializationInfo(GetSpecialization() or 0)
	local doubleSpecID = ns:GetPlayerDoubleSpec()
	for _, setID in pairs(ns.GetSetList()) do
		local set = ns.GetSetByID(setID, true) -- use global instances while searching because it's faster than creating new set objects

		if (not currentSpec or set:GetAssociatedSpec() == currentSpec) and set:GetAutoUpdate() then
			-- deal with having the same spec twice
			local preferredSpecNum = set:GetPreferredSpecNumber()
			if (not doubleSpecID or currentSpec == doubleSpecID) and (not preferredSpecNum or preferredSpecNum == GetSpecialization()) then
				if useGlobalInstance then
					return set, setID
				else
					return ns.GetSetByID(setID, false), setID
				end
			end
		end
	end
end

-- get the current auto-update-set
--TODO: merge this and the above function
function ns.GetCurrentAutoEquipSet(useGlobalInstance)
	local currentSpec = GetSpecializationInfo(GetSpecialization() or 0)
	local doubleSpecID = ns:GetPlayerDoubleSpec()
	for _, setID in pairs(ns.GetSetList()) do
		local set = ns.GetSetByID(setID, true) -- use global instances while searching because it's faster than creating new set objects

		if (not currentSpec or set:GetAssociatedSpec() == currentSpec) and set:GetAutoEquip() then
			-- deal with having the same spec twice
			local preferredSpecNum = set:GetPreferredSpecNumber()
			if (not doubleSpecID or currentSpec == doubleSpecID) and (not preferredSpecNum or preferredSpecNum == GetSpecialization()) then
				if useGlobalInstance then
					return set, setID
				else
					return ns.GetSetByID(setID, false), setID
				end
			end
		end
	end
end

-----------------------------------------------------
-- hook system
-----------------------------------------------------

-- invoke a hook for all currently registered plugins
function ns.InvokeAll(hookName, ...)
	local results = {}
	for _, plugin in pairs(ns.currentPlugins) do
		if plugin[hookName] and type(plugin[hookName] == 'function') then
			local result = {plugin[hookName](...)} -- call function, pack results into a table and save for returning
			tinsert(results, result)
		end
	end
	return results
end
