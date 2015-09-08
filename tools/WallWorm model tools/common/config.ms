global ww_wwmt_version = 2.163
global wallworm_entity_version = 36
/*

This block is the ground work for future versions of WW that will utilize .NET.

global WallWormAssembly
global WallWormDOTNET

try (
	if  WallWormAssembly == undefined then (
		WallWormAssembly = dotnet.loadAssembly "$scripts\\WallWorm.com\\assemblies\\WWTest.dll"
	)
	if WallWormAssembly != undefined AND WallWormDOTNET == undefined  then (
		WallWormDOTNET = dotnetObject "WWTest.WallWormFuncs"
	)
) catch ()
*/
if wallwormUpdateNotice == undefined then (
	global wallwormUpdateNotice = false
)
if wallwormUpdateCheck == undefined then (
	global wallwormUpdateCheck = false
)


global wallworm_globalIni =   ((symbolicPaths.getPathValue "$scripts")+"/WallWorm.com/config/wwmt.ini")
global wallworm_userIni = ((symbolicPaths.getPathValue "$userScripts") + "/WallWorm.com/config/wwmt.ini")


if (wallworm_userIni==undefined OR doesFileExist wallworm_userIni == false) do (
	
   global  wwmtinifolder = ((symbolicPaths.getPathValue "$userScripts") + "/WallWorm.com/config")
	if (makeDir wwmtinifolder all:true == false ) do (
		print "Config Directory doesn't exist"
		messagebox "There is no config directory for the WW Model Tools... and MAXScript does not have permission to write to the appropriate directory."
	)
	
	wallworm_userIni = ((symbolicPaths.getPathValue "$userScripts") + "/WallWorm.com/config/wwmt.ini")
	
)
	
wwmt_installedversion = GetINISetting wallworm_userIni "Version" "wwmt_installedversion"

if wwmt_installedversion ==undefined OR wwmt_installedversion=="" OR (wwmt_installedversion as number) <  ww_wwmt_version do (
	

	fileIn "$scripts\\WallWorm.com\\WallWormUtilities\\addWWtoMaxMenu.ms"
	setINISetting wallworm_userIni "Version" "wwmt_installedversion" (ww_wwmt_version as string)
	
	if wallwormUpdateNotice == false then (
		include "$scripts/WallWorm.com/common/version_funcs.ms"
		--shellLaunch ("http://dev.wallworm.com/topic/33/wwmt_changelog.html?previous="+(wwmt_installedversion as string)) ""
		local maxInfo =  wallworm_getMaxVersion()
		shellLaunch ("http://dev.wallworm.com/topic/33/wwmt_changelog.html?previous="+(wwmt_installedversion as string)+"&installed="+(ww_wwmt_version as string)+"&maxversion="+(maxInfo[1] as string)+"&maxupdateversion="+(maxInfo[2] as string)) ""
		
		wallwormUpdateNotice = true
	)
)
	
 global wwmt_gameInfoDir = GetINISetting wallworm_userIni "Directories" "gameInfoDir"
global wwmt_sdk_folder = GetINISetting wallworm_userIni "Directories" "wwmt_sdk_folder"

if wwmt_sdk_folder=="" do (

	wwmt_sdk_folder = (dotnetclass "System.Environment").GetEnvironmentVariable("sourcesdk")
	
	global wwmt_valvemod_arraystr = (dotnetclass "System.Environment").GetEnvironmentVariable("VProject")
	
	
		if wwmt_valvemod_arraystr != undefined AND wwmt_valvemod_arraystr != "" then (
			
			
			if wwmt_gameInfoDir == undefined OR wwmt_gameInfoDir == "" then (
				wwmt_gameInfoDir = wwmt_valvemod_arraystr
				setINISetting wallworm_userIni "Directories" "gameInfoDir" wwmt_gameInfoDir
			)
			if wwmt_sdk_folder != undefined then (
			wwmt_valvemod_array = filterString wwmt_valvemod_arraystr "\\"
				if wwmt_valvemod_array.count > 0 then (
					append wwmt_sdk_folder ("_content\\"+wwmt_valvemod_array[wwmt_valvemod_array.count ])
					)
				)
		)
	if wwmt_sdk_folder != undefined then (
		setINISetting wallworm_userIni "Directories" "wwmt_sdk_folder" wwmt_sdk_folder
	)
	
)
	
