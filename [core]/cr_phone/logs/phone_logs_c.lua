--Farid

function writeCellphoneLog(convs, from, type, to)
	if source == localPlayer then
		for i, message in ipairs(convs) do
			--exports.cr_logs:writeCellphoneLog(exports.cr_global:getPlayerName(localPlayer), from, type, to, message)
		end
	end
end
addEvent("phone:writeCellphoneLog", true)
addEventHandler("phone:writeCellphoneLog", root, writeCellphoneLog)