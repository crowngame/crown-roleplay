wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil

function resourceStop()
	guiSetInputEnabled(false)
	showCursor(false)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), resourceStop)

local sx,sy = guiGetScreenSize()

addEvent("reports.close",true)
addEventHandler("reports.close",root,function()

	playSound("sound.mp3")
end)

addEvent("reports.send",true)
addEventHandler("reports.send",root,function(msg)
	if string.len(msg) <= 3 or string.len(msg) > 60 then
        outputChatBox("[!]#FFFFFF Raporunuz en az 3 karakter en fazla 60 karakter olmalıdır.", 255, 0, 0,true)
	return end	
	if msg == "" then outputChatBox("[!]#FFFFFF Lütfen rapor içeriğini boş bırakma.", 255, 0, 0, true) return end
	if getElementData(localPlayer, "reportNum") then
		outputChatBox("[!]#FFFFFF Zaten sırada beklemede olan bir raporun var, raporunu sonlandırmak için '/er'.", 255, 0, 0, true)
	else
		outputChatBox("[!]#FFFFFF Başarıyla rapor kaydın oluşturuldu, lütfen sabırla bekle.", 0, 255, 0, true)
		triggerServerEvent("clientSendReport", localPlayer, localPlayer, msg, 4)
	end
end)

function toggleReport()
	executeCommandHandler("report")
	if wHelp then
		guiSetInputEnabled(false)
		showCursor(false)
		destroyElement(wHelp)
		wHelp = nil
	end
end

local sx,sy = guiGetScreenSize()
local pg,pu = 550, 250
local x,y = (sx-pg)/2,(sy-pu)/2
gui={w={},m={},l={},b={}}

function createGUI()
	gui.w["ana"] = guiCreateWindow(x, y, pg, pu, "Oyuncu Raporlama Sistemi", false)
	guiSetVisible(gui.w["ana"], false)
	guiWindowSetSizable(gui.w["ana"], false)
	gui.l["bilgi"] = guiCreateLabel(10, 25, pg-10, 50, "Selam " .. getPlayerName(localPlayer):gsub("_", " ") .. ", oyuncu raporlama arayüzüne hoş geldin!\n Lütfen rapor gönderirken açıklayıcı bir şekilde sorununu belirt.\n Raporunu gönderirken imla kurallarına uy ve saygı çerçevesi içinde davran.", false, gui.w["ana"])
	guiLabelSetHorizontalAlign(gui.l["bilgi"], "center", true)
	guiSetFont(gui.l["bilgi"], "clear-normal")
	gui.m["rapor"] = guiCreateMemo(10, 80, pg-20, pu-135, "", false, gui.w["ana"])
	gui.b["kapat"] = guiCreateButton(10, pu-45, (pg-30)/2, 35, "Kapat", false, gui.w["ana"])
	gui.b["gonder"] = guiCreateButton((pg)/2+5, pu-45, (pg-25)/2, 35, "Gönder", false, gui.w["ana"])
	
	addEventHandler("onClientGUIClick", gui.b["kapat"], function()
		guiSetVisible(gui.w["ana"], false)
		showCursor(false)
	end, false)
	
	addEventHandler("onClientGUIClick", gui.b["gonder"], function()
		local yazi = guiGetText(gui.m["rapor"]):gsub(" ", " ")
		triggerEvent("reports.send", localPlayer, yazi)
		guiSetVisible(gui.w["ana"], false)
		showCursor(false)
	end, false)
end

bindKey("f2","down",function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if not gui.w["ana"] then createGUI() end
		guiSetVisible(gui.w["ana"],not guiGetVisible(gui.w["ana"]))
		showCursor(guiGetVisible(gui.w["ana"]))
	end
end)

addEventHandler('onClientResourceStart', root, function()
	guiSetInputMode("no_binds_when_editing")
end)

