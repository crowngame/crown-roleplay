function canPlayerAccessStaffManager(player)
	return exports.cr_integration:isPlayerTrialAdmin(player) or exports.cr_integration:isPlayerHelper(player) or exports.cr_integration:isPlayerVCTMember(player) or exports.cr_integration:isPlayerLeadScripter(player) or exports.cr_integration:isPlayerMappingTeamLeader(player)
end

function hasPlayerAccess(player)
	local authorizedStaffs = exports.cr_integration:getAuthorizedStaffs()
	return authorizedStaffs[getElementData(player, "account:username")]
end