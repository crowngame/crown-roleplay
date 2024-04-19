local screenSize = Vector2(guiGetScreenSize())

addCommandHandler("ss", function()
    if getElementData(localPlayer, "loggedin") == 1 then
        if not isTimer(renderTimer) then
            renderTimer = setTimer(function()
                dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 255))
            end, 0, 0)
        else
            killTimer(renderTimer)
        end
    end
end)