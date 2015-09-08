/*
Common functions for packing assets. Used by Res File maker and VMF Exporter.

Copyright (c) 2012-2014 by Shawn Olson
http://www.shawnolson.net

All Rights Reserved.

http://dev.wallworm.com

*/


function wallworm_get_soundscape_assets soundscapefile = (
					/*This function returns an array of sound files that are in the soundscape file.*/
					local thewaves = #()
					
					if doesFileExist soundscapefile then (
					
					wavPattern = "\\s+\\\"wave\\\"\\s+\\\"([\w_/.\-!@#<>^\*?$)}]+)"
					dotNetFile = dotNetClass "System.IO.File"
					rx = dotNetClass "System.Text.RegularExpressions.RegEx"
					
						
					local soundscapeContents = dotNetFile.ReadAllText soundscapefile
						
						
					m = rx.match soundscapeContents wavPattern
					
					while m.Success  do (
						 for i = 1 to (m.Groups.count - 1) collect (
							appendIfUnique thewaves (wallworm_safe_path("sound/"+((m.groups.item[1].value)) ))
						 )
						m = m.nextMatch()
					)
					
					
				) else (/*No soundscape found*/)
					

	
				return thewaves
	
	)


	function wallworm_get_assets_from_GLB inp = (
		/*This function returns an array of assets that are listed in the contents of a Convexity Entity (like ambient_generic, prop_static, etc)*/
					local theassets = #()
					assetPattern = ",([\w_/.\-!@#<>^\*?$)}]+)"
					rx = dotNetClass "System.Text.RegularExpressions.RegEx"
					m = rx.match inp assetPattern
					--allowedTypes = #(".wav",".mp3",".mdl",".mp4")
					while m.Success  do (
						 for i = 1 to (m.Groups.count - 1) collect (
							 
							 local theType = toLower (getFileNameType m.groups.item[1].value)
							 if theType == undefined OR theType == "" do continue
							 case theType of (
								 ".wav" : theRoot = "sound/"
								 ".mp3" : theRoot = "sound/"
								 ".mdl" : theRoot = "models/"
								 ".vmt" : theRoot = "materials/"
								 default : continue
							)
							 
							appendIfUnique theassets (wallworm_safe_path (theRoot+m.groups.item[1].value))
						 )
						m = m.nextMatch()
					)
					

					
				return theassets
		
		)
	

function wallworm_res_to_array resfile = (
					/*This function returns an array of assets from a res file.*/
					local theassets = #()
					
					if doesFileExist resfile then (
					
					wavPattern = "\s+\"([\w_/.\-!@#<>^\*?$)}]+)\" \"file\""
					dotNetFile = dotNetClass "System.IO.File"
					rx = dotNetClass "System.Text.RegularExpressions.RegEx"
					
						
					local resContents = dotNetFile.ReadAllText resfile
						
						
					m = rx.match resContents wavPattern
					
					while m.Success  do (
						 for i = 1 to (m.Groups.count - 1) collect (
							appendIfUnique theassets (wallworm_safe_path(((m.groups.item[1].value)) ))
						 )
						m = m.nextMatch()
					)
					
					
				) else (/*No res file found*/)
					
	theassets
)
		

