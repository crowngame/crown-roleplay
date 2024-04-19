function enterCommand(commandName, ...)
	triggerServerEvent("checkCommandEntered", getLocalPlayer(), getLocalPlayer(), commandName, ...)
end
addCommandHandler("check", enterCommand, false, false)

function CreateCheckWindow()
	local width, height = guiGetScreenSize()	
	Button = {}
	Window = guiCreateWindow(width-400,height/4,400,385,"Oyuncu Kontrolü",false)
	guiWindowSetSizable(Window, false)
	Button[3] = guiCreateButton(0.85,0.86,0.12, 0.125,"Close",true,Window)
	addEventHandler("onClientGUIClick", Button[3], CloseCheck)
	Label = {
		guiCreateLabel(0.03,0.06,0.95,0.0887,"İsim: N/A",true,Window),
		guiCreateLabel(0.03,0.10,0.66,0.0887,"IP: N/A",true,Window),
		guiCreateLabel(0.03,0.26,0.66,0.0887,"Para: N/A",true,Window),
		guiCreateLabel(0.03,0.30,0.17,0.0806,"HP: N/A",true,Window),
		guiCreateLabel(0.27,0.34,0.30,0.0806,"Zırh: N/A",true,Window),
		guiCreateLabel(0.03,0.34,0.17,0.0806,"Skin: N/A",true,Window),
		guiCreateLabel(0.27,0.30,0.30,0.0806,"Silah: N/A",true,Window),
		guiCreateLabel(0.03,0.38,0.66,0.0806,"Birlik: N/A",true,Window),
		guiCreateLabel(0.03,0.18,0.66,0.0806,"Ping: N/A",true,Window),
		guiCreateLabel(0.03,0.42,0.66,0.0806,"Araç: N/A",true,Window),
		guiCreateLabel(0.03,0.46,0.66,0.0806,"Uyarı: N/A",true,Window),
		guiCreateLabel(0.03,0.50,0.97,0.0766,"Bölge: N/A",true,Window),
		guiCreateLabel(0.7,0.06,0.4031,0.0766,"X:",true,Window),
		guiCreateLabel(0.7,0.10,0.4031,0.0766,"Y: N/A",true,Window),
		guiCreateLabel(0.7,0.14,0.4031,0.0766,"Z: N/A",true,Window),
		guiCreateLabel(0.7,0.18,0.2907,0.0806,"Interior: N/A",true,Window),
		guiCreateLabel(0.7,0.22,0.2907,0.0806,"Dimension: N/A",true,Window),
		guiCreateLabel(0.03,0.14,0.66,0.0887,"Yetki: N/A", true,Window),
		guiCreateLabel(0.7,0.26,0.4093,0.0806,"Karakter Saati: N/A\n~ Total: N/A",true,Window),
		guiCreateLabel(0.03,0.22,0.66,0.0887,"Bakiye: N/A", true,Window),
		guiCreateLabel(0.03,0.50,0.66,0.0806,"",true,Window),
	}
	
	-- player notes
	memo = guiCreateMemo(0.03, 0.55, 0.8, 0.42, "", true, Window)
	addEventHandler("onClientGUIClick", Window,
		function(button, state)
			if button == "left" and state == "up" then
				if source == memo then
					guiSetInputEnabled(true)
				else
					guiSetInputEnabled(false)
				end
			end
		end
	)
	Button[4] = guiCreateButton(0.85,0.55,0.12, 0.175,"Save\nNote",true,Window)
	
	addEventHandler("onClientGUIClick", Button[4], SaveNote, false)
	
	Button[5] = guiCreateButton(0.7,0.375,0.4093,0.15,"History: N/A",true,Window)
	addEventHandler("onClientGUIClick", Button[5], ShowHistory, false)
	
	Button[6] = guiCreateButton(0.85,0.73,0.12,0.125,"Inv.",true,Window)
	addEventHandler("onClientGUIClick", Button[6], showInventory, false)

	guiSetVisible(Window, false)
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function ()
		CreateCheckWindow()
	end
)

