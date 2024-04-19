local zones = {
    {1911.296875, -1775.27734375, 13.411722183228, 5},
    {1017.71875, -917.8671875, 42.1796875, 5},
    {2064.4228515625, -1831.4716796875, 13.546875, 5},
}

for i = 1, #zones do
    local x, y, z, r = unpack(zones[i])
    zones[i] = {}
    zones[i].col = createColSphere(x, y, z, r)
end

function tamirMain(thePlayer)
    local theVehicle = getPedOccupiedVehicle(thePlayer)
    if theVehicle then
        for i, v in pairs(zones) do
            if isElementWithinColShape(thePlayer, v.col) then
                local vehicleHealth = getElementHealth(theVehicle)
                if vehicleHealth ~= 1000 then
                    local vehFactionID = getElementData(theVehicle, "faction") or 0
                    local vipID = getElementData(thePlayer, "vip") or 0

                    local price = math.floor(math.floor(1000 - vehicleHealth) * 0.2)
					
                    outputChatBox("[!]#FFFFFF Aracınız tamir ediliyor, lütfen bekleyin.", thePlayer, 0, 0, 255, true)
                    outputChatBox("[!]#FFFFFF Tamir fiyat: " .. price .. "$", thePlayer, 0, 0, 255, true)
                    toggleAllControls(thePlayer, false)
                    setElementFrozen(theVehicle, true)

                    setTimer(function()
                        if (vehFactionID == 1) or (vehFactionID == 2) or (vehFactionID == 3) then
							fixVehicle(theVehicle)
                            outputChatBox("[!]#FFFFFF Aracınızın tamir masrafı hükümet tarafından karşılandı.", thePlayer, 0, 255, 0, true)
							triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
                        elseif vipID > 0 then
							fixVehicle(theVehicle)
                            outputChatBox("[!]#FFFFFF VIP olduğunuz için hiç bir ücret ödemediniz.", thePlayer, 0, 255, 0, true)
							triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
                        else
							if exports.cr_global:hasMoney(thePlayer, price) then
								exports.cr_global:takeMoney(thePlayer, price)
								fixVehicle(theVehicle)
								outputChatBox("[!]#FFFFFF Aracınız başarıyla tamir edildi.", thePlayer, 0, 255, 0, true)
								triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
							else
								outputChatBox("[!]#FFFFFF Yeterli paranız yok.", thePlayer, 255, 0, 0, true)
								playSoundFrontEnd(thePlayer, 4)
							end
                        end
						
						toggleAllControls(thePlayer, true)
						setElementFrozen(theVehicle, false)
                    end, 5000, 1)
                else
                    outputChatBox("[!]#FFFFFF Zaten aracınız hasarlı değil.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            end
        end
    end
end
addCommandHandler("tamir", tamirMain, false, false)