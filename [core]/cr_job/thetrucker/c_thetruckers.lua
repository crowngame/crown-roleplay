local theguy = createPed(16, 2571.61328125, -2429, 13.632630348206, 312.83770751953, true)
setElementData(theguy, "talk", 1)
setElementData(theguy, "name", "Charles Kennedy")
setElementFrozen(theguy, true)

function jobDisplayGUI()
	local crimecount = getElementData(getLocalPlayer(), "crimecount")

	if (crimecount > 0) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Charles Kennedy: Müracaatınızda işi almanıza bir engel bulunamamıştır.", 255, 255, 255, 3, {}, true)
		acceptGUI(getLocalPlayer())
		return
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Charles Kennedy: Maalesef ki siciliniz bu işi yapmaya müsait değil.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("trucker:displayJob", true)
addEventHandler("trucker:displayJob", getRootElement(), jobDisplayGUI)

function acceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Tır Şoförlüğü", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			triggerServerEvent("acceptJob", getLocalPlayer(), 10)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "[Ingilizce] Charles Kennedy: Kapıdaki tırlardan birini alarak işe başla, tırın dorsesini almayı unutma.", 255, 255, 255, 3, {}, true)
			setTimer(function() outputChatBox("[!]#FFFFFF Yandaki beyaz kamyonlardan birini alıp, /alkol basla yazarak işe başlayabilirsiniz!", 0, 0, 255, true) end, 500, 1)
			return	
		end
	)
	
	local line = guiCreateLabel(9, 32, 289, 19, "____________________________________________________", false, jobWindow)
	guiLabelSetHorizontalAlign(line, "center", false)
	guiLabelSetVerticalAlign(line, "center")
	local cancelBtn = guiCreateButton(159, 55, 139, 33, "İptal Et", false, jobWindow)
	addEventHandler("onClientGUIClick", cancelBtn, 
		function()
			destroyElement(jobWindow)
			return	
		end
	)
end

