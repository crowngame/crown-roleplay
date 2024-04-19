--Farid
mysql = exports.cr_mysql
gates = { }

function newGate(thePlayer, commandName, itemID)
	if exports.cr_integration:isPlayerGameAdmin(thePlayer) then
		if not itemID or not tonumber(itemID) then
			outputChatBox("KULLANIM: /" .. commandName .. " <itemID>", thePlayer)
			return
		end
		local playerX, playerY, playerZ = getElementPosition(thePlayer)
		
		local tempObject = createObject(itemID, playerX, playerY, playerZ, 0, 0, 0)
		if tempObject then
			local tempTable = { }
			tempTable["startPosition"] = { playerX, playerY, playerZ, 0, 0, 0 }
			tempTable["endPosition"] = { playerX, playerY, playerZ, 0, 0, 0 }
			tempTable["state"] = false -- false is closed, true is opened
			tempTable["timer"] = false
			tempTable["type"] = 1
			tempTable["autocloseTime"] = -1
			tempTable["movementTime"] = 3500
			tempTable["gateSecurityParameters"] = ""
			setElementData(tempObject, "gate:parameters", tempTable, false)
			setElementData(tempObject, "gate:id", -1, false)
			setElementData(tempObject, "gate:edit", true, false)
			table.insert(gates, tempObject)
			triggerClientEvent(thePlayer, "gates:startedit", thePlayer, tempObject, tempTable, -1)
		else
			outputChatBox("Failed to spawn object", thePlayer, 255, 0,0)
		end
	end
end
addCommandHandler("newgate", newGate)

function cancelGateEdit()
	if source then
		if isElement(source) then
			local dbid = getElementData(source, "gate:id")
			if dbid and dbid == -1 then
				destroyElement(source)
			end
			outputChatBox("Edit cancelled", client, 255, 0,0)
		end
	end
end
addEvent("gates:canceledit", true)
addEventHandler("gates:canceledit", getRootElement(), cancelGateEdit)

function startGateSystem(res)
	local result = mysql:query("SELECT `id` FROM `gates` ORDER BY `id` ASC")
	if (result) then
		while true do
			row = mysql:fetch_assoc(result)
			if not row then break end

			local co = coroutine.create(loadOneGate)
			coroutine.resume(co, tonumber(row.id), false)
		end
	end
	mysql:free_result(result)
end
addEventHandler("onResourceStart", getResourceRootElement(), startGateSystem)

function loadOneGate(gateID)
	local row = mysql:query_fetch_assoc("SELECT * FROM `gates` WHERE `id`='" .. tostring(gateID) .. "'")
	if row then
		local tempObject = createObject(row["objectID"], row["startX"], row["startY"], row["startZ"], row["startRX"], row["startRY"], row["startRZ"])
		if tempObject then
			local tempTable = { }
			tempTable["startPosition"] = { tonumber(row["startX"]), tonumber(row["startY"]), tonumber(row["startZ"]), tonumber(row["startRX"]), tonumber(row["startRY"]), tonumber(row["startRZ"]) }
			tempTable["endPosition"] = { tonumber(row["endX"]), tonumber(row["endY"]), tonumber(row["endZ"]), tonumber(row["endRX"]), tonumber(row["endRY"]), tonumber(row["endRZ"]) }
			tempTable["state"] = false -- false is closed, true is opened
			tempTable["timer"] = false
			tempTable["type"] = tonumber(row["gateType"])
			tempTable["autocloseTime"] = tonumber(row["autocloseTime"])
			tempTable["movementTime"] = tonumber(row["movementTime"])
			tempTable["gateSecurityParameters"] = row["gateSecurityParameters"]
			setElementData(tempObject, "gate:parameters", tempTable, false)
			setElementData(tempObject, "gate:id", row["id"], true)
			setElementData(tempObject, "gate:edit", false, false)
			setElementData(tempObject, "gate:busy", false, false)
			setElementData(tempObject, "gate", true, true)
			
			--Exciter 2014.07.12: Support for custom trigger distances and sounds
			local triggerDistance, triggerDistanceVehicle, gateSound
			--outputDebugString("row['triggerDistanceVehicle']=" .. tostring(row['triggerDistanceVehicle']) .. ", row['triggerDistance']=" .. tostring(row['triggerDistance']))
			if row["triggerDistance"] == mysql_null() then triggerDistance = false else triggerDistance = tonumber(row["triggerDistance"]) or 35 end
			if row["triggerDistanceVehicle"] == mysql_null() then triggerDistanceVehicle = false else triggerDistanceVehicle = tonumber(row["triggerDistanceVehicle"]) or 35 end
			if row["sound"] == mysql_null() then gateSound = false else gateSound = tostring(row["sound"]) end
			--outputDebugString("triggerDistanceVehicle=" .. tostring(triggerDistanceVehicle) .. ", triggerDistance=" .. tostring(triggerDistance))
			setElementData(tempObject, "gate:triggerDistance", triggerDistance, true)
			setElementData(tempObject, "gate:triggerDistanceVehicle", triggerDistanceVehicle, true)
			setElementData(tempObject, "gate:sound", gateSound, true)
			
			setElementDimension(tempObject, tonumber(row["objectDimension"]))
			setElementInterior(tempObject, tonumber(row["objectInterior"]))
			table.insert(gates, tempObject)
			--exports.cr_pool:allocateElement(tempObject, false, true)
		end
	end
