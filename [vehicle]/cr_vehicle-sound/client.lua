local sound
local lastGear = nil
local lastRPM = nil
local downgrading = false
local downgradingRPM = { 0, 0 }
local downgradingTime = 2000
local downgradingProgress = 0
local start = 0
local worked = 0
local enabled = true

local vehiclesSounds = {
    -- [507] = { engine = "gtr2000.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [487] = { engine = "gtr2000.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [404] = { engine = "ae86.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [458] = { engine = "civic.wav", gear = "gear.wav", blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    [551] = { engine = "E92.wav", gear = "gear.wav", blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    [529] = { engine = "180sx.wav", gear = "gear.wav", blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [490] = { engine = "180sx.wav", gear = "gear.wav", blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
	[540] = { engine = "rx8.wav", gear = "gear.wav", blowoff = "BlowoffCivic.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [412] = { engine = "m5.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [602] = { engine = "m5.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [503] = { engine = "E92.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [436] = { engine = "E92.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [494] = { engine = "gtr34.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [561] = { engine = "gtr35.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [502] = { engine = "gtr35.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [527] = { engine = "gtr35.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
    -- [521] = { engine = "gtr35.wav", gear = "gear.wav", downTime = 2000, coeff = 10000, volume = 0.03 },
}

local carSounds = {}

local coolDown = {}

local lastVehicle

function startSound(vehicle)
    if not isElement(vehicle) then
        return true
    end
    local model = getElementModel(vehicle)
    if vehiclesSounds[model] then
        if not isElement(carSounds[vehicle]) then
            local x, y, z = getElementPosition(vehicle)
            local sound = playSound3D("sounds/" .. vehiclesSounds[model].engine, x, y, z, true)
            attachElements(sound, vehicle)
            local rpm = getVehicleRPM(vehicle)
            setElementData(vehicle, "carsound:lastGear", getVehicleCurrentGear(vehicle), false)
            setElementData(vehicle, "carsound:lastRPM", rpm, false)
            carSounds[vehicle] = sound
            if vehiclesSounds[model].volume then
                setSoundVolume(sound, vehiclesSounds[model].volume)
            end
            setSoundSpeed(sound, rpm / vehiclesSounds[model].coeff)
        end
    else
        if not carSounds[vehicle] then
            carSounds[vehicle] = true
        end
    end
end

addEventHandler("onClientElementStreamIn", root, function()
    if not enabled then
        return true
    end
    if getElementType(source) == "vehicle" then
        if lastVehicle and lastVehicle == source then
            startSound(source)
        end
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if not enabled then
        return true
    end
    if getElementType(source) == "vehicle" then
        stopVehicleSound(source)
    end
end)

function stopVehicleSound(vehicle)
    local sound = carSounds[vehicle]
    if isElement(sound) then
        destroyElement(sound)
    end
    carSounds[vehicle] = nil
    if isElement(vehicle) then
        local downgradingTimers = getElementData(source, "carsound:downgradingTimers") or {}
        if isTimer(downgradingTimers[1]) then
            killTimer(downgradingTimers[1])
        end
        if isTimer(downgradingTimers[2]) then
            killTimer(downgradingTimers[2])
        end
    end
end

addEventHandler("onClientPlayerVehicleEnter", localPlayer, function(vehicle)
    if not lastVehicle then
        startSound(vehicle)
        lastVehicle = vehicle
        return true
    end
    if lastVehicle and lastVehicle ~= vehicle then
        stopVehicleSound(lastVehicle)
        lastVehicle = vehicle
        startSound(vehicle)
    end
end)

addEventHandler("onClientElementDestroy", root, function()
    if getElementType(source) == "vehicle" then
        local sound = carSounds[source]
        if isElement(sound) then
            destroyElement(sound)
        end
        carSounds[source] = nil
        local downgradingTimers = getElementData(source, "carsound:downgradingTimers") or {}
        if isTimer(downgradingTimers[1]) then
            killTimer(downgradingTimers[1])
        end
        if isTimer(downgradingTimers[2]) then
            killTimer(downgradingTimers[2])
        end
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function() turnSoundsOnOff(true) end)

function turnSoundsOnOff(state)
    local vehicles = getElementsWithinRange(localPlayer.position, 20, "vehicle", localPlayer.interior, localPlayer.dimension)
    if state then
        enabled = true
        addEventHandler("onClientRender", root, checkVehiclesRPM)
        for i, vehicle in ipairs(vehicles) do
            startSound(vehicle)
        end
    else
        enabled = false
        removeEventHandler("onClientRender", root, checkVehiclesRPM)
        for i, vehicle in ipairs(vehicles) do
            local sound = carSounds[vehicle]
            if isElement(sound) then
                destroyElement(sound)
            end
            carSounds[vehicle] = nil
            local downgradingTimers = getElementData(vehicle, "carsound:downgradingTimers") or {}
            if isTimer(downgradingTimers[1]) then
                killTimer(downgradingTimers[1])
            end
            if isTimer(downgradingTimers[2]) then
                killTimer(downgradingTimers[2])
            end
        end
    end
end

function checkVehiclesRPM()
    local x, y, z = getElementPosition(localPlayer)
    for vehicle, sound in pairs (carSounds) do
        if not isElement(vehicle) then
            stopVehicleSound(vehicle)
            return true
        end
		
        local tx, ty, tz = getElementPosition(vehicle)
        if getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) < 40 then
            local rpm = getVehicleRPM(vehicle)
            if not getVehicleEngineState(vehicle) then
                if isElement(sound) and not isSoundPaused(sound) then
                    setSoundPaused(sound, true)
                end
            else
                if rpm == 0 then
                    rpm = math.random(300, 600)
                end
                if isElement(sound) and isSoundPaused(sound) then
                    setSoundPaused(sound, false)
                end
                local model = getElementModel(vehicle)
                local lastGear = getElementData(vehicle, "carsound:lastGear") or 1
                local lastRPM = getElementData(vehicle, "carsound:lastRPM") or 0
                local curGear = getVehicleCurrentGear(vehicle)
                if lastGear > curGear and not isTimer(coolDown[vehicle]) then
                    local isDonateVehicle, exhaust = exports.cr_market:isPrivateVehicle(model), vehicle:getData("vehicle.exhaust")
                    if isDonateVehicle then
                        playGearSound(vehicle)
                    end
                    if exhaust then
                        createBackFire(vehicle, getVehicleModelDummyPosition(model, "exhaust"))
                    end
                end
                local downgradingTimers = getElementData(vehicle, "carsound:downgradingTimers") or {}
                if lastGear > curGear and not downgrading and vehiclesSounds[model] then
                    if isTimer(downgradingTimers[1]) then
                        killTimer(downgradingTimers[1])
                    end
                    if isTimer(downgradingTimers[2]) then
                        killTimer(downgradingTimers[2])
                    end
                    downgrading = true
                    downgradingProgress = 0
                    worked = 0
                    start = getTickCount()
                    downgradingRPM = { lastRPM, 500 }
                    downgradingTimers[1] = setTimer(function()
                        downgradingProgress = downgradingProgress + (1 / (vehiclesSounds[model].downTime / 50))
                        worked = worked + 1
                    end, 50, vehiclesSounds[model].downTime / 50)
                    setElementData(vehicle, "carsound:downgradingTimers", downgradingTimers, false)
                else
                    if vehiclesSounds[model] then
                        if vehiclesSounds[model].blowoff and curGear > lastGear then
                            playBlowoffSound(vehicle)
                        end
                        if downgrading then
                            if (lastRPM < rpm and (lastGear <= curGear)) or lastGear < curGear then
                                if isTimer(downgradingTimers[1]) then
                                    killTimer(downgradingTimers[1])
                                end
                                if isTimer(downgradingTimers[2]) then
                                    killTimer(downgradingTimers[2])
                                end
                                downgrading = false
                            end
                            local temprpm = interpolateBetween(downgradingRPM[1], 0, 0, downgradingRPM[2], 0, 0, downgradingProgress, "Linear")
                            setSoundSpeed(sound, temprpm / vehiclesSounds[model].coeff)
                        else
                            setSoundSpeed(sound, rpm / vehiclesSounds[model].coeff)
                        end
                    end
                    setElementData(vehicle, "carsound:lastGear", curGear, false)
                    setElementData(vehicle, "carsound:lastRPM", rpm, false)
                end
            end
        end
    end
end

function getVectors(x, y, z, x2, y2, z2)
	return x - x2, y - y2, z-z2;
end

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix (element)
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z
end

function createBackFire(theVeh, scx, scy, scz)
	local fireChords={}
	local dist = 0.04
	for i = 1, 6 do
		local x, y, z = getPositionFromElementOffset(theVeh,scx,scy-dist,scz)
		fireChords[i]= {pX = x, pY = y, pZ = z}
		dist = dist + 0.2
	end
	local x,y,z = getPositionFromElementOffset(theVeh,scx,scy,scz)
	local x2,y2,z2 = getPositionFromElementOffset(theVeh,scx,0,scz)
	local v1, v2, v3 = getVectors(x,y,z, x2,y2,z2)
	for i, val in ipairs(fireChords) do
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2,v3, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1+1.5,v2,v3, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1-1.5,v2,v3, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2,v3+0.8, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2,v3-0.8, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+1,v3+0.8, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+2,v3+0.8, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2+10,v3+0.8, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-10,v3+0.8, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-2,v3+0.8, true)
		fxAddGunshot(val.pX,val.pY,val.pZ, v1,v2-1,v3+0.8, true)
	end
	local s = playSound3D("sounds/backfire2.wav", x, y, z, false)
    setSoundMaxDistance(s, 80)	
	setSoundVolume(s, 0.5)

    coolDown[theVeh] = setTimer(function() end, 800, 1)
end

function playBlowoffSound(vehicle)
    if isElement(vehicle) then
        local x, y, z = getElementPosition(vehicle)
        local px, py, pz = getElementPosition(localPlayer)
        if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 10 then
            local model = getElementModel(vehicle)
            local blowoffSound = playSound3D("sounds/" .. vehiclesSounds[model].blowoff, x, y, z, false)
            attachElements(blowoffSound, vehicle)
        end
    end
end

function playGearSound(vehicle)
    if isElement(vehicle) then
        local x, y, z = getElementPosition(vehicle)
        local px, py, pz = getElementPosition(localPlayer)
        if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 10 then
            local model = getElementModel(vehicle)
            local gearSound = playSound3D('sounds/gear.wav', x, y, z, false)
            setSoundVolume(gearSound, 2)
            attachElements(gearSound, vehicle)

            coolDown[vehicle] = setTimer(function() end, 800, 1)
        end
    end
end

function getVehicleRPM(vehicle)
    if isElement(vehicle) then
        local vehicleRPM = getElementData(vehicle, "rpm") or 0
        if (isVehicleOnGround(vehicle)) then
            if (getVehicleEngineState(vehicle) == true) then
                if (getVehicleCurrentGear(vehicle) > 0) then
                    vehicleRPM = math.floor(((getVehicleSpeed(vehicle) / getVehicleCurrentGear(vehicle)) * 180) + 0.5)

                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9800) then
                        vehicleRPM = 9800
                    end
                else
                    vehicleRPM = math.floor(((getVehicleSpeed(vehicle) / 1) * 180) + 0.5)

                    if (vehicleRPM < 650) then
                        vehicleRPM = math.random(650, 750)
                    elseif (vehicleRPM >= 9800) then
                        vehicleRPM = 9800
                    end
                end
            else
                vehicleRPM = 0
            end
        else
            if (getVehicleEngineState(vehicle) == true) then
                vehicleRPM = vehicleRPM - 150

                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = 9800
                end
            else
                vehicleRPM = 0
            end
        end
        setElementData(vehicle, "rpm", vehicleRPM, false)
        return tonumber(vehicleRPM)
    else
        return 0
    end
end

function getVehicleSpeed(vehicle)
    if isElement(vehicle) then
        local vx, vy, vz = getElementVelocity(vehicle)

        if (vx) and (vy) and (vz) then
            return math.sqrt(vx ^ 2 + vy ^ 2 + vz ^ 2) * 180 -- km/h
        else
            return 0
        end
    else
        return 0
    end
end

addEventHandler("onClientResourceStop", resourceRoot, function(stoppedRes)
    for i, v in ipairs(getElementsByType("sound", resourceRoot)) do
        destroyElement(v)
    end
end)