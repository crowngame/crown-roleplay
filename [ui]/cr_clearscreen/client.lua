local screenWidth, screenHeight = guiGetScreenSize()

addEventHandler("onClientResourceStart", resourceRoot, function()
    myScreenSource = dxCreateScreenSource(screenWidth, screenHeight)
end)
 
function clearScreen()
	if myScreenSource then
		dxUpdateScreenSource(myScreenSource)
		dxDrawImage(screenWidth - screenWidth, screenHeight - screenHeight, screenWidth, screenHeight, myScreenSource, 0, 0, 0, tocolor(255, 255, 255, 255), true)      
	end
end

function toggleClearScreen()
	enabled = not enabled
	if enabled then
		addEventHandler("onClientRender", root, clearScreen)
	else
		removeEventHandler("onClientRender", root, clearScreen)
	end
end
bindKey("f9", "down", toggleClearScreen)