fileIn "$scripts/WallWorm.com/custom_attributes/material.ms"



/*
Function returns true if MultiMaterials m1 and m2 have the same number of sub-materials and those submaterials are the same. 

Set byName to true to compare by name instead of actual material.

*/
function wallworm_compareMultiMaterialsMats m1 m2:undefined byName:false nameList:undefined= (
		local same = true
		local compareCount = 0
		if m2 != undefined then (
			compareCount= m2.numsubs
			compareList = m2.materialList
		) else if nameList != undefined then (
			
			 compareCount= nameList.count
			 compareList = nameList
		)
		
		if m1.numsubs == compareCount then (
			
			for i = 1 to m1.numsubs WHERE m1.materialList[i] != undefined AND compareList[i] != undefined  while same == true do  (

				if byName == true then (
					
					if nameList == undefined then (
					
						if toLower m1.materialList[i].name != toLower m2.materialList[i].name then (
							same = false
						)
					) else (
					
						if toLower m1.materialList[i].name != toLower nameList[i] then (
							same = false
						)
						
					)
				) else (
					if m1.materialList[i] != m2.materialList[i] then (
						same = false
					)
					
				)

			)
			
			
			
		) else (
			same = false
		)
	
		same
)




/*
Function returns true if all of the material names in nameList are found in the Material m1. 
*/
function wallworm_doesMatHaveMatNames m1 nameList = (
		local same = true
		local subnames = for m in m1.materialList collect m.name
		for i = 1 to nameList.count WHERE nameList[i] != undefined while same == true do  (
			/*print nameList
			print subnames*/
			if findItem subnames nameList[i] == 0 then (
					same = false
			)		
		)
		same
)




/*This function will give the same material to all objects in the same with matching Multi-Materials*/
function wallworm_InstanceSameMultiMat mat byName:false= (
		global wallworm_compareMultiMaterialsMats
		(for o in objects where o.mat != undefined AND o.mat != mat AND classOf o.mat == MultiMaterial and o.mat.numsubs==mat.numsubs AND (wallworm_compareMultiMaterialsMats mat m2:o.mat byName:byName) == true collect o).mat = mat
)

/*This function will return an array of objects that have a MultiMaterial if it finds any objects with a submaterial list that matches the names in submatnames*/
function wallworm_FindMultiMatBySubNames submatnames = (
		global wallworm_compareMultiMaterialsMats
	(for o in objects where o.mat != undefined AND classOf o.mat == MultiMaterial and o.mat.numsubs==submatnames.count AND (wallworm_compareMultiMaterialsMats o.mat  byName:true nameList:submatnames) == true collect o)
)

/*This function will return an array of objects that have a MultiMaterial if it finds any with a submaterial list that contains matches for all of the names in submatnames, regardless of order.*/
function wallworm_FindMultiMatBySubNames2 submatnames = (
	global wallworm_doesMatHaveMatNames
	(for o in objects where o.mat != undefined AND classOf o.mat == MultiMaterial and o.mat.numsubs>=submatnames.count AND (wallworm_doesMatHaveMatNames o.mat submatnames) == true collect o)
)



	function wallworm_get_ww_displibrary = (
		global wallwormMaterialDisplacementLibrary 
		
		
		if wallwormMaterialDisplacementLibrary != undefined AND classof wallwormMaterialDisplacementLibrary == MaterialLibrary then (
			
			return wallwormMaterialDisplacementLibrary
		)
		
		if doesFileExist "$matlibs/WallWormDisplacementMaterials.mat" == false then (
			
			wallwormMaterialDisplacementLibrary = MaterialLibrary()
			
			global ww_wwdt_defaultMat
			
			
			if ww_wwdt_defaultMat != undefined then (
				append wallwormMaterialDisplacementLibrary ww_wwdt_defaultMat
				saveTempMaterialLibrary wallwormMaterialDisplacementLibrary "$matlibs/WallWormDisplacementMaterials.mat"
			)
		) else (
			
			wallwormMaterialDisplacementLibrary = loadTempMaterialLibrary "$matlibs/WallWormDisplacementMaterials.mat"
			
		)
		
		return wallwormMaterialDisplacementLibrary
		
	)
	
	
	function wallworm_update_ww_displibrary mat = (
		
		if superclassof mat == material then (
			wallwormMaterialDisplacementLibrary = wallworm_get_ww_displibrary()
			
			index = findItem wallwormMaterialDisplacementLibrary mat 
			
			
			
			for i=wallwormMaterialDisplacementLibrary.count to 1 by -1 do (
			
				if wallwormMaterialDisplacementLibrary[i].name == mat.name then (

					deleteItem wallwormMaterialDisplacementLibrary i
				)
				
			)
			
			appendIfUnique wallwormMaterialDisplacementLibrary mat
			saveTempMaterialLibrary wallwormMaterialDisplacementLibrary "$matlibs/WallWormDisplacementMaterials.mat"
				

		)
		
	)


	
	
	
	
function wallworm_canCompileTextures model:false= (
	global wwmt_gameInfoDir
	global wwmt_binDir
	global wwmt_exportMats
	global wwmt_gameInfoDir
	local errors = #()

						if(wwmt_binDir == undefined OR wwmt_binDir == "" OR doesFileExist (wwmt_binDir) ==false) do (
							append errors  "The Bin Directory in the Settings floater must be set to a directory where VTEX.exe is located."
						)
							


						if ( wwmt_exportMats == undefined OR wwmt_exportMats=="" ) then (
							append errors "The material export root has not been set."
						) else (
							if doesFileExist (wwmt_exportMats) ==false then (
								if (makeDir wwmt_exportMats all:true) == false then (
									
									append errors "The material export root does not exist and Wall Worm could not create it."
									)
								
							)
							
						)
						
						studiopath = wwmt_binDir+"\\"+"vtex.exe"
						if doesFileExist (studiopath) ==false do (
							append errors "The Bin Directory does not point to a path where vtex.exe is located."
						)
						
						if(wwmt_gameInfoDir == undefined OR wwmt_gameInfoDir == "" OR doesFileExist (wwmt_gameInfoDir) ==false) do (
							append errors  "The texture exporter now requires you to set the Game Info Directory. Set this in the Wall Worm Settings."
						)
						
						-- OR wwmt_oldModelVTFPath != "true"
						if model == true AND wwmtExporter != "3" AND (wwmt_legacy_names != "true")  then (
							
							append errors  "When you are using the Wunderboy or Cannonfodder SMD Exporters with WW, you must turn on Legacy Tex Names in the settings or your models will not export properly. Please turn that on or switch to the Wall Worm SMD Exporter."
							
						)
						
						
			if errors.count > 0 then (
				return errors
				
			)	else (
				
				return true
				
			)
						
	
	)
	
	function wallworm_isValidBitmap ext vtfCheck:false= (
		local allowedBitmaps = #(".tga",".ifl")
		
		if wwmt_allow_psd == "true" OR wwmt_allow_psd == true then (
			append allowedBitmaps ".psd"
			) else (
			
			
			)
		
		if vtfCheck==true AND VTFImporter != undefined then (
			
			append allowedBitmaps ".vtf"
		)
			
			
		if (findItem allowedBitmaps  (toLower ext)) > 0 then (
			return true
		)
		false
	)
			
	function wallworm_parseIFL f = (
		if f != undefined then (
			local ext = toLower ((getFilenameType f))
			
			if (wallworm_isValidBitmap ext) do (	
					
				if (ext != ".ifl") then (
					
					return #(f)
					
					) else (
						out = #()

					thePath = getFileNamePath f
					local theFile = openFile f mode:"r"
						
						
					if theFile != undefined and doesFileExist f then (


					theCurrentObject = undefined

						while ( not eof theFile ) do (
							


							local theLine = readLine theFile
							append out (thePath+"\\"+theLine)
							
						)
						
						
					)
					close theFile
					return out
				)
			)
		)
		return #()
	)
	

			function wallworm_outputTexName p = (

				try (
				f = getFileNameFile p
				if getFileNameType p == ".ifl" then (
					f = f+"0"
					
				)

				
				return f
				) catch (
					return ""
				)
			)
			
			
		function wallworm_mat_name_limit_check filename = (
			return true
		/*Checks to see if the file name is not too long for a material*/
		if (filename as string).count > 22 then (
			return false
			) else (
			 return true
			)
		
		)
		
		
