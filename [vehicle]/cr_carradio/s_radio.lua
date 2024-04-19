function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	setElementData(vehicle, "vehicle:radio", station, true)
	setElementData(vehicle, "vehicle:radio:old", station, true)
end
addEvent("car:radio:sync", true)
addEventHandler("car:radio:sync", getRootElement(), syncRadio)

function syncRadio(vol)
	local vehicle = getPedOccupiedVehicle(source)
	setElementData(vehicle, "vehicle:radio:volume", vol, true)
	exports.cr_global:sendLocalMeAction(source, "aracının ses düzeyini değiştirdi.")
end
addEvent("car:radio:vol", true)
addEventHandler("car:radio:vol", getRootElement(), syncRadio)

addCommandHandler ("srd",
function (p)
	if exports.cr_integration:isPlayerTrialAdmin (p) then
		local x, y, z = getElementPosition (p)
		
		for i,v in ipairs (getElementsByType ("vehicle")) do
			local vx, vy, vz = getElementPosition (v)
			local distance = getDistanceBetweenPoints3D (x, y, z, vx, vy, vz)
			
			if distance < 200 then
				setElementData (v, "vehicle:radio:volume", 0, true)
			end
		end
		
		exports.cr_global:sendMessageToAdmins ("AdmWrn: " .. getPlayerName (p):gsub("_", " ") .. " has turned all radios off in district " .. getZoneName (x, y, z, false) .. ".")
	end
end)