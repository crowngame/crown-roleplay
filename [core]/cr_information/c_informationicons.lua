-- scripted by Jesse
local sx, sy = guiGetScreenSize()
local pickupsCache = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		--create first details
		for index, value in ipairs(getElementsByType("pickup")) do
			if not pickupsCache[value] then
				if isElementStreamedIn(value) then
					createCache(value)
				end
			end
		end
		addEventHandler("onClientRender", root, drawnPickupText)
	end
)

addEventHandler("onClientElementStreamIn", root,
    function()
        if getElementType(source) == "pickup" then
            createCache(source)
        end
    end
)

addEventHandler("onClientElementStreamOut", root,
    function()
        if getElementType(source) == "pickup" then
            destroyCache(source)
        end
    end
)

local allowedModels = {
	[1239] = true,
}

function createCache(pickup)
 	if pickup and isElement(pickup) and allowedModels[getElementModel(pickup)] then
		x, y, z = getElementPosition(pickup)
		pickupsCache[pickup] = {
			["position"] = {x, y, z},
			["name"] = (getElementData(pickup, "informationicon:information") or ""),
			["id"] = (getElementData(pickup, "informationicon:id") or ""),
		}
	end
end

function destroyCache(pickup)
	if pickup and isElement(pickup) then
		pickupsCache[pickup] = nil
	end
end

function drawnPickupText()
	local cx,cy,cz = getCameraMatrix()
	for pickup, value in pairs(pickupsCache) do
		if not isElement(pickup) then
			pickupsCache[pickup] = nil
			break
		end
		local x, y, z = unpack(value.position)
		local information_text = value.name
		local information_id = value.id

		if exports.cr_global:isStaffOnDuty(localPlayer) then 
			information_text = information_text .. " (" .. information_id .. ")"
		else 
			information_text = information_text
		end
		
		if getElementData(localPlayer, "radaracik") then return end
		if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 20 then
			local px,py,pz = getScreenFromWorldPosition(x,y,z+0.5,0.05)
			if isLineOfSightClear(cx, cy, cz, x, y, z, true, true, true, true, true, false, false) then
				if (px and py) then
					--dxDrawText(information_text, px, py, px, py, tocolor(247, 159, 31, 255), 1, "default-bold", "center", "center", false, false)
					dxDrawFramedText(information_text, px, py, px, py, tocolor(255, 215, 0, 255), 1.2, "default-bold", "center", "top", false, false, false, true, true)
				end
			end
		end
	end
end

function dxDrawFramedText (message , left , top , width , height , color , scale , font , alignX , alignY , clip , wordBreak , postGUI , colorCoded , subPixel)
    dxDrawText (message , left + 1 , top + 1.2 , width + 1 , height + 1 , tocolor (0 , 0 , 0 , alpha) , scale , font , alignX , alignY , clip , wordBreak , postGUI)
    dxDrawText (message , left + 1 , top - 1.2 , width + 1 , height - 1 , tocolor (0 , 0 , 0 , alpha) , scale , font , alignX , alignY , clip , wordBreak , postGUI)
    dxDrawText (message , left - 1 , top + 1.2 , width - 1 , height + 1 , tocolor (0 , 0 , 0 , alpha) , scale , font , alignX , alignY , clip , wordBreak , postGUI)
    dxDrawText (message , left - 1 , top - 1.2 , width - 1 , height - 1 , tocolor (0 , 0 , 0 , alpha) , scale , font , alignX , alignY , clip , wordBreak , postGUI)
    dxDrawText (message , left , top , width , height , color , scale , font , alignX , alignY , clip , wordBreak , postGUI , colorCoded , subPixel)
end