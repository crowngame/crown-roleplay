wItems, gWallet, gItems, gKeys, colSlot, colName, colValue, items, lDescription, bDropItem, bUseItem, bShowItem, bDestroyItem, tabPanel, tabWallet, tabItems, tabWeapons = nil
gWeapons, colWSlot, colWName, colWValue = nil

wRightClick = nil
bPickup, bToggle, bPreviousTrack, bNextTrack, bCloseMenu = nil
ax, ay = nil
item = nil
showinvPlayer = nil
setElementData(localPlayer, "exclusiveGUI", false, false) -- setting this to false prevents possible problems with fridge/shelf inv. 

showFood = true
showKeys = true
showDrugs = true
showOther = true
showBooks = true
showClothes = true
showElectronics = true
showEmpty = true
activeTab = 1

-- PLEASE WAIT window
local sx, sy = guiGetScreenSize()
wWait = guiCreateButton((sx - 200) / 2, (sy - 60) / 2, 200, 60, "Lütfen Bekleyin...", false)
guiSetEnabled(wWait, false)
guiSetVisible(wWait, false)
guiSetProperty(wWait, "AlwaysOnTop", "True")

--[[function clickItem(button, state, absX, absY, x, y, z, element)
	if (button == "right") and (state=="down") then
		if getElementData(localPlayer, "exclusiveGUI") then
			return
		end
		
		local px, py, pz = getElementPosition(localPlayer)
		if element and (getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("cr_map-system")) or getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("cr_interior_system"))) then
			element = nil
		end
		
		if not element then
			local wx, wy, wz = x, y, z
			local x, y, z = nil
			for key, value in ipairs(getElementsByType("object",getResourceRootElement())) do
				if isElementStreamedIn(value) then
					x, y, z = getElementPosition(value)
					local minx, miny, minz, maxx, maxy, maxz = getElementBoundingBox(value)
					
					local offset = 0.34
					
					minx = x + minx - offset
					miny = y + miny - offset
					minz = z + minz - offset
					
					maxx = x + maxx + offset
					maxy = y + maxy + offset
					maxz = z + maxz + offset
					
					local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
					
					if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
						element = value
						break
					end
				end
			end
		end
			
		if element and getElementParent(getElementParent(element)) == getResourceRootElement() then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 3 then
				if (wRightClick) then
					hideItemMenu()
				end
				ax = absX
				ay = absY
				item = element
				showItemMenu()
			else
				outputChatBox("You are too far away from that item.", 255, 0, 0)
			end
		else
			if (wRightClick) then
				hideItemMenu()
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickItem, true)]]

local delayedGBUpdate = nil

