local sx, sy = guiGetScreenSize()
local width, height = 300, 350
local x, y = (sx-width)/2, (sy-height)/2
local imgW, imgH = 155, 135

local roboto = exports.cr_fonts:getFont('UbuntuRegular', 9)
local font = exports.cr_fonts:getFont('UbuntuBold', 11)
local robotoL = exports.cr_fonts:getFont('UbuntuRegular', 11)
local activeTab = "outfit"

local maxRows = 7
local startIndex, endIndex = 1, maxRows

local tabs = {
	[1] = {name="Kıyafet",tab="outfit"},
	[2] = {name="Teçhizat",tab="equipment"},
	[3] = {name="Silah",tab="weapon"},
}

local show = false

local col = createColSphere(1581.580078125, -1683.587890625, 16.1953125, 3)

local col2 = createColSphere(347.115234375, 162.7978515625, 1014.1875, 3)
setElementInterior(col2, 3)
setElementDimension(col2, 293)

addCommandHandler("duty", function()
	if isElementWithinColShape(localPlayer, col) or isElementWithinColShape(localPlayer, col2) then
		local dutyLevel = getElementData(localPlayer, "duty")
		--local dutyseviye = getElementData(localPlayer, "custom_duty")
		dutyPerk = tonumber(getElementData(localPlayer, "custom_duty"))
		local pdFaction = getElementData(localPlayer, "faction")
		if not dutyLevel or dutyLevel == 0 or dutyPerk < 1 or not pdFaction == 1 then
			show = not show
			if dutyPerk > 0 then 
				show = true
			else
				show = false
			return end
			if show then 
				showCursor(true)
			else
				showCursor(false)
			end
		else
			if not show then
				show = false
				triggerServerEvent("customduty:offduty", localPlayer, localPlayer)
			else
				show = false
			end
		end
	end
end)

function onClientColShapeLeave( theElement, matchingDimension )
    if ( theElement == localPlayer ) then  -- Checks whether the leaving element is the local player
    	if show then
        	show = false
        	showCursor(false)
        end
    end
end
addEventHandler("onClientColShapeLeave", col, onClientColShapeLeave)

function onClientColShapeLeave2( theElement, matchingDimension )
    if ( theElement == localPlayer ) then  -- Checks whether the leaving element is the local player
    	if show then
        	show = false
        	showCursor(false)
        end
    end
end
addEventHandler("onClientColShapeLeave", col2, onClientColShapeLeave2)

skins = {
    {name="LSPD Tören Kıyafeti", id=296},
    {name="LSPD Beyaz Erkek #1", id=278},
    {name="LSPD Beyaz Erkek #2", id=279},
    {name="LSPD Beyaz Erkek #3", id=291},
    {name="LSPD Beyaz Erkek #4", id=280},
    {name="LSPD Beyaz Erkek #5", id=266},
    {name="LSPD Siyahi Erkek #1", id=290},
    {name="LSPD Siyahi Erkek #2", id=265},

    {name="LSPD Beyaz Kadın #1", id=281},
    {name="LSPD Beyaz Kadın #2", id=282},
    {name="LSPD Rütbeli Siyahi Kadın #1", id=287},
    {name="LSPD Rütbeli Beyaz Kadın #1", id=288},

    {name="Erkek Akademi Öğrencisi", id=302},
    {name="Kadın Akademi Öğrencisi", id=303},
	
    {name="Gang Unit Erkek", id=304},
	{name="SWAT Erkek I", id=301},
	{name="SWAT Erkek II", id=269},
	{name="SWAT Erkek III", id=268},
	{name="SWAT Kadın I", id=274},
	{name="SWAT Kadın II", id=298},
	{name="SWAT Kadın III", id=307},
}

equipments = {
	{name="Kelepçe", id = 45},
	{name="Teçhizat Kemeri", id = 126},
	{name="Telsiz", id = 6},
	{name="Gaz Maskesi", id = 26},
	{name="Door Ram", id = 29},
	{name="Kamera", id = 115, value = 43},
	{name="Jop", id = 115, value = 3},
}

weapons = {
	{name="Deagle", id=24},
	{name="Shotgun", id=25},
	{name="MP5", id=29},
	{name="M4", id=31},
	{name="Sniper", id=34},
	{name="Teargas", id=17},
}

