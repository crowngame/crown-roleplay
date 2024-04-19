local mysql = exports.cr_mysql

function getKey(thePlayer, commandName)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		local adminName = getPlayerName(thePlayer):gsub(" ", "_")
		local veh = getPedOccupiedVehicle(thePlayer)
		if veh then
			local vehID = getElementData(veh, "dbid")
			givePlayerItem(thePlayer, "giveitem" , adminName, "3" , tostring(vehID))
			exports.cr_discord:sendMessage("getkey-log", "**[GETKEY]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **[" .. vehID .. "]** ID'li aracın anahtarını çıkardı.")
			return true
		else
			local intID = getElementDimension(thePlayer)
			if intID then
				local foundIntID = false
				local keyType = false
				local possibleInteriors = getElementsByType("interior")
				for _, theInterior in pairs (possibleInteriors) do
					if getElementData(theInterior, "dbid") == intID then
						local intType = getElementData(theInterior, "status")[1] 
						if intType == 0 or intType == 2 or intType == 3 then
							keyType = 4 --Yellow key
						else
							keyType = 5 -- Pink key
						end
						foundIntID = intID
						break
					end
				end
				
				if foundIntID and keyType then
					givePlayerItem(thePlayer, "giveitem" , adminName, tostring(keyType) , tostring(foundIntID))
					exports.cr_discord:sendMessage("getkey-log", "**[GETKEY]** **" .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. "** isimli yetkili **[" .. foundIntID .. "]** ID'li interiorun anahtarını çıkardı.")
					return true
				else
					outputChatBox("[!]#FFFFFF Lütfen, bir araca veya interior'a girin.", thePlayer, 255, 0, 0, true)
					return false
				end
			end
		end
	end
end
addCommandHandler("getkey", getKey, false, false)

function setSvPassword(thePlayer, commandName, password)
	if exports.cr_integration:isPlayerDeveloper(thePlayer)	then
		outputChatBox("KULLANIM: /" .. commandName .. " [Sunucuya Koyacağınız Şifre]", thePlayer, 255, 194, 14)
		if password and string.len(password) > 0 then
			if setServerPassword(password) then
				exports.cr_global:sendMessageToStaff("[SYSTEM] " .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " isimli yetkili sunucunun şifresini değiştirdi. (" .. password .. ")", true)
			end
		else
			if setServerPassword('') then
				exports.cr_global:sendMessageToStaff("[SYSTEM] " .. exports.cr_global:getPlayerFullIdentity(thePlayer) .. " isimli yetkili sunucunun şifresini kaldırdı.", true)
			end
		end
	end
end
addCommandHandler("setserverpassword", setSvPassword, false, false)
addCommandHandler("setserverpw", setSvPassword, false, false)