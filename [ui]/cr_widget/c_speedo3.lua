local screnSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 75, 75
local screenX, screenY = (screnSize.x - sizeX) - 10, (screnSize.y - sizeY)

local fonts = {
    awesome = exports.cr_fonts:getFont("FontAwesome", 10),
    font1 = exports.cr_fonts:getFont("sf-bold", 27),
    font2 = exports.cr_fonts:getFont("sf-bold", 11),
}

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").speedo == 3 then
			if getPedOccupiedVehicle(localPlayer) then
				local theVehicle = getPedOccupiedVehicle(localPlayer)
				local vehs = math.floor(getElementSpeed(theVehicle, "kmh"))
				local speedText = getFormatSpeed(vehs)
				local fuel = getElementData(theVehicle, "fuel") or 100
				
				dxDrawText(speedText, screenX, screenY + 60, screenX + sizeX - 73, screenY, tocolor(255, 255, 255), 1, fonts.font1, "right", "center", false, false, false, true)
				dxDrawText("km/h", screenX, screenY + 63, screenX + sizeX - 30, screenY, tocolor(255, 255, 255), 1, fonts.font2, "right", "center", false, false, false, true)
				dxDrawText("", screenX, screenY + 67, screenX + sizeX, screenY, tocolor(255, 255, 255), 1, fonts.awesome, "right", "center", false, false, false, true)
				
				exports.cr_ui:drawRoundedRectangle(screenX + 59, screenY - 40 / 2, 10, 40, tocolor(70, 130, 84), {0.8, 0.8, 0.8, 0.8})
				exports.cr_ui:drawRoundedRectangle(screenX + 59, screenY - 40 / 2, 10, fuel / 2.50, tocolor(121, 220, 145), {0.8, 0.8, 0.8, 0.8})
				
				dxDrawImage(screenX - 105, screenY - 36 / 2, 150, 60, "images/speedo.png", 0, 0, 0, tocolor(170, 170, 170))
				dxDrawImageSection(screenX - 105, screenY - 36 / 2, vehs/2, 60, 0, 0, vehs / 2, 60, "images/speedo.png")
			end
		end
	end
end, 0, 0)