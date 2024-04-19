local mysql = exports.cr_mysql

local bannedPlayers = {}
local banSecurity = {}
local kickSecurity = {}

addEventHandler("onResourceStart", resourceRoot, function()
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				loadBan(row.serial)
			end
		end
	end, mysql:getConnection(), "SELECT serial FROM bans")
end)

function loadBan(serial)
	if not serial then return false end
	dbQuery(function(qh)
		local res, rows, err = dbPoll(qh, 0)
		if rows > 0 then
			for index, row in ipairs(res) do
				local admin = tostring(row["admin"]) or "Bilinmiyor"
				local reason = tostring(row["reason"]) or "Bilinmiyor"
				local date = tostring(row["date"]) or "Bilinmiyor"
				local endTick = tonumber(row["end_tick"]) or 0
				
				bannedPlayers[serial] = {}
				bannedPlayers[serial].admin = admin
				bannedPlayers[serial].reason = reason
				bannedPlayers[serial].date = date
				bannedPlayers[serial].endTick = endTick
			end
		end
	end, mysql:getConnection(), "SELECT admin, reason, date, end_tick FROM bans WHERE serial = ?", serial)
end

function saveBan(serial)
	if not serial then return false end
	if not bannedPlayers[serial] then return false end
	dbExec(mysql:getConnection(), "UPDATE bans SET end_tick = ? WHERE serial = ?", bannedPlayers[serial].endTick, serial)
end

function removeBan(serial)
	if not bannedPlayers[serial] then return false end	
	local query = dbExec(mysql:getConnection(), "DELETE FROM bans WHERE serial = ?", serial)
	if query then
		local targetPlayer = exports.cr_global:getPlayerFromSerial(serial)
		if targetPlayer then
			redirectPlayer(targetPlayer)
		end
		bannedPlayers[serial] = nil
		return true
	end
	return false
end

function checkExpireTime()
	for serial, data in pairs(bannedPlayers) do
		if bannedPlayers[serial] then
			if bannedPlayers[serial].endTick and bannedPlayers[serial].endTick <= 0 then
				removeBan(serial)
			elseif bannedPlayers[serial].endTick and bannedPlayers[serial].endTick > 0 then
				bannedPlayers[serial].endTick = math.max(bannedPlayers[serial].endTick - (60 * 1000), 0)
				saveBan(serial)
				
				if bannedPlayers[serial].endTick == 0 then
					removeBan(serial)
				end
			end
		end
	end
end
setTimer(checkExpireTime, 60 * 1000, 0)

