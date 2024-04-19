addEvent("Owner:bank", true)
addEventHandler("Owner:bank", getRootElement(), function(thePlayer, kisi, miktar)
local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, kisi)
	if targetPlayer then
		if getElementData(thePlayer, "hoursplayed") >= 3 then
			if getElementData(thePlayer, "bankmoney") > tonumber(miktar) then
				if getElementData(targetPlayer, "loggedin") == 1 then
					setElementData(thePlayer, "bankmoney", getElementData(thePlayer, "bankmoney") - miktar)
					exports["cr_mysql"]:query_free("UPDATE characters SET bankmoney = " .. getElementData(thePlayer, "bankmoney") - miktar .. " WHERE id = " .. getElementData(thePlayer, "dbid") .. "")
					exports["cr_mysql"]:query_free("UPDATE characters SET bankmoney = " .. getElementData(targetPlayer, "bankmoney") + miktar .. " WHERE id = " .. getElementData(targetPlayer, "dbid") .. "")
					setElementData(targetPlayer, "bankmoney", getElementData(targetPlayer, "bankmoney") + miktar)
					outputChatBox("[+] #FFFFFF" .. targetPlayerName .. " isimli oyuncuya başarıyla " .. miktar .. "$ yolladınız.", thePlayer, 255, 255, 0, true)
					outputChatBox("[+] #FFFFFF" .. getPlayerName(thePlayer) .. " isimli oyuncudan " .. miktar .. "$ geldi.", targetPlayer, 0, 255, 0, true)
				else
					outputChatBox("[!]#FFFFFF Para gönderemek istediğiniz kişi şuanda oyunda değil.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Bankanızda " .. miktar .. "$ olmadığı için para yollayamadınız.", thePlayer, 255, 0, 0, true)		
			end
		else
			outputChatBox("[!]#FFFFFF Para yollamak için 3 Saatinizin olması gerekiyor lütfen sabırla bekleyiniz.", thePlayer, 255, 0, 0, true)
		end
	end
end)