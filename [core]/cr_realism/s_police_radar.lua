addEventHandler("onVehicleEnter", getRootElement(),
	function(player)
		if exports.cr_global:hasItem(source, 84) then
			setTimer(triggerClientEvent, 1000, 1, player, "enablePoliceRadar", player)
		end
	end
)