/*Update the definitions for materials.*/
function wallworm_update_materials_ca mat addca:true = (
	if mat == undefined then return false
	global wallworm_material_CA
	local c = custAttributes.count mat -- [Basematect:<bool>]
	local out = false

	if c > 0 then (
		for i = c to 1 by -1 do (
			def = custAttributes.getDef mat  i 
			if  def.name  == "Wallworm Material" then (
					local ca = wallworm_material_CA

				

						custAttributes.redefine def (custAttributes.getDefSource wallworm_material_CA)
					
						if def.name == wallworm_material_CA.name  then (
							out = true
						) else ()

			)
			
		)
	)
	if out == false and addca == true then (
		custAttributes.add mat wallworm_material_CA
	)
	out
)

function wallworm_give_mat_ww mat = (
	
	case (classof mat) of (
		
		MultiMaterial:(
			
			for m in mat.materialList where m != undefined do (
				wallworm_give_mat_ww m 
				
			)
		)
		Blend:(
			wallworm_update_materials_ca mat addca:true
			
			
			if mat.map1 != undefined then (
				wallworm_give_mat_ww mat.map1
			)
			if mat.map2 != undefined then (
				wallworm_give_mat_ww mat.map2 
			)
		)
		
		Directx_9_shader: if mat.renderMaterial != undefined then (
			wallworm_update_materials_ca mat.renderMaterial addca:true
		)
		Standard: (
			wallworm_update_materials_ca mat addca:true
			if isProperty mat "crackmaterial" == true AND mat.crackmaterial != undefined then (
				wallworm_update_materials_ca mat.crackmaterial addca:true
			)
			
			)
		default:(
			--do nothing
			)
		)
	
	
	)


function wallworm_assign_wwmats_to_objs objs = (
	
	for obj in objs WHERE obj.mat != undefined do (
		
		wallworm_give_mat_ww obj.mat
		
		
	)
	
	
)

