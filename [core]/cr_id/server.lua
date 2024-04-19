local ids = {}

function playerJoin()
	local slot
	for i = 1, 5000 do
		if (ids[i] == nil) then
			slot = i
			break
		end
	end
	
	ids[slot] = source
	setElementData(source, "playerid", slot)
	exports.cr_pool:allocateElement(source, slot)
	idforname = "CRP." .. getElementData(source, "playerid")
	setPlayerName(source, idforname)
	exports.cr_discord:sendMessage("joinquit-log", "**[>]** **" .. getPlayerName(source):gsub("_", " ") .. "** sunucuya katıldı.\n**IP:** " .. getPlayerIP(source) .. "\n**Serial:** " .. getPlayerSerial(source))
end
addEventHandler("onPlayerJoin", root, playerJoin)

function playerQuit(reason)
	local slot = getElementData(source, "playerid")
	if (slot) then
		ids[slot] = nil
	end
	exports.cr_discord:sendMessage("joinquit-log", "**[<]** **" .. getPlayerName(source):gsub("_", " ") .. "** sunucuya katıldı. (" .. reason .. ")\n**IP:** " .. getPlayerIP(source) .. "\n**Serial:** " .. getPlayerSerial(source))
end
addEventHandler("onPlayerQuit", root, playerQuit)

for key, value in ipairs(getElementsByType("player")) do
	ids[key] = value
	setElementData(value, "playerid", key)
	exports.cr_pool:allocateElement(value, key)
end