function showItemMenu(element, absX, absY)
	if isElement(element) then item = element; ax = absX; ay = absY end
	if not wRightClick then
	local itemID = getElementData(item, "itemID")
	local itemValue = getElementData(item, "itemValue") or 1
	local itemName = getItemName(itemID, itemValue)
	
	if itemID ~= 80 or itemID ~= 214 then
		itemName = itemName .. " (" .. getItemValue(itemID, itemValue) .. ")"
	end
	wRightClick = guiCreateWindow(ax, ay, 150, 200, itemName, false)
	
	local y = 0.13
	if itemID == 81 or itemID == 103 then
		bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Aç", true, wRightClick)
		addEventHandler("onClientGUIClick", bPickup,
			function(button)
				if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
					triggerServerEvent("openFreakinInventory", localPlayer, item, ax, ay)
					hideItemMenu()
				end
			end,
			false
		)
	else
		bPickup = guiCreateButton(0.05, y, 0.9, 0.1, "Öğeyi Al", true, wRightClick)
		addEventHandler("onClientGUIClick", bPickup, pickupItem, false)
	end
	y = y + 0.14
	
	if itemID == 54 then
		bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.15, "Önceki İstasyon", true, wRightClick)
		addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, -1) end, false)
		
		bNextTrack = guiCreateButton(0.53, y, 0.42, 0.15, "Sonraki İstasyon", true, wRightClick)
		addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, 1) end, false)
	
		y = y + 0.18

		-- volume
		local sVolume = guiCreateScrollBar(0.05, y, 0.9, 0.1, true, true, wRightClick)
		guiSetProperty(sVolume, 'StepSize', '0.1')

		local value = split(tostring(itemValue), ':')
		guiScrollBarSetScrollPosition(sVolume, tonumber(value[2]) or 100)
		addEventHandler('onClientGUIScroll', sVolume,
			function()
				if delayedGBUpdate then
					killTimer(delayedGBUpdate)
				end

				delayedGBUpdate = setTimer(
					function(val)
						triggerServerEvent("changeGhettoblasterVolume", item, val)
						delayedGBUpdate = nil
					end, 500, 1, guiScrollBarGetScrollPosition(source))
			end, false)
	end

	if itemID == 176 then
		bPreviousTrack = guiCreateButton(0.05, y, 0.42, 0.15, "Önceki İstasyon", true, wRightClick)
		addEventHandler("onClientGUIClick", bPreviousTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, -1) end, false)
		
		bNextTrack = guiCreateButton(0.53, y, 0.42, 0.15, "Sonraki İstasyon", true, wRightClick)
		addEventHandler("onClientGUIClick", bNextTrack, function() triggerServerEvent("changeGhettoblasterTrack", localPlayer, item, 1) end, false)
	
		y = y + 0.18

		-- volume
		local sVolume = guiCreateScrollBar(0.05, y, 0.9, 0.1, true, true, wRightClick)
		guiSetProperty(sVolume, 'StepSize', '0.1')

		local value = split(tostring(itemValue), ':')
		guiScrollBarSetScrollPosition(sVolume, tonumber(value[2]) or 100)
		addEventHandler('onClientGUIScroll', sVolume,
			function()
				if delayedGBUpdate then
					killTimer(delayedGBUpdate)
				end

				delayedGBUpdate = setTimer(
					function(val)
						triggerServerEvent("changeGhettoblasterVolume", item, val)
						delayedGBUpdate = nil
					end, 500, 1, guiScrollBarGetScrollPosition(source))
			end, false)
	end

	y = y + 0.14
	
	bCloseMenu = guiCreateButton(0.05, y, 0.9, 0.1, "Menüyü Kapat", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideItemMenu, false)
	end
end
addEvent('item:showMenu', false)
addEventHandler("item:showMenu", localPlayer, showItemMenu)

function hideItemMenu()
	if (isElement(bPickup)) then
		destroyElement(bPickup)
	end
	bPickup = nil

	if (isElement(bToggle)) then
		destroyElement(bToggle)
	end
	bToggle = nil

	if (isElement(bPreviousTrack)) then
		destroyElement(bPreviousTrack)
	end
	bPreviousTrack = nil

	if (isElement(bNextTrack)) then
		destroyElement(bNextTrack)
	end
	bNextTrack = nil

	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if delayedGBUpdate then
		killTimer(delayedGBUpdate)
		delayedGBUpdate = nil
	end
	
	ax = nil
	ay = nil

	item = nil

	showCursor(false)
	triggerEvent("cursorHide", localPlayer)
end

function updateMenu(dataname)
	if source == item and dataname == "itemValue" and (getElementData(source, "itemID") == 54 or getElementData(source, "itemID") == 176) then -- update the track while you're in menu
		guiSetText(wRightClick, "Ghettoblaster (" .. (getElementData(source, "itemValue") or 1) .. ")")
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateMenu)

function toggleGhettoblaster(button, state, absX, absY, step)
	triggerServerEvent("toggleGhettoblaster", localPlayer, item)
	hideItemMenu()
end

fp = -100
addCommandHandler("itemprotect",
	function(command, f)
		fp = tonumber(f) or -100
		--exports.cr_hud:sendBottomNotification(localPlayer, "Protect set to faction: " .. (fp == -100 and "admins only" or tostring(fp)))
	end
)

