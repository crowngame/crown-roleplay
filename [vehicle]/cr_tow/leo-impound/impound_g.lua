-- Farid / 2015.1.31

function getPlayerNameFirstLast(player)
	local name = exports.cr_global:getPlayerName(player)
	local parts = exports.cr_global:explode(" ", name)
	return parts[1], parts[#parts]
end