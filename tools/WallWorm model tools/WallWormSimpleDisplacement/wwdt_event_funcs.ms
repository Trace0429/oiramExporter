function ww_wwdt_setDispHandlers=()

function ww_wwdt_setchangehandlers disp br=  (
	try (
	when disp deleted id:#wallworm_deleteDisp  obj  do (	
		

		if (theHold.Redoing() == false OR theHold.Redoing() == 0) AND isDeleted obj == false AND (getUserProp obj "wallworm_ignore_event_propagation" ==undefined OR getUserProp obj "wallworm_ignore_event_propagation" ==false OR  getUserProp obj "wallworm_ignore_event_propagation" =="false")  then (
			

			local canDelete = true
			
			if isProperty obj "canDelete" then (
				canDelete = obj.canDelete()
			)
			
			if (canDelete == true) then (

					local theBrsh 
					if isProperty obj "brushNode" == true AND obj.brushNode != undefined AND isDeleted obj.brushNode == false then (
						theBrsh = obj.brushNode
					) else (
						local br = getUserProp obj "ww_wwdt_displacement_brush"
						if br != undefined then (
							theBrsh = getNodeByName br
						)
					)


						if theBrsh != undefined AND isDeleted theBrsh == false do (
						
							try (
							setUserProp theBrsh "wallworm_ignore_event_propagation" "true"	
							delete theBrsh
							) catch (
								print (getCurrentException())
							)
						)

			) else (
						
				/*
				!TODO Update this to handle the newer sculpt mesh... probably need to swap all instances of obj in sculpt displists and their dispmaparray.		
				*/		
						
				obj2 = copy obj
				setUserPropBuffer obj2 (getUserPropBuffer obj)
				obj2.name = obj.name
				ww_wwdt_setDispHandlers()
				/*max undo*/
				completeRedraw()
				messagebox "Displacement objects cannot be deleted when there is a Displacement Sculpt Mesh in the Scene using this displacement."
			)
		) else (
			--print "holding"
		)
	)
	
	when br deleted id:#wallworm_deleteDispBrush  obj  do (
		global  wallworm_ignore_all_events 
		if (theHold.Redoing() == false OR theHold.Redoing() == 0) AND  obj != undefined AND isDeleted obj == false AND (getUserProp obj "wallworm_ignore_event_propagation" ==undefined OR getUserProp obj "wallworm_ignore_event_propagation" ==false  OR  getUserProp obj "wallworm_ignore_event_propagation" =="false")  then (	
			local dm = undefined
			
			/*!TODO... change this to newer displacement logic.*/
			
			if (dm == undefined ) then (

				local disp = getUserProp obj "ww_wwdt_displacement_target"
				if disp != undefined do (
					
					local dispB = getNodeByName disp
					if dispB != undefined AND isDeleted dispB == false do (
						try (
							setUserProp dispB "wallworm_ignore_event_propagation" "true"
							delete dispB
						) catch ()
					)
				)
			) else (
				obj2 = copy obj
				obj2.name = obj.name
				setUserPropBuffer obj2 (getUserPropBuffer obj)
				ww_wwdt_setDispHandlers()
				/*
				max undo*/
				completeRedraw()
				messagebox "Displacement objects cannot be deleted when there is a Displacement Sculpt Mesh in the Scene."
			)	
		)
	)
	
		when name disp changes  id:#wallworm_nameDisplacementMesh handleAt:#redrawViews obj do (
		 try (
			 global wallworm_ignore_all_events
			 if (theHold.Redoing() == false OR theHold.Redoing() == 0) AND  isDeleted obj == false  then (
				local br = getNodeByName (getUserProp obj "ww_wwdt_displacement_brush")
				setUserProp br "ww_wwdt_displacement_target" obj.name
			 )
		 ) catch ()
		
		)
		
	/*
		when name br changes  id:#wallworm_nameDisplacementBrushMesh handleAt:#redrawViews obj do (
		 try (
			if (theHold.Redoing() == false OR theHold.Redoing() == 0) AND isDeleted obj == false then (
				local disp = getNodeByName (getUserProp obj "ww_wwdt_displacement_target")
				setUserProp disp "ww_wwdt_displacement_brush" obj.name
			)
		 ) catch ()
		
		)

		when transform brsh changes id:#fixBrushVerts handleAt:#redrawViews obj   do (
			local p = getUserProp obj "ww_wwdt_power"
			if p != undefined do (
				wwdt_alignVertexToGrid obj (ww_wwdt_getEdgeVerts p) 
				--print obj
			)
		)


		when transform br changes  id:#wallworm_brushGeometryScale handleAt:#redrawViews obj do (
			   if (theHold.Redoing() == false OR theHold.Redoing() == 0) AND  isDeleted obj== false then (
					if obj.scale != [1,1,1] then (
						obj.scale = [1,1,1]
					)
				)
		)
		
		when transform disp changes  id:#wallworm_displacementGeometryScale handleAt:#redrawViews obj do (
			if (theHold.Redoing() == false OR theHold.Redoing() == 0) AND  isDeleted obj== false then (
				if obj.scale != [1,1,1] then (
					obj.scale = [1,1,1]
				)
			)
			
		)
			*/	
		/*
		
		This event listener is not correct yet. Need to stop user from any edit to brush other than Position/Rotation ... no changing of vertexes.
		
		when geometry br changes  id:#wallworm_listen_for_changed_geometry handleAt:#redrawViews obj do (
			
			if subobjectLevel != 0 then (
				
				max undo
				completeRedraw()
				messagebox "The action was cancelled. You may only move and rotate this mesh. Only sculpt the displacement."
				
				
			)
			subobjectLevel = 0
			
			
		)
		*/
		
		global wallworm_displacement_events
		
		if wallworm_displacement_events == undefined OR wallworm_displacement_events == "true" OR wallworm_displacement_events == true then (
		
		when topology disp changes  id:#wallworm_topoDisplacementMesh handleAt:#redrawViews obj do (
			global wallworm_ignore_all_events
			if (theHold.Redoing() == false OR theHold.Redoing() == 0) AND isDeleted obj == false AND (isProperty obj "useSoftSel" == false OR obj.useSoftSel == undefined OR obj.useSoftSel == false) AND (getUserProp obj "wallworm_ignore_event_propagation" == undefined OR getUserProp obj "wallworm_ignore_event_propagation" ==false OR  getUserProp obj "wallworm_ignore_event_propagation" =="false") then (	
				local br
				local p
				
				if isProperty obj "brushNode" then (
					
					p = obj.power
				) else (
					 br = getUserProp obj "ww_wwdt_displacement_brush"
					if br != undefined then (
						local theBrsh = getNodeByName br
						if theBrsh != undefined then (
						local p = getUserProp theBrsh "ww_wwdt_power"
						)
					)
				)
				
				
				if p != undefined do (
					

					local vc = 25
					if  p != undefined do (
						
						case of (
							(p == 2): (vc = 25)
							(p == 3): (vc = 81)
							(p == 4): (vc = 289)
							)
						
					

					
						if   (getPolygonCount obj)[2]  != vc do (
							max undo
							completeRedraw()
							messagebox "The action was cancelled. You cannot change the vertex count of this mesh."
						)



					)

				)
				
			) else ()

		
		)

		
	
	
		when topology br changes  id:#wallworm_topoDisplacementBrushMesh handleAt:#redrawViews obj do (
			global wallworm_ignore_all_events
			if (theHold.Redoing() == false OR theHold.Redoing() == 0) AND  isDeleted obj == false AND  (isProperty obj "useSoftSel" == false OR obj.useSoftSel == undefined OR obj.useSoftSel == false) AND (getUserProp obj "wallworm_ignore_event_propagation" == undefined OR getUserProp obj "wallworm_ignore_event_propagation" ==false OR  getUserProp obj "wallworm_ignore_event_propagation" =="false") then (	


			

					
					local p = getUserProp obj "ww_wwdt_power"

					local vc = 25
					if p != undefined do (
						
						case of (
							(p == 2): (vc = 25)
							(p == 3): (vc = 81)
							(p == 4): (vc = 289)
							)
						
					

					
						if (getPolygonCount obj)[2]  != vc do (
							max undo
							
							completeRedraw()
							messagebox "The action was cancelled. You cannot change the vertex count of this mesh."
						)



					)

				
			) else ()

		
		)
	) else (
		deleteAllChangeHandlers  id:#wallworm_topoDisplacementMesh
		deleteAllChangeHandlers  id:#wallworm_topoDisplacementBrushMesh
	)
		

	) catch ()
		

	
)	
	