local pickupTimer = nil --Farid
function pickupItem(button, state, item)
	if (button=="left") then
		local restrain = getElementData(localPlayer, "restrain")
		
		if (restrain) and (restrain==1) then
			--exports.cr_hud:sendBottomNotification(localPlayer, "Pick up item failed", "You are cuffed.", 255, 0, 0)
		elseif getElementData(item, "itemID") > 0 and not hasSpaceForItem(localPlayer, getElementData(item, "itemID"), getElementData(item, "itemValue")) then
			--exports.cr_hud:sendBottomNotification(localPlayer, "Pick up item failed", "Your Inventory is full. " .. ("%.2f/%.2f"):format(getCarriedWeight(localPlayer), getMaxWeight(localPlayer)) .. " kg(s)." , 255, 0, 0)
		elseif isElement(item) then
			if wRightClick then
				showCursor(false)
				triggerEvent("cursorHide", localPlayer)
			end
			
			if getKeyState("p") then
				-- don't pick it up otherwise
				if exports.cr_global:isStaffOnDuty(localPlayer) then
					triggerServerEvent("protectItem", item, fp)
				end
			elseif getKeyState("n") then
				-- don't pick it up otherwise
				if exports.cr_global:isStaffOnDuty(localPlayer) or (getElementDimension(localPlayer) ~= 0 and hasItem(localPlayer, 4, getElementDimension(localPlayer)) or hasItem(localPlayer, 5, getElementDimension(localPlayer))) then
					triggerEvent("item:move", root, item)
				end
			else
				if getElementData(item, "transfering") then
					return --outputDebugString("[ITEM] pickupItem / Client / Cancelled by pick up cooldown.")
				end
				triggerServerEvent("pickupItem", localPlayer, item)
			end

			if wRightClick then
				hideItemMenu()
			end
		end
	end
end

addEvent('item:move:protect', true)
addEventHandler('item:move:protect', root,
	function()
		triggerServerEvent("protectItem", source, fp)
	end)
	
function toggleCategory()
	-- let's add the items again
	if (isElement(gWallet)) then
		guiGridListClear(gWallet)
	end
	
	if (isElement(gItems)) then
		guiGridListClear(gItems)
	end
	
	if (isElement(gKeys)) then
		guiGridListClear(gKeys)
	end
	
	if (isElement(gWeapons)) then
		guiGridListClear(gWeapons)
	end
	
	local items = getItems(showinvPlayer)
	
	local tabs = {gWallet, gItems, gKeys, gWeapons}
	for i,v in ipairs(items) do
		local itemid = v[1]
		local itemvalue = v[2]
		local tab = tabs[getItemTab(itemid)]
		local row = guiGridListAddRow(tab)
		guiGridListSetItemText(tab, row, colSlot, tostring(row+1), false, true)
		guiGridListSetItemData(tab, row, colSlot, tostring(i))
		guiGridListSetItemText(tab, row, colName, tostring(getItemName(itemid, itemvalue)), false, false)
		if tab ~= gWeapons then
			guiGridListSetItemText(tab, row, colValue, tostring(getItemValue(itemid, itemvalue)), false, false)
			guiGridListSetItemData(tab, row, colValue, tostring(itemvalue))
		else
			guiGridListSetItemText(tab, row, colValue, tostring(explode(":", itemvalue)[2]), false, false)
			guiGridListSetItemData(tab, row, colValue, tostring(explode(":", itemvalue)[2]))
			
			local silahHak = #tostring(explode(":", itemvalue)[6])>0 and explode(":", itemvalue)[6] or 3
			silahHak = not restrictedWeapons[tonumber(explode(":", itemvalue)[1])] and silahHak or "-"

			local checkString = string.sub(getItemName(itemid, itemvalue), -4)
			if (checkString == " (D)")  then
				silahHak = "-"
			end
			
			silahHak = itemid == 115 and silahHak or "-"
			guiGridListSetItemText(tab, row, 4, silahHak, false, false)
		end
	end
end

function toggleInventory()
	if wItems and guiGetEnabled(wItems) then
		hideInventory()
	end
end
bindKey("i", "down", toggleInventory)