function clientBan(thePlayer, commandName, targetPlayer, minutes, ...)
    if exports.cr_integration:isPlayerManagement(thePlayer) then
		if banSecurity[thePlayer] <= 5 then
			if targetPlayer then
				minutes = tonumber(minutes)
				if minutes then
					if (...) then
						local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
						if targetPlayer then
							local reason = table.concat({...}, " ")
							if minutes > 0 then
								local playerLevel = getElementData(thePlayer, "admin_level") or 0
								local targetLevel = getElementData(targetPlayer, "admin_level") or 0
								if playerLevel >= targetLevel then
									local serial = getPlayerSerial(targetPlayer)
									dbQuery(function(queryHandler, thePlayer, targetPlayer, reason, serial)
										local result, rows, err = dbPoll(queryHandler, 0)
										if (rows > 0) and (result[1]) then
											data = result[1]
											if data then
												outputChatBox("[!]#FFFFFF Zaten [" .. data.serial .. "] serialli kullanıcı sunucudan yasaklı durumda.", thePlayer, 255, 0, 0, true)
												playSoundFrontEnd(thePlayer, 4)
											end
										else
											local time = getRealTime()
											local year = time.year + 1900
											local month = time.month + 1
											local day = time.monthday
											local hour = time.hour
											local minute = time.minute
											local second = time.second

											local currentDatetime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second)
											local endTick = math.floor(minutes) * 60 * 1000
											
											dbExec(mysql:getConnection(), "INSERT INTO bans (serial, admin, reason, date, end_tick) VALUES (?, ?, ?, ?, ?)", serial, exports.cr_global:getPlayerFullAdminTitle(thePlayer), reason, currentDatetime, endTick)
											triggerEvent("savePlayer", targetPlayer, "Client Ban", targetPlayer)
											
											if math.floor(minutes) >= 5000 then
												outputChatBox("[CBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu sunucudan yasakladı.", root, 255, 0, 0)
												outputChatBox("[CBAN] Sebep: " .. reason .. " (Sınırsız)", root, 255, 0, 0)
												exports.cr_discord:sendMessage("ban-log", "[CBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu sunucudan yasakladı.")
												exports.cr_discord:sendMessage("ban-log", "[CBAN] Sebep: " .. reason .. " (Sınırsız)")
											else
												outputChatBox("[CBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu sunucudan yasakladı.", root, 255, 0, 0)
												outputChatBox("[CBAN] Sebep: " .. reason .. " (" .. math.floor(minutes) .. " dakika)", root, 255, 0, 0)
												exports.cr_discord:sendMessage("ban-log", "[CBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu sunucudan yasakladı.")
												exports.cr_discord:sendMessage("ban-log", "[CBAN] Sebep: " .. reason .. " (" .. math.floor(minutes) .. " dakika)")
											end
											
											loadBan(getPlayerSerial(targetPlayer))
											triggerClientEvent(targetPlayer, "account.banScreen", targetPlayer, {exports.cr_global:getPlayerFullAdminTitle(thePlayer), reason, currentDatetime, endTick})
											addAdminHistory(targetPlayer, thePlayer, reason, 7, (tonumber(minutes) and (minutes >= 5000 and 0 or minutes) or 0))
											
											if isElement(targetPlayer) then
												if (getPedOccupiedVehicle(targetPlayer)) then
													removePedFromVehicle(targetPlayer)
												end
												
												exports.cr_global:updateNametagColor(targetPlayer)
												
												setElementData(targetPlayer, "legitnamechange", 1)
												setPlayerName(targetPlayer, "CRP." .. getElementData(targetPlayer, "playerid"))
												setElementData(targetPlayer, "legitnamechange", 0)
												
												for index, value in pairs(getAllElementData(targetPlayer)) do
													if index ~= "playerid" then
														removeElementData(targetPlayer, index)
													end
												end

												setElementData(targetPlayer, "loggedin", 0)
												setElementData(targetPlayer, "account:loggedin", false)
												setElementData(targetPlayer, "account:username", "")
												setElementData(targetPlayer, "account:id", "")
												setElementData(targetPlayer, "dbid", false)
												setElementData(targetPlayer, "admin_level", 0)
												setElementData(targetPlayer, "hiddenadmin", 0)
												setElementData(targetPlayer, "globalooc", 1)
												setElementData(targetPlayer, "muted", 0)
												setElementData(targetPlayer, "loginattempts", 0)
												setElementData(targetPlayer, "timeinserver", 0)
												setElementData(targetPlayer, "chatbubbles", 0)
												setElementDimension(targetPlayer, 9999)
												setElementInterior(targetPlayer, 0)
												exports.cr_global:updateNametagColor(targetPlayer)
												
												destroyElement(targetPlayer)
											end
											
											banSecurity[thePlayer] = banSecurity[thePlayer] + 1
											if banSecurity[thePlayer] <= 1 then
												setTimer(function()
													banSecurity[thePlayer] = 0
												end, 1000 * 60 * 5, 1)
											end
										end
									end, {thePlayer, targetPlayer, reason, serial}, mysql:getConnection(), "SELECT serial FROM bans WHERE serial = ?", serial)
								else
									outputChatBox("[!]#FFFFFF Kendinizden üst yetkili birisini sunucudan yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
									playSoundFrontEnd(thePlayer, 4)
									
									outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi sunucudan yasaklamaya çalıştı.", targetPlayer, 255, 0, 0, true)
								end
							else
								outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
							end
						end
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
					end
				else 
					outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
				end
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
            outputChatBox("[!]#FFFFFF Beş dakika içerisinde yalnızca en fazla 5 kişiyi sunucudan yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("cban", clientBan, false, false)

function offlineClientBan(thePlayer, commandName, serial, minutes, ...)
    if exports.cr_integration:isPlayerManagement(thePlayer) then
		if banSecurity[thePlayer] <= 5 then
			if serial then
				minutes = tonumber(minutes)
				if minutes then
					if (...) then
						local reason = table.concat({...}, " ")
						if minutes > 0 then
							local time = getRealTime()
							local year = time.year + 1900
							local month = time.month + 1
							local day = time.monthday
							local hour = time.hour
							local minute = time.minute
							local second = time.second

							local currentDatetime = string.format("%04d-%02d-%02d %02d:%02d:%02d", year, month, day, hour, minute, second)
							local endTick = math.floor(minutes) * 60 * 1000
							
							loadBan(serial)
							dbExec(mysql:getConnection(), "INSERT INTO bans (serial, admin, reason, date, end_tick) VALUES (?, ?, ?, ?, ?)", serial, exports.cr_global:getPlayerFullAdminTitle(thePlayer), reason, currentDatetime, endTick)
							
							if math.floor(minutes) >= 5000 then
								outputChatBox("[OCBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. serial .. " serialini sunucudan yasakladı.", root, 255, 0, 0)
								outputChatBox("[OCBAN] Sebep: " .. reason .. " (Sınırsız)", root, 255, 0, 0)
								exports.cr_discord:sendMessage("ban-log", "[OBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. serial .. " serialini sunucudan yasakladı.")
								exports.cr_discord:sendMessage("ban-log", "[OBAN] Sebep: " .. reason .. " (Sınırsız)")
							else
								outputChatBox("[OCBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. serial .. " serialini sunucudan yasakladı.", root, 255, 0, 0)
								outputChatBox("[OCBAN] Sebep: " .. reason .. " (" .. math.floor(minutes) .. " dakika)", root, 255, 0, 0)
								exports.cr_discord:sendMessage("ban-log", "[OBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. serial .. " serialini sunucudan yasakladı.")
								exports.cr_discord:sendMessage("ban-log", "[OBAN] Sebep: " .. reason .. " (" .. math.floor(minutes) .. " dakika)")
							end
							
							banSecurity[thePlayer] = banSecurity[thePlayer] + 1
                            if banSecurity[thePlayer] <= 1 then
                                setTimer(function()
                                    banSecurity[thePlayer] = 0
                                end, 5000, 1)
                            end
						else
							outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Beş dakika içerisinde yalnızca en fazla 5 kişi yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("ocban", offlineClientBan, false, false)

function playerBan(thePlayer, commandName, targetPlayer, minutes, ...)
    if exports.cr_integration:isPlayerManagement(thePlayer) then
		if banSecurity[thePlayer] <= 5 then
			if targetPlayer then
				local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					minutes = tonumber(minutes)
					if minutes then
						if (...) then
							local reason = table.concat({...}, " ")
							if minutes >= 0 then
								local playerLevel = getElementData(thePlayer, "admin_level") or 0
								local targetLevel = getElementData(targetPlayer, "admin_level") or 0
								if playerLevel >= targetLevel then
									if minutes == 0 then
										outputChatBox("[BAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu yasakladı.", root, 255, 0, 0)
										outputChatBox("[BAN] Sebep: " .. reason .. " (Sınırsız)", root, 255, 0, 0)
										exports.cr_discord:sendMessage("ban-log", "[BAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu sunucudan yasakladı.")
										exports.cr_discord:sendMessage("ban-log", "[BAN] Sebep: " .. reason .. " (Sınırsız)")
									else
										outputChatBox("[BAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu yasakladı.", root, 255, 0, 0)
										outputChatBox("[BAN] Sebep: " .. reason .. " (" .. minutes .. " dakika)", root, 255, 0, 0)
										exports.cr_discord:sendMessage("ban-log", "[BAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu sunucudan yasakladı.")
										exports.cr_discord:sendMessage("ban-log", "[BAN] Sebep: " .. reason .. " (" .. minutes .. " dakika)")
									end
									
									banPlayer(targetPlayer, true, false, true, exports.cr_global:getPlayerFullAdminTitle(thePlayer), reason, minutes * 60)
									addAdminHistory(targetPlayer, thePlayer, reason, 2, (tonumber(minutes) and (minutes >= 5000 and 0 or minutes) or 0))

                                    banSecurity[thePlayer] = banSecurity[thePlayer] + 1
                                    if banSecurity[thePlayer] <= 1 then
                                        setTimer(function()
                                            banSecurity[thePlayer] = 0
                                        end, 5000, 1)
                                    end
								else
									outputChatBox("[!]#FFFFFF Kendinizden üst yetkili birisini banlayamassınız.", thePlayer, 255, 0, 0, true)
									outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi banlamaya çalıştı.", targetPlayer, 255, 0, 0, true)
									playSoundFrontEnd(thePlayer, 4)
								end
							else
								outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
							end
						else
							outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
					end
				end
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Beş dakika içerisinde yalnızca en fazla 5 kişi yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("ban", playerBan, false, false)

function offlineBan(thePlayer, commandName, serial, minutes, ...)
    if exports.cr_integration:isPlayerManagement(thePlayer) then
		if banSecurity[thePlayer] <= 5 then
			if serial then
				minutes = tonumber(minutes)
				if minutes then
					if (...) then
						local reason = table.concat({...}, " ")
						if minutes >= 0 then
							if minutes == 0 then
								outputChatBox("[OBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. serial .. " serialini sunucudan yasakladı.", root, 255, 0, 0)
								outputChatBox("[OBAN] Sebep: " .. reason .. " (Sınırsız)", root, 255, 0, 0)
								exports.cr_discord:sendMessage("ban-log", "[OBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. serial .. " serialini sunucudan yasakladı.")
								exports.cr_discord:sendMessage("ban-log", "[OBAN] Sebep: " .. reason .. " (Sınırsız)")
							else
								outputChatBox("[OBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. serial .. " serialini sunucudan yasakladı.", root, 255, 0, 0)
								outputChatBox("[OBAN] Sebep: " .. reason .. " (" .. minutes .. " dakika)", root, 255, 0, 0)
								exports.cr_discord:sendMessage("ban-log", "[OBAN] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. serial .. " serialini sunucudan yasakladı.")
								exports.cr_discord:sendMessage("ban-log", "[OBAN] Sebep: " .. reason .. " (" .. minutes .. " dakika)")
							end
							
							addBan(nil, nil, serial, exports.cr_global:getPlayerFullAdminTitle(thePlayer), reason, minutes * 60)
							
							banSecurity[thePlayer] = banSecurity[thePlayer] + 1
                            if banSecurity[thePlayer] <= 1 then
                                setTimer(function()
                                    banSecurity[thePlayer] = 0
                                end, 5000, 1)
                            end
						else
							outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Serial] [Dakika / 0 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("[!]#FFFFFF Beş dakika içerisinde yalnızca en fazla 5 kişi yasaklayabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("oban", offlineBan, false, false)

function kickMain(thePlayer, commandName, targetPlayer, reason)
    if exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
		if kickSecurity[thePlayer] <= 5 then
			if targetPlayer then
				local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then
					if reason then
						local playerLevel = getElementData(thePlayer, "admin_level") or 0
						local targetLevel = getElementData(targetPlayer, "admin_level") or 0
						if playerLevel >= targetLevel then
							outputChatBox("[KICK] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu sunucudan attı.", root, 255, 0, 0)
							outputChatBox("[KICK] Sebep: " .. reason, root, 255, 0, 0)
							exports.cr_discord:sendMessage("kick-log", "[KICK] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " (" .. (getElementData(targetPlayer, "account:username") or "N/A") .. ") isimli oyuncuyu sunucudan attı.")
							exports.cr_discord:sendMessage("kick-log", "[KICK] Sebep: " .. reason)
							
							kickPlayer(targetPlayer, thePlayer, reason)
							addAdminHistory(targetPlayer, thePlayer, reason, 1, 0)
							
							kickSecurity[thePlayer] = kickSecurity[thePlayer] + 1
                            if kickSecurity[thePlayer] <= 1 then
                                setTimer(function()
                                    kickSecurity[thePlayer] = 0
                                end, 1000 * 60 * 5, 1)
                            end
						else
							outputChatBox("[!]#FFFFFF Kendinizden üst yetkili birisini sunucudan atamazsınız.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
							
                            outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizi sunucudan atmaya çalıştı.", targetPlayer, 255, 0, 0, true)
						end
					else
						outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Sebep]", thePlayer, 255, 194, 14)
					end
				end
			else 
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Sebep]", thePlayer, 255, 194, 14)
			end
		else
            outputChatBox("[!]#FFFFFF Beş dakika içerisinde yalnızca en fazla 5 kişiyi sunucudan atabilirsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("kick", kickMain, false, false)

addEventHandler("onPlayerJoin", root, function()
    reloadSomethings(source)
end)

addEventHandler("onPlayerQuit", root, function()
    banSecurity[source] = nil
    kickSecurity[source] = nil
end)

addEventHandler("onResourceStart", resourceRoot, function()
    for key, player in ipairs(getElementsByType("player")) do
        reloadSomethings(player)
    end
end)

function reloadSomethings(thePlayer)
    banSecurity[thePlayer] = 0
    kickSecurity[thePlayer] = 0
end