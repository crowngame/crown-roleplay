function toggleLaser(thePlayer)
	local laser = getElementData(thePlayer, "laser")
	
	if not (laser) then
		setElementData(thePlayer, "laser", true, true)
		outputChatBox("Your weapon laser is now ON.",thePlayer, 0, 255, 0)
	else
		setElementData(thePlayer, "laser", false, true)
		outputChatBox("Your weapon laser is now OFF.",thePlayer, 255, 0, 0)
	end
end
addCommandHandler("toglaser", toggleLaser, false)
addCommandHandler("togglelaser", toggleLaser, false)