if wwmt_sdk_folder==undefined then (
	wwmt_sdk_folder=""
	
)


global wwmt_export = GetINISetting wallworm_userIni "Directories" "export"

if wwmt_export=="" do (
	
	
    if wwmt_sdk_folder == undefined OR wwmt_sdk_folder == "" then (
		wwmt_export = GetINISetting wallworm_globalIni "Directories" "export"
	) else (
		wwmt_export =  (wwmt_sdk_folder+"\\modelsrc")
		
	)
	
	setINISetting wallworm_userIni "Directories" "export" (wwmt_sdk_folder+"\\modelsrc")
	
	)
	
	

	

global wwmt_exportMats = GetINISetting wallworm_userIni "Directories" "exportMats"

if wwmt_exportMats=="" do (
	
	
	 if wwmt_sdk_folder == undefined OR wwmt_sdk_folder == "" then (
		wwmt_exportMats = GetINISetting wallworm_globalIni "Directories" "exportMats"
	 ) else (
		 wwmt_exportMats =  (wwmt_sdk_folder+"\\materialsrc")
		 
	)
	
	setINISetting wallworm_userIni "Directories" "exportMats"  (wwmt_sdk_folder+"\\materialsrc")
	
	)	
	
	
	
global wwmt_def_model_path = GetINISetting wallworm_userIni "Directories" "def_model_path"
if wwmt_def_model_path == "" then (
	wwmt_def_model_path = GetINISetting wallworm_globalIni "Directories" "def_model_path"
 	setINISetting wallworm_userIni "Directories" "def_model_path" wwmt_def_model_path
	
)
	
global wwmt_def_material_path = GetINISetting wallworm_userIni "Directories" "def_material_path"
if wwmt_def_material_path == "" then (
	
	wwmt_def_material_path = GetINISetting wallworm_globalIni "Directories" "def_material_path"
 	setINISetting wallworm_userIni "Directories" "def_material_path" wwmt_def_material_path
	
)
	

global wwdt_mapsrc = GetINISetting wallworm_userIni "Directories" "exportMaps"

if ((wwdt_mapsrc == undefined OR  wwdt_mapsrc == "") AND (wwmt_sdk_folder != undefined AND  wwmt_sdk_folder != "") ) do (

				wwdt_mapsrc =  (wwmt_sdk_folder+"\\mapsrc")
				setINISetting wallworm_userIni "Directories" "exportMaps" wwdt_mapsrc

	
	)
		
 global wwmt_binDir = GetINISetting wallworm_userIni "Directories" "binDir"

if wwmt_binDir == "" then (
	
	wwmt_tmpBin = (dotnetclass "System.Environment").GetEnvironmentVariable("sourcesdk")
	if wwmt_tmpBin != undefined then (
		wwmt_binDir = (wwmt_tmpBin + "\\bin\\orangebox\\bin")
		setINISetting wallworm_userIni "Directories" "binDir" wwmt_binDir
		tmpBin = undefined
	) else (
		setINISetting wallworm_userIni "Directories" "binDir" ""
		
		)
)
	
	
-- if binDir=="" do (
-- 	
-- 	binDir = GetINISetting wallworm_globalIni "Directories" "binDir"
-- 	setINISetting wallworm_userIni "Directories" "binDir" ""
-- 	
-- 	)	


	

global wwmtAutoCompile = GetINISetting wallworm_userIni "Settings" "wwmtAutoCompile"

if wwmtAutoCompile=="" do (
	
	wwmtAutoCompile = GetINISetting wallworm_globalIni "Settings" "wwmtAutoCompile"
	setINISetting wallworm_userIni "Settings" "wwmtAutoCompile" (wwmtAutoCompile as string)
	
)
	
