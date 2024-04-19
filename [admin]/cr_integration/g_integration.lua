mysql = exports.cr_mysql

TESTER = 25
SCRIPTER = 32
LEADSCRIPTER = 79
COMMUNITYLEADER = 14
TRIALADMIN = 18
ADMIN = 17
SENIORADMIN = 64
LEADADMIN = 15
SUPPORTER = 30
VEHICLE_CONSULTATION_TEAM_LEADER = 39
VEHICLE_CONSULTATION_TEAM_MEMBER = 43
MAPPING_TEAM_LEADER = 44
MAPPING_TEAM_MEMBER = 28
STAFF_MEMBER = {32, 14, 18, 17, 64, 15, 30, 39, 43, 44, 28}
AUXILIARY_GROUPS = {32, 39, 43, 44, 28}
ADMIN_GROUPS = {14, 18, 17, 64, 15}

staffTitles = {
	[1] = {
		[0] = "Oyuncu",
		[1] = "Trial Admin",
		[2] = "Game Admin",
		[3] = "Senior Admin",
		[4] = "Lead Admin",
		[5] = "Head Admin",
		[6] = "Management",
		[7] = "Manager",
		[8] = "Community Manager",
		[9] = "Administrator",
		[10] = "Head Administrator",
		[11] = "Developer",
		[12] = "Director",
	},

	[2] = {
		[0] = "Oyuncu",
		[1] = "Helper",
		[2] = "Helper Manager",
	},

	[3] = {
		[0] = "Oyuncu",
		[1] = "VCT Member",
		[2] = "VCT Leader",
	},

	[4] = {
		[0] = "Oyuncu",
		[1] = "Script Tester",
		[2] = "Trial Scripter",
		[3] = "Crown Development",
	},

	[5] = {
		[0] = "Oyuncu",
		[1] = "Mapper",
		[2] = "Lead Mapper",
	}, 
}

function getStaffTitle(teamID, rankID) 
	return staffTitles[tonumber(teamID)][tonumber(rankID)]
end

function getStaffTitles()
	return staffTitles
end

--================================================================================================================

function isPlayerDirector(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 12)
end

function isPlayerDeveloper(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 11)
end

function isPlayerHeadAdministrator(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 10)
end

function isPlayerAdministrator(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 9)
end

function isPlayerCommunityManager(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 8)
end

function isPlayerManager(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 7)
end

function isPlayerManagement(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 6)
end

function isPlayerHeadAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 5)
end

function isPlayerLeadAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 4)
end

function isPlayerSeniorAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 3)
end

function isPlayerGameAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 2)
end

function isPlayerTrialAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local admin_level = getElementData(player, "admin_level") or 0
	return (admin_level >= 1)
end

--================================================================================================================

function isPlayerHelper(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 1)
end

function isPlayerHelperManager(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 2)
end

--================================================================================================================

function isPlayerTester(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 1)
end

function isPlayerScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 2)
end

function isPlayerLeadScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 3)
end

--================================================================================================================

function isPlayerVCTMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 1)
end

function isPlayerVehicleConsultant(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 2)
end

--================================================================================================================

function isPlayerMappingTeamLeader(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 2)
end

function isPlayerMappingTeamMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 1)
end

--================================================================================================================

function isPlayerStaff(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return isPlayerTrialAdmin(player) or isPlayerHelper(player) or isPlayerScripter(player) or isPlayerVCTMember(player) or isPlayerMappingTeamMember(player)
end

function isPlayerIA(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return false
end

--================================================================================================================

adminTitles = {
	[0] = "Oyuncu",
	[1] = "Trial Admin",
	[2] = "Game Admin",
	[3] = "Senior Admin",
	[4] = "Lead Admin",
	[5] = "Head Admin",
	[6] = "Management",
	[7] = "Manager",
	[8] = "Community Manager",
	[9] = "Administrator",
	[10] = "Head Administrator",
	[11] = "Developer",
	[12] = "Director",
}

function getAdminGroups()
	return { SUPPORTER, TRIALADMIN, ADMIN, SENIORADMIN, LEADADMIN }
end

function getAdminTitles()
	return adminTitles
end

function getHelperNumber()
	return SUPPORTER
end

function getAuxiliaryStaffNumbers()
	return table.concat(AUXILIARY_GROUPS, ",")
end

function getAdminStaffNumbers()
	return table.concat(ADMIN_GROUPS, ",")
end

function getAdminTitle(number)
	return adminTitles[number] or "Oyuncu"
end

--================================================================================================================

authorizedStaffs = {
	-- Sadece Administrator üzerine staffs yetkisi verilir.
	["Farid"] = true,
	["biax"] = true,
	["endirectTR"] = true,
	["yigi1doo"] = true,
	["PaLa"] = true,
	["ensar2861"] = true,
	["black"] = true,
}

function getAuthorizedStaffs()
	return authorizedStaffs
end