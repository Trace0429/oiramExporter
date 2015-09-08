/*
Export Brush Texture Dialog

This script creates a UI for exporting brush and displacement textures.

*/

include "$scripts/WallWorm.com/common/matfuncs1.ms"
fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
fileIn "$scripts/WallWorm.com/common/blendrender.ms"
wwProceedTexCompile = wallworm_canCompileTextures() 
if wwProceedTexCompile == true then (


	
	global ww_brushmaterials = #()
	global wallwormbrushtex = #()
	
	global wallworm_exportMatlist
	thematerials = #()
	if wallworm_exportMatlist != undefined AND wallworm_exportMatlist.count > 0 then (
		
		
			join thematerials  wallworm_exportMatlist
		
	)
	
	macros.run "wallworm.com" "WallWormRepairDXRenderMatNamesMCR"
	
	global wallworm_detailarray = #("","swamp_land_002","grass01","grass02","coastline_grass01","coastline_grass02","coastline_redgrass01","coastline_redgrass02","coastline_redgrass03","citygrass01","redgrass","redgrass_light","short_redgrass","PerfTest1","canal_reeds","rocks_redgrass","lostcoast_grass","lostcoast_grass2")
	
	if thematerials.count == 0 then (
	if selection.count > 0 then (
		wallwormbrushtex = selection
	) else (
		--wallwormbrushtex = objects
		
		for o in objects  where ((getUserProp o "wwdt_brush_geometry_export") != undefined OR (getUserProp o "ww_wwdt_displacement_brush") != undefined OR (getUserProp o "wwmt_decal") != undefined OR classOf o.baseObject == WallWormDetailType) AND o.mat != undefined do (

			append wallwormbrushtex o

		)
	)
	
	
		newMats =	for i in wallwormbrushtex where i.mat != undefined  collect i.mat
		join thematerials newMats
	)

		


	for m in thematerials do (
	

			if classOf m == Blend then ( 
				
				shaderType = "WorldVertexTransition"
				
				) else(
				shaderType = "LightmappedGeneric"
				)
			--print (i.mat)
			

				/*
			if (getUserProp i "wwmt_decal")!=undefined then (
				decal = true
			) else (
				 decal = false
			)
			*/
			
			local getNameFromPath = true
			local forModel = false
			local materialPath = undefined
			
			if isProperty m "wallworm" then (
				shaderType = m.valveShader
				decal = m.decal
				
				if m.forModel == true AND m.cdmaterials != "" then (
					getNameFromPath = false

					forModel = true
					materialPath = m.cdmaterials
				)
			)
			
			
			wallworm_appendBitmaps m ww_brushmaterials shaderType coords:true decal:decal getNameFromPath:getNameFromPath forModel:forModel materialPath:materialPath

	
	)
	wallwormbrushtex = undefined 

if ww_brushmaterials.count > 0 then (
	
	eventHandlersStrings = ""
	str = "BrushwwTextureExporter = newRolloutFloater \"Wall Worm Brush Texture Exporter 3.2\" 800 800 10 10\n"

	append str "include \"$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms\"\n\n"
	append str "include \"$scripts/WallWorm.com/common/matfuncs1.ms\"\n\n"
	append str "include \"$scripts/WallWorm.com/common/ww_struct_mat.ms\"\n\n"
	append str "include \"$scripts/WallWorm.com/common/config.ms\"\n\n"
	append str "rollout BrushtextureFields \"Wall Worm Brush Texture Exporter\" width:790 height:790 (\n\n"
		
	append str 	"dropdownList ddl_compression \"Compression\" pos:[15,10] width:99 height:40 items:#(\"\", \"DXT5\", \"nocompress\") selection:5\n"
	append str "dropdownList ddl_shader \"Non Blend Shader\" pos:[130,10] width:128 height:21 items:#(\"LightmappedGeneric\", \"UnlitGeneric\")\n"
	append str ("combobox ddl_surfaceproperty \"Surface Property\" pos:[270,10] width:136 height:3 \n")
	append str ("combobox ddl_detailtype \"Detail Type\" pos:[420,10] width:136 height:3 \n")
	--if  (wwmt_mat_textransform_vmts == true OR wwmt_mat_textransform_vmts == "true")  then (	
		
	--append str ("spinner spnRot \"Rotation\" pos:[50,60] width:60 height:16 range:[-180,180,"+(wwmt_VMTRotation as string)+"] type:#float scale:1 toolTip:\"Set the rotation for these materials. The default is 0... but if the materials come out rotated... you probably want to set this to 180.\"")
		
	--)
	
	y =100
	num = 1
	matNum = 1
	sendToVtex = ""
	onOpenStr = ""
		
	for m in ww_brushmaterials do (
		if m.mat1 == undefined then m.mat1 = m.mat
	--try(
		
	ww_transformRotation = 0	
	if classOf m.mat == Blend then (
		--ww_transformRotation = 180
		m.matName= wallworm_getMaterialName m.mat
		
	)	else (
		
		m.matName= wallworm_getMaterialName m.mat1
		)	
	
	--m.forModel=false
		

			if isProperty m "wallworm" AND m.forModel == true AND m.cdmaterials != "" then (

					materialPath = m.cdmaterials
					m.forModel = true
				
			) else (
				m.forModel = false
				materialPath =  m.getMaterialPathForMat m.mat1
			)
		
		
		
		
	
		if materialPath == "" then (
			temp_wwmt_vtfMmatPath = m.matName
		) else (
				temp_wwmt_vtfMmatPath = materialPath
		)
	
		if wwmt_oldModelVTFPath == "true" OR wwmt_oldModelVTFPath == true then (
			
			
			
			wwmt_vtfMmatPath = temp_wwmt_vtfMmatPath

			
			
			) else (
			
			wwmt_vtfMmatPath = ""
			
			)
	
		
	--m.valveShader="LightmappedGeneric"
			
		--append str (" group \""m.mat.name"\" (\n")

		--append sendToVtex str ("label lblmat"+(matNum as string)+" \"Material "+m.mat.name+"\" pos:[5,"+y as string+"] width:780 height:15\n\n")
		--

				
				targetmatname = (wwmt_gameInfoDir+"\\materials\\"+m.matName+".vmt")
				if doesFileExist (targetmatname) == true then (
					ch = "false"

					) else (
					ch = "true"
					
					)
					
				append str ("checkbox chk_VMT"+(matNum as string)+" \"\" pos:[5,"+y as string+"] width:20 height:15 checked:"+ch+" toolTip:\"Write the VMT file as well as export the texture.\"\n\n")
					
				
				if m.forModel == true then (
					
						theName = m.materialPath+"/"+ m.matName
					
				) else (
					
						theName = m.matName
				)
					
				append str ("on chk_VMT"+(matNum as string)+" rightClick do (\n local theVMFFile = \""+targetmatname+"\"\nif doesFileExist theVMFFile then (\n	folderOpen =\"ShellLaunch \\\""+wallworm_text_editor+"\\\" @\\\""+targetmatname+"\\\"\"\nexecute folderOpen\n)\n)\n")
				append str("label lblmat"+(matNum as string)+" \"VMT Material: ("+(m.valveShader)+") "+(theName as string)+".vmt\" pos:[25,"+y as string+"] width:780 height:15\n\n")
				
				--print s

				y = y +17
				
			--append sendToVtex("if  (wwmt_mat_textransform_vmts == true OR wwmt_mat_textransform_vmts == \"true\")  then (\nww_brushmaterials["+matNum as string+"].setTransforms rot:spnRot.value\n)")
			
			--append sendToVtex("theRot = spnRot.value\nif classOf ww_brushmaterials["+matNum as string+"].mat == Blend then (theRot=theRot)\n")
					
			append sendToVtex("ww_brushmaterials["+matNum as string+"].setTransforms()\n")
		
			append sendToVtex("if (classOf ww_brushmaterials["+matNum as string+"].mat) != Blend AND (classOf ww_brushmaterials["+matNum as string+"].mat) != DirectX_9_Shader then (\nww_brushmaterials["+matNum as string+"].setShader ddl_shader.selected\n)\n" )
			append sendToVtex("ww_brushmaterials["+matNum as string+"].compression = ddl_compression.selected\n")
			append sendToVtex("ww_brushmaterials["+matNum as string+"].surfaceproperty = ddl_surfaceproperty.text\n")
			append sendToVtex("if (ww_brushmaterials["+matNum as string+"].valveShader==\"WorldVertexTransition\") then (\nww_brushmaterials["+matNum as string+"].detailtype=ddl_detailtype.selected)\n" )
/*
		if 	m.valveShader == "WorldVertexTransition" then (
			
			append sendToVtex( "if chk_VMT"+num as string+".checked do (\n")
			append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].diff \"diff\" writeVMT:chk_VMT"+num as string+".checked false\n")
			append sendToVtex ")\n\n"		
				
		)	else ()
			*/
			
		if m.valveShader == "WorldVertexTransition" then (
			
				--blendFile = ww_brushmaterials[matNum].getBlendToolTexName()
				
			
			--pathConfig.removePathLeaf (wallworm_remove_last_slash $.mat.renderMaterial.name)
			
				prepname =  wallworm_remove_last_slash m.matName
				toolpath = pathConfig.removePathLeaf prepname
				--append toolpath "_tool"
				--m.matName+".vmt"	
					
				--writepath = wallworm_bsToFs("$maps/"+toolpath+"/"+(pathConfig.stripPathToLeaf prepname)+"_tool.tga")
				writepath = wallworm_bsToFs(wwmt_exportMats+"/"+toolpath+"/"+(pathConfig.stripPathToLeaf prepname)+"_tool.tga")
				if doesFileExist (getFileNamePath writepath) == false then (
					
					makeDir (getFileNamePath writepath) all:true
					
					
					)
					
			
				--print writepath
				tex = BitmapTexture()
				tex.name = toolpath
				tex.filename = writepath
			
					
				toolpath = wallworm_bsToFs  (toolpath)	
					
					
			--"+(m.matName)+"_tool.vtf
				append str ("checkbox chk"+num as string+" \"Blend Tool Texture VTF: "+(toolpath+"/"+(wallworm_bsToFs (pathConfig.stripPathToLeaf prepname))+"_tool.vtf")+"\" pos:[24,"+y as string+"] checked:"+ch+" width:682 height:15 toolTip:\"Click to export this VTF.\"\n")
				append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
				append onOpenStr ("\nlocal bmt =  wallworm_render_blend_mat ww_brushmaterials["+matNum as string+"].mat size:[15,15]\nif bmt != undefined then (wwmt_tga_"+num as string+".bitmap =bmt\n)\n")
				
				append sendToVtex( "if chk"+num as string+".checked  do (\n")
				
			
				if m.mat2 != undefined AND m.mat2.diffuseMap != undefined AND classOf m.mat2.diffuseMap == BitmapTexture AND m.mat2.diffuseMap.bitmap != undefined AND m.mat2.diffuseMap.bitmap.width != undefined then (
					
					bmWIdth = m.mat2.diffuseMap.bitmap.width
					bmHeight=m.mat2.diffuseMap.bitmap.height
				) else (
					if m.mat1.diffuseMap != undefined AND classOf m.mat1.diffuseMap == BitmapTexture AND m.mat1.diffuseMap.bitmap != undefined AND m.mat1.diffuseMap.bitmap.width != undefined then (
					
						bmWIdth = m.mat1.diffuseMap.bitmap.width
						bmHeight=m.mat1.diffuseMap.bitmap.height
					) else (
						
						bmWIdth = 512
						bmHeight= 512
						
					)
					
					
				)
			
				
			
				append sendToVtex("local bm = wallworm_render_blend_mat ww_brushmaterials["+matNum as string+"].mat size:["+(bmWIdth as string)+","+(bmHeight as string)+"] filename:\""+writepath+"\" overWrite:true\nsave bm\nlocal bmt = BitmapTexture()\nbmt.name = \""+tex.name+"\" \n bmt.bitmap = bm\nwallworm_copy_bitmap_to_sdk bmt forcePath:\""+toolpath+"\" compression:ddl_compression.selected norm:false\n")
				append sendToVtex("wallworm_write_vtf_bat bmt dir:\""+toolpath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
				--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].diff \"diff\" writeVMT:false exportVTF:true\n")
				append sendToVtex ")\n\n"
			
			
			
				num = num + 1	
				y = y +17		
				
				
				
				
		if m.blendmodulate != undefined  then (

			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].blendmodulate  size:[15,15])\n")
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
-- fileName:\""+(m.blendmodulate as string)+"\"			
			status = m.checkDimensions(m.blendmodulate.filename)			
			if (status[1]==true AND status[2]==true) then (
				
				
				
				vtfname = (wallworm_getVTFPathFromBitmap m.blendmodulate) 
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
			
			vtfP = m.blendmodulate.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP
			append str ("checkbox chk"+num as string+" \"blendmodulateuse VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.blendmodulate.filename)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the texture output path by the material name.\"\n")
			
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\nww_brushmaterials["+matNum as string+"].blendmodulate.name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap ww_brushmaterials["+matNum as string+"].blendmodulate forcePath:\"\")\nedt"+num as string+".text = (ww_brushmaterials["+matNum as string+"].blendmodulate.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\nww_brushmaterials["+matNum as string+"].blendmodulate.name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap ww_brushmaterials["+matNum as string+"].blendmodulate forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

				
					
					
					
				append sendToVtex( "if chk"+num as string+".checked  do (\n")
				
				
				append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].blendmodulate forcePath:\""+wwmt_vtfMmatPath+"\" compression:ddl_compression.selected norm:false\n")
				append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].blendmodulate dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
				--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].blendmodulate \"blendmodulate\" writeVMT:false exportVTF:true\n")
				append sendToVtex ")\n\n"
				
			)	else (
				append str ("checkbox chk"+num as string+" \"blendmodulateuse: "+((wallworm_getVTFPathFromBitmap m.blendmodulate) as string)+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
			)	
		y = y +17		

				num = num + 1			
		) 
				
				
				
				
				

		--	if  wwmt_exportMats  m.matName
			
			
		)


		if  m.mat2==undefined	then (
		if m.diff != undefined  then (

			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].mat1.diffuseMap  size:[15,15])\n")
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")	
-- fileName:\""+(m.diff as string)+"\"			
			status = m.checkDimensions(m.diff)			
			if (status[1]==true AND status[2]==true) then (
				
				
				
				vtfname = (wallworm_getVTFPathFromBitmap m.mat1.diffuseMap) 
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
			
			vtfP = m.mat1.diffuseMap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP
			append str ("checkbox chk"+num as string+" \"Diffuse VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.diff)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the texture output path by the material name.\"\n")
			
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\nww_brushmaterials["+matNum as string+"].mat1.diffuseMap.name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap ww_brushmaterials["+matNum as string+"].mat1.diffuseMap forcePath:\"\")\nedt"+num as string+".text = (ww_brushmaterials["+matNum as string+"].mat1.diffuseMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\nww_brushmaterials["+matNum as string+"].mat1.diffuseMap.name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap ww_brushmaterials["+matNum as string+"].mat1.diffuseMap forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

				
					
					
					
				append sendToVtex( "if chk"+num as string+".checked  do (\n")
				
				
				append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat1.diffuseMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:ddl_compression.selected norm:false\n")
				append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat1.diffuseMap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
				--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].diff \"diff\" writeVMT:false exportVTF:true\n")
				append sendToVtex ")\n\n"
				
			)	else (
				append str ("checkbox chk"+num as string+" \"Diffuse: "+((wallworm_getVTFPathFromBitmap m.mat1.diffuseMap) as string)+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
			)	
		y = y +17			
		) else (
				/*
				local dirnotice = " (WILL HAVE TO COPY VMT from SDK to Game!!!)"
				if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" do (
					dirnotice = ""
				)
				append str ("checkbox chk"+num as string+" \"Diffuse COLOR"+dirnotice+"\" pos:[24,"+y as string+"] width:780 height:15\n\n")
				append sendToVtex( "if chk"+num as string+".checked do (\n")
				append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].diff \"diff\" \n")
				append sendToVtex ")\n\n"*/
		)
		

		
		
	)
	
				append sendToVtex( "\nif chk_VMT"+matNum as string+".checked do (\n")
				append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].mat1.diffuseMap \"diff\" writeVMT:true exportVTF:false\n")
				append sendToVtex ")\n\n"
	
		num = num + 1	
		
		groupY = 10
		if m.bump != undefined AND m.mat2==undefined do (
			
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap (wallworm_bumpMapTex	ww_brushmaterials["+matNum as string+"].mat1)  size:[15,15])\n")

				
				status = m.checkDimensions(m.bump)			
				if (status[1]==true AND status[2]==true) then (
					
				bumpMap = wallworm_bumpMapTex	m.mat1
					
				vtfname = (wallworm_getVTFPathFromBitmap bumpMap) 
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
			
			vtfP = bumpMap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Bump VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.bump)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.bumpMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\nbumpMap = wallworm_bumpMapTex	ww_brushmaterials["+matNum as string+"].mat1\nbumpMap.name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap bumpMap forcePath:\"\")\nedt"+num as string+".text = (bumpMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\nbumpMap = wallworm_bumpMapTex	ww_brushmaterials["+matNum as string+"].mat1\nbumpMap.name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap bumpMap forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

					
					
					
					
					append sendToVtex( "if chk"+num as string+".checked do (\n")


					
					append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat1.bumpMap compression:ddl_compression.selected norm:true\n")
					append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat1.bumpMap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader mat:ww_brushmaterials["+matNum as string+"].mat1\n")
					
					
					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].bump \"bump\" \n")
					append sendToVtex ")\n\n"

			) else (
					append str("label lblnum"+(num as string)+" \"Bump has invalid Dimensions\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
		)
		
		

		groupY = 10


		if m.detail != undefined AND m.mat2==undefined do (
			
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap (wallworm_detailMapTex ww_brushmaterials["+matNum as string+"].mat1)  size:[15,15])\n")

			if m.detail != m.diff then (
				status = m.checkDimensions(m.detail)			
				if (status[1]==true AND status[2]==true) then (
					
					
					
					detailMap = wallworm_detailMapTex m.mat1
					
					
				vtfname = (wallworm_getVTFPathFromBitmap detailMap) 
				targetmatname = (wwmt_gameInfoDir+"\\materials\\"+vtfname+".vtf")
				if doesFileExist (targetmatname) == true then (
					ch = "false"

					) else (
					ch = "true"
					
					)
					
					--append str ("checkbox chk"+num as string+" \"Detail VTF: "+((vtfname) as string)+"\" checked:"+ch+" pos:[24,"+y as string+"] width:780 height:15\n\n")
					
		if wwmt_oldModelVTFPath == true then (
			vtfP = wallworm_remove_last_slash temp_wwmt_vtfMmatPath
			en = "false"
			) else (
			
			vtfP = detailMap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Detail VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.detail)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			--theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.bumpMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\ndetailMap = (wallworm_detailMapTex ww_brushmaterials["+matNum as string+"].mat1)\ndetailMap.name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap detailMap forcePath:\"\")\nedt"+num as string+".text = (detailMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\ndetailMap = (wallworm_detailMapTex ww_brushmaterials["+matNum as string+"].mat1)\ndetailMap.name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap detailMap forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

					
					
					append sendToVtex( "if chk"+num as string+".checked do (\n")
					
					append sendToVtex("wallworm_copy_bitmap_to_sdk (wallworm_detailMapTex ww_brushmaterials["+matNum as string+"].mat1) compression:ddl_compression.selected norm:false\n")
					append sendToVtex("wallworm_write_vtf_bat (wallworm_detailMapTex ww_brushmaterials["+matNum as string+"].mat1) dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].detail \"detail\" \n")
					append sendToVtex ")\n\n"
				) else(
					append str ("checkbox chk"+num as string+" \"Detail: "+m.detail+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					)
					
			) else (
					append str("label lblnum"+(num as string)+" \"Detail is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
			
			
		)
		

		
			
		if m.ambient != undefined AND m.forModel == true do (
			
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].mat1.ambientMap  size:[15,15])\n")
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
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.ambientMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  \""+m.materialPath+"\"\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\""+m.materialPath+"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\""+m.materialPath+"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

					
						
						
						
						append sendToVtex( "if chk"+num as string+".checked do (\n")
						

						
						append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat.ambientMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:ddl_compression.selected norm:false\n")
						append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat.ambientMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
						
						
						--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].ambient \"ambient\" \n")
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
		
		
		
		if m.normal != undefined AND m.mat2==undefined do (
			
						
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap (wallworm_bumpMapTex	ww_brushmaterials["+matNum as string+"].mat1)  size:[15,15])\n")

				bumpMap = wallworm_bumpMapTex	m.mat1
				status = m.checkDimensions(m.normal)			
				if (status[1]==true AND status[2]==true) then (
					
					
				vtfname = (wallworm_getVTFPathFromBitmap bumpMap) 
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
			
			vtfP = bumpMap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Bump VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.normal)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.displacementMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\nbumpMap = wallworm_bumpMapTex	ww_brushmaterials["+matNum as string+"].mat1\nbumpMap.name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\nedt"+num as string+".text = (bumpMap.name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\nbumpMap = wallworm_bumpMapTex	ww_brushmaterials["+matNum as string+"].mat1\nbumpMap.name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap bumpMap forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

					m
					--append str ("checkbox chk"+num as string+" \"Normal VTF: "+((vtfname) as string)+"\" checked:"+ch+" pos:[24,"+y as string+"] width:780 height:15\n\n")
					append sendToVtex( "if chk"+num as string+".checked do (\n")
					
					append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat1.displacementMap compression:ddl_compression.selected norm:true\n")
					append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat1.displacementMap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader mat:ww_brushmaterials["+matNum as string+"].mat1\n")
					
					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].normal \"normal\" \n")
					append sendToVtex ")\n\n"

			) else (
				append str("label lblnum"+(num as string)+" \"Normal is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
		)	

		
		if (m.spec != undefined AND  m.forModel == true  AND m.mat.shaderByName == "Phong" ) do (
			
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].mat1.specularMap  size:[15,15])\n")
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
				vtfP = wallworm_remove_last_slash temp_wwmt_vtfMmatPath
				en = "false"
			) else (
				vtfP = m.mat1.specularMap.name
				en = "true"
			)
			
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Phong Specular VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.spec)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.specularMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the model's material path.\"\n")
			append eventHandlersStrings  ("on btn"+num as string+" pressed do (\n"+theMapStr+".name =  \""+m.materialPath+"\"\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\""+m.materialPath+"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("on edt"+num as string+" changed text do (\n"+theMapStr+".name =  text\nchk_VMT"+matNum as string+".checked = true\nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\""+m.materialPath+"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")

						

					append sendToVtex( "if chk"+num as string+".checked do (\n")
					append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat.specularMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:ddl_compression.selected norm:false\n")
					append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat.specularMap  dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")

					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].spec \"spec\" \n")
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
		
		
		if (m.specLevelMap != undefined AND m.mat2==undefined) do (
			
						
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].mat1.specularLevelMap  size:[15,15])\n")

			if m.specLevelMap != m.diff then (
				status = m.checkDimensions(m.specLevelMap)			
				if (status[1]==true AND status[2]==true) then (
					
				vtfname = (wallworm_getVTFPathFromBitmap m.mat1.specularLevelMap) 
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
			
			vtfP = m.mat1.specularLevelMap.name
			en = "true"
		)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"EnvMap Mask VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.specLevelMap)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.specularLevelMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\n"+theMapStr+".name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

			append sendToVtex( "if chk"+num as string+".checked do (\n")
					
			append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat1.specularLevelMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:ddl_compression.selected norm:false\n")
			append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat1.specularLevelMap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
					
					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].specLevelMap \"specLevelMap\" \n")
					append sendToVtex ")\n\n"
				) else(
					append str ("checkbox chk"+num as string+" \"Specular: "+m.specLevelMap+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled: false\n\n")
				)
			) else (
				append str("label lblnum"+(num as string)+" \"Specular is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
		)
		
		
		
		if (m.lightwarptexture != undefined AND m.mat2==undefined) do (
			
						
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].mat1.lightwarptexture  size:[15,15])\n")

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
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.lightwarptexture"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\n"+theMapStr+".name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

			append sendToVtex( "if chk"+num as string+".checked do (\n")
					
			append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat1.lightwarptexture forcePath:\""+wwmt_vtfMmatPath+"\" compression:\"nocompress\" norm:false\n")
			append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat1.lightwarptexture dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
					
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
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].mat1.parallaxmap  size:[15,15])\n")

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
			append str ("checkbox chk"+num as string+" \"Parallaxmap VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.parallaxmap)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.parallaxmap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\n"+theMapStr+".name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

			append sendToVtex( "if chk"+num as string+".checked do (\n")
					
			append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat1.parallaxmap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\"nocompress\" norm:false\n")
			append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat1.parallaxmap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
					
					--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].parallaxmap \"parallaxmap\" \n")
					append sendToVtex ")\n\n"
				) else(
					append str ("checkbox chk"+num as string+" \"Parallaxmap: "+m.parallaxmap+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled: false\n\n")
				)
			) else (
				append str("label lblnum"+(num as string)+" \"Parallaxmap is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
		)
		
		
		
		
		if (m.reflectionMap != undefined AND (classOf m.reflectionMap == BitmapTexture OR (classOf m.reflectionMap == Reflect_Refract AND m.reflectionMap.outputname != undefined AND m.reflectionMap.source == 1))) do (
			
						
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].mat1.reflectionMap  size:[15,15])\n")

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
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.reflectionMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\n"+theMapStr+".name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

			append sendToVtex( "if chk"+num as string+".checked do (\n")
					
			append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat1.reflectionMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:\"\" norm:false\n")
			append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat1.reflectionMap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
					
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
		

		
		
		if m.illum != undefined AND m.mat2==undefined do (
			
			
			append str ("bitmap wwmt_tga_"+num as string+" \"\" pos:[5,"+y as string+"] width:15 height:15\n\n")
			append onOpenStr ("\n wwmt_tga_"+num as string+".bitmap = (renderMap ww_brushmaterials["+matNum as string+"].mat1.selfIllumMap  size:[15,15])\n")

			
			if m.illum != m.diff then (
				status = m.checkDimensions(m.illum)			
				if (status[1]==true AND status[2]==true) then (
					
				vtfname = (wallworm_getVTFPathFromBitmap m.mat1.selfIllumMap) 
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
				
				vtfP = m.mat1.selfIllumMap.name
				en = "true"
			)
			vtfP = wallworm_bsToFs vtfP			
			append str ("checkbox chk"+num as string+" \"Self Illum VTF:\" pos:[24,"+y as string+"] checked:"+ch+" width:82 height:15 toolTip:\"Click to export this VTF.\"\n")
			append str ("editText edt"+num as string+" \"\" enabled:"+en+" pos:[123,"+y as string+"] width:420 height:17 text:\""+vtfP+"\" toolTip:\"Set the output Path of this VTF.\"\n")
			append str ("label lblX"+num as string+" \"/"+(getFileNameFile m.illum)+".vtf\" pos:[550,"+y as string+"] width:200 height:17\n")
			theMapStr = "ww_brushmaterials["+matNum as string+"].mat1.selfIllumMap"
			append str ("button btn"+num as string+" \"^\" enabled:"+en+" pos:[105,"+y as string+"] width:14 height:14 toolTip:\"Set to the output path from the material name.\"\n")
			append eventHandlersStrings  ("\n on btn"+num as string+" pressed do (\n"+theMapStr+".name =  ww_brushmaterials["+matNum as string+"].mat1.name\n vtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\nedt"+num as string+".text = ("+theMapStr+".name)\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\nchk"+num as string+".checked = false\n) else (\nchk"+num as string+".checked = true\n)\n )\n")
			append eventHandlersStrings  ("\n on edt"+num as string+" changed t do (\n"+theMapStr+".name =  t \n \nvtfname = (wallworm_getVTFPathFromBitmap "+theMapStr+" forcePath:\"\")\ntargetmatname = ( (\""+wwmt_gameInfoDir+"\\materials" + "\\\""+"\""+")+vtfname+\""+".vtf"+"\")\nif doesFileExist (targetmatname) == true then (\n chk"+num as string+".checked = false\n) else (\n chk"+num as string+".checked = true\n)\n )\n")

					
					
					
						--append str ("checkbox chk"+num as string+" \"Illumination: "+((vtfname) as string)+"\" checked:"+ch+" pos:[24,"+y as string+"] width:780 height:15\n\n")
						append sendToVtex( "if chk"+num as string+".checked do (\n")

					

					
					
					append sendToVtex("wallworm_copy_bitmap_to_sdk ww_brushmaterials["+matNum as string+"].mat1.selfIllumMap forcePath:\""+wwmt_vtfMmatPath+"\" compression:ddl_compression.selected norm:false\n")
					append sendToVtex("wallworm_write_vtf_bat ww_brushmaterials["+matNum as string+"].mat1.selfIllumMap dir:\""+wwmt_vtfMmatPath+"\" VMTWritten:true runBat:true exportVTF:true shaderUsed:ww_brushmaterials["+matNum as string+"].valveShader\n")
					
						--append sendToVtex("ww_brushmaterials["+matNum as string+"].compileTexture ww_brushmaterials["+matNum as string+"].illum \"illum\" \n")
						append sendToVtex ")\n\n"
				) else(
					append str ("checkbox chk"+num as string+" \"Illumination: "+m.illum+" - INVALID DIMENSIONS -\" pos:[24,"+y as string+"] width:780 height:15 enabled:false\n\n")
					)
			) else (
				append str("label lblnum"+(num as string)+" \"Illumination is Diffuse\" pos:[24,"+y as string+"] width:780 height:15\n\n")
			)
			y = y +17
			num = num + 1
			
			
			
			
		)
		

