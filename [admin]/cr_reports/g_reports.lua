
reportTypes = {
 	{"Başka bir oyuncuyla yaşanan problemler", {18, 17, 64, 15, 14}, "PLY", 214, 6, 6, "" },
	{"Interior Problemleri", {18, 17, 64, 15, 14}, "INT", 255, 126, 0, "" },
	{"Item Problemleri", {18, 17, 64, 15, 14}, "ITM", 255, 126, 0, "" },
	{"Genel Soru", {30, 18, 17, 64, 15, 14}, "SUP", 70, 200, 30, "" }, -- 70, 200, 30
	{"Araçla Alakalı Problemler", {30, 18, 17, 64, 15, 14}, "VEH", 255, 126, 0, "" },
	--{"Vehicle Build/Import Requests", {39, 43}, "VCT", 176, 7, 237, "Use this type to contact the VCT." },
	--{"Mapping Issue", {44, 28}, "MAP", 0, 0, 0 }, Farid IF YOU EVER WANT TO BRING THIS BACK, UNCOMMENT
	--{"Scripting Question", {32}, "ScrT", 148, 126, 12, "Use this type if you with to contact the Scripting Team." },
}

adminTeams = exports.cr_integration:getAdminStaffNumbers()
auxiliaryTeams = exports.cr_integration:getAuxiliaryStaffNumbers()
SUPPORTER = exports.cr_integration:getHelperNumber()

function getReportInfo(row, element)
	if not isElement(element) then
		element = nil
	end

	local staff = reportTypes[row][2]
	local players = getElementsByType("player")
	local vcount = 0
	local scount = 0


	for k,v in ipairs(staff) do
		if v == 39 or v == 43 then

			for key, player in ipairs(players) do
				if exports.cr_integration:isPlayerVCTMember(player) or exports.cr_integration:isPlayerVehicleConsultant(player) then
					vcount = vcount + 1
					save = player
				end
			end

			if vcount==0 then
				return false, "Aktif araç yetkilisi mevcut değil."
			elseif vcount==1 and save == element then
				return false, "Aktif araç yetkilisi mevcut değil."
			end
		elseif v == 32 then

			for key, player in ipairs(players) do
				if exports.cr_integration:isPlayerScripter(player) then
					scount = scount + 1
					save = player
				end
			end

			if scount==0 then
				return false, "Aktif yazılımcı mevcut değil."
			elseif scount==1 and save == element then -- Callback for checking if a aux staff logs out
				return false, "Aktif yazılımcı mevcut değil."
			end
		end
	end

	local name = reportTypes[row][1]
	local abrv = reportTypes[row][3]
	local red = reportTypes[row][4]
	local green = reportTypes[row][5]
	local blue = reportTypes[row][6]

	return staff, false, name, abrv, red, green, blue
end

function isSupporterReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if v == SUPPORTER then
			return true
		end
	end
	return false
end

function isAdminReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(adminTeams, v) then
			return true
		end
	end
	return false
end

function isAuxiliaryReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(auxiliaryTeams, v) then
			return true
		end
	end
	return false
end

function showExternalReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3")
end

function showTopRightReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports.cr_integration:isPlayerTrialAdmin(thePlayer) or exports.cr_integration:isPlayerHelper(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "1" or getElementData(thePlayer, "report_panel_mod") == "3")
end