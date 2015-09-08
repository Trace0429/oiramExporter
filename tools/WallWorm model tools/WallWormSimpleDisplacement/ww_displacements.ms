/*
Wall Worm Displacement Tools
Copyright (c) 2011 by Shawn Olson http://www.shawnolson.net

WallWorm.com



*/


fn ww_wwdt_AlignPivotTo Obj Trgt =
(
	/*Function from
	magicm
	http://forums.cgsociety.org/archive/index.php/t-636495.html
	*/
-- Get matrix from object
if classOf Trgt != matrix3 then Trgt = Trgt.transform

-- Store child transforms
local ChldTms = in coordSys Trgt ( for Chld in Obj.children collect Chld.transform )

-- Current offset transform matrix
local TmScale = scaleMatrix Obj.objectOffsetScale
local TmRot = Obj.objectOffsetRot as matrix3
local TmPos = transMatrix Obj.objectOffsetPos
local TmOffset = TmScale * TmRot * TmPos

-- New offset transform matrix
TmOffset *= obj.transform * inverse Trgt

-- Apply matrix
Obj.transform = Trgt

-- Restore offsets
Obj.objectOffsetPos = TmOffset.translation
Obj.objectOffsetRot = TmOffset.rotation
Obj.objectOffsetScale = TmOffset.scale

-- Restore child transforms
for i = 1 to Obj.children.count do Obj.children[i].transform = ChldTms[i] * inverse Trgt * Obj.transform
)


include "$scripts/WallWorm.com/common/config.ms"
include "$scripts/WallWorm.com/common/ww_common_funcs.ms"

global ww_wwdt_version = 1.0
global ww_wwdt_last_disp_position = [0,0,0]
global ww_wwdt_last_placed_brush = undefined
global ww_wwdt_control_mesh = undefined
global ww_wwdt_map = #()

--"dev/dev_measuregeneric01"
--global ww_wwdt_defaultMat = MultiMaterial numsubs:6 name:"nature/blendcliffgrass001a"
	ww_wwdt_grassBmp = openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/dirtfloor002a.tga"
	ww_wwdt_stoneBmp =  openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/cliffface002a.tga"
	
	ww_wwdt_grasstex = bitmaptexture bitmap:ww_wwdt_grassBmp filename:ww_wwdt_grassBmp.filename
	ww_wwdt_stonetex = bitmaptexture bitmap:ww_wwdt_stoneBmp filename:ww_wwdt_stoneBmp.filename
	
	ww_d9_shadermat = DirectX_9_Shader effectFilename:"$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/fx/blend_dxsas.fx" name:"nature/blendcliffgrass001a" 
	ww_d9_shadermat.seteffectbitmap 1 ww_wwdt_grassBmp
	ww_d9_shadermat.seteffectbitmap 2 ww_wwdt_stoneBmp	
	
	
	global ww_wwdt_defaultMat = ww_d9_shadermat

	--global ww_wwdt_paint 
	global ww_wwdt_uvw 
	--global ww_wwdt_poly 
	
	
-- 	if ww_wwdt_paint == undefined do (
-- 		ww_wwdt_paint = VertexPaint name:"WW Vertex Paint Modifier" mapChannel:-2
-- 	)
	if ww_wwdt_uvw == undefined do (
		ww_wwdt_uvw = UVWMap name:"WW Displacement UVW" utile:1 maptype:4 vtile:1 wtile:1 channel:0 mapChannel:1
	)
-- 	if ww_wwdt_poly == undefined do (
-- 		ww_wwdt_poly = Edit_Poly name:"WW Displacement Poly Mod"
-- 	)
-- 	
if ww_wwdt_ui != undefined do (
	destroyDialog ww_wwdt_ui
)
	

