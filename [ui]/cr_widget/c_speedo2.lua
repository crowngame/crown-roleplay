local screenSize = Vector2(guiGetScreenSize())
local screenX, screenY = screenSize.x - 20, (screenSize.y) / 2

local font = exports.cr_fonts:getFont("Pricedown", 20)

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").speedo == 2 then
			if getPedOccupiedVehicle(localPlayer) then
				local theVehicle = getPedOccupiedVehicle(localPlayer)
				local speed = math.floor(getElementSpeed(theVehicle, "kmh"))
				local fuel = getElementData(theVehicle, "fuel") or 100
				dxDrawFramedText("#08c186HIZ:#ffffff " .. speed .. " KM/H\n#169cc4YAKIT:#ffffff " .. fuel .. " LT", screenX, screenY - 18, screenX, 0, tocolor(255, 255, 255, 255), 1, font, "right")
			end
		end
	end
end, 0, 0)

function dxDrawFramedText(message, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left + 1, top + 1, width + 1, height + 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, true)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left + 1, top - 1, width + 1, height - 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, true)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left - 1, top + 1, width - 1, height + 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, true)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left - 1, top - 1, width - 1, height - 1, tocolor(0, 0, 0, 255), scale, font, alignX, alignY, clip, wordBreak, postGUI, true)
    dxDrawText(message, left, top, width, height, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, true)
end