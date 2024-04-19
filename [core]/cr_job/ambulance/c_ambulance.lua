local drawTimers = {} 
local font = exports.cr_fonts:getFont("RobotoB", 11)
function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,tur,...)
	if not getElementData(localPlayer, "ambulance:started") then return end
    local x, y, z = getElementPosition(TheElement)
    local x2, y2, z2 = getCameraMatrix()
    local distance = distance or 20
    local height = height or 1
    local sourcePos = Vector3(getElementPosition(TheElement))
     local distance = getDistanceBetweenPoints3D(sourcePos.x, sourcePos.y, sourcePos.z, Vector3(getElementPosition(localPlayer)))
    local sx, sy = getScreenFromWorldPosition(x, y, z+height)
    if localPlayer == TheElement then return end
    if(sx) and (sy) then
    	if tur == 'hasta' then
        dxDrawImage (sx-25, sy+10, 50, 50, ':job-system/ambulance/files/hasta.png', 0, 0, -120)
    elseif tur == 'hastane' then
        dxDrawImage (sx-25, sy+10, 50, 50, ':job-system/ambulance/files/hastane.png', 0, 0, -120)
    end
     dxDrawText("[" .. math.floor(distance) .. " km]", sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1), font or "arial", "center", "center")
    end
end

function blip_hasta(state, player)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 8.5, 0, player, "hasta", 1, 20, 255, 255, 255, 255, 1, font, 'hasta')
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
    end
end
addEvent("hastablip",true) 
addEventHandler("hastablip", localPlayer, blip_hasta)

function hastane(state, player)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 8.5, 0, player, "hastane", 1, 20, 255, 255, 255, 255, 1, font,'hastane')
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
    end
end
addEvent("hastaneblip",true) 
addEventHandler("hastaneblip", localPlayer, hastane)