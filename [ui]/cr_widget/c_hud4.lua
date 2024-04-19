local screenSize = Vector2(guiGetScreenSize())
local PADDING = 10

local ITEMS = {
	['hunger'] = {
        icon = '',
        color = tocolor(228, 134, 43),
        iconColor = tocolor(240, 195, 129)
    },
    ['thirst'] = {
        icon = '',
        color = tocolor(22, 156, 196),
        iconColor = tocolor(83, 203, 234)
    },
	['level'] = {
        icon = '',
        color = tocolor(21, 124, 165),
        iconColor = tocolor(50, 185, 222)
    },
}

local INFORMATION_CARD_ITEMS = {
    { icon = "", prefix = "" },
    { icon = "", prefix = "ID" },
    { icon = "", prefix = "" }
}

local CIRCULAR_SIZE = 50
local CIRCULAR_CONTAINER_SIZE = {
    x = CIRCULAR_SIZE * 4 + (PADDING * 4),
    y = 32
}

local fonts = {
	icon = exports.cr_fonts:getFont("FontAwesome", 19),
	regular = exports.cr_fonts:getFont("sf-regular", 10),
	bold = exports.cr_fonts:getFont("sf-bold", 10),
}

setTimer(function()
    if getElementData(localPlayer, "loggedin") == 1 then
	    if getElementData(localPlayer, "hud_settings").hud == 4 then
			local circularPosition = {
				x = screenSize.x - CIRCULAR_SIZE - PADDING * 2,
				y = PADDING * 2
			}

			for key, data in pairs(ITEMS) do
				local value, text = getHudDataValue(key)
				
				dxDrawRectangle(circularPosition.x, circularPosition.y, CIRCULAR_SIZE, CIRCULAR_SIZE, tocolor(18, 18, 20))
				
				dxDrawRectangle(circularPosition.x + 1, circularPosition.y + 1, CIRCULAR_SIZE - 2, CIRCULAR_SIZE - 2, data.color)

				dxDrawText(data.icon, circularPosition.x, circularPosition.y, circularPosition.x + CIRCULAR_SIZE, circularPosition.y + CIRCULAR_SIZE, data.iconColor, 0.5, fonts.icon, "center", "center", true, true)
				dxDrawText(text, circularPosition.x, circularPosition.y + CIRCULAR_SIZE, circularPosition.x + CIRCULAR_SIZE, circularPosition.y + CIRCULAR_SIZE + 20, tocolor(168, 168, 179), 1, fonts.regular, "center", "bottom", true, true)

				circularPosition.x = circularPosition.x - ((PADDING * 1.2) + CIRCULAR_SIZE)
			end

			local cardPosition = {
				x = screenSize.x - (PADDING * 2) - CIRCULAR_CONTAINER_SIZE.x,
				y = screenSize.y - (PADDING * 2) - CIRCULAR_CONTAINER_SIZE.y
			}
			
			dxDrawRectangle(cardPosition.x, cardPosition.y, CIRCULAR_CONTAINER_SIZE.x, CIRCULAR_CONTAINER_SIZE.y, tocolor(18, 18, 20))

			cardPosition.x = cardPosition.x + 20

			for index, data in ipairs(INFORMATION_CARD_ITEMS) do
				local text = getHudCardItemValue(index) or ""
				local textWidth = dxGetTextWidth(text, 1, fonts.regular)

				if data.icon ~= "" then
					dxDrawText(data.icon, cardPosition.x, cardPosition.y, cardPosition.x + CIRCULAR_CONTAINER_SIZE.x, cardPosition.y + CIRCULAR_CONTAINER_SIZE.y, tocolor(168, 168, 179), 0.5, fonts.icon, "left", "center", true, true)
				else
					dxDrawText(data.prefix, cardPosition.x, cardPosition.y, cardPosition.x + CIRCULAR_CONTAINER_SIZE.x, cardPosition.y + CIRCULAR_CONTAINER_SIZE.y, tocolor(168, 168, 179), 1, fonts.bold, "left", "center", true, true)
				end

				dxDrawText(text, cardPosition.x + PADDING * 2.5, cardPosition.y, cardPosition.x + CIRCULAR_CONTAINER_SIZE.x, cardPosition.y + CIRCULAR_CONTAINER_SIZE.y, tocolor(168, 168, 179), 1, fonts.regular, "left", "center", true, true)

				cardPosition.x = cardPosition.x + textWidth + (PADDING * 5)
			end
		end
	end
end, 0, 0)

function getHudDataValue(key)
    if key == "level" then
        local exp = getElementData(localPlayer, "exp") or 0
        local exprange = getElementData(localPlayer, "exprange") or 0
        local level = getElementData(localPlayer, "level") or 0

        return level + (exp / exprange) * 100, level .. "lvl"
    end

    local value = getElementData(localPlayer, key) or 0
    return value, math.min(value, 100) .. "%"
end

function getHudCardItemValue(index)
    if index == 1 then
        local currentDate = getRealTime()
		local hour = currentDate.hour
		local minute = currentDate.minute
		local timeText = string.format("%02d:%02d", hour, minute)
		return timeText
    elseif index == 2 then
        return getElementData(localPlayer, "playerid") or 0
    elseif index == 3 then
        local players = getElementsByType("player")
        return string.format("%03d", #players)
    end
    return ""
end