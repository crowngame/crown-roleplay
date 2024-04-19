local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local resourceName = getResourceName(getThisResource())
------------------------------------------

function account_settings()
	guiSetInputEnabled (true)
	local window = { }
	local width = 400
	local height = getAdminLevel() > 1 and 260 or 210
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Hesap Ayarları", false)
	
	window.passLabel	= guiCreateLabel(10, 37, 70, 20, "Şifre: ", false, window.window)
	window.repeatLabel	= guiCreateLabel(10, 76, 100, 20, "Şifre Tekrarı: ", false, window.window)
	
	window.passEdit		= guiCreateEdit(80, 30, width - 90, 30, "", false, window.window)
	window.repeatEdit	= guiCreateEdit(80, 70, width - 90, 30, "", false, window.window)
	
	
	
	window.editButton = guiCreateButton(10, (getAdminLevel() > 1 and height - 150 or height - 100), width - 20, 40, "Düzenle", false, window.window)
	addEventHandler("onClientGUIClick", window.editButton, 
		function ()
			guiSetInputEnabled (false)
			local pass = guiGetText(window.passEdit)
			local rep = guiGetText(window.repeatEdit)
			if pass == rep then
				triggerServerEvent(resourceName .. ":edit_self", getLocalPlayer(), pass)
			else
				edit_failure()
			end
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
		end
	, false)
	
	if getAdminLevel() > 1 then
		window.adminButton = guiCreateButton(10, height - 100, width - 20, 40, "Hesapları Düzenle", false, window.window)
		addEventHandler("onClientGUIClick", window.adminButton,
			function ()
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
				triggerServerEvent(resourceName .. ":system_admin", getLocalPlayer())
			end
		, false)
	end
	
	
	window.closeButton = guiCreateButton(10, height - 50, width - 20, 40, "Kapat", false, window.window)
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

function edit_success()
	local window = { }
	local width = 240
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Hesap Güncellemesi!", false)
	
	window.errorLabel = guiCreateLabel(10, 30, width - 20, 20, "Hesabın güncellendi!", false, window.window)
	
	
	window.closeButton = guiCreateButton(10, 60, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			showCursor(false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			--window = { }
			--triggerServerEvent(resourceName .. ":main", getLocalPlayer())
		end
	, false)
end

function edit_failure()
	local window = { }
	local width = 240
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Hesap Hatası!", false)
	
	window.errorLabel = guiCreateLabel(10, 30, width - 20, 20, "Şifreler eşleşmiyor!", false, window.window)
	
	
	window.closeButton = guiCreateButton(10, 60, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			account_settings ()
		end
	, false)
end

------------------------------------------
addEvent(resourceName .. ":edit_self_success", true)
addEventHandler(resourceName .. ":edit_self_success", getRootElement(), edit_success)