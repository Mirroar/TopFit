local addonName, ns, _ = ...

function ns:PlayerCanDualWield()
	local _, playerClass = UnitClass('player')
	local specID = GetSpecializationInfo(GetSpecialization() or 0)
	local canDualWield =
		   playerClass == 'DEATHKNIGHT'
		or playerClass == 'ROGUE'
		or specID == 72  -- fury warrior
		or specID == 263 -- enhancement shaman
		or specID == 268 or specID == 269 -- brewmaster/windwalker monk

	return canDualWield
end

function ns:PlayerHasTitansGrip()
	return IsSpellKnown(46917)
end

function ns:GetLinkID(link)
	if not link or type(link) ~= "string" then return end
	local linkType, id = link:match("\124H([^:]+):([^:\124]+)")
	if not linkType then
		linkType, id = link:match("([^:\124]+):([^:\124]+)")
	end
	return tonumber(id), linkType
end
