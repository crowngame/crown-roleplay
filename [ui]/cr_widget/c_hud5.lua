local screenSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 128, 128
local screenX, screenY = (screenSize.x - sizeX) - 50, 40

local fonts = {
    font1 = exports.cr_fonts:getFont("sf-bold", 10),
    font2 = exports.cr_fonts:getFont("sf-regular", 11),
    awesome1 = exports.cr_fonts:getFont("FontAwesome", 10),
}

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").hud == 5 then
			local weapon = getPedWeapon(localPlayer)
			dxDrawImage(screenX, screenY, sizeX, sizeX, "images/weapons/" .. weapon .. ".png")
			
			if bulletWeapons[weapon] then
				local ammo1 = getPedAmmoInClip(localPlayer, getPedWeaponSlot(localPlayer))
				local ammo2 = getPedTotalAmmo(localPlayer) - getPedAmmoInClip(localPlayer)
				
				exports.cr_ui:drawFramedText(ammo1 .. "/" .. ammo2, screenX, screenY + 105, screenX + 130, 0, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")
			end
			
			dxDrawRectangle(screenX - 1, screenY + sizeX, 64, 30, tocolor(10, 10, 10, 230))
			dxDrawText("", screenX + 6, screenY + sizeX + 7, 0, 0, tocolor(255, 0, 0, 255), 1, fonts.awesome1)
			dxDrawText(math.floor(getElementHealth(localPlayer)), screenX + 28, screenY + sizeX + 6, 0, 0, tocolor(255, 0, 0, 255), 1, fonts.font2)
			
			dxDrawRectangle(screenX + 65, screenY + sizeX, 64, 30, tocolor(10, 10, 10, 230))
			dxDrawText("", screenX + 71, screenY + sizeX + 7, 0, 0, tocolor(255, 255, 255, 220), 1, fonts.awesome1)
			dxDrawText(math.floor(getPedArmor(localPlayer)), screenX + 93, screenY + sizeX + 6, 0, 0, tocolor(255, 255, 255, 220), 1, fonts.font2)
			
			dxDrawRectangle(screenX - 1, screenY + sizeX + 32, sizeX + 2, 30, tocolor(10, 10, 10, 230))
			dxDrawText("", screenX + 6, screenY + sizeX + 39, 0, 0, tocolor(85, 152, 78, 255), 1, fonts.awesome1)
			dxDrawText(convertMoney(getElementData(localPlayer, "money")), screenX + 130, screenY + sizeX + 38, screenX, 0, tocolor(85, 152, 78, 255), 1, fonts.font2, "center")
			
			dxDrawRectangle(screenX - 1, screenY + sizeX + 64, sizeX + 2, 30, tocolor(10, 10, 10, 230))
			dxDrawText("", screenX + 6, screenY + sizeX + 71, 0, 0, tocolor(255, 255, 255, 250), 1, fonts.awesome1)
			dxDrawText(convertMoney(getElementData(localPlayer, "bankmoney")), screenX + 130, screenY + sizeX + 70, screenX, 0, tocolor(255, 255, 255, 250), 1, fonts.font2, "center")
			
			if getPedOccupiedVehicle(localPlayer) then
				local theVehicle = getPedOccupiedVehicle(localPlayer)
				local speed = math.floor(getElementSpeed(theVehicle, "kmh"))
				
				dxDrawRectangle(screenX - 1, screenY + sizeX + 96, sizeX + 2, 30, tocolor(10, 10, 10, 230))
				dxDrawText("", screenX + 6, screenY + sizeX + 103, 0, 0, tocolor(255, 255, 255, 250), 1, fonts.awesome1)
				dxDrawText(speed .. " KM/H", screenX + 129, screenY + sizeX + 101, screenX, 0, tocolor(255, 255, 255, 250), 1, fonts.font2, "center")
			end
		end
	end
end, 0, 0)