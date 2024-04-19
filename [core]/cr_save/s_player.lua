mysql = exports.cr_mysql
local playersToBeSaved = { }

function beginSave()

	for key, value in ipairs(getElementsByType("player")) do

		table.insert(playersToBeSaved, value)
	end
	local timerDelay = 0
	for key, thePlayer in ipairs(playersToBeSaved) do
		timerDelay = timerDelay + 1000
		setTimer(savePlayer, timerDelay, 1, "Save All", thePlayer)
	end
end

function syncTIS()
	for key, value in ipairs(getElementsByType("player")) do
		local tis = getElementData(value, "timeinserver")
		if (tis) and (getPlayerIdleTime(value) < 600000)  then
			setElementData(value, "timeinserver", tonumber(tis)+1, false)
		end
	end
end
setTimer(syncTIS, 60000, 0)

function savePlayer(reason, player)
	if source ~= nil then
		player = source
	end
	if isElement(player) then
		local logged = getElementData(player, "loggedin")
		if (logged==1 or reason=="Change Character") then
			local vehicle = getPedOccupiedVehicle(player)
		
			if (vehicle) then
				local seat = getPedOccupiedVehicleSeat(player)
				triggerEvent("onVehicleExit", vehicle, player, seat)
			end
		
			local x, y, z, rot, health, armour, interior, dimension, cuffed, skin, duty, timeinserver, businessprofit, alcohollevel
		
			local x, y, z = getElementPosition(player)
			local rot = getPedRotation(player)
			local health = getElementHealth(player)
			local armor = getPedArmor(player)
			local interior = getElementInterior(player)
			local dimension = getElementDimension(player)
			local alcohollevel = getElementData(player, "alcohollevel")
			local d_addiction = (getElementData(player, "drug.1") or 0) .. ";" .. (getElementData(player, "drug.2") or 0) .. ";" .. (getElementData(player, "drug.3") or 0) .. ";" .. (getElementData(player, "drug.4") or 0) .. ";" .. (getElementData(player, "drug.5") or 0) .. ";" .. (getElementData(player, "drug.6") or 0) .. ";" .. (getElementData(player, "drug.7") or 0) .. ";" .. (getElementData(player, "drug.8") or 0) .. ";" .. (getElementData(player, "drug.9") or 0) .. ";" .. (getElementData(player, "drug.10") or 0)
			money = getElementData(player, "stevie.money")
			if money and money > 0 then
				money = 'money = money + ' .. money .. ', '
			else
				money = ''
			end
			skin = getElementModel(player)
			
			local hunger = getElementData(player, "hunger")
			local thirst = getElementData(player, "thirst")
		
			if getElementData(player, "help") then
				dimension, interior, x, y, z = unpack(getElementData(player, "help"))
			end
		
			-- Fix for #0000984
			if getElementData(player, "businessprofit") and (reason == "Quit" or reason == "Timed Out" or reason == "Unknown" or reason == "Bad Connection" or reason == "Kicked" or reason == "Banned") then
				businessprofit = 'bankmoney = bankmoney + ' .. getElementData(player, "businessprofit") .. ', '
			else
				businessprofit = ''
			end
		
			-- Fix for freecam-tv
			if exports['cr_freecam-tv']:isPlayerFreecamEnabled(player) then 
				x = getElementData(player, "tv:x")
				y = getElementData(player, "tv:y")
				z =  getElementData(player, "tv:z")
				interior = getElementData(player, "tv:int")
				dimension = getElementData(player, "tv:dim") 
			end
		
			local timeinserver = getElementData(player, "timeinserver")
			-- LAST AREA
			local zone = exports.cr_global:getElementZoneName(player)
			if not zone or #zone == 0 then
				zone = "Unknown"
			end
		
			local update = dbExec(mysql:getConnection(), "UPDATE characters SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', rotation='" .. mysql:escape_string(rot) .. "', health='" .. mysql:escape_string(health) .. "', armor='" .. mysql:escape_string(armor) .. "', dimension_id='" .. mysql:escape_string(dimension) .. "', interior_id='" .. mysql:escape_string(interior) .. "', " .. mysql:escape_string(money) .. mysql:escape_string(businessprofit) .. "lastlogin=NOW(), lastarea='" .. mysql:escape_string(zone) .. "', timeinserver='" .. mysql:escape_string(timeinserver) .. "', alcohollevel='" ..  mysql:escape_string(tostring(alcohollevel))  .. "', hunger='" .. mysql:escape_string(hunger) .. "', thirst='" .. mysql:escape_string(thirst) .. "' WHERE id=" .. mysql:escape_string(getElementData(player, "dbid")))
			local update2 = dbExec(mysql:getConnection(), "UPDATE accounts SET lastlogin=NOW() WHERE id = " .. mysql:escape_string(getElementData(player,"account:id")))
		end
	end
end
addEventHandler("onPlayerQuit", root, savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", root, savePlayer)
setTimer(beginSave, 3600000, 0)

addCommandHandler("saveall", function(thePlayer, commandName)
	if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		for _, player in ipairs(getElementsByType("player")) do
			savePlayer("Save All", player)
		end
		outputChatBox("[!]#FFFFFF Başarılı!", thePlayer, 0, 255, 0, true)
	end
end)