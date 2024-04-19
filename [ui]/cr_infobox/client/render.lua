screenSize = Vector2(guiGetScreenSize())

fonts = {
	regular = exports.cr_fonts:getFont("UbuntuRegular", 9),
	bold = exports.cr_fonts:getFont("UbuntuBold", 11),
	icon = exports.cr_fonts:getFont("FontAwesome", 20),
}

Infobox = {}
Infobox.maxBoxes = 5
Infobox.items = {}
Infobox.types = {
    Error = 'error',
    Warning = 'warning',
    Info = 'info',
    Success = 'success',
    Announcement = 'announcement',
    Discord = 'discord',
    Instagram = 'instagram',
    Youtube = 'youtube'
}
Infobox.padding = 10
Infobox.lastClick = 0
Infobox.placement = {
    TopLeft = 'top-left',
    TopCenter = 'top-center',
    TopRight = 'top-right',
    CenterLeft = 'center-left',
    Center = 'center',
    CenterRight = 'center-right',
    BottomLeft = 'bottom-left',
    BottomCenter = 'bottom-center',
    BottomRight = 'bottom-right'
}
Infobox.linesSize = {
    x = 136,
    y = 104 / 2
}
Infobox.linesTexture = 'public/lines.png'

Infobox.colorScheme = {
    [Infobox.types.Error] = {
        __themeColor = 'red',
        __icon = '',
        __sound = 'public/sounds/error.mp3',
        __header = 'Hata',
        __colors = {
            background = 900,
            hover = 800,
            border = 700,
            text = 100,
            icon = 200
        }
    },
    [Infobox.types.Warning] = {
        __themeColor = 'yellow',
        __icon = '',
        __sound = 'public/sounds/warning.mp3',
        __header = 'Uyarı',
        __colors = {
            background = 900,
            hover = 800,
            border = 700,
            text = 100,
            icon = 200
        }
    },
    [Infobox.types.Info] = {
        __themeColor = 'blue',
        __icon = '',
        __sound = 'public/sounds/info.mp3',
        __header = 'Bilgi',
        __colors = {
            background = 900,
            hover = 800,
            border = 700,
            text = 100,
            icon = 200
        }
    },
    [Infobox.types.Success] = {
        __themeColor = 'green',
        __icon = '',
        __sound = 'public/sounds/success.mp3',
        __header = 'Başarılı',
        __colors = {
            background = 900,
            hover = 800,
            border = 700,
            text = 100,
            icon = 200
        }
    },
	[Infobox.types.Announcement] = {
        __themeColor = 'whitep',
        __icon = '',
        __sound = 'public/sounds/info.mp3',
        __header = 'Duyuru',
        __colors = {
            background = 900,
            hover = 800,
            border = 700,
            text = 100,
            icon = 200
        }
    },
    [Infobox.types.Discord] = {
        __themeColor = 'discord',
        __icon = '',
        __sound = 'public/sounds/discord.mp3',
        __iconFont = 'FontAwesomeBrand',
        __colors = {
            background = 900,
            hover = 800,
            border = 700,
            text = 100,
            icon = 200
        }
    },
    [Infobox.types.Instagram] = {
        __themeColor = 'instagram',
        __icon = '',
        __sound = 'public/sounds/discord.mp3',
        __iconFont = 'FontAwesomeBrand',
        __colors = {
            background = 900,
            hover = 800,
            border = 700,
            text = 100,
            icon = 200
        }
    },
    [Infobox.types.Youtube] = {
        __themeColor = 'youtube',
        __icon = '',
        __sound = 'public/sounds/discord.mp3',
        __iconFont = 'FontAwesomeBrand',
        __colors = {
            background = 900,
            hover = 800,
            border = 700,
            text = 100,
            icon = 200
        }
    }
}