function wallworm_update_materials_cas = (

		for mat in sceneMaterials  do (
			wallworm_give_mat_ww mat
		)

)

		
function wallworm_getMaterial m matId:undefined forModel:false collectingMat:false= (
		try (
		if m == undefined then return undefined
		case (classOf m) of (
			
			
			 MultiMaterial : (
				 
				 


				if matId > m.numsubs then (
					matId = (mod  matId m.numsubs) as integer
					if matId == 0 then (
						
						matID = m.numsubs
					)
					
				)
				
				if matId == 0 OR  m.materialList[matId] == undefined then (
					matId = 1

				)


				 
				 
				if matId!= undefined AND m.materialList[matId] != undefined then (
					return wallworm_getMaterial  m.materialList[matId] matId:matId  forModel:forModel  collectingMat:collectingMat
				) else (
					
					if m.materialList[1] != undefined then (
						return wallworm_getMaterial  m.materialList[1] matId:matId  forModel:forModel collectingMat:collectingMat
					) else (
						return undefined
					)
					

				)
			)

			DirectX_9_Shader : (
				if collectingMat == true then (
					return m
				) else (
					
				if m.renderMaterial != undefined AND (findString m.name "/") == undefined AND (findString m.renderMaterial.name "/") != undefined then (
					

					return wallworm_getMaterial m.renderMaterial matId:matId forModel:forModel collectingMat:collectingMat
					
					) else (
						return undefined
					)
					
				)
				

				)
			
			Shell_Material : (
				if m.bakedMaterial != undefined then (
					return wallworm_getMaterial m.bakedMaterial matId:matId forModel:forModel collectingMat:collectingMat
					) else (
						return undefined
					)
			)
				
			
			Standard : (
				return m
			)
			
			Blend : (
				if collectingMat == true then (
					return m
				)
			)
			
			default: (
				
				return undefined				

			)
			
			)
			
		) catch (
				print ("ERROR in getting material: "+getCurrentException())
				return undefined
			)
	)
	
		
		
		

	function wallworm_getMaterialName m matId:undefined forModel:false= (
		try (
		if m == undefined then return "unknown"
		case (classOf m) of (
			
			
			 MultiMaterial : (
				 
				if matId > m.numsubs then (
					matId = (mod  matId m.numsubs) as integer
					if matId == 0 then (
						
						matID = m.numsubs
					)
				)
				
				if  matId == 0 OR m.materialList[matId] == undefined then (
					matId = 1

				)

				 
				if matId!= undefined AND m.materialList[matId] != undefined then (
					return wallworm_getMaterialName  m.materialList[matId] matId:matId  forModel:forModel
				) else (
					
					if m.materialList[1] != undefined then (
						return wallworm_getMaterialName  m.materialList[1] matId:matId  forModel:forModel
					) else (
						return (wallworm_remove_last_slash m.name)
					)
					

				)
			)

			DirectX_9_Shader : (
				if m.renderMaterial != undefined AND (findString m.name "/") == undefined AND (findString m.renderMaterial.name "/") != undefined then (
					

					return wallworm_getMaterialName m.renderMaterial matId:matId forModel:forModel
					
					) else (
						return (wallworm_remove_last_slash m.name)
					)
				)
			
			Shell_Material : (
				if m.bakedMaterial != undefined then (
					return wallworm_getMaterialName m.bakedMaterial matId:matId forModel:forModel
					) else (
						return (wallworm_remove_last_slash m.name)
					)
			)
				
			
			Standard : (
				
				if forModel == false then (
					if m.diffuseMap != undefined and classOf m.diffuseMap == BitmapTexture and m.diffuseMap.filename != undefined and m.diffuseMap.filename != "" AND (substring m.name m.name.count 1) == "/" then (
						
						return (m.name + (getFilenameFile m.diffuseMap.filename))
					
					) else (
						
						return (wallworm_remove_last_slash m.name)
					)

				) else (
					
					if (wwmt_legacy_names == "true" OR wwmt_legacy_names == true) AND m.diffuseMap != undefined and classOf m.diffuseMap == BitmapTexture and m.diffuseMap.filename != undefined and m.diffuseMap.filename != ""  then (
					
						return ((getFilenameFile m.diffuseMap.filename))
					
					) else (
						
						return (wallworm_makeStringSafe  (pathConfig.stripPathToLeaf (wallworm_remove_last_slash m.name)))

						--return (wallworm_remove_last_slash m.name)
					)
					
					
				)
				

				
				)
			
			default: (
				
											
				if superClassOf m == Material then (
					
					return (wallworm_remove_last_slash m.name)
				) else (
					
					if classOf m == string then (
						return m
						) else (
							return ""
						)
					
					)
			)
			
			)
			
		) catch (
				print ("ERROR in getting name of material: "+getCurrentException())
				return ""
			)
	)
	
	
	function wallworm_getMapChannel m matId:undefined forModel:false= (
		try (
		if m == undefined then return "unknown"
		case (classOf m) of (
			
			
			 MultiMaterial : (
				 
				if matId > m.numsubs then (
					matId = (mod  m m.numsubs) as integer

					
				)
				
				if matId == 0 OR  m.materialList[matId] == undefined then (
					matId = 1

				)

				 
				 
				if matId!= undefined AND m.materialList[matId] != undefined then (
					return wallworm_getMapChannel  m.materialList[matId] matId:matId  forModel:forModel
				) else (
					
					if m.materialList[1] != undefined then (
						return wallworm_getMapChannel  m.materialList[1] matId:matId  forModel:forModel
					) else (
						return undefined
					)
				)
			)

			DirectX_9_Shader : (
				if m.renderMaterial != undefined AND (findString m.name "/") == undefined AND (findString m.renderMaterial.name "/") != undefined then (
					

					return wallworm_getMapChannel m.renderMaterial matId:matId forModel:forModel
					
					) else (
						return undefined
					)
				)
			
			Shell_Material : (
				if m.bakedMaterial != undefined then (
					return wallworm_getMapChannel m.bakedMaterial matId:matId forModel:forModel
					) else (
						return undefined
					)
			)
				
			
			Standard : (
				
					if m.diffuseMap != undefined and classOf m.diffuseMap == BitmapTexture and m.diffuseMap.filename != undefined and m.diffuseMap.filename != ""  then (
						
						return m.diffuseMap.coordinates.mapChannel 
					
					) else (
						
						return undefined
					)


				

				
				)
			
			default: (
				
											
				return undefined
			)
			
			)
			
		) catch (
				print ("ERROR in getting Bitmap channel of material: "+getCurrentException())
				return undefined
			)
		undefined
	)
	
	
	function wallworm_appendBitmaps &mat &materials valveShader coords:false decal:false  getNameFromPath:true forModel:false materialPath:undefined= (
	
		
		
	
	
	if mat != undefined AND materials!=undefined do (
		fileIn "$scripts/WallWorm.com/common/ww_struct_mat.ms"
		global ww_vmt
		inList = false
			for m in materials while inList == false do (	
		--for m in materials do (
			try (
				if m.mat == mat  do (inList=true)
			) catch()
			)
		
		if(inList ==false) do(
		if (classOf mat == Standardmaterial ) then (
				
				vmt = ww_vmt()
				vmt.mat = mat
				vmt.decal = decal
				if valveShader!= undefined AND valveShader != "" do (
					vmt.valveShader =  valveShader
				)		
				
				vmt.getNameFromPath = getNameFromPath
				vmt.forModel = forModel
				vmt.setMaterialPath materialPath
			
				 
				
				
				if mat.diffuseMap != undefined AND classOf mat.diffuseMap == BitmapTexture AND mat.diffuseMap.filename != undefined do (

						

						--parsedFilename = filterString (filenameFromPath mat.diffuseMap.filename) "."
						
						
						--if toLower (parsedFilename[parsedFilename.count] ) == "tga" do (
							if ( vmt.isValidBitmap  (getFilenameType mat.diffuseMap.filename) == true) do (
							
							
							
							--appendIfUnique bitmaps mat.diffuseMap.filename

							
							vmt.diff = mat.diffuseMap.filename
								
/*
							if coords == true AND (forModel == true)  then (
								
								
								vmt.basetexturetransform = ("center 0 0 scale "+(mat.diffuseMap.coords.U_Tiling as string)+" "+(mat.diffuseMap.coords.V_Tiling as string)+" rotate "+((mat.diffuseMap.coords.W_Angle + 180) as string)+" translate "+(mat.diffuseMap.coords.V_Offset as string)+" "+(mat.diffuseMap.coords.U_Offset as string))
								
								
							)	
*/
								

						)

					)
							
							
				--add specular level map as phong exponent texture							
				if mat.specularMap  != undefined AND mat.shaderType == 6  do (
					if classOf mat.specularMap  == Bitmaptexture do (
						if mat.specularMap.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if ( vmt.isValidBitmap  (getFilenameType mat.specularMap.filename) == true) do (

								vmt.spec = mat.specularMap.filename
								
								
							
							)
						)
					)
				)
						

				if mat.specularLevelMap  != undefined do (
					if classOf mat.specularLevelMap  == Bitmaptexture do (
						if mat.specularLevelMap.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if ( vmt.isValidBitmap  (getFilenameType mat.specularLevelMap.filename) == true) do (

								vmt.specLevelMap = mat.specularLevelMap.filename
/*
								if coords == true AND (forModel == true)  then (
									
									
									vmt.envmapmasktransform = ("center 0 0 scale "+(mat.specularLevelMap.coords.U_Tiling as string)+" "+(mat.specularLevelMap.coords.V_Tiling as string)+" rotate "+((mat.specularLevelMap.coords.W_Angle + 180) as string)+" translate "+(mat.specularLevelMap.coords.V_Offset as string)+" "+(mat.specularLevelMap.coords.U_Offset as string))
									
									
								)
								*/

							)
						)
					)
				)	


				
				if mat.reflectionMap  != undefined do (
					if classOf mat.reflectionMap  == Bitmaptexture then (
						if mat.reflectionMap.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if ( vmt.isValidBitmap  (getFilenameType mat.reflectionMap.filename) == true) do (

								vmt.reflectionMap = mat.reflectionMap
/*
								if coords == true AND (forModel == true)  then (
									
									
									vmt.envmapmasktransform = ("center 0 0 scale "+(mat.specularLevelMap.coords.U_Tiling as string)+" "+(mat.specularLevelMap.coords.V_Tiling as string)+" rotate "+((mat.specularLevelMap.coords.W_Angle + 180) as string)+" translate "+(mat.specularLevelMap.coords.V_Offset as string)+" "+(mat.specularLevelMap.coords.U_Offset as string))
									
									
								)
								*/

							)
						)
					) else (

						if classOf mat.reflectionMap  == Reflect_Refract then (
							
							vmt.reflectionMap = mat.reflectionMap
						)
						
					)
				)	

				
				if isProperty mat "lightwarptexture" == true AND mat.lightwarptexture  != undefined do (
					if classOf mat.lightwarptexture  == Bitmaptexture do (
						if mat.lightwarptexture.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if ( vmt.isValidBitmap  (getFilenameType mat.lightwarptexture.filename) == true) do (

								vmt.lightwarptexture = mat.lightwarptexture.filename
/*
								if coords == true AND (forModel == true)  then (
									
									
									vmt.lightwarptexture = ("center 0 0 scale "+(mat.lightwarptexture.coords.U_Tiling as string)+" "+(mat.lightwarptexture.coords.V_Tiling as string)+" rotate "+((mat.lightwarptexture.coords.W_Angle + 180) as string)+" translate "+(mat.lightwarptexture.coords.V_Offset as string)+" "+(mat.lightwarptexture.coords.U_Offset as string))
									
									
								)
								*/

							)
						)
					)
				)		
				
				
				
				
				if isProperty mat "parallaxmap" == true AND mat.parallaxmap  != undefined do (
					if classOf mat.parallaxmap  == Bitmaptexture do (
						if mat.parallaxmap.filename != undefined do (
						--parsedFilename = filterString mat.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.specularMap.filename) "."
							if ( vmt.isValidBitmap  (getFilenameType mat.parallaxmap.filename) == true) do (

								vmt.parallaxmap = mat.parallaxmap.filename
								
								/*
								if coords == true AND (forModel == true)  then (
									
									
									vmt.envmapmasktransform = ("center 0 0 scale "+(mat.lightwarptexture.coords.U_Tiling as string)+" "+(mat.lightwarptexture.coords.V_Tiling as string)+" rotate "+((mat.lightwarptexture.coords.W_Angle + 180) as string)+" translate "+(mat.lightwarptexture.coords.V_Offset as string)+" "+(mat.lightwarptexture.coords.U_Offset as string))
									
									
								)
								*/

							)
						)
					)
				)		
				
				

				
				if mat.ambientMap  != undefined do (
					if classOf mat.ambientMap  == Bitmaptexture do (
						if mat.ambientMap.filename != undefined do (
						--parsedFilename = filterString mat.ambientMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.ambientMap.filename) "."
							if ( vmt.isValidBitmap  (getFilenameType mat.ambientMap.filename) == true) do (

								vmt.ambient = mat.ambientMap.filename
							
							)
						)
					)
				)							
							
							
				if mat.selfIllumMap  != undefined do (
					if classOf mat.selfIllumMap  == Bitmaptexture do (
						if mat.selfIllumMap.filename != undefined do (
						--parsedFilename = filterString mat.selfIllumMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat.selfIllumMap.filename) "."
							if ( vmt.isValidBitmap  (getFilenameType mat.selfIllumMap.filename) == true) do (

								vmt.illum = mat.selfIllumMap.filename
							
							)
						)
					)
				)							
							
			detailMap = undefined		
				
				
					

				if mat.displacementMap  != undefined do (
					
					
						if classOf mat.displacementMap == Normal_Bump then (
						
							mapToUse = mat.displacementMap.normal_map
						
							if mat.displacementMap.bump_map != undefined AND classOf mat.displacementMap.bump_map == Bitmaptexture do (
								detailMap = mat.displacementMap.bump_map
							)
						
							
							
						) else (
							mapToUse = mat.displacementMap

						)
					
					
					if classOf mapToUse  == Bitmaptexture do (
						if mapToUse.filename != undefined do (
						--parsedFilename = filterString mat.displacementMap.filename "."
							if ( vmt.isValidBitmap  (getFilenameType mapToUse.filename) == true) do (

								vmt.normal = mapToUse.filename
								/*
								if coords == true AND (wwmt_mat_textransform_vmts == true OR wwmt_mat_textransform_vmts == "true")  then (
									
									
									vmt.bumptransform = ("center 0 0 scale "+(mapToUse.coords.U_Tiling as string)+" "+(mapToUse.coords.V_Tiling as string)+" rotate "+((mapToUse.coords.W_Angle + 180) as string)+" translate "+(mapToUse.coords.V_Offset as string)+" "+(mapToUse.coords.U_Offset as string))
									
									
								)
								*/
							
							)
						)
					)
				)	


				
				if mat.bumpMap  != undefined do (
					
					
					if classOf mat.bumpMap == Normal_Bump then (
						
						mapToUse = mat.bumpMap.normal_map
						
						
						if mat.bumpMap.bump_map != undefined AND classOf mat.bumpMap.bump_map == Bitmaptexture do (
							detailMap = mat.bumpMap.bump_map
							/*
								if coords == true AND (wwmt_mat_textransform_vmts == true OR wwmt_mat_textransform_vmts == "true")  then (

									vmt.detailtexturetransform = ("center 0 0 scale "+(detailMap.coords.U_Tiling as string)+" "+(detailMap.coords.V_Tiling as string)+" rotate "+((detailMap.coords.W_Angle + 180) as string)+" translate "+(detailMap.coords.V_Offset as string)+" "+(detailMap.coords.U_Offset as string))

								)
							
							*/
							
							
							
						)
						
						) else (
							mapToUse = mat.bumpMap

						)
					
					if classOf mapToUse  == Bitmaptexture do (
						if mapToUse.filename != undefined do (
						--parsedFilename = filterString mat.bumpMap.filename "."
							if ( vmt.isValidBitmap  (getFilenameType mapToUse.filename) == true) do (

								
								

								vmt.bump = mapToUse.filename

								/*
								if coords == true AND (wwmt_mat_textransform_vmts == true OR wwmt_mat_textransform_vmts == "true")  then (
									
									
									vmt.bumptransform = ("center 0 0 scale "+(mapToUse.coords.U_Tiling as string)+" "+(mapToUse.coords.V_Tiling as string)+" rotate "+((mapToUse.coords.W_Angle + 180) as string)+" translate "+(mapToUse.coords.V_Offset as string)+" "+(mapToUse.coords.U_Offset as string))
									
									
								)
								*/
								
							
							)
						)
					) 
				)			
				
				
				
				
				
