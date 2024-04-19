Async:setPriority("low")

local mysql = exports.cr_mysql
local chars = "1,2,3,4,5,6,7,8,9,0,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,R,S,Q,T,U,V,X,W,Z"
local codes = split(chars, ",")
local controlSystem = {}

local colSphere = createColSphere(1292.623046875, -2352.373046875, 13.153707504272, 5)

local levels = {
	-- [level] = {gerekenMin, gerekenMax}
	[1] = {0, 7},
	[2] = {8, 19},
	[3] = {20, 35},
	[4] = {36, 55},
	[5] = {56, 79},
	[6] = {80, 107},
	[7] = {108, 139},
	[8] = {140, 175},
	[9] = {176, 215},
	[10] = {216, 259},
	[11] = {260, 307},
	[12] = {308, 359},
	[13] = {360, 415},
	[14] = {416, 475},
	[15] = {476, 539},
	[16] = {540, 607},
	[17] = {608, 679},
	[18] = {680, 755},
	[19] = {756, 835},
	[20] = {836, 919},
	[21] = {920, 980},
	[22] = {981, 1060},
	[23] = {1061, 1120},
	[24] = {1121, 1180},
	[25] = {1181, 1240},
	[26] = {1241, 1300},
	[27] = {1301, 1350},
	[28] = {1351, 1420},
	[29] = {1421, 1500},
	[30] = {1501, 1600},
	[31] = {1601, 1680},
	[32] = {1681, 1750},
	[33] = {1751, 1850},
	[34] = {1851, 1900},
	[35] = {1901, 2000},
	[36] = {2001, 2100},
	[37] = {2101, 2200},
	[38] = {2201, 2300},
	[39] = {2301, 2400},
	[40] = {2401, 2500},
	[41] = {2600, 2799},
	[42] = {2800, 2899},
	[43] = {2900, 2999},
	[44] = {3000, 3199},
	[45] = {3200, 3299},
	[46] = {3300, 3399},
	[47] = {3400, 3499},
	[48] = {3500, 3600},
	[49] = {3700, 3800},
	[50] = {3800, 4000}
}

local moneys = {
	[1] = 300,
	[2] = 500,
	[3] = 1000,
	[4] = 1250,
	[5] = 1500,
	[6] = 1750,
	[7] = 2250,
	[8] = 3500,
	[9] = 5000,
	[10] = 6500,
}

