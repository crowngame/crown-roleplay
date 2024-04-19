mysql = exports.cr_mysql

MTAoutputChatBox = outputChatBox
function outputChatBox(text, visibleTo, r, g, b, colorCoded)
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox(string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded )
		outputChatBox(string.sub(text, 128), visibleTo, r, g, b, colorCoded )
	else
		MTAoutputChatBox(text, visibleTo, r, g, b, colorCoded )
	end
end

function gooc(p,d,...)
	if getElementData(p, "faction") == 1 or getElementData(p, "faction") == 2 or getElementData(p, "faction") == 3 or getElementData(p, "faction") == 20 or getElementData(p, "faction") == 4 then
		if not (...) then
			outputChatBox("KULLANIM: /" .. d .. " [Mesaj]", p, 255, 194, 14)
			return
		end

		message = table.concat({...}, " ")
		for i, v in ipairs(getElementsByType("player")) do
			if getElementData(v, "faction") == 1 or getElementData(v, "faction") == 2 or getElementData(v, "faction") == 3 or getElementData(p, "faction") == 20 or getElementData(p, "faction") == 4 then
				outputChatBox("#f1f1f1[Hükumet OOC] " .. getPlayerName(p) .. ": #FFFFFF" .. message .. "", v, 255, 255, 255, true)
			end
		end
	end
end
addCommandHandler("gooc", gooc)

local gpn = getPlayerName
function getPlayerName(p)
	local name = getElementData(p, "fakename") or gpn(p) or getElementData(p, "name")
	return string.gsub(name, "_", " ")
end

function trunklateText(thePlayer, text, factor)
	return (tostring(text):gsub("^%l", string.upper))
end

local distance1 = 100

------------------------------ LEVEL 1 ------------------------------
addEvent("nodm-showtext", true)
addEventHandler("nodm-showtext", root, function(attacker, text)
	outputChatBox(text, attacker, 255, 0, 0, true)
end)
---------------------------------------------------------------------

function sendStatus(thePlayer, commandName, ...)
	if not (...) then
		setElementData(thePlayer, "chat:status", false)
		return
	end
	setElementData(thePlayer, "isStatusShowing", true)
	local name = getPlayerName(thePlayer)
	local message = table.concat({...}, " ")
	outputChatBox("[!]#FFFFFF Başarıyla statünüzü değiştirdiniz.", thePlayer, 0, 255, 0, true)
	setElementData(thePlayer, "chat:status", message)
	return state, affectedPlayers
end
addCommandHandler("status", sendStatus)

function sendActionNearClients(root, message, type)
	local affectedPlayers = { }
	local x, y, z = getElementPosition(root)

	if getElementType(root) == "player" and exports['cr_freecam-tv']:isPlayerFreecamEnabled(root) then return end

	local shownto = 0
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < (distance or 20) then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if logged==1 and getElementDimension(root) == getElementDimension(nearbyPlayer) then
				triggerClientEvent(nearbyPlayer,"addChatBubble", root, message, type)
			end
		end
	end
end
function getElementDistance(a, b)
	if not isElement(a) or not isElement(b) or getElementDimension(a) ~= getElementDimension(b) then
		return math.huge
	else
		local x, y, z = getElementPosition(a)
		return getDistanceBetweenPoints3D(x, y, z, getElementPosition(b))
	end
end

function icChatsToVoice(audience, msg, from) --Farid
	if getElementData(audience, "text2speech_ic_chats") ~= "0" then
		exports.cr_text2speech:convertTextToSpeech(audience, msg, "en", from, 0.8, 50) 
	end
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

addCommandHandler("imla", function(player)
	outputChatBox("[!]#FFFFFF Otomatik imla modu başarıyla " .. (false == getElementData(player, "imla") and "açıldı" or "kapatıldı") .. ", " .. (true == getElementData(player, "imla") and "açmak" or "kapatmak") .. " için tekrardan /imla yazınız.", player, 0, 255, 0, true)
	setElementData(player, "imla", false == getElementData(player, "imla") and true or false, false)
end)

addCommandHandler("aksan", function(player)
	if getElementData(player, "country") == 0 then
		outputChatBox("[!]#FFFFFF Ülkenizi seçmediğiniz için aksan modunu açamassınız.", player, 255, 0, 0, true)
	else
		outputChatBox("[!]#FFFFFF Aksanınız başarıyla " .. (false == getElementData(player, "chat:aksan") and "açıldı" or "kapatıldı") .. ", " .. (true == getElementData(player, "chat:aksan") and "açmak" or "kapatmak") .. " için tekrardan /aksan yazınız.", player, 0, 255, 0, true)
		setElementData(player, "chat:aksan", false == getElementData(player, "chat:aksan") and true or false, false)
	end
end)

addCommandHandler("talkanim", function(player)
	outputChatBox("[!]#FFFFFF Otomatik konuşma animasyonu başarıyla " .. (false == getElementData(player, "talk_anim") and "açıldı" or "kapatıldı") .. ", " .. (true == getElementData(player, "talk_anim") and "açmak" or "kapatmak") .. " için tekrardan /talkanim yazınız.", player, 0, 255, 0, true)
	setElementData(player, "talk_anim", false == getElementData(player, "talk_anim") and true or false, false)
end)

local country = {
    "Amerikan",
	"Alman",
	"Rus",
	"Avusturalya",
	"Arjantin",
	"Belçika",
	"Bulgaristan",
	"Çin",
	"Fransa",
	"Brezilya",
	"İngiltere",
	"İrlanda",
	"İskoçya",
	"İsrail",
	"İsveç",
	"İsviçre",
	"İtalya",
	"Jamaika",
	"Japonya",
	"Kanada",
	"Kolombiya",
	"Küba",
	"Litvanya",
	"Macaristan",
	"Makedonya",
	"Meksika",
	"Nijerya",
	"Norveç",
	"Peru",
	"Portekiz",
	"Romanya",
	"Sırbistan",
	"Slovakya",
	"Ukrayna",
	"Yunanistan",
	"Danimarka",
	"Çekya",
	"Polonya",
	"Güney Kore",
	"Hollanda",
	"Arnavutluk",
	"İspanya",
	"Vietnam",
	"Avusturya",
	"Mısır",
	"Güney Afrika",
	"Qatar",
	"Türk",
	"Azeri",
}

