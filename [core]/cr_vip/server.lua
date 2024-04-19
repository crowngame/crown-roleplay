local mysql = exports.cr_mysql

addCommandHandler("vipver", function(thePlayer, cmdName, idOrNick, vipRank, days)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		if (not idOrNick or not tonumber(vipRank) or not tonumber(days) or (tonumber(vipRank) < 0 or tonumber(vipRank) > 5)) then
			outputChatBox("KULLANIM: /" .. cmdName .. " [Karakter Adı / ID] [1-5] [Gün]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, idOrNick)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("[!]#FFFFFF Oyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
				end
				
				local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
				if not isPlayerVIP(charID) then
					local id = SmallestID()
					
					local success = dbExec(mysql:getConnection(),"INSERT INTO `vipPlayers` (`id`, `char_id`, `vip_type`, `vip_end_tick`) VALUES ('" .. id .. "', '" .. charID .. "', '" .. (vipRank) .. "', '" .. (endTick) .. "')") or false
					if not success then
						return outputDebugString("@vipsystem_Commands_S: mysql hatası. 21.satır")
					end
				
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncuya başarıyla " .. days .. " günlük VIP [" .. vipRank .. "] verdiniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size " .. days .. " günlük VIP [" .. vipRank .. "] verdi.", targetPlayer, 0, 255, 0, true)
					
					exports.cr_discord:sendMessage("vip-log", "**[VIPVER]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuya " .. days .. " günlük VIP [" .. vipRank .. "] verdi.")
				
					loadVIP(charID)
				else
					if tonumber(vipRank) ~= getElementData(thePlayer, "vip") then 
						outputChatBox("[!]#FFFFFF Oyuncu, vermeye çalıştığınız VIP [" .. vipRank .. "] seviyesine sahip değil.", thePlayer, 255, 0, 0, true)
						return
					end
					local success = dbExec(mysql:getConnection(),"UPDATE `vipPlayers` SET vip_end_tick= vip_end_tick + " .. endTick .. " WHERE char_id=" .. charID .. " and vip_type=" .. vipRank .. " LIMIT 1")
					if not success then
						return outputDebugString("@vipsystem_Core_S: mysql hatası. 36.satır")
					end
					
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun VIP süresine " .. days .. " gün eklediniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili VIP [" .. vipRank .. "] sürenizi " .. days .. " gün uzattı.", targetPlayer, 0, 255, 0, true)
					
					exports.cr_discord:sendMessage("vip-log", "**[VIPVER]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuya " .. days .. " günlük VIP [" .. vipRank .. "] verdi.")
					
					loadVIP(charID)
				end
			end
		end
	else 
		outputChatBox("[!]#FFFFFF Bu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end)

addCommandHandler("vipal", function(thePlayer, cmdName, idOrNick)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		if (not idOrNick) then
			outputChatBox("KULLANIM: /" .. cmdName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, idOrNick)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("[!]#FFFFFF Oyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
				end
				
				if isPlayerVIP(charID) then
					local success = removeVIP(charID)
					if success then
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun VIP üyeliğini aldınız.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili VIP üyeliğinizi aldı.", thePlayer, 255, 0, 0, true)
						exports.cr_discord:sendMessage("vip-log", "**[VIPAL]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncunun VIP üyeliğini aldı.")
					end
				else
					outputChatBox("[!]#FFFFFF Oyuncunun VIP üyeliği bulunmuyor.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	else 
		outputChatBox("[!]#FFFFFF Bu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end)

function vipDagit(thePlayer, commandName, vipID, vipDay)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		vipID = tonumber(vipID)
		if vipID then
			vipDay = tonumber(vipDay)
			if vipDay then
				if vipID >= 1 and vipID <= 5 then
					if vipDay >= 1 then
						for key, player in ipairs(getElementsByType("player")) do
							local playerVIP = getElementData(player, "vip") or 0
							if getElementData(player, "loggedin") == 1 and playerVIP <= 4 then
								local charID = getElementData(player, "dbid")
								if isPlayerVIP(charID) then
									local addDay = math.floor(vipDay / 2)
									addVIP(player, vipID, addDay)
									outputChatBox("[!]#FFFFFF Crown Roleplay tarafından VIP [" .. playerVIP .. "] sürenize " .. addDay .. " gün daha eklendi!", player, 0, 255, 0, true)
									triggerClientEvent(player, "playSuccessfulSound", player)
								else
									removeVIP(charID)
									addVIP(player, vipID, vipDay)
									outputChatBox("[!]#FFFFFF Crown Roleplay tarafından " .. vipDay .. " günlük VIP [" .. vipID .. "] kazandınız!", player, 0, 255, 0, true)
									triggerClientEvent(player, "playSuccessfulSound", player)
								end
							end
						end
						exports.cr_discord:sendMessage("vip-log", "**[VIPDAGIT]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili " .. vipDay .. " günlük VIP [" .. vipID .. "] dağıttı.")
					else
						outputChatBox("[!]#FFFFFF Lütfen sayısal bir gün giriniz.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bu sayıda VIP bulunmuyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Level] [Gün]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Level] [Gün]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vipdagit", vipDagit)

function vipDagit2(thePlayer, commandName)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		for _, player in ipairs(getElementsByType("player")) do
			if getElementData(player, "loggedin") == 1 then
				-- setElementData(player, "vip", 5)
				
				setElementData(player, "vip", 0)
                loadVIP(getElementData(player, "dbid"))
			end
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("vipdagit2", vipDagit2)

addCommandHandler("vipsure", function(thePlayer, cmd, id)
	if id then
	local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, id)
	local id = getElementData(targetPlayer, "dbid")
		if (exports.cr_integration:isPlayerTrialAdmin(thePlayer)) then
			if vipPlayers[id] then
				local vipType = vipPlayers[id].type
				local remaining = vipPlayers[id].endTick
				local remainingInfo = secondsToTimeDesc(remaining/1000)
	
				return outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun kalan VIP [" .. vipType .. "] süresi: " .. remainingInfo, thePlayer, 0, 0, 255, true)
			end
			
			return outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncunun VIP üyeliği bulunmamaktadır.", thePlayer, 255, 0, 0, true)
		end
	end

	local charID = getElementData(thePlayer, "dbid")
	if not charID then return false end

	if vipPlayers[charID] then
		local vipType = vipPlayers[charID].type
		local remaining = vipPlayers[charID].endTick
		local remainingInfo = secondsToTimeDesc(remaining/1000)

		outputChatBox("[!]#FFFFFF Kalan VIP [" .. vipType .. "] süreniz: " .. remainingInfo, thePlayer, 0, 0, 255, true)
	else
		outputChatBox("[!]#FFFFFF VIP üyeliğiniz bulunmamaktadır.", thePlayer, 255, 0, 0, true)
	end
end)

function addVIP(targetPlayer, vipRank, days)
	if targetPlayer and vipRank and days then
		local charID = tonumber(getElementData(targetPlayer, "dbid"))
		if not charID then
			return false
		end
		
		local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
		if not isPlayerVIP(charID) then
			local id = SmallestID()
			local success = dbExec(mysql:getConnection(), "INSERT INTO `vipPlayers` (`id`, `char_id`, `vip_type`, `vip_end_tick`) VALUES ('" .. id .. "', '" .. charID .. "', '" .. (vipRank) .. "', '" .. (endTick) .. "')") or false
			if not success then
				return outputDebugString("@vipsystem_Commands_S addVIP: mysql hatası. 26.satır")
			end
			loadVIP(charID)
		else
		
			local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick= vip_end_tick + " .. endTick .. " WHERE char_id=" .. charID .. " and vip_type=" .. vipRank .. " LIMIT 1")
			if not success then
				return outputDebugString("@vipsystem_Core_S: mysql hatası. 52.satır")
			end
			
			loadVIP(charID)
		end
	end
end

function togPM(thePlayer, commandName)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or (getElementData(thePlayer, "vip") > 0) then
		if not getElementData(thePlayer, "pm:off") then
			outputChatBox("[!]#FFFFFF Özel mesajlarınızı başarıyla kapattınız.", thePlayer, 255, 0, 0, true)
			setElementData(thePlayer, "pm:off", true)
		else
			outputChatBox("[!]#FFFFFF Özel mesajlarınızı başarıyla aktif ettiniz.", thePlayer, 0, 255, 0, true)
			setElementData(thePlayer, "pm:off", nil)
		end
	end	
end
addCommandHandler("pmkapat", togPM, false, false)
addCommandHandler("pmac", togPM, false, false)
addCommandHandler("togpm", togPM, false, false)