local screenSize = Vector2(guiGetScreenSize())
local screenX, screenY = screenSize.x - 20, screenSize.y - 80

local font = exports.cr_fonts:getFont("Bankgothic", 17)

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").speedo == 1 then
			if getPedOccupiedVehicle(localPlayer) then
				local theVehicle = getPedOccupiedVehicle(localPlayer)
				local speed = math.floor(getElementSpeed(theVehicle, "kmh"))
				local fuel = getElementData(theVehicle, "fuel") or 100
				exports.cr_ui:drawBorderedText(2, speed .. " KM/H\n" .. fuel .. " LT", screenX, screenY, screenX, 0, tocolor(225, 225, 230, 255), 1, font, "right")
			end
		end
	end
end, 0, 0)