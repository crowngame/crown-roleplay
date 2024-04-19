addCommandHandler("karaktersil", 
	function(thePlayer, commandName, playerName) 
		if exports.cr_integration:isPlayerScripter(thePlayer) then
			if not playerName then
				outputChatBox("Sözdizimi: /" .. commandName .. " [Isim_Soyisim]", thePlayer)
				return
			end
			
			if string.find(playerName, "_") then
				local result = exports.cr_mysql:query("Delete FROM characters WHERE charactername='" .. playerName .. "'")
				if result then
					outputChatBox("'" .. playerName .. "' isimli karakter başarıyla veritabanından silinmiştir!", thePlayer)
				else
					outputChatBox("'" .. playerName .. "' isimli karakter silinirken bir hata oluştu. Hata Raporu: VT-CH-001", thePlayer)
				end
			else
				outputChatBox("[!] Sözdizimi: /" .. commandName .. " [Isim_Soyisim]", thePlayer)
				return
			end
		end
	end
)

addCommandHandler("karakterlimit", 
	function(thePlayer, commandName, targetPlayerNick, karakterLimiti) 
		if exports.cr_integration:isPlayerScripter(thePlayer) then
			if not targetPlayerNick then
				outputChatBox("Sözdizimi: /" .. commandName .. " [Oyuncu] [Limit]", thePlayer)
				return
			end
			
			local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(targetPlayerNick)
			local result = exports.cr_mysql:query("UPDATE accounts SET karakterlimit='" .. tonumber(karakterLimiti) .. "' WHERE id='" .. getElementData(targetPlayer, "dbid") .. "'")
			if result then
				outputChatBox("'" .. targetPlayerName .. "' isimli oyuncunun maximum karakter limiti başarıyla değiştirilmiştir!", thePlayer)
			else
				outputChatBox("'" .. targetPlayerName .. "' isimli oyuncunun maximum karakter limiti değiştirilemedi. Hata Raporu: VT-CH-002", thePlayer)
			end
		end
	end
)