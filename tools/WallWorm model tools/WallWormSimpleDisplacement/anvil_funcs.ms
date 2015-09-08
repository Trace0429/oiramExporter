/*
Functions used in Anvil

Copyright (c) 2012-2014 by Shawn Olson
www.shawnolson.net

A Wall Worm Tool
www.wallworm.com
*/

global  ww_wwdt_last_disp_position
if ww_wwdt_last_disp_position == undefined then (
	ww_wwdt_last_disp_position	= [0,0,0]
)
global  ww_wwdt_last_placed_brush 
global ww_wwdt_sky_marker
/*global ww_wwdt_control_mesh

if ww_wwdt_control_mesh != undefined AND isDeleted ww_wwdt_control_mesh then (
	ww_wwdt_control_mesh = undefined	
)

global  ww_wwdt_sculpt_vert_count

*/
global  ww_wwdt_map = #()


global ww_wwdt_dispsizes = #("32","64", "128", "256", "512", "1024")
global  ww_wwdt_displacement_power


/*This means the objects is a new Displacement using Custom Attributes*/
function wallworm_get_sculpt_meshes = (
	for obj in objects WHERE isProperty obj "wallworm_edit_mesh" == true  collect obj
)


function wallworm_hide_used_disp_pieces = (

		local sms = wallworm_get_sculpt_meshes()
	
		for sm in sms do (
			sm.hideAllParts()
		)
	
)


/*This means the objects is a new Displacement using Custom Attributes*/
function wallworm_is_displacement obj = (
		if isProperty obj "wallworm" == true AND isProperty obj "ww_displacement" == true then (
			return true
		)
	false
)


if ww_wwdt_displacement_power == undefined then (
	
	ww_wwdt_displacement_power = 2
	)


	function wallworm_show_displacements use:objects = (

		local disps = for disp in use where isProperty disp "ww_displacement" == true OR (getUserProp disp "ww_wwdt_displacement_brush" != undefined ) collect disp 
		unhide disps
		--setTransformLockFlags disps #{7,8,9}
		disps = undefined
			
		)

	function wallworm_hide_displacements use:objects =(

		local disps = for disp in use where isProperty disp "ww_displacement" == true OR (getUserProp disp "ww_wwdt_displacement_brush" != undefined ) collect disp 
		hide disps
		--setTransformLockFlags disps #{7,8,9}
		disps = undefined
			
		)	

	function wallworm_show_displacement_brushes use:objects= (


		local disps = for disp in use where (getUserProp disp "ww_wwdt_displacement" != undefined AND getUserProp disp "ww_wwdt_displacement" == true) collect disp 
		unhide disps
		--disps.xray = off
		--setTransformLockFlags disps #{7,8,9}
		disps = undefined
			
		)

	function wallworm_hide_displacement_brushes  use:objects =(


		local disps = for disp in use where (getUserProp disp "ww_wwdt_displacement" != undefined AND getUserProp disp "ww_wwdt_displacement" == true) collect disp 
		hide disps
		--disps.xray = on
		--setTransformLockFlags disps #{7,8,9}
		disps = undefined
			
		)	
		
		
	function wallworm_move_displacement_mode state = (
		
		
		if state == true then (
			wallworm_show_displacement_brushes use:objects
			wallworm_hide_displacements use:objects 
			
		) else (
			
			wallworm_hide_displacement_brushes use:objects
			wallworm_show_displacements use:objects 
			
			if selection.count >0 then (
				theDisps = #()
				local brshes =  for obj in selection where (getUserProp obj "ww_wwdt_displacement_target" != undefined) collect obj
				for br in brshes do (
					disp = getNodeByName (getUserProp br "ww_wwdt_displacement_target")
					if disp != undefined AND isDeleted disp == false then (
						appendIfUnique theDisps disp
						
						)
					)
				
				if theDisps.count > 0 then (
					select theDisps
					)
				)
			
			
			
		)
		
			wallworm_hide_used_disp_pieces()	
		
	)
		
		
		
		
		

function ww_wwdt_getBrushFromDisp disp = (
	
			if isProperty disp "brushNode" then (
					return disp.brushNode
			)
			local bName = getUserProp disp "ww_wwdt_displacement_brush"
			if bName != undefined do (
				local brush = getNodeByName bName
				if brush != undefined then (
					return brush
					)


			)
			return undefined
	)

	
	function ww_wwdt_getBrushesFromDisplacements disps = (
		
		local brushes = #()
		for disp in disps do (
			local brush = ww_wwdt_getBrushFromDisp disp
			if brush != undefined then (
				
				append brushes brush
				
				) else ()
			
			)
		
		
		return brushes
	)
	
function ww_wwdt_get_marker create:true= (
	ww_wwdt_marker = getNodeByName "WWDT Placement Marker"	
	if (ww_wwdt_marker == undefined OR isDeleted ww_wwdt_marker) AND create == true do (
	
		ww_wwdt_marker = Point name:"WWDT Placement Marker" pos:ww_wwdt_last_disp_position isSelected:on Box:on size:1024
		ww_wwdt_marker.wirecolor = color 198 225 87
	)
	return ww_wwdt_marker
)
ww_wwdt_marker=undefined

function ww_wwdt_get_sky_marker setScale:16 create:true = (
	
	ww_wwdt_sky_marker = undefined 
	
	for obj in objects where isDeleted obj == false AND isProperty obj "wallworm" == true AND isProperty obj "entname" == true AND obj.entname=="sky_camera" while ww_wwdt_sky_marker==undefined do (
		ww_wwdt_sky_marker = obj
	)
	
	if ww_wwdt_sky_marker == undefined then (
		ww_wwdt_sky_marker = getNodeByName "WW Sky Camera"
	)
	if (ww_wwdt_sky_marker == undefined OR isDeleted ww_wwdt_sky_marker) AND create == true do (
	
		ww_wwdt_sky_marker = Box name:"WW Sky Camera" pos:[12288,0,0] renderable:off height:16 width:16 length:16
		
		local skyEnt = wallworm_get_entity_by_name "sky_camera"
		if skyEnt != undefined AND skyEnt.ca != undefined then (
			
			custAttributes.add ww_wwdt_sky_marker skyEnt.ca
			
			if isProperty ww_wwdt_sky_marker "wwmt_scale" == true then (
				ww_wwdt_sky_marker.wwmt_scale = (setScale as integer)
			)
			if isProperty ww_wwdt_sky_marker "entcolor" AND ww_wwdt_sky_marker.entcolor != undefined AND classOf ww_wwdt_sky_marker.entcolor == color then (
						ww_wwdt_sky_marker.wireColor = ww_wwdt_sky_marker.entcolor
			) else (
						ww_wwdt_sky_marker.wireColor = (color 200 200 255)
			) 
			
			
		) else (

			ww_wwdt_sky_marker.wirecolor = color 200 200 255
					
			local GLBPntData = "sky_camera,angles,scale,fogenable,fogblend,use_angles,fogcolor,fogcolor2,fogdir,fogstart,fogend"
			local GLBPntValu = ",0 0 0,"+(setScale as string)+",0,0,0,255 255 255,255 255 255,1 0 0,500.0,2000.0"

				
			setUserProp ww_wwdt_sky_marker "GLBPntData" GLBPntData
			setUserProp ww_wwdt_sky_marker "GLBPntValu" GLBPntValu				
		)
		
		select ww_wwdt_sky_marker
		max zoomext sel all
		
		
		
		messagebox "Wall Worm Created a Sky Camera. Press F11 for some helpful tips."
		
		format "###########\n\nWall Worm Created a Sky Camera.\n\nThe Sky Camera is currently selected. Press Z to zoom in on its location.\n\n"
		
		format "Remember to seal in a sky area by tagging world geometry as sky geometry or else the map will leak!\n\n"
		
		format "Here is a page with some more help:\n\nhttp://dev.wallworm.com/topic/45/3d_skybox.html\n\n"

	)
	return ww_wwdt_sky_marker
)


ww_wwdt_sky_marker=undefined


function ww_wwdt_setDispFlags brush noPhys:false noHull:false noRay:false = (
	/*
vmf displacement flags
2 - no phys
4 - no hull collision
8 - no ray collision

*/
	local flags = 0
	if noPhys == true then (
		flags = flags + 2
		)
	if noHull == true then (
		flags = flags + 4
		)
	if noRay == true then (
		flags = flags + 8
	)
		
	if isProperty brush "wallworm" == true AND isProperty brush "ww_displacement" == true AND isProperty brush "dispflags" == true then (
		brush.dispflags = flags
	) else (
		setUserProp brush "wwdt_displacement_flags" flags
	)
)

function ww_wwdt_getDispFlags brush  = (
	local flags = getUserProp brush "wwdt_displacement_flags"
	if flags == undefined then (
		flags = 0
	) else ()
	return flags
)

function ww_wwdt_setDispFlagsArray brushes noPhys:false noHull:false noRay:false = (
	for brush in brushes where (getUserProp brush "ww_wwdt_displacement" != undefined) AND (getUserProp brush "ww_wwdt_displacement" == true) do (
		ww_wwdt_setDispFlags brush noPhys:noPhys noHull:noHull noRay:noRay
		)
)

function ww_wwdt_setSkyScale amount:16 create:true= (
	
	ww_wwdt_sky_marker=ww_wwdt_get_sky_marker create:create
	if ww_wwdt_sky_marker != undefined AND isDeleted ww_wwdt_sky_marker == false then (
		setUserProp ww_wwdt_sky_marker "wwdt_sky_scale" amount
	
		if isProperty ww_wwdt_sky_marker "wwmt_scale" then (
		
			ww_wwdt_sky_marker.wwmt_scale =  amount
		)
		
	)
	
	
	
)

