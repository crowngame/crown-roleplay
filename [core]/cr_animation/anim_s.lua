local spamTimers = {}

function bindKeysOnJoin()
	bindKey(source, "space", "down", stopAnimation)
end
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function bindAnimationStopKey()
	bindKey(source, "space", "down", stopAnimation)
end
addEvent("bindAnimationStopKey", false)
addEventHandler("bindAnimationStopKey", getRootElement(), bindAnimationStopKey)

function forcedAnim()
	setElementData(source, "forcedanimation", 1, false)
end
addEvent("forcedanim", true)
addEventHandler("forcedanim", getRootElement(), forcedAnim)

function unforcedAnim()
	setElementData(source, "forcedanimation", 0, false)
end
addEvent("unforcedanim", true)
addEventHandler("unforcedanim", getRootElement(), unforcedAnim)

function unbindAnimationStopKey()
	unbindKey(source, "space", "down", stopAnimation)
end
addEvent("unbindAnimationStopKey", true)
addEventHandler("unbindAnimationStopKey", getRootElement(), unbindAnimationStopKey)

function stopAnimation(thePlayer)
	if getElementData(thePlayer, "superman:flying") then
	elseif getElementData(thePlayer, "irp.hookah.isUsing") then
	else
		if getElementData(thePlayer, "dead") == 0 then
			triggerClientEvent (thePlayer, "stopAnimationFix", getRootElement())
		end
	end
end
addCommandHandler("stopanim", stopAnimation, false, false)
addEvent("animation-system:animDURDUR", true)
addEventHandler("animation-system:animDURDUR", getRootElement(), stopAnimation)

function stopAnimationFix2(localPlayer)
	setPedAnimation (localPlayer)
end
addEvent("stopAnimationFix2", true)
addEventHandler("stopAnimationFix2", getRootElement(), stopAnimationFix2)

function animationList(thePlayer)
	outputChatBox("/piss /wank /slapass /fixcar /handsup /hailtaxi /scratch /fu /carchat /egil /cover", thePlayer, 255, 194, 14)
	outputChatBox("/strip 1-2 /lightup /drink /beg /mourn /cheer 1-3 /dans 1-3 /crack 1-2 /yuru(2) 1-37", thePlayer, 255, 194, 14)
	outputChatBox("/gsign 1-5 /puke /rap 1-3 /otur 1-3 /smoke 1-3 /smokelean /laugh /racebasla /sopa 1-3", thePlayer, 255, 194, 14)
	outputChatBox("/selam 1-2 /shove /bitchslap /shocked /dive /ne /fall /fallfront /cpr /copaway /driveby1 /driveby2 /driveby3 /driveby4", thePlayer, 255, 194, 14)
	outputChatBox("/copcome /copleft /copstop /durus2 /durus3 /shake /idle /kostomach /lay /cry /aim /drag /win 1-2 /adrug /kselam /kiss /sertkonus /durus /ysex /ysex2 /taichi", thePlayer, 255, 194, 14)
	outputChatBox("/stopanim or press the space bar to cancel animations.", thePlayer, 255, 194, 14)
end
addCommandHandler("animlist", animationList, false, false)
addCommandHandler("animhelp", animationList, false, false)
addCommandHandler("anims", animationList, false, false)
addCommandHandler("animations", animationList, false, false)

function resetAnimation(thePlayer)
	setPedAnimation(thePlayer)
end

function coverAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "ped", "duck_cower", -1, false, false, false)
	end
end
addCommandHandler("cop", coverAnimation, false, false)

function sertkonusAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "benchpress", "gym_bp_celebrate", -1, false, false, false)
	end
end
addCommandHandler("sertkonus", sertkonusAnimation, false, false)

function cprAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "medic", "cpr", 8000, false, true, false)
	end
end
addCommandHandler("cpr", cprAnimation, false, false)

function elsallaAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "ON_LOOKERS", "wave_loop", -1, true, true, false)
	end
end
addCommandHandler("elsalla", elsallaAnimation, false, false)

function drugAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "DEALER", "DRUGS_BUY", 8000, false, true, false)
	end
end
addCommandHandler("adrug", drugAnimation, false, false)

function kostomachAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "ped", "KO_shot_stom", -1, false, true, false)
	end
end
addCommandHandler("kostomach", kostomachAnimation, false, false)

function copawayAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "police", "coptraf_away", 1300, true, false, false)
	end
end
addCommandHandler("copaway", copawayAnimation, false, false)

function copcomeAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Come", -1, true, false, false)
	end
end
addCommandHandler("copcome", copcomeAnimation, false, false)

function copleftAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Left", -1, true, false, false)
	end
end
addCommandHandler("copleft", copleftAnimation, false, false)

function copstopAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Stop", -1, true, false, false)
	end
end
addCommandHandler("copstop", copstopAnimation, false, false)

function durusAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "ped", "XPRESSscratch", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "DEALER", "DEALER_IDLE_01", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "ped", "XPRESSscratch", -1, true, false, false)
		end
	end
end
addCommandHandler("durus",durusAnimation, false, false)

function pedWait(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "COP_AMBIENT", "Coplook_loop", -1, true, false, false)
	end
end
addCommandHandler("durus2", pedWait, false, false)

function driveBy1(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "DRIVEBYS", "Gang_DrivebyRHS_Bwd", -1, true, false, false)
	end
end
addCommandHandler("driveby1", driveBy1, false, false)

function driveBy2(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "DRIVEBYS", "Gang_DrivebyRHS_Bwd", -1, true, false, false)
	end
end
addCommandHandler("driveby2", driveBy2, false, false)

function pedThink(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "COP_AMBIENT", "Coplook_think", -1, true, false, false)
	end
end
addCommandHandler("durus3", pedThink, false, false)

function pedShake(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "COP_AMBIENT", "Coplook_shake", -1, true, false, false)
	end
end
addCommandHandler("shake", pedShake, false, false)

function idleAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "DEALER", "DEALER_IDLE_01", -1, true, false, true)
	end
end
addCommandHandler("idle", idleAnimation, false, false)

function idle1Animation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "DEALER", "DEALER_IDLE", -1, true, false, false)
	end
end
addCommandHandler("idle1", idle1Animation, false, false)

function gsign1Animation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GHANDS", "gsign1", -1, true, false, false)
	end
end
addCommandHandler("gsign1", gsign1Animation, false, false)

function gsign2Animation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GHANDS", "gsign1LH", -1, true, false, false)
	end
end
addCommandHandler("gsign2", gsign2Animation, false, false)

function gsign3Animation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GHANDS", "gsign2LH", -1, true, false, false)
	end
end
addCommandHandler("gsign3", gsign3Animation, false, false)

function pedPiss(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "PAULNMAC", "Piss_loop", -1, true, false, false)
	end
end
addCommandHandler("piss", pedPiss, false, false)

function pedWank(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "PAULNMAC", "wank_loop", -1, true, false, false)
	end
end
addCommandHandler("wank", pedWank, false, false)

function pedSlapAss(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "SWEET", "sweet_ass_slap", 2000, true, false, false)
	end
end
addCommandHandler("slapass", pedSlapAss, false, false)

function pedCarFix(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "CAR", "Fixn_Car_loop", -1, true, false, false)
	end
end
addCommandHandler("fixcar", pedCarFix, false, false)

function pedHandsup(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "ped", "handsup", -1, false, false, false)
	end
end
addCommandHandler("handsup", pedHandsup, false, false)
addCommandHandler("elkaldir", pedHandsup, false, false)

function pedTaxiHail(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "MISC", "Hiker_Pose", -1, false, true, false)
	end
end
addCommandHandler ("hailtaxi", pedTaxiHail, false, false)

function pedScratch(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "MISC", "Scratchballs_01", -1, true, true, false)
	end
end
addCommandHandler("scratch", pedScratch, false, false)

function pedFU(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "RIOT", "RIOT_FUKU", 800, false, true, false)
	end
end
addCommandHandler("fu", pedFU, false, false)

