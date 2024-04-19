local enabledUsers = {
	["Farid"] = true,
}

local commandList = {
    ["refresh"] = true,
    ["refreshall"] = true,
    ["restart"] = true,
    ["start"] = true,
    ["stop"] = true,
    ["stopall"] = true,
    ["aclrequest"] = true,
    ["reloadacl"] = true,
    ["aexec"] = true,
    ["addaccount"] = true,
    ["chgpass"] = true,
    ["delaccount"] = true,
    ["reloadbans"] = true,
    ["authserial"] = true,
    ["loadmodule"] = true,
    ["sfakelag"] = true,
    ["shutdown"] = true,
    ["sver"] = true,
    ["whois"] = true,
    ["ver"] = true,
    ["chgmypass"] = true,
    ["debugscript"] = true,
    ["login"] = true,
    ["logout"] = true,
    ["msg"] = true,
    ["nick"] = true,
}

addEventHandler("onPlayerCommand", root, function(commandName)
    if (commandList[commandName]) and (not enabledUsers[getElementData(source, "account:username")]) then
		cancelEvent()
    end
end)

addEventHandler("onPlayerCommand", root, function()
    if (getElementData(source, "loggedin") ~= 1) then
        cancelEvent()
    end
end)

function restartSingleResource(thePlayer, commandName, resourceName)
    if exports.cr_integration:isPlayerManagement(thePlayer) then
        if resourceName then
            local theResource = getResourceFromName(tostring(resourceName))
            if theResource then
                if getResourceState(theResource) == "running" then
					restartResource(theResource)
                    exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili '" .. resourceName .. "' isimli scripti yeniden başlattı.")
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script yeniden başlatıldı.", thePlayer, 0, 255, 0, true)
                elseif getResourceState(theResource) == "loaded" then
                    startResource(theResource, true)
                    exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili '" .. resourceName .. "' isimli scripti yeniden başlattı.")
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script yeniden başlatıldı.", thePlayer, 0, 255, 0, true)
                elseif getResourceState(theResource) == "failed to load" then
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script yüklenemedi. (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                else
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script başlatılamadı. (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            else
                outputChatBox("[!]#FFFFFF Böyle bir script bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Script İsmi]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("restartres", restartSingleResource)

function stopSingleResource(thePlayer, commandName, resourceName)
    if exports.cr_integration:isPlayerManagement(thePlayer) then
        if resourceName then
            local theResource = getResourceFromName(tostring(resourceName))
            if theResource then
                if stopResource(theResource) then
                    exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili '" .. resourceName .. "' isimli scripti durdurdu.")
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script durduruldu.", thePlayer, 0, 255, 0, true)
                else
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script durdurulamadı.", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            else
                outputChatBox("[!]#FFFFFF Böyle bir script bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Script İsmi]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("stopres", stopSingleResource)

function startSingleResource(thePlayer, commandName, resourceName)
    if exports.cr_integration:isPlayerManagement(thePlayer) then
        if resourceName then
            local theResource = getResourceFromName(tostring(resourceName))
            if theResource then
                if getResourceState(theResource) == "running" then
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli zaten başlatıldı.", thePlayer, 0, 255, 0, true)
                elseif getResourceState(theResource) == "loaded" then
                    startResource(theResource, true)
                    exports.cr_global:sendMessageToAdmins("[ADM] " .. exports.cr_global:getPlayerFullAdminTitle(thePlayer) .. " isimli yetkili '" .. resourceName .. "' isimli scripti başlattı.")
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script başlatıldı.", thePlayer, 0, 255, 0, true)
                elseif getResourceState(theResource) == "failed to load" then
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script yüklenemedi. (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                else
                    outputChatBox("[!]#FFFFFF '" .. resourceName .. "' isimli script başlatılamadı. (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0, true)
                    playSoundFrontEnd(thePlayer, 4)
                end
            else
                outputChatBox("[!]#FFFFFF Böyle bir script bulunamadı.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
            end
        else
            outputChatBox("KULLANIM: /" .. commandName .. " [Script İsmi]", thePlayer, 255, 194, 14)
        end
    else
        outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
    end
end
addCommandHandler("startres", startSingleResource)