local mysql = exports.cr_mysql
local colSphere = createColSphere(2638.958984375, -2117.013671875, 13.546875, 5)

function destroyVehicle(thePlayer, commandName)
	if isElementWithinColShape(thePlayer, colSphere) then 
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			local dbid = getElementData(theVehicle, "dbid")
			if dbid and dbid > 0 then
				if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") then
					if not exports.cr_market:isPrivateVehicle(getElementModel(theVehicle)) then
						local price = math.floor((getElementData(theVehicle, "carshop:cost") or 0) / 2)

						if dbExec(mysql:getConnection(), "UPDATE vehicles SET deleted = 1 WHERE id = ?", dbid) then
							destroyElement(theVehicle)
							exports.cr_global:giveMoney(thePlayer, price)
							outputChatBox("[!]#FFFFFF Başarıyla '" .. exports.cr_global:getVehicleName(theVehicle) .. "' (" .. dbid .. ") isimli aracınızı parçalatarak $" .. exports.cr_global:formatMoney(price) .. " miktar para kazandınız.", thePlayer, 0, 255, 0, true)
							triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
						else
							outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
						end
					else
						outputChatBox("[!]#FFFFFF Özel araçları parçalayamazsınız.", thePlayer, 255, 0, 0, true)
						playSoundFrontEnd(thePlayer, 4)
					end
				else
					outputChatBox("[!]#FFFFFF Bu araç size ait değil.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
				end
			else
				outputChatBox("[!]#FFFFFF Bu aracı parçalayamazsınız.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end 
	end 
end
addCommandHandler("parcalat", destroyVehicle, false, false)

function neKadar(thePlayer)
	if isElementWithinColShape(thePlayer, colSphere) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			local price = math.floor((getElementData(theVehicle, "carshop:cost") or 0) / 2)
			outputChatBox("[!]#FFFFFF Parçalama fiyatı: $" .. exports.cr_global:formatMoney(price), thePlayer, 0, 0, 255, true)
		end
	end
end
addCommandHandler("nekadar", neKadar, false, false)