include "$scripts\\WallWorm.com\\common\\config.ms"
include "$scripts\\WallWorm.com\\common\\ww_common_funcs.ms"
include "$scripts\\WallWorm.com\\common\\matfuncs1.ms"
include "$scripts/WallWorm.com/common/version_funcs.ms"
include "$scripts/WallWorm.com/common/matgenfuncs.ms"


global wallworm_vmt_import_library

tempLibPath = "$matlibs/WallWormVMTImportMaterials.mat"

if wallworm_vmt_import_library == undefined OR classOf wallworm_vmt_import_library != MaterialLibrary then (
	

	
		if doesFileExist tempLibPath == false then (
			
			wallworm_vmt_import_library = MaterialLibrary()
			

			
			

				saveTempMaterialLibrary wallworm_vmt_import_library tempLibPath

		) else (
			
			wallworm_vmt_import_library = loadTempMaterialLibrary tempLibPath
			
		)
	
	
	wallworm_vmt_import_library = loadTempMaterialLibrary tempLibPath
	
)

global wwmt_raw_mats

if wwmt_raw_mats != undefined then (

	vmt = getOpenFileName  caption:"Find a Source Material File (VMT)" types:"Valve Material (*.vmt)|*.vmt" historyCategory:"Wall Worm Materials" filename:wwmt_raw_mats
) else (
	vmt = getOpenFileName  caption:"Find a Source Material File (VMT)" types:"Valve Material (*.vmt)|*.vmt" historyCategory:"Wall Worm Materials"
)


	


if vmt != undefined then (
	
	mat = wallworm_generateMaterialFromVMT vmt
	
	if mat != undefined then (
		append wallworm_vmt_import_library mat
		saveTempMaterialLibrary wallworm_vmt_import_library tempLibPath
		res = false
		if selection.count > 0 then (
			
			res = queryBox  "Do you want to apply this material to the selection?" title:"VMT Import Options"
			
			if res == true then (
					
				for obj in selection where isProperty obj "material" do (
					
						obj.material = mat
				)
				
			)
			
		) else ()
		
		if res == false then (
		


				messagebox ("The Material [ "+mat.name+" ] is now in the WallWormVMTImportMaterials.mat in your materiallibraries folder.")
			
		)
		
		
	)
	
)