function OpenCheck(ip, adminreports, donPoints, note, history, warns, transfers, bankmoney, money, adminlevel, hoursPlayed, accountname, hoursAcc)
	player = source

	-- accountname
	guiSetText (Label[1], "İsim: " .. getPlayerName(player):gsub("_", " ") .. " (" .. accountname .. ")")
	if adminreports == nil then
		adminreports = "-1"
	end
	
	
	if donPoints == nil then
		donPoints = "Unknown"
	end
	
	if transfers == nil then
		transfers = "N/A"
	end
	
	if warns == nil then
		warns = "N/A"
	end
	
	if history == nil then
		history = "N/A"
	else
		local total = 0
		local str = {}
		for key, value in ipairs(history) do
			total = total + value[2]
			table.insert(str, value[2] .. " " .. getHistoryAction(value[1]))
			if key % 2 == 0 and key < #history then
				table.insert(str, "\n")
			end
		end
		history = table.concat(str, " ")
	end
	
	if bankmoney == nil then
		bankmoney = "-1"
	end
	
	guiSetText (Label[2], "IP: " .. ip)
	guiSetText (Label[18], "Yetki: " ..adminlevel.. " (" .. adminreports .. " Rapor)")
	guiSetText (Label[11], "Uyarılar: " .. warns)
	if not exports.cr_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		guiSetText (Label[3], "Cüzdan: N/A (Banka: N/A)")
	else	
		guiSetText (Label[3], "Cüzdan: $" .. exports.cr_global:formatMoney(money) .. " (Banka: $" .. exports.cr_global:formatMoney(bankmoney) .. ")")
	end
	guiSetText (Button[5], history)
	guiSetText (Label[20], "Bakiye: " .. exports.cr_global:formatMoney(donPoints) .. " TL")
	guiSetText (Label[19], "Saat: " .. (hoursPlayed or "N/A") .. "\n~ Toplam: " .. (hoursAcc or "N/A"))
	
	if (player == getLocalPlayer()) and not exports.cr_integration:isPlayerGameAdmin(getLocalPlayer()) then
		guiSetText (memo, "-You can not view your own note-")
		guiMemoSetReadOnly(memo, true)
		guiSetEnabled(Button[4], false)
	elseif not exports.cr_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		guiSetText (memo, "-You do not have access to admin note-")
		guiMemoSetReadOnly(memo, true)
		guiSetEnabled(Button[4], false)
	else
		guiSetText (memo, note or "ERROR: COULD NOT FETCH NOTE")
		guiSetEnabled(Button[4], true)
		guiMemoSetReadOnly(memo, false)
	end

	if not guiGetVisible(Window) then
		guiSetVisible(Window, true)
	end
end

addEvent("onCheck", true)
addEventHandler("onCheck", getRootElement(), OpenCheck)

-- function getPlayerTeams(thePlayer)
	-- string = "Factions: "
	-- for k,v in pairs(getElementData(thePlayer, "factions")) do
		-- string = string .. k .. ", "
	-- end
	-- return string ~= "Factions: " and string or "Factions: N/A"
-- end

addEventHandler("onClientRender", getRootElement(),
	function()
		if guiGetVisible(Window) and isElement(player) then
			local x, y, z = 0, 0, 0
			if not exports.cr_integration:isPlayerHelper(getLocalPlayer()) and getElementAlpha(player) ~= 0 or exports.cr_integration:isPlayerHeadAdmin(getLocalPlayer()) then 
				x, y, z = getElementPosition(player)
				guiSetText (Label[13], "X: " .. string.format("%.5f", x))
				guiSetText (Label[14], "Y: " .. string.format("%.5f", y))
				guiSetText (Label[15], "Z: " .. string.format("%.5f", z))
			
			else
				guiSetText (Label[13], "X: N/A")
				guiSetText (Label[14], "Y: N/A")
				guiSetText (Label[15], "Z: N/A")
			end
			
			guiSetText (Label[4], "HP: " .. math.floor(getElementHealth(player)))
			guiSetText (Label[5], "Zırh: " .. math.floor(getPedArmor(player)))
			guiSetText (Label[6], "Skin: " .. getElementModel(player))
			
			local weapon = getPedWeapon(player)
			if weapon then
				weapon = getWeaponNameFromID(weapon)
			else
				weapon = "N/A"
			end
			guiSetText (Label[7], "Silah: " .. weapon)
            local cekbirlik =  "Birlik: Bilinmiyor"
			guiSetText (Label[8], cekbirlik)
			guiSetText (Label[9], "Ping: " .. getPlayerPing(player))
			
			local vehicle = getPedOccupiedVehicle(player)
			if vehicle and not exports.cr_integration:isPlayerHelper(getLocalPlayer()) then
				guiSetText (Label[10], "Araç: " .. exports.cr_global:getVehicleName(vehicle) .. " (" ..getVehicleName(vehicle) .. " - " .. getElementData(vehicle, "dbid") .. ")")
			else
				guiSetText (Label[10], "Araç: N/A")
			end
			if not exports.cr_integration:isPlayerHelper(getLocalPlayer()) then
				guiSetText (Label[12], "Bölge: " .. getZoneName(x, y, z))
				guiSetText (Label[16], "Interior: " .. getElementInterior(player))
				guiSetText (Label[17], "Dimension: " .. getElementDimension(player))
			else
				guiSetText (Label[12], "Bölge: N/A")
				guiSetText (Label[16], "Interior: N/A")
				guiSetText (Label[17], "Dimension: N/A")
			end
		end
	end
)

function CloseCheck(button, state)
	if source == Button[3] and button == "left" and state == "up" then
		triggerEvent("cursorHide", getLocalPlayer())
		guiSetVisible(Window, false)
		guiSetInputEnabled(false)
		player = nil
	end
