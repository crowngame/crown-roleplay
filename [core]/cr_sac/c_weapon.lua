local specialWeapons = {
    --[weapon_id] = {true, gereken_level (default değeri 1) }
    [34] = {true, 5},
}

function antiHackWeapon(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    local currentWeaponID = tonumber(getPedWeapon(localPlayer))
    
	if currentWeaponID <= 0 then
        return
    end
	
    if getElementData(localPlayer, "dead") == 1 then
        cancelEvent()
        return
    end
	
    if getElementData(localPlayer, "restrain") == 1 then
        cancelEvent()
        return
    end

    if getWeaponNameFromID(currentWeaponID) == "Vibrator" then
        return
    end

    if getWeaponNameFromID(currentWeaponID) == "Poolstick" then
        return
    end

    if exports.cr_network:getNetworkStatus() then
        outputChatBox("[!]#FFFFFF Silah ile ateş edebilmek için önce internetini düzelt.", 255, 0, 0, true)
        cancelEvent()
        return false
    end

    local hasWeapon = false
    for index, value in ipairs(exports.cr_items:getItems(localPlayer)) do
        if value[1] == 115 and value[2] then
            local weaponData = split(tostring(value[2]), ":")
            if tonumber(weaponData[1]) == currentWeaponID then
                hasWeapon = tonumber(weaponData[1])
            end
        end
    end

    if not hasWeapon then
        cancelEvent()
        outputChatBox("[!]#FFFFFF " .. getWeaponNameFromID(currentWeaponID) .. " marka silah envanterinde yok, kullanamazsın.", 255, 0, 0, true)
    else
        if specialWeapons[hasWeapon] then
            local myVipLevel = tonumber(getElementData(localPlayer, "vip")) or 0
            local requiredLevel = specialWeapons[hasWeapon][2] or 1

            if not (myVipLevel >= requiredLevel) then
                setPedWeaponSlot(localPlayer, 0)
                cancelEvent()
                outputChatBox("[!]#FFFFFF " .. getWeaponNameFromID(hasWeapon) .. " isimli silahı kullanabilmen için VIP [" .. requiredLevel .. "] olmalısın.", 255, 0, 0, true)
            end
        end
    end
end
addEventHandler("onClientWeaponFire", localPlayer, antiHackWeapon)
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, antiHackWeapon)
addEventHandler("onClientPlayerWeaponFire", localPlayer, antiHackWeapon)