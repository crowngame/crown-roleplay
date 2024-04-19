local screenX, screenY = guiGetScreenSize()
local playersCache = {}
local attachedPlayerSlot = {}
local renderTimers = {}
local colorsState = {}

local fonts = {
	headerBold = exports.cr_fonts:getFont("BebasNeueBold", 20),
	headerLight = exports.cr_fonts:getFont("BebasNeueLight", 20),
	columnRegular = exports.cr_fonts:getFont("BebasNeueRegular", 12),
	body = exports.cr_fonts:getFont("UbuntuRegular", 10),
}

local detailScroll = 1

local lastRenderCount = 0

local rowHeight = 30
local firstLoadCache = false

local width, height = 500, 550
local panelX, panelY = screenX / 2 - width / 2, screenY / 2 - height / 2

local requireDataList = {
    ["loggedin"] = true,
    ["level"] = true
}

local bindKey_ = bindKey
local unbindKey_ = unbindKey

local lastOpenAction = false

local hud

function getFirstLetters(str)
    local firstLetters = ""
    for a, b in ipairs(exports.cr_global:split(str, " ")) do
        firstLetters = firstLetters .. utf8.sub(b, 1, 1)
    end
    return firstLetters
end

function createRender(funcName, func, tick)
    if not tick then
        tick = 5
    end

    if not renderTimers[funcName] then
        renderTimers[funcName] = setTimer(func, tick, 0)
    end
end

function checkRender(funcName)
    return renderTimers[funcName]
end

function destroyRender(funcName)
    if renderTimers[funcName] then
        killTimer(renderTimers[funcName])
        renderTimers[funcName] = nil
        collectgarbage("collect")
    end
end

local function bindKey(keys, state, func)
    if type(keys) == "table" then
        for _, value in ipairs(keys) do
            bindKey(value, state, func)
        end
        return
    end
    return bindKey_(keys, state, func)
end

local function unbindKey(keys, state, func)
    if type(keys) == "table" then
        for _, value in ipairs(keys) do
            unbindKey(value, state, func)
        end
        return
    end
    return unbindKey_(keys, state, func)
end

local function sortPlayersCache()
    table.sort(playersCache, function(a, b)
        local idA, idB = a.playerid or 99, b.playerid or 99
        if localPlayerID == idA then
            idA = -1
        end
        if localPlayerID == idB then
            idB = -1
        end
        return idA < idB
    end)
end

local function detailScoreboardBind(key)
    if not (playersCount > detailFullShow) then
        return
    end
    if key == "pgup" or key == "mouse_wheel_up" then
        detailScroll = detailScroll - 15
        if detailScroll < 0 then
            detailScroll = 1
        end
        detailScrollMax = detailScroll + detailFullShow
    elseif key == "pgdn" or key == "mouse_wheel_down" then
        if detailScroll < #playersCache - detailFullShow then
            detailScroll = detailScroll + 15
        end
        detailScrollMax = detailScroll + detailFullShow

        if detailScrollMax > #playersCache then
            detailScrollMax = #playersCache
            detailScroll = #playersCache - detailFullShow
        end
    end
end

local function setupPlayersCache()
    localPlayerID = tonumber(localPlayer:getData("playerid"))

    for _, player_ in ipairs(getElementsByType("player")) do
        local loggedin = tonumber(player_:getData("loggedin") or 0)
        local playerID = tonumber(player_:getData("playerid") or 0)
        local tableInsertID = #playersCache + 1

        playersCache[tableInsertID] = {
            playerid = playerID,
            player = player_,
            name = player_.name:gsub("_", " "),
            level = player_:getData("level"),
            username = player_:getData("account:username") or "",
            loggedin = player_:getData("loggedin"),
			nametagcolor = Vector3(getPlayerNametagColor(player_)),
            ping = math.random(5, 20)
        }
        attachedPlayerSlot[playerID] = playersCache[tableInsertID]
    end

    firstLoadCache = true
    sortPlayersCache()
end

