--[[
--	Copyright (C) Root Gaming - All Rights Reserved
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Daniel Lett <me@lettuceboi.org>, December 2012
]]--

local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local resourceName = getResourceName(getThisResource())

------------------------------------------
function search ()
	guiSetInputEnabled (true)
	local window = { }
	local width = 400
	local height = 200
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "Los Santos Police Department Monitor", false)
	
	window.searchEdit = guiCreateEdit(10, 30, width - 20, 40, "Aranan...", false, window.window)
	
	window.searchCombo = guiCreateComboBox (10, 80, width - 20, 95, "Sorgu Tipi Seçiniz", false, window.window)
	guiComboBoxAddItem(window.searchCombo, "Kişi Kayıtları")
	guiComboBoxAddItem(window.searchCombo, "Araç Plakaları")
	guiComboBoxAddItem(window.searchCombo, "Ev ID'leri")
	guiComboBoxAddItem(window.searchCombo, "Araç ID'leri")
	
	window.goButton = guiCreateButton(10, 110, width - 20, 40, "Sorgula", false, window.window)
	addEventHandler("onClientGUIClick", window.goButton, 
		function ()
			local query = guiGetText(window.searchEdit)
			local queryType = guiComboBoxGetSelected (window.searchCombo)
			
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName  .. ":search", getLocalPlayer(), query, queryType)
		end
	, false)
	window.closeButton = guiCreateButton(10, 160, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":main", getLocalPlayer())
		end
	, false)
end

function search_noresult ()
	local window = { }
	local width = 240
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Sorgu - Sonuç Bulunamadı!", false)
	
	window.errorLabel = guiCreateLabel(10, 30, width - 20, 20, "Bunun için herhangi bir eşleşme bulamadık!", false, window.window)
	
	
	window.closeButton = guiCreateButton(10, 60, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			search()
		end
	, false)
end

function search_error ()
	local window = { }
	local width = 210
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Arama Hatası", false)
	
	window.errorLabel = guiCreateLabel(10, 30, width - 20, 20, "Bir arama türü seçmeniz gerekiyor!", false, window.window)
	
	
	window.closeButton = guiCreateButton(10, 60, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			search()
		end
	, false)
end

------------------------------------------
addEvent(resourceName .. ":search_error", true)
addEvent(resourceName .. ":search_noresult", true)
addEventHandler(resourceName .. ":search_error", getRootElement(), search_error)
addEventHandler(resourceName .. ":search_noresult", getRootElement(), search_noresult)