local drawTimers = {} 
local font = exports.cr_fonts:getFont("sf-regular", 11)

function dxDrawTextOnElement(element, text, height, distance, R, G, B, alpha, size, font, tur, reason, id, ...)
    if getElementDimension(localPlayer) ~= 0 then return end
    if getElementInterior(localPlayer) ~= 0 then return end
    local x, y, z = getElementPosition(element)
    local x2, y2, z2 = getCameraMatrix()
    local distance = distance or 20
    local height = height or 1
    local sourcePos = Vector3(getElementPosition(element))
    local distance = getDistanceBetweenPoints3D(sourcePos.x, sourcePos.y, sourcePos.z, Vector3(getElementPosition(localPlayer)))
    local sx, sy = getScreenFromWorldPosition(x, y, z+height+1)
    local reason = reason or ""
	if localPlayer == element then return end
    if (sx) and (sy) then
        if tur == "destek" then
            dxDrawImage(sx-25, sy-60, 50, 50, "files/destek" .. (id or 1) .. ".png", 0, 0, -120)
        elseif tur == "takip" then
            dxDrawImage(sx-25, sy-60, 50, 50, "files/takip.png", 0, 0, -120)
        end

        local fullText = text:gsub("_", " ") .. " (" .. reason .. ")\n#8AE68A" .. math.floor(distance) .. " #FFFFFFmetre"
        if reason == "" then
            fullText = text:gsub("_", " ") .. "\n#8AE68A" .. math.floor(distance) .. " #FFFFFFmetre"
        end

        dxDrawText(fullText, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1), font or "arial", "center", "center", false, false, false, true, false)
    end
end

function destek(state, player, reason, id)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 0, 0, player, getPlayerName(player):gsub("_", " "), 1, 20, 255, 255, 255, 255, 1, font, "destek", reason, id)
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
    end
end
addEvent("lspd:destek", true) 
addEventHandler("lspd:destek", root, destek)

function takip(state, player, reason, id)
    if (state) then
        drawTimers[player] = setTimer(dxDrawTextOnElement, 8.5, 0, player, getPlayerName(player):gsub("_", " "), 1, 20, 255, 255, 255, 255, 1, font, "takip", reason, id)
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
    end
end
addEvent("lspd:takip", true) 
addEventHandler("lspd:takip", root, takip)

function panik(state, player, reason, id)
    if (state) then
        playSound("panik.mp3")
        drawTimers[player] = setTimer(dxDrawTextOnElement, 8.5, 0, player, getPlayerName(player):gsub("_", " "), 1, 20, 255, 255, 255, 255, 1, font, "destek", reason, id)
        if player == getLocalPlayer() then
            killTimer(drawTimers[player])
        end
    else
        if (isTimer(drawTimers[player])) then killTimer(drawTimers[player]) end
    end
end
addEvent("lspd:panik", true) 
addEventHandler("lspd:panik", root, panik)