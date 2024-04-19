local screenSize = Vector2(guiGetScreenSize())
local width, height = 620, 390
local screenX, screenY = (screenSize.x - width) / 2, (screenSize.y - height) / 2
local clickTick = 0
local selectedCategory = 1

local fonts = {
    awesome1 = exports.cr_fonts:getFont("FontAwesome", 23),
	awesome2 = exports.cr_fonts:getFont("FontAwesome", 16),
    font1 = exports.cr_fonts:getFont("sf-bold", 16),
    font2 = exports.cr_fonts:getFont("sf-regular", 11),
    font3 = exports.cr_fonts:getFont("sf-regular", 10),
	awesome3 = exports.cr_fonts:getFont("FontAwesome", 43),
}

addCommandHandler("hud", function()
	if getElementData(localPlayer, "loggedin") == 1 then
	    if not isTimer(render) then
	        showCursor(true)
	        render = setTimer(function()
	            dxDrawRectangle(screenX, screenY, width, height, tocolor(10, 10, 10, 245))
				dxDrawText("", screenX + 24, screenY + 20, 30, 30, tocolor(255, 255, 255, 250), 1, fonts.awesome1)
	            dxDrawText("arayüzünü belirle", screenX + 75, screenY + 16, width, height, tocolor(255, 255, 255, 250), 1, fonts.font1)
	            dxDrawText("hepimizin bakış açıları farklı olabilir", screenX + 75, screenY + 43, width, height, tocolor(255, 255, 255, 150), 1, fonts.font2)
				
				dxDrawText("", screenX + width - 40, screenY + 20, nil, nil, exports.cr_ui:isInBox(screenX + width - 40, screenY + 20, dxGetTextWidth("", 1, fonts.awesome2), dxGetFontHeight(1, fonts.awesome2)) and tocolor(234, 83, 83, 255) or tocolor(255, 255, 255, 255), 1, fonts.awesome2)
				if exports.cr_ui:isInBox(screenX + width - 40, screenY + 20, dxGetTextWidth("", 1, fonts.awesome2), dxGetFontHeight(1, fonts.awesome2)) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
					clickTick = getTickCount()
					killTimer(render)
					showCursor(false)
				end
				
				local newCX = 0
				for key, value in pairs(categories) do
                    local isSelected = selectedCategory == key
                    dxDrawRectangle(screenX + 20 + newCX, screenY + 75, dxGetTextWidth(value[1], 1, fonts.font3)+20, 30, (exports.cr_ui:isInBox(screenX + 20 + newCX, screenY + 75, dxGetTextWidth(value[1], 1, fonts.font3)+20, 30) or isSelected) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
                    dxDrawText(value[1], screenX + 30 + newCX, screenY + 81, 0, 0, tocolor(255, 255, 255, 235), 1, fonts.font3)
                    
                    if exports.cr_ui:isInBox(screenX + 20 + newCX, screenY + 75, dxGetTextWidth(value[1], 1, fonts.font3)+20, 30) and getKeyState("mouse1") then
                        selectedCategory = key
                    end
                    newCX = newCX + ((dxGetTextWidth(value[1], 1, fonts.font3)+20)+10)
                end
				
				if selectedCategory == 1 then
					local newY = 0
					for key, value in pairs(huds) do
						dxDrawRectangle(screenX + 20, screenY + 120 + newY, width - 40, 30, exports.cr_ui:isInBox(screenX + 20, screenY + 120 + newY, width - 40, 30) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
						dxDrawText(value[1], screenX + 20, screenY + 126 + newY, screenX + width - 40, 35, tocolor(255, 255, 255, 235), 1, fonts.font3, "center")
						
						if exports.cr_ui:isInBox(screenX + 20, screenY + 120 + newY, width - 40, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							if value[1] == "Gizle" then
								local settings = getElementData(localPlayer, "hud_settings")
								settings.hud = 0
								setElementData(localPlayer, "hud_settings", settings)
							else
								local settings = getElementData(localPlayer, "hud_settings")
								settings.hud = key
								setElementData(localPlayer, "hud_settings", settings)
							end
							exports.cr_json:jsonSave("hud_settings", getElementData(localPlayer, "hud_settings"))
							triggerEvent("playSuccessfulSound", localPlayer)
						end
						newY = newY + 36
					end
				elseif selectedCategory == 2 then
					local newY = 0
					for key, value in pairs(speedos) do
						dxDrawRectangle(screenX + 20, screenY + 120 + newY, width - 40, 30, exports.cr_ui:isInBox(screenX + 20, screenY + 120 + newY, width - 40, 30) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
						dxDrawText(value[1], screenX + 20, screenY + 126 + newY, screenX + width - 40, 35, tocolor(255, 255, 255, 235), 1, fonts.font3, "center")
						
						if exports.cr_ui:isInBox(screenX + 20, screenY + 120 + newY, width - 40, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							if value[1] == "Gizle" then
								local settings = getElementData(localPlayer, "hud_settings")
								settings.speedo = 0
								setElementData(localPlayer, "hud_settings", settings)
							else
								local settings = getElementData(localPlayer, "hud_settings")
								settings.speedo = key
								setElementData(localPlayer, "hud_settings", settings)
							end
							exports.cr_json:jsonSave("hud_settings", getElementData(localPlayer, "hud_settings"))
							triggerEvent("playSuccessfulSound", localPlayer)
						end
						newY = newY + 36
					end
				elseif selectedCategory == 3 then
					local newY = 0
					for key, value in pairs(radars) do
						dxDrawRectangle(screenX + 20, screenY + 120 + newY, width - 40, 30, exports.cr_ui:isInBox(screenX + 20, screenY + 120 + newY, width - 40, 30) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
						dxDrawText(value[1], screenX + 20, screenY + 126 + newY, screenX + width - 40, 35, tocolor(255, 255, 255, 235), 1, fonts.font3, "center")
						
						if exports.cr_ui:isInBox(screenX + 20, screenY + 120 + newY, width - 40, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							if value[1] == "Gizle" then
								local settings = getElementData(localPlayer, "hud_settings")
								settings.radar = 0
								setElementData(localPlayer, "hud_settings", settings)
							else
								local settings = getElementData(localPlayer, "hud_settings")
								settings.radar = key
								setElementData(localPlayer, "hud_settings", settings)
							end
							exports.cr_json:jsonSave("hud_settings", getElementData(localPlayer, "hud_settings"))
							triggerEvent("playSuccessfulSound", localPlayer)
						end
						newY = newY + 36
					end
				elseif selectedCategory == 4 then
					local newY = 0
					for key, value in pairs(killmessages) do
						dxDrawRectangle(screenX + 20, screenY + 120 + newY, width - 40, 30, exports.cr_ui:isInBox(screenX + 20, screenY + 120 + newY, width - 40, 30) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
						dxDrawText(value[1], screenX + 20, screenY + 126 + newY, screenX + width - 40, 35, tocolor(255, 255, 255, 235), 1, fonts.font3, "center")
						
						if exports.cr_ui:isInBox(screenX + 20, screenY + 120 + newY, width - 40, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
							clickTick = getTickCount()
							if value[1] == "Gizle" then
								local settings = getElementData(localPlayer, "hud_settings")
								settings.killmessage = 0
								setElementData(localPlayer, "hud_settings", settings)
							else
								local settings = getElementData(localPlayer, "hud_settings")
								settings.killmessage = key
								setElementData(localPlayer, "hud_settings", settings)
							end
							exports.cr_json:jsonSave("hud_settings", getElementData(localPlayer, "hud_settings"))
							triggerEvent("playSuccessfulSound", localPlayer)
						end
						newY = newY + 36
					end
				end
	        end, 0, 0)
	    else
	        killTimer(render)
	        showCursor(false)
	    end
	end
end)

function loadSettings()
	local data, status = exports.cr_json:jsonGet("hud_settings")
	
	setElementData(localPlayer, "hud_settings", {
		hud = data.hud or 1,
		speedo = data.speedo or 1,
		radar = data.radar or 1,
		killmessage = data.killmessage or 1,
	})
	
	return true
end
addEvent("hud:loadSettings", true)
addEventHandler("hud:loadSettings", root, loadSettings)