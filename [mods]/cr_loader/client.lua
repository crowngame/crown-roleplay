local sx,sy = guiGetScreenSize()
local mods,dmods,exists,isimler = {},{},{},{} 
local barX,barY = sx*0.9,sy*0.9

local bilgiyazi = "Araçlar Yükleniyor"
local bilgiyaziG = dxGetTextWidth(bilgiyazi,1.5,"default-bold")/2

local yuklendi,dosyaisim = false,""

local movingOffsetX, movingOffsetY = 0, 0
local isMoving = false

local function downloadMods()
	startTick = getTickCount()
	tick = getTickCount()
	downloadedSize = 0
	for i,v in ipairs(dmods) do
		local file = v.file
		downloadFile(file)
	end
end	

function table.find(tbl,index,value)
	for i,v in pairs(tbl) do 
		if v[index] == value then 
			return i
		end
	end
	return false
end	

addEvent("loader.request",true)
addEventHandler("loader.request",root,function (tbl)
	if tbl then
		mods,dmods = tbl,{}
		totalSize = 0
		drawPercent = 0
		percent = 0
		local deaktifler = loadSetting("Araclar","mbLoader") or toJSON({})
		local deaktifler = fromJSON(deaktifler)
		for i,v in pairs(mods) do
			isimler[v.file] = v.isim
			local model = tostring(v.model)
			if not deaktifler[model] then
				table.insert (dmods, {file = v.file, model = v.model, boyut=v.boyut})
				totalSize = totalSize + v.boyut
			end
		end
		downloadMods()
	end
end)

function getMods()
	if mods then
		return mods,yuklendi
	end	
end

addEventHandler("onClientResourceStart",resourceRoot,function()
	triggerServerEvent("loader.onload",localPlayer)
end)

addEvent("loader.download",true)
addEventHandler("loader.download",root,function(model)
	downloadFile("files/" .. model .. ".txd")
	downloadFile("files/" .. model .. ".dff")
end)

addEventHandler("onClientFileDownloadComplete",root,function(name,success)
	if source == resourceRoot then
		if success then
			local index = table.find(mods,"file",name)
			if index then 
				exists[name] = true
				dosyaisim = isimler[name]
				local model = mods[index].model
				if name:find(".dff") then
					local dff = engineLoadDFF(name)
					engineReplaceModel(dff,model)
				elseif name:find(".txd") then 
					local txd = engineLoadTXD(name)
					engineImportTXD(txd,model)
				elseif name:find(".col") then
					local col = engineLoadCOL(name)
					engineReplaceCOL(col,model)
				end
				drawPercent = percent
				local file = fileOpen(name)
				local size = fileGetSize(file)
				fileClose(file)
				downloadedSize = downloadedSize + size
				percent = math.ceil((downloadedSize/totalSize)*100)
				tick = getTickCount()
				
				if model == 479 then
					setVehicleModelWheelSize(model, "all_wheels", 0.9)
				end
			end	
		end
	end
end)