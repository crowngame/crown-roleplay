addEvent("realism:startsmoking", true)
addEventHandler("realism:startsmoking", getRootElement(),
	function(hand)
		if not (hand) then
			hand = 0
		else
			hand = tonumber(hand)
		end	
		
		triggerClientEvent("realism:smokingsync", source, true, hand)
		setElementData(source, "realism:smoking", true, false)
		setElementData(source, "realism:smoking:hand", hand, false)
		setTimer (stopSmoking, 300000, 1, thePlayer)
	end
);


function stopSmoking(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	if (isElement(thePlayer)) then	
		local isSmoking = getElementData(thePlayer, "realism:smoking")
		local smokingJoint = getElementData(thePlayer, "realism:joint") -- If the player is smoking a Joint, not a ciggy
        if (smokingJoint) then
                triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
                setElementData(thePlayer, "realism:joint", false, false)
                setElementData(thePlayer, "realism:smoking", false, false)
                return
        end
        if (isSmoking) then
                triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
                setElementData(thePlayer, "realism:smoking", false, false)
        end
	end
end
addEvent("realism:stopsmoking", true)
addEventHandler("realism:stopsmoking", getRootElement(), stopSmoking)

function stopSmokingCMD(thePlayer)
    local isSmoking = getElementData(thePlayer, "realism:smoking")
    local smokingJoint = getElementData(thePlayer, "realism:joint")
    if (smokingJoint) then
        stopSmoking(thePlayer)
        exports.cr_global:sendLocalMeAction(thePlayer, "sigarasını yere fırlatır.")
        return
    end
    if (isSmoking) then
        stopSmoking(thePlayer)
        exports.cr_global:sendLocalMeAction(thePlayer, "sigarasını yere fırlatır.")
    end
end
addCommandHandler("sigaraat", stopSmokingCMD)

function changeSmokehand(thePlayer)
	local isSmoking = getElementData(thePlayer, "realism:smoking")
	if (isSmoking) then
		local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
		triggerClientEvent("realism:smokingsync", thePlayer, true, 1-smokingHand)
		setElementData(thePlayer, "realism:smoking:hand",1-smokingHand, false)
	end
end
addCommandHandler("sigaradegistir", changeSmokehand)

function passJointCMD(thePlayer, commandName, target)
    if (not target) then
        outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı/ID]", thePlayer, 255, 194, 14)
        return
    end
   
    local targetPlayer, targetPlayerName = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
    if (not targetPlayer) then
        outputChatBox("[!]#FFFFFF Eşleşecek kimse bulunamadı.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
        return
    end
    if (thePlayer == targetPlayer) then
        outputChatBox("Ahm, you're already smoking this one .. ", thePlayer, 255, 0, 0)
        return
    end
   
    local x, y, z = getElementPosition(thePlayer)
    local tx, ty, tz = getElementPosition(targetPlayer)
    if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) <= 3) then
        local smokingJoint = getElementData(thePlayer, "realism:joint")
        if (smokingJoint) then
            stopSmoking(thePlayer)
            setElementData(thePlayer, "realism:joint", false, false)
            setElementData(thePlayer, "realism:smoking", false, false)
            exports.cr_global:sendLocalMeAction(thePlayer, "passes a joint to " .. targetPlayerName .. ".")
            outputChatBox("((/throwaway to throw it away, /switchhand to change hand, /passjoint to pass your joint))", targetPlayer)
            setElementData(targetPlayer, "realism:joint", true)
            triggerEvent("realism:startsmoking", targetPlayer, 0)
        end
    else
        outputChatBox("You are not close enough to " .. targetPlayerName .. "!", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("passjoint", passJointCMD, false, false)

-- Sync to new players
addEvent("realism:smoking.request", true)
addEventHandler("realism:smoking.request", getRootElement(), 
	function ()
		local players = exports.cr_pool:getPoolElementsByType("player")
		for key, thePlayer in ipairs(players) do
			local isSmoking = getElementData(thePlayer, "realism:smoking")
			if (isSmoking) then
				local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
				triggerClientEvent(source, "realism:smokingsync", thePlayer, isSmoking, smokingHand)
			end
		end
	end
);