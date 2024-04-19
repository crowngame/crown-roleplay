addCommandHandler("surukle", function(thePlayer, commandName, targetPlayerNick)
	if getElementData(thePlayer, "loggedin") == 1 then
		if getElementData(thePlayer, "surukle") then
			outputChatBox("[!]#FFFFFF Aynı anda birden fazla kişi sürükleyemezsiniz!", thePlayer, 255, 0, 0, true)
			return false
		end
		
		local faction = getElementData(thePlayer, "faction")
	
		if (faction == 1) or (faction == 3) then
			if not (targetPlayerNick) then
				outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
			
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						exports.cr_global:applyAnimation(targetPlayer, "CRACK", "crckidle4", -1, false, false, false)
						attachElements(targetPlayer, thePlayer, 0, 1, 0)
						setElementData(thePlayer, "surukle", targetPlayer)
						setElementData(targetPlayer, "surukleniyor", true)
						setElementFrozen(targetPlayer, true)
						exports.cr_global:sendLocalMeAction(thePlayer, "sağ ve sol eli ile şahsın kelepçesinden tutarak çekiştirir.", false, true)
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahsı sürüklemektesiniz. Sürüklemeyi bırakmak için /suruklemeyibirak", thePlayer, 0, 255, 0, true)
						outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " isimli şahıs sizi sürüklüyor.", targetPlayer, 0, 255, 0, true)
					else
						outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
					end
				end
			end
		end
	end
end)

addCommandHandler("suruklemeyibirak", function(thePlayer, commandName)
	local surukle = getElementData(thePlayer, "surukle")
	if surukle then
		detachElements(surukle, thePlayer)
		setElementFrozen(surukle, false)
		setElementData(thePlayer, "surukle", false)
		setElementData(surukle, "surukleniyor", false)
		local targetPlayerName = getPlayerName(surukle)
		exports.cr_global:sendLocalMeAction(thePlayer, "sağ ve sol elini şahsın kelepçesinden çeker.", false, true)
		outputChatBox("[!]#FFFFFF " .. targetPlayerName .. " isimli şahsı sürüklemeyi bıraktınız.", thePlayer, 0, 255, 0, true)
		exports.cr_global:removeAnimation(surukle)
		outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer).. " sizi sürüklemeyi bıraktı.", surukle, 0, 255, 0, true)
	else
		outputChatBox("[!]#FFFFFF Şu anda hiçkimseyi sürüklememektesiniz.", thePlayer, 255, 0, 0, true)
	end
end)