local function scale(w)
	local width, height = guiGetSize(w, false)
	local screenx, screeny = guiGetScreenSize()
	local minwidth = math.min(700, screenx)
	if width < minwidth then
		guiSetSize(w, minwidth, height / width * minwidth, false)
		local width, height = guiGetSize(w, false)
		guiSetPosition(w, (screenx - width) / 2, (screeny - height) / 2, false)
	end
end

function toggleVehTheft()
	if exports.cr_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		local status = getElementData(resourceRoot, "vehtheft")
		local numPdMembers = #getPlayersInTeam(exports.cr_faction:getTeamFromFactionID(1)) + #getPlayersInTeam(exports.cr_faction:getTeamFromFactionID(59)) --PD and HP
		if numPdMembers < 3 then return outputChatBox("Oyunda 3 tane aktif güvenlik olmadığından dolayı, bu özelliği değiştiremezsin.") end -- Automaticly to 'on hold' is less than 3 pd members
		if status == "Açık" then
			guiSetText(lVehTheftStatus, "Kapalı")
			guiLabelSetColor(lVehTheftStatus, 255, 0, 0)
			setElementData(resourceRoot, "vehtheft", "Kapalı")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Vehicle Theft", tostring(status))
		elseif status == "Kapalı" then
			guiSetText(lVehTheftStatus, "Açık")
			guiLabelSetColor(lVehTheftStatus, 0, 255, 0)
			setElementData(resourceRoot, "vehtheft", "Açık")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Vehicle Theft", tostring(status))
		end
	end
end

function togglePropBreak()
	if exports.cr_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		local status = getElementData(resourceRoot, "propbreak")
		local numPdMembers = #getPlayersInTeam(exports.cr_faction:getTeamFromFactionID(1)) + #getPlayersInTeam(exports.cr_faction:getTeamFromFactionID(59)) --PD and HP
		if numPdMembers < 3 then return outputChatBox("Oyunda 3 tane aktif güvenlik olmadığından dolayı, bu özelliği değiştiremezsin.") end -- Automaticly to 'on hold' is less than 3 pd members
		if status == "Açık" then
			guiSetText(lPropBreakStatus, "Kapalı")
			guiLabelSetColor(lPropBreakStatus, 255, 0, 0)
			setElementData(resourceRoot, "propbreak", "Kapalı")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Property Break-in", tostring(status))
		elseif status == "Kapalı" then
			guiSetText(lPropBreakStatus, "Açık")
			guiLabelSetColor(lPropBreakStatus, 0, 255, 0)
			setElementData(resourceRoot, "propbreak", "Açık")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Property Break-in", tostring(status))
		end
	end
end

function togglePaperForg()
	if exports.cr_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		local status = getElementData(resourceRoot, "papforg")
		local numPdMembers = #getPlayersInTeam(exports.cr_faction:getTeamFromFactionID(1)) + #getPlayersInTeam(exports.cr_faction:getTeamFromFactionID(59)) --PD and HP
		if numPdMembers < 3 then return outputChatBox("Oyunda 3 tane aktif güvenlik olmadığından dolayı, bu özelliği değiştiremezsin.") end -- Automaticly to 'on hold' is less than 3 pd members
		if status == "Açık" then
			guiSetText(lPapForgeryStatus, "Kapalı")
			guiLabelSetColor(lPapForgeryStatus, 255, 0, 0)
			setElementData(resourceRoot, "papforg", "Kapalı")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Paper Forgery", tostring(status))
		elseif status == "Kapalı" then
			guiSetText(lPapForgeryStatus, "Açık")
			guiLabelSetColor(lPapForgeryStatus, 0, 255, 0)
			setElementData(resourceRoot, "papforg", "Açık")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Paper Forgery", tostring(status))
		end
	end
end

