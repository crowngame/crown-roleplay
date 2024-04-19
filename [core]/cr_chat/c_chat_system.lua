function playRadioSound()
	playSoundFrontEnd(47)
	setTimer(playSoundFrontEnd, 700, 1, 48)
	setTimer(playSoundFrontEnd, 800, 1, 48)
end
addEvent("playRadioSound", true)
addEventHandler("playRadioSound", root, playRadioSound)

function playCustomChatSound(sound)
	playSound("sound/" .. tostring(sound), false)
end
addEvent("playCustomChatSound", true)
addEventHandler("playCustomChatSound", root, playCustomChatSound)

function playHQSound()
	playSoundFrontEnd(1)
	setTimer(playSoundFrontEnd, 300, 1, 1)
end
addEvent("playHQSound", true)
addEventHandler("playHQSound", root, playHQSound)

--PM SOUND FX / Farid
function playPmSound(message)
	local pmsound = playSound("sound/pmSoundFX.mp3",false)
	setSoundVolume(pmsound, 0.9)
	if message then
		createTrayNotification(message)
	end
end
addEvent("pmClient",true)
addEventHandler("pmClient", root, playPmSound)

function clearChat()
	clearChatBox()
end
addCommandHandler("clearchat", clearChat, false, false)
addCommandHandler("clearchatbox", clearChat, false, false)
addCommandHandler("cc", clearChat, false, false)

bindKey("b", "down", "chatbox", "LocalOOC")
bindKey("u" , "down" , "chatbox", "quickreply")
bindKey("y", "down", "chatbox", "Birlik")