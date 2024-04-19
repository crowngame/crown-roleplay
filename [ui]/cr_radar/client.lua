Display = {}
Display.Width, Display.Height = guiGetScreenSize()

Minimap = {}
Minimap.Width = math.floor(exports.cr_ui:resp(350))
Minimap.Height = math.floor(exports.cr_ui:resp(225))
Minimap.PosX = 20
Minimap.PosY = (Display.Height - 20) - Minimap.Height

Minimap.IsVisible = true
Minimap.TextureSize = radarSettings["mapTextureSize"]
Minimap.NormalTargetSize, Minimap.BiggerTargetSize = Minimap.Width, Minimap.Width * 2
Minimap.MapTarget = dxCreateRenderTarget(Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, true)
Minimap.RenderTarget = dxCreateRenderTarget(Minimap.NormalTargetSize * 3, Minimap.NormalTargetSize * 3, true)
Minimap.MapTexture = dxCreateTexture(radarSettings["mapTexture"])
Minimap.MapVignette = dxCreateTexture(radarSettings["mapVignette"])

Minimap.CurrentZoom = 3
Minimap.MaximumZoom = 8
Minimap.MinimumZoom = 1

Minimap.WaterColor = radarSettings["mapWaterColor"]
Minimap.Alpha = radarSettings["alpha"]
Minimap.PlayerInVehicle = false
Minimap.LostRotation = 0
Minimap.MapUnit = Minimap.TextureSize / 6000

Bigmap = {}
Bigmap.Width, Bigmap.Height = Display.Width, Display.Height
Bigmap.PosX, Bigmap.PosY = 0, 0
Bigmap.IsVisible = false
Bigmap.CurrentZoom = 1
Bigmap.MinimumZoom = 1
Bigmap.MaximumZoom = 3
Bigmap.MapVignette = dxCreateTexture(radarSettings["mapVignette"])

Fonts = {}
Fonts.SweetSixteen1 = exports.cr_fonts:getFont("SweetSixteen", 20)
Fonts.SweetSixteen2 = exports.cr_fonts:getFont("SweetSixteen", 30)
Fonts.SweetSixteen3 = exports.cr_fonts:getFont("SweetSixteen", 22)

Stats = {}
Stats.Bar = {}
Stats.Bar.Width = Minimap.Width
Stats.Bar.Height = 10

local playerX, playerY, playerZ = 0, 0, 0
local mapOffsetX, mapOffsetY, mapIsMoving = 0, 0, false

addEventHandler("onClientResourceStart", resourceRoot, function()
	setPlayerHudComponentVisible("radar", false)
	
	if (Minimap.MapTexture) then
		dxSetTextureEdge(Minimap.MapTexture, "border", tocolor(Minimap.WaterColor[1], Minimap.WaterColor[2], Minimap.WaterColor[3], 255))
	end
end)

function RadarTrue()
	Minimap.IsVisible = true
end
addEvent("onRadarTrue", true)
addEventHandler("onRadarTrue", root, RadarTrue)

function RadarFalse()
	Minimap.IsVisible = false
end
addEvent("onRadarFalse", true)
addEventHandler("onRadarFalse", root, RadarFalse)

addEventHandler("onClientKey", root, function(key, state)
	if (state) then
		if (key == "F11") then
			cancelEvent()
			Bigmap.IsVisible = not Bigmap.IsVisible
			showCursor(false)
			
			if (Bigmap.IsVisible) then
				showChat(false)
				playSoundFrontEnd(1)
				Minimap.IsVisible = false
				showCursor(true)
				setElementData(localPlayer, "hud_settings", {})
			else
				showChat(true)
				playSoundFrontEnd(2)
				Minimap.IsVisible = true
				mapOffsetX, mapOffsetY, mapIsMoving = 0, 0, false
				triggerEvent("hud:loadSettings", localPlayer)
			end
		elseif (key == "mouse_wheel_down" and Bigmap.IsVisible) then
			Bigmap.CurrentZoom = math.min(Bigmap.CurrentZoom + 0.5, Bigmap.MaximumZoom)
		elseif (key == "mouse_wheel_up" and Bigmap.IsVisible) then
			Bigmap.CurrentZoom = math.max(Bigmap.CurrentZoom - 0.5, Bigmap.MinimumZoom)
		elseif (key == "mouse2" and Bigmap.IsVisible) then
			showCursor(not isCursorShowing())
		end
	end
end)

