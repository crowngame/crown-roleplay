---SparroW MTA : https://sparrow-mta.blogspot.com/
---Facebook : https://www.facebook.com/sparrowgta/
---İnstagram : https://www.instagram.com/sparrowmta/
---Discord : https://discord.gg/DzgEcvy

addEventHandler('onClientResourceStart',resourceRoot,function () 
txd = engineLoadTXD ( "gringo.txd" ) 
engineImportTXD ( txd, 5628 ) 
col = engineLoadCOL ( "gringo.col" ) 
engineReplaceCOL ( col,  5628) 
dff = engineLoadDFF ( "gringo.dff", 0 ) 
engineReplaceModel ( dff, 5628 ) 
engineSetModelLODDistance(5628, 500)
end)



---SparroW MTA : https://sparrow-mta.blogspot.com/
---Facebook : https://www.facebook.com/sparrowgta/
---İnstagram : https://www.instagram.com/sparrowmta/
---Discord : https://discord.gg/DzgEcvy
