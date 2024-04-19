Labels = {
    debug = false,
    screen = Vector2(guiGetScreenSize()),

    date = function()
		x = getRealTime();
		x.year = x.year + 1900;
		x.month = x.month + 1;
		
		if (x.monthday < 10) then 
			monthday = "0" .. x.monthday;
		else 
			monthday = x.monthday;
		end
	
		if (x.month < 10) then 
			month = "0" .. x.month;
		else 
			month = x.month;
		end 
	
		return tostring(monthday .. "/" .. month .. "/" .. x.year)
    end,

    index = function(self)
        framesPerSecond = 0
        framesDeltaTime = 0
        lastRenderTick = false 

        label = GuiLabel(0, 0, self.screen.x, 15, "", false) 
        label:setAlpha(0.5)
		
		servers = GuiLabel(0, 0, self.screen.x, 15, "", false) 
        servers:setAlpha(0.5)
    end,
}

instance = new(Labels)
instance:index()

addEventHandler("onClientRender", root, function()
	if getElementData(localPlayer, "loggedin") == 1 then
		local currentTick = getTickCount() 
		lastRenderTick = lastRenderTick or currentTick 
		framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick) 
		lastRenderTick = currentTick 
		framesPerSecond = framesPerSecond + 1
		
		local time = getRealTime()
		local hours = time.hour
		local minutes = time.minute
		local seconds = time.second

		local monthday = time.monthday
		local month = time.month
		local year = time.year
		
		local formattedTime = string.format("%02d/%02d/%04d", monthday, month + 1, year + 1900)
		local formattedHour = string.format("%02d:%02d:%02d", hours, minutes, seconds)
		
		local cdpData = getElementData(root, "cdp") or 0
		local totalCount = #getElementsByType("player") + cdpData
		local serverLabel = "█ CDP: " .. cdpData .. " + CRP: " .. #getElementsByType("player") .." = TOPLAM: " .. totalCount
		
		if framesDeltaTime >= 1000 then 
			ping = localPlayer:getPing()
			dbid = getElementData(localPlayer, "dbid") or 0
			
			label:setText("v" .. exports.cr_global:getScriptVersion() .. " — 【" .. framesPerSecond .. " fps " .. ping .. " ms】【" .. formattedTime .. " " .. formattedHour .. "】【ID: " .. (dbid or "yükleniyor...") .. "】")
			label:setSize(instance.screen.x - guiLabelGetTextExtent(label) + 5, 14, false)
			label:setPosition(instance.screen.x - guiLabelGetTextExtent(label) - 74, instance.screen.y - 15, false)
			
			servers:setText(serverLabel)
			servers:setSize(instance.screen.x - guiLabelGetTextExtent(servers) + 5, 14, false)
			servers:setPosition(5, instance.screen.y - 15, false)
			
			framesDeltaTime = framesDeltaTime - 1000 
            framesPerSecond = 0 + 0
		end
	end
end, true, "low-5")