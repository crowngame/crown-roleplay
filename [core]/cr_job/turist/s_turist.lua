function turistParaVer(thePlayer)
    local vipID = getElementData(thePlayer, "vip") or 0
    local paraMiktar = 0

    if vipID == 1 then
        paraMiktar = 550
    elseif vipID == 2 then
        paraMiktar = 650
    elseif vipID == 3 then
        paraMiktar = 750
    elseif vipID == 4 then
        paraMiktar = 850
    else
        paraMiktar = 450
    end

    exports.cr_global:giveMoney(thePlayer, paraMiktar)
    outputChatBox("[!]#FFFFFF Tebrikler, bu turdan $" .. paraMiktar .. " kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("turistParaVer", true)
addEventHandler("turistParaVer", getRootElement(), turistParaVer)
