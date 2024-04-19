--Farid / 2015.01.08
local GUIEditor = {
    tab = {},
    tabStaff = {},
    label = {},
    labelStaff = {},
    tabpanel = {},
    edit = {},
    gridlist = {},
    gridlistStaff = {},
    gridcol = {},
    gridcolStaff = {},
    gridcolChangeLogs = {},
    window = {},
    button = {},
    combobox = {}
}
local timer = {}
local staffInfo = {}
local staffTeams = {}
local globalChangelogs = {}
local staffTitles = exports.cr_integration:getStaffTitles()
local currentPos = nil
local futurePos = nil

function openStaffManager(staffInfo1, staffTeams1, globalChangelogs1) --/ Farid
	if canPlayerAccessStaffManager(localPlayer) then
		staffTitles = exports.cr_integration:getStaffTitles()
		if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then
			updateStaffInfo(staffInfo1)
			updateStaffTeams(staffTeams1)
			updateChangelogs(globalChangelogs1)
		else
			local yExtend = 32
			showCursor(true)
			guiSetInputEnabled(true)
	        GUIEditor.window[1] = guiCreateWindow(538, 144, 700, 461+yExtend, "Crown Roleplay - Yetkili Görevlendirme Arayüzü", false)
	        guiWindowSetSizable(GUIEditor.window[1], false)
	        exports.cr_global:centerWindow(GUIEditor.window[1])
	        GUIEditor.tabpanel[1] = guiCreateTabPanel(9, 29, 700, 386+yExtend, false, GUIEditor.window[1])
	        
	        GUIEditor.tab.home = guiCreateTab("Genel", GUIEditor.tabpanel[1])
	        
	        GUIEditor.label[1] = guiCreateLabel(10, 16, 56, 28, "Ara:", false, GUIEditor.tab.home)
	        guiSetFont(GUIEditor.label[1], "default-bold-small")
	        guiLabelSetVerticalAlign(GUIEditor.label[1], "center")
	        GUIEditor.edit[1] = guiCreateEdit(84, 16, 232, 28, "", false, GUIEditor.tab.home)
	        addEventHandler("onClientGUIChanged", GUIEditor.edit[1], function()
	        	if source == GUIEditor.edit[1] then
	        		local text = guiGetText(GUIEditor.edit[1])
	        		if string.len(text) >= 3 then
		        		local count = 0
		        		guiSetText(GUIEditor.label[2], "Aranıyor...")
		        		guiLabelSetColor(GUIEditor.label[2], 255,255,255)
		        		currentPos = nil
		        		futurePos = nil
		        		clearStatusText()
		       			killTimerIfExisted(timer.username)
		        		timer.username = setTimer(function() 
		        			local username = exports.cr_cache:getUsername(text)
		        			if username then
		        				guiSetText(GUIEditor.label[2], "Bulundu: " .. username .. ". Sunucudan daha fazla bilgi isteniyor...")
		        				guiLabelSetColor(GUIEditor.label[2], 0,255,0)
		        				killTimerIfExisted(timer.username)
		        				triggerServerEvent("getStaffInfo", localPlayer, username)
		        			else
		        				if count > 4 then
		        					guiSetText(GUIEditor.label[2], "Kullanıcı bulunamadı.")
		        					guiLabelSetColor(GUIEditor.label[2], 255,0,0)
		        					killTimerIfExisted(timer.username)
		        				end
		        			end
			        		count = count + 1
		        		end, 500, 6)
	        		end
	        	end
	        end)

	        GUIEditor.label[2] = guiCreateLabel(10, 44, 306, 23, "Kullanıcı Adı:", false, GUIEditor.tab.home)
	        guiLabelSetHorizontalAlign(GUIEditor.label[2], "right", false)
	        guiLabelSetVerticalAlign(GUIEditor.label[2], "center")
	        
	        GUIEditor.label[3] = guiCreateLabel(10, 69, 74, 22, "Yetkili:", false, GUIEditor.tab.home)
	        guiSetFont(GUIEditor.label[3], "default-bold-small")
	        guiLabelSetVerticalAlign(GUIEditor.label[3], "center")

	        GUIEditor.combobox.admin = guiCreateComboBox(84, 69, 232, 22, "", false, GUIEditor.tab.home)
	        local count = 0
	        guiComboBoxAddItem(GUIEditor.combobox.admin, "Oyuncu")
	        for i, rank in ipairs(staffTitles[1]) do
	        	guiComboBoxAddItem(GUIEditor.combobox.admin, rank)
	        	count = count + 1
	        end
	       	exports.cr_global:guiComboBoxAdjustHeight(GUIEditor.combobox.admin, count)
	       
	        GUIEditor.label[4] = guiCreateLabel(10, 101, 74, 22, "Rehber:", false, GUIEditor.tab.home)
	        guiSetFont(GUIEditor.label[4], "default-bold-small")
	        guiLabelSetVerticalAlign(GUIEditor.label[4], "center")

	        GUIEditor.combobox.sup = guiCreateComboBox(84, 101, 232, 22, "", false, GUIEditor.tab.home)
	        count = 0
	        guiComboBoxAddItem(GUIEditor.combobox.sup, "Oyuncu")
	        for i, rank in ipairs(staffTitles[2]) do
	        	guiComboBoxAddItem(GUIEditor.combobox.sup, rank)
	        	count = count + 1
	        end
	       	exports.cr_global:guiComboBoxAdjustHeight(GUIEditor.combobox.sup, count)

	        GUIEditor.label[5] = guiCreateLabel(10, 133, 74, 22, "VCT:", false, GUIEditor.tab.home)
	        guiSetFont(GUIEditor.label[5], "default-bold-small")
	        guiLabelSetVerticalAlign(GUIEditor.label[5], "center")

	        GUIEditor.combobox.vct = guiCreateComboBox(84, 133, 232, 22, "", false, GUIEditor.tab.home)
	        count = 0
	        guiComboBoxAddItem(GUIEditor.combobox.vct, "Oyuncu")
	        for i, rank in ipairs(staffTitles[3]) do
	        	guiComboBoxAddItem(GUIEditor.combobox.vct, rank)
	        	count = count + 1
	        end
	       	exports.cr_global:guiComboBoxAdjustHeight(GUIEditor.combobox.vct, count)

	        GUIEditor.label[6] = guiCreateLabel(10, 165, 74, 22, "Scripter:", false, GUIEditor.tab.home)
	        guiSetFont(GUIEditor.label[6], "default-bold-small")
	        guiLabelSetVerticalAlign(GUIEditor.label[6], "center")

	        GUIEditor.combobox.scripter = guiCreateComboBox(84, 165, 232, 22, "", false, GUIEditor.tab.home)
	        count = 0
	        guiComboBoxAddItem(GUIEditor.combobox.scripter, "Oyuncu")
	        for i, rank in ipairs(staffTitles[4]) do
	        	guiComboBoxAddItem(GUIEditor.combobox.scripter, rank)
	        	count = count + 1
	        end
	       	exports.cr_global:guiComboBoxAdjustHeight(GUIEditor.combobox.scripter, count)

	       	
	       	GUIEditor.combobox.mapper = guiCreateComboBox(84, 165+yExtend, 232, 22, "", false, GUIEditor.tab.home)
	        count = 0
	        guiComboBoxAddItem(GUIEditor.combobox.mapper, "Oyuncu")
	        for i, rank in ipairs(staffTitles[5]) do
	        	guiComboBoxAddItem(GUIEditor.combobox.mapper, rank)
	        	count = count + 1
	        end
	       	exports.cr_global:guiComboBoxAdjustHeight(GUIEditor.combobox.mapper, count)

	        GUIEditor.label[7] = guiCreateLabel(326, 70, 282, 21, "", false, GUIEditor.tab.home)
	        GUIEditor.label[8] = guiCreateLabel(326, 101, 282, 21, "", false, GUIEditor.tab.home)
	        GUIEditor.label[9] = guiCreateLabel(326, 134, 282, 21, "", false, GUIEditor.tab.home)
	        GUIEditor.label[10] = guiCreateLabel(326, 165, 282, 21, "", false, GUIEditor.tab.home)
	        GUIEditor.label[11] = guiCreateLabel(326, 165+yExtend, 282, 21, "", false, GUIEditor.tab.home)

	        GUIEditor.label[13] = guiCreateLabel(10, 197, 74, 22, "Mapper:", false, GUIEditor.tab.home)
	        guiSetFont(GUIEditor.label[13], "default-bold-small")
	        guiLabelSetVerticalAlign(GUIEditor.label[13], "center")

	        GUIEditor.label[12] = guiCreateLabel(10, 197+yExtend, 74, 22, "Loglar:", false, GUIEditor.tab.home)
	        guiSetFont(GUIEditor.label[12], "default-bold-small")
	        guiLabelSetVerticalAlign(GUIEditor.label[12], "center")
	        
	        GUIEditor.gridlist[1] = guiCreateGridList(10, 226+yExtend, 665, 126, false, GUIEditor.tab.home)
	        GUIEditor.gridcol.type = guiGridListAddColumn(GUIEditor.gridlist[1], "Tip", 0.1)
	        GUIEditor.gridcol.from = guiGridListAddColumn(GUIEditor.gridlist[1], "İtibaren", 0.2)
	        GUIEditor.gridcol.to = guiGridListAddColumn(GUIEditor.gridlist[1], "İle", 0.2)
	        GUIEditor.gridcol.by = guiGridListAddColumn(GUIEditor.gridlist[1], "Tarafından", 0.1)
	        GUIEditor.gridcol.details = guiGridListAddColumn(GUIEditor.gridlist[1], "Detaylar", 0.35)

	        GUIEditor.button[1] = guiCreateButton(411, 16, 122, 28, "Gönder", false, GUIEditor.tab.home)
	        guiSetFont(GUIEditor.button[1], "default-bold-small")
	        addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
				if getElementData(localPlayer, "admin_level") > 0 then
					if source == GUIEditor.button[1] then
						editStaff()
					end
				end
	        end)

	        for i, team in ipairs(staffTitles) do
	        	local tabName = 'N/A'
	        	if i == 1 then
	        		tabName = "Yetkili Takımı"
	        	elseif i == 2 then
	        		tabName = "Rehber Takımı"
	        	elseif i == 3 then
	        		tabName = "VCT Takımı"
	        	elseif i == 4 then
	        		tabName = "Scripting Takımı"
	        	elseif i == 5 then
	        		tabName = "Mapping Takımı"
	        	end
	        	GUIEditor.tabStaff[i] = guiCreateTab(tabName, GUIEditor.tabpanel[1])
		        GUIEditor.gridlistStaff[i] = guiCreateGridList(0.00, 0.00, 1.00, 1.00, true, GUIEditor.tabStaff[i])
		        GUIEditor.gridcolStaff[i] = {}
		        GUIEditor.gridcolStaff[i].rank = guiGridListAddColumn(GUIEditor.gridlistStaff[i], "Rütbe", 0.3)
		        GUIEditor.gridcolStaff[i].username = guiGridListAddColumn(GUIEditor.gridlistStaff[i], "Kullanıcı Adı", 0.2)
		        GUIEditor.gridcolStaff[i].reports = guiGridListAddColumn(GUIEditor.gridlistStaff[i], "Rapor Sayısı", 0.1)
		        GUIEditor.gridcolStaff[i].rating = guiGridListAddColumn(GUIEditor.gridlistStaff[i], "Geribildirim Derecelendirmesi (5 üzerinden)", 0.18)
		        GUIEditor.gridcolStaff[i].feedbacks = guiGridListAddColumn(GUIEditor.gridlistStaff[i], "Geribildirim Sayısı", 0.18)
		        guiSetVisible(GUIEditor.gridlistStaff[i], false)
		        GUIEditor.labelStaff[i] = guiCreateLabel(0, 0, 1, 1, "Yükleniyor...", true, GUIEditor.tabStaff[i])
		        guiLabelSetHorizontalAlign(GUIEditor.labelStaff[i], "center", true)
		        guiLabelSetVerticalAlign(GUIEditor.labelStaff[i], "center", true)
		        addEventHandler("onClientGUIDoubleClick", GUIEditor.gridlistStaff[i], function(button, state)
					if getElementData(localPlayer, "admin_level") > 0 then
						local selectedRow, selectedCol = guiGridListGetSelectedItem(GUIEditor.gridlistStaff[i]) -- get double clicked item in the gridlist
						local username = guiGridListGetItemText(GUIEditor.gridlistStaff[i], selectedRow, 2)
						if button == "left" then
							guiSetSelectedTab(GUIEditor.tabpanel[1], GUIEditor.tab.home)
							guiSetText(GUIEditor.edit[1], username)
						elseif button == "right" then
						   local rank = guiGridListGetItemText(GUIEditor.gridlistStaff[i], selectedRow, 1)
						   local reports = guiGridListGetItemText(GUIEditor.gridlistStaff[i], selectedRow, 3)
						   local rating = guiGridListGetItemText(GUIEditor.gridlistStaff[i], selectedRow, 4)
						   local feedbacks = guiGridListGetItemText(GUIEditor.gridlistStaff[i], selectedRow, 5)
						   setClipboard(rank .. " " .. username .. " " .. reports)
						elseif button == "middle" then
							triggerServerEvent("feedback:openFeedBackDetails", localPlayer, username)
						end
					end
		        end, false)
	        end

	        GUIEditor.tab.changelogs = guiCreateTab("Changelogs", GUIEditor.tabpanel[1])
	        GUIEditor.gridlist.changelogs = guiCreateGridList(0, 0, 1, 1, true, GUIEditor.tab.changelogs)
	        GUIEditor.gridcolChangeLogs.type = guiGridListAddColumn(GUIEditor.gridlist.changelogs, "Tip", 0.1)
	        GUIEditor.gridcolChangeLogs.username = guiGridListAddColumn(GUIEditor.gridlist.changelogs, "Kullanıcı Adı", 0.1)
	        GUIEditor.gridcolChangeLogs.from = guiGridListAddColumn(GUIEditor.gridlist.changelogs, "İtibaren", 0.18)
	        GUIEditor.gridcolChangeLogs.to = guiGridListAddColumn(GUIEditor.gridlist.changelogs, "İle", 0.18)
	        GUIEditor.gridcolChangeLogs.by = guiGridListAddColumn(GUIEditor.gridlist.changelogs, "Tarafından", 0.1)
	        GUIEditor.gridcolChangeLogs.details = guiGridListAddColumn(GUIEditor.gridlist.changelogs, "Detaylar", 0.2)
	        guiSetVisible(GUIEditor.gridlist.changelogs, false)
	        GUIEditor.label.cloading = guiCreateLabel(0, 0, 1, 1, "Yükleniyor...", true, GUIEditor.tab.changelogs)
	        guiLabelSetHorizontalAlign(GUIEditor.label.cloading, "center", true)
	        guiLabelSetVerticalAlign(GUIEditor.label.cloading, "center", true)

	        addEventHandler("onClientGUIDoubleClick", GUIEditor.gridlist.changelogs, function(button, state)
				if getElementData(localPlayer, "admin_level") > 0 then
					if button == "left" then
					   local selectedRow, selectedCol = guiGridListGetSelectedItem(GUIEditor.gridlist.changelogs) -- get double clicked item in the gridlist
						local date = guiGridListGetItemText(GUIEditor.gridlist.changelogs, selectedRow, 1)
						local type = guiGridListGetItemText(GUIEditor.gridlist.changelogs, selectedRow, 2)
						local username = guiGridListGetItemText(GUIEditor.gridlist.changelogs, selectedRow, 3)
						local from = guiGridListGetItemText(GUIEditor.gridlist.changelogs, selectedRow, 4)
						local to = guiGridListGetItemText(GUIEditor.gridlist.changelogs, selectedRow, 5)
						local by = guiGridListGetItemText(GUIEditor.gridlist.changelogs, selectedRow, 6)
						local details = guiGridListGetItemText(GUIEditor.gridlist.changelogs, selectedRow, 7)
						local text = date .. " " .. type .. " " .. username .. " " .. from .. " " .. to .. " " .. by .. " " .. details 
						setClipboard(text)
					end
				end
	        end, false)

	        GUIEditor.button[2] = guiCreateButton(10, 425+yExtend, 700, 26, "Kapat", false, GUIEditor.window[1])  
	        addEventHandler("onClientGUIClick", GUIEditor.button[2], function()
	        	if getElementData(localPlayer, "admin_level") > 0 then
					if source == GUIEditor.button[2] then
						closeStaffManager()
					end
				end
	        end)  
	        addEventHandler("onClientGUIComboBoxAccepted", resourceRoot, guiStaffChange)
			addEventHandler("onClientGUITabSwitched", resourceRoot, onTabSwitch)

	    end
	end
