
rollout anvil_displacements "Displacements" width:395 height:353
(
	
	button btn_create "Create Displacement at Helper" pos:[21,247] width:159 height:26 toolTip:"Create displacement(s) using the settings listed above."
	dropdownList ddl_creationType "Type" pos:[27,31] width:84 height:40 items:#("Ground", "Hill", "Open Hill", "Ring", "Corner", "Bulge", "Tunnel", "Tube", "Cube") toolTip:"Choose the type of displacement piece you are going to use."
	radiobuttons rdo_power "Power" pos:[116,39] width:93 height:30 labels:#("2", "3", "4") default:1 columns:3 toolTip:"Choose the power of this displacement. This relates to the Power in a Source Dislacement."
	--label lbl_version "Version " pos:[617,178] width:67 height:14
	listbox lbx_length "Length" pos:[27,79] width:67 height:5 items:#("32", "64", "128", "256", "512", "1024") selection:5 toolTip:"Length of side of displacement. Also used as default width and height."
	dropdownList ddl_height "Height" pos:[102,128] width:117 height:40 items:#("64", "128", "256", "512", "1024") selection:4 toolTip:"Height of displacement. Not relevant for Ground displacement."
	dropdownList ddl_width "Width" pos:[104,80] width:117 height:40 items:#("64", "128", "256", "512", "1024") selection:4 toolTip:"Width of each displacement."
	checkbox chk_lockWidth "Lock to Length" pos:[138,80] width:91 height:14 checked:true
	checkbox chk_lockHeight "Lock to Length" pos:[137,128] width:92 height:14 checked:true	
	
	
	spinner spn_rows "Rows" pos:[47,193] width:65 height:16 range:[1,100,1] type:#integer scale:1 toolTip:"Used to make multiple rows of displacements."
	spinner spn_columns "Columns" pos:[149,193] width:75 height:16 range:[1,100,1] type:#integer scale:1 toolTip:"Used to make multiple columns of displacements."
	button btn_sew "Sew" pos:[277,155] width:90 height:30 enabled:true toolTip:"Click here to sew the open vertices of displacements that line up next to each other. Note that this action can take a while."
	button ckb_editMode "Sculpt" pos:[277,27] width:90 height:38 toolTip:"Create a Sculpt Mesh for landscape molding and texture blending. If more than one displacement is selected, then creates a sculpt mesh from the selected displacements. Otherwise, uses all VISIBLE displacements in the sculpt mesh."
	checkbutton ckb_texMode "Paint Alpha" pos:[277,71] width:90 height:38 toolTip:"Click to edit texture blending on displacements with Alpha Blending using the Vertex Paint tool." 
 
 
	button btn8 "Lock" pos:[277,291] width:90 height:18 toolTip:"Lock the displacements in the scene so that they cannot be moved, rotated or scaled."
	button btn9 "Unlock" pos:[277,314] width:90 height:18 toolTip:"Unlock the displacements in the scene so that they can be moved, rotated or scaled."
	button ckbGridSnap "Grid and Snap" pos:[21,217] width:91 height:25 toolTip:"Toggle Snaps and Set the Home Grid size to match the value in the Length menu. Also switches to Pivot Point Center."
	checkbutton btn12 "Display Walkable" pos:[277,116] width:90 height:32 toolTip:"Hilight areas in green that are not walkable. Only works on selected meshes and works best in Edit Mode on a single mesh."
	button btn_getHelper "Get Helper" pos:[185,247] width:62 height:26 toolTip:"Select the displacement placement Helper. If it has been deleted, creates a new helper."
	button btn_planar_mapping "Planar Mapping" pos:[277,192] width:90 height:29 toolTip:"Click to add Planar UVW Mapping to the selected objects"
	GroupBox grp4 "Create Displacements" pos:[7,7] width:246 height:300
	GroupBox grp5 "Edit Displacements" pos:[261,7] width:119 height:222
	materialButton btn_material "Default Material" pos:[163,18] width:84 height:19
	button btnSelect "Select" pos:[9,316] width:76 height:21 toolTip:"Select all displacements in the current selection. If selection is empty, select all in scene."
	button btnHide "Hide Selected" pos:[90,316] width:76 height:21 toolTip:"Hide all selected displacements. If selection is empty, hide all in scene."
	button btnShow "Show All" pos:[172,316] width:80 height:21 toolTip:"Show all displacements in scene."
	checkbutton ckbMoveMode "Move Mode" pos:[277,252] width:90 height:23 toolTip:"Toggle the move state. When on, hides displacments and shows the underlying brush face. If off, hides underlying face and shows the displacement."
	GroupBox grp3 "Placement" pos:[262,233] width:118 height:108
	button btnConvertDispFromSel "Faces to Displacements" pos:[23,277] width:128 height:19 toolTip:"Create displacements for all selected faces in selected objects. Objects with no faces selected convert all faces in object."
	button btnPaintDisp "Paint Displacements" pos:[136,219] width:111 height:23 toolTip:"Start the Paint Displacement Application."
	button btn14 "-90" pos:[277,276] width:42 height:13
	button btn15 "+90" pos:[325,276] width:42 height:13
	button btnConvertPlanes "Convert Planes" pos:[154,278] width:91 height:18 toolTip:"Click to convert all selected Planes to Displacements. Planes must have 4,8 or 16 length/widthsegs."
	
	
	function buttonsAllowed = (
		/*
		if ww_wwdt_control_mesh == undefined then (
		 allowed = true
		) else (
			allowed = false
			)
		*/
		
		
		allowed = true
		btn_create.enabled = allowed
		btnConvertDispFromSel.enabled = allowed
		btnPaintDisp.enabled = allowed
		ckbMoveMode.enabled = allowed
		btn_sew.enabled = allowed
		btnConvertPlanes.enabled = allowed
	)
	
	
	
	
	

	
		

	button btnModPower "mod" pos:[213,54] width:31 height:14 toolTip:"Click to convert selected displacements to the given power. Only works with displacements not in an existing sculpt mesh."
	

	
	on anvil_displacements open do
	(
	
	lbx_length.items = ww_wwdt_dispsizes
	ddl_height.items = ww_wwdt_dispsizes
	ddl_width.items = ww_wwdt_dispsizes
	
	lbx_length.selection = 5
	ddl_height.selection = 5
	ddl_width.selection  = 5
		
	
		local temp = #(2,3,4)
		rdo_power.state = (findItem temp ww_wwdt_displacement_power)
	    buttonsAllowed()
	)
	on btn_create pressed do
	(
			max create mode
		--if ww_wwdt_control_mesh == undefined then (
	
			--if theHold.Holding() == false then (
				theHold.SuperBegin()
			--)
	
		
		
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
								local disp1 = ww_wwdt_makeDisplacement pwer l w  pos  showBrush:ckbMoveMode.state
								pos[1] = pos[1] +l
								with undo off (
									selectMore disp1[1]
								)
								) else (
								
									if (ddl_creationType.selected == "Hill" OR ddl_creationType.selected == "Cube" OR ddl_creationType.selected == "Open Hill"  OR ddl_creationType.selected == "Tube"  OR ddl_creationType.selected == "Tunnel") do (
										local disp1 = ww_wwdt_makeDisplacement pwer l w  pos showBrush:ckbMoveMode.state
										if   ddl_creationType.selected != "Tunnel" do (
											disp1[1].pos.z = disp1[1].pos.z+h
										)
										with undo off (
											selectMore disp1[1]
										)
									)
	
									if (ddl_creationType.selected == "Hill" OR ddl_creationType.selected == "Cube" OR ddl_creationType.selected == "Ring"  OR ddl_creationType.selected == "Corner"  OR ddl_creationType.selected == "Bulge") do (
										local disp2 = ww_wwdt_makeDisplacement pwer l h  pos  showBrush:ckbMoveMode.state
										if ddl_creationType.selected == "Tunnel" then (
											disp2[1].pos.x = disp2[1].pos.x + (w/2)
											) else (
											disp2[1].pos.x = disp2[1].pos.x - (w/2)
										)
										disp2[1].pos.z = disp2[1].pos.z + (h/2)
										
										--rotate disp2[2] (angleaxis -90 [0,1,0])
										--WorldAlignPivot disp2[1]
										--WorldAlignPivot disp2[2]
										with undo off (
											rotate disp2[1] (angleaxis -90 [0,1,0])
											selectMore disp2[1]
										)
										if ddl_creationType.selected != "Corner"  do (
											local disp3 = ww_wwdt_makeDisplacement pwer l h  pos showBrush:ckbMoveMode.state 
											if ddl_creationType.selected == "Tunnel" then (
												disp3[1].pos.x = disp3[1].pos.x - (w/2)
											) else (
											
												disp3[1].pos.x = disp3[1].pos.x + (w/2)
											)
											disp3[1].pos.z = disp3[1].pos.z + (h/2)
											
											--rotate disp3[2] (angleaxis 90 [0,1,0])
											--WorldAlignPivot disp3[1]
											--WorldAlignPivot disp3[2]
											with undo off (
												rotate disp3[1] (angleaxis 90 [0,1,0])
												selectMore disp3[1]
											)
										)
									)
									
									if (ddl_creationType.selected == "Hill" OR ddl_creationType.selected == "Open Hill" OR ddl_creationType.selected == "Cube" OR ddl_creationType.selected == "Ring"  OR ddl_creationType.selected == "Corner"  OR ddl_creationType.selected == "Bulge"  OR ddl_creationType.selected == "Tube"   OR ddl_creationType.selected == "Tunnel"  ) do (
						
										local disp4= ww_wwdt_makeDisplacement pwer h w  pos showBrush:ckbMoveMode.state 
										disp4[1].pos.y = disp4[1].pos.y - (l/2)
										disp4[1].pos.z = disp4[1].pos.z + (h/2)
										rotate disp4[1] (angleaxis 90 [1,0,0])
										--rotate disp4[2] (angleaxis 90 [1,0,0])
										--WorldAlignPivot disp4[1]
										--WorldAlignPivot disp4[2]
										selectMore disp4[1]
										if ddl_creationType.selected != "Corner" AND ddl_creationType.selected != "Bulge" do (
											local disp5 = ww_wwdt_makeDisplacement pwer h w  pos   showBrush:ckbMoveMode.state
											disp5[1].pos.y = disp5[1].pos.y + (l/2)
											disp5[1].pos.z = disp5[1].pos.z + (h/2)
											
											--rotate disp5[2] (angleaxis -90 [1,0,0])
											--WorldAlignPivot disp5[1]
	
											--WorldAlignPivot disp5[2]
											with undo off (
												rotate disp5[1] (angleaxis -90 [1,0,0])
												selectMore disp5[1]
											)
										)
									)
									if ddl_creationType.selected == "Cube" OR  ddl_creationType.selected == "Tunnel"   OR  ddl_creationType.selected == "Tube"do (
											local disp6 = ww_wwdt_makeDisplacement pwer l w  pos  showBrush:ckbMoveMode.state
											
	
											if ddl_creationType.selected == "Tunnel" do (
												disp6[1].pos.z = disp6[1].pos.z+h	
											)
											with undo off (
											rotate disp6[1] (angleaxis 180 [0,1,0])	
											--rotate disp6[2] (angleaxis 180 [0,1,0])	
											--WorldAlignPivot disp6[1]
											--WorldAlignPivot disp6[2]
											wwdt_fixVertPosZ disp6[1]
											wwdt_fixVertPosZ disp6[2]
											selectMore disp6[1]
											)
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
					
					wallworm_move_displacement_mode ckbMoveMode.state
					
					
					if ckbMoveMode.state == false then (
						setCommandPanelTaskMode #modify
					)
					
					--ww_wwdt_last_disp_position = ww_wwdt_last_placed_brush.pos
					/*if columns > 1 do (
						ww_wwdt_last_disp_position[2] = ww_wwdt_last_placed_brush.pos.y + w
					)*/
			) else (
				messagebox "You must choose a power for the displacement."
			)
		--)else (
			--messagebox "This function cannot be called when in Edit Mode."
			
		--)
		theHold.SuperAccept "Create Displacement(s)"
	)
	on rdo_power changed stat do
	(
	global ww_wwdt_displacement_power
	  case of (
	      
	     (stat==1):ww_wwdt_displacement_power = 2
	(stat==2):ww_wwdt_displacement_power = 3
	(stat==3):ww_wwdt_displacement_power = 4
	   )
	
	
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
			ww_wwdt_marker.size = (lbx_length.selected as integer) * 2
		)
	)
	on btn_sew pressed do
	(
		ww_wwdt_sewSelected $selection
	)
	on ckb_editMode pressed do
	(
		local doEditMode = true
		if selection.count < 2 then (
			
			doEditMode = queryBox "Because there are less than 2 objects selected, ALL displacements will be turned into a Sculpt Mesh. This could take a while if there are many displacements in the scene. Do you want to make a sculpt mesh from ALL displacements?"
		)
		if doEditMode then (
					wallworm_move_displacement_mode false
					ww_wwdt_editMode()
		)
			
			
	)
	on ckb_texMode changed state do
	(
		
		max create mode
		if state == true then (
	
	
					ww_wwdt_paintMode()
					max modify mode
	
	
				local v = VertexPaintTool()
				v.brushOpacity = 50
				v.curPaintMode = 1
				v.brushSize = 128
				v.brushOpacity  = 100
					
		) else (
				
			with undo off (		
				theDisplacements = for obj in objects WHERE isProperty obj "wallworm_edit_mesh" == true OR isProperty obj "ww_displacement" == true OR (getUserProp obj "ww_wwdt_displacement_brush") != undefined collect obj
			
				if theDisplacements.count > 0 then (
					convertToPoly theDisplacements
				)
			
			
	
				
			)
				
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
	on btn_material picked mtl do
	(
		if mtl !=undefined then (
			global ww_wwdt_defaultMat = mtl
			
			
			wallworm_update_ww_displibrary mtl
			
			
			
			
			
			
		)
	)
	on btnSelect pressed do
	(
			local use = objects
			if selection.count > 0 then (
				use = selection
				)
			local disps = for disp in use where (getUserProp disp "ww_wwdt_displacement_brush" != undefined ) collect disp 
			select disps
			disps = undefined
	
			)
	on btnHide pressed do
	(
	
			if selection.count > 0 then (
				wallworm_hide_displacements use:selection
				) else (
				wallworm_hide_displacements use:objects
				)
	
				
			)
	on btnShow pressed do
	(
				wallworm_show_displacements use:objects			
			)
	on ckbMoveMode changed state do
	(
	
	wallworm_move_displacement_mode state
	
	)
	on btnConvertDispFromSel pressed do
	(
		--if ww_wwdt_control_mesh == undefined then (
			
	
		
			macros.run "wallworm.com" "WallWormDisplacementCreateFromSelectionMCR"
	
		--)else (
			--messagebox "This function cannot be called when in Edit Mode."
			
			--)
		)
	on btnPaintDisp pressed do
	(
		
		--if ww_wwdt_control_mesh == undefined then (
			macros.run "wallworm.com" "WallWormDisplacementPainterMCR"
		--) else (
			--messagebox "This function cannot be called when in Edit Mode."
			
			--)
		)
	on btn14 pressed do
	(
	
		if selection.count > 0 then (
			 for obj in (selection as array) do (
				 in coordsys local  (
				  rotate obj (angleaxis -90 [0,0,1]) 
				 )
			 )
			redrawviews()
		 )
		)
	on btn15 pressed do
	(
	
		if selection.count > 0 then (
			 for obj in (selection as array)  do (
				in coordsys local  (
					rotate obj (angleaxis 90 [0,0,1]) 
				)
			)
			redrawviews()
		)
	
	)
	on btnConvertPlanes pressed do
	(
	macros.run "wallworm.com" "WallWormDisplacementCreateFromPlanesMCR"
	
	)
	on btnModPower pressed  do
	(
		
		
		res = yesNoCancelBox "Delete Originals? If no, there will be copies of the displacements at the new power." title:"Displacement Modification Confirmation" beep:false
		
		
		case res of (
			#yes:wallworm_convert_displacements_power (selection as array) (rdo_power.state + 1) deleteOriginal:true 
			#no:wallworm_convert_displacements_power (selection as array) (rdo_power.state + 1) deleteOriginal:false 
			default:(
				print "No updates to displacements."
			)
			
		)
		
		
		
		
	)
)
