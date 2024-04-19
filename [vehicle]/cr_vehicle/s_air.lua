local listedekiler = {}
local myTimer = {}

addEvent("air:indir", true)
addEventHandler("air:indir", root, function()
	if not getElementData(source, "air:kullaniyor") then
		if source.vehicle then
			if getElementVelocity(source.vehicle) == 0 then
				if exports["cr_items"]:hasItem(source.vehicle, 314) then
					local orjinal = (getVehicleHandling(source.vehicle)["suspensionUpperLimit"]*-0.8)
					local ayar = (getVehicleHandling(source.vehicle)["suspensionLowerLimit"])
					if (ayar - 0.3 < orjinal - 0.1) then
						setVehicleHandling(source.vehicle,"suspensionLowerLimit",ayar + 0.1)
						triggerClientEvent(root, "playVehicleSound", root, "sounds/airride.mp3", source.vehicle)
						source.vehicle:setData("air:default", nil)
						setElementData(client, "air:kullaniyor", 1, false)
						listedekiler[#listedekiler + 1] = source
						myTimer[source] = setTimer(function()
							local player = listedekiler[1]
							table.remove(listedekiler, 1)
							removeElementData(player, "air:kullaniyor")
						end, 3000, 1)
					end
				end
			end
		end
	end
end)

addEvent("air:kaldir", true)
addEventHandler("air:kaldir", root, function()
	if not getElementData(source, "air:kullaniyor") then
		if source.vehicle then
			if getElementVelocity(source.vehicle) == 0 then
				if exports["cr_items"]:hasItem(source.vehicle, 314) then
					local orjinal = (getVehicleHandling(source.vehicle)["suspensionUpperLimit"]*-1.5)
					local ayar = (getVehicleHandling(source.vehicle)["suspensionLowerLimit"])
					if (ayar - 0.2 > orjinal - 0.3) then
						setVehicleHandling(source.vehicle,"suspensionLowerLimit",ayar - 0.1)
						triggerClientEvent(root, "playVehicleSound", root, "sounds/airride.mp3", source.vehicle)
						source.vehicle:setData("air:default", nil)
						setElementData(client, "air:kullaniyor", 1, false)
						listedekiler[#listedekiler + 1] = source
						myTimer[source] = setTimer(function()
							local player = listedekiler[1]
							table.remove(listedekiler, 1)
							removeElementData(player, "air:kullaniyor")
						end, 3000, 1)
					end
				end
			end
		end
	end
end)
 
addEvent("air:sifirla", true)
addEventHandler("air:sifirla", root, function()
	if not getElementData(source, "air:kullaniyor") then
		if source.vehicle then
			if getElementVelocity(source.vehicle) == 0 then
				if exports["cr_items"]:hasItem(source.vehicle, 314) then
					if not source.vehicle:getData("air:default") then
						setVehicleHandling (source.vehicle, "suspensionLowerLimit", nil)
						source.vehicle:setData("air:default", true)
						triggerClientEvent(root, "playVehicleSound", root, "sounds/airride.mp3", source.vehicle)
						setElementData(client, "air:kullaniyor", 1, false)
						listedekiler[#listedekiler + 1] = source
						myTimer[source] = setTimer(function()
							local player = listedekiler[1]
							table.remove(listedekiler, 1)
							removeElementData(player, "air:kullaniyor")
						end, 3000, 1)
					end
				end
			end
		end
	end
end)