end
addCommandHandler("staffs", openStaffManager, false, false)
addEvent("openStaffManager", true)
addEventHandler("openStaffManager", root, openStaffManager)

function closeStaffManager()
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then
		destroyElement(GUIEditor.window[1])
		showCursor(false)
		guiSetInputEnabled(false)
		killTimerIfExisted(timer.username)
		removeEventHandler("onClientGUIComboBoxAccepted", resourceRoot, guiStaffChange)
		removeEventHandler("onClientGUITabSwitched", resourceRoot, onTabSwitch)
		closeConfirmBox()
		cleanUpData()
	end
end

function onTabSwitch(selectedTab)
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then
		local tab = guiGetText(selectedTab) or "0"
		if tab == "Yetkili Takımı" or tab == "Rehber Takımı" or tab == "VCT Takımı" or tab == "Scripting Takımı" or tab == "Mapping Takımı" then 
			if #staffTeams > 0 then
				for i, rank in ipairs(staffTitles) do
					guiSetVisible(GUIEditor.gridlistStaff[i], true)
					guiSetVisible(GUIEditor.labelStaff[i], false)
				end
			else
				for i, rank in ipairs(staffTitles) do
					guiSetVisible(GUIEditor.gridlistStaff[i], false)
					guiSetVisible(GUIEditor.labelStaff[i], true)
				end
				triggerServerEvent("getTeamsData", localPlayer)
			end
		elseif tab == "Loglar" then
			if #globalChangelogs > 0 then
				guiSetVisible(GUIEditor.gridlist.changelogs, true)
				guiSetVisible(GUIEditor.label.cloading, false)
			else
				guiSetVisible(GUIEditor.gridlist.changelogs, false)
				guiSetVisible(GUIEditor.label.cloading, true)
				triggerServerEvent("getChangelogs", localPlayer)

			end
		end	
	end
