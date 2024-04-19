mysql = exports.cr_mysql
reports = { }
local reportsToAward = 30
local gcToAward = 1

local getPlayerName_ = getPlayerName
getPlayerName = function(...)
	if not (...) or not isElement((...)) then
		return "Unknown"
	else
		s = getPlayerName_(...)
		return s and s:gsub("_", " ") or s
	end
end

function reportLazyFix(player, cmd) -- / Farid
	--if exports.cr_integration:isPlayerStaff(player) then
		groups = ','
		local admin_level = getElementData(player, "admin_level") or 0
	    if (admin_level == 1) then
	        groups=groups .. '18,'
	    elseif (admin_level == 2) then
	        groups=groups .. '17,'
	    elseif (admin_level == 3) then
	        groups=groups .. '64,'
	    elseif (admin_level == 4) then
	        groups=groups .. '15,'
	    end

	    local supporter_level = getElementData(player, "supporter_level") or 0
	    if (supporter_level == 1) then
	        groups=groups .. '30,'
	    end

	    local vct_level = getElementData(player, "vct_level") or 0
	    if (vct_level == 1) then
	        groups=groups .. '43,'
	    elseif (vct_level == 2) then
	        groups=groups .. '39,'
	    end

	    local scripter_level = getElementData(player, "scripter_level") or 0
	    if (scripter_level > 0) then
	        groups=groups .. '32,'
	    end

	    local mapper_level = getElementData(player, "mapper_level") or 0
	    if (mapper_level == 1) then
	        groups=groups .. '28,'
	    elseif (mapper_level == 2) then
	        groups=groups .. '44,'
	    end
	    if string.len(groups) > 0 then
			groups = string.sub(groups,1, string.len(groups)-1)
		end
		--outputDebugString("[reportLazyFix] " .. getElementData(player,"account:username") .. " - " .. groups)
	    setElementData(player, "forum_perms", groups, false, true)
	--end
end
addCommandHandler("reportlazyfix", reportLazyFix)


function toggleStatus(thePlayer, section, status)
	local newstatus
	if status == "Kapalı" then
		newstatus = "Açık"
	end
	if status == "Açık" then
		newstatus = "Kapalı"
	end
	exports.cr_global:sendWrnToStaff(getPlayerName(thePlayer) .. " has toggled " .. section .. " to " .. newstatus, "STATUS")
end
addEvent("toggleStatus", true)
addEventHandler("toggleStatus", getRootElement(), toggleStatus)


-- Farid TWEAKS
MTAoutputChatBox = outputChatBox
local function outputChatBox(text, visibleTo, r, g, b, colorCoded)
	if showExternalReportBox(visibleTo) then
		showToAdminPanel(text, visibleTo, r,g,b)
		outputConsole (text, visibleTo)
	else
		--showToAdminPanel(text, visibleTo, r,g,b)
		if string.len(text) > 128 then -- MTA Chatbox size limit
			MTAoutputChatBox(string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded )
			outputChatBox(string.sub(text, 128), visibleTo, r, g, b, colorCoded )
		else
			MTAoutputChatBox(text, visibleTo, r, g, b, colorCoded )
		end
	end
end

function resourceStart(res)
	reports = exports.cr_data:loadReports() or {}
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)

function resourceStop(res)
	exports.cr_data:saveReports(reports)
end
addEventHandler("onResourceStop", getResourceRootElement(), resourceStop)

function getAdminCount()
	local online, duty, lead, leadduty, gm, gmduty = 0, 0, 0, 0,0,0
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) then
			local level = getElementData(value, "admin_level") or 0
			if level >= 1 and level <= 6 then
				online = online + 1

				local aod = getElementData(value, "duty_admin") or 0
				if aod == 1 then
					duty = duty + 1
				end

				if level >= 5 then
					lead = lead + 1
					if aod == 1 then
						leadduty = leadduty + 1
					end
				end
			end

			if exports.cr_integration:isPlayerHelper(value) then
				gm = gm + 1

				local aod = (getElementData(value, "duty_supporter") == 1)
				if aod == true then
					gmduty = gmduty + 1
				end
			end
		end
	end
	return online, duty, lead, leadduty, gm, gmduty
end

function updateReportCount()
	local open = {}
	local handled = {}

	unanswered = {}
	local byadmin = {}
	local alreadyTold = {}

	for k, v in ipairs(getElementsByType("player")) do
		unanswered[v] = { }
		byadmin[v] = { }
		open[v] = 0
		handled[v] = 0
		if exports.cr_integration:isPlayerTrialAdmin(v) and getElementData(v, "loggedin") == 1 then
			local alreadyTold = {}
			for key, value in pairs(reports) do
				local staff, _, n, abrv = getReportInfo(value[7])
				if staff then
					for g, u in ipairs(staff) do
						if (value[5] == v) and not alreadyTold[key] then
							open[v] = open[v] + 1
							alreadyTold[key] = true
							if value[5] then
								handled[v] = handled[v] + 1
								if not byadmin[v][value[5]] then
									byadmin[v][value[5]] = { key }
								else
									table.insert(byadmin[v][value[5]], key)
								end
							else
								table.insert(unanswered[v], abrv .. "" .. tostring(key))
							end
						end
					end
				end
			end
		end
	end
	local answeredReports, unansweredReports = "", ""
	for i = 1, #reports do
		local report = reports[i]
		if report then
			local reporter = report[1]
			local reported = report[2]
			local timestring = report[4]
			local admin = report[5]
			local staff, _, name, abrv, r, g, b = getReportInfo(report[7])
			local seenReport = { }
			local handler = ""

			if (isElement(admin)) then
				local adminName = getElementData(admin, "account:username")
				handler = tostring(getPlayerName(admin)) .. " (" .. adminName .. ")"
			else
				handler = false
			end
			if handler then
				answeredReports = answeredReports .. "#" .. i
			else
				unansweredReports = unansweredReports .. "#" .. i
			end
		end
	end

	-- admstr
	local online, duty, lead, leadduty, gm, gmduty = getAdminCount()

	for key, value in ipairs(getElementsByType("player")) do
		if exports.cr_integration:isPlayerStaff(value) then
			if exports.cr_integration:isPlayerTrialAdmin(value) then
				str = ":: " .. gmduty .. "/" .. gm .. " SUP :: " .. duty  .. "/" ..  online  .. " admins"
			elseif exports.cr_integration:isPlayerHelper(value) then
				str = ":: " .. gmduty .. "/" .. gm .. " SUP"
			else
				str = ""
			end

			--triggerClientEvent(value, "updateReportsCount", value, answeredReports, "", unansweredReports, byadmin[value][value], str)
		end
	end