local function showScoreboard()
    if localPlayer:getData("loggedin") == 1 then
        if not checkRender("renderScoreboard") then
            if not firstLoadCache then
                setupPlayersCache()
            end
            if not isTimer(updatePingTimer) then
                updatePingTimer = setTimer(updatePing, 500, 0)
            end
            playersCount = #getElementsByType("player")
            if #playersCache ~= getElementsByType("player") then
                playersCache = {}
                attachedPlayerSlot = {}
                setupPlayersCache()
            end
            serverName = "CROWN"
            detailScroll = 1
            detailFullShow = math.floor((screenY / 1.7) / rowHeight)
            detailScrollMax = detailFullShow + 1

            hud = exports.cr_widget
            playerStaff = exports.cr_integration:isPlayerStaff(localPlayer) and exports.cr_global:isStaffOnDuty(localPlayer)
            lastOpenAction = not lastOpenAction
            toggleControl("next_weapon", false)
            toggleControl("previous_weapon", false)
            bindKey({ "pgup", "pgdn", "mouse_wheel_up", "mouse_wheel_down" }, "down", detailScoreboardBind)

            local visibleRowsCount = 0
            for index, _ in ipairs(playersCache) do
                if index >= detailScroll and index <= detailScrollMax then
                    visibleRowsCount = visibleRowsCount + 1
                end
            end

            local playersSectionHeight = visibleRowsCount * 28
            local logoSection = 40
            local panelHeight = playersSectionHeight + logoSection + rowHeight

            panelY = screenY / 2 - panelHeight / 2
            version = exports.cr_global:getScriptVersion()

            if not checkRender("renderScoreboard") then
                createRender("renderScoreboard", renderScoreboard)
            end
        end
    end
end

local function hideScoreboard()
    if localPlayer:getData("loggedin") == 1 then
        if checkRender("renderScoreboard") then
            destroyRender("renderScoreboard")
        end
        if isTimer(updatePingTimer) then
            killTimer(updatePingTimer)
        end
        toggleControl("next_weapon", true)
        toggleControl("previous_weapon", true)
        unbindKey({ "pgup", "pgdn", "mouse_wheel_up", "mouse_wheel_down" }, "down", detailScoreboardBind)
    end
end

bindKey("tab", "down", showScoreboard)
bindKey("tab", "up", hideScoreboard)

addEventHandler("onClientElementDataChange", root, function(dataName, _, newData)
    if source and source.type == "player" and requireDataList[dataName] then
        if playersCache[attachedPlayerSlot[source:getData("playerid")]] then
            playersCache[attachedPlayerSlot[source:getData("playerid")]][dataName] = newData
            if dataName == "playerid" then
                sortPlayersCache()
            end
        end
    end
end)

addEventHandler("onClientPlayerJoin", root, function()
    local tableInsertID = #playersCache + 1
    local playerID = source:getData("playerid")
    if not playerID then
        return
    end
    playersCache[tableInsertID] = {
        playerid = playerID,
        player = source,
        name = source.name:gsub("_", " "),
        username = source:getData("account:username") or "",
        level = source:getData("level"),
        loggedin = source:getData("loggedin"),
		nametagcolor = Vector3(getPlayerNametagColor(source)),
        ping = math.random(5, 20)
    }
    attachedPlayerSlot[playerID] = playersCache[tableInsertID]
    collectgarbage("collect")
    sortPlayersCache()
end)

addEventHandler("onClientPlayerQuit", root, function()
    for index, data in ipairs(playersCache) do
        if data.player == source then
            attachedPlayerSlot[data.playerid] = nil
            table.remove(playersCache, index)

            collectgarbage("collect")
        end
    end
    sortPlayersCache()
end)

addEventHandler("onClientPlayerChangeNick", root, function(_, newName)
    if attachedPlayerSlot[source:getData("playerid")] and playersCache[attachedPlayerSlot[source:getData("playerid")]] then
        playersCache[attachedPlayerSlot[source:getData("playerid")]]["name"] = newName:gsub("_", " ")
    end
end)

function updatePing()
    local lastRenderCount = 0
    for i = detailScroll, detailScrollMax + 30 do
        local data = playersCache[i]
        if data and lastRenderCount < detailScrollMax - detailScroll then
            if playersCache[i] and isElement(data.player) then
                playersCache[i]["ping"] = data.loggedin == 1 and data.player:getPing() or 0
                lastRenderCount = lastRenderCount + 1
            end
        end
    end
    playersCount = #getElementsByType("player")
end