end

function cleanUpData()
	staffInfo = {}
	staffTeams = {}
	globalChangelogs = {}
	currentPos = nil
	futurePos = nil
end

addEventHandler("onClientResourceStop", localPlayer, function()
	guiSetInputEnabled(false)
end)

function killTimerIfExisted(timer)
	if isTimer(timer) then
		killTimer(timer)
	end
end

function updateStaffInfo(info) 
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) and info and type(info) == "table" then
		staffInfo = info
		staffTeams = {}
		globalChangelogs = {}
		local user = info.user
		if user then
			if user.username then
				guiSetEnabled(GUIEditor.button[1], true)
				guiSetText(GUIEditor.label[2], info.error or "Sunucudan '" .. user.username .. "' ile ilgili bilgi alındı.")
				guiLabelSetColor(GUIEditor.label[2], 0,255,0)
				if info.error then
					clearStatusText()
				end
				guiComboBoxSetSelected(GUIEditor.combobox.admin, tonumber(user.admin))
				guiComboBoxSetSelected(GUIEditor.combobox.sup, tonumber(user.supporter))
				guiComboBoxSetSelected(GUIEditor.combobox.vct, tonumber(user.vct))
				guiComboBoxSetSelected(GUIEditor.combobox.scripter, tonumber(user.scripter))
				guiComboBoxSetSelected(GUIEditor.combobox.mapper, tonumber(user.mapper))
				currentPos = {
					[1] = tonumber(user.admin),
					[2] = tonumber(user.supporter),
					[3] = tonumber(user.vct),
					[4] = tonumber(user.scripter),
					[5] = tonumber(user.mapper),
				}
				futurePos = {}
			end
		end
		local changelogs = info.changelogs
		if changelogs then
			guiGridListClear(GUIEditor.gridlist[1])
			for i=1, #changelogs do
				local row = guiGridListAddRow(GUIEditor.gridlist[1])
				guiGridListSetItemText(GUIEditor.gridlist[1], row, GUIEditor.gridcol.type, changelogs[i].promoted == "1" and "Terfi" or "Düşme", false, false)
				guiGridListSetItemText(GUIEditor.gridlist[1], row, GUIEditor.gridcol.from, staffTitles[tonumber(changelogs[i].team)][tonumber(changelogs[i].from_rank)], false, false)
				guiGridListSetItemText(GUIEditor.gridlist[1], row, GUIEditor.gridcol.to, staffTitles[tonumber(changelogs[i].team)][tonumber(changelogs[i].to_rank)], false, false)
				guiGridListSetItemText(GUIEditor.gridlist[1], row, GUIEditor.gridcol.by, changelogs[i].by, false, false)
				guiGridListSetItemText(GUIEditor.gridlist[1], row, GUIEditor.gridcol.details, changelogs[i].details or "N/A", false, false)
			end
		end
	end