addEventHandler("onClientClick", root, function(button, state, cursorX, cursorY)
	if (not Minimap.IsVisible and Bigmap.IsVisible) then
		if (button == "left" and state == "down") then
			if (cursorX >= Bigmap.PosX and cursorX <= Bigmap.PosX + Bigmap.Width) then
				if (cursorY >= Bigmap.PosY and cursorY <= Bigmap.PosY + Bigmap.Height) then
					mapOffsetX = cursorX * Bigmap.CurrentZoom + playerX
					mapOffsetY = cursorY * Bigmap.CurrentZoom - playerY
					mapIsMoving = true
				end
			end
		elseif (button == "left" and state == "up") then
			mapIsMoving = false
		end
	end
end)

setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		if (not Minimap.IsVisible and Bigmap.IsVisible) then
			local absoluteX, absoluteY = 0, 0
			local zoneName = "Unknown"
			
			if (getElementInterior(localPlayer) == 0) then
				if (isCursorShowing()) then
					local cursorX, cursorY = getCursorPosition()
					local mapX, mapY = getWorldFromMapPosition(cursorX, cursorY)
					
					absoluteX = cursorX * Display.Width
					absoluteY = cursorY * Display.Height
					
					if (getKeyState("mouse1") and mapIsMoving) then
						playerX = -(absoluteX * Bigmap.CurrentZoom - mapOffsetX)
						playerY = absoluteY * Bigmap.CurrentZoom - mapOffsetY
						
						playerX = math.max(-3000, math.min(3000, playerX))
						playerY = math.max(-3000, math.min(3000, playerY))
					end
				end
				
				local playerRotation = getPedRotation(localPlayer)
				local mapX = (((3000 + playerX) * Minimap.MapUnit) - (Bigmap.Width / 2) * Bigmap.CurrentZoom)
				local mapY = (((3000 - playerY) * Minimap.MapUnit) - (Bigmap.Height / 2) * Bigmap.CurrentZoom)
				local mapWidth, mapHeight = Bigmap.Width * Bigmap.CurrentZoom, Bigmap.Height * Bigmap.CurrentZoom

				dxDrawImageSection(Bigmap.PosX, Bigmap.PosY, Bigmap.Width, Bigmap.Height, mapX, mapY, mapWidth, mapHeight, Minimap.MapTexture, 0, 0, 0, tocolor(255, 255, 255, Minimap.Alpha))
				
				--> Radar area
				for _, area in ipairs(getElementsByType("radararea")) do
					local areaX, areaY = getElementPosition(area)
					local areaWidth, areaHeight = getRadarAreaSize(area)
					local areaR, areaG, areaB, areaA = getRadarAreaColor(area)
						
					if (isRadarAreaFlashing(area)) then
						areaA = areaA * math.abs(getTickCount() % 1000 - 500) / 500
					end
					
					local areaX, areaY = getMapFromWorldPosition(areaX, areaY + areaHeight)
					local areaWidth, areaHeight = areaWidth / Bigmap.CurrentZoom * Minimap.MapUnit, areaHeight / Bigmap.CurrentZoom * Minimap.MapUnit

					--> Width
					if (areaX < Bigmap.PosX) then
						areaWidth = areaWidth - math.abs((Bigmap.PosX) - (areaX))
						areaX = areaX + math.abs((Bigmap.PosX) - (areaX))
					end
					
					if (areaX + areaWidth > Bigmap.PosX + Bigmap.Width) then
						areaWidth = areaWidth - math.abs((Bigmap.PosX + Bigmap.Width) - (areaX + areaWidth))
					end
					
					if (areaX > Bigmap.PosX + Bigmap.Width) then
						areaWidth = areaWidth + math.abs((Bigmap.PosX + Bigmap.Width) - (areaX))
						areaX = areaX - math.abs((Bigmap.PosX + Bigmap.Width) - (areaX))
					end
					
					if (areaX + areaWidth < Bigmap.PosX) then
						areaWidth = areaWidth + math.abs((Bigmap.PosX) - (areaX + areaWidth))
						areaX = areaX - math.abs((Bigmap.PosX) - (areaX + areaWidth))
					end
					
					--> Height
					if (areaY < Bigmap.PosY) then
						areaHeight = areaHeight - math.abs((Bigmap.PosY) - (areaY))
						areaY = areaY + math.abs((Bigmap.PosY) - (areaY))
					end
					
					if (areaY + areaHeight > Bigmap.PosY + Bigmap.Height) then
						areaHeight = areaHeight - math.abs((Bigmap.PosY + Bigmap.Height) - (areaY + areaHeight))
					end
					
					if (areaY + areaHeight < Bigmap.PosY) then
						areaHeight = areaHeight + math.abs((Bigmap.PosY) - (areaY + areaHeight))
						areaY = areaY - math.abs((Bigmap.PosY) - (areaY + areaHeight))
					end
					
					if (areaY > Bigmap.PosY + Bigmap.Height) then
						areaHeight = areaHeight + math.abs((Bigmap.PosY + Bigmap.Height) - (areaY))
						areaY = areaY - math.abs((Bigmap.PosY + Bigmap.Height) - (areaY))
					end
					
					--> Draw
					dxDrawRectangle(areaX, areaY, areaWidth, areaHeight, tocolor(areaR, areaG, areaB, areaA), false)
				end
				
				--> Blips
				for _, blip in ipairs(getElementsByType("blip")) do
					local blipX, blipY, blipZ = getElementPosition(blip)

					if (localPlayer ~= getElementAttachedTo(blip)) then
						local blipSettings = {
							["color"] = {255, 255, 255, 255},
							["size"] = getElementData(blip, "blipSize") or 20,
							["icon"] = getBlipIcon(blip) or "target",
							["exclusive"] = getElementData(blip, "exclusiveBlip") or false
						}
						
						if (blipSettings["icon"] == 0 or blipSettings["icon"] == "waypoint") then
							blipSettings["color"] = {getBlipColor(blip)}
						end
						
						local centerX, centerY = (Bigmap.PosX + (Bigmap.Width / 2)), (Bigmap.PosY + (Bigmap.Height / 2))
						local leftFrame = (centerX - Bigmap.Width / 2) + (blipSettings["size"] / 2)
						local rightFrame = (centerX + Bigmap.Width / 2) - (blipSettings["size"] / 2)
						local topFrame = (centerY - Bigmap.Height / 2) + (blipSettings["size"] / 2)
						local bottomFrame = (centerY + Bigmap.Height / 2) - (blipSettings["size"] / 2)
						local blipX, blipY = getMapFromWorldPosition(blipX, blipY)
						
						centerX = math.max(leftFrame, math.min(rightFrame, blipX))
						centerY = math.max(topFrame, math.min(bottomFrame, blipY))

						dxDrawImage(centerX - (blipSettings["size"] / 2), centerY - (blipSettings["size"] / 2), blipSettings["size"], blipSettings["size"], "images/blips/" .. blipSettings["icon"] .. ".png", 0, 0, 0, tocolor(blipSettings["color"][1], blipSettings["color"][2], blipSettings["color"][3], blipSettings["color"][4]))
					end
				end
				
				--> Local player
				local localX, localY, localZ = getElementPosition(localPlayer)
				local blipX, blipY = getMapFromWorldPosition(localX, localY)
				
				if (blipX >= Bigmap.PosX and blipX <= Bigmap.PosX + Bigmap.Width) then
					if (blipY >= Bigmap.PosY and blipY <= Bigmap.PosY + Bigmap.Height) then
						dxDrawImage(blipX - 10, blipY - 10, 25, 25, "images/arrow.png", 360 - playerRotation)
					end
				end
				
				dxDrawImage(Bigmap.PosX, Bigmap.PosY, Bigmap.Width, Bigmap.Height, Bigmap.MapVignette, 0, -90, 0, tocolor(255, 255, 255, 255))
				dxDrawText(getZoneName(localX, localY, localZ), Bigmap.PosX + 25 + 1, Bigmap.PosY + 25 + 1, 1, 1, tocolor(0, 0, 0, 255), 1, Fonts.SweetSixteen2)
				dxDrawText(getZoneName(localX, localY, localZ), Bigmap.PosX + 25, Bigmap.PosY + 25, 0, 0, tocolor(255, 255, 255, 255), 1, Fonts.SweetSixteen2)
			end
		elseif (Minimap.IsVisible and not Bigmap.IsVisible) then
			if getElementData(localPlayer, "hud_settings").radar == 1 then
				if (radarSettings["showStats"]) then
					Minimap.PosY = ((Display.Height - 10) - Stats.Bar.Height) - Minimap.Height
				else
					Minimap.PosY = (Display.Height - 10) - Minimap.Height
				end
				
				if (getElementInterior(localPlayer) == 0) and (getElementDimension(localPlayer) == 0) then
					Minimap.PlayerInVehicle = getPedOccupiedVehicle(localPlayer)
					playerX, playerY, playerZ = getElementPosition(localPlayer)
					
					--> Calculate positions
					local playerRotation = getPedRotation(localPlayer)
					local playerMapX, playerMapY = (3000 + playerX) / 6000 * Minimap.TextureSize, (3000 - playerY) / 6000 * Minimap.TextureSize
					local streamDistance = getRadarRadius()
					local mapRadius = streamDistance / 6000 * Minimap.TextureSize * Minimap.CurrentZoom
					local mapX, mapY, mapWidth, mapHeight = playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2
					
					--> Set world
					dxSetRenderTarget(Minimap.MapTarget, true)
					dxDrawRectangle(0, 0, Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, tocolor(Minimap.WaterColor[1], Minimap.WaterColor[2], Minimap.WaterColor[3], Minimap.Alpha), false)
					dxDrawImageSection(0, 0, Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, mapX, mapY, mapWidth, mapHeight, Minimap.MapTexture, 0, 0, 0, tocolor(255, 255, 255, Minimap.Alpha), false)
					
					--> Draw radar areas
					for _, area in ipairs(getElementsByType("radararea")) do
						local areaX, areaY = getElementPosition(area)
						local areaWidth, areaHeight = getRadarAreaSize(area)
						local areaMapX, areaMapY, areaMapWidth, areaMapHeight = (3000 + areaX) / 6000 * Minimap.TextureSize, (3000 - areaY) / 6000 * Minimap.TextureSize, areaWidth / 6000 * Minimap.TextureSize, -(areaHeight / 6000 * Minimap.TextureSize)
						
						if (doesCollide(playerMapX - mapRadius, playerMapY - mapRadius, mapRadius * 2, mapRadius * 2, areaMapX, areaMapY, areaMapWidth, areaMapHeight)) then
							local areaR, areaG, areaB, areaA = getRadarAreaColor(area)
							
							if (isRadarAreaFlashing(area)) then
								areaA = areaA * math.abs(getTickCount() % 1000 - 500) / 500
							end
							
							local mapRatio = Minimap.BiggerTargetSize / (mapRadius * 2)
							local areaMapX, areaMapY, areaMapWidth, areaMapHeight = (areaMapX - (playerMapX - mapRadius)) * mapRatio, (areaMapY - (playerMapY - mapRadius)) * mapRatio, areaMapWidth * mapRatio, areaMapHeight * mapRatio
							
							dxSetBlendMode("modulate_add")
							dxDrawRectangle(areaMapX, areaMapY, areaMapWidth, areaMapHeight, tocolor(areaR, areaG, areaB, areaA), false)
							dxSetBlendMode("blend")
						end
					end
					
					--> Draw blip
					dxSetRenderTarget(Minimap.RenderTarget, true)
					dxDrawImage(Minimap.NormalTargetSize / 2, Minimap.NormalTargetSize / 2, Minimap.BiggerTargetSize, Minimap.BiggerTargetSize, Minimap.MapTarget, 0, 0, 0, tocolor(255, 255, 255, 255), false)
					
					local localX, localY, localZ = getElementPosition(localPlayer)
					
					--> Draw fully minimap
					dxSetRenderTarget()
					dxDrawImageSection(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, Minimap.NormalTargetSize / 2 + (Minimap.BiggerTargetSize / 2) - (Minimap.Width / 2), Minimap.NormalTargetSize / 2 + (Minimap.BiggerTargetSize / 2) - (Minimap.Height / 2), Minimap.Width, Minimap.Height, Minimap.RenderTarget, 0, -90, 0, tocolor(255, 255, 255, 255))
					dxDrawImage(Minimap.PosX, Minimap.PosY, Minimap.Width, Minimap.Height, Minimap.MapVignette, 0, -90, 0, tocolor(255, 255, 255, 255))
					dxDrawText(getZoneName(localX, localY, localZ), Minimap.PosX + Minimap.Width + 1, Minimap.PosY + Minimap.Height - 45 + 1, Minimap.Width + 1, Minimap.Height + 1, tocolor(0, 0, 0, 255), 1, Fonts.SweetSixteen1, "right")
					dxDrawText(getZoneName(localX, localY, localZ), Minimap.PosX + Minimap.Width, Minimap.PosY + Minimap.Height - 45, Minimap.Width, Minimap.Height, tocolor(255, 255, 255, 255), 1, Fonts.SweetSixteen1, "right")
					dxDrawImage((Minimap.PosX + (Minimap.Width / 2)) - 10, (Minimap.PosY + (Minimap.Height / 2)) - 10, 24, 24, "images/arrow.png", 360 - playerRotation)
				end
			end
		end
		
		if isPlayerHudComponentVisible("radar") then
			playerX, playerY, playerZ = getElementPosition(localPlayer)
			local playerZoneName = getZoneName(playerX, playerY, playerZ)
			dxDrawText(playerZoneName, 1, 1, Display.Width * 0.265 + 1, Display.Height * 0.975 + 1, tocolor(0, 0, 0, 255), 1, Fonts.SweetSixteen3, "center", "bottom")
			dxDrawText(playerZoneName, 0, 0, Display.Width * 0.265, Display.Height * 0.975, tocolor(255, 255, 255, 255), 1, Fonts.SweetSixteen3, "center", "bottom")
		end
	end
