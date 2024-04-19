mysql = exports.cr_mysql
local lockTimer = nil
chDimension = 125
chInterior = 3

-- CALL BACKS FROM CLIENT

function onEmploymentServer()
	exports.cr_global:sendLocalText(source, "Jessie Smith says: Hello, are you looking for a new job?", nil, nil, nil, 10)
	exports.cr_global:sendLocalText(source, " *Jessie Smith hands over a list with jobs to " .. getPlayerName(source):gsub("_", " ") .. ".", 255, 51, 102)
end

addEvent("onEmploymentServer", true)
addEventHandler("onEmploymentServer", getRootElement(), onEmploymentServer)

function givePlayerJob(jobID)
	local charname = getPlayerName(source)
	local charID = getElementData(source, "dbid")
	mysql:query_free("UPDATE `characters` SET `job`='" .. tostring(jobID) .. "' WHERE `id`='" .. mysql:escape_string(charID) .. "' ")

	if (jobID==4) then -- CITY MAINTENANCE
		exports.cr_global:giveItem(source, 115, "41:1:Spraycan", 2500)
		outputChatBox("Use this spray to paint over the graffiti you find.", source, 255, 194, 14)
		setElementData(source, "tag", 9, false)
		mysql:query_free("UPDATE characters SET tag=9 WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")))
	end
	fetchJobInfoForOnePlayer(source)
	exports.cr_global:updateNametagColor(source)
end
addEvent("acceptJob", true)
addEventHandler("acceptJob", getRootElement(), givePlayerJob)

function fetchJobInfo()
	if not charID then
		for key, player in pairs(getElementsByType("player")) do
			fetchJobInfoForOnePlayer(player)
		end
	end
end
addEvent("job-system:fetchJobInfo", true)
addEventHandler("job-system:fetchJobInfo", getRootElement(), fetchJobInfo)

function fetchJobInfoForOnePlayer(thePlayer)
	local charID = getElementData(thePlayer, "dbid")
	local jobInfo = mysql:query_fetch_assoc("SELECT `job` , `jobID`, `jobLevel`, `jobProgress`, `jobTruckingRuns` FROM `characters` LEFT JOIN `jobs` ON `id` = `jobCharID` AND `job` = `jobID` WHERE `id`='" .. tostring(charID) .. "' ")
	if jobInfo then
		local job = tonumber(jobInfo["job"])
		local jobID = tonumber(jobInfo["jobID"])
		if job and job == 0 then
			setElementData(thePlayer, "job", 0, true)
			setElementData(thePlayer, "jobLevel", 0 , true)
			setElementData(thePlayer, "jobProgress", 0, true)
			setElementData(thePlayer, "job-system-trucker:truckruns", 0, true)
			return true
		end
		
		if not jobID then
			mysql:query_free("INSERT INTO `jobs` SET `jobID`='" .. tostring(job) .. "', `jobCharID`='" .. mysql:escape_string(charID) .. "' ")
		end
	
		setElementData(thePlayer, "job", job, true)
		setElementData(thePlayer, "jobLevel", tonumber(jobInfo["jobLevel"]) or 1, true)
		setElementData(thePlayer, "jobProgress", tonumber(jobInfo["jobProgress"]) or 0, true)
		setElementData(thePlayer, "job-system-trucker:truckruns", tonumber(jobInfo["jobTruckingRuns"]) or 0, true)
	else
		outputDebugString("[Job system] fetchJobInfoForOnePlayer / DB error")
		return false
	end
end
addEvent("job-system:fetchJobInfoForOnePlayer", true)
addEventHandler("job-system:fetchJobInfoForOnePlayer", getRootElement(), fetchJobInfo)

function printJobInfo(thePlayer)
	outputChatBox("~-~-~-~-~-~-~-~-~-~Career Information~-~-~-~-~-~-~-~-~-~-~", thePlayer, 255, 194, 14)
	outputChatBox("Job: " .. (getJobTitleFromID(getElementData(thePlayer, "job")) or "Unemployed") , thePlayer, 255, 194, 14)
	outputChatBox("Title/Level: " .. (tonumber(getElementData(thePlayer, "jobLevel")) or "0") , thePlayer, 255, 194, 14)
	outputChatBox("Progress: " .. (tonumber(getElementData(thePlayer, "jobProgress")) or "0") , thePlayer, 255, 194, 14)
	outputChatBox("~-~-~-~--~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-", thePlayer, 255, 194, 14)
end
addCommandHandler("myjob", printJobInfo)

function quitJob(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	if logged == 1 then
		local job = getElementData(thePlayer, "job")
		if job == 0 then
			outputChatBox("[!]#FFFFFF Bu komutu meslekte iken kullanabilirsiniz.", thePlayer, 255, 0, 0, true)
		else
			local charID = getElementData(thePlayer, "dbid")
			mysql:query_free("UPDATE `characters` SET `job`='0' WHERE `id`='" .. mysql:escape_string(charID) .. "' ")
			fetchJobInfoForOnePlayer(thePlayer)
			if job == 4 then
				setElementData(thePlayer, "tag", 1, false)
				mysql:query_free("UPDATE characters SET tag=1 WHERE id = " .. mysql:escape_string(charID))
			end
			triggerClientEvent(thePlayer, "quitJob", thePlayer, job)
			exports.cr_global:updateNametagColor(thePlayer)
			outputChatBox("[!]#FFFFFF Başarıyla meslekten ayrıldınız.", thePlayer, 0, 255, 0, true)
		end
	end
end
addCommandHandler("endjob", quitJob, false, false)
addCommandHandler("quitjob", quitJob, false, false)
addCommandHandler("meslekayril", quitJob, false, false)