global wallworm_displacement_events = GetINISetting wallworm_userIni "Displacements" "wallworm_displacement_events"

if wallworm_displacement_events=="" OR wallworm_displacement_events == "true" do (
	
	wallworm_displacement_events =  true
	setINISetting wallworm_userIni "Displacements" "wallworm_displacement_events" (wallworm_displacement_events as string)
	
)
	
	
	

	
global wwmtCompileMessage = GetINISetting wallworm_userIni "Settings" "wwmtCompileMessage"
if wwmtCompileMessage=="" do (
	wwmtCompileMessage = GetINISetting wallworm_globalIni "Settings" "wwmtCompileMessage"
	setINISetting wallworm_userIni "Settings" "wwmtCompileMessage" (wwmtCompileMessage as string)
	
)


--this setting is whether the vmf exportor should use the esc character to separate outputs, which is used in later versions of Hammer
global wwmt_vmf_output_separator_esc = GetINISetting wallworm_userIni "Settings" "wwmt_vmf_output_separator_esc"
if wwmt_vmf_output_separator_esc=="" do (
	wwmt_vmf_output_separator_esc = GetINISetting wallworm_globalIni "Settings" "wwmt_vmf_output_separator_esc"
	setINISetting wallworm_userIni "Settings" "wwmt_vmf_output_separator_esc" (wwmt_vmf_output_separator_esc as string)
	
)


	

	
global wwmt_translucentOnlyIfOpacityMap = GetINISetting wallworm_userIni "Materials" "wwmt_translucentOnlyIfOpacityMap"

if wwmt_translucentOnlyIfOpacityMap=="" do (
	
	wwmt_translucentOnlyIfOpacityMap = GetINISetting wallworm_globalIni "Materials" "wwmt_translucentOnlyIfOpacityMap"
	setINISetting wallworm_userIni "Settings" "wwmt_translucentOnlyIfOpacityMap" (wwmt_translucentOnlyIfOpacityMap as string)
	
)
	

global wwmt_oldModelVTFPath = GetINISetting wallworm_userIni "Materials" "wwmt_oldModelVTFPath"

if wwmt_oldModelVTFPath=="" do (
	
	wwmt_oldModelVTFPath = GetINISetting wallworm_globalIni "Materials" "wwmt_oldModelVTFPath"
	setINISetting wallworm_userIni "Settings" "wwmt_oldModelVTFPath" (wwmt_oldModelVTFPath as string)
	
)
	




global wwmt_forceOpaqueFromModel = GetINISetting wallworm_userIni "Materials" "wwmt_forceOpaqueFromModel"

if wwmt_forceOpaqueFromModel=="" do (
	
	wwmt_forceOpaqueFromModel = GetINISetting wallworm_globalIni "Materials" "wwmt_forceOpaqueFromModel"
	setINISetting wallworm_userIni "Materials" "wwmt_forceOpaqueFromModel" (wwmt_forceOpaqueFromModel as string)
	
)
	

global wwmt_allow_psd = GetINISetting wallworm_userIni "Materials" "wwmt_allow_psd"

if wwmt_allow_psd=="" do (
	
	wwmt_allow_psd = GetINISetting wallworm_globalIni "Materials" "wwmt_allow_psd"
	setINISetting wallworm_userIni "Materials" "wwmt_forceOpaqueFromModel" (wwmt_allow_psd as string)
	
)
	
global wwmt_legacy_names = GetINISetting wallworm_userIni "Materials" "wwmt_legacy_names"

if wwmt_legacy_names=="" do (
	
	wwmt_legacy_names = GetINISetting wallworm_globalIni "Materials" "wwmt_legacy_names"
	setINISetting wallworm_userIni "Materials" "wwmt_legacy_names" (wwmt_legacy_names as string)
	
)
/*
global wwmt_mat_textransform_vmts = GetINISetting wallworm_userIni "Materials" "wwmt_mat_textransform_vmts"

if wwmt_mat_textransform_vmts=="" do (
	
	wwmt_mat_textransform_vmts = GetINISetting wallworm_globalIni "Materials" "wwmt_mat_textransform_vmts"
	setINISetting wallworm_userIni "Materials" "wwmt_mat_textransform_vmts" (wwmt_mat_textransform_vmts as string)
	
)
	*/


	
