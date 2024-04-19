local specialWeapons = {
    -- [weapon_id] = { true, gereken_level (default değeri 1) }
    [30] = { true, 2 },
    [31] = { true, 4 }
}

local allowedFactions = {
    -- [factionid] true
    [1] = true,
    [3] = true,
}

addEventHandler("onClientPlayerWeaponSwitch", localPlayer, function(preSlot)
	local currentWeaponID = getPedWeapon(localPlayer)
    if specialWeapons[currentWeaponID] then
        if specialWeapons[currentWeaponID][1] then
            local myVipLevel = tonumber(getElementData(localPlayer, "vip")) or 0
            local myFaction = tonumber(getElementData(localPlayer, "faction")) or 0
            local requiredLevel = specialWeapons[currentWeaponID][2] or 1
            if not (myVipLevel >= requiredLevel) and not (allowedFactions[myFaction]) then
                cancelEvent()
                local preSlot = localPlayer.weaponSlot == preSlot and 0 or preSlot
                setPedWeaponSlot(localPlayer, preSlot)
                outputChatBox("[!] #FFFFFF" .. getWeaponNameFromID(currentWeaponID) .. " adlı silahı kullanabilmen için VIP [" .. requiredLevel .. "] olmalısın.", 255, 0, 0, true)
				playSoundFrontEnd(4)
            end
        end
    end
end)

addEventHandler("onClientPlayerWeaponFire", localPlayer, function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    local currentWeaponID = weapon
    if specialWeapons[currentWeaponID] then
        if specialWeapons[currentWeaponID][1] then
            local myVipLevel = tonumber(getElementData(localPlayer, "vip")) or 0
			local myFaction = tonumber(getElementData(localPlayer, "faction")) or 0
            local requiredLevel = specialWeapons[currentWeaponID][2] or 1
            if not (myVipLevel >= requiredLevel) and not (allowedFactions[myFaction]) then
                cancelEvent()
                setPedWeaponSlot(localPlayer, 0)
                outputChatBox("[!] #FFFFFF" .. getWeaponNameFromID(currentWeaponID) .. " adlı silahı kullanabilmen için VIP [" .. requiredLevel .. "] olmalısın.", 255, 0, 0, true)
				playSoundFrontEnd(4)
            end
        end
    end
end)