local PD_VEHICLES = { 427, 490, 528, 523, 598, 596, 597, 599, 601 }
local resourceName = getResourceName(getThisResource())

------------------------------------------
function loginMDC(user, pass)
	user = exports.cr_mysql:escape_string(user)
	pass = exports.cr_mysql:escape_string(pass)
	local account = exports.cr_mysql:query("SELECT * FROM mdc_users WHERE `user` = '" .. user .. "' AND `pass` = '" .. pass .. "'")
	if exports.cr_mysql:num_rows(account) > 0 then
		local row = exports.cr_mysql:fetch_assoc(account)
		return row
	else
		return 0
	end
end

function getMDCNameFromID(id)
	local row = nil
	local result = exports.cr_mysql:query("SELECT * FROM mdc_users WHERE `id` = '" .. id .. "'")
	if exports.cr_mysql:num_rows(result) > 0 then
		row = exports.cr_mysql:fetch_assoc(result)
		exports.cr_mysql:free_result(result)
		return row.user
	else
		return "Unknown"
	end
end

------------------------------------------
function login(user, pass)
	local account = nil
	if user == nil or pass == nil then
		outputChatBox("KULLANIM: /" ..  command  .. " [username] [password]", source, 155, 155, 255)
	else
		user = exports.cr_mysql:escape_string(user)
		pass = exports.cr_mysql:escape_string(pass)
		
		local accountQuery = exports.cr_mysql:query("SELECT * FROM mdc_users WHERE `user` = '" .. user .. "' AND `pass` = '" .. pass .. "'")
		if exports.cr_mysql:num_rows(accountQuery) > 0 then
			account = exports.cr_mysql:fetch_assoc(accountQuery)
			setElementData(source, "mdc_account", tonumber(account.id))
			setElementData(source, "mdc_admin", tonumber(account.level))
			main()
		else
			outputChatBox("[!]#FFFFFF Girdiğiniz bilgiler yanlış.", source, 255, 155, 155, true)
		end
	end	
end

function main ()
	local warrants = { }
	local apb = { }
	local calls = { }
	
	local warrantResult = exports.cr_mysql:query("SELECT `character`,`wanted_by`,`wanted_details` FROM `mdc_criminals` WHERE `wanted` = '1'")
	if (warrantResult) then
		local count = 1
		while true do
			row = exports.cr_mysql:fetch_assoc(warrantResult)
			if not row then break end
			warrants[count] = { }
			
			--Fetch character name from ID
			local char = nil
			local characterResult = exports.cr_mysql:query("SELECT `charactername` FROM `characters` WHERE `id` = '" ..  exports.cr_mysql:escape_string(row.character)  .. "'")
			warrants[count][1] = "Unknown"
			if exports.cr_mysql:num_rows(characterResult) > 0 then
				char = exports.cr_mysql:fetch_assoc(characterResult)
				warrants[count][1] = char.charactername
			end
			
			
			--Fetch mdc account name from ID
			local account = nil
			local accountResult = exports.cr_mysql:query("SELECT `user` FROM mdc_users WHERE `id` = '" ..  exports.cr_mysql:escape_string(row.wanted_by)  .. "'")
			if exports.cr_mysql:num_rows(accountResult) > 0 then
				account = exports.cr_mysql:fetch_assoc(accountResult)
				warrants[count][3] = account.user
			else
				warrants[count][3] = "Unknown"
			end
			
			warrants[count][2] = row.wanted_details
			count = count + 1
		end
		exports.cr_mysql:free_result(warrantResult)
	end
	
	local apbResult = exports.cr_mysql:query("SELECT * FROM `mdc_apb`")
	if (apbResult) then
		local count = 1
		while true do
			row = exports.cr_mysql:fetch_assoc(apbResult)
			if not row then break end
			apb[count] = { }
			
			apb[count][1] = row.person_involved
			
			--Fetch mdc account name from ID
			local account = nil
			local accountResult = exports.cr_mysql:query("SELECT `user` FROM mdc_users WHERE `id` = '" ..  exports.cr_mysql:escape_string(row.doneby)  .. "'")
			apb[count][3] = "Unknown"
			if exports.cr_mysql:num_rows(accountResult) > 0 then
				account = exports.cr_mysql:fetch_assoc(accountResult)
				apb[count][3] = account.user
			end
			
			apb[count][2] = row.description
			apb[count][4] = row.id
			count = count + 1
		end
		exports.cr_mysql:free_result(apbResult)
	end
	
	local callsResult = exports.cr_mysql:query("SELECT * FROM `mdc_calls` WHERE `timestamp` > CURDATE() - INTERVAL 2 DAY")
	if (callsResult) then
		local count = 1
		while true do
			row = exports.cr_mysql:fetch_assoc(callsResult)
			if not row then break end
			calls[count] = { }
			
			--Fetch mdc account name from ID
			local account = nil
			local accountResult = exports.cr_mysql:query("SELECT `charactername` FROM characters WHERE `id` = '" ..  exports.cr_mysql:escape_string(row.caller)  .. "'")
			calls[count][2] = "Unknown"
			if exports.cr_mysql:num_rows(accountResult) > 0 then
				account = exports.cr_mysql:fetch_assoc(accountResult)
				calls[count][2] = account.charactername
			end
			calls[count][1] = row.id
			
			calls[count][3] = row.number
			calls[count][4] = row.description
			calls[count][5] = row.timestamp
			count = count + 1
		end
		exports.cr_mysql:free_result(callsResult)
	end
	
	
	triggerClientEvent(source, resourceName .. ":main", getRootElement(), warrants, apb, calls) 