global wwmt_exportNonRenderableMeshAsBone = GetINISetting wallworm_userIni "Settings" "wwmt_exportNonRenderableMeshAsBone"

if wwmt_exportNonRenderableMeshAsBone=="" do (
	
	wwmt_exportNonRenderableMeshAsBone = GetINISetting wallworm_globalIni "Settings" "wwmt_exportNonRenderableMeshAsBone"
	setINISetting wallworm_userIni "Settings" "wwmt_exportNonRenderableMeshAsBone" (wwmt_exportNonRenderableMeshAsBone as string)
	
	)
	
	
	
global wwmt_use_local_origin = GetINISetting wallworm_userIni "Settings" "wwmt_use_local_origin"

if wwmt_use_local_origin=="" do (
	
	wwmt_use_local_origin = GetINISetting wallworm_globalIni "Settings" "wwmt_use_local_origin"
	setINISetting wallworm_userIni "Settings" "wwmt_use_local_origin" (wwmt_use_local_origin as string)
)



global wwmt_rotateRefsystem = GetINISetting wallworm_userIni "Settings" "wwmt_rotateRefsystem"

if wwmt_rotateRefsystem=="" do (
	
	wwmt_rotateRefsystem = GetINISetting wallworm_globalIni "Settings" "wwmt_rotateRefsystem"
	setINISetting wallworm_userIni "Settings" "wwmt_rotateRefsystem" (wwmt_rotateRefsystem as string)
)
	
	
global wwmt_default_staticprop = GetINISetting wallworm_userIni "Settings" "wwmt_default_staticprop"

if wwmt_default_staticprop=="" do (
	
	wwmt_default_staticprop = GetINISetting wallworm_globalIni "Settings" "wwmt_default_staticprop"
	setINISetting wallworm_userIni "Settings" "wwmt_default_staticprop" (wwmt_default_staticprop as string)
	
	)
	
	
global wwmt_refLOD = GetINISetting wallworm_userIni "Settings" "wwmt_refLOD"

if wwmt_refLOD=="" do (
	
	wwmt_refLOD = GetINISetting wallworm_globalIni "Settings" "wwmt_refLOD"
	setINISetting wallworm_userIni "Settings" "wwmt_refLOD" (wwmt_refLOD as string)
	
	)
	
	
	
global wwmt_makeHullsNonRenderable = GetINISetting wallworm_userIni "Settings" "wwmt_makeHullsNonRenderable"

if wwmt_makeHullsNonRenderable=="" do (
	
	wwmt_makeHullsNonRenderable = GetINISetting wallworm_globalIni "Settings" "wwmt_makeHullsNonRenderable"
	setINISetting wallworm_userIni "Settings" "wwmt_makeHullsNonRenderable" (wwmt_makeHullsNonRenderable as string)
	
	)
	


	
	
	
global wwmt_overWriteQC = GetINISetting wallworm_userIni "Settings" "overWriteQC"

if wwmt_overWriteQC=="" do (
	
	wwmt_overWriteQC = GetINISetting wallworm_globalIni "Settings" "overWriteQC"
	setINISetting wallworm_userIni "Settings" "overWriteQC" (wwmt_overWriteQC as string)
	
	)
	
	
global wwmt_mappingChannel = GetINISetting wallworm_userIni "Settings" "wwmt_mappingChannel"
if wwmt_mappingChannel=="" do (
	
	wwmt_mappingChannel = GetINISetting wallworm_globalIni "Settings" "wwmt_mappingChannel"
	setINISetting wallworm_userIni "Settings" "wwmt_mappingChannel" (wwmt_mappingChannel as string)
	
)
wwmt_mappingChannel = wwmt_mappingChannel as integer

	/*
	global wwmt_VMTRotation = GetINISetting wallworm_userIni "Materials" "wwmt_VMTRotation"

if wwmt_VMTRotation=="" do (
	
	wwmt_VMTRotation = GetINISetting wallworm_globalIni "Materials" "wwmt_VMTRotation"
	setINISetting wallworm_userIni "Materials" "wwmt_VMTRotation" (wwmt_VMTRotation as string)
	
)
	
	*/
	
	
	
