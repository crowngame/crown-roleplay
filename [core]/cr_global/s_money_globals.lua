mysql = exports.cr_mysql

--TAX
tax = 15 -- percent
function getTaxAmount()
	return tax / 100
end
function setTaxAmount(new)
	tax = math.max(0, math.min(30, math.ceil(new)))
	mysql:query_free("UPDATE settings SET value = " .. tax .. " WHERE name = 'tax'")
end

--INCOME TAX
incometax = 10 -- percent
function getIncomeTaxAmount()
	return incometax / 100
end
function setIncomeTaxAmount(new)
	incometax = math.max(0, math.min(25, math.ceil(new)))
	mysql:query_free("UPDATE settings SET value = " .. incometax .. " WHERE name = 'incometax'")
end

-- load income and normal tax on startup
addEventHandler("onResourceStart", getResourceRootElement(),
	function()
		local result = mysql:query("SELECT value FROM settings WHERE name = 'tax'")
		if result then
			if mysql:num_rows(result) == 0 then
				mysql:query_free("INSERT INTO settings (name, value) VALUES ('tax', " .. tax .. ")")
			else
				local row = mysql:fetch_assoc(result)
				tax = tonumber(row["value"]) or 15
			end
			mysql:free_result(result)
		end
		
		local result = mysql:query("SELECT value FROM settings WHERE name = 'incometax'")
		if result then
			if mysql:num_rows(result) == 0 then
				mysql:query_free("INSERT INTO settings (name, value) VALUES ('incometax', " .. incometax .. ")")
			else
				local row = mysql:fetch_assoc(result)
				incometax = tonumber(row["value"]) or 10
			end
			mysql:free_result(result)
		end
	end
)

-- ////////////////////////////////////
local moneyTimer = {}
local loopLimit = 300
function giveMoney(thePlayer, amount)
	amount = tonumber(amount) or 0
	if amount == 0 then
		return true
	elseif thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.floor(amount)
		if getElementType(thePlayer) == "player" then
			if not dbExec(exports.cr_mysql:getConnection(), "UPDATE characters SET money = money + " .. amount .. " WHERE id = '" ..  getElementData(thePlayer, "dbid")  .. "'") then
				return false
			end

			-- Money / Add a loop check in case takeItem function fails. / Farid
			moneyTimer[thePlayer] = 0
			while exports['cr_items']:takeItem(thePlayer, 134) do
				if moneyTimer[thePlayer] >= loopLimit then
					outputDebugString("exports['cr_items']:takeItem() failed in global:giveMoney function!")
					break
				else
					moneyTimer[thePlayer] = moneyTimer[thePlayer] + 1
				end
			end
			
			if not setElementData(thePlayer, "money", getMoney(thePlayer) + amount, true) then
				return false
			end

			
			if tonumber(getElementData(thePlayer, "money")) > 0 then
				exports.cr_global:giveItem(thePlayer, 134, tonumber(getElementData(thePlayer, "money")))
			end
			
			triggerClientEvent(thePlayer, "moneyUpdateFX", thePlayer, true, amount)
			return true
		elseif getElementType(thePlayer) == "team" then
			return mysql:query_free("UPDATE factions SET bankbalance = bankbalance + " .. amount .. " WHERE id = " .. getElementData(thePlayer, "id")) and setElementData(thePlayer, "money", getMoney(thePlayer) + amount, true) 
		end
	end
	return false
end