end

function search(query, queryType)
	queryType = tonumber(queryType)
	if queryType == -1 then --No type selected.
		triggerClientEvent(source, resourceName .. ":search_error", getRootElement())
	elseif queryType == 0 then --Person
		local character = nil
		local criminal = nil
		local wantedUser = nil
		local crimesRow = nil
		
		local result = exports.cr_mysql:query("SELECT * FROM characters WHERE `charactername` = '" ..  exports.cr_mysql:escape_string(query:gsub(" ", "_"))  .. "'") --Fetch the information from the database about our character.
		
		
		if exports.cr_mysql:num_rows(result) > 0 then
			character = exports.cr_mysql:fetch_assoc(result)
			local result2 = exports.cr_mysql:query("SELECT * FROM `mdc_criminals` WHERE `character` = '" ..  character.id  .. "'") --Select what the PD already knows about this character.
			
			if exports.cr_mysql:num_rows(result2) > 0 then --This MDC profile has been visited before.
				criminal = exports.cr_mysql:fetch_assoc(result2)
			else -- Nobody has gone to this person's MDC, so lets create a template for them to add information to.
				local query = exports.cr_mysql:query_insert_free("INSERT INTO `mdc_criminals` (`character`) VALUES ('" .. character.id .. "')") 
				local result2 = exports.cr_mysql:query("SELECT * FROM `mdc_criminals` WHERE `character` = '" ..  character.id  .. "'") --Select what the PD already knows about this character.
				if query then
					if exports.cr_mysql:num_rows(result2) > 0 then --This MDC profile has been visited before.
						criminal = exports.cr_mysql:fetch_assoc(result2)
					end
				end
			end
			
			
			
			if tonumber(criminal.wanted) == 1 then
				local result3 = exports.cr_mysql:query("SELECT `user` FROM mdc_users WHERE `id` = '" ..  exports.cr_mysql:escape_string(criminal.wanted_by)  .. "'") --We need to figure out the wanted by's name!
				criminal.wanted_by = "unknown"
				if exports.cr_mysql:num_rows(result3) > 0 then
					wantedUser = exports.cr_mysql:fetch_assoc(result3)
					criminal.wanted_by = wantedUser.user
				end
				
			end
			
			local vehicles = { }
			local result4 = exports.cr_mysql:query("SELECT `id`, `model`, `plate` FROM `vehicles` WHERE `owner` = '" ..  character.id  .. "'")
			if (result4) then
				local count = 1
				while true do
					row = exports.cr_mysql:fetch_assoc(result4)
					if not row then break end
					vehicles[count] = { }
					vehicles[count][1] = row.id
					vehicles[count][2] = row.model
					vehicles[count][3] = row.plate
					count = count + 1
					
				end
				
				exports.cr_mysql:free_result(result4)
			end
			
			local properties = { }
			local result5 = exports.cr_mysql:query("SELECT `id`, `name` FROM `interiors` WHERE `owner` = '" ..  character.id  .. "'")
			if (result5) then
				local count = 1
				while true do
					row = exports.cr_mysql:fetch_assoc(result5)
					if not row then break end
					properties[count] = { }
					properties[count][1] = row.id
					properties[count][2] = row.name
					count = count + 1
					
				end
				
				exports.cr_mysql:free_result(result5)
			end
			
			local crimes = { }
			local result6 = exports.cr_mysql:query("SELECT * FROM `mdc_crimes` WHERE `character` = '" ..  character.id  .. "' ORDER BY `id` DESC")
			if (result6) then
				local count = 1
				while true do
					row = exports.cr_mysql:fetch_assoc(result6)
					if not row then break end
					crimes[count] = { }
					crimes[count][1] = row.id
					crimes[count][2] = row.crime
					crimes[count][3] = row.punishment
					crimes[count][4] = getMDCNameFromID(row.officer)
					crimes[count][5] = row.timestamp
					count = count + 1
					
				end
				
				exports.cr_mysql:free_result(result5)
			end
			
			triggerClientEvent(source, resourceName .. ":display_person", getRootElement(), character.charactername, character.age, character.weight, character.height, character.gender, character.car_license, character.gun_license, character.pdjail, criminal.dob, criminal.ethnicity, criminal.phone, criminal.occupation, criminal.address, criminal.photo, criminal.details, criminal.created_by, criminal.wanted, criminal.wanted_by, criminal.wanted_details, character.id, vehicles, properties, crimes) 
			
			exports.cr_mysql:free_result(result)
		else
			triggerClientEvent(source, resourceName .. ":search_noresult", getRootElement())
		end
	elseif queryType == 1 then --Vehicle
		local vehicle = nil
		
		local result = exports.cr_mysql:query("SELECT * FROM vehicles WHERE `plate` = '" ..  exports.cr_mysql:escape_string(query)  .. "'") --Fetch the information from the database 
		if exports.cr_mysql:num_rows(result) > 0 then
			vehicle = exports.cr_mysql:fetch_assoc(result)
			
			local crimes = { }
			local result2 = exports.cr_mysql:query("SELECT * FROM `speedingviolations` WHERE `carID` = '" ..  vehicle.id  .. "' ORDER BY `id` DESC")
			if (result2) then
				local count = 1
				while true do
					row = exports.cr_mysql:fetch_assoc(result2)
					if not row then break end
					crimes[count] = { }
					crimes[count][1] = row.time
					crimes[count][2] = row.speed
					crimes[count][3] = row.area
					crimes[count][4] = exports.cr_cache:getCharacterName(row["personVisible"]) or "Not visible"
					count = count + 1
					
				end
				exports.cr_mysql:free_result(result2)
			end
			
			if tonumber(vehicle.owner) ~= -1 then
				local owner = nil
				local result3 = exports.cr_mysql:query("SELECT `charactername` FROM `characters` WHERE `id` = '" ..  exports.cr_mysql:escape_string(vehicle.owner) .. "'")
				if exports.cr_mysql:num_rows(result3) > 0 then
					owner = exports.cr_mysql:fetch_assoc(result3)
				end
				vehicle.owner = owner.charactername
				vehicle.owner_type = 1
			elseif tonumber(vehicle.faction) ~= -1 then
				local owner = nil
				local result3 = exports.cr_mysql:query("SELECT `name` FROM `factions` WHERE `id` = '" ..  exports.cr_mysql:escape_string(vehicle.faction) .. "'")
				if exports.cr_mysql:num_rows(result3) > 0 then
					owner = exports.cr_mysql:fetch_assoc(result3)
				end
				vehicle.owner = owner.name
				vehicle.owner_type = 2
			else
				vehicle.owner = "None"
				vehicle.owner_type = 0
			end
				
			triggerClientEvent(source, resourceName .. ":display_vehicle", getRootElement(), vehicle.id, vehicle.model, vehicle.color1, vehicle.color2, vehicle.color3, vehicle.color4, vehicle.plate, vehicle.faction, vehicle.owner, vehicle.owner_type, vehicle.impounded, crimes)
		else
			triggerClientEvent(source, resourceName .. ":search_noresult", getRootElement())
		end
	elseif queryType == 2 then --Property
		local result = exports.cr_mysql:query("SElECT * FROM interiors WHERE `id` = '" .. exports.cr_mysql:escape_string(query) .. "'")
		if exports.cr_mysql:num_rows(result) > 0 then
			interior = exports.cr_mysql:fetch_assoc(result)
			if tonumber(interior.type) == 0 then
				interior.type = "House"
			elseif tonumber(interior.type) == 1 then
				interior.type = "Business"
			elseif tonumber(interior.type) == 2 then
				interior.type = "Government"
			else
				interior.type = "Apartment"
			end
			local owner = exports.cr_cache:getCharacterName(interior.owner) or "N/A"
			local district = getZoneName (interior.x, interior.y, interior.z, false) .. ", " .. getZoneName (interior.x, interior.y, interior.z, true)
			triggerClientEvent (source, resourceName .. ":display_property", getRootElement(), interior.id, interior.type, owner, interior.cost, interior.name, district)
		else
			triggerClientEvent(source, resourceName .. ":search_error", getRootElement())
		end
		
	elseif queryType == 3 then --Vehicle by ID
		local vehicle = nil
		
		local result = exports.cr_mysql:query("SELECT * FROM vehicles WHERE `id` = '" ..  exports.cr_mysql:escape_string(query)  .. "'") --Fetch the information from the database 
		if exports.cr_mysql:num_rows(result) > 0 then
			vehicle = exports.cr_mysql:fetch_assoc(result)
			
			local crimes = { }
			local result2 = exports.cr_mysql:query("SELECT * FROM `speedingviolations` WHERE `carID` = '" ..  vehicle.id  .. "' ORDER BY `id` DESC")
			if (result2) then
				local count = 1
				while true do
					row = exports.cr_mysql:fetch_assoc(result2)
					if not row then break end
					crimes[count] = { }
					crimes[count][1] = row.time
					crimes[count][2] = row.speed
					crimes[count][3] = row.area
					crimes[count][4] = exports.cr_cache:getCharacterName(row["personVisible"]) or "Not visible"
					count = count + 1
					
				end
				exports.cr_mysql:free_result(result2)
			end
			
			if tonumber(vehicle.owner) ~= -1 then
				local owner = nil
				local result3 = exports.cr_mysql:query("SELECT `charactername` FROM `characters` WHERE `id` = '" ..  exports.cr_mysql:escape_string(vehicle.owner) .. "'")
				if exports.cr_mysql:num_rows(result3) > 0 then
					owner = exports.cr_mysql:fetch_assoc(result3)
				end
				vehicle.owner = owner.charactername
				vehicle.owner_type = 1
			elseif tonumber(vehicle.faction) ~= -1 then
				local owner = nil
				local result3 = exports.cr_mysql:query("SELECT `name` FROM `factions` WHERE `id` = '" ..  exports.cr_mysql:escape_string(vehicle.faction) .. "'")
				if exports.cr_mysql:num_rows(result3) > 0 then
					owner = exports.cr_mysql:fetch_assoc(result3)
				end
				vehicle.owner = owner.name
				vehicle.owner_type = 2
			else
				vehicle.owner = "None"
				vehicle.owner_type = 0
			end
				
			triggerClientEvent(source, resourceName .. ":display_vehicle", getRootElement(), vehicle.id, vehicle.model, vehicle.color1, vehicle.color2, vehicle.color3, vehicle.color4, vehicle.plate, vehicle.faction, vehicle.owner, vehicle.owner_type, vehicle.impounded, crimes)
		else
			triggerClientEvent(source, resourceName .. ":search_noresult", getRootElement())
		end
	else --This wasn't called by the client GUI, and therefore do nothing.
		return false
	end