end

addEventHandler("onElementDataChange", getRootElement(),
	function(n)
		if getElementType(source) == "player" and (n == "admin_level" or n == "duty_admin" or  n == "account:gmlevel" or n == "duty_supporter") then
			sortReports(false)
			updateReportCount()
		end
	end
)

function updateReportsAdminUI()
	sortReports(false)
	updateReportCount()
end
addEvent("updateReportsForUI", true)
addEventHandler("updateReportsForUI", root, updateReportsAdminUI)

function FaridReportsReminder()
	for key, value in ipairs(getElementsByType("player")) do
		local level = getElementData(value, "admin_level") or 0
		local aod = getElementData(value, "duty_admin") or 0
		local god = getElementData(value, "duty_supporter") or false
		if (exports.cr_integration:isPlayerHelper(value) and god == 1) or (exports.cr_integration:isPlayerTrialAdmin(value) and aod == 1) then
			showUnansweredReports(value)
		end
	end
end
setTimer(FaridReportsReminder, 5*60*1000 , 0) -- every 5 mins.

function sortReports(showMessage) -- Farid
	-- reports[slot] = { }
	-- reports[slot][1] = source -- Reporter
	-- reports[slot][2] = reportedPlayer -- Reported Player
	-- reports[slot][3] = reportedReason -- Reported Reason
	-- reports[slot][4] = timestring -- Time reported at
	-- reports[slot][5] = nil -- Admin dealing with the report
	-- reports[slot][6] = alertTimer -- Alert timer of the report
	-- reports[slot][7] = reportType -- Type report
	-- reports[slot][8] = slot -- Report ID/Slot, used in rolling queue function / Farid
	local sortedReports = {}
	local adminNotice = ""
	local gmNotice = ""
	local unsortedReports = reports

	for key , report in pairs(reports) do
		table.insert(sortedReports, report)
	end

	reports = sortedReports

	for key, report in pairs(reports) do
		if report[8] ~= key then
			if isSupporterReport(report[7]) then
				adminNotice = adminNotice .. "#" .. report[8] .. ", "
				if showMessage then
					outputChatBox("[!]#FFFFFF #" .. report[8] .. " numaralı raporun #" .. key .. " sırasına taşındı.", report[1], 70, 200, 30, true)
				end
			else -- Admin report
				adminNotice = adminNotice .. "#" .. report[8] .. ", "
				gmNotice = gmNotice .. "#" .. report[8] .. ", "
				if showMessage then
					outputChatBox("[!]#FFFFFF #" .. report[8] .. " numaralı raporun #" .. key .. " sırasına taşındı.", report[1], 255, 195, 15, true)
				end
			end
			setElementData(report[1], "reportNum", key)
			report[8] = key
		end
	end

	if showMessage then
		if adminNotice ~= "" then
			adminNotice = string.sub(adminNotice, 1, (string.len(adminNotice) - 2))
			local admins = exports.cr_global:getAdmins()
			for key, value in ipairs(admins) do
				local adminduty = getElementData(value, "duty_admin")
				if (adminduty==1) then
					--outputChatBox("[ADM]#FFFFFF " .. adminNotice .. " numaralı raporlar önceki sıraya kaydırıldı.", value, 255, 195, 15,true)
				end
			end
		end
		if gmNotice ~= "" then
			gmNotice = string.sub(gmNotice, 1, (string.len(gmNotice) - 2))
			local gms = exports.cr_global:getGameMasters()
			for key, value in ipairs(gms) do
				local gmDuty = getElementData(value, "duty_supporter")
				if (gmDuty == 1) then
					--outputChatBox("[SUP]#FFFFFF " .. gmNotice .. " numaralı raporlar önceki sıraya kaydırıldı.", value, 70, 200, 30,true)
				end
			end
		end

	end

end