-- ROTA --
local truckMarker = 0
local truckOldMarker = {}
local truckRoutes = {
	{ 2289.033203125, -2368.7841796875, 13.032156944275, 2 },
	{ 2257.3720703125, -2400.7060546875, 13.030397415161, 2 },
	{ 2260.3037109375, -2419.1826171875, 13.177826881409, 2 },

	{ 2264.232421875, -2439.7099609375, 13.546875, 0, 0 }, -- /tiryukle
	
	{ 2313.66796875, -2351.927734375, 13.019018173218, false },
	{ 2315.3193359375, -2327.3701171875, 13.014348983765, false },
	{ 2291.4091796875, -2303.9091796875, 13.008926391602, false },
	{ 2293.2255859375, -2284.9951171875, 13.010649681091, false },
	{ 2371.3310546875, -2207.73046875, 13.006642341614, false },
	{ 2467.0390625, -2173.8896484375, 13.134081840515, false },
	{ 2653.173828125, -2172.80078125, 10.561710357666, false },
	{ 2763.576171875, -2165.2490234375, 10.56104850769, false },
	{ 2839.22265625, -2071.5283203125, 10.561392784119, false },
	{ 2840.3505859375, -1945.11328125, 10.568307876587, false },
	{ 2842.3642578125, -1861.1953125, 10.55156993866, false },
	{ 2860.4462890625, -1732.3486328125, 10.506821632385, false },
	{ 2895.3994140625, -1609.560546875, 10.506138801575, false },
	{ 2926.0556640625, -1493.3193359375, 10.507655143738, false },
	{ 2918.111328125, -1331.52734375, 10.505562782288, false },
	{ 2894.83203125, -1194.984375, 10.506759643555, false },
	{ 2890.7998046875, -1078.095703125, 10.505749702454, false },
	{ 2896.9580078125, -857.517578125, 10.506636619568, false },
	{ 2899.1669921875, -667.40234375, 10.46727848053, false },
	{ 2884.0234375, -538.044921875, 12.970618247986, false },
	{ 2809.4609375, -428.08203125, 21.037271499634, false },
	{ 2730.2529296875, -344.037109375, 25.940050125122, false },
	{ 2720.39453125, -279.2998046875, 27.440612792969, false },
	{ 2758.8515625, -163.28515625, 31.981685638428, false },
	{ 2775.4794921875, -58.4833984375, 35.664981842041, false },
	{ 2774.9228515625, 18.8046875, 33.441082000732, false },
	{ 2776.29296875, 120.2685546875, 22.677471160889, false },
	{ 2772.087890625, 214.7763671875, 19.901103973389, false },
	{ 2713.9228515625, 300.8544921875, 19.896276473999, false },
	{ 2642.232421875, 330.939453125, 23.041885375977, false },
	{ 2556.759765625, 314.6279296875, 28.363595962524, false },
	{ 2470.484375, 325.890625, 31.187128067017, false },
	{ 2406.0986328125, 331.791015625, 32.2946434021, false },
	{ 2342.6943359375, 328.8544921875, 32.295303344727, false },
	{ 2281.41796875, 343.2431640625, 32.334678649902, false },
	{ 2266.2021484375, 369.21875, 31.444608688354, false },
	{ 2283.8623046875, 398.091796875, 28.796419143677, false },
	{ 2336.01953125, 380.5830078125, 26.394737243652, false },
	{ 2341.73046875, 344.1044921875, 25.983392715454, false },
	{ 2341.2275390625, 293.0849609375, 25.968030929565, false },
	{ 2341.646484375, 228.7705078125, 25.96692276001, false },
	{ 2326.435546875, 216.3408203125, 25.826696395874, false },
	{ 2240.2509765625, 221.2177734375, 14.382840156555, false },
	{ 2162.9853515625, 239.4990234375, 14.204850196838, false },
	{ 2100.314453125, 250.9482421875, 19.333162307739, false },
	{ 2059.91015625, 260.4462890625, 24.828622817993, false },
	{ 2010.056640625, 339.8720703125, 27.896417617798, false },
	{ 1957.1357421875, 355.5, 21.920373916626, false },
	{ 1837.0859375, 375.333984375, 18.63433265686, false },
	{ 1758.6826171875, 389.2998046875, 19.112775802612, false },
	{ 1661.259765625, 384.7021484375, 19.420906066895, false },
	{ 1552.5439453125, 388.310546875, 19.513542175293, false },
	{ 1436.333984375, 419.978515625, 19.513563156128, false },
	{ 1318.1787109375, 478.2880859375, 19.518524169922, false },
	{ 1195.791015625, 540.935546875, 19.514194488525, false },
	{ 1123.259765625, 575.529296875, 19.522159576416, false },
	{ 1070.5634765625, 562.984375, 19.515083312988, false },
	{ 1024.888671875, 492.962890625, 19.518257141113, false },
	{ 970.005859375, 398.85546875, 19.516181945801, false },
	{ 830.044921875, 343.4228515625, 19.520282745361, false },
	{ 681.23828125, 316.478515625, 19.519428253174, false },
	{ 634.685546875, 312.4384765625, 19.556411743164, false },
	{ 601.1474609375, 306.21484375, 18.970489501953, false },
	{ 557.833984375, 276.4814453125, 16.485074996948, false },
	{ 479.3037109375, 210.1328125, 11.157567977905, false },
	{ 372.728515625, 121.4453125, 5.4257574081421, false },
	{ 294.9873046875, 68.015625, 2.0990986824036, false },
	{ 228.16015625, 52.6474609375, 1.9902441501617, false },
	{ 139.830078125, 81.28515625, 1.7089219093323, false },
	{ 40.57421875, 138.5859375, 1.7098755836487, false },
	{ -46.6435546875, 190.54296875, 1.7096428871155, false },
	{ -162.2373046875, 231.3857421875, 9.8659934997559, false },
	{ -223.736328125, 247.4443359375, 11.187070846558, false },
	{ -317.4150390625, 270.6484375, 2.3142137527466, false },
	{ -430.9775390625, 284.5654296875, 1.7145231962204, false },
	{ -573.1103515625, 286.13671875, 1.7096905708313, false },
	{ -702.51171875, 241.978515625, 1.8315165042877, false },
	{ -754.775390625, 204.0322265625, 2.0655035972595, false },
	{ -779.3134765625, 158.970703125, 5.4781475067139, false },
	{ -767.9609375, 116.4140625, 12.032982826233, false },
	{ -738.2666015625, 108.986328125, 14.508462905884, false },
	{ -688.0068359375, 100.6015625, 20.496162414551, false },
	{ -671.333984375, 57.0341796875, 30.733709335327, false },
	{ -698.12109375, 34.2939453125, 33.466701507568, false },
	{ -792.51171875, 21.068359375, 32.859485626221, false },
	{ -864.3994140625, -0.765625, 32.857578277588, false },
	{ -888.962890625, -30.5888671875, 33.095336914063, false },
	{ -783.7236328125, -28.3984375, 46.861751556396, false },
	{ -722.46484375, -0.296875, 58.011692047119, false },
	{ -687.6982421875, 13.5419921875, 67.017791748047, false },
	{ -674.1201171875, -0.0751953125, 71.044921875, false },
	{ -708.5498046875, -60.4443359375, 69.297676086426, false },
	{ -799.9931640625, -105.60546875, 63.413017272949, false },
	{ -893.1962890625, -133.0224609375, 56.766193389893, false },
	{ -941.046875, -191.927734375, 42.813678741455, false },
	{ -961.86328125, -297.0556640625, 36.056476593018, false },
	{ -979.828125, -388.7841796875, 35.964027404785, false },
	{ -1033.94140625, -446.048828125, 35.71017074585, false },
	{ -1118.7216796875, -512.7041015625, 30.642398834229, false },
	{ -1162.9033203125, -612.6630859375, 38.04207611084, false },
	{ -1188.703125, -702.7041015625, 53.41491317749, false },
	{ -1221.8974609375, -758.1298828125, 62.896064758301, false },
	{ -1306.6201171875, -807.8642578125, 72.175659179688, false },
	{ -1377.279296875, -813.4853515625, 80.511688232422, false },
	{ -1459.2412109375, -817.3994140625, 72.506675720215, false },
	{ -1519.22265625, -814.5283203125, 57.689220428467, false },
	{ -1573.595703125, -804.037109375, 50.463943481445, false },
	{ -1683.232421875, -759.3154296875, 40.415649414063, false },
	{ -1743.3466796875, -717.376953125, 30.073614120483, false },
	{ -1757.35546875, -649.5107421875, 19.210958480835, false },
	{ -1759.4267578125, -598.16796875, 15.911893844604, false },
	{ -1803.9482421875, -576.0908203125, 15.665230751038, false },
	{ -1816.529296875, -556.6943359375, 15.780542373657, false },
	{ -1822.7861328125, -491.9130859375, 14.592565536499, false },
	{ -1804.9208984375, -366.4541015625, 18.518835067749, false },
	{ -1796.990234375, -252.248046875, 18.427364349365, false },
	{ -1796.642578125, -130.6328125, 5.3584213256836, false },
	{ -1776.2734375, -118.7939453125, 3.5475242137909, false },
	{ -1757.4453125, -119.2314453125, 3.2048046588898, false },
	{ -1747.47265625, -86.4609375, 3.186190366745, false },
	{ -1747.3681640625, -17.8359375, 3.186291217804, false },
	{ -1747.0029296875, 19.494140625, 3.1858384609222, false },
	{ -1740.23046875, 28.60546875, 3.1856760978699, false },
	{ -1721.21484375, 35.76171875, 3.1846890449524, false },
	{ -1695.51171875, 40.23046875, 3.1872389316559, false },
	
	{ -1680.0087890625, 27.318359375, 3.1856863498688, true },
	
	{ -1708.716796875, 9.9306640625, 3.5546875, 1, 1 },
	
	{ -1734.365234375, 29.119140625, 3.1856656074524, false },
	{ -1747.34765625, 14.7705078125, 3.1861002445221, false },
	{ -1746.673828125, -46.5146484375, 3.1834661960602, false },
	{ -1746.24609375, -110.83984375, 3.1852078437805, false },
	{ -1785.5703125, -114.2978515625, 4.760561466217, false },
	{ -1801.2685546875, -184.849609375, 12.354019165039, false },
	{ -1801.23046875, -221.5498046875, 17.376857757568, false }, 
	{ -1801.41015625, -281.4619140625, 22.45506477356, false },
	{ -1805.6103515625, -340.8515625, 21.826108932495, false },
	{ -1822.529296875, -441.357421875, 14.593308448792, false },
	{ -1827.4873046875, -513.5439453125, 14.592507362366, false },
	{ -1821.1064453125, -561.9873046875, 15.886281967163, false },
	{ -1798.138671875, -584.42578125, 15.745045661926, false },
	{ -1775.4375, -584.3583984375, 15.96713924408, false },
	{ -1764.6904296875, -599.0419921875, 15.900303840637, false },
	{ -1764.5234375, -670.279296875, 21.87317276001, false },
	{ -1738.455078125, -729.97265625, 32.054634094238, false },
	{ -1676.6123046875, -769.1708984375, 41.330997467041, false },
	{ -1593.4580078125, -804.1767578125, 48.686447143555, false },
	{ -1518.7197265625, -822.0380859375, 57.969390869141, false },
	{ -1488.7470703125, -823.775390625, 64.891723632813, false },
	{ -1427.697265625, -820.7451171875, 78.789184570313, false },
	{ -1345.458984375, -817.6455078125, 76.683906555176, false },
	{ -1235.4716796875, -778.2119140625, 64.139083862305, false },
	{ -1205.6904296875, -746.7421875, 60.261089324951, false },
	{ -1166.7158203125, -645.7431640625, 42.233310699463, false },
	{ -1123.630859375, -530.9287109375, 29.99196434021, false },
	{ -1068.9912109375, -470.2177734375, 33.967170715332, false },
	{ -990.9853515625, -427.5263671875, 35.882263183594, false },
	{ -960.6396484375, -320.576171875, 35.845996856689, false },
	{ -947.462890625, -250.33203125, 37.118034362793, false },
	{ -913.876953125, -151.2626953125, 53.38890838623, false },
	{ -852.98828125, -129.1318359375, 60.28394317627, false },
	{ -762.5380859375, -98.283203125, 65.18310546875, false },
	{ -714.2099609375, -72.6904296875, 68.723190307617, false },
	{ -676.484375, -32.859375, 70.126388549805, false },
	{ -722.2109375, 7.0380859375, 58.779621124268, false },
	{ -793.2451171875, -24.990234375, 46.144989013672, false },
	{ -859.7587890625, -45.6962890625, 40.209854125977, false },
	{ -881.28515625, -45.9931640625, 35.724472045898, false },
	{ -875.666015625, -20.4091796875, 32.858669281006, false },
	{ -820.9033203125, 9.2646484375, 32.85782623291, false },
	{ -736.9755859375, 21.8818359375, 33.70719909668, false },
	{ -669.9208984375, 42.755859375, 32.447448730469, false },
	{ -702.7265625, 117.490234375, 16.725429534912, false },
	{ -757.3935546875, 117.1103515625, 13.117983818054, false },
	{ -694.8310546875, 238.8232421875, 1.796316742897, false },
	{ -630.40234375, 268.341796875, 1.7090606689453, false },
	{ -529.0458984375, 281.5546875, 1.7094373703003, false },
	{ -359.068359375, 270.056640625, 1.709691286087, false },
	{ -237.607421875, 245.318359375, 10.477159500122, false },
	{ -141.5751953125, 219.859375, 7.5165166854858, false },
	{ -36.3408203125, 178.3212890625, 1.7103236913681, false },
	{ 61.6240234375, 118.31640625, 1.7102012634277, false },
	{ 169.4111328125, 60.7744140625, 1.7093983888626, false },
	{ 236.1865234375, 46.2783203125, 2.0612630844116, false },
	{ 329.8046875, 82.52734375, 3.1546783447266, false },
	{ 419.4033203125, 151.228515625, 7.7741847038269, false },
	{ 496.5078125, 217.44921875, 12.200430870056, false },
	{ 580.5400390625, 285.423828125, 17.673736572266, false },
	{ 646.15234375, 306.958984375, 19.513525009155, false },
	{ 742.990234375, 318.515625, 19.514932632446, false },
	{ 891.455078125, 355.0634765625, 19.513593673706, false },
	{ 976.4091796875, 394.4375, 19.51411819458, false },
	{ 1018.48046875, 463.2099609375, 19.514226913452, false },
	{ 1045.65625, 518.2744140625, 19.514430999756, false },
	{ 1081.93359375, 563.6240234375, 19.520503997803, false },
	{ 1142.9208984375, 558.92578125, 19.513633728027, false },
	{ 1291.4951171875, 486.0791015625, 19.514261245728, false },
	{ 1454.6796875, 404.7216796875, 19.518146514893, false },
	{ 1580.6435546875, 379.8056640625, 19.51455116272, false },
	{ 1659.1357421875, 379.564453125, 19.409921646118, false },
	{ 1739.7978515625, 383.8408203125, 19.350610733032, false },
	{ 1843.970703125, 366.7626953125, 18.847450256348, false },
	{ 1954.474609375, 350.650390625, 21.71280670166, false },
	{ 1999.34765625, 343.115234375, 27.641914367676, false },
	{ 2049.4375, 263.908203125, 24.759733200073, false },
	{ 2168.404296875, 232.8232421875, 14.200298309326, false },
	{ 2276.6982421875, 211.9931640625, 20.107421875, false },
	{ 2330.0869140625, 211.0908203125, 25.934661865234, false },
	{ 2346.369140625, 224.8583984375, 25.967632293701, false },
	{ 2346.537109375, 271.712890625, 25.967641830444, false },
	{ 2357.625, 280.57421875, 25.960594177246, false },
	{ 2424.8984375, 295.4296875, 32.353092193604, false },
	{ 2504.9248046875, 291.572265625, 29.254356384277, false },
	{ 2585.3271484375, 295.5634765625, 31.930896759033, false },
	{ 2658.65234375, 301.7255859375, 39.214653015137, false },
	{ 2717.5703125, 263.0087890625, 35.601551055908, false },
	{ 2754.708984375, 168.78515625, 20.605672836304, false },
	{ 2755.236328125, 2.63671875, 32.13521194458, false },
	{ 2747.6982421875, -102.80078125, 34.411312103271, false },
	{ 2713.69921875, -215.4921875, 29.672466278076, false },
	{ 2690.30859375, -300.9775390625, 29.298257827759, false },
	{ 2701.1708984375, -345.498046875, 28.16189956665, false },
	{ 2806.2890625, -462.1337890625, 19.867792129517, false },
	{ 2865.794921875, -560.21484375, 12.239706993103, false },
	{ 2873.640625, -675.333984375, 10.467568397522, false },
	{ 2871.0234375, -862.8095703125, 10.507700920105, false },
	{ 2865.8486328125, -1043.845703125, 10.507053375244, false },
	{ 2867.5263671875, -1169.818359375, 10.510443687439, false },
	{ 2895.662109375, -1347.515625, 10.508234024048, false },
	{ 2902.091796875, -1481.474609375, 10.5064868927, false },
	{ 2858.6337890625, -1644.9599609375, 10.507228851318, false },
	{ 2833.97265625, -1741.4833984375, 10.506845474243, false },
	{ 2820.71875, -1878.267578125, 10.63565158844, false },
	{ 2820.626953125, -1960.8359375, 10.569664955139, false },
	{ 2821.2099609375, -2036.21875, 10.568000793457, false },
	{ 2806.0263671875, -2106.4150390625, 10.561282157898, false },
	{ 2728.7333984375, -2152.3466796875, 10.561521530151, false },
	{ 2525.8046875, -2152.9873046875, 13.002594947815, false },
	{ 2405.1943359375, -2164.4765625, 13.007020950317, false },
	{ 2303.4189453125, -2246.5634765625, 13.005805969238, false },
	{ 2280.70703125, -2269.689453125, 13.00731086731, false },
	{ 2289.8388671875, -2309.6982421875, 13.008796691895, false },
	{ 2311.8193359375, -2331.4716796875, 13.015029907227, false },
	{ 2308.400390625, -2349.5322265625, 13.025051116943, false },
	
	{ 2270.28125, -2381.0458984375, 13.178902626038, true, true },
-- Yükleme {true}
-- bitir {true, true}

}

