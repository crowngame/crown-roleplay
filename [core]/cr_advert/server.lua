addEvent("advertisement.send", true)
addEventHandler("advertisement.send", root, function(text)
	if client ~= source then return end
	
	exports.cr_global:takeMoney(source, 100)
	outputChatBox("[!]#FFFFFF Reklamınız kabul edildi, 10 saniye sonra gönderilecektir.", source, 0, 255, 0, true)
	triggerClientEvent(source, "playSuccessfulSound", source)
	
	local playerItems = exports.cr_items:getItems(source)
	local phoneNumber = "-"
	for index, value in ipairs(playerItems) do
		if value[1] == 2 then
			phoneNumber = value[2]
		end
	end
	
	setTimer(function(player)
		outputChatBox("[LSN] " .. text, root, 0, 255, 0)
		outputChatBox("[LSN] İletişim: " .. phoneNumber .. " // " .. getPlayerName(player):gsub("_", " "), root, 0, 255, 0)
	end, 10 * 1000, 1, source)
end)