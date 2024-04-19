local miktar = 650

function trashparaVer(thePlayer)
    local vipID = getElementData(thePlayer, "vip") or 0

    if vipID == 1 then
        miktar = 750
    elseif vipID == 2 then
        miktar = 850
    elseif vipID == 3 then
        miktar = 950
    elseif vipID == 4 then
        miktar = 1050
    else
        miktar = 650
    end

    exports.cr_global:giveMoney(thePlayer, miktar)
    outputChatBox("[!]#FFFFFF Tebrikler, bu turdan $" .. miktar .. " kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("trashparaVer", true)
addEventHandler("trashparaVer", getRootElement(), trashparaVer)
