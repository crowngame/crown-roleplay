function debugScript(thePlayer, commandName, state)
	--if exports.cr_integration:isPlayerDeveloper(thePlayer) then
		state = tonumber(state)
		if state then
			setPlayerScriptDebugLevel(thePlayer, state)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [1-3]", thePlayer, 255, 194, 14)
		end
	--else
		--outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
	--end
end
addCommandHandler("debug", debugScript, false, false)