end

function add_crime(charid, charactername, crime, punishment)
	local officer = getElementData(source, "mdc_account")
	local time = getRealTime()
	local timestamp = time.timestamp
	local query = exports.cr_mysql:query_insert_free("INSERT INTO `mdc_crimes` (`crime`, `punishment`, `character`, `officer`, `timestamp`) VALUES ('" .. exports.cr_mysql:escape_string(crime) .. "','" .. exports.cr_mysql:escape_string(punishment) .. "','" .. charid .. "','" .. officer .. "', '" .. timestamp .. "')")
	if query then
		search(charactername, 0)
	end
end
	
function add_apb(description, person)
	local officer = getElementData(source, "mdc_account")
	local time = getRealTime()
	local timestamp = time.timestamp
	local query = exports.cr_mysql:query_insert_free("INSERT INTO `mdc_apb` (`person_involved`, `description`, `doneby`, `time`) VALUES ('" .. exports.cr_mysql:escape_string(person) .. "','" .. exports.cr_mysql:escape_string(description) .. "','" .. officer .. "', '" .. timestamp .. "')")
	if query then
		main()
	end
end

function remove_crime(charactername, crime_id)

	local query = exports.cr_mysql:query("DELETE FROM `mdc_crimes` WHERE `id` = '" .. crime_id .. "'")
	if query then
		search(charactername, 0)
	end