function showCKList(thePlayer)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) then
		outputChatBox("~~~~~~~~~ Self-CK Requests ~~~~~~~~~", thePlayer, 255, 194, 15)

		local ckcount = 0
		local players = exports.cr_pool:getPoolElementsByType("player")
		for key, value in ipairs(players) do
			local logged = getElementData(value, "loggedin")
			if (logged==1) then
				local requested = getElementData(value, "ckstatus")
				local reason = getElementData(value, "ckreason")
				local pname = getPlayerName(value):gsub("_", " ")
				local playerID = getElementData(value, "playerid")
				if requested=="requested" then
					ckcount = 1
					outputChatBox("Self-CK Request from '" .. pname .. "' (" .. playerID .. ") for the reason '" .. reason .. "'.", thePlayer, 255, 195, 15)
				end
			end
		end

		if ckcount == 0 then
		--	outputChatBox("- Yok.", thePlayer, 255, 255, 255)
		else
			outputChatBox("Use /cka [id] or /ckd [id] to answer the request(s).", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("cks", showCKList)

function reportInfo(thePlayer, commandName, id)
	if exports.cr_integration:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: " .. commandName .. " [ID]", thePlayer, 255, 194, 15)
		else
			local isOverlayDisabled = getElementData(thePlayer, "hud:isOverlayDisabled")
			id = tonumber(id)
			if reports[id] then
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local timestring = reports[id][4]
				local admin = reports[id][5]
				local staff, _, n, abrv, r, g, b = getReportInfo(reports[id][7])

				local playerID = getElementData(reporter, "playerid") or "Unknown"
				local reportedID = getElementData(reported, "playerid") or "Unknown"


				if staff then
					outputChatBox("[#" .. id  .. "] (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " raporladı (" .. reportedID .. ") " .. tostring(getPlayerName(reported)) .. " saat " .. timestring .. ".", thePlayer, r, g, b,true)
					outputChatBox("Sebep: " .. reason, thePlayer, 70, 200, 30,true)
					--outputDebugString(getElementData(thePlayer, "report_panel_mod")) -- shit
					local handler = ""
					if (isElement(admin)) then
						local adminName = getElementData(admin, "account:username")
						outputChatBox("[#" .. id  .. "] Bu rapor " .. getPlayerName(admin) .. " (" .. adminName .. ") adlı yetkilinin kontrolü altında.", thePlayer, 70, 200, 30,true)
					else
						--outputChatBox("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", thePlayer, 255, 221, 117)
						--outputChatBox("   Type /ar " .. id .. " to accept this report. Type /togautocheck to turn on/off auto-check when accepting reports.", thePlayer, 255, 194, 15)
					end
				end


			else
				outputChatBox("[!]#FFFFFF Geçersiz Rapor ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("reportinfo", reportInfo, false, false)
addCommandHandler("ri", reportInfo, false, false)

function changeReportType(thePlayer, commandName, id, rID)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) then
		if not (id) or not (rID) then
			outputChatBox("KULLANIM: " .. commandName .. " [ID] [Report Type ID]", thePlayer, 255, 194, 15)
			outputChatBox("KULLANIM: REPORT TYPES:", thePlayer, 255, 194, 15)
			for ha, lol in ipairs(reportTypes) do
				outputChatBox("#" .. ha .. " - " .. lol[1], thePlayer, 255, 194, 15)
			end
		else
			id = tonumber(id)
			reportID = tonumber(rID)
			if reportID > #reportTypes or reportID < 1 then
				outputChatBox("Error: No report type with that ID found.", thePlayer, 255, 0, 0)
				return
			end
			if reports[id] then
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local timestring = reports[id][4]
				local oldReportType = reports[id][7]

				if oldReportType == reportID then
					outputChatBox("Error: Report was already of that type.", thePlayer, 255, 0, 0)
					return
				end

				local ostaff, _, oname, oabrv = getReportInfo(oldReportType)
				reports[id][7] = reportID
				local staff, _, name, abrv, r, g, b = getReportInfo(reportID)

				if not staff then
					outputChatBox("No Auxiliary staff members of that type online.", thePlayer, 255, 0, 0)
					reports[id][7] = oldReportType
					return
				end
				updateReportCount()
				local playerID = getElementData(reporter, "playerid")
				local reportedID = getElementData(reported, "playerid")
				local adminUser = getElementData(thePlayer, "account:username")

				local players = exports.cr_pool:getPoolElementsByType("player")

				local GMs = exports.cr_global:getGameMasters()
				local admins = exports.cr_global:getAdmins()

				outputChatBox("Your report has been changed from '" .. oname .. "'' to '" .. name .. "' by " .. adminUser, reporter, 255, 126, 0)
				for k, v in ipairs(staff) do
					if string.find(auxiliaryTeams, v) then
						outputChatBox("Report #" .. id .. " - Type changed to " .. name .. ".", thePlayer, 255, 126, 0)
						for key, value in pairs(players) do
							if getElementData(value, "loggedin") == 1 then
								outputChatBox("[#" .. id  .. "] (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reported)) .. " at " .. timestring .. ".", value, r, g, b)--200, 240, 120)
								outputChatBox("Reason: " .. reason, value, 200, 240, 120)
							end
						end
					else
						if isSupporterReport(oldReportType) then
							for key, value in pairs(GMs) do
								local gmDuty = getElementData(value, "duty_supporter")
								if (gmDuty == 1) then
									outputChatBox("Report #" .. id .. " - Type changed from '" .. oname.. "'' to '" .. name .. "'", value, 255, 126, 0)
								end
							end
							for key, value in pairs(admins) do
								local aDuty = getElementData(value, "duty_admin")
								if aDuty == 1 then
									outputChatBox("Report #" .. id .. " - Type changed from '" .. oname.. "'' to '" .. name .. "'", value, 255, 126, 0)
								end
							end
							return
						else
							if isSupporterReport(reportID) then
								for key, value in pairs(GMs) do
									local gmDuty = getElementData(value, "duty_supporter")
									if (gmDuty == 1) then
										outputChatBox("Report #" .. id .. " - Type changed from '" .. oname.. "'' to '" .. name .. "'", value, 255, 126, 0)
									end
								end
								for key, value in pairs(admins) do
									local aDuty = getElementData(value, "duty_admin")
									if aDuty == 1 then
										outputChatBox("Report #" .. id .. " - Type changed from '" .. oname.. "'' to '" .. name .. "'", value, 255, 126, 0)
									end
								end
								return
							else
								for key, value in pairs(admins) do
									local aDuty = getElementData(value, "duty_admin")
									if aDuty == 1 then
										outputChatBox("Report #" .. id .. " - Type changed from '" .. oname.. "'' to '" .. name .. "'", value, 255, 126, 0)
									end
								end
								return
							end
						end
					end
				end
			else
				outputChatBox("[!]#FFFFFF Geçersiz Rapor ID.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("changereport", changeReportType, false, false)
addCommandHandler("cp", changeReportType, false, false)

function playerQuit()
	local originalReportID = getElementData(source, "adminreport")
	local update = false
	local alreadyTold = { }

	if originalReportID then
		-- find the actual report id
		local report = nil
		for i = 1, originalReportID do
			if reports[i] and reports[i][1] and reports[i][1] == source then
				report = i
				break
			end
		end
		if report and reports[report] then
			local theAdmin = reports[report][5]
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[report][7])


			if (isElement(theAdmin)) then
					outputChatBox("[#" .. report  .. "] Player " .. getPlayerName(source) .. " left the game.", theAdmin, 255, 126, 0)--200, 240, 120)
			else
				if staff then -- Check if the aux players are online
					for k, usergroup in ipairs(staff) do
						if string.find(auxiliaryTeams, usergroup) then
							for key, value in ipairs(getElementsByType("players")) do
								if getElementData(value, "loggedin") == 1 then
									if not alreadyTold[value] then
										outputChatBox("[#" .. report  .. "] Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)
										alreadyTold[value] = true
									end
								end
							end
						else
							for key, value in ipairs(getElementsByType("players")) do
								if getElementData(value, "loggedin") == 1 then
									if not alreadyTold[value] then
										local gmduty = getElementData(value, "duty_supporter")
										local adminduty = getElementData(value, "duty_admin")
										if adminduty == 1 or gmduty == 1 then
											outputChatBox("[#" .. report  .. "] Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)
											alreadyTold[value] = true
										end
									end
								end
							end
						end
					end
				end
			end

			local alertTimer = reports[report][6]
			--local timeoutTimer = reports[report][7]

			if isTimer(alertTimer) then
				killTimer(alertTimer)
			end

			--[[if isTimer(timeoutTimer) then
				killTimer(timeoutTimer)
			end]]
			if reports[report] then
				reports[report] = nil -- Destroy any reports made by the player
			end
			update = true
		else
			outputDebugString('report/onPlayerQuit: ' .. getPlayerName(source) .. ' has undefined report pending')
		end
	end

	local alreadyTold = { }
	-- check for reports assigned to him, unassigned if neccessary
	for i = 1, #reports do
		if reports[i] and reports[i][5] == 5 then
			reports[i][5] = nil
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[i][7])
			if staff then -- Check if the aux players are online
				for k, usergroup in ipairs(staff) do
					if string.find(auxiliaryTeams, usergroup) then
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if not alreadyTold[value] then
									local adminName = getElementData(source, "account:username")
									outputChatBox("[#" .. i  .. "] Report is unassigned (" .. adminName .. " left the game)", value, 255, 126, 0)
									alreadyTold[value] = true
									update = true
								end
							end
						end
					else
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if not alreadyTold[value] then
									local gmduty = getElementData(value, "duty_supporter")
									local adminduty = getElementData(value, "duty_admin")
									if adminduty == 1 or gmduty == 1 then
										local adminName = getElementData(source, "account:username")
										outputChatBox("[#" .. i  .. "] Report is unassigned (" .. adminName .. " left the game)", value, 255, 126, 0)--200, 240, 120)
										alreadyTold[value] = true
										update = true
									end
								end
							end
						end
					end
				end
			else
				update = true
			end
		elseif reports[i] and reports[i][2] == source then
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[i][7])
			if staff then -- Check if the aux players are online
				for k, usergroup in ipairs(staff) do
					if string.find(auxiliaryTeams, usergroup) then
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if not alreadyTold[value] then
									local adminName = getElementData(source, "account:username")
									outputChatBox("[#" .. i  .. "] Reported Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)
									alreadyTold[value] = true
									update = true
								end
							end
						end
					else
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if not alreadyTold[value] then
									local gmduty = getElementData(value, "duty_supporter")
									local adminduty = getElementData(value, "duty_admin")
									if adminduty == 1 or gmduty == 1 then
										outputChatBox("[#" .. i  .. "] Reported Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)--200, 240, 120)
										update = true
										alreadyTold[value] = true
									end
								end
							end
						end
					end
				end
			else
				update = true
			end
			local reporter = reports[i][1]
			if reporter ~= source then
				local adminName = getElementData(source, "account:username")
				outputChatBox("Your report " .. abrv .. "#" .. i .. " has been closed (" .. adminName .. " left the game)", reporter, 255, 126, 0)--200, 240, 120)
				setElementData(reporter, "adminreport", false, true)
				setElementData(reporter, "gmreport", false, true)
				setElementData(reporter, "reportadmin", false, false)
			end

			local alertTimer = reports[i][6]
			--local timeoutTimer = reports[i][7]
			if isTimer(alertTimer) then
				killTimer(alertTimer)
			end
			--[[if isTimer(timeoutTimer) then
				killTimer(timeoutTimer)
			end]]
			reports[i] = nil -- Destroy any reports made by the player
		end
	end

	if exports.cr_integration:isPlayerStaff(source) then -- Check if a Aux staff member went offline and there is noone left to handle the report.
		for i = 1, #reports do
			if reports[i] then
				local staff, _ = getReportInfo(reports[i][7], source)
				if not staff then
					outputChatBox(_, reports[i][1], 255, 0, 0)
					outputChatBox("Your report has automatically been closed.", reports[i][1], 255, 0, 0)
					reports[i] = nil
					update = true
				end
			end
		end
	end

	local requested = getElementData(source, "ckstatus") -- Clear any Self-CK requests the player may have.
	if (requested=="requested") then
		for key, value in ipairs(exports.cr_global:getAdmins()) do
			triggerClientEvent(value, "subtractOneFromCKCount", value)
		end
		setElementData(source, "ckstatus", 0)
		setElementData(source, "ckreason", 0)
	end

	if update then
		sortReports(true)
		updateReportCount()
	end


end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)
addEventHandler("accounts:characters:change", getRootElement(), playerQuit)

function playerConnect()
	if exports.cr_integration:isPlayerTrialAdmin(source) then
		local players = exports.cr_pool:getPoolElementsByType("player")
		for key, value in ipairs(players) do
			local logged = getElementData(value, "loggedin")
			if (logged==1) then
				local requested = getElementData(value, "ckstatus")
				if requested=="requested" then
					triggerClientEvent(source, "addOneToCKCountFromSpawn", source)
				end
			end
		end
	end
end
addEventHandler("accounts:characters:spawn", getRootElement(), playerConnect)


function handleReport(reportedPlayer, reportedReason, reportType)
	if client ~= source then return end
	
	local staff, errors, name, abrv, r, g, b = getReportInfo(reportType)
	if not staff then
		outputChatBox(errors, source, 255, 0, 0)
		return
	end

	if getElementData(reportedPlayer, "loggedin") ~= 1 then
		outputChatBox("The player you are reporting is not logged in.", source, 255, 0, 0)
		return
	end
	-- Find a free report slot
	local slot = nil

	sortReports(false)

	for i = 1, getMaxPlayers() do
		if not reports[i] then
			slot = i
			break
		end
	end

	local hours, minutes = getTime()

	-- Fix hours
	if (hours<10) then
		hours = "0" .. hours
	end

	-- Fix minutes
	if (minutes<10) then
		minutes = "0" .. minutes
	end

	local timestring = hours .. ":" .. minutes


	--local alertTimer = setTimer(alertPendingReport, 123500, 2, slot)
	--local alertTimer = setTimer(alertPendingReport, 123500, 0, slot)
	--local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, slot)

	-- Store report information
	reports[slot] = { }
	reports[slot][1] = source -- Reporter
	reports[slot][2] = reportedPlayer -- Reported Player
	reports[slot][3] = reportedReason -- Reported Reason
	reports[slot][4] = timestring -- Time reported at
	reports[slot][5] = nil -- Admin dealing with the report
	reports[slot][6] = alertTimer -- Alert timer of the report
	reports[slot][7] = reportType -- Report Type, table row for new report types / Chaos
	reports[slot][8] = slot -- Report ID/Slot, used in rolling queue function / Farid

	local playerID = getElementData(source, "playerid")
	local reportedID = getElementData(reportedPlayer, "playerid")
	setElementData(source, "reportNum", slot)

	setElementData(source, "adminreport", slot, true)
	setElementData(source, "reportadmin", false)
	local count = 0
	local nigger = 0
	local skipadmin = false
	local gmsTold = false
	local playergotit = false
	local alreadyCalled	= { }

	for _, usergroup in ipairs(staff) do
		if string.find(SUPPORTER, usergroup) then -- Supporters
			setElementData(source, "gmreport", slot, true)
			local GMs = exports.cr_global:getGameMasters()

			for key, value in ipairs(GMs) do
				local gmDuty = getElementData(value, "duty_supporter")
				if (gmDuty == 1) then
					nigger = nigger + 1
					outputChatBox("[#" .. slot  .. "] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " adlı oyuncu yeni bir rapor gönderdi.", value, r, g, b)
					outputChatBox("[#" .. slot  .. "] İçerik: " .. reportedReason, value, r, g, b, true)
				end
				count = count + 1
			end

			local admins = exports.cr_global:getAdmins()
			for key, value in ipairs(admins) do
				local gmDuty = getElementData(value, "duty_admin")
				if (gmDuty == 1) then
					outputChatBox("[#" .. slot  .. "] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " adlı oyuncu yeni bir rapor gönderdi.", value, r, g, b)--200, 240, 120)
					outputChatBox("[#" .. slot  .. "] İçerik: " .. reportedReason, value, r, g, b, true)
				end
				count = count - 1
			end
		end
	end
	updateReportCount()
end

function subscribeToAdminsReports(thePlayer)
	if exports.cr_integration:isPlayerHelper(thePlayer) then
		if getElementData(thePlayer, "report-system:subcribeToAdminReports") then
			setElementData(thePlayer, "report-system:subcribeToAdminReports", false)
			outputChatBox("You've unsubscribed from admin reports.",thePlayer, 255,0,0)
		else
			setElementData(thePlayer, "report-system:subcribeToAdminReports", true)
			outputChatBox("You've subscribed to admin reports.",thePlayer, 0,255,0)
		end
	end
end
addCommandHandler("showadminreports", subscribeToAdminsReports)

addEvent("clientSendReport", true)
addEventHandler("clientSendReport", getRootElement(), handleReport)

function alertPendingReport(id)
	if (reports[id]) then
		local reportingPlayer = reports[id][1]
		local reportedPlayer = reports[id][2]
		local reportedReason = reports[id][3]
		local timestring = reports[id][4]
		local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
		local playerID = getElementData(reportingPlayer, "playerid")
		local reportedID = getElementData(reportedPlayer, "playerid")
		local alreadyTold = { }

		if staff then
			for k, usergroup in ipairs(staff) do
				if string.find(auxiliaryTeams, usergroup) then
					for key, value in ipairs(getElementsByType("player")) do
						if getElementData(value, "loggedin") == 1 then
							if not alreadyTold[value] then
								outputChatBox(" [#" .. id .. "] is still not answered: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 200, 240, 120)
								alreadyTold[value] = true
							end
						end
					end
				else
					for key, value in ipairs(getElementsByType("player")) do
						if getElementData(value, "loggedin") == 1 then
							if not alreadyTold[value] then
								local gmduty = getElementData(value, "duty_supporter")
								local adminduty = getElementData(value, "duty_admin")
								if (gmduty==1) or (adminduty==1) then
									outputChatBox(" [#" .. id .. "] is still not answered: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 200, 240, 120)
								end
							end
						end
					end
				end
			end
		end
	end
end
--[[
function pendingReportTimeout(id)
	if (reports[id]) then

		local reportingPlayer = reports[id][1]
		local isGMreport = reports[id][8]
		-- Destroy the report
		local alertTimer = reports[id][6]
		local timeoutTimer = reports[id][7]

		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end

		if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end

		reports[id] = nil -- Destroy any reports made by the player


		setElementData(reportingPlayer, "reportadmin", false, false)

		local hours, minutes = getTime()

		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end

		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end

		local timestring = hours .. ":" .. minutes

		if isGMreport then
			setElementData(reportingPlayer, "gmreport", false, false)
			local GMs = exports.cr_global:getGameMasters()
			for key, value in ipairs(GMs) do
				local gmduty = getElementData(value, "duty_supporter")
				if (gmduty== true) then
					outputChatBox(" [GM #" .. id .. "] - REPORT #" .. id .. " has expired!", value, 200, 240, 120)
				end
			end
		else
			setElementData(reportingPlayer, "report", false, false)
			local admins = exports.cr_global:getAdmins()
			-- Show to admins
			for key, value in ipairs(admins) do
				local adminduty = getElementData(value, "duty_admin")
				if (adminduty==1) then
					outputChatBox(" [#" .. id .. "] - REPORT #" .. id .. " has expired!", value, 200, 240, 120)
				end
			end
		end

		outputChatBox("[" .. timestring .. "] Your report (#" .. id .. ") has expired.", reportingPlayer, 200, 240, 120)
		sortReports(false)
		updateReportCount()
	end
end]]

function falseReport(thePlayer, commandName, id)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: /" .. commandName .. "[ID]", thePlayer, 255, 194, 14,true)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("[!]#FFFFFF Hatalı Rapor ID.", thePlayer, 255, 0, 0,true)
			else
				local reportHandler = reports[id][5]

				if (reportHandler) then
					outputChatBox("[!]#FFFFFF [#" .. id .. "] ID'li raporun kontrolü " .. getPlayerName(reportHandler) or "yok" .. " (" .. getElementData(reportHandler,"account:username") or "yok" .. ") adlı yetkilide.", thePlayer, 255, 0, 0,true)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]

					--[[
					if reportedPlayer == thePlayer and not exports.cr_integration:isPlayerHeadAdmin(thePlayer) and not isAuxiliaryReport(reports[id][7]) then
						outputChatBox("You better let someone else to handler this report because it's against you.",thePlayer, 255,0,0)
						return false
					end
					]] -- Disabled because staff report is not going to be handled in game anyway / Farid / 2015.1.26

					local reason = reports[id][3]
					local alertTimer = reports[id][6]
					local timeoutTimer = reports[id][7]
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])

					--local found = false
					--if not found and not exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
					--	outputChatBox("You may not false a report that does not have to do with your staff division.", thePlayer, 255, 0, 0)
					--	return
					--end

					local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)

					local adminUsername = getElementData(thePlayer, "account:username")

					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end
					removeElementData(reportingPlayer, "reportNum")
					if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end

					reports[id] = nil
					local alreadyTold = { }
					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					local timestring = hours .. ":" .. minutes
					setElementData(reportingPlayer, "adminreport", false, true)
					setElementData(reportingPlayer, "gmreport", false, true)
					setElementData(reportingPlayer, "reportadmin", true, true)


					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											outputChatBox("[#" .. id .. "] " .. adminTitle .. " (" .. adminUsername .. ") adlı yetkili (#" .. id .. ") ID'li raporu reddetti.", value, r, g, b,true)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox("[#" .. id .. "] " .. adminTitle .. " (" .. adminUsername .. ") adlı yetkili (#" .. id .. ") ID'li raporu reddetti.", value, r, g, b,true)												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					outputChatBox("[#" .. id .. "] ID'li raporun " .. adminTitle .. " (" .. adminUsername .. ") adlı yetkili tarafından reddedildi.", reportingPlayer, r, g, b,true)--200, 240, 120)
					triggerClientEvent (reportingPlayer, "playNudgeSound", reportingPlayer)

					sortReports(true)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("falsereport", falseReport, false, false)
