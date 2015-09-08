/*
Source Game Engine Material Library Generator
Copyright (c) 2011-2014 by Shawn Olson
www.wallworm.com
*/
global wwmt_material_library_version = 1.51
global wwmt_current_material_root
global wallwormMatGen
global wallwormMaxVersions

fileIn "$scripts/WallWorm.com/common/config.ms"			
include "$scripts\\WallWorm.com\\common\\ww_common_funcs.ms"
include "$scripts\\WallWorm.com\\common\\matfuncs1.ms"
include "$scripts/WallWorm.com/common/version_funcs.ms"
include "$scripts/WallWorm.com/common/matgenfuncs.ms"

try(destroyDialog wallwormMatGen)catch(
	
	   --there was not any open
	)

	
function wallworm_can_read_VTF = (
	
	--read data from VMT file f
	global wallwormMaxVersions
	
	if wallwormMaxVersions == undefined then (
		
		wallwormMaxVersions = wallworm_getMaxVersion()
	)

				
	local version = wallwormMaxVersions[1] as integer
	
	if version < 15 then (
		return true
	)
	false
)

function wallworm_texname_out n = (
	wallworm_remove_last_slash (wallworm_safe_path (getFileNamePath n))
)	

function wallworm_getFoldersRecursive root folderFilter recurse:false= (
	local dir_array = #()
	if folderFilter != undefined then (
		
		
		local dirs = filterString folderFilter ","
		
		for dir in dirs do (
			
			join dir_array ( GetDirectories (root+"/"+dir) )
			if recurse == true then (

			for d in dir_array do (
				
				--if matchPattern d pattern:folderFilter do (
				local dirpath = d+"/*"
					local newDirs = GetDirectories (dirpath)
						join dir_array newDirs
						

						
						join dir_array (wallworm_getFoldersRecursive dirpath "*" recurse:true)
					)	
						
				--)
			)
				
			
			
		)
		
		
	)
dir_array
)


