function routeHotlineCall(callingElement, callingPhoneNumber, outboundPhoneNumber, startingCall, message)
local callprogress = getElementData(callingElement, "callprogress")	
	if callingPhoneNumber == 911 then
		if startingCall then
			outputChatBox("LSPD Operator (Telefon): LSPD Hattı, konumunuzu belirtin.", callingElement, 255, 255, 255)
			setElementData(callingElement, "callprogress", 1)
		else
			if (callprogress==1) then -- Requesting the location
				setElementData(callingElement, "call.location", message)
				setElementData(callingElement, "callprogress", 2)
				outputChatBox("LSPD Operator (Telefon): Evet, size nasıl yardımcı olabilirim?", callingElement, 255, 255, 255)
			elseif (callprogress==2) then
				outputChatBox("LSPD Operator (Telefon): Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 255, 255, 255)

				local location = getElementData(callingElement, "call.location")
				local affectedElements = { }

				for key, value in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Police Department"))) do
					for _, itemRow in ipairs(exports['cr_items']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Police Department"))) do
					outputChatBox("[İHBAR] Arayan kişinin numarası " .. outboundPhoneNumber .. " - [" .. getPlayerName(callingElement):gsub("_", " ") .. "] departmente iletilmiştir.", player, 48, 128, 255)
					outputChatBox("[İHBAR] Açıklama: '" .. message .. "'.", player, 48, 128, 255)
					outputChatBox("[İHBAR] Lokasyon: '" .. tostring(location) .. "'.", player, 48, 128, 255)
				end

				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 8294 then
		if startingCall then
			outputChatBox("Los Santos Taxi (Telefon): Los Santos Taxi buyrun, nerede taksiye ihtiyacınız var?", callingElement, 255, 255, 255)
			setElementData(callingElement, "callprogress", 1)
		else
			local founddriver = false
			for key, value in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
				local job = getElementData(value, "job")
				if (job == 2) then
					local car = getPedOccupiedVehicle(value)
					if car and (getElementModel(car)==438 or getElementModel(car)==420) then
						outputChatBox("[RADIO] Operator konuşuyor: Tüm birimlerin dikkatine, " .. outboundPhoneNumber .. " - [" .. getPlayerName(callingElement):gsub("_", " ") .. "] numarasından taksi isteniyor." , value, 250, 210, 5)
						outputChatBox("[RADIO] Verilen adres: '" .. message  .. "'." , value, 250, 210, 5)
						founddriver = true
					end
				end
			end

			if founddriver == true then
				outputChatBox("Los Santos Taxi (Telefon): Pekala, hemen bir taksi gönderiyoruz.", callingElement, 255, 255, 255)
			else
				outputChatBox("Los Santos Taxi (Telefon): Malesef şu an uygun taksicimiz yok, daha sonra tekrar arayabilirsiniz.", callingElement, 255, 255, 255)
			end
			triggerEvent("phone:cancelPhoneCall", callingElement)
		end
	end
end

function log155(message)
	local logMeBuffer = getElementData(getRootElement(), "155log") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"[" .. ("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "155log", logMeBuffer)
end

function read155Log(thePlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factiontype = getElementData(theTeam, "type")
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "155log") or { }
		outputChatBox("Recent 155 calls:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- " .. b, thePlayer)
		end
		outputChatBox("  END", thePlayer)
	end
end
addCommandHandler("show155", read155Log)

function checkService(callingElement)
	t = { "both",
		  "pd",
		  "police",
		  "LSPD",
		  "sahp",
		  "sasd", -- PD ends here
		  "es",
		  "medic",
		  "ems",
		  "lsfd",
	}
	local found = false
	for row, names in ipairs(t) do
		if names == string.lower(getElementData(callingElement, "call.service")) then
			if row == 1 then
				local found = true
				return 1 -- Both!
			elseif row >= 2 and row <= 6 then
				local found = true
				return 2 -- Just the PD please
			elseif row >= 7 and row <= 10 then
				local found = true
				return 3 -- ES
			end
		end
	end
	if not found then
		return 4 -- Not found!
	end
end
