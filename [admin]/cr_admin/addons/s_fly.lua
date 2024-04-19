function fly(thePlayer, commandName)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) then
		if getElementData(thePlayer, "duty_admin") == 1 or getElementData(thePlayer, "duty_supporter") == 1 then
			triggerClientEvent(thePlayer, "onClientFlyToggle", thePlayer)
		else
			outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için görevde olmalısınız.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
		end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("fly", fly, false, false)