function wallworm_collect_assets_from_scene wwmt:true wwmtMaterials:true cvxModels:true sky:true soundscape:true worldMaterials:true mapname:undefined isRes:false vmfsettings:undefined resAndPak:false vbsp:true = (
	
	
	collection = objects as array
	
	more = wallworm_get_all_objects()
	if more.count > 0 then (
		join collection more
	)
	
	
	/*
	
	This function returns an array of all the Assets (MDL, VMT, VTF, TXT, DDS, RES, BSP, SWF) 
	that Wall Worm knows how to collect from the Scene and associated files. 
	
	Since many files are dependant on the map's name, it is important for the user to pass the correct map name.
	
	*/
	
	local wwmt_res_list = #()
	--local wwmt_used_materials = #()

	macros.run "wallworm.com" "WallWormRepairDXRenderMatNamesMCR"

	


	local vbspmats = #()
	
	if isRes == true then (
		appendIfUnique wwmt_res_list ("maps/"+mapname+".bsp")
		appendIfUnique wwmt_res_list ("maps/"+mapname+".res")
	)
	
	global wwmt_gameInfoDir
	local gameDir = wwmt_gameInfoDir
	
	/*if wwmt_gameInfoDir == undefined OR wwmt_gameInfoDir == "" then (
		gameDir = (dotnetclass "System.Environment").GetEnvironmentVariable("VProject")
	)

	if mapname != undefined then (
		print mapname
		)
	*/

	
		


	
	if mapname != undefined AND wwmt_gameInfoDir != undefined AND gameDir != "" then (
		

		
		if isRes == true then (
			
			if doesFileExist (gameDir+"\\maps\\"+mapname+".txt" ) then (
				appendIfUnique wwmt_res_list ("maps/"+mapname+".txt")
			)

			
			if doesFileExist (gameDir+"\\maps\\"+mapname+".jpg" ) then (
				appendIfUnique wwmt_res_list ("maps/"+mapname+".jpg")
			)
			
			/*It appears Overview DDS files will only load if inside the RES File*/
			if doesFileExist (gameDir+"\\resource\\overviews\\"+mapname+".dds" ) then (
				appendIfUnique wwmt_res_list ("resource/overviews/"+mapname+".dds")
			)
			if doesFileExist (gameDir+"\\resource\\overviews\\"+mapname+"_radar.dds" ) then (
				appendIfUnique wwmt_res_list ("resource/overviews/"+mapname+"_radar.dds")
			)
			/*In all of my tests... PAKing a KV file messes up on the server.*/
			if doesFileExist (gameDir+"\\maps\\"+mapname+".kv" ) then (
				appendIfUnique wwmt_res_list ("maps/"+mapname+".kv")
			)
			
			/*Don't PAK the NAV file since a server may want to customize this for their own needs.*/
			if doesFileExist (gameDir+"\\maps\\"+mapname+".nav" ) then (
				appendIfUnique wwmt_res_list ("maps/"+mapname+".nav")
			)	
			
			if doesFileExist (gameDir+"\\materials\\vgui\\backgrounds\\maps\\"+mapname+".vmt" ) then (
				appendIfUnique wwmt_res_list ("materials/vgui/backgrounds/maps/"+mapname+".vmt")
			)
			if doesFileExist (gameDir+"\\materials\\vgui\\backgrounds\\maps\\"+mapname+".vtf" ) then (
				appendIfUnique wwmt_res_list ("materials/vgui/backgrounds/maps/"+mapname+".vtf")
			)	
			

			
			
			if doesFileExist (gameDir+"\\materials\\vgui\\mp_sp_screens\\"+mapname+".vmt" ) then (
				appendIfUnique wwmt_res_list ("materials/vgui/mp_sp_screens/"+mapname+".vmt")
			)
			if doesFileExist (gameDir+"\\materials\\vgui\\mp_sp_screens\\"+mapname+".vtf" ) then (
				appendIfUnique wwmt_res_list ("materials/vgui//mp_sp_screens/"+mapname+".vtf")
			)
			
			
			if doesFileExist (gameDir+"\\materials\\vgui\\gfx\\vgui\\summary_maps\\summary_"+mapname+".vmt" ) then (
				appendIfUnique wwmt_res_list ("materials/vgui/gfx/vgui/summary_maps/summary_"+mapname+".vmt")
			)
			
			if doesFileExist (gameDir+"\\materials\\vgui\\gfx\\vgui\\summary_maps\\summary_"+mapname+".vtf" ) then (
				appendIfUnique wwmt_res_list ("materials/vgui/gfx/vgui/summary_maps/summary_"+mapname+".vtf")
			)
			
		)
		
		
		


		
		if doesFileExist (gameDir+"\\maps\\cfg\\"+mapname+".cfg" ) then (
			appendIfUnique wwmt_res_list ("maps/cfg/"+mapname+".cfg")
		)
		
		
		if doesFileExist (gameDir+"\\maps\\soundcache\\"+mapname+".cache" ) then (
			appendIfUnique wwmt_res_list ("maps/soundcache/"+mapname+".cache")
		)
		
		if doesFileExist (gameDir+"\\maps\\soundcache\\"+mapname+".manifest" ) then (
			appendIfUnique wwmt_res_list ("maps/soundcache/"+mapname+".manifest")
		)
		
		
		if doesFileExist (gameDir+"\\maps\\"+mapname+"_commentary.txt" ) then (
			appendIfUnique wwmt_res_list ("maps/"+mapname+"_commentary.txt")
		)		
		
		if doesFileExist (gameDir+"\\maps\\"+mapname+".ent" ) then (
			appendIfUnique wwmt_res_list ("maps/"+mapname+".ent")
		)
		
		
		if doesFileExist (gameDir+"\\maps\\"+mapname+"_manifest.txt" ) then (
			appendIfUnique wwmt_res_list ("maps/"+mapname+"_manifest.txt")
		)
		
		if doesFileExist (gameDir+"\\particles\\"+mapname+"_manifest.txt" ) then (
			appendIfUnique wwmt_res_list ("particles/"+mapname+"_manifest.txt")
		)
		
		if doesFileExist (gameDir+"\\maps\\"+mapname+"particles.txt" ) then (
			appendIfUnique wwmt_res_list ("maps/"+mapname+"particles.txt")
		)
		
		if doesFileExist (gameDir+"\\maps\\"+mapname+"_exclude.lst" ) then (
			appendIfUnique wwmt_res_list ("maps/"+mapname+"_exclude.lst")
		)
		
		
		if doesFileExist (gameDir+"\\scripts\\soundscapes_"+mapname+".txt" ) then (
			appendIfUnique wwmt_res_list ("scripts/soundscapes_"+mapname+".txt")
		)
		
		if doesFileExist (gameDir+"\\materials\\overviews\\"+mapname+".vmt" ) then (
			appendIfUnique wwmt_res_list ("materials/overviews/"+mapname+".vmt")
		)
		
		if doesFileExist (gameDir+"\\materials\\overviews\\"+mapname+".vtf" ) then (
			appendIfUnique wwmt_res_list ("materials/overviews/"+mapname+".vtf")
		)

		if doesFileExist (gameDir+"\\materials\\overviews\\"+mapname+"_radar.vmt" ) then (
			appendIfUnique wwmt_res_list ("materials/overviews/"+mapname+"_radar.vmt")
		)
		
		if doesFileExist (gameDir+"\\materials\\overviews\\"+mapname+"_radar.vtf" ) then (
			appendIfUnique wwmt_res_list ("materials/overviews/"+mapname+"_radar.vtf")
		)

		
		if doesFileExist (gameDir+"\\materials\\mapDesc\\"+mapname+".jpg" ) then (
			appendIfUnique wwmt_res_list ("materials/mapDesc/"+mapname+".jpg")
		)
		
		if doesFileExist (gameDir+"\\materials\\vgui\\maps\\menu_thumb_"+mapname+".vmt" ) then (
			appendIfUnique wwmt_res_list ("materials/vgui/maps/menu_thumb_"+mapname+".vmt")
		)
		
		if doesFileExist (gameDir+"\\materials\\vgui\\maps\\menu_thumb_"+mapname+".vtf" ) then (
			appendIfUnique wwmt_res_list ("materials/vgui/maps/menu_thumb_"+mapname+".vtf")
		)
		
		if doesFileExist (gameDir+"\\resource\\overviews\\"+mapname+".txt" ) then (
			appendIfUnique wwmt_res_list ("resource/overviews/"+mapname+".txt")
		)

		
		if doesFileExist (gameDir+"\\resource\\flash\\loading-"+mapname+".swf" ) then (
			appendIfUnique wwmt_res_list ("resource/flash/loading-"+mapname+".swf")
		)
		
	)
	

	
	--get all wwmt models
	if wwmt == true OR wwmtMaterials==true then (
					    local wwmts = 0
					    local failed = #()
					    clearSelection()
						for obj in collection  WHERE ( getUserProp obj "wwmt_source_helper" != undefined) do (
							
							isWWMTSource = getUserProp obj "wwmt_source_helper"	
							 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel obj tempWWMT
								 
										if wwmt == true then (
											appendIfUnique wwmt_res_list ("models/"+(tempWWMT.modelPath)+"/"+(toLower tempWWMT.modelName)+".mdl")
											appendIfUnique wwmt_res_list ("models/"+(tempWWMT.modelPath)+"/"+(toLower tempWWMT.modelName)+".vvd")
											appendIfUnique wwmt_res_list ("models/"+(tempWWMT.modelPath)+"/"+tempWWMT.modelName+".sw.vtx")
											appendIfUnique wwmt_res_list ("models/"+(tempWWMT.modelPath)+"/"+tempWWMT.modelName+".dx80.vtx")
											appendIfUnique wwmt_res_list ("models/"+(tempWWMT.modelPath)+"/"+tempWWMT.modelName+".dx90.vtx")
									 
											if tempWWMT.hulls.count > 0 OR tempWWMT.autoHull == true then (
												appendIfUnique wwmt_res_list ("models/"+(tempWWMT.modelPath)+"/"+tempWWMT.modelName+".phy")
											)
										) else ()
								 
										if wwmtMaterials == true then (
										tempWWMT.populateMyMaterials()
											--where (findItem wwmt_used_materials m == 0)
										for m in tempWWMT.materials  do (
											if m.mat1 == undefined then (
												m.mat1 = m.mat
												)
											--appendIfUnique wwmt_used_materials m
												
											if wwmt_oldModelVTFPath == true then (
			
											wwmt_vtfMmatPath = tempWWMT.materialPath
											) else (
											
											wwmt_vtfMmatPath = ""
											
											)	
																				
												
											try (
												appendIfUnique wwmt_res_list ("materials/"+tempWWMT.materialPath+"/"+(wallworm_getMaterialName m.mat1 forModel:true)+".vmt") 
												if m.diff != undefined do (
													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.mat1.diffuseMap forcePath:wwmt_vtfMmatPath))+".vtf") 
												)
											) catch()
											try (
												if m.bump != undefined do (
													--appendIfUnique wwmt_res_list (("materials/"+(tempWWMT.materialPath)+"/") + (getFileNameFile m.bump)+".vmt") 
													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.mat1.bumpMap forcePath:wwmt_vtfMmatPath))+".vtf") 
													)
											) catch()
											try (
												if m.ambient != undefined do (
													--appendIfUnique wwmt_res_list (("materials/"+(tempWWMT.materialPath)+"/") + (getFileNameFile m.ambient)+".vmt") 
													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.mat1.ambientMap forcePath:wwmt_vtfMmatPath))+".vtf") 
												)
											) catch()
											try (
												if m.normal != undefined do (
													--appendIfUnique wwmt_res_list (("materials/"+(tempWWMT.materialPath)+"/") + (getFileNameFile m.normal)+".vmt") 
													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.mat1.displacementMap forcePath:wwmt_vtfMmatPath))+".vtf") 
											)
											) catch()
											try (
												if m.spec != undefined do (
													--appendIfUnique wwmt_res_list (("materials/"+(tempWWMT.materialPath)+"/") + (getFileNameFile m.spec)+".vmt") 
													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.mat1.specularMap forcePath:wwmt_vtfMmatPath))+".vtf") 
												)
											) catch()
											try (
												if m.specLevelMap != undefined do (
													--appendIfUnique wwmt_res_list (("materials/"+(tempWWMT.materialPath)+"/") + (getFileNameFile m.specLevelMap)+".vmt") 
													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.mat1.specularLevelMap forcePath:wwmt_vtfMmatPath))+".vtf") 
												)
											) catch()
											try (
												if m.illum != undefined do (
													--appendIfUnique wwmt_res_list (("materials/"+(tempWWMT.materialPath)+"/") + (getFileNameFile m.illum)+".vmt") 
													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.mat1.selfIllumMap forcePath:wwmt_vtfMmatPath))+".vtf") 
												)
											) catch()
		
											try (
												if m.detail != undefined do (
													--appendIfUnique wwmt_res_list (("materials/"+(tempWWMT.materialPath)+"/") + (getFileNameFile m.illum)+".vmt") 
													detailMap = wallworm_detailMapTex m.mat1
													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap detailMap forcePath:wwmt_vtfMmatPath))+".vtf") 
												)
											) catch()
										
											try (
												if m.lightwarptexture != undefined do (

													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.lightwarptexture forcePath:wwmt_vtfMmatPath))+".vtf") 
												)
											) catch()
											
											try (
												if m.reflectionMap != undefined do (
													
													if classof m.reflectionMap == Reflect_Refract AND m.reflectionMap.outputname != undefined AND m.reflectionMap.outputname  != ""  then (
														
														
														
														local n = getFileNameFile m.reflectionMap.outputname
														
														n = ( substituteString n "_UP" "")
														
														appendIfUnique wwmt_res_list ("materials/"+(wallworm_remove_last_slash (wallworm_safe_path (m.reflectionMap.name)))+"/"+n+".vtf") 
														
														
													) else (
														appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.reflectionMap forcePath:wwmt_vtfMmatPath))+".vtf") 
													)
													


												)
											) catch(
												--print (getCurrentException())
												)
											
											
										)
										
									)
										
										
								 
								 
							 )
							 
						 )

			)
					 
			
	
			
			
			
	if vbsp == true then (

		
		
		

		for d in collection where classof d == WallWormDetailProp AND  d.model != undefined AND d.model != "" do (
			appendIfUnique wwmt_res_list (d.model)
			
			if d.mat != undefined then (
				appendIfUnique vbspmats d.mat 
			)
			
		)
		
		
		local detMats = for d in collection where classof d == WallWormDetailProp AND (d.model ==undefined OR d.model == "") AND d.mat != undefined collect d.mat 
			
		detMats = makeUniqueArray detMats
		
		if detMats.count > 0 then (

			for m in detMats do (

				appendIfUnique vbspmats m
			)
			
		)

		
		
		if isProperty rootNode "DetailSprites" then ( 
			
			
			if rootNode.DetailSprites != "" then (
				
				local detMatFile = rootNode.DetailSprites
				if getFileNameType detMatFile == "" then (
					
					detMatFile += ".vmt"
				)
				
				appendifUnique wwmt_res_list ("materials/"+detMatFile)
			)
		) else (
		
		
		if vmfsettings == undefined  then (
			global wallworm_file_vmf_presets
			if wallworm_file_vmf_presets != undefined then (
				vmfsettings = wallworm_file_vmf_presets
			)
		)

		if vmfsettings != undefined AND vmfsettings.DetailSprites != undefined AND vmfsettings.DetailSprites != "" then (
			
				local detMatFile = vmfsettings.DetailSprites
				if getFileNameType detMatFile == "" then (
					
					detMatFile += ".vmt"
				)
				
				appendifUnique wwmt_res_list ("materials/"+detMatFile)
			

		)
	) 
		

			
	)
			
					 
	if sky==true then (
					 
		gotsky = false
		
		
		for s in collection while gotsky == false where (isDeleted s ==false)  do (
			
			
			if vmfsettings != undefined AND vmfsettings.skyName != undefined AND vmfsettings.skyName != "" then (
				
				skyn = vmfsettings.skyName
				
				
				) else (
				
					skyn = getUserProp s "wwsw_skyname"
				)
			
			
			
			if skyn != undefined AND skyn != "" do (
				
				--appendIfUnique wwmt_used_materials s.mat
				
				
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrft.hdr.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrft.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"ft.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"ft.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrbk.hdr.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrbk.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"bk.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"bk.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrlf.hdr.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrlf.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"lf.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"lf.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrrt.hdr.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrrt.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"rt.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"rt.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrdn.hdr.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrdn.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"dn.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"dn.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrup.hdr.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"_hdrup.vmt")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"up.vtf")
				appendIfUnique wwmt_res_list ("materials/skybox/"+skyn+"up.vmt")
				
				
				
				gotsky = true
				
				)
			
			)
		
		)



					 
		 
					 
	ww_brushmaterials = #()
	

			
	if vbsp == true AND WallWormDetailProp != undefined AND vbspmats != undefined AND vbspmats.count > 0   then (
		
		
		for m in vbspmats do (
			if isProperty m "valveShader" AND m.valveShader != undefined AND m.valveShader != "" then (
			vshader = m.valveShader	
			) else (
				vshader= "UnlitGeneric"
			)
			wallworm_appendBitmaps m ww_brushmaterials vshaderr coords:true
		)
	)		
			
			
			
			
	if worldMaterials == true then (		
	--(findItem wwmt_used_materials i.mat) ==0 AND 
	for i in collection WHERE ((getUserProp i "wwdt_brush_geometry_export" != undefined and getUserProp i "wwdt_brush_geometry_export" == true) OR (getUserProp i "ww_wwdt_displacement_brush") != undefined)  do (
	
		if i.mat != undefined do (
			
			if classOf i.mat == Blend then ( 
				
				shaderType = "WorldVertexTransition"
				
				) else (
				shaderType = "UnLitGeneric"
				)
			
			wallworm_appendBitmaps i.mat ww_brushmaterials shaderType coords:true
		)
	
	)
)

