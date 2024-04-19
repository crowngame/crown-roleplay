localPlayer = getLocalPlayer()
function carshop_showInfo(carPrice, taxPrice)
end
addEvent("carshop:showInfo", true)
addEventHandler("carshop:showInfo", getRootElement(), carshop_showInfo)

local gui, theVehicle = {}
function carshop_buyCar(carPrice, cashEnabled, bankEnabled)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return false
	end

	if gui["_root"] then
		return
	end

	setElementData(getLocalPlayer(), "exclusiveGUI", true, false)

	theVehicle = source

	--[[guiSetInputEnabled(true)
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":cr_resources/window_body.png", false)
	--guiWindowSetSizable(gui["_root"], false)

	gui["lblText1"] = guiCreateLabel(20, 25, windowWidth-40, 16, "Şu aracı almak üzeresiniz:", false, gui["_root"])
	gui["lblVehicleName"] = guiCreateLabel(20, 45+5, windowWidth-40, 13, exports.cr_global:getVehicleName(source) , false, gui["_root"])
	guiSetFont(gui["lblVehicleName"], "default-bold-small")
	gui["lblVehicleCost"] = guiCreateLabel(20, 45+15+5, windowWidth-40, 13, "Fiyat: $" .. exports.cr_global:formatMoney(carPrice), false, gui["_root"])
	guiSetFont(gui["lblVehicleCost"], "default-bold-small")
	gui["lblText2"] = guiCreateLabel(20, 45+15*2, windowWidth-40, 70, "Ödeme butonuna basmanızla birlikte iadenin mümkün olmadığını kabul etmiş sayılırsınız. Bizi seçtiğiniz için teşekkürler!", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblText2"], "left", true)
	guiLabelSetVerticalAlign(gui["lblText2"], "center", true)

	gui["btnCash"] = guiCreateButton(10, 140, 105, 41, "Nakit Öde", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCash"], carshop_buyCar_click, false)
	guiSetEnabled(gui["btnCash"], cashEnabled)

	 gui["btnBank"] = guiCreateButton(120000000000, 140, 105, 41, "Bankadan Öde", false, gui["_root"])
	 addEventHandler("onClientGUIClick", gui["btnBank"], carshop_buyCar_click, false)
	 guiSetEnabled(gui["btnBank"], bankEnabled)

	gui["btnCancel"] = guiCreateButton(232, 140, 105, 41, "İptal", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCancel"], carshop_buyCar_close, false)
end
addEvent("carshop:buyCar", true)
addEventHandler("carshop:buyCar", getRootElement(), carshop_buyCar)]]

function carshop_buyCar_click()
	if exports.cr_global:hasSpaceForItem(getLocalPlayer(), 3, 1) then
		local sourcestr = "cash"
		if (source == gui["btnBank"]) then
			sourcestr = "bank"
		end
		renkSec(sourcestr)
		--
	else
		outputChatBox("[!] #f0f0f0Envanterinizde anahtar için yeterli alanınız yok.", 0, 255, 0, true)
	end
	carshop_buyCar_close()
end


function carshop_buyCar_close()
	if gui["_root"] then
		destroyElement(gui["_root"])
		gui = { }
	end
	guiSetInputEnabled(false)
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
end
--PREVENT ABUSER TO CHANGE CHAR
addEventHandler ("onSapphireXMBShow", getRootElement(), carshop_buyCar_close)
addEventHandler("onClientChangeChar", getRootElement(), carshop_buyCar_close)

function carshop_buyCar_close2()
	if renkWindow then
		destroyElement(renkWindow)
		renkWindow = nil
	end
	guiSetInputEnabled(false)
	showCursor(false)
end
--PREVENT ABUSER TO CHANGE CHAR
addEventHandler ("onSapphireXMBShow", getRootElement(), carshop_buyCar_close2)
addEventHandler("onClientChangeChar", getRootElement(), carshop_buyCar_close2)

function cleanUp()
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
end
addEventHandler("onClientResourceStart", resourceRoot, cleanUp)

function renkSec(sourcestr)
	showCursor(true)
	if renkWindow then
		return
	end

	guiSetInputEnabled(true)
	local screenW, screenH = guiGetScreenSize()
    renkWindow = guiCreateWindow((screenW - 392) / 2, (screenH - 172) / 2, 392, 172, "cortadoMTA - Aracınızın rengini belirleyin.", false)
    guiWindowSetSizable(renkWindow, false)

    siyahImg = guiCreateStaticImage(69, 28, 55, 62, ":carshop-system/img/whitedot.png", false, renkWindow)
    guiSetProperty(siyahImg, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
    siyahOpt = guiCreateRadioButton(88, 94, 15, 15, "", false, renkWindow)
    griImg = guiCreateStaticImage(134, 28, 55, 62, ":carshop-system/img/whitedot.png", false, renkWindow)
    guiSetProperty(griImg, "ImageColours", "tl:FF656565 tr:FF656565 bl:FF656565 br:FF656565")
    griOpt = guiCreateRadioButton(155, 94, 15, 15, "", false, renkWindow)
    beyazImg = guiCreateStaticImage(199, 28, 55, 62, ":carshop-system/img/whitedot.png", false, renkWindow)
    guiSetProperty(beyazImg, "ImageColours", "tl:FFFFFEFE tr:FFFFFEFE bl:FFFFFEFE br:FFFFFEFE")
    beyazOpt = guiCreateRadioButton(219, 94, 15, 15, "", false, renkWindow)
    kirmiziImg = guiCreateStaticImage(264, 28, 55, 62, ":carshop-system/img/whitedot.png", false, renkWindow)
    guiSetProperty(kirmiziImg, "ImageColours", "tl:FFFE0500 tr:FFFE0500 bl:FFFE0500 br:FFFE0500")
    kirmiziOpt = guiCreateRadioButton(284, 94, 15, 15, "", false, renkWindow)
    maviImg = guiCreateStaticImage(329, 28, 54, 62, ":carshop-system/img/whitedot.png", false, renkWindow)
    guiSetProperty(maviImg, "ImageColours", "tl:FF0A04FA tr:FF0A04FA bl:FF0A04FA br:FF0A04FA")
    maviOpt = guiCreateRadioButton(350, 94, 15, 15, "", false, renkWindow)
    noRenkBtn = guiCreateButton(9, 28, 50, 81, "Aracın Kendi Rengini Kullan", false, renkWindow)
    secBtn = guiCreateButton(9, 117, 373, 43, "Seç ve Devam Et", false, renkWindow)  
	addEventHandler("onClientGUIClick", guiRoot, 
		function() 
			if source == secBtn then
				local r, g, b = 0, 0, 0
				if guiRadioButtonGetSelected(siyahOpt) then
					r, g, b = 0, 0, 0
				elseif guiRadioButtonGetSelected(griOpt) then
					r, g, b = 100, 100, 100
				elseif guiRadioButtonGetSelected(beyazOpt) then
					r, g, b = 255, 255, 255
				elseif guiRadioButtonGetSelected(kirmiziOpt) then
					r, g, b = 255, 0, 0
				elseif guiRadioButtonGetSelected(maviOpt) then
					r, g, b = 0, 0, 255
				end
				triggerServerEvent("carshop:buyCar", theVehicle, sourcestr, {r, g, b})	
				carshop_buyCar_close2()
			elseif source == noRenkBtn then
				triggerServerEvent("carshop:buyCar", theVehicle, sourcestr)	
				carshop_buyCar_close2()
			end
		end
	)
end
end