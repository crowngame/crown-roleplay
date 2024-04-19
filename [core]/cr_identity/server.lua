function kimlikGoster(thePlayer, commandName, targetPlayer)
	if not (targetPlayer) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] ", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		local cinsiyet = getElementData(thePlayer, "gender")
		local gun = getElementData(thePlayer, "day")
		local ay = getElementData(thePlayer, "month")
		local yas = getElementData(thePlayer, "age")

		if targetPlayer then
			if targetPlayer == thePlayer then
				outputChatBox("[!]#FFFFFF Bu eylemi kendinize uygulayamazsınız!", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end
			
			if not getElementData(thePlayer, "kimlik") == true then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				local theVehicleT = getPedOccupiedVehicle(targetPlayer)
				
				if distance < 3 then
					outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli kişiye kimliğinizi gösterdiniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi size kimliğini gösterdi.", targetPlayer, 0, 0, 255, true)	
				else
					outputChatBox("[!]#FFFFFF Bir kişiye kimliğini gostermek için yanında olmalısın.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		end
	end
end
addCommandHandler("kimlikgoster", kimlikGoster, false, false)

function ehliyetGoster(thePlayer, commandName, targetPlayer)
	if not (targetPlayer) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID] ", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		local carlicense = getElementData(thePlayer, "license.car")
		local bikelicense = getElementData(thePlayer, "license.bike")
		local boatlicense = getElementData(thePlayer, "license.boat")
		local meslek = getElementData(thePlayer, "job")
		
		if (carlicense==1) then
			carlicense = "#66CCFF [Var]"
		elseif (carlicense==3) then
			carlicense = "#66CCFF [Teori testi geçti]"
		else
			carlicense = "#66CCFF [Yok]"
		end
		
		if (bikelicense==1) then
			bikelicense = "#66CCFF [Var]"
		elseif (bikelicense==3) then
			bikelicense = "#66CCFF [Var]"
		else
			bikelicense = "#66CCFF [Var]"
		end
		
		if (boatlicense==1) then
			boatlicense = "#66CCFF [Var]"
		else
			boatlicense = "#66CCFF [Var]"
		end
		
		if targetPlayer then
			if targetPlayer == thePlayer then
				outputChatBox("[!]#FFFFFF Bu eylemi kendinize uygulayamazsınız!", thePlayer, 255, 0, 0, true)
				return
			end
			
			if not getElementData(thePlayer, "ehliyet") == true then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				local theVehicle = getPedOccupiedVehicle(thePlayer)
				local theVehicleT = getPedOccupiedVehicle(targetPlayer)
				
				if distance < 3 then
				    outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli kişi size ehliyet durumunu gösterdi.", targetPlayer, 0, 255, 0, true)							
					outputChatBox("[!]#FFFFFF Araba ehliyeti:" ..  carlicense  .. "#FFFFFF - Motorsiklet ehliyeti:" ..  bikelicense  .. "#FFFFFF - Bot lisansı:" ..  boatlicense, targetPlayer, 0, 0, 255, true)
	                outputChatBox("[!]#FFFFFF " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli kişiye ehliyetinizi gösterdiniz.", thePlayer, 0, 0, 255, true)
				else
					outputChatBox("[!]#FFFFFF Bir kişiye kimliğini gostermek için yanında olmalısın.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			end
		end
	end
end
addCommandHandler("ehliyetgoster", ehliyetGoster, false, false)