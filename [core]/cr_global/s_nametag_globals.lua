local badges = exports['cr_items']:getBadges()

function updateNametagColor(thePlayer)
	if source then thePlayer = source end
	for k, v in pairs(badges) do
		local title = getElementData(thePlayer, "kullandığıBadge")
		if (title) and title == v[1] then
			setPlayerNametagColor(thePlayer, unpack(v[4]))
			return
		end
	end
	if getElementData(thePlayer, "loggedin") ~= 1 then
		setPlayerNametagColor(thePlayer, 127, 127, 127)
	elseif exports.cr_integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 then
		setPlayerNametagColor(thePlayer, 255, 0, 0) 
	elseif exports.cr_integration:isPlayerHelper(thePlayer) and (getElementData(thePlayer, "duty_supporter") == 1) and getElementData(thePlayer, "hiddenadmin") == 0 then 
		setPlayerNametagColor(thePlayer, 0, 255, 0)
	elseif getElementData(thePlayer, "job") == 2 then
		setPlayerNametagColor(thePlayer, 250, 210, 5)
	elseif getElementData(thePlayer, "mekanik.duty", true) then
		setPlayerNametagColor(thePlayer, 101, 67, 33)
	else
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
end
addEvent("updateNametagColor", true)
addEventHandler("updateNametagColor", getRootElement(), updateNametagColor)

for key, value in ipairs(getElementsByType("player")) do
	updateNametagColor(value)
end	

function toggleGoldenNametag()
	setElementData(client, "lifeTimeNameTag_on", not getElementData(client, "lifeTimeNameTag_on"), true)
	setElementData(client, "nametag_on", not getElementData(client, "nametag_on"), true)
	updateNametagColor(client)
end
addEvent("global:toggleGoldenNametag", true)
addEventHandler("global:toggleGoldenNametag", getRootElement(), toggleGoldenNametag)