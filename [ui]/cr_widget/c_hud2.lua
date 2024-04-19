local screenSize = Vector2(guiGetScreenSize())

local containerPosition = {
    x = screenSize.x * 0.786,
    y = screenSize.y * 0.025
}

local barSize = {
    x = screenSize.x * 0.035,
    y = screenSize.y * 0.017
}

local healthBarSize = {
    x = screenSize.x * 0.095,
    y = screenSize.y * 0.019
}

local barPadding = screenSize.x * 0.003
local imageSize = screenSize.y * 0.016

local armorR, armorG, armorB = 225, 225, 255
local healthR, healthG, healthB = 180, 25, 29

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if getElementData(localPlayer, "hud_settings").hud == 2 then
			local x, y = containerPosition.x, containerPosition.y

			local currentDate = getRealTime()
			local year = currentDate.year + 1900
			local month = currentDate.month + 1
			local day = currentDate.monthday
			local hour = currentDate.hour
			local minute = currentDate.minute
			local dateText = string.format("%02d-%02d-%04d", day, month, year)
			local timeText = string.format("%02d:%02d", hour, minute)

			for _, key in ipairs({ 'ammo', 'armour', 'breath', 'clock', 'health', 'money', 'weapon' }) do
				setPlayerHudComponentVisible(key, true)
			end

			for _, key in ipairs({ 'hunger', 'thirst' }) do
				local value = getElementData(localPlayer, key) or 0
				value = math.min(value, 100)

				local r, g, b = 131, 189, 44
				if value >= 60 and value <= 80 then
					r, g, b = 145, 211, 116
				elseif value >= 40 and value <= 60 then
					r, g, b = 192, 138, 49
				elseif value >= 0 and value <= 40 then
					r, g, b = 180, 25, 29
				end

				dxDrawRectangle(x, y, barSize.x, barSize.y, tocolor(0, 0, 0))
				dxDrawRectangle(x + barPadding / 2, y + barPadding / 2 - 0.2, barSize.x - barPadding, barSize.y - barPadding, tocolor(r, g, b, 155))

				dxDrawRectangle(x + barPadding / 2, y + barPadding / 2 - 0.2, (barSize.x - barPadding) * value / 100, barSize.y - barPadding, tocolor(r, g, b, 155))

				dxDrawImage(x - screenSize.x * 0.004, y, imageSize, imageSize, 'images/' .. key .. '.png')

				if key == 'level' then
					dxDrawText(
							exp .. '/' .. exprange,
							x,
							y,
							barSize.x + x,
							barSize.y + y,
							tocolor(196, 196, 204),
							0.8,
							'default-bold',
							'center',
							'center'
					)
				end
				x = x + barSize.x * 1.2
			end
		end
	end
end, 0, 0)

addEventHandler("onClientElementDataChange", localPlayer, function(theKey, oldValue, newValue)
	if theKey == "hud_settings" then
		if getElementData(localPlayer, "hud_settings").hud == 2 then
			for _, component in ipairs({ 'ammo', 'armour', 'breath', 'clock', 'health', 'money', 'weapon' }) do
				setPlayerHudComponentVisible(component, true)
			end
		else
			for _, component in ipairs({ 'ammo', 'armour', 'breath', 'clock', 'health', 'money', 'weapon' }) do
				setPlayerHudComponentVisible(component, false)
			end
		end
	end
end)