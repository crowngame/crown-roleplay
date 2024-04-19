local fixTimers = {}

function fixWithKit(thePlayer)
	local theVehicle = getNearestVehicle(thePlayer)
	if (theVehicle) then
		if getPedOccupiedVehicle(thePlayer) then
			outputChatBox("[!]#FFFFFF Araçtayken bu işlevi gerçekleştiremezsiniz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end
		
		if isTimer(fixTimers[thePlayer]) then
			outputChatBox("[!]#FFFFFF Zaten tamir işlemi yapıyorsunuz.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
			return
		end
		
		if exports.cr_global:hasItem(thePlayer, 515) then 
			local currVehHp = getElementHealth(theVehicle)
			if currVehHp >= 1000 then
				outputChatBox("[!]#FFFFFF Aracın tamir edilmesine ihtiyaç yok.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
				return
			end
			
			setElementFrozen(thePlayer, true)
			outputChatBox("[!]#FFFFFF Araç tamir ediliyor.", thePlayer, 0, 0, 255, true)
			exports.cr_global:applyAnimation(thePlayer, "bomber", "bom_plant", 15000, true, true, false)
			fixTimers[thePlayer] = setTimer(function()
				outputChatBox("[!]#FFFFFF Aracı başarıyla tamir ettiniz.", thePlayer, 0, 255, 0, true)
				exports.cr_global:takeItem(thePlayer, 515, 1)
				exports.cr_global:removeAnimation(thePlayer)
				setElementData(theVehicle, "enginebroke", 0)
				if currVehHp + 200 >= 1000 then 
					setElementHealth(theVehicle, 1000)
				end
				setElementHealth(theVehicle, currVehHp + 200)
				setElementFrozen(thePlayer, false)
			end, 15000, 1)
		else
			outputChatBox("[!]#FFFFFF Tamir kiti olmadan bu işlemi yapamazsınız.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
    else
        outputChatBox("[!]#FFFFFF Yanınızda bir araç olmadan bu komutu kullanamazsınız.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("tamirkit", fixWithKit, false, false)

function getNearestVehicle(thePlayer)  
    local x, y, z = getElementPosition(thePlayer)  
    local prevDistance  
    local nearestVehicle  
    for i, v in ipairs( getElementsByType( "vehicle" ) ) do  
        local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( v ) )  
        if (distance <= 5) then
            prevDistance = distance  
            nearestVehicle = v 
        end  
    end  
    return nearestVehicle or false  
end