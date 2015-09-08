/*Generate a Map of models from the modelsrc folders*/

fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
fileIn "$scripts/WallWorm.com/importers/Mario_Kart_SMD_Importer.ms"

struct wallworm_mdlQCmap (
	qc=undefined,
	mdl=undefined,
	function getMyMdl = (
		mdl = wallworm_parse_qc qc  buildMesh:false	
		if mdl != undefined then (
			if matchPattern mdl pattern:"*/*" then (
				mdl = "models/"+mdl
			) else (
				mdl = "models\\"+mdl
			)
			mdl = toLower (wallworm_safe_path mdl)
		)
	)
)

global wallworm_complete_model_list = #()

function wallworm_findQCByModelName m = (
		for mdls in wallworm_complete_model_list WHERE mdls.mdl != undefined AND (toLower (mdls.mdl)) == (toLower m) collect mdls
)

function wallworm_findQCByModelNameMatch m = (
		for mdls in wallworm_complete_model_list WHERE mdls.mdl != undefined AND (matchpattern mdls.mdl pattern:("*"+m+"*"))==true collect mdls
)

function wallworm_findQCByMissingModel = (
		for mdls in wallworm_complete_model_list WHERE mdls.mdl == undefined collect mdls
)

function wwmt_getQCFilesRecursive root folderFilter fileFilter= (

	
	local dir_array = #()
	
	local dirs = filterString folderFilter ","
	
	for dir in dirs do (
		
		join dir_array ( GetDirectories (root+"/"+dir) )

		for d in dir_array do (
			
			--if matchPattern d pattern:folderFilter do (
			
				join dir_array (GetDirectories (d+"/*"))
			--)
		)
		 	
		
		
	)
	
	

		
		

		my_files = #()
		
		local files = filterString fileFilter ","

		for file in files do (
		
			for f in dir_array do (

					join my_files (getFiles (f+file+".qc"))

			)
		)
		return my_files 

)



