local screenSize = Vector2(guiGetScreenSize())
local screenX, screenY = screenSize.x - 150, 60

local fonts = {
    font1 = exports.cr_fonts:getFont("Pricedown", 24),
    font2 = exports.cr_fonts:getFont("sf-bold", 10)
}

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").hud == 1 then
			local weapon = getPedWeapon(localPlayer)
			dxDrawImage(screenX, screenY, 128, 128, "images/weapons/" .. weapon .. ".png")
			
			if bulletWeapons[weapon] then
				local ammo1 = getPedAmmoInClip(localPlayer, getPedWeaponSlot(localPlayer))
				local ammo2 = getPedTotalAmmo(localPlayer) - getPedAmmoInClip(localPlayer)
				
				exports.cr_ui:drawFramedText(ammo1 .. "/" .. ammo2, screenX, screenY + 105, screenX + 130, 0, tocolor(255, 255, 255, 255), 1, fonts.font2, "center")
			end
			
			exports.cr_ui:drawFramedText(os.date("%H:%M"), screenX, screenY + 5, screenX - 20, 0, tocolor(255, 255, 255, 255), 1, fonts.font1, "right")
			exports.cr_ui:drawFramedText("$" .. exports.cr_global:getMoney(localPlayer), screenX, screenY + 35, screenX - 20, 0, tocolor(85, 152, 78, 255), 1, fonts.font1, "right")
			
			dxDrawRectangle(screenX - 160, screenY + 77, 140, 15, tocolor(0, 0, 0, 255))
			dxDrawRectangle(screenX - 158, screenY + 79, 136, 11, tocolor(255, 0, 0, 100))
			dxDrawRectangle(screenX - 158, screenY + 79, math.floor(getElementHealth(localPlayer)) * 1.363, 11, tocolor(255, 0, 0, 255))
			
			if getPedArmor(localPlayer) > 0 then
				dxDrawRectangle(screenX - 160, screenY + 96, 140, 15, tocolor(0, 0, 0, 255))
				dxDrawRectangle(screenX - 158, screenY + 98, 136, 11, tocolor(230, 230, 230, 100))
				dxDrawRectangle(screenX - 158, screenY + 98, math.floor(getPedArmor(localPlayer)) * 1.363, 11, tocolor(230, 230, 230, 255))
			end
		end
	end
end, 0, 0)