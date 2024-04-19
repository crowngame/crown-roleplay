local screenSize = Vector2(guiGetScreenSize())
local sizeX, sizeY = 720, 650
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2
local clickTick = 0

local fonts = {
    awesome1 = exports.cr_fonts:getFont("FontAwesome", 24),
	awesome2 = exports.cr_fonts:getFont("FontAwesome", 16),
    font1 = exports.cr_fonts:getFont("sf-bold", 16),
    font2 = exports.cr_fonts:getFont("sf-regular", 11),
    font3 = exports.cr_fonts:getFont("sf-regular", 10),
    font4 = exports.cr_fonts:getFont("sf-medium", 11),
    font5 = exports.cr_fonts:getFont("sf-bold", 10),
}

addCommandHandler("nametag", function()
	if getElementData(localPlayer, "loggedin") == 1 then
	    if not isTimer(render) then
	        showCursor(true)
	        render = setTimer(function()
				newX = 0
				newY = 0
	            dxDrawRectangle(screenX, screenY, sizeX, sizeY, tocolor(10, 10, 10, 245))
				
				dxDrawText("", screenX + 25, screenY + 22, 30, 30, tocolor(255, 255, 255, 250), 1, fonts.awesome1)
	            dxDrawText("nametagını belirle", screenX + 83, screenY + 16, sizeX, sizeY, tocolor(255, 255, 255, 250), 1, fonts.font1)
	            dxDrawText("hepimizin bakış açıları farklı olabilir", screenX + 83, screenY + 43, sizeX, sizeY, tocolor(255, 255, 255, 150), 1, fonts.font2)
				
				dxDrawText("", screenX + sizeX - 40, screenY + 20, nil, nil, exports.cr_ui:isInBox(screenX + sizeX - 40, screenY + 20, dxGetTextWidth("", 1, fonts.awesome2), dxGetFontHeight(1, fonts.awesome2)) and tocolor(234, 83, 83, 255) or tocolor(255, 255, 255, 255), 1, fonts.awesome2)
				if exports.cr_ui:isInBox(screenX + sizeX - 40, screenY + 20, dxGetTextWidth("", 1, fonts.awesome2), dxGetFontHeight(1, fonts.awesome2)) and getKeyState("mouse1") and clickTick + 500 < getTickCount() then
					clickTick = getTickCount()
					killTimer(render)
					showCursor(false)
				end
				
				dxDrawText("Yazı Tipi Belirle:", screenX + 30, screenY + 80 + newY, sizeX, sizeY, tocolor(255, 255, 255, 255), 1, fonts.font4)
				
				local textWidth = dxGetTextWidth("Klasik (default - bold)", 1, "default - bold")
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").font == 1)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Klasik (default-bold)", screenX + 43 + newX, screenY + 115 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, "default-bold")

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.font = 1
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Modern (sf-regular)", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").font == 2)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Modern (sf-regular)", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
					local settings = getElementData(localPlayer, "nametag_settings")
					settings.font = 2
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Modern Kalın (sf-bold)", 1, fonts.font5)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").font == 3)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Modern Kalın (sf-bold)", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font5)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.font = 3
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Klasik İnce (default)", 1, "default")
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").font == 4)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Klasik İnce (default)", screenX + 43 + newX, screenY + 115 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, "default")

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.font = 4
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = 0
	            newY = newY + 80
				
				
				dxDrawText("Can ve Zırh Gösterimi Belirle:", screenX + 30, screenY + 80 + newY, sizeX, sizeY, tocolor(255, 255, 255, 255), 1, fonts.font4)
				
				local textWidth = dxGetTextWidth("Bar ile", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").type == 1)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Bar ile", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.type = 1
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Yazı ile", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").type == 2)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Yazı ile", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.type = 2
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Gizle", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").type == 3)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Gizle", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.type = 3
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = 0
	            newY = newY + 80
				
				
				dxDrawText("ID Gösterimi Belirle:", screenX + 30, screenY + 80 + newY, sizeX, sizeY, tocolor(255, 255, 255, 255), 1, fonts.font4)
				
				local textWidth = dxGetTextWidth("Göster", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").id == 1)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Göster", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.id = 1
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Gizle", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").id == 2)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Gizle", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.id = 2
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = 0
	            newY = newY + 80
				
				
				dxDrawText("Yazı Kalınlığı Belirle:", screenX + 30, screenY + 80 + newY, sizeX, sizeY, tocolor(255, 255, 255, 255), 1, fonts.font4)
				
				local textWidth = dxGetTextWidth("Kalın Kenarlık", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").border == 1)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Kalın Kenarlık", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.border = 1
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("İnce Kenarlık", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").border == 2)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("İnce Kenarlık", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.border = 2
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Yok", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").border == 3)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Yok", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.border = 3
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = 0
	            newY = newY + 80
				
				
				dxDrawText("Ülke Yerini Belirle:", screenX + 30, screenY + 80 + newY, sizeX, sizeY, tocolor(255, 255, 255, 255), 1, fonts.font4)
				
				local textWidth = dxGetTextWidth("İkonların Yanı", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").country == 1)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("İkonların Yanı", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.country = 1
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("İsmin Yanı", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").country == 2)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("İsmin Yanı", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.country = 2
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Kapalı", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").country == 3)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Kapalı", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.country = 3
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = 0
	            newY = newY + 80
				
				
				dxDrawText("Etiket Gösterimi Belirle:", screenX + 30, screenY + 80 + newY, sizeX, sizeY, tocolor(255, 255, 255, 255), 1, fonts.font4)
				
				local textWidth = dxGetTextWidth("Göster", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").icon == 1)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Göster", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.icon = 1
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Gizle", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").icon == 2)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Gizle", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.icon = 2
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = 0
	            newY = newY + 80
				
				
				dxDrawText("Yerleştirme Belirle:", screenX + 30, screenY + 80 + newY, sizeX, sizeY, tocolor(255, 255, 255, 255), 1, fonts.font4)
				
				local textWidth = dxGetTextWidth("Dinamik", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").placement == 1)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Dinamik", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.placement = 1
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = newX + textWidth + 35
				
				local textWidth = dxGetTextWidth("Statik", 1, fonts.font3)
	            dxDrawRectangle(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30, (exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) or (getElementData(localPlayer, "nametag_settings").placement == 2)) and tocolor(50, 50, 50, 240) or tocolor(25, 25, 25, 240))
	            dxDrawText("Statik", screenX + 43 + newX, screenY + 114 + newY, sizeX, sizeY, tocolor(255, 255, 255, 235), 1, fonts.font3)

	            if exports.cr_ui:isInBox(screenX + 30 + newX, screenY + 108 + newY, textWidth + 25, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
	                clickTick = getTickCount()
	                local settings = getElementData(localPlayer, "nametag_settings")
					settings.placement = 2
	                setElementData(localPlayer, "nametag_settings", settings)
					exports.cr_json:jsonSave("nametag_settings", settings)
					triggerEvent("playSuccessfulSound", localPlayer)
	            end
	            newX = 0
	            newY = newY + 80
	        end, 0, 0)
	    else
	        killTimer(render)
	        showCursor(false)
	    end
	end
end)

function loadSettings()
	local data, status = exports.cr_json:jsonGet("nametag_settings")
	
	setElementData(localPlayer, "nametag_settings", {
		font = data.font or 1,
		type = data.type or 1,
		id = data.id or 1,
		border = data.border or 1,
		country = data.country or 1,
		icon = data.icon or 1,
		placement = data.placement or 1
	})
	
	return true
end
addEvent("nametag:loadSettings", true)
addEventHandler("nametag:loadSettings", root, loadSettings)