
--include "ww_struct_mat.ms"
include "$scripts/WallWorm.com/common/matfuncs1.ms"
include "$scripts/WallWorm.com/common/ww_struct_mat.ms"
wwProceedTexCompile = wallworm_canCompileTextures model:true
if wwProceedTexCompile == true then (
ww_scene_lods.populateMyMaterials()	

	
if ww_scene_lods.materials.count > 0 then (
	
	
str = "wwTextureExporter = newRolloutFloater \"Wall Worm Model Tools Texture Exporter 3.2\" 800 800 10 10\n"
eventHandlersStrings = ""
	
append str "include \"$scripts/WallWorm.com/common/ww_struct_mat.ms\"\n\n"
append str "include \"$scripts/WallWorm.com/common/config.ms\"\n\n"
append str "rollout textureFields \"Wall Worm Model Tools Texture Exporter\" width:790 height:790 (\n\n"
y =10
	num = 1
	matNum = 1
	sendToVtex = ""
	onOpenStr = ""
	global wwmt_oldModelVTFPath
	for m in ww_scene_lods.materials do (
		try(
			
		if m.mat1 == undefined then m.mat1 = m.mat
		
		if wwmt_oldModelVTFPath == true then (
			wwmt_vtfMmatPath = ww_scene_lods.materialPath
		) else (
			wwmt_vtfMmatPath = ""
		)

		m.matName = wallworm_getMaterialName m.mat1 forModel:true
			/*
			if m.getNameFromPath == false then (	) else (
			m.matName = wallworm_getMaterialName m.mat1 forModel:false
			print "LOD get name from path"
			)*/
		--append str (" group \""m.mat.name"\" (\n")

		--append sendToVtex str ("label lblmat"+(matNum as string)+" \"Material "+m.mat.name+"\" pos:[5,"+y as string+"] width:780 height:15\n\n")
		--
			try (
				
				
				targetmatname = (wwmt_gameInfoDir+"\\materials\\"+ww_scene_lods.materialPath+"\\"+m.matName+".vmt")
				/*if m.getNameFromPath == false then () else (
					
					targetmatname = (wwmt_gameInfoDir+"\\materials\\"+m.matName+".vmt")
					
					)*/
				if doesFileExist (targetmatname) == true then (
					ch = "false"

					) else (
					ch = "true"
					
					)
				
				
				
				append str ("checkbox chk_VMT"+matNum as string+" \"\" pos:[5,"+y as string+"] width:20 height:15 checked:"+ch+" toolTip:\"Write the VMT file as well as export the texture.\"\n\n")
				append str("label lblmat"+(matNum as string)+" \"VMT Material: ("+(m.valveShader)+") "+ww_scene_lods.materialPath+"/"+ m.matName +".vmt\" pos:[25,"+y as string+"] width:780 height:15\n\n")
				append sendToVtex("ww_scene_lods.materials["+matNum as string+"].setTransforms()\n")
				--print s
				) catch(
				print (getCurrentException())
				
				)
				y = y +17
		
			
		if m.diff != undefined then (

			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.diffuseMap  size:[15,15])\n")
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
			
			if wallworm_mat_name_limit_check (getFilenameFile m.diff) == false then (
				append str ("checkbox chk"+num as string+" \"Diffuse VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.diffuseMap) as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
			status = m.checkDimensions(m.diff)		
			if (status[1]==true AND status[2]==true) then (
				
				
				vtfname = (wallworm_getVTFPathFromBitmap m.mat1.diffuseMap forcePath:wwmt_vtfMmatPath) 
				targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
				if doesFileExist (targetmatname) == true then (
					ch = "false"

				) else (
					ch = "true"
					
				)

		if wwmt_oldModelVTFPath == true then (
			vtfP = ww_scene_lods.materialPath
			en = "false"
			) else (
			
			vtfP = m.mat1.diffuseMap.name
			en = "true"
		)
			
		vtfP = wallworm_bsToFs vtfP
		
			append str ("checkbox chk"+num as string+" \"Diffuse VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.diff)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\nww_scene_lods.materials["+matNum as string+"].mat1.diffuseMap.name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap ww_scene_lods.materials["+matNum as string+"].mat1.diffuseMap forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = (ww_scene_lods.materials["+matNum as string+"].mat1.diffuseMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\nww_scene_lods.materials["+matNum as string+"].mat1.diffuseMap.name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap ww_scene_lods.materials["+matNum as string+"].mat1.diffuseMap forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = (ww_scene_lods.materials["+matNum as string+"].mat1.diffuseMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

					

				
				append sendToVtex( "if chk"+num as string+".checked do (\n")
				
				
				append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat.diffuseMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\""+ww_scene_lods.compression+"\" norm:false\n")
				append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat.diffuseMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
				

				--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].mat.diffuseMap \"diff\" \n")
				append sendToVtex ")\n\n"
				
			)	else (
				append str ("checkbox chk"+num as string+" \"Diffuse VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.diffuseMap) as string)+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				)		
			)


		) else (
			/*
				local dirnotice = " (WILL HAVE TO COPY VMT from SDK to Game!!!)"
				if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" do (
					dirnotice = ""
					
					)
				
				append str ("checkbox chk"+num as string+" \"Diffuse COLOR"+dirnotice+"\" pos:[24,"+y as string+"] width:780 height:15\n\n")
				append sendToVtex( "if chk"+num as string+".checked do (\n")
				append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].mat.diffuseMap \"diff\" \n")
				append sendToVtex ")\n\n"*/
				)
		y = y +17
				
				append sendToVtex( "if chk_VMT"+matNum as string+".checked do (\n")
				append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].mat1.diffuseMap \"diff\" writeVMT:true exportVTF:false\n")
				append sendToVtex ")\n\n"				
				
		num = num + 1		



				
				
				
		groupY = 10
		if m.bump != undefined do (
			
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap (wallworm_bumpMapTex ww_scene_lods.materials["+matNum as string+"].mat1)  size:[15,15])\n")

					

				bumpMap = wallworm_bumpMapTex	m.mat1

				
				if wallworm_mat_name_limit_check (getFilenameFile m.bump) == false then (
					append str ("checkbox chk"+num as string+" \"Bump VTF: "+((wallworm_getVTFPathFromBitmap bumpMap) as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
				
					status = m.checkDimensions(m.bump)	
					if (status[1]==true AND status[2]==true) then (
						
						vtfname = (wallworm_getVTFPathFromBitmap m.mat1.bumpMap forcePath:wwmt_vtfMmatPath) 
						targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
						if doesFileExist (targetmatname) == true then (
							ch = "false"

						) else (
							ch = "true"
							
						)
						
		if wwmt_oldModelVTFPath == true then (
			vtfP = ww_scene_lods.materialPath
			en = "false"
			) else (
			
			vtfP = bumpMap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP
						
			append str ("checkbox chk"+num as string+" \"Bump VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.bump)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n bumpMap = wallworm_bumpMapTex ww_scene_lods.materials["+matNum as string+"].mat1\nbumpMap.name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap bumpMap forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = (bumpMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n bumpMap = wallworm_bumpMapTex ww_scene_lods.materials["+matNum as string+"].mat1\nbumpMap.name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap bumpMap forcePath:ww_scene_lods.materialPath)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

				
						append sendToVtex( "if chk"+num as string+".checked do (\n")
					
						append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat.bumpMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\"\" norm:true\n")
						append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat.bumpMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
						
						
						
						--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].bump \"bump\" \n")
						append sendToVtex ")\n\n"
					)	else (
						append str ("checkbox chk"+num as string+" \"Bump VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.bumpMap) as string)+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					
					)	
				)

			y = y +17
			num = num + 1
			
			
			
			
		)
		
		
		if m.detail != undefined do (
			
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap (wallworm_detailMapTex	ww_scene_lods.materials["+matNum as string+"].mat1)  size:[15,15])\n")
			
			if m.detail != m.diff then (
				if wallworm_mat_name_limit_check (getFilenameFile m.detail) == false then (
					append str ("checkbox chk"+num as string+" \"Detail: "+(m.detail as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
					status = m.checkDimensions(m.detail)	
					if (status[1]==true AND status[2]==true) then (
						
						
						
					detailMap = wallworm_detailMapTex m.mat1
					
						
						vtfname = (wallworm_getVTFPathFromBitmap detailMap forcePath:wwmt_vtfMmatPath) 
						targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
						if doesFileExist (targetmatname) == true then (
							ch = "false"

						) else (
							ch = "true"
							
						)	
						
		if wwmt_oldModelVTFPath == true then (
			vtfP = ww_scene_lods.materialPath
			en = "false"
			) else (
			
			vtfP = detailMap.name
			en = "true"
		)
		vtfP = wallworm_bsToFs vtfP
			append str ("checkbox chk"+num as string+" \"Detail VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.detail)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\ndetailMap = (wallworm_detailMapTex ww_scene_lods.materials["+matNum as string+"].mat1)\ndetailMap.name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap detailMap forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = (detailMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\ndetailMap = (wallworm_detailMapTex ww_scene_lods.materials["+matNum as string+"].mat1)\ndetailMap.name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap detailMap forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = (detailMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

					
					
					append sendToVtex( "if chk"+num as string+".checked do (\n")
						

						
						append sendToVtex("wallworm_copy_bitmap_to_sdk (wallworm_detailMapTex ww_scene_lods.materials["+matNum as string+"].mat1) forcePath:\""+wwmt_vtfMmatPath+"\" compression:\""+ww_scene_lods.compression+"\" norm:false\n")
						append sendToVtex("wallworm_write_vtf_bat (wallworm_detailMapTex ww_scene_lods.materials["+matNum as string+"].mat1)  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
				
						
						--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].detail \"detail\" \n")
						append sendToVtex ")\n\n"
					) else (
						append str ("checkbox chk"+num as string+" \"Detail: "+m.detail+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
						
						)
					)
			) else (
					append str("label lblnum"+(num as string)+" \"Detail is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
			
			
		)
		
		
			
		if m.ambient != undefined do (
			
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.ambientMap  size:[15,15])\n")
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
			
			if m.ambient != m.diff then (
				
				if wallworm_mat_name_limit_check (getFilenameFile m.ambient) == false then (
					append str ("checkbox chk"+num as string+" \"AO VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.ambientMap) as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
				
					status = m.checkDimensions(m.ambient)	
					if (status[1]==true AND status[2]==true) then (
						
						vtfname = (wallworm_getVTFPathFromBitmap m.mat1.ambientMap forcePath:wwmt_vtfMmatPath) 
						targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
						if doesFileExist (targetmatname) == true then (
							ch = "false"

						) else (
							ch = "true"
							
						)	
		if wwmt_oldModelVTFPath == true then (
			vtfP = ww_scene_lods.materialPath
			en = "false"
			) else (
			
			vtfP = m.mat1.ambientMap.name
			en = "true"
		)
				
		vtfP = wallworm_bsToFs vtfP
		
			append str ("checkbox chk"+num as string+" \"AO VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.ambient)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.ambientMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

					
						
						
						
						append sendToVtex( "if chk"+num as string+".checked do (\n")
						

						
						append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat.ambientMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\""+ww_scene_lods.compression+"\" norm:false\n")
						append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat.ambientMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
						
						
						--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].ambient \"ambient\" \n")
						append sendToVtex ")\n\n"
					) else(
							append str ("checkbox chk"+num as string+" \"AO VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.ambientMap) as string)t+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					)
				)
			) else (
					append str("label lblnum"+(num as string)+" \"Ambient is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			
			y = y +17
			num = num + 1
			
			
			
			
		)
			
		if m.normal != undefined do (
			
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap (wallworm_bumpMapTex	ww_scene_lods.materials["+matNum as string+"].mat1)  size:[15,15])\n")
			
			bumpMap = wallworm_bumpMapTex	m.mat1
				
				if wallworm_mat_name_limit_check (getFilenameFile m.normal) == false then (
					append str ("checkbox chk"+num as string+" \"Normal: "+((wallworm_getVTFPathFromBitmap bumpMap) as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
				
					status = m.checkDimensions(m.normal)	
					if (status[1]==true AND status[2]==true) then (
					
						vtfname = (wallworm_getVTFPathFromBitmap m.mat1.displacementMap forcePath:wwmt_vtfMmatPath) 
						targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
						if doesFileExist (targetmatname) == true then (
							ch = "false"

						) else (
							ch = "true"
							
						)	
						
		if wwmt_oldModelVTFPath == true then (
			vtfP = ww_scene_lods.materialPath
			en = "false"
			) else (
			
			vtfP = bumpMap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP			
						
			append str ("checkbox chk"+num as string+" \"Bump VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.normal)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.displacementMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n bumpMap = wallworm_bumpMapTex ww_scene_lods.materials["+matNum as string+"].mat1\n   bumpMapname =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap bumpMap forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = (bumpMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n  bumpMap = wallworm_bumpMapTex ww_scene_lods.materials["+matNum as string+"].mat1\n  bumpMap.name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap bumpMap forcePath:ww_scene_lods.materialPath)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

					append sendToVtex( "if chk"+num as string+".checked do (\n")
					append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat.displacementMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\"\" norm:true\n")
					append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat.displacementMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
					

						--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].normal \"normal\" \n")
						append sendToVtex ")\n\n"
					) else(
						append str ("checkbox chk"+num as string+" \"Bump VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.displacementMap) as string)+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					)
				)

			y = y +17
			num = num + 1
			
		)	
			
		if (m.spec != undefined AND m.mat.shaderType == 6) do (
			
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.specularMap  size:[15,15])\n")
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
			if m.spec != m.diff then (
				
				
				if wallworm_mat_name_limit_check (getFilenameFile m.spec) == false then (
					append str ("checkbox chk"+num as string+" \"Phong Specular VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.specularMap) as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
				status = m.checkDimensions(m.spec)	
				if (status[1]==true AND status[2]==true) then (
					
						vtfname = (wallworm_getVTFPathFromBitmap m.mat1.specularMap forcePath:wwmt_vtfMmatPath) 
						targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
						if doesFileExist (targetmatname) == true then (
							ch = "false"

						) else (
							ch = "true"
							
						)	
			if wwmt_oldModelVTFPath == true then (
				vtfP = ww_scene_lods.materialPath
				en = "false"
				) else (
				
				vtfP = m.mat1.specularMap.name
				en = "true"
			)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Phong Specular VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.spec)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.specularMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

						

					append sendToVtex( "if chk"+num as string+".checked do (\n")
					append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat.specularMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\""+ww_scene_lods.compression+"\" norm:false\n")
					append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat.specularMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")

					--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].spec \"spec\" \n")
					append sendToVtex ")\n\n"
					) else(
										append str ("checkbox chk"+num as string+" \"Phong Specular VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.specularMap) as string)+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					
					)
				)
				) else (
					append str("label lblnum"+(num as string)+" \"Phong Specular is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
				)
			y = y +17
			num = num + 1
			
			
			
			
		)	
		
		if (m.specLevelMap != undefined ) do (

			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.specularLevelMap  size:[15,15])\n")
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
			if m.specLevelMap != m.diff then (
				
				if wallworm_mat_name_limit_check (getFilenameFile m.specLevelMap) == false then (
					append str ("checkbox chk"+num as string+" \"EnvMap Mask VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.specularLevelMap) as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
				
				status = m.checkDimensions(m.specLevelMap)	
				if (status[1]==true AND status[2]==true) then (
					
						vtfname = (wallworm_getVTFPathFromBitmap m.mat1.specularLevelMap forcePath:wwmt_vtfMmatPath) 
						targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
						if doesFileExist (targetmatname) == true then (
							ch = "false"

						) else (
							ch = "true"
							
						)	
					
						--append str ("checkbox chk"+num as string+" \"EnvMap Mask VTF: "+((vtfname) as string)+"\" checked:"+ch+" pos:[24,"+y as string+"] width:780 height:15\n\n")
						
			if wwmt_oldModelVTFPath == true then (
				vtfP = ww_scene_lods.materialPath
				en = "false"
			) else (
				vtfP = m.mat1.specularLevelMap.name
				en = "true"
			)
			vtfP = wallworm_bsToFs vtfP
			append str ("checkbox chk"+num as string+" \"EnvMap Mask VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.specLevelMap)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.specularLevelMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

						
						
						append sendToVtex( "if chk"+num as string+".checked do (\n")
						

						append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat.specularLevelMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\""+ww_scene_lods.compression+"\" norm:false\n")
						append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat.specularLevelMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
						
						--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].specLevelMap \"specLevelMap\" \n")
						append sendToVtex ")\n\n"
				) else(
						append str ("checkbox chk"+num as string+" \"EnvMap Mask: "+((wallworm_getVTFPathFromBitmap m.mat1.specularLevelMap) as string)+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					
					)
				)
				) else (
						append str("label lblnum"+(num as string)+" \"Specular is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
				)
			y = y +17
			num = num + 1
			
			)
		
		if m.illum != undefined do (
			
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.selfIllumMap  size:[15,15])\n")
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
			
			if m.illum != m.diff then (
				if wallworm_mat_name_limit_check (getFilenameFile m.illum) == false then (
					append str ("checkbox chk"+num as string+" \"Self Illum VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.selfIllumMap) as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
				status = m.checkDimensions(m.illum)	
				if (status[1]==true AND status[2]==true) then (
					
						vtfname = (wallworm_getVTFPathFromBitmap m.mat1.selfIllumMap forcePath:wwmt_vtfMmatPath) 
						targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
						if doesFileExist (targetmatname) == true then (
							ch = "false"

						) else (
							ch = "true"
							
						)	
			if wwmt_oldModelVTFPath == true then (
				vtfP = ww_scene_lods.materialPath
				en = "false"
			) else (
			
				vtfP = m.mat1.selfIllumMap.name
				en = "true"
			)
			vtfP = wallworm_bsToFs vtfP
			append str ("checkbox chk"+num as string+" \"Self Illum VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.illum)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.selfIllumMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

						
						
						append sendToVtex( "if chk"+num as string+".checked do (\n")
					
						append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat.selfIllumMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\""+ww_scene_lods.compression+"\" norm:false\n")
						append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat.selfIllumMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
						
						--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].illum \"illum\" \n")
						append sendToVtex ")\n\n"
						

						
				) else(
						append str ("checkbox chk"+num as string+" \"Self Illum VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.selfIllumMap) as string)+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					
					)
				)
			) else (
				append str("label lblnum"+(num as string)+" \"Illumination is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
			
			
			
			
		)
		
		
		if (m.lightwarptexture != undefined) do (
			
						
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.lightwarptexture  size:[15,15])\n")

			if m.lightwarptexture != m.diff then (
				status = m.checkDimensions(m.lightwarptexture)			
				if (status[1]==true AND status[2]==true) then (
					
				vtfname = (wallworm_getVTFPathFromBitmap m.mat1.lightwarptexture) 
				targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
				if doesFileExist (targetmatname) == true then (
					ch = "false"

					) else (
					ch = "true"
					
					)
		if wwmt_oldModelVTFPath == true then (
			vtfP = wallworm_remove_last_slash temp_wwmt_vtfMmatPath
			en = "false"
			) else (
			
			vtfP = m.mat1.lightwarptexture.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Lightwarp VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.lightwarptexture)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.lightwarptexture"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

			append sendToVtex( "if chk"+num as string+".checked do (\n")
					
			append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat1.lightwarptexture forcePath:\""+wwmt_vtfMmatPath+"\" compression:\"nocompress\" norm:false\n")
			append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat1.lightwarptexture dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
					
					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].lightwarptexture \"lightwarptexture\" \n")
					append sendToVtex ")\n\n"
				) else(
					append str ("checkbox chk"+num as string+" \"Lightwarp: "+m.lightwarptexture+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled: false\n\n")
				)
			) else (
				append str("label lblnum"+(num as string)+" \"Lightwarp is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
		)
		
		

		
		if (m.parallaxmap != undefined) do (
			
						
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.parallaxmap  size:[15,15])\n")

			if m.parallaxmap != m.diff then (
				status = m.checkDimensions(m.parallaxmap)			
				if (status[1]==true AND status[2]==true) then (
					
				vtfname = (wallworm_getVTFPathFromBitmap m.mat1.parallaxmap) 
				targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
				if doesFileExist (targetmatname) == true then (
					ch = "false"

					) else (
					ch = "true"
					
					)
		if wwmt_oldModelVTFPath == true then (
			vtfP = wallworm_remove_last_slash temp_wwmt_vtfMmatPath
			en = "false"
			) else (
			
			vtfP = m.mat1.parallaxmap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Parallax Map VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.parallaxmap)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.parallaxmap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

			append sendToVtex( "if chk"+num as string+".checked do (\n")
					
			append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat1.parallaxmap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\"nocompress\" norm:false\n")
			append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat1.parallaxmap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
					
					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].parallaxmap \"parallaxmap\" \n")
					append sendToVtex ")\n\n"
				) else(
					append str ("checkbox chk"+num as string+" \"Parallax Map: "+m.parallaxmap+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled: false\n\n")
				)
			) else (
				append str("label lblnum"+(num as string)+" \"Parallax Map is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
		)
		
		
		
		
		if m.refract != undefined do (
			
				append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.refractionMap  size:[15,15])\n")
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
			
			if m.refract != m.diff then (
				
				if wallworm_mat_name_limit_check (getFilenameFile m.refract) == false then (
					append str ("checkbox chk"+num as string+" \"Refraction VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.refractionMap) as string)+" - NAME TOO LONG--More than 22 characters. -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
				
				) else (
					
				status = m.checkDimensions(m.refract)	
				if (status[1]==true AND status[2]==true) then (
					
						vtfname = (wallworm_getVTFPathFromBitmap m.mat1.refractionMap forcePath:wwmt_vtfMmatPath) 
						targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
						if doesFileExist (targetmatname) == true then (
							ch = "false"

						) else (
							ch = "true"
							
						)	
						
		if wwmt_oldModelVTFPath == true then (
			vtfP = ww_scene_lods.materialPath
			en = "false"
			) else (
			
			vtfP = m.mat1.refractionMap.name
			en = "true"
		)	

			vtfP = wallworm_bsToFs vtfP		
			append str ("checkbox chk"+num as string+" \"Refraction VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.refract)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.refractionMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_scene_lods.materialPath\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:ww_scene_lods.materialPath)\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

						

						append sendToVtex( "if chk"+num as string+".checked do (\n")
						append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat.refractionMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\""+ww_scene_lods.compression+"\" norm:false\n")
						append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat.refractionMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
						
						--append sendToVtex("ww_scene_lods.materials["+matNum as string+"].compileTexture ww_scene_lods.materials["+matNum as string+"].refract \"refract\" \n")
						append sendToVtex ")\n\n"

						
				) else(
						append str ("checkbox chk"+num as string+" \"Refractination VTF: "+((wallworm_getVTFPathFromBitmap m.mat1.refractionMap) as string)t+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					
					)
				)
			) else (
				append str("label lblnum"+(num as string)+" \"Refraction is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
			
			
			
			
		)
		
		
		
		if (m.reflectionMap != undefined AND (classOf m.reflectionMap == BitmapTexture OR (classOf m.reflectionMap == Reflect_Refract AND m.reflectionMap.outputname != undefined AND m.reflectionMap.source == 1))) do (
			
						
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_scene_lods.materials["+matNum as string+"].mat1.reflectionMap  size:[15,15])\n")

			if m.reflectionMap != m.diff then (
				
				status = m.checkDimensions(m.reflectionMap)			
				if classof m.reflectionMap == Reflect_Refract OR (status[1]==true AND status[2]==true) then (
					
				vtfname = (wallworm_getVTFPathFromBitmap m.mat1.reflectionMap) 
				targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
				if doesFileExist (targetmatname) == true then (
					ch = "false"

					) else (
					ch = "true"
					
					)
		if wwmt_oldModelVTFPath == true then (
			vtfP = wallworm_remove_last_slash temp_wwmt_vtfMmatPath
			en = "false"
			) else (
			
			vtfP = m.mat1.reflectionMap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Cubemap VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.reflectionMap.outputname)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_scene_lods.materials["+matNum as string+"].mat1.reflectionMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_scene_lods.materials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\n"+theMapStr+".name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

			append sendToVtex( "if chk"+num as string+".checked do (\n")
					
			append sendToVtex("wallworm_copy_bitmap_to_sdk ww_scene_lods.materials["+matNum as string+"].mat1.reflectionMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\""+ww_scene_lods.compression+"\" norm:false\n")
			append sendToVtex("wallworm_write_vtf_bat ww_scene_lods.materials["+matNum as string+"].mat1.reflectionMap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_scene_lods.materials["+matNum as string+"].valveShader\n")
					
					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].lightwarptexture \"lightwarptexture\" \n")
					append sendToVtex ")\n\n"
				) else(
					append str ("checkbox chk"+num as string+" \"Cubemap: "+m.reflectionMap.outputname as string+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled: false\n\n")
				)
			) else (
				append str("label lblnum"+(num as string)+" \"Cubemap is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
		)
		
		
		
		
		
		
		
		
-- 		
		)	catch()
num = num + 1
		matNum = matNum +1
		y=y+20
	
		--append str ")"
		
		)
	
	
		append str  ("button btn_exportTGAs \"Export Selected Textures\" pos:[5,"+y as string+"] width:200 height:48\n\n")
		append str("HyperLink exportTex \"Basic Texture Docs\" pos:[230,"+y as string+"] width:132 height:16 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:\"http://dev.wallworm.com/topic/18/textures.html\"\n\n")
		y = y +17
		append str("HyperLink exportTexUsing \"Exporting Textures\" pos:[230,"+y as string+"] width:132 height:16 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:\"http://dev.wallworm.com/document/70/export_textures.html\"\n\n")
		y = y +17
		append str("HyperLink exportSkins \"Exporting Multiple Skins\" pos:[230,"+y as string+"] width:132 height:16 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:\"http://dev.wallworm.com/document/71/export_multiple_texture_skins.html\"\n\n")
		y = y +17
		
		append str("HyperLink materialTips \"Material Reference Charts and Hints\" pos:[230,"+y as string+"] width:200 height:16 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:\"http://dev.wallworm.com/topic/18/textures.html#materialChart\"\n\n")
		y = y +27
		
		
		
		append str ("label hintLabel \"Remember that the exporter will only list/export map slots that have a Bitmap Map with a TGA bitmap as the image.\"  pos:[5,"+y as string+"] width:700 height:28\n\n")
		
		append str eventHandlersStrings
		--format eventHandlersStrings
		
		append str "on btn_exportTGAs pressed do (\n"

		append str "if ww_scene_lods.canCompile \"tex\" then (\n\n"
		
		append str sendToVtex
		--if wwmtCompileMessage == true OR wwmtCompileMessage == "true" do (
			append str "\n\n messagebox \"Materials Exported.\" \n"
		--)
		
		append str ") else(\n\n messagebox \"You must set the Bin Directory and give your model a Material Path for this function to work.\"  \n\n)\n"

       append str ")\n\n"		
		
		append str ("on textureFields open do (\n"+onOpenStr+"\n)")
	
	append str ")\n\n"
		
		
		append str "addRollout textureFields wwTextureExporter\n"
	--clearListener()
	--print str
	execute str
	
	

		
	) else (
		
		messagebox "You can only export TGA and PSD Bitmaps. Since there are none in your model or LODs, there is nothing to export."
		)
		
) else (
	macros.run "wallworm.com" "WallWormModelToolsConfigMCR"
	msg = "There are problems:\n\n"
	for er in wwProceedTexCompile do (
		append msg ("* "+er+"\n")
		)
	 messagebox msg
	)