end

function updateStaffTeams(info) 
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) and info and type(info) == "table" and #info > 0 then
		staffTeams = info
		for i, team in ipairs(staffTeams) do
			guiGridListClear(GUIEditor.gridlistStaff[i])
			for j, user in ipairs(team) do
				local row = guiGridListAddRow(GUIEditor.gridlistStaff[i])
				if not GUIEditor.gridcolStaff[i] then GUIEditor.gridcolStaff[i] = {} end
				guiGridListSetItemText(GUIEditor.gridlistStaff[i], row, GUIEditor.gridcolStaff[i].rank, staffTitles[i][user.rank[i]] or "Oyuncu", false, false)
				guiGridListSetItemText(GUIEditor.gridlistStaff[i], row, GUIEditor.gridcolStaff[i].username, user.username, false, false)
				guiGridListSetItemText(GUIEditor.gridlistStaff[i], row, GUIEditor.gridcolStaff[i].reports, user.adminreports, false, true)
				guiGridListSetItemText(GUIEditor.gridlistStaff[i], row, GUIEditor.gridcolStaff[i].rating, formatRating(user.rating), false, true)
				guiGridListSetItemText(GUIEditor.gridlistStaff[i], row, GUIEditor.gridcolStaff[i].feedbacks, user.feedbacks, false, true)
			end
		end
		for i, rank in ipairs(staffTitles) do
			guiSetVisible(GUIEditor.gridlistStaff[i], true)
			guiSetVisible(GUIEditor.labelStaff[i], false)
		end
	end
