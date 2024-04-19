local sx, sy = guiGetScreenSize()
local pg, pu = 256,512
local GUI  = {
	button = {},
	edit   = {},
	window = {},
	label  = {},
}

function toggleUber(bool)
	pg, pu = guiGetSize(wPhoneMenu,false)
	if bool then
		createUberGUI()
		addEventHandler("onClientGUIClick", root, clickUberFunctions)
	else
		if GUI.window[1] then 
			GUI.window[1]:destroy()
			GUI.window[1] = nil
		end
		removeEventHandler("onClientGUIClick", root, clickUberFunctions)
	end
end

function createUberGUI() -- CANER BUNLARIN PNGSİ DEĞİŞECEK VE POZİSYONLARI DEĞİŞECEK GÜZELCE AYARLA 
    GUI.window[1] = guiCreateStaticImage(0+20,0+92.5,pg-38,pu-165,"images/blackbg.png",false, wPhoneMenu)
    guiSetProperty(GUI.window[1], "NormalTextColour", "FF909090")
	GUI.edit[1] = guiCreateEdit(10, 65,200,30,"Müşteri ID'si giriniz!",false,GUI.window[1])
	GUI.label[1] = guiCreateLabel(10 , 125 , 250 , 150 , "Bir müşteri isen kendi butonuna \nbasarak bir taksi talep edebilirsin!\n  \nBir taksici isen kendi butonuna \nbasarak bir taksi talebini kabul \nedebilirsin!",false,GUI.window[1])
	GUI.button[1] = guiCreateStaticImage(10,pu-(pu/2), pg-60, 32,"images/taksibtn.png",false,GUI.window[1])-- MÜŞTERİ BUTONU
	GUI.button[2] = guiCreateStaticImage(10,pu-(pu/2.5), pg-60, 32,"images/taksibtn.png",false,GUI.window[1])-- TAKSİCİ BUTONU 
	GUI.label[2] = guiCreateLabel((pg-60)/2 - string.len("Taksi çağır!")*1.5 , 8 , 100 , 25 , "Taksi çağır!" , false , GUI.button[1])
	GUI.label[3] = guiCreateLabel((pg-60)/2 - string.len("Müşteri talebi al!")*1.85 , 8 , 100 , 25 , "Müşteri talebi al!" , false , GUI.button[2])
	guiSetEnabled(GUI.label[2] , false)
	guiSetEnabled(GUI.label[3] , false)
	guiLabelSetColor(GUI.label[2], 0,0,0)
	guiLabelSetColor(GUI.label[3], 0,0,0)
--	local GUI.button[3] = guiCreateStaticImage(120,495,35,30,"images/HomeTusu.png",false,GUI.window[1])
end


function clickUberFunctions() -- Tıklama fonksiyonları
	if source == GUI.button[1] then -- Müşteri tıklama olayı
		triggerServerEvent("uber:CallingDriver" , localPlayer)
	elseif source == GUI.button[2] then -- Sürücü tıklama olayı

		local target = guiGetText(GUI.edit[1])
		if target == "" or target == " " then
			outputChatBox("[!]#FFFFFF Bu kısma ID veya Müşteri ismi giriniz!",255,0,0,true)
		return end

		local veh = getPedOccupiedVehicle(localPlayer)
	
		if not veh or veh:getData("taksiplaka") ~= 1 or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then
			outputChatBox("[!]#FFFFFF Müşteri kabul etmek için taksi plakası olan bir araçta sürücü koltuğunda olman gerek!" ,255,0,0,true)
		return end-- Kontroller				
		
		triggerServerEvent("uber:CallingClient" , localPlayer , target)
	end
end