global wwmt_autoMaterialNewModel = GetINISetting wallworm_userIni "Materials" "wwmt_autoMaterialNewModel"
if wwmt_autoMaterialNewModel=="" do (
	
	wwmt_autoMaterialNewModel = GetINISetting wallworm_globalIni "Materials" "wwmt_autoMaterialNewModel"
	setINISetting wallworm_userIni "Materials" "wwmt_autoMaterialNewModel" (wwmt_autoMaterialNewModel as string)
	
	)
	
	
global wwmtAutoOpenFolder = GetINISetting wallworm_userIni "Settings" "wwmtAutoOpenFolder"

if wwmtAutoOpenFolder=="" do (
	
	wwmtAutoOpenFolder = GetINISetting wallworm_globalIni "Settings" "wwmtAutoOpenFolder"
	setINISetting wallworm_userIni "Settings" "wwmtAutoOpenFolder" (wwmtAutoOpenFolder as string)
	
	)
	
	
--copyTarget = GetINISetting wallworm_userIni "Settings" "copyTarget"
 global wwmt_copyTarget = "false"
if  wwmt_copyTarget=="" do (
	
	 wwmt_copyTarget = GetINISetting wallworm_globalIni "Settings" "copyTarget"
	setINISetting wallworm_userIni "Settings" "copyTarget" (wwmt_copyTarget as string)
	
	)

	
	
 global wwmt_createLayers = GetINISetting wallworm_userIni "Settings" "createLayers"

if  wwmt_createLayers=="" do (
	
	 wwmt_createLayers = GetINISetting wallworm_globalIni "Settings" "createLayers"
	setINISetting wallworm_userIni "Settings" "createLayers" (wwmt_createLayers as string)
	
	)
	
	

	
	
 global wwmt_lodLimit = GetINISetting wallworm_userIni "Settings" "lodLimit"

if  wwmt_lodLimit=="" OR wwmt_lodLimit=="0" do (
	
	 wwmt_lodLimit = GetINISetting wallworm_globalIni "Settings" "lodLimit"
	setINISetting wallworm_userIni "Settings" "lodLimit" (wwmt_lodLimit as string)
	
	)
	
global wwmt_lodLimit = wwmt_lodLimit as integer	

if wwmt_lodLimit < 1 then (
		wwmt_lodLimit = 1
)


global wwmt_hull_tool	 = GetINISetting wallworm_userIni "Settings" "wwmt_hull_tool"

if wwmt_hull_tool	=="" do (
	
	wwmt_hull_tool	 = GetINISetting wallworm_globalIni "Settings" "wwmt_hull_tool"
	setINISetting wallworm_userIni "Settings" "wwmt_hull_tool" (wwmt_hull_tool as string)
	
	)
	
global wwmt_hull_tool	 = wwmt_hull_tool as string	



	

global wwmtExporter	 = GetINISetting wallworm_userIni "Settings" "wwmtExporter"

if wwmtExporter	=="" do (
	
	wwmtExporter	 = GetINISetting wallworm_globalIni "Settings" "wwmtExporter	"
	setINISetting wallworm_userIni "Settings" "wwmtExporter" (wwmtExporter as string)
	
	)
	
global wwmtExporter	 = wwmtExporter	 as string	

	
	

	
	
global wwmt_hull_limit_handling = GetINISetting wallworm_userIni "Settings" "wwmt_hull_limit_handling"