-----
				
						if detailMap != undefined do (
						--parsedFilename = filterString mat.displacementMap.filename "."
							if ( vmt.isValidBitmap  (getFilenameType detailMap.filename) == true) do (

								vmt.detail = detailMap.filename
							
							)
						)



				

						
						
						

					
					
					appendIfUnique materials vmt

					--return vmt
				
				if isProperty mat "crackmaterial" == true AND mat.crackmaterial != undefined then (
							
					wallworm_appendBitmaps mat.crackmaterial materials valveShader coords:coords decal:decal  getNameFromPath:getNameFromPath forModel:forModel materialPath:materialPath

				)	
			
			
			) else (
				if (classOf mat == Multimaterial ) then (
					for m in mat.materialList do (
						
						if isProperty m "valveShader" == true then (
							
								vs = m.valveShader
						) else (
								vs = valveShader
						)
						
						wallworm_appendBitmaps m materials vs   coords:coords  decal:decal  getNameFromPath:getNameFromPath forModel:forModel materialPath:materialPath
						
						)
					) else (
						
						if (classOf mat == Blend ) do (
							--try (
							
							--print "this is a blend"
							tempMap = #()
							

							
						if isProperty mat.map1 "valveShader" == true then (
							
								vs1 = mat.map1.valveShader
						) else (
								vs1 = valveShader
						)
							

							
						if isProperty mat.map2 "valveShader" == true then (
							
								vs2 = mat.map2.valveShader
						) else (
								vs2 = valveShader
						)
						
						
							wallworm_appendBitmaps mat.map1 tempMap vs1 coords:coords
							wallworm_appendBitmaps mat.map2 tempMap vs2 coords:coords
							
							
							
							
							vmt3 = ww_vmt()
							vmt3.mat = mat
							vmt3.mat1 = mat.map2
							vmt3.mat2 = mat.map1
							
							vmt3.diff = tempMap[2].diff
							vmt3.diff2 = tempMap[1].diff
							
							if tempMap[2].bump != undefined then (
								vmt3.bump = tempMap[2].bump
							)
							if tempMap[1].bump != undefined then (
								vmt3.bump2 = tempMap[1].bump
							)
							if tempMap[2].normal != undefined then (
								vmt3.normal = tempMap[2].normal
							)
							if tempMap[1].normal != undefined then (
								vmt3.normal2 = tempMap[1].normal
							)
							if tempMap[2].detail != undefined then (
								vmt3.detail = tempMap[2].detail
							)
							if tempMap[1].detail != undefined then (
								vmt3.detail2 = tempMap[1].detail
							)
							if tempMap[2].spec != undefined then (
								vmt3.spec = tempMap[2].spec
							) 
							if tempMap[1].spec != undefined then (
								vmt3.spec2 = tempMap[1].spec
							)
							if tempMap[2].illum != undefined then (
								vmt3.illum = tempMap[2].illum
							)
							if tempMap[1].illum != undefined then (
								vmt3.illum2 = tempMap[1].illum							
							)
							if tempMap[2].specLevelMap != undefined then (
								vmt3.specLevelMap = tempMap[2].specLevelMap
							) 
							if tempMap[1].specLevelMap != undefined then (
								vmt3.specLevelMap2 = tempMap[1].specLevelMap
							)
							
							if isProperty tempMap[1] "lightwarptexture" == true then (
								
								vmt3.lightwarptexture2 = tempMap[1].lightwarptexture
								
							)
							
							if isProperty tempMap[2] "lightwarptexture" == true then (

								vmt3.lightwarptexture = tempMap[2].lightwarptexture
								
							)
							
							
							
							if isProperty tempMap[1] "parallaxmap" == true then (
								
								vmt3.lightwarptexture2 = tempMap[1].parallaxmap
								
							)
							
							if isProperty tempMap[2] "parallaxmap" == true then (

								vmt3.parallaxmap = tempMap[2].parallaxmap
								
							)
							
							

							
							
							
							
							
							if isProperty tempMap[1] "reflectionMap" == true then (
								
								vmt3.reflectionMap2 = tempMap[1].reflectionMap
								
							)
							
							if isProperty tempMap[2] "reflectionMap" == true then (

								vmt3.reflectionMap = tempMap[2].reflectionMap
								
							)
							
							

							vmt3.valveShader  = 	"WorldVertexTransition"	
							vmt3.matName =  wallworm_getMaterialName  mat
							vmt3.materialPath =  vmt3.getMaterialPathForMat mat.map2
							vmt3.materialPath2 =  vmt3.getMaterialPathForMat mat.map1
							
							if mat.mask != undefined AND classOf mat.mask == BitmapTexture then (
							
								vmt3.blendmodulate = mat.mask
								
							)
							

							
							
							/*
							vmt3 = ww_vmt()
							vmt3.mat = mat
							vmt3.mat1 = mat.map1
							vmt3.mat2 = mat.map2
							
							vmt3.diff = tempMap[1].diff
							vmt3.diff2 = tempMap[2].diff
							
							if tempMap[1].bump != undefined then (
								vmt3.bump = tempMap[1].bump
							)
							if tempMap[2].bump != undefined then (
								vmt3.bump2 = tempMap[2].bump
							)
							if tempMap[1].normal != undefined then (
								vmt3.normal = tempMap[1].normal
							)
							if tempMap[2].normal != undefined then (
								vmt3.normal2 = tempMap[2].normal
							)
							if tempMap[1].detail != undefined then (
								vmt3.detail = tempMap[1].detail
							)
							if tempMap[2].detail != undefined then (
								vmt3.detail2 = tempMap[2].detail
							)
							if tempMap[1].spec != undefined then (
								vmt3.spec = tempMap[1].spec
							) 
							if tempMap[2].spec != undefined then (
								vmt3.spec2 = tempMap[2].spec
							)
							if tempMap[1].illum != undefined then (
								vmt3.illum = tempMap[1].illum
							)
							if tempMap[2].illum != undefined then (
								vmt3.illum2 = tempMap[2].illum							
							)
							if tempMap[1].specLevelMap != undefined then (
								vmt3.specLevelMap = tempMap[1].specLevelMap
							) 
							if tempMap[2].specLevelMap != undefined then (
								vmt3.specLevelMap2 = tempMap[2].specLevelMap
							)

							vmt3.valveShader  = 	"WorldVertexTransition"	
							vmt3.matName =  wallworm_getMaterialName  mat
							vmt3.materialPath =  vmt3.getMaterialPathForMat mat.map1
							vmt3.materialPath2 =  vmt3.getMaterialPathForMat mat.map2
							
							*/
							
							
							appendIfUnique materials vmt3
								
							appendIfUnique materials tempMap[1]
							appendIfUnique materials tempMap[2]
								
								
							--) catch(
								--print ("There was a problem with this Blend Material: "+getCurrentException())
								
								--)
							)
						
						
						if (classOf mat ==Shell_Material) do (
							
							wallworm_appendBitmaps mat.bakedMaterial materials valveShader getNameFromPath:getNameFromPath coords:coords forModel:forModel materialPath:materialPath
							
						)
						if (classOf mat ==DirectX_9_Shader) do (
							
							wallworm_appendBitmaps mat.renderMaterial materials valveShader getNameFromPath:getNameFromPath coords:coords forModel:forModel materialPath:materialPath
							
							)
						)
			)
		)
	)
)
		/*	
	function wallworm_remove_filename_from_path p = (
		local fnameuse = filenameFromPath tex.filename
		
		if matchpattern texnameuse pattern:("*"+fnameuse) then (
			
			texnameuse = substituteString texnameuse fnameuse ""
		)
	)
*/

			function wallworm_getVTFPathFromBitmap tex forcePath:"" = (
				--try (
				
				if classOf tex == Normal_Bump then (
					
					tex = tex.normal_map
					
				)
				

				if classOf tex == BitmapTexture then (

					if forcePath == "" then (
						if tex.name == "" then (
							tex.name = "UntitledTexture"
							)
							
							
							local texnameuse = tex.name
							local fnameuse = filenameFromPath tex.filename
							if matchpattern texnameuse pattern:("*"+fnameuse) then (
								/*Added to allow the bitmap node to include the bitmap name for easier reference in scene.*/
								texnameuse = substituteString texnameuse fnameuse ""
							)
						dir = wallworm_remove_last_slash texnameuse
					) else (
						dir = wallworm_remove_last_slash forcePath
					)
					return (wallworm_safe_path (dir + "\\" + (wallworm_outputTexName tex.filename)))

				) else (
					if classOf tex == String then (	
						return (wallworm_safe_path(forcePath + "\\" + (wallworm_outputTexName tex)))
					)
				)
				
				-- pathConfig.removePathLeaf "c:\whatever\mytest\whatever"
				
				
			--) catch (
				--print (getCurrentException())
				--)
				return ""
			)
	
	function wallworm_detailMapTex mat = (

		
				if mat.displacementMap  != undefined AND classOf mat.displacementMap == Normal_Bump AND mat.displacementMap.bump_map != undefined AND classOf mat.displacementMap.bump_map == BitmapTexture then (
					--print mat.displacementMap
						

							
								return mat.displacementMap.bump_map

				
						

						

					) else (
						
				if mat.bumpMap  != undefined do (
					
						--print mat.bumpMap
						
							
							if classOf mat.bumpMap == Normal_Bump AND mat.bumpMap.bump_map != undefined AND classOf mat.bumpMap.bump_map == BitmapTexture then (
							
								return mat.bumpMap.bump_map

							) else ()						
						

						
					)
				)
			return undefined
		)		
			
			
			
	function wallworm_bumpMapTex mat = (
		
	
				if mat.displacementMap  != undefined then (
					
					if classOf mat.displacementMap == BitmapTexture then (
						
						return mat.displacementMap
						
						) else (
						
							
							if classOf mat.displacementMap == Normal_Bump AND mat.displacementMap.normal_map != undefined AND classOf mat.displacementMap.normal_map == BitmapTexture then (
							
								return mat.displacementMap.normal_map

							) else ()						
						
						)
						

					) else (
						
				if mat.bumpMap  != undefined do (
					
					if classOf mat.bumpMap == BitmapTexture then (
						
						return mat.bumpMap
						
						) else (
						
							
							if classOf mat.bumpMap == Normal_Bump AND mat.bumpMap.normal_map != undefined AND classOf mat.bumpMap.normal_map == BitmapTexture then (
							
								return mat.bumpMap.normal_map

							) else ()						
						
						)
						
					)
				)

		)		
			
	
			
			
			function wallworm_write_vtf_bat tex diffName:"" dir:"" VMTWritten:false runBat:true exportVTF:true extra:"" shaderUsed:"LightmappedGeneric" texlist:#() mat:undefined = (
				
					bt = ""
				
				ssbump = false
				
				if mat != undefined AND isProperty mat "wallworm" then (
						
					ssbump = mat.ssbump
					
				)
				
				
				if classof tex == Reflect_Refract then (
					
					
					if tex.source == 1 AND tex.outputname != undefined   then (
					
						for cb in tex.bitmapname WHERE cb != "" do (
						
							if doesFileExist cb == true then (
									tptex = BitmapTexture()
									tptex.name = tex.name
									tptex.filename = cb
								    append bt (wallworm_write_vtf_bat tptex diffName:diffName dir:dir VMTWritten:VMTWritten runBat:runBat exportVTF:exportVTF extra:extra shaderUsed:"UnlitGeneric" texlist:texlist)
							)
							
						)

						
						
					)
					
					
					
					
				) else (
				
				

				
			batchstring = ""
				 if classOf tex == Normal_Bump then (
					tex = tex.normal_map
				)
		
				if texlist.count == 0 AND tex.filename != undefined  then (
					
					texlist = wallworm_parseIFL tex.filename
					
				)	
				

				
				
		--if texlist.count == 0 then ( return false)
		/*
		if texlist.count > 1 then (
			c = 1
			for t in texlist do (
				if c > 1 then (
					bmt = BitmapTexture
					bmt.filename = t
					append batchstring (wallworm_write_vtf_bat (bmt) type frame:c runBat:false)
				)
				c+=1
				)
		)
			*/	
				
				local texname = wallworm_getVTFPathFromBitmap tex forcePath:dir
				
				if classOf tex == BitmapTexture then (
					
					
					tga1 = tex.filename
					
					if dir == "" then (
						dir = tex.name
					)
					--diffName = getFilenameFile tex.filename
					
					if (getFilenameType tga1) == ".ifl" then (	
						--tga = wwmt_exportMats+"\\"+dir+diffName+(toLower ((getFilenameType texlist[1])) )

						diffName = getFilenameFile texlist[1]
						
						tga = wallworm_safe_path ( wwmt_exportMats+"\\"+texname+(getFilenameType texlist[1]))
						if ssbump then (	
							ssbumpname = 	wallworm_safe_path ( wwmt_exportMats+"\\"+texname+"_ssbump"+(getFilenameType texlist[1]))
						)
					) else (
						diffName = getFilenameFile tex.filename
						tga = wallworm_safe_path ( wwmt_exportMats+"\\"+texname+(getFilenameType tex.filename))
						if ssbump then (	
							ssbumpname = 	wallworm_safe_path ( wwmt_exportMats+"\\"+texname+"_ssbump"+(getFilenameType tex.filename))
						)
					)	
					
					
					
					) else (
					
					
					tga = tex
					
					
					
					)
				
				
				batchName = wallworm_safe_path ( wwmt_exportMats+"\\"+texname+".bat" )
					
					--batchName  = wallworm_FsToBs (wwmt_exportMats+"\\"+dir+diffName+".bat")
					--print ("BATCH SHOULD BE "+batchName)
					
				

					
					
					if batchName != undefined AND doesFileExist (getFileNamePath batchName) == false then (
						makeDir (getFileNamePath batchName) all:true
					)
					
					
					
					if doesFileExist batchName == true then (
						local newBatch = OpenFile batchName mode:"w"	
					) else (
						local newBatch = CreateFile(batchName)	
					)

			
								

							

					Format "@echo on\n" to:newBatch	
					
					--local bt = "cd \""+wwmt_binDir+">\"\n" 
				    --Format bt to:newBatch
							
					global wwmt_gameInfoDir
								
					gameInfoParam = ""		
								
					if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" do (
						gameInfoParam = " -game \""+wwmt_gameInfoDir+"\""
						
						) 

					/*	
					if VMTWritten == true then (
						extra = ""
						) else (
						
						extra = " -shader "+shaderUsed+extra
						)	
						
					*/	

					

					
					if ssbump then (
						/*See if normal2ssbump.exe resides in BIN*/
						if doesFileExist (wwmt_binDir+"\\normal2ssbump.exe") then (
							
							bt = "\""+wwmt_binDir+"\\normal2ssbump.exe\"  \""+tga+"\"\n"
							Format bt to:newBatch
							
							
							if runBat == false then (
								append gameInfoParam " -nopause"
							)	
							
							bt = "\""+wwmt_binDir+"\vtex.exe\""+gameInfoParam+" -mkdir  \""+ssbumpname+"\"\n"

								
							Format bt to:newBatch
							
						) else (
							
							print (wwmt_binDir+"\\normal2ssbump.exe not found... skipping SSBump conversion.")
						)
						
						
					)
					
					
					if runBat == false then (
						append gameInfoParam " -nopause"
					)	
					
					bt = "\""+wwmt_binDir+"\vtex.exe\""+gameInfoParam+" -mkdir  \""+tga+"\"\n"

						
					Format bt to:newBatch
						
					if batchstring != "" then (
						
						format batchstring to:newBatch
						
						)	
					
					Format "@pause\n" to:newBatch
					
					close newBatch
						
						
					if runBat == true AND exportVTF == true then (
						shellLaunch batchName ""
					)		
					)
					return bt
				)
			
			
			
			function wallworm_copy_bitmap_to_sdk tex forcePath:"" texlist:#() compression:undefined norm:false sky:false= (
				
				if classof tex == Reflect_Refract then (
					
					
					if tex.source == 1 AND tex.outputname != undefined   then (
					
						for cb in tex.bitmapname WHERE cb != "" do (
						
							if doesFileExist cb then (
									tptex = BitmapTexture()
									tptex.name = tex.name
									tptex.filename = cb
								    wallworm_copy_bitmap_to_sdk tptex forcePath:forcePath texlist:texlist compression:compression norm:norm sky:sky
							)
							
						)

						
						
					)
					
					
					
					
				) else (
				
				
				
				if classOf tex == Normal_Bump then (
					tex = tex.normal_map
				)
				
				local diffName = getFileNameFile tex.filename
				
				local tga = ""
				local newParams
				
				--if texlist.count == 0 then (
					
					texlist = wallworm_parseIFL tex.filename
					
				--)	
				
				
				local texname = wallworm_getVTFPathFromBitmap tex forcePath:forcePath
				
				if (getFilenameType tex.filename) == ".ifl" then (	
					tga = wallworm_safe_path ( wwmt_exportMats+"\\"+texname+(toLower ((getFilenameType texlist[1])) ) )
				) else (
					tga = wallworm_safe_path ( wwmt_exportMats+"\\"+texname+(toLower ((getFilenameType tex.filename)) ) )
				)				
				
				
				--format "Source: %\nDestination: %\n" texlist[1] tga
				
				if doesFileExist (getFileNamePath (wwmt_exportMats+"\\"+texname+".txt")) == false then (
						makeDir (getFileNamePath (wwmt_exportMats+"\\"+texname+".txt")) all:true
				)
							
							
				if doesFileExist (wwmt_exportMats+"\\"+texname+".txt")	== true then (
					local newParams = OpenFile (wwmt_exportMats+"\\"+texname+".txt")	mode:"w"
				) else (
					local newParams = CreateFile(wwmt_exportMats+"\\"+texname+".txt")		
				)
				if norm == true then (
					--No compression because a normal map
					format ("normal 1\n") to:newParams	
				) else (
					if compression != undefined and compression != ""   then (
						
						if tolower compression == "dxt5" AND (tex.alphasource == 2 OR (tex.bitmap != undefined AND tex.bitmap.hasAlpha == false)) then (
							
							--do not add alpha
						) else (						)
						
						
						--Use designated compression
							format ((toLower compression)+" 1\n") to:newParams	

						
					)
				)
				
				if texlist.count > 1 then (
					--This is an image file list
					format ("startframe 0\nendframe "+((texlist.count-1)	 as string)+"\n") to:newParams	
				)
				
				close newParams
				
		
				if getFilenamePath tex.filename != getFilenamePath tga AND doesFileExist tga then (
					--print ("Deleting "+tga)
					deleteFile tga
				)	
				if getFilenamePath texlist[1] != getFilenamePath tga then (
					copyFile (mapPaths.getFullFilePath texlist[1]) tga	
				)
				if (toLower ((getFilenameType tex.filename)) == ".ifl") then (
					
					theTexBit= BitmapTexture()
					theTexBit.name = tex.name
					for t in texlist do (
						theTexBit.filename = t
						texname = wallworm_getVTFPathFromBitmap theTexBit forcePath:forcePath
						
						tga2 = wallworm_safe_path ( wwmt_exportMats+"\\"+texname+(toLower ((getFilenameType t)) ))
						--print  tga2
						if doesFileExist t AND (getFilenamePath t != getFilenamePath tga2) then (

								if doesFileExist tga2 then (
									deleteFile tga2
												
								)
								copyFile (mapPaths.getFullFilePath t) tga2	

						)
						
						
					)

								
				) else ()

			)
		)

			
			function wallworm_TextureUntextured objarray:undefined theMat:undefined= (
				
				if theMat == undefined then (
					try (
						--get the material that is open in slate
						theMat = sme.GetMtlInParamEditor()
						if theMat == undefined OR superClassOf theMat != Material then (
							theMat = medit.GetCurMtl()
						)
					) catch (
						--for older versions of Max that don't have Slate
						 theMat = medit.GetCurMtl()
					)
				)
				
				
				if theMat != undefined AND superClassOf theMat == Material then (
					
					if objarray == undefined then (
						
						
						if selection.count > 0 then (
							objarray = selection as array
							) else (
							objarray = objects as array
							)
						
						
						)
						if objarray.count > 0 then (
							for obj in objarray where obj.mat == undefined do (
								obj.mat = theMat
								)
							)

					)

				)
			
				
				