function Infobox.getPositionWithPlacement(placement, width, height)
    if placement == Infobox.placement.TopLeft then
        return Infobox.padding, Infobox.padding
    elseif placement == Infobox.placement.TopCenter then
        return screenSize.x / 2 - width / 2, Infobox.padding
    elseif placement == Infobox.placement.TopRight then
        return screenSize.x - width - Infobox.padding, Infobox.padding
    elseif placement == Infobox.placement.CenterLeft then
        return Infobox.padding, screenSize.y / 2 - height / 2
    elseif placement == Infobox.placement.Center then
        return screenSize.x / 2 - width / 2, screenSize.y / 2 - height / 2
    elseif placement == Infobox.placement.CenterRight then
        return screenSize.x - width - Infobox.padding, screenSize.y / 2 - height / 2
    elseif placement == Infobox.placement.BottomLeft then
        return Infobox.padding, screenSize.y - height - Infobox.padding
    elseif placement == Infobox.placement.BottomCenter then
        return screenSize.x / 2 - width / 2, screenSize.y - height - Infobox.padding
    elseif placement == Infobox.placement.BottomRight then
        return screenSize.x - width - Infobox.padding, screenSize.y - height - Infobox.padding
    end
end

function Infobox.overrideTheme()
    local theme = {}
	theme.DISCORD = {
        [900] = '#7289da',
        [800] = '#677bc4',
        [700] = '#5b6eae',
        [600] = '#4e608f',
        [500] = '#424b66',
        [400] = '#363e4d',
        [300] = '#F2F2F2',
        [200] = '#F2F2F2',
        [100] = '#F2F2F2',
        [50] = '#060607'
    }
    theme.INSTAGRAM = {
        [900] = '#E1306C',
        [800] = '#D91E5D',
        [700] = '#C81F66',
        [600] = '#B22E5B',
        [500] = '#A22C5B',
        [400] = '#8F2A5B',
        [300] = '#F2F2F2',
        [200] = '#F2F2F2',
        [100] = '#F2F2F2',
        [50] = '#45225B'
    }
    theme.YOUTUBE = {
        [900] = '#fE0000',
        [800] = '#FF3434',
        [700] = '#C81F66',
        [600] = '#B22E5B',
        [500] = '#A22C5B',
        [400] = '#8F2A5B',
        [300] = '#F2F2F2',
        [200] = '#F2F2F2',
        [100] = '#F2F2F2',
        [50] = '#45225B'
    }
	theme.BLUE = {
		[25] = "#f0fdff",
		[50] = "#edfbfe",
		[100] = "#d3f4fa",
		[200] = "#ace8f5",
		[300] = "#53cbea",
		[400] = "#32b9de",
		[500] = "#169cc4",
		[600] = "#157ca5",
		[700] = "#186486",
		[800] = "#1c536e",
		[900] = "#1c455d"
	}
	theme.GREEN = {
		[25] = "#f0fdf4",
		[50] = "#ebfef5",
		[100] = "#cffce6",
		[200] = "#a3f7d1",
		[300] = "#53eab0",
		[400] = "#2dda9d",
		[500] = "#08c186",
		[600] = "#009d6e",
		[700] = "#007d5b",
		[800] = "#026349",
		[900] = "#03513e"
	}
	theme.ORANGE = {
		[25] = "#fff4ed",
		[50] = "#fd8ef",
		[100] = "#fbefd9",
		[200] = "#f6dbb2",
		[300] = "#f0c381",
		[400] = "#eaa353",
		[500] = "#e4862b",
		[600] = "#d56c21",
		[700] = "#b1541d",
		[800] = "#8d431f",
		[900] = "#72391c"
	}
	theme.RED = {
		[25] = "#fff1f1",
		[50] = "#fef2f2",
		[100] = "#fde3e3",
		[200] = "#fccccc",
		[300] = "#f9a8a8",
		[400] = "#f37676",
		[500] = "#ea5353",
		[600] = "#d62c2c",
		[700] = "#b32222",
		[800] = "#951f1f",
		[900] = "#7c2020"
	}
	theme.GRAY = {
		[900] = "#121214",
		[800] = "#202024",
		[700] = "#29292e",
		[600] = "#323238",
		[500] = "#3d3d43",
		[400] = "#666666",
		[300] = "#a8a8b3",
		[200] = "#c4c4cc",
		[100] = "#e1e1e6",
		[50] = "#f0f0f5",
		[25] = "#f5f5fa"
	}
	theme.WHITE = {
		[900] = "#FFFFFF",
		[800] = "#efefef",
		[700] = "#dcdcdc",
		[600] = "#bdbdbd",
		[500] = "#989898",
		[400] = "#7c7c7c",
		[300] = "#656565",
		[200] = "#121214",
		[100] = "#464646",
		[50] = "#3d3d3d",
		[25] = "#333333"
	}
	theme.LIGHT = {
		[25] = "#1f1f1f",
		[50] = "#262626",
		[100] = "#434343",
		[200] = "#595959",
		[300] = "#8c8c8c",
		[400] = "#bfbfbf",
		[500] = "#d9d9d9",
		[600] = "#f5f5f5",
		[700] = "#fafafa",
		[800] = "#FFFFFF",
		[900] = "#FFFFFF"
	}
	theme.PURPLE = {
		[25] = "#F7F5FF",
		[50] = "#F3ECFF",
		[100] = "#E9D8FD",
		[200] = "#D6BCFA",
		[300] = "#B794F4",
		[400] = "#9F7AEA",
		[500] = "#805AD5",
		[600] = "#6B46C1",
		[700] = "#553C9A",
		[800] = "#44337A",
		[900] = "#322659"
	}
	theme.YELLOW = {
		[25] = "#fffdf2",
		[50] = "#fcfcea",
		[100] = "#f9f8c8",
		[200] = "#f5ee93",
		[300] = "#efdf55",
		[400] = "#e7ca1f",
		[500] = "#d8b51a",
		[600] = "#ba8d14",
		[700] = "#956713",
		[800] = "#7c5217",
		[900] = "#69431a"
	}
	theme.WHITEP = {
		[25] = "#FFFFFF",
		[50] = "#efefef",
		[100] = "#dcdcdc",
		[200] = "#bdbdbd",
		[300] = "#989898",
		[400] = "#7c7c7c",
		[500] = "#656565",
		[600] = "#525252",
		[700] = "#464646",
		[800] = "#3d3d3d",
		[900] = "#333333"
	}
	theme.BACKGROUND = {
		BODY = theme.GRAY[900],
		SURFACE = "#09090D",
		LEVEL1 = theme.GRAY[800],
		LEVEL2 = theme.GRAY[700],
		LEVEL3 = theme.GRAY[600],
		TOOLTIP = theme.GRAY[600],
	}

    return theme
