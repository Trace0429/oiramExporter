/*
Wall Worm Material Merger
http://www.wallworm.com

Copyright (C) 2012-2013 by Shawn Olson
http://www.shawnolson.net

Please report any bugs in the Wall Worm forums at http://www.wallworm.net.
Or email me at lightcube@gmail.com.

Feel free to donate!
http://dev.wallworm.com/topic/42/donate.html

This Macroscript allows you to combine all the maps of a selection of materials into composited and flattened maps per map slot.

Full documentation and changelog for this script located here:

http://www.shawnolson.net/a/1819/material_merger.html

General Usage:

1) Render To Texture on one or more models. Make sure the models are using the same UVW template! You can use the same 
UVW on mutliple objects by selecting them all and and adding a Unwrap UVW modifier. Make sure to flatten the mapping.
**hint** When using RTT you can RTT all objects at once.

2) Select all objects with baked materials.

3) Open Material Merger.

4) Click "Create Composite From Selection".

5) Choose a basename for your output maps.

6) Select the output directory.

7) Click Flatten Maps. 

NOTE THAT THIS WILL OVERWRITE ANY MATCHING BITMAPS IN THE TARGET DIRECTORY WITHOUT ASKING FOR CONFIRMATION!

You can assign the new material with combined/flattened maps to objects by selecting them and clicking the "Assign Flattened" button.


!TODO

* Figure out a logic for when there are multiple shader types in the material list. Right now it will 

*/

