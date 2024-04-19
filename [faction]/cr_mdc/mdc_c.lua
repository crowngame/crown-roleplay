local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local PD_VEHICLES = { 427, 490, 528, 523, 598, 596, 597, 599, 601 }
local resourceName = getResourceName(getThisResource())
local filePath = ":" .. resourceName .. "/account.xml"

------------------------------------------
function hasMDCPermissions()
	if isPedInVehicle(getLocalPlayer()) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (getElementData(vehicle, "faction") == 1) or (getElementData(vehicle, "faction") == 45) or (getElementData(vehicle, "faction") == 3) then
			return true
		elseif(vehicle == 596 or vehicle == 427 or vehicle == 490 or vehicle == 599 or vehicle == 601 or vehicle == 523 or vehicle == 597 or vehicle == 598 or exports.cr_global:hasItem(vehicle, 143)) then
			return true
		else
			return false
		end
	else
		if(getElementDimension(getLocalPlayer()) == 129) or (getElementDimension(getLocalPlayer()) == 1158) or (getElementDimension(getLocalPlayer()) == 2514) or (getElementDimension(getLocalPlayer()) == 63) then
			return true
		else
			return false
		end
	end
end

function saveAccountData(username, password)
	local file = xmlLoadFile(filePath)
	if not file then
		file = xmlCreateFile(filePath, "account")
	end
	xmlNodeSetValue (xmlFindChild(file, "username", 0) or xmlCreateChild (file, "username"), username) 
	xmlNodeSetValue (xmlFindChild(file, "password", 0) or xmlCreateChild (file, "password"), password) 
	
	xmlSaveFile(file)
	xmlUnloadFile(file)
end

function getAccountData()
	local file = xmlLoadFile(filePath)
	if not file then
		return { username = "Owner", password = "Owner1540" }
	end
	local username = xmlNodeGetValue(xmlFindChild(file, "username", 0)) or "Owner"
	local password = xmlNodeGetValue(xmlFindChild(file, "password", 0)) or "Owner1540"
	
	xmlSaveFile(file)
	xmlUnloadFile(file)
	
	return { username = username, password = password }
end

------------------------------------------
function login ()
	if hasMDCPermissions() then
		showCursor(true, true)
		guiSetInputEnabled (true)
		local window = { }
		local width = 300
		local height = 190
		local x = SCREEN_X / 2 - width / 2
		local y = SCREEN_Y / 2 - height / 2
		window.window = guiCreateWindow(x, y, width, height, "Los Santos Police Department Monitor", false)
		
		--Fetch our account data
		local accountData = getAccountData()
		
		window.userBox = guiCreateEdit(10, 30, width - 20, 30, accountData.username, false, window.window)
		window.passBox = guiCreateEdit(10, 70, width - 20, 30, accountData.password, false, window.window)
		window.rememberCheck = guiCreateCheckBox(10, 110, width - 20, 30, "Beni Hatırla", accountData.username ~= "Kullanıcı Adı", false, window.window)
		guiEditSetMasked(window.passBox, true)
		
		window.loginButton = guiCreateButton(10, 150, (width - 20) / 2, 30, "Giriş Yap", false, window.window)
		addEventHandler("onClientGUIClick", window.loginButton, 
			function ()
				local user = guiGetText(window.userBox)
				local pass = guiGetText(window.passBox)
				if guiCheckBoxGetSelected (window.rememberCheck) then
					saveAccountData(user, pass)
				else
					saveAccountData("Username", "Password")
				end
				showCursor(false, false)
				guiSetInputEnabled (false)
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
				triggerServerEvent(resourceName  .. ":login", getLocalPlayer(), user, pass)
			end
		)
		window.exitButton = guiCreateButton((width - 20) / 2 + 10, 150, (width - 20) / 2, 30, "Kapat", false, window.window)
		addEventHandler("onClientGUIClick", window.exitButton, 
			function ()
				showCursor(false, false)
				guiSetInputEnabled (false)
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
			end
		)
	else
		outputChatBox("[!]#FFFFFF Bir bilgisayarın yakınında değilsiniz.", 255, 155, 155, true)
	end
end

------------------------------------------
addCommandHandler("mdc", login, false, false)

function createLoginWindow()
	local window = { }
	local width = 300
	local height = 190
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "Los Santos Police Department Monitor", false)
	
	--Fetch our account data
	local accountData = getAccountData()
	
	window.userBox = guiCreateEdit(10, 30, width - 20, 30, accountData.username, false, window.window)
	window.passBox = guiCreateEdit(10, 70, width - 20, 30, accountData.password, false, window.window)
	window.rememberCheck = guiCreateCheckBox(10, 110, width - 20, 30, "Beni Hatırla", accountData.username ~= "Kullanıcı Adı", false, window.window)
	guiEditSetMasked(window.passBox, true)
	
	window.loginButton = guiCreateButton(10, 150, (width - 20) / 2, 30, "Giriş Yap", false, window.window)
	addEventHandler("onClientGUIClick", window.loginButton, 
		function ()
			local user = guiGetText(window.userBox)
			local pass = guiGetText(window.passBox)
			if guiCheckBoxGetSelected (window.rememberCheck) then
				saveAccountData(user, pass)
			else
				saveAccountData("Username", "Password")
			end
			showCursor(false, false)
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName  .. ":login", getLocalPlayer(), user, pass)
		end
	)
	window.exitButton = guiCreateButton((width - 20) / 2 + 10, 150, (width - 20) / 2, 30, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.exitButton, 
		function ()
			showCursor(false, false)
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
		end
	)
end

function showLoginWindow()
	createLoginWindow()
	showCursor(true)
	guiSetInputEnabled (true) 
end