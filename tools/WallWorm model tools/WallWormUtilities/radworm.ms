/*
Generate Lights Radiosity File for Source Engine
Copyright (c) 2011-2013
By Shawn Olson http://www.shawnolson.net

A Wall Worm Mod Tool
http://www.wallworm.com


This tool will find all materials in the scene that have self-illumination and create a Lights.Rad file that you can save and use for compiling your map
*/
(
include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"

	
	usedVals = #()
	
	
	materials = #()
	mats = #()
	
	noShadowCollection = #()

	
	--collect all materials in the scene
	for o in objects WHERE o.mat != undefined AND ( (getUserProp o "wwdt_brush_geometry_export" != undefined  OR (isProperty o.mat "wallworm" == true AND o.mat.valveShader == "LightmappedGeneric")) OR ( (getUserProp o "wwmt_source") == undefined AND  (getUserProp o "wwmt_proxie_source" == undefined)) OR (isProperty o "entityType" == true AND o.entityType == "SolidClass") ) do (
		wallworm_appendBitmaps o.mat materials "LightmappedGeneric"
	)
	
/*
	
	This block is only hopeful... in case Valve adds support for props to also give light.
	
	for o in objects WHERE o.mat != undefined AND ((getUserProp o "wwmt_source") != undefined  OR  (getUserProp o "wwmt_proxie_source" != undefined) OR (isProperty o "entityType" == true AND o.entityType == "PointClass")) do (
		local getPathFrom = undefined
		local materialPath = undefined
		if (getUserProp o "wwmt_source") != undefined then (
				getPathFrom = o
		) 
		print getPathFrom
		if (getUserProp o "wwmt_proxie_source") != undefined then (
			
				themdlname = getUserProp o "wwmt_proxie_source"
				
				if themdlname != undefined then (
					
					getPathFrom = getNodeByName themdlname
				)
			
			
		)
		
		if getPathFrom != undefined then (
			
				materialPath = getUserProp getPathFrom "wwmt_materialPath"
		)
		
		
		wallworm_appendBitmaps o.mat materials "VertexLitGeneric" forModel:true materialPath:materialPath
	)
	*/

	
	
	
		matString = ""
		
		for mat in materials WHERE classOf mat.mat == Standard do (
		
		
		
			theMat = mat.mat
		
	
			--if theMat!=undefined AND theMat.useSelfIllumColor != undefined AND (theMat.useSelfIllumColor==true OR (theMat.selfillumMap == undefined AND classOf theMat.selfillumMap == BitmapTexture)) then (
			--AND (theMat.selfillumMap == undefined )
			theMatName = (wallworm_getMaterialName theMat)
			if theMat!=undefined AND theMat.useSelfIllumColor != undefined AND (theMat.useSelfIllumColor==true ) then (
				
				
				c = theMat.SelfIllumColor as color
				
				
				
				
				if mat.forModel == true AND mat.materialPath != undefined then (
					
						outpath = mat.materialPath + "/" + theMatName
				) else (
					
					outpath = theMatName
				)
				
				
				if findItem usedVals outpath == 0 then (
				
					local RadAmount
					
					if isProperty theMat "wallworm"== true then (
						
						RadAmount = theMat.RadAmount
						
					) else (
						
						RadAmount = (c.value * theMat.selfillumMapAmount) 
						)
					
					
				str = outpath + " " + ((c.red as integer)  as string)+ " " + ((c.green as integer) as string)+ " " + ((c.blue as integer) as string) +" " + (( RadAmount as integer) as string)+"\n"
				
				append matString  str
				
				append usedVals outpath
				
				)
				
				appendifUnique mats theMat
				
				--print ("adding " +mat.name)
				
				) else (
				
				--print ("Skipping "+mat.name)
				
				)
			
				if isProperty theMat "shadowOn" == true AND theMat.shadowOn == false do (
				
					appendIfUnique noShadowCollection ( theMatName )
				
				)
			
			
		) 			
		
	
		
		/*Now look for models with transparency*/
		mdlcollection = #()
		for o in objects WHERE getUserProp o "wwmt_source_helper" != undefined AND (getUserProp o "wwmt_opaque" == undefined OR getUserProp o "wwmt_opaque" == false OR getUserProp o  "wwmt_opaque" == "false") do (
			
			appendIfUnique mdlcollection ((getUserProp o "wwmt_modelPath")+"/"+(getUserProp o "wwmt_modelname"))
			
			
		)
		
		
		

		
		
		--exludeMatsFromNoShadowCollect = #()
		for o in objects WHERE getUserProp o "wwmt_source_helper" != undefined  do (
			
			
			local tempWWMT = ww_LOD_wrapper()
			tempWWMT.init()					
			tempWWMT.setTargetModel o tempWWMT
			
			
			tempWWMT.populateMyMaterials()
			
			
			for m in tempWWMT.materials WHERE isProperty m.mat "shadowOn" == true AND m.mat.shadowOn == false do (
				
				appendIfUnique noShadowCollection ( tempWWMT.materialPath+"/"+(wallworm_getMaterialName m.mat forModel:true))
				
			)
			
			--join exludeMatsFromNoShadowCollect (tempWWMT.collectAllObjects())
			
			
		)
		

		
		noShadowCollection = makeUniqueArray noShadowCollection
		
		
		
	
	if mats.count > 0 OR mdlcollection.count >0 OR noShadowCollection.count >0 then (

	mapFileName = getFilenameFile maxFileName
	filename = (""+wwdt_mapsrc+"/"+(mapFileName as string)+".rad")
	filename = getSaveFileName caption:"Save Rad File" filename:filename types:"RAD File(*.rad)|*.rad" historyCategory:"Wall Worm VMF"

		
		if filename != undefined do(
			local radFile = openFile filename mode:"w+"

		)
		if filename == undefined OR radFile == undefined then (
		

			messagebox "The Rad File was not saved."
		
		
		) else (

		/*	
	if mats.count > 0  then (
			for m in mats do (
				
				c = m.SelfIllumColor as color
				str = (wallworm_getMaterialName m) + " " + (formattedPrint c.red format:".0f")+ " " + (formattedPrint c.green format:".0f")+ " " + (formattedPrint c.blue format:".0f") +" " + (formattedPrint (c.value * 10) format:".0f")+"\n"
				
				format str to: radFile
				--print str
			)
			
		)
			*/
			
	format matString to:radFile		
		




	if noShadowCollection.count >0 then (
		for mat in noShadowCollection do (
			
			format ("noshadow "+mat+"\n") to: radFile
			
			)
		
		)
		


			
	if mdlcollection.count >0 then (
		for mdl in mdlcollection do (
			
			format ("forcetextureshadow "+mdl+".mdl\n") to: radFile
			
			)
		
		)
		
		
		
		
		
		
		
			str = undefined
			
			close radFile
			radFile = undefined
			try (
				
				global wallworm_text_editor
				
				folderOpen ="ShellLaunch \""+wallworm_text_editor+"\" @\""+filename+"\""
				execute folderOpen
			) catch(
				folderOpen ="ShellLaunch \"explorer.exe\" @\""+(getFilenamePath filename)+"\""
				execute folderOpen
					
			)	
					
		)

	) else (
			messagebox "There are no materials in the scene with Self-Illumination. If there are materials with self-illumination, check that they do not have bitmaps in their self-illumination slot."
	)
	materials = undefined
	mats = undefined
	gc()
)