function wwmt_getFilesRecursive root folderFilter fileFilter recurse:false= (


	local dir_array = wallworm_getFoldersRecursive root folderFilter recurse:recurse

	dir_array = makeUniqueArray dir_array

		my_files = #()
		
		local files = filterString fileFilter ","

		for file in files do (
			for f in dir_array do (		

				--print ("LOOKFOR: "+(f+file+".vmt"))
					join my_files (getFiles (f+file+".vmt"))

			)
		)
		
		my_files = makeUniqueArray my_files
		
		return my_files 

)
	
	
function wwmt_ceate_material_library p project br bl mdl folderFilter fileFilter recurse = (
	--find all VMT files
	--find all folders and recursively run this func

	local oneLibrary = true
	 if (wallwormMatGen.chk_seperateLibraries.checked == true) then(
		oneLibrary = false
		local BrushMaterials = MaterialLibrary()
		local ModelMaterials = MaterialLibrary()
		local BlendMaterials = MaterialLibrary()
	 ) else (	 
		local AllMaterials = MaterialLibrary()
	)
	 
	global vmts
	vmts = wwmt_getFilesRecursive p folderFilter fileFilter recurse:recurse
	
	--try(

	local total = vmts.count
	local count = 0
	 
	for vmt in vmts do (
		
	
		mat = wallworm_generateMaterialFromVMT vmt  brushColor:wallwormMatGen.cp_brush.color  modelColor:wallwormMatGen.cp_model.color dispColor:wallwormMatGen.cp_blend.color  dispColor2:wallwormMatGen.cp_brush.color  rootPath:wwmt_raw_mats
		
		
		local useMat = true
		
		if  bl == false AND (classof mat == DirectX_9_Shader OR mat.valveShader == "WorldVertexTransition")  then  (
			useMat = false	 
		) else (
			
			if  mdl == false AND isProperty mat "forModel" AND   mat.forModel == true then (		
				useMat = false	 
			) else if (br==false  AND  (isProperty mat "valveShader" == true AND mat.valveShader == "LightmappedGeneric")) then  (
				useMat = false	 
			) else (
				
					if br == false AND mdl == false then (
						if  (classof mat != DirectX_9_Shader) then (
								useMat = false
						)
						
					)
			)
		)
				
		if useMat == true  then (
		 if (oneLibrary ==true) then ( 
			 
			 
			 
			 
			 
			 append AllMaterials mat
			 
			 
			 ) else (
			 
					if classof mat == DirectX_9_Shader OR mat.valveShader == "WorldVertexTransition" then  (
						


								append BlendMaterials mat

						
						
						
						--displayMat.k_d = wallwormMatGen.cp_blend.color
							) else if mat.forModel == true then (
							
							
								append ModelMaterials mat
							) else (
						
								append BrushMaterials mat
							)

			 
			 
			 )
		
		


			count+=1
			wallwormMatGen.pb1.value = 100.*count/total
			gc()
			 
			 
		 )
			 
		)
	
	--) catch(
		
		--print ("There is an error "+getCurrentException())
		--)
		local matContinue = false
		if (oneLibrary ==true ) then (
			
			if( AllMaterials.count > 0 ) do (
				matContinue = true
				)
				
			)else(
				
			if BrushMaterials.count >0 OR ModelMaterials.count > 0  OR BlendMaterials.count > 0 do (
				matContinue = true
				)
			
			)
		
		
		if matContinue == false then (
			
			messagebox "No VMTs found in the specified directories... no Material Library generated."
			
			
			) else (
			message = "Library Created:\n\n"
			
			
			     if (oneLibrary ==true) then (
					 
					 

					 
								saveTempMaterialLibrary AllMaterials ("$matlibs/"+project+".mat")
								message += ("All Materials created in \""+project+".mat\" in the Project Material Libraries folder.\n\n")
					 
							) else (
			
			
				if br == true AND BrushMaterials.count > 0 do (
				
				saveTempMaterialLibrary BrushMaterials ("$matlibs/"+project+"_brushes.mat")
				message += ("Brush Materials created in \""+project+"_brushes.mat\" in the Project Material Libraries folder.\n\n")
				
				)
			
				if bl ==true AND BlendMaterials.count > 0 do (
					saveTempMaterialLibrary BlendMaterials ("$matlibs/"+project+"_blend.mat")
					
					message += ("Blend Materials created in \""+project+"_blend.mat\" in the Project Material Libraries folder.\n\n")
				)
				
				if mdl==true AND  ModelMaterials.count > 0 do (
					saveTempMaterialLibrary ModelMaterials ("$matlibs/"+project+"_models.mat")
					
					message += ("Model Materials created in \""+project+"_models.mat\" in the Project Material Libraries folder.\n\n")
				)
				
				) 
				
				messagebox message
			)

		
	)

