

filein "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
filein "$scripts/WallWorm.com/common/settings_struct.ms"

try(destroyDialog wwmt_config)catch(
	   --there was not any open
	)
	
global wallworm_setting_presets = #()

rollout wwmt_config "Wall Worm Settings" width:793 height:647
(
	GroupBox grp2 "General Settings" pos:[497,446] width:275 height:40
	GroupBox grp4 "Paths" pos:[10,2] width:476 height:308
	button btn_expPath "modelsrc" pos:[20,38] width:52 height:18 toolTip:"Pick the root folder for your model exports. You probably want to choose your model source folder inside sourcesdk_content > yourmode."
	button btn_expMatPath "materialsrc" pos:[20,60] width:53 height:17 toolTip:"Pick the root folder for your material exports. You probably want to choose your material source folder inside sourcesdk_content > yourmode."
	checkbox chk_makeLayers "Make and Use Layers" pos:[504,462] width:127 height:14 toolTip:"Check this option if you want the tool to create layers for this model and all of its helpers in the Layer Manager."
	button btn_binDir "Bin Dir" pos:[20,104] width:53 height:17 toolTip:"Click Here to set the Bin Directory (your sdk bin folder for automatically compiling models and materials)"
	spinner spn_lodLimit "LOD List Length" pos:[103,470] width:121 height:16 range:[1,10,2] type:#integer scale:1 toolTip:"Choose the number of LODs to list in the LOD list controller."
	checkbox chk_compileModels "Compile Models on Export" pos:[211,351] width:146 height:18 toolTip:"Compile the model automatically when the export finishes. Note that this will fail if Steam is not running!"
	checkbox chk_openModelFolder "Open Model Folder on Export" pos:[211,368] width:158 height:18 toolTip:"Automatically open the model folder when exporting finishes."
	spinner spn_FOV "Field of View" pos:[88,491] width:136 height:16 range:[0,180,75] type:#integer toolTip:"Enter the Feild of View for your game. In HL2 this is 75."
	dropdownList ddl_resolution "Metric Resolution" pos:[22,509] width:200 height:40 items:#("1920 x 1080", "1680 x 1050", "1280 x 1024", "1920 x 1200", "1440 x 900", "1024 x 768", "1366 x 768") toolTip:"Choose the resolution that WWMT should use for calculating the LOD switch distance."
	GroupBox grp3 "LOD Settings" pos:[11,453] width:222 height:169
	radiobuttons rdo_exporter "Exporter Plugin" pos:[29,353] width:166 height:62 labels:#("Wunderboy's SMD Exporter", "Cannonfodder's SMD Exporter", "Wall Worm SMD Exporter") columns:1 toolTip:"Choose your prefered SMD Exporter. See docs for details."
	label lbl3 "Default Model Path" pos:[521,21] width:142 height:13
	label lbl4 "Default Material Path" pos:[518,149] width:142 height:13
	combobox edtDefMatPath "" pos:[515,165] width:210 height:6 toolTip:"Set the default material path for new models. Not required... but a time saver if you are working on multiple models for the same project."
	combobox edtDefModPath "" pos:[515,48] width:208 height:6 toolTip:"Set the default model path for new models. Not required... but a time saver if you are working on multiple models for the same project."
	button btn_getModelPath "Get from Model" pos:[629,22] width:92 height:12 toolTip:"Set the default model path from the values of the current model's Model Path. If no model is selected, nothing happens."
	button btn_getMaterialPath "Get from Model" pos:[629,148] width:92 height:12 toolTip:"Set the default material path from the values of the current model's Material Path. If no model is selected, nothing happens."
	GroupBox grp5 "Model Defaults" pos:[496,2] width:275 height:299
	button btn_gameInfoDir "Game Info" pos:[21,125] width:53 height:14 toolTip:"Choose the path to the game that you are working on to override Steam's current system-wide game path. Needed for games like Left 4 Dead."
	checkbox chk_nonRenderable "Export Non-Renderable Mesh as Bone" pos:[211,419] width:201 height:17 toolTip:"Only works in Wunderboy's SMD Exporter and the WWMT SMD exporter. Will only export as mesh objects that are renderable; non-renderable meshes are only exported as Bones... which is useful for things like CAT rigs."
	checkbox chk_makeHullsNonRenderable "Processed Hulls become Non-Renderable" pos:[509,373] width:215 height:19 toolTip:"Make all meshes non-renderable when added as hull or processed."
	HyperLink pathHelp "Path Help" pos:[405,13] width:55 height:15 address:"http://dev.wallworm.com/document/77/understanding_how_to_set_up_paths.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	button btnAddModelPath "+" pos:[729,49] width:23 height:19 toolTip:"Save Model Path for using later."
	button btnRemoveModelPath "-" pos:[729,73] width:23 height:21 toolTip:"Remove selected Model Path."
	button btnAddMaterialPath "+" pos:[728,166] width:23 height:19 toolTip:"Save Material Path for using later."
	button btnRemoveMaterialPath "-" pos:[728,189] width:23 height:21 toolTip:"Remove selected Material Path."
	checkbox chk_wwmt_overWriteQC "Overwrite Existing QC" pos:[211,385] width:165 height:18 tooltTip:"When set, the exporter will overwrite existing QCs. If not, the exporter will not overwrite an existing QC file."
	spinner spn_mappingChannel "Default Mapping Channel" pos:[343,476] width:112 height:16 range:[-1,100,1] type:#integer scale:1 toolTip:"Set the default mapping channel to use for exporting UVWs in new models. Feature only available with the WWMT SMD Exporter and Wunderboy's SMD Exporter 1.7+."
	checkbox chk_translucent "Translucent Only if Diffuse in Opacity" pos:[251,496] width:200 height:17 toolTip:"When off, materials will automatically get the $translucent flag if the diffuse map has an alpha channel. If on, the materials will only get $translucent if the diffuse bitmap is also in the opacity map and they have an alpha channel."
	GroupBox grp13 "Material Options" pos:[240,454] width:222 height:169
	checkbox chk8 "Force Opaque VMT if Model $opaque" pos:[251,515] width:199 height:16 toolTip:"When checked, VMTs for this model will not use the material's opacity and alpha settings if the model has the $opaque setting checked. If set, there is no $alpha, $translucent or $alphatest when the model has $opaque set."
	dropdownList ddl_hullhandling "Expensive Collision Hull Handling" pos:[507,328] width:244 height:40 items:#("Do Nothing", "Match $maxconvexpieces to Hull Count", "Use -fullcollide")

	button btn_expMapPath "mapsrc" pos:[20,82] width:53 height:17 toolTip:"Pick the map export folder for VMFs. You probably want to choose your map source folder inside sourcesdk_content > yourmod > map_src."


	checkbox chk9 "Alert Message on Compile" pos:[211,401] width:194 height:20 toolTip:"Check this option if you want an Message prompt after exporting models. If off, you can see the message in the MAXScript Listener (F11)."
	checkbox chkGiveMat "Give New Models a Material if None" pos:[251,533] width:197 height:17 toolTip:"When checked, adding models to a WWMT helper does not require the models to have a material. Instead, WWMT will apply a material to the model."
	checkbox chk_wwmt_refLOD "Generated LODs are References" pos:[22,554] width:190 height:21 toolTip:"When checked, the LOD Generator will make each LOD a Reference of the root mesh instead of a Copy. Changes to the root mesh mean you need to click Genereate for each LOD if using a Reference."
	checkbox chk_wwmt_use_local_origin "New Models Use Local Origin" pos:[517,278] width:161 height:18 toolTip:"Use this option if you regularly build models in a scene with other props; using this option is good if you export models mostly with the Anvil VMF Exporter, are using proxies or design away from the world origin."
	dropdownList ddl_wwmt_LODOptimize "LOD Resolution Modifier" pos:[20,573] width:204 height:40 items:#("MultiRes", "ProOptimizer","None") toolTip:"Choose the LOD Optimizer to use for generated LODs. The default is MultiRes... but if you have a newer version of Max you may want to use Pro Optimize."
	radiobuttons rdo_hullgen "Hull Generator" pos:[510,396] width:69 height:46 labels:#("MassFX", "Convexity") toolTip:"Choose the engine for generating collision hulls. Dependant on your version of Max and 3rd Party Plugins."
	GroupBox grp11 "Collision Hull Options" pos:[497,306] width:275 height:123
	checkbox chk_staticprop "New Models Default to $staticprop" pos:[516,258] width:215 height:19 toolTip:"Check this if you predominantly create static props and new models are assumed to be static props."
	combobox cbxFGD "FGD" pos:[22,145] width:456 height:4 toolTip:"Set the FGD file that contains all the data for your mod's entities."
	button btnAddFGD "Get FGD" pos:[73,145] width:64 height:16 toolTip:"Browse your computer for an FGD file that is used by your Mod."
	button btnAddFGDLine "+" pos:[140,145] width:28 height:16 toolTip:"Add the FGD address typed into the FGD field."
	button btnRemoveFGDLine "-" pos:[172,145] width:28 height:16 toolTip:"Remove the selected FGD from the FGD list."
	combobox cbxPresets "Setting Presets" pos:[498,494] width:213 height:8 toolTip:"Select a preset from the list or add a new one in the field below."
	button btnNewPreset "New" pos:[715,535] width:54 height:26 toolTip:"Create a New Preset"
	button btnSavePreset "Save" pos:[715,569] width:54 height:27 toolTip:"Save the current UI settings into the currently selected preset."
	button btnDeletePreset "Delete" pos:[716,604] width:53 height:26 toolTip:"Delete the current preset from the list."
	button btnSDK_Content "sdk_content" pos:[19,17] width:99 height:15 toolTip:"Set the folder that contains your mod's modelsrc, materialsrc and mapsrc folders."
	edittext edtModelsrc "" pos:[74,37] width:403 height:20
	edittext edtMaterialsrc "" pos:[74,59] width:402 height:18
	edittext edtMapsrc "" pos:[74,81] width:402 height:18
	edittext edtBinDir "" pos:[75,102] width:402 height:18
	button btnAutoDir "Auto from VProject" pos:[122,18] width:111 height:14 toolTip:"Try to detect and set the paths for your mod based on global environment settings in Windows. DOES NOT ALWAYS WORK!"
	edittext edtGameinfo "" pos:[74,123] width:404 height:17
	HyperLink cust "PSD Warning" pos:[367,555] width:71 height:15 address:"http://dev.wallworm.com/document/104/some_psds_can_crash_vtex.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	checkbox chkPSD "Allow PSD" pos:[251,553] width:107 height:15 toolTip:"Allow the use of PSD files for sending to the texture compile. Please read the PSD Warning link!"
	--checkbox chk_wwmt_mat_textransform_vmts "VMT Texture Transforms" pos:[552,110] width:186 height:14 toolTip:"When checked, world and blend materials will include the target material's texture transform in the VMT and the VMF exporter will not calculate per-texture coordinates on a face."
	--spinner spnVMTRotation "VMT Rotation" pos:[702,128] width:58 height:16 range:[-180,180,0] type:#float scale:1 toolTip:"Default texture rotation for brush material exporter."
	checkbox chkwwmt_oldModelVTFPath "Legacy VTF" pos:[251,572] width:74 height:18 toolTip:"Click here to output Model VTFs into the legacy WWMT directory instead of using the bitmap name for the output path."
	checkbox chkLegacyTex "Legacy Tex Names" pos:[251,593] width:120 height:15 checked:false toolTip:"When on, the references to model materials will always default to the materials diffuse bitmap. If off, the material in SMDs and model textures will use the material name. When using the WWMT SMD exporter, you should not use legacy texture names."
	checkbox chkRotateRefsystem "Rotate" pos:[687,278] width:83 height:20 toolTip:"Make new models default to rotating their origin Z axis by 90 degrees either in the QC or in the SMD (depending on the exporters and other settings in the model)."
	button btnImport "Import" pos:[715,500] width:55 height:27 toolTip:"Import Game settings. Browse for your mods GameConfig.txt file (usually in the Bin folder)." 
 
	button btnReparse "Reparse" pos:[203,145] width:44 height:16 toolTip:"Press here to rebuild the entity cache used by Wall Worm."
	
	edittext edtTextEditor "Text Editor" pos:[239,273] width:235 height:23 toolTip:"Enter the text editor your system uses. Common editors are notepad and notepad++"
	edittext edtWinRar "WinRAR" pos:[26,273] width:205 height:20 toolTip:"Enter the path to where WinRar is installed."
	GroupBox grp19 "Model Export Options" pos:[11,331] width:450 height:115
	edittext edtMatGenRoot "" pos:[74,244] width:403 height:23
	button btnMatGenRoot "MatGen" pos:[23,242] width:44 height:25 toolTip:"Set the root path of your raw materials collection used by the material library generator."
	



	checkbox chkDispList "Displacement Topo Listen" pos:[628,463] width:141 height:16 tooltip:"This is an advanced feature. Turn this off ONLY IF you are an advanced user. When off, WW no longer listens for displacement topology changes. This increases performance--but you must not change displacement topology!"
	

	
		function smd_tex_name_alert = (
		
			if  rdo_exporter.state != 3 AND chkLegacyTex.checked ==false then (
				messagebox "If not using the WWMT SMD Exporter, you must turn on the Legacy Tex Names to export textures."
			)
				
		
		
		)	
		
		
			function writePreferences = (
				with printAllElements on (
					local str = "global wallworm_setting_presets = " + (wallworm_setting_presets as string)
				)
					local prefFile 
					if doesFileExist "$userScripts\\WallWorm.com\\config\\sourcePresets.ms" == false then (
						prefFile = createFile "$userScripts\\WallWorm.com\\config\\sourcePresets.ms"
						close prefFile
						) else (
						
						)
					
					prefFile = openFile "$userScripts\\WallWorm.com\\config\\sourcePresets.ms" mode:"w+"
					format str to:prefFile
					close prefFile
				
				)
function fillSDKPaths = (
	if wwmt_export != undefined AND wwmt_export != "" then (
		edtModelsrc.text = wwmt_export
	)
	if wwmt_exportMats != undefined AND  wwmt_exportMats != "" then (
		 edtMaterialsrc.text = wwmt_exportMats
	)
	
	if wwdt_mapsrc != undefined AND wwdt_mapsrc != "" then (
		edtMapsrc.text = wwdt_mapsrc
	)
	
	)
function setUIFromGlobal = (	
			global wallworm_userIni
			global wwmt_def_fgd
			global wwmt_raw_mats 
			global wwdt_mapsrc 
			global wwmt_current_material_Paths 
			global wwmt_current_model_Paths 
			global wwmt_mappingChannel 
			global wwmt_FOV 
			global wwmt_verticalRes
			global wwmt_horizontalRes 
			global wwmt_LODOptimize
			global wwmt_hull_limit_handling 
			global wwmtExporter
			global wwmt_hull_tool 
			global wwmt_lodLimit 
			global wwmt_createLayers 
			global wwmt_copyTarget 
			global wwmtAutoOpenFolder 
			global wwmt_autoMaterialNewModel 
			global wwmt_mappingChannel
			global wwmt_overWriteQC 
			global wwmt_makeHullsNonRenderable 
			global wwmt_refLOD
			global wwmt_default_staticprop 
			global wwmt_use_local_origin 
			global wwmt_exportNonRenderableMeshAsBone 
			global wwmt_forceOpaqueFromModel 
			global wwmt_translucentOnlyIfOpacityMap 
			global wwmtCompileMessage 
			global wwmtAutoCompile 
			global wwmt_gameInfoDir 
			global wwmt_binDir 
			global wwmt_def_material_path 
			global wwmt_def_model_path 
			global wwmt_exportMats 
			global wwmt_export 
			global wwmt_allow_psd
			--global wwmt_mat_textransform_vmts
			global wwmt_oldModelVTFPath
			global wwmt_legacy_names
			global wwmt_rotateRefsystem
			global wallworm_text_editor
			global wallworm_winrar
			global wallworm_displacement_events

	if wallworm_displacement_events == undefined then (
		wallworm_displacement_events = true
	)

	edtTextEditor.text = wallworm_text_editor
	edtWinRar.text = wallworm_winrar

	if wwmt_raw_mats != undefined then (
		edtMatGenRoot.text = wwmt_raw_mats
	)


	if wwmt_binDir != undefined AND wwmt_binDir != "" then (
		edtBinDir.text = wwmt_binDir
	)
	
	
	if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" then (
		edtGameinfo.text = wwmt_gameInfoDir
	)		
	
	
	fillSDKPaths()
	
if ( wwmt_createLayers == "true") then ( 
		chk_makeLayers.checked =true
	) else (
		chk_makeLayers.checked =false
	)
	
	if (wallworm_displacement_events == undefined OR wallworm_displacement_events == "true" OR wallworm_displacement_events == true  ) then ( 
		chkDispList.checked = true
		global ww_wwdt_setDispHandlers
		
		if ww_wwdt_setDispHandlers == undefined then (
			filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
		)
		ww_wwdt_setDispHandlers deleteFirst:true
		
	) else (
		
		chkDispList.checked = false
		deleteAllChangeHandlers  id:#wallworm_topoDisplacementMesh
		deleteAllChangeHandlers  id:#wallworm_topoDisplacementBrushMesh
		
	)
	
	
	
	
	if ( wwmt_legacy_names == "true") then ( 
		chkLegacyTex.checked =true
	) else (
		chkLegacyTex.checked =false
	)

	
	if ( wwmt_default_staticprop == "true") then ( 
		chk_staticprop.checked =true
	
	) else (
		chk_staticprop.checked =false

	
	)
	
	
	if ( wwmt_rotateRefsystem == "true" OR wwmt_rotateRefsystem == true) then ( 
		chkRotateRefsystem.checked =true
	
	) else (
		chkRotateRefsystem.checked =false

	
	)
	
	
	
	if wwmt_oldModelVTFPath == "true" then (
		chkwwmt_oldModelVTFPath.checked = true
		
		) else (
		chkwwmt_oldModelVTFPath.checked = false
		)
	
	
	
	if ( wwmt_allow_psd == "true") then ( 
		chkPSD.checked =true
	
	) else (
		chkPSD.checked =false
	)
	/*
	if ( wwmt_mat_textransform_vmts == "true") then ( 
		chk_wwmt_mat_textransform_vmts.checked =true
	
	) else (
		chk_wwmt_mat_textransform_vmts.checked =false
	)
	*/
		

	
	
	if  wwmt_translucentOnlyIfOpacityMap == "true" then (
		chk_translucent.checked =true
		) else (
		
		chk_translucent.checked =false
		)
	
	if  wwmt_forceOpaqueFromModel == "true" then (
		chk8.checked =true
		) else (
		
		chk8.checked =false
		)
		
		
	

	
	
	
	
	
	
					if wwmtAutoOpenFolder == "true" then (
							
						chk_openModelFolder.checked=true

							
					)	else(
						chk_openModelFolder.checked=false
						
					)
						
						
						if wwmtAutoCompile == "true" then (
							
							chk_compileModels.checked=true
							
						)	else(
							chk_compileModels.checked=false
							
						)

						
						if wwmt_refLOD == "true" then (
							
							chk_wwmt_refLOD.checked=true
							
						)	else(
							chk_wwmt_refLOD.checked=false
							
						)
						
						
						if wwmt_use_local_origin == "true" then (
							
							chk_wwmt_use_local_origin.checked=true
							
						)	else(
							chk_wwmt_use_local_origin.checked=false
							
						)
						
						
						
						
						
						if wwmt_exportNonRenderableMeshAsBone == "true" then (
							
							chk_nonRenderable.checked=true
							
						)	else(
							chk_nonRenderable.checked=false
							
						)
						
						if wwmt_makeHullsNonRenderable == "true" then (
							
							chk_makeHullsNonRenderable.checked=true
							
						)	else(
							chk_makeHullsNonRenderable.checked=false
							
						)
						
						
						
						
						

							
							if wwmt_def_material_path != undefined do (
								edtDefMatPath.text = wwmt_def_material_path
							)
							if wwmt_def_model_path != undefined do (
								edtDefModPath.text = wwmt_def_model_path
							)
							
							
							
	
						if ww_scene_lods == undefined do (
								
	
							btn_getModelPath.enabled = false
							btn_getMaterialPath.enabled = false
						)
							
							
						if wwmt_autoMaterialNewModel == "true" then (
							chkGiveMat.checked = true
						) else (
							chkGiveMat.checked = false
						)
						
						
						
							
	spn_lodLimit.value = wwmt_lodLimit
						
	resString= wwmt_horizontalRes as string +" x " +  wwmt_verticalRes as string

						wwmtavailableSMDExporters = wwmt_smd_exporters_installed()
						
						

						
						
						
					if wwmtExporter == "3" OR wwmtavailableSMDExporters == 0 then (
					
					

					--messagebox "You do not have a valid SMD Exporter Plugin installed. Please go to www.wallworm.com and find your preferred exporter linked in the WWMT docs."
							
							--rdo_exporter.enabled = false

						wwmtExporter = "3"
						rdo_exporter.state = 3
						setINISetting wallworm_userIni "Settings" "wwmtExporter" "3"
						
					) else (
					
					if wwmtExporter == undefined AND wwmtExporter != "3" then (
						
					if wwmtavailableSMDExporters == 1 do (
						
						wwmtExporter = "1"
	
						setINISetting wallworm_userIni "Settings" "wwmtExporter" "1"
						
						--rdo_exporter.labels = #("Wunderboy's SMD Exporter")
						
					) 
					
					if wwmtavailableSMDExporters == 2 do (
						
						
						wwmtExporter = "2"
	
						setINISetting wallworm_userIni "Settings" "wwmtExporter" "2"
						
						--rdo_exporter.labels = #("Cannonfodder's SMD Exporter")
						
						
					) 
					
				) else ()
						
				)	
				
					if wwmtExporter == undefined OR wwmtExporter == "3" then (
						rdo_exporter.state = 3
						setINISetting wallworm_userIni "Settings" "wwmtExporter" "3"
					) else (
						
						if wwmtExporter == "2" then (
							rdo_exporter.state = 2
						) else (
							wwmtExporter = "1"
							rdo_exporter.state = 1
							setINISetting wallworm_userIni "Settings" "wwmtExporter" "1"
							)
							
					)		
						rdo_hullgen.state = (wwmt_hull_tool as integer)
						ddl_wwmt_LODOptimize.selection = wwmt_LODOptimize
						ddl_hullhandling.selection = wwmt_hull_limit_handling				
						ddl_resolution.selection = findItem 	ddl_resolution.items 	resString	
						spn_FOV.value =  (wwmt_FOV as integer)
						spn_mappingChannel.value = (wwmt_mappingChannel as integer)
							
						if wwmt_overWriteQC == "true" then (
							
							chk_wwmt_overWriteQC.checked=true
							
						)	else(
							chk_wwmt_overWriteQC.checked=false
							
						)						

	--	
						

						
	
						if wwmtCompileMessage == "true" then (
							
							chk9.checked=true
							
						)	else(
							chk9.checked=false
							
						)				
							
				currentList = GetINISetting wallworm_userIni "Directories" "wwmt_saved_model_path_list"
					
				wwmt_current_model_Paths = #()		


				if currentList != undefined AND currentList != "" do (
					
					for word in (filterString currentList ",") do( 
						append wwmt_current_model_Paths word
					)
					
					
					s = ""
					iteration = 1
					for so in wwmt_current_model_Paths do (

						if iteration > 1 do (
							append s ","
						)
						
						append s so
						iteration = iteration + 1
					)	
					edtDefModPath.items = wwmt_current_model_Paths				
				) 
				
				if edtDefModPath.items == undefined OR edtDefModPath.items.count == 0 do (
					
					if wwmt_def_model_path != undefined AND wwmt_def_model_path != "" do (
						append edtDefModPath.items wwmt_def_model_path
					)
					
					)


			
					if wwmt_def_model_path != undefined AND wwmt_def_model_path != "" do (
						
						
						edtDefModPath.text = wwmt_def_model_path
						
						
						if ((findItem edtDefModPath.items wwmt_def_model_path) == 0 ) do (
							tempArray = edtDefModPath.items
							append tempArray wwmt_def_model_path
							sort tempArray
							edtDefModPath.items = tempArray
						
						
						)
						
						edtDefModPath.selection = findItem edtDefModPath.items wwmt_def_model_path 
						
						)
					
						
						
						
						
				currentList = GetINISetting wallworm_userIni "Directories" "wwmt_saved_material_path_list"
			
				wwmt_current_material_Paths = #()		


				if currentList != undefined AND currentList != "" do (
					for word in (filterString currentList ",") do( 
						append wwmt_current_material_Paths word
					)
					
					
					s = ""
					iteration = 1
					for so in wwmt_current_material_Paths do (

						if iteration > 1 do (
							append s ","
						)
						
						append s so
						iteration = iteration + 1
					)	
					edtDefMatPath.items = wwmt_current_material_Paths				
				) 
				
				if edtDefMatPath.items == undefined OR edtDefMatPath.items.count == 0 do (
					
					if wwmt_def_material_path != undefined AND wwmt_def_material_path != "" do (
						append edtDefMatPath.items wwmt_def_material_path
					)
					
					)


			
					if wwmt_def_material_path != undefined AND wwmt_def_material_path != "" do (
						edtDefMatPath.text = wwmt_def_material_path
						
						if ((findItem edtDefMatPath.items wwmt_def_material_path) == 0 ) do (
						tempArray = edtDefMatPath.items
						append tempArray wwmt_def_material_path
						sort tempArray
						edtDefMatPath.items = tempArray
						
						
						)
						
						edtDefMatPath.selection = findItem edtDefMatPath.items wwmt_def_material_path 
						
						)
					
						
						
						
					
						
		currentList = GetINISetting wallworm_userIni "Directories" "wwmt_saved_fgd_list"
			if currentList == undefined then currentList = ""
				wwmt_current_fgds = #()		


				if currentList != undefined AND currentList != "" do (
					
					for word in (filterString currentList ",") do( 
						append wwmt_current_fgds word
					)
					
					
					s = ""
					iteration = 1
					for so in wwmt_current_fgds do (

						if iteration > 1 do (
							append s ","
						)
						
						append s so
						iteration = iteration + 1
					)	
					cbxFGD.items = wwmt_current_fgds				
				) 
				
				if cbxFGD.items == undefined OR cbxFGD.items.count == 0 do (
					
					if wwmt_def_fgd != undefined AND wwmt_def_fgd != "" do (
						append cbxFGD.items wwmt_def_fgd
					)
					
					)


			
					if wwmt_def_fgd != undefined AND wwmt_def_fgd != "" do (
						
						
						--cbxFGD.text = wwmt_def_fgd
						
						
						if ((findItem cbxFGD.items wwmt_def_fgd) == 0 ) do (
							tempArray = cbxFGD.items
							append tempArray wwmt_def_fgd
							sort tempArray
							cbxFGD.items = tempArray
						
						
						)
						
						cbxFGD.selection = findItem cbxFGD.items wwmt_def_fgd 
						
						)
						
						
						
)





	fn addFGD fgd = (
		
		if (fgd == undefined OR fgd == "") then (
			--messagebox "You must type in a path for your model to save it to the list."
		) else(
			
			local s = ""

					
			local tempArray = wwmt_config.cbxFGD.items
			local tempText = fgd
			
			appendIfUnique tempArray tempText
	         sort tempArray
			
			wwmt_config.cbxFGD.items = tempArray
	         wwmt_config.cbxFGD.selection = findItem tempArray tempText
	
			local iteration = 1
			so = ""
			for so in tempArray do (
				
				if iteration > 1 do (
					append s ","
				)
				append s so
				iteration = iteration + 1
			)	
	
	
	
			setINISetting wallworm_userIni "Directories" "wwmt_saved_fgd_list" s	
		)
		
		
		
		
		
		
		)


			

	function fillPresets = (
		global wallworm_setting_presets
		local presetLabels  = #()
		if wallworm_setting_presets.count > 0 then (
			
			for s in wallworm_setting_presets do (
				append presetLabels s.name
				
				
				)
			
			
			)
			
			cbxPresets.items = presetLabels
		)
		
		function setCurrentPresetIndex = (
			
			setINISetting wallworm_userIni "Presets" "wallwormCurrentSetting" (cbxPresets.selection as string)
			
		)


			

			

		
			
			

			
	

	
	
			/*
	on chk_wwmt_mat_textransform_vmts changed state do
	(
	
	
	
				if (state == true) then (
					wwmt_mat_textransform_vmts = "true"
					setINISetting wallworm_userIni "Materials" "wwmt_mat_textransform_vmts" "true"
				
				)else(
				
					wwmt_mat_textransform_vmts = "false"
					setINISetting wallworm_userIni "Materials" "wwmt_mat_textransform_vmts" "false"
				)
		
		
	)*/
	/*
	on spnVMTRotation changed val do
	(
	global wwmt_VMTRotation
	wwmt_VMTRotation = val
	setINISetting wallworm_userIni "Materials" "wwmt_VMTRotation" (wwmt_VMTRotation as string)
	)*/

		
		

					

					
	

	

	
	
	
	
	
	on wwmt_config open do
	(
	
	setUIFromGlobal()
	/*Fill Preset Manager*/
	global wallworm_userIni
		
	global	wallworm_setting_presets
	if (doesFileExist "$userScripts\\WallWorm.com\\config\\sourcePresets.ms") == true then (
		--readValue "$userScripts\\WallWorm.com\\config\\sourcePresets.ms" ignoreStringEscapes:true
		local temp = openFile "$userScripts\\WallWorm.com\\config\\sourcePresets.ms" mode:"r"
		if temp != undefined then (
			
			
			try (
				execute temp
			--execute ("try (\n"+temp+"\n)  catch (\nmessagebox \"There was a problem with the presets file.\"\n)")	
			--readValue temp ignoreStringEscapes:true
			) catch (
				messagebox "There was a problem reading the Presets file. It may be corrupt."
			)
			close temp
			
			fillPresets()
		)
	) else (
		
		wallwormSettingPresetsStr  = GetINISetting wallworm_userIni "Presets" "wallwormSettingPresets"
		if wallwormSettingPresetsStr != undefined AND wallwormSettingPresetsStr != "" then (
		
		local theStr = "global wallworm_setting_presets = " +  wallwormSettingPresetsStr
		execute theStr
		fillPresets()
		
	
		
	) else ()
		
	
		
	)	
		
	
		local currentPreset = getINISetting wallworm_userIni "Presets" "wallwormCurrentSetting"
		if currentPreset != undefined AND currentPreset != "" then (
			cbxPresets.selection = (currentPreset as number)
			) else ()
	
		
		
		
		
	
	)
	on btn_expPath pressed do
	(
			try(
				newPath = getSavePath caption:"Set Root Export Path"  historyCategory:"WallWorm" initialDir:wwmt_export
				) catch (
				newPath = getSavePath caption:"Set Root Export Path"  historyCategory:"WallWorm"
				)
			if (newPath != undefined) do (
				wwmt_export = newPath
				setINISetting wallworm_userIni "Directories" "export" wwmt_export
				
	
	
				edtModelsrc.text = wwmt_export
	
	
				--wwmt_config.btn_expPath.caption = wwmt_export
			)
		)
	on btn_expMatPath pressed do
	(
			try (
				newPath = getSavePath caption:"Set Root Export Path"  historyCategory:"WallWorm" initialDir:wwmt_exportMats
				) catch(
				newPath = getSavePath caption:"Set Root Export Path"  historyCategory:"WallWorm"
				
				)
			if (newPath != undefined) do (
				wwmt_exportMats = newPath
				setINISetting wallworm_userIni "Directories" "exportMats" wwmt_exportMats
				
	
	
				edtMaterialsrc.text = wwmt_exportMats
	
	
				--wwmt_config.btn_expMatPath.caption = wwmt_exportMats
			)
		)
	on chk_makeLayers changed state do
	(
			
			if (state == true) then (
				 wwmt_createLayers = "true"
				setINISetting wallworm_userIni "Settings" "createLayers" "true"
				
				)else(
				
				 wwmt_createLayers = "false"
				setINISetting wallworm_userIni "Settings" "createLayers" "false"
				)
			
			)
	on btn_binDir pressed do
	(
			try( 
				newPath = getSavePath caption:"Set Root Export Path"  historyCategory:"WallWorm" initialDir: wwmt_binDir
				) catch (
				newPath = getSavePath caption:"Set Root Export Path"  historyCategory:"WallWorm"
				)
			if (newPath != undefined) do (
				 wwmt_binDir = newPath
				setINISetting wallworm_userIni "Directories" "binDir"  wwmt_binDir
	
				edtBinDir.text = wwmt_binDir
	
	
	
				--wwmt_config.btn_expPath.caption = export
			)
		)
	on spn_lodLimit changed val do
	(
			 wwmt_lodLimit = val
							setINISetting wallworm_userIni "Settings" "lodLimit" ( wwmt_lodLimit as string)
		)
	on chk_compileModels changed state do
	(
			
			if (state == true) then (
				wwmtAutoCompile = "true"
				setINISetting wallworm_userIni "Settings" "wwmtAutoCompile" "true"
				
				)else(
				
				wwmtAutoCompile = "false"
				setINISetting wallworm_userIni "Settings" "wwmtAutoCompile" "false"
				)
			
			)
	on chk_openModelFolder changed state do
	(
	
			if (state == true) then (
				wwmtAutoOpenFolder = "true"
				setINISetting wallworm_userIni "Settings" "wwmtAutoOpenFolder" "true"
				
				)else(
				
				wwmtAutoOpenFolder = "false"
				setINISetting wallworm_userIni "Settings" "wwmtAutoOpenFolder" "false"
				)
			
			)
	on spn_FOV changed val do
	(
			 wwmt_FOV = val
			setINISetting wallworm_userIni "Settings" "FOV" ( wwmt_FOV as string)
		)
	on ddl_resolution selected sel do
	(
			--parse val
			--ddl_resolution.items[]
			selectedText = ddl_resolution.items[sel]
			iteration = 1
			for word in (filterString selectedText " x ") do(    
				
				if iteration == 1 do (
					 wwmt_horizontalRes = word as integer
					setINISetting wallworm_userIni "Settings" "horizontalRes" ( wwmt_horizontalRes as string)
					
					)
				if iteration == 2 do (
	
					 wwmt_verticalRes = word as integer
					setINISetting wallworm_userIni "Settings" "verticalRes" ( wwmt_verticalRes as string)
					)
					
					iteration = iteration +1
				)
			
		)
	on rdo_exporter changed stat do
	(
		
		
		
		
	
	wwmtExporter = (stat as string)
	
	
		
		if wwmtExporter=="3" then (
			
			makeSMDs = true
			) else (
			theClasses = exporterPlugin.classes
			makeSMDs = false;
			for c in theClasses while makeSMDs==false do (
				
				if wwmtExporter=="1" AND c == SMDExporter do (
					makeSMDs = true
				)
	
				if wwmtExporter=="2" AND  c== SmdExport do (
						
					makeSMDs = true
						
				)
				
				
				)
			)
		if makeSMDs == false do (
			
			if wwmtExporter=="1" then (
				messagebox "You have opted to use Jed's SMD Exporter but do not have it installed. Please go to www.wunderboy.org"
				wwmtExporter = "3"
				rdo_exporter.state = 3
				) else(
				
				messagebox "You have opted to use Cannonfodder's SMD Exporter but do not have it installed. Please go to www.chaosincarnate.net"
				wwmtExporter = "3"
				rdo_exporter.state = 3
				)
			
			)
			
	
			
			setINISetting wallworm_userIni "Settings" "wwmtExporter" (wwmtExporter as string)
		
			
			smd_tex_name_alert()
			
			
	
	)
	on edtDefMatPath selected sel do
	(	
	
	wwmt_def_material_path = edtDefMatPath.items[sel] 
	setINISetting wallworm_userIni "Directories" "def_material_path" wwmt_def_material_path
		
		
	)
	on edtDefMatPath entered text do
	(
	
	wwmt_def_material_path = text
	setINISetting wallworm_userIni "Directories" "def_material_path" wwmt_def_material_path
	
	)
	on edtDefModPath selected sel do
	(	
	
		
	wwmt_def_model_path = edtDefModPath.selected
	setINISetting wallworm_userIni "Directories" "def_model_path" wwmt_def_model_path
		
		
	)
	on edtDefModPath entered text do
	(
	
	wwmt_def_model_path = text
	setINISetting wallworm_userIni "Directories" "def_model_path" wwmt_def_model_path
	
	)
	on btn_getModelPath pressed do
	(
	   try (
		wwmt_def_model_path = ww_scene_lods.modelPath
		if wwmt_def_model_path != undefined do (
			setINISetting wallworm_userIni "Directories" "def_model_path" wwmt_def_model_path
			edtDefModPath.text = wwmt_def_model_path
			
			local s = ""
			
			local tempArray = edtDefModPath.items
			
			appendIfUnique tempArray wwmt_def_model_path
	         sort tempArray
	
			edtDefModPath.items = tempArray
	         edtDefModPath.selection = findItem tempArray wwmt_def_model_path
	
			local iteration = 1
			so = ""
			for so in tempArray do (
				
				if iteration > 1 do (
					append s ","
				)
				append s so
				iteration = iteration + 1
			)	
	
	
	
			setINISetting wallworm_userIni "Directories" "wwmt_saved_model_path_list" s	
			
			
			
			
			
		)
	) catch()
	
	)
	on btn_getMaterialPath pressed do
	(
	   try (
		wwmt_def_material_path = ww_scene_lods.materialPath
		if wwmt_def_material_path != undefined do (
			setINISetting wallworm_userIni "Directories" "def_material_path" wwmt_def_material_path
			edtDefMatPath.text = wwmt_def_material_path
			
			
			
			
			
			local s = ""
			
			local tempArray = edtDefMatPath.items
			
			appendIfUnique tempArray wwmt_def_material_path
	         sort tempArray
	
			edtDefMatPath.items = tempArray
	         edtDefMatPath.selection = findItem tempArray wwmt_def_material_path
	
			local iteration = 1
			so = ""
			for so in tempArray do (
				
				if iteration > 1 do (
					append s ","
				)
				append s so
				iteration = iteration + 1
			)	
	
	
	
			setINISetting wallworm_userIni "Directories" "wwmt_saved_material_path_list" s	
			
			
			
			
			
			
			
			
		)
	) catch()
	)
	on btn_gameInfoDir pressed do
	(
			try( 
				
				if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" then (
					newp = wwmt_gameInfoDir
					
					) else (
					
					newp = wwmt_binDir
					)
				
				newPath = getSavePath caption:"Set Game Info Path" historyCategory:"WallWorm" initialDir: newp
				) catch (
				newPath = getSavePath caption:"Set Game Info Path" historyCategory:"WallWorm"
				)
			if (newPath != undefined) do (
				 wwmt_gameInfoDir = newPath
				setINISetting wallworm_userIni "Directories" "gameInfoDir"  wwmt_gameInfoDir
				
				edtGameinfo.text = wwmt_gameInfoDir
	
				--wwmt_config.btn_expPath.caption = export
			)
		)
	on chk_nonRenderable changed state do
	(
			
			if (state == true) then (
				wwmt_exportNonRenderableMeshAsBone = "true"
				setINISetting wallworm_userIni "Settings" "wwmt_exportNonRenderableMeshAsBone" "true"
				
				)else(
				
				wwmt_exportNonRenderableMeshAsBone = "false"
				setINISetting wallworm_userIni "Settings" "wwmt_exportNonRenderableMeshAsBone" "false"
				)
			
	)
			
	on chkDispList changed stat do (
		global wallworm_displacement_events
		wallworm_displacement_events = stat			
		setINISetting wallworm_userIni "Displacements" "wallworm_displacement_events" (wallworm_displacement_events as string)
		
		if (wallworm_displacement_events == true  ) then ( 
			global ww_wwdt_setDispHandlers
			if ww_wwdt_setDispHandlers == undefined then (
				filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
			)
			ww_wwdt_setDispHandlers deleteFirst:true
			
		) else (
			

			deleteAllChangeHandlers  id:#wallworm_topoDisplacementMesh
			deleteAllChangeHandlers  id:#wallworm_topoDisplacementBrushMesh
			
		)
	
		
		
		
	)
			
	on chk_makeHullsNonRenderable changed state do
	(
			
			if (state == true) then (
				wwmt_makeHullsNonRenderable = "true"
				setINISetting wallworm_userIni "Settings" "wwmt_makeHullsNonRenderable" "true"
				
				)else(
				
				wwmt_makeHullsNonRenderable = "false"
				setINISetting wallworm_userIni "Settings" "wwmt_makeHullsNonRenderable" "false"
				)
			
			)
	on btnAddModelPath pressed do
	(
		
		if (edtDefModPath.text == undefined OR edtDefModPath.text == "") then (
			messagebox "You must type in a path for your model to save it to the list."
		) else(
			
			local s = ""
			
			local tempArray = edtDefModPath.items
			local tempText = edtDefModPath.text
			
			appendIfUnique tempArray tempText
	         sort tempArray
	
			edtDefModPath.items = tempArray
	         edtDefModPath.selection = findItem tempArray tempText
	
			local iteration = 1
			so = ""
			for so in tempArray do (
				
				if iteration > 1 do (
					append s ","
				)
				append s so
				iteration = iteration + 1
			)	
	
	
	
			setINISetting wallworm_userIni "Directories" "wwmt_saved_model_path_list" s	
		)
		
	)
	on btnRemoveModelPath pressed do
	(
		
		if (edtDefModPath.selection == 0) then (
			messagebox "You can only remove an item from the list if you have selected one."
		) else(
			
			local s = ""
			
	
			local tempArray = edtDefModPath.items
			
			deleteItem tempArray edtDefModPath.selection
			
			edtDefModPath.items = tempArray
			
			local iteration = 1
			so = ""
			for so in edtDefModPath.items do (
				
				if iteration > 1 do (
					append s ","
				)
				append s so
				iteration = iteration + 1
			)	
			setINISetting wallworm_userIni "Directories" "wwmt_saved_model_path_list" s	
		)
		
	)
	on btnAddMaterialPath pressed do
	(
		
		if (edtDefMatPath.text == undefined OR edtDefMatPath.text == "") then (
			messagebox "You must type in a path for your Material to save it to the list."
		) else(
			
			local s = ""
			
			local tempArray = edtDefMatPath.items
			local tempText = edtDefMatPath.text
			appendIfUnique tempArray tempText
	
	         sort tempArray
	
			edtDefMatPath.items = tempArray
	
	         edtDefMatPath.selection = findItem tempArray tempText
			local iteration = 1
			so = ""
			for so in edtDefMatPath.items do (
				
				if iteration > 1 do (
					append s ","
				)
				append s so
				iteration = iteration + 1
			)	
			setINISetting wallworm_userIni "Directories" "wwmt_saved_material_path_list" s	
		)
		
	)
	on btnRemoveMaterialPath pressed do
	(
		
		if (edtDefMatPath.selection == 0) then (
			messagebox "You can only remove an item from the list if you have selected one."
		) else(
			
			local s = ""
			
	
			local tempArray = edtDefMatPath.items
			
			deleteItem tempArray edtDefMatPath.selection
			
			edtDefMatPath.items = tempArray
			
			local iteration = 1
			so = ""
			for so in edtDefMatPath.items do (
				
				if iteration > 1 do (
					append s ","
				)
				append s so
				iteration = iteration + 1
			)	
			setINISetting wallworm_userIni "Directories" "wwmt_saved_material_path_list" s	
		)
		
	)
	on chk_wwmt_overWriteQC changed state do
	(
	
			if (state == true) then (
				wwmt_overWriteQC = "true"
				setINISetting wallworm_userIni "Settings" "overWriteQC" "true"
				
				)else(
				
				wwmt_overWriteQC= "false"
				setINISetting wallworm_userIni "Settings" "overWriteQC" "false"
				)
			
			)
	on spn_mappingChannel changed val do
	(
	
	
				wwmt_mappingChannel = (val as string)
				setINISetting wallworm_userIni "Settings" "wwmt_mappingChannel" (val as string)
				
	
			
			)
	on chk_translucent changed state do
	(
			
			if (state == true) then (
				wwmt_translucentOnlyIfOpacityMap= "true"
				setINISetting wallworm_userIni "Materials" "wwmt_translucentOnlyIfOpacityMap" "true"
				
				)else(
				
				wwmt_translucentOnlyIfOpacityMap = "false"
				setINISetting wallworm_userIni "Materials" "wwmt_translucentOnlyIfOpacityMap" "false"
				)
			
			)
	on chk8 changed state do
	(
	
		
		
			if (state == true) then (
				wwmt_forceOpaqueFromModel= "true"
				setINISetting wallworm_userIni "Materials" "wwmt_forceOpaqueFromModel" "true"
				
				)else(
				
				wwmt_forceOpaqueFromModel = "false"
				setINISetting wallworm_userIni "Materials" "wwmt_forceOpaqueFromModel" "false"
				)
		
	
	)
	on ddl_hullhandling selected sel do
	(
		   
						wwmt_hull_limit_handling = sel
		   				setINISetting wallworm_userIni "Settings" "wwmt_hull_limit_handling" (wwmt_hull_limit_handling as string)
		   )
	on btn_expMapPath pressed do
	(
		
	
			try (
				newPath = getSavePath caption:"Set Root Export Path" historyCategory:"WallWorm" initialDir:wwdt_mapsrc
				) catch(
				newPath = getSavePath caption:"Set Root Export Path" historyCategory:"WallWorm"
				
				)
			if (newPath != undefined) do (
	
				wwdt_mapsrc = newPath
				setINISetting wallworm_userIni "Directories" "exportMaps" wwdt_mapsrc
				edtMapsrc.text = wwdt_mapsrc
			
			)
		)
	on chk9 changed state do
	(
	
				if (state == true) then (
				 wwmtCompileMessage = "true"
				setINISetting wallworm_userIni "Settings" "wwmtCompileMessage" "true"
				
				)else(
				
				 wwmtCompileMessage = "false"
				setINISetting wallworm_userIni "Settings" "wwmtCompileMessage" "false"
				)	
	
	)
	on chkGiveMat changed state do
	(
			
			if (state == true) then (
				 wwmt_autoMaterialNewModel = "true"
				setINISetting wallworm_userIni "Materials" "wwmt_autoMaterialNewModel" "true"
				
				)else(
				
				 wwmt_autoMaterialNewModel = "false"
				setINISetting wallworm_userIni "Materials" "wwmt_autoMaterialNewModel" "false"
				)
			
	)
	on chk_wwmt_refLOD changed state do
	(
	
		
			if (state == true) then (
				 wwmt_refLOD = "true"
				setINISetting wallworm_userIni "Settings" "wwmt_refLOD" "true"
				
				)else(
				
				 wwmt_refLOD = "false"
				setINISetting wallworm_userIni "Settings" "wwmt_refLOD" "false"
				)
		
		
	
	
	)
	on chk_wwmt_use_local_origin changed state do
	(
	
		
			if (state == true) then (
				 wwmt_use_local_origin = "true"
				setINISetting wallworm_userIni "Settings" "wwmt_use_local_origin" "true"
				
				)else(
				
				 wwmt_use_local_origin = "false"
				setINISetting wallworm_userIni "Settings" "wwmt_use_local_origin" "false"
				)
		
		
	--
	
	)
	on ddl_wwmt_LODOptimize selected sel do
	(
			wwmt_LODOptimize = ddl_wwmt_LODOptimize.selection
			setINISetting wallworm_userIni "Settings" "wwmt_LODOptimize" (ddl_wwmt_LODOptimize.selection as string)
	)
	on rdo_hullgen changed stat do
	(
		
		if stat == 2 AND Maple3D_HullFnsAvailable() == false then (
			stat = 1
			messagebox "The Convexity Hull Wrapper is only available if you own Convexity 1.7+."
			
			) else ()
		
				wwmt_hull_tool = stat
		
		
				
				setINISetting wallworm_userIni "Settings" "wwmt_hull_tool" (wwmt_hull_tool as string)
	
	)
	on chk_staticprop changed state do
	(
	
		
			if (state == true) then (
				 wwmt_default_staticprop = "true"
				setINISetting wallworm_userIni "Settings" "wwmt_default_staticprop" "true"
				
				)else(
				
				 wwmt_default_staticprop = "false"
				setINISetting wallworm_userIni "Settings" "wwmt_default_staticprop" "false"
				)
		
		
	--
	
	)
	on cbxFGD selected sel do
	(
	
		
	if wwmt_def_fgd != cbxFGD.selected then (
		global wallworm_reparse_fgd = true
		
	)
		
	wwmt_def_fgd = cbxFGD.selected
	setINISetting wallworm_userIni "Directories" "wwmt_def_fgd" wwmt_def_fgd 
	
		macros.run "wallworm.com" "wallwormParseFGD2"
		
	)
	on btnAddFGD pressed do
	(
	
	
			newPath = getOpenFileName  caption:"Get FGD File" historyCategory:"WallWorm" types:"Source Game Definition(*.fgd)|*.fgd"
	
				if (newPath != undefined) do (
					 addFGD newPath
					
					--wwmt_config.btn_expPath.caption = export
					--close newPath
				)
	
	
	
	)
	on btnAddFGDLine pressed do
	(
		
		if (cbxFGD.text == undefined OR cbxFGD.text == "") then (
			messagebox "You must type in a path for your model to save it to the list."
		) else(
			addFGD cbxFGD.text 
			
		)
		
	)
	on btnRemoveFGDLine pressed do
	(
			
			if (wwmt_config.cbxFGD.selection > 0) then (
				
				local s = ""
	
						
				local tempArray = wwmt_config.cbxFGD.items
	
				
				deleteItem tempArray wwmt_config.cbxFGD.selection
				
				sort tempArray
				
				wwmt_config.cbxFGD.items = tempArray
				wwmt_config.cbxFGD.selection = findItem tempArray tempText
		
				local iteration = 1
				so = ""
				for so in tempArray do (
					
					if iteration > 1 do (
						append s ","
					)
					append s so
					iteration = iteration + 1
				)	
		
		
		
				setINISetting wallworm_userIni "Directories" "wwmt_saved_fgd_list" s	
			) else (
				
				messagebox "No FGD is selected to delete."
				
				)
			
			
			
			
			)
	on cbxPresets selected sel do
	(
				
				
				global wwmt_def_fgd
		
				local previousFGD = wwmt_def_fgd
				
				global wallworm_setting_presets
				
				
				if sel > 0 then (
					
				--	try (
					global wallworm_userIni
					wallworm_setting_presets[sel].preset.setGlobalsFromPreset()
					setINISetting wallworm_userIni "Presets" "wallwormCurrentSetting" (sel as string)
					setUIFromGlobal()
					--) catch (
						
						--print (getCurrentException())
						
						--)
					
					
						if wwmt_def_fgd != previousFGD then (
								macros.run "wallworm.com" "wallwormParseFGD2"
		
						)
					
					
					
					) else ()
				
				
				
			)
	on btnNewPreset pressed do
	(
			
			cbxPresets.selection = 0
			
			
			
		)
	on btnSavePreset pressed do
	(
		
		
		if cbxPresets.text != "" then (
			
					global wallworm_setting_presets
					local preset = WallWormPresetStore()
					preset.preset = WallWormConfig()
					preset.preset.setPresetFromGlobals()
					preset.name = cbxPresets.text
		
					if preset.name == undefined OR preset.name  == "" then (
						
						local sfn = maxFileName
				
						if sfn != undefined AND sfn != "" then (
						preset.name =substring  sfn 1 (sfn.count - 4)
						) else (
							
							preset.name = "New Preset"
						)
						
					)
			
					
					if wallworm_setting_presets.count == 0 OR cbxPresets.selection == 0 then (
						append wallworm_setting_presets preset
					) else (
						
						wallworm_setting_presets[cbxPresets.selection] = preset
					)
					
					
					
					
	
					writePreferences()
	
					--setINISetting wallworm_userIni "Presets" "wallwormSettingPresets" (wallworm_setting_presets as string)
					--cbxPresets.items = (updateVMFPresetList() as array)
					
					fillPresets()
			
				) else (
					
					messagebox "You can only save a preset if you give it a name."
					)
			)
	on btnDeletePreset pressed do
	(
					
					
					if cbxPresets.selection > 0 then (
						global wallworm_setting_presets
						
						deleteItem wallworm_setting_presets cbxPresets.selection
						writePreferences()
						fillPresets()
						) else (
						messagebox "You can only delete a preset if it is selected in the Preset List."
						)
					)
	on btnSDK_Content pressed do
	(
		
		
			try(
				newPath = getSavePath caption:"Set sdk_content MOD folder"  historyCategory:"WallWorm" initialDir:wwmt_sdk_folder
				) catch (
				newPath = getSavePath caption:"Set sdk_content MOD folder"  historyCategory:"WallWorm"
				)
				
				
			if (newPath != undefined) do (
				global wwmt_sdk_folder
				wwmt_sdk_folder = newPath
				setINISetting wallworm_userIni "Directories" "wwmt_sdk_folder" wwmt_sdk_folder
				
				wwmt_export = wwmt_sdk_folder + "\\modelsrc"
				setINISetting wallworm_userIni "Directories" "export" wwmt_export
				
				if doesFileExist wwmt_export == false then (
					makeDir wwmt_export all:true
				)					
	
				
				wwmt_exportMats = wwmt_sdk_folder + "\\materialsrc"	
				setINISetting wallworm_userIni "Directories" "exportMats" wwmt_exportMats
				if doesFileExist (wwmt_exportMats) == false then (
					makeDir wwmt_exportMats all:true
				)
					
					
				
				if doesFileExist (wwmt_sdk_folder + "\\maps") == true then (
					wwdt_mapsrc = wwmt_sdk_folder + "\\maps"
				) else (
					wwdt_mapsrc = wwmt_sdk_folder + "\\mapsrc"
				)
					
				if doesFileExist (wwdt_mapsrc) == false then (
					makeDir (wwdt_mapsrc) all:true
					
					)
				
				setINISetting wallworm_userIni "Directories" "exportMaps" wwdt_mapsrc
	
				fillSDKPaths()
			)
		)
	on edtModelsrc entered text do
	(
				wwmt_export = text
				setINISetting wallworm_userIni "Directories" "export" text
			)
	on edtMaterialsrc entered text do
	(
			wwmt_exportMats = text
			setINISetting wallworm_userIni "Directories" "exportMats" text
			
			)
	on edtMapsrc entered text do
	(
			wwdt_mapsrc = text
			setINISetting wallworm_userIni "Directories" "exportMats" text
			
			)
	on edtBinDir entered text do
	(
				wwmt_binDir = text
				setINISetting wallworm_userIni "Directories" "binDir" text
				
				
			)
	on btnAutoDir pressed do
	(
			try (
					global wwmt_sdk_folder
			
			wwmt_sdk_folder = (dotnetclass "System.Environment").GetEnvironmentVariable("sourcesdk")
		
			wwmt_valvemod_arraystr = (dotnetclass "System.Environment").GetEnvironmentVariable("VProject")
		
	
		
		
		if wwmt_valvemod_arraystr != undefined AND wwmt_valvemod_arraystr != "" then (
			
			wwmt_gameInfoDir = wwmt_valvemod_arraystr
			setINISetting wallworm_userIni "Directories" "gameInfoDir" wwmt_gameInfoDir
			edtGameinfo.text = wwmt_valvemod_arraystr
			
			
			wwmt_valvemod_array = filterString wwmt_valvemod_arraystr "\\"
			if wwmt_sdk_folder != undefined AND wwmt_valvemod_array.count > 0 then (
				append wwmt_sdk_folder ("_content\\"+wwmt_valvemod_array[wwmt_valvemod_array.count ])
				)
			
			)
			
			setINISetting wallworm_userIni "Directories" "wwmt_sdk_folder" wwmt_sdk_folder
			
			global wwmt_export
			
			wwmt_export =  (wwmt_sdk_folder+"\\modelsrc")
			setINISetting wallworm_userIni "Directories" "export" wwmt_export
			edtModelsrc.text = wwmt_export
			
			global wwmt_exportMats
			wwmt_exportMats =  (wwmt_sdk_folder+"\\materialsrc")
			setINISetting wallworm_userIni "Directories" "exportMats" wwmt_exportMats
			edtMaterialsrc.text = wwmt_exportMats
		
			global wwmt_binDir
			wwmt_binDir = ((dotnetclass "System.Environment").GetEnvironmentVariable("sourcesdk") + "\\bin\\orangebox\\bin")
			setINISetting wallworm_userIni "Directories" "binDir" wwmt_binDir
			edtBinDir.text = wwmt_binDir
			
			global  wwdt_mapsrc
			wwdt_mapsrc =  (wwmt_sdk_folder+"\\mapsrc")
			setINISetting wallworm_userIni "Directories" "exportMaps" wwdt_mapsrc
			edtMapsrc.text = wwdt_mapsrc
			
		) catch()
			
			)
	on edtGameinfo entered text do
	(
				global wwmt_gameInfoDir = text
				setINISetting wallworm_userIni "Directories" "gameInfoDir" text
	)
	on chkPSD changed state do
	(
			
			
					if (state == true) then (
					wwmt_allow_psd = "true"
					setINISetting wallworm_userIni "Materials" "wwmt_allow_psd" "true"
					
					)else(
					
					wwmt_allow_psd = "false"
					setINISetting wallworm_userIni "Materials" "wwmt_allow_psd" "false"
					)
			
			
			
			
			
			)
	on chkwwmt_oldModelVTFPath changed state do
	(
		global wwmt_oldModelVTFPath
	
				if (state == true) then (
					wwmt_oldModelVTFPath = "true"
					setINISetting wallworm_userIni "Materials" "wwmt_oldModelVTFPath" "true"
				
				)else(
				
					wwmt_oldModelVTFPath = "false"
					setINISetting wallworm_userIni "Materials" "wwmt_oldModelVTFPath" "false"
				)
		)
	on chkLegacyTex changed state do
	(
	
		
		global wwmt_legacy_names
	
				if (state == true) then (
					wwmt_legacy_names = "true"
					setINISetting wallworm_userIni "Materials" "wwmt_legacy_names" "true"
	
						
	
				)else(
				
					wwmt_legacy_names = "false"
					setINISetting wallworm_userIni "Materials" "wwmt_legacy_names" "false"
						if rdo_exporter.state != 3 then ( 
							messagebox "This setting is required for accurate results exporting models when using Cannonfodder's SMD Exporter or Wunderboy's SMD Exporter."
						)
						
				)
		
		
	
	
	)
	on chkRotateRefsystem changed state do
	(
		global wwmt_rotateRefsystem
			if (state == true) then (
				 wwmt_rotateRefsystem = "true"
				setINISetting wallworm_userIni "Settings" "wwmt_rotateRefsystem" "true"
				
				)else(
				
				 wwmt_rotateRefsystem = "false"
				setINISetting wallworm_userIni "Settings" "wwmt_rotateRefsystem" "false"
				)
		
		)
	on btnImport pressed do
	(
				
				
					
				
				if doesFileExist wwmt_binDir then 
				(
					initialDir = wwmt_binDir
				) else if doesFileExist wwmt_sdk_folder then (
					initialDir = wwmt_sdk_folder
				) else (
					initialDir = undefined
					)
				
				try (
					filename = getOpenFileName caption:"Import Game Settings from GameConfig.txt in your Bin Dir"  historyCategory:"WallWorm" initialDir:initialDir
					
				) catch (
					filename = getOpenFileName caption:"Import Game Settings from GameConfig.txt in your Bin Dir"  historyCategory:"WallWorm"
	
				)
				if filename != undefined then (
					
					
					presets = wallworm_parse_gameinfo filename		
					
					if presets.count > 0 then (
						
						
						
						
						
						
						
					global wallworm_setting_presets
					
						
					if wallworm_setting_presets.count == 0 then (
						
						local preset = WallWormPresetStore()
						preset.preset = WallWormConfig()
						preset.name = "Default"
						preset.preset.setPresetFromGlobals()
						preset.preset.sanitize_vars()
						
						append wallworm_setting_presets preset
						
						if preset.preset._wwmt_def_fgd != undefined AND  preset.preset._wwmt_def_fgd  != "" then (
							addFGD preset.preset._wwmt_def_fgd
						)
					)
						
		
	
			
					for pres in presets do (
						pres.preset.sanitize_vars()
						append wallworm_setting_presets pres
						if pres.preset._wwmt_def_fgd != undefined AND  pres.preset._wwmt_def_fgd  != "" then (
							addFGD pres.preset._wwmt_def_fgd
						)
					)
					
					
					
					
	
					writePreferences()
	
					--setINISetting wallworm_userIni "Presets" "wallwormSettingPresets" (wallworm_setting_presets as string)
					--cbxPresets.items = (updateVMFPresetList() as array)
					
					fillPresets()
						
						
						
						
						
						)
					
					
					
					
				)
			
			)
	on btnReparse pressed do
	(
					global wallworm_reparse_fgd = true
					macros.run "wallworm.com" "wallwormParseFGD2"
			)
	on edtTextEditor entered text do
	(
	
	wallworm_text_editor = text
	setINISetting wallworm_userIni "Applications" "text_editor" wallworm_text_editor
	
	)
	on edtWinRar entered text do
	(
	
	wallworm_winrar = text
	setINISetting wallworm_userIni "Applications" "winrar" wallworm_winrar
	
	)
	on edtMatGenRoot entered tex do
	(
			
			if doesFileExist tex == true then (
					global wwmt_raw_mats
					 wwmt_raw_mats = tex
					setINISetting wallworm_userIni "Directories" "wwmt_raw_mats"  wwmt_raw_mats
			) else (
					edtMatGenRoot.text = wwmt_raw_mats
					messagebox "You did not enter a path that exists on your computer."
			)
			
		)
	on btnMatGenRoot pressed do
	(
				global wwmt_raw_mats
					try( 
					
					if wwmt_raw_mats != undefined AND wwmt_raw_mats != "" then (
						newp = wwmt_raw_mats
						
						) else (
						
						newp = "$maps"
						)
					
					newPath = getSavePath caption:"Set Material Library Generator Root" historyCategory:"WallWorm" initialDir: newp
					) catch (
					newPath = getSavePath caption:"Set Game Info Path" historyCategory:"WallWorm"
					)
				if (newPath != undefined) do (
					 wwmt_raw_mats = newPath
					setINISetting wallworm_userIni "Directories" "wwmt_raw_mats"  wwmt_raw_mats
					
					edtMatGenRoot.text = wwmt_raw_mats
		
					--wwmt_config.btn_expPath.caption = export
				)	
		)
)

	
	--addRollout wwmt_config wwToolsConfigFloater

	createDialog wwmt_config

--wwmt_config.btn_expPath.caption = export

-- if  wwmt_copyTarget == "true" then (
-- 	
-- 	wwmt_config.chk_copy.checked =true
-- 	) else (
-- 	wwmt_config.chk_copy.checked =false
-- 	
-- 	)
-- 	
	