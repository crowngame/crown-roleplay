--[[
--	Copyright (C) Root Gaming - All Rights Reserved
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Daniel Lett <me@lettuceboi.org>, December 2012
]]--

local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local resourceName = getResourceName(getThisResource())
------------------------------------------
function getTime(day, month, timestamp)
	local months = { "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık" }
	local days = { "Pazar", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi" }
	local time = nil
	local ts = nil
	
	if timestamp then
		time = getRealTime(timestamp)
	else
		time = getRealTime()
	end
	
	ts = (tonumber(time.hour) >= 12 and tostring(tonumber(time.hour) - 12) or time.hour) .. ":" .. ("%02d"):format(time.minute) .. (tonumber(time.hour) >= 12 and " PM" or " AM")
	
	if month then
		ts =  months[time.month + 1] .. " " ..  time.monthday .. ", " .. ts
	end
	
	if day then
		ts = days[time.weekday + 1].. ", " .. ts
	end
	
	return ts
end

function getShortTime(timestamp)
	local months = { "OCA", "ŞUB", "MAR", "NİS", "MAY", "HAZ", "TEM", "AĞU", "EYL", "EKİ", "KAS", "ARA" }
	local time = nil
	local ts = nil
	
	if timestamp then
		time = getRealTime(timestamp)
	else
		time = getRealTime()
	end
	
	ts = time.hour .. ":" .. ("%02d"):format(time.minute)
	ts =  months[time.month + 1] .. " " ..  time.monthday .. ", " .. tostring(tonumber(time.year) + 1900) .. " " .. ts
	
	return ts
end

function DEC_HEX(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

------------------------------------------
function add_apb()
	guiSetInputEnabled (true)
	local window = { }
	local width = 400
	local height = 280
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Aranan Ekle", false)
	
	local y = 30
	window.timeLabel 	= guiCreateLabel(10, y, 70, 20, "Tarih: ", false, window.window)
	y = y + 30
	window.descLabel 	= guiCreateLabel(10, y, 70, 20, "Açıklama: ", false, window.window)
	y = y + 70
	window.personLabel 	= guiCreateLabel(10, y, 70, 40, "Kişi \nDahil Olan: ", false, window.window)
	
	y = 30
	window.time2Label 	= guiCreateLabel(80, y, width - 90, 20, getTime(true, true, false), false, window.window)
	y = y + 30
	window.descMemo		= guiCreateMemo(80, y, width - 90, 60, "Yaşananlardan bazı ayrıntılar.", false, window.window)
	y = y + 70
	window.personEdit	= guiCreateEdit(80, y, width - 90, 30, "Kim Yaptı?", false, window.window)
	
	window.addButton = guiCreateButton(10, height - 100, width - 20, 40, "Aranmayı Ekle", false, window.window)
	addEventHandler("onClientGUIClick", window.addButton, 
		function ()
			local description = guiGetText(window.descMemo)
			local person = guiGetText(window.personEdit)
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":add_apb", getLocalPlayer(), description, person)
		end
	, false)
	
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

function view_apb(id, characterName, description, issuedBy)
	guiSetInputEnabled (true)
	local window = { }
	local width = 400
	local height = 280
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Arananlar", false)
	
	local y = 30
	window.issuedLabel 	= guiCreateLabel(10, y, 70, 20, "Kuruluş: ", false, window.window)
	y = y + 30
	window.descLabel 	= guiCreateLabel(10, y, 70, 20, "Açıklama: ", false, window.window)
	y = y + 70
	window.personLabel 	= guiCreateLabel(10, y, 70, 40, "Kişi \nDahil Olan: ", false, window.window)
	
	y = 30
	
	window.issuedEdit 	= guiCreateEdit(80, y, width - 90, 30, issuedBy, false, window.window)
	guiEditSetReadOnly(window.issuedEdit, true)
	y = y + 40
	
	window.descMemo		= guiCreateMemo(80, y, width - 90, 60, description, false, window.window)
	guiMemoSetReadOnly(window.descMemo, true)
	y = y + 70
	
	window.personButton	= guiCreateButton(80, y, width - 90, 30, characterName, false, window.window)
	addEventHandler("onClientGUIClick", window.personButton,
		function()
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":search", getLocalPlayer(), characterName, 0)
		end
	, false)
	
	window.addButton = guiCreateButton(10, height - 100, width - 20, 40, "Arananı Sil", false, window.window)
	addEventHandler("onClientGUIClick", window.addButton, 
		function ()
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			triggerServerEvent(resourceName .. ":remove_apb", getLocalPlayer(), id)
		end
	, false)
	
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