end

function SaveNote(button, state)
	if source == Button[4] and button == "left" and state == "up" then
		local text = guiGetText(memo)
		if text then
			triggerServerEvent("savePlayerNote", getLocalPlayer(), player, text)
		end
	end
end

function ShowHistory(button, state)
	if source == Button[5] and button == "left" and state == "up" then
		triggerServerEvent("showAdminHistory", getLocalPlayer(), player)
	end
end

function showInventory(button, state)
	if source == Button[6] and button == "left" and state == "up" then
		if not exports.cr_integration:isPlayerHelper(getLocalPlayer()) then
			triggerServerEvent("admin:showInventory", player)
		end
	end
end

local wHist, gHist, bClose, lastElement

-- window


addEvent("cshowAdminHistory", true)
addEventHandler("cshowAdminHistory", getRootElement(),
	function(info, targetID)
		if wHist then
			destroyElement(wHist)
			wHist = nil
			
			showCursor(false)
		else
			local sx, sy = guiGetScreenSize()
			
			local name
			if targetID == nil then
				name = getPlayerName(source)
			else
				name = "Account " .. tostring(targetID)
			end
			
			wHist = guiCreateWindow(sx / 2 - 350, sy / 2 - 250, 800, 600, tostring(targetID) .. " isimli kullanıcın tarihçesi", false)
			exports.cr_global:centerWindow(wHist)
			
			-- date, action, reason, duration, a.username, c.charactername, id
			
			gHist = guiCreateGridList(0, 0.04, 1, 0.88, true, wHist)
			local colID = guiGridListAddColumn(gHist, "ID", 0.05)
			local colAction = guiGridListAddColumn(gHist, "Ceza", 0.07)
			local colChar = guiGridListAddColumn(gHist, "Karakter", 0.2)
			local colReason = guiGridListAddColumn(gHist, "Sebep", 0.25)
			local colDuration = guiGridListAddColumn(gHist, "Süre", 0.07)
			local colAdmin = guiGridListAddColumn(gHist, "Yetkili", 0.15)
			local colDate = guiGridListAddColumn(gHist, "Tarih", 0.15)
			
			
			for _, res in pairs(info) do
				local row = guiGridListAddRow(gHist)
				guiGridListSetItemText(gHist, row, colID,   res[7]  or "?", false, true)
				guiGridListSetItemText(gHist, row, colAction, getHistoryAction(res[2]), false, false)
				guiGridListSetItemText(gHist, row, colChar, res[6], false, false)
				guiGridListSetItemText(gHist, row, colReason, res[3], false, false)
				guiGridListSetItemText(gHist, row, colDuration, historyDuration(res[4], tonumber(res[2])), false, false)
				guiGridListSetItemText(gHist, row, colAdmin, res[5], false, false)
				guiGridListSetItemText(gHist, row, colDate, res[1], false, false)
			end
		
			
			local bremove = guiCreateButton(0, 0.93, 0.5, 0.07, "Kaldır", true, wHist)
			addEventHandler("onClientGUIClick", bremove,
				function(button, state)
					if exports.cr_integration:isPlayerTrialAdmin(localPlayer) or exports.cr_integration:isPlayerHelper(localPlayer) then
						local row, col = guiGridListGetSelectedItem(gHist)
						if row ~= -1 and col ~= -1 then
							local gridID = guiGridListGetItemText(gHist , row, col)
							local record = getHistoryRecordFromId(info, gridID)
							if tonumber(record[2]) == 6 then
								return outputChatBox("[!]#FFFFFF Bu kayıt kaldırılamaz.", 255, 0, 0, true)
							end
							if not exports.cr_integration:isPlayerHeadAdmin(localPlayer) and tonumber(record[8]) ~= getElementData(localPlayer, "account:id") then
								return outputChatBox("[!]#FFFFFF Yalnızca cezayı uygulayan yetkili olduğunuz kayıt kaldırabilirsiniz.", 255, 0, 0, true)
							end
							triggerServerEvent("admin:removehistory", getLocalPlayer(), gridID)
							destroyElement(wHist)
							wHist = nil
							showCursor(false)
						else
							outputChatBox("[!]#FFFFFF Bir kayıt seçmeniz gerekiyor.", 255, 0, 0, true)
						end
					else
						outputChatBox("[!]#FFFFFF İtiraz etmek ve bu kayıtı kaldırılmasını sağlamak için lütfen discord adresimizden destek talebi oluşturun.", 255, 0, 0, true)
					end
				end, false
			)
		
			
			bClose = guiCreateButton(0.52, 0.93, 0.47, 0.07, "Kapat", true, wHist)
			addEventHandler("onClientGUIClick", bClose,
				function(button, state)
					if button == "left" and state == "up" then
						destroyElement(wHist)
						wHist = nil
						
						showCursor(false)
					end
				end, false
			)
			
			showCursor(true)
		end
	end
)
 