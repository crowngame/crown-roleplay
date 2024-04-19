function jailPlayer(thePlayer, commandName, targetPlayer, minutes, ...)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (targetPlayer) or not (minutes) or not (...) or (minutes < 1) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local reason = table.concat({...}, " ")
			
			if (targetPlayer) then
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "account:id")
				
				if isTimer(jailTimer) then
					killTimer(jailTimer)
				end
				
				if (isPedInVehicle(targetPlayer)) then
					setElementData(targetPlayer, "realinvehicle", 0)
					removePedFromVehicle(targetPlayer)
				end
				detachElements(targetPlayer)
				
				setElementDimension(targetPlayer, 65400 + getElementData(targetPlayer, "playerid"))
				setElementInterior(targetPlayer, 6)
				setCameraInterior(targetPlayer, 6)
				setElementPosition(targetPlayer, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(targetPlayer, 267.438446)
				
				if (minutes >= 5000) then
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail = '1', adminjail_time = '" .. minutes .. "', adminjail_permanent = '1', adminjail_by = '" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "', adminjail_reason = '" .. reason .. "' WHERE id = '" .. accountID .. "'")
					setElementData(targetPlayer, "jailtimer", true)
					
					outputChatBox("(( " .. targetPlayerName .. " cezalandırıldı. Süre: Sınırsız - Gerekçe: " .. reason .. " ))", root, 255, 0, 0)
					exports.cr_discord:sendMessage("jail-log", "**[JAIL]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuyu **Sınırsız** olarak hapise attı.")
					exports.cr_discord:sendMessage("jail-log", "**[JAIL]** Sebep: " .. reason)
				else
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail = '1', adminjail_time = '" .. minutes .. "', adminjail_permanent = '0', adminjail_by = '" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "', adminjail_reason = '" .. reason .. "' WHERE id = '" .. accountID .. "'")
					
					local theTimer = setTimer(timerUnjailPlayer, 60000, 1, targetPlayer)
					setElementData(targetPlayer, "jailtimer", theTimer)
					setElementData(targetPlayer, "jailserved", 0)
					setElementData(targetPlayer, "jailtimer", theTimer)
					
					outputChatBox("(( " .. targetPlayerName .. " cezalandırıldı. Süre: " .. minutes .. " dakika - Gerekçe: " .. reason .. " ))", root, 255, 0, 0)
					exports.cr_discord:sendMessage("jail-log", "**[JAIL]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuyu **" .. minutes .. " dakika** hapise attı.")
					exports.cr_discord:sendMessage("jail-log", "**[JAIL]** Sebep: " .. reason)
				end
				
				setElementData(targetPlayer, "adminjailed", true)
				setElementData(targetPlayer, "jailreason", reason)
				setElementData(targetPlayer, "jailtime", minutes)
				setElementData(targetPlayer, "jailadmin", exports.cr_global:getPlayerFullAdminTitle(thePlayer))
				
				addAdminHistory(targetPlayer, thePlayer, reason, 0, (tonumber(minutes) and (minutes == 5000 and 0 or minutes) or 0))
			end
		end
	end
end
addCommandHandler("jail", jailPlayer, false, false)
addCommandHandler("sjail", jailPlayer, false, false)

function offlineJailPlayer(thePlayer, commandName, targetPlayer, minutes, ...)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (targetPlayer) or not (minutes) or not (...) or (minutes < 1) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Kullanıcı Adı] [Dakika / 5000 = Sınırsız] [Sebep]", thePlayer, 255, 194, 14)
		else
			local reason = table.concat({...}, " ")
			local onlinePlayers = getElementsByType("player")
			for _, player in ipairs(onlinePlayers) do
				if targetPlayer:lower() == getElementData(player, "account:username"):lower() then
					local commandNameTemp = "jail"
					if commandName:lower() == "sojail" then
						commandNameTemp = "sjail"
					end
					jailPlayer(thePlayer, commandNameTemp, getPlayerName(player):gsub(" ", "_"), minutes, reason)
					return true
				end
			end
			
			local row = mysql:query_fetch_assoc("SELECT id, username, mtaserial, admin FROM accounts WHERE username = '" ..  mysql:escape_string(targetPlayer)  .. "' LIMIT 1")
			local accountID = false
			local accountUsername = false
			if row and row.id ~= mysql_null() then
				accountID = row["id"] 
				accountUsername = row["username"] 
			else
				outputChatBox("[!]#FFFFFF Böyle bir kullanıcı bulunamadı.", thePlayer, 255, 0, 0, true)
				return false
			end
			
			if (minutes >= 5000) then
				dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail = '1', adminjail_time = '5000', adminjail_permanent = '1', adminjail_by = '" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "', adminjail_reason = '" .. reason .. "' WHERE id = '" .. accountID .. "'")
				outputChatBox("(( " .. accountUsername .. " cezalandırıldı. Süre: Sınırsız - Gerekçe: " .. reason .. " ))", root, 255, 0, 0)
				exports.cr_discord:sendMessage("jail-log", "**[OJAIL]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. accountUsername .. "** isimli oyuncuyu **Sınırsız** olarak hapise attı.")
				exports.cr_discord:sendMessage("jail-log", "**[OJAIL]** Sebep: " .. reason)
			else
				dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail = '1', adminjail_time = '" .. minutes .. "', adminjail_permanent = '0', adminjail_by = '" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "', adminjail_reason = '" .. reason .. "' WHERE id = '" .. accountID .. "'")
				outputChatBox("(( " .. accountUsername .. " cezalandırıldı. Süre: " .. minutes .. " dakika - Gerekçe: " .. reason .. " ))", root, 255, 0, 0)
				exports.cr_discord:sendMessage("jail-log", "**[OJAIL]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **" .. accountUsername .. "** isimli oyuncuyu **" .. minutes .. " dakika** hapise attı.")
				exports.cr_discord:sendMessage("jail-log", "**[OJAIL]** Sebep: " .. reason)
			end
			
			addAdminHistory(accountID, thePlayer, reason, 0, (tonumber(minutes) and (minutes == 5000 and 0 or minutes) or 0))
		end
	end
end
addCommandHandler("ojail", offlineJailPlayer, false, false)
addCommandHandler("sojail", offlineJailPlayer, false, false)

function timerUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "jailserved")
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "account:id")
		if (timeServed) then
			setElementData(jailedPlayer, "jailserved", timeServed + 1)
			local timeLeft = timeLeft - 1
			setElementData(jailedPlayer, "jailtime", timeLeft)
		
			if (timeLeft <= 0) and not (getElementData(jailedPlayer, "pd.jailtime")) then
				local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time = '0', adminjail = '0' WHERE id = '" .. accountID .. "'")
				setElementData(jailedPlayer, "jailtimer", false)
				setElementData(jailedPlayer, "adminjailed", false)
				setElementData(jailedPlayer, "jailreason", false)
				setElementData(jailedPlayer, "jailtime", false)
				setElementData(jailedPlayer, "jailadmin", false)
				setElementPosition(jailedPlayer, 1537.052734375, -1724.091796875, 13.546875)
				setPedRotation(jailedPlayer, 0)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				
				outputChatBox("[!]#FFFFFF Hapis süreniz tamamlandı, bir dahakine lütfen dikkatli olun.", jailedPlayer, 0, 255, 0, true)
				exports.cr_global:sendMessageToAdmins("[UNJAIL] " .. getPlayerName(jailedPlayer):gsub("_", " ") .. " isimli oyuncunun hapis süresi doldu.")
				exports.cr_discord:sendMessage("jail-log", "**[UNJAIL]** **" .. getPlayerName(jailedPlayer):gsub("_", " ") .. "** isimli oyuncunun hapis süresi doldu.")
			else
				local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time = '" .. timeLeft .. "' WHERE id = '" .. accountID .. "'")
				local theTimer = setTimer(timerUnjailPlayer, 60000, 1, jailedPlayer)
				setElementData(jailedPlayer, "jailtimer", theTimer)
				
				local jailCounter = {}
				jailCounter.minutesleft = timeLeft
				jailCounter.reason = getElementData(jailedPlayer, "jailreason")
				jailCounter.admin = getElementData(jailedPlayer, "jailadmin")
			end
		end
	end
