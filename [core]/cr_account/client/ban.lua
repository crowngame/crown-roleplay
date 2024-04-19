local sizeX, sizeY = 320, 30
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 2.1
local clickTimer = 0

local fonts = {
    font1 = exports.cr_fonts:getFont("UbuntuRegular", 10),
    font2 = exports.cr_fonts:getFont("UbuntuRegular", 9),
	awesome = exports.cr_fonts:getFont("FontAwesome", 9)
}

local banDetails = {}

function renderBan()
    dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(35, 35, 35, 175))
    dxDrawImage(screenX + 85, screenY - 165, 140, 140, ":cr_ui/public/images/logos/solid.png", 0, 0, 0, exports.cr_ui:getServerColor(1))
	
	dxDrawText("", 48, 16, 0, screenSize.y, exports.cr_ui:getServerColor(1, 200), 1, fonts.awesome, "center")
	dxDrawText("crown roleplay v" .. exports.cr_global:getScriptVersion(), 38, 16, 0, screenSize.y, exports.cr_ui:getServerColor(1, 200), 1, fonts.font2)
	
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

    dxDrawRectangle(screenX, screenY, sizeX, sizeY, tocolor(10, 10, 10, 235))
    dxDrawText("Sunucudan Yasaklandınız!", screenX + 160, screenY + 6, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")

    dxDrawRectangle(screenX, screenY + 35, sizeX, sizeY + 69, tocolor(10, 10, 10, 235))
    dxDrawText("Yasaklayan: " .. banDetails[1], screenX + 160, screenY + 45, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")
    dxDrawText("Yasaklanma Sebebi: " .. banDetails[2], screenX + 160, screenY + 65, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")
    dxDrawText("Yasaklanma Tarihi: " .. banDetails[3], screenX + 160, screenY + 85, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")
    dxDrawText("Yasaklanma Süresi: " .. secondsToTimeDesc(banDetails[4] / 1000), screenX + 160, screenY + 105, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font1, "center")

    dxDrawRectangle(screenX, screenY + 140, sizeX, sizeY + 55, tocolor(10, 10, 10, 235))
    dxDrawImage(screenX + 10, screenY + 145, 75, 75, "images/discord.png", 0, 0, 0, tocolor(255, 255, 255, 235))
    dxDrawText("Yasağınız ile ilgili bir sorunuz varsa.", screenX + 200, screenY + 155, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font2, "center")
    dxDrawText("discord.gg/crownrp", screenX + 200, screenY + 175, nil, nil, tocolor(255, 255, 255, 255), 1, fonts.font2, "center")
    dxDrawText("(Kopyalamak için buraya tıklayınız)", screenX + 200, screenY + 195, nil, nil, exports.cr_ui:isInBox(screenX + 303 - dxGetTextWidth("(Kopyalamak için buraya tıklayınız)", 1, fonts.font2), screenY + 195, dxGetTextWidth("(Kopyalamak için buraya tıklayınız)", 1, fonts.font2), 15) and tocolor(255, 255, 255, 200) or tocolor(255, 255, 255, 255), 1, fonts.font2, "center")

    if exports.cr_ui:isInBox(screenX + 303 - dxGetTextWidth("(Kopyalamak için buraya tıklayınız)", 1, fonts.font2), screenY + 195, dxGetTextWidth("(Kopyalamak için buraya tıklayınız)", 1, fonts.font2), 15) and getKeyState("mouse1") and clickTimer + 1000 <= getTickCount() then
        clickTimer = getTickCount()
        setClipboard("discord.gg/crownrp")
        triggerEvent("playSuccessfulSound", localPlayer)
    end
end

addEvent("account.banScreen", true)
addEventHandler("account.banScreen", root, function(banDetailsTable)
	setCameraMatrix(-350.67303466797, 2229.3159179688, 46.286087036133, -257.8219909668, 2193.5864257812, 36.182357788086)
	fadeCamera(true)
	showCursor(true)
	showChat(false)
	musicSoundTimer = setTimer(playMusic, 500, 0)
	
    addEventHandler("onClientRender", root, renderBan)
    addEventHandler("onClientKey", root, onClientKey)
    banDetails = banDetailsTable
	
	if isEventHandlerAdded("onClientRender", root, renderAccount) then
		removeEventHandler("onClientRender", root, renderAccount)
	end
end)

function onClientKey(button, press)
    cancelEvent()
end