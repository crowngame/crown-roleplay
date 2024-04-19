local chatting = false
local chatters = { }

function checkForChat()
	if not (getElementAlpha(getLocalPlayer()) == 0) then
		if (isChatBoxInputActive() and not chatting) then
			chatting = true
			setElementData(localPlayer, "writing", true)
		elseif (not isChatBoxInputActive() and chatting) then
			chatting = false
			setElementData(localPlayer, "writing", false)
		end
	end
end
setTimer(checkForChat, 200, 0)