end

function Infobox.generateColorScheme(boxType)
    local theme = Infobox.overrideTheme()

    local colorScheme = Infobox.colorScheme[boxType]
    local themeColor = theme[colorScheme.__themeColor:upper()]
    local colors = colorScheme.__colors

    local color = {}
    color.background = themeColor[colors.background]
    color.hover = themeColor[colors.hover]
    color.border = themeColor[colors.border]
    color.text = themeColor[colors.text]
    color.icon = themeColor[colors.icon]

    return color
end

function Infobox.render()
    if #Infobox.items == 0 then
        return
    end

    for i = 1, #Infobox.items do
        local box = Infobox.items[i]
        if not box then
            return
        end

        local color = box.color
        local x, y = box.position.x, box.position.y
        local width, height = box.size.x, box.size.y

        if i > 1 and #Infobox.items > 1 then
            local previousBox = Infobox.items[i - 1]
            local previousX, previousY = previousBox.position.x, previousBox.position.y
            local previousWidth, previousHeight = previousBox.size.x, previousBox.size.y

            if box.placement == previousBox.placement then
                if box.placement == Infobox.placement.TopLeft then
                    y = previousY + previousHeight + Infobox.padding
                elseif box.placement == Infobox.placement.TopCenter then
                    y = previousY + previousHeight + Infobox.padding
                elseif box.placement == Infobox.placement.TopRight then
                    y = previousY + previousHeight + Infobox.padding
                elseif box.placement == Infobox.placement.CenterLeft then
                    x = previousX + previousWidth + Infobox.padding
                elseif box.placement == Infobox.placement.Center then
                    x = previousX + previousWidth + Infobox.padding
                elseif box.placement == Infobox.placement.CenterRight then
                    y = previousY + previousHeight + Infobox.padding
                elseif box.placement == Infobox.placement.BottomLeft then
                    y = previousY - previousHeight - Infobox.padding
                elseif box.placement == Infobox.placement.BottomCenter then
                    y = previousY - (Infobox.padding / 2) - height
                elseif box.placement == Infobox.placement.BottomRight then
                    y = previousY - previousHeight - Infobox.padding
                end

                box.position.x = x
                box.position.y = y
            end
        else
            x, y = Infobox.getPositionWithPlacement(box.placement, box.size.x, box.size.y)
            box.position.x = x
            box.position.y = y
        end

        local hover = exports.cr_ui:isInBox(x, y, width, height)

        if hover and box.clipboardText then
            if getKeyState('mouse1') and Infobox.lastClick + 200 <= getTickCount() then
                Infobox.lastClick = getTickCount()
                setClipboard(box.clipboardText)
                exports.cr_infobox:addBox('success', 'Başarıyla kopyaladınız, tarayıcınıza girip doğrudan CTRL+V yaparak yapıştırın.')
            end
        end

        dxDrawRectangle(x, y, width, height, exports.cr_ui:rgba(color[hover and 'hover' or 'background'], 1), true)
        dxDrawImage(x, y, 136, height, Infobox.linesTexture, 0, 0, 0, tocolor(255, 255, 255, 255), true)

        dxDrawRectangle(x, y, width, 1, exports.cr_ui:rgba(color.border, 1), true)
        dxDrawRectangle(x, y + height - 1, width, 1, exports.cr_ui:rgba(color.border, 1), true)

        dxDrawRectangle(x, y, 1, height, exports.cr_ui:rgba(color.border, 1), true)
        dxDrawRectangle(x + width - 1, y, 1, height, exports.cr_ui:rgba(color.border, 1), true)

        dxDrawText(
                box.icon,
                x + Infobox.padding + 2,
                y + Infobox.padding,
                0,
                0,
                exports.cr_ui:rgba(color.icon, 1),
                1,
                box.font.icon,
                'left',
                'top',
                false,
                false,
                true
       )

        local textX = x + Infobox.padding * 5.5
        local textY = y + Infobox.padding

        dxDrawText(
                box.header,
                textX,
                textY,
                0,
                0,
                exports.cr_ui:rgba(color.text, 1),
                1,
                box.font.header,
                'left',
                'top',
                false,
                false,
                true
       )

        textY = textY + Infobox.padding * 2

        dxDrawText(
                box.message,
                textX,
                textY,
                0,
                0,
                exports.cr_ui:rgba(color.text, 1),
                1,
                box.font.message,
                'left',
                'top',
                false,
                false,
                true
       )
    end