end

function formatRating(rating)
	if not rating or not tonumber(rating) then
		return 0
	else
		return exports.cr_global:round(rating, 2)
	end
end

function updateChangelogs(info) 
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) and info and type(info) == "table" and #info > 0 then
		globalChangelogs = info
		local changelogs = globalChangelogs
		if changelogs then
			guiGridListClear(GUIEditor.gridlist.changelogs)
			for i=1, #changelogs do
				local row = guiGridListAddRow(GUIEditor.gridlist.changelogs)
				guiGridListSetItemText(GUIEditor.gridlist.changelogs, row, GUIEditor.gridcolChangeLogs.type, changelogs[i].promoted == "1" and "Terfi" or "Düşme", false, false)
				guiGridListSetItemText(GUIEditor.gridlist.changelogs, row, GUIEditor.gridcolChangeLogs.username, changelogs[i].username, false, false)
				guiGridListSetItemText(GUIEditor.gridlist.changelogs, row, GUIEditor.gridcolChangeLogs.from, staffTitles[tonumber(changelogs[i].team)][tonumber(changelogs[i].from_rank)], false, false)
				guiGridListSetItemText(GUIEditor.gridlist.changelogs, row, GUIEditor.gridcolChangeLogs.to, staffTitles[tonumber(changelogs[i].team)][tonumber(changelogs[i].to_rank)], false, false)
				guiGridListSetItemText(GUIEditor.gridlist.changelogs, row, GUIEditor.gridcolChangeLogs.by, changelogs[i].by, false, false)
				guiGridListSetItemText(GUIEditor.gridlist.changelogs, row, GUIEditor.gridcolChangeLogs.details, changelogs[i].details or "N/A", false, false)
			end
		end
		guiSetVisible(GUIEditor.gridlist.changelogs, true)
		guiSetVisible(GUIEditor.label.cloading, false)
	end