function pedStrip(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "STRIP", "STR_Loop_C", -1, false, true, false)
		else
			setPedAnimation(thePlayer, "STRIP", "strip_D", -1, false, true, false)
		end
	end
end
addCommandHandler("strip", pedStrip, false, false)

function pedLightup (thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "SMOKING", "M_smk_in", 4000, true, true, false)
	end
end
addCommandHandler("lightup", pedLightup, false, false)

function pedHeil (thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "ON_LOOKERS", "Pointup_in", 999999, false, true, false)
	end
end
addCommandHandler("heil", pedHeil, false, false)

function pedDrink(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "BAR", "dnk_stndM_loop", 2300, false, false, false)
	end
end
addCommandHandler("drink", pedDrink, false, false)

function pedLay(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "BEACH", "sitnwait_Loop_W", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "BEACH", "Lay_Bac_Loop", -1, true, false, false)
		end
	end
end
addCommandHandler("lay", pedLay, false, false)

function begAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "SHOP", "SHP_Rob_React", 4000, true, false, false)
	end
end
addCommandHandler("beg", begAnimation, false, false)

function pedMourn(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GRAVEYARD", "mrnM_loop", -1, true, false, false)
	end
end
addCommandHandler("mourn", pedMourn, false, false)

function pedCry(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GRAVEYARD", "mrnF_loop", -1, true, false, false)
	end
end
addCommandHandler("cry", pedCry, false, false)

function pedCheer(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "OTB", "wtchrace_win", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "RIOT", "RIOT_shout", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "STRIP", "PUN_HOLLER", -1, true, false, false)
		end
	end
end
addCommandHandler("cheer", pedCheer, false, false)

function danceAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "DANCING", "DAN_Down_A", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "DANCING", "dnce_M_d", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "DANCING", "DAN_Right_A", -1, true, false, false)
		end
	end
end
addCommandHandler("dans", danceAnimation, false, false)

function crackAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "CRACK", "crckidle1", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "CRACK", "crckidle3", -1, true, false, false)
		elseif arg == 4 then
			setPedAnimation(thePlayer, "CRACK", "crckidle4", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "CRACK", "crckidle2", -1, true, false, false)
		end
	end
end
addCommandHandler("crack", crackAnimation, false, false)

function gsignAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "GHANDS", "gsign2", 4000, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "GHANDS", "gsign3", 4000, true, false, false)
		elseif arg == 4 then
			setPedAnimation(thePlayer, "GHANDS", "gsign4", 4000, true, false, false)
		elseif arg == 5 then
			setPedAnimation(thePlayer, "GHANDS", "gsign5", 4000, true, false, false)
		else
			setPedAnimation(thePlayer, "GHANDS", "gsign1", 4000, true, false, false)
		end
	end
end
addCommandHandler("gsign", gsignAnimation, false, false)

function pukeAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "FOOD", "EAT_Vomit_P", 8000, true, false, false)
	end
end
addCommandHandler("puke", pukeAnimation, false, false)

function rapAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "LOWRIDER", "RAP_B_Loop", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "LOWRIDER", "RAP_C_Loop", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "LOWRIDER", "RAP_A_Loop", -1, true, false, false)
		end
	end
end
addCommandHandler("rap", rapAnimation, false, false)

function aimAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "SHOP", "ROB_Loop_Threat", -1, false, true, false)
	end
end
addCommandHandler("aim", aimAnimation, false, false)

function sitAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if isPedInVehicle(thePlayer) then
			if arg == 2 then
				setPedAnimation(thePlayer, "CAR", "Sit_relaxed")
			else
				setPedAnimation(thePlayer, "CAR", "Tap_hand")
			end
			source = thePlayer
			bindAnimationStopKey()
		else
			if arg == 2 then
				setPedAnimation(thePlayer, "FOOD", "FF_Sit_Look", -1, true, false, false)
			elseif arg == 3 then
				setPedAnimation(thePlayer, "Attractors", "Stepsit_loop", -1, true, false, false)
			elseif arg == 4 then
				setPedAnimation(thePlayer, "BEACH", "ParkSit_W_loop", 1, true, false, false)
			elseif arg == 5 then
				setPedAnimation(thePlayer, "BEACH", "ParkSit_M_loop", 1, true, false, false)
			elseif arg == 6 then
				setPedAnimation(thePlayer, "BLOWJOBZ", "BJ_Couch_Loop_P", -1, true, false, false)
			elseif arg == 7 then
				setPedAnimation(thePlayer, "JST_BUISNESS", "girl_02", -1, true, false, false)
			elseif arg == 8 then
				triggerClientEvent(thePlayer, "sync:anim", thePlayer, "oturn1")
			else
				setPedAnimation(thePlayer, "ped", "SEAT_idle", -1, true, false, false)
			end
		end
	end
end
addCommandHandler("otur", sitAnimation, false, false)

function smokeAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "SMOKING", "M_smkstnd_loop", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "LOWRIDER", "M_smkstnd_loop", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "GANGS", "smkcig_prtl", -1, true, false, false)
		end
	end
end
addCommandHandler("smoke", smokeAnimation, false, false)

function smokeleanAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "LOWRIDER", "M_smklean_loop", -1, true, false, false)
	end
end
addCommandHandler("smokelean", smokeleanAnimation, false, false)

function smokedragAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "SMOKING", "M_smk_drag", 4000, true, false, false)
	end
end
addCommandHandler("drag", smokedragAnimation, false, false)

function laughAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "RAPPING", "Laugh_01", -1, true, false, false)
	end
end
addCommandHandler("laugh", laughAnimation, false, false)

function startraceAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "CAR", "flag_drop", 4200, true, false, false)
	end
end
addCommandHandler("racebasla", startraceAnimation, false, false)

function carchatAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "CAR_CHAT", "car_talkm_loop", -1, true, false, false)
	end
end
addCommandHandler("carchat", carchatAnimation, false, false)

function tiredAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "FAT", "idle_tired", -1, true, false, false)
	end
end
addCommandHandler("egil", tiredAnimation, false, false)

function handshakeAnimation(thePlayer, cmd, otherGuy)
	if (not isPedInVehicle(thePlayer)) then
		if otherGuy then
			local otherPlayer = exports.cr_global:findPlayerByPartialNick(thePlayer, otherGuy)
			if otherPlayer then
				if (getPedOccupiedVehicle(thePlayer) == false and getPedOccupiedVehicle(otherPlayer) == false)  then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(otherPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<1) then -- Are they standing next to each other?
					setPedAnimation(thePlayer, "GANGS", "hndshkfa", -1, false, false, false)
					setPedAnimation(otherPlayer, "GANGS", "hndshkfa", -1, false, false, false)
					else
					outputChatBox("You are too far away to daps this player.", thePlayer, 255, 0, 0)
					end
				else
				outputChatBox("You can't daps if you or the other player is in a vehicle.", thePlayer, 255, 0, 0)
				end
			end
		else
			setPedAnimation(thePlayer, "GANGS", "hndshkfa", -1, false, false, false)
		end
	end
end
addCommandHandler("selam", handshakeAnimation, false, false)

function shoveAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "shake_carSH", -1, true, false, false)
	end
end
addCommandHandler("kapikir", shoveAnimation, false, false)

function bitchslapAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "MISC", "bitchslap", -1, true, false, false)
	end
end
addCommandHandler("bitchslap", bitchslapAnimation, false, false)

function shockedAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "ON_LOOKERS", "panic_loop", -1, true, false, false)
	end
end
addCommandHandler("shocked", shockedAnimation, false, false)

function diveAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "ped", "EV_dive", -1, false, true, false)
	end
end
addCommandHandler("dive", diveAnimation, false, false)

function whatAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		if isTimer(spamTimers[thePlayer]) then
			local remainingSeconds = math.ceil(getTimerDetails(spamTimers[thePlayer])/1000)
			outputChatBox("[!] #FFFFFFBu işlemi yapabilmek için " .. remainingSeconds .. " saniye bekleyiniz.", thePlayer, 255, 0, 0, true)
			return
		end
		spamTimers[thePlayer] = setTimer(function() end, 3 * 1000, 1)
		setPedAnimation(thePlayer, "RIOT", "RIOT_ANGRY", -1, true, false, false)
	end
end
addCommandHandler("ne", whatAnimation, false, false)

function polisoturAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "CAMERA", "camcrch_idleloop", -1, true, false, false)
	end
end
addCommandHandler("cok", polisoturAnimation, false, false)

function fallfrontAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		if isTimer(spamTimers[thePlayer]) then
			local remainingSeconds = math.ceil(getTimerDetails(spamTimers[thePlayer])/1000)
			outputChatBox("[!] #FFFFFFBu işlemi yapabilmek için " .. remainingSeconds .. " saniye bekleyiniz.", thePlayer, 255, 0, 0, true)
			return
		end
		spamTimers[thePlayer] = setTimer(function() end, 3 * 1000, 1)
		setPedAnimation(thePlayer, "ped", "FLOOR_hit_f", -1, false, false, false)
	end
end
addCommandHandler("fallfront", fallfrontAnimation, false, false)

function fallAnimation(thePlayer)
	if (not isPedInVehicle(thePlayer)) then
		if isTimer(spamTimers[thePlayer]) then
			local remainingSeconds = math.ceil(getTimerDetails(spamTimers[thePlayer])/1000)
			outputChatBox("[!] #FFFFFFBu işlemi yapabilmek için " .. remainingSeconds .. " saniye bekleyiniz.", thePlayer, 255, 0, 0, true)
			return
		end
		spamTimers[thePlayer] = setTimer(function() end, 3 * 1000, 1)
		setPedAnimation(thePlayer, "ped", "FLOOR_hit", -1, false, false, false)
	end
end
addCommandHandler("fall", fallAnimation, false, false)

local walk = {
	"WALK_armed", "WALK_civi", "WALK_csaw", "WOMAN_walksexy", "WALK_drunk", "WALK_fat", "WALK_fatold", "WALK_gang1", "WALK_gang2", "WALK_old",
	"WALK_player", "WALK_rocket", "WALK_shuffle", "Walk_Wuzi", "woman_run", "WOMAN_runbusy", "WOMAN_runfatold", "woman_runpanic", "WOMAN_runsexy", "WOMAN_walkbusy",
	"WOMAN_walkfatold", "WOMAN_walknorm", "WOMAN_walkold", "WOMAN_walkpro", "WOMAN_walksexy", "WOMAN_walkshop", "run_1armed", "run_armed", "run_civi", "run_csaw",
	"run_fat", "run_fatold", "run_old", "run_player", "run_rocket", "Run_Wuzi"
}
function walkAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
	
		if getPedOccupiedVehicle(thePlayer) then
			return
		end
		
		if not walk[arg] then
			arg = 2
		end
		
		setPedAnimation(thePlayer, "PED", walk[arg], -1, true, true, false)
	end
end
addCommandHandler("yuru", walkAnimation, false, false)
addCommandHandler("yuru2", walkAnimation, false, false)

function batAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "CRACK", "Bbalbat_Idle_02", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "Baseball", "Bat_IDLE", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "CRACK", "Bbalbat_Idle_01", -1, true, false, false)
		end
	end
end
addCommandHandler("sopa", batAnimation, false, false)

function winAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	arg = tonumber(arg)
	
	if (not isPedInVehicle(thePlayer)) then
		if arg == 2 then
			setPedAnimation(thePlayer, "CASINO", "manwinb", 2000, false, false, false)
		else
			setPedAnimation(thePlayer, "CASINO", "manwind", 2000, false, false, false)
		end
	end
end
addCommandHandler("win", winAnimation, false, false)

function asilAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "BSKTBALL", "BBALL_Dnk", 1, false, false, false)
	end
end
addCommandHandler("asil", asilAnimation, false, false)

