player = {}
thePed = {}
marker = {}
marker_hospital = {}
blip = {}
player.colshape = createColSphere(2016.03125, -1432.146484375, 13.545955657959, 30)
player.hospital = createColSphere(2031.9521484375, -1414.7451171875, 16.9921875, 10)
mesleksayi = 0
hastane = {}
hastane_ped = {}
function test()
	print(mesleksayi)
end 
addCommandHandler("testet", test)

player.startjob = function(thePlayer, commandName, arg1)
	if getElementData(thePlayer, "loggedin") == 1 then 
		if arg1 == "basla" then
			local theVehicle = getPedOccupiedVehicle(thePlayer) 
			if not theVehicle then return false end
			if getElementModel(theVehicle) == 416 then
				if mesleksayi > 0 then 
					if not getElementData(thePlayer, "ambulance:started") then
						return outputChatBox("[!]#FFFFFF Zaten aktif bir ambulans şoförü var.", thePlayer, 255, 0, 0, true) 
					end
				end
				if getElementData(thePlayer, "ambulance:started") then return outputChatBox("[!]#FFFFFF Zaten mesleğe başladınız.", thePlayer, 255, 0, 0, true) end
				if not isElementWithinColShape(thePlayer, player.colshape) then return outputChatBox("[!]#FFFFFF Meslek bölgesinde olmadan başlayamazsınız.", thePlayer, 255, 0, 0, true) end
				if var then return end
				local random = math.random(1, 8)
				local x, y, z = randomPos[random][1], randomPos[random][2], randomPos[random][3]
				setElementData(thePlayer, "ambulance:started", true)
				outputChatBox("[!]#FFFFFF Mesleğe başarıyla başladınız.", thePlayer, 0, 255, 0, true)
				mesleksayi = mesleksayi + 1
				marker[thePlayer] = createMarker (x, y, z, "checkpoint", 7, 251, 0, 255, 180, thePlayer)
				thePed[thePlayer] = createPed(240, x, y, z, randomPos[random][6])
				hastane_ped[thePlayer] = createPed(183, 2039.587890625, -1416.2412109375, 17.17077445983, 97)
				player.hospital = createColSphere(2031.9521484375, -1414.7451171875, 16.9921875, 10)
				triggerClientEvent(thePlayer, 'hastablip', thePlayer, true, thePed[thePlayer])
				setTimer(setPedAnimation, 1000, 1, thePed[thePlayer], "CRACK", "crckidle1", -1, true, false, false)
				thePed.colshape = createColSphere(x, y, z, 7)
				addEventHandler("onColShapeHit", thePed.colshape, function(thePlayer)
					if isElement(thePed.colshape) then
						if getElementData(thePlayer, "ambulance:started") then
							triggerClientEvent(thePlayer, 'hastablip', thePlayer, false, thePed[thePlayer])
							destroyElement(thePed.colshape)
							destroyElement(marker[thePlayer])
							setElementFrozen(theVehicle, true)
							outputChatBox("[!]#FFFFFF Hasta aracınıza biniyor lütfen bekleyin.", thePlayer, 0, 0, 255, true)
							setTimer(function()
								warpPedIntoVehicle(thePed[thePlayer], theVehicle, 3)
								setElementFrozen(theVehicle, false)
								setElementData(thePlayer, "ambulance:patient", true)
								triggerClientEvent(thePlayer, 'hastaneblip', thePlayer, true, hastane_ped[thePlayer])
								marker_hospital[thePlayer] = createMarker (2030.03515625, -1417.8408203125, 17.098867416382, "checkpoint", 7, 251, 0, 255, 180, thePlayer)
							end, 2000, 1, thePlayer)
						end
					end
				end)

				addEventHandler("onColShapeHit", player.hospital, function(thePlayer)
					if isElement(player.hospital) then
						if getElementData(thePlayer, "ambulance:patient") then
							triggerClientEvent(thePlayer, 'hastaneblip', thePlayer, false, hastane_ped[thePlayer])
							destroyElement(player.hospital)
							destroyElement(marker_hospital[thePlayer])
							setElementFrozen(theVehicle, true)
							outputChatBox("[!]#FFFFFF Hasta, hastaneye sevk ediliyor lütfen bekleyin.", thePlayer, 0, 0, 255, true)
							setTimer(function() 
								removePedFromVehicle(thePed[thePlayer])
								destroyElement(thePed[thePlayer])
								setElementFrozen(theVehicle, false)
								setElementData(thePlayer, "ambulance:patient", false)
								exports.cr_global:giveMoney(thePlayer, 500)
								outputChatBox("[!]#FFFFFF Hastayı hastaneye sevk ettiniz.", thePlayer, 0, 255, 0, true)
								mesleksayi = mesleksayi - 1
								setElementData(thePlayer, "ambulance:started", false)
								executeCommandHandler("ambulans", thePlayer, "basla")
							end, 2000, 1, thePlayer)
						end
					end
				end)
			end
		elseif arg1 == "ayril" then
			if getElementData(thePlayer, "ambulance:started") then
				setElementData(thePlayer, "ambulance:started", false)
				setElementData(thePlayer, "ambulance:patient", false)
				if isEventHandlerAdded(thePlayer, 'hastaneblip', thePlayer, true, hastane_ped[thePlayer]) then
					removeEventHandler(thePlayer, 'hastaneblip', thePlayer, true, hastane_ped[thePlayer])
				end 
				if isElement(thePed[thePlayer]) then
					if isEventHandlerAdded(thePlayer, 'hastablip', thePlayer, true, thePed[thePlayer]) then
						removeEventHandler(thePlayer, 'hastablip', thePlayer, true, thePed[thePlayer])
					end
				end
				if isElement(thePed[thePlayer]) then destroyElement(thePed[thePlayer]) end
				if isElement(marker_hospital[thePlayer]) then destroyElement(marker_hospital[thePlayer]) end
				if isElement(player.hospital) then destroyElement(player.hospital) end
				if isElement(marker[thePlayer]) then destroyElement(marker[thePlayer]) end
				mesleksayi = mesleksayi - 1
			end
		end
	end
end
addCommandHandler("ambulans", player.startjob)

player.start = function()
	for i, v in ipairs(getElementsByType("player")) do 
		setElementData(v, "ambulance:started", false)
		setElementData(v, "ambulance:patient", false)
	end
end
addEventHandler("onResourceStart", resourceRoot, player.start)

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

player.exitveh = function(theVehicle, seat, jacked)
	if getElementModel(theVehicle) == 416 then
		if getElementData(source, "ambulance:started") then 
			executeCommandHandler("ambulans", source, "ayril")
			removePedFromVehicle(source)
			respawnVehicle(theVehicle)
			setElementPosition(source, 2039.349609375, -1412.9013671875, 17.1640625)
		end 
	end
end
addEventHandler("onPlayerVehicleExit", root, player.exitveh)