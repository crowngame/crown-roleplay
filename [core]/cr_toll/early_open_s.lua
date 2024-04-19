function canAccessEarlyZone(theVehicle, thePlayer)
	if theVehicle and (getElementData(theVehicle, "lspd:siren") or getElementData(theVehicle, "lspd:siren1") or getElementData(theVehicle, "lspd:siren2") or getElementData(theVehicle, "lspd:siren3") or getElementData(theVehicle, "lspd:datdat")) then
		return true
	end
	return false and tonumber(pValue) == 1
end