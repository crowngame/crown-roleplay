function bantbantlamaOnayGUI(arayan, aranan)
	local screenW, screenH = guiGetScreenSize()
    bantSorWindow = guiCreateWindow((screenW - 455) / 2, (screenH - 141) / 2, 455, 141, "Crown Roleplay - Ağız Bantlama Sistemi", false)
    guiWindowSetSizable(bantSorWindow, false)

    bantlamaTheLabel = guiCreateLabel(12, 25, 433, 40, getPlayerName(arayan) .. " isimli kişi ağızınızı bantlamak istiyor, kabul ediyor musunuz?", false, bantSorWindow)
    guiLabelSetHorizontalAlign(bantlamaTheLabel, "center", true)
    guiLabelSetVerticalAlign(bantlamaTheLabel, "center")
    bantlamaKabulEtSorBtn = guiCreateButton(12, 75, 215, 50, "Evet", false, bantSorWindow)
    guiSetProperty(bantlamaKabulEtSorBtn, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", bantlamaKabulEtSorBtn, function() destroyElement(bantSorWindow) triggerServerEvent("bant:bantlamaKabul", arayan, arayan, aranan) end)
    bantlamaReddetBtn = guiCreateButton(235, 75, 210, 50, "Hayır", false, bantSorWindow)
    guiSetProperty(bantlamaReddetBtn, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", bantlamaReddetBtn, function() destroyElement(bantSorWindow) triggerServerEvent("bant:bantlamaRed", arayan, arayan, aranan) end)
end
addEvent("bant:bantbantlamaOnayGUI", true)
addEventHandler("bant:bantbantlamaOnayGUI", root, bantbantlamaOnayGUI)