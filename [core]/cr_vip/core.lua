local mysql = exports.cr_mysql
vipPlayers = {}

addEventHandler("onResourceStart", resourceRoot, function()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					loadVIP(row.char_id)
				end
			end
		end,
	mysql:getConnection(), "SELECT `char_id` FROM `vipPlayers`")
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in pairs(getElementsByType("player")) do
		local charID = tonumber(getElementData(player, "dbid"))
		if charID then
			saveVIP(charID)
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	local charID = getElementData(source, "dbid")
	if not charID then return false end
	saveVIP(charID)
end)

function loadVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local vipType = tonumber(row["vip_type"]) or 0
					local endTick = tonumber(row["vip_end_tick"]) or 0
					if vipType > 0 then
						vipPlayers[charID] = {}
						vipPlayers[charID].type = vipType
						vipPlayers[charID].endTick = endTick
						local targetPlayer = exports.cr_global:getPlayerFromCharacterID(charID)
						if targetPlayer then
							setElementData(targetPlayer, "vip", vipType)
						end
					else 
						setElementData(targetPlayer, "vip", 0)
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `vip_type`, `vip_end_tick` FROM `vipPlayers` WHERE char_id='" .. charID .. "'")
end

function saveVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	if not vipPlayers[charID] then return false end
	
	local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick='" .. (vipPlayers[charID].endTick) .. "' WHERE char_id=" .. charID .. " LIMIT 1")
	if not success then
		outputDebugString("@vipsystem_Core_S: mysql hatası. 79.satır")
		return
	end
end

function removeVIP(charID)
	if not vipPlayers[charID] then return false end	
	local query = dbExec(mysql:getConnection(), "DELETE FROM `vipPlayers` WHERE char_id=" .. charID .. " LIMIT 1")
	if query then
		local targetPlayer = exports.cr_global:getPlayerFromCharacterID(charID)
		if targetPlayer then
			setElementData(targetPlayer, "vip", 0)
			outputChatBox("[!]#FFFFFF VIP süreniz doldu.", targetPlayer, 0, 0, 255, true)
		end
		vipPlayers[charID] = nil
		return true
	end
	return false
end

function checkExpireTime()
	for charID, data in pairs(vipPlayers) do
		if (charID and data) then
			if vipPlayers[charID] then
				if vipPlayers[charID].endTick and vipPlayers[charID].endTick <= 0 then

					local success = removeVIP(charID)
					if success then
					end

				elseif vipPlayers[charID].endTick and vipPlayers[charID].endTick > 0 then

					vipPlayers[charID].endTick = math.max(vipPlayers[charID].endTick - (60 * 1000), 0)
					saveVIP(charID)
					
					if vipPlayers[charID].endTick == 0 then
						local success = removeVIP(charID)
						if success then
						end
					end

				end
			end
		end
	end
end
setTimer(checkExpireTime, 60 * 1000, 0)