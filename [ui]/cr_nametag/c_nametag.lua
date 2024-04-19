local players = {}
local font = "default-bold"
local size = 1
local fontSize = 10
local maxDistance = 30
local badges = {}
local masks = {}

local maxIconsPerLine = 6
local iconsThisLine = 0
local iconSize = 32

local postGUI = false

local settings = {
	font = 1,
	type = 1,
	id = 1,
	border = 1,
	country = 1,
	icon = 1,
	placement = 1,
	toggleNametag = true,
}

if settings.font == 1 then
	font = "default-bold"
elseif settings.font == 2 then
	font = exports.cr_fonts:getFont("sf-regular", fontSize)
elseif settings.font == 3 then
	font = exports.cr_fonts:getFont("sf-bold", fontSize)
elseif settings.font == 4 then
	font = "default"
end

--===========================================================================================================================================================

function renderNametags()
	if settings.toggleNametag then
		if getElementData(localPlayer, "loggedin") == 1 then
			local cameraX, cameraY, cameraZ = getElementPosition(localPlayer)
			for player, data in pairs(players) do
				if isElement(player) then
					local boneX, boneY, boneZ
					if settings.placement == 1 then
						boneX, boneY, boneZ = getPedBonePosition(player, 6)
						boneZ = boneZ + 0.14
					else
						boneX, boneY, boneZ = getElementPosition(player)
						boneZ = boneZ + 0.9
					end
					
					local distance = math.sqrt((cameraX - boneX) ^ 2 + (cameraY - boneY) ^ 2 + (cameraZ - boneZ) ^ 2)
					local alpha = distance >= 20 and math.max(0, 255 - (distance * 7)) or 255
					
					if (aimsAt(player)) or (distance <= maxDistance) and (isElementOnScreen(player)) and (isLineOfSightClear(cameraX, cameraY, cameraZ, boneX, boneY, boneZ, true, false, false, true, false, false, false, localPlayer)) and (getElementAlpha(player) >= 200) then
						local screenX, screenY = getScreenFromWorldPosition(boneX, boneY, boneZ)
						
						if screenX and screenY then
							local text = ""
							local lineY = 0
							local sectionY = 0
							
							local name = getPlayerName(player):gsub("_", " ") .. " (" .. getElementData(player, "playerid") .. ")"
							if settings.id == 2 then name = getPlayerName(player):gsub("_", " ") end
							
							local name, icons, tinted, badge = getPlayerIcons(player, name)
							local r, g, b = getPlayerNametagColor(player)
							
							if aimsAt(player) then
								alpha = 255
							end
							
							if settings.icon == 1 then
								local expectedIcons = math.min(#icons, maxIconsPerLine)
								local iconW, iconH = 29 * size, 29 * size
								local xpos, ypos = 0, -10 * size
								local offset = iconW * expectedIcons
								
								if #icons > expectedIcons then
									if settings.font == 1 or settings.font == 4 then
										lineY = lineY + 26
										sectionY = sectionY + 26
									elseif settings.font == 2 or settings.font == 3 then
										lineY = lineY + 27
										sectionY = sectionY + 27
									end
								end
								
								for index, value in ipairs(icons) do
									local fixy = 0
									if settings.type == 1 then
										fixy = 1
									elseif settings.type == 2 then
										fixy = 3
										if settings.font == 2 or settings.font == 3 then
											fixy = fixy + 1
										end
									end
									
									dxDrawImage(screenX + xpos - iconW - offset / 2 + 30, screenY + ypos + fixy - 23 - sectionY, iconW - 2, iconH - 2, "images/icons/" .. value .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
									
									iconsThisLine = iconsThisLine + 1
									if iconsThisLine == expectedIcons then
										expectedIcons = math.min(#icons - index, maxIconsPerLine)
										offset = iconW * expectedIcons
										iconsThisLine = 0
										xpos = 0
										ypos = ypos + iconH
									else
										xpos = xpos + iconW
									end
								end
								
								if #icons > 0 then
									lineY = lineY + 33
									
									if settings.font == 1 or settings.font == 4 then
										sectionY = sectionY + 33
									elseif settings.font == 2 or settings.font == 3 then
										sectionY = sectionY + 34
									end
								end
							end
							
							if getElementData(player, "afk") then
								text = text .. "\n#f0801d[AFK]"
							end
							
							if getElementData(player, "injury") == 1 then
								text = text .. "\n#cd403b[RK -> Saldıramaz]"
							end
							
							if getElementData(player, "baygin") then
								text = text .. "\n#cd403b[Yaralı - /hasarlar]"
							end
							
							if badge then
								text = text .. "\n" .. RGBToHex(r, g, b) .. badge
							end
							
							text = text .. "\n" .. RGBToHex(r, g, b) .. name
							
							if not tinted then
								if settings.type == 1 then
									local padding = 16 * size
									local width, height = 50 * size, 8 * size
									
									local screenY = screenY - padding + (3 * size)
									
									local armor = getPedArmor(player)
									if armor > 0 then
										dxDrawRectangle(screenX - width / 2, screenY - lineY, width, height, tocolor(0, 0, 0), postGUI)
										dxDrawRectangle(screenX - width / 2 + 1, screenY - lineY + 1, (width - 2), height - 2, tocolor(200, 200, 200, 50), postGUI)
										dxDrawRectangle(screenX - width / 2 + 1, screenY - lineY + 1, (width - 2) * armor / 100, height - 2, tocolor(200, 200, 200, alpha), postGUI)
										lineY = lineY + ((height + 1) * size)
										
										if settings.font == 1 or settings.font == 4 then
											sectionY = sectionY + 9
										elseif settings.font == 2 or settings.font == 3 then
											sectionY = sectionY + 10
										end
									end
									
									dxDrawRectangle(screenX - width / 2, screenY - lineY, width, height, tocolor(0, 0, 0, 230), postGUI)
									dxDrawRectangle(screenX - width / 2 + 1, screenY - lineY + 1, (width - 2), height - 2, tocolor(200, 15, 15, 100), postGUI)
									dxDrawRectangle(screenX - width / 2 + 1, screenY - lineY + 1, (width - 2) * getElementHealth(player) / 100, height - 2, tocolor(200, 15, 15, alpha), postGUI)
									
									if settings.font == 1 or settings.font == 4 then
										lineY = lineY + 16
									elseif settings.font == 2 or settings.font == 3 then
										lineY = lineY + 17
									end
								elseif settings.type == 2 then
									text = text .. "\n#FFFFFFHP: " .. getHealthColor(player) .. math.floor(getElementHealth(player)) .. "%"
									
									if getPedArmor(player) > 0 then
										text = text .. "\n#FFFFFFZırh:#999999 " .. math.floor(getPedArmor(player)) .. "%"
										
										if settings.font == 1 or settings.font == 4 then
											sectionY = sectionY + 15
										elseif settings.font == 2 or settings.font == 3 then
											sectionY = sectionY + 16
										end
									end
								elseif settings.type == 3 then
									if settings.font == 1 or settings.font == 4 then
										lineY = lineY + 5
									elseif settings.font == 2 or settings.font == 3 then
										lineY = lineY + 6
									end
									
									if settings.font == 1 or settings.font == 4 then
										sectionY = sectionY - 10
									elseif settings.font == 2 or settings.font == 3 then
										sectionY = sectionY - 11
									end
								end
							end
							
							if settings.border == 1 then
								dxDrawBorderText(text, screenX, 0, screenX, screenY - lineY, tocolor(255, 255, 255, alpha), size, font, "center", "bottom", false, true, postGUI, true)
							elseif settings.border == 2 then
								dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), screenX + 1, 1, screenX + 1, screenY - lineY + 1, tocolor(0, 0, 0, alpha), size, font, "center", "bottom", false, true, postGUI, true)
								dxDrawText(text, screenX, 0, screenX, screenY - lineY, tocolor(255, 255, 255, alpha), size, font, "center", "bottom", false, true, postGUI, true)
							elseif settings.border == 3 then
								dxDrawText(text, screenX, 0, screenX, screenY - lineY, tocolor(255, 255, 255, alpha), size, font, "center", "bottom", false, true, postGUI, true)
							end
							
							if getElementData(localPlayer, "nametag_settings").font == 2 or getElementData(localPlayer, "nametag_settings").font == 3 then
								sectionY = sectionY + 2
							end
							
							local textW = dxGetTextWidth(text:gsub("#%x%x%x%x%x%x", ""), scale, font) / 2
							
							local leftSectionX = 0
							if settings.country == 2 then
								local country = getElementData(player, "country") or 0
								dxDrawImage(screenX - textW - 38, screenY - sectionY - 32 + 2, 27, 13, "images/icons/country/" .. country .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
								leftSectionX = leftSectionX + 37
							end
							
							local donater = getElementData(player, "donater") or 0
							if donater > 0 then
								dxDrawImage(screenX - textW - 33 - leftSectionX, screenY - sectionY - 32 - 3, 23, 23, "images/icons/donater" .. donater .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
							end
							
							if getElementData(player, "writing") then
								dxDrawImage(screenX + textW + 10, screenY - sectionY - 32 - 3, 24, 24, "images/icons/writing.png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
							end
							
							if exports.cr_voice:getPlayerTalking(player) then
								dxDrawImage(screenX + textW + 10, screenY - sectionY - 32 - 3, 24, 24, "images/icons/microphone.png", 0, 0, 0, tocolor(255, 255, 255, alpha), postGUI)
							end
						end
					end
				end
			end
		end
	end
end
renderNametagsTimer = setTimer(renderNametags, 0, 0)

--===========================================================================================================================================================

addEventHandler("onClientElementDataChange", localPlayer, function(theKey, newValue, oldValue)
	if theKey == "nametag_settings" then
		settings = {
			font = getElementData(localPlayer, "nametag_settings").font or 1,
			type = getElementData(localPlayer, "nametag_settings").type or 1,
			id = getElementData(localPlayer, "nametag_settings").id or 1,
			border = getElementData(localPlayer, "nametag_settings").border or 1,
			country = getElementData(localPlayer, "nametag_settings").country or 1,
			icon = getElementData(localPlayer, "nametag_settings").icon or 1,
			placement = getElementData(localPlayer, "nametag_settings").placement or 1,
			toggleNametag = settings.toggleNametag,
		}
		
		if settings.font == 1 then
			font = "default-bold"
		elseif settings.font == 2 then
			font = exports.cr_fonts:getFont("sf-regular", fontSize)
		elseif settings.font == 3 then
			font = exports.cr_fonts:getFont("sf-bold", fontSize)
		elseif settings.font == 4 then
			font = "default"
		end
	end
end)

loadTimer = setTimer(function()
	if getElementData(localPlayer, "loggedin") == 1 then
		for _, value in pairs(exports.cr_items:getBadges()) do
			badges[value[1]] = {value[4][1], value[4][2], value[4][3], value[5]}
		end
		outputConsole("[NAMETAG] Rozet ayarları yüklendi.")
		
		for _, value in pairs(exports.cr_items:getMasks()) do
			masks[value[1]] = {value[1], value[2], value[3], value[4]}
		end
		outputConsole("[NAMETAG] Maske ayarları yüklendi.")
		
		killTimer(loadTimer)
	end
end, 1000, 0)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "player" then
        createCache(source)
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "player" then
        destroyCache(source)
    end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    settings = {
		font = getElementData(localPlayer, "nametag_settings").font or 1,
		type = getElementData(localPlayer, "nametag_settings").type or 1,
		id = getElementData(localPlayer, "nametag_settings").id or 1,
		border = getElementData(localPlayer, "nametag_settings").border or 1,
		country = getElementData(localPlayer, "nametag_settings").country or 1,
		icon = getElementData(localPlayer, "nametag_settings").icon or 1,
		placement = getElementData(localPlayer, "nametag_settings").placement or 1,
		toggleNametag = settings.toggleNametag,
	}
	
	if settings.font == 1 then
		font = "default-bold"
	elseif settings.font == 2 then
		font = exports.cr_fonts:getFont("sf-regular", fontSize)
	elseif settings.font == 3 then
		font = exports.cr_fonts:getFont("sf-bold", fontSize)
	elseif settings.font == 4 then
		font = "default"
	end
	
	for _, player in ipairs(getElementsByType("player")) do
        setPlayerNametagShowing(player, false)
		if isElementStreamedIn(player) then
            if getElementType(player) == "player" then
                createCache(player)
            end
        end
    end
end)

function createCache(element)
    if not players[element] then
        players[element] = true
    end
end

function destroyCache(element)
    if players[element] then
        players[element] = nil
    end
end

--===========================================================================================================================================================

local ox, oy, oz = getElementPosition(localPlayer)

setTimer(function()
    local screenX, screenY, nz = getElementPosition(localPlayer)
    if math.floor(ox) == math.floor(screenX) and math.floor(oy) == math.floor(screenY) and math.floor(oz) == math.floor(screenY) then
        setElementData(localPlayer, "afk", true)
        moveAfk = true
    else
        if moveAfk then
            if not clickAfk and not minimizeAfk then
                setElementData(localPlayer, "afk", false)
            end
        end
    end
    ox, oy, oz = screenX, screenY, nz
end, 30 * 1000, 0)

addEventHandler("onClientCursorMove", root, function(x, sectionY)
	if not isCursorShowing() then return end
	if getElementData(localPlayer, "afk") and not isMTAWindowActive() then
		setElementData(localPlayer, "afk", false)
	end
end)

addEventHandler("onClientMinimize", root, function()
	setElementData(localPlayer, "afk", true)
    minimizeAfk = true
	
	if isTimer(renderNametagsTimer) then
		killTimer(renderNametagsTimer)
	end
end)

addEventHandler("onClientRestore", root, function()
	setElementData(localPlayer, "afk", false)
    minimizeAfk = false
	
	if not isTimer(renderNametagsTimer) then
		renderNametagsTimer = setTimer(renderNametags, 0, 0)
	end
end)

--===========================================================================================================================================================

function getPlayerIcons(player, name)
	if getElementData(player, "loggedin") == 1 then
		local icons = {}
		local tinted = false
		local badge = nil

		if getElementData(player, "hiddenadmin") ~= 1 then
			if getElementData(player, "duty_supporter") == 1 and getElementData(player, "supporter_level") == 1 then		
				table.insert(icons, "duty/helper")				
			end

			if getElementData(player, "duty_admin") == 1 and getElementData(player, "admin_level") > 0 then		
				table.insert(icons, "duty/" .. getElementData(player, "admin_level"))
			end
		end

		local vehicle = getPedOccupiedVehicle(player)
		local windowsDown = vehicle and getElementData(vehicle, "vehicle:windowstat") == 1

		if vehicle and not windowsDown and vehicle ~= getPedOccupiedVehicle(localPlayer) and getElementData(vehicle, "tinted") then
			name = "Gizli (Cam Filmi) [>" .. getElementData(player, "dbid") .. "]"
			tinted = true
		end

		if not tinted then
			if getPlayerMaskState(player) then 
				name = "Gizli [>" .. getElementData(player, "dbid") .. "]"
			end

			if getElementData(player, "restrain") == 1 then
				table.insert(icons, "handcuffs")
			end
	        
	        if getElementData(player, "cellphoneGUItogNametagSynced") == 1 then
				table.insert(icons, "phone")
			end

			if getElementData(player, "smoking") then
				table.insert(icons, "cigarette")
			end

			if getElementData(player, "fullfacehelmet") then
				table.insert(icons, "helmet")
			end

			if getElementData(player, "gasmask") then
				table.insert(icons, "gasmask")
			end

			if getElementData(player, "seatbelt") and getPedOccupiedVehicle(player) then
				table.insert(icons, "seatbelt")
			end
		end

		if windowsDown and getPedOccupiedVehicle(player) then
			table.insert(icons, "window")
		end

		if getElementData(player, "vip") > 0 then
			table.insert(icons, "vip" .. getElementData(player, "vip"))
		end
		
		if settings.country == 1 then
			local country = getElementData(player, "country") or 0
			table.insert(icons, "country/-" .. country)
		end
		
		for k, v in pairs(badges) do
			local title = getElementData(player, k)
			if title then
				badge = title
				table.insert(icons, "badge")
			end
		end
		
		if getElementData(player, "tags") then
			for _, value in pairs(getElementData(player, "tags")) do
				table.insert(icons, "tags/" .. value)
			end
		end

		if getElementData(player, "youtuber") == 1 then
			table.insert(icons, "youtuber")
		end

		if getElementData(player, "rp_plus") == 1 then
			table.insert(icons, "rp_plus")
		end

		return name, icons, tinted, badge
	end
end

function aimsSniper()
	return getPedControlState(localPlayer, "aim_weapon") and (getPedWeapon(localPlayer) == 22 or getPedWeapon(localPlayer) == 23 or getPedWeapon(localPlayer) == 24 or getPedWeapon(localPlayer) == 25 or getPedWeapon(localPlayer) == 26 or getPedWeapon(localPlayer) == 27 or getPedWeapon(localPlayer) == 28 or getPedWeapon(localPlayer) == 29 or getPedWeapon(localPlayer) == 30 or getPedWeapon(localPlayer) == 31 or getPedWeapon(localPlayer) == 32 or getPedWeapon(localPlayer) == 33 or getPedWeapon(localPlayer) == 34)
end

function aimsAt(player)
	return getPedTarget(localPlayer) == player and aimsSniper()
end

function getBadgeColor(player)
	for k, v in pairs(badges) do
		if getElementData(player, k) then
			return unpack(badges[k])
		end
	end
end

function getPlayerMaskState(player)
	for index, value in pairs(masks) do
		if getElementData(player, value[1]) then
			return true
		end
	end
	return false
end

function getHealthColor(player)
	local color = "#9c9c9c"
	
	if getElementHealth(player) <= 30 then
		color = "#ff0000"
	elseif getElementHealth(player) <= 70 then
		color = "#ffd11a"
	else
		color = "#009432"
	end
	
	return color
end

function dxDrawBorderText(message, left, top, width, height, color, size, font, alignX, alignY, clip, wordBreak, postGUI)
    color, size, font, alignX, alignY, clip, wordBreak, postGUI = color or tocolor(255, 255, 255), size or 1, font or "default", alignX or "left", alignY or "top", clip or false, wordBreak or false, postGUI or false
    borderColor = tocolor(0, 0, 0)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left + 1, top + 1, width + 1, height + 1, borderColor, size, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left + 1, top - 1, width + 1, height - 1, borderColor, size, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left - 1, top + 1, width - 1, height + 1, borderColor, size, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message:gsub("#%x%x%x%x%x%x", ""), left - 1, top - 1, width - 1, height - 1, borderColor, size, font, alignX, alignY, clip, wordBreak, postGUI)
    dxDrawText(message, left, top, width, height, color, size, font, alignX, alignY, clip, wordBreak, postGUI, true)
end

function RGBToHex(red, green, blue, alpha)
	if ((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end

	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end
end

addCommandHandler("nametagkapat", function()
	outputChatBox("[!]#FFFFFF Nametag başarıyla " .. (false == settings.toggleNametag and "açıldı" or "kapatıldı") .. ", " .. (true == settings.toggleNametag and "açmak" or "kapatmak") .. " için tekrardan /nametagkapat yazınız.", 0, 255, 0, true)
	settings.toggleNametag = false == settings.toggleNametag and true or false
end)