function startJob(cmd, arg)
	if arg == "basla" then
		if not routeMarker then
			local veh = getPedOccupiedVehicle(getLocalPlayer())
			local vehModel = getElementModel(veh)
			local jobVehicle = 515
			
			if vehModel == jobVehicle then
				updateTruckRoutes()
				truckBlip = createBlip(2289.0332, -2368.7841, 13.0321, 0, 3, 255, 200, 0, 255)
				addEventHandler("onClientMarkerHit", resourceRoot, truckRoutesMarkerHit)
			end
		else
			--exports.cr_hud:sendBottomNotification(localPlayer, "Tır Şoförlüğü", "Zaten bir sefere başladın.")
		end
	end
end
addCommandHandler("tir", startJob)


function updateTruckRoutes()
	truckMarker = truckMarker + 1
	for i,v in ipairs(truckRoutes) do
		if i == truckMarker then
			if v[4] == 2 then
				theMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				setElementPosition(truckBlip, v[1], v[2], v[3])
				setBlipColor(truckBlip, 255, 0, 0, 255)
				table.insert(truckOldMarker, { theMarker, 2 })
			elseif v[4] == 1 and v[5] == 0 then
				loadingMarker1 = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				setElementPosition(truckBlip, v[1], v[2], v[3])
				setBlipColor(truckBlip, 255, 255, 0, 255)
				table.insert(truckOldMarker, { loadingMarker1, 1, 0 })
			elseif v[4] == 1 and v[5] == 1 then
				loadingMarker2 = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				setElementPosition(truckBlip, v[1], v[2], v[3])
				setBlipColor(truckBlip, 255, 255, 0, 255)
				table.insert(truckOldMarker, { loadingMarker2, 1, 1 })
			elseif not v[4] == true then
				routeMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				setElementPosition(truckBlip, v[1], v[2], v[3])
				setBlipColor(truckBlip, 255, 0, 0, 255)
				table.insert(truckOldMarker, { routeMarker, false })
			elseif v[4] == true and v[5] == true then 
				fMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				setElementPosition(truckBlip, v[1], v[2], v[3])
				setBlipColor(truckBlip, 255, 255, 0, 255)
				table.insert(truckOldMarker, { fMarker, true, true })	
			elseif v[4] == true then
				pMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				setElementPosition(truckBlip, v[1], v[2], v[3])
				setBlipColor(truckBlip, 255, 255, 0, 255)
				table.insert(truckOldMarker, { pMarker, true, false })			
			end
		end
	end
