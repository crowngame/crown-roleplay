local sound = nil

addEvent("warn:sound", true)
addEventHandler("warn:sound", root, function()
    if sound and isElement(sound) then
        stopSound(sound)
    end

    sound = playSound("addons/warn.mp3", false)
    setSoundVolume(sound, 1.0)
end)