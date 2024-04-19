function getVehiclesOwnedByCharacter(thePlayer)
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	
	local carids = { }
	local numcars = 0
	local indexcars = 1
	for key, value in ipairs(exports.cr_pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))

		if (owner) and (owner==dbid) then
			local id = getElementData(value, "dbid")
			carids[numcars+1] = id
			numcars = numcars + 1
		end
	end
	return numcars, carids
end

function canPlayerBuyVehicle(thePlayer)
	if (isElement(thePlayer)) then
		if getElementData(thePlayer, "loggedin") == 1 then
			local maxvehicles = getElementData(thePlayer, "maxvehicles") or 0
			local novehicles, veharray = getVehiclesOwnedByCharacter(thePlayer)
			if (novehicles < maxvehicles) then
				return true
			end
			return false, "Too much vehicles" 
			
		end
		return false, "Player not logged in"
	end
	return false, "Element not found"
end

function isVehicleEmpty(vehicle)
    if not isElement(vehicle) or getElementType(vehicle) ~= "vehicle" then
        return true
    end

    local passengers = getVehicleMaxPassengers(vehicle)
    if type(passengers) == "number" then
        for seat = 4, passengers do
            if getVehicleOccupant(vehicle, seat) then
                return false
            end
        end
    end
    return true
end

addEventHandler("onVehicleStartEnter", root, function(thePlayer, seat, jacked)
	if jacked and seat == 0 then
		cancelEvent(true)
		outputChatBox("[!]#FFFFFF Binmeye çalıştığınız arabanın sürücü koltuğunda birisi var.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end)