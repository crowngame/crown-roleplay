local cacheData = {}
local quitReason = {
    ["Unknown"] = "Bilinmiyor",
    ["Quit"] = "Kendi İsteğiyle",
    ["Kicked"] = "Atma",
    ["Banned"] = "Yasaklama",
    ["Bad Connection"] = "Zayıf İnternet",
    ["Timed out"] = "Bağlantı Koptu"
}

addCommandHandler("quitlog", function()
	createUI()
end)

function createUI()
    if isElement(window) then
        destroyElement(window)
    end
    window = guiCreateWindow(0, 0, 724, 474, "Yakın Çevrede Çıkan Oyuncular", false)
    guiWindowSetSizable(window, false)
    exports.cr_global:centerWindow(window)

    close = guiCreateButton(10, 426, 704, 38, "Arayüzü Kapat", false, window)
    gridlist = guiCreateGridList(9, 26, 705, 382, false, window)
    guiGridListAddColumn(gridlist, "Karakter Adı", 0.2)
    guiGridListAddColumn(gridlist, "Kullanıcı Adı", 0.2)
    guiGridListAddColumn(gridlist, "Çıkış Sebebi", 0.2)
    guiGridListAddColumn(gridlist, "Uzaklık (mt)", 0.1)
    guiGridListAddColumn(gridlist, "Konum", 0.1)
    guiGridListAddColumn(gridlist, "Tarih", 0.2)

    if cacheData and #cacheData > 0 then
        for index, data in ipairs(cacheData) do
            local row = guiGridListAddRow(gridlist)
            if row then
                for i = 1, 6 do
                    guiGridListSetItemText(gridlist, row, i, data[i], false, false)
                end

            end
        end
    end
	
    addEventHandler("onClientGUIClick", close, function(b)
        if source == close then
            destroyElement(window)
        end
    end)
end

addEventHandler("onClientPlayerQuit", root, function(reason)
    if localPlayer == source then
        return
    end
	
    if source:getData("loggedin") ~= 1 then
        return
    end
	
    local distance = getDistanceBetweenPoints3D(localPlayer.position, source.position)
    if distance < 20 then
        cacheData[#cacheData + 1] = { source.name:gsub("_", " "), source:getData("account:username"), quitReason[reason] or "İnternet Kesintisi", math.floor(distance), getZoneName(source.position), exports.cr_global:getTimestamp() }
    end
end)