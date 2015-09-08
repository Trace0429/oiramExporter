global wallworm_displacement_brush_node_CA = attributes "Wallworm Displacement Brush Node" version:5 (
	local wallworm = true
	local ww_displacement_brush = true
	local disp = undefined

	parameters main rollout:params (
		dispName type:#string
		power type:#integer default:2 animatable:false
		isUpdating type:#boolean default:false
	)
	function getNode = (
		refs.dependentnodes (custAttributes.getOwner this) firstonly:on	
	)
	
	function getDisp = (
		thisNode = getNode()
		dispName = getUserProp thisNode "ww_wwdt_displacement_target"
		if dispName != undefined AND dispName != "" then (
			disp = getNodeByName dispName
		)
		disp
	)
	
	
	
	
	function deleteMe = (
			
		disableRefMsgs()
		thisNode = getNode()
		getDisp()
		local doDelete = true
		if disp != undefined AND isDeleted disp == false then (
			if (disp.canDelete()) == true then (
				delete disp
			) else (
				doDelete = false
			)
		)
		if doDelete == true then (
			delete thisNode
		)
		enableRefMsgs()
	)
	
	rollout params "Options" (
			label dispLabel ""
		
			button alignToBrush "Move Displacement Here" tooltip:"Moves this displacement to match the position and rotation of the underlying brush face (this current object)."
			button gotoDisp "Get Displacement"
			button unlockMe "Allow Movement" toolTip:"Press here if the displacement brush cannot move."
			on unlockMe pressed do (
				
					setTransformLockFlags $ #{7,8,9}
			)
			on alignToBrush pressed do (
			
				if disp != undefined then (
					disp.position = $.position
					disp.rotation = $.rotation
					
				) else (
						messagebox "It appears the displacement is missing! You will need to recreate this displacement :("
				)
				
			)
			
			on gotoDisp pressed do (
			
				if disp != undefined then (
					unhide disp
					select disp
				)
				
				
				
			)
		
			on params open do (
				

					if $ != undefined AND isProperty $ "ww_displacement_brush" then (
						unhide $
						dispName = getUserProp $ "ww_wwdt_displacement_target"
						if dispName != undefined AND dispName != "" then (
							disp = getNodeByName dispName
						)


						if disp != undefined then (
								dispLabel.text = ("For: "+dispName)
								hide disp
						) else (
							
								--delete $
						)
					)

			)
		)
	)
	