function copyClipboard()
	local row, col = guiGridListGetSelectedItem(source)
	local text = guiGridListGetItemData(source, row, colValue)
	if setClipboard(text) then
		--exports.cr_hud:sendBottomNotification(localPlayer, "Copying", "Copied '" .. text .. "' to clipboard.")
	else
		--exports.cr_hud:sendBottomNotification(localPlayer, "Copying", "Failed copying '" .. text .. "' to clipboard.")
	end
end

function showInventory(player)
	if not (wItems) then
		showinvPlayer = player
		if wItems then
			hideInventory()
		end
		if getElementData(localPlayer, "exclusiveGUI") then
			return
		end
		setElementData(localPlayer, "exclusiveGUI", true, false)
		local width, height = 600, 500
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		local title = "Envanter"
		if player ~= localPlayer then
			title = getPlayerName(player) .. "'in Envanteri"
		end
		wItems = guiCreateWindow(x, y, width, height, title, false)
		guiWindowSetSizable(wItems, false)
		
		tabPanel = guiCreateTabPanel(0.025, 0.05, 0.95, 0.7, true, wItems)
		tabWallet = guiCreateTab("Cüzdan", tabPanel)
		tabItems = guiCreateTab("Envanter", tabPanel)
		tabKeys = guiCreateTab("Anahtarlar", tabPanel)
		tabWeapons = guiCreateTab("Silahlar", tabPanel)
		
		if activeTab == 1 then
			guiSetSelectedTab(tabPanel, tabWallet)
		elseif activeTab == 2 then
			guiSetSelectedTab(tabPanel, tabItems)
		elseif activeTab == 3 then
			guiSetSelectedTab(tabPanel, tabKeys)
		elseif activeTab == 4 then
			guiSetSelectedTab(tabPanel, tabWeapons)
		end
		
		addEventHandler("onClientGUITabSwitched", tabPanel,
			function(tab)
				if tab == tabWallet then
					activeTab = 1
				elseif tab == tabItems then
					activeTab = 2
				elseif tab == tabKeys then
					activeTab = 3
				elseif tab == tabWeapons then
					activeTab = 4
				end
			end,
			false)
		
		-- WALLET
		gWallet = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWallet)
		addEventHandler("onClientGUIClick", gWallet, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gWallet, copyClipboard, false)
		
		colSlot = guiGridListAddColumn(gWallet, "Slot", 0.1)
		colName = guiGridListAddColumn(gWallet, "Adı", 0.225)
		colValue = guiGridListAddColumn(gWallet, "Değeri", 0.625)
		
		-- ITEMS
		gItems = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabItems)
		addEventHandler("onClientGUIClick", gItems, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gItems, copyClipboard, false)
		
		colSlot = guiGridListAddColumn(gItems, "Slot", 0.1)
		colName = guiGridListAddColumn(gItems, "Adı", 0.225)
		colValue = guiGridListAddColumn(gItems, "Değeri", 0.625)
		
		-- keys
		gKeys = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabKeys)
		addEventHandler("onClientGUIClick", gKeys, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gKeys, copyClipboard, false)
	
		colSlot = guiGridListAddColumn(gKeys, "Slot", 0.1)
		colName = guiGridListAddColumn(gKeys, "Adı", 0.625)
		colValue = guiGridListAddColumn(gKeys, "Değeri", 0.225)

		-- WEAPONS
		gWeapons = guiCreateGridList(0.025, 0.05, 0.95, 0.9, true, tabWeapons)
		addEventHandler("onClientGUIClick", gWeapons, showDescription, false)
		addEventHandler("onClientGUIDoubleClick", gWeapons, copyClipboard, false)
		
		colWSlot = guiGridListAddColumn(gWeapons, "Slot", 0.1)
		colWName = guiGridListAddColumn(gWeapons, "Adı", 0.225)
		colWValue = guiGridListAddColumn(gWeapons, "Değeri", 0.325)
		colWSilahHakki = guiGridListAddColumn(gWeapons, "Silah Hakkı", 0.225)
		
		-- GENERAL
		lDescription = guiCreateLabel(0.025, 0.87, 0.95, 0.1, "Açıklamasını görmek için bir öğeye tıklayın.", true, wItems)
		guiLabelSetHorizontalAlign(lDescription, "center", true)
		guiSetFont(lDescription, "default-bold-small")
		
		bClose = guiCreateButton(0.375, 0.91, 0.2, 0.15, "Envanteri Kapat", true, wItems)
		addEventHandler("onClientGUIClick", bClose, hideInventory, false)
		
		source = nil
		toggleCategory()
		showCursor(true)
	end
