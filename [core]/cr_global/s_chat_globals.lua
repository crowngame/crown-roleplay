MTAoutputChatBox = outputChatBox
function outputChatBox(text, visibleTo, r, g, b, colorCoded)
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox(string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded )
		outputChatBox(string.sub(text, 128), visibleTo, r, g, b, colorCoded )
	else
		MTAoutputChatBox(text, visibleTo, r, g, b, colorCoded )
	end
end

oocState = getElementData(getRootElement(),"globalooc:state") or 0

function getOOCState()
	return oocState
end

function setOOCState(state)
	oocState = state
	setElementData(getRootElement(),"globalooc:state", state, false)
end

function changeWarnStyle(thePlayer, commandName)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local warnStyle = getElementData(thePlayer, "wrn:style")
		local wrnStyleString
		if warnStyle == 1 then
			warnStyle = 0
			wrnStyleString = "Style changed to chat box"
		else
			warnStyle = 1
			wrnStyleString = "Style changed to side bar"
		end
		local dbid = getElementData(thePlayer, "account:id")
		local query = exports.cr_mysql:query_free("UPDATE accounts SET warn_style='" ..  warnStyle  .. "' WHERE id = '" .. dbid .. "'")
		if query then
			setElementData(thePlayer, "wrn:style", warnStyle)
			outputChatBox(wrnStyleString, thePlayer, 0, 255, 0)
		else
			outputChatBox("MYSQL-ERROR-0069, Please report on the mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("changewarnstyle", changeWarnStyle, false, false)

--Farid
function sendMessageToAdmins(message,showToOffDutyAdmins)
	local players = exports.cr_pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		if (exports.cr_integration:isPlayerTrialAdmin(thePlayer)) then
			if showToOffDutyAdmins or (getElementData(thePlayer, "duty_admin") == 1) then
				if getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3" then
					exports["cr_reports"]:showToAdminPanel(message, thePlayer, 255,0,0)
				else
					if getElementData(thePlayer, "wrn:style") == 1 then
						triggerClientEvent(thePlayer, "sendWrnMessage", thePlayer, message)
					else
						outputChatBox(message, thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end

--Farid
function sendMessageToSupporters(message, showToOffDutyGMs)
	local players = exports.cr_pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		if (exports.cr_integration:isPlayerHelper(thePlayer)) then
			if showToOffDutyGMs or getElementData(thePlayer, "duty_supporter") == 1 then
				if getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3" then
					exports["cr_reports"]:showToAdminPanel(message, thePlayer, 255,0,0)
				else
					if getElementData(thePlayer, "wrn:style") == 1 then
						triggerClientEvent(thePlayer, "sendWrnMessage", thePlayer, message)
					else
						outputChatBox(message, thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end

function sendMessageToStaff(message,showToOffDutyStaff)
	local players = exports.cr_pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		if exports.cr_integration:isPlayerStaff(thePlayer) then
			if showToOffDutyStaff or getElementData(thePlayer, "duty_admin") == 1 or getElementData(thePlayer, "duty_supporter") == 1 then
				if getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3" then
					exports["cr_reports"]:showToAdminPanel(message, thePlayer, 255,0,0)
				else
					if getElementData(thePlayer, "wrn:style") == 1 then
						triggerClientEvent(thePlayer, "sendWrnMessage", thePlayer, message)
					else
						outputChatBox(message, thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end

function findPlayerByPartialNick(thePlayer, partialNick, fromBankSystem)
	if not partialNick and not isElement(thePlayer) and type(thePlayer) == "string" then
		outputDebugString("Incorrect Parameters in findPlayerByPartialNick")
		partialNick = thePlayer
		thePlayer = nil
	end
	
	local candidates = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	
	if type(partialNick) == "string" then
		partialNick = string.lower(partialNick)
	elseif isElement(partialNick) and getElementType(partialNick) == "player" then
		return partialNick, getPlayerName(partialNick):gsub("_", " ")
	end

	if thePlayer and partialNick == "*" then
		return thePlayer, getPlayerName(thePlayer):gsub("_", " ")
	elseif type(partialNick) == "string" and getPlayerFromName(partialNick) then
		return getPlayerFromName(partialNick), getPlayerName(getPlayerFromName(partialNick)):gsub("_", " ")
	elseif tonumber(partialNick) then
		matchPlayer = exports.cr_pool:getElement("player", tonumber(partialNick))
		candidates = { matchPlayer }
	else
		local players = exports.cr_pool:getPoolElementsByType("player")
		for playerKey, arrayPlayer in ipairs(players) do
			if isElement(arrayPlayer) then
				local found = false
				local playerName = string.lower(getPlayerName(arrayPlayer))
				local posStart, posEnd = string.find(playerName, tostring(partialNick), 1, true)
				if not posStart and not posEnd then
					posStart, posEnd = string.find(playerName:gsub(" ", "_"), tostring(partialNick), 1, true)
				end

				if posStart and posEnd then
					if posEnd - posStart > matchNickAccuracy then
						matchNickAccuracy = posEnd - posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						candidates = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						matchNick = nil
						matchPlayer = nil
						table.insert(candidates, arrayPlayer)
					end
				end
			end
		end
	end
	
	if not matchPlayer or not isElement(matchPlayer) then
		if isElement(thePlayer) then
			if #candidates == 0 then
				if not fromBankSystem then
					outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Toplam " .. #candidates .. " oyuncu eşleşiyor:", thePlayer, 0, 0, 255, true)
				for _, arrayPlayer in ipairs(candidates) do
					outputChatBox(">>#FFFFFF (" .. tostring(getElementData(arrayPlayer, "playerid")) .. ") " .. getPlayerName(arrayPlayer), thePlayer, 0, 255, 0, true)
				end
			end
		end
		return false
	else
		return matchPlayer, getPlayerName(matchPlayer):gsub("_", " ")
	end
end

function sendLocalText(root, message, r, g, b, distance, exclude, useFocusColors, ignoreDeaths, useHex)
	if client ~= source then return end
	
	if not useHex then
		useHex = false
	end
	exclude = exclude or {}
	local affectedPlayers = { }
	local x, y, z = getElementPosition(root)
	
	if getElementType(root) == "player" and exports['cr_freecam-tv']:isPlayerFreecamEnabled(root) then return end
	
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < (distance or 20) then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if not exclude[nearbyPlayer] and (ignoreDeaths or not isPedDead(nearbyPlayer)) and logged==1 and getElementDimension(root) == getElementDimension(nearbyPlayer) then
				local r2, g2, b2 = r, g, b
				if useFocusColors then
					local focus = getElementData(nearbyPlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == root then
								r2, g2, b2 = unpack(color)
							end
						end
					end
				end
				
				outputChatBox(message, nearbyPlayer, r2, g2, b2, true)
				table.insert(affectedPlayers, nearbyPlayer)
			end
		end
	end
	
	if getElementType(root) == "player" and #affectedPlayers > 0 then -- TV SHOW!
		exports['cr_freecam-tv']:add(affectedPlayers)
	end
	return true, affectedPlayers
end
addEvent("sendLocalText", true)
addEventHandler("sendLocalText", getRootElement(), sendLocalText)

function sendLocalMeAction(thePlayer, message, fromPlayer, ignoreDeaths)
	if client ~= source then return end
	
	if string.find(message, "#%x%x%x%x%x%x") then
		message = message
	end

	local name = getPlayerName(thePlayer) or getElementData(thePlayer, "rpp.npc.name") or getElementData(thePlayer, "name")
	if getPlayerMaskState(thePlayer) then
		name = "Gizli [>" .. getElementData(thePlayer, "dbid") .. "]"
	end

	local state, affectedPlayers = sendLocalText(thePlayer, (fromPlayer and "*" or "*") .. " " ..  string.gsub(name, "_", " ") .. (message:sub(1, 1) == "'" and "" or " ") .. message:gsub('"([^"]-)"', '#FFFFFF "%1#FFFFFF "#dfaeff'), 223, 174, 255, 30, {}, true, ignoreDeaths, true)
	exports.cr_discord:sendMessage("me-log", (fromPlayer and "*" or "*") .. " " ..  string.gsub(name, "_", " ") .. (message:sub(1, 1) == "'" and "" or " ") .. message:gsub('"([^"]-)"', '#FFFFFF "%1#FFFFFF "#dfaeff'))
	return state, affectedPlayers
end
addEvent("sendLocalMeAction", true)
addEventHandler("sendLocalMeAction", root, sendLocalMeAction)

function sendLocalDoAction(thePlayer, message, ignoreDeaths)
	if client ~= source then return end
	
	if string.find(message, "#%x%x%x%x%x%x") then
		message = message
	end
	
	local name = getPlayerName(thePlayer) or getElementData(thePlayer, "rpp.npc.name") or getElementData(thePlayer, "name")
	if getPlayerMaskState(thePlayer) then
		name = "Gizli [>" .. getElementData(thePlayer, "dbid") .. "]"
	end

	local state, affectedPlayers = sendLocalText(thePlayer, "* " .. message:gsub('"([^"]-)"', '#FFFFFF "%1#FFFFFF "#84cbad') .. " ((" .. name:gsub("_", " ") .. "))", 132, 203, 173, 30, {}, true, ignoreDeaths)
	exports.cr_discord:sendMessage("do-log", "* " .. message:gsub('"([^"]-)"', '#FFFFFF "%1#FFFFFF "#84cbad') .. " ((" .. name:gsub("_", " ") .. "))")
	return state, affectedPlayers
end

function sendLocalChatAction(thePlayer, message, fromPlayer, ignoreDeaths)
	if client ~= source then return end
	
	if string.find(message, "#%x%x%x%x%x%x") then
		message = message
	end
	
	local name = getPlayerName(thePlayer) or getElementData(thePlayer, "rpp.npc.name") or getElementData(thePlayer, "name")
	if getPlayerMaskState(thePlayer) then
		name = "Gizli [>" .. getElementData(thePlayer, "dbid") .. "]"
	end
	
	local state, affectedPlayers = sendLocalText(thePlayer, (fromPlayer and "*" or "*") .. " " ..  string.gsub(name, "_", " ") .. (message:sub(1, 1) == "'" and "" or " ") .. message:gsub('"([^"]-)"', '#FFFFFF "%1#FFFFFF "#dfaeff'), 223, 174, 255, 30, {}, true, ignoreDeaths, true)
	return state, affectedPlayers
end
addEvent("sendLocalChatAction", true)
addEventHandler("sendLocalChatAction", getRootElement(), sendLocalMeAction)

local gpn = getPlayerName
function getPlayerName(p)
	local name = getElementData(p, "fakename") or gpn(p) or getElementData(p, "name") or getElementData(p, "rpp.npc.name")
	return string.gsub(name, "_", " ")
end

function getPlayerMaskState(player)
	local masks = exports["cr_items"]:getMasks()
	for index, value in pairs(masks) do
		if getElementData(player, value[1]) then
			return true
		end
	end
	return false
end

function maskeBul(thePlayer, commandName, maskID)
	maskID = tonumber(maskID)
	if maskID then
		if maskID > 0 then
			local foundPlayer = nil
			
			for k, player in ipairs(getElementsByType("player")) do
				if maskID == getElementData(player, "dbid") then
					foundPlayer = player
					break
				end
			end
			
			if foundPlayer then
				outputChatBox("[!]#FFFFFF Sonuç: " .. getPlayerName(foundPlayer):gsub("_", " ") .. " (" .. getElementData(foundPlayer, "playerid") .. ")", thePlayer, 0, 255, 0, true)
			else
				outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Maske ID]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Maske ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("maskebul", maskeBul, false, false)