addCommandHandler("fr", falseReport, false, false)

function acceptReport(thePlayer, commandName, id)
	if exports.cr_integration:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("[!]#FFFFFF Geçersiz Rapor ID.", thePlayer, 255, 0, 0, true)
			else
				local reportHandler = reports[id][5]

				if (reportHandler) and isElement(reportHandler) then
					outputChatBox("[!]#FFFFFF [#" .. id .. "] ID'li rapor ile " .. getPlayerName(reportHandler) .. " ilgileniyor.", thePlayer, 255, 0, 0, true)
				else

					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]

					if reportingPlayer == thePlayer and not exports.cr_integration:isPlayerScripter(thePlayer) then
						outputChatBox("You can not accept your own report.",thePlayer, 255,0,0)
						return false
					--[[
					elseif reportedPlayer == thePlayer and not exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
						outputChatBox("You better let someone else to handler this report because it's against you.",thePlayer, 255,0,0)
						return false
						]] -- Disabled because staff report is not going to be handled in game anyway / Farid / 2015.1.26
					end

					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
					--[[local found = false
					for k, userg in ipairs(staff) do
						if string.find(getElementData(thePlayer, "forum_perms"), userg) then
							found = true
						end
					end
					if not found and not exports.cr_integration:isPlayerHeadAdmin(thePlayer) then
						outputChatBox("You may not accept a report that does not have to do with your staff division. Transfer it first with /changereport", thePlayer, 255, 0, 0)
						return
					end]]


					local reason = reports[id][3]
					local alertTimer = reports[id][6]
					--local timeoutTimer = reports[id][7]
					local alreadyTold = { }

					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end

					--[[if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end]]

					reports[id][5] = thePlayer -- Admin dealing with this report

					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					setElementData(reportingPlayer, "reportadmin", thePlayer, false)

					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")
					local adminID = getElementData(thePlayer, "playerid")

					local adminName = getElementData(thePlayer, "account:username")
					local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)


					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											outputChatBox("[#" .. id .. "] " .. adminTitle .. " " .. adminName .. " (" .. adminID .. ") adlı yetkili bu raporu kabul etti.", value, 255, 84, 84, true)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox("[#" .. id .. "] " .. adminTitle .. " " .. adminName .. " (" .. adminID .. ") adlı yetkili bu raporu kabul etti.", value, r, g, b,true)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					outputChatBox("[!]#FFFFFF " .. adminTitle .. " " .. getPlayerName(thePlayer) .. " (" .. adminName .. ") raporunuzu kabul etti (#" .. id .. ")", reportingPlayer, 0, 255, 0,true)
					outputChatBox("[!]#FFFFFF Lütfen yetkilinin sizinle iletişim kurmasını bekleyin.", reportingPlayer, 0, 0, 255,true)
					triggerClientEvent (reportingPlayer, "playNudgeSound", reportingPlayer)

					if getElementData(thePlayer, "report:autocheck") then
						triggerClientEvent(thePlayer, "report:onOpenCheck", thePlayer, tostring(playerID))
					end

					setElementData(thePlayer, "targetPMer", reportingPlayer, false)
					--setElementData(reportingPlayer, "targetPMed", thePlayer, false)

					--local accountID = getElementData(thePlayer, "account:id")
					--exports.cr_logs:dbLog({"ac" .. tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " accepted a report. Report: " .. reason)
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("acceptreport", acceptReport, false, false)
addCommandHandler("ar", acceptReport, false, false)

function toggleAutoCheck(thePlayer)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)) then
		if getElementData(thePlayer, "report:autocheck") then
			setElementData(thePlayer, "report:autocheck", false)
			outputChatBox(" You've just disabled auto /check on /ar.", thePlayer, 255, 0,0)
		else
			setElementData(thePlayer, "report:autocheck", true)
			outputChatBox(" You've just enabled auto /check on /ar.", thePlayer, 0, 255,0)
		end
	end