global wallworm_displacement_CA = attributes "Wallworm Displacement" version:7 (
	
	local wallworm = true
	local ww_displacement = true
	
	parameters main rollout:params (
		power type:#integer default:2 animatable:false
		sg type:#integer ui:sg_ui  default:0 animatable:false
		dispflags type:#integer default:0 animatable:false
		lightmapScale type:#integer ui:lightmapscale_spinner default:16 animatable:false
		NoPhys type:#boolean ui:noPhys_checkbox default:false animatable:false
		NoHull type:#boolean ui:noHull_checkbox default:false animatable:false
		NoRay type:#boolean ui:noRay_checkbox default:false animatable:false
		brushNode type:#node animatable:false
		isUpdating type:#boolean default:false
		dispinfo type:#string default:""

	)
	function getNode = (
		refs.dependentnodes (custAttributes.getOwner this) firstonly:on	
	)
	
	function canDelete = (
		local can = true
		thisNode = getNode()
		disps = for obj in objects WHERE isProperty obj "wallworm_edit_mesh" == true AND findItem obj.displist thisNode > 0 collect obj
		if disps.count > 0 then (
			can = false
		)
		can
	)
	
	function deleteMe = (
		if (canDelete()) = true then (
			disableRefMsgs()
			
			if brushNode != undefined AND isDeleted brushNode == false then (
				delete brushNode
				
			)
			thisNode = getNode()
			delete thisNode
			
			enableRefMsgs()
			
		)
	)
	
	function stopIgnoreEventPropagation = (
		thisNode = getNode()
		setUserProp thisNode "wallworm_ignore_event_propagation" "false"
		
		if brushNode != undefined AND isDeleted brushNode == false then (
			setUserProp brushNode "wallworm_ignore_event_propagation" "false" 
		)
	)
	
	function setAlphaChannel = (
		theDispChunk = getNode()
		polyop.setMapSupport theDispChunk  -2 true
		nverts = theDispChunk.numverts
		polyop.setNumMapVerts theDispChunk -2 nverts keep:true

		polyop.defaultMapFaces theDispChunk -2
		
		
		--meshop.setVertAlpha (theDispChunk.mesh) -2 (#{1..nverts} as array) 1.0

	)
	
	function bakeDispInfo = (
		
		local TheVMF = wallwormVMF()	
		if TheVMF != undefined then (
			TheVMF.getSkyboxHelper()
			TheVMF.ww_wwdt_makeVMFDisplacement brushNode (getNode()) returnDispInfo:true bakeDispinfo:true
			TheVMF = undefined
		)
		
	)
	
	function qaudrifyMe = (

		with redraw off (
			if PolyToolsModeling != undefined AND PolyToolsModeling.Quadrify != undefined  then (
				select (getNode())
				PolyToolsModeling.Quadrify false false		
			) else (
				messagebox "This function is only available in versions of Max that have the Graphite Modeling Tools and the Quadrify method."
			)
		)

	)

	
	function traingulateMe = (
		suspendEditing()
		with redraw off (
			obj = getNode()
			convertToMesh obj

			notDone = true
			while notDOne do (
				local edges = obj.Edges
				
				meshop.autoEdge obj edges 0 type:#SetClear

				if edges.count == (obj.Edges).count do (
					notDone = false
					)
				
				)	
				convertToPoly obj
		)
		resumeEditing()
	)
	
	rollout params "Displacement Settings" (

		checkbox noPhys_checkbox "No Phys"  toolTip:"Disables any Physics Objects from Colliding with the displacement."
		checkbox noHull_checkbox "No Hull Collision" toolTip:"Disables any Player or NPC from Colliding with the displacement."
		checkbox noRay_checkbox "No Ray Collision" toolTip:"Disables raycasts from Colliding with the displacement. Gunfire and bullets will not collide with the displacement surface."
		spinner lightmapscale_spinner "Lightmap Scale" range:[1,256,16] type:#integer step:1 tooltip:"The lightmaps scale of the displacement. The lower the number, the higher the detail of baked shadows but the larger your BSP file will be."
		spinner sg_ui "Smoothing Group" range:[0,32,0] tooltip:"The smoothing group of this displacement." type:#integer step:1
		checkbutton ckb_texMode "Paint Alpha" toolTip:"Click to edit texture blending on displacements with Alpha Blending using the Vertex Paint tool." 
		button wwDisplayWalkable "Display Walkable" tooltip:"Hilight faces that are too steep to walk on."

		button wwExportBlend "Export Material" tooltip:"Export a VMT and VTFs from the Blend material applied to this displacement."

		button copyAlphaToColor "Copy Vertex Alpha to Color" tooltip:"Copy the vertex alpha channel to the vertex color channel."
		
		button wwMoveMode "Move Mode" toolTip:"Click here to move the displacement. This is helpful once the displacement has been modified from its original state."
		button alignToBrush "Align to Brush Face" tooltip:"Moves this displacement to match the position and rotation of the underlying brush face for this displacement."
		button unlockMe "Allow Movement" toolTip:"Press here if the displacement cannot move. You should mostly use the Move Mode, however."
		
		button bakeMe "Bake Info" toolTip:"Press here to update and bake the displacement information (dispinfo). This will make exporting the scene work more quickly."
		button clearBake "Clear Bake" toolTip:"Press here to remove the baked displacement information for this displacement."
		button btnQuadrifyMe "Quadrify Me" tooltip:"Quadrify this displacement to make me easier to sculpt."
		button btnTriangulateMe "Triangulate Me" tooltip:"Triangulate me to display correct walkable surfaces."
		
		on btnQuadrifyMe pressed do (
			qaudrifyMe()
		)
		
		on btnTriangulateMe pressed do (
			traingulateMe()
		)
		
		on bakeMe pressed do (
			
			
			bakeDispInfo()
			
			)
			
		on clearBake pressed do (
			dispinfo = ""
		)
		
		on unlockMe pressed do (
					setTransformLockFlags $ #{7,8,9}
		)
		
		on alignToBrush pressed do (
		
			if brushNode != undefined AND isDeleted brushNode == false  then (
				$.position =  brushNode.position
				$.rotation = brushNode.rotation
				
			) else (
					messagebox "It appears the underlying brush is missing! You will need to recreate this displacement :("
			)
			
		)
		
		on copyAlphaToColor pressed do (
		
				ChannelInfo.CopyChannel $ 3 -2
				ChannelInfo.PasteChannel $ 3 0
			
		)
		
		
		on wwExportBlend pressed do (
			
			macros.run "wallworm.com" "WallWormAnvilCompileVTFMCR"
		)

		on params open do (
			if brushNode != undefined AND isDeleted brushNode == false  then (
				hide brushNode
			)
			
			if bit.and dispflags 2 == 2 then (
					noPhys_checkbox.checked = true
			)
			if bit.and dispflags 4 == 4 then (
					noHull_checkbox.checked = true
			)
			if bit.and dispflags 8 == 8 then (
					noRay_checkbox.checked = true
			)
			
		)
		
		on wwMoveMode pressed do (
			if brushNode != undefined AND isDeleted brushNode == false  then (
				select brushNode
				setTransformLockFlags brushNode #{7,8,9}
				
				max modify mode
			)
		)
		
		
		function updateFlagsFromChecks = (
			dispflags = 0
			if noPhys_checkbox.checked == true then (

				)
			if noHull_checkbox.checked == true then (
				dispflags += 4

				)
			if noRay_checkbox.checked == true then (
				dispflags += 8

			)
			


		)
		
		
		on noPhys_checkbox changed st do (

			updateFlagsFromChecks()
			dispinfo = ""
		)
		on noHull_checkbox  changed st do (
			updateFlagsFromChecks()
			dispinfo = ""
		)
		on noRay_checkbox  changed st do (
			updateFlagsFromChecks()
			dispinfo = ""
		)
		

		
		on wwDisplayWalkable pressed do (
			
			if  (maxVersion())[1] >=12000 then (
				try (
					macros.run "wallworm.com" "WW_Face_Walkable"
				) catch (
					messagebox "This function only works if you have Wall Worm installed."
				)
			) else (
				messagebox "This feature only works in 3ds Max 2010+."
			)
			
		)
		
		
		on ckb_texMode changed state do
		(
			global ww_wwdt_control_mesh
			if ww_wwdt_control_mesh == undefined OR  isDeleted ww_wwdt_control_mesh then ( 
				if state == true then (
			

						ww_wwdt_paintMode()

						local v = VertexPaintTool()
						v.brushOpacity = 50
						v.curPaintMode = 1
						v.brushSize = 128
						v.brushOpacity  = 100
							
				) else (

					oldSurviveState = custAttribCollapseManager.surviveState
					custAttribCollapseManager.surviveState = true
					convertToPoly (custAttributes.getOwner this)
					custAttribCollapseManager.surviveState = oldSurviveState

				)
			) else (
					messagebox "This function is off when there is a Wall Worm Displacement Sculpt Mesh in the scene."
				
			)
		)
		
		
		
	)
	
	
)

global wallworm_displacement_edit_disp_CA = attributes "Wallworm Displacement Sculpt Mesh" version:20 (
		local wallworm = true

		local dispMapArray = #()
		local wallworm_edit_mesh = true
	

		local params
			
		function allowed_displacement  obj = (isProperty obj "ww_displacement" == true OR  isProperty obj "ww_displacement_brush" == true )
	
		parameters main (
			displist type:#nodeTab tabSizeVariable:true
			vertCount type:#integer
			mapints type:#intTab tabSizeVariable:true
			isUpdating type:#boolean default:false
			lastcommittime type:#float default:0
		)
		function getNode = (
			refs.dependentnodes (custAttributes.getOwner this) firstonly:on	
		)
		function qaudrifyMe = (

			with redraw off (
				if PolyToolsModeling != undefined AND PolyToolsModeling.Quadrify != undefined  then (
					select (getNode())
					PolyToolsModeling.Quadrify false false		
				) else (
					messagebox "This function is only available in versions of Max that have the Graphite Modeling Tools and the Quadrify method."
				)
			)

		)
	function clearDispMapArray = (
		/*Would you like to free some memory?*/
		dispMapArray = #()
		--setProperty this "dispMapArray" (#())
	)
	
	function traingulateMe = (
		suspendEditing()
		with redraw off (
			obj = getNode()
			convertToMesh obj

			notDone = true
			while notDOne do (
				local edges = obj.Edges
				
				meshop.autoEdge obj edges 0 type:#SetClear

				if edges.count == (obj.Edges).count do (
					notDone = false
					)
				
				)	
				convertToPoly obj
		)
		resumeEditing()
	)
	function bakeMapArrayString = (


			mapints = #()

				--dispMapArray = getProperty this "dispMapArray"
				for entry in dispMapArray do (
					
					for i in entry[2] do (
						
						append mapints i
						
						
					)
					
					append mapints 0
					
					
					for i in entry[3][1] do (
						
						append mapints i
						
						
					)
					
					append mapints 0
					
					for i in entry[3][2] do (
						
						append mapints i
						
						
					)
					
					append mapints 0
						
				)
				setproperty this "mapints"	mapints
				
				mapints
			)
	
	
		function parsemap = (

				dispMapArray = #()
				currentCount = 1

				--lineString = ""
			
				dil = getProperty this "displist"
				
				mapints = getProperty this "mapints"
			
				for obj in dil do (
					verts =  #()
					verts1 = #()
					verts2=#()
					--verts = mapints[currentCount]
					hasFound0 = false
					while   currentCount<= mapints.count AND hasFound0 == false do (
						
						if mapints[currentCount]  == 0 then (
							
							currentCount += 1	
							hasFound0 = true
						) else (
							append verts mapints[currentCount] 
							currentCount += 1
							
						)
						
						
					)
					
					
					hasFound0 = false
					while   currentCount<= mapints.count AND hasFound0 == false do (
						
						if mapints[currentCount]  == 0 then (
							
							currentCount += 1	
							hasFound0 = true
						) else (
							append verts1 mapints[currentCount] 
							currentCount += 1
							
						)
						
						
					)
					
					
					hasFound0 = false
					while   currentCount<= mapints.count AND hasFound0 == false do (
						
						if mapints[currentCount]  == 0 then (
							
							currentCount += 1	
							hasFound0 = true
						) else (
							append verts2 mapints[currentCount] 
							currentCount += 1
							
						)
						
						
					)
					
					
					
					
					theList = #(obj,verts,#(verts1,verts2))

					
					append dispMapArray theList


				)
					
				setProperty this "dispMapArray" dispMapArray
			)
		
			
			function hideAllParts = (
				for d in displist do (
						hide d
						
						setTransformLockFlags d #all
						if isValidNode d.brushNode then (
							setTransformLockFlags d.brushNode #all
							hide d.brushNode
						)
				)
			)
			
			
		function bakeAllDispinfo = (

				for d in displist do (
						d.bakeDispInfo()
					
				)
		)
		
		function SendMatToMats = (

			thisDispMesh = refs.dependentNodes (custAttributes.getOwner this) firstOnly: true --baseObjectOnly: <bool> 

			if thisDispMesh.mat != undefined then (
			
				if classOf thisDispMesh.mat == Standard OR classOf thisDispMesh.mat == Blend OR (classof thisDispMesh.mat == DirectX_9_Shader AND thisDispMesh.mat.renderMaterial != undefined AND (classof thisDispMesh.mat.renderMaterial == Blend OR classof thisDispMesh.mat.renderMaterial == Standard)) then (
				
				
					for d in displist do (
							d.mat = thisDispMesh.mat
						
					)
					return true
				)
				
			)
			false
		)
		
		function addAlphaToAllDisps = (
			disableRefMsgs()
			with redraw off
			with undo off (
				for d in displist do (
					d.setAlphaChannel()
				)
			)
			enableRefMsgs()
		)
		
		
	
		function updateLastUpdateTime = (
			
			if lastcommittime > 0 then (
				params.labelLastCommit.text = (((lastcommittime) as string)+ " seconds")
			)
		)
		
		rollout params "Wall Worm Functions" (
			
			group "Sculpt and Paint" (
				checkbutton ckb_texMode "Paint Alpha" tooltip:"Paint the alpha to control blend texture changes."
				button wwDisplayWalkable "Display Walkable" tooltip:"Hilight faces that are too steep to walk on."
				button btnQuadrifyMe "Quadrify Me" tooltip:"Quadrify this displacement to make me easier to sculpt."
				button btnTriangulateMe "Triangulate Me" tooltip:"Triangulate me to display correct walkable surfaces."
				pickbutton addDisplacement "Add Displacement" toolTip:"Add a displacement from the scene to this sculpt mesh."	 filter:allowed_displacement		message:"Pick a Wall Worm displacement to add to the sculpt mesh.\n"
				
			)
			
			
			group "Commit" (

				button wwCommitChanges "Commit Changes" tooltip:"Commit the changes for the mesh."
				label labelLastCL "Last Commit: " across:2
				label labelLastCommit ""
				
				button wwRevert "Revert to Pieces" tooltip:"Reverts the mesh to the respective parts."
			)
			
			
			group "Miscellaneous" (
				button bakeMe "Bake Info" toolTip:"Press here to update and bake the displacement information (dispinfo). This will make exporting the scene work more quickly."
				button clearBake "Clear Bake" toolTip:"Press here to remove the baked displacement information for this displacement."
				button btn_sendMatToMats "Send Material to Pieces" tooltip:"This will send the current material of the displacement to all underlying displacement pieces."
				button addAlphas "Fix Alphas" tooltip:"Run this function if your displacements are not getting full alpha values (for example, the displacements seem to always get solid alphas)."
			
			)
			

			
			on addAlphas pressed do (
				addAlphaToAllDisps()
			)
			
			on btnQuadrifyMe pressed do (
				qaudrifyMe()
			)
			
			on btnTriangulateMe pressed do (
				traingulateMe()
			)
			
			
			on btn_sendMatToMats pressed do (
				if SendMatToMats() == false then (
						messagebox "The function could not succeed. It only works if this sculpt mesh has a Standard or Blend material, or a DirectX_Shader with a Standard or Blend Render Material."
					
				)
				
			)
			
			on clearBake pressed do (
				for disp in displist do (
					disp.dispinfo = ""
				)
				
			)
			
			function commit = (
			/*	if theHold.Holding() == false then (
					theHold.Begin()
				)*/
				local started = timestamp()
				max create mode
				disableRefMsgs()
				with redraw off 
				with undo off (
					--dispMapArray = getProperty this "dispMapArray"
					
					
					--dispMapArray = getProperty this "dispMapArray"
					
					if dispMapArray == undefined OR dispMapArray.count == 0 then (
						parsemap()
					)
					local pv_setVert = polyop.setVert
					local pvSetVertColor = polyop.setVertColor
					local pv_getVert = polyop.getVert
					--in coordsys world (
						if dispMapArray != undefined AND dispMapArray.count > 0 do (
							--in coordsys world (
								--AND ((wwdt[1].power == 2 AND wwdt[1].numverts==25)) ... consider adding this block and other powers for displacements that might have invalid number of verts
								for wwdt in dispMapArray where (isDeleted wwdt[1] ==false)  do (
									--unhide wwdt[1]
									--setTransformLockFlags wwdt[1] #{7,8,9}
									
									local theDispChunk = wwdt[1] 
									
									local dispNumVerts = theDispChunk.numverts

									local vertmap = wwdt[3][2]
									for i=1 to vertmap.count while i <= dispNumVerts do (

										local sculptvert = wwdt[3][1][i]
										
										local controlMeshVert = pv_getVert $ sculptvert --node:$
										--local originalMeshVert = polyop.getVert wwdt[1] wwdt[3][2][i]   

						
										--dist = distance originalMeshVert controlMeshVert

										pv_setVert theDispChunk vertmap[i] controlMeshVert  --node:$
										
										if (maxVersion())[1] >= 12000 do (
											$.SetSelection #Vertex #{(sculptvert)}
											local theVertColor =$.getVertexColor #Alpha
											pvSetVertColor theDispChunk -2 vertmap[i] theVertColor
										)
									)
								)
							--)
						)
					--)
				)
				
				enableRefMsgs()
				
				local ended = timestamp()
				lastcommittime = ((ended - started) / 1000.0) 
				minutes = lastcommittime / 60 
										--leftover = mod seconds 60 
										
				format "Commited in % seconds (% minutes)\n"  lastcommittime minutes 	
				updateLastUpdateTime()
				--theHold.Accept "Commit Displacement Changes"
			)
			
			on bakeMe pressed do (
				bakeAllDispinfo()
			)
			
			on addDisplacement picked p do (
				--disableRefMsgs()
				local orig
				
				if isProperty p "ww_displacement" == true then (
					orig = p
				) else (
					
					dispName = getUserProp p "ww_wwdt_displacement_target"
					if dispName != undefined AND dispName != "" then (
								orig = getNodeByName dispName
					)					
				)
				

				local getNumVerts = polyop.getNumVerts
				
				if orig != undefined AND isDeleted orig == false AND findItem displist orig == 0 then (
				
				
					max create mode
					commit()
				--ww_wwdt_delete_all_handlers()

					--setUserProp $ "wallworm_ignore_event_propagation" true
					--setProperty this "isUpdating" true
					isUpdating = true
				
					
					convertToPoly orig	
				
					append displist orig			
					dispMapArray = #()
					/*Reset the vertmapping in existing displacements*/
				
					for d in displist do (

						local theOrigVerts = getNumVerts d
						local theverts = #{1..theOrigVerts} as array
						append dispMapArray #(d,theverts,#(#(),#()))
					)
				
					--dispMapArray = getProperty this "dispMapArray"
				


				
					

					obj = copy orig
					setUserProp obj "wallworm_ignore_event_propagation" "true"
					
					if obj.brushNode != undefined AND isDeleted obj.brushNode == false then (
						setUserProp obj.brushNode "ww_wwdt_displacement_target" ""
						setUserProp obj.brushNode "wallworm_is_updating" "false"	
						setUserProp obj.brushNode "wallworm_ignore_event_propagation" "false"		
						delete obj.brushNode
					)

					
					polyop.attach $ obj	
					

						
					local vs = getNumVerts $
					
					$.weldThreshold = 1
					polyop.weldVertsByThreshold $ #{1..vs}
						

						
						
			vertCount = getNumVerts $
			--setProperty this "vertCount" vs
			local controlVerts = #()
			
		--	local checkFromSource = #{1..vertCount} as array -- create an array to store all the vertices in the control mesh
			local pv_getVert = polyop.getVert
			
			in coordsys world (
			with redraw off 
					

						
					for i = 1 to vertCount do (
						
						local pt = (pv_getVert $ i)
						
						append controlVerts #(pt,(length pt),i)
						
						
					)
					
						fn compareFN v1 v2 =

						(

							
						local d = ( v1[2])-(v2[2])

						case of

						(

						(d < 0.): -1

						(d > 0.): 1

						default: 0

						)

						)

						

					qsort controlVerts compareFN 
					
				
			for maps in dispMapArray do (
				
				
				
				
				for ov in maps[2]  do (
					--maps is an array structured like this:  #(originalMeshObject,arrayOfVerticesInMesh,#(#(),#()))
					dispvert = pv_getVert maps[1] ov --get vertice from original mesh
					local toOrigin = length dispvert
					

					
					local minIndex = 1
					local maxIndex = vertCount
					local midIndex = (floor ((minIndex+maxIndex)/2)) as integer
					
					local searchValue = toOrigin - 1.0
					
					

					do (
						

						
						midValue = controlVerts[midIndex][2]
						
					
						
						if midValue < searchValue then (
							minIndex = midIndex
						) else (
							maxIndex = midIndex
						)
						
						midIndex = (floor ((minIndex+maxIndex)/2)) as integer
						
						--format "###########\nMin\t%\nMid\t%\nMax\t%\n" minIndex midIndex maxIndex
						
					) while ( minIndex != midIndex)
					
					
					
					local nf = true
					
					for i=minIndex to vertCount while nf do (		
						theVert = controlVerts[i][1] --get vertice from the control mesh
						--if ((abs (dispvert.x - theVert.x ) < 1) AND (abs (dispvert.y - theVert.y) < 1) AND (abs (dispvert.z - theVert.z) < 1)) then (
						if (distance dispvert theVert) < 1 then (
							append maps[3][1] controlVerts[i][3] --record the control mesh vertice
							append maps[3][2] ov --record the original vertice
							--checkFrom[i] = false
							--deleteItem checkFrom (findItem checkFrom i) --delete item from the checkFrom array to reduce overhead in next iteration
							nf = false
						) else()
					)
					
				)
				
			)
	

			
		)

					
	
				setTransformLockFlags orig #all
				hide orig
				if isProperty orig "brushNode" AND orig.brushNode != undefined AND isDeleted orig.brushNode == false then (
					setTransformLockFlags orig.brushNode #all	
					orig.brushNode.xray = on
					hide orig.brushNode
				)
				isUpdating	= false
				--setProperty this "isUpdating" false
				
				--setProperty this "dispMapArray" dispMapArray
				
				bakeMapArrayString()
				--ww_wwdt_setDispHandlers()	
				
				--setUserProp $ "wallworm_ignore_event_propagation" "false"
				

				max modify mode
			) else (
				
					messagebox "This displacement is already part of this sculpt mesh."
			)
			
			--enableRefMsgs()
		)
			
			
			

			on params open do (
				
				/*
				if mapints.count == 0 then (
					bakeMapArrayString()
				)
				
				if dispMapArray == undefined OR dispMapArray.count == 0 then (

					parsemap()
					
				)*/
				hideAllParts()
				updateLastUpdateTime()
			)
			
			

			

			
			
			

			
			on wwDisplayWalkable pressed do (
						
						if  (maxVersion())[1] >=12000 then (
							try (
								macros.run "wallworm.com" "WW_Face_Walkable"
							) catch (
								messagebox "This function only works if you have Wall Worm installed."
							)
						) else (
								messagebox "This feature only works in 3ds Max 2010+."
						)
					)
					
			on ckb_texMode changed state do
			(


				if $ != undefined then (
				
					if state == true then (
			

							addModifier $ (VertexPaint name:"WW Blend Paint" mapChannel:-2)

							local v = VertexPaintTool()
							v.brushOpacity = 50
							v.curPaintMode = 1
							v.brushSize = 128
							v.brushOpacity  = 100
								
					) else (

						oldSurviveState = custAttribCollapseManager.surviveState
						custAttribCollapseManager.surviveState = true
						convertToPoly $
						custAttribCollapseManager.surviveState = oldSurviveState

					)

				)

			)
			
			on wwCommitChanges pressed do (
				
				commit()
				max modify mode
			)
			
			on wwRevert pressed do  with redraw off (
				
				if querybox "Do you want to commit changes first? If not, any changes made since the last commit will be lost." == true then (
					commit()
				)
				
				if displist != undefined AND displist.count > 0 then (

					unhide (displist as array)
					
					for disp in displist do (
						setTransformLockFlags disp #{7,8,9}
						setTransformLockFlags disp.brushNode #{7,8,9}
						if isProperty disp "stopIgnoreEventPropagation" then (
							disp.stopIgnoreEventPropagation()
						)
					)

				)
				global ww_wwdt_setDispHandlers
				
				if ww_wwdt_setDispHandlers == undefined AND doesFileExist "$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms" then (
					
					fileIn "$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
				)
				if ww_wwdt_setDispHandlers != undefined then (
					ww_wwdt_setDispHandlers()
				)
				delete $
				
			)
		
		
	)		
	
	
		function setArrayMap ar = (
			dispMapArray = ar
		)
				
		function getArrayMap = (
			return dispMapArray
		)
		

	
)
