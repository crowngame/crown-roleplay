function warnAdmins(thePlayer, commandName, ...)
	if getElementData(thePlayer, "loggedin") == 0 then return end
	if exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
        local message = table.concat({...}, " ")
        local playerName = getElementData(thePlayer, "account:username")
        if (...) then
            for i, v in ipairs(getElementsByType("player")) do 
                if exports.cr_integration:isPlayerTrialAdmin(v) or exports.cr_integration:isPlayerHelper(v) then
                    outputChatBox(" ", v)
                    outputChatBox("[ÖNEMLİ] " .. playerName .. ": " .. message, v, 255, 0, 0, true)
                    outputChatBox(" ", v)
                    triggerClientEvent(v, "warn:sound", v)
                end
            end
        else 
            outputChatBox("KULLANIM: /" .. commandName .. " [Mesaj]", thePlayer, 255, 194, 14)
        end
	else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end
addCommandHandler("warn", warnAdmins, false, false)