addEventHandler("onClientRender", getRootElement(), function()
	if show then
		if (isCursorShowing() and isMoving) then
		    local cursorX, cursorY = getCursorPosition()

		    cursorX = cursorX * sx
		    cursorY = cursorY * sy
		    
		    x = cursorX - movingOffsetX
		    y = cursorY - movingOffsetY
		end

		dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 180))
		tabcount = 0
		for index, tabV in ipairs(tabs) do 
			tabcount = tabcount + 1
			dxDrawRectangle(x-87+(tabcount*87), y-26, 85, 25, tocolor(25, 25, 25, 180))
			if isInBox(x-87+(tabcount*87), y-26, 85, 25) then 
				dxDrawRectangle(x-87+(tabcount*87), y-26, 85, 25, tocolor(45, 45, 45, 150))
				if isClicked() then
					activeTab = tabV.tab
				end
			end

			dxDrawText(tabV.name, x-87+(tabcount*87), y-26, x-2+(tabcount*87), y-1, tocolor(255, 255, 255, 255), 1, roboto, "center", "center")
		end

		if activeTab == "outfit" then
			dxDrawText("LSPD - Kıyafet Arayüzü", x+12, y+10, x+width, y+height, tocolor(255, 255, 255, 255), 1, font, "left", "top")
			dxDrawLine(x + 10, y + 38, x + (width-10), y + 38, tocolor(135, 135, 135, 255))
			dxDrawRectangle(x + 10, y + 50, width-20, height-117, tocolor(0, 0, 0, 200))
			count = 0
			for index = startIndex, endIndex do
				local value = skins[index]
				count = count + 1
				dxDrawRectangle(x + 10, y + 15 + (count*34), width-20, 30, tocolor(45, 45, 45, 180))

				if isInBox(x + 10, y + 15 + (count*34), width-20, 30) then 
					dxDrawRectangle(x + 10, y + 15 + (count*34), width-20, 30, tocolor(45, 45, 45, 255))
					if isClicked() then
						triggerServerEvent("duty-ui:equipOutfit", localPlayer, localPlayer, skins[index].id)
					end
					dxDrawRectangle(x+15+width, y+(count*25), width/1.5, height/1.85, tocolor(0, 0, 0, 150))
					dxDrawImage(x+40+width, y+(count*25)+20, imgW, imgH, ":cr_items/images/skins/" .. string.format("%03d", skins[index].id) .. ".png")
				end

				if count ~= #skins then
					dxDrawRectangle(x + 10, y + 46 + (count*34), width-20, 2.5, tocolor(135, 135, 135, 200))
				end

				dxDrawText(value.name .. " (#" .. value.id .. ")", x + 15, y + 15 + (count*34), x + 10+width-20, y + 15 + (count*34)+30, tocolor(255, 255, 255, 255), 1, roboto, "left", "center")
			end
			dxDrawText("X", x+282, y-22, x, y, tocolor(255, 255, 255, 255), 1, roboto, "left", "top")
			if isInBox(x+275, y-22, x+15, y) then 
				if isClicked() then 
					showCursor(false)
					show = not show
				end
			end
			dxDrawText("LSPD Kıyafet arayüzüne hoşgeldiniz, \nbu arayüzden ihtiyacınız olan \nkıyafeti kuşanabilirsiniz.", x, y, x+width, y+height-10, tocolor(255, 255, 255, 255), 1, roboto, "center", "bottom")
		elseif activeTab == "equipment" then
			dxDrawText("LSPD - Teçhizat Arayüzü", x+12, y+10, x+width, y+height, tocolor(255, 255, 255, 255), 1, font, "left", "top")
			dxDrawLine(x + 10, y + 38, x + (width-10), y + 38, tocolor(135, 135, 135, 255))
			dxDrawRectangle(x + 10, y + 50, width-20, height-117, tocolor(0, 0, 0, 200))
			count = 0
			for index, value in pairs(equipments) do
				count = count + 1
				dxDrawRectangle(x + 10, y + 15 + (count*34), width-20, 30, tocolor(45, 45, 45, 180))

				if isInBox(x + 10, y + 15 + (count*34), width-20, 30) then 
					dxDrawRectangle(x + 10, y + 15 + (count*34), width-20, 30, tocolor(45, 45, 45, 255))
					if isClicked() then
						triggerServerEvent("duty-ui:giveItem", localPlayer, localPlayer, equipments[index].id, equipments[index].name, equipments[index].value)
					end
					dxDrawRectangle(x+15+width, y+(count*25), width/1.5, height/1.85, tocolor(0, 0, 0, 150))
					if equipments[index].value then
						dxDrawImage(x+40+width, y+(count*25)+20, imgW, imgH, ":cr_items/images/-" .. (equipments[index].value) .. ".png")
					else
						dxDrawImage(x+40+width, y+(count*25)+20, imgW, imgH, ":cr_items/images/" .. (equipments[index].id) .. ".png")
					end
				end

				if count ~= #equipments then
					dxDrawRectangle(x + 10, y + 46 + (count*34), width-20, 2.5, tocolor(135, 135, 135, 200))
				end

				dxDrawText(value.name .. " (#" .. (value.id) .. ")", x + 15, y + 15 + (count*34), x + 10+width-20, y + 15 + (count*34)+30, tocolor(255, 255, 255, 255), 1, roboto, "left", "center")
			end
			dxDrawText("X", x+282, y-22, x, y, tocolor(255, 255, 255, 255), 1, roboto, "left", "top")
			if isInBox(x+282, y-22, x, y) then 
				if isClicked() then 
					showCursor(false)
					show = not show
				end
			end
			dxDrawText("LSPD Teçhizat arayüzüne hoşgeldiniz, \nbu arayüzden ihtiyacınız olan \nteçhizat eşyasını kuşanabilirsiniz.", x, y, x+width, y+height-10, tocolor(255, 255, 255, 255), 1, roboto, "center", "bottom")
		elseif activeTab == "weapon" then
			dxDrawText("LSPD - Ateşli Silahlar Arayüzü", x+12, y+10, x+width, y+height, tocolor(255, 255, 255, 255), 1, font, "left", "top")
			dxDrawLine(x + 10, y + 38, x + (width-10), y + 38, tocolor(135, 135, 135, 255))
			dxDrawRectangle(x + 10, y + 50, width-20, height-117, tocolor(0, 0, 0, 200))
			count = 0
			for index, value in pairs(weapons) do
				count = count + 1
				dxDrawRectangle(x + 10, y + 15 + (count*34), width-20, 30, tocolor(45, 45, 45, 180))

				if isInBox(x + 10, y + 15 + (count*34), width-20, 30) then 
					dxDrawRectangle(x + 10, y + 15 + (count*34), width-20, 30, tocolor(45, 45, 45, 255))
					if isClicked() then
						triggerServerEvent("duty-ui:giveWeapon", localPlayer, localPlayer, weapons[index].id, weapons[index].name)
					end
					dxDrawRectangle(x+15+width, y+(count*25), width/1.5, height/1.85, tocolor(0, 0, 0, 150))
					dxDrawImage(x+40+width, y+(count*25)+20, imgW, imgH, ":cr_items/images/-" .. weapons[index].id .. ".png")
				end

				if count ~= #weapons then
					dxDrawRectangle(x + 10, y + 46 + (count*34), width-20, 2.5, tocolor(135, 135, 135, 200))
				end

				dxDrawText(value.name, x + 15, y + 15 + (count*34), x + 10+width-20, y + 15 + (count*34)+30, tocolor(255, 255, 255, 255), 1, roboto, "left", "center")
			end
			dxDrawText("X", x+282, y-22, x, y, tocolor(255, 255, 255, 255), 1, roboto, "left", "top")
			if isInBox(x+282, y-22, x, y) then 
				if isClicked() then 
					showCursor(false)
					show = not show
				end
			end
			dxDrawText("LSPD Silahlar arayüzüne hoşgeldiniz, \nbu arayüzden (ihtiyacınız olan) \ngörev silahını kuşanabilirsiniz.", x, y, x+width, y+height-10, tocolor(255, 255, 255, 255), 1, roboto, "center", "bottom")
		end
	end