end, 0, 0)

setTimer(function()
    if getElementData(localPlayer, "loggedin") == 1 then
	    if getElementData(localPlayer, "hud_settings").radar ~= 2 or getElementInterior(localPlayer) ~= 0 or getElementDimension(localPlayer) ~= 0 then 
	        setPlayerHudComponentVisible("radar", false)
	    else 
	        setPlayerHudComponentVisible("radar", true)
	    end
	end
end, 500, 0)

function doesCollide(x1, y1, w1, h1, x2, y2, w2, h2)
	local horizontal = (x1 < x2) ~= (x1 + w1 < x2) or (x1 > x2) ~= (x1 > x2 + w2)
	local vertical = (y1 < y2) ~= (y1 + h1 < y2) or (y1 > y2) ~= (y1 > y2 + h2)
	
	return (horizontal and vertical)
end

function getRadarRadius()
	if (not Minimap.PlayerInVehicle) then
		return 180
	else
		local vehicleX, vehicleY, vehicleZ = getElementVelocity(Minimap.PlayerInVehicle)
		local currentSpeed = (1 + (vehicleX ^ 2 + vehicleY ^ 2 + vehicleZ ^ 2) ^ (0.5)) / 2
	
		if (currentSpeed <= 0.5) then
			return 180
		elseif (currentSpeed >= 1) then
			return 360
		end
		
		local distance = currentSpeed - 0.5
		local ratio = 180 / 0.5
		
		return math.ceil((distance * ratio) + 180)
	end