-- 		
		--)	catch()

		matNum = matNum +1
		y=y+20
	
		--append str ")"
		
		)
	
	
		append str  ("button btn_exportTGAs \"Export Selected Textures\" pos:[5,"+y as string+"] width:200 height:48\n\n")
		append str("HyperLink exportTex \"Basic Texture Docs\" pos:[230,"+y as string+"] width:132 height:16 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:\"http://dev.wallworm.com/topic/18/textures.html\"\n\n")
		y = y +17
		append str("HyperLink exportTexUsing \"Exporting Brush Textures and Decals\" pos:[230,"+y as string+"] width:232 height:16 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:\"http://dev.wallworm.com/document/109/brush_materials_and_decals.html\"\n\n")
		y = y +17

		append str("HyperLink materialTips \"Material Reference Charts and Hints\" pos:[230,"+y as string+"] width:200 height:16 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:\"http://dev.wallworm.com/topic/18/textures.html#materialChart\"\n\n")
		y = y +27
		
		append str eventHandlersStrings
		
		append str "on btn_exportTGAs pressed do (\n"
		append str "if (wallworm_binSet \"tex\") == true then (\n\n"
		append str sendToVtex
		append str "\n\n messagebox \"Materials Exported.\" \n"
		append str ") else(\n\n messagebox \"You must set the Bin Directory for this function to work.\"  \n\n)\n"
		append str ")\n\n"	

		--format eventHandlersStrings
		append str ("\non BrushtextureFields open do (\nddl_surfaceproperty.items = wwmt_surfaceprop_list\nddl_detailtype.items = wallworm_detailarray\n"+onOpenStr+")\n)\n\n")
		append str "addRollout BrushtextureFields BrushwwTextureExporter\n"
		
	--print str
	execute str
	
	

		
	) else (
		messagebox "No valid materials were found in these scene."
	)
) else (
	
	msg = "There are problems:\n\n"
	for er in wwProceedTexCompile do (
		append msg ("* "+er+"\n")
		)
	 messagebox msg
	)
	
	wallworm_exportMatlist = undefined 