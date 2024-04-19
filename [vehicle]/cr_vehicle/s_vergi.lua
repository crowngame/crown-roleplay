addCommandHandler("toplamvergi", 
	function(thePlayer)
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			outputChatBox("[!]#FFFFFF Aracın Toplam Vergisi: $" .. tostring(getElementData(theVehicle, "toplamvergi") or 0), thePlayer, 0, 0, 255, true)
		else
			outputChatBox("[!]#FFFFFF Herhangi bir araçta değilsiniz!", thePlayer, 255, 0, 0, true)
		end
	end
)