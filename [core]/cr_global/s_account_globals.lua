function getCharacterIDFromName(charName)
	if not charName then return false end
	charName = string.gsub(charName, " ", "_")
	local query = exports.cr_mysql:query_fetch_assoc("SELECT `id` FROM characters WHERE `charactername`='" .. exports.cr_mysql:escape_string(charName) .. "' LIMIT 1")
	if query then
		local id = tonumber(query["id"])
		exports.cr_mysql:free_result(query)
		if id > 0 then
			return id
		end
	end
	return false
end
function getCharacterNameFromID(charID)
	if not charID then return false end
	local query = exports.cr_mysql:query_fetch_assoc("SELECT `charactername` FROM characters WHERE `id`='" .. exports.cr_mysql:escape_string(charID) .. "' LIMIT 1")
	if query then
		local charName = tostring(query["charactername"])
		exports.cr_mysql:free_result(query)
		if charName then
			return charName
		end
	end
	outputDebugString("getCharacterNameFromID(): Unable",2)
	return false
end

local userNamesCache = {}
function getUserNameFromID(userID)
	if not userID then return false end
	if userNamesCache[userID] then
		return userNamesCache[userID]
	end
	local query = exports.cr_mysql:query_fetch_assoc("SELECT `username` FROM accounts WHERE `id`='" .. mysql:escape_string(tostring(userID)) .. "' LIMIT 1")
	if query then
		local userName = tostring(query["username"])
		exports.cr_mysql:free_result(query)
		if userName then
			userNamesCache[userID] = userName
			return userName
		end
	end
	outputDebugString("getUserNameFromID(): Unable",2)
	return false
end

function getPlayerFromCharacterID(charID)
	local players = exports.cr_pool:getPoolElementsByType("player")
	for k,v in ipairs(players) do
		if(tonumber(getElementData(v, "dbid")) == tonumber(charID)) then
			return v
		end
	end
	return false
end

function getPlayerFromSerial(serial)
	for key, value in ipairs(getElementsByType("player")) do
		if getPlayerSerial(value) == serial then
			return value
		end
	end
	return false
end