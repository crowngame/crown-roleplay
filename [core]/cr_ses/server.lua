local isSpeaker = false
speakerBox = {}

addCommandHandler("ses", function(thePlayer, commandName)
	if getElementData(thePlayer, "level") > 1 then
		if (isElement(speakerBox[thePlayer])) then isSpeaker = true end
		triggerClientEvent(thePlayer, "onPlayerViewSpeakerManagment", thePlayer, isSpeaker)
	else
		outputChatBox("[!]#FFFFFF Ses sistemini kullanabilmek için en az 2 seviye olmalısınız.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end)

addEvent("onPlayerPlaceSpeakerBox", true)
addEventHandler("onPlayerPlaceSpeakerBox", root, function(url, isCar) 
	if (url) then
		if (isElement(speakerBox[source])) then
			local x, y, z = getElementPosition(speakerBox[source]) 
			outputChatBox("[!]#FFFFFF Başarıyla ses kaldırıldı.", source, 255, 0, 0, true)
			destroyElement(speakerBox[source])
			removeEventHandler("onPlayerQuit", source, destroySpeakersOnPlayerQuit)
		end
		
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getElementRotation(source)
		local interior = getElementInterior(source)
		local dimension = getElementDimension(source)
		speakerBox[source] = createObject(2226, x - 0.5, y + 0.5, z - 1, 0, 0, rx)
		setElementInterior(speakerBox[source], interior)
		setElementDimension(speakerBox[source], dimension)
		outputChatBox("[!]#FFFFFF Başarıyla ses oluşturuldu.", source, 0, 255, 0, true)
		addEventHandler("onPlayerQuit", source, destroySpeakersOnPlayerQuit)
		triggerClientEvent(root, "onPlayerStartSpeakerBoxSound", root, source, url, isCar)
		
		if (isCar) then
			local car = getPedOccupiedVehicle(source)
			attachElements(speakerBox [source], car, -0.7, -1.5, -0.5, 0, 90, 0)
		end
	end
end)

addEvent("onPlayerDestroySpeakerBox", true)
addEventHandler("onPlayerDestroySpeakerBox", root, function()
	if (isElement(speakerBox[source])) then
		destroyElement(speakerBox[source])
		triggerClientEvent(root, "onPlayerDestroySpeakerBox", root, source)
		removeEventHandler("onPlayerQuit", source, destroySpeakersOnPlayerQuit)
		outputChatBox("[!]#FFFFFF Başarıyla ses kaldırıldı.", source, 255, 0, 0, true)
	else
		outputChatBox("[!]#FFFFFF Şuanda koyduğunuz ses bulunmuyor.", source, 255, 0, 0, true)
	end
end)

addEvent("onPlayerChangeSpeakerBoxVolume", true) 
addEventHandler("onPlayerChangeSpeakerBoxVolume", root, function(to)
	triggerClientEvent(root, "onPlayerChangeSpeakerBoxVolumeC", root, source, to)
end)

function destroySpeakersOnPlayerQuit ()
	if (isElement(speakerBox [source])) then
		destroyElement(speakerBox [source])
		triggerClientEvent(root, "onPlayerDestroySpeakerBox", root, source)
	end
end