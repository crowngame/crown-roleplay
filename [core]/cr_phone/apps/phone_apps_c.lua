﻿apps = {
	"history",
	"contacts",
	"settings",
	--"safari",
	"messages",
	--"lsbank",
	"flappy-bird",
	--"spotify",
	"twitter",
}
appNames = {
	["history"] = "Arayan",
	["contacts"] = "Rehber",
	["settings"] = "Ayarlar",
	--["safari"] = "Safari",
	["messages"] = "Mesaj",
	--["lsbank"] = "Banka",
	["flappy-bird"] = "Bird",
	--["spotify"] = "Spotify",
	["twitter"] = "Twitter",
}

guiApps = {}
local maxAppsPerRow = 4
local appsMaxRows = 4
local iconSize = 40
local iconSpacing = 15
local btnAlpha = 0
function drawOneApp(appPane, appId, appName, xoffset, yoffset)
	if appPane and isElement(appPane) then
		if not xoffset then xoffset = 0 end
		if not yoffset then yoffset = 0 end
		local posX = 30+xoffset
		local posY = 100+yoffset

		guiApps[appId] = {}
		guiApps[appId][1] = guiCreateStaticImage(posX,posY,iconSize,iconSize,"images/" .. appName .. ".png",false,appPane)
		guiApps[appId][2] = guiCreateButton(posX,posY,iconSize,iconSize,"",false,appPane)


		x,y = guiGetPosition(guiApps[appId][1],false)
		guiApps[appId][3] = guiCreateLabel(x-3,y+14,iconSize+5,iconSize,convertString(appName),false,appPane)
		guiLabelSetHorizontalAlign(guiApps[appId][3], "center", true)
	    guiLabelSetVerticalAlign(guiApps[appId][3], "bottom")
	    guiSetEnabled(guiApps[appId][3],false)

		guiSetAlpha(guiApps[appId][2], btnAlpha)
		posX = posX + iconSize+iconSpacing
		return true
	end
end

guiPaneApps = {}

function drawOnePaneOfApps(paneId, xoffset, yoffset)
	if isPhoneGUICreated() then
		if not xoffset then xoffset = 0 end
		if not yoffset then yoffset = 0 end
		local itemsPerRow = 0
		local rows = 0
		local original_xoffset = xoffset
		guiPaneApps[paneId] = guiCreateScrollPane(30+xoffset, 10+yoffset, 221, 330, false, wPhoneMenu)
		for i = 1, #apps do 
			if drawOneApp(guiPaneApps[paneId], i, apps[i],  xoffset, yoffset) then
				itemsPerRow = itemsPerRow + 1
				xoffset = xoffset + iconSpacing + iconSize
				if itemsPerRow >= maxAppsPerRow then
					itemsPerRow = 0
					rows = rows + 1
					yoffset = yoffset + iconSpacing + iconSize + 7
					xoffset = original_xoffset
					if rows >= appsMaxRows then
						break
					end
				end
			end
		end
		return guiPaneApps[paneId]
	end
end

function drawAllPaneOfApps(xoffset, yoffset)
	if not xoffset then xoffset = 0 end
	if not yoffset then yoffset = 0 end
	if isPhoneGUICreated() and #apps > 0 then
		if #apps > 12 then
			maxAppsPerRow = 4
			appsMaxRows = 5
			iconSize = 48
		end
		local maxAppsPerPane = maxAppsPerRow*appsMaxRows
		local numberOfPanes = math.ceil(#apps/maxAppsPerPane)
		for i = 1, numberOfPanes do
			addEventHandler("onClientGUIClick", drawOnePaneOfApps(i, xoffset, yoffset), clientClickApp)
		end
		if numberOfPanes > 1 then
			--Draw switch arrows but will make later.
		end
	end
end

function togglePanesOfApps(state)
	local didIt = nil
	if guiPaneApps[1] and isElement(guiPaneApps[1]) then
		for i, pane in pairs(guiPaneApps) do
			didIt = guiSetVisible(pane, state)
		end
	end
	return didIt
end

function clientClickApp()
	if isPhoneGUICreated() then
		for i = 1, #apps do
			if source == guiApps[i][2] then
				local clickedAppName = apps[i]
				if clickedAppName == "history" then
					toggleOffEverything()
					toggleHistory(true)
				elseif clickedAppName == "contacts" then
					guiSetEnabled(wPhoneMenu, false)
					if not contactList[phone] then
						triggerServerEvent("phone:requestContacts", localPlayer, phone)
					else
						openPhoneContacts(contactList[phone])
					end
				elseif clickedAppName == "power_off" then
					powerOffPhone()
				elseif clickedAppName == "settings" then
					toggleOffEverything()
					settingPageActive = true
					toggleSettingsGUI(true)
				elseif clickedAppName == "hotlines" then
					toggleOffEverything()
					toggleHotlines(true)
				elseif clickedAppName == "messages" then
					toggleOffEverything()
					--drawOneSMSThread()
					drawAllSMSThreads()
				elseif clickedAppName == "safari" then
					toggleOffEverything()
					toggleSafari(true)
				elseif clickedAppName == "flappy-bird" then
					toggleOffEverything()
					toggleFlappyBird(true)
				--elseif clickedAppName == "lsbank" then
					--toggleOffEverything()
					--toggleLSBank(true)
				elseif clickedAppName == "ilgl" then
					toggleOffEverything()
					toggleIllegal(true)
				elseif clickedAppName == "taksi" then
					toggleOffEverything()
					toggleUber(true)
				elseif clickedAppName == "twitter" then
					toggleOffEverything()
					toggleTwitter(true)
				--elseif clickedAppName == "spotify" then
					--toggleOffEverything()
					--toggleSpotify(true)
				end
				break
			end
		end
	end
end


function convertString(_name)
	return appNames[_name]
end
