local screenX, screenY = guiGetScreenSize()
local font = exports.cr_fonts:getFont("sf-bold", 12)

local deathTimer = 50
local deathLabel = nil

function playerDeath()
	if isTimer(lowerTime) then
		killTimer(lowerTime)
	end

	if exports.cr_global:hasItem(localPlayer, 115) or exports.cr_global:hasItem(localPlayer, 116) then
		deathTimer = 200
	else
		deathTimer = 50
	end
	
	lowerTime = setTimer(lowerTimer, 1000, deathTimer)
	
	toggleAllControls(false, false, false)
	setElementData(localPlayer, "dead", 1)
	setElementData(localPlayer, "injury", 1)
	outputChatBox("[!]#FFFFFF Bayıldınız, " .. deathTimer .. " saniye sonra tekrar ayılacaksınız.", 0, 0, 255, true)
	addEventHandler("onClientRender", root, drawnTimer)
end
addEvent("playerdeath", true)
addEventHandler("playerdeath", localPlayer, playerDeath)

addEventHandler("onClientKey", root, function(button, press)
	if (getElementData(localPlayer, "dead") == 1) then
		if (press) then 
			if button == "lctrl" or button == "rctrl" or button == "space"  then 
				cancelEvent()     
				return true 
			end
		end
	end
end)

function lowerTimer()
	deathTimer = deathTimer - 1
	if deathTimer <= 0 then
		triggerServerEvent("es-system:acceptDeath", localPlayer, localPlayer, victimDropItem)
		playerRespawn()
		removeEventHandler("onClientRender", root, drawnTimer)
	end
end

function drawnTimer()
    local text = deathTimer .. " saniye sonra ayılacaksınız."
	dxDrawText(text, 0, 130, screenX, screenY - 75, tocolor(255, 255, 255, 255), 1, font, "center", "bottom")
end

function playerRespawn()
    removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	if isTimer(lowerTimer) then
		killTimer(lowerTimer)
		toggleAllControls(true, true, true)
		setElementData(source, "baygin", nil)
		setElementData(localPlayer, "dead", 0)
	end
end
addEvent("bayilmaRevive", true)
addEventHandler("bayilmaRevive", root, playerRespawn)

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", localPlayer, function()
	start = getTickCount()
end)

function closeRespawnButton()
	removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	if isTimer(lowerTimer) then
		killTimer(lowerTimer)
		toggleAllControls(true, true, true)
	end
end
addEvent("es-system:closeRespawnButton", true)
addEventHandler("es-system:closeRespawnButton", localPlayer, closeRespawnButton)

addEventHandler("onClientPlayerWasted", localPlayer, function(attacker, weapon, bodypart)
	if getElementData(source, "dead") == 1 then
		cancelEvent()
	end
end)

addEventHandler("onClientPlayerDamage", localPlayer, function()
	if getElementData(source, "dead") == 1 then
		cancelEvent()
	end
end)