(


	
rollout WallWormFlattenMaps "Wall Worm Material Merger Version 1.2" width:386 height:266
(
	
	local theCurrentMat
	local newMat
	local wallworm_matmergeIni
	
	button btnCreateComposite "Create Composite From Selection" pos:[13,40] width:216 height:37 toolTip:"Generate a material where all map channels from all selected objects get placed into a single material where the channels are composited."
	button btnGetDir "Output Dir" pos:[14,111] width:82 height:25 toolTip:"Assign the output directory for the flattened bitmaps."
	edittext edtDir "" pos:[105,112] width:227 height:24 toolTip:"Assign the output directory for the flattened bitmaps."
	edittext edtBaseName "Base Name" pos:[15,82] width:361 height:25 toolTip:"Create the base name for the bitmaps. All bitmaps will get this name and be appended with the map channel abbreviation."
	button btnAssignComposites "Assign Composited" pos:[236,40] width:141 height:37 enabled:false toolTip:"Assign the current non-flattened material to the selected objects."
	button btnFlattenMaps "Flatten Maps" pos:[194,141] width:179 height:51 enabled:false toolTip:"Create flattened bitmaps for all active channels in the composited material."
	button btnAssignFlatMat "Assign Flattened" pos:[284,194] width:89 height:26 enabled:false toolTip:"Assign the current flattened material to the selected objects."
	dropdownList ddlSize "" pos:[110,168] width:78 height:21 items:#("64", "128", "256", "512", "1024", "2048", "4096") selection:5 toolTip:"Choose the size for your output bitmaps."
	combobox cbxType "" pos:[14,144] width:89 height:4 items:#("tga", "bmp", "png", "tif", "exr", "dds") toolTip:"Choose the target export file type."
	label lbl1 "Written By" pos:[14,236] width:56 height:18
	HyperLink smo "Shawn Olson" pos:[76,236] width:89 height:15 address:"http://www.shawnolson.net" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	HyperLink ww "A Wall Worm Tool" pos:[15,219] width:132 height:15 address:"http://www.wallworm.com" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	/*Get some love from the users.*/
	HyperLink donate "Donate" pos:[172,236] width:49 height:15 address:"http://dev.wallworm.com/topic/42/donate.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	spinner spnChannel "Channel" pos:[143,195] width:45 height:16 range:[0,100,1] type:#integer scale:1 toolTip:"Set the UVW channel used in the flattened maps."
	label lbl9 "Bitmap Size" pos:[108,144] width:78 height:18
	button btnUpdateUVW "Update Channel" pos:[195,194] width:86 height:26 enabled:false toolTip:"Update the flattened UVW channels to the current Channel value."
	checkbox chkShell "Assign to Shell" pos:[288,231] width:88 height:18 checked:true toolTip:"When checked, the Assign Flattened function will always keep the current materials as the Render Material and apply the flattened material as the baked material."
	button btn26 "Open" pos:[337,113] width:37 height:23
	HyperLink cust4 "Docs" pos:[226,236] width:45 height:15 address:"http://www.shawnolson.net/a/1819/material_merger.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	dropdownList ddlShaderType "" pos:[15,10] width:212 height:21 items:#("Anisotropic", "Blinn", "Hanrahan-Krueger", "Metal", "Multi-Layer", "Oren-Nayer-Blinn", "Phong", "Strauss", "Translucent Shader") selection:2
	
	

	/*dropdownList ddl2 "" pos:[248,231] width:124 height:21 items:#("Standard Material", "Vray Becomes Standard", "Vray Out")*/
	/*
	 Get the Standard Material from an input Material. Required to collect materials from Shell Materials, Multimaterials and DirectX_Shaders.
	*/
	function wallworm_getStandardMaterials m &materiallist = (
		

		if m == undefined OR superClassOf m != Material then return false
		case (classOf m) of (
			
			
			 MultiMaterial : (
				for mi in m.materialList where mi != undefined do (
					
					wallworm_getStandardMaterials mi materiallist
					
					)
			)

			DirectX_9_Shader : (
				
				wallworm_getStandardMaterials m.renderMaterial materiallist

			)
			
			Shell_Material : (
				wallworm_getStandardMaterials m.bakedMaterial materiallist
				
			)
				
			
			Standard : (
				
				
				appendIfUnique materiallist m

				
			)
			
			
			VRayMtl : (
				appendIfUnique materiallist m
			)
			
			
			default: (
				
					--the material isn't a recognized class		
						return false
				
			)
			
		)
		
		return true
			
	)
	
	/*
	This function will take a map node and add it to the targetMap's (material) targetMap ( texture slot) in a composite map at that node.
	*/
	function wallworm_add_map_to_target_composite &targetMat inputMap targetMap = (
		
		
		if targetMat == undefined OR inputMap == undefined OR targetMap == undefined OR (isProperty targetMat targetMap == false) then return false
			
		
		
		local compositTex

		
		case targetMap of (

			"diffuseMap": (
					if targetMat.diffuseMap !=undefined AND classOf targetMat.diffuseMap ==compositeTextureMap then (
						compositTex = targetMat.diffuseMap
					) else ()
			)
			
			"bumpMap": (
					if targetMat.bumpMap !=undefined AND classOf targetMat.bumpMap ==compositeTextureMap then (
						compositTex = targetMat.bumpMap
					) else ()
			)
			
			"anisotropyMap": (
					if targetMat.anisotropyMap !=undefined AND classOf targetMat.anisotropyMap ==compositeTextureMap then (
						compositTex = targetMat.anisotropyMap
					) else ()
			)
			
			
			
			"DiffuseLevelMap": (
					if targetMat.DiffuseLevelMap !=undefined AND classOf targetMat.DiffuseLevelMap ==compositeTextureMap then (
						compositTex = targetMat.DiffuseLevelMap
					) else ()
			)
			
			
			"DiffuseRoughnessMap": (
					if targetMat.DiffuseRoughnessMap !=undefined AND classOf targetMat.DiffuseRoughnessMap ==compositeTextureMap then (
						compositTex = targetMat.DiffuseRoughnessMap
					) else ()
			)
			
			"specularMap": (
					if targetMat.specularMap !=undefined AND classOf targetMat.specularMap ==compositeTextureMap then (
						compositTex = targetMat.specularMap
					) else ()
			)
			
			"specularLevelMap": (
					if targetMat.specularLevelMap !=undefined AND classOf targetMat.specularLevelMap ==compositeTextureMap then (
						compositTex = targetMat.specularLevelMap
					) else ()
			)
			
			"SelfIllumMap": (
					if targetMat.SelfIllumMap !=undefined AND classOf targetMat.SelfIllumMap ==compositeTextureMap then (
						compositTex = targetMat.SelfIllumMap
					) else ()
			)
			
			"displacementMap": (
					if targetMat.displacementMap !=undefined AND classOf targetMat.displacementMap ==compositeTextureMap then (
						compositTex = targetMat.displacementMap
					) else ()
			)
			
			"ReflectionMap": (
					if targetMat.ReflectionMap !=undefined AND classOf targetMat.ReflectionMap ==compositeTextureMap then (
						compositTex = targetMat.ReflectionMap
					) else ()
			)
			
			"RefractionMap": (
					if targetMat.RefractionMap !=undefined AND classOf targetMat.RefractionMap ==compositeTextureMap then (
						compositTex = targetMat.RefractionMap
					) else ()
			)

			"OrientationMap": (
					if targetMat.OrientationMap !=undefined AND classOf targetMat.OrientationMap ==compositeTextureMap then (
						compositTex = targetMat.OrientationMap
					) else ()
			)
			
			"opacityMap": (
					if targetMat.opacityMap !=undefined AND classOf targetMat.opacityMap ==compositeTextureMap then (
						compositTex = targetMat.opacityMap
					) else ()
			)
			
			"GlossinessMap": (
					if targetMat.GlossinessMap !=undefined AND classOf targetMat.GlossinessMap ==compositeTextureMap then (
						compositTex = targetMat.GlossinessMap
					) else ()
			)
			
			"filterMap": (
					if targetMat.filterMap !=undefined AND classOf targetMat.filterMap ==compositeTextureMap then (
						compositTex = targetMat.filterMap
					) else ()
			)
			
			
			default:(
				--compositTex = compositeTextureMap()
			)
		)

		
		if compositTex == undefined then (
			
			compositTex = compositeTextureMap()
			
		)
		
		
		
		theMapList = compositTex.mapList
		appendIfUnique  theMapList inputMap
		compositTex.mapList = theMapList
		

		case targetMap of (

			"ambientMap": (
					targetMat.ambientMap = compositTex
			)
			"diffuseMap": (
					targetMat.diffuseMap = compositTex
			)
			
			"anisotropyMap": (
					targetMat.anisotropyMap = compositTex
			)
			

			"bumpMap": (
					targetMat.bumpMap = compositTex
			)
			
			"DiffuseLevelMap": (
					targetMat.DiffuseLevelMap = compositTex
			)
			
			"DiffuseRoughnessMap": (
					targetMat.DiffuseRoughnessMap = compositTex
			)

			"specularMap": (
					targetMat.specularMap = compositTex
			)
			
			"specularLevelMap": (
					targetMat.specularLevelMap = compositTex
			)
			
			"SelfIllumMap": (
					targetMat.SelfIllumMap = compositTex
			)
			
			"displacementMap": (
					targetMat.displacementMap = compositTex
			)
			
			"ReflectionMap": (
					targetMat.ReflectionMap = compositTex
			)
			
			"RefractionMap": (
					targetMat.RefractionMap = compositTex
			)

			"OrientationMap": (
					targetMat.OrientationMap = compositTex
			)
			
			"opacityMap": (
					targetMat.opacityMap = compositTex
			)
			
			"GlossinessMap": (
					targetMat.GlossinessMap = compositTex
			)
			
			"filterMap": (
					targetMat.filterMap = compositTex
			)
			
			
			

		)
		
		
		
		
	)

	
	/*
	This function creates a Standard Material where all the map channels are composite maps of all the materials in the materiallist.
	*/
	function wallworm_create_composites_material materiallist = (
		
		
		if materiallist == undefined OR classOf materiallist != array OR materiallist.count == 0 then return undefined
			
		local theNewMaterial = Standard()
		
		theNewMaterial.name = uniqueName "Flattened Composite Material"
		theNewMaterial.shaderByName =  ddlShaderType.selected
		for mat in materiallist do (
			
			if isProperty mat "ambientMap" AND mat.ambientMap != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.ambientMap "ambientMap"
			)
			
			if isProperty mat "anisotropyMap" AND mat.anisotropyMap != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.anisotropyMap "anisotropyMap"
			)
			if isProperty mat "filterMap" AND mat.filterMap != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.filterMap "filterMap"
			)
			
			
			
			
			if isProperty mat "diffuseMap" AND mat.diffuseMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.diffuseMap "diffuseMap"
			)
			
			if isProperty mat "bumpMap" AND mat.bumpMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.bumpMap "bumpMap"
			)
			
			if isProperty mat "DiffuseLevelMap" AND mat.DiffuseLevelMap != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.DiffuseLevelMap "DiffuseLevelMap"
			)
			
			if isProperty mat "specularLevelMap" AND mat.specularLevelMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.specularLevelMap "specularLevelMap"
			)
			
			if isProperty mat "GlossinessMap" AND mat.GlossinessMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.GlossinessMap "GlossinessMap"
			)
			
			
			if isProperty mat "opacityMap" AND mat.opacityMap != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.opacityMap "opacityMap"
			)
			
			if isProperty mat "OrientationMap" AND mat.OrientationMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.OrientationMap "OrientationMap"
			)
			
			if isProperty mat "RefractionMap" AND mat.RefractionMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.RefractionMap "RefractionMap"
			)
			
			
			if isProperty mat "ReflectionMap" AND mat.ReflectionMap != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.ReflectionMap "ReflectionMap"
			)
			
			if isProperty mat "displacementMap" AND mat.displacementMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.displacementMap "displacementMap"
			)
			
			if isProperty mat "SelfIllumMap" AND mat.SelfIllumMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.SelfIllumMap "SelfIllumMap"
			)
			if isProperty mat "specularMap" AND mat.specularMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.specularMap "specularMap"
			)
			
			if isProperty mat "DiffuseRoughnessMap" AND mat.DiffuseRoughnessMap != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.DiffuseRoughnessMap "DiffuseRoughnessMap"
			)
			
			
			

			
			
			
			/*Experimental VRay Mat*/
			
			
			if isProperty mat "texmap_diffuse" AND mat.texmap_diffuse != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_diffuse "diffuseMap"
			)
			
			if isProperty mat "texmap_reflection" AND mat.texmap_reflection != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_reflection "ReflectionMap"
			)
			
			if isProperty mat "texmap_refraction" AND mat.texmap_refraction != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_refraction "RefractionMap"
			)
			
			if isProperty mat "texmap_bump" AND mat.texmap_bump != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_bump "bumpMap"
			)
			
			if isProperty mat "texmap_displacement" AND mat.texmap_displacement != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_displacement "displacementMap"
			)
			
			if isProperty mat "texmap_opacity" AND mat.texmap_opacity != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_opacity "opacityMap"
			)
			
			if isProperty mat "texmap_hilightGlossiness" AND mat.texmap_hilightGlossiness != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_hilightGlossiness "GlossinessMap"
			)
			
			if isProperty mat "texmap_anisotropy" AND mat.texmap_anisotropy != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_anisotropy "anisotropyMap"
			)
			
			
			if isProperty mat "texmap_roughness" AND mat.texmap_roughness != undefined  then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_roughness "DiffuseRoughnessMap"
			)
			
			if isProperty mat "texmap_translucent" AND mat.texmap_translucent != undefined then (
				wallworm_add_map_to_target_composite theNewMaterial mat.texmap_translucent "filterMap"
			)
			
			/*
			Some more Vray Material maps... not sure how to map them yet.

			texmap_environment
			texmap_reflectionGlossiness
			texmap_refractionGlossiness
			texmap_refractionIOR
			
			
			
			*/
		)
		

		return theNewMaterial

	)
	
	function wallworm_set_all_mapchannel mat uvChannel = (
		
			if isProperty mat "ambientMap" AND mat.ambientMap != undefined AND classOf mat.ambientMap == BitmapTexture then (
					mat.ambientMap.coords.mapChannel = uvChannel
			)
			
			
			if isProperty mat "anisotropyMap" AND mat.anisotropyMap != undefined AND classOf mat.anisotropyMap == BitmapTexture  then (
					mat.diffuseMap.coords.anisotropyMap = uvChannel
			)

			
			if isProperty mat "diffuseMap" AND mat.diffuseMap != undefined AND classOf mat.diffuseMap == BitmapTexture  then (
					mat.diffuseMap.coords.mapChannel = uvChannel
			)
			
			if isProperty mat "bumpMap" AND mat.bumpMap != undefined AND classOf mat.bumpMap == BitmapTexture  then (
					mat.bumpMap.coords.mapChannel = uvChannel
			)
			
			if isProperty mat "DiffuseLevelMap" AND mat.DiffuseLevelMap != undefined AND classOf mat.DiffuseLevelMap == BitmapTexture then (
					mat.DiffuseLevelMap.coords.mapChannel = uvChannel
			)
			
			if isProperty mat "DiffuseRoughnessMap" AND mat.DiffuseRoughnessMap != undefined AND classOf mat.DiffuseRoughnessMap == BitmapTexture then (
					mat.DiffuseRoughnessMap.coords.mapChannel = uvChannel
			)

			if isProperty mat "specularLevelMap" AND mat.specularLevelMap != undefined AND classOf mat.specularLevelMap == BitmapTexture  then (
					mat.specularLevelMap.coords.mapChannel = uvChannel
			)
			
			if isProperty mat "GlossinessMap" AND mat.GlossinessMap != undefined AND classOf mat.GlossinessMap == BitmapTexture  then (
					mat.GlossinessMap.coords.mapChannel = uvChannel
			)
			
			
			if isProperty mat "opacityMap" AND mat.opacityMap != undefined AND classOf mat.opacityMap == BitmapTexture then (
					mat.opacityMap.coords.mapChannel = uvChannel
			)
			
			if isProperty mat "OrientationMap" AND mat.OrientationMap != undefined AND classOf mat.OrientationMap == BitmapTexture  then (
					mat.OrientationMap.coords.mapChannel = uvChannel
			)
			
			if isProperty mat "RefractionMap" AND mat.RefractionMap != undefined AND classOf mat.RefractionMap == BitmapTexture  then (
					mat.RefractionMap.coords.mapChannel = uvChannel
			)
			
			
			if isProperty mat "ReflectionMap" AND mat.ReflectionMap != undefined AND classOf mat.ReflectionMap == BitmapTexture then (
					mat.ReflectionMap.coords.mapChannel = uvChannel
			)
			
			if isProperty mat "displacementMap" AND mat.displacementMap != undefined AND classOf mat.displacementMap == BitmapTexture  then (
					mat.displacementMap.coords.mapChannel = uvChannel
			)
			
			if isProperty mat "SelfIllumMap" AND mat.SelfIllumMap != undefined AND classOf mat.SelfIllumMap == BitmapTexture  then (
					mat.SelfIllumMap.coords.mapChannel = uvChannel
			)
			if isProperty mat "specularMap" AND mat.specularMap != undefined AND classOf mat.specularMap == BitmapTexture  then (
					mat.specularMap.coords.mapChannel = uvChannel
			)
			if isProperty mat "filterMap" AND mat.filterMap != undefined AND classOf mat.filterMap == BitmapTexture  then (
					mat.filterMap.coords.mapChannel = uvChannel
			)
		
		
		
		
		
		)
	
	
	
	/*
	 This function will output bitmaps for each used channel in a material.
	*/
	function wallworm_flatten_all_maps mat size:[512,512] baseName:"WWFlattened" basePath:undefined fileType:"tga" uvChannel:1 = (
			if basePath == undefined then (
				basePath = pathConfig.convertPathToAbsolute "image"
				)
			local newMaterial = Standard()
			newMaterial.name = baseName 
			newMaterial.shaderByName =  ddlShaderType.selected	
				
			if isProperty mat "ambientMap" AND mat.ambientMap != undefined then (
					local outfile = basePath + "\\"+baseName+"_amb."+fileType
				
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
				
					rm = renderMap mat.ambientMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.ambientMap = newTex
					showTextureMap newMaterial newMaterial.ambientMap true
			)
			
			if isProperty mat "anisotropyMap" AND mat.anisotropyMap != undefined then (
					local outfile = basePath + "\\"+baseName+"_anis."+fileType
				
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
				
					rm = renderMap mat.anisotropyMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.anisotropyMap = newTex
					showTextureMap newMaterial newMaterial.anisotropyMap true
			)
			
			

			
			
			if isProperty mat "diffuseMap" AND mat.diffuseMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_dif."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.diffuseMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.diffuseMap = newTex
					showTextureMap newMaterial newMaterial.diffuseMap true
				
			)
			
			
			if isProperty mat "DiffuseRoughnessMap" AND mat.DiffuseRoughnessMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_rough."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.DiffuseRoughnessMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.DiffuseRoughnessMap = newTex
					showTextureMap newMaterial newMaterial.DiffuseRoughnessMap true
				
			)
			
			
			
			
			
			
			if isProperty mat "bumpMap" AND mat.bumpMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_bmp."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.bumpMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.bumpMap = newTex
					--showTextureMap newMaterial newMaterial.bumpMap true
			)
			
			if isProperty mat "DiffuseLevelMap" AND mat.DiffuseLevelMap != undefined then (
					local outfile = basePath + "\\"+baseName+"_DifLev."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.DiffuseLevelMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.DiffuseLevelMap = newTex
					--showTextureMap newMaterial newMaterial.DiffuseLevelMap true
			)
			
			if isProperty mat "specularLevelMap" AND mat.specularLevelMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_specLev."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.specularLevelMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.specularLevelMap = newTex
					--showTextureMap newMaterial newMaterial.specularLevelMap true
			)
			
			if isProperty mat "GlossinessMap" AND mat.GlossinessMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_Gloss."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.GlossinessMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.GlossinessMap = newTex
					--showTextureMap newMaterial newMaterial.GlossinessMap true
			)
			
			
			if isProperty mat "opacityMap" AND mat.opacityMap != undefined then (
					local outfile = basePath + "\\"+baseName+"_opac."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.opacityMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.opacityMap = newTex
					--showTextureMap newMaterial newMaterial.opacityMap true
			)
			
			
			if isProperty mat "filterMap" AND mat.filterMap != undefined then (
					local outfile = basePath + "\\"+baseName+"_filt."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.filterMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.filterMap = newTex
					--showTextureMap newMaterial newMaterial.opacityMap true
			)
			
			
			
			
			
			
			if isProperty mat "OrientationMap" AND mat.OrientationMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_Orient."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.OrientationMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.OrientationMap = newTex
					--showTextureMap newMaterial newMaterial.OrientationMap true
			)
			
			if isProperty mat "RefractionMap" AND mat.RefractionMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_Refr."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.RefractionMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.RefractionMap = newTex
					--showTextureMap newMaterial newMaterial.RefractionMap true
			)
			
			
			if isProperty mat "ReflectionMap" AND mat.ReflectionMap != undefined then (
					local outfile = basePath + "\\"+baseName+"_Ref."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.ReflectionMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.ReflectionMap = newTex
					--showTextureMap newMaterial newMaterial.ReflectionMap true
			)
			
			if isProperty mat "displacementMap" AND mat.displacementMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_disp."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.displacementMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.displacementMap = newTex
					--showTextureMap newMaterial newMaterial.displacementMap true
			)
			
			if isProperty mat "SelfIllumMap" AND mat.SelfIllumMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_illum."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.SelfIllumMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.SelfIllumMap = newTex
					--showTextureMap newMaterial newMaterial.SelfIllumMap true
			)
			if isProperty mat "specularMap" AND mat.specularMap != undefined  then (
					local outfile = basePath + "\\"+baseName+"_spec."+fileType
					if doesFileExist (getFilenamePath outfile) == false then (
						makeDir (getFilenamePath outfile) all:true
					)
					rm = renderMap mat.specularMap  size:size filename:outfile display:true
					save rm
					close rm
					local newTex = BitmapTexture filename:outfile
					newTex.name = baseName
					newMaterial.specularMap = newTex
					--showTextureMap newMaterial newMaterial.specularMap true
			)


			wallworm_set_all_mapchannel newMaterial uvChannel
			
		
			return newMaterial
		
		)
	
		
	function wallworm_collect_mats_from_objects objs = (
		
		if objs != undefined AND classOf objs == array AND objs.count > 0 then (
			local theMats = #()
			local newMat
			print objs
			for obj in objs WHERE obj.mat != undefined do (
				--print obj
				wallworm_getStandardMaterials obj.mat &theMats
				
			)
			
			if theMats.count > 0 then (
				print theMats
				newMat = wallworm_create_composites_material theMats
				return newMat
			)
			
		) else (
			print "wrong list type"
			return false
		)
		false
	)	
	
	
	
	
	function getConfigPath = (
		wallworm_matmergeIni = ((symbolicPaths.getPathValue "$userScripts") + "/WallWorm.com/config/matmerge.ini")
		if (wallworm_matmergeIni==undefined OR doesFileExist wallworm_matmergeIni == false) do (
			if (makeDir ((symbolicPaths.getPathValue "$userScripts") + "/WallWorm.com/config") all:true == false ) do (
				print "Config Directory doesn't exist and could not be created."

			)
			wallworm_matmergeIni = ((symbolicPaths.getPathValue "$userScripts") + "/WallWorm.com/config/matmerge.ini")
	
		)
		
		
	)
	
	
	function setConfigForTool = (
		
			/*Store the current settings to reuse next time the tool is opened.*/
			setINISetting wallworm_matmergeIni "Settings" "size" (ddlSize.selected)
			setINISetting wallworm_matmergeIni "Settings" "dir" (edtDir.text)
			setINISetting wallworm_matmergeIni "Settings" "basename" (edtBaseName.text)
			setINISetting wallworm_matmergeIni "Settings" "uvchannel" (spnChannel.value as string)
			setINISetting wallworm_matmergeIni "Settings" "shaderType" ddlShaderType.selected
			if cbxType.selected != undefined then (
				setINISetting wallworm_matmergeIni "Settings" "type" (cbxType.selected)
			)
			
			setINISetting wallworm_matmergeIni "Settings" "shell" (chkShell.checked as string)
			
			

		)

	on WallWormFlattenMaps open do
	(
			getConfigPath()
		
			/*Get defaults from config file and assign them to the UI if present. Otherwise, give defaults.*/
			local size = getINISetting wallworm_matmergeIni "Settings" "size"
			local dir = getINISetting wallworm_matmergeIni "Settings" "dir"
			local basename = getINISetting wallworm_matmergeIni "Settings" "basename"
			local type = getINISetting wallworm_matmergeIni "Settings" "type"
			local chan = getINISetting wallworm_matmergeIni "Settings" "uvchannel"
		
			local shaderType = 	getINISetting wallworm_matmergeIni "Settings" "shaderType"
			
			if shaderType == undefined OR shaderType == "" then (
				shaderType = "Blinn"
			)
		
			if size == undefined or size == "" then (
				size = "1024"
			)
			
			if dir == undefined OR dir == "" then (
				dir = pathConfig.convertPathToAbsolute "$maps"
			)
			
			if basename == undefined OR basename == "" then (
				basename = "FlattenedMaterial"
			)
			if type == undefined OR type=="" then (
				type = "tga"
			)
			
			if chan == undefined OR chan == "" then (
				
				chan = 1
			)
				
			shellAssign = getINISetting wallworm_matmergeIni "Settings" "shell"
			if shellAssign == "" OR shellAssign == "true" then (
				chkShell.checked = true
				
			) else (
				chkShell.checked = false
				)
			
			edtDir.text = dir
			edtBaseName.text = basename
			
			ddlSize.selection = findItem ddlSize.items (size as string)
			
			if (findItem cbxType.items (type as string) )== 0 then (
				
				local tempList = ddlType.items
				append tempList (type as string)
				ddlSize.items = tempList
				
			)
			
			
			cbxType.selection = findItem cbxType.items (type as string)
			
			
			
			if (findItem ddlShaderType.items shaderType )== 0 then (
				
				shaderType = "Blinn"
				
			)
			
			
			ddlShaderType.selection = findItem ddlShaderType.items shaderType
			
			
			spnChannel.value = chan as integer
			
		)
	on btnCreateComposite pressed do
	(
	 if selection.count > 0 then (
		theCurrentMat = wallworm_collect_mats_from_objects (selection as array)
		if theCurrentMat != false then (
	
			btnFlattenMaps.enabled = true
			btnAssignComposites.enabled = true
			) else (
			
				btnFlattenMaps.enabled = false
				btnAssignComposites.enabled = false
				messagebox "No material was created."
			
			)
	 ) else (
				btnFlattenMaps.enabled = false
				btnAssignComposites.enabled = false
		 messagebox "You must select objects first."
			
		 )
	)
	on btnGetDir pressed do
	(
				
				local thePath = getSavePath caption:"Set Flattened Map Directory" initialDir:edtDir.text
				if (thePath != undefined ) then (
					
					edtDir.text = thePath
					setConfigForTool()
					)
				
				
				
			)
	on edtDir entered text do
	(
		setConfigForTool()
	
	)
	on edtBaseName entered text do
	(
		setConfigForTool()
	)
	on btnAssignComposites pressed do
	(
		undo label:"Assign Composited Material" on (
			if theCurrentMat != undefined AND selection.count > 0 then (
				selection.mat = theCurrentMat
				
				)
			)
	)
	on btnFlattenMaps pressed do
	(
		if doesFileExist edtDir.text then (
		size = ddlSize.selected as number
		newMat = wallworm_flatten_all_maps theCurrentMat size:[size,size] baseName:edtBaseName.text basePath:edtDir.text fileType:cbxType.text uvChannel:spnChannel.value
			btnAssignFlatMat.enabled = true
			btnUpdateUVW.enabled =  true
		) else (
			messagebox "The Target Output Folder does not exist! Pick a new output path..."
			--btnAssignFlatMat.enabled = true
			--btnUpdateUVW.enabled =  true
		)
	)
	on btnAssignFlatMat pressed do
	(
		undo label:"Assign Flattened Material" on (
		if newMat != undefined AND selection.count > 0 then (
			if chkShell.checked == false then (
				selection.mat = newMat
			) else (
				
				for obj in selection as array do (
					
					if obj.mat == undefined then (
						
						obj.mat = newMat
						
						) else (
						
						oldMat =  obj.mat
						
						newShell = Shell_Material()
						newShell.name = (edtBaseName.text + "_Shell")
						newShell.originalMaterial = oldMat
						newShell.bakedMaterial = newMat
						newShell.viewportMtlIndex = 1
						obj.mat = newShell
						
						)
					
					
					
					)
				
				)
		)
		)
	)
	on ddlSize selected sel do
	(
		setConfigForTool()
	
	)
	on cbxType changed text do
	(
		setConfigForTool()
	
	)
	on spnChannel changed val do
	(
	setConfigForTool()
	)
	on btnUpdateUVW pressed do
	(
		wallworm_set_all_mapchannel newMat spnChannel.value
	
	)
	on chkShell changed state do
	(
	setConfigForTool()
	)
	on btn26 pressed do
	(
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+edtDir.text+"\""
				execute folderOpen
	
	)
	on ddlShaderType selected sel do
	(
			setConfigForTool()
	
	)
)

createDialog WallWormFlattenMaps   

)
