function getJobTitleFromID(jobID)
	if (tonumber(jobID)==1) then
		return "Kargo Şoförü"
	elseif (tonumber(jobID)==2) then
		return "Taksi Şoförü"
	elseif  (tonumber(jobID)==3) then
		return "Otobüs Şoförü"
	elseif (tonumber(jobID)==4) then
		return "Şehir Temizlikçisi"
	elseif (tonumber(jobID)==5) then
		return "Tamirci"
	elseif (tonumber(jobID)==6) then
		return "Çilingir"
	elseif (tonumber(jobID)==7) then
		return "Long Haul Truck Driver"
	elseif (tonumber(jobID)==8) then
		return "Sigara Kaçakçısı"
	elseif (tonumber(jobID)==9) then
		return "Alkol Kaçakçısı"
	elseif (tonumber(jobID)==10) then
		return "Tır Şoförü"
	elseif (tonumber(jobID)==11) then
		return "Kamyon Şoförü"
	elseif (tonumber(jobID)==12) then
		return "-----------------"
	elseif (tonumber(jobID)==14) then
		return "Beton Taşımacılığı"
	elseif (tonumber(jobID)==15) then
		return "Deniz Taşımacılığı"
    elseif (tonumber(jobID)==16) then
		return "Çöp Şöförü"
	elseif (tonumber(jobID)==17) then
		return "Terzi"
	elseif (tonumber(jobID)==18) then
		return "Oduncu"
	elseif (tonumber(jobID)==18) then
		return "Kasap"
	else
		return "Sivil"
	end
end