function wallworm_update_dxdisplay dxversion:11 = (
	
	for mat in sceneMaterials where  classOf mat == DirectX_9_Shader AND getFileNameFile mat.effectfile ==  "blend_dxsas11_nitrous" do (
		
		if viewport.GetRenderLevel() != #smoothhighlights then (
			
			if dxversion != 11 then (
				mat.technique = 3
			) else (
				
				mat.technique = 1
				
			)
			
		) else (
			
			if dxversion != 11 then (
				
				
				mat.technique = 2
				
				
			) else (
				
				mat.technique = 0
				
			)
			
			
		)
		
	)


	
)


function wallworm_blend_to_DXBlend mat:undefined  rev:false= (
	local mat2
	
	
	defaultBitmaps  = #()
	
	
	local bm1 = openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/dirtfloor002a.tga"
	local bm2 =  openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/cliffface002a.tga"
	

	
	if mat != undefined AND classOf mat == Blend  then (
		
		mat2 = mat
		if mat2.map1 != undefined AND mat2.map1.diffusemap != undefined AND classof mat2.map1.diffusemap == bitmaptexture AND doesFileExist mat2.map1.diffusemap.filename == true	AND ( VTFImporter != undefined OR getFileNameType  mat2.map1.diffusemap.filename != ".vtf" ) then (
			
		
			bm1 = mat2.map1.diffusemap.bitmap
		)
		
		if mat2.map2 != undefined AND mat2.map2.diffusemap != undefined AND classof mat2.map2.diffusemap == bitmaptexture AND doesFileExist mat2.map2.diffusemap.filename == true	AND ( VTFImporter != undefined OR getFileNameType  mat2.map2.diffusemap.filename != ".vtf" ) then (
			bm2 = mat2.map2.diffusemap.bitmap
		)
		
	) else (
		
		local bm1 = openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/dirtfloor002a.tga"
		local bm2 =  openBitMap "$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/nature/cliffface002a.tga"
		
		local tex1 = bitmaptexture bitmap:bm1 filename:bm1.filename name:"nature"
		local tex2 = bitmaptexture bitmap:bm2 filename:bm2.filename name:"nature"
		
		if mat == undefined OR classOf mat != Standard  then (

			
			
			mat2 = Blend map1:(Standard diffusemap:(tex1) showInViewport:true  name:"nature/dirtfloor002a" ) map2:(Standard diffusemap:(tex2) showInViewport:true  name:"nature/cliffface002a" ) showInViewport:true  name:"nature/blendcliffgrass001a" 
			
		) else (
			
			
			if classOf mat == Standard AND mat.diffusemap != undefined AND classof mat.diffusemap == BitmapTexture then (
				mat2 = Blend map1:mat map2:(Standard diffusemap:(tex2) showInViewport:true  name:"nature/cliffface002a" ) showInViewport:true  name:"nature/blendcliffgrass001a" 
			)
			
			
			
		)
			
		
	)
	
	

	local dxmat
		
	if(MaxVersion())[1]  >= 16000 AND (NitrousGraphicsManager.IsEnabled() == true ) then (
			dxmat = DirectX_9_Shader effectFilename:"$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/fx/blend_dxsas11_nitrous.fx" name:mat2.name
		
			if  rev == false then (
				dxmat.TextureTop = bm1
				dxmat.TextureBottom = bm2
			) else (
				dxmat.TextureTop = bm2
				dxmat.TextureBottom = bm1
			)
	) else (
			dxmat = DirectX_9_Shader effectFilename:"$scripts/WallWorm.com/WallWormSimpleDisplacement/maps/fx/blend_dxsas.fx" name:mat2.name
			if  rev == false then (
				dxmat.seteffectbitmap 1 bm1
				dxmat.seteffectbitmap 2 bm2	
			) else (
				dxmat.seteffectbitmap 1 bm2
				dxmat.seteffectbitmap 2 bm1
			)
			
	)
		
	/*Swap the materials. Probably from an imported VMT*/
	if  rev == true then (
		om1 = mat2.map1
		om2 = mat2.map2
		mat2.map1 = om2
		mat2.map2 = om1
	)
	dxmat.renderMaterial =  mat2
	
	wallworm_update_materials_ca mat2.map1 addca:true
	wallworm_update_materials_ca mat2.map2 addca:true
	wallworm_update_materials_ca dxmat.renderMaterial addca:true
	
	
	dxmat
)



