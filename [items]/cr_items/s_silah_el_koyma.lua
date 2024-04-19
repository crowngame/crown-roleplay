function setHak(thePlayer, commandName, targetName, weaponSerial, yeniHak)
	if exports["cr_integration"]:isPlayerDeveloper(thePlayer) then
		local yeniHak = tonumber(yeniHak)
		if not (targetName) or (not weaponSerial) or not yeniHak or (yeniHak and yeniHak > 3 or yeniHak < 0) then
			return outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Silah Seriali] [Yeni Hak 1-3]", thePlayer, 255, 194, 14)
		end
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetName)
		if not targetPlayer then
			return outputChatBox("[!]#FFFFFF Kişi bulunamadı.", thePlayer, 255, 0, 0, true)
		end
		local itemSlot = getItems(targetPlayer)
		for i, v in ipairs(itemSlot) do
			--if v[1] == 115 and not restrictedWeapons[tonumber(explode(":", v[2])[1])] then
				if explode(":", v[2])[2] and (explode(":", v[2])[2] == weaponSerial) then
					if not v[1] == 115 or restrictedWeapons[tonumber(explode(":", v[2])[1])] then
						return outputChatBox("[!]#FFFFFF Bu komut sadece silahlar için kullanılabilir!", thePlayer, 255, 0, 0, true)
					end
					local checkString = string.sub(explode(":", v[2])[3], -4) == " (D)"
					if checkString then
						return outputChatBox("[!]#FFFFFF Bu komut Duty silahlarında kullanılamaz!", thePlayer, 255, 0, 0, true)
					end
					
					takeItem(targetPlayer, 115, v[2])
					giveItem(targetPlayer, 115, tonumber(explode(":", v[2])[1]) .. ":" .. tostring(explode(":", v[2])[2]) .. ":" .. tostring(explode(":", v[2])[3]) .. ":" .. tostring(explode(":", v[2])[4]) .. ":" .. tostring(explode(":", v[2])[5]) .. ":" .. tostring(yeniHak))
						
					local suffix = "kişi"
					if exports["cr_integration"]:isPlayerDeveloper(thePlayer) then
						suffix = "yetkili"
					end
					outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " adlı kişinin, " .. explode(":", v[2])[3] .. " silahının hakkı " .. yeniHak .. " olarak değiştirildi.", thePlayer, 0, 55, 255, true)
					outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " adlı " .. suffix .. ", " .. explode(":", v[2])[3] .. " silahınızın hakkını " .. yeniHak .. " olarak değiştirdi.", targetPlayer, 0, 55, 255, true)
					return
				end
			--end
		end
		outputChatBox("[!]#FFFFFF Silah seriali bulunamadı!", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("sethak", setHak)