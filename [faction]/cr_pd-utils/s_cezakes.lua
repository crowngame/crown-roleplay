function cezaKes(thePlayer, commandName, amount, ...)
	if (getElementData(thePlayer, "faction") == 1) or (getElementData(thePlayer, "faction") == 3) then
		amount = tonumber(amount)
		if amount then
			if (...) then
				if amount > 0 then
					local plate = table.concat({...}, " ")
					local foundVehicle = nil
					
					for k, v in ipairs(exports.cr_pool:getPoolElementsByType("vehicle")) do
						if plate == getElementData(v, "plate") then
							foundVehicle = v
						end
					end
					
					if foundVehicle ~= nil then
						local px, py, pz = getElementPosition(thePlayer)
						local vx, vy, vz = getElementPosition(foundVehicle)
						local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
						if distance <= 10 then
							local dbid = getElementData(foundVehicle, "dbid")
							if dbid and dbid > 0 then
								local punishment = getElementData(foundVehicle, "punishment") or 0
								dbExec(mysql:getConnection(), "UPDATE vehicles SET punishment = " .. punishment + amount .. " WHERE id = " .. dbid)
								setElementData(foundVehicle, "enginebroke", 1)
								setElementData(foundVehicle, "punishment", punishment + amount)
								exports.cr_global:sendLocalMeAction(thePlayer, "ceza makbuzunu aracın camı ile sileceğin arasına sıkıştırır.")
							else
								outputChatBox("[!]#FFFFFF Bu araca ceza kesemezsiniz.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
						else
							outputChatBox("[!]#FFFFFF '" .. getElementData(foundVehicle, "plate") .. "' plakalı araca yeterince yakın değilsiniz.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Bu plakalı araç bulunamadı.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Lütfen geçerli bir ceza tutarı giriniz.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [Ceza Tutarı] [Plaka]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [Ceza Tutarı] [Plaka]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("[!]#FFFFFF Bu işlemi yalnızca legal birlik üyeleri yapabilir.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("cezakes", cezaKes, false, false)