end



function guiStaffChange()
	if not currentPos then return false end
	if source == GUIEditor.combobox.admin then
		local admin = guiComboBoxGetSelected(GUIEditor.combobox.admin)
		if admin == -1 then admin = 0 end
		local myLevel = getElementData(localPlayer, "admin_level") or 0
		if (not hasPlayerAccess(localPlayer) or myLevel < admin or myLevel < currentPos[1]) and (getElementData(localPlayer, "admin_level") > 0) then
			guiSetText(GUIEditor.label[7], "Yeterli yetkiniz yok.")
			guiComboBoxSetSelected(GUIEditor.combobox.admin, currentPos[1])
		elseif admin > currentPos[1] then
			guiSetText(GUIEditor.label[7], "Terfi: " .. staffTitles[1][admin])
			futurePos[1] = admin
		elseif admin < currentPos[1] then
			guiSetText(GUIEditor.label[7], "Düşme: " .. staffTitles[1][admin])
			futurePos[1] = admin
		else
			guiSetText(GUIEditor.label[7], "")
		end
	elseif source == GUIEditor.combobox.sup then
		local sup = guiComboBoxGetSelected(GUIEditor.combobox.sup)
		if sup == -1 then sup = 0 end
		if (not hasPlayerAccess(localPlayer)) and (getElementData(localPlayer, "admin_level") > 0) and (not exports.cr_integration:isPlayerHelperManager(localPlayer)) then
			guiSetText(GUIEditor.label[8], "Yeterli yetkiniz yok.")
			guiComboBoxSetSelected(GUIEditor.combobox.sup, currentPos[2])
		elseif sup > currentPos[2] then
			guiSetText(GUIEditor.label[8], "Terfi: " .. staffTitles[2][sup])
			futurePos[2] = sup
		elseif sup < currentPos[2] then
			guiSetText(GUIEditor.label[8], "Düşme: " .. staffTitles[2][sup])
			futurePos[2] = sup
		else
			guiSetText(GUIEditor.label[8], "")
		end
	elseif source == GUIEditor.combobox.vct then
		local vct = guiComboBoxGetSelected(GUIEditor.combobox.vct)
		if vct == -1 then vct = 0 end
		local myLevel = getElementData(localPlayer, "vct_level") or 0
		if (not hasPlayerAccess(localPlayer)) and (getElementData(localPlayer, "admin_level") > 0) and (myLevel <= vct or myLevel <= currentPos[3]) then
			guiSetText(GUIEditor.label[9], "Yeterli yetkiniz yok.")
			guiComboBoxSetSelected(GUIEditor.combobox.vct, currentPos[3])
		elseif vct > currentPos[3] then
			guiSetText(GUIEditor.label[9], "Terfi: " .. staffTitles[3][vct])
			futurePos[3] = vct
		elseif vct < currentPos[3] then
			guiSetText(GUIEditor.label[9], "Düşme: " .. staffTitles[3][vct])
			futurePos[3] = vct
		else
			guiSetText(GUIEditor.label[9], "")
		end
	elseif source == GUIEditor.combobox.scripter then
		local scripter = guiComboBoxGetSelected(GUIEditor.combobox.scripter)
		if scripter == -1 then scripter = 0 end
		if (not hasPlayerAccess(localPlayer)) and (getElementData(localPlayer, "admin_level") > 0) then
			guiSetText(GUIEditor.label[10], "Yeterli yetkiniz yok.")
			guiComboBoxSetSelected(GUIEditor.combobox.scripter, currentPos[4])
		elseif scripter > currentPos[4] then
			guiSetText(GUIEditor.label[10], "Terfi: " .. staffTitles[4][scripter])
			futurePos[4] = scripter
		elseif scripter < currentPos[4] then
			guiSetText(GUIEditor.label[10], "Düşme: " .. staffTitles[4][scripter])
			futurePos[4] = scripter
		else
			guiSetText(GUIEditor.label[10], "")
		end
	elseif source == GUIEditor.combobox.mapper then
		local mapper = guiComboBoxGetSelected(GUIEditor.combobox.mapper)
		if mapper == -1 then mapper = 0 end
		local myLevel = getElementData(localPlayer, "mapper_level") or 0
		if (not hasPlayerAccess(localPlayer)) and (getElementData(localPlayer, "admin_level") > 0) and (myLevel <= mapper or myLevel <= currentPos[5]) then
			guiSetText(GUIEditor.label[11], "Yeterli yetkiniz yok.")
			guiComboBoxSetSelected(GUIEditor.combobox.mapper, currentPos[5])
		elseif mapper > currentPos[5] then
			guiSetText(GUIEditor.label[11], "Terfi: " .. staffTitles[5][mapper])
			futurePos[5] = mapper
		elseif mapper < currentPos[5] then
			guiSetText(GUIEditor.label[11], "Düşme: " .. staffTitles[5][mapper])
			futurePos[5] = mapper
		else
			guiSetText(GUIEditor.label[11], "")
		end
	end