end)

local lastClick = getTickCount()
function isClicked()
    if getKeyState("mouse1") and lastClick < getTickCount() then lastClick=getTickCount()+500 return true end
    return false
end

function isInBox(xS,yS,wS,hS)
	if (isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*sx, cursorY*sy
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
    if (x and y and w and h) then
        if (not borderColor) then
            borderColor = tocolor(0, 0, 0, 200);
        end
        
        if (not bgColor) then
            bgColor = borderColor;
        end
        
        --> Background
        dxDrawRectangle(x, y, w, h, bgColor, postGUI);
        
        --> Border
        dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI); -- top
        dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI); -- bottom
        dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI); -- left
        dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI); -- right
    end
end

addEventHandler("onClientClick",root,function(b,state,cursorX,cursorY)
    if not show then return end
    if b == "left" then
        if state == "down" and isInBox(x,y,width,20) and isClicked() then
            movingOffsetX = cursorX - x
            movingOffsetY = cursorY - y
            isMoving = true
        elseif state == "up" and isMoving then
            isMoving = nil
        end
    end
end)

addEventHandler("onClientKey",root,function(button, state)
    if not show then return end

    if button == "mouse_wheel_down" then
		startIndex=startIndex+1
		endIndex=endIndex+1

		if endIndex >= #skins then
			startIndex=#skins-maxRows+1
			endIndex=#skins
		end

	elseif button ==  "mouse_wheel_up" then

		startIndex=startIndex-1
		endIndex=endIndex-1

		if startIndex <= 1 then
			startIndex=1
			endIndex=maxRows	
		end
	end
end)