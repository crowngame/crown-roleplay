local fonts = {
	[1] = exports.cr_fonts:getFont("UbuntuRegular", 10),
	[2] = exports.cr_fonts:getFont("UbuntuRegular", 10),
	[3] = exports.cr_fonts:getFont("UbuntuRegular", 10),
	[4] = exports.cr_fonts:getFont("UbuntuRegular", 10),
	[5] = exports.cr_fonts:getFont("UbuntuRegular", 9),
	[6] = exports.cr_fonts:getFont("UbuntuRegular", 10),
	[7] = exports.cr_fonts:getFont("UbuntuRegular", 10),
	[8] = exports.cr_fonts:getFont("UbuntuRegular", 10),
	[9] = exports.cr_fonts:getFont("UbuntuRegular", 9),
	[10] = exports.cr_fonts:getFont("FontAwesome", 10),
	[11] = exports.cr_fonts:getFont("UbuntuRegular", 10),
	[12] = exports.cr_fonts:getFont("UbuntuRegular", 9),
}

twitterActive = false
local currentRow, maxRow = 1, 5
local lastClick = 0
local Cache = {}
function toggleTwitter(bool)
	twitterActive = bool
	if twitterActive then
		addEventHandler("onClientRender", root, drawTwitter)
		guiSetInputEnabled(true)
		edit = guiCreateEdit(30, 80, 205, 25, "", false, wPhoneMenu)
		guiEditSetMaxLength(edit, 32)
		setElementData(edit, "disabledDX", true)
		--triggerServerEvent("twitter:cache", localPlayer, localPlayer)
	else
		removeEventHandler("onClientRender", root, drawTwitter)
		guiSetInputEnabled(false)
		if isElement(edit) then
			destroyElement(edit)
		end
	end
end

guiSetInputEnabled(false)

function addListener(event, func)
    addEvent(event, true)
    addEventHandler(event, root, func)
end

addListener("SyncTwitterCache",
	function(dat)
		Cache = dat
	end
)

function hasAccess(player, hashKey)
    for i, v in ipairs(Cache) do
        if tonumber(v.hashKey) == tonumber(hashKey) then
            if tonumber(v.creator) == tonumber(getElementData(player, "dbid")) then
                return true
            end
        end
    end
    if exports.cr_integration:isPlayerManagement(player) and getElementData(player, "duty_admin") == 1 then
        return true
    end
    return false
end

function getTwitterStamp(tim)
	local now = getRealTime()
	time = tim[1]
	if not time.hour or not time.minute then return "" end

	
	if (now.hour == time.hour) and (now.minute == time.minute) and (now.second > time.second) then
		return (math.floor(now.second-time.second)) .. " saniye önce"
	elseif (now.hour == time.hour) and (now.minute == time.minute) then
		return "Şimdi"
	elseif (now.hour == time.hour) and (now.minute > time.minute) then
		return (math.floor(now.minute-time.minute)) .. " dk önce"
	
	elseif (now.hour > time.hour) then
		return (math.floor(now.hour-time.hour)) .. " saat önce"
	else
		return ""
	end
end

function count(table)
	if not table then return 0 end
	--if type(table) == "string" then return 0 end

	local counter = 0
	for i, v in pairs(table) do
		counter = counter + 1
	end
	return counter
end

local totalHeight = 0
local auth = {}
local alphas = {}

