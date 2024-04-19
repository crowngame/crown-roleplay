function updateItemThings()
--	setPlayerHudComponentVisible("radar", true)
end
addEvent("item:updateclient", true)
addEventHandler("item:updateclient", getRootElement(), updateItemThings)
addEventHandler("onCharacterLogin", getRootElement(), updateItemThings)
addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(), updateItemThings)
addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), updateItemThings)
