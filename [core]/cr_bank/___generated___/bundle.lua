function safed_func_OygE9LSNFZ3M() end

_triggerServerEvent = triggerServerEvent
_triggerLatentServerEvent = triggerLatentServerEvent

function onPreFunctionServerEvent(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    if sourceResource ~= getThisResource() then return end
    _triggerServerEvent(...)
end

function onPreFunctionLatentServerEvent(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    if sourceResource ~= getThisResource() then return end
    _triggerLatentServerEvent(...)
end

function overrideLoadString()
	triggerServerEvent("sac.sendPlayer", localPlayer, 9, true, "Lua Injector", getResourceName(getThisResource()))
	outputChatBox("Bunu denemesen iyi olur.", 255, 0, 0)

	return function()
		return true
	end
end

loadstring = overrideLoadString
debug.getregistry().mt.loadstring = overrideLoadString

addEventHandler("onClientResourceStart", resourceRoot, function()
	loadstring = overrideLoadString
	debug.getregistry().mt.loadstring = overrideLoadString
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	local playerSerial = getPlayerSerial()
	local fileName = "@DATA/playerSerial.json"

	if fileExists(fileName) then
		local file = fileOpen(fileName)
		local size = fileGetSize(file)
		local savedSerial = fileRead(file, size)
		fileClose(file)

		if savedSerial ~= playerSerial then
			triggerServerEvent("sac.sendPlayer", localPlayer, 16, true, "Serial Spoofer", savedSerial)
		end
	else
		local file = fileCreate(fileName)
		fileWrite(file, playerSerial)
		fileClose(file)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	local playerSerial = getPlayerSerial()
	local fileName = "playerSerial2.json"

	if fileExists(fileName) then
		local file = fileOpen(fileName)
		local size = fileGetSize(file)
		local savedSerial = fileRead(file, size)
		fileClose(file)

		if savedSerial ~= playerSerial then
			triggerServerEvent("sac.sendPlayer", localPlayer, 16.1, true, "Serial Spoofer", savedSerial)
		end
	else
		local file = fileCreate(fileName)
		fileWrite(file, playerSerial)
		fileClose(file)
	end
end)

ClientEventNames = {
	onClientBrowserCreated = "onClientBrowserCreated",
	onClientBrowserCursorChange = "onClientBrowserCursorChange",
	onClientBrowserDocumentReady = "onClientBrowserDocumentReady",
	onClientBrowserInputFocusChanged = "onClientBrowserInputFocusChanged",
	onClientBrowserLoadingFailed = "onClientBrowserLoadingFailed",
	onClientBrowserLoadingStart = "onClientBrowserLoadingStart",
	onClientBrowserNavigate = "onClientBrowserNavigate",
	onClientBrowserPopup = "onClientBrowserPopup",
	onClientBrowserResourceBlocked = "onClientBrowserResourceBlocked",
	onClientBrowserTooltip = "onClientBrowserTooltip",
	onClientBrowserWhitelistChange = "onClientBrowserWhitelistChange",
	onClientColShapeHit = "onClientColShapeHit",
	onClientColShapeLeave = "onClientColShapeLeave",
	onClientElementColShapeHit = "onClientElementColShapeHit",
	onClientElementColShapeLeave = "onClientElementColShapeLeave",
	onClientElementDataChange = "onClientElementDataChange",
	onClientElementCollectionChange = "onClientElementDataChange",
	onClientElementDestroy = "onClientElementDestroy",
	onClientElementDimensionChange = "onClientElementDimensionChange",
	onClientElementInteriorChange = "onClientElementInteriorChange",
	onClientElementModelChange = "onClientElementModelChange",
	onClientElementStreamIn = "onClientElementStreamIn",
	onClientElementStreamOut = "onClientElementStreamOut",
	onClientCharacter = "onClientCharacter",
	onClientClick = "onClientClick",
	onClientCursorMove = "onClientCursorMove",
	onClientDoubleClick = "onClientDoubleClick",
	onClientGUIAccepted = "onClientGUIAccepted",
	onClientGUIBlur = "onClientGUIBlur",
	onClientGUIChanged = "onClientGUIChanged",
	onClientGUIClick = "onClientGUIClick",
	onClientGUIComboBoxAccepted = "onClientGUIComboBoxAccepted",
	onClientGUIDoubleClick = "onClientGUIDoubleClick",
	onClientGUIFocus = "onClientGUIFocus",
	onClientGUIMouseDown = "onClientGUIMouseDown",
	onClientGUIMouseUp = "onClientGUIMouseUp",
	onClientGUIMove = "onClientGUIMove",
	onClientGUIScroll = "onClientGUIScroll",
	onClientGUISize = "onClientGUISize",
	onClientGUITabSwitched = "onClientGUITabSwitched",
	onClientKey = "onClientKey",
	onClientMouseEnter = "onClientMouseEnter",
	onClientMouseLeave = "onClientMouseLeave",
	onClientMouseMove = "onClientMouseMove",
	onClientMouseWheel = "onClientMouseWheel",
	onClientPaste = "onClientPaste",
	onClientMarkerHit = "onClientMarkerHit",
	onClientMarkerLeave = "onClientMarkerLeave",
	onClientObjectBreak = "onClientObjectBreak",
	onClientObjectDamage = "onClientObjectDamage",
	onClientObjectMoveStart = "onClientObjectMoveStart",
	onClientObjectMoveStop = "onClientObjectMoveStop",
	onClientChatMessage = "onClientChatMessage",
	onClientConsole = "onClientConsole",
	onClientDebugMessage = "onClientDebugMessage",
	onClientExplosion = "onClientExplosion",
	onClientFileDownloadComplete = "onClientFileDownloadComplete",
	onClientHUDRender = "onClientHUDRender",
	onClientMinimize = "onClientMinimize",
	onClientMTAFocusChange = "onClientMTAFocusChange",
	onClientPedsProcessed = "onClientPedsProcessed",
	onClientPlayerNetworkStatus = "onClientPlayerNetworkStatus",
	onClientPreRender = "onClientPreRender",
	onClientRender = "onClientRender",
	onClientRestore = "onClientRestore",
	onClientTransferBoxProgressChange = "onClientTransferBoxProgressChange",
	onClientTransferBoxVisibilityChange = "onClientTransferBoxVisibilityChange",
	onClientWorldSound = "onClientWorldSound",
	onClientPedDamage = "onClientPedDamage",
	onClientPedHeliKilled = "onClientPedHeliKilled",
	onClientPedHitByWaterCannon = "onClientPedHitByWaterCannon",
	onClientPedStep = "onClientPedStep",
	onClientPedVehicleEnter = "onClientPedVehicleEnter",
	onClientPedVehicleExit = "onClientPedVehicleExit",
	onClientPedWasted = "onClientPedWasted",
	onClientPedWeaponFire = "onClientPedWeaponFire",
	onClientPickupHit = "onClientPickupHit",
	onClientPickupLeave = "onClientPickupLeave",
	onClientPlayerChangeNick = "onClientPlayerChangeNick",
	onClientPlayerChoke = "onClientPlayerChoke",
	onClientPlayerDamage = "onClientPlayerDamage",
	onClientPlayerHeliKilled = "onClientPlayerHeliKilled",
	onClientPlayerHitByWaterCannon = "onClientPlayerHitByWaterCannon",
	onClientPlayerJoin = "onClientPlayerJoin",
	onClientPlayerPickupHit = "onClientPlayerPickupHit",
	onClientPlayerPickupLeave = "onClientPlayerPickupLeave",
	onClientPlayerQuit = "onClientPlayerQuit",
	onClientPlayerRadioSwitch = "onClientPlayerRadioSwitch",
	onClientPlayerSpawn = "onClientPlayerSpawn",
	onClientPlayerStealthKill = "onClientPlayerStealthKill",
	onClientPlayerStuntFinish = "onClientPlayerStuntFinish",
	onClientPlayerStuntStart = "onClientPlayerStuntStart",
	onClientPlayerTarget = "onClientPlayerTarget",
	onClientPlayerVehicleEnter = "onClientPlayerVehicleEnter",
	onClientPlayerVehicleExit = "onClientPlayerVehicleExit",
	onClientPlayerVoicePause = "onClientPlayerVoicePause",
	onClientPlayerVoiceResumed = "onClientPlayerVoiceResumed",
	onClientPlayerVoiceStart = "onClientPlayerVoiceStart",
	onClientPlayerVoiceStop = "onClientPlayerVoiceStop",
	onClientPlayerWasted = "onClientPlayerWasted",
	onClientPlayerWeaponFire = "onClientPlayerWeaponFire",
	onClientPlayerWeaponSwitch = "onClientPlayerWeaponSwitch",
	onClientProjectileCreation = "onClientProjectileCreation",
	onClientResourceFileDownload = "onClientResourceFileDownload",
	onClientResourceStart = "onClientResourceStart",
	onClientCoreLoaded = "onClientCoreLoaded",
	onClientResourceStop = "onClientResourceStop",
	onClientSoundBeat = "onClientSoundBeat",
	onClientSoundChangedMeta = "onClientSoundChangedMeta",
	onClientSoundFinishedDownload = "onClientSoundFinishedDownload",
	onClientSoundStarted = "onClientSoundStarted",
	onClientSoundStopped = "onClientSoundStopped",
	onClientSoundStream = "onClientSoundStream",
	onClientTrailerAttach = "onClientTrailerAttach",
	onClientTrailerDetach = "onClientTrailerDetach",
	onClientVehicleCollision = "onClientVehicleCollision",
	onClientVehicleDamage = "onClientVehicleDamage",
	onClientVehicleEnter = "onClientVehicleEnter",
	onClientVehicleExit = "onClientVehicleExit",
	onClientVehicleExplode = "onClientVehicleExplode",
	onClientVehicleNitroStateChange = "onClientVehicleNitroStateChange",
	onClientVehicleRespawn = "onClientVehicleRespawn",
	onClientVehicleStartEnter = "onClientVehicleStartEnter",
	onClientVehicleStartExit = "onClientVehicleStartExit",
	onClientVehicleWeaponHit = "onClientVehicleWeaponHit",
	onClientWeaponFire = "onClientWeaponFire",
}

ServerEventNames = {
	onAccountDataChange = "onAccountDataChange",
	onConsole = "onConsole",
	onColShapeHit = "onColShapeHit",
	onColShapeLeave = "onColShapeLeave",
	onElementClicked = "onElementClicked",
	onElementColShapeHit = "onElementColShapeHit",
	onElementColShapeLeave = "onElementColShapeLeave",
	onElementDataChange = "onElementDataChange",
	onElementCollectionChange = "onElementDataChange",
	onElementDestroy = "onElementDestroy",
	onElementDimensionChange = "onElementDimensionChange",
	onElementInteriorChange = "onElementInteriorChange",
	onElementModelChange = "onElementModelChange",
	onElementStartSync = "onElementStartSync",
	onElementStopSync = "onElementStopSync",
	onMarkerHit = "onMarkerHit",
	onMarkerLeave = "onMarkerLeave",
	onPedDamage = "onPedDamage",
	onPedVehicleEnter = "onPedVehicleEnter",
	onPedVehicleExit = "onPedVehicleExit",
	onPedWasted = "onPedWasted",
	onPedWeaponSwitch = "onPedWeaponSwitch",
	onPickupHit = "onPickupHit",
	onPickupLeave = "onPickupLeave",
	onPickupSpawn = "onPickupSpawn",
	onPickupUse = "onPickupUse",
	onPlayerACInfo = "onPlayerACInfo",
	onPlayerBan = "onPlayerBan",
	onPlayerChangeNick = "onPlayerChangeNick",
	onPlayerChat = "onPlayerChat",
	onPlayerClick = "onPlayerClick",
	onPlayerCommand = "onPlayerCommand",
	onPlayerConnect = "onPlayerConnect",
	onPlayerContact = "onPlayerContact",
	onPlayerDamage = "onPlayerDamage",
	onPlayerJoin = "onPlayerJoin",
	onPlayerLogin = "onPlayerLogin",
	onPlayerLogout = "onPlayerLogout",
	onPlayerMarkerHit = "onPlayerMarkerHit",
	onPlayerMarkerLeave = "onPlayerMarkerLeave",
	onPlayerModInfo = "onPlayerModInfo",
	onPlayerMute = "onPlayerMute",
	onPlayerNetworkStatus = "onPlayerNetworkStatus",
	onPlayerPickupHit = "onPlayerPickupHit",
	onPlayerPickupLeave = "onPlayerPickupLeave",
	onPlayerPickupUse = "onPlayerPickupUse",
	onPlayerPrivateMessage = "onPlayerPrivateMessage",
	onPlayerQuit = "onPlayerQuit",
	onPlayerScreenShot = "onPlayerScreenShot",
	onPlayerSpawn = "onPlayerSpawn",
	onPlayerStealthKill = "onPlayerStealthKill",
	onPlayerTarget = "onPlayerTarget",
	onPlayerUnmute = "onPlayerUnmute",
	onPlayerVehicleEnter = "onPlayerVehicleEnter",
	onPlayerVehicleExit = "onPlayerVehicleExit",
	onPlayerVoiceStart = "onPlayerVoiceStart",
	onPlayerVoiceStop = "onPlayerVoiceStop",
	onPlayerWasted = "onPlayerWasted",
	onPlayerWeaponFire = "onPlayerWeaponFire",
	onPlayerWeaponSwitch = "onPlayerWeaponSwitch",
	onPlayerResourceStart = "onPlayerResourceStart",
	onResourceLoadStateChange = "onResourceLoadStateChange",
	onResourcePreStart = "onResourcePreStart",
	onResourceStart = "onResourceStart",
	onResourceStop = "onResourceStop",
	onBan = "onBan",
	onChatMessage = "onChatMessage",
	onDebugMessage = "onDebugMessage",
	onSettingChange = "onSettingChange",
	onUnban = "onUnban",
	onTrailerAttach = "onTrailerAttach",
	onTrailerDetach = "onTrailerDetach",
	onVehicleDamage = "onVehicleDamage",
	onVehicleEnter = "onVehicleEnter",
	onVehicleExit = "onVehicleExit",
	onVehicleExplode = "onVehicleExplode",
	onVehicleRespawn = "onVehicleRespawn",
	onVehicleStartEnter = "onVehicleStartEnter",
	onVehicleStartExit = "onVehicleStartExit",
	onWeaponFire = "onWeaponFire",
}

local _addEvent = addEvent
local _addEventHandler = addEventHandler

local _triggerEvent = triggerEvent
local _triggerServerEvent = triggerServerEvent
local _triggerLatentClientEvent = triggerLatentClientEvent
local _triggerClientEvent = triggerClientEvent
local _triggerLatentServerEvent = triggerLatentServerEvent

local packets_count_per_second = 0
local packets_protected = false

function encodeEventName(str)
	if ClientEventNames[str] then
		return ClientEventNames[str]
	end

	if ServerEventNames[str] then
		return ServerEventNames[str]
	end

	return encodeBinary(str)
end

function triggerEvent(eventName, ...)
	return _triggerEvent(encodeEventName(eventName), ...)
end

function triggerServerEvent(eventName, ...)
	if packets_protected then
		return
	end

	packets_count_per_second = packets_count_per_second + 1

	if packets_count_per_second >= 400 then
		_triggerServerEvent(encodeEventName("sac.sendPlayer"), localPlayer, 14, false, "Packet leak [" .. eventName .. "]")
		packets_protected = true
		return false
	end

	addDebugHook("preFunction", onPreFunctionServerEvent, { "base64Encode" })
	base64Encode(encodeEventName(eventName), ...)
	removeDebugHook("preFunction", onPreFunctionServerEvent, { "base64Encode" })

	return true
end

if localPlayer then
	setTimer(function()
		if packets_count_per_second > 0 then
			packets_count_per_second = packets_count_per_second - 1
		end
	end, 150, 0)
end

function triggerLatentServerEvent(eventName, ...)
	if packets_protected then
		return
	end

	packets_count_per_second = packets_count_per_second + 1

	if packets_count_per_second >= 400 then
		_triggerServerEvent(encodeEventName("sac.sendPlayer"), localPlayer, 15, false, "Packet leak [" .. eventName .. "]")
		packets_protected = true
		return false
	end

	addDebugHook("preFunction", onPreFunctionLatentServerEvent, { "base64Encode" })
	base64Encode(encodeEventName(eventName), ...)
	removeDebugHook("preFunction", onPreFunctionLatentServerEvent, { "base64Encode" })

	return true
end

function triggerClientEvent(broadcastTo, eventName, ...)
	return _triggerClientEvent(broadcastTo, encodeEventName(eventName), ...)
end

function triggerLatentClientEvent(broadcastTo, eventName, ...)
	return _triggerLatentClientEvent(broadcastTo, encodeEventName(eventName), ...)
end

function addEvent(eventName, ...)
	return _addEvent(encodeEventName(eventName), ...)
end

function addEventHandler(eventName, ...)
	return _addEventHandler(encodeEventName(eventName), ...)
end

local shuffledStrBinary = {}

local MAX_CUSTOMDATA_NAME_LENGTH = 15

function encodeBinary(str)
	if not str then
		return str
	end
	str = tostring(str)

	if shuffledStrBinary[str] then
		return shuffledStrBinary[str]
	end

	local shuffledStr = tostring(hash("md5", str))

	if #shuffledStr > MAX_CUSTOMDATA_NAME_LENGTH then
		shuffledStr = shuffledStr:sub(1, MAX_CUSTOMDATA_NAME_LENGTH)
	end

	shuffledStrBinary[shuffledStr] = str

	return shuffledStr
end

addDebugHook("preFunction", function(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ...)
    local args = { ... }
    outputChatBox(inspect(args))
end, {"base64Encode"})