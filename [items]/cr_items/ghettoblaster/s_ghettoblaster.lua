-- Updated by Adams 27/01/14
local timer = {}
local tuned = {}
local function updateWorldItemValue(item, station, volume)
    if station < 0 or station > #exports.cr_carradio:getStreams() then return end

    local newvalue = tostring(station)
    if volume and volume ~= 100 then
        newvalue = newvalue .. ':' .. volume
    end

    setElementData(item, "itemValue", newvalue)
    mysql:query_free("UPDATE worlditems SET itemvalue='" .. newvalue .. "' WHERE id=" .. getElementData(item, "id"))
    triggerClientEvent("toggleSound", item)
end

function changeTrack(item, step)
    local streams = exports.cr_carradio:getStreams()
    local splitValue = split(tostring(getElementData(item, "itemValue")), ':')
    local current = tonumber(splitValue[1]) or 1
    current = current + step
    if current > #streams then
        current = 0
    elseif current < 0 then
        current = #streams
    end
    updateWorldItemValue(item, current, tonumber(splitValue[2]))
	
	if not tuned[item] then
		exports.cr_global:sendLocalMeAction(source, "retunes the Ghettoblaster.")
		tuned[item] = true
	else
		if timer[item] and isTimer(timer[item]) then
			killTimer(timer[item])
		end
		timer[item] = setTimer(function()
			tuned[item] = false
		end, 10*1000, 1)
	end
end
addEvent("changeGhettoblasterTrack", true)
addEventHandler("changeGhettoblasterTrack", getRootElement(), changeTrack)

addEvent('changeGhettoblasterVolume', true)
addEventHandler('changeGhettoblasterVolume', root, function(newvalue)
    newvalue = math.floor(newvalue)
    if newvalue < 0 or newvalue > 100 then return end

    local splitValue = split(tostring(getElementData(source, "itemValue")), ':')

    updateWorldItemValue(source, tonumber(splitValue[1]) or 1, newvalue)
end)

function changeStation(thePlayer, commandName, operator)
	if operator then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local count = 0
		
		for key, item in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("cr_item-world")))) do
			local dbid = getElementData(item, "id")
			if dbid then
				local x, y, z = getElementPosition(item)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(item) == getElementDimension(thePlayer) and getElementInterior(item) == getElementInterior(thePlayer) then
					if getElementData(item, "itemID") == 54 or getElementData(item, "itemID") == 176 then
						local station = getElementData(item, "itemValue")
						if operator == "+" then
							if (station + 1) > 0 and (station + 1) <= #exports.cr_carradio:getStreams() then
								setElementData(item, "itemValue", station + 1)
								mysql:query_free("UPDATE worlditems SET itemvalue='" .. station + 1 .. "' WHERE id=" .. getElementData(item, "id"))
								triggerClientEvent("toggleSound", item)
								exports.cr_global:sendLocalMeAction(thePlayer, "hoparlörün kanalını ayarlar.")
							else
								outputChatBox("[!]#FFFFFF Hoparlör maksimum kanala ulaştı.", thePlayer, 255, 0, 0, true)
							end
						elseif operator == "-" then
							if (station - 1) > 0 then
								setElementData(item, "itemValue", station - 1)
								mysql:query_free("UPDATE worlditems SET itemvalue='" .. station - 1 .. "' WHERE id=" .. getElementData(item, "id"))
								triggerClientEvent("toggleSound", item)
								exports.cr_global:sendLocalMeAction(thePlayer, "hoparlörün kanalını ayarlar.")
							else
								outputChatBox("[!]#FFFFFF Hoparlör minimum kanala ulaştı.", thePlayer, 255, 0, 0, true)
							end
						end
						count = count + 1
					end
				end
			end
		end
		
		if (count == 0) then
			outputChatBox("[!]#FFFFFF Yakınlarda hoparlör yok.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("KULLANIM: /" .. commandName .. " [+ / -]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("cs", changeStation, false, false)