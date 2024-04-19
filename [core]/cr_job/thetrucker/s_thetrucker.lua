function truckerPay(thePlayer)
    local vipLevel = getElementData(thePlayer, "vip") or 0
    local miktar = 850

    if vipLevel == 1 then
        miktar = 900
    elseif vipLevel == 2 then
        miktar = 1100
    elseif vipLevel == 3 then
        miktar = 1250
    elseif vipLevel == 4 then
        miktar = 1350
    end

    exports.cr_global:giveMoney(thePlayer, miktar)
    outputChatBox("[!]#FFFFFF Tebrikler, bu turdan $" .. miktar .. " kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("trucker:pay", true)
addEventHandler("trucker:pay", getRootElement(), truckerPay)


function tstopJob(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	
	setElementPosition(thePlayer, 2273.498046875, -2348.6064453125, 13.546875)
	setElementRotation(thePlayer, 0, 0, 316)
end
addEvent("trucker:exitVeh", true)
addEventHandler("trucker:exitVeh", getRootElement(), tstopJob)

function createTrailer(type)
	if tonumber(type) == 1 then
		veh = createVehicle(435, 2267.8115234375, -2401.49609375, 14.040822982788, 0, 0, 312.48352050781)
	else
		veh = createVehicle(435, -1687.44921875, 25.59375, 4.0749635696411, 0, 0, 47.428588867188)
	end
	--setElementData(veh, "dbid", -1, true)
	setElementData(veh, "fuel", exports["cr_vehicle-fuel"]:getMaxFuel(veh), false)
	--setElementData(veh, "plate", "TIR", true)
	setElementData(veh, "Impounded", 0)
	setElementData(veh, "engine", 1, false)
	setElementData(veh, "oldx", x, false)
	setElementData(veh, "oldy", y, false)
	setElementData(veh, "oldz", z, false)
	setElementData(veh, "faction", -1)
	setElementData(veh, "job", 6, false)
	setElementData(veh, "handbrake", 0, true)
	return veh
end
addEvent("trucker:createTrailer", true)
addEventHandler("trucker:createTrailer", root, createTrailer)

--[[
function destroyTrailer()
	if getElementData(source, "job") == 6 then
		destroyElement(source)
	end
end
addEventHandler("onTrailerDetach", getRootElement(), destroyTrailer)]]

function destroyTrailer(veh)
	if getElementData(veh, "job") == 6 then
		destroyElement(veh)
	end
end
addEvent("trucker:destroyTrailer", true)
addEventHandler("trucker:destroyTrailer", getRootElement(), destroyTrailer)