end

function truckRoutesMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 515 then
				for _, marker in ipairs(truckOldMarker) do
					if source == marker[1] and matchingDimension then
						if marker[2] == 2 then
							destroyElement(source)
							updateTruckRoutes()
						elseif marker[2] == false then
							if getVehicleTowedByVehicle(hitVehicle) then
								destroyElement(source)
								updateTruckRoutes()
							end
						elseif marker[2] == true and marker[3] == true then
							if getVehicleTowedByVehicle(hitVehicle) then
								local hitVehicle = getPedOccupiedVehicle(hitPlayer)
								truckMarker = 0
								--exports.cr_hud:sendBottomNotification(hitPlayer, "Tır Şoförlüğü", "Bu turdan 280$ kazandınız.")
								triggerServerEvent("trucker:pay", hitPlayer, hitPlayer)
								detachTrailerFromVehicle(hitVehicle)
								destroyElement(source)
								cancelJob()
							end
						elseif marker[2] == true and marker[3] == false then
							if getVehicleTowedByVehicle(hitVehicle) then
								local hitVehicle = getPedOccupiedVehicle(hitPlayer)
								setElementFrozen(hitPlayer, true)
								setElementFrozen(hitVehicle, true)
								toggleAllControls(false, true, false)
								--outputChatBox("[!]#FFFFFF Aracınızın dorsesi indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
								--exports.cr_hud:sendBottomNotification(hitPlayer, "Tır Şoförlüğü", "Aracınızın dorsesi indiriliyor, lütfen bekleyiniz.")
								setTimer(
									function(thePlayer, hitVehicle, hitMarker)
										destroyElement(hitMarker)
										local trailer = getVehicleTowedByVehicle(hitVehicle)
										detachTrailerFromVehicle(hitVehicle)
										triggerServerEvent("trucker:pay", hitPlayer, hitPlayer)
										--outputChatBox("[!]#FFFFFF Dorseniz indirilmiş ve paranız ödenmiştir ($240), geri dönebilirsiniz.", 0, 255, 0, true)
										--exports.cr_hud:sendBottomNotification(hitPlayer, "Tır Şoförlüğü", "Dorseniz indirilmiş ve paranız ödenmiştir (240$), geri dönebilirsiniz.")
										setElementFrozen(hitVehicle, false)
										setElementFrozen(thePlayer, false)
										toggleAllControls(true)
										updateTruckRoutes()
									end, 1000, 1, hitPlayer, hitVehicle, source
								)	
							end
						end
					end
				end
			end
		end
	end
end

function loadTrailer(cmd)
	for _, marker in ipairs(truckOldMarker) do
		if marker[2] == 1 and marker[3] == 0 then
			if isElementWithinMarker(getLocalPlayer(), marker[1]) then
				setElementPosition(getLocalPlayer(), 2274.69921875, -2395.02734375, 14.488780975342)
				setElementRotation(getLocalPlayer(), 0, 0, 312.48352050781)
				local playerVeh = getPedOccupiedVehicle(getLocalPlayer())
				setElementPosition(playerVeh, 2274.69921875, -2395.02734375, 14.488780975342)
				setElementRotation(playerVeh, 0, 0, 312.48352050781)
				local veh = triggerServerEvent("trucker:createTrailer", getLocalPlayer(), 1)
				destroyElement(marker[1])
				updateTruckRoutes()
			end	
		elseif marker[2] == 1 and marker[3] == 1 then
			if isElementWithinMarker(getLocalPlayer(), marker[1]) then
				setElementPosition(getLocalPlayer(), -1694.4443359375, 31.955078125, 4.5789170265198)
				setElementRotation(getLocalPlayer(), 0, 0, 47.428588867188)
				local playerVeh = getPedOccupiedVehicle(getLocalPlayer())
				setElementPosition(playerVeh, -1694.4443359375, 31.955078125, 4.5789170265198)
				setElementRotation(playerVeh, 0, 0, 47.428588867188)
				local veh = triggerServerEvent("trucker:createTrailer", getLocalPlayer(), 2)
				destroyElement(marker[1])
				updateTruckRoutes()
			end
		end
	end
end
addCommandHandler("tiryukle", loadTrailer)

function cancelJob()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	if pedVeh then
		if pedVehModel == 515 then
			exports.cr_global:fadeToBlack()
			for i,v in ipairs(truckOldMarker) do
				destroyElement(v[1])
			end
			truckOldMarker = {}
			truckMarker = 0
			triggerServerEvent("trucker:exitVeh", getLocalPlayer(), getLocalPlayer())
			removeEventHandler("onClientMarkerHit", resourceRoot, truckRoutesMarkerHit)
			removeEventHandler("onClientVehicleStartEnter", getRootElement(), tirAntiYabanci)
			setTimer(function() exports.cr_global:fadeFromBlack() end, 2000, 1)
		end
	end
end

function cantJacked(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleJob == 6 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			--exports.cr_hud:sendBottomNotification(thePlayer, "Tır Şoförlüğü", "Meslek aracına binemezsiniz.")
		elseif thePlayer == getLocalPlayer() and playerJob ~= 10 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			--exports.cr_hud:sendBottomNotification(thePlayer, "Tır Şoförlüğü", "Bu araca binmek için Tır Şoförlüğü mesleğinde olmanız gerekmektedir.")
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), cantJacked)

function cantExit(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			cancelJob()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), cantExit)