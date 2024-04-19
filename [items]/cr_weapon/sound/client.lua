setWorldSoundEnabled(42, false)
setWorldSoundEnabled(5, false)
setWorldSoundEnabled(5, 87, true)
setWorldSoundEnabled(5, 58, true)
setWorldSoundEnabled(5, 37, true)

local function playGunfireSound(weaponID)
    local muzzleX, muzzleY, muzzleZ = getPedWeaponMuzzlePosition(source)
    local dimension = getElementDimension(source)

    if weaponID == 22 then
        local sound = playSound3D("sounds/weap/colt45.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 95)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 23 then
        local sound = playSound3D("sounds/weap/silenced.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 15)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 24 then
        local sound = nil
        local mode = getElementData(source, "deaglemode")
        if mode == 0 then
            sound = playSound3D("sounds/weap/tazer.wav", muzzleX, muzzleY, muzzleZ, false)
        else
            sound = playSound3D("sounds/weap/deagle.wav", muzzleX, muzzleY, muzzleZ, false)
            setSoundVolume(sound, 0.3)
        end
        setSoundMaxDistance(sound, 120)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 25 then
        local sound = nil
        local mode = getElementData(source, "shotgunmode")
        if mode == 0 then
            sound = playSound3D("sounds/weap/beanbag.wav", muzzleX, muzzleY, muzzleZ, false)
        else
            sound = playSound3D("sounds/weap/shotgun.wav", muzzleX, muzzleY, muzzleZ, false)
            setSoundVolume(sound, 0.3)
        end
        setSoundMaxDistance(sound, 120)
        setElementDimension(sound, dimension)
    elseif weaponID == 26 then
        local sound = playSound3D("sounds/weap/sawed-off.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 95)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 27 then
        local sound = playSound3D("sounds/weap/combat-shotgun.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 100)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 28 then
        local sound = playSound3D("sounds/weap/uzi.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 105)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 32 then
        local sound = playSound3D("sounds/weap/tec9.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 105)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 29 then
        local sound = playSound3D("sounds/weap/mp5.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 120)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 30 then
        local sound = playSound3D("sounds/weap/ak47.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 180)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 31 then
        local sound = playSound3D("sounds/weap/m4.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 170)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.4)
    elseif weaponID == 33 then
        local sound = playSound3D("sounds/weap/rifle.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 175)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    elseif weaponID == 34 then
        local sound = playSound3D("sounds/weap/sniper.wav", muzzleX, muzzleY, muzzleZ, false)
        setSoundMaxDistance(sound, 325)
        setElementDimension(sound, dimension)
        setSoundVolume(sound, 0.3)
    end
end
addEventHandler("onClientPlayerWeaponFire", root, playGunfireSound)