function  ww_wwdt_createControlMesh sel = (
	
	--hide sel
	
	if sel == undefined OR sel.count == 0 do (
		return false
		)
	
	
	
		--Trgt = Point pos:[0,0,0]


		
		

		

	
	
	disablesceneredraw()
	
	
	if ww_wwdt_control_mesh != undefined AND isDeleted ww_wwdt_control_mesh ==false do (
		delete ww_wwdt_control_mesh
	)			
	
	theController = undefined
	
	--sels = copy sel
	
	
	local maparray = #()
	
	for orig in sel do (
		
		convertToPoly orig
		local theOrigVerts = polyop.getNumVerts orig
		local theverts = #{1..theOrigVerts}
		for h in (polyop.getHiddenVerts orig) do (
			theverts[h] = false
		)
		
		
		append maparray #(orig,theverts,#(#(),#()))

		
		obj = copy orig
		local toDelete = polyOp.getHiddenFaces orig		
		--polyop.deleteFaces obj toDelete
		--hide orig
		--convertToPoly obj
		
		if theController == undefined then (
			
			theController = obj
			theController.name = "WW Displacement Controller"
			
			
			) else (
			
			polyop.attach theController obj
			
			)
		
		
		
		
		)
	
		
		local toDelete = polyOp.getHiddenFaces theController		
		polyop.deleteFaces theController toDelete
		

		local vs = polyop.getNumVerts theController
		
		theController.weldThreshold = 1
		polyop.weldVertsByThreshold theController #{1..vs}

	
		
		local vs = polyop.getNumVerts theController
		
		-- go through each vertice in new mesh
		for i=1 to vs do (
			theVert = polyop.getVert theController i 
			--find all matching vertices in the original meshes by matching vertice positions
			
			for maps in maparray do (
				--print maps[1].name
				
				for ov in maps[2] do (
					--where findItem (polyop.getHiddenVerts maps[1]) ov == false 
					
					if polyop.getVert maps[1] ov  == theVert do (
						
						append maps[3][1] i --record the control mesh vertice
						append maps[3][2] ov --record the original vertice

					)
					
				)
			)
		)
		
		
		
		for obj in sel do (
			setTransformLockFlags obj #all
			hide obj
			
			
			
		)
		/*
		for maps in maparray do (
			
			maps[1] = maps[1].name
			)
		*/
		
		
		ww_wwdt_control_mesh = theController
		setTransformLockFlags theController #all
		select theController
			
			
		--setUserPropBuffer theController ("ww_wwdt_controller_map = "+maparray as string)
			
			
		--setUserProp theController "ww_wwdt_controller_map" maparray
		--delete Trgt
		ww_wwdt_map = maparray
		enablesceneredraw()
		redrawviews()
			
	
	)

	
	
	function ww_wwdt_commit_edit ctr = (
		
		--if ctr != undefined AND isDeleted ctr == false do (
			--thear = getUserProp ctr "ww_wwdt_controller_map"
			if ctr ==undefined OR isDeleted ctr do (
				if ww_wwdt_map != undefined AND ww_wwdt_map.count > 0 do (
					for ar in ww_wwdt_map do (
						unhide ar[1]
					)
				)
				return false
				
				)
				
			convertToPoly ctr
		
			if ww_wwdt_map != undefined AND ww_wwdt_map.count > 0 do (
				--execute ("theArray = "+thear)
				
				--print ww_wwdt_map
				--Trgt = Point pos:[0,0,0]
				
				
				
				for ar in ww_wwdt_map do (
					unhide ar[1]
				    setTransformLockFlags ar[1] #none
					
					for i=1 to ar[3][2].count do (
						
						local controlMeshVert = polyop.getVert ctr ar[3][1][i]  
						local originalMeshVert = polyop.getVert ar[1] ar[3][2][i]  
						--
						
						--format "CONTROL MESH (%): % %    --- ORIGINAL MESH (%): % %\n\n" ctr.name ar[3][1][i] controlMeshVert ar[1].name ar[3][2][i] originalMeshVert
						
		
						dist = distance originalMeshVert controlMeshVert
						if dist == 0.0 then (
							--unitVector = [0,0,1]
							--print "no move"
						) else (
							--format "Move obj % vert # % FROM % to %\n" ar[1].name i originalMeshVert controlMeshVert
							polyop.setVert ar[1] ar[3][2][i] controlMeshVert 
							
							--unitVector = normalize (controlMeshVert-originalMeshVert
						)
			
						ctr.SetSelection #Vertex #{(ar[3][1][i])}
						local theVertColor =ctr.getVertexColor #Alpha

						polyop.setVertColor ar[1] -2 ar[3][2][i] theVertColor
						
						

					)
					
					--addModifier ar[1] ww_wwdt_uvw
				)
				delete ctr

			)
		
		--)
		
	)


function changeMode disp t= (
	
	if ww_wwdt_control_mesh != undefined AND isDeleted ww_wwdt_control_mesh == false then (
		
			if t == "texture" do (

				addModifier ww_wwdt_control_mesh (VertexPaint name:"WW Blend Paint" mapChannel:-2)
			) 
	) else (
		convertto disp editable_poly
		--addModifier disp ww_wwdt_uvw
	
		if t == "texture" then (
				--addModifier disp ww_wwdt_poly
					--addModifier disp ww_wwdt_paint
			) else (
					--addModifier disp ww_wwdt_paint
					--addModifier disp ww_wwdt_poly
			)
		)
	)



function ww_wwdt_editMode = (

	
	theDisp = #()				
	
	

	for disp in objects do (
			local bName = getUserProp disp "ww_wwdt_displacement_brush"
			if bName != undefined do (


				append theDisp disp
				--changeMode disp "edit"
			)
		)
	
	    --select theDisp
		
		ww_wwdt_createControlMesh theDisp
		

		
	)

function ww_wwdt_paintMode = (
	disablesceneredraw()
	theDisp = #()
	for disp in objects do (
			local bName = getUserProp disp "ww_wwdt_displacement_brush"
			if bName != undefined do (
				append theDisp disp

				changeMode disp "texture"
				


			)
		)
	
		select theDisp
		enablesceneredraw()
		redrawviews()
	)

	
	function ww_wwdt_getEdgeVerts power = (
		edgeVertices = #{}
					case of (
						
						(power==2): edgeVertices = #{1..6, 10..11, 15..16, 20..31, 35..36, 40..41, 45..51, 55, 59, 63, 67, 71, 75, 79, 83, 87, 91, 95}
						(power==3): edgeVertices = #{1..10, 18..19, 27..28, 36..37, 45..46, 54..55, 63..64, 72..91, 99..100, 108..109, 117..118, 126..127, 135..136, 144..145, 153..163, 171, 179, 187, 195, 203, 211, 219, 227, 235, 243, 251, 259, 267, 275, 283, 291, 299, 307, 315, 323, 331, 339, 347, 355, 363, 371, 379}
						(power==4): edgeVertices = #{1..18, 34..35, 51..52, 68..69, 85..86, 102..103, 119..120, 136..137, 153..154, 170..171, 187..188, 204..205, 221..222, 238..239, 255..256, 272..307, 323..324, 340..341, 357..358, 374..375, 391..392, 408..409, 425..426, 442..443, 459..460, 476..477, 493..494, 510..511, 527..528, 544..545, 561..579, 595, 611, 627, 643, 659, 675, 691, 707, 723, 739, 755, 771, 787, 803, 819, 835, 851, 867, 883, 899, 915, 931, 947, 963, 979, 995, 1011, 1027, 1043, 1059, 1075, 1091, 1107, 1123, 1139, 1155, 1171, 1187, 1203, 1219, 1235, 1251, 1267, 1283, 1299, 1315, 1331, 1347, 1363, 1379, 1395, 1411, 1427, 1443, 1459, 1475, 1491, 1507, 1523}
					)
			return edgeVertices
		)
	
function ww_wwdt_sewSelected sel = (
	disableSceneRedraw()
	posStore = #()	
	tempPosStore = #()	
	brushList = #()	
	for disp in sel do (
		convertto disp editable_poly
		local brushName = getUserProp disp "ww_wwdt_displacement_brush"
		if brushName != undefined do (
			local b = getNodeByName  brushName
			
			if b !=undefined AND isDeleted b == false do (
				
				appendIfUnique brushList #(b,disp) 
				power = getUserProp b "ww_wwdt_power"
				
				edgeVertices = ww_wwdt_getEdgeVerts power
					
				faceStore = #{}		
						
				addDisp = true
				hiddenFaces = polyop.getHiddenFaces disp 

				for start = 1 to b.GetNumFaces()  do (
					if findItem hiddenFaces start == 0 do (
						appendIfUnique faceStore start
					 )
				
				)
		
				for f in faceStore do (
					verts = polyop.getFaceVerts b f
						for vert in verts do (
							if findItem edgeVertices vert > 0 do (
								tpos = polyop.getVert b vert
								if findItem tempPosStore tpos > 0 then (
									append posStore tpos
								) else (
									appendIfUnique tempPosStore tpos
								)
							
							)
						)
				)
			)
		)
	)
	

	ind = 1
	objStore = #()	
	posMap = #()
	for v in posStore do (
		objStore[ind] = #()
		posMap[ind] = v
		for br in brushList do (
			vertexAt = false
			for bv = 1 to br[1].GetNumVertices() while vertexAt==false do (
				if (polyop.getVert br[1] bv) == v do (
					appendIfUnique objStore[ind] #(br[2],bv)
					vertexAt = true
				)
			)
		)
		ind+=1
	)
	
	for ar in objStore do (
		if ar.count > 1 do (
			avPos = [0,0,0]
			for s in ar do (	
				currentPos = polyop.getVert s[1] s[2]
				avPos = avPos + currentPos
			)
			avPos = avPos / ar.count
			for s in ar do (
				currentPos = polyop.getVert s[1] s[2]
				vec = (avPos-currentPos)	
				if dist != 0.0 do (
					polyop.moveVert s[1] s[2] (vec) node:s[1]
				) 	
			)
		)
	)
	enableSceneRedraw()
	--messagebox "Selected Displacements Sewn"
)
	
	
	
	

function ww_wwdt_getMinVertexOnSide side power = (
	
	vertexArrays = #()
	
	vertexArrays[2] = #()

	vertexArrays[2][1] = #(21,1,25, (quat 1 0 0 0) , (quat 0 -1 0 0),1,16,#(21,22,23,24,25,16,17,18,19,20,11,12,13,14,15,6,7,8,9,10,1,2,3,4,5)) -- bottom
	vertexArrays[2][2] = #(26,50,30, (quat 1 0 0 0), (quat 0 -1 0 0),17,32,#(26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50)) --top
	vertexArrays[2][3] = #(21,46,1,(quat 0 1 0 0),(quat 0 0 -1 0),81,96,#(21,16,11,6,1,63,64,65,66,51,79,80,81,82,67,95,96,97,98,83,46,41,36,31,26)) -- w
	vertexArrays[2][4] = #(5,30,25,(quat 0 1 0 0),(quat 0 0 -1 0),49,64,#(5,10,15,20,25,55,56,57,58,59,71,72,73,74,75,87,88,89,90,91,30,35,40,45,50)) -- e
	vertexArrays[2][5] = #(25,50,21,(quat 1 0 0 0),(quat 0 0 -1 0),65,80,#(25,24,23,22,21,59,60,61,62,63,75,76,77,78,79,91,92,93,94,95,50,49,48,47,46)) -- n
	vertexArrays[2][6] = #(1,26,5,(quat 1 0 0 0),(quat 0 0 -1 0),33,48,#(1,2,3,4,5,51,52,53,54,55,67,68,69,70,71,83,84,85,86,87,26,27,28,29,30)) -- s

	vertexArrays[3] = #()

	vertexArrays[3][1] = #(73,1,81, (quat 1 0 0 0) , (quat 0 -1 0 0),1,64,#(73,74,75,76,77,78,79,80,81,64,65,66,67,68,69,70,71,72,55,56,57,58,59,60,61,62,63,46,47,48,49,50,51,52,53,54,37,38,39,40,41,42,43,44,45,28,29,30,31,32,33,34,35,36,19,20,21,22,23,24,25,26,27,10,11,12,13,14,15,16,17,18,1,2,3,4,5,6,7,8,9)) -- (1) Bottom
	vertexArrays[3][2] = #(82,162,90, (quat 1 0 0 0), (quat 0 -1 0 0),65,128,#(82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162)) -- Top
	vertexArrays[3][3] = #(73,154,1,(quat 0 1 0 0),(quat 0 0 -1 0),321,384,#(73,64,55,46,37,28,19,10,1,187,188,189,190,191,192,193,194,163,219,220,221,222,223,224,225,226,195,251,252,253,254,255,256,257,258,227,283,284,285,286,287,288,289,290,259,315,316,317,318,319,320,321,322,291,347,348,349,350,351,352,353,354,323,379,380,381,382,383,384,385,386,355,154,145,136,127,118,109,100,91,82)) -- W
	vertexArrays[3][4] = #(9,90,81,(quat 0 1 0 0),(quat 0 0 -1 0),193,256,#(9,18,27,36,45,54,63,72,81,171,172,173,174,175,176,177,178,179,203,204,205,206,207,208,209,210,211,235,236,237,238,239,240,241,242,243,267,268,269,270,271,272,273,274,275,299,300,301,302,303,304,305,306,307,331,332,333,334,335,336,337,338,339,363,364,365,366,367,368,369,370,371,90,99,108,117,126,135,144,153,162)) -- E
	vertexArrays[3][5] = #(81,162,73,(quat 1 0 0 0),(quat 0 0 -1 0),257,320,#(81,80,79,78,77,76,75,74,73,179,180,181,182,183,184,185,186,187,211,212,213,214,215,216,217,218,219,243,244,245,246,247,248,249,250,251,275,276,277,278,279,280,281,282,283,307,308,309,310,311,312,313,314,315,339,340,341,342,343,344,345,346,347,371,372,373,374,375,376,377,378,379,162,161,160,159,158,157,156,155,154)) -- N
	vertexArrays[3][6] = #(1,82,9,(quat 1 0 0 0),(quat 0 0 -1 0),129,192,#(1,2,3,4,5,6,7,8,9,163,164,165,166,167,168,169,170,171,195,196,197,198,199,200,201,202,203,227,228,229,230,231,232,233,234,235,259,260,261,262,263,264,265,266,267,291,292,293,294,295,296,297,298,299,323,324,325,326,327,328,329,330,331,355,356,357,358,359,360,361,362,363,82,83,84,85,86,87,88,89,90)) -- S
	
	
	
	vertexArrays[4] = #()

	vertexArrays[4][1] = #(273,1,289,(quat 1 0 0 0) , (quat 0 -1 0 0),1,256,#(273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17)) -- (1) Bottom
	vertexArrays[4][2] = #(290,578,306,(quat 1 0 0 0), (quat 0 -1 0 0),257,512,#(290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,576,577,578)) -- (2) Top
	vertexArrays[4][3] = #(273,562,1,(quat 0 1 0 0),(quat 0 0 -1 0),1281,1536,#(273,256,239,222,205,188,171,154,137,120,103,86,69,52,35,18,1,627,628,629,630,631,632,633,634,635,636,637,638,639,640,641,642,579,691,692,693,694,695,696,697,698,699,700,701,702,703,704,705,706,643,755,756,757,758,759,760,761,762,763,764,765,766,767,768,769,770,707,819,820,821,822,823,824,825,826,827,828,829,830,831,832,833,834,771,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,835,947,948,949,950,951,952,953,954,955,956,957,958,959,960,961,962,899,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,963, 1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,1088,1089,1090,1027,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151,1152,1153,1154,1091,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215,1216,1217,1218,1155,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279,1280,1281,1282,1219,1331,1332,1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343,1344,1345,1346,1283,1395,1396,1397,1398,1399,1400,1401,1402,1403,1404,1405,1406,1407,1408,1409,1410,1347,1459,1460,1461,1462,1463,1464,1465,1466,1467,1468,1469,1470,1471,1472,1473,1474,1411,1523,1524,1525,1526,1527,1528,1529,1530,1531,1532,1533,1534,1535,1536,1537,1538,1475,562,545,528,511,494,477,460,443,426,409,392,375,358,341,324,307,290)) -- (6)  W
	vertexArrays[4][4] = #(17,306,289,(quat 0 1 0 0),(quat 0 0 -1 0),769,1024,#(17,34,51,68,85,102,119,136,153,170,187,204,221,238,255,272,289,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1235,1236,1237,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1363,1364,1365,1366,1367,1368,1369,1370,1371,1372,1373,1374,1375,1376,1377,1378,1379,1427,1428,1429,1430,1431,1432,1433,1434,1435,1436,1437,1438,1439,1440,1441,1442,1443,1491,1492,1493,1494,1495,1496,1497,1498,1499,1500,1501,1502,1503,1504,1505,1506,1507,306,323,340,357,374,391,408,425,442,459,476,493,510,527,544,561,578)) -- (4) E
	vertexArrays[4][5] = #(289,578,273,(quat 1 0 0 0),(quat 0 0 -1 0),1025,1280,#(289,288,287,286,285,284,283,282,281,280,279,278,277,276,275,274,273,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1187,1188,1189,1190,1191,1192,1193,1194,1195,1196,1197,1198,1199,1200,1201,1202,1203,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1315,1316,1317,1318,1319,1320,1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1379,1380,1381,1382,1383,1384,1385,1386,1387,1388,1389,1390,1391,1392,1393,1394,1395,1443,1444,1445,1446,1447,1448,1449,1450,1451,1452,1453,1454,1455,1456,1457,1458,1459,1507,1508,1509,1510,1511,1512,1513,1514,1515,1516,1517,1518,1519,1520,1521,1522,1523,578,577,576,575,574,573,572,571,570,569,568,567,566,565,564,563,562)) -- (5) N
	vertexArrays[4][6] = #(1,290,17,(quat 1 0 0 0),(quat 0 0 -1 0),513,768,#(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1219,1220,1221,1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,1293,1294,1295,1296,1297,1298,1299,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361,1362,1363,1411,1412,1413,1414,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1475,1476,1477,1478,1479,1480,1481,1482,1483,1484,1485,1486,1487,1488,1489,1490,1491,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306)) -- (3) S
	
	out = vertexArrays[power][side]
	
	return out
	)	
	
	
	function ww_wwdt_offsetByEdgeVertice power side vertice = (
		

		
		
		)
	
function ww_wwdt_vmfpowertosegs p = (
	
	case of (

		(p==2): s = 4

		(p==3): s=8

		(p==4): s=16

		default: s=16

	)

	return s
	)

function ww_wwdt_getBrushValues m = (
	brushVertices = #()

				case of (
				(m==1): brushVertices = #(3,4,2, (quat 1 0 0 0) , (quat 0 -1 0 0) )
				(m==2):  brushVertices = #(5,6,8, (quat 1 0 0 0), (quat 0 -1 0 0) )
				(m==3): brushVertices = #(3,1,5,(quat 0 1 0 0),(quat 0 0 -1 0))
				(m==4):  brushVertices = #(8,6,2,(quat 0 1 0 0),(quat 0 0 -1 0))
				(m==5): brushVertices = #(4,3,7,(quat 1 0 0 0),(quat 0 0 -1 0))	
				(m==6): brushVertices = #(6,5,1,(quat 1 0 0 0),(quat 0 0 -1 0))									
				default:  brushVertices = #(3,4,2,(quat 1 0 0 0),(quat 0 -1 0 0))
			)
			return brushVertices
	)

function  ww_wwdt_makeDisplacement p l w h t pos mat = (
	segs = ww_wwdt_vmfpowertosegs p
	
	if pos == undefined do (
		
		pos=ww_wwdt_last_disp_position
		)
	local brsh = Box length:l width:w height:h isSelected:off lengthsegs:segs widthsegs:segs heightsegs:segs pos:pos	
	brsh.name =(uniqueName  "WW_Displacement_Brush_")
	modi = Smooth smoothingBits:1	
	addModifier brsh modi	
	addModifier brsh ww_wwdt_uvw	
	convertto brsh editable_poly
	ww_wwdt_last_placed_brush = brsh	
		
	--ww_wwdt_last_disp_position = ww_wwdt_last_placed_brush.pos	
	
	--#("Ground","Hill","Open Hill","Ring","Corner","Cube")


		
	if t == "Ground" then (

		
		Trgt = Point pos:brsh.position

		Trgt.pos.z += h
		
		
		ww_wwdt_AlignPivotTo brsh Trgt
		
		delete Trgt
		
		
		)	
	
	disp = copy brsh
	
	channelInfo.addChannel disp
 	--channelInfo.update()
		
	convertto disp editable_poly
	
	disp.name =(uniqueName  ("WW_Displacement_"+t+"_"))
	setUserProp disp "ww_wwdt_displacement_brush" brsh.name
	setUserProp brsh "ww_wwdt_displacement" "true"
	setUserProp brsh "ww_wwdt_displacement_target" disp.name
	setUserProp brsh "ww_wwdt_power" (p as string)
	brsh.xray=on
	brsh.renderable = off
	setTransformLockFlags brsh #all
	
	
	
	hide brsh
	
	
	paramWire.connect2way disp.pos.controller[#X_Position] brsh.pos.controller[#X_Position] "X_Position" "X_Position"
	paramWire.connect2way disp.pos.controller[#Y_Position] brsh.pos.controller[#Y_Position] "Y_Position" "Y_Position"
	paramWire.connect2way disp.pos.controller[#Z_Position] brsh.pos.controller[#Z_Position] "Z_Position" "Z_Position"
	paramWire.connect2way disp.rotation.controller[#X_Rotation] brsh.rotation.controller[#X_Rotation] "X_Rotation" "X_Rotation"
	paramWire.connect2way disp.rotation.controller[#Y_Rotation] brsh.rotation.controller[#Y_Rotation] "Y_Rotation" "Y_Rotation"
	paramWire.connect2way disp.rotation.controller[#Z_Rotation] brsh.rotation.controller[#Z_Rotation] "Z_Rotation" "Z_Rotation"
	paramWire.connect2way disp.transform.controller[#Scale] brsh.transform.controller[#Scale] "Scale" "Scale"
	select disp
				local hidefaces = #{}

				case of (
				(t == "Ground"): (
					startNum = (segs * segs)
					startNum2 = (startNum * 2)+1
					hidefaces = #{1..startNum,startNum2..disp.numfaces}
					brsh.pos.z = (brsh.pos.z - h)	
					)
				(t=="Hill"): (
						startNum = 1
						endNum = (segs * segs) 
						hidefaces = #{startNum..endNum}
					)
				(t=="Ring"): (
						startNum = 1
						endNum = (segs * segs)* 2
						hidefaces = #{startNum..endNum}
					)
					
				(t=="Bulge"): (
						startNum = 1
						endNum = (segs * segs) 
					    startNum2 = (startNum * 2)+1
					    endNum2 = (segs * segs)* 3
						hidefaces = #{startNum..endNum,startNum2..endNum2}
					)
				(t=="Corner"): (
						startNum = 1
						endNum = (segs * segs) 
					    startNum2 = (startNum * 3)+1
					    endNum2 = (segs * segs)* 4
						hidefaces = #{startNum..endNum,startNum2..endNum2}
					)
				(t=="Open Hill"): (
						startNuma = 1
						endNuma= (segs * segs) 
						startNum = ( (segs * segs)  * 2)+1
						endNum = (segs * segs) * 3
					    startNum2 = ((segs * segs) * 4)+1
					    endNum2 = (segs * segs)* 5
						hidefaces = #{startNuma..endNuma,startNum..endNum,startNum2..endNum2}
					)
				)
	
	if hidefaces.count > 0 do (
	
		subobjectLevel = 4
		setCommandPanelTaskMode #modify
		disp.SetSelection #Face hidefaces
		disp.Hide #Face
		subobjectLevel = 0	
	)
	
	
   if mat == undefined do (
		mat = ww_wwdt_defaultMat
	)

	disp.mat = mat	
	
	--addModifier disp ww_wwdt_uvw
	--addModifier disp ww_wwdt_paint
	--addModifier disp ww_wwdt_poly
	--convertToPoly disp
	
	when disp deleted id:#deleteDisp obj  do (
		
		local br = getUserProp obj "ww_wwdt_displacement_brush"
		if br != undefined do (
			
			local theBrsh = getNodeByName br
			if theBrsh != undefined do (
			
				delete theBrsh
			)
		)
		
		
	)
	

)	

function ww_wwdt_makeVMFDisplacement b dispo brush side = (
	local vmf = ""
			disp = copy dispo
		try(
	
		if brush==undefined do (
		
		brush = 1
		)
	
	
	
	if side==undefined do (
		
		side = 1
		)
	
	if disp.mat == undefined do (
		m = Standard name:"dev/dev_devmeasuregeneric01"

		disp.mat = m

		)
	
	oldSel = selection
	

	
		
		
		
	if b !=undefined AND isDeleted b == false do (
		convertto disp editable_poly
		select disp
		setCommandPanelTaskMode #modify
		subObjectLevel = 1
		local power = getUserProp b "ww_wwdt_power"
		case of (
			(power==2): rows = 5
			(power==3): rows=9
			(power==4): rows=17
			default: rows=17
		)
		vmf = "solid\n"
		local l = "{\n"
		append vmf l
		l = "\"id\" \""+(brush as string)+"\"\n"
			
		append vmf l
		edgeVertices = ww_wwdt_getEdgeVerts power		
	for m = 1 to 6 do (

		brushVertices = ww_wwdt_getMinVertexOnSide m power
		sBottomLeft = polyop.getVert b brushVertices[1]
		sTopLeft = polyop.getVert b brushVertices[2]
		sTopRight = polyop.getVert b brushVertices[3]
		ro = 0

		utileAmount = 1
		vtileAmount = 1	
		
		l = "side\n"
		append vmf l
		l = "{\n"
		append vmf l
		l = "\"id\" \""+(side as string)+"\"\n"
		append vmf l
		l = "\"plane\" \"("+(sBottomLeft[1] as string)+" "+(sBottomLeft[2] as string)+" "+(sBottomLeft[3] as string)+") ("+(sTopLeft[1] as string)+" "+(sTopLeft[2] as string)+" "+(sTopLeft[3] as string)+") ("+(sTopRight[1] as string)+" "+(sTopRight[2] as string)+" "+(sTopRight[3] as string)+")\"\n"
		append vmf l
		l = "\"material\" \""+(disp.mat.name)+"\"\n"
		append vmf l
		l="\"uaxis\" \"["+(brushVertices[4].x as string)+" "+(brushVertices[4].y as string)+" "+(brushVertices[4].z as string)+" "+(brushVertices[4].w as string)+"] "+(utileAmount as string)+"\"\n"
		append vmf l
		l="\"vaxis\" \"["+(brushVertices[5].x as string)+" "+(brushVertices[5].y as string)+" "+(brushVertices[5].z as string)+" "+(brushVertices[5].w as string)+"] "+(utileAmount as string)+"\"\n"
		append vmf l
		l = "\"rotation\" \""+(ro as string)+"\"\n"
		append vmf l
		l = "\"lightmapscale\" \"16\"\n"
		append vmf l
		l = "\"smoothing_groups\" \"0\"\n"
		append vmf l
		local norms = ""
		local dists = ""
		local offsets = ""
		local offset_normals = ""
		local alphas = ""
		local triangle_tags = ""		
		
		addDisp = true
		hiddenFaces = polyop.getHiddenFaces disp 

		for start = brushVertices[6] to brushVertices[7] while addDisp == true do (
		
		
			 if findItem hiddenFaces start > 0 do (
				 addDisp = false
				 )
		)
		
		
	if addDisp == true do (			
		
		
		
		
		l = "dispinfo\n"
		append vmf l
		l = "{\n"
		append vmf l
		l = "\"power\" \""+(power as string)+"\"\n"
		append vmf l
		l = "\"startposition\" \"["+(sBottomLeft[1] as string)+" "+(sBottomLeft[2] as string)+" "+(sBottomLeft[3] as string)+"]\"\n"
		append vmf l
		l = "\"flags\" \"0\"\n"
		append vmf l
		l = "\"elevation\" \"0\"\n"
		append vmf l
		l = "\"subdiv\" \"0\"\n"
		append vmf l
		
		
	
		local row = 0
		local column = 0
			
			
		local norms = "\nnormals\n{\n\"row0\" \""
		local dists = "\ndistances\n{\n\"row0\" \""
		local offsets = "\noffsets\n{\n\"row0\" \""
		local offset_normals = "\noffset_normals\n{\n\"row0\" \""
		local alphas = "\nalphas\n{\n\"row0\" \""
		local triangle_tags = "\ntriangle_tags\n{\n\"row0\" \""
	
	
	

	
		verticeStore =brushVertices[8]


		for i in brushVertices[8] do (


			vs = polyop.getVert b i 
			vd = polyop.getVert disp i 

			dist = distance vs vd
			if dist == 0.0 then (
				unitVector = [0,0,1]
			) else (
				unitVector = normalize (vd-vs)
			)
			
		n = (unitVector[1] as string)+" "+ (unitVector[2] as string)+" "+(unitVector[3] as string)+" "
		append norms n

		dis = (dist as string)+" "
		append dists dis
			
		
		
		offset = "0 0 0 "

		append offsets offset
		
	
		offsetn = "0 0 1 "
		append offset_normals offsetn	
			
		disp.SetSelection #Vertex #{i}
		local theVertColor =disp.getVertexColor #Alpha

		a = (theVertColor.value as string)+" "
		append alphas a
			
			column+=1
			if (column == rows) do (
				
				column = 0
				row+=1
				
				n="\"\n"
				append norms n
				append dists n
				append offsets n
				append alphas n
				append offset_normals n
				if row < rows do (
					
					
				n="\"row"+(row as string)+"\" \""
				append norms n
				append dists n
				append offsets n
				append alphas n
				append offset_normals n
					)
				
				
				
				)
			
			)

			
			
				n="\n}\n"
				append norms n
				append dists n
				append offsets n
				append alphas n
				append offset_normals n
			
				append vmf norms
				append vmf dists
				append vmf offsets
				append vmf offset_normals
				append vmf alphas			
			
				--END DISPINFO
				en = "\n}\n"
				append vmf en	
		
		)
	

		--END SIDE
		en = "\n}\n"
		append vmf en	
	

						side+=1	
		)
						

			)
		
		
	

		delete disp	
			

		en = "	editor\n{\n\"color\" \"0 180 133\"\n\"visgroupshown\" \"1\"\n\"visgroupautoshown\" \"1\"\n}\n}\n"
		append vmf en
		
		--print vmf
		try (
		subObjectLevel = 0
		select oldSel			
		) catch(
			print "ahhh"
			)
		)
		catch (
			
			delete disp	
			
			vmf = "//Error in Side/Displacement output"
			print vmf
			throw()
			)
	return vmf
)
	
function ww_wwdt_outputVMF = (
	
	clearSelection()
	disablesceneredraw()
	
	local sfn = maxFileName
	
	if sfn != undefined AND sfn != "" then (
	local mapFileName =substring  sfn 1 (sfn.count - 4)
	) else (
		
		local mapFileName = "MyMap"
		)

	include "$scripts/WallWorm.com/common/config.ms"

	
	
	filename = getSaveFileName  caption:"Save Your VMF:" filename:(""+wwdt_mapsrc+"/"+(mapFileName as string)+".vmf") types:"VMF(*.vmf)"

--if the path exists, will result in something like:
if filename != undefined do(
	local sv = openFile filename mode:"w+"

)
	if filename == undefined OR sv == undefined then (
		
		enablesceneredraw()
		messagebox "The VMF was not saved."
		
		
		) else (
	try(

		local brush = 2
		local side = 7
		
		local gotsky = false
		
		skyname = "sky_day01_01"
		for s in objects while gotsky == false do (
			
			skyn = getUserProp s "wwsw_skyname"
			
			if skyn != undefined do (
				
				skyname=(skyn + "_hdr")
				gotsky = true
				
				)
			
			)
		
			

	
			
			
		format "\n\n//########################\n//Start Displacement Output\n\n//Generated by the Wall Worm Displacement Tool\n\n//http://www.wallworm.com\n\n"  to:sv

		
		n="versioninfo\n"
		format n to:sv
n="{\n"
		format n to:sv
	n="\"editorversion\" \"400\"\n"
		format n to:sv
	n="\"editorbuild\" \"5004\"\n"
		format n to:sv
	n="\"mapversion\" \"4\"\n"
		format n to:sv
	n="\"formatversion\" \"100\"\n"
		format n to:sv
	n="\"prefab\" \"0\"\n"
		format n to:sv
n="}\n"
		format n to:sv
n="visgroups\n"
		format n to:sv
n="{\n"
		format n to:sv
n="}\n"
		format n to:sv
n="viewsettings\n"
		format n to:sv
n="{\n"
		format n to:sv
	n="\"bSnapToGrid\" \"1\"\n"
		format n to:sv
	n="\"bShowGrid\" \"1\"\n"
		format n to:sv
	n="\"bShowLogicalGrid\" \"0\"\n"
		format n to:sv
	n="\"nGridSpacing\" \"64\"\n"
		format n to:sv
	n="\"bShow3DGrid\" \"0\"\n"
		format n to:sv
n="}\n"
		format n to:sv
n="world\n"
		format n to:sv
n="{\n"
		format n to:sv
	n="\"id\" \"1\"\n"
		format n to:sv
	n="\"mapversion\" \"4\"\n"
		format n to:sv
	n="\"classname\" \"worldspawn\"\n"
		format n to:sv
	n="\"detailmaterial\" \"detail/detailsprites\"\n"
		format n to:sv
	n="\"detailvbsp\" \"detail.vbsp\"\n"
		format n to:sv
	n="\"maxpropscreenwidth\" \"-1\"\n"
		format n to:sv
	n="\"skyname\" \""+skyname+"\"\n"
		format n to:sv

		
		
		
		for disp in objects do (
			local dispName = getUserProp disp "ww_wwdt_displacement_brush"
			if dispName != undefined do (
				s = getNodeByName  dispName
				if s !=undefined AND isDeleted s == false do (
					--convertto disp editable_poly
					n = ww_wwdt_makeVMFDisplacement s disp brush side
					format n to:sv
			
					brush+=1
					side+=6
					)
			)
		)
		
		
		
		n="\n}"
		format n to:sv
				
		
				for wwmt in shapes do (
			
					local mdl = undefined
					
					local targetlist = getUserProp wwmt "wwmt_targetslist"
					
					
					if targetlist!=undefined do (
						local targetsArray = filterString targetlist ","
					

						mdl  = getNodeByName targetsArray[1]
						if isDeleted mdl then (
							mdl=undefined
							) else(
							
								local modelPath = getUserProp wwmt "wwmt_modelPath"
								local modelName = getUserProp wwmt "wwmt_modelname"
							
							)
							
					)
								
					useThisWWMT = true
					if 	wwmt.parent != undefined AND wwmt.parent.parent != undefined do (
						
						parentlist = getUserProp wwmt.parent.parent "wwmt_source_helper"
						if parentlist != undefined do (
							useThisWWMT = false
							
							)
					)				
											
							if modelPath != undefined AND modelName != undefined AND mdl !=undefined AND useThisWWMT==true do (
						
						
						
								local propType = getUserProp wwmt "wwmt_base"
								
								local className = "prop_static"
								if propType==undefined OR propType=="" then (
									
										local static getUserProp wwmt "wwmt_staticprop"
									
										if static == undefined OR static == "false" then (
											className = "prop_dynamic"
											) else (
												className = "prop_static"
											)

									
									
									
									) else (
									
									className = "prop_physics"
									
									)
								
									
									local theRotation = quatToEuler mdl.rotation
						--(theRotation.z * -1) 
									
									local theZ = theRotation.z - 180
						
	n="\n entity\n"
	format n to:sv
n="{\n"
											format n to:sv
n="\"id\" \""+(brush as string)+"\"\n"
											format n to:sv
n="\"classname\" \""+className+"\"\n"
											format n to:sv
--n="\"angles\" \""+(theRotation.x as string)+" "+((theZ ) as string)+" "+(theRotation.y as string)+"\"\n"

n="\"angles\" \"0 -180 0\"\n"

											format n to:sv
n="\"fademindist\" \"-1\"\n"
											format n to:sv
n="\"fadescale\" \"1\"\n"
											format n to:sv
n="\"model\" \"models/"+(modelPath as string)+"/"+(modelName as string)+".mdl\"\n"
											format n to:sv
n="\"skin\" \"0\"\n"
											format n to:sv
n="\"solid\" \"6\"\n"
											format n to:sv




n="\"origin\" \""+(mdl.pos.x as string)+" "+(mdl.pos.y as string)+" "+(mdl.pos.z as string)+"\"\n"


											format n to:sv
n="editor\n"
											format n to:sv
n="{\n"
											format n to:sv
n="\"color\" \"255 255 0\"\n"
											format n to:sv
n="\"visgroupshown\" \"1\"\n"
											format n to:sv
n="\"visgroupautoshown\" \"1\"\n"
											format n to:sv
n="\"logicalpos\" \"[0 0]\"\n"
											format n to:sv
n="}\n"
											format n to:sv
n="}\n"
											format n to:sv
			
						
						
											brush+=1
						
						)
					

			
			
			)
						
					
					
					
		enablesceneredraw()
		messagebox "The VMF File was successfully saved"
		close sv
		
		) catch (
		enablesceneredraw()
	
		messagebox "There was an error. Press F11 for more information."
		print ("The error is % " +(getCurrentException() as string))
	
	
	)
) 

enablesceneredraw()
)
	

rollout ww_wwdt_ui "WW Displacements" width:214 height:730
(
	button btn_create "Create Displacement" pos:[11,256] width:192 height:34 toolTip:"Create displacement(s) using the settings listed above."
	dropdownList ddl_creationType "Type" pos:[8,11] width:84 height:40 items:#("Ground", "Hill", "Open Hill", "Ring", "Corner", "Bulge", "Cube") toolTip:"Choose the type of displacement piece you are going to use."
	radiobuttons rdo_power "Power" pos:[97,19] width:93 height:30 labels:#("2", "3", "4") default:3 columns:3 toolTip:"Choose the power of this displacement. This relates to the Power in a Source Dislacement."
	label lbl_version "Version " pos:[13,488] width:67 height:19
	HyperLink wwlink "WallWorm.com" pos:[11,521] width:84 height:20 address:"http://www.wallworm.com" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	label lbl2 "Copyright (c) 2011 by " pos:[12,551] width:107 height:18
	HyperLink smolink "Shawn Olson" pos:[121,551] width:82 height:17 address:"http://www.shawnolson.net" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	button btn_vmf "Create VMF" pos:[118,349] width:89 height:34 toolTip:"Click here to generate a VMF file that you can open in Hammer. Displacements will become displacements. WWMT models will become prop_static, prop_physics or prop_dynamic. WW Sky Writer objects will export as the sky_name."
	listbox lbx_length "Length" pos:[8,59] width:67 height:8
	dropdownList ddl_height "Height" pos:[83,145] width:117 height:40
	dropdownList ddl_width "Width" pos:[85,82] width:117 height:40 
	checkbox chk_lockWidth "Lock to Length" pos:[119,82] width:91 height:14 checked:true
	checkbox chk_lockHeight "Lock to Length" pos:[118,145] width:92 height:14 checked:true	
	spinner spn_rows "Rows" pos:[19,202] width:74 height:16 range:[1,100,1] type:#integer scale:1
	spinner spn_columns "Columns" pos:[117,202] width:88 height:16 range:[1,100,1] type:#integer scale:1
	materialButton btn_material "Default Material" pos:[20,391] width:176 height:20
	button btn_sew "Sew" pos:[9,349] width:97 height:34 toolTip:"Click here to sew the open vertices of displacements that line up next to each other. Note that this action can take a while."
	GroupBox grp1 "Displacement Tool" pos:[7,469] width:200 height:111
	GroupBox grp2 "Wall Worm Shout Out" pos:[7,589] width:199 height:127
	label lbl7 "For a full-feature 3ds Max VMF Exporter, you should check out Convexity. It's the way you can get your Convex geometry, lights and entities into Source straight from Max!" pos:[14,615] width:185 height:72
	HyperLink cust7 "Convexity" pos:[80,687] width:100 height:17 address:"http://www.maple3d.com" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	checkbutton ckb_editMode "Edit Mode" pos:[11,298] width:95 height:38 toolTip:"Click here to be able to edit the landscape and texture blending." checked:false
	checkbutton ckb_texMode "Texture Mode" pos:[118,298] width:87 height:38 enabled:false toolTip:"Click to edit texture blending. Must be in Edit Mode." checked:false
	spinner spn_uvwtile "Tile" pos:[135,232] width:68 height:16 range:[0.1,100,1] type:#float scale:0.05 toolTip:"UVW Tiling for faces. Not yet outputting correctly in exported VMF... you may need to edit texture scales in Hammer."
	button btn_settings "Settings" pos:[83,487] width:115 height:30 toolTip:"Open the settings floater for all Wall Worm Tools. You can set the Map Src folder for where your VMFs should get saved."
	button btn_generateLibrary "Generate Library" pos:[20,424] width:93 height:25 toolTip:"Open the WW Material Library Generator to create 3ds Max material libraries based off of a Source VMT material collection."
	button btn_exportVTFS "Export VTFs" pos:[120,424] width:77 height:25 toolTip:"Export VTFs/VMTs (textures) based on the textures on the geometry in the scene."
	HyperLink donate "Donate" pos:[155,521] width:43 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://wallworm.com/projects/utilities/docs/resources/donate.html"
	HyperLink cust22 "Forums" pos:[99,521] width:51 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://www.wallworm.net"
	
	on btn_create pressed do
	(
			
			if rdo_power.state != 0 then (
				
				pwer = case rdo_power.state of (
	
					1: 2
	
					2: 3
	
					3: 4
				)
	
				l = (lbx_length.selected) as integer
				w = (ddl_width.selected) as integer
				h = (ddl_height.selected) as integer
	
				
				rows = spn_rows.value
				columns = spn_columns.value
				column = 1
				
				
				if ww_wwdt_last_placed_brush != undefined AND isDeleted ww_wwdt_last_placed_brush == false then (
						pos = ww_wwdt_last_placed_brush.pos
						pos[1] = pos[1] + l
				) else (
						pos=ww_wwdt_last_disp_position
				)
		
				
				
				--pos = ww_wwdt_last_disp_position
	
				for i = 1 to (rows * columns) do (
						ww_wwdt_makeDisplacement pwer l w h ddl_creationType.selected pos btn_material.material
					    pos[1] = pos[1] +l
					   column+=1
					   if column > columns do (
						   pos[1] =0
						   pos[2]=pos[2]+w
						   column = 1
						   )
					)
					
					
					
					--ww_wwdt_last_disp_position = ww_wwdt_last_placed_brush.pos
					/*if columns > 1 do (
						ww_wwdt_last_disp_position[2] = ww_wwdt_last_placed_brush.pos.y + w
					)*/
			) else (
				messagebox "You must choose a power for the displacement."
			)
			
	)
	on btn_vmf pressed do
	(
	
	ww_wwdt_outputVMF()
		
		
	
	
	)
	on lbx_length selected sel do
	(
	
		if chk_lockWidth.checked do (
			ddl_width.selection = sel
	
		)
		if chk_lockHeight.checked do (
			ddl_height.selection = sel
	
		)
	
	)
	on btn_sew pressed do
	(
		ww_wwdt_sewSelected $selection
	)
	on ckb_editMode changed state do
	(
		if state == true then (
			btn_create.enabled = false
			ww_wwdt_editMode()
			ckb_texMode.enabled = true
	
		) else (
			
			ww_wwdt_commit_edit ww_wwdt_control_mesh
			btn_create.enabled = true
			ckb_texMode.enabled = false
			ckb_texMode.checked = false
			)
	)
	on ckb_texMode changed state do
	(
		if state == true then (
	
				if ww_wwdt_control_mesh == undefined OR  isDeleted ww_wwdt_control_mesh then ( 
					ww_wwdt_paintMode()
					ckb_editMode.checked = false
				) else (
					--ww_wwdt_paint = 
					addModifier ww_wwdt_control_mesh (VertexPaint name:"WW Blend Paint" mapChannel:-2)
					
					)
		) else (
				if ww_wwdt_control_mesh != undefined AND  isDeleted ww_wwdt_control_mesh == false do ( 
					convertToPoly ww_wwdt_control_mesh
				)
			)
	)
	on spn_uvwtile changed val do
	(
	
	ww_wwdt_uvw.utile = val
	ww_wwdt_uvw.vtile = val
	ww_wwdt_uvw.wtile = val
	)
	on btn_settings pressed do
	(
		try (
		macros.run "wallworm.com" "WallWormModelToolsConfigMCR"
		) catch (
			if doesFileExist "$scripts\\WallWorm.com\\WallWormModelTools\\wwmt_mcr.ms" then (
				fileIn "$scripts\\WallWorm.com\\WallWormModelTools\\wwmt_mcr.ms"
				macros.run "wallworm.com" "WallWormModelToolsConfigMCR"
			) else (
				messageBox "The settings are now integrated with Wall Worm Model Tools. Please run the WWMT install script."
			)
		)
	)
	on btn_generateLibrary pressed do
	(
	try (
		macros.run "wallworm.com" "WallWormMaterialGeneratorMCR"
	) catch(
		messagebox (getCurrentException)
		)
	
	
	)
	on btn_exportVTFS pressed do
	(
			if wallworm_binSet "tex" then (
				include "$scripts\\WallWorm.com\\common\\exportBrushTex.ms"
			) else (
				messagebox "To compile textures, the following requirements must be met:\n\n*\"Bin Dir\" set in the Settings floater"
			)
								
	
		)
)
global ww_wwdt_dispsizes = #("64", "128", "256", "512", "1024", "2048", "4096")



createDialog ww_wwdt_ui

ww_wwdt_ui.lbx_length.items = ww_wwdt_dispsizes
ww_wwdt_ui.ddl_height.items = ww_wwdt_dispsizes
ww_wwdt_ui.ddl_width.items = ww_wwdt_dispsizes

ww_wwdt_ui.lbx_length.selection = 5
ww_wwdt_ui.ddl_height.selection = 5
ww_wwdt_ui.ddl_width.selection = 5

ww_wwdt_ui.spn_uvwtile.controller = ww_wwdt_uvw.utile.controller

ww_wwdt_ui.lbl_version.caption +=  (ww_wwdt_version as string)