rollout wallwormMatGen "Material Generator" width:208 height:495
(
	checkbox chk_brushLibrary "Brush Library" pos:[23,27] width:91 height:15 toolTip:"Create a brush material library."
	checkbox chk_blendLibrary "Blend Library" pos:[23,45] width:94 height:14 toolTip:"Create a blend material library."
	checkbox chk_modelLibrary "Model Library" pos:[23,63] width:89 height:14 toolTip:"Create a model material library."
	checkbox chk_seperateLibraries "Separate Libraries by Type" pos:[18,93] width:172 height:14
	edittext edt_libraryName "" pos:[13,135] width:177 height:28 toolTip:"Enter a name for this library project. This will be the prefix for each library created."
	edittext edtFolders "" text:"*" pos:[13,186] width:177 height:27 toolTip:"Enter a string to limit folders to those that match the given pattern. The asterisk (*) is a wildcard."
	edittext edtFileFilters "" text:"*" pos:[13,239] width:177 height:30 toolTip:"Enter a string to limit files to those that match the given pattern. The asterisk (*) is a wildcard."
	label lbl1 "Export Project Name" pos:[19,115] width:106 height:16
	colorPicker cp_brush "" pos:[124,29] width:46 height:13 color:(color 155 155 155) title:"Default Brush Color" toolTip:"Choose a default diffuse color for brush materials."
	colorPicker cp_blend "" pos:[124,47] width:46 height:13 color:(color 0 155 0) title:"Default Blend Color" toolTip:"Choose a default diffuse color for blend materials."
	colorPicker cp_model "" pos:[124,65] width:46 height:13 color:(color 155 155 0) title:"Default Model Color" toolTip:"Choose a default diffuse color for model materials."
	button btn_createLibraries "Material Root" pos:[20,277] width:173 height:35 toolTip:"Click here to create the material libraries. This can take several minutes if there are a lot of folders and/or VMTs."

	progressBar pb1 "ProgressBar" pos:[19,381] width:170 height:23


	label lbl2 "Copyright (c) 2014 by Shawn Olson" pos:[18,441] width:172 height:19
	GroupBox grp1 "Types of Libraries" pos:[15,11] width:176 height:76
	
	label lbl3 "Folder Filter" pos:[18,168] width:62 height:16
	label lbl5 "File Filters" pos:[20,221] width:53 height:16
	label lblMLV "Material Library Generator V " pos:[20,412] width:170 height:22
	button btnGenerate "Create" pos:[19,342] width:172 height:23
	
	HyperLink wwlink "Wall Worm" pos:[19,460] width:86 height:15 address:"http://www.wallworm.com" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	HyperLink mathelplink "Help" pos:[110,460] width:86 height:15 address:"http://dev.wallworm.com/topic/35/material_library_generator.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	checkbox chk_recurse "Recursive" pos:[21,322] width:72 height:14

	
	on btn_createLibraries pressed do
	(
	
						
						
	
	
			global wwmt_raw_mats
				--try(
					newPath = getSavePath caption:"Find Material Root" initialDir:wwmt_raw_mats
					--historyCategory:"WWMTPaths" initialDir:newp 
					--) catch (
					--newPath = getSavePath caption:"Find Material Root" 
					--historyCategory:"WWMTPaths"
					--)
						
				
					
				if (newPath != undefined) do (
					
					if newPath != wwmt_raw_mats do (
						
						
						wwmt_raw_mats = newPath
						setINISetting wallworm_userIni "Directories" "wwmt_raw_mats" wwmt_raw_mats
						
					)
					
					wwmt_current_material_root = newPath	
					
				) 
			
		
		
		)
	on btnGenerate pressed do
	(
		
		
							errors = #()
					
					if edt_libraryName.text == "" do (
						
						append errors "You must give this export a project name."
						
						)
					if (chk_brushLibrary.checked == false AND chk_blendLibrary.checked == false AND chk_modelLibrary.checked == false) do (
						append errors "You must choose the types of material libraries to create."
						
						)	
						
						
						
						
					if (edtFolders.text == "") do (
						append errors "The folder filter cannot be empty. If you want to search all folders in the material root, type an asterisk (*). Otherwise, wrap a folder name in asterisks."
						
						) 
						
					if (edtFileFilters.text == "") do (
						append errors "The file filter cannot be empty. If you want to search all VMT files, type an asterisk (*). Otherwise, wrap a file name in asterisks to use only that VMTs that have this filter in the file name."
						
						) 	
						
						
						
						
	
						
					global wwmt_raw_mats
					if wwmt_raw_mats == undefined OR doesFileExist wwmt_raw_mats == false do ( 
						append errors  "Please choose a root material folder from which to start the scan."
					)
						
					if errors.count == 0 then (
						
					) else(
						
						message = "There are problems:\n\n"
						
						for err in errors do (
							
							append message ("* "+err + "\n\n")
							
							)
						messagebox message
						return false
						)
		
						
					
		
	
				
				wwmt_ceate_material_library wwmt_raw_mats  edt_libraryName.text chk_brushLibrary.checked chk_blendLibrary.checked chk_modelLibrary.checked edtFolders.text edtFileFilters.text chk_recurse.checked
	
					
						
	
	
	)
)





	createDialog wallwormMatGen

	wallwormMatGen.lblMLV.text +=  (wwmt_material_library_version as string)