function drawTwitter()
	if not twitterActive then
		removeEventHandler("onClientRender", root, drawTwitter)
		return
	end
	local twitterFlow = Cache or {}
	local x, y = guiGetPosition(wPhoneMenu, false)
	local defX, defY = x, y
	local x, y = x + 30, y + 120
	if currentRow > 1 then
		y = y - 50
		maxRow = 6
		guiSetAlpha(edit, 0)
	else
		dxDrawText("Bir şeyler yaz ve 'ENTER'la", x+19, y-63, 210, 25, tocolor(255, 255, 255), 1, fonts[5], "left", "top")
		guiSetAlpha(edit, 1)
		
	end
	flowCount = count(twitterFlow) or 0
	if flowCount < maxRow and currentRow >= 5 then
		currentRow = 1
	end
	if getKeyState("enter") and lastClick+500 <= getTickCount() and not isConsoleActive() then
		lastClick = getTickCount()
		local tweetText = guiGetText(edit)
		if tweetText ~= "" then
			local playerX, playerY, playerZ = getElementPosition(localPlayer)
			local zone = getZoneName(playerX, playerY, playerZ)
			local playerName = "@" .. (getPlayerName(localPlayer):gsub("_", "")):lower()
			guiSetText(edit, "")
			triggerServerEvent("twitter:add", localPlayer, localPlayer, playerName, zone, tweetText)
		end
	end

	if flowCount == 0 then
		dxDrawText("Buralar boş...\nHadi, ilk tweeti sen oluştur!", defX, defY, w+defX, h+defY, tocolor(255, 255, 255), 1, fonts[11], "center", "center")
	else
		
		local getFlow = (twitterFlow)
		local flowTable = {}
		for i, v in pairs(getFlow) do
			flowTable[#flowTable + 1] = v
		end
		table.sort(flowTable,
			function(a, b)
				local indexOne = tonumber(a.sortIndex)
				local indexTwo = tonumber(b.sortIndex)
				return indexOne > indexTwo
			end
		)
		local counter = 0
		--inside
		local totalHeight = 0
		local maxRow = 6
		local latestRow = currentRow + maxRow - 1
		for i, v in pairs(flowTable) do
			counter = counter + 1
			if counter >= currentRow and counter <= latestRow then
				if v.retweeter then
					totalHeight = totalHeight + 45
				else
					totalHeight = totalHeight + 45
				end
			end
		end
		if currentRow > 1 then
			maxRow = math.floor(315/39)
			if totalHeight >= 200 then maxRow = maxRow - 1 end
			if totalHeight >= 210 then maxRow = maxRow - 1 end
			if totalHeight >= 220 then maxRow = maxRow - 1 end
		else
			maxRow = math.floor(315/39)
			if totalHeight > 200 then maxRow = maxRow - 1 end
			if totalHeight > 180 then maxRow = maxRow - 2 end
			if totalHeight == 200 and maxRow == 5 then maxRow = maxRow + 1 end
		
		end
		local latestRow = currentRow + maxRow - 1
		local counter = 0
		for i, v in pairs(flowTable) do
			counter = counter + 1
			
			if counter >= currentRow and counter <= latestRow then
				if not alphas[v.hashKey] then alphas[v.hashKey] = 1 end
				if alphas[v.hashKey] ~= 10 then
					local currentTick = getTickCount()
					if alphas[v.hashKey] < 10 then
						alphas[v.hashKey] = alphas[v.hashKey] + 1
					end
				end
				currentAlpha = alphas[v.hashKey]/10 or 0

				if v.retweeter then
					dxDrawText(" " .. v.retweeter.data.name .. " (" .. getTwitterStamp(v.time) .. ")", x, y, w, h, tocolor(255,255,255, 100*currentAlpha), 1, fonts[10], "left", "top")
					y = y + 15
				else
					dxDrawText(getTwitterStamp(v.time), x, y, w, h, tocolor(255,255,255, 100*currentAlpha), 1, fonts[10], "left", "top")
					y = y + 15
					
				end
				dxDrawText(v.charname, x, y, w, h, tocolor(255,255,255,255*currentAlpha), 1, fonts[12], "left", "top")
				dxDrawText(v.name, x+dxGetTextWidth(v.charname,1,fonts[12])+3, y, w, h, tocolor(255,255,255, 100*currentAlpha), 1, fonts[5], "left", "top")
				dxDrawText(v.text, x, y+15, w, h, tocolor(255,255,255,255*currentAlpha), 1, fonts[9], "left", "top", false, false, false, true)
				
				--interactive button system:
				for i=0, 2 do
					buttonW, buttonH = 210/2.6, 20
					letX, letY, letW, letH = x+(i*buttonW)-21, y+33, buttonW, buttonH
					if (tonumber(i) == 0) then
						--@retweet system
						dxDrawText(" " .. count(v.data.retweet), letX, letY, letW+letX, letH+letY, tocolor(225, 225, 225, 255*currentAlpha), 1, fonts[10], "center", "top")
						if exports.cr_ui:isInBox(letX, letY, letW, letH) then
							if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
								lastClick = getTickCount()
								triggerServerEvent("twitter:retweet", localPlayer, localPlayer, v.hashKey)
							end
						end
					elseif (tonumber(i) == 1) then
						--@like system
						dxDrawText(" " .. count(v.data.like), letX, letY, letW+letX, letH+letY, tocolor(225, 225, 225, 255*currentAlpha), 1, fonts[10], "center", "top")
						if exports.cr_ui:isInBox(letX, letY, letW, letH) then
							if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
								lastClick = getTickCount()
								triggerServerEvent("twitter:like", localPlayer, localPlayer, v.hashKey)
							end
						end
					elseif (tonumber(i) == 2) then
						--@save system
						dxDrawText(" " .. count(v.data.save), letX, letY, letW+letX, letH+letY, tocolor(225, 225, 225, 255*currentAlpha), 1, fonts[10], "center", "top")
						if exports.cr_ui:isInBox(letX, letY, letW, letH) then
							if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
								lastClick = getTickCount()
								triggerServerEvent("twitter:save", localPlayer, localPlayer, v.hashKey)
							end
						end
					end
				end
				if hasAccess(localPlayer, v.hashKey) then
					if not auth[v.hashKey] then
						dxDrawText("", x+200, y, w, h, tocolor(255, 255, 255, 255*currentAlpha), 1, fonts[10], "left", "top")
					else
						dxDrawText("", x+200, y, w, h, tocolor(232, 65, 24, 255*currentAlpha), 1, fonts[10], "left", "top")
					end
					if exports.cr_ui:isInBox(x+195, y, 15, 15) then
						if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
							lastClick = getTickCount()
							if not auth[v.hashKey] then
								auth[v.hashKey] = true
							else
								triggerServerEvent("twitter:remove", localPlayer, localPlayer, v.hashKey)
							end
						end
					end
				end
				dxDrawLine(defX+20, y+54, defX+w - 20, y+54, tocolor(255, 255, 255, 50*currentAlpha), 1)
				y = y + 60
			end
		end
	end
end

addEventHandler("onClientKey", root, function(k, s)
	if s and twitterActive then
		if k == "mouse_wheel_down" then
			if currentRow < flowCount - (maxRow - 1) then
				currentRow = currentRow + 1
			end
		elseif k == "mouse_wheel_up" then
			if currentRow > 1 then
				currentRow = currentRow - 1
			end
		end
	end
end)