end

--Exported (Exciter 2014.07.12: Exported functions for creating/destroying non-db gates, for use by other scripts)
function createGate(model,x,y,z,rx,ry,rz,x2,y2,z2,rx2,ry2,rz2,int,dim,autocloseTime,movementTime,gateType,securityParameters,triggerDistance,triggerDistanceVehicle,sound)
	local tempObject = createObject(model, x, y, z, rx, ry, rz)
	if tempObject then
		local tempTable = { }
		tempTable["startPosition"] = { x, y, z, rx, ry, rz }
		tempTable["endPosition"] = { x2, y2, z2, rx2, ry2, rz2 }
		tempTable["state"] = false
		tempTable["timer"] = false
		tempTable["type"] = gateType or 1
		tempTable["autocloseTime"] = autocloseTime or -1
		tempTable["movementTime"] = movementTime or 3500
		tempTable["gateSecurityParameters"] = securityParameters or ""
		setElementData(tempObject, "gate:parameters", tempTable, false)
		setElementData(tempObject, "gate:id", -1, false)
		setElementData(tempObject, "gate:edit", false, false)
		setElementData(tempObject, "gate:busy", false, false)
		setElementData(tempObject, "gate", true, true)
		if not triggerDistance then triggerDistance = false else triggerDistance = tonumber(triggerDistance) or 35 end
		if not triggerDistanceVehicle then triggerDistanceVehicle = false else triggerDistanceVehicle = tonumber(triggerDistanceVehicle) or 35 end
		if not sound then sound = false else sound = tostring(sound) end
		setElementData(tempObject, "gate:triggerDistance", triggerDistance, true)
		setElementData(tempObject, "gate:triggerDistanceVehicle", triggerDistanceVehicle, true)
		setElementData(tempObject, "gate:sound", sound, false)
		setElementDimension(tempObject, dim)
		setElementInterior(tempObject, int)
		if triggerDistance then
			setElementData(tempObject, "gate.triggerdistance", triggerDistance, true)
		end
		if sound then
			setElementData(tempObject, "gate.sound", sound, false)
		end
		table.insert(gates, tempObject)
		return tempObject
	else
		return false
	end
end
function removeGate(element)
	if not isElement(element) then return end
	local position
	for k,v in ipairs(gates) do
		if(v == element) then
			position = k
			break
		end
	end
	if position then
		table.remove(gates, position)
	end
	destroyElement(element)
end

--[[
Gate types:
1. /gate for everyone
2. /gate for everyone with password
3. /gate with item
4. /gate with item and itemvalue ending on *
5. open with /gate and keypad
6. colsphere trigger
7. /gate for person in faction
8. query string which allows a variety of conditionals (ex: 170=mansion gate AND 168 OR PILOT) //Exciter
9. for person with access to given vehicle ID (vehicle key, member of vehicles faction, or admin on duty) //Exciter
10. gate that only work with the keycard item, whereas the item value and gate password need to be a exact match //Exciter
]]