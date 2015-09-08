/*
Hull Helper for Wall Worm Mod Tools
Copyright (c) 2011-2012
All Rights Reserved

http://www.wallworm.com

Written by Shawn Olson
http://www.shawnolson.net

The advanced hull function requires Convexity 1.17+.
Convexity is available at http://www.maple3d.com

*/
try(destroyDialog wwmt_hull_helper)catch(
	
	   --there was not any open
	)

include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
	
	

rollout wwmt_hull_helper "Wall Worm Hull Helper" width:288 height:235
(
	button btn1 "Grow" pos:[11,62] width:60 height:25 toolTip:"Grow Subobject Selection."
	button btn2 "Shrink" pos:[75,62] width:60 height:25 toolTip:"Shrink Subobject Selection."
	button btn3 "Detach" pos:[11,119] width:65 height:30 toolTip:"Detach selected faces as an Element SubObject and hide the selection."
	button btn10 "Unhide All" pos:[81,119] width:65 height:30 toolTip:"Unhide any hidden faces in the selected object."
	label lbl1 "Wall Worm Hull Helper" pos:[168,6] width:113 height:18
	button btn5 "Prepare From Selection" pos:[11,7] width:138 height:30 toolTip:"Copy and Hide the selected Meshes, convert the copies into a single Editable Poly and go to Polygon Sub Object Mode."
	HyperLink wwlink "Wall Worm" pos:[9,199] width:87 height:15 address:"http://www.wallworm.com"
	button btn24 "Loop" pos:[11,90] width:60 height:25
	button btn25 "Ring" pos:[75,90] width:60 height:25
	button btn9 "Create Hulls From Selection" pos:[139,85] width:142 height:29 toolTip:"Create Convex Hull for each Element of each Object in the current selection."
	spinner spn_max_verts "Max Verts Per Hull" pos:[195,63] width:84 height:16 range:[4,4096,44] type:#integer scale:1 toolTip:"Choose the maximum number of vertices any hull piece can have when being generated."
	button btn_process "Process Selected Hulls" pos:[153,119] width:128 height:31 toolTip:"Click here to make the selected objects ready to export as a $concave hull by adding the appropriate smoothing groups and material names."
	button btnPivot "Pivots to Selection Center" pos:[12,42] width:137 height:15 toolTip:"Align the pivot of each item in the selection to selection center. Necessary if you are having a problem with the hulls being offset."
	button btn12 "Quick Hulls" pos:[170,25] width:110 height:29 toolTip:"Assign Quick Hulls to the selected WWMT helpers."
	button btn13 "Merge Selected Hulls" pos:[155,156] width:127 height:20 toolTip:"Merge selected hulls into a single object."

	button btnSkinEach "Skin on Each Object Selected" pos:[114,187] width:167 height:29 toolTip:"Add a separate skin modifier to each object in the selection."

	on btn1 pressed do
	(
	 if classOf $ == Editable_Poly do (
		$.EditablePoly.GrowSelection ()
	 )
	)
	on btn2 pressed do
	(
		 if classOf $ == Editable_Poly do (
			$.EditablePoly.ShrinkSelection ()
		 )
	)
	on btn3 pressed do
	(
			 if classOf $ == Editable_Poly do (
				$.EditablePoly.detachToElement #Face keepOriginal:off
				$.EditablePoly.Hide #Face
			 )
	)
	on btn10 pressed do
	(
			 if classOf $ == Editable_Poly do (
				$.EditablePoly.unhideAll #Face
			 )
	)
	on btn5 pressed do
	(
	
	 if selection != undefined AND selection.count > 0 then (
			newObj = undefined
			 for obj in selection do (
				 if superClassOf obj == GeometryClass then (
						temp = copy obj
						
						convertToPoly temp
						
						if newObj == undefined then (
							newObj = temp
						) else (
							newObj.attach temp newObj
						)
						setUserPropBuffer newObj "wwmt_temphull = true"
					 ) else (
					 print "not right class"
					 )
				 )
	
		 
			if newObj != undefined do (
				
				newObj.name = uniqueName (selection[1].name + "_Hull_Master")
				
				hide selection
				select newObj
				setCommandPanelTaskMode #modify
				subobjectLevel = 4
	
				
				)
				) else(
				messagebox "No valid objects selected."
			)
	
	
	)
	on btn24 pressed do
	(
	
	macros.run "PolyTools" "Loop"
	
	)
	on btn25 pressed do
	(
	macros.run "PolyTools" "Ring"
	
	)
	on btn9 pressed do
	(
	
		if selection.count > 0 then (
			if subobjectLevel != 0 then (
				subobjectLevel = 0
			)
			try (
				NewHulls = wallwormCreateMeshFromMeshes $ vertlimit:spn_max_verts.value doOffsetransforms:true resestX1:false
				hide $
				select NewHulls
				wwmt_hullsmoothinggroups NewHulls 1 
				redrawViews()
			)catch (
				 messagebox "There was a problem. The Wall Worm Hull Helper only works if you have either the nVidia PhysX Plugin or MassFX (Integrated into 3ds Max 2012+)."
			)
		) else (
			messagebox "This function only works if you have one or more objects selected."
		)
	)
	on btn_process pressed do
	(
		if selection.count > 0 then (
			if subobjectLevel != 0 then (
				subobjectLevel = 0
				)
			
			wwmt_hullsmoothinggroups selection 1 
			redrawViews()
		) else (
			messagebox "This function works on a selection of objects."
			)
	
	)
	on btnPivot pressed do
	(
	
	 for obj in selection do (
	  obj.pivot = selection.center
	
	 )
	
	)
	on btn12 pressed do
	(
		
				if selection.count == 0 then (
				
				messagebox "This function only works when you have selected a set of WWMT helpers."
				
				) else (
					   oldsel = selection as array
					    local wwmts = 0
					    local failed = #()
					    clearSelection()
						for obj in oldsel do (
							
							isWWMTSource = getUserProp obj "wwmt_source_helper"	
							 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel obj tempWWMT
										try (
											
											if (tempWWMT.createHull maxVerts:spn_max_verts.value) == true then ( 
												wwmts+=1
												) else (
												
												append failed ("Failed to Create Hull: "+ tempWWMT.modelName)
												)
											
										) catch (
		
											append failed ("Failed to Create Hull: "+ tempWWMT.modelName)
											)
								
							)
							tempWWMT = undefined
						)
						
						
						
						select oldsel
						local failedmessage = ""
						if failed.count > 0 do (
							
							failedmessage= "\n\n("+(failed.count as string)+") Model(s) failed to create hulls. Press F11 to see the list."
							for i in failed do (
								print i
								)
							)
						
						if wwmts == 0 then (
							
							messagebox ("No no models were hulled. Either no WWMT helpers were selected or there were errors."+failedmessage)
							
							) else (
							
							messagebox ((wwmts as string)+ " models were hulled."+failedmessage)
							
							)
						
					)
		
	
	
	)
	on btn13 pressed do
	(
	
		if selection.count > 0 then (
			wallworm_merge_hulls()
		
		)
	)
	on btnSkinEach pressed do
	(
			objs = for obj in selection where validModifier obj Skin == true AND obj.modifiers[#Skin] == undefined collect obj
	
	
				
			if objs.count > 0 then (
				
				for obj in objs do (
					addModifier obj (Skin())
				)
			)
			
		)
)
			

	createDialog wwmt_hull_helper