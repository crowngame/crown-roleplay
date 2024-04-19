local sizeX, sizeY = 250, 40
local screenX, screenY = (screenSize.x - sizeX) / 2, (screenSize.y - sizeY) / 1.9
local clickTick = 0

local currentPage = 1
local hidePassword = true

local _rememberMe = false
local accountInfo = false

isLoading = false

local selected = ""
local textBoxes = {
	["login_username"] = {"", false},
	["login_password"] = {"", false},
	["register_username"] = {"", false},
	["register_password"] = {"", false},
	["register_password_again"] = {"", false},
}

local fonts = {
    font1 = exports.cr_fonts:getFont("UbuntuRegular", 10),
    font2 = exports.cr_fonts:getFont("UbuntuBold", 10),
    font3 = exports.cr_fonts:getFont("UbuntuRegular", 9),
    awesome = exports.cr_fonts:getFont("FontAwesome", 11),
    awesome2 = exports.cr_fonts:getFont("FontAwesome", 10),
    awesome3 = exports.cr_fonts:getFont("FontAwesome", 9)
}

function renderAccount()
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(35, 35, 35, 175))
	dxDrawImage(screenX + 50, screenY - 220, 150, 150, ":cr_ui/public/images/logos/solid.png", 0, 0, 0, exports.cr_ui:getServerColor(1, 230))
	
	dxDrawText("", 48, 16, 0, screenSize.y, exports.cr_ui:getServerColor(1, 200), 1, fonts.awesome3, "center")
	dxDrawText("crown roleplay v" .. exports.cr_global:getScriptVersion(), 38, 16, 0, screenSize.y, exports.cr_ui:getServerColor(1, 200), 1, fonts.font3)
	
	if music.sound then
		dxDrawText(music.isMusicPaused and "" or "", 48, screenSize.y - 32, 0, 0, tocolor(255, 255, 255, 200), 1, fonts.awesome3, "center")
		dxDrawText((musics[music.soundIndex].name or "Müzik") .. (" (" .. convertMusicTime(math.floor(getSoundPosition(music.sound))) .. "/" .. convertMusicTime(math.floor(getSoundLength(music.sound))) .. ")") or "", 40, screenSize.y - 32, 0, 0, tocolor(255, 255, 255, 200), 1, fonts.font3)
		
		if not isLoading then
			if exports.cr_ui:isInBox(16, screenSize.y - 32, dxGetTextWidth(music.isMusicPaused and "" or "", 1, fonts.awesome3), dxGetFontHeight(1, fonts.awesome3)) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
				clickTick = getTickCount()
				setSoundPaused(music.sound, not music.isMusicPaused)
				music.isMusicPaused = not music.isMusicPaused
			end
		end
	end
	
	if currentPage == 1 then
		--> Kullanıcı Adı
		dxDrawRectangle(screenX, screenY - 55, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(textBoxes["login_username"][2] and textBoxes["login_username"][1] or "kullanıcı adı", screenX + 15, screenY - 44, nil, nil, selected == "login_username" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		
		if exports.cr_ui:isInBox(screenX, screenY - 55, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				selected = "login_username"
				textBoxes[selected][1] = ""
				textBoxes[selected][2] = true
				guiSetInputMode("allow_binds")
			end
		end
		
		--> Şifre
		if hidePassword then
			loginPassword = textBoxes["login_password"][2] and string.rep("*", #textBoxes["login_password"][1]) or "şifre"
			hideIcon = ""
		else
			loginPassword = textBoxes["login_password"][2] and textBoxes["login_password"][1] or "şifre"
			hideIcon = ""
		end
		
		dxDrawRectangle(screenX, screenY - 5, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(loginPassword, screenX + 15, screenY + 6, nil, nil, selected == "login_password" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		dxDrawText(hideIcon, screenX + sizeX - 20, screenY + 7, nil, nil, tocolor(255, 255, 255, 200), 1, fonts.awesome2, "center")
		
		if exports.cr_ui:isInBox(screenX + sizeX - 40, screenY + 7, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				if hidePassword then
					hidePassword = false
				else
					hidePassword = true
				end
			end
		end
		
		if exports.cr_ui:isInBox(screenX, screenY - 5, sizeX - 35, sizeY) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				selected = "login_password"
				textBoxes[selected][1] = ""
				textBoxes[selected][2] = true
				guiSetInputMode("allow_binds")
			end
		end
		
		--> Beni Hatırla
		dxDrawText("beni hatırla", screenX + sizeX - dxGetTextWidth("beni hatırla", 1, _rememberMe and fonts.font2 or fonts.font1), screenY + 41, nil, nil, exports.cr_ui:isInBox(screenX + sizeX - dxGetTextWidth("beni hatırla", 1, _rememberMe and fonts.font2 or fonts.font1), screenY + 41, dxGetTextWidth("beni hatırla", 1, _rememberMe and fonts.font2 or fonts.font1), 15) and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, _rememberMe and fonts.font2 or fonts.font1)
		
		if exports.cr_ui:isInBox(screenX + sizeX - dxGetTextWidth("beni hatırla", 1, _rememberMe and fonts.font2 or fonts.font1), screenY + 41, dxGetTextWidth("beni hatırla", 1, _rememberMe and fonts.font2 or fonts.font1), 15) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				_rememberMe = not _rememberMe
			end
		end
		
		--> Giriş Yap
		dxDrawRectangle(screenX, screenY + 65, sizeX, sizeY, exports.cr_ui:isInBox(screenX, screenY + 65, sizeX, sizeY) and exports.cr_ui:getServerColor(1) or exports.cr_ui:getServerColor(1, 245))
		dxDrawText("giriş yap", screenX + sizeX - 125, screenY + 76, nil, nil, tocolor(20, 20, 20, 250), 1, fonts.font1, "center")
		
		if exports.cr_ui:isInBox(screenX, screenY + 65, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 600 <= getTickCount() then
			clickTick = getTickCount()
			--if not isTransferBoxActive() then
				if not isLoading then
					if #textBoxes["login_username"][1] > 0 and #textBoxes["login_username"][1] ~= "" then
						if #textBoxes["login_password"][1] > 0 and #textBoxes["login_password"][1] ~= "" then
							isLoading = true
							addEventHandler("onClientRender", root, renderQueryLoading)
							triggerServerEvent("account.requestLogin", localPlayer, textBoxes["login_username"][1], textBoxes["login_password"][1])
							
							if _rememberMe then
								exports.cr_json:jsonSave("account_info", { username = textBoxes["login_username"][1], password = textBoxes["login_password"][1], rememberMe = _rememberMe }, true)
							end
						else
							exports.cr_infobox:addBox("error", "Şifre boş kalmamalıdır.")
						end
					else
						exports.cr_infobox:addBox("error", "Kullanıcı adı boş kalmamalıdır.")
					end
				end
			--else
				--exports.cr_infobox:addBox("error", "Sunucu dosyaları yüklenirken hesabınıza giriş yapamazsınız.")
			--end
		end
		
		--> Kayıt Ol
		dxDrawRectangle(screenX, screenY + 110, sizeX, sizeY, exports.cr_ui:isInBox(screenX, screenY + 110, sizeX, sizeY) and tocolor(25, 25, 25, 255) or tocolor(20, 20, 20, 255))
		dxDrawText("kayıt ol", screenX + sizeX - 125, screenY + 121, nil, nil, exports.cr_ui:getServerColor(1, 250), 1, fonts.font1, "center")
		
		if exports.cr_ui:isInBox(screenX, screenY + 110, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				currentPage = 2
			end
		end
	elseif currentPage == 2 then
		--> Kullanıcı Adı
		dxDrawRectangle(screenX, screenY - 55, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(textBoxes["register_username"][2] and textBoxes["register_username"][1] or "kullanıcı adı", screenX + 15, screenY - 44, nil, nil, selected == "register_username" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		
		if exports.cr_ui:isInBox(screenX, screenY - 55, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				selected = "register_username"
				textBoxes[selected][1] = ""
				textBoxes[selected][2] = true
				guiSetInputMode("allow_binds")
			end
		end
		
		--> Şifre
		if hidePassword then
			registerPassword = textBoxes["register_password"][2] and string.rep("*", #textBoxes["register_password"][1]) or "şifre"
			hideIcon = ""
		else
			registerPassword = textBoxes["register_password"][2] and textBoxes["register_password"][1] or "şifre"
			hideIcon = ""
		end
		
		dxDrawRectangle(screenX, screenY - 5, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(registerPassword, screenX + 15, screenY + 6, nil, nil, selected == "register_password" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		dxDrawText(hideIcon, screenX + sizeX - 20, screenY + 7, nil, nil, tocolor(255, 255, 255, 200), 1, fonts.awesome2, "center")
		
		if exports.cr_ui:isInBox(screenX + sizeX - 40, screenY + 7, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				if hidePassword then
					hidePassword = false
				else
					hidePassword = true
				end
			end
		end
		
		if exports.cr_ui:isInBox(screenX, screenY - 5, sizeX - 35, sizeY) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				selected = "register_password"
				textBoxes[selected][1] = ""
				textBoxes[selected][2] = true
				guiSetInputMode("allow_binds")
			end
		end
		
		--> Şifre Yeniden
		if hidePassword then
			registerPassword = textBoxes["register_password_again"][2] and string.rep("*", #textBoxes["register_password_again"][1]) or "şifre 2x"
			hideIcon = ""
		else
			registerPassword = textBoxes["register_password_again"][2] and textBoxes["register_password_again"][1] or "şifre 2x"
			hideIcon = ""
		end
		
		dxDrawRectangle(screenX, screenY + 45, sizeX, sizeY, tocolor(10, 10, 10, 245))
		dxDrawText(registerPassword, screenX + 15, screenY + 56, nil, nil, selected == "register_password_again" and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1)
		dxDrawText(hideIcon, screenX + sizeX - 20, screenY + 57, nil, nil, tocolor(255, 255, 255, 200), 1, fonts.awesome2, "center")
		
		if exports.cr_ui:isInBox(screenX + sizeX - 40, screenY + 57, 30, 30) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				if hidePassword then
					hidePassword = false
				else
					hidePassword = true
				end
			end
		end
		
		if exports.cr_ui:isInBox(screenX, screenY + 45, sizeX - 35, sizeY) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				selected = "register_password_again"
				textBoxes[selected][1] = ""
				textBoxes[selected][2] = true
				guiSetInputMode("allow_binds")
			end
		end
		
		--> Kayıt Ol
		dxDrawRectangle(screenX, screenY + 95, sizeX, sizeY, exports.cr_ui:isInBox(screenX + 95, screenY + 95, sizeX, sizeY) and exports.cr_ui:getServerColor(1) or exports.cr_ui:getServerColor(1, 245))
		dxDrawText("kayıt ol", screenX + sizeX - 125, screenY + 106, nil, nil, tocolor(20, 20, 20, 250), 1, fonts.font1, "center")
		
		if exports.cr_ui:isInBox(screenX, screenY + 95, sizeX, sizeY) and getKeyState("mouse1") and clickTick + 600 <= getTickCount() then
			clickTick = getTickCount()
			if not isLoading then
				if #textBoxes["register_username"][1] > 0 and #textBoxes["register_username"][1] ~= "" then
					if string.len(textBoxes["register_username"][1]) >= 3 then
						if not string.match(#textBoxes["register_username"][1], "%W") then
							if (#textBoxes["register_password"][1] > 0 and #textBoxes["register_password"][1] ~= "") and (#textBoxes["register_password_again"][1] > 0 and #textBoxes["register_password_again"][1] ~= "") then
								if (string.len(textBoxes["register_password"][1]) >= 6) and (string.len(textBoxes["register_password_again"][1]) >= 6) then
									if textBoxes["register_password"][1] == textBoxes["register_password_again"][1] then
										isLoading = true
										addEventHandler("onClientRender", root, renderQueryLoading)
										triggerServerEvent("account.requestRegister", localPlayer, textBoxes["register_username"][1], textBoxes["register_password"][1])
									else
										exports.cr_infobox:addBox("error", "Şifreler uyuşmuyor.")
									end
								else
									exports.cr_infobox:addBox("error", "Şifreniz minimum 6 karakter olmalıdır.")
								end
							else
								exports.cr_infobox:addBox("error", "Şifre boş kalmamalıdır.")
							end
						else
							exports.cr_infobox:addBox("error", "Kullanıcı adında uygunsuz karakter olmamalıdır.")
						end
					else
						exports.cr_infobox:addBox("error", "Kullanıcı adınız minimum 3 karakter olmalıdır.")
					end
				else
					exports.cr_infobox:addBox("error", "Kullanıcı adı boş kalmamalıdır.")
				end
			end
		end
		
		--> Giriş Yap
		dxDrawText("giriş sekmesine dön", screenX + sizeX - 125, screenY + 145, nil, nil, exports.cr_ui:isInBox(screenX + dxGetTextWidth("giriş sekmesine dön", 1, fonts.font1) - 75, screenY + 145, dxGetTextWidth("giriş sekmesine dön", 1, fonts.font1), 15) and tocolor(255, 255, 255, 250) or tocolor(255, 255, 255, 200), 1, fonts.font1, "center")
		
		if exports.cr_ui:isInBox(screenX + dxGetTextWidth("giriş sekmesine dön", 1, fonts.font1) - 75, screenY + 145, dxGetTextWidth("giriş sekmesine dön", 1, fonts.font1), 15) and getKeyState("mouse1") and clickTick + 500 <= getTickCount() then
			if not isLoading then
				clickTick = getTickCount()
				currentPage = 1
			end
		end
	end
	
	if not accountInfo then
		local data, status = exports.cr_json:jsonGet("account_info", true)
		
		if status then
			if data.rememberMe then
				textBoxes["login_username"][1] = tostring(data.username)
				textBoxes["login_username"][2] = true
				textBoxes["login_password"][1] = tostring(data.password)
				textBoxes["login_password"][2] = true
				_rememberMe = true
			else
				_rememberMe = false
			end
		end
		
		accountInfo = true
	end
end

function renderVignette()
	dxDrawImage(0, 0, screenSize.x, screenSize.y, "images/vignette.png", 0, 0, 0, tocolor(255, 255, 255, 200))
end

function renderLoading()
	exports.cr_ui:drawSpinner({
        position = {
            x = (screenSize.x - 128) / 2,
            y = (screenSize.y - 128) / 2
        },
        size = 128,

        speed = 2,
		
		label = 'Yükleniyor...',

        variant = 'soft',
        color = 'gray',
		postGUI = true
    })
end

function renderQueryLoading()
	dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(10, 10, 10, 150), true)
	exports.cr_ui:drawSpinner({
        position = {
            x = (screenSize.x - 128) / 2,
            y = (screenSize.y - 128) / 2
        },
        size = 128,

        speed = 2,
		
		label = 'Yükleniyor...',

        variant = 'soft',
        color = 'gray',
		
		postGUI = true
    })
end

--==================================================================================================================

function eventWrite(...)
    write(...)
end

function write(char)
	if selected ~= "" and textBoxes[selected][2] then
		if not isLoading then
			local text = textBoxes[selected][1]
			if #text <= 20 then
				textBoxes[selected][1] = (textBoxes[selected][1] .. char):gsub(" ", "")
				playSound(":cr_ui/public/sounds/key.mp3")
			end
		end
	end
end

function removeCharacter(key, state)
    if key == "backspace" and state then
        if selected ~= "" and textBoxes[selected][2] then
			if not isLoading then
				local text = textBoxes[selected][1]
				if #text > 0 then
					textBoxes[selected][1] = string.sub(text, 1, #text - 1)
					playSound(":cr_ui/public/sounds/key.mp3")
				end
			end
        end
    end
end

function enterKey(key, state)
    if (key == "enter" and state) and (clickTick + 600 <= getTickCount()) then
        if currentPage == 1 then
			clickTick = getTickCount()
			if not isTransferBoxActive() then
				if not isLoading then
					if #textBoxes["login_username"][1] > 0 and #textBoxes["login_username"][1] ~= "" then
						if #textBoxes["login_password"][1] > 0 and #textBoxes["login_password"][1] ~= "" then
							isLoading = true
							addEventHandler("onClientRender", root, renderQueryLoading)
							triggerServerEvent("account.requestLogin", localPlayer, textBoxes["login_username"][1], textBoxes["login_password"][1])
						else
							exports.cr_infobox:addBox("error", "Şifre boş kalmamalıdır.")
						end
					else
						exports.cr_infobox:addBox("error", "Kullanıcı adı boş kalmamalıdır.")
					end
				end
			else
				exports.cr_infobox:addBox("error", "Sunucu dosyaları yüklenirken hesabınıza giriş yapamazsınız.")
			end
        elseif currentPage == 2 then
			clickTick = getTickCount()
			if not isLoading then
				if #textBoxes["register_username"][1] > 0 and #textBoxes["register_username"][1] ~= "" then
					if (#textBoxes["register_password"][1] > 0 and #textBoxes["register_password"][1] ~= "") and (#textBoxes["register_password_again"][1] > 0 and #textBoxes["register_password_again"][1] ~= "") then
						if textBoxes["register_password"][1] == textBoxes["register_password_again"][1] then
							isLoading = true
							addEventHandler("onClientRender", root, renderQueryLoading)
							triggerServerEvent("account.requestRegister", localPlayer, textBoxes["register_username"][1], textBoxes["register_password"][1])
						else
							exports.cr_infobox:addBox("error", "Şifreler uyuşmuyor.")
						end
					else
						exports.cr_infobox:addBox("error", "Şifre boş kalmamalıdır.")
					end
				else
					exports.cr_infobox:addBox("error", "Kullanıcı adı boş kalmamalıdır.")
				end
			end
		end
    end
end

function pasteClipboardText(clipboardText)
	if clipboardText then
		if selected ~= "" and textBoxes[selected][2] then
			if not isLoading then
				local text = textBoxes[selected][1]
				if #text <= 20 then
					textBoxes[selected][1] = textBoxes[selected][1] .. clipboardText
					playSound(":cr_ui/public/sounds/key.mp3")
				end
			end
		end
	end
end

--==================================================================================================================

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "loggedin") ~= 1 then
		isLoading = true
		addEventHandler("onClientRender", root, renderQueryLoading)
		
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)
		setCameraMatrix(456.15551757812, -1989.2800292969, 26.29380607605, 382.49728393555, -2055.2377929688, 11.325818061829, 0, 70)
		fadeCamera(true)
		showCursor(true)
		showChat(false)
		addEventHandler("onClientRender", root, renderAccount)
		addEventHandler("onClientRender", root, renderVignette)
		addEventHandler("onClientCharacter", root, eventWrite)
		addEventHandler("onClientKey", root, removeCharacter)
		addEventHandler("onClientKey", root, enterKey)
		addEventHandler("onClientPaste", root, pasteClipboardText)
		music.soundTimer = setTimer(playMusic, 500, 0)

		triggerServerEvent("account.resetPlayer", localPlayer)
		triggerServerEvent("account.isBanned", localPlayer)
		
		isLoading = false
		removeEventHandler("onClientRender", root, renderQueryLoading)
	end
end)

addEvent("account.removeLogin", true)
addEventHandler("account.removeLogin", root, function()
    showCursor(false)
    removeEventHandler("onClientRender", root, renderAccount)
    removeEventHandler("onClientCharacter", root, eventWrite)
    removeEventHandler("onClientKey", root, removeCharacter)
    removeEventHandler("onClientKey", root, enterKey)
	removeEventHandler("onClientPaste", root, pasteClipboardText)
end)

addEvent("account.removeQueryLoading", true)
addEventHandler("account.removeQueryLoading", root, function()
    isLoading = false
	removeEventHandler("onClientRender", root, renderQueryLoading)
end)

addEvent("account.spawnCharacterComplete", true)
addEventHandler("account.spawnCharacterComplete", root, function()
	clearChatBox()
	showChat(true)
	showCursor(false)
	fadeCamera(false, 0)
	setCameraTarget(localPlayer, localPlayer)
	addEventHandler("onClientRender", root, renderLoading)

	setTimer(function()
		removeEventHandler("onClientRender", root, renderVignette)
		removeEventHandler("onClientRender", root, renderLoading)
		fadeCamera(true, 2, 0, 0, 0)
		
		if isTimer(music.soundTimer) then killTimer(music.soundTimer)end
		if isElement(music.sound) then destroyElement(music.sound) end

		outputChatBox("[!]#FFFFFF " .. getPlayerName(localPlayer):gsub("_", " ") .. " isimli karakterinize giriş sağlandı.", 0, 255, 0, true)
		outputChatBox("[!]#FFFFFF İyi roller ve eğlenceler dileriz.", 0, 255, 0, true)
		
		triggerEvent("playSuccessfulSound", localPlayer)
	end, 2000, 1)
end)

addEventHandler("onClientPlayerChangeNick", root, function(oldNick, newNick)
	if (source == localPlayer) then
		local legitNameChange = getElementData(localPlayer, "legitnamechange")
		if (oldNick ~= newNick) and (legitNameChange == 0) then
			triggerServerEvent("account.resetPlayerName", localPlayer, oldNick, newNick)
			cancelEvent()
		end
	end
end)