local kiralamaPed = createPed(120, 354.3173828125, -1812.6943359375, 4.4333090782166)
setElementData(kiralamaPed, "name", "Mike Johnson")
setElementData(kiralamaPed, "talk", 1)
setElementFrozen(kiralamaPed, true)

function centerWindow(center_window)
    local screenW,screenH=guiGetScreenSize()
    local windowW,windowH=guiGetSize(center_window,false)
    local x,y = (screenW-windowW)/2,(screenH-windowH)/2
    guiSetPosition(center_window,x,y,false)
end

local lp = getLocalPlayer()


Cartogo = {
    gridlist = {},
    window = {},
    button = {},
    label = {}
}

Cartogo.window[1] = guiCreateWindow(407, 250, 550, 243, "Araç Kiralama", false)
guiWindowSetSizable(Cartogo.window[1], false)
centerWindow(Cartogo.window[1])

Cartogo.button[1] = guiCreateButton(443, 169, 97, 25, "Kirala", false, Cartogo.window[1])
guiSetProperty(Cartogo.button[1], "NormalTextColour", "FFAAAAAA")
Cartogo.button[2] = guiCreateButton(443, 200, 97, 25, "Kapat", false, Cartogo.window[1])
guiSetProperty(Cartogo.button[2], "NormalTextColour", "FFAAAAAA")
Cartogo.gridlist[1] = guiCreateGridList(9, 23, 531, 141, false, Cartogo.window[1])

local column1 = guiGridListAddColumn(Cartogo.gridlist[1], "Araç", 0.5)
local column2 = guiGridListAddColumn(Cartogo.gridlist[1], "Fiyat", 0.3)
local column3 = guiGridListAddColumn(Cartogo.gridlist[1], "Durumu", 0.3)

local index1 = guiGridListAddRow(Cartogo.gridlist[1])
local index2 = guiGridListAddRow(Cartogo.gridlist[1])
local index3 = guiGridListAddRow(Cartogo.gridlist[1])
local index4 = guiGridListAddRow(Cartogo.gridlist[1])
local index5 = guiGridListAddRow(Cartogo.gridlist[1])
local index6 = guiGridListAddRow(Cartogo.gridlist[1])
local index7 = guiGridListAddRow(Cartogo.gridlist[1])

guiGridListSetItemText(Cartogo.gridlist[1], index1, column1, "Volkswagen Golf R32 (( Flash ))", false, false)
guiGridListSetItemText(Cartogo.gridlist[1], index1, column2, "300$", false, false)
guiGridListSetItemText(Cartogo.gridlist[1], index1, column3, "Müsait", true, false)
guiGridListSetItemText(Cartogo.gridlist[1], index2, column1, "Ford Crown Victoria (( Premier ))", false, false)
guiGridListSetItemText(Cartogo.gridlist[1], index2, column2, "450$", false, false)
guiGridListSetItemText(Cartogo.gridlist[1], index2, column3, "Müsait", true, false)
guiGridListSetItemText(Cartogo.gridlist[1], index3, column1, "Chevrolet Corvair (( Tampa ))", false, false)
guiGridListSetItemText(Cartogo.gridlist[1], index3, column2, "200$", false, false)
guiGridListSetItemText(Cartogo.gridlist[1], index3, column3, "Müsait", true, false)
guiGridListSetItemText(Cartogo.gridlist[1], index4, column1, "Toyota Hilux N50 (( Bobcat ))", false, false)
guiGridListSetItemText(Cartogo.gridlist[1], index4, column2, "350$", false, false)
guiGridListSetItemText(Cartogo.gridlist[1], index4, column3, "Müsait", true, false)

Cartogo.label[1] = guiCreateLabel(8, 172, 425, 61, "Araç Kiralamaya Hoşgeldiniz!\nKullanımdaki araçları kiralayamazsınız.\nKiraladığınız Araç Siz Terkedince Araç Kiralamaya Geri Döner.", false, Cartogo.window[1])
guiLabelSetColor(Cartogo.label[1], 255, 255, 255)
guiLabelSetHorizontalAlign(Cartogo.label[1], "center", false)

guiSetVisible(Cartogo.window[1], false)

local flash_fiyat = 300
local premier_fiyat = 450
local tampa_fiyat = 200
local bobcat_fiyat = 350

local flash_kullanim = false
local premier_kullanim = false
local tampa_kullanim = false
local bobcat_kullanim = false

addEventHandler("onClientGUIClick", Cartogo.button[2], function(button)

	if button == "left" then
		guiSetVisible(Cartogo.window[1], false)
		showCursor(false)
	end
end, false)

addEvent("kiralamaGoster", true)
addEventHandler("kiralamaGoster", getLocalPlayer(), 
	function()
		if (not getElementData(getLocalPlayer(), "kiralanmis")) then
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Mike Johnson: Hoşgeldiniz bayım, size nasıl yardımcı olabilirim?", 255, 255, 255, 10, {}, true)
			guiSetVisible(Cartogo.window[1], true)
			showCursor(true)
		else
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Mike Johnson: Üzgünüm, zaten bir araç kiraladınız. Aynı anda birden fazla araç kiralayamazsınız.", 255, 255, 255, 10, {}, true)
		end	
	end
)