if wwmt_hull_limit_handling=="" do (
	
	wwmt_hull_limit_handling = GetINISetting wallworm_globalIni "Settings" "wwmt_hull_limit_handling"
	setINISetting wallworm_userIni "Settings" "wwmt_hull_limit_handling" wwmt_hull_limit_handling
	
	)
	global wwmt_hull_limit_handling = wwmt_hull_limit_handling as integer
	
	

global wwmt_LODOptimize = GetINISetting wallworm_userIni "Settings" "wwmt_LODOptimize"

if wwmt_LODOptimize=="" do (
	
	wwmt_LODOptimize = GetINISetting wallworm_globalIni "Settings" "wwmt_LODOptimize"
	setINISetting wallworm_userIni "Settings" "wwmt_LODOptimize" wwmt_LODOptimize
	
	)
	global wwmt_LODOptimize = wwmt_LODOptimize as integer	
	
--horizontalRes=1680
--verticalRes=1050
--FOV=75	
	
global wwmt_horizontalRes = GetINISetting wallworm_userIni "Settings" "horizontalRes"

if wwmt_horizontalRes=="" do (
	
	wwmt_horizontalRes = GetINISetting wallworm_globalIni "Settings" "horizontalRes"
	setINISetting wallworm_userIni "Settings" "horizontalRes" wwmt_horizontalRes
	
	)
	
global wwmt_horizontalRes = wwmt_horizontalRes as integer	
	
	
	
global wwmt_verticalRes = GetINISetting wallworm_userIni "Settings" "verticalRes"

if wwmt_verticalRes=="" do (
	
	wwmt_verticalRes = GetINISetting wallworm_globalIni "Settings" "verticalRes"
	setINISetting wallworm_userIni "Settings" "verticalRes" wwmt_verticalRes
	
	)
	
global wwmt_verticalRes = wwmt_verticalRes as integer	
	
global wwmt_FOV = GetINISetting wallworm_userIni "Settings" "FOV"

if wwmt_FOV=="" do (
	
	wwmt_FOV = GetINISetting wallworm_globalIni "Settings" "FOV"
	setINISetting wallworm_userIni "Settings" "FOV" wwmt_FOV
	
	)
	
wwmt_FOV = wwmt_FOV as integer	
	
	

	
							
		currentModelPathtList = GetINISetting wallworm_userIni "Directories" "wwmt_saved_model_path_list"
		if currentModelPathtList == undefined then (
			
			currentModelPathtList = GetINISetting wallworm_globalIni "Directories" "wwmt_saved_model_path_list"
			SetINISetting wallworm_userIni "Directories" "wwmt_saved_model_path_list" currentModelPathtList
			
		)
	
	
			
		global wwmt_current_model_Paths = #()	
		
				currentModelPathtList = GetINISetting wallworm_userIni "Directories" "wwmt_saved_model_path_list"
				if currentModelPathtList == undefined OR currentModelPathtList == "" then (
					
					currentModelPathtList = GetINISetting wallworm_globalIni "Directories" "wwmt_saved_model_path_list"
					SetINISetting wallworm_globalIni "Directories" "wwmt_saved_model_path_list" currentModelPathtList
					
					)

				if currentModelPathtList != undefined AND currentModelPathtList != "" do (
					
					for word in (filterString currentModelPathtList ",") do( 
						append wwmt_current_model_Paths word
					)
					
					
				) 
				
				
				if wwmt_def_model_path != undefined AND wwmt_def_model_path != "" AND findItem wwmt_current_model_Paths wwmt_def_model_path == 0 do (
					
					append wwmt_current_model_Paths wwmt_def_model_path
					
					)
				


					
			
					
				global wwmt_current_material_Paths = #()	
					
				currentMaterialPathList = GetINISetting wallworm_userIni "Directories" "wwmt_saved_material_path_list"
				if currentMaterialPathList == undefined OR currentMaterialPathList == "" then (
					
					currentMaterialPathList = GetINISetting wallworm_globalIni "Directories" "wwmt_saved_material_path_list"
					SetINISetting wallworm_globalIni "Directories" "wwmt_saved_material_path_list" currentMaterialPathList
					
					)

