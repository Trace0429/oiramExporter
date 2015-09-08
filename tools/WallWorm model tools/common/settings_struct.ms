Struct WallWormConfig (
	_wwmt_def_fgd,
	_wwmt_raw_mats,
	_wwdt_mapsrc,
	_wwmt_current_material_Paths,
	_wwmt_current_model_Paths,
	_wwmt_mappingChannel,
	_wwmt_FOV,
	_wwmt_verticalRes,
	_wwmt_horizontalRes,
	_wwmt_LODOptimize,
	_wwmt_hull_limit_handling,
	_wwmtExporter,
	_wwmt_hull_tool,
	_wwmt_lodLimit,
	_wwmt_createLayers,
	_wwmt_copyTarget,
	_wwmtAutoOpenFolder,
	_wwmt_autoMaterialNewModel,
	_wwmt_overWriteQC,
	_wwmt_makeHullsNonRenderable,
	_wwmt_refLOD,
	_wwmt_default_staticprop,
	_wwmt_use_local_origin,
	_wwmt_exportNonRenderableMeshAsBone,
	_wwmt_forceOpaqueFromModel,
	_wwmt_translucentOnlyIfOpacityMap,
	_wwmtCompileMessage,
	_wwmtAutoCompile,
	_wwmt_gameInfoDir,
	_wwmt_binDir,
	_wwmt_def_material_path,
	_wwmt_def_model_path,
	_wwmt_exportMats,
	_wwmt_export,
	_wwmt_allow_psd,
	_wwmt_mat_textransform_vmts,
	_wwmt_oldModelVTFPath,	
	_wwmt_legacy_names,
	_wwmt_rotateRefsystem,
	_wallworm_text_editor="notepad",
	_wallworm_winrar,
	_wallworm_displacement_events = true,
	
	function replace_improper_vals str = (
		
			str = substituteString str "\t" "\\t"
			str = substituteString str "\n" "\\n"
			str		
	),
	
	function sanitize_vars = (

		_wwmt_raw_mats = replace_improper_vals (wallworm_remove_last_slash	(wallworm_FsToBs ( _wwmt_raw_mats)) char:"\\"		)
		_wwdt_mapsrc = replace_improper_vals (wallworm_remove_last_slash	(wallworm_FsToBs ( _wwdt_mapsrc )) char:"\\"	)	
		_wwmt_gameInfoDir = replace_improper_vals (wallworm_remove_last_slash	(wallworm_FsToBs (_wwmt_gameInfoDir )) char:"\\"		)
		_wwmt_binDir =replace_improper_vals ( wallworm_remove_last_slash	(wallworm_FsToBs ( _wwmt_binDir )) char:"\\"		)
		_wwmt_def_material_path = replace_improper_vals (wallworm_remove_last_slash	(wallworm_FsToBs ( _wwmt_def_material_path )) char:"\\"		)
		_wwmt_def_model_path = replace_improper_vals (wallworm_remove_last_slash	(wallworm_FsToBs (_wwmt_def_model_path )) char:"\\"		)
		_wallworm_winrar = replace_improper_vals (wallworm_remove_last_slash	(wallworm_FsToBs (_wallworm_winrar )) char:"\\"	)
		_wwmt_def_fgd  = replace_improper_vals (wallworm_remove_last_slash	(wallworm_FsToBs (_wwmt_def_fgd )) char:"\\"	)
			
	),
	
	function setGlobalsFromPreset = (
		
			sanitize_vars()
			global wallworm_userIni
			global wwmt_def_fgd = _wwmt_def_fgd
			global wwmt_raw_mats = _wwmt_raw_mats
			global wwdt_mapsrc = _wwdt_mapsrc
			/*global wwmt_current_material_Paths = _wwmt_current_material_Paths
			global wwmt_current_model_Paths = _wwmt_current_model_Paths*/
			global wwmt_mappingChannel = _wwmt_mappingChannel
			global wwmt_FOV = _wwmt_FOV
			global wwmt_verticalRes = _wwmt_verticalRes
			global wwmt_horizontalRes = _wwmt_horizontalRes
			global wwmt_LODOptimize = _wwmt_LODOptimize
			global wwmt_hull_limit_handling = _wwmt_hull_limit_handling
			global wwmtExporter = _wwmtExporter
			global wwmt_hull_tool = _wwmt_hull_tool
			global wwmt_lodLimit = _wwmt_lodLimit
			global wwmt_createLayers = _wwmt_createLayers
			global wwmt_copyTarget = _wwmt_copyTarget
			global wwmtAutoOpenFolder = _wwmtAutoOpenFolder
			global wwmt_autoMaterialNewModel = _wwmt_autoMaterialNewModel
			global wwmt_mappingChannel = _wwmt_mappingChannel
			global wwmt_overWriteQC = _wwmt_overWriteQC
			global wwmt_makeHullsNonRenderable = _wwmt_makeHullsNonRenderable
			global wwmt_refLOD = _wwmt_refLOD
			global wwmt_default_staticprop = _wwmt_default_staticprop
			global wwmt_use_local_origin = _wwmt_use_local_origin
			global wwmt_exportNonRenderableMeshAsBone = _wwmt_exportNonRenderableMeshAsBone
			global wwmt_forceOpaqueFromModel = _wwmt_forceOpaqueFromModel
			global wwmt_translucentOnlyIfOpacityMap = _wwmt_translucentOnlyIfOpacityMap
			global wwmtCompileMessage = _wwmtCompileMessage
			global wwmtAutoCompile = _wwmtAutoCompile
			global wwmt_gameInfoDir = _wwmt_gameInfoDir
			global wwmt_binDir = _wwmt_binDir
			global wwmt_def_material_path = _wwmt_def_material_path
			global wwmt_def_model_path = _wwmt_def_model_path
			global wwmt_exportMats = _wwmt_exportMats
			global wwmt_export =  _wwmt_export
			global wwmt_allow_psd = _wwmt_allow_psd
			global wallworm_text_editor = _wallworm_text_editor
			global wallworm_winrar = _wallworm_winrar
			global wallworm_displacement_events = _wallworm_displacement_events
			
			if wallworm_displacement_events == undefined then (
				wallworm_displacement_events = true
			)
			
			
			if wwmt_allow_psd == undefined then (
				wwmt_allow_psd = "false"
				)
				
			if wallworm_text_editor == undefined then (
					wallworm_text_editor = "notepad.exe"
			)	
			
			if wallworm_winrar == undefined then (
					wallworm_winrar = "C:\Program Files\WinRAR"
			)
				
			/*	
			global wwmt_mat_textransform_vmts = _wwmt_mat_textransform_vmts
			if wwmt_mat_textransform_vmts == undefined then (
				wwmt_mat_textransform_vmts = "true"
				)
				*/
			global wwmt_oldModelVTFPath = _wwmt_oldModelVTFPath	
			if wwmt_oldModelVTFPath == undefined then (
				wwmt_oldModelVTFPath = "false"
			)
				
				
			global wwmt_legacy_names = _wwmt_legacy_names
			if wwmt_legacy_names == undefined then (
				wwmt_legacy_names = "false"
			)
			
			global wwmt_rotateRefsystem
			if wwmt_rotateRefsystem == undefined then (
				wwmt_rotateRefsystem = "true"
			)
			

			setINISetting wallworm_userIni "Directories" "export" wwmt_export
			setINISetting wallworm_userIni "Directories" "exportMats" wwmt_exportMats
			setINISetting wallworm_userIni "Settings" "createLayers" wwmt_createLayers
			setINISetting wallworm_userIni "Directories" "binDir"  wwmt_binDir
			setINISetting wallworm_userIni "Settings" "lodLimit" (wwmt_lodLimit as string)
			setINISetting wallworm_userIni "Settings" "wwmtAutoCompile" wwmtAutoCompile
			setINISetting wallworm_userIni "Settings" "wwmtAutoOpenFolder" wwmtAutoOpenFolder
			setINISetting wallworm_userIni "Settings" "FOV" (wwmt_FOV as string)
			setINISetting wallworm_userIni "Settings" "horizontalRes" (wwmt_horizontalRes as string)
			setINISetting wallworm_userIni "Settings" "verticalRes" (wwmt_verticalRes as string)
			setINISetting wallworm_userIni "Settings" "wwmtExporter" wwmtExporter
			setINISetting wallworm_userIni "Directories" "def_material_path" wwmt_def_material_path
			setINISetting wallworm_userIni "Directories" "def_model_path" wwmt_def_model_path
			setINISetting wallworm_userIni "Directories" "gameInfoDir"  wwmt_gameInfoDir
			setINISetting wallworm_userIni "Settings" "wwmt_exportNonRenderableMeshAsBone" wwmt_exportNonRenderableMeshAsBone
			setINISetting wallworm_userIni "Settings" "wwmt_makeHullsNonRenderable" wwmt_makeHullsNonRenderable
			setINISetting wallworm_userIni "Settings" "overWriteQC" wwmt_overWriteQC
			setINISetting wallworm_userIni "Settings" "wwmt_mappingChannel" (wwmt_mappingChannel as string)
			setINISetting wallworm_userIni "Materials" "wwmt_translucentOnlyIfOpacityMap" wwmt_translucentOnlyIfOpacityMap
			setINISetting wallworm_userIni "Materials" "wwmt_forceOpaqueFromModel" wwmt_forceOpaqueFromModel
			--setINISetting wallworm_userIni "Materials" "wwmt_mat_textransform_vmts" wwmt_mat_textransform_vmts
			setINISetting wallworm_userIni "Materials" "wwmt_allow_psd" wwmt_allow_psd
			setINISetting wallworm_userIni "Materials" "wwmt_oldModelVTFPath" wwmt_oldModelVTFPath
			setINISetting wallworm_userIni "Materials" "wwmt_legacy_names" wwmt_legacy_names
			setINISetting wallworm_userIni "Settings" "wwmt_hull_limit_handling" (wwmt_hull_limit_handling as string)
			setINISetting wallworm_userIni "Directories" "exportMaps" wwdt_mapsrc
			setINISetting wallworm_userIni "Settings" "wwmtCompileMessage" wwmtCompileMessage
			setINISetting wallworm_userIni "Materials" "wwmt_autoMaterialNewModel" wwmt_autoMaterialNewModel
			setINISetting wallworm_userIni "Materials" "wwmt_autoMaterialNewModel" wwmt_allow_psd
			setINISetting wallworm_userIni "Settings" "wwmt_refLOD" wwmt_refLOD
			setINISetting wallworm_userIni "Settings" "wwmt_use_local_origin" wwmt_use_local_origin
			setINISetting wallworm_userIni "Settings" "wwmt_LODOptimize" (wwmt_LODOptimize as string)
			setINISetting wallworm_userIni "Settings" "wwmt_hull_tool" (wwmt_hull_tool as string)
			setINISetting wallworm_userIni "Settings" "wwmt_default_staticprop" wwmt_default_staticprop
			setINISetting wallworm_userIni "Directories" "wwmt_def_fgd" wwmt_def_fgd
			setINISetting wallworm_userIni "Settings" "wwmt_rotateRefsystem" wwmt_rotateRefsystem			
			setINISetting wallworm_userIni "Applications" "text_editor" wallworm_text_editor
			setINISetting wallworm_userIni "Applications" "winrar" wallworm_winrar	
			setINISetting wallworm_userIni "Directories" "wwmt_raw_mats"  wwmt_raw_mats
			setINISetting wallworm_userIni "Displacements" "wallworm_displacement_events"  (wallworm_displacement_events as string)

		),
	
	function setPresetFromGlobals = (
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
			
			
			global wallworm_winrar
			global wallworm_text_editor
			
			global wallworm_displacement_events

			_wwmt_def_fgd = wwmt_def_fgd
			_wwmt_raw_mats = wwmt_raw_mats
			_wwdt_mapsrc = wwdt_mapsrc
			_wwmt_current_material_Paths = wwmt_current_material_Paths
			_wwmt_current_model_Paths = wwmt_current_model_Paths
			_wwmt_mappingChannel = wwmt_mappingChannel
			_wwmt_FOV = wwmt_FOV
			_wwmt_verticalRes = wwmt_verticalRes
			_wwmt_horizontalRes = wwmt_horizontalRes
			_wwmt_LODOptimize = wwmt_LODOptimize
			_wwmt_hull_limit_handling = wwmt_hull_limit_handling
			_wwmtExporter = wwmtExporter
			_wwmt_hull_tool = wwmt_hull_tool
			_wwmt_lodLimit = wwmt_lodLimit
			_wwmt_createLayers = wwmt_createLayers
			_wwmt_copyTarget = wwmt_copyTarget
			_wwmtAutoOpenFolder = wwmtAutoOpenFolder
			_wwmt_autoMaterialNewModel = wwmt_autoMaterialNewModel
			_wwmt_mappingChannel = wwmt_mappingChannel
			_wwmt_overWriteQC = wwmt_overWriteQC
			_wwmt_makeHullsNonRenderable = wwmt_makeHullsNonRenderable
			_wwmt_refLOD = wwmt_refLOD
			_wwmt_default_staticprop = wwmt_default_staticprop
			_wwmt_use_local_origin = wwmt_use_local_origin
			_wwmt_exportNonRenderableMeshAsBone = wwmt_exportNonRenderableMeshAsBone
			_wwmt_forceOpaqueFromModel = wwmt_forceOpaqueFromModel
			_wwmt_translucentOnlyIfOpacityMap = wwmt_translucentOnlyIfOpacityMap
			_wwmtCompileMessage = wwmtCompileMessage
			_wwmtAutoCompile = wwmtAutoCompile
			_wwmt_gameInfoDir = wwmt_gameInfoDir
			_wwmt_binDir = wwmt_binDir
			_wwmt_def_material_path = wwmt_def_material_path
			_wwmt_def_model_path = wwmt_def_model_path
			_wwmt_exportMats = wwmt_exportMats
			_wwmt_export =  wwmt_export
			_wwmt_allow_psd = wwmt_allow_psd
			_wwmt_mat_textransform_vmts = true
			_wwmt_oldModelVTFPath =wwmt_oldModelVTFPath 
			_wwmt_legacy_names = wwmt_legacy_names 	
			_wwmt_rotateRefsystem = wwmt_rotateRefsystem	

			_wallworm_winrar = wallworm_winrar
			_wallworm_text_editor = wallworm_text_editor
			_wallworm_displacement_events = wallworm_displacement_events
			sanitize_vars()

		)
		
		
	)	
	
	
	Struct WallWormPresetStore (
		name = "New Preset",
		preset
		
	)
	
	
	
	