function wallworm_convert_blends_to_dx objs = (
	
		for obj in objs WHERE obj.mat != undefined AND classOf obj.mat == Blend do (
			
			obj.mat = (wallworm_blend_to_DXBlend mat:obj.mat)
			
			
		)
	
	
)

/*

Function to copy the Vertex Alpha to Vertex

*/
function wallworm_copy_alpha_to_vert obj = (
	
	/*
	polyop.setMapSupport obj 0 true
	
	
	local alphverts = polyop.getNumMapVerts obj -2
	
	polyop.setNumMapVerts obj 0 alphverts keep:false
	
	for tv = 1 to alphverts do (
		
	polyop.setMapVert obj 0 tv  (polyop.getMapVert obj -2 tv)
	--format "" ((polyop.getMapVert obj -2 tv) * -1)
	)
	
	*/
	
	ChannelInfo.CopyChannel obj 3 -2
	ChannelInfo.PasteChannel obj 3 0
)

function wallworm_copy_alphas_to_verts objs = (
	
	for obj in objs do (
		wallworm_copy_alpha_to_vert obj
	)
	
	
)


/*

matchPolice

1: return true only if match all
2: return true only if match none
3: return true if match found

*/

function wallworm_matchStringArray str pattern matchPolicy:1 = (
		local ma
		print str
		if matchPattern pattern pattern:"*,*" == true then (
			strs = filterString pattern ","
			ma = true
			for s in strs while ma == true do (
					
				
				local m = matchPattern str pattern:("*"+s+"*")
				
				
				
				
				
				
				if m == true AND matchPolicy == 3 then (
						return true
					
				)
				
				
				
				if m == true AND matchPolicy == 2 then (
					
					ma = false
				)
				
				if m == false AND matchPolicy == 1 then (
					
					ma = false
				)
				
			)
			
		) else (
			
			ma = matchPattern str pattern:("*"+pattern+"*")
			if matchPolicy == 2   then (
				ma = not ma
				
			)
			
		)  
		ma
)



