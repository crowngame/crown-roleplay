local mysql = exports.cr_mysql

addEvent("wearable.buyItem", true)
addEventHandler("wearable.buyItem", root,
    function(player, modelID, price)
        local boneTable, bone = findThemBonePosition(modelID);
        if exports.cr_global:hasMoney(player, price) then
            if exports.cr_global:takeMoney(player, price) then
                outputChatBox("[!]#FFFFFF Aksesuarı başarıyla satın aldınız!", player, 0, 255, 0, true);
                dbExec(mysql:getConnection(), "INSERT INTO `wearables` SET `model` = ?, `owner` = ?, `x` = '0', `y` = '0', `z` = '0', `rx` = '0', `ry` = '0', `rz` = '0', `bone` = ?", tonumber(modelID), tonumber(player:getData("dbid")), tonumber(bone))
                triggerEvent("wearable.loadMyWearables", root, player)
            end
        else
            outputChatBox("[!]#FFFFFF Yeterli paranız olmadığı için aksesuarı satın alamadınız.", player, 255, 0, 0, true);
        end
    end
);

function findThemBonePosition(modelID)
    for index, value in ipairs(getWearables()) do
        for _, data in ipairs(value['list']) do
            if tonumber(data['modelid']) == tonumber(modelID) then
                return value['position'], value['bone']
            end
        end
    end
    return {0, 0, 0, 0, 0, 0, 1, 1, 1}, 1
end