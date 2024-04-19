local miktar = 885

function alcoholPay(thePlayer)
    local vipLevel = getElementData(thePlayer, "vip") or 0

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
addEvent("alcohol:pay", true)
addEventHandler("alcohol:pay", getRootElement(), alcoholPay)

function alcoholStopJob(thePlayer)
    local pedVeh = getPedOccupiedVehicle(thePlayer)
    removePedFromVehicle(thePlayer)
    respawnVehicle(pedVeh)
    -- setElementPosition(thePlayer, 2579.0166015625, -2424.84765625, 13.635452270508)
    -- setElementRotation(thePlayer, 0, 0, 312.48065185547)
end
addEvent("alcohol:exitVeh", true)
addEventHandler("alcohol:exitVeh", getRootElement(), alcoholStopJob)
