function loadedWeapon(target, tablem)
	if isElement(window) then destroyElement(window) end
	window = guiCreateWindow(0, 0, 549, 335, getTeamName(getPlayerTeam(localPlayer)) .. " - El Koy | Görevli: " .. getPlayerName(localPlayer):gsub("_", " "), false)
	guiWindowSetSizable(window, false)
	guiWindowSetMovable(window, false)
	exports.cr_global:centerWindow(window)

	tab = guiCreateTabPanel(10,20,539,275,false,window)
	tab1 = guiCreateTab("Silaha El Koyma", tab)

	label1 = guiCreateLabel(45, 16, 9999, 9999, "Aşağıdan kullanıcının el koyulmasını istediğiniz silahı seçebilir ve el koyabilirsiniz.", false, tab1)

	grid = guiCreateGridList(7, 85, 515, 155, false, tab1)
	guiGridListAddColumn(grid, "Silah Adı", 0.5)
	guiGridListAddColumn(grid, "Güncel Hakkı", 0.45)
	for i, v in ipairs(tablem) do
		if v[1] == 115 then
			local itemid = v[1]
			local itemvalue = v[2]
			local row = guiGridListAddRow(grid)
			local silahHak = #tostring(explode(":", itemvalue)[6])>0 and explode(":", itemvalue)[6] or 3
			silahHak = not restrictedWeapons[tonumber(explode(":", itemvalue)[1])] and silahHak or "-"

			local checkString = string.sub(exports.cr_items:getItemName(itemid, itemvalue), -4)
			if (checkString == " (D)")  then
				silahHak = "-"
			end
			
			silahHak = itemid == 115 and silahHak or "-"
		  	guiGridListSetItemText(grid, row, 1, tostring(exports.cr_items:getItemName(v[1], v[2])), false, true)
		  	guiGridListSetItemText(grid, row, 2, silahHak, false, true)
		  	guiGridListSetItemData(grid, row, 2, tostring(explode(":", itemvalue)[2]))
		end
	end

	use = guiCreateButton(9, 300, 267, 31, "El Koy", false, window)
	
	addEventHandler('onClientGUIClick',use,function()
		if guiGetSelectedTab(tab) == tab1 then
			local row = guiGridListGetSelectedItem(grid)
			if row ~= -1 then
				if guiGridListGetItemText(grid, row, 2) == "-" then
					outputChatBox('[!]#FFFFFF Görev silahına el koyamazsınız.', 255, 0, 0, true)
					destroyElement(window)
					return
				end
				triggerServerEvent(getResourceName(getThisResource()) .. ' >> takeGun',localPlayer,localPlayer,target,guiGridListGetItemData(grid, row, 2))
				destroyElement(window)
			else
				outputChatBox("[!]#FFFFFF Lütfen listeden bir silah seçiniz.", 255, 0, 0, true)
			end
		end
	end, false)
	
	close = guiCreateButton(286, 300, 254, 31, "Kapat", false, window)

	addEventHandler("onClientGUIClick", close, function()
		destroyElement(window)
	end, false)
end
addEvent(getResourceName(getThisResource()) .. " >> loadedWeapon", true)
addEventHandler(getResourceName(getThisResource()) .. " >> loadedWeapon", root, loadedWeapon)