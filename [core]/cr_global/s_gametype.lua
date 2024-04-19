local index = 1
local gameTypes = {
	"█ En Yüksek FPS!",
	"█ FPS & LAG Sıkıntısı Yok!",
    "█ Hard Roleplay",
    "█ Çok Hızlı MB İner!",
	"█ Crown Roleplay v" .. getScriptVersion(),
    "█ Canlı Gece Hayatı!",
    "█ Polisler ve Mafyalar"
}

setTimer(function()
	if index >= #gameTypes then
        index = 1
	else
		index = index + 1
    end
	setGameType(gameTypes[index])
end, 1000 * 5, 0)