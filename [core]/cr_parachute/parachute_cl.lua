root = getRootElement ()
localPlayer = getLocalPlayer ()
fallspeed = -0.1
slowfallspeed = -1.5
haltspeed = 0.007
movespeed = 0.003
lastspeed = 0
synccount = 1

local function onResourceStart (resource)
  bindKey ("fire", "down", onFire)
end
addEventHandler ("onClientResourceStart", getResourceRootElement (), onResourceStart)

function onFire (key, keyState)
  if (getPedWeapon (localPlayer) == 46) then
    if (isPedDoingTask (localPlayer, "TASK_SIMPLE_IN_AIR")) then
	--setPedAnimation (localPlayer, "PARACHUTE", "PARA_float", -1, false, true, false)
      triggerServerEvent ("requestAddParachute", localPlayer)
	x,y,z = getElementPosition(localPlayer)
	opensound = playSound3D("parachuteopen.mp3",x,y,z,false)
	setSoundMaxDistance(opensound, 25)
	setSoundMinDistance(opensound, 10)
    end
  end
end

function onRender ()
  	if (getElementData (localPlayer, "parachuting")) then
	   	if (isPedDoingTask (localPlayer, "TASK_SIMPLE_IN_AIR")) or (isPedDoingTask (localPlayer, "TASK_SIMPLE_NAMED_ANIM")) then
	      	local fallingElement = localPlayer
	     	vehicle = getPedOccupiedVehicle (localPlayer)
	      	if (vehicle) then fallingElement = vehicle end
	      	px, py, pz, lx, ly, lz = getCameraMatrix ()
			local vx = math.deg (math.atan2 (lz - pz, getDistanceBetweenPoints2D (lx, ly, px, py))*-1)
			local camRotZ = (360 - math.deg (math.atan2 ((lx - px), (ly - py)))*-1) % 360
	      	velX, velY, velZ = getElementVelocity (fallingElement)    
	      	local currentfallspeed = fallspeed
	      	if (getPedControlState ("backwards")) then currentfallspeed = slowfallspeed end
	      	if (getPedControlState ("forwards") or getPedControlState ("backwards")) then
	        	local dirX = math.sin (math.rad (camRotZ))
	        	local dirY = math.cos (math.rad (camRotZ))
	        	if (dirX > 0 and velX < 1) then velX = velX + dirX * movespeed
	        	elseif (dirX < 0 and velX > -1) then velX = velX + dirX * movespeed end
	        	if (dirY > 0 and velY < 1) then velY = velY + dirY * movespeed
	        	elseif (dirY < 0 and velY > -1) then velY = velY + dirY * movespeed end
	      	end
			setElementRotation (fallingElement,0,0,camRotZ-15)
			newRot = camRotZ-15
			synccount = synccount + 1
			if synccount == 50 then
				triggerServerEvent ("RotSync",getRootElement(), localPlayer,newRot)
				synccount = 1
			end
		   	if (velZ < currentfallspeed) then
		       	if (lastspeed < 0) then
		       		if (lastspeed > currentfallspeed or lastspeed == currentfallspeed) then
		           		velZ = currentfallspeed
		       		else
		           		velZ = lastspeed + haltspeed
		       		end
		       	end        
		   	end
	      	lastspeed = velZ
	      	setElementVelocity (fallingElement, velX, velY, velZ)
	   	else
	     	triggerServerEvent ("requestRemoveParachute", localPlayer)
	   	end
  	end
end
addEventHandler ("onClientRender", root, onRender)
	
function LevelOff(chuter)
	rx,ry,rz = getElementRotation (chuter)
	setElementRotation (chuter,0,0,rz)
end
addEvent("ClientLevelOff",true)
addEventHandler("ClientLevelOff", getRootElement(), LevelOff)

