/*
Wall Worm Anvil
Level Design Tools for Source
Copyright (c) 2011-2012 by Shawn Olson http://www.shawnolson.net

WallWorm.com



*/
--(

filein "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
	if (maxVersion())[1] >=12000 do (
		fileIn 	"$scripts\\WallWorm.com\\WallWormUtilities\\WalkableXView.ms"
	)
	
filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
filein 	"$scripts\\WallWorm.com\\common\\mse\\wallwormVMF.mse"

global ww_wwdt_version = 2.53
global ww_wwdt_last_disp_position = [0,0,0]
global ww_wwdt_last_placed_brush = undefined
global ww_wwdt_control_mesh = undefined
global ww_wwdt_map = #()
global ww_wwdt_sculpt_vert_count = 0

	
function ww_wwdt_get_marker = (
	ww_wwdt_marker = getNodeByName "WWDT Placement Marker"	
	if ww_wwdt_marker == undefined OR isDeleted ww_wwdt_marker do (
	
		ww_wwdt_marker = Point name:"WWDT Placement Marker" pos:ww_wwdt_last_disp_position isSelected:on Box:on size:1024
		ww_wwdt_marker.wirecolor = color 198 225 87
	)
	return ww_wwdt_marker
)
ww_wwdt_marker=undefined

function ww_wwdt_get_sky_marker = (
	ww_wwdt_sky_marker = getNodeByName "WW Sky Camera"	
	if ww_wwdt_sky_marker == undefined OR isDeleted ww_wwdt_sky_marker do (
	
		ww_wwdt_sky_marker = Point name:"WW Sky Camera" pos:[12288,0,0] Box:on size:1024
		ww_wwdt_sky_marker.wirecolor = color 200 200 255
	)
	return ww_wwdt_sky_marker
)


ww_wwdt_sky_marker=undefined


function ww_wwdt_setSkyScale amount:16 = (
	
	ww_wwdt_sky_marker=ww_wwdt_get_sky_marker()
	setUserProp ww_wwdt_sky_marker "wwdt_sky_scale" amount
	
)

--"dev/dev_measuregeneric01"
--global ww_wwdt_defaultMat = MultiMaterial numsubs:6 name:"nature/blendcliffgrass001a"
	ww_wwdt_grassBmp = openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/dirtfloor002a.tga"
	ww_wwdt_stoneBmp =  openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/cliffface002a.tga"
	
	ww_wwdt_grasstex = bitmaptexture bitmap:ww_wwdt_grassBmp filename:ww_wwdt_grassBmp.filename
	ww_wwdt_stonetex = bitmaptexture bitmap:ww_wwdt_stoneBmp filename:ww_wwdt_stoneBmp.filename
	
	ww_d9_shadermat = DirectX_9_Shader effectFilename:"$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/fx/blend_dxsas.fx" name:"nature/blendcliffgrass001a" 
	ww_d9_shadermat.seteffectbitmap 1 ww_wwdt_grassBmp
	ww_d9_shadermat.seteffectbitmap 2 ww_wwdt_stoneBmp	
	

	ww_d9_shadermat.renderMaterial =  Blend map1:(Standard diffusemap:(ww_wwdt_grasstex) showInViewport:true  name:"nature/blendcliffgrass001a" ) map2:(Standard diffusemap:(ww_wwdt_stonetex) showInViewport:true  name:"nature/blendcliffgrass001a" ) showInViewport:true  name:"nature/blendcliffgrass001a" 

	
	global ww_wwdt_defaultMat = ww_d9_shadermat

	--global ww_wwdt_paint 

	--global ww_wwdt_poly 
	
	
 	if ww_wwdt_paint == undefined do (
 		ww_wwdt_paint = VertexPaint name:"WW Vertex Paint Modifier" mapChannel:-2
 	)

-- 	if ww_wwdt_poly == undefined do (
-- 		ww_wwdt_poly = Edit_Poly name:"WW Displacement Poly Mod"
-- 	)
-- 	
	

	
if ww_wwdt_ui != undefined do (
	destroyDialog ww_wwdt_ui
)

/*
function wwdt_getAlpha obj v = (
		local theVertColor 
	
		if 	(maxVersion())[1] <10000 OR classOf obj == Editable_Mesh  then (
			    temp = copy obj
				convertToMesh temp
				meshop.supportVAlphas temp
				theVertColor =  (meshop.getVAlpha temp v)
				delete temp
			) else (
				obj.SetSelection #Vertex #{v}
				theVertColor =obj.getVertexColor #Alpha

			)

		return theVertColor
	)
*/

function wwdt_lock_displacement_transforms = (
		for disp in objects where (getUserProp disp "ww_wwdt_displacement_brush" != undefined)  do (
			setTransformLockFlags disp #all
		)
	)

function wwdt_unlock_displacement_transforms = (
		for disp in objects where (getUserProp disp "ww_wwdt_displacement_brush" != undefined)  do (
			setTransformLockFlags disp #none
		)
	)	
		
function wwdt_fixVertPosZ obj = (
					
		for v =  1 to (polyop.getNumVerts obj) do (
				originalMeshVert = polyop.getVert obj v
				nowPos 	= [originalMeshVert[1],originalMeshVert[2],obj.pos.z]
				polyop.setVert obj v nowPos 
		)
							
							
)	

function wwdt_alignVertexToGrid obj va = (
	--print "align start"
	if obj != undefined AND va !=undefined AND isDeleted obj == false AND classOf obj == Editable_Poly do (
		--print "found obj and v list"
		local movelist = #()
		local moveVectors = #()
		
		
		
		for v in va do (
			
			local coords = polyop.getVert obj v
			local coordStore = copy coords
			

					if mod coords[1] (floor coords[1]) > 0.5 then (
						coords[1] = ceil coords[1]
						) else (
						coords[1] = floor coords[1]
					)


					if mod coords[2] (floor coords[2])  > 0.5 then (
						coords[2] = ceil coords[2]
						) else (
						coords[2] = floor coords[2]
					)


					if mod coords[3] (floor coords[3])  > 0.5 then (
						coords[3] = ceil coords[3]
						) else (
						coords[3] = floor coords[3]
					)

				if coords != coordStore do (
						append movelist v
						append moveVectors (coords-coordStore)
					)
				
				
			)

			if movelist.count > 0 AND moveVectors.count > 0 do (
				
				--print moveVectors 
				
				
				for i = 1 to moveVectors.count do (
					local vl = movelist[i]
					polyop.moveVert obj #{vl} moveVectors[i] node:obj
					)
				
			)
			
			--print "finished align"
			
		)
	)
	
	function wwdt_fix_brush_vertices brsh = (
		
			local p = getUserProp brsh "ww_wwdt_power"
			if p != undefined do (
				wwdt_alignVertexToGrid brsh (ww_wwdt_getEdgeVerts p) 
				--print obj
			)

		)
	
function  ww_wwdt_createControlMesh sel = (
	
	if sel == undefined OR sel.count == 0 do (
		return false
	)

	if ww_wwdt_control_mesh != undefined AND isDeleted ww_wwdt_control_mesh ==false do (
		--if there is already a mesh assigned to the global variable, delete it
		delete ww_wwdt_control_mesh
	)			
	
	--variable to store the Controller Mesh (will be created from displacement meshes in sel)
	theController = undefined
	
	
	local maparray = #()
	local notFound = #()
	with redraw off 
	for orig in sel do (
		
		convertToPoly orig
		local theOrigVerts = polyop.getNumVerts orig
		local theverts = #()
		for i = 1 to theOrigVerts do (
			append theverts i
			
			)

		--print theverts
		append maparray #(orig,theverts,#(#(),#()))

		--use a copy of the orig for merging into the controller mesh
		obj = copy orig
		
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
	

		local vs = polyop.getNumVerts theController
		
		theController.weldThreshold = 1
		polyop.weldVertsByThreshold theController #{1..vs}

		

		
		--vs = polyop.getNumVerts theController
	
/*		
		
		IGNORE THIS BLOCK... was first method of filling map that is here just for reference
		
		-- go through each vertice in new mesh
		for i=1 to vs do (		
			
			closestVert = #(undefined,undefined,undefined)
			theVert = polyop.getVert theController i 
			--find all matching vertices in the original meshes by matching vertice positions
			for maps in maparray do (
				--print maps[1].name
				notFound = true
				for ov in maps[2] while notFound do (
					dispvert = polyop.getVert maps[1] ov
					if dispvert  == theVert then (
					--thisvert = if polyop.getVert maps[1] ov
					--if close_enough thisvert[1] theVert[1] 0.5 == true AND close_enough thisvert[2] theVert[2] 0.5 == true  AND close_enough thisvert[3] theVert[3] 0.5 == true do (
						append maps[3][1] i --record the control mesh vertice
						append maps[3][2] ov --record the original vertice
						notFound = false
					)  else (

						if (distance dispvert theVert) < 0.5 do (
							append maps[3][1] i --record the control mesh vertice
							append maps[3][2] ov --record the original vertice
							notFound = false
							
						)

					)
					
				)
			)
		)

				checkFrom1 = #()
				for i=1 to vs do (
					
					append checkFrom1 i
					)
	*/		
			--theController is a poly mesh created from all the objects that are stored in the maparray below
			vs = polyop.getNumVerts theController
			
			with redraw off 
			for maps in maparray do (
				--maps is an array structured like this:  #(originalMeshObject,arrayOfVerticesInMesh,#(#(),#()))
				checkFrom = #() -- create an array to store all the vertices in the control mesh
				for i=1 to vs do (
					append checkFrom i
				)
				for ov in maps[2] do (
					dispvert = polyop.getVert maps[1] ov --get vertice from original mesh
					local nf = true
					for i in checkFrom while nf do (		
						theVert = polyop.getVert theController i --get vertice from the control mesh
						if dispvert  == theVert do (
							append maps[3][1] i --record the control mesh vertice
							append maps[3][2] ov --record the original vertice
							deleteItem checkFrom (findItem checkFrom i) --delete item from the checkFrom array to reduce overhead in next iteration
							deleteItem maps[2] (findItem maps[2] ov) --delete vertex from the maps[2] array to reduce overhead in next iteration
							nf = false
						)  
					)
				)
				
				--now map all vertices in objects that were not mapped above by finding a vertex that is within 1 unit
				--this might happen if there was some problem with the meshes (maybe the vertices were not aligned properly and the welding above moved vertices)
				for ov in maps[2] do (
					--maps is an array structured like this:  #(originalMeshObject,arrayOfVerticesInMesh,#(#(),#()))
					dispvert = polyop.getVert maps[1] ov --get vertice from original mesh
					local nf = true
					for i in checkFrom while nf do (		
						theVert = polyop.getVert theController i --get vertice from the control mesh
						if (distance dispvert theVert) < 1 do (
							append maps[3][1] i --record the control mesh vertice
							append maps[3][2] ov --record the original vertice
							deleteItem checkFrom (findItem checkFrom i) --delete item from the checkFrom array to reduce overhead in next iteration
							nf = false
						)
					)
				)
				
			)
	
	
	

		
		for obj in sel do (
			setTransformLockFlags obj #all
			hide obj

		)

		
		ww_wwdt_control_mesh = theController
		setUserProp theController "wwdt_displacement_array" sel  --store the objects used to make this mesh in case they need to be retrieved
		setTransformLockFlags theController #all
		select theController
		
		--store the map in the global variable
		ww_wwdt_map = maparray
		enablesceneredraw()
		redrawviews()
			
		ww_wwdt_sculpt_vert_count = polyop.getNumVerts theController
		
		--ww_wwdt_control_mesh
		--ww_wwdt_editMode()
		
			when topology theController change id:#topologyControlMesh handleAt:#redrawViews obj  do (
			--make an event to unhide the displacements if the control mesh is deleted

				
				if (getPolygonCount obj)[2] != ww_wwdt_sculpt_vert_count do (
					max undo
					completeRedraw()
					messagebox "The action was cancelled. You cannot change the vertex count of this mesh."
				)

			)
		
		
		
		when theController deleted id:#deleteControlMesh obj  do (
			--make an event to unhide the displacements if the control mesh is deleted
			if ww_wwdt_map != undefined AND ww_wwdt_map.count > 0 do (

				for wwdt in ww_wwdt_map do (
					unhide wwdt[1]
				)
			)
			ww_wwdt_ui.ckb_editMode.checked = false
			deleteAllChangeHandlers  id:#topologyControlMesh
		)

		

	
	)

	
	
	function ww_wwdt_commit_edit ctr = (
		
		--if ctr != undefined AND isDeleted ctr == false do (
			--thear = getUserProp ctr "ww_wwdt_controller_map"
			if ctr ==undefined OR isDeleted ctr do (
				if ww_wwdt_map != undefined AND ww_wwdt_map.count > 0 do (
					for ar in ww_wwdt_map where (isDeleted ar[1] ==false) do (
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
				
				
				
				for wwdt in ww_wwdt_map where (isDeleted wwdt[1] ==false) do (
					unhide wwdt[1]
				    setTransformLockFlags wwdt[1] #none
					
					for i=1 to wwdt[3][2].count do (
						--wwdt is a displacement tool disp pait
						-- wwdt[1] = displacement
						--wwdt[2] = brush
						local controlMeshVert = polyop.getVert ctr wwdt[3][1][i]
						local originalMeshVert = polyop.getVert wwdt[1] wwdt[3][2][i]   
						--
						
						--format "CONTROL MESH (%): % %    --- ORIGINAL MESH (%): % %\n\n" ctr.name ar[3][1][i] controlMeshVert ar[1].name ar[3][2][i] originalMeshVert
						
		
						dist = distance originalMeshVert controlMeshVert
						--if dist == 0.0 then (
							--unitVector = [0,0,1]
							--print "no move"
						--) else (
							--format "Move obj % vert # % FROM % to %\n" ar[1].name i originalMeshVert controlMeshVert
							polyop.setVert wwdt[1] wwdt[3][2][i] controlMeshVert 
							-- node:ar[1]
							--unitVector = normalize (controlMeshVert-originalMeshVert
						--)
						if (maxVersion())[1] >= 12000 do (
							ctr.SetSelection #Vertex #{(wwdt[3][1][i])}
							local theVertColor =ctr.getVertexColor #Alpha
							polyop.setVertColor wwdt[1] -2 wwdt[3][2][i] theVertColor
						)
						

					)


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

	
		if t == "texture" then (

				addModifier disp ww_wwdt_paint
			
			) else (
					--addModifier disp ww_wwdt_paint

			)
		)
		

		
	)



function ww_wwdt_editMode = (

	
	theDisp = #()				

	if selection.count > 1 then (
		 
		useSel = selection
		) else (
		useSel = objects
		)

	for disp in useSel where (isDeleted disp ==false) do (
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
	for disp in objects where (isDeleted disp ==false) do (
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

	
	
function ww_wwdt_sewSelected sel = (
	disableSceneRedraw()
	posStore = #()	
	tempPosStore = #()	
	brushList = #()	
	local refNode = undefined
	for disp in sel where (isDeleted disp ==false) do (
		
		local brushName = getUserProp disp "ww_wwdt_displacement_brush"
		if brushName != undefined do (
			local b = getNodeByName  brushName
			
			if b !=undefined AND isDeleted b == false do (
				
				if refNode == undefined do (
					refNode = b
				)

				convertto b editable_poly
				convertto disp editable_poly
				appendIfUnique brushList #(b,disp) 
				power = getUserProp b "ww_wwdt_power"
				
				edgeVertices = ww_wwdt_getEdgeVerts power
					
				--faceStore = #{}		
						
				--addDisp = true
				--hiddenFaces = polyop.getHiddenFaces disp 

				--for start = 1 to b.GetNumFaces()  do (
					--if findItem hiddenFaces start == 0 do (
						--appendIfUnique faceStore start
					 --)
				
				--)
		
				--for f in faceStore do (
					--verts = polyop.getFaceVerts b f
						for vert in edgeVertices do (
							--if findItem edgeVertices vert > 0 do (
								tpos = polyop.getVert b vert 
								--print tpos
								if findItem tempPosStore tpos > 0 then (
									append posStore tpos
								) else (
									appendIfUnique tempPosStore tpos
								)
							
							--)
						)
				--)
			)
		)
	)
	
	/*
	print "Brushes:"
	print brushList
	
	print "Postore:"
	print posStore
	
	
	print "Tempstore:"
	print tempPosStore
	
	*/

	ind = 1
	objStore = #()	
	posMap = #()
	for v in posStore do (
		objStore[ind] = #()
		posMap[ind] = v
		for br in brushList do (
			
			
			vertexAt = false
			for bv = 1 to br[1].GetNumVertices() while vertexAt==false do (
				
				--local vagainst = (polyop.getVert br[1] bv)
				localv = polyop.getVert br[1] bv
				if localv== v then (
				
				--if ( (close_enough vagainst[1] v[1] 0.6) AND (close_enough vagainst[2] v[2] 0.6) AND (close_enough vagainst[3] v[3] 0.6) ) do (
					appendIfUnique objStore[ind] #(br[2],bv)
					vertexAt = true
				) else (
					
					if distance localv v < 0.5 do (
						
						appendIfUnique objStore[ind] #(br[2],bv)
						vertexAt = true
						
						)
					
					
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
	
	
	


	
function wwdt_bind_disp_to_brush disp brsh p l w  = (
	
	setUserProp disp "ww_wwdt_displacement_brush" brsh.name
	setUserProp brsh "ww_wwdt_displacement" "true"
	setUserProp brsh "ww_wwdt_displacement_target" disp.name

	
	setUserProp brsh "ww_wwdt_power" (p as string)
	setUserProp brsh "ww_wwdt_length" (l as string)
	setUserProp brsh "ww_wwdt_width" (w as string)
	
	

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
	
	
	wwdt_alignVertexToGrid brsh (ww_wwdt_getEdgeVerts p) 
	wwdt_alignVertexToGrid disp (ww_wwdt_getEdgeVerts p) 
	

	
	
	ww_wwdt_setchangehandlers disp 
		

		


	
		
	
	)	
	
	
	
function  ww_wwdt_makeDisplacement p l w pos mat = (
	segs = ww_wwdt_vmfpowertosegs p
	
	if pos == undefined do (
		
		pos=ww_wwdt_last_disp_position
		)
	local brsh = Plane length:l width:w isSelected:off lengthsegs:segs widthsegs:segs pos:pos	
	brsh.name =(uniqueName  "WW_Displacement_Brush_")
	--modi = Smooth smoothingBits:1	
	--addModifier brsh modi	

	convertto brsh editable_poly
	ww_wwdt_last_placed_brush = brsh	
		
	--ww_wwdt_last_disp_position = ww_wwdt_last_placed_brush.pos	
	
	--#("Ground","Hill","Open Hill","Ring","Corner","Cube")


		

	
	disp = copy brsh
	
	channelInfo.addChannel disp
 	--channelInfo.update()
		
	
	
	disp.name =(uniqueName  ("WW_Displacement_"))

	wwdt_bind_disp_to_brush disp brsh	p l w
	--select disp
		
	

   if mat == undefined do (
		mat = ww_wwdt_defaultMat
	)

	disp.mat = mat	
	

	--addModifier disp ww_wwdt_paint
	--addModifier disp ww_wwdt_poly
	--convertToPoly disp
	
	case of (
		
		(p==2) :(
			facesToRetriangulate = #{2, 4..5, 7, 10, 12..13, 15}
			fcount = 16
			ecount = 96
		)
		(p==3) : (
			facesToRetriangulate =#{2, 4, 6, 8..9, 11, 13, 15, 18, 20, 22, 24..25, 27, 29, 31, 34, 36, 38, 40..41, 43, 45, 47, 50, 52, 54, 56..57, 59, 61, 63}
			ecount = 144
			fcount = 64
			)
		(p==4 ): (
			facesToRetriangulate =#{2, 4, 6, 8, 10, 12, 14, 16..17, 19, 21, 23, 25, 27, 29, 31, 34, 36, 38, 40, 42, 44, 46, 48..49, 51, 53, 55, 57, 59, 61, 63, 66, 68, 70, 72, 74, 76, 78, 80..81, 83, 85, 87, 89, 91, 93, 95, 98, 100, 102, 104, 106, 108, 110, 112..113, 115, 117, 119, 121, 123, 125, 127, 130, 132, 134, 136, 138, 140, 142, 144..145, 147, 149, 151, 153, 155, 157, 159, 162, 164, 166, 168, 170, 172, 174, 176..177, 179, 181, 183, 185, 187, 189, 191, 194, 196, 198, 200, 202, 204, 206, 208..209, 211, 213, 215, 217, 219, 221, 223, 226, 228, 230, 232, 234, 236, 238, 240..241, 243, 245, 247, 249, 251, 253, 255}
			ecount = 544
			fcount = 256
		)
	)
		
		for i in facesToRetriangulate do (
			--print i
			disp.TurnDiagonal i 1
		)
	
		
		convertToMesh disp

		notDone = true
		while notDOne do (
			local edges = disp.Edges
			
			meshop.autoEdge disp edges 0 type:#SetClear

			if edges.count == (disp.Edges).count do (
				notDone = false
				)
			
			)
		
		
		

		convertto disp editable_poly
		
	return #(disp,brsh)

)	

function wwdt_copy_displacement objs =
(
		for disp in objs[2] do (
			local dispName = getUserProp disp "ww_wwdt_displacement_brush"
			if dispName != undefined do (
				s = getNodeByName  dispName
				if s !=undefined AND isDeleted s == false do (
					
					
					brsh = copy s
					p = getUserProp s "ww_wwdt_power" 
					l = getUserProp s "ww_wwdt_length" 
					w = getUserProp s "ww_wwdt_width" 

					
					wwdt_bind_disp_to_brush disp brsh p l w
					
					
					
					
					/*
					local l = getUserProp disp "ww_wwdt_length"
					local w = getUserProp disp "ww_wwdt_length"
					if l == undefined do l = 1024
					if w == undefined do w= 1024
					local useMat
					if disp.mat != undefined then (
						useMat = disp.mat
						)else(
						
						
						)
						disps = ww_wwdt_makeDisplacement pwer l w disp.pos useMat
						disps[1].rotation = disp.rotation
						*/
						
				)
					--delete disp
			)
		)

)



	

rollout ww_wwdt_ui "Wall Worm Anvil - Level Design Tools for Source" width:705 height:368
(
	bitmap anvillogo "anvil" pos:[491,172] width:200 height:107 fileName:"$scripts/WallWorm.com/assets/anvil_logo.tif" 
 
 
 
 
	button btn_create "Create Displacement" pos:[32,279] width:192 height:37 toolTip:"Create displacement(s) using the settings listed above."
	dropdownList ddl_creationType "Type" pos:[27,31] width:84 height:40 items:#("Ground", "Hill", "Open Hill", "Ring", "Corner", "Bulge", "Tunnel", "Tube", "Cube") toolTip:"Choose the type of displacement piece you are going to use."
	radiobuttons rdo_power "Power" pos:[116,39] width:93 height:30 labels:#("2", "3", "4") default:1 columns:3 toolTip:"Choose the power of this displacement. This relates to the Power in a Source Dislacement."
	--label lbl_version "Version " pos:[617,178] width:67 height:14
	HyperLink wwlink "WallWorm.com" pos:[262,344] width:84 height:20 address:"http://www.wallworm.com" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	label lbl2 "Copyright (c) 2012 by " pos:[7,345] width:107 height:18
	HyperLink smolink "Shawn Olson" pos:[116,345] width:82 height:17 address:"http://www.shawnolson.net" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	button btn_vmf "Create VMF (Send to Hammer)" pos:[492,300] width:199 height:40 toolTip:"Click here to generate a VMF file that you can open in Hammer. Displacements will become displacements. WWMT models will become prop_static, prop_physics or prop_dynamic. WW Sky Writer objects will export as the sky_name."
	listbox lbx_length "Length" pos:[27,79] width:67 height:8 toolTip:"Length of side of displacement. Also used as default width and height."
	dropdownList ddl_height "Height" pos:[102,165] width:117 height:40 toolTip:"Height of displacement. Not relevant for Ground displacement."
	dropdownList ddl_width "Width" pos:[104,102] width:117 height:40 toolTip:"Width of each displacement."
	checkbox chk_lockWidth "Lock to Length" pos:[138,102] width:91 height:14 checked:true
	checkbox chk_lockHeight "Lock to Length" pos:[137,165] width:92 height:14 checked:true	
	
	
	spinner spn_rows "Rows" pos:[47,222] width:65 height:16 range:[1,100,1] type:#integer scale:1 toolTip:"Used to make multiple rows of displacements."
	spinner spn_columns "Columns" pos:[149,222] width:75 height:16 range:[1,100,1] type:#integer scale:1 toolTip:"Used to make multiple columns of displacements."
	materialButton btn_material "Default Material" pos:[599,34] width:84 height:26
	button btn_sew "Sew" pos:[277,114] width:59 height:30 enabled:true toolTip:"Click here to sew the open vertices of displacements that line up next to each other. Note that this action can take a while."
	HyperLink cust7 "Convexity" pos:[590,345] width:100 height:17 address:"http://www.maple3d.com" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	checkbutton ckb_editMode "Edit Mode" pos:[276,32] width:95 height:38 toolTip:"Click here to be able to edit the landscape and texture blending. If more than one displacement is selected, then edit mode only uses the selected displacements. Otherwise, uses all displacements." checked:false
	checkbutton ckb_texMode "Paint Alpha" pos:[377,32] width:87 height:38 toolTip:"Click to edit texture blending on displacements with Alpha Blending using the Vertex Paint tool." 
 
 
	button btn_settings "Settings" pos:[492,281] width:198 height:16 toolTip:"Open the settings floater for all Wall Worm Tools. You can set the Map Src folder for where your VMFs should get saved."
	button btn_generateLibrary "Generate Library" pos:[503,34] width:93 height:26 toolTip:"Open the WW Material Library Generator to create 3ds Max material libraries based off of a Source VMT material collection."
	button btn_exportVTFS "Export VMTs/VTFs into Source" pos:[502,72] width:181 height:31 toolTip:"Export VTFs/VMTs (textures) based on the textures on the geometry in the scene."
	HyperLink donate "Donate" pos:[406,344] width:43 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/42/donate.html"
	HyperLink cust22 "Forums" pos:[350,344] width:51 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://www.wallworm.net"
	GroupBox grp3 "Material Functions" pos:[493,7] width:195 height:111
	button btn8 "Lock Displacements" pos:[277,150] width:110 height:36 toolTip:"Lock the displacements in the scene so that they cannot be moved, rotated or scaled."
	button btn9 "Unlock" pos:[392,150] width:70 height:36 toolTip:"Unlock the displacements in the scene so that they can be moved, rotated or scaled."
	button ckbGridSnap "Grid and Snap" pos:[31,244] width:104 height:25 toolTip:"Toggle Snaps and Set the Home Grid size to match the value in the Length menu. Also switches to Pivot Point Center."
	checkbutton btn12 "Display Walkable" pos:[277,76] width:185 height:32 toolTip:"Hilight areas in green that are not walkable. Only works on selected meshes and works best in Edit Mode on a single mesh."
	button btncreateWWMTProxies "Create WWMT Proxy" pos:[493,123] width:113 height:23 toolTip:"Create proxy wwmt objects in the scene from the selected WWMT helpers."
	button btn_getHelper "Get Helper" pos:[137,244] width:86 height:25 toolTip:"Select the displacement placement Helper. If it has been deleted, creates a new helper."
	button btn_planar_mapping "Planar Mapping" pos:[339,114] width:122 height:29 toolTip:"Click to add Planar UVW Mapping to the selected objects"
	GroupBox grp4 "Create Displacements" pos:[7,7] width:246 height:334
	GroupBox grp5 "Edit Displacements" pos:[262,7] width:218 height:188
	button btn_addBrush "Add" pos:[272,234] width:50 height:17 toolTip:"Designate all selected objects as brush geometry when exporting to VMF."
	button btn_removeBrush "Remove" pos:[328,234] width:71 height:17 toolTip:"Remove selected objects from the list of items that should become brushes (world geometry) in the VMF."
	button btn31 "Select" pos:[406,234] width:65 height:17 toolTip:"Select all objects in the current selection designated as brush geometry. If selection is empty, selects from entire scene."
	label lbl3 "Works with" pos:[530,345] width:60 height:15
	label lbl10 "Brush Geometry" pos:[274,216] width:86 height:16
	button btn49 "Add" pos:[273,297] width:53 height:17 toolTip:"Designate all selected objects as belonging in the 3D Skybox when exporting to VMF."
	button btn50 "Remove" pos:[329,297] width:50 height:17 toolTip:"Remove selected objects from the list of items that should be in the 3D Skybox in the VMF."
	button btn51 "Select" pos:[383,297] width:40 height:17 toolTip:"Select all objects in the current selection designated as 3D Skybox objects. If selection is empty, selects from entire scene."
	label lbl11 "Skybox Object" pos:[274,279] width:86 height:16
	GroupBox grp13 "Export Tags" pos:[262,199] width:218 height:142
	button btn71 "Sky Cam" pos:[427,297] width:45 height:17 toolTip:"Select the WW Sky Camera helper. The location of the Sky Camera Helper will export as the origin of your mini map if creating a 3D Skybox."
	button btn_setSkyScale "1/16" pos:[407,317] width:29 height:17 toolTip:"Set to Skybox Scale ( 1/16 )"
	button btn_setSkyScale2 "1/32" pos:[440,317] width:32 height:17 toolTip:"Set to L4D Skybox Scale ( 1/32 )"
	spinner spn_scale "Skybox Scale 1/" pos:[344,317] width:58 height:16 range:[1,100,16] type:#integer scale:1 toolTip:"Set the skybox scale for this level."	
	
	
	dropdownList ddl_propType "Prop Types" pos:[608,125] width:81 height:40 items:#("prop_static", "prop_detail", "prop_physics", "prop_dynamic") toolTip:"Set the selected WWMT helpers to the following prop type. Will propagate to the helper's proxies."
	button btn23 "Add" pos:[373,256] width:25 height:15 toolTip:"Set the selection as a brush and a func_detail."
	button btn24 "Remove" pos:[406,257] width:65 height:15 toolTip:"Remove this item form the func_detail list."
	label lbl6 "Detail" pos:[272,257] width:51 height:15
	button btn73 "Sky and Brush" pos:[380,277] width:92 height:16 toolTip:"Set the selected objects as both brush and sky objects."
	button btn36 "More Proxy Tools" pos:[493,148] width:113 height:16
	button btn27 "Group Add" pos:[315,256] width:55 height:15
	
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
				
				
				--if ww_wwdt_last_placed_brush != undefined AND isDeleted ww_wwdt_last_placed_brush == false then (
						--pos = ww_wwdt_last_placed_brush.pos
						--pos[1] = pos[1] + l
				--) else (
						--pos=ww_wwdt_last_disp_position
				--)
				ww_wwdt_marker = ww_wwdt_get_marker()
				pos = ww_wwdt_marker.pos
				
				clearselection()
				
				--pos = ww_wwdt_last_disp_position
				for i = 1 to (rows * columns) do (
					
						--h ddl_creationType.selected
					
					
	
							if ddl_creationType.selected == "Ground" then (
								local disp1 = ww_wwdt_makeDisplacement pwer l w  pos btn_material.material
								pos[1] = pos[1] +l
								selectMore disp1[1]
								) else (
								
									if (ddl_creationType.selected == "Hill" OR ddl_creationType.selected == "Cube" OR ddl_creationType.selected == "Open Hill"  OR ddl_creationType.selected == "Tube"  OR ddl_creationType.selected == "Tunnel") do (
										local disp1 = ww_wwdt_makeDisplacement pwer l w  pos btn_material.material
										if   ddl_creationType.selected != "Tunnel" do (
											disp1[1].pos.z = disp1[1].pos.z+h
										)
										selectMore disp1[1]
									)
	
									if (ddl_creationType.selected == "Hill" OR ddl_creationType.selected == "Cube" OR ddl_creationType.selected == "Ring"  OR ddl_creationType.selected == "Corner"  OR ddl_creationType.selected == "Bulge") do (
										local disp2 = ww_wwdt_makeDisplacement pwer l h  pos btn_material.material
										if ddl_creationType.selected == "Tunnel" then (
											disp2[1].pos.x = disp2[1].pos.x + (w/2)
											) else (
											disp2[1].pos.x = disp2[1].pos.x - (w/2)
										)
										disp2[1].pos.z = disp2[1].pos.z + (h/2)
										rotate disp2[1] (angleaxis -90 [0,1,0])
										--rotate disp2[2] (angleaxis -90 [0,1,0])
										--WorldAlignPivot disp2[1]
										--WorldAlignPivot disp2[2]
										
										selectMore disp2[1]
										if ddl_creationType.selected != "Corner"  do (
											local disp3 = ww_wwdt_makeDisplacement pwer l h  pos btn_material.material
											if ddl_creationType.selected == "Tunnel" then (
												disp3[1].pos.x = disp3[1].pos.x - (w/2)
											) else (
											
												disp3[1].pos.x = disp3[1].pos.x + (w/2)
											)
											disp3[1].pos.z = disp3[1].pos.z + (h/2)
											rotate disp3[1] (angleaxis 90 [0,1,0])
											--rotate disp3[2] (angleaxis 90 [0,1,0])
											--WorldAlignPivot disp3[1]
											--WorldAlignPivot disp3[2]
											selectMore disp3[1]
										)
									)
									
									if (ddl_creationType.selected == "Hill" OR ddl_creationType.selected == "Open Hill" OR ddl_creationType.selected == "Cube" OR ddl_creationType.selected == "Ring"  OR ddl_creationType.selected == "Corner"  OR ddl_creationType.selected == "Bulge"  OR ddl_creationType.selected == "Tube"   OR ddl_creationType.selected == "Tunnel"  ) do (
						
										local disp4= ww_wwdt_makeDisplacement pwer h w  pos btn_material.material
										disp4[1].pos.y = disp4[1].pos.y - (l/2)
										disp4[1].pos.z = disp4[1].pos.z + (h/2)
										rotate disp4[1] (angleaxis 90 [1,0,0])
										--rotate disp4[2] (angleaxis 90 [1,0,0])
										--WorldAlignPivot disp4[1]
										--WorldAlignPivot disp4[2]
										selectMore disp4[1]
										if ddl_creationType.selected != "Corner" AND ddl_creationType.selected != "Bulge" do (
											local disp5 = ww_wwdt_makeDisplacement pwer h w  pos btn_material.material
											disp5[1].pos.y = disp5[1].pos.y + (l/2)
											disp5[1].pos.z = disp5[1].pos.z + (h/2)
											rotate disp5[1] (angleaxis -90 [1,0,0])
											--rotate disp5[2] (angleaxis -90 [1,0,0])
											--WorldAlignPivot disp5[1]
	
											--WorldAlignPivot disp5[2]
											selectMore disp5[1]
										)
									)
									if ddl_creationType.selected == "Cube" OR  ddl_creationType.selected == "Tunnel"   OR  ddl_creationType.selected == "Tube"do (
											local disp6 = ww_wwdt_makeDisplacement pwer l w  pos btn_material.material
											
	
											if ddl_creationType.selected == "Tunnel" do (
												disp6[1].pos.z = disp6[1].pos.z+h	
											)
											rotate disp6[1] (angleaxis 180 [0,1,0])	
											--rotate disp6[2] (angleaxis 180 [0,1,0])	
											--WorldAlignPivot disp6[1]
											--WorldAlignPivot disp6[2]
											wwdt_fixVertPosZ disp6[1]
											wwdt_fixVertPosZ disp6[2]
											selectMore disp6[1]
											--disp6[1].parent = cp
											--setTransformLockFlags disp6[1] #all
									)
									pos[1] = pos[1] +l
								
								)
								
								
							
							if (ddl_creationType.selected == "Hill" OR ddl_creationType.selected == "Cube" OR ddl_creationType.selected == "Bulge"   OR ddl_creationType.selected == "Corner") do (
								pos[1]=pos[1]+l
							)
					
						ww_wwdt_marker.pos = pos
						ww_wwdt_last_disp_position = pos
					
					    
					   column+=1
					   if column > columns do (
						   pos[1] =0
						   pos[2]=pos[2]+w
							if (ddl_creationType.selected == "Hill" OR ddl_creationType.selected == "Cube" OR ddl_creationType.selected == "Open Hill"  OR ddl_creationType.selected == "Tube"  OR ddl_creationType.selected == "Tunnel"  OR ddl_creationType.selected == "Bulge"   OR ddl_creationType.selected == "Corner") do (
								pos[2]=pos[2]+w
							)
						   
						   column = 1
						   )
					)
					
					setCommandPanelTaskMode #modify
					
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
	
	 macros.run "wallworm.com" "WallWormExportVMFMCR"
		
		
	
	
	)
	on lbx_length selected sel do
	(
	
		if chk_lockWidth.checked do (
			ddl_width.selection = sel
	
		)
		if chk_lockHeight.checked do (
			ddl_height.selection = sel
	
		)
		
		
		ww_wwdt_marker = ww_wwdt_get_marker()
		if classOf ww_wwdt_marker == Point do (
			ww_wwdt_marker.size = lbx_length.selected as integer
		)
	)
	on btn_sew pressed do
	(
		ww_wwdt_sewSelected $selection
	)
	on ckb_editMode changed state do
	(
		if state == true then (
			--btn_create.enabled = false
			ww_wwdt_editMode()
			--ckb_texMode.enabled = true
	
		) else (
			
			ww_wwdt_commit_edit ww_wwdt_control_mesh
			--btn_create.enabled = true
			--ckb_texMode.enabled = false
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
					
				local v = VertexPaintTool()
				v.brushOpacity = 50
				v.curPaintMode = 1
				v.brushSize = 128
				v.brushOpacity  = 100
					
		) else (
				if ww_wwdt_control_mesh != undefined AND  isDeleted ww_wwdt_control_mesh == false do ( 
					convertToPoly ww_wwdt_control_mesh
				)
			)
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
		try (
			if wallworm_binSet "tex" then (
				include "$scripts\\WallWorm.com\\common\\exportBrushTex.ms"
			) else (
				messagebox "To compile textures, the following requirements must be met:\n\n*\"Bin Dir\" set in the Settings floater"
			)
			) catch (
			
				include "$scripts\\WallWorm.com\\common\\exportBrushTex.ms"
			)
	
	)
	on btn8 pressed do
	(
	wwdt_lock_displacement_transforms()
	
	)
	on btn9 pressed do
	(
	
	wwdt_unlock_displacement_transforms()
	)
	on ckbGridSnap pressed do
	(
	
		SetGridSpacing ((lbx_length.selected) as integer)
		snapMode.active = true
		--max snap toggle
		toolMode.pivotCenter()
	
	)
	on btn12 changed state do
	(
		if 	(maxVersion())[1] >=12000 then (
			try (
				macros.run "wallworm.com" "WW_Face_Walkable"
			) catch (
				fileIn "$scripts\\WallWorm.com\\WallWormModelTools\\wwmt_mcr.ms"
				macros.run "wallworm.com" "WW_Face_Walkable"
				)
			) else (
				
				messagebox "This feature only works in 3ds Max 2010+."
				
				)
	)
	on btncreateWWMTProxies pressed do
	(
	/*Create wwmt proxies from selection*/
		macros.run "wallworm.com" "WallWormModelToolsCreateProxyiesMCR"
	)
	on btn_getHelper pressed do
	(
	
	  local h = ww_wwdt_get_marker()
	  select h
	
	)
	on btn_planar_mapping pressed do
	(
	
	
	 if selection.count > 0 do (
		 newsel = #()	
	
	     for obj in selection  where  isDeleted obj == false AND (getUserProp obj "ww_wwdt_displacement_brush" != undefined)   do (
			 append newsel obj
			 
			 )
	
			if newsel.count > 0 do (
				
	
				clearSelection
				select newsel
				setCommandPanelTaskMode #modify
				local theUVW = Uvwmap ()
				modPanel.addModToSelection (theUVW) ui:on
	
				
				)
	 )
	
	)
	on btn_addBrush pressed do
	(
		macros.run "wallworm.com" "WallWormDesignateSelectionAsBrushes"
	)
	on btn_removeBrush pressed do
	(
		macros.run "wallworm.com" "WallWormRemoveSelectionFromBrushes"
	)
	on btn31 pressed do
	(
		
		if selection.count > 0 then (
			select (for obj in selection where  (getUserProp obj "wwdt_brush_geometry_export") != undefined AND (getUserProp obj "wwdt_brush_geometry_export") == true collect obj)
		) else (
			select (for obj in objects where  (getUserProp obj "wwdt_brush_geometry_export") != undefined AND (getUserProp obj "wwdt_brush_geometry_export") == true collect obj)
		)
	
	
	)
	on btn49 pressed do
	(
		
		macros.run "wallworm.com" "WallWormDesignateSelectionAsSky"
		
	)
	on btn50 pressed do
	(
		macros.run "wallworm.com" "WallWormRemoveSelectionFromSky"
	)
	on btn51 pressed do
	(
		
		if selection.count > 0 then (
			select (for obj in selection where  (getUserProp obj "wwdt_skybox_export") != undefined AND (getUserProp obj "wwdt_skybox_export") == true collect obj)
		) else (
			select (for obj in objects where  (getUserProp obj "wwdt_skybox_export") != undefined AND (getUserProp obj "wwdt_skybox_export") == true collect obj)
		)
	
	
	)
	on btn71 pressed do
	(
	
	 ww_wwdt_sky_marker=ww_wwdt_get_sky_marker()
	 select ww_wwdt_sky_marker
	 --max zoomext sel all
	)
	on btn_setSkyScale pressed do
	(
			
			spn_scale.value = 16
			ww_wwdt_setSkyScale amount:spn_scale.value
			)
	on btn_setSkyScale2 pressed do
	(
			
		spn_scale.value = 32
		ww_wwdt_setSkyScale amount:spn_scale.value
	
			
	)
	on spn_scale changed val do
	(
	ww_wwdt_setSkyScale amount:spn_scale.value
	
	)
	on ddl_propType selected sel do
	(
	
					if selection.count == 0 then (
					
					messagebox "This function only works when you have selected a set of WWMT helpers."
					
					) else (
						   oldsel = selection as array
						    local wwmts = 0
						    local failed = #()
						    clearSelection()
							local res = #()
							for obj in oldsel do (
								
								isWWMTSource = getUserProp obj "wwmt_source_helper"	
								 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
	
											local tempWWMT = ww_LOD_wrapper()
	
											tempWWMT.init()					
											tempWWMT.setTargetModel obj tempWWMT
											--messagebox ddl_propType.selected
											local message = (tempWWMT.setCoreCVXEntityValue type:ddl_propType.selected)
											if message != "" then (
												
												append res message
												)
	
	                                 )
	                           )
							   
							   if res.count > 0 then (
								   message = "The action was completed but there were some problems:\n\n"
								   for m in res do (
									   append message ("*"+m+"\n")
									   
									   )
								   messagebox message
								   )
							   select oldsel
	                  )
	
	
	
	)
	on btn23 pressed do
	(
	
			macros.run "wallworm.com" "WallWormDesignateSelectionAsBrushes"
			macros.run "wallworm.com" "WallWormDesignateSelectionAsFuncDetail"
	)
	on btn24 pressed do
	(
			macros.run "wallworm.com" "WallWormRemoveSelectionFromFuncDetail"
	)
	on btn73 pressed do
	(
			macros.run "wallworm.com" "WallWormDesignateSelectionAsBrushes"
			macros.run "wallworm.com" "WallWormDesignateSelectionAsSky"
	
	)
	on btn36 pressed do
	(
	macros.run "wallworm.com" "WallWormModelToolsProxyToolsMCR"
	
	)
	on btn27 pressed  do
	(
	
	        group selection name:(uniqueName "WW Func Detail")  select:true
	
	
			macros.run "wallworm.com" "WallWormDesignateSelectionAsBrushes"
			macros.run "wallworm.com" "WallWormDesignateSelectionAsFuncDetail"
	)
)
global ww_wwdt_dispsizes = #("64", "128", "256", "512", "1024", "2048", "4096")



createDialog ww_wwdt_ui

ww_wwdt_ui.lbx_length.items = ww_wwdt_dispsizes
ww_wwdt_ui.ddl_height.items = ww_wwdt_dispsizes
ww_wwdt_ui.ddl_width.items = ww_wwdt_dispsizes

ww_wwdt_ui.lbx_length.selection = 5
ww_wwdt_ui.ddl_height.selection = 5
ww_wwdt_ui.ddl_width.selection  = 5



ww_wwdt_ui.title +=" - Version " + (ww_wwdt_version as string)
--)
callbacks.removeScripts id:#wwdt_displacement_clone_handler
callbacks.addScript #postNodesCloned "wwdt_copy_displacement (callbacks.notificationParam())" id:#wwdt_displacement_clone_handler 

--find all displacements and run their correct event handlers

--deleteAllChangeHandlers  id:#topologyControlMesh
ww_wwdt_setDispHandlers()	

callbacks.removeScripts id:#wwdt_displacement_topo_handler

callbacks.addScript #filePostOpenProcess fileName:"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\startup.ms" id:#wwdt_displacement_topo_handler  persistent:true