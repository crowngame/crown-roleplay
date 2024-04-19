function setCarToGoGridlistRow (player, vehname, text, state)
local text = tostring(text)
local veh = tostring(vehname)
local state = tostring(state)

triggerClientEvent(getRootElement(), "setGridList", getRootElement(), veh, text, state)
end

function flashOlustur(player, x, y, z, rz, int, zaman)
	if client ~= source then return end
	
	local vehShopData = exports["cr_vehicle-manager"]:getInfoFromVehShopID(621)
	local gerekenPara = 300
	if zaman == 14400000 then
		gerekenPara = gerekenPara * 4
	elseif zaman == 10800000 then
		gerekenPara = gerekenPara * 3
	elseif zaman == 7200000 then
		gerekenPara = gerekenPara * 2
	elseif zaman == 3600000 then
		gerekenPara = gerekenPara
	end
	
	if (exports.cr_global:hasMoney(player, gerekenPara)) then
		exports.cr_global:sendLocalText(source, "Mike Johnson: Aracınızı yan taraftan alabilirsiniz!", 255, 255, 255, 10, {}, true)
		exports.cr_global:takeMoney(player, gerekenPara)
		local x = tonumber(x)
		local y = tonumber(y)
		local z = tonumber(z)
		local rz = tonumber(rz)
		local int = tonumber(int)
		local veh = createVehicle(getVehicleModelFromName("Flash"), x, y, z, 0, 0, rz, "KIRALIK")
		
		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		setVehicleVariant(veh, exports['cr_vehicle']:getRandomVariant(getElementModel(veh)))

		setElementData(veh, "dbid", -getElementData(player, "dbid"))
		setElementData(veh, "fuel", exports["cr_vehicle-fuel"]:getMaxFuel(veh))
		setElementData(veh, "plate", "KIRALIK")
		setElementData(veh, "Impounded", 0)
		setElementData(veh, "engine", 0)
		setElementData(veh, "oldx", x)
		setElementData(veh, "oldy", y)
		setElementData(veh, "oldz", z)
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", getElementData(player, "dbid"))
		setElementData(veh, "job", 0)
		setElementData(veh, "handbrake", 0)
		
		setElementData(veh, "brand", vehShopData.vehbrand)
		setElementData(veh, "maximemodel", vehShopData.vehmodel)
		setElementData(veh, "year", vehShopData.vehyear)
		setElementData(veh, "vehicle_shop_id", vehShopData.id)
		
		exports.cr_global:giveItem(player, 3, -getElementData(player, "dbid"))

		setElementData(player, "kiralanmis", true)
		
		warpPedIntoVehicle(player, veh, 0)
		setTimer(function() 
			exports["cr_items"]:deleteAll(3, -getElementData(player, "dbid"))
			destroyElement(veh) 
			outputChatBox("Aracınız dükkana geri gönderildi!", player, 255, 0, 0) 
			setElementData(source, "kiralanmis", false)
		end, zaman, 1)
		addEventHandler("onPlayerQuit", function()
			setElementData(source, "kiralanmis", false) 
			exports["cr_items"]:deleteAll(3, -getElementData(player, "dbid")) 
			destroyElement(veh) 
		end)
	else
		exports.cr_global:sendLocalText(player, "Mike Johnson: Üzgünüm efendim, yeterli paranız yok.", 255, 255, 255, 10, {}, true)
		setCarToGoGridlistRow(player, "flash", "Müsait", "hayır")
	end
end
addEvent("flashOlustur", true)
addEventHandler("flashOlustur", getRootElement(), flashOlustur)

