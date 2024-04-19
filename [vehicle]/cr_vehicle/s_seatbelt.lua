﻿local noBelt = { [431] = true, [437] = true }
local spamTimersSeatbeltWindow = {}

function seatbelt(thePlayer)
	if getPedOccupiedVehicle(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (getVehicleType(theVehicle) == "BMX" or getVehicleType(theVehicle) == "Bike") or (noBelt[getElementModel(theVehicle)] and getVehicleOccupant(theVehicle, 0) ~= thePlayer) then
			outputChatBox("[!]#FFFFFF Kullandığınız araçta emniyet kemeri bulunmamaktadır.", thePlayer, 255, 0, 0, true)
		else
			if isTimer(spamTimersSeatbeltWindow[thePlayer]) then return end
			if (getElementData(thePlayer, "seatbelt") == true) then
				triggerClientEvent(root, "playVehicleSound", root, "sounds/seatbelt.mp3", thePlayer)
				setElementData(thePlayer, "seatbelt", false, true)
				exports.cr_global:sendLocalMeAction(thePlayer, "sağ ve sol ellerini kemere götürür, kemerini çıkartır.")
			else
				triggerClientEvent(root, "playVehicleSound", root, "sounds/seatbelt.mp3", thePlayer)
				setElementData(thePlayer, "seatbelt", true, true)
				exports.cr_global:sendLocalMeAction(thePlayer, "sağ ve sol ellerini kemere götürür, kemerini takar.")
			end

			spamTimersSeatbeltWindow[thePlayer] = setTimer(function() end, 1500, 1)
		end
	end
end
addCommandHandler("seatbelt", seatbelt)
addCommandHandler("belt", seatbelt)
addEvent('realism:seatbelt:toggle', true)
addEventHandler('realism:seatbelt:toggle', root, seatbelt)

function removeSeatbelt(thePlayer)
	if getElementData(thePlayer, "seatbelt") and not isPedInVehicle(thePlayer) then
		triggerClientEvent(root, "playVehicleSound", root, "sounds/seatbelt.mp3", thePlayer)
		setElementData(thePlayer, "seatbelt", false, true)
		exports.cr_global:sendLocalMeAction(thePlayer, "sağ ve sol ellerini kemere götürür, kemerini çıkartır.")
	end
end
addEventHandler("onVehicleExit", getRootElement(), removeSeatbelt)