function ww_wwdt_delete_all_handlers = (
	deleteAllChangeHandlers  id:#wallworm_brushGeometryScale
	deleteAllChangeHandlers  id:#wallworm_displacementGeometryScale		
	deleteAllChangeHandlers  id:#wallworm_nameDisplacementBrushMesh
	deleteAllChangeHandlers  id:#wallworm_nameDisplacementMesh	
	deleteAllChangeHandlers  id:#wallworm_deleteDisp
	deleteAllChangeHandlers  id:#wallworm_deleteDispBrush
	deleteAllChangeHandlers  id:#wallworm_topoDisplacementMesh
	deleteAllChangeHandlers  id:#wallworm_topoDisplacementBrushMesh
	deleteAllChangeHandlers  id:#wallworm_brushGeometryScale
	deleteAllChangeHandlers  id:#wallworm_displacementGeometryScale

)


function wallworm_all_displacement_cleanup = (
	max create mode
	ww_wwdt_delete_all_handlers()
	deleteAllChangeHandlers  id:#topologyControlMesh
	deleteAllChangeHandlers  id:#deleteControlMesh
	
	callbacks.removeScripts  id:#wwdt_displacement_topo_handler
	callbacks.removeScripts id:#wwdt_displacement_clone_handler

	
	

	local dispCollection  =	for obj in objects WHERE isProperty obj "wallworm" == true AND (isProperty obj "wallworm_edit_mesh" == true ) collect obj

	if dispCollection.count > 0 then (
		for disp in dispCollection do (
			disp.clearDispMapArray()
		)
	)
)


