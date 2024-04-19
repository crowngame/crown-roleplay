addEvent("skinshop.buy", true)
addEventHandler("skinshop.buy", root, function(price, model)
	if client ~= source then return end
    if source and tonumber(price) and tonumber(model) then
        if exports.cr_global:hasMoney(source, price) then
            if exports.cr_global:giveItem(source, 16, model) then
				exports.cr_global:takeMoney(source, price)
                source:outputChat("[!]#FFFFFF Kıyafetin üzerine tam oturdu! Görevli ürünü poşetledi ve sana verdi.", source, 0, 255, 0, true)
				triggerClientEvent(source, "playSuccessfulSound", source)
            else
                source:outputChat("[!]#FFFFFF Görünüşe göre bu kıyafet için sepetinde yer yok.", source, 255, 0, 0, true)
				playSoundFrontEnd(source, 4)
                exports.cr_global:giveMoney(source, price)
            end
        else
            source:outputChat("[!]#FFFFFF Üzgünüz, bu kıyafeti satın almak için gerekli miktarı karşılamıyorsun.", source, 255, 0, 0, true)
			playSoundFrontEnd(source, 4)
        end
    else
        source:outputChat("[!]#FFFFFF Bir sorun oluştu.", source, 255, 0, 0, true)
		playSoundFrontEnd(source, 4)
    end
end)