end

function clearStatusText()
	guiSetText(GUIEditor.label[7], "")
	guiSetText(GUIEditor.label[8], "")
	guiSetText(GUIEditor.label[9], "")
	guiSetText(GUIEditor.label[10], "")
	guiSetText(GUIEditor.label[11], "")
end

function editStaff()
	if not currentPos or not futurePos or not GUIEditor.window[1] or not isElement(GUIEditor.window[1]) then return false end
	for i = 1, #currentPos do
		if futurePos[i] and currentPos[i] ~= futurePos[i] then
			guiSetEnabled(GUIEditor.button[1], false)
			showConfirmEditStaff()
			break
		end
	end
end

function showConfirmEditStaff()
	if not currentPos or not futurePos or not GUIEditor.window[1] or not isElement(GUIEditor.window[1]) then return false end
	closeConfirmBox()
	guiSetEnabled(GUIEditor.window[1], false)
    GUIEditor.window[2] = guiCreateWindow(687, 334, 420, 171, "Yetki Güncellemesi", false)
    guiWindowSetSizable(GUIEditor.window[2], false)
    exports.cr_global:centerWindow(GUIEditor.window[2])
    GUIEditor.label[100] = guiCreateLabel(11, 27, 394, 63, "'" .. staffInfo.user.username .. "' kullanıcısının yetkisini güncellemek üzeresiniz.\n\nLütfen bu yetki değişikliğine ilişkin nedenleri veya ayrıntıları (varsa) aşağıdaki metin kutusuna girin:", false, GUIEditor.window[2])
    guiLabelSetHorizontalAlign(GUIEditor.label[100], "left", true)
    GUIEditor.edit[100] = guiCreateEdit(11, 94, 394, 32, "", false, GUIEditor.window[2])
    GUIEditor.button[100] = guiCreateButton(12, 136, 198, 25, "Onayla", false, GUIEditor.window[2])
    addEventHandler("onClientGUIClick", GUIEditor.button[100], function()
		if getElementData(localPlayer, "admin_level") > 0 then
			if source == GUIEditor.button[100] then
				triggerServerEvent("9SyUY2IjdO", localPlayer, staffInfo.user.id, futurePos, guiGetText(GUIEditor.edit[100]))
				closeConfirmBox()
			end
		end
    end)  
    GUIEditor.button[101] = guiCreateButton(212, 136, 198, 25, "İptal", false, GUIEditor.window[2]) 
    addEventHandler("onClientGUIClick", GUIEditor.button[101], function()
		if getElementData(localPlayer, "admin_level") > 0 then
			if source == GUIEditor.button[101] then
				closeConfirmBox()
			end
		end
    end)  
end

function closeConfirmBox()
	if GUIEditor.window[2] and isElement(GUIEditor.window[2]) then
		destroyElement(GUIEditor.window[2])
		if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then
			guiSetEnabled(GUIEditor.window[1], true)
		end
	end
end