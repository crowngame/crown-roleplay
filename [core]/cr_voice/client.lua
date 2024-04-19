local screenX, screenY = guiGetScreenSize()
local font = exports.cr_fonts:getFont("UbuntuRegular", 11)

local streamedOut = {}
local voicePlayers = {}

addEventHandler("onClientRender", root, function()
    for _, player in ipairs(getElementsByType("player")) do
        if voicePlayers[player] then
			local voiceChannel = player:getData("voiceChannel")
            local vecSoundPos = player.position
            local vecCamPos = Camera.position
        
            local fMaxVol = 3
			local fMinDistance = 5
			local fMaxDistance = 25
			
            local fVehicle = player.vehicle
            local skipSight = false
			
			if voiceChannel == 2 then
				fMinDistance = 0
				fMaxDistance = 0
				skipSight = true
			end
			
            local fDistance = (vecSoundPos - vecCamPos).length
            
            local fPanSharpness = 1.0
            if (fMinDistance ~= fMinDistance * 2) then
                fPanSharpness = math.max(0, math.min(1, (fDistance - fMinDistance) / ((fMinDistance * 2) - fMinDistance)))
            end

            local fPanLimit = (0.65 * fPanSharpness + 0.35)

            -- Pan
            local vecLook = Camera.matrix.forward.normalized
            local vecSound = (vecSoundPos - vecCamPos).normalized
            local cross = vecLook:cross(vecSound)
            local fPan = math.max(-fPanLimit, math.min(-cross.z, fPanLimit))

            local fDistDiff = fMaxDistance - fMinDistance

            -- Transform e^-x to suit our sound
            local fVolume
            if (fDistance <= fMinDistance) or voiceChannel == 2 then
                fVolume = fMaxVol
            elseif (fDistance >= fMaxDistance) then
                fVolume = 0.0
            else
                fVolume = math.exp(-(fDistance - fMinDistance) * (5.0 / fDistDiff)) * fMaxVol
            end
            setSoundPan(player, fPan)
            
            if (isLineOfSightClear(localPlayer.position, vecSoundPos, true, true, false, true, false, true, true, localPlayer) or skipSight) or voiceChannel == 2 then
                setSoundVolume(player, fVolume)
                setSoundEffectEnabled(player, "compressor", false)
            else
                local fVolume = fVolume * 5.5
                local fVolume = fVolume < 0.01 and 0 or fVolume
                setSoundVolume(player, fVolume)
                setSoundEffectEnabled(player, "compressor", true)
            end
        else
            if getSoundVolume(player) ~= 0 then
                setSoundVolume(player, 0)
            end
        end
    end

	if getElementData(localPlayer, "loggedin") == 1 then
		local lowerY = 0
		for player in pairs(voicePlayers) do
			local lx, ly, lz = getElementPosition(localPlayer)
			local px, py, pz = getElementPosition(player)
			local distance = getDistanceBetweenPoints3D(lx, ly, lz, px, py, pz)
			local alpha = distance >= 20 and math.max(0, 255 - (distance * 7)) or 255
			
			if distance <= 30 or player:getData("voiceChannel") == 2 then
				local playerName = getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ")"
				local nameExtension = "(" .. math.floor(distance) .. "m)"
				
				if getPlayerMaskState(player) then 
					playerName = "Gizli [>" .. getElementData(player, "dbid") .. "]"
				end
				
				if player:getData("voiceChannel") == 2 then
					nameExtension = "tüm oyuncular için konuşuyor"
					
					if getElementData(player, "hiddenadmin") == 1 then
						playerName = "Gizli Yetkili"
					end
				end
				
				local text = playerName .. " " .. nameExtension
				local r, g, b = getPlayerNametagColor(player)
				
				local w, h = dxGetTextWidth(text, 1, font), 25
				local x, y = screenX - w - 10, screenY - 100 - lowerY
				
				exports.cr_ui:drawFramedText(text, x, y, w, h, tocolor(r, g, b, alpha), 1, font, "left", "top")

				lowerY = lowerY + h
			end
		end
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    triggerServerEvent("voice:broadcastUpdate", localPlayer, getElementsByType("player"))
    for _, player in ipairs(getElementsByType("player")) do
        setSoundVolume(player, 0)
    end
end)

addEventHandler("onClientPlayerJoin", root, function()
    triggerServerEvent("voice:broadcastUpdate", localPlayer, getElementsByType("player"))
    setSoundVolume(source, 0)
end)

addEventHandler("onClientPlayerVoiceStart", root, function()
    if source:getData("loggedin") ~= 1 then cancelEvent() return end
    local distance = getDistanceBetweenPoints3D(localPlayer.position, source.position)
    local voiceChannel = source:getData("voiceChannel")
    if distance < 10 or voiceChannel == 2 then
        voicePlayers[source] = true
    end
end)

addEventHandler("onClientPlayerVoiceStop", root, function()
	voicePlayers[source] = nil
end)

function getPlayerTalking(plr)
	return voicePlayers[plr]
end

addEventHandler("onClientPlayerQuit", root, function()
	voicePlayers[source] = nil
end)

bindKey(".", "down", function()
	if localPlayer:getData("loggedin") ~= 1 then return end
	if authorizedUsers[getElementData(localPlayer, "account:username")] then
		if getElementData(localPlayer, "voiceChannel") == 1 then
			setElementData(localPlayer, "voiceChannel", 2)
		elseif getElementData(localPlayer, "voiceChannel") == 2 then
			setElementData(localPlayer, "voiceChannel", 1)
		else
			setElementData(localPlayer, "voiceChannel", 1)
		end
		
		outputChatBox("[!]#FFFFFF Konuşma kanalı [" .. getElementData(localPlayer, "voiceChannel") .. "] olarak değiştirildi.", 0, 255, 0, true)
	end
end)

function getPlayerMaskState(player)
	local masks = exports["cr_items"]:getMasks()
	for index, value in pairs(masks) do
		if getElementData(player, value[1]) then
			return true
		end
	end
	return false
end

local shuffledStrBinary = {}

local MAX_CUSTOMDATA_NAME_LENGTH = 12

function encode(str)
    if not str then
        return str
    end
    str = tostring(str)

    if shuffledStrBinary[str] then
        return shuffledStrBinary[str]
    end

    local shuffledStr = tostring(hash('sha512', str))

    if #shuffledStr > MAX_CUSTOMDATA_NAME_LENGTH then
        shuffledStr = shuffledStr:sub(1, MAX_CUSTOMDATA_NAME_LENGTH)
    end

    shuffledStrBinary[shuffledStr] = str

    return shuffledStr
end

local asd = encode("market.convertMoney")
outputChatBox(asd)