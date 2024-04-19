function playVehicleSound(soundPath, theVehicle)
    local x, y, z = getElementPosition(theVehicle)
    local sound = playSound3D(soundPath, x, y, z, false)
    if sound then
        attachElements(sound, theVehicle)
        setSoundVolume(sound, 0.5)
        setSoundMaxDistance(sound, 90)
        setElementDimension(sound, getElementDimension(theVehicle))
    end
end
addEvent("playVehicleSound", true)
addEventHandler("playVehicleSound", root, playVehicleSound)

addEvent("vehicleHorn", true)
addEventHandler("vehicleHorn", root, function (state, theVehicle)
    if isElement(TrainSound) and (state) then
    	if isTimer(decrease) then
    		killTimer(decrease)
    	end
    	destroyElement(TrainSound)
    end

    if not (state) then
    	decrease = setTimer(function() 
    		local time, final = getTimerDetails(decrease)
    		if isElement(TrainSound) then
    			if final ~= 1 then
    				local volume = getSoundVolume(TrainSound)
    				setSoundVolume(TrainSound, volume - 0.5)
    			else
    				destroyElement(TrainSound)
    			end
    		end
    	end, 300, 10)
    end
	
    if (state) then
        local x, y, z = getElementPosition(theVehicle)
        TrainSound = playSound3D("trainHorn.mp3", x, y, z)
        setSoundVolume(TrainSound, 5.0)
        setSoundMaxDistance(TrainSound, 190)
        attachElements(TrainSound, theVehicle)
    end
end)