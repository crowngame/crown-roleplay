Locations = {
	[1] = {"Bank of Los Santos", {1310.0205078125, -1366.7958984375, 13}, false},
	[2] = {"Los Santos Network", {649.2919921875, -1359.3642578125, 13}, false},
	[3] = {"Yedek Anahtarcı", {2292.25, -1722.6865234375, 13.5546875}, false},
	[4] = {"Pizza Stack", {2105.48828125, -1806.4501953125, 13.559017181396}, false},
    [5] = {"Araç Parçalama", {2637.8994140625, -2116.646484375, 13}, false},
    [6] = {"Ekonomik Galeri", {2130.015625, -2156.2685546875, 14.689163208008}, false},
	[7] = {"Orta Galeri", {2128.302734375, -1130.6826171875, 25.550813674927}, false},
	[8] = {"Lüks Galeri", {550.9482421875, -1285.0009765625, 21.089172363281}, false},
    [9] = {"Balık İskelesi", {370.2373046875, -2069.4345703125, 13}, false},
    [10] = {"Taksi Şöförlüğü", {1786.7568359375, -1865.0390625, 13}, false},
    [11] = {"Tır Şöförlüğü", {2282.6513671875, -2349.4306640625, 13}, false},
    [12] = {"Çöpcülük Mesleği", {1615.2705078125, -1841.58984375, 13}, false},
    [13] = {"Kamyon Şöförlüğü", {2213.6884765625, -2658.5869140625, 13}, false},
    [14] = {"Sigara Kaçakcılığı", {2455.6630859375, -2644.7119140625, 13}, false},
    [15] = {"Alkol Kaçakcılığı", {2572.41796875, -2426.80859375, 13}, false},
    [16] = {"Beton Taşımacılığı", {2335.96875, -2079.87109375, 13}, false},
    [17] = {"Turist Mesleği", {1010.2001953125, -1867.55859375, 13}, false},
    [18] = {"Mermici", {1423.248046875, -1292.0322265625, 13}, false},
    [19] = {"Giyim Mağazası", {2244.396484375, -1665.5673828125, 13}, false},
}

Instance = {
	window = nil,
        blip = nil,

	find = function(self)
		if isElement(self.window) then
			return
		end
		self.window = guiCreateWindow(0, 0, 510, 333, "Crown Roleplay - Navigasyon", false)
		exports.cr_global:centerWindow(self.window)
                guiWindowSetSizable(self.window, false)

                grid = guiCreateGridList(9, 26, 485, 237, false, self.window)
                column = guiGridListAddColumn(grid, "Bölge Adı", 0.9)
                for index, value in pairs(Locations) do
                        local id = guiGridListAddRow(grid)
                        guiGridListSetItemText(grid, id, column, value[1], false, false)
                        guiGridListSetItemData(grid, id, column, index)
                end
                
                ok = guiCreateButton(9, 267, 485, 27, "İşaretle", false, self.window)
                addEventHandler('onClientGUIClick', ok,
                	function(b, s)
                                local selectedRow, selectedColumn = guiGridListGetSelectedItem(grid)
                                if selectedRow ~= -1 then
                                        local selectedJob = guiGridListGetItemData(grid, selectedRow, selectedColumn)
                                         outputChatBox("[!]#FFFFFF Bulmak istediğiniz yer radarda kırmızı olarak işaretlendi.", 0, 225, 0, true)
                                        if isElement(self.blip) then
                                                self.blip.position = unpack(Locations[selectedJob][2])
                                                return
                                        end
                                       -- self.blip = Blip(Locations[selectedJob][2][1], Locations[selectedJob][2][2], Locations[selectedJob][2][3], 0, 5)
                                       exports.cr_navigation:findBestWay(Locations[selectedJob][2][1], Locations[selectedJob][2][2], Locations[selectedJob][2][3])
                                end
                	end
                )
                close = guiCreateButton(9, 298, 485, 25, "Arayüzü Kapat", false, self.window)
                addEventHandler('onClientGUIClick', close,
                	function(b, s)
                	       self.window:destroy()
                	end
                )   
	end,
}

Array = Instance
addCommandHandler('navigasyon', function() Array:find() end)