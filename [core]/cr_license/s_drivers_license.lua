mysql = exports.cr_mysql

function giveCarLicense(usingGC)
	
	local theVehicle = getPedOccupiedVehicle(source)
	setElementData(source, "realinvehicle", 0, false)
	removePedFromVehicle(source)
	if theVehicle then 
		respawnVehicle(theVehicle)
		setElementData(theVehicle, "handbrake", 1, false)
		setElementFrozen(theVehicle, true)
	end
	setElementData(source, "license.car", 1)
	dbExec(mysql:getConnection(), "UPDATE characters SET car_license='1' WHERE charactername='" .. (getPlayerName(source)) .. "' LIMIT 1")
	setElementData(source, "license.bike", 1)
	dbExec(mysql:getConnection(), "UPDATE characters SET bike_license='1' WHERE charactername='" .. (getPlayerName(source)) .. "' LIMIT 1")
	setElementData(source, "license.boat", 1)
	dbExec(mysql:getConnection(), "UPDATE characters SET boat_license='1' WHERE charactername='" .. (getPlayerName(source)) .. "' LIMIT 1")
	----exports.cr_hud:sendBottomNotification(source, "Karatekin Sürücü Kursu", "Tebrikler! Başarıyla tüm gereken şeyleri tamamladınız.")
	exports["cr_infobox"]:addBox(source, "success", "Başarıyla ehliyet aldınız!")
	exports.cr_global:giveItem(source, 133, getPlayerName(source):gsub("_"," "))
	executeCommandHandler("stats", source, getPlayerName(source))
end
addEvent("acceptCarLicense", true)
addEventHandler("acceptCarLicense", getRootElement(), giveCarLicense)

function passTheory()
	setElementData(source,"license.car.cangetin",true, false)
	setElementData(source,"license.car",3) -- Set data to "theory passed"
	dbExec(mysql:getConnection(), "UPDATE characters SET car_license='3' WHERE charactername='" .. (getPlayerName(source)) .. "' LIMIT 1")
end
addEvent("theoryComplete", true)
addEventHandler("theoryComplete", getRootElement(), passTheory)

function checkDoLCars(player, seat)
	-- aka civilian previons	
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and getElementModel(source) == 410 then
		if getElementData(player,"license.car") == 3 then
			if getElementData(player, "license.car.cangetin") then
				----exports.cr_hud:sendBottomNotification(player, "Karatekin Sürücü Kursu", "'J' tuşuna basarak aracı çalıştırır, 'G' tuşuna basarak el frenini indirebilirsiniz.")
			else
				----exports.cr_hud:sendBottomNotification(player, "Karatekin Sürücü Kursu", "Bu aracı sadece ehliyet sorularını dolduranlar kullanabilir.")
				if not exports["cr_integration"]:isPlayerManagement(player) then
					cancelEvent()
				end
			end
		elseif seat > 0 then
			----exports.cr_hud:sendBottomNotification(player, "Karatekin Sürücü Kursu", "Bu aracı sadece ehliyet sorularını dolduranlar kullanabilir.")
			--cancelEvent()
		else
			----exports.cr_hud:sendBottomNotification(player, "Karatekin Sürücü Kursu", "Bu aracı sadece ehliyet sorularını dolduranlar kullanabilir.")
			if not exports["cr_integration"]:isPlayerManagement(player) then
				cancelEvent()
			end
		end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkDoLCars)