--[[
--	Copyright (C) Root Gaming - All Rights Reserved
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Daniel Lett <me@lettuceboi.org>, December 2012
]]--

local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local resourceName = getResourceName(getThisResource())

------------------------------------------
function getMDCAccountID()
	return getElementData(getLocalPlayer(), "mdc_account")
end

function getAdminLevel()
	return tonumber(getElementData(getLocalPlayer(), "mdc_admin"))
end

function main (warrants, apb, calls)
	showCursor(true, true)
	local window = { }
	local width = 700
	local height = 500
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "Los Santos Police Department Monitor", false)
	
	local spacer = 10
	local quarter = width / 3
	local button = { x = spacer, y = 30, width = quarter - spacer, height = 50 }
	
	--Search Button
	window.searchButton = guiCreateButton(button.x, button.y, button.width, button.height, "Veritaban Sorgula", false, window.window)
	addEventHandler("onClientGUIClick", window.searchButton, 
		function()
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			search()
		end
	, false)
	window.searchButtonImage = guiCreateStaticImage (5, 5, 40, 40, ":mdc-system/img/search.png", false, window.searchButton)
	
	--Add APB Button
	button.x = button.x + button.width + spacer
	window.addButton = guiCreateButton(button.x, button.y, button.width, button.height, "Aranan Kaydı Ekle", false, window.window)
	addEventHandler("onClientGUIClick", window.addButton, 
		function()
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			add_apb()
		end
	, false)
	window.searchButtonImage = guiCreateStaticImage (5, 5, 40, 40, ":mdc-system/img/add.png", false, window.addButton)
	
	--Account Settings Button
	button.x = button.x + button.width + spacer
	window.accountButton = guiCreateButton(button.x, button.y, button.width, button.height, "Hesap Ayarları", false, window.window)
	addEventHandler("onClientGUIClick", window.accountButton, 
		function()
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			account_settings()
		end
	, false)
	window.searchButtonImage = guiCreateStaticImage (5, 5, 40, 40, ":mdc-system/img/settings.png", false, window.accountButton)
	
	
	--Toll system button
	--[[
	button.x = button.x + button.width + spacer
	window.tollsButton = guiCreateButton(button.x, button.y, button.width, button.height, "Tolls", false, window.window)
	addEventHandler("onClientGUIClick", window.tollsButton,
		function ()
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":tolls", getLocalPlayer())
		end
	, false)
	]]
	window.mainPanel	= guiCreateTabPanel (10, 90, width - 15, height - 150, false, window.window)
	
	window.apbTab		= guiCreateTab("Arananlar", window.mainPanel)
	window.apbTable		= guiCreateGridList (10, 10, width - 35, height - 190, false, window.apbTab)
	
	window.personCol	= guiGridListAddColumn(window.apbTable, "Aranan", 0.25)
	window.wantedCol	= guiGridListAddColumn(window.apbTable, "Sebebi", 0.5)
	window.issuedByCol	= guiGridListAddColumn(window.apbTable, "Kuruluş", 0.25)
	
	if (#apb > 0) then
		for i = 1, #apb, 1 do
			local row = guiGridListAddRow (window.apbTable)
			guiGridListSetItemText(window.apbTable, row, window.personCol, apb[i][1]:gsub("_", " "), false, false)
			guiGridListSetItemText(window.apbTable, row, window.wantedCol, apb[i][2], false, false)
			guiGridListSetItemText(window.apbTable, row, window.issuedByCol, apb[i][3], false, false)
			guiGridListSetItemData(window.apbTable, row, window.personCol, apb[i][4])
		end
		
		addEventHandler("onClientGUIDoubleClick", window.apbTable,
			function ()
				local selectedRow, selectedCol = guiGridListGetSelectedItem(window.apbTable)
				local characterName = guiGridListGetItemText(window.apbTable, selectedRow, window.personCol)
				local description = guiGridListGetItemText(window.apbTable, selectedRow, window.wantedCol)
				local issuedBy = guiGridListGetItemText(window.apbTable, selectedRow, window.issuedByCol)
				local id = guiGridListGetItemData(window.apbTable, selectedRow, window.personCol)
				--triggerServerEvent(resourceName .. ":search", getLocalPlayer(), characterName, 0)
				view_apb(id, characterName, description, issuedBy)
				
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
			end
		, false)
		
	else
		local row = guiGridListAddRow (window.apbTable)
		guiGridListSetItemText (window.apbTable, row, window.personCol, "Aranan Kaydı Bulunmuyor", false, false)
	end
	
	
	window.warrantTab	= guiCreateTab("Şüpheli Kaydı", window.mainPanel)
	window.warrantTable	= guiCreateGridList (10, 10, width - 35, height - 190, false, window.warrantTab)
	window.charCol		= guiGridListAddColumn(window.warrantTable, "Şüpheli", 0.25)
	window.warrantCol	= guiGridListAddColumn(window.warrantTable, "Şüphe", 0.45)
	window.issuedCol	= guiGridListAddColumn(window.warrantTable, "Kuruluş", 0.25)
	
	if (#warrants > 0) then
		for i = 1, #warrants, 1 do
			local row = guiGridListAddRow (window.warrantTable)
			guiGridListSetItemText(window.warrantTable, row, window.charCol, warrants[i][1]:gsub("_", " "), false, false)
			guiGridListSetItemText(window.warrantTable, row, window.warrantCol, warrants[i][2], false, false)
			guiGridListSetItemText(window.warrantTable, row, window.issuedCol, warrants[i][3], false, false)
			--guiGridListSetItemData(window.warrantTable, row, window.propCol, warrants[i][1])
		end
		
		addEventHandler("onClientGUIDoubleClick", window.warrantTable,
			function ()
				local selectedRow, selectedCol = guiGridListGetSelectedItem(window.warrantTable)
				local characterName = guiGridListGetItemText(window.warrantTable, selectedRow, window.charCol)
				triggerServerEvent(resourceName .. ":search", getLocalPlayer(), characterName, 0)
				
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
			end
		, false)
		
	else
		local row = guiGridListAddRow (window.warrantTable)
		guiGridListSetItemText (window.warrantTable, row, window.charCol, "Şüpheli Kaydı Bulunmuyor", false, false)
	end
	
	
	window.callsTab			= guiCreateTab("İhbarlar", window.mainPanel)
	window.callsTable		= guiCreateGridList(10, 10, width - 35, height - 190, false, window.callsTab)
	window.callerCol		= guiGridListAddColumn(window.callsTable, "Arayan", 0.2)
	window.phoneCol			= guiGridListAddColumn(window.callsTable, "Telefon", 0.12)
	window.convoCol			= guiGridListAddColumn(window.callsTable, "Açıklama", 0.5)
	window.timeCol			= guiGridListAddColumn(window.callsTable, "Zaman", 0.1)
	
	if not calls then calls = {} end
	if (#calls > 0) then
		for i = 1, #calls, 1 do
			local row = guiGridListAddRow (window.callsTable)
			guiGridListSetItemText(window.callsTable, row, window.callerCol, calls[i][2], false, false)
			guiGridListSetItemData(window.callsTable, row, window.callerCol, calls[i][1])
			guiGridListSetItemText(window.callsTable, row, window.phoneCol, calls[i][3], false, false)
			guiGridListSetItemText(window.callsTable, row, window.convoCol, calls[i][4], false, false)
			guiGridListSetItemText(window.callsTable, row, window.timeCol, calls[i][5], false, false)
		end
		
		addEventHandler("onClientGUIDoubleClick", window.callsTable,
			function ()
				local selectedRow, selectedCol = guiGridListGetSelectedItem(window.callsTable)
				local characterName = guiGridListGetItemText(window.callsTable, selectedRow, window.callerCol)
				triggerServerEvent(resourceName .. ":search", getLocalPlayer(), characterName, 0)
				
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
			end
		, false)
		
	else
		local row = guiGridListAddRow (window.callsTable)
		guiGridListSetItemText (window.callsTable, row, window.callerCol, "İhbar Yok", false, false)
	end
	
	
	window.closeButton = guiCreateButton(10, height - 50, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			showCursor(false, false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
		end
	, false)
end

------------------------------------------
addEvent(resourceName .. ":main", true)
addEventHandler(resourceName .. ":main", getRootElement(), main)