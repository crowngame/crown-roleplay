local screenSize = Vector2(guiGetScreenSize())

local skullSize = {
    x = 32,
    y = 32
}

local skullPosition = {
    x = screenSize.x / 2 - skullSize.x / 2,
    y = screenSize.y - skullSize.y - 10
}

setTimer(function()
    if getElementData(localPlayer, "injury") == 1 then
		dxDrawImage(skullPosition.x, skullPosition.y, skullSize.x, skullSize.y, "images/injury.png")
	end
end, 0, 0)

setTimer(function()
	if getElementData(localPlayer, "injury") == 1 then
		if not getPedOccupiedVehicle(localPlayer) then
			local x, y, z = getElementPosition(localPlayer)
			fxAddBlood(x, y, z + 0.5, 0.00000, 0.00000, 0.00000, 0, 1)
		end
	end
end, 100, 0)