callbacks.removeScripts id:#wallWormRemoveDisplacementListenersAtFileOpen
callbacks.addScript #filePreOpenProcess "if (callbacks.notificationParam())[1] == 1 then (wallworm_all_displacement_cleanup()) else ()" id:#wallWormRemoveDisplacementListenersAtFileOpen


callbacks.removeScripts id:#wallWormRemoveDisplacementListenersAtShutDown
callbacks.addScript #preSystemShutdown "wallworm_all_displacement_cleanup()" id:#wallWormRemoveDisplacementListenersAtShutDown


callbacks.removeScripts id:#wallWormRemoveDisplacementListenersAtNew
callbacks.addScript #systemPreNew "if (callbacks.notificationParam()) == 1 then (wallworm_all_displacement_cleanup())" id:#wallWormRemoveDisplacementListenersAtNew



	
function wallworm_sculpt_mesh_handlers theController = (
	
			when topology theController change id:#topologyControlMesh handleAt:#redrawViews obj  do (
			--make an event to unhide the displacements if the control mesh is deleted
				global wallworm_ignore_all_events
				if isDeleted obj == false AND  (isProperty obj "isUpdating" == false OR obj.isUpdating == false) AND (getPolygonCount obj)[2] != obj.vertCount AND (isProperty obj "useSoftSel" == false OR obj.useSoftSel == undefined OR obj.useSoftSel == false) AND (theHold.Redoing() == false OR theHold.Redoing() == 0) do (

					
						max undo
						completeRedraw()
						messagebox "The action was cancelled. You cannot change the vertex count of this mesh."

				)

			)
		
		when theController deleted id:#deleteControlMesh obj  do (
			--make an event to unhide the displacements if the control mesh is deleted
			global wallworm_ignore_all_events
			if isProperty obj "displist" == true AND obj.displist != undefined AND obj.displist.count > 0 then (
					for d in obj.displist WHERE isValidNode d do (
						unhide d
						
						setTransformLockFlags d #{7,8,9}
						if isValidNode d.brushNode then (
							setTransformLockFlags d.brushNode #{7,8,9}
							d.brushNode.xray = off
						)
					)
			)

		)
	
	
)
	
function deleteAllEmptyBrushNodes = (
	count = 0
	for obj in objects where isProperty obj "ww_displacement_brush" == true AND isProperty obj "getDisp" == true AND (obj.getDisp()) == undefined do (
		try (
		obj.deleteMe()
		count += 1
		) catch ()
	)
	count
)	

	
function ww_wwdt_setDispHandlers deleteFirst:true = (

	if deleteFirst == true then (
		ww_wwdt_delete_all_handlers()
	)
	
--deleteAllChangeHandlers id:#wallworm_listen_for_changed_geometry
	
	for disp in objects where (isProperty disp "ww_displacement" == true  OR (getUserProp disp "ww_wwdt_displacement_brush" != undefined)) AND isDeleted disp == false  do (
		
		if isProperty disp "brushNode" then (
			br = 	disp.brushNode
		) else (
			local br = getNodeByName (getUserProp disp "ww_wwdt_displacement_brush")
		)
		if br != undefined AND isDeleted br == false then (
			ww_wwdt_setchangehandlers disp br
		) else (
			--add function to recreate and rebind 
			)
	)
	--deleteAllEmptyBrushNodes()
)

function wallworm_displacement_to_poly deleteBrush:true disps:objects = (
	if disps.count > 0 then (
		ww_wwdt_delete_all_handlers()
		
		disps = for disp in disps WHERE isProperty disp "ww_displacement" collect disp 
			
		for disp in disps do (
				
			
			if deleteBrush == true then (
					delete disp.brushNode
			) else (
				wallworm_remove_ca_by_name disp.brushNode "Wallworm Displacement Brush Node"
				setUserProp disp.brushNode "ww_wwdt_displacement" undefined
				setUserProp disp.brushNode "ww_wwdt_displacement_target" undefined

			)
			
			setUserProp disp "ww_wwdt_displacement_brush" undefined
			wallworm_remove_ca_by_name disp "Wallworm Displacement"
			
		)
		
		ww_wwdt_setDispHandlers()
	)
	
)
