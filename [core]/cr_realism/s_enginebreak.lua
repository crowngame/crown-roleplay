function engineBreak()
	local health = getElementHealth(source)
	local driver = getVehicleController(source)
	local vehID = getElementData(source, "dbid")
	
	if (driver) then
		if (health<=300) then
			local rand = math.random(1, 2)

			if (rand==1) then -- 50% chance
				setVehicleEngineState(source, false)
				setElementData(source, "engine", 0, false)
				exports.cr_global:sendLocalDoAction(driver, "Aracınızın motoru arızalandı.")
				-- Take key / Give key to player when engine off by Anthony
				if exports['cr_global']:hasItem(source, 3, vehID) then
					exports['cr_global']:takeItem(source, 3, vehID)
					exports['cr_global']:giveItem(driver, 3, vehID)
				else
				end
			end
		elseif (health<=400) then
			local rand = math.random(1, 5)

			if (rand==1) then -- 20% chance
				setVehicleEngineState(source, false)
				setElementData(source, "engine", 0, false)
				exports.cr_global:sendLocalDoAction(driver, "Aracınızın motoru arızalandı.")
				-- Take key / Give key to player when engine off by Anthony
				if exports['cr_global']:hasItem(source, 3, vehID) then
					exports['cr_global']:takeItem(source, 3, vehID)
					exports['cr_global']:giveItem(driver, 3, vehID)
				else
				end
			end
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), engineBreak)