end
addEvent("showInventory", true)
addEventHandler("showInventory", getRootElement(), showInventory)

function hideInventory()
	colSlot = nil
	colName = nil
	colValue = nil
	
	colWSlot = nil
	colWName = nil
	colWValue = nil
	colWSilahHakki = nil
	
	if wItems then
		destroyElement(wItems)
	end
	wItems = nil
	
	showCursor(false)
	setElementData(localPlayer, "exclusiveGUI", false, false)
	
	hideNewInventory()
end
addEvent("hideInventory", true)
addEventHandler("hideInventory", getRootElement(), hideInventory)

function showDescription(button, state)
	if (button=="left") then
		if (guiGetSelectedTab(tabPanel)==tabItems or guiGetSelectedTab(tabPanel)==tabKeys) then -- ITEMS
			local row, col = guiGridListGetSelectedItem(guiGetSelectedTab(tabPanel) == tabKeys and gKeys or gItems)
			
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Açıklamasını görmek için bir öğeye tıklayın.")
			else
				local slot = tonumber(guiGridListGetItemData(guiGetSelectedTab(tabPanel) == tabKeys and gKeys or gItems, row, 1))
				local items = getItems(showinvPlayer)
				if not items[slot] then
					guiSetText(lDescription, "Boş bir yuva.")
				end
			end
		elseif (guiGetSelectedTab(tabPanel)==tabWeapons) then -- WEAPONS
			local row, col = guiGridListGetSelectedItem(gWeapons)
			if (row==-1) or (col==-1) then
				guiSetText(lDescription, "Açıklamasını görmek için bir öğeye tıklayın.")
			else
				local name = tostring(guiGridListGetItemText(gWeapons, row, 2))
				local ammo = tostring(guiGridListGetItemText(gWeapons, row, 3))
				local desc = "A " .. name .. " with " .. ammo .. " ammunition."
					
				guiSetText(lDescription, desc)
			end
		end
	end
end

