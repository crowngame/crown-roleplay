local socials

local function announceSocialMediaAccounts()
    if localPlayer:getData('loggedin') ~= 1 then
        return false
    end

    if not socials then
        socials = {
            { key = 'discord', header = 'Discord Sunucumuz', url = ('Toplulukla buluşmak için %s\nsunucumuza katılın!\nBuraya tıklayarak kopyalayın.'):format('discord.gg/crownrp'), value = 'discord.gg/crownrp' },
            -- { key = 'youtube', header = 'Youtube Kanalımız', url = ('Her gün Youtube kanalımıza video atıyoruz.\nTıkla ve kanal linkimizi kopyala!\nKanalımıza abone ol, bildirimlerini aç!'), value = 'https://www.youtube.com/@crownroleplay' },
        }
    end

    local social = socials[math.random(1, #socials)]
    addBox(social.key, { header = social.header, message = social.url }, 15000, 'bottom-center', social.value)
end
setTimer(announceSocialMediaAccounts, 1000 * 60 * 10, 0)

function announceSocialMediaWarn()
    if exports.cr_integration:isPlayerDeveloper(localPlayer) then
        announceSocialMediaAccounts()
        outputChatBox("[!]#FFFFFF Duyuru başarıyla geçildi.", 0, 255, 0, true)
    end
end
addCommandHandler("duyuruyap", announceSocialMediaWarn, false, false)