end

function remove_apb(id)
	local query = exports.cr_mysql:query("DELETE FROM `mdc_apb` WHERE `id` = '" .. id .. "'")
	if query then
		main()
	end
end

function update_person(charid, charactername, dob, ethnicity, phone, occupation, address, photo)
	if tonumber(photo) > 1 then
		photo = exports.cr_mysql:escape_string(photo)
	else
		local qSkin = exports.cr_mysql:query("SELECT `skin` FROM `characters` WHERE `id` = '" .. exports.cr_mysql:escape_string(charid) .. "' ")
		if exports.cr_mysql:num_rows(qSkin) > 0 then
			local row = exports.cr_mysql:fetch_assoc(qSkin)
			photo = row.skin
		end
	end
	
	dob			= exports.cr_mysql:escape_string(dob)
	ethnicity	= exports.cr_mysql:escape_string(ethnicity)
	phone		= exports.cr_mysql:escape_string(phone)
	occupation	= exports.cr_mysql:escape_string(occupation)
	address		= exports.cr_mysql:escape_string(address)
	
	
	
	local qUpdate = exports.cr_mysql:query("UPDATE `mdc_criminals` SET `dob` = '" .. dob .. "', `ethnicity` = '" .. ethnicity .. "', `phone` = '" .. phone .. "', `occupation` = '" .. occupation .. "', `address` = '" .. address .. "', `photo` = '" .. photo .. "' WHERE `character` = '" .. exports.cr_mysql:escape_string(charid) .. "' ")
	if qUpdate then
		search(charactername, 0)
	end
