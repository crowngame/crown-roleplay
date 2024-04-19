addDebugHook("preFunction", function(sourceResource, functionName, isAllowedByACL, luaFileName, luaLineNumber, ...)
	local args = {...}
	local resourceName = sourceResource and getResourceName(sourceResource)
	triggerServerEvent("sac.sendPlayer", localPlayer, 5, true, "Lua Executor", resourceName, luaFileName, luaLineNumber, args[1])
    cancelEvent()
	return "skip"
end, {"loadstring"})

local mtaFunctions = {
	["setElementData"] = true,
	["triggerEvent"] = true,
	["triggerServerEvent"] = true,
	["triggerClientEvent"] = true,
	["triggerLatentServerEvent"] = true,
	["outputChatBox"] = true,
	["function"] = true,
	["addEvent"] = true,
	["addEventHandler"] = true,
	["addDebugHook"] = true,
	["createExplosion"] = true,
	["createProjectile"] = true,
	["setElementPosition"] = true,
	["outputChatBox"] = true,
	["loadstring"] = true,
	["addCommandHandler"] = true,
}

setTimer(function()
	for _, memo in ipairs(getElementsByType("gui-memo")) do
		if memo then
			text = guiGetText(memo) or "test"
			for index, value in pairs(mtaFunctions) do
				if string.find((text), index) then
					triggerServerEvent("sac.sendPlayer", localPlayer, 4, true, "Lua Executor Panel", text)
				end
			end
		end
	end
	
	for _, edit in ipairs(getElementsByType("gui-edit")) do
		if edit then
			text = guiGetText(edit) or "test"
			for index, value in pairs(mtaFunctions) do
				if string.find((text), index) then
					triggerServerEvent("sac.detectedPlayer", localPlayer, 4, true, "Lua Executor Panel", text)
				end
			end
		end
	end
end, 1000, 0)

local blockedExplosionTypes = {
    [0] = true,
    [2] = true,
    [3] = true,
    [10] = true,
}

addEventHandler("onClientExplosion", root, function(x, y, z, theType)
    if blockedExplosionTypes[theType] then
        cancelEvent()
    end
end)

--==============================================================================================================

local screenSize = Vector2(guiGetScreenSize())

setTimer(function()
	if not dxGetStatus().AllowScreenUpload then
		dxDrawRectangle(0, 0, screenSize.x, screenSize.y, tocolor(0, 0, 0, 255), true)
		dxDrawText('ESC > Ayarlar > "Ekran yüklemesine izin verin" aktifleştirin!', screenSize.x, screenSize.y, 0, 0, tocolor(255, 0, 0, 255), 3, "default-bold", "center", "center", false, false, true)
	end
end, 0, 0)