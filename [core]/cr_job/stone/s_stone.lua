local miktar = 1000

function stonePay(thePlayer)
    local vipLevel = getElementData(thePlayer, "vip") or 0

    if vipLevel == 1 then
        miktar = 1100
    elseif vipLevel == 2 then
        miktar = 1200
    elseif vipLevel == 3 then
        miktar = 1300
    elseif vipLevel == 4 then
        miktar = 1400
    end

    exports.cr_global:giveMoney(thePlayer, miktar)
    outputChatBox("[!]#FFFFFF Tebrikler, bu turdan $" .. miktar .. " kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("stone:pay", true)
addEventHandler("stone:pay", getRootElement(), stonePay)

function stoneStopJob(thePlayer)
    local pedVeh = getPedOccupiedVehicle(thePlayer)
    removePedFromVehicle(thePlayer)
    respawnVehicle(pedVeh)
    setElementPosition(thePlayer, 2338.080078125, -2056.8310546875, 13.548931121826)
    setElementRotation(thePlayer, 0, 0, 91.822357177734)
end
addEvent("stone:exitVeh", true)
addEventHandler("stone:exitVeh", getRootElement(), stoneStopJob)