addEventHandler("onClientGUIClick", Cartogo.button[1], function(button)
	local screenW, screenH = guiGetScreenSize()
	saatlikPencere = guiCreateWindow((screenW - 301) / 2, (screenH - 166) / 2, 301, 166, "Araç Kiralama - 808 Roleplay", false)
	guiWindowSetSizable(saatlikPencere, false)

	birsaatbuton = guiCreateButton(17, 32, 128, 51, "1 Saat", false, saatlikPencere)
	ikisaatbuton = guiCreateButton(155, 32, 128, 51, "2 Saat", false, saatlikPencere)
	ucsaatbuton = guiCreateButton(17, 93, 128, 51, "3 Saat", false, saatlikPencere)
	dortsaatbuton = guiCreateButton(155, 93, 128, 51, "4 Saat", false, saatlikPencere)

	local x, y, z = 0, 0, 0
	local rz = 0
	local int = 0
	local rnd_park = math.random(1, 5)

	if rnd_park == 1 then
		x, y, z = 350.29998779297, -1809.5, 4.4000000953674
	elseif rnd_park == 2 then
		x, y, z = 343.89999389648, -1809.6999511719, 4.4000000953674
	elseif rnd_park == 3 then
		x, y, z = 337.29998779297, -1809.8000488281, 4.5
	elseif rnd_park == 4 then
		x, y, z = 330.89999389648, -1809.8000488281, 4.5
	elseif rnd_park == 5 then
		x, y, z = 324.39999389648, -1809.5999755859, 4.5
	end

	if button == "left" then
		guiSetVisible(Cartogo.window[1], false)
		showCursor(false)
		if (guiGridListGetSelectedItem(Cartogo.gridlist[1]) == index1) and flash_kullanim == false then
			guiSetText(birsaatbuton, "1 Saat\n $" .. tostring(flash_fiyat))
			guiSetText(ikisaatbuton, "2 Saat\n $" .. tostring(flash_fiyat*2))
			guiSetText(ucsaatbuton, "3 Saat\n $" .. tostring(flash_fiyat*3))
			guiSetText(dortsaatbuton, "4 Saat\n $" .. tostring(flash_fiyat*4))
			addEventHandler("onClientGUIClick", birsaatbuton, 
				function()			
					triggerServerEvent("flashOlustur", lp, lp, x, y, z, rz, int, 3600000)
					setGridList("flash", "Kullanımda", "evet")
					flash_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", ikisaatbuton, 
				function()			
					triggerServerEvent("flashOlustur", lp, lp, x, y, z, rz, int, 7200000)
					setGridList("flash", "Kullanımda", "evet")
					flash_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", ucsaatbuton, 
				function()			
					triggerServerEvent("flashOlustur", lp, lp, x, y, z, rz, int, 10800000)
					setGridList("flash", "Kullanımda", "evet")
					flash_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", dortsaatbuton, 
				function()			
					triggerServerEvent("flashOlustur", lp, lp, x, y, z, rz, int, 14400000)
					setGridList("flash", "Kullanımda", "evet")
					flash_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			guiSetVisible(Cartogo.window[1], false)
		elseif (guiGridListGetSelectedItem(Cartogo.gridlist[1]) == index2) and premier_kullanim == false then
			guiSetText(birsaatbuton, "1 Saat\n $" .. tostring(premier_fiyat))
			guiSetText(ikisaatbuton, "2 Saat\n $" .. tostring(premier_fiyat*2))
			guiSetText(ucsaatbuton, "3 Saat\n $" .. tostring(premier_fiyat*3))
			guiSetText(dortsaatbuton, "4 Saat\n $" .. tostring(premier_fiyat*4))
			addEventHandler("onClientGUIClick", birsaatbuton, 
				function()			
					triggerServerEvent("premierOlustur", lp, lp, x, y, z, rz, int, 3600000)
					setGridList("premier", "Kullanımda", "evet")
					premier_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", ikisaatbuton, 
				function()			
					triggerServerEvent("premierOlustur", lp, lp, x, y, z, rz, int, 7200000)
					setGridList("premier", "Kullanımda", "evet")
					premier_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", ucsaatbuton, 
				function()			
					triggerServerEvent("premierOlustur", lp, lp, x, y, z, rz, int, 10800000)
					setGridList("premier", "Kullanımda", "evet")
					premier_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", dortsaatbuton, 
				function()			
					triggerServerEvent("premierOlustur", lp, lp, x, y, z, rz, int, 14400000)
					setGridList("premier", "Kullanımda", "evet")
					premier_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			guiSetVisible(Cartogo.window[1], false)
		elseif (guiGridListGetSelectedItem(Cartogo.gridlist[1]) == index3) and tampa_kullanim == false then
			guiSetText(birsaatbuton, "1 Saat\n $" .. tostring(tampa_fiyat))
			guiSetText(ikisaatbuton, "2 Saat\n $" .. tostring(tampa_fiyat*2))
			guiSetText(ucsaatbuton, "3 Saat\n $" .. tostring(tampa_fiyat*3))
			guiSetText(dortsaatbuton, "4 Saat\n $" .. tostring(tampa_fiyat*4))
			addEventHandler("onClientGUIClick", birsaatbuton, 
				function()			
					triggerServerEvent("tampaOlustur", lp, lp, x, y, z, rz, int, 3600000)
					setGridList("tampa", "Kullanımda", "evet")
					tampa_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", ikisaatbuton, 
				function()			
					triggerServerEvent("tampaOlustur", lp, lp, x, y, z, rz, int, 7200000)
					setGridList("tampa", "Kullanımda", "evet")
					tampa_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", ucsaatbuton, 
				function()			
					triggerServerEvent("tampaOlustur", lp, lp, x, y, z, rz, int, 10800000)
					setGridList("tampa", "Kullanımda", "evet")
					tampa_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", dortsaatbuton, 
				function()			
					triggerServerEvent("tampaOlustur", lp, lp, x, y, z, rz, int, 14400000)
					setGridList("tampa", "Kullanımda", "evet")
					tampa_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			guiSetVisible(Cartogo.window[1], false)
		elseif (guiGridListGetSelectedItem(Cartogo.gridlist[1]) == index4) and bobcat_kullanim == false then
			guiSetText(birsaatbuton, "1 Saat\n $" .. tostring(bobcat_fiyat))
			guiSetText(ikisaatbuton, "2 Saat\n $" .. tostring(bobcat_fiyat*2))
			guiSetText(ucsaatbuton, "3 Saat\n $" .. tostring(bobcat_fiyat*3))
			guiSetText(dortsaatbuton, "4 Saat\n $" .. tostring(bobcat_fiyat*4))
			addEventHandler("onClientGUIClick", birsaatbuton, 
				function()			
					triggerServerEvent("bobcatOlustur", lp, lp, x, y, z, rz, int, 3600000)
					setGridList("bobcat", "Kullanımda", "evet")
					bobcat_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", ikisaatbuton, 
				function()			
					triggerServerEvent("bobcatOlustur", lp, lp, x, y, z, rz, int, 7200000)
					setGridList("bobcat", "Kullanımda", "evet")
					bobcat_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", ucsaatbuton, 
				function()			
					triggerServerEvent("bobcatOlustur", lp, lp, x, y, z, rz, int, 10800000)
					setGridList("bobcat", "Kullanımda", "evet")
					bobcat_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			addEventHandler("onClientGUIClick", dortsaatbuton, 
				function()			
					triggerServerEvent("bobcatOlustur", lp, lp, x, y, z, rz, int, 14400000)
					setGridList("bobcat", "Kullanımda", "evet")
					bobcat_kullanim = true
					guiSetVisible(saatlikPencere, false)
				end
			)
			guiSetVisible(Cartogo.window[1], false)
		else
			if flash_kullanim == true then
				triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Mike Johnson: Üzgünüm ancak istediğiniz araç şu anda kullanımda.", 255, 255, 255, 10, {}, true)
				destroyElement(saatlikPencere)
			elseif premier_kullanim == true then
				triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Mike Johnson: Üzgünüm ancak istediğiniz araç şu anda kullanımda.", 255, 255, 255, 10, {}, true)
				destroyElement(saatlikPencere)
			elseif tampa_kullanim == true then
				triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Mike Johnson: Üzgünüm ancak istediğiniz araç şu anda kullanımda.", 255, 255, 255, 10, {}, true)
				destroyElement(saatlikPencere)
			elseif bobcat_kullanim == true then
				triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Mike Johnson: Üzgünüm ancak istediğiniz araç şu anda kullanımda.", 255, 255, 255, 10, {}, true)
				destroyElement(saatlikPencere)
			end
		end
	end
end, false)

function setGridList(typ, text, state)
	local text = tostring(text)
	local state = tostring(state)

	if typ == "flash" then
		guiGridListSetItemText(Cartogo.gridlist[1], index1, column3, text, true, false)
		if state == "hayır" then
			flash_kullanim = false
		else
			flash_kullanim = true
		end
	elseif typ == "premier" then
		guiGridListSetItemText(Cartogo.gridlist[1], index2, column3, text, true, false)
		if state == "hayır" then
			premier_kullanim = false
		else
			premier_kullanim = true
		end
	elseif typ == "tampa" then
		guiGridListSetItemText(Cartogo.gridlist[1], index3, column3, text, true, false)
		if state == "hayır" then
			tampa_kullanim = false
		else
			tampa_kullanim = true
		end
	elseif typ == "bobcat" then
		guiGridListSetItemText(Cartogo.gridlist[1], index4, column3, text, true, false)
		if state == "hayır" then
			bobcat_kullanim = false
		else
			bobcat_kullanim = true
		end
	end
end
addEvent("setGridList", true)
addEventHandler("setGridList", getRootElement(), setGridList)

addCommandHandler("kirabug", function(cmd) if exports.cr_integration:isPlayerManagement(getLocalPlayer()) then flash_kullanim = false premier_kullanim = false bobcat_kullanim = false tampa_kullanim = false end end)