if ww_brushmaterials.count > 0 then (
	--where (findItem wwmt_used_materials m.mat == 0)
											for m in ww_brushmaterials  do (
												try (
													
											if m.mat1 == undefined then (
												m.mat1 = m.mat
												)
													
													
													--appendIfUnique wwmt_used_materials m.mat
													
													--m.matName=m.mat.name
													m.forModel=false
													--m.valveShader="LightmappedGeneric"
													
													--
												if (m.materialPath != undefined AND m.materialPath != "") then (
													--m.setMaterialPath m.matName
													
												) 
												
												if (m.materialPath != undefined AND m.materialPath != "") then (
							
													mpstring = m.materialPath+"/"
												) else (
													mpstring = m.mat.name+"/"
													
													)
													
		if wwmt_oldModelVTFPath == true then (
			
			
			materialPath =  m.getMaterialPathForMat m.mat1.mat
			
			if materialPath == "" then (
			wwmt_vtfMmatPath = m.matName
			) else (
				wwmt_vtfMmatPath = materialPath
			)
			
			
			) else (
			
			wwmt_vtfMmatPath = ""
			
			)
													
													
													
													
												
											appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+((wallworm_getMaterialName m.mat)+".vmt") ))

											try (
												if m.diff != undefined do (
													--appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(mpstring + (getFileNameFile m.diff)+".vmt") ))
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat1.diffuseMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											

											try (
												if m.blendmodulate != undefined AND classof m.blendmodulate == BitmapTexture then (
													--appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(mpstring + (getFileNameFile m.diff)+".vmt") ))
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.blendmodulate forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											
											
											try (
												if m.bump != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring + (getFileNameFile m.bump)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat1.bumpMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
													)
											) catch()
											try (
												if m.ambient != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring + (getFileNameFile m.ambient)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat1.ambientMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
												if m.normal != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring +  (getFileNameFile m.normal)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat1.displacementMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
											)
											) catch()
											try (
												if m.spec != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring + (getFileNameFile m.spec)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat1.specularMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
												if m.specLevelMap != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring + (getFileNameFile m.specLevelMap)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat1.specularLevelMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
												if m.illum != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring +  (getFileNameFile m.illum)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat1.selfIllumMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
											if m.detail != undefined do (
												detailMap = wallworm_detailMapTex m.mat1
												appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap detailMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch ()
											
											try (
												if m.lightwarptexture != undefined do (

													appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.lightwarptexture forcePath:wwmt_vtfMmatPath))+".vtf") 
												)
											) catch()
											
											try (
												if m.reflectionMap != undefined do (
													
													if classof m.reflectionMap == Reflect_Refract AND m.reflectionMap.outputname != undefined AND m.reflectionMap.outputname  != ""  then (
														
														
														
														local n = getFileNameFile m.reflectionMap.outputname
														
														n = ( substituteString n "_UP" "")
														
														appendIfUnique wwmt_res_list ("materials/"+(wallworm_remove_last_slash (wallworm_safe_path (m.reflectionMap.name)))+"/"+n+".vtf") 
														
														
													) else (
														appendIfUnique wwmt_res_list ("materials/"+((wallworm_getVTFPathFromBitmap m.reflectionMap forcePath:wwmt_vtfMmatPath))+".vtf") 
													)
													


												)
											) catch(
												--print (getCurrentException())
												)
											
											
											
											
											if m.mat2 != undefined then (
												

											try (
												if m.diff2 != undefined do (
													--appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(mpstring + (getFileNameFile m.diff)+".vmt") ))
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat2.diffuseMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
												if m.bump2 != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring + (getFileNameFile m.bump)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat2.bumpMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
													)
											) catch()
											try (
												if m.ambient2 != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring + (getFileNameFile m.ambient)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat2.ambientMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
												if m.normal2 != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring +  (getFileNameFile m.normal)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat2.displacementMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
											)
											) catch()
											try (
												if m.spec2 != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring + (getFileNameFile m.spec)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat2.specularMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
												if m.specLevelMap2 != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring + (getFileNameFile m.specLevelMap)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat2.specularLevelMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
												if m.illum2 != undefined do (
													--appendIfUnique wwmt_res_list ("materials/"+mpstring +  (getFileNameFile m.illum)+".vmt") 
													appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap m.mat2.selfIllumMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch()
											try (
											if m.detail2 != undefined do (
												detailMap = wallworm_detailMapTex m.mat2
												appendIfUnique wwmt_res_list (wallworm_safe_path("materials/"+(wallworm_getVTFPathFromBitmap detailMap forcePath:wwmt_vtfMmatPath)+".vtf")) 
												)
											) catch ()
												
												
												
												)
											
											


												
										) catch(
											print (getCurrentException())
											
											)
										)
					)

				
				
				if soundscape == true then (
					

					
					soundscapefile = wwmt_gameInfoDir + "\\maps\\"+mapname+"_level_sounds.txt" 
					
					sounds = wallworm_get_soundscape_assets (wwmt_gameInfoDir + "\\scripts\\soundscapes_"+mapname+".txt")
					if sounds.count > 0 then (
						join wwmt_res_list sounds
					)

					sounds = wallworm_get_soundscape_assets (wwmt_gameInfoDir + "\\maps\\"+mapname+"_level_sounds.txt" )
					if sounds.count > 0 then (
						join wwmt_res_list sounds
					)
	
				)
				
				if cvxModels == true then (
					
					for ent in collection WHERE isProperty ent "wallworm" == true AND isProperty ent "exportProps" == true do (
						for property in ent.exportProps do (
							val = (getProperty ent property)
							local theType = toLower (getFileNameType (val as string))
							if theType == undefined OR theType == "" do continue
							case theType of (
								".wav" : theRoot = "sound/"
								".mp3" : theRoot = "sound/"
								".mdl" : theRoot = "models/"
								".vmt" : theRoot = "materials/"
								default : continue
							)
							appendIfUnique wwmt_res_list (wallworm_safe_path (theRoot+val))
						)
						
					)
					
					for ent in collection WHERE (getuserprop ent "GLBPntValu" != undefined) AND ( getUserProp ent "wwmt_source_helper" == undefined) do (
						
						assets = wallworm_get_assets_from_GLB (getuserprop ent "GLBPntValu")
						if assets.count > 0 then (
							
							join wwmt_res_list assets
						)
						
					)
					
					
				)
			
			wwmt_res_list = makeUniqueArray wwmt_res_list
				
		return wwmt_res_list
	)