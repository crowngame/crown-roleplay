local screenW, screenH = guiGetScreenSize()

local lsnPed = createPed(240, 8.4716796875, -3.6376953125, 40.4296875)
setElementRotation(lsnPed, 0, 0, -90)
setElementDimension(lsnPed, 16)
setElementInterior(lsnPed, 24)
setElementData(lsnPed, "nametag", true)
setElementData(lsnPed, "name", "David Parks")
setElementFrozen(lsnPed, true)

function reklamVer()
	if getElementData(localPlayer, "vip") > 0 then
		reklamGUI()
	end
end
addCommandHandler("reklamver", reklamVer, false, false)

function reklamGUI()
	guiSetInputMode("no_binds_when_editing")
	
	reklamWindow = guiCreateWindow((screenW - 484) / 2, (screenH - 183) / 2, 484, 183, "Crown Roleplay - Reklam Verme Arayüzü", false)
	guiWindowSetSizable(reklamWindow, false)

	label = guiCreateLabel(10, 24, 464, 26, "Reklamınız:", false, reklamWindow)
	guiLabelSetVerticalAlign(label, "center")
	
	edit = guiCreateEdit(10, 50, 464, 29, "", false, reklamWindow)
	
	submit = guiCreateButton(10, 89, 464, 34, "Reklamı Gönder ($100)", false, reklamWindow)
	guiSetProperty(submit, "NormalTextColour", "FFAAAAAA")
	
	close = guiCreateButton(10, 133, 464, 34, "Pencereyi Kapat", false, reklamWindow)
	guiSetProperty(close, "NormalTextColour", "FFAAAAAA")
	
	addEventHandler("onClientGUIClick", guiRoot, onClientGUIClick)
end
addEvent("reklamGUI", true)
addEventHandler("reklamGUI", root, reklamGUI)

local spamTimers = {}

function onClientGUIClick()
	if source == close then
		destroyElement(reklamWindow)
	elseif source == submit then
		if not isTimer(spamTimers[localPlayer]) then
			if exports.cr_global:hasMoney(localPlayer, 100) then
				triggerServerEvent("advertisement.send", localPlayer, guiGetText(edit))
				spamTimers[localPlayer] = setTimer(function() end, 5 * 60 * 1000, 1)
			else
				outputChatBox("[!]#FFFFFF Reklam vermek için yeterli paranız yok.", 255, 0, 0, true)
				playSoundFrontEnd(4)
			end
		else
			outputChatBox("[!]#FFFFFF Her 5 dakikada bir reklam gönderebilirsiniz.", 255, 0, 0, true)
			playSoundFrontEnd(4)
		end
		destroyElement(reklamWindow)
	end
end