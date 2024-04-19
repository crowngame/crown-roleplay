function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
	removePedFromVehicle(player)
	setElementData(player, "realinvehicle", 0, false)

	return triggerClientEvent(player,"doSetFreecamEnabled", getRootElement(), x, y, z, dontChangeFixedMode)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", getRootElement(), dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
	return isEnabled(player)
end

--Farid's rework
function asyncActivateFreecam ()
	if client ~= source then return end
	if not isEnabled(source) then
		outputDebugString("[FREECAM] asyncActivateFreecam / Ran")
		removePedFromVehicle(source)
		setElementAlpha(source, 0)
		setElementFrozen(source, true)
		if not exports.cr_integration:isPlayerTrialAdmin(source) then
			exports.cr_global:sendMessageToAdmins("[FREECAM] " .. exports.cr_global:getAdminTitle1(source) .. " has activated temporary /freecam.")
		end
		setElementData(source, "freecam:state", true, false)
		exports.cr_logs:dbLog(source, 4, {source}, "FREECAM")
	end
end
addEvent("freecam:asyncActivateFreecam", true)
addEventHandler("freecam:asyncActivateFreecam", root, asyncActivateFreecam)

function asyncDeactivateFreecam ()
	if client ~= source then return end
	if true or isEnabled(source) then
		outputDebugString("[FREECAM] asyncDeactivateFreecam / Ran")
		removePedFromVehicle(source)
		setElementAlpha(source, 255)
		setElementFrozen(source, false)
		setElementData(source, "freecam:state", false, false)
	end
end
addEvent("freecam:asyncDeactivateFreecam", true)
addEventHandler("freecam:asyncDeactivateFreecam", root, asyncDeactivateFreecam)