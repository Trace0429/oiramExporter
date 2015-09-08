
rollout anvil_displacements_settings "Displacement Flags" width:391 height:48
(
	
	checkbox chkNoPhys "No Phys" pos:[7,15] width:65 height:15 toolTip:"Disables any physics objects colliding with the displacement."
	checkbox chkNoHull "No Hull Collision" pos:[82,14] width:101 height:19 toolTip:"Disables any player or NPC collisions with the displacement."
	checkbox chkNoRay "No Ray Collision" pos:[185,14] width:101 height:17 toolTip:"Disables raycasts colliding with the displacement. Gunfire and bullets will not collide with the displacement surface."
	button btnSetDisplacementFlags "Set Flags" pos:[318,13] width:68 height:17 toolTip:"Set the Displacement Flags on the selected displacements."
	button btn30 "Get" pos:[289,13] width:26 height:17 toolTip:"Prefell the settings from those already stored in the selected displacement."

	function setFlagsFromSelection = (
		
		
		local flags = 0
		if selection.count == 1 then (
		if isProperty $ "wallworm" AND isProperty $ "dispflags" then (
				flags = $.dispflags
		) else (
				local brush = ww_wwdt_getBrushFromDisp $
				if brush != undefined then (
					
					local flags = ww_wwdt_getDispFlags brush
				)
		)

		if flags != undefined AND flags != 0 then (
			

			--print flags
			
			if bit.and flags 2 == 2 then (
				chkNoPhys.checked = true
				) else (
				chkNoPhys.checked = false
				)
			if bit.and flags 4 == 4 then (
				chkNoHull.checked = true
				) else (
				chkNoHull.checked = false
				
				)
			if bit.and flags 8 == 8 then (
				chkNoRay.checked = true
				) else (
				chkNoRay.checked = false
				)
				
			) else ()
		
		
		
		
		) else (

			
			)
		
		
		
		)
	
	
	
	on anvil_displacements_settings open do
	(
	setFlagsFromSelection()
	
	)
	on btnSetDisplacementFlags pressed do
	(
		if selection.count > 0 then (
			
			for obj in selection WHERE isProperty obj "wallworm" == true AND isProperty obj "ww_displacement" == true AND isProperty obj "dispflags" == true do (
				ww_wwdt_setDispFlags obj noPhys:chkNoPhys.checked noHull:chkNoHull.checked noRay:chkNoRay.checked
			)

			for obj in selection WHERE isProperty obj "wallworm" == true AND isProperty obj "wallworm_edit_mesh" == true  do (
				
				
				
				for d in obj.displist do (
					ww_wwdt_setDispFlags d noPhys:chkNoPhys.checked noHull:chkNoHull.checked noRay:chkNoRay.checked
				)
				
			)
			
			
			
			
			
			
			local brushes = ww_wwdt_getBrushesFromDisplacements selection
			if brushes.count > 0 then (
				ww_wwdt_setDispFlagsArray brushes noPhys:chkNoPhys.checked noHull:chkNoHull.checked noRay:chkNoRay.checked
			)
		) else (
			messagebox "You must select displacements to set this property."
		)
	)
	on btn30 pressed  do
	(
	 if selection.count ==1 AND (getUserProp $ "ww_wwdt_displacement_brush" != undefined) then (
	 setFlagsFromSelection()
	) else (
	messagebox "This function only works when you have a single Displacement selected."
	)
	
	)
)