end

function update_details(charid, charactername, details)

	details		= exports.cr_mysql:escape_string(details)
	
	local qUpdate = exports.cr_mysql:query("UPDATE `mdc_criminals` SET `details` = '" .. details .. "' WHERE `character` = '" .. exports.cr_mysql:escape_string(charid) .. "' ")
	if qUpdate then
		search(charactername, 0)
	end
end

function update_warrant(charid, charactername, wanted, details)
	
	details = exports.cr_mysql:escape_string(details)
	local wanted_by = getElementData(source, "mdc_account")
	
	local qUpdate = exports.cr_mysql:query("UPDATE `mdc_criminals` SET `wanted` = '" .. wanted .. "', `wanted_by` = '" .. wanted_by .. "', `wanted_details` = '" .. details .. "' WHERE `character` = '" .. exports.cr_mysql:escape_string(charid) .. "' ")
	if qUpdate then
		search(charactername, 0)
	end
end

function tolls()	
	local locked = { }
	locked [1] = exports.cr_toll:isTollLocked(1)
	locked [2] = exports.cr_toll:isTollLocked(3)
	locked [3] = exports.cr_toll:isTollLocked(5)
	locked [4] = exports.cr_toll:isTollLocked(6)
	locked [5] = exports.cr_toll:isTollLocked(7)
	locked [6] = exports.cr_toll:isTollLocked(9)
	locked [7] = exports.cr_toll:isTollLocked(10)
	locked [8] = exports.cr_toll:isTollLocked(11)
	locked [9] = exports.cr_toll:isTollLocked(12)
	locked [10] = exports.cr_toll:isTollLocked(13)
	triggerClientEvent(source, resourceName .. ":tolls", getRootElement(), locked)
end

function toggle_toll(id)
	--We create a system here so that both directions are blocked at once for simplicity's sake.
	if id == 1 then
		exports.cr_toll:toggleToll(1)
		if exports.cr_toll:isTollLocked(1) ~= exports.cr_toll:isTollLocked(2) then exports.cr_toll:toggleToll(2) end
	elseif id == 2 then
		exports.cr_toll:toggleToll(3)
		if exports.cr_toll:isTollLocked(3) ~= exports.cr_toll:isTollLocked(4) then exports.cr_toll:toggleToll(4) end
	elseif id == 3 then
		exports.cr_toll:toggleToll(5)
	elseif id == 4 then
		exports.cr_toll:toggleToll(6)
	elseif id == 5 then
		exports.cr_toll:toggleToll(7)
		if exports.cr_toll:isTollLocked(7) ~= exports.cr_toll:isTollLocked(8) then exports.cr_toll:toggleToll(8) end
	elseif id == 6 then
		exports.cr_toll:toggleToll(9)
	elseif id == 7 then
		exports.cr_toll:toggleToll(10)
	elseif id == 8 then
		exports.cr_toll:toggleToll(11)
	elseif id == 9 then
		exports.cr_toll:toggleToll(12)
	elseif id == 10 then
		exports.cr_toll:toggleToll(13)
	end
		
	tolls()
