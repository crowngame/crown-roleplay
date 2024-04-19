local fonts = {}

local fontsSource = {
	["Bankgothic"] = "files/Bankgothic.ttf",
	
	["Bebas"] = "files/Bebas.ttf",
	["BebasNeueBold"] = "files/BebasNeueBold.otf",
	["BebasNeueLight"] = "files/BebasNeueLight.otf",
	["BebasNeueRegular"] = "files/BebasNeueRegular.otf",
	
	["FontAwesome"] = "files/FontAwesome.ttf",
	["FontAwesomeBrand"] = "files/FontAwesomeBrand.ttf",
	["FontAwesomeRegular"] = "files/FontAwesomeRegular.otf",
	
	["in-bold"] = "files/in-bold.ttf",
	["in-elight"] = "files/in-elight.ttf",
    ["in-elightitalic"] = "files/in-elightitalic.ttf",
	["in-italic"] = "files/in-italic.ttf",
    ["in-light"] = "files/in-light.ttf",
    ["in-lightitalic"] = "files/in-lightitalic.ttf",
	["in-regular"] = "files/in-regular.ttf",
    ["in-thin"] = "files/in-thin.ttf",
    ["in-thinitalic"] = "files/in-thinitalic.ttf",
	["in-medium"] = "files/in-medium.ttf",
	
	["license"] = "files/license.ttf",
	
	["Pricedown"] = "files/Pricedown.ttf",
	
	["Roboto"] = "files/Roboto-Regular.ttf",
	["RobotoB"] = "files/Roboto-Bold.ttf",
	["RobotoL"] = "files/Roboto-Light.ttf",
	["Roboto-Black"] = "files/Roboto-Black.ttf",
	["Roboto-Bold"] = "files/Roboto-Bold.ttf",
	["Roboto-Light"] = "files/Roboto-Light.ttf",
	["Roboto-Light-Italic"] = "files/Roboto-Light-Italic.ttf",
	["Roboto-Medium"] = "files/Roboto-Medium.ttf",
	["Roboto-Regular"] = "files/Roboto-Regular.ttf",
	
	["sf-bold"] = "files/sf-bold.ttf",
	["sf-bolditalic"] = "files/sf-bolditalic.ttf",
	["sf-heavy"] = "files/sf-heavy.ttf",
	["sf-heavyitalic"] = "files/sf-heavyitalic.ttf",
	["sf-italic"] = "files/sf-italic.ttf",
	["sf-light"] = "files/sf-light.ttf",
	["sf-lightitalic"] = "files/sf-lightitalic.ttf",
	["sf-medium"] = "files/sf-medium.ttf",
	["sf-mediumitalic"] = "files/sf-mediumitalic.ttf",
	["sf-regular"] = "files/sf-regular.ttf",
	["sf-semibold"] = "files/sf-semibold.ttf",
	["sf-semibolditalic"] = "files/sf-semibolditalic.ttf",
	
	["SignPainter"] = "files/SignPainter.ttf",
	["SweetSixteen"] = "files/SweetSixteen.ttf",
	
	["UbuntuBold"] = "files/UbuntuBold.ttf",
	["UbuntuLight"] = "files/UbuntuLight.ttf",
	["UbuntuRegular"] = "files/UbuntuRegular.ttf",
}

function getFont(font, size, bold, quality)
    if not font then return end
    if not size then return end
	
    local fontE = false
    local _font = font
    
    if bold then
        font = font .. "-Bold"
    end
    
    if quality then
        font = font .. "-" .. quality 
    end
    
    if font and size then
	    local subText = font .. size
	    local value = fonts[subText]
	    if value then
		    fontE = value
		end
	end
    
    if not fontE then
        local v = fontsSource[_font]
        fontE = DxFont(v, size, bold, quality)
        local subText = font .. size
        fonts[subText] = fontE
    end
    
	return fontE
end