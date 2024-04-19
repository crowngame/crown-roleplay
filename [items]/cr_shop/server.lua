local mysql = exports.cr_mysql
local shop = new("shops")

function shop.prototype.____constructor(self)
    self._function = {
        load = function(...) self:load(...) end, 
        load_all = function(...) self:load_all(...) end, 
        create = function(...) self:create(...) end, 
        nearbys = function(...) self:nearbys(...) end, 
        delete = function(...) self:delete(...) end, 
        teleport = function(...) self:teleport(...) end, 
        buy = function(...) self:buy(...) end, 
    }

    self._shop, self._count, self._npc = {}, 0, 0
    setTimer(self._function.load_all, 1000, 1)
    
    addCommandHandler("makeshop", self._function.create, false, false)
    addCommandHandler("nearbyshops", self._function.nearbys, false, false)
    addCommandHandler("delshop", self._function.delete, false, false)
    addCommandHandler("gotoshop", self._function.teleport, false, false)

    addEvent("shop.buy", true)
    addEventHandler("shop.buy", root, self._function.buy)
end

function shop.prototype.buy(self, shopID, itemID)
    -- item[1], item[2], item[3] = id, price, value
	if client ~= source then return end
	if shopID and itemID and tonumber(shopID) and tonumber(itemID) then
		local item = shopItems[shopID][itemID]
		if item[1] and item[2] and item[3] then
			if exports.cr_global:hasMoney(source, item[2]) then
				if exports.cr_items:hasSpaceForItem(source, item[1], item[3]) then
					if item[1] == 115 then
						local serial1 = tonumber(getElementData(source, "account:character:id"))
						local serial2 = tonumber(getElementData(source, "account:character:id"))
						local mySerial = exports.cr_global:createWeaponSerial(1, serial1, serial2)
						exports.cr_global:takeMoney(source, item[2])
						exports.cr_global:giveItem(source, 115, item[3] .. ":" .. mySerial .. ":" .. getWeaponNameFromID(item[3]) .. "::")
						outputChatBox("[!]#FFFFFF Başarıyla $" .. item[2] .. " karşılığında " .. exports.cr_items:getItemName(-item[3]) .. " aldınız.", source, 0, 255, 0, true)
						exports.cr_discord:sendMessage("shop-log", "[SHOP] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu $" .. item[2] .. " karşılığında " .. exports.cr_items:getItemName(-item[3]) .. " aldı.")
					elseif item[1] == 2 then
						local attempts = 0
						while true do
							attempts = attempts + 1
							itemValue = math.random(311111, attempts < 20 and 899999 or 8999999)
							
							local mysqlQ = mysql:query("SELECT `phonenumber` FROM `phones` WHERE `phonenumber` = '" .. itemValue .. "'")
							if mysql:num_rows(mysqlQ) == 0 then
								mysql:free_result(mysqlQ)
								break
							end
							mysql:free_result(mysqlQ)
						end

						exports.cr_global:takeMoney(source, item[2])
						exports.cr_items:giveItem(source, item[1], itemValue)
						outputChatBox("[!]#FFFFFF Başarıyla $" .. item[2] .. " karşılığında Telefon aldınız.", source, 0, 255, 0, true)
						exports.cr_discord:sendMessage("shop-log", "[SHOP] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu $" .. item[2] .. " karşılığında Telefon aldı.")
					elseif item[1] == 56 then 
						if getElementData(source, "vip") > 0 then 
							exports.cr_global:takeMoney(source, item[2])
							exports.cr_items:giveItem(source, item[1], item[3])
							outputChatBox("[!]#FFFFFF Başarıyla $" .. item[2] .. " karşılığında Maske aldınız.", source, 0, 255, 0, true)
							exports.cr_discord:sendMessage("shop-log", "[SHOP] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu $" .. item[2] .. " karşılığında Maske aldı.")
						else
							outputChatBox("[!]#FFFFFF Bu ürün VIP'lere özel olduğu için alamazsınız.", source, 255, 0, 0, true)
							playSoundFrontEnd(source, 4)
						end
					else
						exports.cr_global:takeMoney(source, item[2])
						exports.cr_global:giveItem(source, item[1], item[3])
						outputChatBox("[!]#FFFFFF Başarıyla $" .. item[2] .. " karşılığında " .. exports.cr_items:getItemName(item[1]) .. " aldınız.", source, 0, 255, 0, true)
						exports.cr_discord:sendMessage("shop-log", "[SHOP] " .. getPlayerName(source):gsub("_", " ") .. " isimli oyuncu $" .. item[2] .. " karşılığında " .. exports.cr_items:getItemName(item[1]) .. " aldı.")
					end

					exports.cr_global:sendLocalMeAction(source, "kasiyere bir miktar para uzatır, " .. exports.cr_items:getItemName(item[1]) .. " isimli eşyayı satın alır.")
				else
					outputChatBox("[!]#FFFFFF Bu ürünü taşıyabilmek için yeterli alana sahip değilsiniz.", source, 255, 0, 0, true)
					playSoundFrontEnd(source, 4)
				end
			else
				outputChatBox("[!]#FFFFFF " .. (item[1] == 115 and getWeaponNameFromID(item[3]) or exports.cr_items:getItemName(item[1])) .. " almak için yeterli miktarda paranız bulunmuyor.", source, 255, 0, 0, true)
				playSoundFrontEnd(source, 4)
			end
		end
	end
