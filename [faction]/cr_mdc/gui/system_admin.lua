--[[
--	Copyright (C) Root Gaming - All Rights Reserved
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Daniel Lett <me@lettuceboi.org>, December 2012
]]--

local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local resourceName = getResourceName(getThisResource())
------------------------------------------

function system_admin (users, count)
	local window = { }
	local width = 400
	local height = 400
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Sistem Yetkili Paneli", false)
	
	window.usersTable	= guiCreateGridList (10, 90, width - 20, height - 90 - 60, false, window.window)
	window.userCol		= guiGridListAddColumn(window.usersTable, "Kullanıcı", 0.7)
	window.levelCol		= guiGridListAddColumn(window.usersTable, "Yetki", 0.25)
	
	window.usersRows = { }
	for i = 1, count - 1, 1 do
		window.usersRows[i] = guiGridListAddRow (window.usersTable)
		guiGridListSetItemText (window.usersTable, window.usersRows[i], window.userCol, users[i][2], false, false)
		guiGridListSetItemText (window.usersTable, window.usersRows[i], window.levelCol, (tonumber(users[i][3]) == 1 and "Personel" or "Yetkili"), false, false)
		guiGridListSetItemData (window.usersTable, window.usersRows[i], window.userCol, users[i][1])
	end
	
	window.createButton = guiCreateButton(10, 30, (width / 3) - 15, 50, "Hesap Oluştur", false, window.window)
	addEventHandler("onClientGUIClick", window.createButton, 
		function()
			guiSetVisible(window.window, false)
			create()
		end
	, false)
	
	window.editButton = guiCreateButton(width / 3 + 5, 30, (width / 3) - 10, 50, "Hesap Düzenle", false, window.window)
	addEventHandler("onClientGUIClick", window.editButton, 
		function()
			local row, col = guiGridListGetSelectedItem (window.usersTable)
			local accountID =  guiGridListGetItemData (window.usersTable, row, window.userCol)
			local user =  guiGridListGetItemText (window.usersTable, row, window.userCol)
			local level =  guiGridListGetItemText (window.usersTable, row, window.levelCol)
			if accountID then
				edit(accountID, user, level)
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
			end
		end
	, false)
	
	window.deleteButton = guiCreateButton((width / 3 * 2) + 5, 30, (width / 3) - 15, 50, "Hesap Sil", false, window.window)
	addEventHandler("onClientGUIClick", window.deleteButton,
		function()
			local row, col = guiGridListGetSelectedItem (window.usersTable)
			local accountID =  guiGridListGetItemData (window.usersTable, row, window.userCol)
			if accountID then
				triggerServerEvent(resourceName .. ":delete_account", getLocalPlayer(), accountID)
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
			end
		end
	, false)
	
	window.closeButton = guiCreateButton(10, height - 50, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			guiSetVisible(window.window, false)
			destroyElement(window.window)
		    window = { }
		    showCursor(false, false)
			--triggerServerEvent(resourceName .. ":main", getLocalPlayer())
		end
	, false)
end

function create()
	guiSetInputEnabled (true)
	local window = { }
	local width = 400
	local height = 240
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Hesap Oluştur", false)
	
	window.userLabel	= guiCreateLabel(10, 37, 70, 20, "Kullanıcı Adı: ", false, window.window)
	window.passLabel	= guiCreateLabel(10, 76, 100, 20, "Şifre: ", false, window.window)
	window.levelLabel	= guiCreateLabel(10, 110, 100, 20, "Seviye: ", false, window.window)
	
	window.userEdit	= guiCreateEdit(80, 30, width - 90, 30, "", false, window.window)
	window.passEdit	= guiCreateEdit(80, 70, width - 90, 30, "", false, window.window)
	
	window.levelCombo = guiCreateComboBox (80, 110, width - 90, 65, "Seviye Seçin", false, window.window)
	guiComboBoxAddItem(window.levelCombo, "Personel")
	guiComboBoxAddItem(window.levelCombo, "Yetkili")
	
	window.editButton = guiCreateButton(10, height - 100, width - 20, 40, "Oluştur", false, window.window)
	addEventHandler("onClientGUIClick", window.editButton, 
		function ()
			guiSetInputEnabled (false)
			local user = guiGetText(window.userEdit)
			local pass = guiGetText(window.passEdit)
			local level = guiComboBoxGetSelected (window.levelCombo)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":create_account", getLocalPlayer(), user, pass, level)
		end
	, false)
	
	window.closeButton = guiCreateButton(10, height - 50, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":system_admin", getLocalPlayer())
		end
	, false)
end

function edit(accountID, user, level)
	guiSetInputEnabled (true)
	local window = { }
	local width = 400
	local height = 240
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Hesap Düzenle: " .. user, false)
	
	window.userLabel	= guiCreateLabel(10, 37, 70, 20, "Kullanıcı Adı: ", false, window.window)
	window.passLabel	= guiCreateLabel(10, 76, 100, 20, "Şifre: ", false, window.window)
	window.levelLabel	= guiCreateLabel(10, 110, 100, 20, "Seviye: ", false, window.window)
	
	window.userEdit	= guiCreateEdit(80, 30, width - 90, 30, user, false, window.window)
	window.passEdit	= guiCreateEdit(80, 70, width - 90, 30, "", false, window.window)
	
	window.levelCombo = guiCreateComboBox (80, 110, width - 90, 65, level, false, window.window)
	guiComboBoxAddItem(window.levelCombo, "Personel")
	guiComboBoxAddItem(window.levelCombo, "Yetkili")
	
	window.editButton = guiCreateButton(10, height - 100, width - 20, 40, "Düzenle!", false, window.window)
	addEventHandler("onClientGUIClick", window.editButton, 
		function ()
			guiSetInputEnabled (false)
			local user = guiGetText(window.userEdit)
			local pass = guiGetText(window.passEdit)
			local level = guiComboBoxGetSelected (window.levelCombo)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":edit_account", getLocalPlayer(), accountID, user, pass, level)
		end
	, false)
	
	window.closeButton = guiCreateButton(10, height - 50, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":system_admin", getLocalPlayer())
		end
	, false)
end



------------------------------------------
addEvent(resourceName .. ":system_admin", true)
addEventHandler(resourceName .. ":system_admin", getRootElement(), system_admin)