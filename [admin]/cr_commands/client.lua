local commands = {
    ["ban"] = true,
    ["oban"] = true,
    ["cban"] = true,
    ["ocban"] = true,
    ["kick"] = true,
    ["jail"] = true,
    ["sjail"] = true,
    ["osjail"] = true,
    ["reconnect"] = true,
    ["freconnect"] = true,
    ["quit"] = true,
    ["pm"] = true,
    ["ooc"] = true,
    ["b"] = true,
    ["vehicle_next_weapon"] = true,
    ["vehicle_previous_weapon"] = true,
    ["aracgetir"] = true,
}

local keyList = {}

function updateKeyList()
    keyList = {}
    for commandName in pairs(commands) do
        local keys = getBoundKeys(commandName)
        if keys then
            for keyName, state in pairs(keys) do
                keyList[keyName] = commandName
            end
        end
    end
    setTimer(updateKeyList, 1000, 1)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    updateKeyList()
end)

addEventHandler("onClientKey", root, function(button, press)
    if ((not isChatBoxInputActive()) and (not isMTAWindowActive()) and (not isConsoleActive())) then
        if keyList[button] then
            if press then
				outputChatBox("[!]#FFFFFF [" .. tostring(button) .. "] butonuna eklediğiniz [" .. tostring(keyList[button]) .. "] bindini kaldırınız.", 255, 0, 0, true)
				playSoundFrontEnd(4)
				cancelEvent()
				return
            end
        end
    end
end)

function nahVer()
    local screenWidth, screenHeight = guiGetScreenSize()
    local nah = guiCreateStaticImage((screenWidth / 2) - (750/2), (screenHeight / 2) - (600/2), 750, 600, "images/nah.png", false)
    setTimer(destroyElement, 5000, 1, nah)
    local nahVer = playSound("sounds/saplak.mp3")   
    setSoundVolume(nahVer, 1)
end
addCommandHandler("adminol", nahVer)
addEvent("nahVer", true)
addEventHandler("nahVer", root, nahVer)