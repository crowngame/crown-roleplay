local localPlayer = getLocalPlayer()
local show = false
local width, height = 400, 67
local sx, sy = guiGetScreenSize()

local font1 = exports.cr_fonts:getFont("sf-regular", 10)
local font2 = exports.cr_fonts:getFont("sf-bold", 15)

local content = {}
local timerClose = nil
local cooldownTime = 20
local toBeDrawnWidth = width
local justClicked = false

function drawOverlayTopRight(info, widthNew, posXOffsetNew, posYOffsetNew, cooldown)
	local pinned = getElementData(localPlayer, "hud:pin")
	if not pinned and timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
	
	if info then
		content = info
		content[1][1] = string.sub(content[1][1], 1, 1)..string.sub(content[1][1], 2)
	else
		return false
	end
	
	
	if posXOffsetNew then
		posXOffset = posXOffsetNew
	end
	
	if posYOffsetNew then
		posYOffset = posYOffsetNew
	end
	
	if cooldown then
		cooldownTime = cooldown
	end
	
	if content then
		show = true
	end
	
	toBeDrawnWidth = width
	
	if cooldownTime ~= 0 and not pinned then
		timerClose = setTimer(function()
			show = false
			setElementData(localPlayer, "hud:overlayTopRight", 0, false)
		end, cooldownTime * 1000, 1)
	end
end
addEvent("hudOverlay:drawOverlayTopRight", true)
addEventHandler("hudOverlay:drawOverlayTopRight", localPlayer, drawOverlayTopRight)

addEventHandler("onClientRender", root, function ()
	if show and not getElementData(localPlayer, "integration:previewPMShowing") and getElementData(localPlayer, "loggedin") == 1 then 
		if (getPedWeapon(localPlayer) ~= 43 or not getPedControlState(localPlayer, "aim_weapon")) then
			local posXOffset, posYOffset = 0, 165
			local hudDxHeight = getElementData(localPlayer, "hud:whereToDisplayY") or 0
			if hudDxHeight then
				posYOffset = posYOffset + hudDxHeight + 30
			end
			
			local y = (sy - 16*(#content)) / 2
	
			dxDrawRectangle(sx-toBeDrawnWidth+posXOffset, y, toBeDrawnWidth-20, 16*(#content)+30, tocolor(10, 10, 10, 225)) -- main
		
			for i=1, #content do
				if content[i] then
					if i == 1 or content[i][7] == "title" then
						dxDrawText(content[i][1] or "" , sx-toBeDrawnWidth+17+posXOffset, (16*i)+y+1, toBeDrawnWidth-5, 15, tocolor (255, 255, 255, 225), 1, font2)
					else
						dxDrawText(content[i][1] or "" , sx-toBeDrawnWidth+17+posXOffset, (16*i)+y+4, toBeDrawnWidth-5, 15, tocolor (content[i][2] or 225, content[i][3] or 225, content[i][4] or 225, content[i][5] or 225), content[i][6] or 1, font1, "left", "top", false, false, false, true)
					end
				end
			end
		end
	end
end, false)

function pinIt()
	setElementData(localPlayer, "hud:pin", true, false)
	if timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
end

function unpinIt()
	pinIt()
	setElementData(localPlayer, "hud:pin", false, false)
	timerClose = setTimer(function()
		show = false
		setElementData(localPlayer, "hud:overlayTopRight", 0, false)
	end, 3000, 1)
end

function isOverlayShow()
	return show
end