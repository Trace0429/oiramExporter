global wallworm_vmf_settings_CA
wallworm_vmf_settings_CA = attributes "Wallworm_VMF" 
version:1 
(

parameters params rollout:vmfparams (
	    filename  type:#filename
		outputModels type:#boolean default:true ui:chk_models
		outputDisplacements type:#boolean default:true ui:chk_displacements
		outputBrushes type:#boolean default:true ui:chk_wwBrush
		outputPointEntities type:#boolean default:true ui:chk_cvxEntities
		outputBrushEntities type:#boolean default:true ui:chk_cvxWalls
		outputLights type:#boolean default:true ui:chk_lights
		vradBoth type:#boolean default:true ui:chk_vradBoth
		vradFinal type:#boolean default:false ui:chk_vradFinal
		vvisFast type:#boolean default:false ui:chk_visFast
		launchGame type:#boolean default:false ui:chk_launch
		compileMap type:#boolean default:false ui:chk_compile
		lightMultiplier  type:#float default:200 ui:spn_lightMultiplier
		lightEnvMultiplier type:#float default:20 ui:spn_lightEnvMultiplier
		includeHidden type:#boolean default:true ui:chkHidden
		visOpts type:#string  default:"" ui:edt_visOpts
		radOpts type:#string default:"" ui:edt_radOpts
		bspOpts type:#string default:"" ui:edt_bspOpts
		lightmapScale type:#float default:16 ui:spnLightmapScale
		EmbedWWMT type:#boolean default:false ui:chkEmbedWWMT
		EmbeddWWMTTex type:#boolean default:false ui:chkEmbeddWWMTTex
		EmbedSky type:#boolean default:false ui:chkEmbedSky
		EmbedCVXProps type:#boolean default:false ui:chkEmbedCVXProps
		EmbedWorldTex type:#boolean default:false ui:chkEmbedWorldTex
		EmbedWAVs type:#boolean default:false ui:chkEmbedWAVs
		EmbedVBSP type:#boolean default:false ui:chkEmbedVBSP
		HDRBrightness type:#color  default:(color 255 255 255) ui:cpHDRBrightness
		AmbientLDR type:#color  default: (color 255 255 255) ui:cpAmbient 
		AmbientHDR type:#color  default:(color 255 255 255) ui:cpAmbientHDR
		UseBrightness type:#boolean  default:true ui:chkUseBrightness
		UseLDRAmbient type:#boolean  default:true ui:chkUseLDRAmbient
		HDRScale type:#float  default:1.00 ui:spnHDRScale
		SunSpreadAngle type:#float  default:0.00 ui:spnSunSpreadAngle
		AmbientHDRScale type:#float  default:1.00 ui:spnAmbientScale    
		AmbientScale type:#float  default:2.0 ui:spnAmbientScaleLDR
		skyName type:#string default:""  -- ui:cbxSkyName
		MaxPropScreenWidth type:#integer default:-1 ui:spnMaxPropScreenWidth
		MinPropScreenWidth type:#integer default:0 ui:spnMinPropScreenWidth
		DetailSprites type:#string  default:"detail/detailsprites" ui:edtDetailSprites
		DetailVBSP type:#string  default:"detail.vbsp" ui:edtDetailVBSP
		BreakNonPlanarFaces type:#boolean default:false ui:chkBreakNonPlanarFaces
		precise type:#boolean default:true ui:chkPrecise
		compileLogWindow type:#boolean default:false ui:chkCompileLogWindow

)

function getSettingsFromVMFStruct vmf = (
		with redraw off (

		if vmf.filename != undefined then (
			filename  = vmf.filename 
		)
		outputModels = vmf.outputModels 
		outputDisplacements = vmf.outputDisplacements 
		outputBrushes = vmf.outputBrushes 
		outputPointEntities = vmf.outputPointEntities 
		outputBrushEntities = vmf.outputBrushEntities 
		outputLights = vmf.outputLights 
		vradBoth = vmf.vradBoth 
		vradFinal = vmf.vradFinal 
		vvisFast = vmf.vvisFast 
		launchGame = vmf.launchGame 
		compileMap = vmf.compileMap 
		lightMultiplier  = vmf.lightMultiplier 
		lightEnvMultiplier = vmf.lightEnvMultiplier 
		includeHidden = vmf.includeHidden 
		visOpts = vmf.visOpts 
		radOpts = vmf.radOpts 
		bspOpts = vmf.bspOpts 
		lightmapScale = vmf.lightmapScale 
		EmbedWWMT = vmf.EmbedWWMT 
		EmbeddWWMTTex = vmf.EmbeddWWMTTex 
		EmbedSky = vmf.EmbedSky 
		EmbedCVXProps = vmf.EmbedCVXProps 
		EmbedWorldTex = vmf.EmbedWorldTex 
		EmbedWAVs = vmf.EmbedWAVs 
		EmbedVBSP = vmf.EmbedVBSP 
		HDRBrightness = vmf.HDRBrightness 
		AmbientLDR = vmf.AmbientLDR 
		AmbientHDR = vmf.AmbientHDR 
		UseBrightness = vmf.UseBrightness 
		UseLDRAmbient = vmf.UseLDRAmbient 
		HDRScale = vmf.HDRScale 
		SunSpreadAngle = vmf.SunSpreadAngle 
		AmbientHDRScale = vmf.AmbientHDRScale 
		AmbientScale = vmf.AmbientScale 
		skyName = vmf.skyName 
		MaxPropScreenWidth = vmf.MaxPropScreenWidth 
		MinPropScreenWidth = vmf.MinPropScreenWidth 
		DetailSprites = vmf.DetailSprites
		DetailVBSP = vmf.DetailVBSP 
		BreakNonPlanarFaces = vmf.BreakNonPlanarFaces 
		precise = vmf.precise
		compileLogWindow = vmf.compileLogWindow

	)
)
	
function setVMFFromthis &vmf= (

	    vmf.filename  = filename 
		vmf.outputModels = outputModels 
		vmf.outputDisplacements = outputDisplacements 
		vmf.outputBrushes = outputBrushes 
		vmf.outputPointEntities = outputPointEntities 
		vmf.outputBrushEntities = outputBrushEntities 
		vmf.outputLights = outputLights 
		vmf.vradBoth = vradBoth 
		vmf.vradFinal = vradFinal 
		vmf.vvisFast = vvisFast 
		vmf.launchGame = launchGame 
		vmf.compileMap = compileMap 
		vmf.lightMultiplier  = lightMultiplier 
		vmf.lightEnvMultiplier = lightEnvMultiplier 
		vmf.includeHidden = includeHidden 
		vmf.visOpts = visOpts 
		vmf.radOpts = radOpts 
		vmf.bspOpts = bspOpts 
		vmf.lightmapScale = lightmapScale 
		vmf.EmbedWWMT = EmbedWWMT 
		vmf.EmbeddWWMTTex = EmbeddWWMTTex 
		vmf.EmbedSky = EmbedSky 
		vmf.EmbedCVXProps = EmbedCVXProps 
		vmf.EmbedWorldTex = EmbedWorldTex 
		vmf.EmbedWAVs = EmbedWAVs 
		vmf.EmbedVBSP = EmbedVBSP 
		vmf.HDRBrightness = HDRBrightness 
		vmf.AmbientLDR = AmbientLDR 
		vmf.AmbientHDR = AmbientHDR 
		vmf.UseBrightness = UseBrightness 
		vmf.UseLDRAmbient = UseLDRAmbient 
		vmf.HDRScale = HDRScale 
		vmf.SunSpreadAngle = SunSpreadAngle 
		vmf.AmbientHDRScale = AmbientHDRScale 
		vmf.AmbientScale = AmbientScale 
		vmf.skyName = skyName 
		vmf.MaxPropScreenWidth = MaxPropScreenWidth 
		vmf.MinPropScreenWidth = MinPropScreenWidth 
		vmf.DetailSprites = DetailSprites
		vmf.DetailVBSP = DetailVBSP 
		vmf.BreakNonPlanarFaces = BreakNonPlanarFaces 
		vmf.precise = precise
		vmf.compileLogWindow = compileLogWindow

)
	
rollout vmfparams "Wall Worm VMF"
(
	Group  "Exported Objects" (
		checkbox chk_displacements "Displacements"  toolTip:"Export displacements created with Anvil."
		checkbox chk_wwBrush "World Brushes"  toolTip:"Export geometry as world brushes that you've assigned as Brushes in Anvil. Also exports geometry in any layer called `Convexity Walls` and `Convexity Floors`."
		checkbox chk_cvxWalls "Brush Entities"  toolTip:"Export Brush and Associated Entity information for any geometry that has been tied to a brush entity."
		checkbox chk_cvxEntities "Point Entities"  toolTip:"Export all Point Entities."
		checkbox chk_lights "Lights"  toolTip:"Export all scene lights as corresponding light entity."
		checkbox chk_models "WWMT Models" toolTip:"Export all WWMT helpers in the scene along with their associated Proxy models."	
		checkbox chkHidden "Hidden Objects"  toolTip:"Export objects that are hidden."

	)
	
	
	group "Compile Parameters" (
		

		dropdownList ddlBSPOpts ""  items:#("", " -verbose ", " -onlyents ", " -onlyprops ", " -glview ", " -nodetail ", " -nowater ", " -low ", " -vproject <directory> ", " -game <directory> ", " -novconfig ", " -threads #", " -verboseentities ", " -noweld ", " -nocsg ", " -noshare ", " -notjunc ", " -noopt ", " -noprune ", " -nomerge ", " -nomergewater ", " -nosubdiv ", " -micro <#> ", " -fulldetail ", " -leaktest ", " -bumpall ", " -snapaxial ", " -block # # ", " -blocks # # # # ", " -dumpstaticprops ", " -dumpcollide ", " -luxelscale # ", " -lightifmissing ", " -localphysx ", " -keepstalezip ", " -replacematerials ", " -FullMinidumps ")
		label bsplabel "BSP Options"  align:#left
		edittext edt_bspOpts ""		

		
		label vislabel "Vis Options" align:#left
		
		checkbox chk_visFast "Fast"
		dropdownList ddlVisOpts ""  items:#("", " -radius_override # ", " -nosort ", " -tmpin ", " -tmpout ", " -low ", " -threads #", " -v ", " -verbose ", " -novconfig ", " -mpi ", " -mpi_pw <string> ", " -vproject <string> ", " -game <string> ")

		edittext edt_visOpts "Options" 

		label radlabel "Rad Options" align:#left
		dropdownList ddlRadOpts ""  items:#("", " -ldr ", " -hdr ", " -both ", " -fast ", " -final ", " -extrasky <int> ", " -lights <filename>.rad ", " -bounce <int> ", " -smooth <int> ", " -luxeldensity <normal> ", " -softsun <float> ", " -StaticPropLighting ", " -StaticPropPolys ", " -TextureShadows ", " -low ", " -threads <int> ", " -mpi ", " -mpi_pw <string> ", " -noextra ", " -chop <int> ", " -maxchop <int> ", " -LargeDispSampleRadius ", " -compressconstant <int> ", " -rederrors ", " -vproject <directory> ", " -game <directory> ", " -v ", " -verbose ", " -novconfig ", " -dump ", " -dumpnormals ", " -debugextra ", " -dlightmap ", " -stoponexit ", " -nodetaillight ", " -centersamples ", " -loghash ", " -onlydetail ", " -maxdispsamplesize # ", " -FullMinidump ", " -OnlyStaticProps ", " -StaticPropNormals ", " -noskyboxrecurse ", " -nossprops ")
		checkbox chk_vradBoth "Both" across:2 toolTip:"This option only adds -both flag. Calculates both HDR and LDR."
		checkbox chk_vradFinal "Final" toolTip:"Spend extra time firing light_environment rays. When on, equivalent to -extrasky 16. When not used, then equivalent to -extrasky 1."
		edittext edt_radOpts "" 

	)




	Group "Lights" (

		spinner spn_lightMultiplier "light multiplier"  range:[1,1000,200] type:#float scale:1 toolTip:"Enter a multiplier converting Max light multipliers into Source light brightness. This value is multiplied against the lights' individual multipliers. This value is for the light and light_spot entities."
		spinner spn_lightEnvMultiplier "env mult"  range:[1,1000,20] type:#integer scale:1 toolTip:"Enter a multiplier for the light_environment entities. This multiplier is multiplied against the light's multiplier for the final Source multiplier. So if the light has a multiplier of 1 and this numer is 20, the Source brightness will be 20."
		spinner spnLightmapScale "Default Lightmap Scale"  range:[1,1024,16] type:#integer scale:1 toolTip:"Set the default lightmap scale for all brush and displacement faces that have not been otherwise set individually."

	)
		
	Group  "PAK Assets Into BSP" (
		checkbox chkEmbedWWMT "WWMT Models"  toolTip:"PAK the MDL files for WWMT models and proxies in this scene."
		checkbox chkEmbeddWWMTTex "WWMT Textures"  toolTip:"Embed all VMT and VTF files associated with your WWMT models and proxies."
		checkbox chkEmbedSky "Sky Textures"  toolTip:"Embed your Sky textures. Only works with Skywriter."
		checkbox chkEmbedCVXProps "Entity Assets"  toolTip:"Collect MDL, VMT, WAV and MP3 from Entities."
		checkbox chkEmbedWorldTex "World Textures"  toolTip:"Embed VMT and VTF files from the world geometry. The materials must be named properly for this function to work. This option not yet fully tested."
		checkbox chkEmbedVBSP "Detail Texture"  toolTip:"Embed your detail texture. Note that this will read materials from Wall Worm Detail Props."
		checkbox chkEmbedWAVs "Soundscape Contents"  toolTip:"Collect sounds listed in soundscapes."
		button btn19 "Update Pak List"  toolTip:"Recreate the pak list for zipping assets into the scene. May be necessary if you have added new models/materials, etc since the last time the scene was exported."

	)

	group "Light Defaults" (
		colorPicker cpAmbient "Ambient"   title:"Choose Ambient color (controls the Global Tint in Max)." toolTip:"Choose the ambient color for your map. Only works if you have a light that exports as light_environment. Will change the Max global Tint inside the Max Environment settings."
		colorPicker cpHDRBrightness "HDR Color" title:"Choose Brightness (HDR Color)" toolTip:"Set the default global HDR color for lights. Only works if Use LDR Color is unchecked."
		colorPicker cpAmbientHDR "Ambient HDR"   title:"Choose Ambient color" toolTip:"Choose the HDR Ambient color. Only works if there is a light_environment light in the scene and Use LDR Ambient is unchecked."
		checkbox chkUseBrightness "Use LDR Color"  toolTip:"Set the global option for lights to use their LDR color as the HDR color if the light hasn't had a value set specifically."
		checkbox chkUseLDRAmbient "Use LDR Ambient"  toolTip:"Reuse the global Ambient color for the light_environment HDR ambient color."
		spinner spnHDRScale "HDR Scale"  range:[1,100,1] type:#float scale:0.01 toolTip:"Set the default HDR scale for all lights that do not have this value set individually."
	)
	Group "Environment" (
		spinner spnAmbientScale "Amb HDRScale"  range:[0,1000,1] toolTip:"Set the Ambient HDR Scale."
		spinner spnAmbientScaleLDR "Ambient Scale"  range:[0,1000,2] toolTip:"Set the Ambient Scale Multiplier for the light_environment. This value will be multiplied by the light's multiplier to create the value for the ambient light level (brightness of indirect environment lighting)."
		spinner spnSunSpreadAngle "Sun Spread"  range:[0,180,0] type:#integer scale:1 toolTip:"Set the Sun Spread angle. Only works if there is a light that exports as light_environment in the scene."
	
	)
	
	group "Map Parameters" (
		combobox cbxSkyName "Sky Name"  toolTip:"Enter the name of the sky for this map. The list will automatically include any sky writer files in the map."
		spinner spnMaxPropScreenWidth "Start"  range:[-1,32000,-1] type:#integer scale:1 toolTip:"Number of pixels wide at which all props in the level start to fade (<0 = use fademaxdist). This number is ignored if the prop has a specific fade distance specified."
		spinner spnMinPropScreenWidth "End"  range:[-1,32000,0] type:#integer scale:1 toolTip:"Minimum number of pixels wide at which the prop is visible (0 = don't fade out). This number is ignored if the prop has a specific fade distance specified."
		label detailSPrLabel "Detail Sprite" align:#left
		edittext edtDetailSprites "" 
		label detailVBSPLabel "VBSP File" align:#left
		edittext edtDetailVBSP "" 
	)
	
	group "Export" (
		checkbox chkBreakNonPlanarFaces "Break Non Planar Faces"  toolTip:"Tell the exporter to break non-planar polygons into pieces. Useful for solving problems where convex geometry in Max sometimes misses geometry... but might take longer to export."
		checkbox chkPrecise "Precise Coords"  toolTip:"When on, uses long digits for brush vertex coordinates. For Hammer-like truncatedvalues, turn off (but may lead to non-convex geometry and/or changes in exported geometry)."
		checkbox chkCompileLogWindow "Output Compile Window"  toolTip:"When on, the compile log is displayed in console. When off, the compiler will not display a lot of info. At the end of compile, the compile log will open in your text editor."
		checkbox chk_compile "Compile Map on Export" 
		checkbox chk_launch "Launch Game after Compile" 
		button btn_export "Export to VMF" toolTip:"Run the export. You'll be prompted to name and save the file. This may take several minutes (or longer depending on scene complexity and computer speed) and may appear to have frozen Max."
	)

	group "Extra Functions" (
		button btnLeak "Open Leak File" toolTip:"Load the Leak File to help find leaks. This file only exists if you have tried to compile and the compiler created a LIN file."	
		button btn5 "Run Compile Batch"  toolTip:"Compile the map. This function only works if you have previously exported the map."
		button btnOpenMaps "Open Maps"  toolTip:"Open the folder where your VMF exports to along with Wall Worm batch files."
	)
	
	
	HyperLink help "WW VMF Help" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/47/vmf_exporter.html"	
	HyperLink linkWW "WallWorm.com"  address:"http://www.wallworm.com" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	HyperLink donate "Donate & Support Wall Worm"  color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/42/donate.html"	

)

)
/*
b = Box()
custAttributes.add b wallworm_vmf_settings_CA*/