end
addCommandHandler("toggleautocheck", toggleAutoCheck, false, false)
addCommandHandler("togautocheck", toggleAutoCheck, false, false)

function transferReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports.cr_integration:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID] [Adminname]", thePlayer, 200, 240, 120)
		else
			local targetAdmin, username = exports.cr_global:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("[!]#FFFFFF Geçersiz Rapor ID.", thePlayer, 255, 0, 0, true)
				elseif (reports[id][5] ~= thePlayer) and not (exports.cr_integration:isPlayerGameAdmin(thePlayer)) then
					outputChatBox("This is not your report, pal.", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local report = reports[id][3]
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
					reports[id][5] = targetAdmin -- Admin dealing with this report

					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					local alreadyTold ={ }
					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")

					outputChatBox("[" .. timestring .. "] " .. getPlayerName(thePlayer) .. " handed your report to " ..  getPlayerName(targetAdmin)  .. " (#" .. id .. "), Please wait for him/her to contact you.", reportingPlayer, 200, 240, 120)
					outputChatBox(getPlayerName(thePlayer) .. " handed report #" .. id .. " to you. Please proceed to contact the player (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", targetAdmin, 200, 240, 120)

					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " handed report #" .. id .. " over to  " ..  getPlayerName(targetAdmin) , value, r, g, b)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " handed report #" .. id .. " over to  " ..  getPlayerName(targetAdmin) , value, r, g, b)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					--local accountID = getElementData(thePlayer, "account:id")
					--exports.cr_logs:dbLog({"ac" .. tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " had a report transfered to them. Report: " .. reason)
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("transferreport", transferReport, false, false)
addCommandHandler("tr", transferReport, false, false)

function closeReport(thePlayer, commandName, id)
	if exports.cr_integration:isPlayerStaff(thePlayer) then
		if not (id) then
			closeAllReports(thePlayer)
			--outputChatBox("KULLANIM: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
			if (reports[id]==nil) then
				outputChatBox("[!]#FFFFFF Geçersiz Rapor ID.", thePlayer, 255, 0, 0, true)
			elseif (reports[id][5] ~= thePlayer) then
				outputChatBox("This is not your report, pal.", thePlayer, 255, 0, 0)
			else
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local alertTimer = reports[id][6]
				local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
				local alreadyTold = { }

				if isTimer(alertTimer) then
					killTimer(alertTimer)
				end

				--[[if isTimer(timeoutTimer) then
					killTimer(timeoutTimer)
				end]]

				reports[id] = nil

				local adminName = getElementData(thePlayer,"account:username")
				local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)

				if (isElement(reporter)) then
					setElementData(reporter, "adminreport", false, true)
					setElementData(reporter, "gmreport", false, true)
					setElementData(reporter, "reportadmin", false, false)
					removeElementData(reporter, "reportNum")
					outputChatBox("[!] " .. adminTitle .. " " .. getPlayerName(thePlayer) .. " (" .. adminName .. ") adlı yetkili raporunu kapattı.", reporter, r, g, b, true)
					triggerClientEvent(reporter, "feedback:form", thePlayer) -- Staff feedback / Farid / 2015.1.29
				end

				if staff then
					for k, usergroup in ipairs(staff) do
						if string.find(auxiliaryTeams, usergroup) then
							for key, value in ipairs(getElementsByType("player")) do
								if getElementData(value, "loggedin") == 1 then
									if not alreadyTold[value] then
										outputChatBox("[#" .. id .. "] " .. adminTitle .. " (" .. adminName .. ") adlı yetkili raporu sonlandırdı. #" .. id .. ". -", value, r, g, b, true)
										updateVeri(thePlayer)
											setTimer(function()
										    executeCommandHandler ("raporum", thePlayer)
											end, 5000, 1)
										alreadyTold[value] = true
									end
								end
							end
						else
							for key, value in ipairs(getElementsByType("player")) do
								if getElementData(value, "loggedin") == 1 then
									if not alreadyTold[value] then
										local adminduty = getElementData(value, "duty_admin")
										local gmduty = getElementData(value, "duty_supporter")
										if (adminduty==1) or (gmduty==1) then
											outputChatBox("[#" .. id .. "] " .. adminTitle .. " (" .. adminName .. ") adlı yetkili raporu sonlandırdı. #" .. id .. ". -", value, r, g, b, true)--200, 240, 120)
											updateVeri(thePlayer)
											setTimer(function()
										    executeCommandHandler ("raporum", thePlayer)
											end, 5000, 1)
											alreadyTold[value] = true
										end
									end
								end
							end
						end
					end
				end

				sortReports(true)
				updateReportCount()
				updateStaffReportCount(thePlayer)
			end
		end
	end