-- // Farid
function showReportMainUI()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	--outputDebugString(logged)
	if (logged==1) then
		if (wReportMain==nil)  then
			reportedPlayer = nil
			wReportMain = guiCreateWindow(0.2, 0.2, 0.2, 0.25, "Crown Roleplay - Yardım Arayüzü", true)
			playSound("sound.mp3")
			scale(wReportMain)
			guiSetInputEnabled(true)

			lPlayerName = guiCreateLabel(0, 0.1, 1.0, 0.3, "Kimi şikayet ediyorsun?", true, wReportMain)
			guiLabelSetHorizontalAlign(lPlayerName, "center", true)			
			guiSetFont(lPlayerName, "default-bold-small")

			tPlayerName = guiCreateEdit(0.3799, 0.13 , 0.25, 0.08, "Aradığınız Isim / ID", true, wReportMain)
			guiLabelSetHorizontalAlign(lPlayerName, "center", true)						
			addEventHandler("onClientGUIClick", tPlayerName, function()
				guiSetText(tPlayerName,"")
			end, false)

			lNameCheck = guiCreateLabel(0, 0.220, 1.0, 0.3, "Üst tarafı doldurmak zorunda değilsin.", true, wReportMain)
			guiLabelSetHorizontalAlign(lNameCheck, "center", true)						
			guiSetFont(lNameCheck, "default-bold-small")
			guiLabelSetColor(lNameCheck, 0, 255, 0)
			addEventHandler("onClientGUIChanged", tPlayerName, checkNameExists)

			lReportType = guiCreateLabel(0, 0.26, 1.0, 0.3, "Rapor içeriğinizi seçiniz.", true, wReportMain)
			guiLabelSetHorizontalAlign(lReportType, "center", true)			
			guiSetFont(lReportType, "default-bold-small")

			cReportType = guiCreateComboBox(0.358, 0.32, 0.3, 0.34, "Raporuma içerik belirle.", true, wReportMain)
			
			for key, value in ipairs(reportTypes) do
				guiComboBoxAddItem(cReportType, value[1])
			end
			addEventHandler("onClientGUIComboBoxAccepted", cReportType, canISubmit)
			addEventHandler("onClientGUIComboBoxAccepted", cReportType, function()
				local selected = guiComboBoxGetSelected(cReportType)+1
				guiLabelSetHorizontalAlign(lReportType, "center", true)
				guiSetText(lReportType, reportTypes[selected][7])
				end)

			lReport = guiCreateLabel(0, 0.45, 1.0, 0.3, "Merhaba sayın oyuncu, senden bir ricam var. Lütfen rapor açarken yazım kurallarına uy, sabırla bekle. ", true, wReportMain)
			guiLabelSetHorizontalAlign(lReport, "center")
			guiSetFont(lReport, "default-bold-small")
			guiSetFont(lPlayerName, "default-bold-small")

			tReport = guiCreateMemo(0.025, 0.49, 6, 0.3, "", true, wReportMain)
			addEventHandler("onClientGUIChanged", tReport, canISubmit)

			lLengthCheck = guiCreateLabel(0.29, 0.81, 0.4, 0.3, "Uzunluk: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150", true, wReportMain)
			guiLabelSetHorizontalAlign(lLengthCheck, "center")
			guiLabelSetColor(lLengthCheck, 0, 255, 0)
			guiSetFont(lLengthCheck, "default-bold-small")

			bSubmitReport = guiCreateButton(0, 0.875, 0.2, 0.1, "Gönder", true, wReportMain)
			addEventHandler("onClientGUIClick", bSubmitReport, submitReport)

			guiWindowSetSizable(wReportMain, false)
			showCursor(true)
			triggerEvent("hud:convertUI", localPlayer, wReportMain)			

		elseif (wReportMain~=nil) then
			guiSetVisible(wReportMain, false)
			destroyElement(wReportMain)

			wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil
			guiSetInputEnabled(false)
			showCursor(false)
		end
	end
end
-- addCommandHandler("report", showReportMainUI)

