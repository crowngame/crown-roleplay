local screenX, screenY = guiGetScreenSize()
local requestedWord = nil

local font = exports.cr_fonts:getFont("UbuntuBold", 20)

addEvent("hotwire.drawText", true)
addEventHandler("hotwire.drawText", root, function(word)
    requestedWord = word
end)

addEvent("hotwire.removeText", true)
addEventHandler("hotwire.removeText", root, function()
    requestedWord = nil
end)

addEventHandler("onClientRender", root, function()
    if (requestedWord) then
        dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 150))
        dxDrawText(requestedWord, 0, 0, screenX, screenY, tocolor(255, 255, 255, 255), 1, font, "center", "center")
    end
end)