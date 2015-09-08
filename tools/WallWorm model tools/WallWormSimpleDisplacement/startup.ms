
	max create mode
	filein  "$scripts\\WallWorm.com\\custom_attributes\\displacements.ms"	

	
	print "Wallworm Displacement Startup Script running for this file."
	

	if (macros.run "wallworm.com" "WallWormDisplacementsCheckMCR")==false then (

		print "No displacements found in the scene... Displacement Startup Script Removed."
	) else (
	
		
		--try (
		filein "$scripts\\WallWorm.com\\WallWormModelTools\\ww_structs.ms"
		filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
		filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\anvil_funcs.ms"
			
		global wallworm_update_displacements
		global ww_wwdt_setDispHandlers
		global wallworm_sculpt_mesh_handlers
		wallworm_update_displacements()
		
		
		
		oldDisps = for obj in objects WHERE getUserprop obj "ww_wwdt_displacement_brush" != undefined AND (isProperty obj "ww_displacement" == false OR (isProperty obj "brushNode" AND obj.brushNode == undefined)) collect obj
		if oldDisps.count > 0 AND (queryBox "Old Format Displacements Found... do you want to update?" title:"Wall Worm Notice" beep:true) == true then (
			

			
			macros.run "wallworm.com" "WallWormRemoveDisplacementsStartupMCR"
			
			
			global wallworm_displacement_CA		
			global wallworm_displacement_brush_node_CA			
			
			if wallworm_displacement_CA == undefined OR wallworm_displacement_brush_node_CA == undefined then (
				include  "$scripts\\WallWorm.com\\custom_attributes\\displacements.ms"	
				
				print "Had to reinclude the displacement custom attributes."
			)
			
			global problemDisps = #()
			
			custAttributes.add oldDisps wallworm_displacement_CA
			
			for disp in oldDisps WHERE disp != undefined AND isDeleted disp == false do (
				
				myBrushName = getUserprop disp "ww_wwdt_displacement_brush"
				
				if myBrushName != undefined AND myBrushName != "" then (
						myBrushNode = getNodeByName myBrushName
					
						if myBrushNode != undefined then (
							power = (getUserProp myBrushNode "ww_wwdt_power") as integer
						
						
							fl = getUserProp myBrushNode "wwdt_displacement_flags"
							if fl != undefined AND fl != "" then (
								
								disp.dispflags = (fl as integer)
							)


							disp.power = power 

							disp.brushNode = myBrushNode
					

							custAttributes.add myBrushNode wallworm_displacement_brush_node_CA
								
							myBrushNode.power = power	
							
						) else (
							
							append problemDisps disp
						)
				) else (
					
					append problemDisps disp
					
				)
			
			)
		
			if problemDisps.count > 0 then (
				
					select problemDisps
				
					messagebox "There were some displacements that could not be updated. They have been selected."
			)
				
		)
		

		
		ww_wwdt_setDispHandlers()
		
		
		for obj in objects where isProperty obj "wallworm_edit_mesh" do (
			wallworm_sculpt_mesh_handlers obj
		)

	)