function hourlyBox()
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "loggedin") == 1 then
			local minutesPlayed = getElementData(player, "minutesPlayed") or 0
			setElementData(player, "minutesPlayed", minutesPlayed + 1)
			dbExec(mysql:getConnection(), "UPDATE characters SET minutesPlayed = ? WHERE id = ?", getElementData(player, "minutesPlayed"), getElementData(player, "dbid"))
			
			if minutesPlayed >= 60 then
				controlSystem[player] = {}
				controlSystem[player].code = codes[math.random(#codes)] .. codes[math.random(#codes)] .. codes[math.random(#codes)] .. codes[math.random(#codes)]
				triggerClientEvent(player, "payday.playSound", player)
				
				local boxHours = getElementData(player, "box_hours") or 0
				local hoursPlayed = getElementData(player, "hoursplayed") or 0
				
				setElementData(player, "box_hours", boxHours + 1)
				setElementData(player, "minutesPlayed", 0)
				setElementData(player, "hoursplayed", hoursPlayed + 1)
				
				dbExec(mysql:getConnection(), "UPDATE characters SET box_hours = ? WHERE id = ?", getElementData(player, "box_hours"), getElementData(player, "dbid"))
				dbExec(mysql:getConnection(), "UPDATE characters SET minutesPlayed = ? WHERE id = ?", 0, getElementData(player, "dbid"))
				dbExec(mysql:getConnection(), "UPDATE characters SET hoursplayed = ? WHERE id = ?", getElementData(player, "hoursplayed"), getElementData(player, "dbid"))
				
				if getElementData(player, "box_hours") >= 4 then
					local boxCount = getElementData(player, "box_count") or 0
					outputChatBox("[!]#FFFFFF Dört saat oynadınız ve bir kutu kazandınız.", player, 0, 255, 0, true)
					setElementData(player, "box_hours", 0)
					setElementData(player, "box_count", boxCount + 1)
					dbExec(mysql:getConnection(), "UPDATE characters SET box_hours = ? WHERE id = ?", 0, getElementData(player, "dbid"))
					dbExec(mysql:getConnection(), "UPDATE characters SET box_count = ? WHERE id = ?", getElementData(player, "box_count"), getElementData(player, "dbid"))
				end
				
				outputChatBox("[!]#FFFFFF Saatlik bonus ve maaşınızı 2 dakika içinde [/onayla " .. controlSystem[player].code .. "] yazarak onaylayıp alabilirsiniz.", player, 0, 0, 255, true)

				if player and isElement(player) and controlSystem[player] then
					controlSystem[player].endTimer = setTimer(function(player)
						if isElement(player) then
							if controlSystem[player] then
								outputChatBox("[!]#FFFFFF Doğrulama kodunu girmediğiniz için saatlik bonus alamadınız.", player, 255, 0, 0, true)
								playSoundFrontEnd(player, 4)
								controlSystem[player] = nil
							end
						end
					end, 60 * 2000, 1, player)
				end
			end
		end
	end
end
setTimer(hourlyBox, 60 * 1000, 0)

function onaylaCommand(thePlayer, commandName, code)
	if code then 
		if controlSystem[thePlayer] then
			if tostring(controlSystem[thePlayer].code) == tostring(code) then
				controlSystem[thePlayer] = nil
				local bankMoney = getElementData(thePlayer, "bankmoney") or 0
				
				if getElementData(thePlayer, "vip") == 1 then
					setElementData(thePlayer, "bankmoney", bankMoney + 300)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [1] olduğunuz için saatlik maaşınız 300$ kazandınız.", thePlayer, 0, 255, 0, true)
				elseif getElementData(thePlayer, "vip") == 2 then
					setElementData(thePlayer, "bankmoney", bankMoney + 400)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [2] olduğunuz için saatlik maaşınız 400$ kazandınız.", thePlayer, 0, 255, 0, true)
				elseif getElementData(thePlayer, "vip") == 3 then
					setElementData(thePlayer, "bankmoney", bankMoney + 500)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [3] olduğunuz için saatlik maaşınız 500$ kazandınız.", thePlayer, 0, 255, 0, true)
				elseif getElementData(thePlayer, "vip") == 4 then
					setElementData(thePlayer, "bankmoney", bankMoney + 600)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [4] olduğunuz için saatlik maaşınız 600$ kazandınız.", thePlayer, 0, 255, 0, true)
				elseif getElementData(thePlayer, "vip") == 5 then
					setElementData(thePlayer, "bankmoney", bankMoney + 700)
					outputChatBox("[!]#FFFFFF Tebrikler, VIP [5] olduğunuz için saatlik maaşınız 700$ kazandınız.", thePlayer, 0, 255, 0, true)
				else
					setElementData(thePlayer, "bankmoney", bankMoney + 200)
					outputChatBox("[!]#FFFFFF Tebrikler, saatlik maaşınız 200$ yatırıldı.", thePlayer, 0, 255, 0, true)
				end
				
				triggerClientEvent(thePlayer, "playSuccessfulSound", thePlayer)
				dbExec(mysql:getConnection(), "UPDATE characters SET bankmoney = ? WHERE id = ?", getElementData(thePlayer, "bankmoney"), getElementData(thePlayer, "dbid"))
			else
				outputChatBox("[!]#FFFFFF Eksik ya da yanlış bir kod girdiniz.", thePlayer, 255, 0, 0, true)
				playSoundFrontEnd(thePlayer, 4)
			end
		end
	end
end
addCommandHandler("onayla", onaylaCommand, false, false)

function boxRemaining(source, commandName)
	local minutesPlayed = getElementData(source, "minutesPlayed") or 0
	local boxHours = getElementData(source, "box_hours") or 0
	local boxCount = getElementData(source, "box_count") or 0
	
	outputChatBox("[!]#FFFFFF Bir kutu daha kazanmanıza kalan zaman: " .. (3 - boxHours) .. " saat " .. (60 - minutesPlayed) .. " dakika", source, 0, 255, 0, true)
	outputChatBox("[!]#FFFFFF Kutu puanı: " .. boxHours .. "/4 (Tamamlandığında +1 kutu kazanırsınız.)", source, 0, 255, 0, true)
	outputChatBox("[!]#FFFFFF Kutu durumu: " .. boxCount .. " kutunuz var.", source, 0, 255, 0, true)
end
addCommandHandler("kutukalan", boxRemaining, false, false)

function openBox(source, commandName)
	if isElementWithinColShape(source, colSphere) then
		local boxCount = getElementData(source, "box_count") or 0
		if boxCount > 0 then
			local randomMoney = moneys[math.random(1, 10)]
			exports.cr_global:giveMoney(source, randomMoney)
			outputChatBox("[!]#FFFFFF Tebrikler, hediye ağacından " .. exports.cr_global:formatMoney(randomMoney) .. "$ aldınız.", source, 0, 255, 0, true)
			
			setElementData(source, "box_count", boxCount - 1)
			dbExec(mysql:getConnection(), "UPDATE characters SET box_count = ? WHERE id = ?", getElementData(source, "box_count"), getElementData(source, "dbid"))
		else
			outputChatBox("[!]#FFFFFF Hediye kutunuz bulunmuyor.", source, 255, 0, 0, true)
			playSoundFrontEnd(source, 4)
		end
	end
end
addCommandHandler("hediyeal", openBox, false, false)

addEventHandler("onElementDataChange", root, function(theKey, oldValue, newValue)
	if getElementType(source) == "player" and theKey == "hoursplayed" then
		local level = getPlayerLevel(source) or 1
		setElementData(source, "level", level)
		dbExec(mysql:getConnection(), "UPDATE characters SET level = ? WHERE id = ?", level, getElementData(source, "dbid"))
	end
end)

function getPlayerLevel(thePlayer)
	if getElementData(thePlayer, "loggedin") == 1 then
		local hoursPlayed = getElementData(thePlayer, "hoursplayed")
		for index, value in pairs(levels) do
			local minimum, maximum = unpack(value)
			if hoursPlayed >= minimum and hoursPlayed <= maximum then
				return index
			end	
		end
	end
	return false
end