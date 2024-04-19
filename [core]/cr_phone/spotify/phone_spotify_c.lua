local spotifyGUIs = {}
function toggleSpotify(state)
	if state then
		isSpotifyShowing = true
		createSpotifyMenu()
		guiSetInputEnabled(true)
		addEventHandler("onClientGUIClick", root, clickBankFunctions)
	else
		isSpotifyShowing = false
		guiSetInputEnabled(false)
		for k,v in ipairs(spotifyGUIs) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		removeEventHandler("onClientGUIClick", root, clickBankFunctions)
	end
end

function createSpotifyMenu()
	spotifyGUIs[1] = guiCreateButton(35,420,100,33,"",false,wPhoneMenu) -- oynat
	guiSetAlpha(spotifyGUIs[1],0)

	spotifyGUIs[2] = guiCreateButton(140,420,100,33,"",false,wPhoneMenu) -- durdur
	guiSetAlpha(spotifyGUIs[2],0)
end

addEventHandler("onClientGUIClick", getRootElement (), function(btn)
if source == spotifyGUIs[1] then
if getElementData(localPlayer,"sound:true",true) then return end
sound = playSound("spotify/spotifyList/" .. math.random(1,11) .. ".mp3")
setElementData(localPlayer,"sound:true",true)
setSoundVolume(sound, 1)
elseif source == spotifyGUIs[2] then
stopSound(sound)
setElementData(localPlayer,"sound:true",false)
end
end)