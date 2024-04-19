local sizeX, sizeY = 320, 100
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2

local fonts = {
    font1 = exports.cr_fonts:getFont("UbuntuBold", 17),
    font2 = exports.cr_fonts:getFont("UbuntuRegular", 14),
    font3 = exports.cr_fonts:getFont("UbuntuRegular", 9),
    awesome = exports.cr_fonts:getFont("FontAwesome", 9)
}

function renderSerial()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(35, 35, 35, 200))
	
	dxDrawText("", 48, 16, 0, screenSize.y, exports.cr_ui:getServerColor(1, 200), 1, fonts.awesome, "center")
	dxDrawText("crown roleplay v" .. exports.cr_global:getScriptVersion(), 38, 16, 0, screenSize.y, exports.cr_ui:getServerColor(1, 200), 1, fonts.font3)
	
	if music.sound then
		dxDrawText(music.isMusicPaused and "" or "", 48, screenSize.y - 32, 0, 0, tocolor(255, 255, 255, 200), 1, fonts.awesome, "center")
		dxDrawText((musics[music.soundIndex].name or "Müzik") .. (" (" .. convertMusicTime(math.floor(getSoundPosition(music.sound))) .. "/" .. convertMusicTime(math.floor(getSoundLength(music.sound))) .. ")") or "", 40, screenSize.y - 32, 0, 0, tocolor(255, 255, 255, 200), 1, fonts.font3)
		
		if not isLoading then
			if exports.cr_ui:isInBox(16, screenSize.y - 32, dxGetTextWidth(music.isMusicPaused and "" or "", 1, fonts.awesome), dxGetFontHeight(1, fonts.awesome)) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				setSoundPaused(music.sound, not music.isMusicPaused)
				music.isMusicPaused = not music.isMusicPaused
			end
		end
	end
	
    dxDrawText("Farklı bir cihazdan giriş yapıldı.", screenX, screenY, screenX + sizeX, screenY + 30, tocolor(255, 255, 255, 250), 1, fonts.font1, "center")
    dxDrawText("Hesabınıza erişmek için Discord üzerinden ticket açınız.", screenX, screenY + 35, screenX + sizeX, screenY + sizeY, tocolor(255, 255, 255, 175), 1, fonts.font2, "center")
end

addEvent("account.serialScreen", true)
addEventHandler("account.serialScreen", root, function()
	setCameraMatrix(456.15551757812, -1989.2800292969, 26.29380607605, 382.49728393555, -2055.2377929688, 11.325818061829, 0, 70)
	fadeCamera(true)
	showCursor(true)
	showChat(false)
	musicSoundTimer = setTimer(playMusic, 500, 0)
	
    addEventHandler("onClientRender", root, renderSerial)
    addEventHandler("onClientKey", root, onClientKey)
	
	removeEventHandler("onClientRender", root, renderAccount)
	removeEventHandler("onClientCharacter", root, eventWrite)
	removeEventHandler("onClientKey", root, removeCharacter)
	removeEventHandler("onClientKey", root, enterKey)
	removeEventHandler("onClientPaste", root, pasteClipboardText)
end)

function onClientKey(button, press)
    cancelEvent()
end