end
addCommandHandler("closereport", closeReport, false, false)
addCommandHandler("cr", closeReport, false, false)

function closeAllReports(thePlayer)
	if exports.cr_integration:isPlayerStaff(thePlayer) then
		local count = 0
		for i = 1, getMaxPlayers() do
			local report = reports[i]
			if report then
				local admin = report[5]
				if isElement(admin) and admin == thePlayer then
					closeReport(thePlayer, "cr" , i)
					count = count + 1
				end
			end
		end

		if count == 0 then
			outputChatBox("[!]#FFFFFF Kapatılmayan rapor yok.", thePlayer, 0, 0, 255,true)--255, 194, 15)
		else
			outputChatBox("[!]#FFFFFF Toplam " .. count .. " raporu sonlandırdın.", thePlayer, 0, 0, 255, true)--255, 194, 15)
		end
	end
end
addCommandHandler("closeallreports", closeAllReports, false, false)
addCommandHandler("car", closeAllReports, false, false)

function dropReport(thePlayer, commandName, id)
	if exports.cr_integration:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: " .. commandName .. " [ID]", thePlayer, 255, 195, 14)
		else
			id = tonumber(id)
			if (reports[id] == nil) then
				outputChatBox("[!]#FFFFFF Geçersiz Rapor ID.", thePlayer, 255, 0, 0, true)
			else
				if (reports[id][5] ~= thePlayer) then
					outputChatBox("You are not handling this report.", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local reason = reports[id][3]
					reports[id][5] = nil
					reports[id][6] = alertTimer
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
					--reports[id][7] = timeoutTimer

					local adminName = getElementData(thePlayer,"account:username")
					local adminTitle = exports.cr_global:getPlayerAdminTitle(thePlayer)
					local alreadyTold = { }

					local reporter = reports[id][1]
					if (isElement(reporter)) then
						setElementData(reporter, "adminreport", id, true)
						setElementData(reporter, "reportadmin", false, false)
						outputChatBox(adminTitle .. " " .. getPlayerName(thePlayer) .. " (" .. adminName .. ") has released your report. Please wait until another member of staff accepts your report.", reporter, r, g, b)
					end

					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											outputChatBox("[#" .. id .. "] - " .. adminTitle .. " " .. getPlayerName(thePlayer) .. " (" .. adminName .. ") has dropped report #" .. id .. ". -", value, r, g, b)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox("[#" .. id .. "] - " .. adminTitle .. " " .. getPlayerName(thePlayer) .. " (" .. adminName .. ") has dropped report #" .. id .. ". -", value, r, g, b)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end
					
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("dropreport", dropReport, false, false)
addCommandHandler("dr", dropReport, false, false)

function endReport(thePlayer, commandName)
	local adminreport = getElementData(thePlayer, "adminreport")
	local gmreport = getElementData(thePlayer, "gmreport")

	local report = false
	for i=1, getMaxPlayers() do
		if reports[i] and (reports[i][1] == thePlayer) then
			report = i
			break
		end
	end

	if not adminreport or not report then
		outputChatBox("[!]#FFFFFF Bekleyen bir raporunuz yok.", thePlayer, 255, 0, 0, true)
		setElementData(thePlayer, "adminreport", false, true)
		setElementData(thePlayer, "gmreport", false, true)
		setElementData(thePlayer, "reportadmin", false, false)
	else
		local hours, minutes = getTime()

		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end

		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end

		local timestring = hours .. ":" .. minutes
		local reportedPlayer = reports[report][2]
		--local reason = reports[report][3]
		local reportHandler = reports[report][5]
		local alertTimer = reports[report][6]
		--local timeoutTimer = reports[report][7]

		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end

		--[[if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end]]
		removeElementData(thePlayer, "reportNum")
		reports[report] = nil
		setElementData(thePlayer, "adminreport", false, true)
		setElementData(thePlayer, "gmreport", false, true)
		setElementData(thePlayer, "reportadmin", false, false)

		outputChatBox("[!]#FFFFFF Raporunuzu iptal ettiniz.", thePlayer, 0, 255, 0, true)
		local otherAccountID = nil
		if (isElement(reportHandler)) then
			outputChatBox("[!]#FFFFFF " .. getPlayerName(thePlayer) .. " başarıyla raporu sonlandırdı. (ID #" .. report .. ").", reportHandler, 255, 126, 0,true)
			otherAccountID = getElementData(reportHandler, "account:id")
			updateStaffReportCount(reportHandler)
			triggerClientEvent(thePlayer, "feedback:form", reportHandler) -- Staff feedback / Farid / 2015.1.29
		end
		
		sortReports(true)
		updateReportCount()
	end
end
addCommandHandler("endreport", endReport, false, false)
addCommandHandler("er", endReport, false, false)

function showUnansweredReports(thePlayer)
	if exports.cr_integration:isPlayerStaff(thePlayer) then
		if showTopRightReportBox(thePlayer) then
			setElementData(thePlayer, "report:topRight", 1, true)
		else
			local count = 0
			local seenReport = { }
			for i = 1, #reports do
				local report = reports[i]
				if report then
					local reporter = report[1]
					local reported = report[2]
					local timestring = report[4]
					local admin = report[5]
					local staff, _, name, abrv, r, g, b = getReportInfo(report[7])

					local handler = ""
					if (isElement(admin)) then
						--handler = tostring(getPlayerName(admin))
					else
						handler = ""
						if staff then
							for k,v in ipairs(staff) do
								if not seenReport[i] then
									outputChatBox("[#" .. tostring(i) .. "] " .. tostring(getPlayerName(reporter)) .. " kişisine ait cevapsız bir rapor bulunuyor!", thePlayer, r, g, b, true)
									count = count + 1
									seenReport[i] = true
								end
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("ur", showUnansweredReports, false, false)

function showReports(thePlayer)
	if (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)) then
		if showTopRightReportBox(thePlayer) then
			setElementData(thePlayer, "report:topRight", 3, true)
		else
			local count = 0
			for i = 1, #reports do
				local report = reports[i]
				if report then
					local reporter = report[1]
					local reported = report[2]
					local timestring = report[4]
					local admin = report[5]
					local staff, _, name, abrv, r, g, b = getReportInfo(report[7])
					local seenReport = { }
					local handler = ""

					if (isElement(admin)) then
						local adminName = getElementData(admin, "account:username")
						handler = tostring(getPlayerName(admin)) .. " (" .. adminName .. ")"
					else
						handler = "Yok."
					end
					
					if staff then
						for k,v in ipairs(staff) do
							if (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)) and not seenReport[i] then
								outputChatBox("[!]#FFFFFF Rapor " .. abrv .. "#" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' şikayet ediyor '" .. tostring(getPlayerName(reported)) .. "' saat " .. timestring .. ". Okuyan: " .. handler .. "", thePlayer, r, g, b,true)
								count = count + 1
								seenReport[i] = true
							end
						end
					end
				end
			end

			if count == 0 then
				outputChatBox("[!]#FFFFFF Henüz bekleyen rapor bulunmuyor.", thePlayer, 0, 0, 255,true)
			end
		end
	end
end
addCommandHandler("reports", showReports, false, false)

function updateStaffReportCount(thePlayer)
	local adminreports = getElementData(thePlayer, "adminreports")
	adminreports = adminreports + 1
	setElementData(thePlayer, "adminreports", adminreports, false)
end

function saveReportCount()
	local adminreports = getElementData(source, "adminreports")
	if tonumber(adminreports) then
		dbExec(mysql:getConnection(), "UPDATE `accounts` SET `adminreports`='" .. adminreports .. "' WHERE `id` = " .. (getElementData(source, "account:id")))	
	end

	local adminreports_saved = getElementData(source, "adminreports_saved")
	if tonumber(adminreports_saved) then
		dbExec(mysql:getConnection(), "UPDATE `accounts` SET `adminreports_saved`='" .. adminreports_saved .. "' WHERE `id` = " .. (getElementData(source, "account:id")))
	end
end
addEventHandler("onPlayerQuit", getRootElement(), saveReportCount)

function getSavedReports(thePlayer)
	local adminreports_saved = getElementData(thePlayer, "adminreports_saved") or 0
	outputChatBox("You have saved " .. adminreports_saved .. " reports. " .. reportsToAward-adminreports_saved .. " more to a reward!", thePlayer, 255, 126, 0)
end
addCommandHandler("getsavedreports", getSavedReports)

function setSavedReports(thePlayer, cmd, reports)
	if getElementData(thePlayer, "account:id") ~= 1 then
		return false
	end
	if reports and tonumber(reports) and tonumber(reports) >=0 then
		reports = tonumber(reports)
	else
		reports = 0
	end
	setElementData(thePlayer, "adminreports_saved", reports , false)
	outputChatBox("You have set saved report count to " .. reports .. ".", thePlayer, 255, 126, 0)
end
addCommandHandler("setsavedreports", setSavedReports)

function updateVeri(thePlayer)
	local dbid = getElementData(thePlayer, "account:id")
	local r = getElementData(thePlayer, "adminreports")
	local guncelle = dbExec(mysql:getConnection(), "UPDATE accounts SET adminreports='" .. (r) .. "' WHERE id='" .. dbid .. "'")
end
addCommandHandler("raporum", updateVeri)

function raporPanel(thePlayer, commandName, argument)
	if exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer) then
		if argument then
			if argument == "ac" then
				setElementData(thePlayer, "report_panel_mod", "3")
			elseif argument == "kapat" then
				setElementData(thePlayer, "report_panel_mod", "0")
			else
				outputChatBox("KULLANIM: /" .. commandName .. " [ac/kapat]", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [ac/kapat]", thePlayer, 255, 194, 14)
		end
	else
		
	end
end
addCommandHandler("raporpanel", raporPanel)