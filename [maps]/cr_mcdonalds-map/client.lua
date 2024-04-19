
-----------------------------------------------------------
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
-----------------------------------------------------------

function replaceModel()
txd_lombada = engineLoadTXD ( "data/lombada.txd" )
engineImportTXD ( txd_lombada, 17534 )
col_lombada = engineLoadCOL ( "data/lombada.col" )
engineReplaceCOL ( col_lombada, 17534 )
dff_lombada = engineLoadDFF ( "data/lombada.dff", 17534 )
engineReplaceModel ( dff_lombada, 17534 )

end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), replaceModel)

-----------------------------------------------------------
-- Sitemiz : https://sparrow-mta.blogspot.com/

-- Facebook : https://facebook.com/sparrowgta/
-- İnstagram : https://instagram.com/sparrowmta/
-- YouTube : https://www.youtube.com/@TurkishSparroW/

-- Discord : https://discord.gg/DzgEcvy
-----------------------------------------------------------