function ww_wwdt_getLightmapscale_faces obj = (
	global wallworm_temporary_face_array = #()
	local faceArray 
	local faceArrayString = (getUserProp obj "wwdt_lightmapscale_faces") as string
	if faceArrayString != undefined then (
		local ex = "global wallworm_temporary_face_array = "+faceArrayString
		execute ex
		faceArray = wallworm_temporary_face_array
	) else ()
	if faceArray == undefined then (
		faceArray = #()
		) else ()
		
	wallworm_temporary_face_array = undefined	
	return faceArray
)

function ww_wwdt_setLightmapscale obj amount:16 = (

			if SuperClassOf obj == ObjectSet then (
			
			 for oo in obj do (
				 
				 ww_wwdt_setLightmapscale oo amount:amount
				 )
				 
				 
			) else (
				 
				 
				 if isProperty obj "wallworm" == true AND isProperty obj "ww_displacement" AND isProperty obj "lightmapScale" then (
					 obj.lightmapScale = amount
				) else (
					 
				local brush = (ww_wwdt_getBrushFromDisp obj)
				if brush != undefined then (
					setUserProp brush "wwdt_lightmapscale" amount
				) else (
					local temp = convertToPoly (copy obj)
					if isDeleted obj == false AND superClassOf obj == GeometryClass AND (((polyOp.getFaceSelection temp as array).count > 0)) then (
						--storeSub = subobjectLevel



						
					
						local newfaceArray = polyOp.getFaceSelection temp
						local oldFaceArray = ww_wwdt_getLightmapscale_faces obj 
						--print oldFaceArray
						for i = 1 to temp.numfaces do (
							
							if newfaceArray[i] == true then (
								oldFaceArray[i] = amount
							)
							
						)

						setUserProp obj "wwdt_lightmapscale_faces" oldFaceArray
						

						
						) else (
							
							setUserProp obj "wwdt_lightmapscale" amount
						)
						delete temp
					)
					
					
				)	
			)

)





function ww_wwdt_getLightmapscale obj  = (
	local amount
		
	local brush = (ww_wwdt_getBrushFromDisp obj)
	if brush != undefined then (
		amount = getUserProp brush "wwdt_lightmapscale"
	) else (
		amount = getUserProp obj "wwdt_lightmapscale"
		
		)
	if amount == undefined then (
		--amount = 16
		) else ()
	return amount
	
	
)


/*
--"dev/dev_measuregeneric01"
--global ww_wwdt_defaultMat = MultiMaterial numsubs:6 name:"nature/blendcliffgrass001a"
	ww_wwdt_grassBmp = openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/dirtfloor002a.tga"
	ww_wwdt_stoneBmp =  openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/cliffface002a.tga"
	
	ww_wwdt_grasstex = bitmaptexture bitmap:ww_wwdt_grassBmp filename:ww_wwdt_grassBmp.filename
	ww_wwdt_stonetex = bitmaptexture bitmap:ww_wwdt_stoneBmp filename:ww_wwdt_stoneBmp.filename
	*/
	if ww_d9_shadermat == undefined OR classOf ww_d9_shadermat != DirectX_9_Shader then (
		/*
		if(MaxVersion())[1]  >= 16000 then (
			ww_d9_shadermat = DirectX_9_Shader effectFilename:"$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/fx/blend_dxsas11_nitrous.fx" name:"nature/blendcliffgrass001a" 
			ww_d9_shadermat.TextureTop = ww_wwdt_grassBmp
			ww_d9_shadermat.TextureBottom = ww_wwdt_stoneBmp
			
		) else (
			ww_d9_shadermat = DirectX_9_Shader effectFilename:"$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/fx/blend_dxsas.fx" name:"nature/blendcliffgrass001a" 
			ww_d9_shadermat.seteffectbitmap 1 ww_wwdt_grassBmp
			ww_d9_shadermat.seteffectbitmap 2 ww_wwdt_stoneBmp				
			
		)
		*/

		ww_d9_shadermat = wallworm_blend_to_DXBlend mat:ww_d9_shadermat
		
	)

	--ww_d9_shadermat.renderMaterial =  Blend map1:(Standard diffusemap:(ww_wwdt_grasstex) showInViewport:true  name:"nature/dirtfloor002a" ) map2:(Standard diffusemap:(ww_wwdt_stonetex) showInViewport:true  name:"nature/cliffface002a" ) showInViewport:true  name:"nature/blendcliffgrass001a" 

	wallworm_get_ww_displibrary()
	global wallwormMaterialDisplacementLibrary
	
	if wallwormMaterialDisplacementLibrary==undefined OR wallwormMaterialDisplacementLibrary.count == 0 then (
	global ww_wwdt_defaultMat = ww_d9_shadermat
	) else (
		global ww_wwdt_defaultMat =  wallwormMaterialDisplacementLibrary[wallwormMaterialDisplacementLibrary.count]
	)
	
	
	

	--global ww_wwdt_paint 

	--global ww_wwdt_poly 
	
	
 	if ww_wwdt_paint == undefined do (
 		ww_wwdt_paint = VertexPaint name:"WW Vertex Paint Modifier" mapChannel:-2
 	)

-- 	if ww_wwdt_poly == undefined do (
-- 		ww_wwdt_poly = Edit_Poly name:"WW Displacement Poly Mod"
-- 	)
-- 	
	
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

function wallworm_find_displacement_mesh = (
	
	theMesh = getNodeByName "WW Displacement Controller"
	if theMesh == undefined then (
		/*
		for obj in objects where (getUserProp obj "wwdt_displacement_array" != undefined) do (
			
			return obj
			
			)
		*/
		) else (
			return theMesh
		)
	
	return undefined
	
	)
	
	


function wwdt_lock_displacement_transforms = (
		for disp in objects where (getUserProp disp "ww_wwdt_displacement_brush" != undefined)  do (
			setTransformLockFlags disp #all
		)
	)

function wwdt_unlock_displacement_transforms = (
		for disp in objects where (getUserProp disp "ww_wwdt_displacement_brush" != undefined)  do (
			setTransformLockFlags disp #{7,8,9}
		)
	)	
		
function wwdt_fixVertPosZ obj = (
					
		for v =  1 to (polyop.getNumVerts obj) do (
				originalMeshVert = polyop.getVert obj v
				nowPos 	= [originalMeshVert[1],originalMeshVert[2],obj.pos.z]
				polyop.setVert obj v nowPos 
		)
							
							
)	

