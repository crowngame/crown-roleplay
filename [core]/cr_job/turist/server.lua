mysql = exports.cr_mysql
local turistYeri = createColSphere (990.380859375, -1869.146484375, 12.648922920227, 3)
local meslekID = 19
function turistt(thePlayer)
    if (isElementWithinColShape(thePlayer, turistYeri)) then
	    if not (getElementData(thePlayer, "job") == meslekID) then
	        if not (getElementData(thePlayer, "job") == 0) then
		        outputChatBox("#cc0000[!]#FFFFFF Bu mesleğe girebilmek için önceki mesleğinden istifa etmen gerekli. #F55C5C(/meslektenayril)", thePlayer, 255, 0, 0, true)
		    else
	            if setElementData(thePlayer, "job", tonumber(meslekID)) then
                    mysql:query_free("UPDATE characters SET job = " ..  tonumber(meslekID)  .. " WHERE id = " .. mysql:escape_string(getElementData(thePlayer, "dbid")))
					exports.cr_jobs:fetchJobInfoForOnePlayer(thePlayer)
	                outputChatBox("#00CC00[!]#FFFFFF Meslek başarıyla alındı: #6699FFTurist Mesleği", thePlayer, 255, 194, 14, true)
	            end
		    end
		else
		outputChatBox("#cc0000[!]#FFFFFF Zaten Turist mesleğindesiniz.", thePlayer, 255, 0, 0, true)
	    end
	else	
	    outputChatBox("#cc0000[!]#FFFFFF Meslek bölgesinde değilsin.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("turistisbasi", turistt)