function useItem(itemSlot)
--function useItem(button)
	showinvPlayer = localPlayer
	if getElementHealth(localPlayer) == 0 then return end
	local x, y, z = getElementPosition(localPlayer)
	local groundz = getGroundPosition(x, y, z)
	if itemSlot > 0 then -- ITEMS
		local item = getItems(showinvPlayer)[itemSlot]
		local itemID = item[1]
		local itemName = getItemName(itemID)
		local itemValue = item[2]
		local additional = nil
		if (itemID==2) then -- cellphone
			hideInventory()
			triggerEvent("phone:slidePhoneIn", localPlayer, itemValue)
			return
		elseif (itemID==6) then -- radio
			--exports.cr_hud:sendBottomNotification(localPlayer, "Item Usage", "Press Y to use this item. You can also use /tuneradio to tune your radio.", 255, 194, 14)
			return
		elseif (itemID==7) then -- phonebook
			--exports.cr_hud:sendBottomNotification(localPlayer, "Item Usage", "Use /phonebook to use this item.", 255, 194, 14)
			return
		elseif (itemID==18) then -- City Guide
			triggerEvent("showCityGuide", getLocalPlayer())
			return
		elseif (itemID==19) then -- MP3 PLayer
			exports.cr_carradio:showMP3GUI()
			hideInventory()
			return
		elseif (itemID==27) then -- Flashbang
			local x, y, z = getElementPosition(getLocalPlayer())
			local rot = getPedRotation(getLocalPlayer())
			x = x + math.sin(math.rad(-rot)) * 10
			y = y + math.cos(math.rad(-rot)) * 10
			z = getGroundPosition(x, y, z + 2)
			additional = { x, y, z } 
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==28 or itemID==54 or itemID==176) then -- Glowstick or Ghettoblaster or speaker
			local x, y, z = getElementPosition(getLocalPlayer())
			local rot = getPedRotation(getLocalPlayer())
			x = x + math.sin(math.rad(-rot)) * 2
			y = y + math.cos(math.rad(-rot)) * 2
			z = getGroundPosition(x, y, z)
			additional = { x, y, z - 0.5 }
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		elseif (itemID==30) or (itemID==31) or (itemID==32) or (itemID==33) then
			--exports.cr_hud:sendBottomNotification(localPlayer, "Item Usage", "Use the chemistry set purchasable from 24/7 to use this item.", 255, 0, 0)
			return
		--[[
		elseif (itemID==34) then -- COCAINE
			doDrug1Effect()
		elseif (itemID==35) then
			doDrug2Effect()
		elseif (itemID==36) then
			doDrug3Effect()
		elseif (itemID==37) then
			doDrug4Effect()
		elseif (itemID==38) then
			if not getPedOccupiedVehicle(localPlayer) then
				doDrug5Effect()
			end
		elseif (itemID==39) then
			doDrug6Effect()
		elseif (itemID==40) then
			doDrug3Effect()
			doDrug1Effect()
		elseif (itemID==41) then
			doDrug4Effect()
			doDrug6Effect()
		elseif (itemID==42) then
			if not getPedOccupiedVehicle(localPlayer) then
				doDrug5Effect()
				doDrug2Effect()
			end
		elseif (itemID==43) then
			doDrug4Effect()
			doDrug1Effect()
			doDrug6Effect()
		]]
		elseif (itemID==44) then
			return
		elseif (itemID==45) or (itemID==46) or (itemID==47) or (itemID==66) then
			--exports.cr_hud:sendBottomNotification(source, "Item Usage", "Right click a player to use this item.")
			return
		elseif (itemID==50) or (itemID==51) or (itemID==52) then
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
			hideInventory()
		elseif (itemID==53) then -- Breathalizer
			--exports.cr_hud:sendBottomNotification(localPlayer, "Item Usage", "Use /breathtest to use this item.")
			return
		elseif (itemID==57) then -- FUEL CAN
			hideInventory()
		elseif (itemID==58) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.3, false)
				end, 5000, 1
			)
		elseif (itemID==229) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.3, false)
				end, 5000, 1
			)
		elseif (itemID==61) then -- Emergency Light Becon
			--exports.cr_hud:sendBottomNotification(localPlayer, "Item Usage", "Put it in your car inventory and press 'P' to toggle it.")
			return
		elseif (itemID==62) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.3, false)
				end, 5000, 1
			)
		elseif (itemID==63) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.2, false)
				end, 10000, 1
			)
		elseif (itemID==67) then -- GPS
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Put it in your car inventory and Press 'F5'.")
			return
		elseif (itemID==70) then -- First Aid Kit
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Right click on a player who's knocked out to stabilize him.")
			return
		elseif (itemID==71) then -- Notebook
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Use /writenote [text] to write a note. There are " .. itemValue .. " pages left.")
			return
		elseif (itemID==72) then -- Note
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "The Note reads: " .. itemValue)
		elseif (itemID==78) then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "This San Andreas Pilot License was issued for " .. itemValue .. ".")
			return
		elseif (itemID==81) then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Drop this Fridge in an Interior.")
			return
		elseif (itemID==84) then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Put it in a car or carry it to know when police is around.")
			return
		elseif (itemID==85) then -- Emergency Light Becon
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Put it in your car inventory and press 'N' to toggle it.")
			return
		elseif (itemID==91) then
			setTimer(
				function()
					setElementData(localPlayer, "alcohollevel", (getElementData(localPlayer, "alcohollevel") or 0) + 0.35, false)
				end, 15000, 1
			)
		elseif (itemID==103) then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Drop this shelf in an interior.")
			return
		elseif (itemID==111) then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName,  "A personal GPS, shiny. Got the latest maps installed.")
			return
		--[[	
		elseif itemID == 115 then
			local info = split(tostring(itemValue), ':')
			if info and info[1] == '46' then
				--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Scroll to your parachute while in the air to use it.")
			else
				setClipboard(info[2])
				--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Copied the weapon serial to your clipboard!")
				----exports.cr_hud:sendBottomNotification(localPlayer, itemName, "This item is (part of) a weapon, you cannot use it with clicking on it. If you have all the parts needed, the gun will appear in your scrollmenu.")
			end
			return
		elseif itemID == 116 then
			local parts = exports.cr_global:explode(':', itemValue)
			local ammo_id = tonumber(parts[1])
			local rounds = tonumber(parts[2])
			local weapons
			if ammo_id and rounds then
				local ammo = exports.cr_weapon:getAmmo(ammo_id)
				if ammo and ammo.weapons then
					--exports.cr_hud:sendBottomNotification(localPlayer, ammo.cartridge .. ' ' .. itemName, "Cartridge: " .. ammo.cartridge .. ", Bullet Style: " .. ammo.bullet_style .. ", Bullet Weight: "
						..exports.cr_global:round(ammo.bullet_weight*1000,2) .. " grams, Application: " .. ammo.application .. ", Compactible with " .. exports.cr_weapon:formatWeaponNames(ammo.weapons) .. ".")
				end
			end
			return
			--]]
		elseif itemID == 117 then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Please place this item into a vehicle, then control it over the vehicles right mouse button menu.")
			return
		elseif itemID == 174 then
			triggerServerEvent("startFAAmapGUI", localPlayer)
			return
		elseif (itemID==118) then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName,  "Put it in your car and approach a toll booth.")
			return
		elseif itemID == 121 then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "A heavy box full of supplies!")
			return
		elseif itemID == 145 then -- flashlight
			exports.cr_dynamic_lighting_flash:toggleFlashLight(nil, item[3])
		elseif (itemID==147) then -- Picture Frame --  Adams
			if(itemValue and itemValue ~= 1) then
				local split = exports.cr_global:explode(";", itemValue)
				if(#split > 1) then
					--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Drop this in an interior to replace the texture '" .. tostring(split[2]) .. "'.")
				else
					local url = itemValue
					triggerServerEvent ("frames:fetchTexture", localPlayer, itemSlot, url)
				end
				return
			else
				triggerEvent ("frames:showFrameGUI", localPlayer, itemSlot)
				return
			end
		elseif (itemID==148) then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "OCW permit - " .. itemValue .. ".")
			return
		elseif (itemID==149) then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "CCW permit - " .. itemValue .. ".")
			return
		elseif (itemID==150) then -- ATM card
			local itemExploded = explode(";", itemValue) 
			if tonumber(itemExploded[2]) > 0 then
				--exports.cr_hud:sendBottomNotification(localPlayer, g_items[itemID][1] , "Card Number: '" .. itemExploded[1] .. "', Owner: '" .. tostring(exports.cr_cache:getCharacterNameFromID(itemExploded[2])):gsub("_", " ") .. "'. Drag & Drop to a nearby ATM Machine.")
			else
				--exports.cr_hud:sendBottomNotification(localPlayer, g_items[itemID][1] , "Card Number: '" .. itemExploded[1] .. "', Owner: '" .. tostring(exports.cr_cache:getBusinessNameFromID(math.abs(itemExploded[2]))) .. "'. Drag & Drop to a nearby ATM Machine.")
			end
			return
		elseif (itemID==152) then -- ID card
			local itemExploded = explode(";", itemValue)
			local text = "Name '" .. itemExploded[1]:gsub("_", " ") .. "', Gender: '" .. itemExploded[2] .. "', DoB: '" .. itemExploded[3] .. "', Fingerprint: '" .. itemExploded[4] .. "' "
			--exports.cr_hud:sendBottomNotification(localPlayer, g_items[itemID][1] , text)
			return
		elseif (itemID==133) or (itemID==153) or (itemID==154) or (itemID==155)then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "This " .. itemName .. " was issued for " .. itemValue .. ".")
			return
		elseif (itemID==169) then -- Keypad door lock
			--exports.cr_hud:sendBottomNotification(localPlayer, g_items[itemID][1] .. " - Equipping for interior ID #" .. itemValue , "Attach this device to a stable wall to install. You can uninstall this device and reinstall it freely later on.")
			return
		elseif (itemID==170) then -- Keycard
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Swipe this card at " .. tostring(itemValue) .. " to gain access.")
			return
		elseif (itemID==177) then -- Remote dispatch device
			executeCommandHandler("dispatch")
			hideInventory()
			return
		elseif (itemID==178) then
			local bInfo = split(tostring(itemValue), ':')
			local bID = bInfo[3]
			triggerServerEvent("books:beginBook", localPlayer, bID, itemSlot)
			hideInventory()
			return
		elseif (itemID==211) then -- Christmas Lottery Ticket
			outputChatBox("Try giving the ticket to Santa to see what you might have won.", 255, 194, 14)
			return
		elseif (itemID==212) then -- Snow Tire
			outputChatBox("Put this in your vehicle for better traction in snow.", 155, 255, 155)
			return
		elseif itemID == 232 then -- car battery charger
			for i, veh in pairs(exports.cr_global:getNearbyElements(localPlayer, 'vehicle', 5)) do
				if veh and isElement(veh) then
					local doors = exports.cr_vehicle:getDoorsFor(getElementModel(veh) , 0)
					if #doors > 0 and doors[1] and doors[1][1] == 'Hood' and getVehicleDoorOpenRatio (veh, 0) < 0.5 then
						--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Please open the hood of this vehicle first.")
					elseif isVehicleLocked (veh) then
						--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "Please unlock this vehicle first.")
					else
						triggerServerEvent("useItem", localPlayer, itemSlot, veh)
					end
					return
				end
			end
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "There is no vehicle around you.")
		else
			triggerServerEvent("useItem", localPlayer, itemSlot, additional)
		end
	else
		if itemSlot == -100 then
			--exports.cr_hud:sendBottomNotification(localPlayer, itemName, "You wear Body Armor.")
		else
			setPedWeaponSlot(localPlayer, -itemSlot)
		end
	end