function  ww_wwdt_createControlMesh selin = (
	global wallworm_debug
	
	if wallworm_debug != undefined AND wallworm_debug == true then (
	
			local start = timestamp()
		
	)
		
	max create mode
	/*
	if theHold.Holding() == false then (
		theHold.Begin()
	)
*/
	
	if selin == undefined OR selin.count == 0 do (
		return false
	)
	with redraw off
	with undo off  (
		
	disableRefMsgs()
	sel = (selin as array)
	sel = makeUniqueArray sel
	

	local pv_getNumVerts = polyop.getNumVerts
	local pv_attach = polyop.attach
	local pv_getVert = polyop.getVert
	
	--ww_wwdt_delete_all_handlers()
	--with undo off (
	/*
	if ww_wwdt_control_mesh != undefined AND isDeleted ww_wwdt_control_mesh ==false do (
		--if there is already a mesh assigned to the global variable, delete it
		print "deleting control mesh"
		delete ww_wwdt_control_mesh
	)			
	*/
	
	--variable to store the Controller Mesh (will be created from displacement meshes in sel)
	local theController = undefined
	
	
	local maparray = #()
	local notFound = #()

	for orig in sel do (
		addModifier orig (VertexPaint mapChannel:-2)
		convertToPoly orig
		local theOrigVerts = pv_getNumVerts orig
		local theverts = #{1..theOrigVerts} as array
		/*for i = 1 to theOrigVerts do (
			append theverts i
			
			)*/

		--print theverts
		
		
		append maparray #(orig,theverts,#(#(),#()))

		--setUserProp orig "wallworm_is_updating" "true"	
		--setUserProp orig "wallworm_ignore_event_propagation" "true"	
		--use a copy of the orig for merging into the controller mesh
		obj = snapshot orig  --copy orig
		/*
		if obj.brushNode != undefined AND isDeleted obj.brushNode == false then (
			setUserProp obj.brushNode "ww_wwdt_displacement_target" ""
			setUserProp obj.brushNode "wallworm_is_updating" "false"	
			setUserProp obj.brushNode "wallworm_ignore_event_propagation" "false"		
			delete obj.brushNode
		)
			
		setUserProp orig "wallworm_is_updating" "false"	
		setUserProp orig "wallworm_ignore_event_propagation" "false"		
		setUserPropBuffer obj ""
		*/
		--resetXForm obj	


			
		
		if theController == undefined then (
			
			theController = Editable_Mesh transform:(matrix3 1)
			
			theController.name = uniqueName "DisplacementSculptMesh"
			/*setUserProp obj "wallworm_ignore_event_propagation" "true"
			resetXForm theController	
			
			oldState = custAttribCollapseManager.surviveState
			custAttribCollapseManager.surviveState = false
				
			
			custAttribCollapseManager.surviveState = oldState

			local c = custAttributes.count theController -- [BaseObject:<bool>]
				if c > 0 then (
					for i = c to 1 by -1 do (
							custAttributes.delete theController i
					)
				)
			*/

			convertToPoly theController

				
		) else (



			--in coordsys world theController.attach obj --targetNode:theController sourceNode:obj
			
			
		)
		
		in coordsys theController pv_attach theController obj --targetNode:theController sourceNode:obj		
		
		
	)
		

		
		--convertToPoly theController

		local vs = pv_getNumVerts theController
		
		theController.weldThreshold = 1
		polyop.weldVertsByThreshold theController #{1..vs}

	
			vs = pv_getNumVerts theController
		--	local checkFromSource = #{1..vs} --as array -- create an array to store all the vertices in the control mesh
	
			--theController is a poly mesh created from all the objects that are stored in the maparray below
			in coordsys world (
			
			local controlVerts = #()
		--	local controlDistances = #()
			
			--controlVerts = for i to vs collect (pv_getVert theController i)
				
			--controlDistances = for i to vs collect (pv_getVert theController i)
				
			for i = 1 to vs do (
				
				--local pt = (pv_getVert theController i)
				
				append controlVerts #((length (pv_getVert theController i)),i)
				
				--local dist = distance pt [0,0,0]
				--append controlDistances dist
				
			)
			
				fn compareFN v1 v2 =

				(

					
				local d = ( v1[1])-(v2[1])

				case of

				(

				(d < 0.): -1

				(d > 0.): 1

				default: 0

				)

				)

				

			qsort controlVerts compareFN 

			
			--local good = 0
			--local bad = 0 
			

			with redraw off 
			for maps in maparray do (
			

				for ov in maps[2]  do (
					--maps is an array structured like this:  #(originalMeshObject,arrayOfVerticesInMesh,#(#(),#()))
					dispvert = pv_getVert maps[1] ov --get vertice from original mesh
					local toOrigin = length dispvert
					

					
					local minIndex = 1
					local maxIndex = vs
					local midIndex = (floor ((minIndex+maxIndex)/2)) as integer
					
					local searchValue = toOrigin - 1.0
					
					

					do (
						

						
						midValue = controlVerts[midIndex][1]
						
					
						
						if midValue < searchValue then (
							minIndex = midIndex
						) else (
							maxIndex = midIndex
						)
						
						midIndex = (floor ((minIndex+maxIndex)/2)) as integer
						
						--format "###########\nMin\t%\nMid\t%\nMax\t%\n" minIndex midIndex maxIndex
						
					) while ( minIndex != midIndex)
					
					
					
					local nf = true
					
					for i=minIndex to vs while nf do (		
						theVert = pv_getVert theController controlVerts[i][2] --get vertice from the control mesh
						--local pt = (pv_getVert theController i)
						
						
						--if ((abs (dispvert.x - theVert.x ) < 1) AND (abs (dispvert.y - theVert.y) < 1) AND (abs (dispvert.z - theVert.z) < 1)) then (
						if (distance dispvert theVert) < 1 then (
							append maps[3][1] controlVerts[i][2] --record the control mesh vertice
							append maps[3][2] ov --record the original vertice
							--checkFrom[i] = false
							--deleteItem checkFrom (findItem checkFrom i) --delete item from the checkFrom array to reduce overhead in next iteration
							nf = false
						) else()
					)


					
					
					
					
					
				)
				
				
			)
	
		)


		
		--ww_wwdt_control_mesh = theController
		

		--format "There were % GOOD and % BAD\n" good bad
		
		--setUserProp theController "wwdt_displacement_array" selArray  --store the objects used to make this mesh in case they need to be retrieved
		setTransformLockFlags theController #all
		theController.pivot = theController.center
		

		select theController

		--store the map in the global variable
		---ww_wwdt_map = maparray
		--maparray = undefined
		controlVerts = undefined
		gc()


			
		
		wallworm_sculpt_mesh_handlers theController

		

		global wallworm_displacement_edit_disp_CA
		custAttributes.add theController wallworm_displacement_edit_disp_CA
		

		theController.displist = sel
		
		theController.setArrayMap maparray
		
		theController.vertCount = vs
		
		theController.bakeMapArrayString()
		theController.hideAllParts()
		setUserProp theController "wallworm_ignore_event_propagation" "false"
		
		--ww_wwdt_setDispHandlers deleteFirst:false
		
		enableRefMsgs()
		--theHold.Accept "Create Displacement Control Mesh"
		)		
		if wallworm_debug != undefined AND wallworm_debug == true then (
		
				local end = timestamp()
			
				local total = (end - start) / 1000
				local minutes = floor (total / 60)
				local seconds = mod total 60
				format "Sculpt Mesh created in %:% (% total seconds)\n" minutes seconds total
			
		)
		
		redrawviews()
	)

	
	
	function ww_wwdt_commit_edit ctr = (
		if theHold.Holding() == false then (
			theHold.Begin()
		)
		disableRefMsgs()
		
		
		local pv_getVert = polyop.getVert
		local pv_setVert = polyop.setVert
		
		
		local vc = false
		
		if (maxVersion())[1] >= 12000 do (
			
			vc = true
			local pv_setVertColor = polyop.setVertColor


		)
		

		
		--with undo off (
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
				
			
			--polyop.setMapSupport ctr 1 true
				
				
			if isProperty ctr "dispMapArray" == true then (
				
				
				ww_wwdt_mapA = ctr.dispMapArray
				
			) else (
				
				ww_wwdt_mapA = ww_wwdt_map
			)	
				

			convertToPoly ctr	
				
				
			if ww_wwdt_mapA != undefined AND ww_wwdt_mapA.count > 0 do (
				--execute ("theArray = "+thear)
				
				--print ww_wwdt_map
				--Trgt = Point pos:[0,0,0]
				
				
				
				for wwdt in ww_wwdt_mapA where (isDeleted wwdt[1] ==false) do (
					unhide wwdt[1]
				    --setTransformLockFlags wwdt[1] #none
					setTransformLockFlags wwdt[1] #{7,8,9}
					for i=1 to wwdt[3][2].count do (
						--wwdt is a displacement tool disp pait
						-- wwdt[1] = displacement
						--wwdt[2] = brush
						local controlMeshVert = pv_getVert ctr wwdt[3][1][i]
						--local originalMeshVert = pv_getVert wwdt[1] wwdt[3][2][i]   
						--
						
						--format "CONTROL MESH (%): % %    --- ORIGINAL MESH (%): % %\n\n" ctr.name ar[3][1][i] controlMeshVert ar[1].name ar[3][2][i] originalMeshVert
						
		
						--dist = distance originalMeshVert controlMeshVert
						--if dist == 0.0 then (
							--unitVector = [0,0,1]
							--print "no move"
						--) else (
							--format "Move obj % vert # % FROM % to %\n" ar[1].name i originalMeshVert controlMeshVert
							pv_setVert wwdt[1] wwdt[3][2][i] controlMeshVert 
						
						
							
							-- node:ar[1]
							--unitVector = normalize (controlMeshVert-originalMeshVert
						--)
						if vc == true do (
							ctr.SetSelection #Vertex #{(wwdt[3][1][i])}
							local theVertColor =ctr.getVertexColor #Alpha
							pv_setVertColor wwdt[1] -2 wwdt[3][2][i] theVertColor
						)
						

					)

					/*Iterate over UVW coords and copy
					
					This will require mapping the original map verts to the control mesh map verts... which is not yet implemented.
					*/
					
					--polyop.setMapSupport ctr 1 true

				)
				delete ctr

			)
			/*
			global ww_wwdt_control_mesh
			
			if ww_wwdt_control_mesh != undefined AND isDeleted ww_wwdt_control_mesh == false then (
				
					delete ww_wwdt_control_mesh
			)
			
			ww_wwdt_control_mesh = undefined*/
		--)
		--)
		enableRefMsgs()
		theHold.Accept "Exit Displacement Edit Mode"
			
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

	wallworm_move_displacement_mode false
	local theDisp = #()				

	if selection.count > 1 then (
		 
		useSel = selection as array
		
	) else (
		
		useSel = objects as array
	)

	for disp in useSel where (isDeleted disp ==false) AND disp.isHidden == false AND (isProperty disp "ww_displacement" == true  OR   getUserProp disp "ww_wwdt_displacement_brush" != undefined ) do (
		
			if wallworm_is_displacement disp then (
				append theDisp disp
				
				) else (
				
					local bName = getUserProp disp "ww_wwdt_displacement_brush" 
					if bName != undefined do (


						append theDisp disp
						--changeMode disp "edit"
					)				
				)
		

		)
		
		theDisp = makeUniqueArray theDisp
	
	    --select theDisp
		
		--print (theDisp.count as string)
		
		ww_wwdt_createControlMesh theDisp
		
		try(
			macros.run "PolyTools" "PaintDeformPushPull"
			) catch()

	)
	
	
	function wallworm_find_all_sculpt_meshes = (
		
		objs = for obj in objects WHERE isProperty obj "wallworm_edit_mesh" == true collect obj
		objs
	)
	
	function wallworm_is_object_in_sculptmesh obj meshArray:undefined= (
		
		if meshArray == undedfined then (
			meshArray = wallworm_find_all_sculpt_meshes()
		)
		for msh in meshArray do (
				if findItem msh.displist obj != 0 then (
					return msh
				)
		)
		
		return undefined
	)

function ww_wwdt_paintMode = (
	disablesceneredraw()
	--theDisp = #()
	
	/*
	!TODO
	
	find all edit meshes... and apply vertex paint to them ,,, then the disps*/
	/*meshArray = wallworm_find_all_sculpt_meshes()
	
	if meshArray.count > 0 then (
		
		for msh in meshArray do (
			addModifier msh (VertexPaint name:"WW Blend Paint" mapChannel:-2)
		)
		
	)
	
	
	for disp in objects where (isDeleted disp ==false) AND (wallworm_is_object_in_sculptmesh obj meshArray:meshArray) == undefined do (
			local bName = getUserProp disp "ww_wwdt_displacement_brush"
		
			if bName != undefined do (
				append theDisp disp
				changeMode disp "texture"
				
			)
		)
		*/
		
		allSculpts = wallworm_find_all_sculpt_meshes()
		
		
		with undo off (		
			theDisplacements = for obj in objects WHERE isProperty obj "wallworm_edit_mesh" == true OR (((isProperty obj "ww_displacement" == true) OR (getUserProp obj "ww_wwdt_displacement_brush") != undefined)  AND (wallworm_is_object_in_sculptmesh obj meshArray:allSculpts) == undefined ) collect obj
		
			if theDisplacements.count > 0 then (
				addModifier theDisplacements ww_wwdt_paint
				select theDisplacements
			)
		
		

			
		)
		enablesceneredraw()
		redrawviews()
	)

	
	
function ww_wwdt_sewSelected sel = (
	
	max create mode
	
	if theHold.Holding() == false then (
		theHold.Begin()
	)

	disableSceneRedraw()
	disableRefMsgs()
	local posStore = #()	
	local tempPosStore = #()	
	local brushList = #()	
	--local refNode = undefined
	--with undo off
	local pv_getVert = polyop.getVert
	local pv_moveVert = polyop.moveVert
	
	in coordsys world   (
	for disp in sel where (isDeleted disp ==false) AND isProperty disp "brushNode" == true do (
		
		local b
		
		if isProperty disp "brushNode" then (
				b = disp.brushNode
				power = disp.power
		) else (
			local brushName = getUserProp disp "ww_wwdt_displacement_brush"
			if brushName != undefined do (
				 b = getNodeByName  brushName
				if b != undefined then (
					power = getUserProp b "ww_wwdt_power"
				)
			)
		)
		
			if b !=undefined AND isDeleted b == false do (
				
				--if refNode == undefined do (
					--refNode = b
				--)

				--convertto b editable_poly
				--convertto disp editable_poly
				
				
				appendIfUnique brushList #(b,disp) 
				
				
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
								tpos = pv_getVert b vert   node:b
							
								/*
								If the position hasen't been found yet, add it to the tempstore list
								*/
								if findItem tempPosStore tpos > 0 then (
									append posStore tpos
								) else (
									/*
									Place the position in the tempstore
									*/
									
									nf = true
									for tps in tempPosStore while nf == true do (
										
										if distance tps tpos < 1 then (
											append posStore tpos
											nf = false
											)
										
										)
									
									if nf == true then (
										appendIfUnique tempPosStore tpos
									)
								)
							
							--)
						)
				--)
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

	for v in posStore do (
		objStore[ind] = #()

		for br in brushList do (
			
			
			vertexAt = false
			for bv = 1 to br[1].GetNumVertices() while vertexAt==false do (
				
				--local vagainst = (polyop.getVert br[1] bv)
				localv = pv_getVert br[1] bv  node:br[1]
				if localv== v then (
				
				--if ( (close_enough vagainst[1] v[1] 0.6) AND (close_enough vagainst[2] v[2] 0.6) AND (close_enough vagainst[3] v[3] 0.6) ) do (
					appendIfUnique objStore[ind] #(br[2],bv)
					vertexAt = true
				) else (
					
					if distance localv v < 1.0 do (
						
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
				currentPos = pv_getVert s[1] s[2]   node:s[1]
				avPos = avPos + currentPos
			)
			avPos = avPos / ar.count
			for s in ar do (
				currentPos = pv_getVert s[1] s[2]  node:s[1]
				vec = (avPos-currentPos)	
				if dist != 0.0 do (
					pv_moveVert s[1] s[2] (vec) node:s[1]
				) 	
			)
		)
	)
)




	enableRefMsgs()
	enableSceneRedraw()
	redrawviews()
	--messagebox "Selected Displacements Sewn"
	if theHold.Holding() == false then (
		theHold.Begin()
	)
	theHold.Accept "Sew Displacements"
	forceCompleteRedraw()
	objStore
)
	
	
	


	
function wwdt_bind_disp_to_brush disp brsh p l w  = (
	
	setUserProp disp "ww_wwdt_displacement_brush" brsh.name
	setUserProp brsh "ww_wwdt_displacement" "true"
	setUserProp brsh "ww_wwdt_displacement_target" disp.name

	
	setUserProp brsh "ww_wwdt_power" (p as string)
	setUserProp brsh "ww_wwdt_length" (l as string)
	setUserProp brsh "ww_wwdt_width" (w as string)
	
	
	
	
	
	
	--brsh.xray=on
	brsh.renderable = off
	setTransformLockFlags brsh #all
	
	
	
	hide brsh
	
	disp.parent = brsh
	if isProperty disp "brushNode" == true then (
		disp.brushNode = brsh
	)
	
	/*
	No longer using param wiring.
	
	paramWire.connect2way disp.pos.controller[#X_Position] brsh.pos.controller[#X_Position] "X_Position" "X_Position"
	paramWire.connect2way disp.pos.controller[#Y_Position] brsh.pos.controller[#Y_Position] "Y_Position" "Y_Position"
	paramWire.connect2way disp.pos.controller[#Z_Position] brsh.pos.controller[#Z_Position] "Z_Position" "Z_Position"
	paramWire.connect2way disp.rotation.controller[#X_Rotation] brsh.rotation.controller[#X_Rotation] "X_Rotation" "X_Rotation"
	paramWire.connect2way disp.rotation.controller[#Y_Rotation] brsh.rotation.controller[#Y_Rotation] "Y_Rotation" "Y_Rotation"
	paramWire.connect2way disp.rotation.controller[#Z_Rotation] brsh.rotation.controller[#Z_Rotation] "Z_Rotation" "Z_Rotation"
	paramWire.connect2way disp.transform.controller[#Scale] brsh.transform.controller[#Scale] "Scale" "Scale"
	*/
	
	--wwdt_alignVertexToGrid brsh (ww_wwdt_getEdgeVerts p) 
	--wwdt_alignVertexToGrid disp (ww_wwdt_getEdgeVerts p) 
	

	
	
	ww_wwdt_setchangehandlers disp brsh
		

		
	
	)	
	
	function wallworm_autoEdgeobj obj convertToP:true= (
		oldClass = classof obj
		if oldClass != editable_mesh then (
				convertToMesh obj
		)
		notDone = true
		while notDOne do (
			local edges = obj.Edges
			
			meshop.autoEdge obj edges 0 type:#SetClear

			if edges.count == (obj.Edges).count do (
				notDone = false
				)
			
			)	
		
		if convertToP == true then (
			convertToPoly obj
		) else (
			if oldClass != editable_mesh AND canConvertTo obj oldClass then (
					convertTo obj oldClass
			)
		)	
	)
	
	function wallworm_quadrify_all objs:selection= (

		if objs != undefined AND objs.count>0 then (
			oldSel = objs
			for obj in objs do (
				select obj
				PolyToolsModeling.Quadrify false false		
			)
			select oldSel
			return true
		)
		false
	)
	
	
function wallworm_displacement_brush_bind disp brsh p l:128 w:128 skipCA:false= (
		wwdt_bind_disp_to_brush disp brsh	p l w

		--converttoPoly disp
		setTransformLockFlags disp #{7,8,9}
		setTransformLockFlags brsh #{7,8,9}			
		
		if NOT skipCA then (
			global wallworm_displacement_CA
			custAttributes.add disp wallworm_displacement_CA 
			disp.power = p	
			disp.brushNode = brsh
		)	
			global wallworm_displacement_brush_node_CA
			custAttributes.add brsh wallworm_displacement_brush_node_CA
			brsh.power = p


)
	
	
function wallworm_retriangulate_displacement disp = (
	
	disp.SetSelection #Face #{1..disp.numFaces}
	disp.retriangulate 1
	
	/*
	for i = 1 to disp.numFaces do (
	
			disp.setDiagonal i 1 3
		
	)*/
	
	
	case of (
		
		(disp.power==2) :(
			facesToRetriangulate = #{2, 4..5, 7, 10, 12..13, 15}
			fcount = 16
			ecount = 96
		)
		(disp.power==3) : (
			facesToRetriangulate =#{2, 4, 6, 8..9, 11, 13, 15, 18, 20, 22, 24..25, 27, 29, 31, 34, 36, 38, 40..41, 43, 45, 47, 50, 52, 54, 56..57, 59, 61, 63}
			ecount = 144
			fcount = 64
			)
		(disp.power==4 ): (
			facesToRetriangulate =#{2, 4, 6, 8, 10, 12, 14, 16..17, 19, 21, 23, 25, 27, 29, 31, 34, 36, 38, 40, 42, 44, 46, 48..49, 51, 53, 55, 57, 59, 61, 63, 66, 68, 70, 72, 74, 76, 78, 80..81, 83, 85, 87, 89, 91, 93, 95, 98, 100, 102, 104, 106, 108, 110, 112..113, 115, 117, 119, 121, 123, 125, 127, 130, 132, 134, 136, 138, 140, 142, 144..145, 147, 149, 151, 153, 155, 157, 159, 162, 164, 166, 168, 170, 172, 174, 176..177, 179, 181, 183, 185, 187, 189, 191, 194, 196, 198, 200, 202, 204, 206, 208..209, 211, 213, 215, 217, 219, 221, 223, 226, 228, 230, 232, 234, 236, 238, 240..241, 243, 245, 247, 249, 251, 253, 255}
			ecount = 544
			fcount = 256
		)
	)
		
		for i in facesToRetriangulate do (
			--print i
			disp.TurnDiagonal i 1
		)
	
	
)
	
	
/*Function to create a WW displacement. If brsh is not undefined, one is created as pos; otherwise, brsh is used as the base.*/	
function  ww_wwdt_makeDisplacement p l w pos mat:undefined brsh:undefined showBrush:false matId:undefined hold:true= (
	--if ww_wwdt_control_mesh != undefined then return #(undefined, undefined)
	/*
	if hold == true then (
		if theHold.Holding() == false then (
			theHold.Begin()
		)
	)*/
	with undo off (
	segs = ww_wwdt_vmfpowertosegs p
	

	local createDisp = true
		
	allowedDImensions = #(2,3,4)
	
	
	
	--print brsh.lengthsegs
	-- AND (findItem allowedDImensions brsh.lengthsegs != 0)
	if brsh != undefined  then (
		
		createDisp = false
		
		if classOf brsh == Plane then (
		l = brsh.length
		w = brsh.width
		segs = brsh.lengthsegs
		case  of (
			
			(brsh.lengthsegs==4):p=2
			(brsh.lengthsegs==8):p=3
			(brsh.lengthsegs==16):p=4
			default:p=2
			
			)
		)
		
		if brsh.mat != undefined then (
			mat = brsh.mat
			
			)
			
			--brsh.mat = undefined
		) else (
		
		)
		
	if createDisp == true then (	
		
		if pos == undefined AND ww_wwdt_last_disp_position != undefined then (
			pos=ww_wwdt_last_disp_position
		) else (
			
			  if pos == undefined then (
				  pos = [0,0,0]
				  )
			--
			)
		if l == undefined then l = 512
		if w == undefined then w = 512
			
		local brsh = Plane length:l width:w isSelected:off lengthsegs:segs widthsegs:segs pos:pos	
	)
	brsh.name =(uniqueName  "WW_Displacement_Brush_")
	brsh.wirecolor = random (color 0 0 0) (color 255 255 255) 


	--modi = Smooth smoothingBits:1	
	--addModifier brsh modi	


	addModifier brsh (VertexPaint mapChannel:-2)
	
	converttoPoly brsh
	
	
	if matId != undefined then (
		local fs = #{1..brsh.numfaces}
		polyop.setFaceMatID brsh fs matId
	)
	--resetXForm brsh
	ww_wwdt_last_placed_brush = brsh	
		
	--ww_wwdt_last_disp_position = ww_wwdt_last_placed_brush.pos	
	
	--#("Ground","Hill","Open Hill","Ring","Corner","Cube")

	--resetXform brsh
		

	
	disp = copy brsh
	
	brsh.makePlanar #Object
	
	--brsh.dispNode = disp
	
	
	disp.wirecolor	= brsh.wirecolor
	
	--channelInfo.addChannel disp
 	--channelInfo.update()
		
	
	
	disp.name =(uniqueName  ("WW_Displacement_"))

	
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
	
		/*
		convertToMesh disp

		notDone = true
		while notDOne do (
			local edges = disp.Edges
			
			meshop.autoEdge disp edges 0 type:#SetClear

			if edges.count == (disp.Edges).count do (
				notDone = false
				)
			
			)
		*/
		
		wallworm_displacement_brush_bind disp brsh p l:l w:w

		if showBrush == true then (
				hide disp
				unhide brsh
		)
/*
	if hold == true then (
		theHold.Accept "Create Displacement"	
	)*/
)
	return #(disp,brsh)

)	


/*This function gets called when a displacement is copied.*/
function wwdt_copy_displacement objs =
(

	for disp in objs[2] WHERE isProperty disp "wallworm_edit_mesh" == true  do (
			setUserProp disp "wallworm_is_updating" "true"
			setUserProp disp "wallworm_ignore_event_propagation" "true"
			local c = custAttributes.count disp -- [BaseObject:<bool>]

			local myinstances
			InstanceMgr.getinstances disp &myinstances
		
			InstanceMgr.MakeObjectsUnique &myinstances #individual 
		
		
			disp.name = uniqueName "WW Ref Mesh "
			setTransformLockFlags disp #none
			if c > 0 then (
				for i = c to 1 by -1 do (
					def = custAttributes.getDef disp  i 
					if def.name == "Wallworm Displacement Sculpt Mesh" then (

						
						custAttributes.delete disp i
						
							
					)
					
				)
			)

	)
	
	
		for disp in objs[2] WHERE (getUserProp disp "wallworm_is_updating" == undefined OR getUserProp disp "wallworm_is_updating" == false OR getUserProp disp "wallworm_is_updating" == "false") AND  (isProperty disp "brushNode" == true OR  getUserProp disp "ww_wwdt_displacement_brush" != undefined OR getUserProp disp "ww_wwdt_displacement_target" != undefined) do (
			local s = undefined 

			
			--max create mode
			
			local myinstances
			InstanceMgr.getinstances disp &myinstances
			InstanceMgr.MakeObjectsUnique &myinstances #individual 
		
			
			
			

			if getUserProp disp "ww_wwdt_displacement_target" != undefined then (
				
				

				--ww_wwdt_delete_all_handlers()
				
				--ww_wwdt_setDispHandlers()
				
				dispname = getUserProp disp "ww_wwdt_displacement_target"
					
				if dispName != undefined then (
					mydisp = getNodeByName  dispName
				)
				
				
				
				newc = copy mydisp
				

				
				
				
				
				if isDeleted newc.brushNode == false then (
					setUserProp newc.brushNode "wallworm_is_updating" "true"
					setUserProp newc.brushNode "ww_wwdt_displacement_target" undefined
					
					setUserProp newc.brushNode "wallworm_ignore_event_propagation" "true"

					try (
					delete newc.brushNode
					) catch (
						--ignore delete error scripts (like px.
					)
				)
				
				
				hide newc
				newc.brushNode = disp
				unhide newc.brushNode
				
				setUserProp disp "ww_wwdt_displacement_target" newc.name
				
				newc.parent = disp
				newc.pos = disp.pos
				
				
				setTransformLockFlags newc #all
				setTransformLockFlags newc.brushNode #{7,8,9}
				
				
				setUserProp newc  "ww_wwdt_displacement_brush" newc.brushNode.name
				
				/*
				local c = custAttributes.count disp -- [BaseObject:<bool>]

					if c > 0 then (
						
						
						for i = c to 1 by -1 do (
							
							--atsget = custAttributes.get  obj  i   --BaseObject:true
							


								custAttributes.delete disp i

							
						)
						
					)
				
				
				--copying a brush
				
				
				
				
				
				paramWire.disconnect2way disp.pos.controller[#X_Position] mydisp.pos.controller[#X_Position]
				paramWire.disconnect2way disp.pos.controller[#Y_Position] mydisp.pos.controller[#Y_Position]
				paramWire.disconnect2way disp.pos.controller[#Z_Position] mydisp.pos.controller[#Z_Position]
				paramWire.disconnect2way disp.rotation.controller[#X_Rotation] mydisp.rotation.controller[#X_Rotation]
				paramWire.disconnect2way disp.rotation.controller[#Y_Rotation] mydisp.rotation.controller[#Y_Rotation]
				paramWire.disconnect2way disp.rotation.controller[#Z_Rotation] mydisp.rotation.controller[#Z_Rotation]
				paramWire.disconnect2way disp.transform.controller[#Scale] mydisp.transform.controller[#Scale]
							
							
				
				
				if isProperty mydisp "brushNode" then (
					p = mydisp.power
					--mydisp.brushNode = brsh
				) else (
							
					p = getUserProp disp "ww_wwdt_power" 
				)
					
						
				l = getUserProp disp "ww_wwdt_length" 
				w = getUserProp disp "ww_wwdt_width" 

				
				setUserProp disp "ww_wwdt_displacement_target" ""
				

				setUserProp disp "wallworm_is_updating" "true"				

				
				
				--setUserPropBuffer disp ""
				

				
				
				

					
				disp.name = uniqueName "WW_Displacement_Brush_"
						
				
				
				ww_wwdt_makeDisplacement p l w disp.pos mat:mydisp.mat brsh:disp
				
				
				setUserProp disp "wallworm_is_updating" "false"

				
				
				*/
				
			) else (
				--copying a displacement
			
			
				if isProperty disp "brushNode" == true then ( 
						
						s=disp.brushNode
						
				) else (
				
					local dispName = getUserProp disp "ww_wwdt_displacement_brush"
					if dispName != undefined then (
							s = getNodeByName  dispName
					)

				)
				
				
				
				if s != undefined AND isDeleted s == false then (

					
						setUserProp s "wallworm_is_updating" "true"
					
						setUserProp s "wallworm_ignore_event_propagation" "true"
					
						brsh = copy s
					
						brsh.pos = disp.pos
					
						setUserProp brsh "wallworm_is_updating" "false"
						setUserProp s "wallworm_is_updating" "false"
					
						if isProperty disp "brushNode" then (
								p = disp.power
								disp.brushNode = brsh
						) else (
							
							p = getUserProp s "ww_wwdt_power" 
						)
					
						
						l = getUserProp s "ww_wwdt_length" 
						w = getUserProp s "ww_wwdt_width" 
/*
				paramWire.disconnect2way disp.pos.controller[#X_Position] s.pos.controller[#X_Position]
				paramWire.disconnect2way disp.pos.controller[#Y_Position] s.pos.controller[#Y_Position]
				paramWire.disconnect2way disp.pos.controller[#Z_Position] s.pos.controller[#Z_Position]
				paramWire.disconnect2way disp.rotation.controller[#X_Rotation] s.rotation.controller[#X_Rotation]
				paramWire.disconnect2way disp.rotation.controller[#Y_Rotation] s.rotation.controller[#Y_Rotation]
				paramWire.disconnect2way disp.rotation.controller[#Z_Rotation] s.rotation.controller[#Z_Rotation]
				paramWire.disconnect2way disp.transform.controller[#Scale] s.transform.controller[#Scale]*/
						/**/
						
						
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
							

						--delete disp
				) else (
				
				print disp
				)
			
			
			)
		)

		
		
)



/*This function is used for legacy purposes to repair old, uncommitted sculpt meshes. No longer needed but keep for older scenes for now.*/
	function wallworm_repair_displacement = (
		
		
		oldControlMesh = wallworm_find_displacement_mesh()
		if oldControlMesh != undefined then (
			
			theOldSelection = getUserProp oldControlMesh "wwdt_displacement_array"
			if theOldSelection != undefined do (
				
				local toExecute = "wallworm_displacement_theOldSelectionList = "+theOldSelection +" as array"
				execute toExecute
				global wallworm_displacement_theOldSelectionList
				--wallworm_displacement_theOldSelectionList = theOldSelection as array
				if wallworm_displacement_theOldSelectionList != undefined AND wallworm_displacement_theOldSelectionList.count > 0 then (
					oldControlMesh.name = "WWDISPTEMPNAME"
					
					local theSelections = #()
					for obj in wallworm_displacement_theOldSelectionList do (
						
						local disp = getNodeByName obj
						if disp != undefined then (
							appendIfUnique theSelections disp
							)
						
						)
					if theSelections.count > 0 then (
						ww_wwdt_createControlMesh theSelections
						global ww_wwdt_control_mesh
						local currentMesh = ww_wwdt_control_mesh
						ww_wwdt_control_mesh = oldControlMesh
						delete currentMesh
						ww_wwdt_commit_edit ww_wwdt_control_mesh
						return true
					)
					)
				)
			
		) else (
				
				return false
				)
		
		return false
		
	)
	

	
/*
wallworm_worldPointToFFD and wallworm_alignPlaneToQuad written by Denis Trofimov
For more discussion on these two functions, see http://forums.cgsociety.org/showthread.php?f=98&t=1073891
*/
fn wallworm_worldPointToFFD p ffd pos = 
  (
  	otm = p.objecttransform
  	mtm = (getModContextTM p ffd)*ffd.lattice_transform.value
  	bmin = getModContextBBoxMin p ffd
  	bmax = getModContextBBoxMax p ffd
  
  	v = (pos * (inverse otm) * mtm - bmin)/(bmax - bmin)
  	v.z = 0
  	v
  )
  
  fn wallworm_alignPlaneToQuad node:selection[1] face:undefined planeDimension:[1,1] = if iskindof node Editable_Poly do 
  (

  	if face == undefined and node.selectedfaces.count > 0 do face = node.selectedfaces[1].index 
  	if face != undefined and (vv = polyop.getfaceverts node face).count == 4 do
  	(
		--theHold.Begin()
		local gv = polyop.getVert
		
  		v1 = gv node vv[1]
  		v2 = gv node vv[2]
  		v3 = gv node vv[3]
  		v4 = gv node vv[4]
  		
  		front = normalize (v1-v2)
  		side = normalize (v2-v3)
  		up = polyop.getfacenormal node face
  		center = polyop.getsafefacecenter node face
  		
  		tm = orthogonalize (matrix3 front side up center)
  		
  		tm = pretranslate tm [0.5, 0.5, 0]
  		p = plane width:1 length:1 widthsegs:planeDimension.x lengthsegs:planeDimension.y transform:tm
  		ffd = FFDBox deformType:1 tension:25.0 continuity:0.0
  		setDimensions ffd [2,2,2]
  		animateall ffd
  		addmodifier p ffd
  		modpanel.setcurrentobject ffd
  		ffd.control_point_1 = ffd.control_point_5 = wallworm_worldPointToFFD p ffd v3
  		ffd.control_point_2 = ffd.control_point_6 = wallworm_worldPointToFFD p ffd v4
  		ffd.control_point_3 = ffd.control_point_7 = wallworm_worldPointToFFD p ffd v2
  		ffd.control_point_4 = ffd.control_point_8 = wallworm_worldPointToFFD p ffd v1

		--theHold.Accept "Create Plane on Quad"
  		return p
  	)
  )
	
  
fn lerp x y s = (x + s * (y - x))
 
 fn wallworm_mxssetedgevisflags m face flags =
 (	
 	setEdgeVis m  face 1 flags[1];
 	setEdgeVis m  face 2 flags[2];
 	setEdgeVis m  face 3 flags[3];
 )
 
function wallworm_setglobalPolyop = (
		global wallworm_SetVert = polyop.setVert
		global wallworm_getVert = polyop.getVert
		global wallworm_getMapVert = polyop.getMapVert
		global wallworm_setMapVert = polyop.setMapVert
		global wallworm_getMapFace = polyop.getMapFace
		global wallworm_getMapSupport = polyop.getMapSupport
	 
)
 
 




 fn wallworm_MakePlaneMesh bottom_left bottom_right top_right top_left  tbottom_left tbottom_right ttop_right ttop_left  alphas:undefined alphaColors:undefined width_segs:4  length_segs:4 =
 (
 	local wverts = width_segs + 1;
 	local lverts = length_segs + 1; 
 	local nverts = wverts * lverts;
 	local nfaces = length_segs * width_segs * 2;
 	local lscalar = 1.0/length_segs;
 	local wscalar = 1.0/width_segs;
 	local len_segs_m1 = length_segs - 1;
 	local wid_segs_m1 = width_segs - 1;
 	
 -- build the coordsys	
 	
 	local xaxis = normalize (bottom_right - bottom_left);
 	local temp =  bottom_left - top_left;
 	local zaxis = normalize (cross temp xaxis);
 	local yaxis = normalize (cross zaxis xaxis );
 	local trans = (bottom_right + bottom_left + top_left + top_right) * 0.25;
 	local tm = (matrix3 xaxis yaxis zaxis trans);
 	
 -- create an empty mesh
 	
 	msh = mesh numverts:nverts numfaces:nfaces;

 	
 -- setup the default mapping channel	
 	
	local setMapSupport = meshop.setMapSupport 
	local setNumMapVerts = meshop.setNumMapVerts
	local setNumMapFaces = meshop.setNumMapFaces
	
 	setMapSupport msh 1 true;
 	setNumMapVerts msh 1 nverts;
 	setNumMapFaces msh 1 nfaces; 
	

	
	setMapSupport msh -2 true;
	setNumMapVerts msh -2 nverts;
	setNumMapFaces msh -2 nfaces; 

	meshop.setVertAlpha msh -2 (#{1..nverts} as array) 1.0
 -- set the transform	
 	
 	msh.transform = tm;
 	
 -- generate the verts	
	
	
	local setMapVert = meshop.setMapVert

	
 	local vi = 1;	-- vert index
 	for i = 1 to lverts do
 	(
 		local iscale = (i-1) * lscalar;
 		
 		local vert_start = lerp bottom_left top_left iscale;
 		local vert_end = lerp bottom_right top_right iscale;	
 		
 		local tvert_start = lerp tbottom_left ttop_left iscale;
 		local tvert_end = lerp tbottom_right ttop_right iscale;	
		
		if alphas != undefined then (
			
			
			/*
			local avert_start = lerp alphas[1] alphas[4] iscale;
			local avert_end = lerp alphas[2] alphas[3] iscale;	*/
			
			local avert_start = lerp alphaColors[1].value alphaColors[4].value iscale;
			local avert_end = lerp alphaColors[2].value alphaColors[3].value iscale;	
			

		) else (
			
			
		)
		
 		/*local tvert_start = [0,lerp 0 1 iscale,0];
		local tvert_end = [1,lerp 0 1 iscale,0];*/

		
 		
		
 		for j = 1 to wverts do
 		(
 			local jscale = (j-1) * wscalar;
			
 			setVert msh vi (lerp vert_start vert_end jscale);
 			setMapVert msh 1 vi (lerp tvert_start tvert_end jscale);	
			if alphas != undefined then (
				/*			*/
				--pv_setVertColor nd -2 vert theVertColor
				
				local alphaValueAtVert = ((lerp avert_start avert_end jscale)/255.0)
				--print alphaValueAtVert
				

	
				setMapVert msh -2 vi [alphaValueAtVert,alphaValueAtVert,alphaValueAtVert]
			) else (
				
				setMapVert msh -2 vi [1.0,1.0,1.0]
			)
 			vi += 1;
 		)

		
		
 	)
 	
 -- generate the faces	
 	
	local setMapFace = meshop.setMapFace
	
 	local fi = 1; -- face index
 	for i = 0 to len_segs_m1 do
 	(
 		j = i * wverts + 1;	-- compute the starting vert index
 		for k = 0 to wid_segs_m1 do
 		(
 -- quad vert indices			
 			
 			local na = j + k;
 			local nb = na + wverts;
 			local nc = nb + 1;
 			local nd = na + 1;
 			
 -- create first quad face			
 			
 			setface msh fi [nb,na,nc];
 			wallworm_mxssetedgevisflags msh fi #{1,3};
 			setMapFace msh 1 fi [nb,na,nc];
			if alphas != undefined then (
				setMapFace msh -2 fi [nb,na,nc];
			)
 			fi += 1;
 			
 -- create second quad face			
 			
 			setface msh fi [nc,na,nd];
 			wallworm_mxssetedgevisflags msh fi #{2,3};
 			setMapFace msh 1 fi [nc,na,nd];
			if alphas != undefined then (
				setMapFace msh -2 fi [nc,na,nd];
			)
 			fi += 1;
 		)
 	)
 	update msh
	convertToPoly msh
	gc()
 	msh
 )	
  
 fn wallworm_alignPlaneToQuad2 node:selection[1] face:undefined mapchannel:1 planeDimension:[4,4] = if iskindof node Editable_Poly do 
 (
 	if face == undefined and node.selectedfaces.count > 0 do face = node.selectedfaces[1].index 
 	if face != undefined and (vv = polyop.getfaceverts node face).count == 4 do
 	(
		local gv = polyop.getvert
		
		in coordsys world (
			v1 = gv node vv[1] node:node
			v2 = gv node vv[2] node:node
			v3 = gv node vv[3] node:node
			v4 = gv node vv[4] node:node
		)
		
		local gmv = polyop.getMapVert
		
		mface = polyop.getMapFace node mapchannel face
		
 		tv1 = gmv node mapchannel mface[1]
 		tv2 = gmv node mapchannel mface[2]
 		tv3 = gmv node mapchannel mface[3]
 		tv4 = gmv node mapchannel mface[4]
		
		
		local alphas = undefined
		local alphaColors = undefined
		local getVertexColor = node.getVertexColor  
		local setSelection = node.setSelection
		
		if polyop.getMapSupport node -2 == true AND polyop.getNumMapVerts node -2 > 3 then (
			alphas = #()
			alphaColors = #()
			
			SetSelection #Vertex #{vv[1]}
			alphaColors[1] = getVertexColor #Alpha
				
			SetSelection #Vertex #{vv[2]}
			alphaColors[2] = getVertexColor #Alpha
				
			SetSelection #Vertex #{vv[3]}
			alphaColors[3] = getVertexColor #Alpha
				
			SetSelection #Vertex #{vv[4]}
			alphaColors[4] = getVertexColor #Alpha
			/**/

			

			alphas[1] = gmv node -2 mface[4]
			alphas[2] = gmv node -2 mface[1]
			alphas[3] = gmv node -2 mface[2]
			alphas[4] = gmv node -2 mface[3]			/**/
			
		)
		
		
 		wallworm_MakePlaneMesh v1 v2 v3 v4  tv1 tv2 tv3 tv4   alphas:alphas alphaColors:alphaColors width_segs:planeDimension.x  length_segs:planeDimension.y;
 	)
 )
  
  
	
function wallworm_create_plane_from_polygon polynode faceId forceQuad:true power:2 mapchannel:1 = (
	--if ww_wwdt_control_mesh == undefined then (
					segs = ww_wwdt_vmfpowertosegs power
					dim = [segs,segs]
					brsh = wallworm_alignPlaneToQuad2 node:polynode face:faceId planeDimension:dim mapchannel:mapchannel
					if polynode.mat != undefined AND brsh != undefined then brsh.mat = polynode.mat
					return brsh
	--)
	undefined
)
	
	



	
function wallworm_create_displacements_from_array ar:selection power:undefined= (
	--global ww_wwdt_control_mesh
	oldsys = set coordsys world
	max create mode
	local getFaceMatID = polyop.getFaceMatID -- <Poly poly> <int face>
	local getFaceSelection = polyop.getFaceSelection
	local gms = polyop.getMapSupport
	global ww_wwdt_displacement_power
	if power == undefined then (
		
			power = ww_wwdt_displacement_power
	)
	local displacements = #()
	--if ww_wwdt_control_mesh == undefined then (

	/*
		if (theHold.Holding()==false) then (
			theHold.Begin()
		)*/
	global wallworm_debug
	
	if wallworm_debug != undefined AND wallworm_debug == true then (
	
			local start = timestamp()
		
	)
		
		disableRefMsgs()
		--setCommandPanelTaskMode mode:#modify
		with redraw off undo off (
		--with undo off (
			if ar.count > 0 then (
				theSel = ar as array
				oldSelection = selection as array
				hide theSel
				max select none
				--max select none
				for obj in theSel where obj != undefined AND canConvertTo obj Editable_Poly == true do (
					--print obj
					--try (

					local theMat = obj.mat
					
					
					local objMats = #()
					local mapchannels = #()
					local offsetTM = undefined
					
						if classOf obj == Editable_Poly then (
							useNode = obj
							shouldDelete = false
						) else (
							shouldDelete = true
							useNode = copy obj
							resetXForm useNode
							convertToPoly useNode
							

						)
						if classof obj.baseObject == CorVex then (
							offsetTM = (inverse obj.objecttransform).translation    -- useNode.transform.translation --+ obj.objectoffsetpos
						)						
							
						selectedFaces = getFaceSelection useNode
							
						if selectedFaces.isEmpty then (
							--print "face selection is empty"
							selectedFaces = #{1..useNode.numfaces}
						)
						
						for f in selectedFaces do (
								--setCommandPanelTaskMode mode:#modify
							
							
								if theMat != undefined then (
										matId = getFaceMatID useNode f
										if objMats[matId] == undefined then (
											
											 local newMat = wallworm_getMaterial theMat matId:matId forModel:false collectingMat:true
											local checkMat
											objMats[matId] = newMat
											
											if classOf newMat != Standard then (
											
												checkMat	= wallworm_getMaterial theMat matId:matId forModel:false collectingMat:false
												if classOf checkMat != Standard then (
													
													checkMat = undefined
												)
											) else (
											
												checkMat == newMat
												
											)

											
											
											if checkMat != undefined AND checkMat.diffusemap != undefined AND checkMat.diffusemap.coords != undefined AND checkMat.diffusemap.coords.mapchannel != undefined AND gms useNode checkMat.diffusemap.coords.mapchannel == true then (
												mapchannels[matId] = checkMat.diffusemap.coords.mapchannel
											) else (
												mapchannels[matId] = 1
											)
											--format "Mat % from Mat Id %\n" newbrush.mat matId 
										) else (
											
										)

								)
							
							
							
							
								mc = 1
								if matId != undefined AND mapchannels[matId] != undefined then (
										mc = mapchannels[matId]
								)
							
								newbrush = wallworm_create_plane_from_polygon useNode f power:power mapchannel:mc
								

							--print newbrush.lengthsegs
							if newbrush != undefined then (
								--print ww_wwdt_displacement_power
								--setCommandPanelTaskMode mode:#create
								
								if theMat != undefined then (

										newbrush.mat = objMats[matId]
								)
								
								if offsetTM != undefined then (
									--pretranslate newBrush.transform offsetTM
									
									m = newBrush.transform
									translate m offsetTM
									newbrush.transform = m
									/*
									newbrush.pos += offsetTM
									resetXForm newbrush
									convertToPoly newbrush*/
									--in coordsys world newbrush.pos -= offsetTM
									--format "Offset by - %\n" offsetTM
								) else (
										--print "no offset"
								)
																
								append displacements (ww_wwdt_makeDisplacement power 128 128 newbrush.pos mat:newbrush.mat brsh:newbrush matId:undefined hold:false)
							) else ()
								
						)
						if useNode != undefined AND shouldDelete == true AND isDeleted useNode == false then (
									
							delete useNode
									
						)

			
				)
				
				if oldSelection != undefined AND oldSelection.count > 0 then (
					select oldSelection 
				)
			)
		)
		
		if wallworm_debug != undefined AND wallworm_debug == true then (
		
				local end = timestamp()

				local total = (end - start) / 1000
				local minutes = floor (total / 60) as integer
				local seconds = (mod total 60) as integer
			
				format "Displacements placed in %:% minutes (% total seconds)\n" minutes seconds total
			
		)
		
		enableRefMsgs()
		redrawviews()
		/*
			if theHold.Holding() == true then (
				theHold.Accept "Create Displacement(s) from Selection"
			)*/

		set coordsys oldsys
		return displacements
	/*) else (
		return false
	)*/
)



/*Update the custom attribute definitions for a displacement object.*/
function wallworm_update_displacement_cas obj  = (

	--disableRefMsgs()
	with undo off
	with redraw off (
		local c = custAttributes.count obj -- [BaseObject:<bool>]
		local out = false

		if c > 0 then (
			for i = c to 1 by -1 do (
				def = custAttributes.getDef obj  i 
				if matchPattern def.name  pattern:"Wallworm Displacement*" == true then (
						local ca = undefined
						global wallworm_displacement_edit_disp_CA
						global  wallworm_displacement_brush_node_CA
						global wallworm_displacement_CA
					
						case def.name of (
							
								"Wallworm Displacement": ca = wallworm_displacement_CA
								"Wallworm Displacement Brush Node": ca = wallworm_displacement_brush_node_CA
								"Wallworm Displacement Sculpt Mesh": ca = wallworm_displacement_edit_disp_CA
							
						)
					
					
					
						if ca != undefined then (
							custAttributes.redefine def (custAttributes.getDefSource ca)
						
							if def.name == ca.name  then (
								out = true
							) else ()
						)
				)
				
			)
		)
	)
	--enableRefMsgs()
	out
)
/*Update the custom attribute definitions for all displacements in scene. Returns array of displacements that failed the update (which should never happen).*/
function wallworm_update_displacements = (
    local notUpdated = #()
	local startTime = timestamp()
		max create mode
		for obj in objects WHERE isProperty obj "wallworm" == true AND ((isProperty obj "ww_displacement" == true AND obj.version < 7) OR (isProperty obj "ww_displacement_brush" == true AND obj.version < 5) OR (isProperty obj "wallworm_edit_mesh" == true AND obj.version < 20)) do (
				
			if (wallworm_update_displacement_cas obj ) == false then (
					
					append notUpdated obj
			)
		)
	
	local endtime = timestamp()
		
		

	format "Updating Displacement Custom Attributes took % seconds\n" ((endtime - startTime) / 1000.0)
		
	notUpdated
)

function wallworm_get_exported_brush_by_id id identical:true= (
	local bid = id as string + ","
	local objs
	if identical == true then (
		objs = for obj in objects where getUserProp obj "wallworm_exported_brush_ids" != undefined AND (getUserProp obj "wallworm_exported_brush_ids"==bid OR getUserProp obj "wallworm_exported_brush_ids"== id ) collect obj	
	) else (
		objs = for obj in objects where getUserProp obj "wallworm_exported_brush_ids" != undefined AND matchpattern ((getUserProp obj "wallworm_exported_brush_ids") as string) pattern:("*"+bid+"*") == true collect obj	
	)
	objs
)

/*

Function to change power of a displacement.
Will create a new displacement at the updated power. 
*/

function wallworm_convert_displacement_power disp power deleteOriginal:false= (

	if disp.power != power then (
	gv = polyop.getVert
	
	local br = disp.brushNode
	
	max create mode
	
	
	if power < disp.power AND TurboReverse != undefined then (
		
		if deleteOriginal == false then (
			disp = copy disp
			br = disp.brushNode
		)
		
		
		
		
		setUserProp disp "wallworm_ignore_event_propagation" true
		setUserProp br "wallworm_ignore_event_propagation" true
		

		
		/*Convert to Poly first because of an error with TurboReverse if there are modifiers on the disp or br objects instanced onto other objects*/
		convertToPoly disp
		convertToPoly br
		

		
		
		local TBV = TurboReverse()
		TBV.iterations = disp.power - power
		TBV.restore_vertices = 0
		
		disp.setSelection #Face (#{})
		disp.setSelection #Vertex (#{})
		br.setSelection #Face (#{})
		br.setSelection #Vertex (#{})
		
		
		
		
		addModifier disp TBV
		addModifier br TBV
		
		convertToPoly disp
		convertToPoly br
		disp.power = power
		br.power = power
		
		wallworm_retriangulate_displacement disp
		
		
		
		setUserProp br "ww_wwdt_power" power
		
		
		setUserProp disp "wallworm_ignore_event_propagation" false
		setUserProp br "wallworm_ignore_event_propagation" false

		
	) else (
	
		local segs
		
		local bottom_left, bottom_right, top_right, top_left
		local tbottom_left = [0,0,0]
		local tbottom_right = [1,0,0]
		local ttop_right = [1,1,0]
		local ttop_left  = [0,1,0]
		
		case power of (
			
			2:(
				segs = 4
			)
			3:(
				segs = 8
			)
			4:(
				segs = 16
			)
		)

		case disp.power of (
			
			2:(

				v1 = 1
				v2=5
				v3=21
				v4=25
				cornerFaces = #(1,4,16,13)
			)
			3:(

				v1 = 1
				v2=9
				v3=73
				v4=81
				cornerFaces = #(1,8,64,57)
			)
			4:(
				v1 = 1
				v2=17

				v3=273
				v4=289
				cornerFaces = #(1,16,256,241)
			)
		)
		
		select disp
		PolyToolsModeling.Quadrify false false		
		

		in coordsys world (
			bottom_left = gv br v1 node:br
			bottom_right = gv br v2 node:br
			top_left = gv br v3 node:br
			top_right = gv br v4 node:br
		)
		
		
		
		local alphas = undefined
		local alphaColors = undefined		
		local gmv = polyop.getMapVert



		local tbottom_left = [0,0,0]
		local tbottom_right = [1,0,0]
		local ttop_right = [1,1,0]
		local ttop_left  = [0,1,0]
		
		

		mface1a = polyop.getMapFace disp 1 cornerFaces[1]
		mface2a= polyop.getMapFace disp 1 cornerFaces[2]
		mface3a = polyop.getMapFace disp 1 cornerFaces[3]
		mface4a = polyop.getMapFace disp 1 cornerFaces[4]
		


		

		tbottom_left = gmv disp 1 mface1a[2]
		tbottom_right = gmv disp 1 mface2a[3]
		ttop_right= gmv disp 1 mface3a[4]
		ttop_left= gmv disp 1 mface4a[1]	
	

				
		if polyop.getMapSupport disp -2 == true then (

			
			
			
		

		mface1 = polyop.getMapFace disp -2 cornerFaces[1]
		mface2= polyop.getMapFace disp -2 cornerFaces[2]
		mface3 = polyop.getMapFace disp -2 cornerFaces[3]
		mface4 = polyop.getMapFace disp -2 cornerFaces[4]
		
			
					/*
			tv1 = gmv node mapchannel mface[1]
			tv2 = gmv node mapchannel mface[2]
			tv3 = gmv node mapchannel mface[3]
			tv4 = gmv node mapchannel mface[4]
			*/
			

			local getVertexColor = disp.getVertexColor  
			local setSelection = disp.setSelection
			
			if  polyop.getNumMapVerts disp -2 > 3 then (
				alphas = #()
				alphaColors = #()
				
				SetSelection #Vertex #{mface1[2]}
				alphaColors[1] = getVertexColor #Alpha
					
				SetSelection #Vertex #{mface2[3]}
				alphaColors[2] = getVertexColor #Alpha
					
				SetSelection #Vertex #{mface3[4]}
				alphaColors[3] = getVertexColor #Alpha
					
				SetSelection #Vertex #{mface4[1]}
				alphaColors[4] = getVertexColor #Alpha
				/**/

				

				alphas[1] = gmv disp -2 mface1[4]
				alphas[2] = gmv disp -2 mface2[1]
				alphas[3] = gmv disp -2 mface3[2]
				alphas[4] = gmv disp -2 mface4[3]			/**/
				
			)
			
		
		)
		
		
		newBrush = wallworm_MakePlaneMesh   bottom_left bottom_right top_right top_left tbottom_left tbottom_right ttop_right ttop_left alphaColors:alphaColors alphas:alphas   width_segs:segs  length_segs:segs;
		--newBrush.transform = br.transform
		
		newBrush.mat = disp.mat
		
		newBrush.name = uniqueName "WW_Displacement_Brush_"
		
		local proj = Projection()
		local disptemp = copy newBrush
		disptemp.transform = disp.transform

		addModifier disptemp proj
		proj.addObjectNode disp
		newDispName = UniqueName disp.name
		max modify mode
		select disptemp
		proj.autoWrapTolerance = 0.0
		--proj.resetCage()
		proj.autowrapCage()
		proj.exportCage newDispName
		
		max create mode		
		
		newDisp = getNodeByName newDispName
		
		
		newDisp.name = uniqueName "WW_Displacement_"
		
		delete disptemp
		
		wallworm_displacement_brush_bind newDisp newBrush power l:(distance bottom_left top_left) w:(distance bottom_left bottom_right) skipCA:true
		
		
		local custAtrCt = custAttributes.count disp
		if custAtrCt > 0 then (
			for i = 1 to custAtrCt do (
				wallworm_copy_ca i disp newDisp
			)
			
		)
		newDisp.brushNode = newBrush
		newDisp.power = power
		newBrush.power = power
		
		in coordsys newBrush (
			
		)
		
		wallworm_retriangulate_displacement newDisp
		
		newDisp.parent = newBrush
		
		if deleteOriginal then (
			
			/*
			newDisp.name = disp.name
			newBrush.name = br.name*/
			delete disp
			if isDeleted br == false then (
					delete br
			)
		)
		)
	)
	
)

function wallworm_find_all_displacements_in_sculpt = (

	local disps = #()
	dispsall = for sculpt in objects where isProperty sculpt "wallworm_edit_mesh" collect sculpt.displist
	for dl in dispsall do (
		join disps dl
	)
	if disps.count > 0 then (
		disps = makeUniqueArray disps
	)
	dispsall = undefined
	disps
)

function wallworm_convert_displacements_power disps power deleteOriginal:false = (	
	max create mode
	ww_wwdt_delete_all_handlers()
	with redraw off
	undo off (
		local skipBecauseInSculpt = wallworm_find_all_displacements_in_sculpt()
		for disp  in disps where isProperty disp "ww_displacement" AND findItem skipBecauseInSculpt disp == 0 do ( 
			wallworm_convert_displacement_power disp power deleteOriginal:deleteOriginal
		)
	)
	ww_wwdt_setDispHandlers()
	skipBecauseInSculpt = undefined
)

function wallworm_make_displacementBrushesPlanar sel:selection = (
	
	local s = sel as array

	
	if s.count > 0 then (
		
		local sculpts = for obj in s where isProperty obj "wallworm_edit_mesh" collect obj.displist

		local dispsBR = for obj in s where isProperty obj "ww_displacement" collect obj.brushNode

		local brushes = for obj in s where isProperty obj "ww_displacement_brush" collect obj
			
		for sc in sculpts do (
			for d in sc do (
				append brushes d.brushNode
			)
		)

		
		join brushes dispsBR
		
		if brushes.count > 0 then (
			brushes = makeUniqueArray brushes
			
			for brsh in brushes do (
			
				brsh.makePlanar #Object
			)
			
		)		
	)
)

fileIn "$scripts/WallWorm.com/custom_attributes/map_cas.ms"