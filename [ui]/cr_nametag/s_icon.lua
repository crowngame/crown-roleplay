local mysql = exports.cr_mysql

function etiketVer(thePlayer, commandName, targetPlayer, id)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		if targetPlayer then
            id = tonumber(id)
			if id then
				if id >= 1 and id <= 6 then
					targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							local tags = getElementData(targetPlayer, "tags") or {}
							local found = false
							local foundIndex = 0
							
							for index, value in pairs(tags) do
								if value == id then
									found = true
									foundIndex = index
								end
							end
							
							if found then
								table.remove(tags, foundIndex)
								setElementData(targetPlayer, "tags", tags)
								dbExec(mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON(tags), getElementData(targetPlayer, "dbid"))
								
								outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun [" .. id .. "] ID'li etiketi alındı.", thePlayer, 0, 255, 0, true)
								outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin [" .. id .. "] ID'li etiketizi aldı.", targetPlayer, 0, 0, 255, true)
								exports.cr_discord:sendMessage("etiket-log", "[ETIKET] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun [" .. id .. "] ID'li etiketini aldı.")
							else
								if #tags >= 0 and #tags <= 5 then
									table.insert(tags, id)
									setElementData(targetPlayer, "tags", tags)
									dbExec(mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON(tags), getElementData(targetPlayer, "dbid"))
									
									outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya [" .. id .. "] ID'li etiket verildi.", thePlayer, 0, 255, 0, true)
									outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. id .. "] ID'li etiket verdi.", targetPlayer, 0, 0, 255, true)
									exports.cr_discord:sendMessage("etiket-log", "[ETIKET] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya [" .. id .. "] ID'li etiketi verdi.")
								else
									outputChatBox("[!]#FFFFFF Maksimum 5 tane etiket verebilirsiniz.", thePlayer, 255, 0, 0, true)
									playSoundFrontEnd(thePlayer, 4)
								end
							end
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Bu sayıya ait bir etiket bulunmuyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Etiket ID]", thePlayer, 255, 194, 14)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [Etiket ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("etiketver", etiketVer, false, false)

function etiketAl(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		if targetPlayer then
			targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") then
					local tags = getElementData(targetPlayer, "tags") or {}
					tags = {}
					setElementData(targetPlayer, "tags", tags)

					dbExec(mysql:getConnection(), "UPDATE characters SET tags = ? WHERE id = ?", toJSON(tags), getElementData(targetPlayer, "dbid"))
					outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun etiketleri alındı.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili etiketlerinizi aldı.", targetPlayer, 0, 0, 255, true)
					exports.cr_discord:sendMessage("etiket-log", "[ETIKET-AL] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun etiketlerini aldı.")
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("etiketal", etiketAl, false, false)

function donaterVer(thePlayer, commandName, targetPlayer, id)
	if getElementData(thePlayer, "account:username") == "Farid" or getElementData(thePlayer, "account:username") == "biax" then
		if targetPlayer then
            id = tonumber(id)
			if id then
				if id >= 0 and id <= 5 then
					targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
					if targetPlayer then
						if getElementData(targetPlayer, "loggedin") == 1 then
							setElementData(targetPlayer, "donater", id)
							dbExec(mysql:getConnection(), "UPDATE accounts SET donater = ? WHERE id = ?", id, getElementData(targetPlayer, "account:id"))
							
							outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya [" .. id .. "] ID'li donater etiketi verildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size [" .. id .. "] ID'li donater etiketi verdi.", targetPlayer, 0, 0, 255, true)
							exports.cr_discord:sendMessage("etiket-log", "[DONATER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya [" .. id .. "] ID'li donater etiketi verdi.")
						else
							outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					end
				else
					outputChatBox("[!]#FFFFFF Bu sayıya ait bir donater etiketi bulunmuyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0-5]", thePlayer, 255, 194, 14)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] [0-5]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("donaterver", donaterVer, false, false)

function youtuberVer(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		if targetPlayer then
			targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					if getElementData(targetPlayer, "youtuber") == 1 then
						setElementData(targetPlayer, "youtuber", 0)
						dbExec(mysql:getConnection(), "UPDATE accounts SET youtuber = ? WHERE id = ?", 0, getElementData(targetPlayer, "account:id"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun YouTuber etiketi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin YouTuber etiketinizi aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("etiket-log", "[YOUTUBER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun YouTuber etiketini aldı.")
					else
						setElementData(targetPlayer, "youtuber", 1)
						dbExec(mysql:getConnection(), "UPDATE accounts SET youtuber = ? WHERE id = ?", 1, getElementData(targetPlayer, "account:id"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya YouTuber etiketi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size YouTuber etiketi verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("etiket-log", "[YOUTUBER] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya YouTuber etiketi verdi.")
					end
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("ytver", youtuberVer, false, false)
addCommandHandler("youtuberver", youtuberVer, false, false)

function rpPlusVer(thePlayer, commandName, targetPlayer)
	if exports.cr_integration:isPlayerAdministrator(thePlayer) then
		if targetPlayer then
			targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				if getElementData(targetPlayer, "loggedin") == 1 then
					if getElementData(targetPlayer, "rp_plus") == 1 then
						setElementData(targetPlayer, "rp_plus", 0)
						dbExec(mysql:getConnection(), "UPDATE accounts SET rp_plus = ? WHERE id = ?", 0, getElementData(targetPlayer, "account:id"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncunun RP+ etiketi alındı.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili sizin RP+ etiketinizi aldı.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("etiket-log", "[RP+] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncunun RP+ etiketini aldı.")
					else
						setElementData(targetPlayer, "rp_plus", 1)
						dbExec(mysql:getConnection(), "UPDATE accounts SET rp_plus = ? WHERE id = ?", 1, getElementData(targetPlayer, "account:id"))
						outputChatBox("[!]#FFFFFF Başarıyla " .. targetPlayerName .. " isimli oyuncuya RP+ etiketi verildi.", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili size RP+ etiketi verdi.", targetPlayer, 0, 0, 255, true)
						exports.cr_discord:sendMessage("etiket-log", "[RP+] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuya RP+ etiketi verdi.")
					end
					
					exports.cr_global:updateNametagColor(targetPlayer)
				else
					outputChatBox("[!]#FFFFFF Bu oyuncu hesabına giriş yapmadığı için işlem gerçekleşmedi.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("rpver", rpPlusVer, false, false)
addCommandHandler("rpplusver", rpPlusVer, false, false)