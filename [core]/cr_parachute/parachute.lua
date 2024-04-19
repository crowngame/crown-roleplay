root = getRootElement ()
--chutekill = {}

local function onResourceStart (resource)
  players = getElementsByType ("player")
  for k, v in pairs (players) do
    setElementData (v, "parachuting", false)
  end
end
addEventHandler ("onResourceStart", getResourceRootElement (getThisResource ()), onResourceStart)

function requestAddParachute ()
  	local fallingElement = source
  	local vehicle = getPedOccupiedVehicle (source)
  	if (vehicle) then fallingElement = vehicle end
  	takeWeapon (source, 46)
  	rz = getPedRotation(source)
	--outputDebugString("ped rotations: " .. tostring(rx) .. "," .. tostring(ry) .. "," .. tostring(rz))
  	setPedRotation(source,rz)
	oldchute = getElementData (source, "chute")
	if oldchute then
		destroyElement(oldchute)
	end
  	local chute = createObject (3131, 0, 0, 0)
  	attachElements (chute, fallingElement, 0, 0, -0.2,0,0,-15)
	--table.insert(chutekill,chute)
	--chute2 = createObject (1222, 0, 0, 0)
	--attachElements (chute2,chute, 0, 0, -1)
 	setElementData (source, "parachuting", true)
  	setElementData (source, "chute", chute)
	triggerClientEvent ("ClientLevelOff",getRootElement(), source)
end
addEvent ("requestAddParachute", true)
addEventHandler ("requestAddParachute", root, requestAddParachute)

function requestRemoveParachute ()
	chute = getElementData (source, "chute")
	if (chute) then 
		destroyElement (chute)
		--for timerKey, chuteValue in ipairs(chutekill) do
       		--	-- kill the timer
		--	if isElement(chuteValue) then
     		--		destroyElement (chuteValue)
		--	end
		--end
		--chutekill = nil
		--chutekill = {} 
	end
 	setElementData (source, "parachuting", false)
  	setElementData (source, "chute", false)
	giveWeapon (source, 46, 1, true)
end
addEvent ("requestRemoveParachute", true)
addEventHandler ("requestRemoveParachute", root, requestRemoveParachute)

function serverRotSync(chuter,rot)
	chute = getElementData (chuter, "chute")
	setObjectRotation (chute,0,0,rot)
	--outputDebugString("sync " .. tostring(rot) .. " " .. tostring(chuter) .. " " ..  tostring(chute) .. "")
end
addEvent("RotSync",true)
addEventHandler("RotSync", getRootElement(), serverRotSync)
