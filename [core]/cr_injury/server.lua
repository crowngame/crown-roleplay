local mysql = exports.cr_mysql

local injuryPlayers = {}
local weapons = {
	[4] = true,
	[22] = true,
	[23] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
	[29] = true,
	[30] = true,
	[31] = true,
	[32] = true,
	[33] = true,
	[34] = true,
}

addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
	if isElement(attacker) then
		if not injuryPlayers[source] then
			setElementData(source, "injury", 1)
			
			injuryPlayers[source] = {}
			injuryPlayers[source].player = source
			injuryPlayers[source].timer = setTimer(function(player)
				if injuryPlayers[player] then
					local thePlayer = injuryPlayers[player].player
					
					if not isElement(thePlayer) then
						if isTimer(injuryPlayers[thePlayer].timer) then killTimer(injuryPlayers[thePlayer].timer) end
						return
					end
					
					if getElementData(thePlayer, "injury") ~= 1 then
						if isTimer(injuryPlayers[thePlayer].timer) then killTimer(injuryPlayers[thePlayer].timer) end
						return
					end
					
					local health = getElementHealth(thePlayer)
					if health > 20 then
						setElementHealth(thePlayer, health - 10)
					end
				end
			end, 1000 * 120, 0, source)
		end
	end
end)

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if theKey == "injury" then
		if getElementData(source, "injury") ~= 1 then
			if injuryPlayers[source] and isTimer(injuryPlayers[source].timer) then killTimer(injuryPlayers[source].timer) end
			injuryPlayers[source] = nil
		end
	end
end)