GUIEditor = {
    gridlist = {},
    window = {},
    button = {}
}

function countryPanel()
    local screenW, screenH = guiGetScreenSize()
    GUIEditor.window[1] = guiCreateWindow((screenW - 232) / 2, (screenH - 306) / 2, 232, 306, "Ülke Seçme Paneli", false)
    guiWindowSetSizable(GUIEditor.window[1], false)
    GUIEditor.button[1] = guiCreateButton(10, 271, 213, 25, "Kaydet", false, GUIEditor.window[1])
    guiSetFont(GUIEditor.button[1], "default-bold-small")
    GUIEditor.gridlist[1] = guiCreateGridList(12, 29, 211, 240, false, GUIEditor.window[1])
    guiGridListAddColumn(GUIEditor.gridlist[1], "Ülkeler", 0.75)
    
	for i = 0, 49 do
        guiGridListAddRow(GUIEditor.gridlist[1])
    end
	
	guiGridListSetItemText(GUIEditor.gridlist[1], 1, 1, "Amerika", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 2, 1, "Almanya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 3, 1, "Rusya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 4, 1, "Avusturalya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 5, 1, "Arjantin", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 6, 1, "Belçika", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 7, 1, "Bulgaristan", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 8, 1, "Çin", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 9, 1, "Fransa", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 10, 1, "Brezilya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 11, 1, "İngiltere", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 12, 1, "İrlanda", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 13, 1, "İskoçya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 14, 1, "İsrail", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 15, 1, "İsveç", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 16, 1, "İsviçre", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 17, 1, "İtalya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 18, 1, "Jamaika", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 19, 1, "Japonya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 20, 1, "Kanada", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 21, 1, "Kolombiya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 22, 1, "Küba", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 23, 1, "Litvanya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 24, 1, "Macaristan", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 25, 1, "Makedonya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 26, 1, "Meksika", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 27, 1, "Nijerya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 28, 1, "Norveç", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 29, 1, "Peru", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 30, 1, "Portekiz", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 31, 1, "Romanya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 32, 1, "Sırbistan", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 33, 1, "Slovakya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 34, 1, "Ukrayna", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 35, 1, "Yunanistan", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 36, 1, "Danimarka", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 37, 1, "Çekya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 38, 1, "Polonya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 39, 1, "Güney Kore", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 40, 1, "Hollanda", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 41, 1, "Arnavutluk", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 42, 1, "İspanya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 43, 1, "Vietnam", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 44, 1, "Avusturya", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 45, 1, "Mısır", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 46, 1, "Güney Afrika", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 47, 1, "Qatar", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 48, 1, "Türkiye", false, false)
	guiGridListSetItemText(GUIEditor.gridlist[1], 49, 1, "Azerbaycan", false, false)
	
	showCursor(true)

    addEventHandler("onClientGUIClick", GUIEditor.button[1], bayrakEkle)
end
addEvent("account.countryPanel", true)
addEventHandler("account.countryPanel", root, countryPanel)

function bayrakEkle()
    local liste = GUIEditor.gridlist[1]
    local pencere = GUIEditor.window[1]

    if source == GUIEditor.button[1] then
        local countryIndex = guiGridListGetSelectedItem(liste)
        if countryIndex and countryIndex ~= -1 then
            triggerServerEvent("account.countryChange", localPlayer, countryIndex)
            showCursor(false)
            if isElement(pencere) then
                destroyElement(pencere)
            end
        else
			exports.cr_infobox:addBox("error", "Lütfen bir ülke seçin.")
        end
    end
end