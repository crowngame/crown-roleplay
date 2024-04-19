addEventHandler("onClientVehicleDamage", root, function()
    if (isVehicleEmpty(source) and exports.cr_global:getVehicleVelocity(source) < 10 and not getVehicleEngineState(source)) or source.health < 350 then
        cancelEvent()
    end
end)

setTimer(function()
    local nearbyVehicles = getElementsWithinRange(localPlayer.position, 20, "vehicle", localPlayer.interior, localPlayer.dimension)
    if #nearbyVehicles > 0 then
        for _, vehicle in ipairs(nearbyVehicles) do
            if vehicle.health < 350 or vehicle.type == "Boat" or vehicle.type == "BMX" then
                if not vehicle.damageProof then
                    setVehicleDamageProof(vehicle, true)
                end
            else
                if vehicle.damageProof then
                    setVehicleDamageProof(vehicle, false)
                end
            end
        end
    end
end, 200, 0)

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