function renderColumn(position, size, rows, background, color, font)
    dxDrawRectangle(position.x, position.y, size.x, size.y, background)

    local rowsWidth = size.x / #rows

    for i = 1, #rows do
        local row = rows[i]
        if row then
            if i == 1 then
                dxDrawText(row, position.x + 30, position.y, 0, position.y + size.y, color, 1, font, "left", "center", false, false, false, true)
            elseif i == 2 then
                dxDrawText(row, position.x + 80, position.y, 0, position.y + size.y, color, 1, font, "left", "center", false, false, false, true)
            elseif i == 3 then
                dxDrawText(row, position.x + rowsWidth * (i - 1), position.y, position.x + rowsWidth * i, position.y + size.y, color, 1, font, "center", "center", false, false, false, true)
            elseif i == 4 then
                dxDrawText(row, position.x + rowsWidth * (i - 1), position.y, position.x + rowsWidth * i, position.y + size.y, color, 1, font, "center", "center", false, false, false, true)
            end
        end
    end
end

function renderScoreboard()
    local serverNameTextWidth = dxGetTextWidth(serverName, 1, fonts.headerBold)
    dxDrawText(serverName, panelX, panelY - 40, 0, 0, tocolor(225, 225, 230), 1, fonts.headerBold, "left", "top")
    dxDrawText('ROLEPLAY', panelX + serverNameTextWidth + 3, panelY - 40, 0, 0, tocolor(225, 225, 230), 1, fonts.headerLight, "left", "top")

    renderColumn({
        x = panelX,
        y = panelY
    }, {
        x = width,
        y = rowHeight
    }, { 'ID', 'Karakter Adı', 'Seviye', 'Ping' }, tocolor(18, 18, 20), tocolor(102, 102, 102), fonts.columnRegular)
    dxDrawLine(panelX, panelY + rowHeight, panelX + width, panelY + rowHeight, tocolor(225, 225, 230), 1)

    if lastRenderCount and detailScrollMax > lastRenderCount then
        detailScrollMax = detailScrollMax - lastRenderCount
    end

    local i = 1
    for index, data in ipairs(playersCache) do
        if index >= detailScroll and index <= detailScrollMax then
            local playerY = panelY + (index - detailScroll + 1) * (rowHeight)

            local r, g, b = 145, 145, 145
            local alpha = 200
			if data["nametagcolor"] then
                r, g, b = data["nametagcolor"].x, data["nametagcolor"].y, data["nametagcolor"].z
            end

            local id = data["playerid"]
            local name = playerStaff and data.name .. " (" .. data.username .. ")" or data.name
            local level = data["level"] or 0
            local ping = data["ping"] or 0

            local background = i % 2 == 0 and tocolor(32, 32, 36) or tocolor(18, 18, 20)

            renderColumn({
                x = panelX,
                y = playerY
            }, {
                x = width,
                y = rowHeight
            }, { id, name, level, ping }, background, tocolor(r, g, b, alpha), fonts.body)

            i = i + 1
            lastY = playerY
        end
    end

    dxDrawRectangle(panelX, lastY + rowHeight, width, 35, tocolor(18, 18, 20, 230))

    local playersCountText = playersCount .. ' online'
    local textWidth = dxGetTextWidth(playersCountText, 1, fonts.columnRegular)

    dxDrawText('v' .. version .. ' love explore more', panelX + 20, lastY + rowHeight, width + (panelX + 20), 35 + (lastY + rowHeight), tocolor(50, 50, 56, 205), 1, fonts.columnRegular, "left", "center", false, false, false, true)
    dxDrawText(playersCountText, panelX - 20, lastY + rowHeight, width + (panelX - 20), 35 + (lastY + rowHeight), tocolor(196, 196, 204), 1, fonts.columnRegular, "right", "center", false, false, false, true)

    local opacity = math.abs(math.sin(getTickCount() / 500))
	dxDrawRectangle(panelX + width - 20 - textWidth - 15, lastY + rowHeight + 35 / 2 - 3, 10, 10, tocolor(0, 157, 110, 255 * opacity))

    if playersCount > detailFullShow then
        local trackW, trackH = 12, lastY - panelY + rowHeight
        local scrollX, scrollY = panelX + width + trackW + 1, panelY + 12
		
		dxDrawRectangle(scrollX, scrollY, trackW, trackH, tocolor(18, 18, 20, 230))

        local visibleFactor = math.min((detailScrollMax - detailScroll) / playersCount, 1.0)
        local gripHeight = trackH * visibleFactor
        local gripY = scrollY + math.min(detailScroll / playersCount, 1.0 - visibleFactor) * trackH

		dxDrawRectangle(scrollX, gripY, trackW, gripHeight, tocolor(242, 242, 242, 40))
    end
end