hotlines = {
	[911] = "Los Santos Police Department",
	[8294] = "Los Santos Taxi",
}

function isNumberAHotline(theNumber)
	local challengeNumber = tonumber(theNumber)
	return hotlines[challengeNumber]
end