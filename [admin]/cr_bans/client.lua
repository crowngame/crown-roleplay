function createWindow(bans, clientBans)
    window = guiCreateWindow(0, 0, 700, 400, "Banlar (Toplam Banlar: " .. (#bans or 0) .. " - Toplam Client Banları: " .. (#clientBans or 0) .. ")", false)
    exports.cr_global:centerWindow(window)

	tabPanel = guiCreateTabPanel(10, 24, 680, 315, false, window)
	tab1 = guiCreateTab("Banlar", tabPanel)
	tab2 = guiCreateTab("Client Banlar", tabPanel)
	
	gridList1 = guiCreateGridList(10, 10, 660, 270, false, tab1)
    guiGridListAddColumn(gridList1, "Karakter Adı", 0.2)
    guiGridListAddColumn(gridList1, "Yetkili", 0.2)
    guiGridListAddColumn(gridList1, "Sebep", 0.15)
    guiGridListAddColumn(gridList1, "IP", 0.16)
    guiGridListAddColumn(gridList1, "Serial", 0.24)
	
	for k, v in ipairs(bans) do 
        local row = guiGridListAddRow(gridList1)
        guiGridListSetItemText(gridList1, row, 1, v[1] or "?", false, false)
        guiGridListSetItemText(gridList1, row, 2, v[2] or "?", false, false)
        guiGridListSetItemText(gridList1, row, 3, v[3] or "?", false, false)
        guiGridListSetItemText(gridList1, row, 4, v[4] or "?", false, false)
        guiGridListSetItemText(gridList1, row, 5, v[5] or "?", false, false)
    end
	
    gridList2 = guiCreateGridList(10, 10, 660, 270, false, tab2)
    guiGridListAddColumn(gridList2, "ID", 0.1)
    guiGridListAddColumn(gridList2, "Serial", 0.25)
    guiGridListAddColumn(gridList2, "Yetkili", 0.25)
    guiGridListAddColumn(gridList2, "Sebep", 0.15)
    guiGridListAddColumn(gridList2, "Tarih", 0.2)

    for k, v in ipairs(clientBans) do 
        local row = guiGridListAddRow(gridList2)
        guiGridListSetItemText(gridList2, row, 1, v[1] or "?", false, false)
        guiGridListSetItemText(gridList2, row, 2, v[2] or "?", false, false)
        guiGridListSetItemText(gridList2, row, 3, v[3] or "?", false, false)
        guiGridListSetItemText(gridList2, row, 4, v[4] or "?", false, false)
        guiGridListSetItemText(gridList2, row, 5, v[5] or "?", false, false)
    end

    close = guiCreateButton(0.01, 0.87, 0.47, 0.10, "Kapat", true, window)
    ok = guiCreateButton(0.5, 0.87, 0.48, 0.10, "Banı Kaldır", true, window)
end
addEvent("bans:openWindow", true)
addEventHandler("bans:openWindow", root, createWindow)

addEventHandler("onClientGUIClick", root, function(btn)
    if source == close then 
        destroyElement(window)
    elseif source == ok then
		if guiGetSelectedTab(tabPanel) == tab1 then
			local selectedItem = guiGridListGetSelectedItem(gridList1)
			if selectedItem and selectedItem ~= 1 then
				local serial = guiGridListGetItemText(gridList1, selectedItem, 5)
				triggerServerEvent("bans:removeBan", localPlayer, 1, serial)
				destroyElement(window)
				showCursor(false)
			end
		elseif guiGetSelectedTab(tabPanel) == tab2 then
			local selectedItem = guiGridListGetSelectedItem(gridList2)
			if selectedItem and selectedItem ~= 1 then
				local id = guiGridListGetItemText(gridList2, selectedItem, 1)
				triggerServerEvent("bans:removeBan", localPlayer, 2, id)
				destroyElement(window)
				showCursor(false)
			end
		end
    end
end)