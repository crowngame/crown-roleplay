local miktar = 750

function cpay(thePlayer)
    local vipLevel = getElementData(thePlayer, "vip") or 0

    if vipLevel == 1 then
        miktar = 845
    elseif vipLevel == 2 then
        miktar = 975
    elseif vipLevel == 3 then
        miktar = 1020
    elseif vipLevel == 4 then
        miktar = 1250
    end

    exports.cr_global:giveMoney(thePlayer, miktar)
    outputChatBox("[!]#FFFFFF Tebrikler, bu turdan $" .. miktar .. " kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("cigar:pay", true)
addEventHandler("cigar:pay", getRootElement(), cpay)

function cstopJob(thePlayer)
    local pedVeh = getPedOccupiedVehicle(thePlayer)
    removePedFromVehicle(thePlayer)
    respawnVehicle(pedVeh)
    setElementPosition(thePlayer, 2455.34765625, -2643.5400390625, 13.662845611572)
    setElementRotation(thePlayer, 0, 0, 267.11743164063)
end
addEvent("cigar:exitVeh", true)
addEventHandler("cigar:exitVeh", getRootElement(), cstopJob)