function submitReport(button, state)
	if (source==bSubmitReport) and (button=="left") and (state=="up") then
		
		triggerServerEvent("clientSendReport", getLocalPlayer(), reportedPlayer or getLocalPlayer(), tostring(guiGetText(tReport)), (guiComboBoxGetSelected(cReportType)+1))

		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		if (wHelp) then
			destroyElement(wHelp)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

function checkReportLength(theEditBox)
	guiSetText(lLengthCheck, "Uzunluk: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150")

	if (tonumber(string.len(tostring(guiGetText(tReport))))-1>150) then
		guiLabelSetColor(lLengthCheck, 255, 0, 0)
		return false
	elseif (tonumber(string.len(tostring(guiGetText(tReport))))-1<3) then
		guiLabelSetColor(lLengthCheck, 255, 0, 0)
		return false
	elseif (tonumber(string.len(tostring(guiGetText(tReport))))-1>130) then
		guiLabelSetColor(lLengthCheck, 255, 255, 0)
		return true
	else
		guiLabelSetColor(lLengthCheck,0, 255, 0)
		return true
	end
end

function checkType(theGUI)
	local selected = guiComboBoxGetSelected(cReportType)+1 -- +1 to relate to the table for later

	if not selected or selected == 0 then
		return false
	else
		return true
	end
end

function canISubmit()
	local rType = checkType()
	local rReportLength = checkReportLength()
	--[[local adminreport = getElementData(getLocalPlayer(), "adminreport")
	local gmreport = getElementData(getLocalPlayer(), "gmreport")]]
	local reportnum = getElementData(getLocalPlayer(), "reportNum")
	if rType and rReportLength then
		if reportnum then
			guiSetText(wReportMain, "Rapor kimliğiniz #" .. (reportnum).. " Hala beklemede. Lütfen başka bir şey göndermeden önce bekleyin veya bekleyin .. ")
		else
			guiSetEnabled(bSubmitReport, true)
		end
	else
		guiSetEnabled(bSubmitReport, false)
	end
end

function checkNameExists(theEditBox)
	local found = nil
	local count = 0


	local text = guiGetText(theEditBox)
	if text and #text > 0 then
		local players = getElementsByType("player")
		if tonumber(text) then
			local id = tonumber(text)
			for key, value in ipairs(players) do
				if getElementData(value, "playerid") == id then
					found = value
					count = 1
					break
				end
			end
		else
			for key, value in ipairs(players) do
				local username = string.lower(tostring(getPlayerName(value)))
				if string.find(username, string.lower(text)) then
					count = count + 1
					found = value
					break
				end
			end
		end
	end

	if (count>1) then
		guiSetText(lNameCheck, "Multiple Found - Will take yourself to submit.")
		guiLabelSetColor(lNameCheck, 255, 255, 0)
	elseif (count==1) then
		guiSetText(lNameCheck, "Seçilen: " .. getPlayerName(found) .. " [ID #" .. getElementData(found, "playerid") .. "]")
		guiLabelSetColor(lNameCheck, 0, 255, 0)
		reportedPlayer = found
	elseif (count==0) then
		guiSetText(lNameCheck, "Böyle bir oyuncu yok. Kafandan bir şeyler üretiyorsun sanırım.")
		guiLabelSetColor(lNameCheck, 255, 0, 0)
	end
end

-- Close button
function clickCloseButton(button, state)
	if (source==bClose) and (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		if (wHelp) then
			destroyElement(wHelp)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil
		guiSetInputEnabled(false)
		showCursor(false)
	elseif (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil
		guiSetInputEnabled(false)
		showCursor(false)

		triggerEvent("viewF1Help", getLocalPlayer())
	end
end

function onOpenCheck(playerID)
	executeCommandHandler ("check", tostring(playerID))
end
addEvent("report:onOpenCheck", true)
addEventHandler("report:onOpenCheck", getRootElement(), onOpenCheck)
