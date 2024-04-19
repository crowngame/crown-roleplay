
---SparroW MTA : https://sparrow-mta.blogspot.com/
---Facebook : https://www.facebook.com/sparrowgta/
---İnstagram : https://www.instagram.com/sparrowmta/
---Discord : https://discord.gg/DzgEcvy




shader = dxCreateShader("shader.fx")
gorsel = dxCreateTexture("las69str2.bmp") -- Objenin .txd dosyasındaki değiştirmek istediğiniz kaplama .bmp adı
function apply()
engineApplyShaderToWorldTexture(shader, "las69str2") -- Objenin .txd dosyasındaki değiştirmek istediğiniz kaplama .bmp adı
dxSetShaderValue(shader, "gTexture", gorsel)
end
addEventHandler("onClientResourceStart", root, apply)