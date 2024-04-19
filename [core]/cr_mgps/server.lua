local gpsBlips = {}
local gpsMarkers = {}

function intBul(thePlayer, commandName, intID)
	local playerID = getElementData(thePlayer, "dbid")
	if not intID then
		outputChatBox("KULLANIM: /" .. commandName .. " [Kapı Numarası]", thePlayer, 255, 194, 14)
		return false
	end
	if not gpsBlips[playerID] then
		local interior = exports.cr_pool:getElement("interior", intID)
		if interior then
			if exports.cr_global:hasItem(thePlayer, 2) then
				local intposX, intposY, intposZ = getElementPosition(interior)
				gpsBlips[playerID] = createBlip(intposX, intposY, intposZ, 19, 2, 255, 0, 0, 255, 0, 99999.0, thePlayer)
				gpsMarkers[playerID] = createMarker(intposX, intposY, intposZ, "checkpoint", 3, 255, 0, 0, 255, thePlayer)
				attachElements(gpsMarkers[playerID], interior)
				attachElements(gpsBlips[playerID], interior)
				if gpsBlips[playerID] then
					outputChatBox("[!]#FFFFFF Belirtilen kapı numarası GPS'inizde işaretlendi.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!]#FFFFFF İşareti kaldırmak için (/kgps) yazınız.", thePlayer, 0, 255, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Bu işlemi yapabilmek için Telefon sahibi olmalısınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	else
		outputChatBox("[!]#FFFFFF GPS zaten çalışıyor, kapatmak için (/kgps)", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("intbul", intBul, false, false)
addCommandHandler("interiorbul", intBul, false, false)
addCommandHandler("evbul", intBul, false, false)
addCommandHandler("mgps", intBul, false, false)
addCommandHandler("gps", intBul, false, false)

function kgpsFunc(thePlayer, commandName)
	local playerID = getElementData(thePlayer, "dbid")
	if gpsBlips[playerID] then
		destroyElement(gpsMarkers[playerID])
		gpsMarkers[playerID] = false
		destroyElement(gpsBlips[playerID])
		gpsBlips[playerID] = false
		outputChatBox("[!]#FFFFFF Kapı numarası GPS'i kaldırıldı.", thePlayer, 0, 255, 0, true)
	end
end
addCommandHandler("kgps", kgpsFunc, false, false)