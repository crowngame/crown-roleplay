local screenX, screenY = guiGetScreenSize()

setTimer(function()
	if isElementInWater(localPlayer) then
        local oxygen = screenX * getPedOxygenLevel(localPlayer) / 1000
        dxDrawRectangle(0, 0, screenX, 2, tocolor(155, 155, 155, 155))
        dxDrawRectangle(0, 0, oxygen, 2, tocolor(245, 245, 245))
    end
end, 0, 0)