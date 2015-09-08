	rollout wwmt_utilities "WWMT Model Functions" width:378 height:424
	(
		button btnQuickConvert "Quick WWMT" pos:[6,238] width:126 height:49 toolTip:"Make a WWMT model out of each selected piece of geometry."
		button btnQuickCompile "Quick Compile" pos:[15,311] width:102 height:20 toolTip:"Compile each WWMT model in the current selection."
		button btnExportAllTex "All Textures" pos:[15,334] width:102 height:21 toolTip:"Export all textures for all selected WWMT models."
		GroupBox grp4 "Generate" pos:[6,8] width:126 height:224
		GroupBox grp5 "Compile" pos:[7,293] width:120 height:74
		checkbox chkLocals "Local $origin" pos:[16,27] width:82 height:15 toolTip:"Set all of the new WWMT helpers to use the Local Origin."
		checkbox chkFlip "Flip" pos:[16,44] width:82 height:15 toolTip:"Set all of the new WWMT helpers to use the Flip origin."

		checkbox chk_defStatic "$staticprop" pos:[16,96] width:82 height:15 toolTip:"Set all of the new WWMT helpers to set $staticprop."
		checkbox chk_defAutoHull "Auto Hull" pos:[16,171] width:69 height:15 toolTip:"Set all of the new WWMT helpers to use Auto Hull."
		button btn_clearWWMT "Clear WWMT" pos:[7,371] width:121 height:25 toolTip:"Click to clear the WWMT data for the selected items."
		checkbox chk_defOpaque "$opaque" pos:[16,115] width:80 height:14
		checkbox chk_defMostlyopque "$mostlyopaque" pos:[16,133] width:90 height:18
		checkbox chk_defConcave "$concave" pos:[16,153] width:70 height:17
		button btn_allOrigins ">" pos:[109,27] width:18 height:14 toolTip:"Apply $origin setting to All Selected WWMT helpers."
		button btn_allFlip ">" pos:[109,44] width:18 height:14 toolTip:"Apply Flip setting to All Selected WWMT helpers."
		button btn_allStatic ">" pos:[109,96] width:18 height:14 toolTip:"Apply $staticprop setting to All Selected WWMT helpers."
		button btn_allOpaque ">" pos:[109,115] width:18 height:14 toolTip:"Apply $opaque setting to All Selected WWMT helpers."
		button btn_allMostlyOpaque ">" pos:[109,133] width:18 height:14 toolTip:"Apply $mostlyopaque setting to All Selected WWMT helpers."
		button btn_allConcave ">" pos:[109,153] width:18 height:14 toolTip:"Apply $concave setting to All Selected WWMT helpers."
		button btn_allAuto ">" pos:[109,171] width:18 height:14 toolTip:"Apply Auto Hull setting to All Selected WWMT helpers."
		dropdownList ddl_quick_surface "$surfaceprop" pos:[148,8] width:185 height:40
		button btn_allSurface ">" pos:[344,26] width:21 height:22 toolTip:"Apply this Surface Property to all selected WWMT helpers."
		checkbox chk_defLockQC "QC Lock" pos:[17,190] width:64 height:17
		button btn_allLock ">" pos:[109,190] width:18 height:14 toolTip:"Lock the QC of all Selected WWMT Helpers."
					
		
		combobox cbx_allModelPath "Set Model Paths" pos:[149,56] width:179 height:4
		combobox cbx_allMateriallPath "Set Material Paths" pos:[150,143] width:180 height:4
		dropdownList ddl_setShader "Set Material Shader" pos:[152,248] width:175 height:40 items:#("VertexLitGeneric", "UnlitGeneric")
		button btn_setAllModelPath ">" pos:[342,76] width:22 height:19 toolTip:"Set the relative Model Path of all selected WWMT helpers to this value."
		button btn_setAllMaterialPath ">" pos:[339,163] width:26 height:18 toolTip:"Set the relative Material Path of all selected WWMT helpers to this value."
		button btn_setAllShaders ">" pos:[338,269] width:27 height:18 toolTip:"Set the Shader to use for materials of all selected WWMT helpers to this value."
		
		button btn9 "Quick Hulls" pos:[148,388] width:220 height:24 toolTip:"Assign Quick Hulls to the selected WWMT helpers."
		spinner spn_max_verts "Max Verts Per Hull" pos:[191,365] width:177 height:16 range:[4,4096,44] type:#integer scale:1 toolTip:"Choose the maximum number of vertices any hull piece can have when being generated."
		GroupBox grp7 "Hull Functions" pos:[138,340] width:236 height:79

		button btn_setSkyScale "1/16" pos:[263,298] width:29 height:17 toolTip:"Set to Skybox Scale ( 1/16 )"
		button btn_setSkyScale2 "1/32" pos:[293,298] width:32 height:17 toolTip:"Set to L4D Skybox Scale ( 1/32 )"
		spinner spn_scale "Scale" pos:[241,318] width:84 height:16 range:[0.01,100,1] scale:0.1		
		
		
		
		
		
		
		label lbl3 "Sky Scales" pos:[192,300] width:52 height:15
		button btnScale ">" pos:[338,317] width:27 height:18 toolTip:"Set selected WWMT helpers to use this scale."
		
		checkbox chkOriginInSMD "Origin in SMD" pos:[16,58] width:85 height:14
		checkbox chkRotateOrigin "Rotate Origin" pos:[16,76] width:86 height:14
		button btnRotateOrigin ">" pos:[109,77] width:18 height:14 toolTip:"Rotate the Origin of all selected WWMT helpers."
		button btnOriginInSMD ">" pos:[109,59] width:18 height:14 toolTip:"Calculate origin values in the SMD if the SMD exporter supports it."
		
		
		
		
		
		button btn_deleteWWMT "Delete WWMT" pos:[8,400] width:120 height:18 toolTip:"Delete the WWMT helper and other WWMT utility helpers in the selection."
		
		spinner spnChannel "Channel" pos:[41,211] width:57 height:16 range:[0,100,1] type:#integer scale:1
		button btnChannel ">" pos:[110,211] width:16 height:16
		

					
					
					
					
					
		on wwmt_utilities open do
		(
			
		global wwmt_current_material_Paths
		global wwmt_current_model_Paths
		global wwmt_def_model_path
		global wwmt_def_material_path
		
		global wwmt_mappingChannel 
			
		spnChannel.value = wwmt_mappingChannel as integer
			
		if (wwmt_current_material_Paths != undefined AND wwmt_current_material_Paths.count > 0) do (	
			cbx_allMateriallPath.items= wwmt_current_material_Paths
		)
		if ( wwmt_current_model_Paths != undefined AND wwmt_current_model_Paths.count>0) do (
			cbx_allModelPath.items = wwmt_current_model_Paths
		)
		
		
			if wwmt_def_model_path != undefined  do (
							
					cbx_allModelPath.selection = 	findItem cbx_allModelPath.items wwmt_def_model_path 
							
			)
		
		
		
			if wwmt_def_material_path != undefined  do (
							
					cbx_allMateriallPath.selection = 	findItem cbx_allMateriallPath.items wwmt_def_material_path 
							
			)
			
			ddl_quick_surface.items = wwmt_surfaceprop_list
			
		
		--ddl_setShader.items = wwToolsFloater.rollouts[1].ddl_shader.items
		
		
		
		)
		on btnQuickConvert pressed do
		(
			
			
			if selection.count == 0 then (
				
				messagebox "This function only works when you have selected the objects you want to use for your WWMT helpers."
				
				) else (
			
				        coll = #()
				   
				        objcol = selection as array
						clearSelection()
						local wwmts = 0
						for obj in objcol do (
							
							if isDeleted obj == false AND superClassOf obj == GeometryClass do (
								local tempWWMT = ww_LOD_wrapper()
								tempWWMT.init()					
								tempWWMT.setTargetModel obj tempWWMT
								
								tempWWMT.setLocalOrigin chkLocals.checked
								tempWWMT.setAltOrigin chkFlip.checked
								tempWWMT.setAutoHull chk_defAutoHull.checked
								tempWWMT.setStaticprop chk_defStatic.checked
								tempWWMT.setSurfaceProperty ddl_quick_surface.selected
								
								
								tempWWMT.setOpaque chk_defOpaque.checked
								tempWWMT.setMostlyOpaque chk_defMostlyopque.checked
								tempWWMT.setLock chk_defLockQC.checked
								
								tempWWMT.setConcave chk_defConcave.checked
								
								
								tempWWMT.setModelPath cbx_allModelPath.text
								tempWWMT.setShaderType ddl_setShader.selected
								tempWWMT.setMaterialPath cbx_allMateriallPath.text
								tempWWMT.setScale spn_scale.value
								
								tempWWMT.setRotateRefsystem chkRotateOrigin.checked
								tempWWMT.setinternalOrigin chkOriginInSMD.checked
								tempWWMT.setUVW(spnChannel.value)	
									--tempWWMT.outputModelQC()
							
									append coll tempWWMT.target
								wwmts+=1
							
							)	
						
						)
						
						if coll.count > 0 then (
							
							select coll
							
							if wwmts == 0 then (
							
								messagebox "No WWMT helpers were created."
							
							) else (
							
							messagebox ((wwmts as string)+ " WWMT helper(s) were created.")
							
							)
							
							
							) else (
							
							 messagebox "No items were converted to WWMT models."
							
							)
						)
				   
				   )
		on btnQuickCompile pressed do
		(
					   
			macros.run "wallworm.com" "WallWormModelToolsQuickCompileMCR"
					   
			)
		on btnExportAllTex pressed do
		(
					
			macros.run "wallworm.com" "WallWormModelToolsQuickCompileVTFMCR"
					
					
					
		)
		on btn_clearWWMT pressed do
		(
		
		
			
			if selection.count == 0 then (
				
				messagebox "This function only works when you have selected objects."
				
				) else (
			
					macros.Run  "wallworm.com" "WallWormClearWWMTMCR"
				)
		
		
		)
		on btn_allOrigins pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
												tempWWMT.setLocalOrigin chkLocals.checked
												wwmts+=1
		
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_allFlip pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
		
												tempWWMT.setAltOrigin chkFlip.checked
		
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_allStatic pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
		
										tempWWMT.setStaticprop chk_defStatic.checked
										
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_allOpaque pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
		
										tempWWMT.setOpaque chk_defOpaque.checked
		
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_allMostlyOpaque pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
		
										tempWWMT.setMostlyOpaque chk_defMostlyopque.checked
										
		
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_allConcave pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
										
										tempWWMT.setConcave chk_defConcave.checked
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_allAuto pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
		
										tempWWMT.setAutoHull chk_defAutoHull.checked
										
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_allSurface pressed do
		(
					
											if selection.count == 0 then (
								
								messagebox "This function only works when you have selected a set of WWMT helpers."
								
								) else (
									   oldsel = selection as array
									    local wwmts = 0
									    clearSelection()
										for obj in oldsel do (
											
											isWWMTSource = getUserProp obj "wwmt_source_helper"	
											 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
														local tempWWMT = ww_LOD_wrapper()
														tempWWMT.init()					
														tempWWMT.setTargetModel obj tempWWMT
				
												tempWWMT.setSurfaceProperty ddl_quick_surface.selected
												
														wwmts+=1
												
												
											)
										
										)
										
										
										
										select oldsel
										
										if wwmts == 0 then (
											
											messagebox "No WWMT helpers were selected; no models were updated."
											
											) else (
											
											messagebox ((wwmts as string)+ " models were updated.")
											
											)
										
									)
					
					
					
					
					)
		on chk_defLockQC changed state do
		(
		
			)
		on btn_allLock pressed do
		(
					
								if selection.count == 0 then (
								
								messagebox "This function only works when you have selected a set of WWMT helpers."
								
								) else (
									   oldsel = selection as array
									    local wwmts = 0
									    clearSelection()
										for obj in oldsel do (
											
											isWWMTSource = getUserProp obj "wwmt_source_helper"	
											 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
														local tempWWMT = ww_LOD_wrapper()
														tempWWMT.init()					
														tempWWMT.setTargetModel obj tempWWMT
														tempWWMT.setLock chk_defLockQC.checked
														wwmts+=1
											)
										
										)
										
										
										
										select oldsel
										
										if wwmts == 0 then (
											
											messagebox "No WWMT helpers were selected; no models were updated."
											
											) else (
											
											messagebox ((wwmts as string)+ " models were updated.")
											
											)
										
									)
					
					
					
					
					
					
					
					
					
					
					)
		on btn_setAllModelPath pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
		
												tempWWMT.setModelPath cbx_allModelPath.text
		
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_setAllMaterialPath pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
		
												tempWWMT.setMaterialPath cbx_allMateriallPath.text
		
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn_setAllShaders pressed do
		(
					
										   
						if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT
		
												tempWWMT.setShaderType ddl_setShader.selected
		
												wwmts+=1
										
										
									)
								
								)
								
								
								
								select oldsel
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no models were updated."
									
									) else (
									
									messagebox ((wwmts as string)+ " models were updated.")
									
									)
								
							)
					)
		on btn9 pressed do
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
		on btn_setSkyScale pressed do
		(
			
			spn_scale.value = 0.0625
		
			
			)
		on btn_setSkyScale2 pressed do
		(
				
				spn_scale.value = 0.03125
				ww_scene_lods.setScale(spn_scale.value)	
				
		)
		on btnScale pressed do
		(
		
							   
								if selection.count == 0 then (
								
								messagebox "This function only works when you have selected a set of WWMT helpers."
								
								) else (
									   oldsel = selection as array
									    local wwmts = 0
									    clearSelection()
										for obj in oldsel do (
											
											isWWMTSource = getUserProp obj "wwmt_source_helper"	
											 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
														local tempWWMT = ww_LOD_wrapper()
														tempWWMT.init()					
														tempWWMT.setTargetModel obj tempWWMT
				
												tempWWMT.setScale spn_scale.value
												
				
														wwmts+=1
												
												
											)
										
										)
										
										
										
										select oldsel
										
										if wwmts == 0 then (
											
											messagebox "No WWMT helpers were selected; no models were updated."
											
											) else (
											
											messagebox ((wwmts as string)+ " models were updated.")
											
											)
										
									)
		
		)
		on btnRotateOrigin pressed do
		(
		--!TODO
						
			
								if selection.count == 0 then (
								
								messagebox "This function only works when you have selected a set of WWMT helpers."
								
								) else (
									   oldsel = selection as array
									    local wwmts = 0
									    clearSelection()
										for obj in oldsel do (
											
											isWWMTSource = getUserProp obj "wwmt_source_helper"	
											 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
														local tempWWMT = ww_LOD_wrapper()
														tempWWMT.init()					
														tempWWMT.setTargetModel obj tempWWMT
														tempWWMT.setRotateRefsystem chkRotateOrigin.checked
														wwmts+=1
											)
										
										)
		
										
										select oldsel
										
										if wwmts == 0 then (
											
											messagebox "No WWMT helpers were selected; no models were updated."
											
											) else (
											
											messagebox ((wwmts as string)+ " models were updated.")
											
											)
										
									)
			
			
			
			
			
		
		)
		on btnOriginInSMD pressed do
		(
		
								if selection.count == 0 then (
								
								messagebox "This function only works when you have selected a set of WWMT helpers."
								
								) else (
									   oldsel = selection as array
									    local wwmts = 0
									    clearSelection()
										for obj in oldsel do (
											
											isWWMTSource = getUserProp obj "wwmt_source_helper"	
											 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
														local tempWWMT = ww_LOD_wrapper()
														tempWWMT.init()					
														tempWWMT.setTargetModel obj tempWWMT
														tempWWMT.setinternalOrigin chkOriginInSMD.checked
														wwmts+=1
											)
										
										)
										
										
										
										select oldsel
										
										if wwmts == 0 then (
											
											messagebox "No WWMT helpers were selected; no models were updated."
											
											) else (
											
											messagebox ((wwmts as string)+ " models were updated.")
											
											)
										
									)
			
			
			
		)
		on btn_deleteWWMT pressed do
		(
		
		
			
			if selection.count == 0 then (
				
				messagebox "This function only works when you have selected objects."
				
				) else (
			
		
						
						macros.Run  "wallworm.com" "WallWormDeleteWWMTMCR"
						
				)
		
		
		)
		on btnChannel pressed do
		(
					
		
					
								if selection.count == 0 then (
								
								messagebox "This function only works when you have selected a set of WWMT helpers."
								
								) else (
									   oldsel = selection as array
									    local wwmts = 0
									    clearSelection()
										for obj in oldsel do (
											
											isWWMTSource = getUserProp obj "wwmt_source_helper"	
											 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
														local tempWWMT = ww_LOD_wrapper()
														tempWWMT.init()					
														tempWWMT.setTargetModel obj tempWWMT
				
														tempWWMT.setUVW(spnChannel.value)	
				
														wwmts+=1
												
												
											)
										
										)
										
										
										
										select oldsel
										
										if wwmts == 0 then (
											
											messagebox "No WWMT helpers were selected; no models were updated."
											
											) else (
											
											messagebox ((wwmts as string)+ " models were updated.")
											
											)
										
									)
					
					
				)
	)
	