function wallworm_material_redirect mats newPath &ignore:#() prepend:false maps:true texNameToPath:true texPathOnlyForBitmaps:true skipPattern:undefined matchP:undefined= (
	
		
		for m in mats where findItem ignore m  == 0 AND (skipPattern==undefined OR skipPattern==""  OR (skipPattern != undefined AND skipPattern != ""  AND wallworm_matchStringArray m.name skipPattern matchPolicy:2 == true)) AND (matchP==undefined OR matchP==""  OR ( matchP !=undefined AND matchP != "" AND wallworm_matchStringArray m.name matchP matchPolicy:3 == true)) do (
		
			print m
			if prepend == true then (
				newPath += "/"+(getFileNamePath m.name)
			)
			m.name = newPath+"/" + (getFileNameFile m.name)
				
			m.name = wallworm_safe_path m.name
			append ignore m	
			if maps == true then (
				
				newMats = #()
				
				if superClassOf m == Material then (
					
					ms = getNumSubMtls  m
					if ms > 0 then (
						for msi = 1 to ms do (
							ma = (getSubMtl  m msi)
							if ma != undefined then (
								appendIfUnique newMats ma
							)
						)
						
					)
				)
				
				
				ms = getNumSubTexmaps m
				if ms > 0 then (
					for msi = 1 to ms do (
						mp = (getSubTexmap m msi)
						if mp != undefined then (
							if texNameToPath == true AND (texPathOnlyForBitmaps == false OR classOf mp == BitmapTexture) then (
								mp.name = newPath
							) else (
								appendIfUnique newMats mp
							)
						)
					)
					
				)
				
				
				if newMats.count > 0 then (
					wallworm_material_redirect newMats newPath ignore:&ignore prepend:prepend maps:maps matchP:matchP skipPattern:skipPattern texPathOnlyForBitmaps:texPathOnlyForBitmaps texNameToPath:texNameToPath
				)
				
			)
				
		)
	
)