function uzanAnimation(thePlayer, cmd, arg)
	local logged = getElementData(thePlayer, "loggedin")
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "BSKTBALL", "BBALL_Dnk", 1, false, false, false)
	end
end
addCommandHandler("asil", uzanAnimation, false, false)

function grabbAnimation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "BAR", "Barserve_bottle", 2000, false, false, false)
	end
end
addCommandHandler("grabbottle", grabbAnimation, false, false)

function taichiAnimation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "PARK", "Tai_Chi_Loop", -1, false, false, false)
	end
end
addCommandHandler("taichi", taichiAnimation, false, false)

function bompAnimation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "BOMBER", "BOM_Plant", -1, false, false, false)
	end
end
addCommandHandler("bomp", bompAnimation, false, false)

function kartopuAnimation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GRENADE", "WEAPON_throw", -1, false, false, false)
	end
end
addCommandHandler("karat", kartopuAnimation, false, false)

function kapakAnimation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "hndshkaa", -1, false, false, false)
	end
end
addCommandHandler("kapak", kapakAnimation, false, false)

function kollariniac(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "BSKTBALL", "BBALL_def_loop", -1, false, false, false)
	end
end
addCommandHandler("kollariac", kollariniac, false, false)

function sikerimAnimation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "hndshkba", -1, false, false, false)
	end
end
addCommandHandler("senisikerim", sikerimAnimation, false, false)

function teklifhayirAnimation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "Invite_No", -1, false, false, false)
	end
end
addCommandHandler("teklifhayir", teklifhayirAnimation, false, false)

function teklifevetAnimation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "Invite_Yes", -1, false, false, false)
	end
end
addCommandHandler("teklifevet", teklifevetAnimation, false, false)

function sohbet1Animation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "prtial_gngtlkA", -1, false, false, false)
	end
end
addCommandHandler("anlat1", sohbet1Animation, false, false)

function sohbet2Animation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "prtial_gngtlkB", -1, false, false, false)
	end
end
addCommandHandler("anlat2", sohbet2Animation, false, false)

function sohbet3Animation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "prtial_gngtlkC", -1, false, false, false)
	end
end
addCommandHandler("anlat3", sohbet3Animation, false, false)

function sohbet4Animation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "prtial_gngtlkD", -1, false, false, false)
	end
end
addCommandHandler("anlat4", sohbet4Animation, false, false)

function sohbet5Animation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "prtial_gngtlkE", -1, false, false, false)
	end
end
addCommandHandler("anlat5", sohbet5Animation, false, false)

function sohbet6Animation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "GANGS", "prtial_gngtlkF", -1, false, false, false)
	end
end
addCommandHandler("anlat6", sohbet6Animation, false, false)

function bar1Animation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "BAR", "Barcustom_get", -1, false, false, false)
	end
end
addCommandHandler("kahveal", bar1Animation, false, false)

function bar2Animation(thePlayer, cmd, arg)
	if (not isPedInVehicle(thePlayer)) then
		setPedAnimation(thePlayer, "BAR", "Barcustom_get", -1, false, false, false)
	end
end
addCommandHandler("kahveal", bar2Animation, false, false)

function yaslanmaAnimasyonlari(thePlayer, cmd, arg)
	arg = tonumber(arg)
	if (not isPedInVehicle(thePlayer)) then
		source = thePlayer
		if arg == 2 then
			setPedAnimation(thePlayer, "BAR", "BARman_idle", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation(thePlayer, "Attractors", "Stepsit_loop", -1, true, false, false)
		else
			setPedAnimation(thePlayer, "GANGS", "leanIDLE", -1, true, false, false)
		end
	end
end
addCommandHandler("lean", yaslanmaAnimasyonlari, false, false)

function kissingAnimation(thePlayer, commandName, target)
	if not target or target == "" then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		return false
	end
	
	local targetPlayer = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
	if not (targetPlayer) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		return false
	end

	local x, y, z = getElementPosition(thePlayer)
	local tx, ty, tz = getElementPosition(targetPlayer)
	if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<1) and getPedOccupiedVehicle(thePlayer) == false and getPedOccupiedVehicle(targetPlayer) == false then
		exports.cr_global:applyAnimation(thePlayer, "KISSING", "Grlfrd_Kiss_01", -1, false, false, false)
		exports.cr_global:applyAnimation(targetPlayer, "KISSING", "Grlfrd_Kiss_01", -1, false, false, false)
	end