end

function stopGasmaskDamage(attacker, weapon)
	local gasmask = getElementData(localPlayer, "gasmask")

	if (weapon==17 or weapon==41) and (gasmask) then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, stopGasmaskDamage)



addEventHandler("onClientChangeChar", getRootElement(), hideInventory)

local function updateInv()
	if wItems and source == showinvPlayer then
		source = nil
		setTimer(toggleCategory, 50, 1)
	end
end
addEventHandler("recieveItems", getRootElement(), updateInv)

addEvent("finishItemDrop", true)
addEventHandler("finishItemDrop", localPlayer,
	function()
		if wItems then
			guiSetVisible(wWait, false)
			guiSetEnabled(wItems, true)
		end
	end
)

--
-- Scuba Gear
--
addEventHandler("onClientPlayerDamage", localPlayer,
	function(attacker, weapon)
		if weapon == 53 and getElementData(source, "scuba") then
			cancelEvent()
		end
	end
)

--
-- Carried items weight.
--
addCommandHandler("carried",
	function(command, detailed)
		--exports.cr_hud:sendBottomNotification(localPlayer, "Carried Weight", ("%.2f/%.2f"):format(getCarriedWeight(localPlayer), getMaxWeight(localPlayer)))
		if detailed == "detailed" then
			for k, v in ipairs(getItems(localPlayer)) do
				--exports.cr_hud:sendBottomNotification(localPlayer, "Carried Weight",  "  %.2f %s; %s", getItemWeight(v[1], v[2]), getItemName(v[1], v[2]), getItemDescription(v[1], v[2]))
			end
		end
	end
)

--
-- are we watching TV?
--
function isWatchingTV()
	return exports['cr_freecam-tv']:isFreecamEnabled()
end
