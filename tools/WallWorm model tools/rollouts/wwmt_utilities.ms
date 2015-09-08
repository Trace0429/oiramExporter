	rollout wwmt_utilities "Utilities" width:250 height:880
	(
		HyperLink utilLink "Utilities Help" pos:[127,7] width:111 height:20 address:"http://dev.wallworm.com/document/63/utilities_rollout.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		materialButton btnSkins "Pick Skin Material" pos:[6,6] width:111 height:23 enabled:false toolTip:"Browse your materials to create a Skinfamily... you must select a Mulit Sub-Object Material. Each material in the Multimaterial will become a skin someone can choose for the model."
		button btn_exportTextures "Export Textures" pos:[6,36] width:111 height:29 toolTip:"Click Here to create texures (both VMTs and VTFs) from the materials and bitmaps applied to your model and LODs."
		button btnQuickConvert "Quick WWMT" pos:[11,587] width:225 height:22 toolTip:"Make a WWMT model out of each selected piece of geometry."
		button btnQuickCompile "Quick Compile" pos:[150,115] width:77 height:38 toolTip:"Compile each WWMT model in the current selection."
		button btnExportAllTex "All Textures" pos:[150,160] width:78 height:38 toolTip:"Export all textures for all selected WWMT models."
		GroupBox grp1 "Scene Process Functions" pos:[3,72] width:239 height:24
		GroupBox grp4 "Generate" pos:[12,97] width:126 height:208
		GroupBox grp5 "Compile" pos:[143,97] width:95 height:113
		checkbox chkLocals "Local $origin" pos:[22,116] width:82 height:15 toolTip:"Set all of the new WWMT helpers to use the Local Origin."
		checkbox chkFlip "Flip" pos:[22,133] width:82 height:15 toolTip:"Set all of the new WWMT helpers to use the Flip origin."

		checkbox chk_defStatic "$staticprop" pos:[22,186] width:82 height:15 toolTip:"Set all of the new WWMT helpers to set $staticprop."
		checkbox chk_defAutoHull "Auto Hull" pos:[22,261] width:69 height:15 toolTip:"Set all of the new WWMT helpers to use Auto Hull."
		button btn_clearWWMT "Clear WWMT" pos:[142,217] width:95 height:43 toolTip:"Click to clear the WWMT data for the selected items."
		checkbox chk_defOpaque "$opaque" pos:[22,205] width:80 height:14
		checkbox chk_defMostlyopque "$mostlyopaque" pos:[22,223] width:90 height:18
		checkbox chk_defConcave "$concave" pos:[22,243] width:70 height:17
		checkbutton ckb_expMorphsAsVTA "Morphs As VTAs" pos:[128,768] width:100 height:41 enabled:false toolTip:"Export Morphs as VTAs in model."
		button btn_expVTAs "Export VTAs" pos:[14,769] width:101 height:40 enabled:false toolTip:"Run VTA Export on Morphs in model."
		GroupBox grpVTA "VTA Functions" pos:[3,751] width:238 height:106
		button btn_generateMaterialLibrary "Create Material Library" pos:[123,36] width:119 height:29 toolTip:"Click to generate Material Libraries from folders on your computer."
		button btn_allOrigins ">" pos:[115,116] width:18 height:14 toolTip:"Apply $origin setting to All Selected WWMT helpers."
		button btn_allFlip ">" pos:[115,133] width:18 height:14 toolTip:"Apply Flip setting to All Selected WWMT helpers."
		button btn_allStatic ">" pos:[115,186] width:18 height:14 toolTip:"Apply $staticprop setting to All Selected WWMT helpers."
		button btn_allOpaque ">" pos:[115,205] width:18 height:14 toolTip:"Apply $opaque setting to All Selected WWMT helpers."
		button btn_allMostlyOpaque ">" pos:[115,223] width:18 height:14 toolTip:"Apply $mostlyopaque setting to All Selected WWMT helpers."
		button btn_allConcave ">" pos:[115,243] width:18 height:14 toolTip:"Apply $concave setting to All Selected WWMT helpers."
		button btn_allAuto ">" pos:[115,261] width:18 height:14 toolTip:"Apply Auto Hull setting to All Selected WWMT helpers."
		dropdownList ddl_quick_surface "$surfaceprop" pos:[12,311] width:185 height:40
		button btn_allSurface ">" pos:[208,329] width:21 height:22 toolTip:"Apply this Surface Property to all selected WWMT helpers."
		checkbox chk_defLockQC "QC Lock" pos:[23,280] width:64 height:17
		button btn_allLock ">" pos:[115,280] width:18 height:14 toolTip:"Lock the QC of all Selected WWMT Helpers."
					
		
		combobox cbx_allModelPath "Set Model Paths" pos:[13,359] width:179 height:4
		combobox cbx_allMateriallPath "Set Material Paths" pos:[14,446] width:180 height:4
		dropdownList ddl_setShader "Set Material Shader" pos:[16,535] width:175 height:40 items:#("VertexLitGeneric", "UnlitGeneric")
		button btn_setAllModelPath ">" pos:[206,379] width:22 height:19 toolTip:"Set the relative Model Path of all selected WWMT helpers to this value."
		button btn_setAllMaterialPath ">" pos:[203,466] width:26 height:18 toolTip:"Set the relative Material Path of all selected WWMT helpers to this value."
		button btn_setAllShaders ">" pos:[202,556] width:27 height:18 toolTip:"Set the Shader to use for materials of all selected WWMT helpers to this value."
		button btnCollectSkins "Collect Skins from Proxies" pos:[20,693] width:208 height:34 enabled:false toolTip:"Collect materials from proxies of this model and add them to the model's skins."
		button btnCreateProxy "Create Proxy" pos:[20,654] width:92 height:34 enabled:false toolTip:"Create a proxy of this model for re-use in the scene."
		GroupBox grp13 "Proxy Functions" pos:[4,632] width:236 height:111


		HyperLink cust2 "Understanding VTA/Flex Export" pos:[15,818] width:213 height:20 address:"http://dev.wallworm.com/document/76/making_facial_animations.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
		button btn59 "More Proxy Funcs" pos:[114,654] width:112 height:34
		checkbox chkOriginInSMD "Origin in SMD" pos:[22,150] width:85 height:14
		checkbox chkRotateOrigin "Rotate Origin" pos:[22,168] width:86 height:14
		button btnRotateOrigin ">" pos:[115,169] width:18 height:14 toolTip:"Rotate the Origin of all selected WWMT helpers."
		button btnOriginInSMD ">" pos:[115,151] width:18 height:14 toolTip:"Calculate origin values in the SMD if the SMD exporter supports it."
		button btn_deleteWWMT "Delete WWMT" pos:[143,264] width:94 height:42 toolTip:"Delete the WWMT helper and all other helpers in the selection."
		on wwmt_utilities open do
		(
		
		global wwmt_current_material_Paths
		global wwmt_current_model_Paths
		global wwmt_def_model_path
		global wwmt_def_material_path
		
			
		
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
		on btnSkins picked mtl do
		(
		
			if classOf mtl == MultiMaterial then (
				ww_scene_lods.target.mat = mtl
			) else (
				messagebox "FAILED!!\n\nYou can only use a Multi/Sub-Object Material for Skins!\n\n**Each material in the MultiMaterial will become a skin in the skinfamily."
			)
		
		)
		on btn_exportTextures pressed do
		(
					if ww_scene_lods.canCompile "tex" then (
					include "$scripts/WallWorm.com/WallWormModelTools/textureExport.ms"
					) else (
						messagebox "To compile textures, the following requirements must be met:\n\n*Set a \"Material Path\" in the Export Options rollout\n*Have valid materials (with Bitmaps in the diffuse slots) on model\n*\"Bin Dir\" AND \"Material Root Directory\" set in the Settings floater"
						)
					
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
								tempWWMT.setRotateRefsystem chkRotateOrigin.checked
								tempWWMT.setinternalOrigin chkOriginInSMD.checked
								
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
											tempWWMT.outputModelQC()
											wwmts+=1
										) catch (
		
											append failed ("Failed to Export: "+ tempWWMT.modelName)
											)
								
							)
						
						)
						
						
						
						select oldsel
						local failedmessage = ""
						if failed.count > 0 do (
							
							failedmessage= "\n\n("+(failed.count as string)+") Model(s) failed to export. Press F11 to see the list."
							for i in failed do (
								print i
								)
							)
						
						if wwmts == 0 then (
							
							messagebox ("No no models were exported. Either no WWMT helpers were selected or there were errors."+failedmessage)
							
							) else (
							
							messagebox ((wwmts as string)+ " models were exported."+failedmessage)
							
							)
						
					)
					   
			)
		on btnExportAllTex pressed do
		(
					
				if selection.count == 0 then (
				
					messagebox "This function only works when you have selected a set of WWMT helpers."
				
				) else (
						oldsel = selection as array
					   
					    clearSelection()
						for obj in oldsel do (
							
							isWWMTSource = getUserProp obj "wwmt_source_helper"	
							 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel obj tempWWMT
										tempWWMT.populateMyMaterials()
										for m in tempWWMT.materials do (
											try (
												if m.diff != undefined do (
													m.compileTexture m.diff "diff"
												)
											) catch()
											try (
												if m.bump != undefined do (
												m.compileTexture m.bump "bump"
													)
											) catch()
											try (
												if m.ambient != undefined do (
													m.compileTexture m.ambient "ambient"
												)
											) catch()
											try (
												if m.normal != undefined do (
												m.compileTexture m.normal "normal"
											)
											) catch()
											try (
												if m.spec != undefined do (
													m.compileTexture m.spec "spec"
												)
											) catch()
											try (
												if m.specLevelMap != undefined do (
													m.compileTexture m.specLevelMap "specLevelMap"
												)
											) catch()
											try (
												if m.illum != undefined do (
													m.compileTexture m.illum "illum"
												)
											) catch()
		
												
										
										)
		
							)
						
						)
					
						select oldsel
					
					)
					
					
					
		)
		on btn_clearWWMT pressed do
		(
		
		
			
			if selection.count == 0 then (
				
				messagebox "This function only works when you have selected objects."
				
				) else (
			
		
						
						macros.Run  "wallworm.com" "WallWormClearWWMTMCR"
						
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
		
		
		on ckb_expMorphsAsVTA changed state do
		(
		
		ww_scene_lods.setMorphasvta state
		
		)
		on btn_expVTAs pressed do
		(
			if ww_scene_lods.areMorphs() == true then (
					max select all
					clearNodeSelection()
		
					select ww_scene_lods.targets
					ww_scene_lods.resetBonesArray()
						if ww_scene_lods.bonesarray.count > 0 then (
							selectMore ww_scene_lods.bonesarray
						) 
						
			if wwmt_exportNonRenderableMeshAsBone != undefined AND wwmt_exportNonRenderableMeshAsBone != "" AND (wwmt_exportNonRenderableMeshAsBone == "true" OR wwmt_exportNonRenderableMeshAsBone == true ) then (
				
				exportNonRenderableMeshAsBone = true
				
				) else (
				
				exportNonRenderableMeshAsBone = false
				)
						
						
						ww_scene_lods.exportVTAs exportNonRenderableMeshAsBone
					) else (
						messagebox "This function only works on a model that has a Morpher or Morph-O-Matic modifier."
						)
		)
		on btn_generateMaterialLibrary pressed do
		(
		try (
		fileIn "$scripts\\WallWorm.com\\common\\wwmt_material_library_generator.ms"
		) catch(
			messagebox (getCurrentException)
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
		on btnCollectSkins pressed do
		(
		
		 ww_scene_lods.gatherMySkins()
						
		
		)
		on btnCreateProxy pressed do
		(
			try (
				local proxy = ww_scene_lods.createProxy()
				select proxy
			) catch (
				print (getCurrentException() as string)
				messagebox "The proxy could not be created. Check the MAXScript listener (F11) for more info."
				)
		)
		on btn59 pressed do
		(
		
		macros.run "wallworm.com" "WallWormModelToolsProxyToolsMCR"
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
	)
	