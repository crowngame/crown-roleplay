function canAccessManager(thePlayer)
	if not thePlayer then
		thePlayer = localPlayer
	end
	
	if not localPlayer then
		return false
	end
	
	if exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
		return true
	end
	return false
end