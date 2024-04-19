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
function display_vehicle (id, model, color1, color2, color3, color4, plate, faction, owner, owner_type, impounded, crimes)
	local window = { }
	local width = 500
	local height = 520
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow(x, y, width, height, "MDC Araç Arama: " ..  plate, false)
	
	window.nameLabel	= guiCreateLabel(10, 30, 180, 20, "Araç: ", false, window.window)
	window.plateLabel 	= guiCreateLabel(10, 50, 180, 20, "Plaka: ", false, window.window)
	window.primaryLabel	= guiCreateLabel(10, 70, 180, 20, "Birinci Renk: ", false, window.window)
	window.secondLabel	= guiCreateLabel(10, 90, 180, 20, "İkinci Renk: ", false, window.window)
	window.vinLabel		= guiCreateLabel(10, 110, 180, 20, "Araç ID: ", false, window.window)
	window.ownerLabel	= guiCreateLabel(10, 130, 220, 20, "Sahibi: ", false, window.window)
	window.impoundLabel	= guiCreateLabel(10, 150, 220, 20, "Vergi: ", false, window.window)
	
	local function color1_tocolor() local colors = fromJSON (color1) dxDrawRectangle (x + 105, y + 70, 18, 18, tocolor(colors[1], colors[2], colors[3]), true) end
	local function color2_tocolor() local colors = fromJSON (color2) dxDrawRectangle (x + 105, y + 90, 18, 18, tocolor(colors[1], colors[2], colors[3]), true) end
	addEventHandler("onClientRender", getRootElement(), color1_tocolor)
	addEventHandler("onClientRender", getRootElement(), color2_tocolor)
	
	window.name2Label		= guiCreateLabel(105, 30, 180, 20, getVehicleNameFromModel (model), false, window.window)
	window.plate2Label		= guiCreateLabel(105, 50, 180, 20, plate, false, window.window)
	window.vin2Label		= guiCreateLabel(105, 110, 180, 20, id, false, window.window)
	if owner_type ~= 1 then
		window.owner2Label		= guiCreateLabel(105, 130, 220, 20, owner:gsub("_", " "), false, window.window)
	else
		window.ownerButton		= guiCreateButton(105, 130, 220, 20, owner:gsub("_", " "), false, window.window)
		addEventHandler("onClientGUIClick", window.ownerButton,
			function ()
				removeEventHandler("onClientRender", getRootElement(), color1_tocolor)
				removeEventHandler("onClientRender", getRootElement(), color2_tocolor)
				guiSetInputEnabled (false)
				guiSetVisible(window.window, false)
				destroyElement(window.window)
				window = { }
				triggerServerEvent(resourceName .. ":search", getLocalPlayer(), owner, 0)
			end
		, false)
	end
	window.impound2Label	= guiCreateLabel(105, 150, 220, 20, (tonumber(impounded) == 1 and "Evet" or "Hayır"), false, window.window)
	
	window.mainPanel	= guiCreateTabPanel (10, 190, width - 20, 270, false, window.window)
	window.crimesTab	= guiCreateTab("Hız İhlaleri", window.mainPanel)
	window.crimesTable	= guiCreateGridList (10, 10, width - 40, 230, false, window.crimesTab)
	window.dateCol		= guiGridListAddColumn(window.crimesTable, "Tarih", 0.3)
	window.speedCol		= guiGridListAddColumn(window.crimesTable, "Hız", 0.15)
	window.locCol		= guiGridListAddColumn(window.crimesTable, "Lokasyon", 0.25)
	window.personCol	= guiGridListAddColumn(window.crimesTable, "Kişi", 0.3)
	
	if (#crimes > 0) then
		for i = 1, #crimes, 1 do
			local row = guiGridListAddRow (window.crimesTable)
			guiGridListSetItemText(window.crimesTable, row, window.dateCol, crimes[i][1], false, false)
			guiGridListSetItemText(window.crimesTable, row, window.speedCol, crimes[i][2], false, false)
			guiGridListSetItemText(window.crimesTable, row, window.locCol, crimes[i][3], false, false)
			guiGridListSetItemText(window.crimesTable, row, window.personCol, crimes[i][4], false, false)
			--[[guiGridListSetItemText(window.crimesTable, row, window.dateCol, getShortTime(crimes[i][5]), false, false)
			guiGridListSetItemText(window.crimesTable, row, window.crimeCol, crimes[i][2], false, false)
			guiGridListSetItemText(window.crimesTable, row, window.punishCol, crimes[i][3], false, false)
			guiGridListSetItemData(window.crimesTable, row, window.dateCol, crimes[i][5])
			guiGridListSetItemData(window.crimesTable, row, window.crimeCol, crimes[i][1])
			guiGridListSetItemData(window.crimesTable, row, window.punishCol, crimes[i][4])]]
		end
		
		
	else
		local row = guiGridListAddRow (window.crimesTable)
		guiGridListSetItemText (window.crimesTable, row, window.dateCol, "Hız İhlali Bulunmuyor", false, false)
	end
	
	
	window.closeButton = guiCreateButton(10, height - 50, width - 20, 40, "Kapat", false, window.window)
	addEventHandler("onClientGUIClick", window.closeButton, 
		function ()
			removeEventHandler("onClientRender", getRootElement(), color1_tocolor)
			removeEventHandler("onClientRender", getRootElement(), color2_tocolor)
			guiSetInputEnabled (false)
			guiSetVisible(window.window, false)
			destroyElement(window.window)
			window = { }
			if getElementData(getLocalPlayer(), "mdc_close_to") then
				triggerServerEvent(resourceName .. ":search", getLocalPlayer(), getElementData(getLocalPlayer(), "mdc_close_to"), getElementData(getLocalPlayer(), "mdc_close_type"))
			else
				triggerServerEvent(resourceName .. ":main", getLocalPlayer())
			end
		end
	, false)
end


------------------------------------------
addEvent(resourceName .. ":display_vehicle", true)
addEventHandler(resourceName .. ":display_vehicle", getRootElement(), display_vehicle)