if currentMaterialPathList != undefined AND currentMaterialPathList != "" do (
	for word in (filterString currentMaterialPathList ",") do( 
		append wwmt_current_material_Paths word
	)	
) 
				
			
if wwmt_def_material_path!= undefined AND wwmt_def_material_path!= "" AND findItem wwmt_current_material_Paths wwmt_def_material_path == 0 do (

	append wwmt_current_material_Paths wwmt_def_material_path
)	
	
	
	--Displacement Tool Config
	
global wwmt_raw_mats = GetINISetting wallworm_userIni "Directories" "wwmt_raw_mats"
					
if wwmt_raw_mats=="" do (
	
	wwmt_raw_mats = GetINISetting wallworm_globalIni "Directories" "wwmt_raw_mats"
	setINISetting wallworm_userIni "Directories" "wwmt_raw_mats" "$maps"
	
)

	
global wwmt_def_fgd = GetINISetting wallworm_userIni "Directories" "wwmt_def_fgd"

if wwmt_def_fgd == undefined do (
	
	wwmt_def_fgd = ""
	
)
	
global wwmt_surfaceprop_list = #("", "Metal_Box", "Plastic_Box", "Wood_Box", "Wood_Crate", "Wood_Furniture", "Wood_Panel", "Wood_Plank", "Wood_Solid", "Wood_lowdensity", "alienflesh", "antlion", "antlionsand", "armorflesh", "asphalt", "baserock", "bloodyflesh", "boulder", "brakingrubbertire", "brick", "canister", "cardboard", "carpet", "ceiling_tile", "chain", "chainlink", "combine_glass", "combine_metal", "computer", "concrete", "concrete_block", "crowbar", "default", "default_silent", "dirt", "flesh", "floating_metal_barrel", "floatingstandable", "foliage", "glass", "glassbottle", "grass", "gravel", "gravel", "grenade", "gunship", "ice", "item", "jeeptire", "ladder", "metal", "metal_barrel", "metal_bouncy", "metal_seafloorcar", "metalgrate", "metalpanel", "metalvehicle", "metalvent", "mud", "no_decal", "paintcan", "paper", "papercup", "plaster", "plastic", "plastic_barrel", "plastic_barrel_buoyant", "player", "player_control_clip", "popcan", "pottery", "quicksand", "rock", "roller", "rubber", "rubbertire", "sand", "slidingrubbertire", "slidingrubbertire_front", "slidingrubbertire_rear", "slime", "slipperymetal", "slipperyslime", "snow", "solidmetal", "strider", "tile", "wade", "water", "watermelon", "weapon", "wood", "zombieflesh")


global wallworm_text_editor = GetINISetting wallworm_userIni "Applications" "text_editor"

if wallworm_text_editor=="" do (
	
	wallworm_text_editor = GetINISetting wallworm_globalIni "Applications" "text_editor"
	setINISetting wallworm_userIni  "Applications" "text_editor" wallworm_text_editor
	
)

global wallworm_winrar = GetINISetting wallworm_userIni "Applications" "winrar"

if wallworm_winrar=="" do (
	
	wallworm_winrar = GetINISetting wallworm_globalIni "Applications" "winrar"
	setINISetting wallworm_userIni "Applications" "winrar" wallworm_winrar
	
)

global wallworm_skinops_getBoneNameByListID
/*This variable exists because Max 2014 changed the way getBoneName works*/
if wallworm_skinops_getBoneNameByListID == undefined then (
	wallworm_skinops_getBoneNameByListID= skinops.getBoneName
	if  (hasProperty skinops #getBoneNameByListID) do
		 wallworm_skinops_getBoneNameByListID = skinops.getBoneNameByListID
)

global wallworm_use_WW_VBSP = GetINISetting wallworm_userIni "Exporters" "ww_vbsp"
--ww_vbsp=false


global wallworm_mapsize 
if wallworm_mapsize == undefined OR classof wallworm_mapsize != Point2 then (
	wallworm_mapsize =  [-16384,16384]
)