end

function getPointFromDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist
	
	return x + dx, y + dy
end

function getVectorRotation(X, Y, X2, Y2)
	local rotation = 6.2831853071796 - math.atan2(X2 - X, Y2 - Y) % 6.2831853071796
	
	return -rotation
end

function getMinimapState()
	return Minimap.IsVisible
end

function getBigmapState()
	return Bigmap.IsVisible
end

function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (Bigmap.PosX + (Bigmap.Width / 2)), (Bigmap.PosY + (Bigmap.Height / 2))
	local mapLeftFrame = centerX - ((playerX - worldX) / Bigmap.CurrentZoom * Minimap.MapUnit)
	local mapRightFrame = centerX + ((worldX - playerX) / Bigmap.CurrentZoom * Minimap.MapUnit)
	local mapTopFrame = centerY - ((worldY - playerY) / Bigmap.CurrentZoom * Minimap.MapUnit)
	local mapBottomFrame = centerY + ((playerY - worldY) / Bigmap.CurrentZoom * Minimap.MapUnit)
	
	centerX = math.max(mapLeftFrame, math.min(mapRightFrame, centerX))
	centerY = math.max(mapTopFrame, math.min(mapBottomFrame, centerY))
	
	return centerX, centerY
end

function getWorldFromMapPosition(mapX, mapY)
	local worldX = playerX + ((mapX * ((Bigmap.Width * Bigmap.CurrentZoom) * 2)) - (Bigmap.Width * Bigmap.CurrentZoom))
	local worldY = playerY + ((mapY * ((Bigmap.Height * Bigmap.CurrentZoom) * 2)) - (Bigmap.Height * Bigmap.CurrentZoom)) * -1
	
	return worldX, worldY
end