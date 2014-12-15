local addonName, ns = ...

local defaultOptions = {
	showComparisonTooltip = true,
	minimapIcon = {},
}

local updateHandlers = {}
local currentVersion = nil -- default version, gets incremented by adding update handlers

local function InitializeDB()
	-- TODO: replace with self.db = LibStub('AceDB-3.0'):New(addonName..'DB', defaults, nil)
	local profileName = GetUnitName('player')..' - '..GetRealmName('player')
	local selectedProfile = profileName
	if TopFitDB then
		selectedProfile = TopFitDB.profileKeys[profileName]
		if not selectedProfile then
			-- initialize profile for this character
			TopFitDB.profileKeys[profileName] = profileName
			TopFitDB.profiles[profileName] = defaultOptions
			selectedProfile = profileName
		end
	else
		-- initialize saved variables
		TopFitDB = {
			version = currentVersion,
			profileKeys = {
				[profileName] = profileName
			},
			profiles = {
				[profileName] = defaultOptions
			}
		}
	end
	ns.db = {profile = TopFitDB.profiles[selectedProfile]}

	-- make sure a sets container exists even if there are no sets
	if not ns.db.profile.sets then ns.db.profile.sets = {} end
end

local function UpdateDB()
	-- check the current addOn version against the version number in the database and run appropriate update handlers
	for _, update in ipairs(updateHandlers) do
		if not TopFitDB.version or TopFitDB.version < update.version then
			if update.handler then
				update.handler()
			end

			TopFitDB.version = update.version
		end
	end
end

local function AddUpdateHandler(versionNumber, handler)
	assert(versionNumber and (not currentVersion or versionNumber > currentVersion), "AddUpdateHandler: Update version number must be greater than previous version.")

	tinsert(updateHandlers, {
		version = versionNumber,
		handler = handler,
	})
	currentVersion = versionNumber
end

AddUpdateHandler(600, function()
	-- updating from a pre-6.0v1-version
	-- wipe all sets because of incompatibility and major stat changes
	for _, profile in pairs(TopFitDB.profiles) do
		profile.sets = nil
		profile.defaultUpdateSet = nil
		profile.defaultUpdateSet2 = nil
	end
end)

AddUpdateHandler(601, function()
	-- 6.0v3 adds setting for minimap button
	for _, profile in pairs(TopFitDB.profiles) do
		profile.minimapIcon = {}
	end
end)

AddUpdateHandler(602, function()
	-- 6.0v4 moves settings for auto-equip and auto-update into sets themselves
	for _, profile in pairs(TopFitDB.profiles) do
		for specIndex, savedVar in ipairs({'defaultUpdateSet', 'defaultUpdateSet2'}) do
			if profile[savedVar] then
				local set = ns.GetSetByID(profile[savedVar])
				if set then
					set:SetAutoUpdate(true)
					if not profile.preventAutoUpdateOnRespec then
						set:SetAutoEquip(true)
					end

					-- also set associated spec if the set has none assigned yet
					if not set:GetAssociatedSpec() then
						local specID = GetSpecializationInfo(GetSpecialization(nil, nil, specIndex) or 0)
						set:SetAssociatedSpec(specID)
					end
				end
			end
		end
		profile.defaultUpdateSet = nil
		profile.defaultUpdateSet2 = nil
		profile.preventAutoUpdateOnRespec = nil
	end
end)

function ns:PrepareDatabase()
	InitializeDB()
	UpdateDB()
end
