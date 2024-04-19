local protectedDatas = {
	["admin_level"] = true,
	["supporter_level"] = true,
	["vct_level"] = true,
	["mapper_level"] = true,
	["scripter_level"] = true,
	["money"] = true,
	["bankmoney"] = true,
	["vip"] = true,
	["balance"] = true,
	["dbid"] = true,
	["account:character:id"] = true,
	["account:id"] = true,
	["account:username"] = true,
	["account:loggedin"] = true,
	["loggedin"] = true,
	["hiddenadmin"] = true,
	["legitnamechange"] = true,
	["boxHours"] = true,
	["boxCount"] = true,
	["tags"] = true,
	["donater"] = true,
	["youtuber"] = true,
	["rp_plus"] = true,
	["playerid"] = true,
	["itemID"] = true,
	["itemValue"] = true,
	["faction"] = true,
	["factionrank"] = true,
	["factionleader"] = true,
	["custom_duty"] = true,
	["adminjailed"] = true,
	["jailtime"] = true,
	["jailtimer"] = true,
	["jailadmin"] = true,
	["jailreason"] = true,
	["minutesPlayed"] = true,
	["hoursplayed"] = true,
	["level"] = true,
}

local dataChangeCount = {}

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if protectedDatas[theKey] then
		if getElementType(source) == "player" then
			if client and client == source then
				cancelEvent(true)
				setElementData(client, theKey, oldValue)
				
				sendMessage("[SAC #1] " .. getPlayerName(client):gsub("_", " ") .. " (" .. getElementData(client, "playerid") .. ") isimli oyuncudan geçersiz veri değişikliği algılandı, derhal kontrol edin.")
				sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
				sendMessage(">> IP: " .. getPlayerIP(client))
				sendMessage(">> Serial: " .. getPlayerSerial(client))
				
				kickPlayer(client, "Shine Anti-Cheat", "SAC #1")
			elseif client and client ~= source then
				cancelEvent(true)
				setElementData(source, theKey, oldValue)
				
				sendMessage("[SAC #1.1] " .. getPlayerName(source):gsub("_", " ") .. " (" .. getElementData(source, "playerid") .. ") isimli oyuncudan geçersiz veri değişikliği algılandı, derhal kontrol edin.")
				sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
				sendMessage(">> IP: " .. getPlayerIP(source))
				sendMessage(">> Serial: " .. getPlayerSerial(source))
				
				kickPlayer(client, "Shine Anti-Cheat", "SAC #1.1")
			end
		elseif client and (getElementType(source) == "object") then
			cancelEvent(true)
			setElementData(source, theKey, oldValue)
			
			sendMessage("[SAC #1.2] " .. getPlayerName(client):gsub("_", " ") .. " (" .. getElementData(client, "playerid") .. ") isimli oyuncudan objeye geçersiz veri değişikliği algılandı, derhal kontrol edin.")
			sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
			sendMessage(">> IP: " .. getPlayerIP(client))
			sendMessage(">> Serial: " .. getPlayerSerial(client))
			
			kickPlayer(client, "Shine Anti-Cheat", "SAC #1.2")
		end
	end
	
	if (type(tonumber(theKey)) == "number") and (tonumber(theKey) >= 1 and tonumber(theKey) <= 100000) and client then
		cancelEvent(true)
		
		sendMessage("[SAC #1.3] " .. getPlayerName(client):gsub("_", " ") .. " (" .. getElementData(client, "playerid") .. ") isimli oyuncudan geçersiz veri değişikliği algılandı, derhal kontrol edin.")
		sendMessage(">> " .. tostring(theKey) .. ": " .. tostring(oldValue) .. " > " .. tostring(newValue))
		sendMessage(">> IP: " .. getPlayerIP(client))
		sendMessage(">> Serial: " .. getPlayerSerial(client))
		
		kickPlayer(client, "Shine Anti-Cheat", "SAC #1.3")
	end
end)

setTimer(function()
	for _, player in ipairs(getElementsByType("player")) do
		if isPedWearingJetpack(player) then
			sendMessage("[SAC #2] " .. getPlayerName(source):gsub("_", " ") .. " (" .. getElementData(source, "playerid") .. ") isimli oyuncu Jetpack kullandığı için sunucudan yasaklandı.")
			sendMessage(">> IP: " .. getPlayerIP(source))
			sendMessage(">> Serial: " .. getPlayerSerial(source))
	
			banPlayer(player, true, false, true, "Shine Anti-Cheat", "SAC #2")
		end
	end
end, 1000, 0)

addEventHandler("onPlayerACInfo", root, function(detectedACList)
	for _, acCode in ipairs(detectedACList) do
		if acCode == 14 then
			banPlayer(source, true, false, true, "Shine Anti-Cheat", "SAC #3")
		end
	end
end)

addEvent("sac.sendPlayer", true)
addEventHandler("sac.sendPlayer", root, function(sacCode, isBan, reason, ...)
	if client ~= source then return end
	if sacCode and isBan and reason then
		local args = { ... }
		
		sendMessage("[SAC #" .. sacCode .. "] " .. getPlayerName(source):gsub("_", " ") .. " (" .. getElementData(source, "playerid") .. ") isimli oyuncu " .. reason .. " sebebiyle sunucudan " .. (isBan and "yasaklandı" or "atıldı") .. ".")
		sendMessage(">> IP: " .. getPlayerIP(source))
		sendMessage(">> Serial: " .. getPlayerSerial(source))
		
		if sacCode == 4 then
			sendMessage(">> Kelime:\n" .. tostring(args[1]))
		elseif sacCode == 5 then
			sendMessage(">> Script: " .. tostring(args[1]) .. " => " .. tostring(args[2]) .. " (" .. tostring(args[3]) .. ")")
			sendMessage(">> Kod:\n" .. tostring(args[4]))
		elseif sacCode == 9 then
			sendMessage(">> Script: " .. tostring(args[1]))
		end
		
		if isBan then
			banPlayer(source, true, false, true, "Shine Anti-Cheat", "SAC #" .. sacCode)
		else
			kickPlayer(source, "Shine Anti-Cheat", "SAC #" .. sacCode)
		end
	end
end)

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if client then
		local player = client
		
		if not dataChangeCount[player] then
            dataChangeCount[player] = {
                count = 1,
                timer = setTimer(function()
                    dataChangeCount[player] = nil
                end, 1000, 1)
            }
        else
            dataChangeCount[player].count = dataChangeCount[player].count + 1

            if dataChangeCount[player].count >= 500 then
				sendMessage("[SAC #8] " .. getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ") isimli oyuncudan geçersiz veri değişikliği algılandı ve sunucudan atıldı.")
				sendMessage(">> IP: " .. getPlayerIP(player))
				sendMessage(">> Serial: " .. getPlayerSerial(player))
				
				kickPlayer(player, "Shine Anti-Cheat", "SAC #8")

                dataChangeCount[player].count = 0
                if isTimer(dataChangeCount[player].timer) then
                    killTimer(dataChangeCount[player].timer)
                end
            end
        end
	end
end)

function sendMessage(message)
	exports.cr_global:sendMessageToAdmins(message, true)
	exports.cr_discord:sendMessage("sac-log", message)
end