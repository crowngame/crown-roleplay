local mysql = exports.cr_mysql

function banList(thePlayer, commandName)
	if exports.cr_integration:isPlayerManagement(thePlayer) then
        local bans = {}
        local clientBans = {}
		
		for _, ban in ipairs(getBans()) do
        	table.insert(bans, {getBanNick(ban), getBanAdmin(ban), getBanReason(ban), getBanIP(ban), getBanSerial(ban)})
        end
		
		local query = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM bans"), -1)
		if (query) then
			for i, bans in ipairs(query) do
            	table.insert(clientBans, {bans["id"], bans["serial"], bans["admin"], bans["reason"], bans["date"]})
            end
        end

        triggerClientEvent(thePlayer, "bans:openWindow", thePlayer, bans, clientBans)
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("bans", banList, false, false)

addEvent("bans:removeBan", true)
addEventHandler("bans:removeBan", root, function(type, data)
	if client ~= source then return end
	if type == 1 then
		removeBanFromSerial(data)
		outputChatBox("[!]#FFFFFF Başarıyla [" .. data .. "] numaralı serialin banını kaldırıldı.", source, 0, 255, 0, true)
		exports.cr_global:sendMessageToAdmins("[UNBAN] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili [" .. data .. "] serialin banını kaldırdı.")
		exports.cr_discord:sendMessage("ban-log", "[UNBAN] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili [" .. data .. "] serialin banını kaldırdı.")
	elseif type == 2 then
		dbExec(mysql:getConnection(), "DELETE FROM bans WHERE id = ?", data)
		outputChatBox("[!]#FFFFFF Başarıyla [" .. data .. "] ID'li ban kaldırıldı.", source, 0, 255, 0, true)
		exports.cr_global:sendMessageToAdmins("[UNCBAN] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili [" .. data .. "] ID'li banı kaldırdı.")
		exports.cr_discord:sendMessage("ban-log", "[UNCBAN] " .. exports.cr_global:getPlayerFullAdminTitle(source) .. " isimli yetkili [" .. data .. "] ID'li banı kaldırdı.")
	end
end)

function removeBanFromSerial(serial)
	for _, ban in ipairs(getBans()) do
		if serial == getBanSerial(ban) then
			removeBan(ban)
		end
    end
end