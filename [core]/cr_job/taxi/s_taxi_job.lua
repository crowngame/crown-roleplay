addEventHandler("onVehicleRespawn", getRootElement(),
	function()
		if isVehicleTaxiLightOn(source) then
			setVehicleTaxiLightOn(source, false)
		end
	end
)

addEventHandler("onVehicleStartExit", getRootElement(),
	function(player, seat, jacked)
		if isVehicleTaxiLightOn(source) then
			setVehicleTaxiLightOn(source, false)
		end
	end
)

function toggleTaxiLight(thePlayer, commandName)
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle then
		if getVehicleController(theVehicle) == thePlayer and getElementModel(theVehicle) == 420 or getElementModel(theVehicle) == 420 then
			setVehicleTaxiLightOn(theVehicle, not isVehicleTaxiLightOn(theVehicle))
		end
	end
end
addCommandHandler("taxilight", toggleTaxiLight, false, false)

local spamTimers = {}

function taksiReklam(thePlayer)
	if getElementData(thePlayer, "loggedin") == 1 then
		if getElementData(thePlayer, "job") == 2 then
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			if theVehicle then
				if not isTimer(spamTimers[thePlayer]) then
					if exports.cr_global:hasMoney(thePlayer, 50) then
						exports.cr_global:takeMoney(thePlayer, 50)

						local playerItems = exports["cr_items"]:getItems(thePlayer)
						local telefonNumarasi = "Yok"
						for index, value in ipairs(playerItems) do
							if value[1] == 2 then
								telefonNumarasi = value[2]
							end
						end

						outputChatBox("[T] Los Santos Taxi 7/24 Hizmetinizde! [" .. getPlayerName(thePlayer):gsub("_", " ") .. " - " .. telefonNumarasi .. "]", root, 0, 255, 0)
						triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)

						spamTimers[thePlayer] = setTimer(function() end, 300000, 1)
					else
						outputChatBox("[!]#FFFFFF Reklam vermek için yeterli paranız yok.", thePlayer, 255, 0, 0, true)
					end
				else
					outputChatBox("[!]#FFFFFF Her 5 dakikada bir taksi reklam gönderebilirsiniz.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Bu komutu taksi aracında iken kullanabilirsiniz.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("[!]#FFFFFF Bu komutu yalnızca Taksi Şoförleri kullanabilir.", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("taksireklam", taksiReklam)