end
addEvent("admin:timerUnjailPlayer", false)
addEventHandler("admin:timerUnjailPlayer", root, timerUnjailPlayer)

function unjailPlayer(thePlayer, commandName, targetPlayer)
	if (exports.cr_integration:isPlayerAdministrator(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if (targetPlayer) then
				local jailed = getElementData(targetPlayer, "jailtimer", nil)
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "account:id")
				
				if not (jailed) then
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli oyuncu hapiste değil.", thePlayer, 255, 0, 0, true)
				else
					local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time = '0', adminjail = '0' WHERE id = '" .. accountID .. "'")

					if isTimer(jailed) then
						killTimer(jailed)
					end
					
					setElementData(targetPlayer, "jailtimer", false)
					setElementData(targetPlayer, "adminjailed", false)
					setElementData(targetPlayer, "jailreason", false)
					setElementData(targetPlayer, "jailtime", false)
					setElementData(targetPlayer, "jailadmin", false)
					setElementPosition(targetPlayer, 2031.3515625 + math.random(3, 6), -1417.6787109375 + math.random(3, 6), 16.9921875)
					setPedRotation(targetPlayer, 0)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
					
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.cr_global:getPlayerFullAdminTitle(thePlayer)
					if (hiddenAdmin == 1) then
						adminTitle = "Gizli Yetkili"
					end
			
					outputChatBox("[!]#FFFFFF " .. adminTitle .. " isimli yetkili seni hapisten çıkarttı, bir daha suç işleme.", targetPlayer, 0, 255, 0,true)
					exports.cr_global:sendMessageToAdmins("[UNJAIL] " .. adminTitle .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu hapisten çıkarttı.")
					exports.cr_discord:sendMessage("jail-log", "**[UNJAIL]** **" .. adminTitle .. "** isimli yetkili **" .. targetPlayerName .. "** isimli oyuncuyu hapisten çıkarttı.")
				end
			end
		end
	end
end
addCommandHandler("unjail", unjailPlayer, false, false)

function jailedPlayers(thePlayer, commandName)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer)) then
		local players = exports.cr_pool:getPoolElementsByType("player")
		local count = 0
		for _, player in ipairs(players) do
			if getElementData(player, "adminjailed") then
				if tonumber(getElementData(player, "jailtime")) then
					outputChatBox("[OOC] " .. getPlayerName(player):gsub("_", " ") .. " isimli oyuncu " .. tostring(getElementData(player, "jailadmin")) .. " tarafından " .. tostring(getElementData(player, "jailserved")) .. " dakikadır içeride, " .. tostring(getElementData(player,"jailtime")) .. " dakikası kaldı.", thePlayer, 255, 0, 0)
					outputChatBox("[OOC] Sebep: " .. tostring(getElementData(player, "jailreason")), thePlayer, 255, 0, 0)
				else
					outputChatBox("[OOC] " .. getPlayerName(player):gsub("_", " ") .. " isimli oyuncu " .. tostring(getElementData(player, "jailadmin")) .. " tarafından süresiz hapise atıldı.", thePlayer, 255, 0, 0)
					outputChatBox("[OOC] Sebep: " .. tostring(getElementData(player, "jailreason")), thePlayer, 255, 0, 0)
				end
				count = count + 1
			elseif getElementData(player, "jailed") then
				outputChatBox("[IC] " ..  getPlayerName(player):gsub("_", " ") .. " isimli oyuncunun || Hücre ID: " .. getElementData(player, "jail:cell") .. " || Mahkum ID: " ..  tostring(getElementData(player, "jail:id"))  .. " - Daha fazla bilgi için /arrest.", thePlayer, 255, 0, 0)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("[!]#FFFFFF Hiç kimse hapiste değil.", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("jailed", jailedPlayers, false, false)