function wallworm_parse_gameinfo filename = (
	local games = #()
	if ((doesFileExist filename) == false) then (
		 return false
	)
	 
	local ms = memStreamMgr.openFile filename
	
	
	while ms.eos() == false do (
		

		
		ms.skipSpace()
		try (
		theline = ms.readLine()
		) catch (
			continue
		)
		theline = trimLeft theline
		

		if ((matchPattern theLine pattern:"\"games\"") == true) then (
			
			
			local gamesStr = wallworm_readBlock2 ms p1:"{" p2:"}"
			
			gameStream = memStreamMgr.openString gamesStr
			
				while gameStream.eos() == false do (
		

		
					gameStream.skipSpace()
					try (
					theline2 = gameStream.readLine()
					) catch (
						continue
					)
					
					
					if gameStream.peekToken() == "{" then (
						
				
					
					local preset = WallWormPresetStore()
					preset.preset = WallWormConfig()
					preset.preset.setPresetFromGlobals()
					preset.name = trimLeft ( trimRight (substituteString theline2 "\"" ""))
					preset.preset._wwmt_binDir =  wallworm_remove_last_slash (getFileNamePath filename)  char:"\\"

					local modStr = 	gameStream.readBlock "{" "}"
						
					modStream = memStreamMgr.openString modStr
						
					while  modStream.eos() != true do (
						
						local modline = modStream.readLine()
						
						modline = substituteString modline "\"" ""
						
						
						
						while matchPattern modline pattern:"*\t\t*" == true do (
							
							modline = substituteString modline "\t\t" "\t"
						)

						while matchPattern modline pattern:"*  *" == true do (
							
							modline = substituteString modline "  " " "
						)
						
						local vars = filterString modline "\t"
						

						
						
						if vars.count == 2 then (
						

							local val = wallworm_remove_last_slash	(wallworm_FsToBs ( vars[2] )) char:"\\"
							--format "Prop: % : %\n" vars[1] val 
							
							case vars[1] of (
								"GameDir":preset.preset._wwmt_gameInfoDir = val
								"MapDir":(
									preset.preset._wwdt_mapsrc = val
									preset.preset._wwmt_exportMats = ((getFileNamePath val)+"materialsrc")
									preset.preset._wwmt_export = ((getFileNamePath val)+"modelsrc")
								)
								"GameData0": (preset.preset._wwmt_def_fgd = val
									--print "added fgd"
								)
							)
							
						)
						
						/*			 = wwmt_def_fgd


		*/
						
						
					)
					memStreamMgr.close modStream
					
					preset.preset.sanitize_vars()
					
					append	games preset
						
						
					)

				)
				memStreamMgr.close gameStream
		)
	)
	
	memStreamMgr.close ms
	
	games
)