function getAdminTitles()
	return exports.cr_integration:getAdminTitles()
end

function getAdmins()
	local players = exports.cr_pool:getPoolElementsByType("player")

	local admins = { }

	for key, value in ipairs(players) do
		if exports.cr_integration:isPlayerTrialAdmin(value) then
			table.insert(admins,value)
		end
	end
	return admins
end

function getPlayerAdminLevel(thePlayer)
	return (isElement(thePlayer) and getElementData(thePlayer, "admin_level")) or 0
end

function getPlayerFullAdminTitle(thePlayer)
	if isElement(thePlayer) then
		local title = "Oyuncu"
		local accountUsername = getElementData(thePlayer, "account:username") or "N/A"
		if exports.cr_integration:isPlayerIA(thePlayer) then
			return "Internal Affairs"
		end
		if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
			local adminTitles = getAdminTitles()
			local text = adminTitles[getPlayerAdminLevel(thePlayer)] or "Oyuncu"
			title = text
		elseif exports.cr_integration:isPlayerHelper(thePlayer) then
			title = "Helper"
		elseif exports.cr_integration:isPlayerLeadScripter(thePlayer) then
			title = "Scripter"
		elseif exports.cr_integration:isPlayerScripter(thePlayer) then
			title = "Trial Scripter"
		elseif exports.cr_integration:isPlayerVCTMember(thePlayer) then
			title = "Vehicle Consultation Member"
		elseif exports.cr_integration:isPlayerVehicleConsultant(thePlayer) then
			title = "Vehicle Consultation Leader"
		elseif exports.cr_integration:isPlayerMappingTeamMember(thePlayer) then
			title = "Mapper"
		else
			title = "Oyuncu"
		end
		return title .. " " .. getPlayerName(thePlayer):gsub("_", " ") .. " (" .. accountUsername .. ")"
	end
end

function getPlayerAdminTitle(thePlayer)
	if isElement(thePlayer) then
		if exports.cr_integration:isPlayerIA(thePlayer) then
			return "Internal Affairs"
		end
		if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
			local adminTitles = getAdminTitles()
			local text = adminTitles[getPlayerAdminLevel(thePlayer)] or "Oyuncu"

			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
			if (hiddenAdmin==1) then
				text = text .. " (Gizli)"
			end

			return text
		elseif exports.cr_integration:isPlayerHelper(thePlayer) then
			return "Helper"
		elseif exports.cr_integration:isPlayerLeadScripter(thePlayer) then
			return "Scripter"
		elseif exports.cr_integration:isPlayerScripter(thePlayer) then
			return "Trial Scripter"
		elseif exports.cr_integration:isPlayerVCTMember(thePlayer) then
			return "Vehicle Consultation Member"
		elseif exports.cr_integration:isPlayerVehicleConsultant(thePlayer) then
			return "Vehicle Consultation Leader"
		elseif exports.cr_integration:isPlayerMappingTeamMember(thePlayer) then
			return "Mapper"
		else
			return "Oyuncu"
		end
	end
end

--[[GM]]--
function getGameMasters()
	local players = exports.cr_pool:getPoolElementsByType("player")
	local gameMasters = { }
	for key, value in ipairs(players) do
		if exports.cr_integration:isPlayerHelper(value) then
			table.insert(gameMasters, value)
		end
	end
	return gameMasters
end

--[[/GM]]--

local scripters = {
}

local lvl2scripters = {

}

local internalaffairs = {

}

function isPlayerLvl2Scripter(thePlayer)
	return lvl2scripters[thePlayer] or lvl2scripters[getElementData(thePlayer, "account:username") or "Owner"] or false
end

function isPlayerIA(thePlayer)
	return internalaffairs[thePlayer] or internalaffairs[getElementData(thePlayer, "account:username") or "Owner"] or false
end

function isPlayerScripter(thePlayer)
	return exports["cr_integration"]:isPlayerScripter(thePlayer)
end

function getAdminTitle1(thePlayer)
	local adminTitles = getAdminTitles()
	local title = adminTitles[getPlayerAdminLevel(thePlayer)] or false
	local username = getElementData(thePlayer, "account:username")
	if not title then
		if exports.cr_integration:isPlayerHelper(thePlayer) then
			return "Helper " .. username
		else
			return "Player " .. username
		end
	end
	if getElementData(thePlayer, "hiddenadmin") == 1 then
		return "Gizli Yetkili"
	else
		return title .. " " .. username
	end
end

function isStaffOnDuty(thePlayer)
	return isAdminOnDuty(thePlayer) or isSupporterOnDuty(thePlayer)
end

function isStaff(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)
	else
		return false
	end
end

function isAdminOnDuty(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.cr_integration:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "duty_admin") == 1)
	else
		return false
	end
end

function isSupporterOnDuty(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.cr_integration:isPlayerHelper(thePlayer) and (getElementData(thePlayer, "duty_supporter") == 1)
	else
		return false
	end
end