function premierOlustur (player, x, y, z, rz, int, zaman)
	if client ~= source then return end
	
	local vehShopData = exports["cr_vehicle-manager"]:getInfoFromVehShopID(214)
	local gerekenPara = 450
	if zaman == 14400000 then
		gerekenPara = gerekenPara * 4
	elseif zaman == 10800000 then
		gerekenPara = gerekenPara * 3
	elseif zaman == 7200000 then
		gerekenPara = gerekenPara * 2
	elseif zaman == 3600000 then
		gerekenPara = gerekenPara
	end
	
	if (exports.cr_global:hasMoney(player, gerekenPara)) then
		exports.cr_global:sendLocalText(source, "Mike Johnson: Aracınızı yan taraftan alabilirsiniz!", 255, 255, 255, 10, {}, true)
		exports.cr_global:takeMoney(player, gerekenPara)
		local x = tonumber(x)
		local y = tonumber(y)
		local z = tonumber(z)
		local rz = tonumber(rz)
		local int = tonumber(int)
		local veh = createVehicle(getVehicleModelFromName("Premier"), x, y, z, 0, 0, rz, "KIRALIK")
		
		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		setVehicleVariant(veh, exports['cr_vehicle']:getRandomVariant(getElementModel(veh)))

		setElementData(veh, "dbid", -getElementData(player, "dbid"))
		setElementData(veh, "fuel", exports["cr_vehicle-fuel"]:getMaxFuel(veh))
		setElementData(veh, "plate", "KIRALIK")
		setElementData(veh, "Impounded", 0)
		setElementData(veh, "engine", 0)
		setElementData(veh, "oldx", x)
		setElementData(veh, "oldy", y)
		setElementData(veh, "oldz", z)
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", getElementData(player, "dbid"))
		setElementData(veh, "job", 0)
		setElementData(veh, "handbrake", 0)
		
		setElementData(veh, "brand", vehShopData.vehbrand)
		setElementData(veh, "maximemodel", vehShopData.vehmodel)
		setElementData(veh, "year", vehShopData.vehyear)
		setElementData(veh, "vehicle_shop_id", vehShopData.id)
		
		exports.cr_global:giveItem(player, 3, -getElementData(player, "dbid"))
	
		setElementData(player, "kiralanmis", true)
		
		warpPedIntoVehicle(player, veh, 0)
		setTimer(function() 
			exports["cr_items"]:deleteAll(3, -getElementData(player, "dbid"))
			destroyElement(veh) 
			outputChatBox("Aracınız dükkana geri gönderildi!", player, 255, 0, 0) 
			setElementData(player, "kiralanmis", false)
		end, zaman, 1)
		addEventHandler("onPlayerQuit", function() setElementData(source, "kiralanmis", false) exports["cr_items"]:deleteAll(3, -getElementData(player, "dbid")) destroyElement(veh) end)
	else
		exports.cr_global:sendLocalText(source, "Mike Johnson: Üzgünüm efendim, yeterli paranız yok.", 255, 255, 255, 10, {}, true)
		setCarToGoGridlistRow(player, "premier", "Müsait", "hayır")
	end
end
addEvent("premierOlustur", true)
addEventHandler("premierOlustur", getRootElement(), premierOlustur)

function tampaOlustur (player, x, y, z, rz, int, zaman)
	if client ~= source then return end
	
	local vehShopData = exports["cr_vehicle-manager"]:getInfoFromVehShopID(798)
	local gerekenPara = 200
	if zaman == 14400000 then
		gerekenPara = gerekenPara * 4
	elseif zaman == 10800000 then
		gerekenPara = gerekenPara * 3
	elseif zaman == 7200000 then
		gerekenPara = gerekenPara * 2
	elseif zaman == 3600000 then
		gerekenPara = gerekenPara
	end
	
	if (exports.cr_global:hasMoney(player, gerekenPara)) then
		exports.cr_global:sendLocalText(source, "Mike Johnson: Aracınızı yan taraftan alabilirsiniz!", 255, 255, 255, 10, {}, true)
		exports.cr_global:takeMoney(player, gerekenPara)
		local x = tonumber(x)
		local y = tonumber(y)
		local z = tonumber(z)
		local rz = tonumber(rz)
		local int = tonumber(int)
		local veh = createVehicle(getVehicleModelFromName("Tampa"), x, y, z, 0, 0, rz, "KIRALIK")
		
		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		setVehicleVariant(veh, exports['cr_vehicle']:getRandomVariant(getElementModel(veh)))

		setElementData(veh, "dbid", -getElementData(player, "dbid"))
		setElementData(veh, "fuel", exports["cr_vehicle-fuel"]:getMaxFuel(veh))
		setElementData(veh, "plate", "KIRALIK")
		setElementData(veh, "Impounded", 0)
		setElementData(veh, "engine", 0)
		setElementData(veh, "oldx", x)
		setElementData(veh, "oldy", y)
		setElementData(veh, "oldz", z)
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", getElementData(player, "dbid"))
		setElementData(veh, "job", 0)
		setElementData(veh, "handbrake", 0)
		
		setElementData(veh, "brand", vehShopData.vehbrand)
		setElementData(veh, "maximemodel", vehShopData.vehmodel)
		setElementData(veh, "year", vehShopData.vehyear)
		setElementData(veh, "vehicle_shop_id", vehShopData.id)
		
		exports.cr_global:giveItem(player, 3, -getElementData(player, "dbid"))

		setElementData(player, "kiralanmis", true)
		
		warpPedIntoVehicle(player, veh, 0)
		setTimer(function() 
			exports["cr_items"]:deleteAll(3, -getElementData(player, "dbid"))
			destroyElement(veh) 
			outputChatBox("Aracınız dükkana geri gönderildi!", player, 255, 0, 0) 
			setElementData(player, "kiralanmis", false)
		end, zaman, 1)
		addEventHandler("onPlayerQuit", function() setElementData(source, "kiralanmis", false) exports["cr_items"]:deleteAll(3, -getElementData(player, "dbid")) destroyElement(veh) end)
	else
		exports.cr_global:sendLocalText(source, "Mike Johnson: Üzgünüm efendim, yeterli paranız yok.", 255, 255, 255, 10, {}, true)
		setCarToGoGridlistRow(player, "tampa", "Müsait", "hayır")
	end
