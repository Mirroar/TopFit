--[[

	Requires: LuaSocket, LuaJson, prtr-dump
	Run via: lua importer.lua

--]]

-- ordered by id as in http://www.wowhead.com/classes
local classes = {'WARRIOR', 'PALADIN', 'HUNTER', 'ROGUE', 'PRIEST', 'DEATHKNIGHT', 'SHAMAN', 'MAGE', 'WARLOCK', 'MONK', 'DRUID'}
local stats   = {
	["Strength"] = "ITEM_MOD_STRENGTH_SHORT",
	["Agility"] = "ITEM_MOD_AGILITY_SHORT",
	["Stamina"] = "ITEM_MOD_STAMINA_SHORT",
	["Intellect"] = "ITEM_MOD_INTELLECT_SHORT",
	["Spirit"] = "ITEM_MOD_SPIRIT_SHORT",

	-- TODO
	["MainHandDps"] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT", -- TOPFIT_ITEM_MOD_MAINHAND
	["OffHandDps"] = "ITEM_MOD_DAMAGE_PER_SECOND_SHORT", -- TOPFIT_ITEM_MOD_OFFHAND

	["CritRating"] = "ITEM_MOD_CRIT_RATING_SHORT",
	["HasteRating"] = "ITEM_MOD_HASTE_RATING_SHORT",
	["MasteryRating"] = "ITEM_MOD_MASTERY_RATING_SHORT",
	["ExpertiseRating"] = "ITEM_MOD_EXPERTISE_RATING_SHORT",
	["PhysicalHitRating"] = "ITEM_MOD_HIT_RATING_SHORT",
	["SpellHitRating"] = "ITEM_MOD_HIT_RATING_SHORT",

	["SpellPower"] = "ITEM_MOD_SPELL_POWER_SHORT",
	["AttackPower"] = "ITEM_MOD_ATTACK_POWER_SHORT",
	["Armor"] = "RESISTANCE0_NAME",
	["DodgeRating"] = "ITEM_MOD_DODGE_RATING_SHORT",
	["ParryRating"] = "ITEM_MOD_PARRY_RATING_SHORT",

	["ResilienceRating"] = "ITEM_MOD_RESILIENCE_RATING_SHORT",
	["PvpPower"] = "ITEM_MOD_PVP_POWER_SHORT",
}

local json = require("json.decode")
local url  = require("socket.url")
local http = require("socket.http")
local dump = require("dump")

-- TeamRobot.Wow.Version.getStrategyVersion()
local strategies = http.request('http://www.askmrrobot.com/wow/json/strategies/v56')
local parsed = json.decode(strategies)

local presets = {}
for playStyle, weightSets in pairs(parsed.Data) do
	local class = nil
	for _, className in ipairs(classes) do
		if playStyle:upper():match('^'..className) then
			class = className
			break
		end
	end

	if class then
		if not presets[class] then presets[class] = {} end
		local hasteInfo = nil

		for _, weightSet in pairs(weightSets) do
			local spec = (weightSet.SubSpec):sub(class:len() + 1)

			-- print(class, weightSet.Name, weightSet.Text)
			local weights = {
				name = spec .. weightSet.Name,
				desc = weightSet.Text,
				weights = {},
				caps = {}
			}

			for stat, weight in pairs(weightSet.Weights) do
				local globalString = stats[stat]
				if globalString then
					weights.weights[ globalString ] = weight
				else
					print('missing global string', stat)
				end
			end

			-- TODO: weightSet.SoftCappedWeights, weightSet.HardCaps

			if weightSet.HasteRating > 0 then
				weights.caps['ITEM_MOD_HASTE_RATING_SHORT'] = {
					value = weightSet.HasteRating,
					soft = false,
					active = true,
				}
			elseif weightSet.HasteRating == 0 and weightSet.HasteExtraTicks > 0 then
				if not hasteInfo then
					-- TeamRobot.Wow.Version.getHasteVersion()
					hasteInfo = http.request('http://www.askmrrobot.com/wow/json/haste/v5?subSpec=' .. (weightSet.SubSpec):lower())
					hasteInfo = json.decode(hasteInfo)
				end
				if hasteInfo and type(hasteInfo.Data) == "table" then
					for _, info in ipairs(hasteInfo.Data.Breakpoints) do
						-- FIXME: select proper entry
						if not info.IsTemporary and info.Duration == weightSet.HasteSpellDuration then
							weights.caps['ITEM_MOD_HASTE_RATING_SHORT'] = {
								value = info.Rating,
								soft = true,
								active = true,
								afterValue = weightSet.SoftCappedWeights['HasteRating'],
							}
							break
						end
					end
				else
					-- print('no data?', 'http://www.askmrrobot.com/wow/json/haste/v5?subSpec=' .. (weightSet.SubSpec):lower())
				end
			end

			table.insert(presets[class], weights)
		end
	end
end

-- print( dump.tostring(presets) )
dump.tofile(presets, 'presets.lua')

--[[

	* afterwards, fix strings: ^(\s*)([A-Z_0-9]+) => $1["$2"]

	* add wrapper:
local _, ns = ...

function ns:GetPresets(class)
	class = class or select(2, UnitClass("player"))
	return ns.presets[class]
end

ns.presets = { ... }

--]]
