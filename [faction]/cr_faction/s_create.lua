mysql = exports.cr_mysql
local birlikCol = createColSphere(1380.8447265625, -1088.904296875, 27.384355545044, 1)

function birlikKurTrigger(thePlayer, cmd)
	local playerTeam = getElementData(thePlayer, "faction")
	
	if playerTeam ~= -1 then
		outputChatBox("[!]#FFFFFF Zaten bir birliğiniz var.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
		return
	end
	
	if (isElementWithinColShape(thePlayer, birlikCol)) then
		triggerClientEvent(thePlayer, "birlikKurGUI", thePlayer)
	end
end
addCommandHandler("birlikkur", birlikKurTrigger, false, false)

function birlikKur(thePlayer, birlikName, birlikType)
	if client ~= source then return end
	
	local money = exports.cr_global:getMoney(thePlayer)	
	
	if string.len(birlikName) < 4 then
		outputChatBox("[!]#FFFFFF Birlik ismi en az 4 karakterden oluşmalıdır.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
		return false
	elseif string.len(birlikName) > 36 then
		outputChatBox("[!]#FFFFFF Birlik ismi en fazla 36 karakterden oluşmalıdır.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
		return false
	end
	
	if money >= 10000 then
		factionName = birlikName
		factionType = tonumber(birlikType)
		local getrow = mysql:query("SELECT * FROM factions WHERE name='" .. factionName .. "'")
		local numrows = mysql:num_rows(getrow)
		if numrows > 0 then
			outputChatBox("[!]#FFFFFF Maalesef, birlik ismi kullanımda!", thePlayer, 255, 0, 0, true)
			return false
		end
		
		local theTeam = createTeam(tostring(factionName))
		if theTeam then
			if mysql:query_free("INSERT INTO factions SET name='" .. mysql:escape_string(factionName) .. "', bankbalance='0', type='" .. mysql:escape_string(factionType) .. "'") then
				local id = mysql:insert_id()
				exports.cr_pool:allocateElement(theTeam, id)
				
				dbExec(mysql:getConnection(), "UPDATE factions SET rank_1='Dynamic Rank #1', rank_2='Dynamic Rank #2', rank_3='Dynamic Rank #3', rank_4='Dynamic Rank #4', rank_5='Dynamic Rank #5', rank_6='Dynamic Rank #6', rank_7='Dynamic Rank #7', rank_8='Dynamic Rank #8', rank_9='Dynamic Rank #9', rank_10='Dynamic Rank #10', rank_11='Dynamic Rank #11', rank_12='Dynamic Rank #12', rank_13='Dynamic Rank #13', rank_14='Dynamic Rank #14', rank_15='Dynamic Rank #15', rank_16='Dynamic Rank #16', rank_17='Dynamic Rank #17', rank_18='Dynamic Rank #18', rank_19='Dynamic Rank #19', rank_20='Dynamic Rank #20',  motd='Welcome to the faction.', note = '' WHERE id='" .. id .. "'")
				outputChatBox("[!]#FFFFFF Başarıyla " .. factionName .. " (" .. id .. ") isimli birlik kuruldu.", thePlayer, 0, 255, 0, true)
				setElementData(theTeam, "type", tonumber(factionType))
				setElementData(theTeam, "id", tonumber(id))
				setElementData(theTeam, "money", 0)
				
				local factionRanks = {}
				local factionWages = {}
				for i = 1, 20 do
					factionRanks[i] = "Dynamic Rank #" .. i
					factionWages[i] = 100
				end
				setElementData(theTeam, "ranks", factionRanks, false)
				setElementData(theTeam, "wages", factionWages, false)
				setElementData(theTeam, "motd", "Birliğe hoş geldiniz.", false)
				setElementData(theTeam, "note", "", false)
				
				dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = 1, faction_id = " .. tonumber(id) .. ", faction_rank = 1, faction_phone = NULL, duty = 0 WHERE id = " .. getElementData(thePlayer, "dbid"))
				setPlayerTeam(thePlayer, theTeam)
				setElementData(thePlayer, "faction", id, true)
				setElementData(thePlayer, "factionrank", 1, true)
				setElementData(thePlayer, "factionleader", 1, true)
				setElementData(thePlayer, "factionphone", nil, true)
				triggerEvent("duty:offduty", thePlayer)
				triggerEvent("onPlayerJoinFaction", thePlayer, theTeam)
				
				exports.cr_logs:dbLog(thePlayer, 4, theTeam, "MAKE FACTION")
				exports.cr_global:takeMoney(thePlayer, 10000)
				exports.cr_global:sendMessageToAdmins("[BIRLIK-KUR] " .. getPlayerName(thePlayer):gsub("_", " ") .. " isimli oyuncu " .. factionName .. " (" .. id .. ") isimli yeni birlik oluşturdu.")
			else
				destroyElement(theTeam)
				outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("[!]#FFFFFF Böyle bir birlik bulunuyor.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("[!]#FFFFFF Maalesef, birlik kuracak paranız yok.", thePlayer, 255, 0, 0, true)
	end
end
addEvent("birlikKur", true)
addEventHandler("birlikKur", getRootElement(), birlikKur)

function aracimiBirligeVer(thePlayer, cmd, vehID)
	if vehID then
		local playerID = getElementData(thePlayer, "dbid")
		local vehElement = exports.cr_pool:getElement("vehicle", vehID)
		local vehOwner = getElementData(vehElement, "owner")
		local vehFaction = getElementData(vehElement, "faction")
		if  vehFaction == -1 then
			if vehOwner == playerID then
				local playerBirlik = getElementData(thePlayer, "faction")
				if playerBirlik then
					local elementSet = setElementData(vehElement, "faction", playerBirlik)
					local query = mysql:query("UPDATE vehicles SET faction='" .. playerBirlik .. "' WHERE id='" .. vehID .. "'")
					if elementSet and query then
						exports["cr_items"]:deleteAll(3, vehID)
						outputChatBox("[!]#FFFFFF Aracınız başarıyla birliğe verilmiştir.", thePlayer, 0, 255, 0, true)
					end
				else
					outputChatBox("[!]#FFFFFF Bir birlikte değilsiniz.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!]#FFFFFF Araç size ait değil.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("[!]#FFFFFF Araç zaten bir birliğe ait.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("KULLANIM: /" .. cmd .. " [Araç ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("abv", aracimiBirligeVer)

function aracimiBirlikGeriVer(thePlayer, cmd, vehID)
	if vehID then
		local playerID = getElementData(thePlayer, "dbid")
		local vehElement = exports.cr_pool:getElement("vehicle", vehID)
		local vehOwner = getElementData(vehElement, "owner")
		local vehFaction = getElementData(vehElement, "faction")
		local factionLeader = getElementData(thePlayer, "factionleader")
		local playerBirlik = getElementData(thePlayer, "faction")
		if playerBirlik then
			if playerBirlik == vehFaction then
				if factionLeader == 1 then
					local elementSet = setElementData(vehElement, "faction", -1)
					local query = mysql:query("UPDATE vehicles SET faction='-1' WHERE id='" .. vehID .. "'")
					if elementSet and query then
						outputChatBox("[!]#FFFFFF Aracınız başarıyla sahibine geri verilmiştir!", thePlayer, 0, 255, 0, true)
					end
				else
					outputChatBox("[!]#FFFFFF Aracı sahibine geri verebilmek için birlik lideri olmalısınız.", thePlayer, 255, 0, 0, true)
				end
			end
		else
			outputChatBox("[!]#FFFFFF Bir birlikte değilsiniz.", thePlayer, 255, 0, 0, true)
		end
	else
		outputChatBox("KULLANIM: /" .. cmd .. " [Araç ID]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("abg", aracimiBirlikGeriVer)