local weaponDistrict = {}

function giveMessage(weapon)
    if not weaponDistrict[source] then
		weaponDistrict[source] = true
		local x, y, z = getElementPosition(source)
		local players = getElementsWithinRange(x, y, z, 25)
		
		setTimer(function(element)
			weaponDistrict[element] = false
		end, 25000, 1, source)
		
		for _, player in ipairs(players) do
			outputChatBox("Bölge IC: Çevreden silah sesleri duyabilirsiniz. ((" .. getPlayerName(source):gsub("_", " ") .. ")) ", player, 255, 255, 255, true)
		end
	end
end
addEventHandler("onPlayerWeaponFire", root, giveMessage)