end
addEventHandler("onClientRender", root, Infobox.render, true, 'low-5')

function addBox(boxType, message, duration, placement, clipboardText)
    if #Infobox.items >= Infobox.maxBoxes then
        table.remove(Infobox.items, 1)
    end

    local header = Infobox.colorScheme[boxType].__header or 'Bildirim'

    if type(message) == 'table' then
        header = message.header
        message = message.message
    end

    if not duration or not tonumber(duration) then
        duration = 5000
    end

    playSound(Infobox.colorScheme[boxType].__sound)

    local iconFont = Infobox.colorScheme[boxType].__iconFont
    if iconFont then
        iconFont = exports.cr_fonts:getFont(iconFont, 20)
    end

    local messageLines = split(message, '\n')
    local messageLinesCount = #messageLines
    local messageHeight = dxGetFontHeight(1, fonts.regular) * messageLinesCount

    local box = {}
    box.type = boxType
    box.header = header
    box.message = message
    box.duration = duration
    box.clipboardText = clipboardText
    box.placement = placement or Infobox.placement.CenterRight
    box.font = {
        header = fonts.bold,
        message = fonts.regular,
        icon = iconFont or fonts.icon
    }

    local headerWidth = dxGetTextWidth(header, 1, box.font.header) + Infobox.padding * 8
    local messageWidth = dxGetTextWidth(message, 1, box.font.message) + Infobox.padding * 8

    if headerWidth > messageWidth then
        messageWidth = headerWidth
    end

    box.icon = Infobox.colorScheme[boxType].__icon
    box.size = {
        x = messageWidth,
        y = messageHeight + Infobox.padding * 4
    }

    if box.size.x < Infobox.linesSize.x then
        box.size.x = Infobox.linesSize.x
    end

    box.color = Infobox.generateColorScheme(boxType)

    local x, y = Infobox.getPositionWithPlacement(box.placement, box.size.x, box.size.y)
    box.position = {
        x = x,
        y = y
    }

    table.insert(Infobox.items, box)
    setTimer(function()
        table.remove(Infobox.items, 1)
    end, duration, 1)
end
addEvent('infobox.addBox', true)
addEventHandler('infobox.addBox', root, addBox)

function isRenderInfobox()
	if #Infobox.items > 0 then
		return true
	end
	return false
end