local sx, sy = guiGetScreenSize()
local scrSrc = dxCreateScreenSource(sx, sy)

local shaderFX = dxCreateShader("tinted_windows.fx", 1, 200, true)

function goodWindowTint()
	for key,veh in ipairs(getElementsByType("vehicle")) do
		if (getElementData(veh, "tinted") == true) then
			engineApplyShaderToWorldTexture(shaderFX, "vehiclegeneric256", veh)
			engineApplyShaderToWorldTexture(shaderFX, "hotdog92glass128", veh)
			engineApplyShaderToWorldTexture(shaderFX, "okoshko", veh)
			engineApplyShaderToWorldTexture(shaderFX, "@hite", veh)
		else
			engineRemoveShaderFromWorldTexture(shaderFX, "vehiclegeneric256", veh)
			engineRemoveShaderFromWorldTexture(shaderFX, "hotdog92glass128", veh)
			engineRemoveShaderFromWorldTexture(shaderFX, "okoshko", veh)
			engineRemoveShaderFromWorldTexture(shaderFX, "@hite", veh)
		end
	end
	for _, veh in ipairs(getElementsByType("vehicle")) do
		if (getElementData(veh, "faction") == 15) then
			local shader, tec = dxCreateShader ("texreplace.fx")
			local tex = dxCreateTexture ("textures/sasd.png")
			engineApplyShaderToWorldTexture (shader, "vehiclepoldecals128", veh)
			engineApplyShaderToWorldTexture (shader, "vehiclepoldecals128lod", veh)
			dxSetShaderValue (shader, "gTexture", tex)
		end
		if (getElementData(veh, "dbid") == 3) then
			local shader, tec = dxCreateShader ("texreplace.fx")
			local texs = dxCreateTexture ("textures/mv.png")
			engineApplyShaderToWorldTexture (shader, "elegy3body256", veh)
			engineApplyShaderToWorldTexture (shader, "elegy3body256lod", veh)
			dxSetShaderValue (shader, "gTexture", texs)
		end
		if (getElementData(veh, "dbid") == 6) then
			local shader, tec = dxCreateShader ("texreplace.fx")
			local texs = dxCreateTexture ("textures/elegy5.png")
			engineApplyShaderToWorldTexture (shader, "#emapelegybody128", veh)
			engineApplyShaderToWorldTexture (shader, "#emapelegybody128lod", veh)
			dxSetShaderValue (shader, "gTexture", texs)
		end
	end
end
addEvent("legitimateResponceRecived", true)
addEventHandler("legitimateResponceRecived", getRootElement(), goodWindowTint)

function startTheRes()
	triggerServerEvent("tintDemWindows", getLocalPlayer())
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), startTheRes)
addEventHandler("onVehicleRespawn", getResourceRootElement(getThisResource()), startTheRes)
addEvent("tintWindows", true)
addEventHandler("tintWindows", getRootElement(), startTheRes)

function loadEGMTextures(pixels, type)
	for _, veh in ipairs(getElementsByType("vehicle")) do
		if (getElementData(veh, "faction") == 1) and type == "car" then
			local shader, tec = dxCreateShader ("texreplace.fx")
			local tex = dxCreateTexture (pixels)
			engineApplyShaderToWorldTexture (shader, "vehiclepoldecals128", veh)
			engineApplyShaderToWorldTexture (shader, "vehiclepoldecals128lod", veh)
			dxSetShaderValue (shader, "gTexture", tex)
		end
		if (getElementData(veh, "faction") == 1) and type == "bike" then
			local shader, tec = dxCreateShader ("texreplace.fx")
			local tex = dxCreateTexture (pixels)
			engineApplyShaderToWorldTexture (shader, "copbike92decalSA64", veh)
			dxSetShaderValue (shader, "gTexture", tex)
		end
		if (getElementData(veh, "faction") == 1) and type == "bike2" and getElementModel(veh) == 523 then
			local shader, tec = dxCreateShader ("texreplace.fx")
			local tex = dxCreateTexture (pixels)
			engineApplyShaderToWorldTexture (shader, "vehiclepoldecals128", veh)
			engineApplyShaderToWorldTexture (shader, "vehiclepoldecals128lod", veh)
			dxSetShaderValue (shader, "gTexture", tex)
		end
	end
end
addEvent("loadEGMTextures", true)
addEventHandler("loadEGMTextures", getRootElement(), loadEGMTextures)
