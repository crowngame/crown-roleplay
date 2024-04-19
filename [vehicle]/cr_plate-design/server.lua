local mysql = exports.cr_mysql

function setVehiclePlateDesign(thePlayer, commandName, vehicleID, plateID)
	if exports.cr_integration:isPlayerHeadAdministrator(thePlayer) then
		vehicleID = tonumber(vehicleID)
		if vehicleID then
			plateID = tonumber(plateID)
			if plateID then
				if plateID >= 1 and plateID <= 5 then
					local theVehicle = exports.cr_pool:getElement("vehicle", vehicleID)
					if theVehicle then
						setElementData(theVehicle, "plate_design", plateID)
						mysql:query_free("UPDATE vehicles SET plate_design = '" .. mysql:escape_string(plateID) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
						outputChatBox("[!]#FFFFFF Başarıyla aracın plakası değiştirildi.", thePlayer, 0, 255, 0, true)
					else
						outputChatBox("[!]#FFFFFF Geçersiz Araç ID.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bu sayıya ait bir plaka bulunmuyor.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID] [Plaka ID (1-5)]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Araç ID] [Plaka ID (1-5)]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("setvehicleplatedesign", setVehiclePlateDesign, false, false)
addCommandHandler("setvehplatedesign", setVehiclePlateDesign, false, false)