end
addCommandHandler("kiss", kissingAnimation, false, false)

function kselamAnimation(thePlayer, commandName, target)
	if not target or target == "" then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		return false
	end
	
	local targetPlayer = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
	if not (targetPlayer) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		return false
	end

	local x, y, z = getElementPosition(thePlayer)
	local tx, ty, tz = getElementPosition(targetPlayer)
	if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) < 1) and getPedOccupiedVehicle(thePlayer) == false and getPedOccupiedVehicle(targetPlayer) == false then
		exports.cr_global:applyAnimation(thePlayer, "GANGS", "prtial_hndshk_biz_01", -1, false, false, false)
		exports.cr_global:applyAnimation(targetPlayer, "GANGS", "prtial_hndshk_biz_01", -1, false, false, false)
	end
end
addCommandHandler("kselam", kselamAnimation, false, false)

function ysexAnimation(thePlayer, commandName, target)
	if not target or target == "" then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		return false
	end
	
	local targetPlayer = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
	if not (targetPlayer) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		return false
	end

	local x, y, z = getElementPosition(thePlayer)
	local tx, ty, tz = getElementPosition(targetPlayer)
	if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<1) and getPedOccupiedVehicle(thePlayer) == false and getPedOccupiedVehicle(targetPlayer) == false then
		exports.cr_global:applyAnimation(thePlayer, "BLOWJOBZ", "BJ_Couch_End_P", -1, false, false, false)
		exports.cr_global:applyAnimation(targetPlayer, "BLOWJOBZ", "BJ_Couch_End_W", -1, false, false, false)
	end
end
addCommandHandler("ysex", ysexAnimation, false, false)

function ysex2Animation(thePlayer, commandName, target)
	if not target or target == "" then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		return false
	end
	
	local targetPlayer = exports.cr_global:findPlayerByPartialNick(thePlayer, target)
	if not (targetPlayer) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı / ID]", thePlayer, 255, 194, 14)
		return false
	end

	local x, y, z = getElementPosition(thePlayer)
	local tx, ty, tz = getElementPosition(targetPlayer)
	if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<1) and getPedOccupiedVehicle(thePlayer) == false and getPedOccupiedVehicle(targetPlayer) == false then
		exports.cr_global:applyAnimation(thePlayer, "BLOWJOBZ", "BJ_Couch_Loop_P", -1, false, false, false)
		exports.cr_global:applyAnimation(targetPlayer, "BLOWJOBZ", "BJ_Couch_Loop_W", -1, false, false, false)
	end
end
addCommandHandler("ysex2", ysex2Animation, false, false)

function realHandshakeAnimation(thePlayer, cmd, otherGuy)
	if otherGuy then
		local otherPlayer = exports.cr_global:findPlayerByPartialNick(thePlayer, otherGuy)
		if otherPlayer then
			if (getPedOccupiedVehicle(thePlayer) == false and getPedOccupiedVehicle(otherPlayer) == false)  then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(otherPlayer)
				if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<1.5) then -- Are they standing next to each other?
					exports.cr_global:applyAnimation(thePlayer, "GANGS", "prtial_hndshk_biz_01", -1, false, false, false)
					exports.cr_global:applyAnimation(otherPlayer, "GANGS", "prtial_hndshk_biz_01", -1, false, false, false)
				else
					outputChatBox("You are too far away to handshake this player.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("You can't handshake if you or the other player is in a vehicle.", thePlayer, 255, 0, 0)
			end
		end
	else
		exports.cr_global:applyAnimation(thePlayer, "GANGS", "prtial_hndshk_biz_01", -1, false, false, false)
	end
end
addCommandHandler("handshake", realHandshakeAnimation, false, false)