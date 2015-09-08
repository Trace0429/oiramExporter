/*
Wall Worm VMF Exporter Window
Copyright (c) 2012-2014 by Shawn Olson

www.wallworm.com

*/
--(

filein "$scripts\\WallWorm.com\\custom_attributes\\vmf.ms"

	try (destroyDialog WallWormVMFExport) catch ()

	fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
	fileIn "$scripts/WallWorm.com/common/packing_funcs.ms"
	scriptPath= symbolicPaths.getPathValue "$userScripts"
	userIni = scriptPath + "\WallWorm.com\config\wwmt.ini"

	filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\anvil_funcs.ms"
		
	fileIn "$scripts/WallWorm.com/common/mse/parseFGD.mse"
	fileIn "$scripts/WallWorm.com/common/packing_funcs.ms"
	fileIn "$scripts/WallWorm.com/common/mse/wallwormVMF.mse"	
	vmfPresets = #()
	wallworm_vmfPresets=#()
	if wallworm_file_vmf_presets == undefined then (	
		wallworm_file_vmf_presets = wallwormVMF()	
	)
	
	if wallworm_file_vmf_presets.filename != undefined then (
		wallworm_file_vmf_presets.sanitize_filename()
		
	)
		




	function updateVMFPresetList = (
		local theLabels = #()
		global wallworm_vmfPresets
		for vmf in wallworm_vmfPresets do (
			append theLabels vmf.name
			
		)
		
		return theLabels
	)

wwvmfdummy = wallwormVMF()	
global wallwormVMFExportVersion = wwvmfdummy.exporterVersion
rollout WallWormVMFExport "Wall Worm VMF Exporter | Version " width:402 height:735
(
	
	bitmap anvillogo "anvil" pos:[179,8] width:217 height:107 fileName:"$scripts/WallWorm.com/assets/anvil_logo.tif" 
	checkbox chk_displacements "Displacements" pos:[24,148] width:81 height:15 checked:true toolTip:"Export displacements created with Anvil."
	checkbox chk_wwBrush "World Brushes" pos:[24,167] width:122 height:15 checked:true toolTip:"Export geometry as world brushes that you've assigned as Brushes in Anvil. Also exports geometry in any layer called `Convexity Walls` and `Convexity Floors`."
	checkbox chk_cvxWalls "Brush Entities" pos:[24,188] width:140 height:15 checked:true toolTip:"Export Brush and Associated Entity information for any geometry that has been tied to a brush entity."
	checkbox chk_cvxEntities "Point Entities" pos:[24,230] width:140 height:15 checked:true toolTip:"Export all Point Entities."
	checkbox chk_lights "Lights" pos:[24,249] width:134 height:15 checked:true toolTip:"Export all scene lights as corresponding light entity."
	button btn_export "Export VMF (and Compile if Applicable)" pos:[179,635] width:216 height:29 toolTip:"Run the export. You'll be prompted to name and save the file. This may take several minutes (or longer depending on scene complexity and computer speed) and may appear to have frozen Max."
	checkbox chk_models "WWMT Models" pos:[24,209] width:106 height:15 checked:true toolTip:"Export all WWMT helpers in the scene along with their associated Proxy models."
	GroupBox grp1 "Export" pos:[10,128] width:164 height:162
	checkbox chk_visFast "Fast" pos:[190,223] width:49 height:15
	checkbox chk_vradBoth "Both" pos:[190,299] width:49 height:15 checked:true toolTip:"This option only adds -both flag. Calculates both HDR and LDR."
	checkbox chk_vradFinal "Final" pos:[242,299] width:46 height:15 toolTip:"Spend extra time firing light_environment rays. When on, equivalent to -extrasky 16. When not used, then equivalent to -extrasky 1."
	GroupBox grp2 "Vis Options" pos:[179,204] width:217 height:72
	GroupBox grp3 "Rad Options" pos:[180,280] width:216 height:77
	checkbox chk_compile "Compile Map on Export" pos:[11,635] width:145 height:19 checked:false
	checkbox chk_launch "Launch Game after Compile" pos:[12,655] width:150 height:17 checked:false
	edittext edt_visOpts "Options" pos:[190,247] width:200 height:18
	edittext edt_radOpts "Options" pos:[190,328] width:200 height:18
	edittext edt_bspOpts "Options" pos:[190,168] width:200 height:18
	GroupBox grp10 "BSP Options" pos:[179,121] width:217 height:75
	spinner spn_lightMultiplier "light multiplier" pos:[93,344] width:77 height:16 range:[1,1000,200] type:#float scale:1 toolTip:"Enter a multiplier converting Max light multipliers into Source light brightness. This value is multiplied against the lights' individual multipliers. This value is for the light and light_spot entities."
	spinner spn_lightEnvMultiplier "env mult" pos:[341,425] width:49 height:16 range:[1,1000,20] type:#integer scale:1 toolTip:"Enter a multiplier for the light_environment entities. This multiplier is multiplied against the light's multiplier for the final Source multiplier. So if the light has a multiplier of 1 and this numer is 20, the Source brightness will be 20."
	GroupBox grp17 "Lights" pos:[11,292] width:164 height:152
	dropdownList ddlVisOpts "" pos:[244,218] width:147 height:21 items:#("", " -radius_override # ", " -nosort ", " -tmpin ", " -tmpout ", " -low ", " -threads #", " -v ", " -verbose ", " -novconfig ", " -mpi ", " -mpi_pw <string> ", " -vproject <string> ", " -game <string> ")
	combobox cbxPresets "Presets" pos:[9,7] width:125 height:7 selection:0
	button btnSavePreset "Save" pos:[137,49] width:37 height:21
	dropdownList ddlBSPOpts "" pos:[191,137] width:199 height:21 items:#("", " -verbose ", " -onlyents ", " -onlyprops ", " -glview ", " -nodetail ", " -nowater ", " -low ", " -vproject <directory> ", " -game <directory> ", " -novconfig ", " -threads #", " -verboseentities ", " -noweld ", " -nocsg ", " -noshare ", " -notjunc ", " -noopt ", " -noprune ", " -nomerge ", " -nomergewater ", " -nosubdiv ", " -micro <#> ", " -fulldetail ", " -leaktest ", " -bumpall ", " -snapaxial ", " -block # # ", " -blocks # # # # ", " -blocksize 1024", " -dumpstaticprops ", " -dumpcollide ", " -luxelscale # ", " -lightifmissing ", " -localphysx ", " -keepstalezip ", " -replacematerials ", " -FullMinidumps ")
	dropdownList ddlRadOpts "" pos:[291,296] width:100 height:21 items:#("", " -ldr ", " -hdr ", " -both ", " -fast ", " -final ", " -extrasky <int> ", " -lights <filename>.rad ", " -bounce <int> ", " -smooth <int> ", " -luxeldensity <normal> ", " -softsun <float> ", " -StaticPropLighting ", " -StaticPropPolys ", " -TextureShadows ", " -low ", " -threads <int> ", " -mpi ", " -mpi_pw <string> ", " -noextra ", " -chop <int> ", " -maxchop <int> ", " -LargeDispSampleRadius ", " -compressconstant <int> ", " -rederrors ", " -vproject <directory> ", " -game <directory> ", " -v ", " -verbose ", " -novconfig ", " -dump ", " -dumpnormals ", " -debugextra ", " -dlightmap ", " -stoponexit ", " -nodetaillight ", " -centersamples ", " -loghash ", " -onlydetail ", " -maxdispsamplesize # ", " -FullMinidump ", " -OnlyStaticProps ", " -StaticPropNormals ", " -noskyboxrecurse ", " -nossprops ")
	button btnDeletePreset "Delete" pos:[137,73] width:37 height:20 toolTip:"Click here to delete the selected preset."
	button btn28 "New" pos:[137,27] width:37 height:19		
		
	checkbox chkHidden "Hidden Objects" pos:[24,269] width:143 height:16 checked:true toolTip:"Export objects that are hidden."
	spinner spnLightmapScale "Default Lightmap Scale" pos:[106,313] width:63 height:16 range:[1,1024,16] type:#integer scale:1 toolTip:"Set the default lightmap scale for all brush and displacement faces that have not been otherwise set individually."
	button btn5 "Run Compile Batch" pos:[179,670] width:102 height:27 toolTip:"Compile the map. This function only works if you have previously exported the map."
	button btnOpenMaps "Open Maps" pos:[289,671] width:62 height:26 toolTip:"Open the folder where your VMF exports to along with Wall Worm batch files."
	checkbox chkEmbedWWMT "WWMT Models" pos:[20,474] width:92 height:14 toolTip:"PAK the MDL files for WWMT models and proxies in this scene."
	checkbox chkEmbeddWWMTTex "WWMT Textures" pos:[20,493] width:103 height:14 toolTip:"Embed all VMT and VTF files associated with your WWMT models and proxies."
	checkbox chkEmbedSky "Sky Textures" pos:[20,530] width:88 height:15 toolTip:"Embed your Sky textures. Only works with Skywriter."
	checkbox chkEmbedCVXProps "Entity Assets" pos:[20,566] width:90 height:15 toolTip:"Collect MDL, VMT, WAV and MP3 from Entities."
	checkbox chkEmbedWorldTex "World Textures" pos:[20,512] width:100 height:16 toolTip:"Embed VMT and VTF files from the world geometry. The materials must be named properly for this function to work. This option not yet fully tested."
	checkbox chkEmbedVBSP "Detail Texture" pos:[20,584] width:88 height:15 toolTip:"Embed your detail texture. Note that this will read materials from Wall Worm Detail Props."

	
	GroupBox grp6 "PAK Assets Into BSP" pos:[12,454] width:163 height:176
	colorPicker cpAmbient "Ambient" pos:[191,380] width:60 height:16 color:(color 255 255 255) title:"Choose Ambient color (controls the Global Tint in Max)." toolTip:"Choose the ambient color for your map. Only works if you have a light that exports as light_environment. Will change the Max global Tint inside the Max Environment settings."
	colorPicker cpHDRBrightness "HDR Color" pos:[24,392] width:145 height:19 enabled:false color:(color 255 255 255) title:"Choose Brightness (HDR Color)" toolTip:"Set the default global HDR color for lights. Only works if Use LDR Color is unchecked."
	colorPicker cpAmbientHDR "Ambient HDR" pos:[194,403] width:86 height:16 enabled:false color:(color 255 255 255) title:"Choose Ambient color" toolTip:"Choose the HDR Ambient color. Only works if there is a light_environment light in the scene and Use LDR Ambient is unchecked."
	checkbox chkUseBrightness "Use LDR Color" pos:[26,419] width:121 height:16 checked:true toolTip:"Set the global option for lights to use their LDR color as the HDR color if the light hasn't had a value set specifically."
	checkbox chkUseLDRAmbient "Use LDR Ambient" pos:[288,403] width:105 height:16 checked:true toolTip:"Reuse the global Ambient color for the light_environment HDR ambient color."
	spinner spnHDRScale "HDR Scale" pos:[85,369] width:85 height:16 range:[1,100,1] type:#float scale:0.01 toolTip:"Set the default HDR scale for all lights that do not have this value set individually."
	spinner spnSunSpreadAngle "Sun Spread" pos:[348,379] width:40 height:16 range:[0,180,0] type:#integer scale:1 toolTip:"Set the Sun Spread angle. Only works if there is a light that exports as light_environment in the scene."
	
	GroupBox grpLightEnv "Environment" pos:[181,360] width:215 height:164
	button btn19 "Update Pak List" pos:[21,602] width:139 height:18 toolTip:"Recreate the pak list for zipping assets into the scene. May be necessary if you have added new models/materials, etc since the last time the scene was exported."
	spinner spnAmbientScale "Amb HDRScale" pos:[244,425] width:56 height:16 range:[0,1000,1] toolTip:"Set the Ambient HDR Scale."
	spinner spnAmbientScaleLDR "" pos:[257,379] width:36 height:16 range:[0,1000,2] toolTip:"Set the Ambient Scale Multiplier for the light_environment. This value will be multiplied by the light's multiplier to create the value for the ambient light level (brightness of indirect environment lighting)."
	combobox cbxSkyName "Sky Name" pos:[191,444] width:198 height:3 toolTip:"Enter the name of the sky for this map. The list will automatically include any sky writer files in the map."
	spinner spnMaxPropScreenWidth "Start" pos:[241,575] width:67 height:16 range:[-1,32000,-1] type:#integer scale:1 toolTip:"Number of pixels wide at which all props in the level start to fade (<0 = use fademaxdist). This number is ignored if the prop has a specific fade distance specified."
	spinner spnMinPropScreenWidth "End" pos:[328,574] width:66 height:16 range:[-1,32000,0] type:#integer scale:1 toolTip:"Minimum number of pixels wide at which the prop is visible (0 = don't fade out). This number is ignored if the prop has a specific fade distance specified."
	HyperLink linkWW "WallWorm.com" pos:[17,710] width:96 height:17 address:"http://www.wallworm.com" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	HyperLink donate "Donate & Support Wall Worm" pos:[127,710] width:143 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/42/donate.html"	
	HyperLink help "Help" pos:[327,710] width:43 height:20 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/47/vmf_exporter.html"	
	button btnLeak "Leak" pos:[356,671] width:39 height:26 toolTip:"Load the Leak File to help find leaks. This file only exists if you have tried to compile and the compiler created a LIN file."
	checkbox chkEmbedWAVs "Soundscape Contents" pos:[20,548] width:145 height:15 toolTip:"Collect sounds listed in soundscapes."
	edittext edtDetailSprites "detail/detailsprites" pos:[184,528] width:210 height:19
	edittext edtDetailVBSP "detail.vbsp" pos:[184,551] width:210 height:20
	label lbl1 "Fade" pos:[185,575] width:31 height:13
	checkbox chkBreakNonPlanarFaces "Break Non Planar Faces" pos:[185,598] width:210 height:16 toolTip:"Tell the exporter to break non-planar polygons into pieces. Useful for solving problems where convex geometry in Max sometimes misses geometry... but might take longer to export."
	checkbox chkPrecise "Precise Coords" pos:[185,616] width:210 height:16 checked:true toolTip:"When on, uses long digits for brush vertex coordinates. For Hammer-like truncatedvalues, turn off (but may lead to non-convex geometry and/or changes in exported geometry)."
	checkbox chkCompileLogWindow "Output Compile Window" pos:[12,677] width:150 height:17 toolTip:"When on, the compile log is displayed in console. When off, the compiler will not display a lot of info. At the end of compile, the compile log will open in your text editor."
	
	function useHDRBrightness state = (
		global wallworm_file_vmf_presets		
		if state == true then (
			cpHDRBrightness.enabled = true
			chkUseBrightness.checked = false
		) else (
			cpHDRBrightness.enabled = false
			chkUseBrightness.checked = true
			
		)
		wallworm_file_vmf_presets.UseBrightness = NOT state
		rootNode.UseBrightness = NOT state
	)
	
	function useHDRAmbient state = (
		
		global wallworm_file_vmf_presets			
		if state == true then (
			cpAmbientHDR.enabled = true
			chkUseLDRAmbient.checked = false
		) else (
			cpAmbientHDR.enabled = false
			chkUseLDRAmbient.checked = true
		)
		
		wallworm_file_vmf_presets.UseLDRAmbient = NOT state
		rootNode.UseLDRAmbient = NOT state
		
		
	)
	
	function writePreferences = (
		with printAllElements on (
			local str = "global wallworm_vmfPresets = " + (wallworm_vmfPresets as string)
		)
		local prefFile 
		if doesFileExist "$userScripts\\WallWorm.com\\config\\vmfPresets.ms" == false then (
			prefFile = createFile "$userScripts\\WallWorm.com\\config\\vmfPresets.ms"
			close prefFile
			) else (
			
			)
		try (
			prefFile = openFile "$userScripts\\WallWorm.com\\config\\vmfPresets.ms" mode:"w+"
			format str to:prefFile
			close prefFile
		) catch ()
	)
	
	

	function getVMFFromUI = (
		/*This function fills a VMF struct from the UI's current settings*/
		global wallworm_file_vmf_presets
		if wallworm_file_vmf_presets == undefined then (
			wallworm_file_vmf_presets = wallwormVMF()
		)
		wallworm_file_vmf_presets.outputModels=chk_models.state
		wallworm_file_vmf_presets.outputDisplacements=chk_displacements.state
		wallworm_file_vmf_presets.outputBrushes=chk_wwBrush.state
		wallworm_file_vmf_presets.outputPointEntities=chk_cvxEntities.state
		wallworm_file_vmf_presets.outputBrushEntities=chk_cvxWalls.state
		wallworm_file_vmf_presets.outputLights=chk_lights.state
		wallworm_file_vmf_presets.vradBoth=chk_vradBoth.state
		wallworm_file_vmf_presets.vradFinal=chk_vradFinal.state
		wallworm_file_vmf_presets.includeHidden = chkHidden.state
		wallworm_file_vmf_presets.vvisFast=chk_visFast.state
		wallworm_file_vmf_presets.launchGame = chk_launch.state
		wallworm_file_vmf_presets.visOpts = edt_visOpts.text
		wallworm_file_vmf_presets.radOpts=edt_radOpts.text
		wallworm_file_vmf_presets.bspOpts=edt_bspOpts.text
		wallworm_file_vmf_presets.lightMultiplier = spn_lightMultiplier.value
		wallworm_file_vmf_presets.lightEnvMultiplier = spn_lightEnvMultiplier.value
		wallworm_file_vmf_presets.lightmapScale = spnLightmapScale.value
		
		wallworm_file_vmf_presets.launchGame=chk_launch.state
		wallworm_file_vmf_presets.compileMap=chk_compile.state
		
		wallworm_file_vmf_presets.MaxPropScreenWidth = spnMaxPropScreenWidth.value
		wallworm_file_vmf_presets.MinPropScreenWidth = spnMinPropScreenWidth.value
			
		wallworm_file_vmf_presets.EmbedWWMT = chkEmbedWWMT.state
		wallworm_file_vmf_presets.EmbeddWWMTTex= chkEmbeddWWMTTex.state
		wallworm_file_vmf_presets.EmbedSky = chkEmbedSky.state 
		wallworm_file_vmf_presets.EmbedCVXProps = chkEmbedCVXProps.state 
		wallworm_file_vmf_presets.EmbedWorldTex = chkEmbedWorldTex.state
		
		if wallworm_file_vmf_presets.EmbedVBSP != undefined then (
			wallworm_file_vmf_presets.EmbedVBSP = chkEmbedVBSP.state
		)
		wallworm_file_vmf_presets.compileLogWindow = chkCompileLogWindow.state
		
		wallworm_file_vmf_presets.EmbedWAVs = chkEmbedWAVs.state
		

		wallworm_file_vmf_presets.HDRBrightness = cpHDRBrightness.color
		wallworm_file_vmf_presets.AmbientHDR = cpAmbientHDR.color
		wallworm_file_vmf_presets.UseBrightness = chkUseBrightness.state
		wallworm_file_vmf_presets.UseLDRAmbient = chkUseLDRAmbient.state
		wallworm_file_vmf_presets.HDRScale =spnHDRScale.value
		wallworm_file_vmf_presets.SunSpreadAngle = spnSunSpreadAngle.value
		wallworm_file_vmf_presets.BreakNonPlanarFaces = chkBreakNonPlanarFaces.state
		

		wallworm_file_vmf_presets.precise = chkPrecise.state
		
		wallworm_file_vmf_presets.AmbientHDRScale = spnAmbientScale.value
		
		
		wallworm_file_vmf_presets.AmbientScale = spnAmbientScaleLDR.value
		
		wallworm_file_vmf_presets.AmbientLDR = cpAmbient.color
		
		
		wallworm_file_vmf_presets.skyName = cbxSkyName.text
		
		
		wallworm_file_vmf_presets.DetailSprites = edtDetailSprites.text
		wallworm_file_vmf_presets.DetailVBSP = edtDetailVBSP.text
		
		global wallwormVMFExportVersion
		wallworm_file_vmf_presets.exporterVersion = wallwormVMFExportVersion

		
		return wallworm_file_vmf_presets
	)

	function setFromPreset vmf = (
			/*This function fills the UI with properties saved in a preset (or in the file settings)*/
			vmf.sanitize_filename()
			try (
			chk_models.state= vmf.outputModels
			chk_displacements.state= vmf.outputDisplacements
			chk_wwBrush.state= vmf.outputBrushes
			chk_cvxEntities.state= vmf.outputPointEntities
			chk_cvxWalls.state= vmf.outputBrushEntities
			chk_lights.state= vmf.outputLights
			chk_vradBoth.state= vmf.vradBoth
			chk_vradFinal.state= vmf.vradFinal
			chk_visFast.state= vmf.vvisFast
			chk_launch.state= vmf.launchGame
			edt_visOpts.text= vmf.visOpts
			edt_radOpts.text= vmf.radOpts
			edt_bspOpts.text= vmf.bspOpts
			spn_lightMultiplier.value= vmf.lightMultiplier
			spn_lightEnvMultiplier.value= vmf.lightEnvMultiplier
			spnLightmapScale.value = vmf.lightmapScale
				
			chk_launch.state	=	vmf.launchGame
			chk_compile.state =	vmf.compileMap

				

			if vmf.precise != undefined then (
				chkPrecise.state = vmf.precise
			)
			
			if vmf.compileLogWindow != undefined then (
				
				chkCompileLogWindow.state = vmf.compileLogWindow
			)
			
			

			
			chkEmbedWWMT.state	 = vmf.EmbedWWMT
			chkEmbeddWWMTTex.state = vmf.EmbeddWWMTTex
			chkEmbedSky.state =  vmf.EmbedSky
			chkEmbedCVXProps.state =  	vmf.EmbedCVXProps
			chkEmbedWorldTex.state = 	vmf.EmbedWorldTex
			
			if vmf.EmbedVBSP != undefined then (
				chkEmbedVBSP.state = 	vmf.EmbedVBSP
			)

			
			if vmf.EmbedWAVs != undefined then (
			 chkEmbedWAVs.state = vmf.EmbedWAVs
			)
			
			
			if vmf.BreakNonPlanarFaces != undefined then (
				chkBreakNonPlanarFaces.state = 	vmf.BreakNonPlanarFaces
			)
			if wallworm_file_vmf_presets.AmbientLDR != undefined then (
				cpAmbient.color = vmf.AmbientLDR
			)
			if wallworm_file_vmf_presets.AmbientScale != undefined then (
				spnAmbientScaleLDR.value = vmf.AmbientScale
			)
			if wallworm_file_vmf_presets.HDRBrightness != undefined then (
				cpHDRBrightness.color = vmf.HDRBrightness
			)
			if wallworm_file_vmf_presets.AmbientHDR != undefined then (
				cpAmbientHDR.color = vmf.AmbientHDR
			)
			if wallworm_file_vmf_presets.UseBrightness != undefined then (
				chkUseBrightness.state = vmf.UseBrightness
			)
			if wallworm_file_vmf_presets.UseLDRAmbient != undefined then (
				chkUseLDRAmbient.state = vmf.UseLDRAmbient
			)
			if wallworm_file_vmf_presets.HDRScale != undefined then (
				spnHDRScale.value = vmf.HDRScale
			)
			if wallworm_file_vmf_presets.SunSpreadAngle != undefined then (
				spnSunSpreadAngle.value = vmf.SunSpreadAngle
			)
			if wallworm_file_vmf_presets.AmbientHDRScale != undefined then (
				spnAmbientScale.value = vmf.AmbientHDRScale
			)	
			if vmf.includeHidden != undefined then (
				chkHidden.state=vmf.includeHidden
				) else ()
				
			if (wallworm_file_vmf_presets.MaxPropScreenWidth != undefined ) then (
				
				spnMaxPropScreenWidth.value = wallworm_file_vmf_presets.MaxPropScreenWidth
				
				)
				
			if wallworm_file_vmf_presets.DetailSprites != undefined AND wallworm_file_vmf_presets.DetailSprites != "" then (
				edtDetailSprites.text = vmf.DetailSprites
			)	
			if wallworm_file_vmf_presets.DetailVBSP != undefined AND wallworm_file_vmf_presets.DetailVBSP != "" then (
				edtDetailVBSP.text = vmf.DetailVBSP
			)	
			if (wallworm_file_vmf_presets.MinPropScreenWidth != undefined ) then (
				
				spnMinPropScreenWidth.value = wallworm_file_vmf_presets.MinPropScreenWidth
				
				)
				
			if wallworm_file_vmf_presets.skyName != undefined then (
				
				if findItem cbxSkyName.items wallworm_file_vmf_presets.skyName == 0 then (
					
					tempItems = cbxSkyName.items
					append tempItems wallworm_file_vmf_presets.skyName
					
					 cbxSkyName.items = tempItems
					) else (
					
					
					)
					
					cbxSkyName.selection = findItem  cbxSkyName.items wallworm_file_vmf_presets.skyName

				)
				
				
				
				
				
			) catch (
				
				print (getCurrentException())
			)
			
			

			if vmf.UseBrightness == undefined OR vmf.UseBrightness == true then (
				useHDRBrightness false
			) else (
				useHDRBrightness true
				)
				
			if vmf.UseLDRAmbient == undefined OR vmf.UseLDRAmbient == true then (
				useHDRAmbient false
			) else (
				useHDRAmbient true
			)
				

			

	)
	
	function setFileVMFProperties filename:undefined= (
		/*This function saves the properties of the UI into the file's properties.*/
			global wallworm_file_vmf_presets
			wallworm_file_vmf_presets = getVMFFromUI()
		
			wallworm_file_vmf_presets.wallworm_get_worldspawns()
			wallworm_file_vmf_presets.setWorldspawn()
		
		
			/*		
		
			wallwormVMFSettingsIndex = fileProperties.findProperty #custom "wallwormVMFSettings"

			if wallwormVMFSettingsIndex != 0 then (
				fileProperties.deleteProperty #custom "wallwormVMFSettings"
			)

			
			if filename != undefined then (
				wallworm_file_vmf_presets.filename = filename
			)

			wallworm_file_vmf_presets.sv = undefined
			wallworm_file_vmf_presets.devmap = undefined
			wallworm_file_vmf_presets.worldspawn = undefined*/
			
			global wallwormVMFExportVersion
			wallworm_file_vmf_presets.exporterVersion = wallwormVMFExportVersion
			/*VERY IMPORTANT!! Unset the _this property or the object will be saved with a recursion that breaks the object when saved into the file!*/
			--wallworm_file_vmf_presets._this = undefined
			--fileProperties.addProperty #custom "wallwormVMFSettings" (wallworm_file_vmf_presets as string)
			
			
			if NOT isProperty rootNode "Wallworm_VMF" then (
				
				custAttributes.add rootNode wallworm_vmf_settings_CA
			)
			
			rootNode.getSettingsFromVMFStruct wallworm_file_vmf_presets
			
			if wallworm_file_vmf_presets.filename != undefined then (
				--wallworm_file_vmf_presets._this = wallworm_file_vmf_presets
				wallworm_file_vmf_presets.writeBatchFile()
			)
			
		)
	

	function getSkyNames = (
		
		global wallworm_file_vmf_presets
		
		local skyList = #()
		
		if wallworm_file_vmf_presets.skyName != undefined AND wallworm_file_vmf_presets.skyName != "" then (
			append skyList wallworm_file_vmf_presets.skyName
			
			)
		
		for s in objects  where (isDeleted s ==false)  AND  getUserProp s "wwsw_skyname" != undefined do (
			
			appendIfUnique skyList  (getUserProp s "wwsw_skyname")
			
			
			)
		
		refCollection = #()
		wallworm_file_vmf_presets.getXrefs refCollection undefined
		if refCollection.count > 0 then (
				for ref in refCollection  do (
					for s in ref.tree.children  where (ww_getUserProp s "wwsw_skyname" xref:ref.tree.children) !=undefined  do (
						
						appendIfUnique skyList  (ww_getUserProp s "wwsw_skyname"  xref:ref.tree.children)
			
					)
					
				)
			)

		
		/*
			if skyList.count == 0 then (
				
				append skyList "sky_day01_01"
				
				)
		
		*/
			
			--print skyList
			return skyList
		)
	

	
	
	
	
	
	
	on WallWormVMFExport open do
	(
	WallWormVMFExport.title = WallWormVMFExport.title + (wwvmfdummy.exporterVersion as string)
		
		
		
		
		
			
		global wallworm_userIni
		/*
	global	wallworm_vmfPresets
		
	if (doesFileExist "$userScripts\\WallWorm.com\\config\\vmfPresets.ms") == true then (
		--readValue "$userScripts\\WallWorm.com\\config\\sourcePresets.ms" ignoreStringEscapes:true
		local temp = openFile "$userScripts\\WallWorm.com\\config\\vmfPresets.ms" mode:"r"
		execute temp
		close temp
		fillPresets()
	) else (
		
		wallwormSettingPresetsStr  = GetINISetting wallworm_userIni "Presets" "wallwormSettingPresets"
		if wallwormSettingPresetsStr != undefined AND wallwormSettingPresetsStr != "" then (
		
		local theStr = "global wallworm_setting_presets = " +  wallwormSettingPresetsStr
		execute theStr
		fillPresets()
		
	
		
	) else ()
		
	
		
	)	
		*/
	
	if (doesFileExist "$userScripts\\WallWorm.com\\config\\vmfPresets.ms") == true then (
		--readValue "$userScripts\\WallWorm.com\\config\\sourcePresets.ms" ignoreStringEscapes:true
		
		try (
		local temp = openFile "$userScripts\\WallWorm.com\\config\\vmfPresets.ms" mode:"r"
		execute temp
		close temp
		) catch()
		--fillPresets()
	) else  (
		try (
				local temp = openFile "$scripts\\WallWorm.com\\config\\vmfPresets.ms" mode:"r"
				execute temp
				close temp

		) catch(
				local temp = openFile "$scripts\\WallWorm.com\\config\\vmfPresets.ms" mode:"r"
				execute temp
				close temp
			
		)
	)
		
		
		
		
	
		
		
		
		
		cbxSkyName.items = getSkyNames()
	
		global wallworm_file_vmf_presets
	
	
		if wallworm_file_vmf_presets.skyName != undefined AND wallworm_file_vmf_presets.skyName != "" then (
		
			cbxSkyName.selection = findItem cbxSkyName.items wallworm_file_vmf_presets.skyName
		
		)
		
	--cpAmbient.color=lightTintColor
	)
	on chk_displacements changed state do
	(


		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.outputDisplacements = state
		rootNode.outputDisplacements = state
		--setFileVMFProperties()
	
	)
	on chk_wwBrush changed state do
	(

		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.outputBrushes = state
		rootNode.outputBrushes = state
		
	
	)
	on chk_cvxWalls changed state do
	(

		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.outputBrushEntities = state
		rootNode.outputBrushEntities = state
	)
	on chk_cvxEntities changed state do
	(

		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.outputPointEntities = state
		rootNode.outputPointEntities = state

	
	)
	on chk_lights changed state do
	(

		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.outputLights = state
		rootNode.outputLights = state
		
	
	)
	on btn_export pressed do
	with undo off 
		(
			--forcecompleteredraw()
			--vmf = getVMFFromUI()
			max create mode
			global wallworm_file_vmf_presets
			--print vmf
			macros.run "wallworm.com" "WallWormRepairDXRenderMatNamesMCR"
			suspendEditing()
			
			--  (
			--try with redraw off (
			local started = timestamp()
			if wallworm_file_vmf_presets.setFileName() == true then (
				
				rootNode.Wallworm_VMF.filename = wallworm_file_vmf_presets.filename
				
				if  wallworm_file_vmf_presets.outputVMF() == true  then (
						local ended = timestamp()
						seconds = ((ended - started) / 1000.0) 
						minutes = seconds / 60 
												--leftover = mod seconds 60 
												
						format "% Exported in % seconds (% minutes)\n" (getFileNameFile (wallworm_file_vmf_presets.filename)) seconds minutes 	
						
						--setFileVMFProperties filename:wallworm_file_vmf_presets.filename

					if chk_compile.state == true then (
						
						wallworm_file_vmf_presets.writeBatchFile()
						wallworm_file_vmf_presets._this = wallworm_file_vmf_presets
						 wallworm_file_vmf_presets.writeBSPZIPBatchFile()
			
			
						wallworm_file_vmf_presets.runCompile()
					) else (
						
							addednoticice = ""
							--addednoticice = "\n\nCurrently, brush geometry UVW is not properly exported."	
							if (maxVersion())[1] < 12000 then (
								addednoticice += "\n\nUnfortunately, at the moment, the vertex painting (material blending) only exports from Max 2010+."
									
							) else (
									
							)
							messagebox ("The VMF File was successfully saved."+addednoticice)
						
						
						)
					
					
				) else (
						messagebox "VMF Not Saved."
				)
		
			) else (
				
				Print "VMF Name not set... not exporting."
			)
				
				resumeEditing()
				
			--) catch (
		
					--resumeEditing()
				
				--messagebox "Oops... there was a problem with the export. Press F11 for more details."
				
				--print (getCurrentException())
					--message
			--)
			vmf = undefined
		)
	on chk_models changed state do
	(

		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.outputModels = state
		rootNode.outputModels = state
	)
	on chk_visFast changed state do
	(

		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.vvisFast = state
		rootNode.vvisFast = state
	
	)
	on chk_vradBoth changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.vradBoth = state
		rootNode.vradBoth = state
	)
	on chk_vradFinal changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.vradFinal = state
		rootNode.vradFinal = state
	
	)
	on chk_compile changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.compileMap = state
		rootNode.compileMap = state
	)
	on chk_launch changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.launchGame = state
		rootNode.launchGame = state

	)
	on edt_visOpts entered text do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.visOpts = text
		rootNode.visOpts = text
	)
	on edt_radOpts entered text do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.radOpts = text
		rootNode.radOpts = text

	
	)
	on edt_bspOpts entered text do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.bspOpts = text
		rootNode.bspOpts = text
	
	)
	on spn_lightMultiplier changed val do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.lightMultiplier = val
		rootNode.lightMultiplier = val
	
	)
	on spn_lightEnvMultiplier changed val do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.lightEnvMultiplier = val
		rootNode.lightEnvMultiplier = val
	
	)
	on ddlVisOpts selected sel do
	(
		edt_visOpts.text += ddlVisOpts.selected
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.visOpts = edt_visOpts.text
		rootNode.visOpts = edt_visOpts.text
	)
	on cbxPresets selected sel do
	(
				if cbxPresets.selection > 0 then (
					global wallworm_vmfPresets
					setFromPreset (wallworm_vmfPresets[cbxPresets.selection].vmf )
				)
				setFileVMFProperties()
	)
	on btnSavePreset pressed do
	(
				global wallworm_vmfPresets
				local preset = wallwormVMFPreset()
				preset.vmf = copy (getVMFFromUI())
				preset.name = cbxPresets.text
				preset.vmf._this = undefined
				preset.vmf.devmap = undefined
				preset.vmf.worldspawn = undefined
				preset.vmf.filename = undefined
				preset.vmf.allObject = #()
				preset.vmf.objectCollection= #()
				preset.vmf.shapeCollection=#()
				preset.vmf.lightCollection=#()
				preset.vmf.cameraCollection=#()
				preset.vmf.helperCollection = #()
					
					
					
				if preset.name == undefined OR preset.name  == "" then (
					
					local sfn = maxFileName
			
					if sfn != undefined AND sfn != "" then (
					preset.name =substring  sfn 1 (sfn.count - 4)
					) else (
						
						preset.name = "New Preset"
					)
					
				)
		
				
				if wallworm_vmfPresets.count == 0 OR cbxPresets.selection == 0 then (
					append wallworm_vmfPresets preset
				) else (
					
					wallworm_vmfPresets[cbxPresets.selection] = preset
				)
				
				
				writePreferences()
				
				--setINISetting wallworm_userIni "Presets" "vmf" (wallworm_vmfPresets as string)
				cbxPresets.items = (updateVMFPresetList() as array)
				
			)
	on ddlBSPOpts selected sel do
	(
		edt_bspOpts.text += ddlBSPOpts.selected
	
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.bspOpts = edt_bspOpts.text
		rootNode.bspOpts = edt_bspOpts.text
		
	
	)
	on ddlRadOpts selected sel do
	(
		edt_radOpts.text += ddlRadOpts.selected
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.radOpts = edt_radOpts.text
		rootNode.radOpts = edt_radOpts.text
		
	)
	on btnDeletePreset pressed do
	(
		if cbxPresets.selection > 0 then (
			global wallworm_vmfPresets
			deleteItem 	wallworm_vmfPresets cbxPresets.selection
			writePreferences()
			cbxPresets.items = (updateVMFPresetList() as array)

		)
	)
	on btn28 pressed do
	(
	cbxPresets.selection = 0
	
	)
	on chkHidden changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.includeHidden = state
		rootNode.includeHidden = state
		
	)
	on spnLightmapScale changed val do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.lightmapScale = val
		rootNode.lightmapScale = val
	
	)
	on btn5 pressed do
	(
		global wallworm_file_vmf_presets
		wallworm_file_vmf_presets.writeBatchFile()
		wallworm_file_vmf_presets._this = wallworm_file_vmf_presets
		if wallworm_file_vmf_presets.addPackBat() ==true then (
			wallworm_file_vmf_presets.writeBSPZIPBatchFile()
		)
		wallworm_file_vmf_presets.runCompile()
		
	)
	on btnOpenMaps pressed do
	(
		   
		   global wallworm_file_vmf_presets
		   if wallworm_file_vmf_presets.filename != undefined then (
					folderOpen =
					execute ("ShellLaunch \"explorer.exe\" @\""+(getFilenamePath wallworm_file_vmf_presets.filename)+"\"")
			   
			   ) else (
			   
				execute ("ShellLaunch \"explorer.exe\" @\""+(wwdt_mapsrc)+"\"")
			   
			   )
		   
		   )
	on chkEmbedWWMT changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.EmbedWWMT = state
		rootNode.EmbedWWMT = state

	)
	on chkEmbeddWWMTTex changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.EmbeddWWMTTex = state
		rootNode.EmbeddWWMTTex = state

	
	)
	on chkEmbedSky changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.EmbedSky = state
		rootNode.EmbedSky = state

	)
	on chkEmbedCVXProps changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.EmbedCVXProps = state
		rootNode.EmbedCVXProps = state

	)
	on chkEmbedWorldTex changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.EmbedWorldTex = state
		rootNode.EmbedWorldTex = state
	
	)
	on chkEmbedVBSP changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.EmbedVBSP = state
		rootNode.EmbedVBSP = state
	
	)
	on cpAmbient changed col do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.AmbientLDR = col
		rootNode.AmbientLDR = col

	
	)
	on cpHDRBrightness changed col do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.HDRBrightness = col
		rootNode.HDRBrightness = col
	)
	on cpAmbientHDR changed col do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.AmbientHDR = col
		rootNode.AmbientHDR = col
	)
	on chkUseBrightness changed state do
	(
	
		if state == true then (
		
			useHDRBrightness false
		) else (
		
			useHDRBrightness true
		)

	)
	on chkUseLDRAmbient changed state do
	(
		if state == true then (
			useHDRAmbient false
		) else (
			useHDRAmbient true
		)

	)
	
	
	
	
	on spnAmbientScaleLDR changed val do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.AmbientScale = val
		rootNode.AmbientScale = val
	)
	
	on spnHDRScale changed val do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.HDRScale = val
		rootNode.HDRScale = val

	)
	on spnSunSpreadAngle changed val do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.SunSpreadAngle = val
		rootNode.SunSpreadAngle = val
	
	)
	on btn19 pressed do
	(
		macros.run "wallworm.com" "WallWormRepairDXRenderMatNamesMCR"
		global wallworm_file_vmf_presets
		wallworm_file_vmf_presets.writeBatchFile()
		wallworm_file_vmf_presets._this = wallworm_file_vmf_presets
		wallworm_file_vmf_presets.writeBSPZIPBatchFile()
	
	)
	on spnAmbientScale changed val do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.AmbientHDRScale = val
		rootNode.AmbientHDRScale = val
		
	)
	on cbxSkyName selected sel do
	(
		if sel > 0 AND cbxSkyName.selected != undefined then (
			wallworm_file_vmf_presets.skyName = cbxSkyName.selected
			

			rootNode.skyName = wallworm_file_vmf_presets.skyName

	
			
		)
	)
	on cbxSkyName entered text do
	(
		global wallworm_file_vmf_presets
		wallworm_file_vmf_presets.skyName = text

		if findItem cbxSkyName.items wallworm_file_vmf_presets.skyName == 0 then (
			
			tempItems = cbxSkyName.items
			append tempItems wallworm_file_vmf_presets.skyName
			
			 cbxSkyName.items = tempItems
			) else (
			
			
			)
			if cbxSkyName.items != undefined then (
			cbxSkyName.selection = findItem cbxSkyName.items wallworm_file_vmf_presets.skyName
			)
			

			rootNode.skyName = text


	)
	on spnMaxPropScreenWidth changed val do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.MaxPropScreenWidth = val
		rootNode.MaxPropScreenWidth = val
		
	)
	on spnMinPropScreenWidth changed val do
	(
	
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.MinPropScreenWidth = val
		rootNode.MinPropScreenWidth = val

	)
	on btnLeak pressed do
	(
		macros.run "wallworm.com" "WallWormLoadLeakFileMCR"
	)
	on chkEmbedWAVs changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.EmbedWAVs = state
		rootNode.EmbedWAVs = state

	)
	on edtDetailSprites entered text do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.DetailSprites = text
		rootNode.DetailSprites = text

	)
	on edtDetailVBSP entered text do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.DetailVBSP = text
		rootNode.DetailVBSP = text
		
	)
	on chkBreakNonPlanarFaces changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.BreakNonPlanarFaces = state
		rootNode.BreakNonPlanarFaces = state
			
	)
	on chkPrecise changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.precise = state
		rootNode.precise = state
		
	)
	on chkCompileLogWindow changed state do
	(
		global wallworm_file_vmf_presets			
		wallworm_file_vmf_presets.compileLogWindow = state
		rootNode.compileLogWindow = state

	)
)




	if NOT isProperty rootNode "Wallworm_VMF" then (
		/*Legacy data not stored in CA.*/
		wallwormVMFSettingsIndex = fileProperties.findProperty #custom "wallwormVMFSettings"
		if wallwormVMFSettingsIndex != 0 then (
			wallwormVMFSettings1=fileProperties.getPropertyValue #custom wallwormVMFSettingsIndex
			wallwormVMFSettings = "global wallworm_file_vmf_presets = ("+wallwormVMFSettings1+")"
			execute wallwormVMFSettings
			--print wallworm_file_vmf_presets
			
			wallworm_file_vmf_presets.wallworm_get_worldspawns()
			wallworm_file_vmf_presets.setFromWorldspawn()
			wallworm_file_vmf_presets.sanitize_filename()

			custAttributes.add rootNode wallworm_vmf_settings_CA
			rootNode.setVMFFromthis wallworm_file_vmf_presets	
			
		)  else (
			
			custAttributes.add rootNode wallworm_vmf_settings_CA
			rootNode.setVMFFromthis wallworm_file_vmf_presets	
			wallworm_file_vmf_presets = wallwormVMF()
			rootNode.setVMFFromthis &wallworm_file_vmf_presets	
		)
		

		

		
	) else (
		
		wallworm_file_vmf_presets = wallwormVMF()
		rootNode.setVMFFromthis &wallworm_file_vmf_presets	
		
		if isProperty rootNode "WW Entity worldspawn" then (
			
			wallworm_file_vmf_presets.worldspawn = rootNode
			wallworm_file_vmf_presets.setFromWorldspawn()
		)
		

		


		
	)
	
		

	createDialog WallWormVMFExport
	wwvmfdummy = undefined 
	WallWormVMFExport.cbxPresets.items = (updateVMFPresetList() as array)
	
	if isProperty rootNode "WW Entity worldspawn" then (
		
		wallworm_file_vmf_presets.worldspawn = rootNode
		wallworm_file_vmf_presets.setFromWorldspawn()
		wallworm_file_vmf_presets.setWorldspawn()

	)
		


	WallWormVMFExport.setFromPreset (wallworm_file_vmf_presets)
	
	WallWormVMFExport.cbxSkyName.items = WallWormVMFExport.getSkyNames()
	

	bspItems = WallWormVMFExport.ddlBSPOpts.items
	radItems = WallWormVMFExport.ddlRadOpts.items
	visItems = WallWormVMFExport.ddlVisOpts.items

	/*ALphabetize the option lists*/
	sort bspItems
	sort radItems
	sort visItems

	

	WallWormVMFExport.ddlBSPOpts.items = bspItems
	WallWormVMFExport.ddlRadOpts.items = radItems
	WallWormVMFExport.ddlVisOpts.items = visItems
	
	bspItems = undefined
	radItems = undefined
	visItems = undefined
	
		
	--)