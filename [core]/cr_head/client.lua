local screenSize = Vector2(guiGetScreenSize())

function getScreenRotationFromWorldPosition(targetX, targetY, targetZ)
    local camX, camY, _, lookAtX, lookAtY = getCameraMatrix()
    local camRotZ = math.atan2 ((lookAtX - camX), (lookAtY - camY))
    local dirX = targetX - camX
    local dirY = targetY - camY
    local dirRotZ = math.atan2(dirX,dirY)
    local relRotZ = dirRotZ - camRotZ
    return math.deg(relRotZ)
end

setTimer(function()
	for _, player in ipairs(getElementsByType("player"), root, true) do
		local rot = getPedCameraRotation(player)
		local x, y, z = getElementPosition(player)
		local sx, sy = getScreenFromWorldPosition(x, y, z)
		local sxx, syy = guiGetScreenSize()
		local vx = x + math.sin(math.rad(rot)) * 10
		local vy = y + math.cos(math.rad(rot)) * 10
		local _, _, vz = getWorldFromScreenPosition(sxx, syy, 1)
		
		if getElementData(player, "head_turning") then
			setPedAimTarget(player, vx, vy, vz)
			setPedLookAt(player, vx, vy, vz)
		end
	end
end, 1000, 0)

function headTurning(thePlayer, commandName)
	if getElementData(localPlayer, "head_turning") then
		outputChatBox("[!]#FFFFFF Kafa çevirme başarıyla kapatıldı.", 255, 0, 0, true)
		setElementData(localPlayer, "head_turning", false)
	else
		outputChatBox("[!]#FFFFFF Kafa çevirme başarıyla açıldı.", 0, 255, 0, true)
		setElementData(localPlayer, "head_turning", true)
	end
end
addCommandHandler("kafa", headTurning, false, false)
addCommandHandler("kafacevir", headTurning, false, false)
addCommandHandler("headturning", headTurning, false, false)