function takeMoney(thePlayer, amount, rest)
	amount = tonumber(amount) or 0
	if amount == 0 then
		return true, 0
	elseif thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.ceil(amount)
		
		local money = getMoney(thePlayer)
		if rest and amount > money then
			amount = money
		end
		
		if amount == 0 then
			return true, 0
		elseif hasMoney(thePlayer, amount) then
			if getElementType(thePlayer) == "player" then
				if not dbExec(exports.cr_mysql:getConnection(), "UPDATE characters SET money = money - " .. amount .. " WHERE id = '" ..  getElementData(thePlayer, "dbid")  .. "'") then
					return false
				end

				moneyTimer[thePlayer] = 0
				while exports['cr_items']:takeItem(thePlayer, 134) do
					if moneyTimer[thePlayer] >= loopLimit then
						outputDebugString("exports['cr_items']:takeItem() failed in global:takeMoney function!")
						break
					else
						moneyTimer[thePlayer] = moneyTimer[thePlayer] + 1
					end
				end

				if not setElementData(thePlayer, "money", money - amount, true)	then
					return false
				end
				
				if tonumber(getElementData(thePlayer, "money")) > 0 then
					exports.cr_global:giveItem(thePlayer, 134, tonumber(getElementData(thePlayer, "money")))
				end
				
				triggerClientEvent(thePlayer, "moneyUpdateFX", thePlayer, false, amount)
				return true, amount
			elseif getElementType(thePlayer) == "team" then
				return mysql:query_free("UPDATE factions SET bankbalance = bankbalance - " .. amount .. " WHERE id = " .. getElementData(thePlayer, "id")) and setElementData(thePlayer, "money", money - amount, true)	
			end
			return false, 0
		end
	end
	return false, 0
end

function setMoney(thePlayer, amount, onSpawn)
	amount = tonumber(amount) or 0
	if thePlayer and isElement(thePlayer) and (amount >= 0 or onSpawn) then
		amount = math.floor(amount)
		if getElementType(thePlayer) == "player" then
			if not onSpawn then
				if not mysql:query_free("UPDATE characters SET money = " .. amount .. " WHERE id = " .. getElementData(thePlayer, "dbid")) then
					return false
				end
			end

			-- Money / Add a loop check in case takeItem function fails. / Farid
			moneyTimer[thePlayer] = 0
			while exports['cr_items']:takeItem(thePlayer, 134) do
				if moneyTimer[thePlayer] >= loopLimit then
					outputDebugString("exports['cr_items']:takeItem() failed in global:takeMoney function!")
					break
				else
					moneyTimer[thePlayer] = moneyTimer[thePlayer] + 1
				end
			end

			local currentMoney = getElementData(thePlayer, "money")

			if not setElementData(thePlayer, "money", amount, true) then
				return false
			end

			
			if amount > 0 then
				exports.cr_global:giveItem(thePlayer, 134, amount)
			end
		
			
			if not onSpawn then
				if amount > currentMoney then
					triggerClientEvent(thePlayer, "moneyUpdateFX", thePlayer, true, amount-currentMoney)
				elseif amount < currentMoney then
					triggerClientEvent(thePlayer, "moneyUpdateFX", thePlayer, false, currentMoney-amount)
				end
			end

			return true
		elseif getElementType(thePlayer) == "team" then
			return mysql:query_free("UPDATE factions SET bankbalance = " .. amount .. " WHERE id = " .. getElementData(thePlayer, "id")) and setElementData(thePlayer, "money", amount, true)
		end
	end
end

function hasMoney(thePlayer, amount)
	amount = tonumber(amount) or 0
	if thePlayer and isElement(thePlayer) and amount >= 0 then
		amount = math.floor(amount)
		
		return getMoney(thePlayer) >= amount
	end
	return false
end

function getMoney(thePlayer, nocheck)
	if not nocheck then
		--checkMoneyHacks(thePlayer) -- Disabled because we don't use MTA's setPlayerMoney/getPlayerMoney at all. /Farid
	end
	return getElementData(thePlayer, "money") or 0
end

function checkMoneyHacks(thePlayer)
	if not getMoney(thePlayer, true) or getElementType(thePlayer) ~= "player" then return end
	
	local safemoney = getMoney(thePlayer, true)
	local hackmoney = getPlayerMoney(thePlayer)
	if (safemoney < hackmoney) then
		setPlayerMoney(thePlayer, safemoney)
		sendMessageToAdmins("Possible money hack detected: " .. getPlayerName(thePlayer))
		return true
	else
		return false
	end
end

-- ////////////////////////////////////

function formatMoney(amount)
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end


addEvent("global:takeMoney", true)
addEventHandler("global:takeMoney", root, takeMoney)