end

function system_admin()
	local query = exports.cr_mysql:query("SELECT * FROM mdc_users ORDER BY id ASC")
	if (query) then
		local rows = { }
		local count = 1
		
		while true do
			row = exports.cr_mysql:fetch_assoc(query)
			if not row then break end
			rows[count] = { }
			rows[count][1] = row.id
			rows[count][2] = row.user
			rows[count][3] = row.level
			count = count + 1
			
		end
		
		exports.cr_mysql:free_result(query)
		triggerClientEvent(source, resourceName .. ":system_admin", getRootElement(), rows, count)
	end
end

function create_account(user, pass, level)
	if level == -1 then
		level = 0
	end
	
	local query = "INSERT INTO `mdc_users` (`user`, `pass`, `level`) VALUES ('" .. exports.cr_mysql:escape_string(user) .. "','" .. exports.cr_mysql:escape_string(pass) .. "','" .. exports.cr_mysql:escape_string(level + 1) .. "')"
	if exports.cr_mysql:query(query) then
		system_admin()
	end
end

function edit_account(id, user, pass, level)
	local query = "UPDATE `mdc_users` SET `user` = '" .. exports.cr_mysql:escape_string(user) .. "' "
		..((string.len(pass) > 0) and ", `pass` = '" .. exports.cr_mysql:escape_string(pass) .. "' " or " ")
		..((level ~= -1) and ", `level` = '" .. exports.cr_mysql:escape_string(level + 1) .. "' " or " ")
		 .. "WHERE `id` = '" .. id .. "' "
	
	if exports.cr_mysql:query(query) then
		system_admin()
	end
end

function edit_self(pass)
	local id = getElementData(source, "mdc_account")
	local query = "UPDATE `mdc_users` SET `pass` = '" .. exports.cr_mysql:escape_string(pass) .. "' WHERE `id` = '" .. id .. "' "
	
	if exports.cr_mysql:query(query) then
		triggerClientEvent(source, resourceName .. ":edit_self_success", getRootElement())
	end
end

function delete_account(id)
	local query = exports.cr_mysql:query("DELETE FROM `mdc_users` WHERE `id` = '" .. id .. "'")
	if query then
		system_admin()
	end
end

------------------------------------------
addEvent(resourceName .. ":login", true)
addEvent(resourceName .. ":main", true)
addEvent(resourceName .. ":search", true)
addEvent(resourceName .. ":add_crime", true)
addEvent(resourceName .. ":add_apb", true)
addEvent(resourceName .. ":remove_crime", true)
addEvent(resourceName .. ":remove_apb", true)
addEvent(resourceName .. ":update_person", true)
addEvent(resourceName .. ":update_details", true)
addEvent(resourceName .. ":update_warrant", true)
addEvent(resourceName .. ":tolls", true)
addEvent(resourceName .. ":toggle_toll", true)
addEvent(resourceName .. ":system_admin", true)
addEvent(resourceName .. ":create_account", true)
addEvent(resourceName .. ":edit_account", true)
addEvent(resourceName .. ":edit_self", true)
addEvent(resourceName .. ":delete_account", true)
addEventHandler(resourceName .. ":login", getRootElement(), login)
addEventHandler(resourceName .. ":main", getRootElement(), main)
addEventHandler(resourceName .. ":search", getRootElement(), search)
addEventHandler(resourceName .. ":add_crime", getRootElement(), add_crime)
addEventHandler(resourceName .. ":add_apb", getRootElement(), add_apb)
addEventHandler(resourceName .. ":remove_crime", getRootElement(), remove_crime)
addEventHandler(resourceName .. ":remove_apb", getRootElement(), remove_apb)
addEventHandler(resourceName .. ":update_person", getRootElement(), update_person)
addEventHandler(resourceName .. ":update_details", getRootElement(), update_details)
addEventHandler(resourceName .. ":update_warrant", getRootElement(), update_warrant)
addEventHandler(resourceName .. ":tolls", getRootElement(), tolls)
addEventHandler(resourceName .. ":toggle_toll", getRootElement(), toggle_toll)
addEventHandler(resourceName .. ":system_admin", getRootElement(), system_admin)
addEventHandler(resourceName .. ":create_account", getRootElement(), create_account)
addEventHandler(resourceName .. ":edit_account", getRootElement(), edit_account)
addEventHandler(resourceName .. ":edit_self", getRootElement(), edit_self)
addEventHandler(resourceName .. ":delete_account", getRootElement(), delete_account)