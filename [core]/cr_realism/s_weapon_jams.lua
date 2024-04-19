--[[function toggleFiring(enabled, showJamMessage)
	toggleControl(source, "fire", enabled)
	
	if (showJamMessage) then
		exports.cr_global:sendLocalMeAction(source, "'s weapon jams.")
	end
end
addEvent("togglefiring", true)
addEventHandler("togglefiring", getRootElement(), toggleFiring)

function resourceStart(res)
	for key, value in ipairs(exports.cr_pool:getPoolElementsByType("player")) do
		toggleControl(value, "fire", true)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)

function weaponJammed()
	setElementData(source, "jammed", 1, false)
end
addEvent("jammed", true)
addEventHandler("jammed", getRootElement(), weaponJammed)

function weaponUnjammed()
	setElementData(source, "jammed", 0, false)
end
addEvent("notjammed", true)
addEventHandler("notjammed", getRootElement(), weaponUnjammed)

addEvent("onPlayerHeadshot")
addEventHandler("onPlayerDamage", getRootElement(),
	function (attacker, weapon, bodypart, loss)
		if bodypart == 9 then
			killPed(source, attacker, weapon, bodypart)
		end
	end
)]]