end

function shop.prototype.create(self, thePlayer, commandName, type, skin, name)
    if exports.cr_integration:isPlayerCommunityManager(thePlayer) then
        if not tonumber(type) or not tonumber(skin) or not name or tonumber(type) > #types or tonumber(type) < 0 then
            outputChatBox("KULLANIM: /" .. commandName .. " [Tip] [Skin | -1 = Rastgele] [Karakter Adı | -1 = Rastgele]", thePlayer, 255, 194, 14)
		    outputChatBox("[!]#FFFFFF Tip: 1 = Genel Mağaza", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tip: 2 = Yemek Mağazası", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tip: 3 = Elektronik Mağazası", thePlayer, 0, 0, 255, true)
            outputChatBox("[!]#FFFFFF Tip: 4 = Spor Mağazası", thePlayer, 0, 0, 255, true)
        else
			if tonumber(skin) == -1 then
				skin = exports.cr_global:getRandomSkin()
			end
			
			if tonumber(name) == -1 then
				name = exports.cr_global:createRandomMaleName()
				name = string.gsub(name, " ", "_")
			end
			
            dbQuery(function(qh)
                local result = dbPoll(qh, 0)
                if result and #result > 0 then 
                    outputChatBox("[!]#FFFFFF Bu isimde bir NPC mağaza zaten var.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
                else 
                    local type = math.floor(tonumber(type))
                    local x, y, z = getElementPosition(thePlayer)
                    local _, _, rot = getElementRotation(thePlayer)
                    local interior, dimension = getElementInterior(thePlayer), getElementDimension(thePlayer)
                    local names = types[type]
                    dbQuery(function(qh)
                        local result, _, id = dbPoll(qh, 0)
                        if id then
                            self._function.load(id)
                            outputChatBox("[!]#FFFFFF Yeni bir NPC mağaza (ID: " .. id .. " - " .. names .. ") oluşturdunuz.", thePlayer, 0, 255, 0, true)
                        else 
                            outputChatBox("[!]#FFFFFF Bir sorun oluştu.", thePlayer, 255, 0, 0, true)
							playSoundFrontEnd(thePlayer, 4)
                        end
                    end, mysql:getConnection(), "INSERT INTO shops SET skin = ?, x = ?, y = ?, z = ?, rotation = ?, dimension = ?, interior = ?, shoptype = ?, pedName = ?", skin, x, y, z, rot, dimension, interior, type, tostring(name))
                end
            end, mysql:getConnection(), "SELECT * FROM shops WHERE pedName = ?", name)
        end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

function shop.prototype.nearbys(self, thePlayer, commandName)
    if exports.cr_integration:isPlayerCommunityManager(thePlayer) then
        local px, py, pz = getElementPosition(thePlayer)
        for k, v in pairs(getElementsByType("ped", resourceRoot, true)) do 
            if getElementData(v, "shop.type") or false then 
                local x, y, z = getElementPosition(v)
                local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
                if distance <= 20 then 
                    outputChatBox("[!]#FFFFFF ID: " .. getElementData(v, "shop.id") .. " - Tip: (#" .. getElementData(v, "shop.type") .. ") - Mesafe: " .. math.ceil(distance) .. " m.", thePlayer, 0, 0, 255, true)
                    self._npc = self._npc + 1
                end
            end
        end
		
        if self._npc == 0 then 
            outputChatBox("[!]#FFFFFF Yakınınızda NPC mağaza bulunmuyor.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
        end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

function shop.prototype.delete(self, thePlayer, commandName, id)
    if exports.cr_integration:isPlayerCommunityManager(thePlayer) then 
        if not id or not tonumber(id) then outputChatBox("KULLANIM: /delshop [ID]", thePlayer, 255, 194, 14) return end
        local id = math.floor(tonumber(id))
        if self._shop[id] then
            local ped = self._shop[id]
            if isElement(ped) then
                destroyElement(ped)
            end
            dbExec(mysql:getConnection(), "DELETE FROM shops WHERE id = ?", id)
            outputChatBox("[!]#FFFFFF Başarıyla [" .. id .. "] ID'li NPC mağazayı kaldırdınız.", thePlayer, 0, 255, 0, true)
        else
            outputChatBox("[!]#FFFFFF [" .. id .. "] ID'li bir NPC mağaza bulunmuyor.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
        end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

function shop.prototype.teleport(self, thePlayer, commandName, id)
    if exports.cr_integration:isPlayerCommunityManager(thePlayer) then 
        if not id or not tonumber(id) then outputChatBox("KULLANIM: /gotoshop [ID]", thePlayer, 255, 194, 14) return end
        local id = math.floor(tonumber(id))
        if self._shop[id] then 
            local ped = self._shop[id]
            if isElement(ped) then 
                local x, y, z = getElementPosition(ped)
                local rot = getElementRotation(ped)
                local dim = getElementDimension(ped)
                local int = getElementInterior(ped)
                if not isPedInVehicle(thePlayer) then
                    setElementPosition(thePlayer, x, y, z)
                    setElementInterior(thePlayer, int)
                    setElementDimension(thePlayer, dim)
                    outputChatBox("[!]#FFFFFF Başarıyla [" .. id .. "] ID'li NPC mağazaya ışınlandınız.", thePlayer, 0, 255, 0, true)
                else
                    outputChatBox("[!]#FFFFFF Araç içerisindeyken bu işlemi gerçekleştiremezsiniz.", thePlayer, 255, 0, 0, true)
					playSoundFrontEnd(thePlayer, 4)
                end                   
            end
        else
            outputChatBox("[!]#FFFFFF [" .. id .. "] ID'li bir NPC mağaza bulunmuyor.", thePlayer, 255, 0, 0, true)
			playSoundFrontEnd(thePlayer, 4)
        end
    else
		outputChatBox("[!]#FFFFFF Bu komutu kullanabilmek için gerekli yetkiye sahip değilsiniz.", thePlayer, 255, 0, 0, true)
		playSoundFrontEnd(thePlayer, 4)
	end
end

function shop.prototype.load(self, id)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if #result > 0 then 
            for k, v in pairs(result) do 
                local ped = createPed(v.skin, v.x, v.y, v.z, v.rotation)
                setElementDimension(ped, v.dimension)
                setElementInterior(ped, v.interior)
                setElementFrozen(ped, true)
                setElementData(ped, "talk", 1)
                setElementData(ped, "shop.id", v.id)
                setElementData(ped, "shop.type", v.shoptype)
                setElementData(ped, "name", v.pedName)
                self._shop[v.id] = ped
				setPedWalkingStyle(self._shop[v.id], 118)
            end
        end
    end, mysql:getConnection(), "SELECT * FROM shops WHERE id = ? AND deletedBy = 0", id)
end

function shop.prototype.load_all(self)
    dbQuery(function(qh)
        local result = dbPoll(qh, 0)
        if #result > 0 then 
            for k, v in pairs(result) do 
                self._function.load(v.id)
                self._count = self._count + 1
            end
            outputDebugString("[SHOPS] Toplamda " .. self._count .. " adet mağaza yüklendi.")
        end
    end, mysql:getConnection(), "SELECT id FROM shops")
end

function getNextID()
    local qH = dbQuery(mysql:getConnection(), "SELECT MIN(e1.phonenumber+1) AS nextID FROM phones AS e1 LEFT JOIN phones AS e2 ON e1.phonenumber +1 = e2.phonenumber WHERE e2.phonenumber IS NULL")
    local result = dbPoll(qH, -1)
    if result then
        local id = tonumber(result[1]["nextID"]) or 1
        return id
    end
    return false
end

load(shop)