end
addEvent("tampaOlustur", true)
addEventHandler("tampaOlustur", getRootElement(), tampaOlustur)

function bobcatOlustur (player, x, y, z, rz, int, zaman)
	if client ~= source then return end
	
	local vehShopData = exports["cr_vehicle-manager"]:getInfoFromVehShopID(171)
	local gerekenPara = 350
	if zaman == 14400000 then
		gerekenPara = gerekenPara * 4
	elseif zaman == 10800000 then
		gerekenPara = gerekenPara * 3
	elseif zaman == 7200000 then
		gerekenPara = gerekenPara * 2
	elseif zaman == 3600000 then
		gerekenPara = gerekenPara
	end
	
	if (exports.cr_global:hasMoney(player, gerekenPara)) then
		exports.cr_global:sendLocalText(source, "Mike Johnson: Aracınızı yan taraftan alabilirsiniz!", 255, 255, 255, 10, {}, true)
		exports.cr_global:takeMoney(player, gerekenPara)
		local x = tonumber(x)
		local y = tonumber(y)
		local z = tonumber(z)
		local rz = tonumber(rz)
		local int = tonumber(int)
		local veh = createVehicle(getVehicleModelFromName("Bobcat"), x, y, z, 0, 0, rz, "KIRALIK")
		
		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		setVehicleVariant(veh, exports['cr_vehicle']:getRandomVariant(getElementModel(veh)))

		setElementData(veh, "dbid", -getElementData(player, "dbid"))
		setElementData(veh, "fuel", exports["cr_vehicle-fuel"]:getMaxFuel(veh))
		setElementData(veh, "plate", "KIRALIK")
		setElementData(veh, "Impounded", 0)
		setElementData(veh, "engine", 0)
		setElementData(veh, "oldx", x)
		setElementData(veh, "oldy", y)
		setElementData(veh, "oldz", z)
		setElementData(veh, "faction", -1)
		setElementData(veh, "owner", getElementData(player, "dbid"))
		setElementData(veh, "job", 0)
		setElementData(veh, "handbrake", 0)
		
		setElementData(veh, "brand", vehShopData.vehbrand)
		setElementData(veh, "maximemodel", vehShopData.vehmodel)
		setElementData(veh, "year", vehShopData.vehyear)
		setElementData(veh, "vehicle_shop_id", vehShopData.id)
		
		exports.cr_global:giveItem(player, 3, -getElementData(player, "dbid"))
	
		setElementData(player, "kiralanmis", true)
		
		warpPedIntoVehicle(player, veh, 0)
		setTimer(function() 
			exports["cr_items"]:deleteAll(3, -getElementData(player, "dbid"))
			destroyElement(veh) 
			outputChatBox("Aracınız dükkana geri gönderildi!", player, 255, 0, 0) 
			setElementData(player, "kiralanmis", false)
		end, zaman, 1)
		addEventHandler("onPlayerQuit", function() setElementData(source, "kiralanmis", false) exports["cr_items"]:deleteAll(3, -getElementData(player, "dbid")) destroyElement(veh) end)
	else
		exports.cr_global:sendLocalText(source, "Mike Johnson: Üzgünüm efendim, yeterli paranız yok.", 255, 255, 255, 10, {}, true)
		setCarToGoGridlistRow(player, "bobcat", "Müsait", "hayır")
	end
end
addEvent("bobcatOlustur", true)
addEventHandler("bobcatOlustur", getRootElement(), bobcatOlustur)

-- addCommandHandler("kira", function(thePlayer) setElementData(thePlayer, "kiralanmis", false) end)

function qwebronaptin()
    setElementData(source, "nametag1selected", true)
end
addEventHandler("onPlayerJoin", root, qwebronaptin)