function localIC(source, message)
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(source) then return end
	local affectedElements = { }
	table.insert(affectedElements, source)
	local x, y, z = getElementPosition(source)
	if getPlayerMaskState(source) then
		playerName = "Gizli [>" .. getElementData(source, "dbid") .. "]"
	else
		playerName = getPlayerName(source)
	end
	local time = getRealTime()

	message = string.gsub(message, "#%x%x%x%x%x%x", "")
	message = trunklateText(source, message)

	local color = {0xEE,0xEE,0xEE}

	local focus = getElementData(source, "focus")
	local focusColor = false
	if type(focus) == "table" then
		for player, color2 in pairs(focus) do
			if player == source then
				color = color2
			end
		end
	end

	if message == ":)" then
		exports.cr_global:sendLocalMeAction(source, "gülümser.")
		return
	elseif message == ":D" then
		exports.cr_global:sendLocalMeAction(source, "kahkaha atar.")
		return
	elseif message == ";)" then
		exports.cr_global:sendLocalMeAction(source, "göz kırpar.")
		return
	elseif message == "O.o" then
		exports.cr_global:sendLocalMeAction(source, "sol kaşını havaya kaldırır.")
		return
	elseif message == "O.O" then
		exports.cr_global:sendLocalMeAction(source, "sağ kaşını havaya kaldırır.")
		return
	elseif message == "X.x" then
		exports.cr_global:sendLocalMeAction(source, "gözlerini kapatır.")
		return
	elseif message == ":(" then
		exports.cr_global:sendLocalDoAction(source, "Yüzünde üzgün bir ifade oluştuğu görülebilir.")
		return	
	end

	local aksan = ""
	if getElementData(source, "chat:aksan") then
		aksan = " (" .. country[tonumber(getElementData(source, "country"))] .. " Aksanı)"
	end
	
	local telefon = ""
	if tonumber(getElementData(source, 'callingState')) == 2 then
		telefon = " (Telefon)"
	end
	
	local playerVehicle = getPedOccupiedVehicle(source)
	if getElementData(source, "imla") then
		local yazi = string.sub(message, 1, 1)
		if type(yazi) == "string" then
			message = string.upper(yazi)..string.sub(message, 2, #message)
		end
		if string.sub(message, -1) ~= "." then
			message = message .. "."
		end
	end
	
	if playerVehicle then
		local vehicle = ""
		if (exports['cr_vehicle']:isVehicleWindowUp(playerVehicle)) then
			table.insert(affectedElements, playerVehicle)
			vehicle = " ((Arabada))"
		end
		outputChatBox(playerName..aksan..telefon..vehicle .. ": " .. message, source, unpack(color))
	else
		if getElementData(source, "talk_anim") then
			exports.cr_global:applyAnimation(source, "GANGS", "prtial_gngtlkA", 1, false, true, false)
		end
		outputChatBox(playerName..aksan..telefon .. ": " .. message, source, unpack(color))
	end

	local dimension = getElementDimension(source)
	local interior = getElementInterior(source)

	if dimension ~= 0 then
		table.insert(affectedElements, "in" .. tostring(dimension))
	end

	if(getResourceFromName("cr_tooltips"))then
		triggerClientEvent(source, "tooltips:showHelp", source, 17)
	end

	for key, nearbyPlayer in ipairs(getElementsByType("player")) do
		local dist = getElementDistance(source, nearbyPlayer)
		if dist < 20 then
			local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
			local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
			if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
				--triggerClientEvent(nearbyPlayer,"addChatBubble", source, playerName.. " : " .. message, "say")
				local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
				if not (isPedDead(nearbyPlayer)) and (logged==1) and (nearbyPlayer~=source) then
				message2 = message
					local pveh = getPedOccupiedVehicle(source)
					local nbpveh = getPedOccupiedVehicle(nearbyPlayer)
					local color = {0xEE,0xEE,0xEE}

					local focus = getElementData(nearbyPlayer, "focus")
					local focusColor = false
					if type(focus) == "table" then
						for player, color2 in pairs(focus) do
							if player == source then
								focusColor = true
								color = color2
							end
						end
					end

					if pveh then
						if (exports['cr_vehicle']:isVehicleWindowUp(pveh)) then
							for i = 0, getVehicleMaxPassengers(pveh) do
								local lp = getVehicleOccupant(pveh, i)

								if (lp) and (lp~=source) then
									outputChatBox(playerName .. " ((Arabada)): " .. message2, lp, unpack(color))
									table.insert(affectedElements, lp)
									--icChatsToVoice(lp, message2, source)
								end
							end
							table.insert(affectedElements, pveh)
							exports['cr_freecam-tv']:add(affectedElements)
							return
						end
					end

					if nbpveh and exports['cr_vehicle']:isVehicleWindowUp(nbpveh) == true then
						--[[if not focusColor then
							if dist < 3 then
							elseif dist < 6 then
								color = {0xDD,0xDD,0xDD}
							elseif dist < 9 then
								color = {0xCC,0xCC,0xCC}
							elseif dist < 12 then
								color = {0xBB,0xBB,0xBB}
							else
								color = {0xAA,0xAA,0xAA}
							end
						end
						-- for players in vehicle
						outputChatBox(playerName .. ": " .. message2, nearbyPlayer, unpack(color))]]
						--table.insert(affectedElements, nearbyPlayer)
					else
						if not focusColor then
							if dist < 4 then
							elseif dist < 8 then
								color = {0xDD,0xDD,0xDD}
							elseif dist < 12 then
								color = {0xCC,0xCC,0xCC}
							elseif dist < 16 then
								color = {0xBB,0xBB,0xBB}
							else
								color = {0xAA,0xAA,0xAA}
							end
						end
						outputChatBox(playerName .. aksan..telefon .. ": " .. message2, nearbyPlayer, unpack(color))
						table.insert(affectedElements, nearbyPlayer)
						--icChatsToVoice(nearbyPlayer, message2, source)
					end
				end
			end
		end
	end
	exports['cr_freecam-tv']:add(affectedElements)
end

function meEmote(source, cmd, ...)
	local logged = getElementData(source, "loggedin")
	if logged == 1 then
		local message = table.concat({...}, " ")
		if not (...) then
			outputChatBox("KULLANIM: /me [Action]", source, 255, 194, 14)
		else

			local result, affectedPlayers = exports.cr_global:sendLocalMeAction(source, message, true, true)
		end
	end
end
addCommandHandler("ME", meEmote, false, true)
addCommandHandler("Me", meEmote, false, true)

function outputChatBoxCar(vehicle, target, text1, text2, color)
	if vehicle and exports['cr_vehicle']:isVehicleWindowUp(vehicle) then
		if getPedOccupiedVehicle(target) == vehicle then
			outputChatBox(text1 .. " ((Arabada))" .. text2, target, unpack(color))
			return true
		else
			return false
		end
	end
	outputChatBox(text1 .. text2, target, unpack(color))
	return true
end

function radio(source, radioID, message)
	local customSound = false
	local affectedElements = { }
	local indirectlyAffectedElements = { }
	table.insert(affectedElements, source)
	radioID = tonumber(radioID) or 1
	local hasRadio, itemKey, itemValue, itemID = exports.cr_global:hasItem(source, 6)
	if hasRadio or getElementType(source) == "ped" or radioID == -2 then
		local theChannel = itemValue
		if radioID < 0 then
			theChannel = radioID
		elseif radioID == 1 and exports.cr_integration:isPlayerTrialAdmin(source) and tonumber(message) and tonumber(message) >= 1 and tonumber(message) <= 10 then
			return
		elseif radioID ~= 1 then
			local count = 0
			local items = exports['cr_items']:getItems(source)
			for k, v in ipairs(items) do
				if v[1] == 6 then
					count = count + 1
					if count == radioID then
						theChannel = v[2]
						break
					end
				end
			end
		end

		local isRestricted, factionID = isThisFreqRestricted(theChannel)
		local playerFaction = getElementData(source, "faction")
		if theChannel == 1 or theChannel == 0 then
			outputChatBox("Please Tune your radio first with /tuneradio [channel]", source, 255, 194, 14)
		elseif isRestricted and tonumber(playerFaction) ~= tonumber(factionID) then
			outputChatBox("You are not allowed to access this channel. Please retune your radio.", source, 255, 194, 14)
		elseif theChannel > 1 or radioID < 0 then
			--triggerClientEvent (source, "playRadioSound", getRootElement())
			local username = getPlayerName(source)
			local channelName = "#" .. theChannel

			message = trunklateText(source, message)
			local r, g, b = 0, 102, 255
			local focus = getElementData(source, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == source then
						r, g, b = unpack(color)
					end
				end
			end

			if radioID == -1 then
				local teams = {
					getTeamFromName("Los Santos Sheriff Department"),
					getTeamFromName("Los Santos Police Department"),
					getTeamFromName("Oto Kurtarma 7/24"),
					getTeamFromName("Los Santos President"),
					getTeamFromName("Federal Aviation Administration"),
					getTeamFromName("San Andreas Highway Patrol"),
					getTeamFromName("Superior Court of San Andreas"),
					getTeamFromName("San Andreas Public Transport"),
				}

				for _, faction in ipairs(teams) do
					if faction and isElement(faction) then
						for key, value in ipairs(getPlayersInTeam(faction)) do
							for _, itemRow in ipairs(exports['cr_items']:getItems(value)) do
								--outputDebugString(tostring(itemRow[1]) .. " - " .. tostring(itemRow[2]))
								if tonumber(itemRow[1]) and tonumber(itemRow[2]) and tonumber(itemRow[1]) == 6 and tonumber(itemRow[2]) > 0 then
									table.insert(affectedElements, value)
									break
								end
							end
						end
					end
				end

				channelName = "DEPARTMENT"
			elseif radioID == -2 then
				local a = {}
				for key, value in ipairs(exports.cr_sfia:getPlayersInAircraft()) do
					table.insert(affectedElements, value)
					a[value] = true
				end

				for key, value in ipairs(getPlayersInTeam(getTeamFromName("Federal Aviation Administration"))) do
					if not a[value] then
						for _, itemRow in ipairs(exports['cr_items']:getItems(value)) do
							if (itemRow[1] == 6 and itemRow[2] > 0) then
								table.insert(affectedElements, value)
								break
							end
						end
					end
				end

				channelName = "AIR"
			elseif radioID == -3 then --PA (speakers) in vehicles and interiors // Exciter
				local outputDim = getElementDimension(source)
				local vehicle
				if isPedInVehicle(source) then
					vehicle = getPedOccupiedVehicle(source)
					outputDim = tonumber(getElementData(vehicle, "dbid")) + 20000
				end
				if(outputDim > 0) then
					local canUsePA = false
					if(outputDim > 20000) then --vehicle interior
						local dbid = outputDim - 20000
						if not vehicle then
							for k,v in ipairs(exports.cr_pool:getPoolElementsByType("vehicle-system")) do
								if getElementData(v, "dbid") == dbid then
									vehicle = v
									break
								end
							end
						end
						if vehicle then
							canUsePA = getElementData(source, "adminduty") == 1 or exports.cr_global:hasItem(source, 3, tonumber(dbid)) or (getElementData(source, "faction") > 0 and getElementData(source, "faction") == getElementData(vehicle, "faction"))
						end
					else
						canUsePA = getElementData(source, "adminduty") == 1 or exports.cr_global:hasItem(source, 4, outputDim) or exports.cr_global:hasItem(source, 5,outputDim)
					end
					--outputDebugString("canUsePA=" .. tostring(canUsePA))
					if not canUsePA then
						return false
					end

					local outputInt = getElementInterior(source)
					for key, value in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
						if(getElementDimension(value) == outputDim) then
							if(getElementInterior(value) == outputInt or vehicle) then
								table.insert(affectedElements, value)
							end
						end
					end
					if vehicle then
						for i = 0, getVehicleMaxPassengers(vehicle) do
							local player = getVehicleOccupant(vehicle, i)
							if player then
								table.insert(affectedElements, player)
							end
						end
					end
					r, g, b = 0,149,255
					channelName = "SPEAKERS"
					customSound = "pa.mp3"
				else
					return false
				end
			elseif radioID == -4 then --PA (speakers) at airports // Exciter
				local x,y,z = getElementPosition(source)
				local zonename = getZoneName(x,y,z,false)
				local outputDim = getElementDimension(source)
				local allowedFactions = {
					47, --FAA
				}
				local allowedAirports = {
					["Easter Bay Airport"]=true,
					["Los Santos International"]=true,
					["Las Venturas Airport"]=true
				}
				allowedAirportDimensions = {
					[1317]=true, --LSA terminal
					[2337]=true, --LSA deaprture hall
					[2340]=true, --LSA terminal 2
				}
				airportDimensionsSF = {}
				airportDimensionsLS = {
					[1317]=true, --terminal
					[2337]=true, --deaprture hall
					[2340]=true, --terminal 2
				}
				airportDimensionsLV = {}
				local airportDimensions = {}
				local targetAirport = zonename
				if(zonename == "Easter Bay Airport" or airportDimensionsSF[outputDim]) then
					airportDimensions = airportDimensionsSF
				elseif(zonename == "Los Santos International" or airportDimensionsLS[outputDim]) then
					airportDimensions = airportDimensionsLS
				elseif(zonename == "Las Venturas Airport" or airportDimensionsLV[outputDim]) then
					airportDimensions = airportDimensionsLV
				end

				local inAllowedFaction = false
				for k,v in ipairs(allowedFactions) do
					if exports.cr_faction:isPlayerInFaction(source, v) then
						inAllowedFaction = true
					end
				end

				if(inAllowedFaction) then
					if(allowedAirportDimensions[outputDim] or outputDim == 0 and allowedAirports[zonename]) then
						for key, value in ipairs(getElementsByType("player")) do
							x,y,z = getElementPosition(value)
							zonename = getZoneName(x,y,z,false)
							local dim = getElementDimension(value)
							if(airportDimensions[dim] or dim == 0 and zonename == targetAirport) then
								table.insert(affectedElements, value)
							end
						end
						r, g, b = 0,149,255
						channelName = "AIRPORT SPEAKERS"
						customSound = "pa.mp3"
					else
						return false
					end
				else
					return false
				end
			else
				for key, value in ipairs(getElementsByType("player")) do
					if exports.cr_global:hasItem(value, 6, theChannel) then
						local isRestricted, factionID = isThisFreqRestricted(theChannel)
						local playerFaction = getElementData(value, "faction")
						if (isRestricted and tonumber(playerFaction) == tonumber(factionID)) or not isRestricted then
							table.insert(affectedElements, value)
						end
					end
				end
			end

			if channelName == "DEPARTMENT" then
			outputChatBoxCar(getPedOccupiedVehicle(source), source, "[" .. channelName .. "] " .. username, " : " .. message, {r,162,b})
			else
			outputChatBoxCar(getPedOccupiedVehicle(source), source, "[" .. channelName .. "] " .. username, " : " .. message, {r,g,b})
			end

			for i = #affectedElements, 1, -1 do
				if getElementData(affectedElements[i], "loggedin") ~= 1 then
					table.remove(affectedElements, i)
				end
			end

			for key, value in ipairs(affectedElements) do
				if customSound then
					triggerClientEvent(value, "playCustomChatSound", getRootElement(), customSound)
				else
					triggerClientEvent (value, "playRadioSound", getRootElement())
				end
				if value ~= source then
					local r, g, b = 0, 102, 255
					local focus = getElementData(value, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == source then
								r, g, b = unpack(color)
							end
						end
					end
					if channelName == "DEPARTMENT" then
					outputChatBoxCar(getPedOccupiedVehicle(value), value, "[" .. channelName .. "] " .. username, " : " .. trunklateText(value, message2), {r,162,b})
					else
					outputChatBoxCar(getPedOccupiedVehicle(value), value, "[" .. channelName .. "] " .. username, " : " .. trunklateText(value, message2), {r,g,b})
					end

					--if not exports.cr_global:hasItem(value, 88) == false then  ***Earpiece Fix***
					if exports.cr_global:hasItem(value, 88) == false then
						-- Show it to people near who can hear his radio
						for k, v in ipairs(exports.cr_global:getNearbyElements(value, "player",7)) do
							local logged2 = getElementData(v, "loggedin")
							if (logged2==1) then
								local found = false
								for kx, vx in ipairs(affectedElements) do
									if v == vx then
										found = true
										break
									end
								end

								if not found then
									local message2 = message
									local text1 = getPlayerName(value) .. "'s Radio"
									local text2 = ": " .. trunklateText(v, message2)

									if outputChatBoxCar(getPedOccupiedVehicle(value), v, text1, text2, {255, 255, 255}) then
										table.insert(indirectlyAffectedElements, v)
									end
								end
							end
						end
					end
				end
			end
			--
			--Show the radio to nearby listening in people near the speaker
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDistance(source, value) < 10 then
					if (value~=source) then
						local message2 = message
						local text1 = getPlayerName(source) .. " [RADIO]"
						local text2 = " : " .. trunklateText(value, message2)

						if outputChatBoxCar(getPedOccupiedVehicle(source), value, text1, text2, {255, 255, 255}) then
							table.insert(indirectlyAffectedElements, value)
						end
					end
				end
			end

			if #indirectlyAffectedElements > 0 then
				table.insert(affectedElements, "Indirectly Affected:")
				for k, v in ipairs(indirectlyAffectedElements) do
					table.insert(affectedElements, v)
				end
			end
		else
			outputChatBox("Radyonuz kapalı. ((/toggleradio))", source, 255, 0, 0)
		end
	else
		outputChatBox("Radyon yok.", source, 255, 0, 0)
	end
end

function chatMain(message, messageType)
	cancelEvent()
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(source) then cancelEvent() return end

	local logged = getElementData(source, "loggedin")

	if (messageType == 1 or not (isPedDead(source))) and (logged==1) and not (messageType==2) then -- Player cannot chat while dead or not logged in, unless its OOC
		local dimension = getElementDimension(source)
		local interior = getElementInterior(source)
		-- Local IC
		if (messageType==0) then
			localIC(source, message, 1)
		elseif (messageType==1) then -- Local /me action
			meEmote(source, "me", message)
		end
	elseif (messageType==2) and (logged==1) then -- Radio
		radio(source, 1, message)
	end
end
addEventHandler("onPlayerChat", getRootElement(), chatMain)

function msgRadio(thePlayer, commandName, ...)
	if (...) then
		local message = table.concat({...}, " ")
		radio(thePlayer, 1, message)
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("r", msgRadio, false, false)
addCommandHandler("radio", msgRadio, false, false)

for i = 1, 20 do
	addCommandHandler("r" .. tostring(i),
		function(thePlayer, commandName, ...)
			if i <= exports['cr_items']:countItems(thePlayer, 6) then
				if (...) then
					radio(thePlayer, i, table.concat({...}, " "))
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
				end
			end
		end
	)
end

function govAnnouncement(thePlayer, commandName, ...)
	local theTeam = getPlayerTeam(thePlayer)

	if (theTeam) then
		local teamID = tonumber(getElementData(theTeam, "id"))

		if (teamID==1 or teamID==2 or teamID==3 or teamID==47 or teamID==59) then
			local message = table.concat({...}, " ")
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionLeader = getElementData(thePlayer,"factionleader")

			if #message == 0 then
				outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
				return false
			end

			if factionLeader>0 then
				local ranks = getElementData(theTeam,"ranks")
				local factionRankTitle = ranks[factionRank]

				--exports.cr_logs:logMessage("[IC: Government Message] " .. factionRankTitle .. " " .. getPlayerName(thePlayer) .. ": " .. message, 6)
				exports.cr_logs:dbLog(source, 16, source, message)
				for key, value in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
					local logged = getElementData(value, "loggedin")

					if (logged==1) then
						outputChatBox(">> Hükümetten Duyuru " .. factionRankTitle .. " " .. getPlayerName(thePlayer), value, 0, 183, 239)
						outputChatBox(message, value, 0, 183, 239)
					end
				end
			else
				outputChatBox("Bu komutu kullanma izniniz yok.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gov", govAnnouncement)

function departmentradio(thePlayer, commandName, ...)
	local theTeam = getElementType(thePlayer) == "player" and getPlayerTeam(thePlayer)
	local tollped = getElementType(thePlayer) == "ped" and getElementData(thePlayer, "toll:key")
	if (theTeam)  or (tollped) then
		local teamID = nil
		if not tollped then
			teamID = tonumber(getElementData(theTeam, "id"))
		end

		if (teamID==1 or teamID==2 or teamID==3 or tollped) then --47=FAA 64=SAPT
			if (...) then
				local message = table.concat({...}, " ")
				radio(thePlayer, -1, message)
			elseif not tollped then
				outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("dep", departmentradio, false, false)
addCommandHandler("department", departmentradio, false, false)

function airradio(thePlayer, commandName, ...)
	local playersInAir = exports.cr_sfia:getPlayersInAircraft()
	if playersInAir then
		local found = false
		if getPlayerTeam(thePlayer) == getTeamFromName("Federal Aviation Administration") then
			for _, itemRow in ipairs(exports['cr_items']:getItems(thePlayer)) do
				if (itemRow[1] == 6 and itemRow[2] > 0) then
					found = true
					break
				end
			end
		end

		if not found then
			for k, v in ipairs(playersInAir) do
				if v == thePlayer then
					found = true
					break
				end
			end
		end

		if found then
			if not ... then
				outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
			else
				radio(thePlayer, -2, table.concat({...}, " "))
			end
		else
			outputChatBox("Hava frekansı hakkında konuşamıyordunuz.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("air", airradio, false, false)
addCommandHandler("airradio", airradio, false, false)

 --PA (speakers) in vehicles and interiors // Exciter
function ICpublicAnnouncement(thePlayer, commandName, ...)
	if not ... then
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	else
		radio(thePlayer, -3, table.concat({...}, " "))
	end
end
addCommandHandler("pa", ICpublicAnnouncement, false, false)

 --PA (speakers) at airports // Exciter
function ICAirportAnnouncement(thePlayer, commandName, ...)
	if not ... then
		outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
	else
		radio(thePlayer, -4, table.concat({...}, " "))
	end
end
addCommandHandler("airportpa", ICAirportAnnouncement, false, false)
-- End of Main Chat

function adminDuyuru(thePlayer, commandName, ...)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
        if (...) then
			local message = table.concat({...}, " ")
			local adminName = exports.cr_global:getPlayerAdminTitle(thePlayer) .. " " .. getElementData(thePlayer, "account:username")
			
			if getElementData(thePlayer, "hiddenadmin") == 1 then
				adminName = "Gizli Yetkili"
			end
			
            for _, player in ipairs(getElementsByType("player")) do
            	if getElementData(player, "loggedin") == 1 then
					exports.cr_infobox:addBox(player, "announcement", adminName .. ": " .. message)
				end
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [İleti]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("duyuru", adminDuyuru, false, false)

function globalOOC(thePlayer, commandName, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin"))

	if (logged==1) then
		if not (exports.cr_integration:isPlayerManagement(thePlayer)) then
		return end
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		else
			local oocEnabled = exports.cr_global:getOOCState()
			message = table.concat({...}, " ")
			local muted = getElementData(thePlayer, "muted")
			if (oocEnabled==0) and not exports.cr_integration:isPlayerSeniorAdmin(thePlayer) and not exports.cr_integration:isPlayerScripter(thePlayer) then
				outputChatBox("OOC Sohbet şu anda devre dışı.", thePlayer, 255, 0, 0)
			elseif (muted==1) then
				outputChatBox("Şu anda OOC Sohbetinden sessize alındı.", thePlayer, 255, 0, 0)
			else
				local affectedElements = { }
				local players = exports.cr_pool:getPoolElementsByType("player")
				local playerName = getPlayerName(thePlayer)
				local playerID = getElementData(thePlayer, "playerid")

				for k, arrayPlayer in ipairs(players) do
					local logged = tonumber(getElementData(arrayPlayer, "loggedin"))
					local targetOOCEnabled = getElementData(arrayPlayer, "globalooc")

					if (logged==1) and (targetOOCEnabled==1) then
						table.insert(affectedElements, arrayPlayer)
						if exports.cr_integration:isPlayerGameAdmin(thePlayer) then
                            local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
							if getElementData(thePlayer, "hiddenadmin") then
								outputChatBox("[OOC] #FF0000" .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. "#CCFFFF: " .. message, arrayPlayer, 196, 255, 255, true)
							else
								outputChatBox("[OOC] #FF0000" .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. "#CCFFFF: " .. message, arrayPlayer, 196, 255, 255, true)
							end
                        else
							outputChatBox("[OOC] #FF0000" .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. "#CCFFFF: " .. message, arrayPlayer, 196, 255, 255, true)
                        end
					end
				end
				exports.cr_logs:dbLog(thePlayer, 18, affectedElements, message)
			end
		end
	end
end
addCommandHandler("ooc", globalOOC, false, false)
addCommandHandler("GlobalOOC", globalOOC)

function playerToggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		local playerOOCEnabled = getElementData(thePlayer, "globalooc")

		if (playerOOCEnabled==1) then
			outputChatBox("Artık Global OOC Sohbetini gizlediniz.", thePlayer, 255, 194, 14)
			setElementData(thePlayer, "globalooc", 0, false)
		else
			outputChatBox("Global OOC Chat'i şimdi etkinleştirdiniz.", thePlayer, 255, 194, 14)
			setElementData(thePlayer, "globalooc", 1, false)
		end
		dbExec(mysql:getConnection(),"UPDATE accounts SET globalooc=" .. (getElementData(thePlayer, "globalooc")) .. " WHERE id = " .. (getElementData(thePlayer, "account:id")))
	end
end
addCommandHandler("toggleooc", playerToggleOOC, false, false)

local advertisementMessages = { "samp", "SA-MP", "Kye", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "www.", ".com", "co.cc", ".net", ".co.uk", "everlast", "neverlast", "www.everlastgaming.com", "trueliferp", "truelife", "mtarp", "mta:rp", "mta-rp", "Inception", "Akıllıok", "Enes", "Fatih", "Ediz", "inception", "sarp", "server", "lucy", "Lucy", "Arya", "harun", "rpg", "rp"}

function isFriendOf(thePlayer, targetPlayer)
	return exports['cr_social']:isFriendOf(getElementData(thePlayer, "account:id"), getElementData(targetPlayer, "account:id"))
end

ignoreList = {}
function ignoreOnePlayer(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		if not (targetPlayerNick) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
			if exports.cr_integration:isPlayerTrialAdmin(targetPlayer) then
				outputChatBox("Yöneticileri yoksaymayabilirsiniz.", thePlayer, 255, 0, 0)
				return
			end

			local existed = false
			for k, v in ipairs(ignoreList) do
				if v[2] == targetPlayer then
					table.remove(ignoreList, k)
					outputChatBox("Artık fısıltıları görmezden gelmiyorsun " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
					existed = true
					break
				end
			end
			if not existed then
				table.insert(ignoreList, {thePlayer, targetPlayer})
				outputChatBox("Fısıltıları görmezden geliyorsun " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
				outputChatBox("Yok saymakta olduğunuz oyuncuların tam listesi için /ignorelist yazın.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("ignore", ignoreOnePlayer)

function checkifiamfucked(thePlayer, commandName)
	outputChatBox(" ~~~~~~~~~ Engellenmiş Kişiler ~~~~~~~~~ ", thePlayer, 237, 172, 19)
	outputChatBox("    -- AKIMI YÜKSELTME --", thePlayer, 2, 172, 19)
	for k, v in ipairs(ignoreList) do
		if v[1] == thePlayer then
			outputChatBox(getPlayerName(v[2]):gsub("_"," "), thePlayer, 255, 255, 255)
		end
	end
	outputChatBox(" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ", thePlayer, 237, 172, 19)
end
addCommandHandler("ignorelist", checkifiamfucked)

addEventHandler('onPlayerQuit', root,
	function()
		ignoreList[source] = nil
		for k, v in pairs(ignoreList) do
			for kx, vx in ipairs(v) do
				if vx == source then
					table.remove(vx, kx)
					break
				end
			end
		end
	end)

function pmPlayer(thePlayer, commandName, who, ...)
	local message = nil
	if tostring(commandName):lower() == "quickreply" and who then
		local target = getElementData(thePlayer, "targetPMer")
		if not target or not isElement(target) or not (getElementType(target) == "player") or not (getElementData(target, "loggedin") == 1) then
			outputChatBox("[!]#FFFFFF Kimse size özel mesaj atmadı.", thePlayer, 255, 0, 0, true)
			return false
		end
		message = who .. " " .. table.concat({...}, " ")
		who = target
	else
		if not (who) or not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [İleti]", thePlayer, 255, 194, 14)
			outputChatBox("'u' tuşuyla son özel mesajı hızlı yanıtlayabilirsiniz.", thePlayer, 255, 194, 14)
			return false
		end
		message = table.concat({...}, " ")
	end

	if who and message and getElementData(thePlayer, "loggedin") == 1 then

		local loggedIn = getElementData(thePlayer, "loggedin")
		if (loggedIn==0) then
			return
		end

		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, who)

		if (targetPlayer) then
			if getElementData(targetPlayer, "loggedin") ~= 1 then
				outputChatBox("[!]#FFFFFF Mesaj atmakta olduğunuz oyuncu karakterine giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				return false
			end

			if getElementData(thePlayer, "adminjailed") and not exports.cr_integration:isPlayerGameAdmin(targetPlayer) then
				outputChatBox("[!]#FFFFFF OOC hapisdeyken sadece yetkililere mesaj atabilirsiniz.", thePlayer, 255, 255, 0)
		    	return
		    end
  
			if getElementData(thePlayer, "pm:off") then
				outputChatBox("[!]#FFFFFF Özel mesaj alımlarınız kapalı olduğu için mesaj gönderemediniz.", thePlayer, 255, 0, 0, true)
				return false
			end
  
			if getElementData(targetPlayer, "pm:off") then
				outputChatBox("[!]#FFFFFF Mesaj atmakta olduğunuz oyuncu özel mesaj alımlarını kapattığı için mesaj gönderemediniz.", thePlayer, 255, 0, 0, true)
				return false
			end
		
			for k, v in ipairs(ignoreList) do
				if v[2] == targetPlayer and v[1] == thePlayer then
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya özel mesaj gönder için onu engelli listenizden kaldırın.", thePlayer, 255, 0, 0, true)
					return false
				end
			end
			for k, v in ipairs(ignoreList) do
				if v[1] == thePlayer and v[2] == thePlayer then
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu sizin özel mesajlarınızı engellemiş.", thePlayer, 255, 0, 0, true)
					return false
				end
			end

			setElementData(targetPlayer, "targetPMer", thePlayer, false)

			local playerName = getPlayerName(thePlayer):gsub("_", " ")
			local targetUsername1, username1 = getElementData(targetPlayer, "account:username"), getElementData(thePlayer, "account:username")

			local targetUsername = " (" .. targetUsername1 .. ")"
			local username = " (" .. username1 .. ")"

			if not exports.cr_integration:isPlayerTrialAdmin(targetPlayer) and not exports.cr_integration:isPlayerScripter(targetPlayer) then
				username = ""
			end

			if not exports.cr_integration:isPlayerTrialAdmin(thePlayer) and not exports.cr_integration:isPlayerScripter(thePlayer) then
				targetUsername = ""
			end
		
			if not exports.cr_integration:isPlayerHeadAdmin(thePlayer) and not exports.cr_integration:isPlayerHeadAdmin(targetPlayer) then
				for k,v in ipairs(advertisementMessages) do
					local found = string.find(string.lower(message), "%s" .. tostring(v))
					local found2 = string.find(string.lower(message), tostring(v) .. "%s")
					if (found) or (found2) or (string.lower(message)==tostring(v)) then
						exports.cr_global:sendMessageToAdmins("[PM] " .. tostring(playerName) .. " isimli oyuncu " .. tostring(targetPlayerName) .. " isimli oyuncuya yasaklı kelime içeren özel mesaj gönderdi.")
						exports.cr_global:sendMessageToAdmins("[PM] Mesaj: " .. tostring(message))
						break
					end
				end
			end

			if getElementData(thePlayer, "imla") then
				local yazi = string.sub(message, 1, 1)
				if type(yazi) == "string" then
					message = string.upper(yazi)..string.sub(message, 2, #message)
				end
				if string.sub(message, -1) ~= "." then
					message = message .. "."
				end
			end

			local playerid = getElementData(thePlayer, "playerid")
			local targetid = getElementData(targetPlayer, "playerid")

			outputChatBox(">> (" .. targetid .. ") " .. targetPlayerName ..targetUsername.. ": " .. message, thePlayer, 255, 194, 14, true)
			if getElementData(targetPlayer, "afk") then
				exports.cr_infobox:addBox(thePlayer, "info", "Mesaj göndermeye çalıştığınız oyuncu ALT-TAB durumunda, ancak mesajınız iletildi.")
			end
		
			outputChatBox("<< (" .. playerid .. ") " .. playerName ..username .. ": " .. message, targetPlayer, 255, 255, 0, true)

			triggerClientEvent(targetPlayer, "pmClient", targetPlayer)
			triggerClientEvent(thePlayer, "pmClient", thePlayer)

			local received = {}
			received[thePlayer] = true
			received[targetPlayer] = true
			for key, value in pairs(getElementsByType("player")) do
				if isElement(value) and not received[value] then
					local listening = getElementData(value, "bigears")
					if listening == thePlayer or listening == targetPlayer then
						received[value] = true
						outputChatBox("(" .. playerid .. ") " .. playerName .. " -> (" .. targetid .. ") " .. targetPlayerName .. ": " .. message, value, 255, 255, 0)
						triggerClientEvent(value,"pmClient",value)
					end
				end
			end

			if senderPmPerk and tonumber(senderPmState) == 1 and not (getElementData(targetPlayer, "reportadmin") == thePlayer) then -- if sender has pms off.
				outputChatBox("[!]#FFFFFF Özel mesajlarınız kapalı iken özel mesaj attınız, cevap için ÖM'nizi açmalısınız.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("pm", pmPlayer, false, false)
addCommandHandler("om", pmPlayer, false, false)
addCommandHandler("quickreply", pmPlayer, false, false)

function localOOC(thePlayer, commandName, ...)
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if (logged==1) and not (isPedDead(thePlayer)) then
		local muted = getElementData(thePlayer, "muted")
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		elseif (muted==1) then
			outputChatBox("Global OOC’dan sustunuz.", thePlayer, 255, 0, 0)
		else
			local r, b, g = 220, 220, 220
			if exports.cr_integration:isPlayerManagement(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and not getElementData(thePlayer, "supervising") then
				r,b , g = 0, 185, 255
				setElementData(thePlayer, "supervisorBchat", false)
			elseif exports.cr_integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and not getElementData(thePlayer, "supervising") then
				r, b, g = 85, 155, 255
				setElementData(thePlayer, "supervisorBchat", false)
			elseif exports.cr_integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 and getElementData(thePlayer, "supervising") then
				r, b, g = 100, 149, 237
				setElementData(thePlayer, "supervisorBchat", true)
			elseif exports.cr_integration:isPlayerHelper(thePlayer) and getElementData(thePlayer, "supervising") then
				r, b, g = 100, 149, 237
				setElementData(thePlayer, "supervisorBchat", true)
			elseif exports.cr_integration:isPlayerHelper(thePlayer) and not getElementData(thePlayer, "supervising") then
				r, b, g = 196, 255, 255
				setElementData(thePlayer, "supervisorBchat", false)
			end
			local playerName = getPlayerName(thePlayer):gsub("_", " ")
			
			if (dimension >= 1 and interior >= 1) then
				local dbid, entrance, exit, interiorType, interiorElement = exports["cr_interior"]:findProperty(thePlayer)
				if interiorElement then
					--ooc setting
					ooc = getElementData(interiorElement, "interiorsettings").ooc
					if ooc then
						--exports.cr_hud:sendBottomNotification(thePlayer, "OOC Chat Pasif!", "Bulunduğunuz mülkün sahibi bu mülkte OOC chat kullanmasını yasaklamış!")
						return
					end
				end
			end

			local message = table.concat({...}, " ")

			if getPlayerMaskState(thePlayer) then
				playerName = "Gizli [>" .. getElementData(thePlayer, "dbid") .. "]"
			else
				playerName = getPlayerName(thePlayer)
			end

			local sending = "#ccffff[OOC]#ccffff " .. playerName .. "#ccffff: (( " .. message .. " ))"
			local element= thePlayer

			if getElementData(thePlayer, "imla") then
				local yazi = string.sub(message, 1, 1)
				if type(yazi) == "string" then
					message = string.upper(yazi)..string.sub(message, 2, #message)
				end
				if string.sub(message, -1) ~= "." then
					message = message .. "."
				end
			end

			if exports.cr_integration:isPlayerHelper(element) and element:getData("duty_supporter") == 1 and element:getData("hiddenadmin") == 0 and not element:getData("supervising") then
				sending = "#ccffff[OOC]#00FF00 " .. playerName .. "#ccffff: (( " .. message .. " ))"
				exports.cr_discord:sendMessage("oocchat-log","**[OOC]** " .. playerName .. ": **" .. message .. "**")
			end
			
			if exports.cr_integration:isPlayerTrialAdmin(element) and element:getData("duty_admin") == 1 and element:getData("hiddenadmin") == 0 and not element:getData("supervising") then
				sending = "#ccffff[OOC]#FF0000 " .. playerName .. "#ccffff: (( " .. message .. " ))"
				exports.cr_discord:sendMessage("oocchat-log","**[OOC]** " .. playerName .. ": **" .. message .. "**")
			end
			
			if getElementData(thePlayer, "supervisorBchat") == false or nil then
				result, affectedElements = exports.cr_global:sendLocalText(thePlayer, sending, r,b,g)
				exports.cr_discord:sendMessage("oocchat-log","**[OOC]** " .. playerName .. ": **" .. message .. "**")
			else
				result, affectedElements = exports.cr_global:sendLocalText(thePlayer, sending, r,b,g)
				exports.cr_discord:sendMessage("oocchat-log","**[OOC]** " .. playerName .. ": **" .. message .. "**")
			end
		end
	end
end
addCommandHandler("b", localOOC, false, false)
addCommandHandler("LocalOOC", localOOC)

function districtIC(thePlayer, commandName, ...)
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if (logged==1) and not (isPedDead(thePlayer)) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local playerName = getPlayerName(thePlayer)
			local message = table.concat({...}, " ")
			local zonename = exports.cr_global:getElementZoneName(thePlayer)
			local x, y = getElementPosition(thePlayer)

			for key, value in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
				local playerzone = exports.cr_global:getElementZoneName(value)
				local playerdimension = getElementDimension(value)
				local playerinterior = getElementInterior(value)

				if (zonename==playerzone) and (dimension==playerdimension) and (interior==playerinterior) and getDistanceBetweenPoints2D(x, y, getElementPosition(value)) < 200 then
					local logged = getElementData(value, "loggedin")
					if (logged==1) then
						table.insert(affectedElements, value)
						if exports.cr_integration:isPlayerTrialAdmin(value) then
							outputChatBox("Bölge IC: " .. message .. " ((" ..  playerName  .. "))", value, 255, 255, 255)
						else
							outputChatBox("Bölge IC: " .. message, value, 255, 255, 255)
						end
					end
				end
			end
			exports.cr_logs:dbLog(thePlayer, 13, affectedElements, message)
		end
	end
end
--addCommandHandler("district", districtIC, false, false)

function localDo(thePlayer, commandName, ...)
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if logged==1 then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Action/Event]", thePlayer, 255, 194, 14)
		else
			local message = table.concat({...}, " ")
			--exports.cr_logs:logMessage("[IC: Local Do] * " .. message .. " *      ((" .. getPlayerName(thePlayer) .. "))", 19)
			local result, affectedElements = exports.cr_global:sendLocalDoAction(thePlayer, message, true)
			exports.cr_logs:dbLog(thePlayer, 14, affectedElements, message)
		end
	end
end
addCommandHandler("do", localDo, false, false)


function localShout(thePlayer, commandName, ...)
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end
	local affectedElements = { }
	table.insert(affectedElements, thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)

	if not (isPedDead(thePlayer)) and (logged==1) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		else
			local playerName = getPlayerName(thePlayer)
			local time = getRealTime()


			local message = trunklateText(thePlayer, table.concat({...}, " "))
			local r, g, b = 255, 255, 255
			local focus = getElementData(thePlayer, "focus")
			if type(focus) == "table" then
				for player, color in pairs(focus) do
					if player == thePlayer then
						r, g, b = unpack(color)
					end
				end
			end
			outputChatBox(playerName .. " (Bağırma): " .. message .. "!", thePlayer, r, g, b)
			--icChatsToVoice(thePlayer, message, thePlayer)
			--exports.cr_logs:logMessage("[IC: Local Shout] " .. playerName .. ": " .. message, 1)
			for index, nearbyPlayer in ipairs(getElementsByType("player")) do
				if getElementDistance(thePlayer, nearbyPlayer) < 40 then
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

					if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) and (nearbyPlayer~=thePlayer) then
						local logged = getElementData(nearbyPlayer, "loggedin")

						if (logged==1) and not (isPedDead(nearbyPlayer)) then
							local message2 = message
							message2 = trunklateText(nearbyPlayer, message2)
							local r, g, b = 255, 255, 255
							local focus = getElementData(nearbyPlayer, "focus")
							if type(focus) == "table" then
								for player, color in pairs(focus) do
									if player == thePlayer then
										r, g, b = unpack(color)
									end
								end
							end
							outputChatBox(playerName .. " (Bağırma): " .. message2 .. "!", nearbyPlayer, r, g, b)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("s", localShout, false, false)

function megaphoneShout(thePlayer, commandName, ...)
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")
	local dimension = getElementDimension(thePlayer)
	local interior = getElementInterior(thePlayer)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	local seat = getPedOccupiedVehicleSeat(thePlayer)

	if not (isPedDead(thePlayer)) and (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local factionID = getElementData(thePlayer, "faction") or -1

		if factionID == 1 or factionID == 3 then
			local affectedElements = { }

			if not (...) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
			else
				local playerName = getPlayerName(thePlayer)
				local message = trunklateText(thePlayer, table.concat({...}, " "))

				for index, nearbyPlayer in ipairs(getElementsByType("player")) do
					if getElementDistance(thePlayer, nearbyPlayer) < 40 then
						local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
						local nearbyPlayerInterior = getElementInterior(nearbyPlayer)

						if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
							local logged = getElementData(nearbyPlayer, "loggedin")

							if (logged==1) and not (isPedDead(nearbyPlayer)) then
								local message2 = message
							
								table.insert(affectedElements, nearbyPlayer)
								outputChatBox("((" .. getPlayerName(thePlayer):gsub("_", " ") .. ")) Megafon <O: " .. trunklateText(nearbyPlayer, message2), nearbyPlayer, 255, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("m", megaphoneShout, false, false)

local togState = { }
function toggleFaction(thePlayer, commandName, State)
	local pF = getElementData(thePlayer, "faction")
	local fL = getElementData(thePlayer, "factionleader")
	local theTeam = getPlayerTeam(thePlayer)

	if fL == 1 then
		if togState[pF] == false or not togState[pF] then
			togState[pF] = true
			for index, arrayPlayer in ipairs(getElementsByType("player")) do
				if isElement(arrayPlayer) then
					if getPlayerTeam(arrayPlayer) == theTeam and getElementData(thePlayer, "loggedin") == 1 then
						outputChatBox("[" .. getTeamName(getPlayerTeam(thePlayer)) .. "] OOC birlik sohbeti devre dışı bırakıldı.", arrayPlayer, 255, 0, 0)
					end
				end
			end
		else
			togState[pF] = false
			for index, arrayPlayer in ipairs(getElementsByType("player")) do
				if isElement(arrayPlayer) then
					if getPlayerTeam(arrayPlayer) == theTeam and getElementData(thePlayer, "loggedin") == 1 then
						outputChatBox("[" .. getTeamName(getPlayerTeam(thePlayer)) .. "] OOC birlik sohbeti açıldı.", arrayPlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("togglef", toggleFaction)
addCommandHandler("togf", toggleFaction)

function toggleFactionSelf(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) then
		local factionBlocked = getElementData(thePlayer, "chat-system:blockF")

		if (factionBlocked==1) then
			setElementData(thePlayer, "chat-system:blockF", 0, false)
			outputChatBox("Grup sohbeti artık kendiniz için etkin.", thePlayer, 0, 255, 0)
		else
			setElementData(thePlayer, "chat-system:blockF", 1, false)
			outputChatBox("Grup sohbeti artık kendiniz için devre dışı.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togglefactionchat", toggleFactionSelf)
addCommandHandler("togglefaction", toggleFactionSelf)
addCommandHandler("togfaction", toggleFactionSelf)

function factionOOC(thePlayer, commandName, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [İleti]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			
			if not (theTeam) or (theTeamName == "Citizen") then
				outputChatBox("[!]#FFFFFF Herhangi bir birlikte bulunmuyorsunuz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end
			
			local playerName = getPlayerName(thePlayer)
			local playerFaction = getElementData(thePlayer, "faction")
			local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
			local ranks = getElementData(theTeam, "ranks")
			local factionRankTitle = ranks[factionRank] or "Bilinmiyor"

			local affectedElements = { }
			table.insert(affectedElements, theTeam)
			local message = table.concat({...}, " ")

			if (togState[playerFaction]) == true then
				return
			end

			if getElementData(thePlayer, "imla") then
				local yazi = string.sub(message, 1, 1)
				if type(yazi) == "string" then
					message = string.upper(yazi)..string.sub(message, 2, #message)
				end
				if string.sub(message, -1) ~= "." then
					message = message .. "."
				end
			end

			for index, arrayPlayer in ipairs(getElementsByType("player")) do
				if isElement(arrayPlayer) then
					if getElementData(arrayPlayer, "bigearsfaction") == theTeam then
						outputChatBox("[" .. getTeamName(getPlayerTeam(thePlayer)) .. "] (" .. factionRankTitle .. ") " .. playerName .. ": " .. message, arrayPlayer, 249, 160, 41)
					elseif getPlayerTeam(arrayPlayer) == theTeam and getElementData(arrayPlayer, "loggedin") == 1 and getElementData(arrayPlayer, "chat-system:blockF") ~= 1 then
						table.insert(affectedElements, arrayPlayer)
						outputChatBox("[" .. getTeamName(getPlayerTeam(thePlayer)) .. "] (" .. factionRankTitle .. ") " .. playerName .. ": " .. message, arrayPlayer, 249, 160, 41)
					end
				end
			end
		end
	end
end
addCommandHandler("f", factionOOC, false, false)
addCommandHandler("Birlik", factionOOC)

--HQ CHAT FOR PD / Farid
function sfpdHq(thePlayer, commandName, ...)
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")

	if (factionType == 2) then
		local message = table.concat({...}, " ")
		local factionID = tonumber(getElementData(thePlayer, "faction"))

		if not exports.cr_faction:isPlayerFactionLeader(thePlayer, factionID) then
			outputChatBox("Bu komutu kullanma izniniz yok.", thePlayer, 255, 0, 0)
		elseif #message == 0 then
			outputChatBox("KULLANIM: /hq [Mesaj]", thePlayer, 255, 194, 14)
		else

			local teamPlayers = getPlayersInTeam(theTeam)
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local username = getPlayerName(thePlayer)

				for key, value in ipairs(teamPlayers) do
				triggerClientEvent (value, "playHQSound", getRootElement())
				outputChatBox("HQ: " ..  (factionRankTitle or "") .. " " ..  username  .. ": " ..  message  .. "", value, 0, 197, 205)
			end
		end
	end
end
addCommandHandler("hq", sfpdHq)

function factionLeaderOOC(thePlayer, commandName, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [İleti]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local theTeamName = getTeamName(theTeam)
			
			if not (theTeam) or (theTeamName == "Citizen") then
				outputChatBox("[!]#FFFFFF Herhangi bir birlikte bulunmuyorsunuz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end
			
			local playerName = getPlayerName(thePlayer)
			local playerFaction = getElementData(thePlayer, "faction")
			local factionRank = tonumber(getElementData(thePlayer, "factionrank"))
			local ranks = getElementData(theTeam, "ranks")
			local factionRankTitle = ranks[factionRank] or "Bilinmiyor"

			local affectedElements = {}
			table.insert(affectedElements, theTeam)
			local message = table.concat({...}, " ")

			if (togState[playerFaction]) == true then
				return
			end

			if getElementData(thePlayer, "imla") then
				local yazi = string.sub(message, 1, 1)
				if type(yazi) == "string" then
					message = string.upper(yazi)..string.sub(message, 2, #message)
				end
				if string.sub(message, -1) ~= "." then
					message = message .. "."
				end
			end

			for index, arrayPlayer in ipairs(getElementsByType("player")) do
				if isElement(arrayPlayer) then
					if getElementData(arrayPlayer, "bigearsfaction") == theTeam then
						outputChatBox("[" .. getTeamName(getPlayerTeam(thePlayer)) .. "] (" .. factionRankTitle .. ") " .. playerName .. ": " .. message, arrayPlayer, 176, 115, 52)
					elseif getPlayerTeam(arrayPlayer) == theTeam and getElementData(arrayPlayer, "loggedin") == 1 and getElementData(arrayPlayer, "chat-system:blockF") ~= 1 and getElementData(arrayPlayer, "factionleader") == 1 then
						table.insert(affectedElements, arrayPlayer)
						outputChatBox("[" .. getTeamName(getPlayerTeam(thePlayer)) .. "] (" .. factionRankTitle .. ") " .. playerName .. ": " .. message, arrayPlayer, 176, 115, 52)
					end
				end
			end
		end
	end
end
addCommandHandler("fl", factionLeaderOOC, false, false)

local goocTogState = false
function togGovOOC(thePlayer, theCommand)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer)) then
		if (goocTogState == false) then
			outputChatBox("Hükümet OOC şimdi devre dışı bırakıldı.", thePlayer, 0, 255, 0)
			goocTogState = true
		elseif (goocTogState == true) then
			outputChatBox("Hükümet OOC'si etkinleştirildi.", thePlayer, 0, 255, 0)
			goocTogState = false
		else
			outputChatBox("[TG-G-C-ERR-545] Please report on mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("toggovooc", togGovOOC)
addCommandHandler("toggooc", togGovOOC)

function togGovOOCSelf(thePlayer, theCommand)
	local logged = getElementData(thePlayer, "loggedin")
	local team = getPlayerTeam(thePlayer)
	if (getTeamName(team) == "Los Santos Fire Department") or (getTeamName(team) == "Los Santos Police Department") or (getTeamName(team) == "Los Santos Government") or (getTeamName(team) == "San Andreas Highway Patrol") or (getTeamName(team) == "Superior Court of San Andreas") or (getTeamName(team) == "Federal Aviation Administration") and (logged==1) then
		local selfState = getElementData(thePlayer, "chat.togGovOOCSelf") or false
		if (selfState == false) then
			outputChatBox("Hükümet OOC şimdi kendiniz için devre dışı bırakıldı.  " .. tostring(theCommand) .. "", thePlayer, 0, 255, 0)
			setElementData(thePlayer, "chat.togGovOOCSelf", true)
		elseif (selfState == true) then
			outputChatBox("Hükümet OOC kendiniz için etkinleştirildi.", thePlayer, 0, 255, 0)
			setElementData(thePlayer, "chat.togGovOOCSelf", false)
		else
			outputChatBox("[TG-G-C-ERR-546] Please report on mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("toggov", togGovOOCSelf)

function setRadioChannel(thePlayer, commandName, slot, channel)
	slot = tonumber(slot)
	channel = tonumber(channel)

	if not channel then
		channel = slot
		slot = 1
	end

	if not (channel) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Radio Slot] [Channel Number]", thePlayer, 255, 194, 14)
	else
		if (exports.cr_global:hasItem(thePlayer, 6)) then
			local count = 0
			local items = exports['cr_items']:getItems(thePlayer)
			for k, v in ipairs(items) do
				if v[1] == 6 then
					count = count + 1
					if count == slot then
						if v[2] > 0 then
							local isRestricted, factionID = isThisFreqRestricted(channel)
							local playerFaction = getElementData(thePlayer, "faction")

							if channel > 1 and channel < 1000000000 and (not isRestricted or (tonumber(playerFaction) == tonumber(factionID)))then
								if exports['cr_items']:updateItemValue(thePlayer, k, channel) then
									outputChatBox("Radyonuzu kanala yeniden bağladınız #" .. channel .. ".", thePlayer)
									triggerEvent('sendAme', thePlayer, "telsizlerini dinler.")
								end
							else
								outputChatBox("Radyonuzu bu frekansa ayarlayamazsınız.!", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("Radyonuz kapalı. ((/toggleradio))", thePlayer, 255, 0, 0)
						end
						return
					end
				end
			end
			outputChatBox("O kadar çok telsizin yok.", thePlayer, 255, 0, 0)
		else
			outputChatBox("Radyon yok!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("tuneradio", setRadioChannel, false, false)

function toggleRadio(thePlayer, commandName, slot)
	if (exports.cr_global:hasItem(thePlayer, 6)) then
		local slot = tonumber(slot)
		local items = exports['cr_items']:getItems(thePlayer)
		local titemValue = false
		local count = 0
		for k, v in ipairs(items) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						titemValue = v[2]
						break
					end
				else
					titemValue = v[2]
					break
				end
			end
		end

		-- gender switch for /me
		local genderm = getElementData(thePlayer, "gender") == 1 and "her" or "his"

		if titemValue < 0 then
			outputChatBox("Radyonuzu açtınız.", thePlayer, 255, 194, 14)
			triggerEvent('sendAme', thePlayer, "" .. genderm .. " telsizini açar.")
		else
			outputChatBox("Radyonuzu kapattınız.", thePlayer, 255, 194, 14)
			triggerEvent('sendAme', thePlayer, "" .. genderm .. " telsizini kapatır.")
		end

		local count = 0
		for k, v in ipairs(items) do
			if v[1] == 6 then
				if slot then
					count = count + 1
					if count == slot then
						exports['cr_items']:updateItemValue(thePlayer, k, (titemValue < 0 and 1 or -1) * math.abs(v[2] or 1))
						break
					end
				else
					exports['cr_items']:updateItemValue(thePlayer, k, (titemValue < 0 and 1 or -1) * math.abs(v[2] or 1))
				end
			end
		end
	else
		outputChatBox("Radyon yok!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("toggleradio", toggleRadio, false, false)

-- Misc
local function sortTable(a, b)
	if b[2] < a[2] then
		return true
	end

	if b[2] == a[2] and b[4] > a[4] then
		return true
	end

	return false
end

function managementChat(thePlayer, commandName, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if exports.cr_integration:isPlayerManagement(thePlayer) then
			if (...) then
				if getElementData(thePlayer, "hideu") then
					setElementData(thePlayer, "hideu", false)
					outputChatBox("[!]#FFFFFF Yönetim sohbet kapalı olduğu için otomatik olarak açıldı.", thePlayer, 0, 255, 0, true)
				end
				local message = table.concat({...}, " ")
				local accountName = getElementData(thePlayer, "account:username")
				for i, player in ipairs(getElementsByType("player")) do
					if exports.cr_integration:isPlayerManagement(player) then
						local hideu = getElementData(player, "hideu") or false
						if not hideu then
							outputChatBox("[ÜYK] " .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " (" .. accountName .. "): " .. message, player, 204, 102, 255)
						end
					end
				end
				exports.cr_discord:sendMessage("uchat-log", "**[ÜYK]** **" .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " (" .. accountName .. ")**: " .. message)
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [İleti]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	end
end
addCommandHandler("u", managementChat)

function staffChat(thePlayer, commandName, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
			if (...) then
				if getElementData(thePlayer, "hidea") then
					setElementData(thePlayer, "hidea", false)
					outputChatBox("[!]#FFFFFF Yetkili sohbet kapalı olduğu için otomatik olarak açıldı.", thePlayer, 0, 255, 0, true)
				end
				local message = table.concat({...}, " ")
				local accountName = getElementData(thePlayer, "account:username")
				for i, player in ipairs(getElementsByType("player")) do
					if exports.cr_integration:isPlayerTrialAdmin(player) then
						local hidea = getElementData(player, "hidea") or false
						if not hidea then
							outputChatBox("[ADM] " .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " (" .. accountName .. "): " .. message, player, 51, 255, 102)
						end
					end
				end
				exports.cr_discord:sendMessage("achat-log", "**[ADM]** **" .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " (" .. accountName .. ")**: " .. message)
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [İleti]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	end
end
addCommandHandler("a", staffChat)

function helperChat(thePlayer, commandName, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if exports.cr_integration:isPlayerHelper(thePlayer) or exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
			if (...) then
				if getElementData(thePlayer, "hideg") then
					setElementData(thePlayer, "hideg", false)
					outputChatBox("[!]#FFFFFF Rehber sohbet kapalı olduğu için otomatik olarak açıldı.", thePlayer, 0, 255, 0, true)
				end
				local message = table.concat({...}, " ")
				local accountName = getElementData(thePlayer, "account:username")
				for i, player in ipairs(getElementsByType("player")) do
					if exports.cr_integration:isPlayerHelper(player) or exports.cr_integration:isPlayerTrialAdmin(player) then
						local hideg = getElementData(player, "hideg") or false
						if not hideg then
							outputChatBox("[RHB] " .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " (" .. accountName .. "): " .. message, player, 255, 100, 150)
						end
					end
				end
				exports.cr_discord:sendMessage("gchat-log", "**[RHB]** **" .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " (" .. accountName .. ")**: " .. message)
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [İleti]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	end
end
addCommandHandler("g", helperChat)

function sendInterserverChatMessage(message)
	if message then
		for _, player in ipairs(getElementsByType("player")) do
			if exports.cr_integration:isPlayerHelper(player) or exports.cr_integration:isPlayerTrialAdmin(player) then
				local hidesa = getElementData(player, "hidesa") or false
				if not hidesa then
					outputChatBox(message, player, 255, 212, 59)
				end
			end
		end
		return "SUCCESS"
	end
	return false
end

function interserverChat(thePlayer, commandName, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if exports.cr_integration:isPlayerHelper(thePlayer) or exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
			if (...) then
				if getElementData(thePlayer, "hidesa") then
					setElementData(thePlayer, "hidesa", false)
					outputChatBox("[!]#FFFFFF Sunucular arası sohbet kapalı olduğu için otomatik olarak açıldı.", thePlayer, 0, 255, 0, true)
				end
				
				local message = table.concat({...}, " ")
				for _, player in ipairs(getElementsByType("player")) do
					if exports.cr_integration:isPlayerHelper(player) or exports.cr_integration:isPlayerTrialAdmin(player) then
						local hidesa = getElementData(player, "hidesa") or false
						if not hidesa then
							outputChatBox("[CRP] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. ": " .. message, player, 116, 192, 252)
						end
					end
				end
				
				callRemote("185.160.30.248:22005", getResourceName(getThisResource()), "sendInterserverChatMessage", function(responseData, errorID)
					responseData = tostring(responseData)
					if responseData == "ERROR" then
						outputDebugString("callRemote: ERROR #" .. errorID)
					elseif responseData ~= "SUCCESS" then
						outputDebugString("callRemote: Unexpected reply: " .. responseData)
					end
				end, "[CRP] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. ": " .. message)
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [İleti]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	end
end
addCommandHandler("sa", interserverChat, false, false)

function toggleInterserverChat(thePlayer, commandName)
	if exports.cr_integration:isPlayerHelper(thePlayer) or exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local hidesa = getElementData(thePlayer, "hidesa") or false
		setElementData(thePlayer, "hidesa", not hidesa)
		outputChatBox("[!]#FFFFFF Sunucular arası sohbet başarıyla " .. (hidesa and "aktif ettiniz" or "gizlediniz") .. ".", thePlayer, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("togsa", toggleInterserverChat, false, false)
addCommandHandler("togglesa", toggleInterserverChat, false, false)

function toggleUYKChat(thePlayer, commandName)
	if exports.cr_integration:isPlayerManagement(thePlayer) then
		local hideu = getElementData(thePlayer, "hideu") or false
		setElementData(thePlayer, "hideu", not hideu)
		outputChatBox("[!]#FFFFFF Yönetim sohbetini başarıyla " .. (hideu and "aktif ettiniz" or "gizlediniz") .. ".", thePlayer, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("togu", toggleUYKChat, false, false)
addCommandHandler("toggleu", toggleUYKChat, false, false)

function toggleAdminChat(thePlayer, commandName)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local hidea = getElementData(thePlayer, "hidea") or false
		setElementData(thePlayer, "hidea", not hidea)
		outputChatBox("[!]#FFFFFF Yetkili sohbetini başarıyla " .. (hidea and "aktif ettiniz" or "gizlediniz") .. ".", thePlayer, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("toga", toggleAdminChat, false, false)
addCommandHandler("togglea", toggleAdminChat, false, false)

function toggleHelperChat(thePlayer, commandName)
	if exports.cr_integration:isPlayerHelper(thePlayer) or exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		local hideg = getElementData(thePlayer, "hideg") or false
		setElementData(thePlayer, "hideg", not hideg)
		outputChatBox("[!]#FFFFFF Rehber sohbetini başarıyla " .. (hideg and "aktif ettiniz" or "gizlediniz") .. ".", thePlayer, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("togg", toggleHelperChat, false, false)
addCommandHandler("toggleg", toggleHelperChat, false, false)
addCommandHandler("togh", toggleHelperChat, false, false)
addCommandHandler("toggleh", toggleHelperChat, false, false)

function toggleOOC(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) and (exports.cr_integration:isPlayerDeveloper(thePlayer)) then
		local players = exports.cr_pool:getPoolElementsByType("player")
		local oocEnabled = exports.cr_global:getOOCState()
		if (commandName == "togooc") then
			if (oocEnabled==0) then
				exports.cr_global:setOOCState(1)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")

					if	(logged==1) then
						outputChatBox("[!]#FFFFFF OOC sohbeti yönetici tarafından etkinleştirild.", arrayPlayer, 0, 255, 0, true)
					end
				end
			elseif (oocEnabled==1) then
				exports.cr_global:setOOCState(0)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")

					if	(logged==1) then
						outputChatBox("[!]#FFFFFF OOC sohbeti yönetici tarafından devre dışı bırakıldı.", arrayPlayer, 255, 0, 0, true)
					end
				end
			end
		elseif (commandName == "stogooc") then
			if (oocEnabled==0) then
				exports.cr_global:setOOCState(1)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					local admin = getElementData(arrayPlayer, "admin_level")

					if	(logged==1) and (tonumber(admin)>0)then
						outputChatBox("[!]#FFFFFF OOC sohbet yönetici tarafından sessizce etkinleştirildi.", arrayPlayer, 0, 255, 0, true)
					end
				end
			elseif (oocEnabled==1) then
				exports.cr_global:setOOCState(0)

				for k, arrayPlayer in ipairs(players) do
					local logged = getElementData(arrayPlayer, "loggedin")
					local admin = getElementData(arrayPlayer, "admin_level")

					if (logged==1) and (tonumber(admin)>0)then
						outputChatBox("[!]#FFFFFF OOC sohbeti yönetici tarafından devre dışı bırakıldı.", arrayPlayer, 255, 0, 0, true)
					end
				end
			end
		end
	end
end
addCommandHandler("togooc", toggleOOC, false, false)
addCommandHandler("stogooc", toggleOOC, false, false)

function payPlayer(thePlayer, commandName, targetPlayerNick, amount)
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not (targetPlayerNick) or not (amount) or not tonumber(amount) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Kişi/ID] [Miktar]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)

			if targetPlayer then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)

				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)

				if (distance<=10) then
					amount = math.floor(math.abs(tonumber(amount)))

					local hoursplayed = getElementData(thePlayer, "hoursplayed")

					if (targetPlayer==thePlayer) then
						outputChatBox("[!]#FFFFFF Kendinize para ödeyemezsiniz.", thePlayer, 255, 0, 0, true)
					elseif amount == 0 then
						outputChatBox("[!]#FFFFFF 0'dan büyük bir miktar girmeniz gerekir.", thePlayer, 255, 0, 0, true)
					elseif (hoursplayed<5) and (amount>50) and not exports.cr_integration:isPlayerTrialAdmin(thePlayer) and not exports.cr_integration:isPlayerTrialAdmin(targetPlayer) and not exports.cr_integration:isPlayerHelper(thePlayer) and not exports.cr_integration:isPlayerHelper(targetPlayer) then
						outputChatBox("[!]#FFFFFF 50$'dan fazla transfer yapmadan 5 saat önce en az 5 saat oynamalısınız.", thePlayer, 255, 0, 0, true)
					elseif exports.cr_global:hasMoney(thePlayer, amount) then
						if hoursplayed < 5 and not exports.cr_integration:isPlayerTrialAdmin(targetPlayer) and not exports.cr_integration:isPlayerTrialAdmin(thePlayer) and not exports.cr_integration:isPlayerHelper(targetPlayer) and not exports.cr_integration:isPlayerHelper(thePlayer) then
							local totalAmount = (getElementData(thePlayer, "payAmount") or 0) + amount
							if totalAmount > 200 then
								outputChatBox("[!]#FFFFFF Beş dakikada yalnızca 200$ ödeyebilirsiniz.", thePlayer, 255, 0, 0, true)
								return
							end
							setElementData(thePlayer, "payAmount", totalAmount, false)
							setTimer(
								function(thePlayer, amount)
									if isElement(thePlayer) then
										local totalAmount = (getElementData(thePlayer, "payAmount") or 0) - amount
										setElementData(thePlayer, "payAmount", totalAmount <= 0 and false or totalAmount, false)
									end
								end,
								300000, 1, thePlayer, amount
							)
						end
						--exports.cr_logs:logMessage("[Money Transfer From " .. getPlayerName(thePlayer) .. " To: " .. targetPlayerName .. "] Value: " .. amount .. "$", 5)
						exports.cr_logs:dbLog(thePlayer, 25, targetPlayer, "PAY " .. amount)

						if (hoursplayed<5) then
							exports.cr_global:sendMessageToAdmins("AdmWarn: New Player '" .. getPlayerName(thePlayer) .. "' transferred $" .. exports.cr_global:formatMoney(amount) .. " to '" .. targetPlayerName .. "'.")
						end

						-- DEAL!
						exports.cr_global:takeMoney(thePlayer, amount)
						exports.cr_global:giveMoney(targetPlayer, amount)

						local gender = getElementData(thePlayer, "gender")
						local genderm = "his"
						if (gender == 1) then
							genderm = "her"
						end
						triggerEvent('sendAme', thePlayer, "elini cebine atar, cüzdanından birkaç miktar para alır ve " .. targetPlayerName .. "'e verir.")
						outputChatBox("[!]#FFFFFF " ..  exports.cr_global:formatMoney(amount) .. "$ parayı " .. targetPlayerName .. " isimli oyuncuya verdin.", thePlayer, 0, 255, 0, true)
						exports.cr_discord:sendMessage("paraver-log","**[PARAVER]** **" .. getPlayerName(thePlayer) .. "** isimli oyuncu **" .. targetPlayerName .. "** adlı kişiye **(" .. exports.cr_global:formatMoney(amount) .. "$)** para gönderdi.")
						outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " isimli oyuncu size " .. exports.cr_global:formatMoney(amount) .. "$ para verdi.", targetPlayer, 0, 255, 0, true)

						exports.cr_global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
					else
						outputChatBox("[!]#FFFFFF Yeterli paran yok.", thePlayer, 255, 0, 0, true)
					end
				else
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " kişisine çok uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("paraver", payPlayer, false, false)

function maskeCikart(thePlayer, commandName, targetPlayer)
		if not (targetPlayer) then 
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					
				else
				local x, y, z = getElementPosition(thePlayer)
		        local tx, ty, tz = getElementPosition(targetPlayer)
		        local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)

		    if (distance<=5) then
					local any = false
					local masks = exports['cr_items']:getMasks()
					for key, value in pairs(masks) do
						if getElementData(targetPlayer, value[1]) then
							any = true
							setElementData(targetPlayer, value[1], false, true)
							triggerEvent('sendAme', thePlayer, "sağ/sol ellerini kullanarak, " .. targetPlayerName .. " kişisinin maskesini çıkartır.")
						end
					end
					if any then
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("[*] Maskeniz " .. username.. " isimli kişi tarafından çıkartılmıştır.", targetPlayer, 255, 0, 0)
						else
							outputChatBox("[*] Maskeniz gizli bir yetkili tarafından çıkartılmıştır.", targetPlayer, 255, 0, 0)
						end
					else
						outputChatBox("[*] Oyuncu maskeli değil.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("maskecikart", maskeCikart, false, false)

addCommandHandler("zarat100", function(thePlayer)
	exports.cr_global:sendLocalText(thePlayer, "* " .. getPlayerName(thePlayer):gsub("_", " ") .. " zar attı. ((" .. math.random(1, 100) .. "))", 102, 255, 255)	
end)

function removeAnimation(thePlayer)
	exports.cr_global:removeAnimation(thePlayer)
end

-- /c(lose)
function localClose(thePlayer, commandName, ...)
	if exports['cr_freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	local logged = tonumber(getElementData(thePlayer, "loggedin"))

	if (logged==1) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		else
			local affectedElements = { }
			local name = getPlayerName(thePlayer)
			local message = table.concat({...}, " ")
			--exports.cr_logs:logMessage("[IC: Whisper] " .. name .. ": " .. message, 1)
			message = trunklateText(thePlayer, message)

			local playerCar = getPedOccupiedVehicle(thePlayer)
			for index, targetPlayers in ipairs(getElementsByType("player")) do
				if getElementDistance(thePlayer, targetPlayers) < 3 then
					local message2 = message
					local r, g, b = 255, 255, 255
					local focus = getElementData(targetPlayers, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == thePlayer then
								r, g, b = unpack(color)
							end
						end
					end
					local pveh = getPedOccupiedVehicle(targetPlayers)
					if playerCar then
						if not exports['cr_vehicle']:isVehicleWindowUp(playerCar) then
							if pveh then
								if playerCar == pveh then
									table.insert(affectedElements, targetPlayers)
									outputChatBox(name .. " (Kısık Ses): " .. message2, targetPlayers, r, g, b)
									--icChatsToVoice(targetPlayers, message2, thePlayer)
								elseif not (exports['cr_vehicle']:isVehicleWindowUp(pveh)) then
									table.insert(affectedElements, targetPlayers)
									outputChatBox(name .. " (Kısık Ses): " .. message2, targetPlayers, r, g, b)
									--icChatsToVoice(targetPlayers, message2, thePlayer)
								end
							else
								table.insert(affectedElements, targetPlayers)
								outputChatBox(name .. " (Kısık Ses): " .. message2, targetPlayers, r, g, b)
								--icChatsToVoice(targetPlayers, message2, thePlayer)
							end
						else
							if pveh then
								if pveh == playerCar then
									table.insert(affectedElements, targetPlayers)
									outputChatBox(name .. " (Kısık Ses): " .. message2, targetPlayers, r, g, b)
									--icChatsToVoice(targetPlayers, message2, thePlayer)
								end
							end
						end
					else
						if pveh then
							if playerCar then
								if playerCar == pveh then
									table.insert(affectedElements, targetPlayers)
									outputChatBox(name .. " (Kısık Ses): " .. message2, targetPlayers, r, g, b)
									--icChatsToVoice(targetPlayers, message2, thePlayer)
								end
							elseif not (exports['cr_vehicle']:isVehicleWindowUp(pveh)) then
								table.insert(affectedElements, targetPlayers)
								outputChatBox(name .. " (Kısık Ses): " .. message2, targetPlayers, r, g, b)
								--icChatsToVoice(targetPlayers, message2, thePlayer)
							end
						else
							table.insert(affectedElements, targetPlayers)
							outputChatBox(name .. " (Kısık Ses): " .. message2, targetPlayers, r, g, b)
							--icChatsToVoice(targetPlayers, message2, thePlayer)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("c", localClose, false, false)

function StartInterview(thePlayer, commandName, targetPartialPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		if(factionType==6)then -- news faction
			if not (targetPartialPlayer) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPartialPlayer)
				if targetPlayer then
					local targetLogged = getElementData(targetPlayer, "loggedin")
					if (targetLogged==1) then
						if(getElementData(targetPlayer,"interview"))then
							outputChatBox("Bu oyuncu zaten röportaj yapıyor.", thePlayer, 255, 0, 0)
						else
							setElementData(targetPlayer, "interview", true, false)
							local playerName = getPlayerName(thePlayer)
							outputChatBox(playerName  .. " röportaj için teklif etti.", targetPlayer, 0, 255, 0)
							outputChatBox("(( Görüşme sırasında konuşmak için /i kullanın. ))", targetPlayer, 0, 255, 0)
							local NewsFaction = getPlayersInTeam(getPlayerTeam(thePlayer))
							for key, value in ipairs(NewsFaction) do
								outputChatBox("(( " ..  playerName  .. " " .. targetPlayerName .. " kişisini röportaja davet ettin. ))", value, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("interview", StartInterview, false, false)

function endInterview(thePlayer, commandName, targetPartialPlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		if(factionType==6)then -- news faction
			if not (targetPartialPlayer) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPartialPlayer)
				if targetPlayer then
					local targetLogged = getElementData(targetPlayer, "loggedin")
					if (targetLogged==1) then
						if not(getElementData(targetPlayer,"interview"))then
							outputChatBox("Bu oyuncu ile röportaj yapılmadı.", thePlayer, 255, 0, 0)
						else
							setElementData(targetPlayer, "interview", false, false)
							local playerName = getPlayerName(thePlayer)
							outputChatBox(playerName  .. " görüşmeniz sona erdi.", targetPlayer, 255, 0, 0)

							local NewsFaction = getPlayersInTeam(getPlayerTeam(thePlayer))
							for key, value in ipairs(NewsFaction) do
								outputChatBox("(( " ..  playerName  .. " " .. targetPlayerName .. " kişinin röportajı sona erdi. ))", value, 255, 0, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("endinterview", endInterview, false, false)

function interviewChat(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	if (logged==1) then
		if(getElementData(thePlayer, "interview"))then
			if not(...)then
				outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
			else
				local message = table.concat({...}, " ")
				local name = getPlayerName(thePlayer)

				local finalmessage = "[LSN] Röportaj Misafir " .. name  .. ": " ..  message
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				if (factionType == 6) then -- news faction
					finalmessage = "[LSN] " .. name  .. ": " ..  message
				end

				for key, value in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
					if (getElementData(value, "loggedin")==1) then
						if not (getElementData(value, "tognews")==1) then
							outputChatBox(finalmessage, value, 200, 100, 200)
						end
					end
				end
				exports.cr_logs:dbLog(thePlayer, 23, thePlayer, "NEWS " .. message)
				exports.cr_global:giveMoney(getTeamFromName("Los Santos Network"), 200)
			end
		end
	end
end
addCommandHandler("i", interviewChat, false, false)

-- /charity
function charityCash(thePlayer, commandName, amount)
	if not (amount) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Amount]", thePlayer, 255, 194, 14)
	else
		local donation = tonumber(amount)
		if (donation<=0) then
			outputChatBox("Sıfırdan büyük bir miktar girmelisiniz.", thePlayer, 255, 0, 0)
		else
			if not exports.cr_global:takeMoney(thePlayer, donation) then
				outputChatBox("Çıkarılacak o kadar paran yok.", thePlayer, 255, 0, 0)
			else
				outputChatBox("$" ..  exports.cr_global:formatMoney(donation)  .. " değerinde bağış yaptın.", thePlayer, 0, 255, 0)
				exports.cr_global:sendMessageToAdmins("AdmWrn: " ..getPlayerName(thePlayer).. " bağış yaptı $" ..exports.cr_global:formatMoney(donation))
				exports.cr_logs:dbLog(thePlayer, 25, thePlayer, "CHARITY $" .. amount)
			end
		end
	end
end
addCommandHandler("charity", charityCash, false, false)

-- /bigears
function bigEars(thePlayer, commandName, targetPlayerNick)
	if exports.cr_integration:isPlayerGameAdmin(thePlayer) then
		local current = getElementData(thePlayer, "bigears")
		if not current and not targetPlayerNick then
			outputChatBox("KULLANIM: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
		elseif current and not targetPlayerNick then
			setElementData(thePlayer, "bigears", false, false)
			outputChatBox("Büyük Kulaklar kapalı.", thePlayer, 255, 0, 0)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)

			if targetPlayer then
				outputChatBox("Şimdi dinleniyor " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
				exports.cr_logs:dbLog(thePlayer, 4, targetPlayer, "BIGEARS " .. targetPlayerName)
				setElementData(thePlayer, "bigears", targetPlayer, false)
			end
		end
	end
end
addCommandHandler("bigears", bigEars)

function removeBigEars()
	for key, value in pairs(getElementsByType("player")) do
		if isElement(value) and getElementData(value, "bigears") == source then
			setElementData(value, "bigears", false, false)
			outputChatBox("Büyük Kulaklar kapalı (Oyuncu Çıktı).", value, 255, 0, 0)
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), removeBigEars)

function bigEarsFaction(thePlayer, commandName, factionID)
	if exports.cr_integration:isPlayerGameAdmin(thePlayer) then
		factionID = tonumber(factionID)
		local current = getElementData(thePlayer, "bigearsfaction")
		if not current and not factionID then
			outputChatBox("KULLANIM: /" .. commandName .. " [faction id]", thePlayer, 255, 194, 14)
		elseif current and not factionID then
			setElementData(thePlayer, "bigearsfaction", false, false)
			outputChatBox("Büyük Kulaklar kapalı.", thePlayer, 255, 0, 0)
		else
			local team = exports.cr_pool:getElement("team", factionID)
			if not team then
				outputChatBox("Böyle bir birlik bulunamadı.", thePlayer, 255, 0, 0)
			else
				outputChatBox("" .. getTeamName(team) .. " şimdi dinle.", thePlayer, 0, 255, 0)
				setElementData(thePlayer, "bigearsfaction", team, false)
			end
		end
	end
end
addEvent("factions:listenFaction", true)
addEventHandler("factions:listenFaction", root, bigEarsFaction)
addCommandHandler("bigearsf", bigEarsFaction)

function disableMsg(message, player)
	cancelEvent()
	-- send it using 	our own PM etiquette instead
	pmPlayer(source, "pm", player, message)
end
addEventHandler("onPlayerPrivateMessage", getRootElement(), disableMsg)

-- /focus
function focus(thePlayer, commandName, targetPlayer, r, g, b)
	local focus = getElementData(thePlayer, "focus")
	if targetPlayer then
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			if type(focus) ~= "table" then
				focus = {}
			end

			if focus[targetPlayer] and not r then
				outputChatBox("Vurgulamayı bıraktın " .. string.format("#%02x%02x%02x", unpack(focus[targetPlayer])) .. targetPlayerName .. "#ffc20e.", thePlayer, 255, 194, 14, true)
				focus[targetPlayer] = nil
			else
				color = {tonumber(r) or math.random(63,255), tonumber(g) or math.random(63,255), tonumber(b) or math.random(63,255)}
				for _, v in ipairs(color) do
					if v < 0 or v > 255 then
						outputChatBox("Geçersiz renk: " .. v, thePlayer, 255, 0, 0)
						return
					end
				end

				focus[targetPlayer] = color
				outputChatBox("Şimdi vurguluyorsunuz " .. string.format("#%02x%02x%02x", unpack(focus[targetPlayer])) .. targetPlayerName .. "#00ff00.", thePlayer, 0, 255, 0, true)
			end
			setElementData(thePlayer, "focus", focus, false)
		end
	else
		if type(focus) == "table" then
			outputChatBox("İzliyorsun: ", thePlayer, 255, 194, 14)
			for player, color in pairs(focus) do
				outputChatBox("  " .. getPlayerName(player):gsub("_", " "), thePlayer, unpack(color))
			end
		end
		outputChatBox("Birini eklemek için, /" .. commandName .. " [player] [optional red/green/blue], to remove just /" .. commandName .. " [player] again.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("focus", focus)
addCommandHandler("highlight", focus)

addEventHandler("onPlayerQuit", root,
	function()
		for k, v in ipairs(getElementsByType("player")) do
			if v ~= source then
				local focus = getElementData(v, "focus")
				if focus and focus[source] then
					focus[source] = nil
					setElementData(v, "focus", focus, false)
				end
			end
		end
	end
)

-- START of /st and /togglest and /togst

function isPlayerStaff(thePlayer)
	--if exports.cr_integration:isPlayerHelper(thePlayer) then return true end
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then return true end
	if exports.cr_integration:isPlayerScripter(thePlayer) then return true end

	return false
end

function businessOOC(thePlayer, commandName, business, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if not business then
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
			outputChatBox("OR KULLANIM: /" .. commandName .. " [Business] [Mesaj]", thePlayer, 255, 194, 14)
		else
			local playerName = getPlayerName(thePlayer):gsub("_", " ")
			local message = table.concat({...}, " ")
			if tonumber(business) then
				business = tonumber(business)
			else
				message = business .. ' ' .. message
				business = 1
			end

			local b = exports.cr_business:getPlayerBusinesses(thePlayer) or { }
			local b = b[business]
			if b then
				local affectedElements = { }


				for index, arrayPlayer in ipairs(getElementsByType("player")) do
					if isElement(arrayPlayer) then
						if getElementData(arrayPlayer, "bigearsbusiness") == b then
							outputChatBox("((" .. exports.cr_business:getBusinessName(b) .. ")) " .. playerName .. ": " .. message, arrayPlayer, 3, 157, 157)
						elseif exports.cr_business:isPlayerInBusiness(arrayPlayer, b) and getElementData(arrayPlayer, "loggedin") == 1 and getElementData(arrayPlayer, "chat-system:blockB") ~= 1 then
							table.insert(affectedElements, arrayPlayer)
							outputChatBox("((" .. exports.cr_business:getBusinessName(b) .. ")) " .. playerName .. ": " .. message, arrayPlayer, 255, 150, 255)
						end
					end
				end
				exports.cr_logs:dbLog(thePlayer, 41, affectedElements, message)
			else
				outputChatBox('Alanda hiç işiniz yok ' .. business .. '.', thePlayer, 255, 100, 100)
			end
		end
	end
end
addCommandHandler("bu", businessOOC, false, false)

function toggleBusinessSelf(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if(logged==1) then
		local BusinessBlocked = getElementData(thePlayer, "chat-system:blockB")

		if (BusinessBlocked==1) then
			setElementData(thePlayer, "chat-system:blockB", 0, false)
			outputChatBox("İş sohbeti artık kendiniz için etkin.", thePlayer, 0, 255, 0)
		else
			setElementData(thePlayer, "chat-system:blockB", 1, false)
			outputChatBox("İş sohbeti artık kendiniz için devre dışı.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("togglebusinesschat", toggleBusinessSelf)
addCommandHandler("togglebusiness", toggleBusinessSelf)
addCommandHandler("togbusiness", toggleBusinessSelf)

function chatTemizle(thePlayer, commandName)
    if exports.cr_integration:isPlayerLeadAdmin(thePlayer) then
        for i = 0, 50 do
			outputChatBox(" ", root)
		end
    end
end
addCommandHandler("temizle", chatTemizle, false, false)

function cevreIC(thePlayer, commandName, ...)
	if exports.cr_integration:isPlayerManagement(thePlayer) then
		if (...) then
			local message = table.concat({ ... }, " ")
			outputChatBox(">> " .. message, root, 255, 194, 14)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("cevre", cevreIC, false, false)

local allowedFactions = {
	[1] = true,
}

function getDistanceFromElement(from, to)
	if not from or not to then return end
	local x, y, z = getElementPosition(from)
	local x1, y1, z1 = getElementPosition(to)
	return getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)
end

addEvent("sendAme", true)
addEventHandler("sendAme", root, function(message)
	if client and client ~= source then return end
	return exports.cr_global:sendLocalMeAction(source, message, true, true)
end)

addEvent("sendAdo", true)
addEventHandler("sendAdo", root, function(message)
	if client and client ~= source then return end
	return sendToNearByClients(source, "* " .. message .. " ((" .. getPlayerName(source) .. (message:sub(1, 1) == "'" and "" or " ") .. ")) *")
end)