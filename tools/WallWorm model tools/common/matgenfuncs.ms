			
			/*
			This function takes an array that comes from a line string in a VMT and converts the values to colors or integers
			*/
			function wallworm_get_color_from_string_arrays lineArray t:"color"= (

					local mult = false
					if t=="color" then (
							if lineArray.count > 1 AND (matchpattern lineArray[2] pattern:"*[*" == true) then (
								
									mult = true
								
							) else (
								mult = false
								
							)
						
					)
					
					local colval = ""
					local ct = lineArray.count
					for i = 1 to ct do (
						
						append colval lineArray[i]
						
						if i != ct then (
							append colval " "	
						)
					)
					
					--colval  =( lineArray[2]+" " + lineArray[3] +" " + lineArray[4])
					
					colval = substituteString colval "\"" ""
					
					 colval = substituteString colval "{" ""
					 colval = substituteString colval "}" ""
					
					 colval = substituteString colval "]" ""
					 colval = substituteString colval "[" ""
					
					 colvals = filterString colval " "
					local v
					if t=="color" then (
						if colvals != undefined AND colvals.count >=4 then (
							
							if (mult == true) then (
								
									v = color ((colvals[2] as float) * 255) ((colvals[3] as float)* 255) ((colvals[4] as float)* 255)
								
							) else (
								v = color (colvals[2] as float) (colvals[3] as float) (colvals[4] as float)
								
							)
							
						)
					) else (
						if colvals != undefined AND colvals.count > 0 then (
							case t of (
								"float": (v = colvals[2] as float)
								"integer": (v = colvals[2] as float)
								"string": (v = ( colvals[2] as string+" " + colvals[3] as string+" " + colvals[4] as string))
								"array":(v = colvals)
							)
						
						)
					)
			v
		)	
function wallworm_getBitmapFromPaths fname extraPath:undefined extraRootPaths:undefined collecting:true= (
	
	global wwmt_gameInfoDir
	global wwmt_exportMats
	global wwmt_raw_mats
	patharray = #()
	
	if extraPath != undefined AND extraPath != "" then (
		
		if doesFileExist extraPath == true then (
			appendIfUnique patharray (extraPath)
		)
		
		p2 = (wwmt_gameInfoDir + "\\materials\\"+extraPath)
		
		if doesFileExist p2 == true then (
			appendIfUnique patharray p2
		)
		p3 = (wwmt_exportMats+"\\"+extraPath)
		if doesFileExist p3 == true then (
			appendIfUnique patharray p3
		)
		
		
		p4 = (wwmt_raw_mats+"\\"+extraPath)
		if doesFileExist p4 == true then (
			appendIfUnique patharray p4
		)
		
	)
	appendIfUnique patharray (wwmt_gameInfoDir + "\\materials\\")
	appendIfUnique patharray (wwmt_exportMats)
	appendIfUnique patharray (wwmt_raw_mats )
	
	if extraRootPaths != undefined AND extraRootPaths.count > 0 then (
			nps = #()
			for p in patharray do (
				for p2 in extraRootPaths do (
				
					appendIfUnique nps (p+"\\"+p2)
					
				)
				
			)
		
			if nps.count > 0 then (
				for n in nps do (
					appendifunique patharray n
				)
			)
	)
	
	
	for p in patharray do (
		
		theTex = (p+"\\"+fname+".psd")
		if doesFileExist theTex then (
			
			return #(theTex,true)
		)
		
	)
	
	
	for p in patharray do (
		
		theTex = (p+"\\"+fname+".tga")
		if doesFileExist theTex then (
			
			return #(theTex,true)
		)
		
	)

	if collecting == true OR (wallworm_isValidBitmap ".vtf" vtfCheck:true) == true  then (
		
		for p in patharray do (
			theTex = (p+"\\"+fname+".vtf")

			if doesFileExist theTex then (

				if VTFImporter != undefined then (
						canClose = true
				) else (
					canClose = false
					)
				
				return #(theTex,canClose)
			)
			
		)
	
	)

	
	if extraPath == undefined then (
		extraPath = ""
	)
		
	return #((extraPath+"\\"+fname+".tga"),false)

)

function wallworm_getVMTFromPaths fname extraPath:undefined extraRootPaths:undefined= (
	
	
	--fname = getFileNameFile fname
	ftype = getFileNameType fname
	if ftype != undefined AND ftype != "" then (
		--print fname
			fname = substituteString fname ftype ""
		--print fname
	)
	
	global wwmt_gameInfoDir
	global wwmt_exportMats
	patharray = #()
	if extraPath != undefined then (
		
		appendIfUnique patharray (extraPath)
		appendIfUnique patharray (wwmt_exportMats+"\\"+extraPath)
		appendIfUnique patharray (wwmt_gameInfoDir + "\\materials\\"+extraPath)
		appendIfUnique patharray (wwmt_raw_mats + "\\"+extraPath)
		
	)
	appendIfUnique patharray (wwmt_gameInfoDir + "\\materials\\")
	appendIfUnique patharray (wwmt_exportMats)
	appendIfUnique patharray (wwmt_raw_mats )
	
	
	if extraRootPaths != undefined AND extraRootPaths.count > 0 then (
			nps = #()
			for p in patharray do (
				for p2 in extraRootPaths do (
				
					appendIfUnique nps (p+"\\"+p2)
					
				)
				
			)
		
			if nps.count > 0 then (
				for n in nps do (
					appendifunique patharray n
				)
			)
	)
	
	
	--format "###########\nPaths:\t%\nMaterial Name: \t%\n" patharray fname
	global wallworm_debug
								
	
	for p in patharray do (
		
		theTex = (p+"\\"+fname+".vmt")
		if wallworm_debug == true then (
		print ("Looking for: "+theTex)
		)
			
		if doesFileExist theTex then (
			if wallworm_debug == true then (
			print ("FOUND VMT "+theTex)
			)
			return theTex
		)
		
	)
	
	return undefined

)



function wallworm_get_sourcematpaths inp = (
	wallworm_safe_path (getFileNamePath inp)
)


function wallworm_getValueVMTVal ln = (
	
	ln =  substituteString ln "\"" ""
	ln =  substituteString ln "\"" ""
	ln =  substituteString ln "\\\\" "\\"	
	ln =  substituteString ln "\\" "/"	
	ln
)


function wallworm_generateMaterialFromVMT vmt addMat:undefined matType:"brush" brushColor:(color 200 200 20)  modelColor:(color 203 37 5) dispColor:(color 10 240 10)  dispColor2:(color 240 240 10) extraPath:undefined overWriteName:undefined rootPath:undefined extraRootPaths:undefined= (


		local displayMat = undefined
		local diffuseName = ""

		local bumpName = ""
		local opacityName = ""
		local useMat = true

		local lineNum = 0
		local isTranslucent = false
		local selfIllum = false
		local selfIllumName = ""
		local color1
		local color2
		local nocull = false
		local makeNewMats = true --will be false if this was an included vmt
		local theVMT = openFile vmt mode:"r"
	
		if theVMT== undefined do (
			useMat==false
			--print vmt
			return undefined
			)
		
			
		if addMat == undefined then (
			
			local addMat =  Standard diffusemap:(BitmapTexture()) showInViewport:true
			wallworm_give_mat_ww addMat	
		) else (
			makeNewMats = false
		)
		
			
		if overWriteName == undefined then (
			
			
			
			if rootPath == undefined then (
				global wwmt_raw_mats
				if wwmt_raw_mats != undefined AND wwmt_raw_mats != "" AND findString vmt wwmt_raw_mats != 0 then (
					
					rootPath = wwmt_raw_mats
					
				)
				
				
				
			)
			
			
			if makeNewMats == true then (	
				if rootPath != undefined then (
					
					addMat.name = substituteString vmt rootPath ""
					addMat.name = substituteString addMat.name ".vmt" ""
					
				) else (
					
					addMat.name =  getFileNamePath vmt
				)
			)
		) else (
			if makeNewMats == true then (	
				addMat.name =  overWriteName
			)
		)
		if makeNewMats == true then (	
			addMat.name = wallworm_safe_path addMat.name
			addMat.name = wallworm_remove_first_slash addMat.name
			addMat.name = wallworm_remove_last_slash addMat.name
		)
		local blendV = VertexColor()
		--local mp1 = Standard diffusemap:(BitmapTexture()) showInViewport:true
		local mp2 = Standard diffusemap:(BitmapTexture()) showInViewport:true
		local addMatB =  Blend map1:addMat map2:mp2 mask:blendV	showInViewport:true

		wallworm_give_mat_ww addMatB
		--wallworm_give_mat_ww mp1
		wallworm_give_mat_ww mp2
			
		
		--mask:VertexColor 
		while (useMat==true AND not eof theVMT ) do (
			
			lineNum += 1
			
			--try (
			--fLines[lineNum] = filePos theVMT
			local theLine = readLine theVMT

			
			theLine = trimleft theLine
			theLine = trimRight theLine
			theLine = substituteString theLine "\t" " "
			theLine = substituteString theLine "  " " "
			
			--lines to ignore until support for these features are added (to speed gneeration up)		
			if (theLine == "" OR theLine == undefined OR ( (substring theLine 1 2) == "//") ) do continue

			
			if (matchPattern theLine pattern:"*LightmappedGeneric*") == true do (
				matType = "brush"
				
				addMat.valveShader = "LightmappedGeneric"
				continue
				
			)
			
	if ((matchPattern theLine pattern:"*VertexLitGeneric*")==true) then (
		matType = "model"
		addMat.forModel = true
		addMat.valveShader = "VertexLitGeneric"
		continue
	) 
	
			
	
		if (matchPattern theLine pattern:"*WorldVertexTransition*") == true do (
			matType = "blend"

	
			--addMat =  undefined		
	
			addMatB.valveShader = "WorldVertexTransition"
			addMat.valveShader = "LightMappedGeneric"
			addMatB.map2.valveShader = "LightMappedGeneric"
			addMatB.name =  addMat.name

			continue
				
		)		
			

			

			if ((matchPattern theLine pattern:"*$parallaxmap*") == true) do continue
			if ((matchPattern theLine pattern:"*srgb?$basetexture*") == true) do continue
			if ((matchPattern theLine pattern:"*$distancealpha*") == true) do continue			
			
			
			if ((matchPattern theLine pattern:"*$halflambert *") == true) then (
				addMat.halflambert = true
				matType = "model"
				addMat.forModel = true
				continue
			)
			
			if ((matchPattern theLine pattern:"*$FlashlightNoLambert*") == true) then (
				addMat.FlashlightNoLambert = true
				matType = "model"
				addMat.forModel = true
				continue
			)
			
			
			if ((matchPattern theLine pattern:"*$ignorez*") == true) then (
				addMat.ignorez = true
				continue
			)
			if ((matchPattern theLine pattern:"*$nofog*") == true) then (
				addMat.nofog = true
				continue
			)
			if ((matchPattern theLine pattern:"*$alphatest*") == true) then (
			
				addMat.alphatest = true
				continue
			
			)
			
			if ((matchPattern theLine pattern:"*$vertexcolor*") == true) then (
				matType = "model"
				addMat.forModel = true
				addMat.ww_vertexcolor = true
				continue
			
			)
			if ((matchPattern theLine pattern:"*$vertexfog*") == true) then (
				--matType = "model"
				--addMat.forModel = true
				addMat.vertexfog = true
				continue
			
			)
			if ((matchPattern theLine pattern:"*$rimlight*") == true) then (
				addMat.rimlight = true
				matType = "model"
				addMat.forModel = true
				continue
			)
			
			


			
			
			if ((matchPattern theLine pattern:"*$rimmask*") == true) then (
				addMat.rimmask = true
				matType = "model"
				addMat.forModel = true
				continue
			)
			
			
			if ((matchPattern theLine pattern:"*$nocull*") == true) then  (
				nocull = true
				addMat.twoSided = on
				continue
			)
			
			if ((matchPattern theLine pattern:"*$additive*") == true) then (
				addMat.opacityType =	2
				continue
			)
			

			
			if ((matchPattern theLine pattern:"*$writeZ*") == true) then (
				addMat.writeZ = true
				continue
			)
			
			if ((matchPattern theLine pattern:"*$ssbump2*") == true) then (
				addMatB.ssbump2 = true
				addMatB.map2.ssbump = true
				continue
			) else if ((matchPattern theLine pattern:"*$ssbump*") == true) then (
				addMat.ssbump2 = true
				addMatB.ssbump = true
				continue
			) 
			
			if ((matchPattern theLine pattern:"*%compilehint*") == true) then (
				addMat.compilehint = true
				continue
			)	
			
			if ((matchPattern theLine pattern:"*%compileladder*") == true) then (
				addMat.compileladder = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compileNoLight*") == true) then (
				addMat.compileNoLight = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compilenpcclip*") == true) then (
				addMat.compilenpcclip = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compileorigin*") == true) then (
				addMat.compileorigin = true
				continue
			)

			if ((matchPattern theLine pattern:"*%compileclip*") == true) then (
				addMat.compileclip = true
				continue
			)	
			
			if ((matchPattern theLine pattern:"*%compilenodraw*") == true) then (
				addMat.compilenodraw = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compilenonsolid*") == true) then (
				addMat.compilenonsolid = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compilepassbullets*") == true) then (
				addMat.compilepassbullets = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compile2Dsky*") == true) then (
				addMat.compile2Dsky = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compileDetail*") == true) then (
				addMat.compileDetail = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compilefog*") == true) then (
				addMat.compilefog = true
				continue
			)
			

			
			
			
			
			
			if ((matchPattern theLine pattern:"*%compilewater*") == true) then (
				addMat.compilewater = true
				continue
			)	
			
			if ((matchPattern theLine pattern:"*%compiletrigger*") == true) then (
				addMat.compiletrigger = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compileplayercontrolclip*") == true) then (
				addMat.compileplayercontrolclip = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compileskip*") == true) then (
				addMat.compileskip = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compilesky*") == true) then (
				addMat.compilesky = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compileSlime*") == true) then (
				addMat.compileSlime = true
				continue
			)
			if ((matchPattern theLine pattern:"*%compileTeam*") == true) then (
				addMat.compileTeam = true
				continue
			)
			
			local lineArray = filterString theLine " "
				
			if lineArray.count >= 1 then (
				param = lineArray[1]
			) else (
				param = theLine
			)
				
			param = substituteString param "\"" ""

			
			if lineArray.count > 1 then (
				val = lineArray[2]
				
				val = substituteString val "\"" ""
				
				if matchPattern val pattern:"*//*" == true then (
					
					pos = findString val "//"
					if pos > 1 then (
					
					val = substring val 1 (pos - 1)
					) else (
							val = undefined
							continue
					)
				)

			) else (
				
				val = undefined
				continue
			)
				
			
	
			if (  (matchPattern param pattern:"*$model*") == true AND ((matchPattern param pattern:"*$modelmaterial*") == false ) AND val !=undefined AND ((matchPattern val pattern:"*true*") OR (matchPattern val pattern:"*1*") )) do (
			
				matType = "model"
				addMat.forModel = true

				
				

			
			) 
			
	
	
			if ((matchPattern theLine pattern:"*include*")==true) then (
				
				vmtval = val
			
				if findString vmtval "materials/" == 1 then (
					vmtval = replace vmtval 1 10 ""
					
				)
			
				vmtval = wwmt_raw_mats + "/"+vmtval
			
				wallworm_generateMaterialFromVMT vmtval addMat:addMat matType:matType brushColor:brushColor  modelColor:modelColor dispColor:dispColor  dispColor2:dispColor2 extraPath:extraPath overWriteName:overWriteName rootPath:rootPath extraRootPaths:extraRootPaths
			
				continue
			)
				
				
			/*	
			if ((matchPattern theLine pattern:"*$alpha *") == true) then (
			
				addMat.opacity =	((wallworm_getValueVMTVal val) as integer) * 100
									
				continue
			
			)

*/
				/*
				skip all transforms for now ... add support later
				*/
				if ((matchPattern theLine pattern:"*texturetransform*") == true)  then (
				--write function for transform
				continue 
				)  
				/*
				if ((matchPattern theLine pattern:"*$basetexturetransform*") == true) AND ((matchPattern theLine pattern:"*$basetexturetransform2*") == false)  then (
				--write function for transform
				continue 
				)  else if ((matchPattern theLine pattern:"*$basetexturetransform2*") == true) then (
				
				
					continue 
				)
				*/

			case param of (
				"$surfaceprop":(
					if addMat != undefined then (
						addMat.surfaceproperty = val
					)
					if addMatB != undefined then (
						addMatB.surfaceproperty = val
					)
					continue
				
				)
				"$alpha":(

					if val != undefined then (
						op = (val as integer)
						if op != undefined then (
							addMat.opacity = (op) * 100
							
						)
					)
				continue
				
				)
				
				

				"%detailtype":(
					addMat.detail = val
					addMatB.detail = val
					continue
				)
				
				
				"$surfaceprop2":(
					addMatB.map2.surfaceproperty = val
					addMatB.surfaceproperty2 = val
					continue				
				)
				"$alpha2":(

					if val != undefined then (
						op = (val as integer)
						if op != undefined then (
							addMatB.map2.opacity = (op) * 100
						)
					)
					continue				
				)
				
				
				
				"%detailtype2":(
					addMatB.detail2 = val
					continue
				)
				
				default:()
			)
			

			if ((matchPattern theLine pattern:"*$envmapsaturation*") == true) then (
				addMat.useEnvSettings = true
				if addMat.envmapsaturation != undefined AND val != undefined then ( 
					
					if lineArray.count < 3 then (
						if val as float != undefined then (
							addMat.envmapsaturation = val as float
						)
					) else (
						c = wallworm_get_color_from_string_arrays lineArray  t:"float"
						if c != undefined then (
							addMat.envmapsaturation = c
						)
						--addMat.envmapsaturation = val as float
					)
				)
				continue
			)
			
			if ((matchPattern theLine pattern:"*$envmapcontrast*") == true) then (
				addMat.useEnvSettings = true
				if val as float != undefined then (
					addMat.envmapcontrast = val as float
				)
				continue
			)
			
			

			
			
			
			if ((matchPattern theLine pattern:"*$envmaptint*") == true) then (
			

				addMat.useEnvSettings = true
			
				c = wallworm_get_color_from_string_arrays lineArray  t:"color"

				if c != undefined then (
					--
					addMat.envmaptint = c
				)
			
				continue
			
			)
			


		
			if ((matchPattern theLine pattern:"*$rimexponent*") == true) then (
				addMat.rimlight = true
				if val != undefined AND val as float != undefined then (
					addMat.rimexponent = val as float
				)
				matType = "model"
				addMat.forModel = true
				continue
			)
			
			if ((matchPattern theLine pattern:"*$rimboost*") == true) then (
				addMat.rimlight = true
				if val != undefined AND val as float != undefined then (
					addMat.rimboost = val as float
				)
				matType = "model"
				addMat.forModel = true
				continue
			)
		

			
			
			
			if ((matchPattern theLine pattern:"*$phong*") == true) then (

				addMat.shaderByName = "Phong"
				matType = "model"
				addMat.forModel = true
			
				if val != undefined then (
					if ((matchPattern theLine pattern:"*$phongboost*") == true AND val as float != undefined ) then (
						addMat.phongboost = val as float
						continue
					)
			

				
					if ((matchPattern theLine pattern:"*$phongfresnelranges*") == true ) then (
					


						if lineArray.count > 3 then (
							addMat.phongfresnelranges = (lineArray[2] + " " +  lineArray[3]+ " " +  lineArray[4])

						) else (
							addMat.phongfresnelranges = val as string
						)
						
						addMat.phongfresnelranges = substituteString (addMat.phongfresnelranges) "[" ""
						addMat.phongfresnelranges = substituteString (addMat.phongfresnelranges) "]" ""
						addMat.phongfresnelranges = substituteString (addMat.phongfresnelranges) "\"" ""

						continue
					)
				)
				
				
				if (matchPattern param pattern:"*$phongexponenttexture*") == true AND val != undefined  then (
					
					phongexponenttextureName = wallworm_getValueVMTVal val
					--print diffuseName
					
					addMat.specularMap = BitmapTexture()
					addMat.specularMap.name = (wallworm_get_sourcematpaths phongexponenttextureName)
					
					local theTex = wallworm_getBitmapFromPaths phongexponenttextureName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
					tex1	= theTex[1]
					canClose 	= theTex[2]
					
					
					
					addMat.specularMap.filename = tex1
					if canClose == true do (
						 close addMat.specularMap.bitmap
					)
				) else (
					if ((matchPattern theLine pattern:"*$phongexponent*") == true AND (matchPattern theLine pattern:"*$phongexponenttexture*") == false AND val as float != undefined) then (
						addMat.phongexponent = val as float
						continue
					)
				)
				continue
			
			)
			

				if ((matchPattern theLine pattern:"*$maxfogdensityscalar*") == true) then (
					addMat.use_maxfogdensityscalar = true
					if  val as float != undefined then (
						maxfogdensityscalar = val as float
					)
					matType = "model"
					addMat.forModel = true
					continue
				)


				if ((matchPattern theLine pattern:"*$disablecsmlookup*") == true) then (
					addMat.disablecsmlookup = true
					matType = "model"
					addMat.forModel = true
					continue
				)



			
			if ((matchPattern theLine pattern:"*$treeSway*") == true) then (
				matType = "model"
				addMat.forModel = true
			
				addMat.treeSway = true
				if val != undefined then (
					if ((matchPattern theLine pattern:"*$treeSwayHeight*") == true) then (
						addMat.treeSwayHeight = val as float
						continue
					)
					
					if ((matchPattern theLine pattern:"*$treeSwayStartHeight*") == true) then (
						addMat.treeSwayStartHeight = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwayRadius*") == true) then (
						addMat.treeSwayRadius = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwayStartRadius*") == true) then (
						addMat.treeSwayStartRadius = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwaySpeed*") == true) then (
						addMat.treeSwaySpeed = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwayStrength*") == true) then (
						addMat.treeSwayStrength = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwayScrumbleSpeed*") == true) then (
						addMat.treeSwayScrumbleSpeed = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwayScrumbleStrength*") == true) then (
						addMat.treeSwayScrumbleStrength = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwayScrumbleFrequency*") == true) then (
						addMat.treeSwayScrumbleFrequency = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwayFalloffExp*") == true) then (
						addMat.treeSwayFalloffExp = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwayScrumbleFalloffExp*") == true) then (
						addMat.treeSwayScrumbleFalloffExp = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwaySpeedHighWindMultiplier*") == true) then (
						addMat.treeSwaySpeedHighWindMultiplier = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwaySpeedLerpStart*") == true) then (
						addMat.treeSwaySpeedLerpStart = val as float
						continue
					)
					if ((matchPattern theLine pattern:"*$treeSwaySpeedLerpEnd*") == true) then (
						addMat.treeSwaySpeedLerpEnd = val as float
						continue
					)
				)
				continue
			
			)
			

			
			if ((matchPattern theLine pattern:"*$lightjitter*") == true) then (
				matType = "model"
				addMat.forModel = true
			
				addMat.detailsprite = true
				addMat.useJitter = true
			
			
			
				if ((matchPattern theLine pattern:"*$lightjitteramount*") == true) then (
					addMat.lightjitteramount = val as float
					continue
				)
				

				if ((matchPattern theLine pattern:"*$lightjittersin1angle*") == true) then (
					addMat.lightjittersin1angle = val as float
					continue
				)
				if ((matchPattern theLine pattern:"*$lightjittersin1speed*") == true) then (
					addMat.lightjittersin1speed = val as float
					continue
				)
				if ((matchPattern theLine pattern:"*$lightjittersin1dispersion*") == true) then (
					addMat.lightjittersin1dispersion = val as float
					continue
				)
				
				if ((matchPattern theLine pattern:"*$lightjittersin2angle*") == true) then (
					addMat.lightjittersin2angle = val as float
					continue
				)
				if ((matchPattern theLine pattern:"*$lightjittersin2speed*") == true) then (
					addMat.lightjittersin2speed = val as float
					continue
				)
				if ((matchPattern theLine pattern:"*$lightjittersin2dispersion*") == true) then (
					addMat.lightjittersin2dispersion = val as float
					continue
				)
				
				if ((matchPattern theLine pattern:"*$lightjittersin3angle*") == true) then (
					addMat.lightjittersin3angle = val as float
					continue
				)
				if ((matchPattern theLine pattern:"*$lightjittersin3speed*") == true) then (
					addMat.lightjittersin3speed = val as float
					continue
				)
				if ((matchPattern theLine pattern:"*$lightjittersin3dispersion*") == true) then (
					addMat.lightjittersin3dispersion = val as float
					continue
				)
				if ((matchPattern theLine pattern:"*$lightjittergustmultiplier*") == true) then (
					addMat.lightjittergustmultiplier = val as float
					continue
				)
				if ((matchPattern theLine pattern:"*$lightjittergustspeed*") == true) then (
					addMat.lightjittergustspeed = val as float
					continue
				)
				
			if ((matchPattern theLine pattern:"*$lightjittercolour*") == true) then (
			
			

			
			
				c = wallworm_get_color_from_string_arrays lineArray t:"color"
				if c != undefined then (
						addMat.lightjittercolour = c
				)

				continue
			
			)
				
				
				
				
				continue
			
			)
			
			
			
			
			if ((matchPattern theLine pattern:"*$reflectivity*") == true) then (
			
			
				addMat.useReflectivity = true
			
			
				c = wallworm_get_color_from_string_arrays lineArray t:"color"
				if c != undefined then (
						addMat.reflectivity = c
				)

				continue
			
			)
			
			

			if ((matchPattern theLine pattern:"*$detailscale*") == true) then (
				
				addMat.usedetailscale = true
				if val != undefined AND (val as float) != undefined then (
					addMat.detailscale = val as float
				)
				continue
			)
			
			

			if ((matchPattern theLine pattern:"*$detailblendfactor*") == true) then (
				addMat.useadvanceddetail = true
				if val != undefined AND (val as float) != undefined then (
					addMat.detailblendfactor = val as float
				)
				continue
			)
			
			if ((matchPattern theLine pattern:"*$detailblendmode*") == true) then (
				addMat.useadvanceddetail = true
				if val != undefined AND (val as float) != undefined then (
					addMat.detailblendmode = val as float
				)
				continue
			)
			
			if ((matchPattern theLine pattern:"*$detailtint*") == true) then (
			
			
				addMat.useadvanceddetail = true
			
				c = wallworm_get_color_from_string_arrays lineArray
				if c != undefined then (
					--print c
					addMat.detailtint = c
				)
			
			

				continue
			
			)

			if ((matchPattern theLine pattern:"*$seamless_scale*") == true) then (
				addMatB.use_seamless_scale = true
				if val != undefined AND (val as integer) != undefined then (
					addMatB.seamless_scale = val as integer
				)
				continue
			)

			
			
			if ((matchPattern theLine pattern:"*%keywords*") == true) then (
			
			
				local kwvars = filterString val ","
			
				addMat.keywords = kwvars
				continue
			)
			



			if ((matchPattern theLine pattern:"*$decal*") == true) then (
				addMatB.decal = true
				addMat.decal = true
				if ((matchPattern theLine pattern:"*$decalscale*") == true) then (
					if val != undefined AND (val as float) != undefined then (
						addMat.decalscale = val as float
						addMatB.decalscale = val as float
					)
					continue
				)
				
				if ((matchPattern theLine pattern:"*$decalfadeduration*") == true) then (
					if val != undefined AND (val as float) != undefined then (
						addMat.decalfadeduration = val as float
						addMatB.decalfadeduration = val as float
					)
					continue
				)
				
				if ((matchPattern theLine pattern:"*$decalfadetime*") == true) then (
					if val != undefined AND (val as float) != undefined then (
						addMat.decalfadetime = val as float
						addMatB.decalfadetime = val as float
					)
					continue
				)
				continue
			)
			
			
			if ((matchPattern theLine pattern:"*$modelmaterial*") == true) then (
				addMat.modelmaterial = val
				addMatB.modelmaterial = val
				continue
			)
			
			if ((matchPattern theLine pattern:"*$fogscale*") == true) then (
				if val != undefined AND (val as float) != undefined then (
					addMat.fogscale = val as float
					addMatB.fogscale = val as float
				)
				continue
			)
			

			


			if ((matchPattern theLine pattern:"*$rimexponent*") == true) then (
				addMat.rimexponent = val as float
				addMatB.rimexponent = val as float
				continue
			)		
			
			if ((matchPattern theLine pattern:"*$rimboost*") == true) then (
				addMat.rimboost = val as float
				addMatB.rimboost = val as float
				continue
			)		
			
				
/*
				if val == undefined then(
					--print ((lineNum as string) + " : "+theLine + " evaluated to : Param : "+param+" ; Val : undefined")
					
					) else (
				--print ((lineNum as string) + " : "+theLine + " evaluated to : Param : "+param+" ; Val : "+val)
			)
	*/		
			

			
			

		


	if val !=undefined then (	
		
		if ((matchPattern param pattern:"*$color2*") == true AND lineArray.count >=4)   then (


					
				c = wallworm_get_color_from_string_arrays lineArray  t:"color"

				if c != undefined then (
					--
					color2 = c
				)
					
					
		
		) else if ((matchPattern param pattern:"*$color*") == true AND lineArray.count >=4)   then (
			c = wallworm_get_color_from_string_arrays lineArray  t:"color"

				if c != undefined then (
					--
					color1 = c
				)
	)

	)
	
	
	

	
	
	
	
			
if (((matchPattern param pattern:"*$baseTexture*") == true)  AND val !=undefined AND ( (matchPattern param pattern:"*$baseTexture2*") == false)  )  do (
	
	

	if 	matType == "blend" then (
		addMat.name=val
	)


	diffuseName = wallworm_getValueVMTVal val



	if diffuseName == "" do (
		--print ("Failed on this String: "+theLine)
		 --continue
		)
	
	local theTex = wallworm_getBitmapFromPaths diffuseName extraPath:extraPath extraRootPaths:extraRootPaths collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]

		
	if addMat != undefined do (
	
	   --print diffuseName
		
		if wwmt_legacy_names == true AND matType=="model" then (
		
		addMat.name=diffuseName
		) else (
			

		)
		addMat.diffusemap.filename = tex1
		addMat.diffusemap.name = wallworm_get_sourcematpaths diffuseName

		
		if canClose == true do (
			close addMat.diffusemap.bitmap
		)
	) 

	
	
	/*				close theVMT
	return addMat
	if addMatB != undefined do (
		addMatB.map1.diffusemap.name = wallworm_get_sourcematpaths diffuseName
		addMatB.map1.diffusemap.filename = tex1
		--print addMatB.map1.diffusemap.filename 
		if canClose == true do (
			close addMatB.map1.diffusemap.bitmap
		)
	)
	*/
	
      
		
	)

	

	if  (matchPattern param pattern:"*$baseTexture2*") == true AND val != undefined do (
	
	--addMat =  undefined			


	addMatB.map2.name=val
	dName = wallworm_getValueVMTVal val
		

		
	local theTex = wallworm_getBitmapFromPaths dName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex2	= theTex[1]
	canClose = theTex[2]

		addMatB.map2.diffusemap.filename = tex2
		
		addMatB.map2.diffusemap.name = wallworm_get_sourcematpaths dName
		
		if canClose == true do (
			close addMatB.map2.diffusemap.bitmap
		)
		--print addMatB.map2.diffusemap.filename 
	

		
	)

	
	if  (matchPattern param pattern:"*$blendmodulatetexture*") == true AND val != undefined do (
	
	--addMat =  undefined			
	
	dName = wallworm_getValueVMTVal val
		
	local theTex = wallworm_getBitmapFromPaths dName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex2	= theTex[1]
	canClose = theTex[2]

		addMatB.mask = BitmapTexture()
		addMatB.mask.name = wallworm_get_sourcematpaths dName		

		addMatB.mask.filename = tex2

		
		if canClose == true do (
			close addMatB.mask.bitmap
		)
		--print addMatB.map2.diffusemap.filename 
	

		
	)
	

	

	
if (matchPattern param pattern:"*$AmbientOcclTexture*") == true AND val != undefined   do (
	
	ambientocclusionName = wallworm_getValueVMTVal val
	--print diffuseName
	
	addMat.ambientMap = BitmapTexture()
	addMat.ambientMap.name = (wallworm_get_sourcematpaths ambientocclusionName)
	
	local theTex = wallworm_getBitmapFromPaths ambientocclusionName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
	
	
	addMat.ambientMap.filename = tex1
	if canClose == true do (
		 close addMat.ambientMap.bitmap
	)
)
	
	
	

if (matchPattern param pattern:"*$bumpmap*") == true AND (matchPattern param pattern:"*$bumpmap2*") == false AND val != undefined  then (
	
	bumpName = wallworm_getValueVMTVal val
	--print diffuseName
	
	addMat.bumpmap = BitmapTexture()
	addMat.bumpmap.name = (wallworm_get_sourcematpaths bumpName)
	
	local theTex = wallworm_getBitmapFromPaths bumpName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
	
	
	addMat.bumpmap.filename = tex1
		if canClose == true do (
		 close addMat.bumpmap.bitmap
		)
) else if (matchPattern param pattern:"*$bumpmap2*") == true AND val != undefined  then (
	
	bumpName = wallworm_getValueVMTVal val
	--print diffuseName
	
	addMatB.map2.bumpmap = BitmapTexture()
	addMatB.map2.bumpmap.name = (wallworm_get_sourcematpaths bumpName)
	
	local theTex = wallworm_getBitmapFromPaths bumpName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
	
	
	addMatB.map2.bumpmap.filename = tex1
		if canClose == true do (
		 close addMatB.map2.bumpmap.bitmap
		)
)
		

if (matchPattern param pattern:"*$lightwarptexture*") == true AND (matchPattern param pattern:"*$lightwarptexture2*") == false AND val != undefined  then (
	
	bumpName = wallworm_getValueVMTVal val
	--print diffuseName
	
	addMat.lightwarptexture = BitmapTexture()
	addMat.lightwarptexture.name = (wallworm_get_sourcematpaths bumpName)
	
	local theTex = wallworm_getBitmapFromPaths bumpName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
	
	
	addMat.lightwarptexture.filename = tex1
		if canClose == true do (
		 close addMat.lightwarptexture.bitmap
		)
) else if (matchPattern param pattern:"*$lightwarptexture2*") == true AND val != undefined  then (
	
	bumpName = wallworm_getValueVMTVal val
	--print diffuseName
	
	addMatB.map2.lightwarptexture = BitmapTexture()
	addMatB.map2.lightwarptexture.name = (wallworm_get_sourcematpaths bumpName)
	
	local theTex = wallworm_getBitmapFromPaths bumpName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
	
	
	addMatB.map2.lightwarptexture.filename = tex1
		if canClose == true do (
		 close addMatB.map2.lightwarptexture.bitmap
		)
)
		



if (matchPattern theLine pattern:"*$translucent*") == true do (
	
	addMat.opacityMap = addMat.diffusemap
	isTranslucent = true
	)	

if (matchPattern theLine pattern:"*$selfillum*" )==true do (
	
	selfIllum = true
	

	)	

	if (matchPattern param pattern:"*$selfillumtexture*") == true AND (matchPattern param pattern:"*$selfillumtexture2*") == false AND val != undefined  AND addMat != undefined  do (
	
	selfIllumName = wallworm_getValueVMTVal val
	--print diffuseName
	
	addMat.selfIllumMap  = BitmapTexture()
	addMat.selfIllumMap.name = (wallworm_get_sourcematpaths selfIllumName)
		

	local theTex = wallworm_getBitmapFromPaths selfIllumName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
	addMat.selfIllumMap.filename = tex1
				if canClose == true do (
					close addMat.selfIllumMap.bitmap
				)
	)
	
	
	if (matchPattern param pattern:"*$selfillumtexture2*") == true AND val != undefined    do (
	
	selfIllumName = wallworm_getValueVMTVal val
	--print diffuseName
	
	addMatB.map2.selfIllumMap  = BitmapTexture()
	addMatB.map2.selfIllumMap.name = (wallworm_get_sourcematpaths selfIllumName)
		

	local theTex = wallworm_getBitmapFromPaths selfIllumName extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
	addMatB.map2.selfIllumMap.filename = tex1
				if canClose == true do (
					close addMatB.map2.selfIllumMap.bitmap
				)
	)

	
	
	if ((matchPattern theLine pattern:"*$envmap*") == true) then (
	
	
	)

	
	if (matchPattern param pattern:"*$envmapmask*") == true AND (matchPattern param pattern:"*$envmapmask2*") == false AND val != undefined  do (
	
	envmapmask = wallworm_getValueVMTVal val
	--print diffuseName
	
	addMat.specularLevelMap  = BitmapTexture()
	addMat.specularLevelMap.name = (wallworm_get_sourcematpaths envmapmask)
		
	local theTex = wallworm_getBitmapFromPaths envmapmask extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
	addMat.specularLevelMap.filename = tex1
				if canClose == true do (
					close addMat.specularLevelMap.bitmap
				)
	)
	
	if (matchPattern param pattern:"*$envmapmask2*") == true  AND val != undefined    do (
	
	envmapmask = wallworm_getValueVMTVal val
	--print diffuseName
	
		addMatB.map2.specularLevelMap  = BitmapTexture()
		addMatB.map2.specularLevelMap.name = (wallworm_get_sourcematpaths envmapmask)
		
	local theTex = wallworm_getBitmapFromPaths envmapmask extraPath:extraPath extraRootPaths:extraRootPaths  collecting:false
	tex1	= theTex[1]
	canClose 	= theTex[2]
	
		addMatB.map2.specularLevelMap.filename = tex1
				if canClose == true do (
					close 	addMatB.map2.specularLevelMap.bitmap
				)
	)
	

	
	
	
	
	
			--$bumpmap
				
 -- returns true


				
			
			
			--) catch ()
		)
		if theVMT != undefined do (
			close theVMT
		)

		--addMatB.map1 = addMat
		

		
		if useMat == true do (	
			
		
		
		if (addMat.forModel == true) then (

			--get the cdmaterials from the file path starting from materials/
			addMat.cdmaterials = wallworm_bstofs ( getFileNamePath addMat.name)
		
		) 

			
		if addMat.detailsprite== true OR addMat.alphatest == true then (
				
			
			addMat.opacityMap = addMat.diffuseMap
			addMat.opacityMap.monoOutput = 1
			
		)
			
			

		if addMatB != undefined do (
			displayMatnameB = addMatB.name
		)
		
		if addMat != undefined do (
			--displayMatname = ((count as string)+" "+addMat.name)
			displayMatname = addMat.name
			addMat.name = addMat.name -- + " render"
			
		)
		

		
		if matType == "blend" then (
			--displayMat = DirectX_9_Shader renderMaterial:addMatB effectFilename:"$maps/fx/blend_dxsas.fx"
			

			
			/*
			!!TODO swap the order of map1 & 2
			*/
			
			addMatB.map1 = addMat
		
			displayMat = wallworm_blend_to_DXBlend mat:addMatB rev:true
			--
			/*bm1 = openBitMap addMatB.map1.diffusemap.filename
			if bm1 != undefined then (
				bm1a = bitmaptexture bitmap:bm1 filename:addMatB.map1.diffusemap.filename
				displayMat.seteffectbitmap 1 bm1
				
				close bm1
				
			) else (
				
				--displayMat.seteffectbitmap 1 addMatB.map1.diffusemap.filename
				
				)
			
			bm2 = openBitMap addMatB.map2.diffusemap.filename
			if bm2 != undefined do (
				bm2a = bitmaptexture bitmap:bm2 filename:addMatB.map2.diffusemap.filename
				displayMat.seteffectbitmap 2 bm2
				close bm2
			)
			*/
			
			
			if color1 != undefined  then (
				
				
				addMatB.map1.diffuse = color1
				addMatB.map1.ambient = color1
				
			) else (
				
				--addMatB.map1.diffuse = dispColor
				
				)
			
			if color2 != undefined   then ( 
				
				addMatB.map2.diffuse = color2
				addMatB.map2.ambient = color2
				
			) else (
				
				addMatB.map2.diffuse = dispColor2
				
				
				)
			
			
				
				
				
			oldm1 = addMatB.map1
			--oldm2 = addMatB.map2
				
				
			addMatB.map1 = addMatB.map2
			addMatB.map2	 = oldm1
				
				
			--addMatB.name = displayMatnameB
			displayMat.name = displayMatnameB
		) else (
			
				
			if color1 != undefined then (	
				if  matType != "model" then (
				
				
				addMat.diffuse = color1
				addMat.ambient = color1
				
				) 
			) else (

				if  matType != "model" then (
				
				
					addMat.diffuse = brushColor
					addMat.ambient = brushColor
				
				) 
				
			)
			
			if color2 != undefined then (	
				if  matType == "model" then (
				
				
				addMat.diffuse = color2
				addMat.ambient = color2
				
				) 
			) else (

				if  matType != "model" then (
				
				
					addMat.diffuse = brushColor
					addMat.ambient = brushColor
				
				)  else (
					addMat.diffuse = modelColor
					addMat.ambient = modelColor
					
				)
				
			)
			
			
			displayMat = addMat
			displayMat.name = displayMatname
			

			)
		

			)


	
	displayMat
	)
	
	
function wallworm_getLibraryFromMatName matname debug:false= (
	local lib = undefined
	matname = wallworm_remove_last_slash matname
	
	
	global wallworm_debug
	
	if wallworm_debug != undefined AND  wallworm_debug == true then (
			debug = true
	)
	if debug == true then (
		print ("Looking for this material: "+matname)
	)
	
		libpath = filterString matname "/" splitEmptyTokens:false
		if debug == true then (
			print ("Material broken into this: "+libpath as string)
		)
		if libpath.count > 1 then (
			local matlib = ((trimLeft (trimRight libpath[1]))+".mat")
			if debug == true then (
				print matlib
			)
			if doesFileExist matlib == true then (
				lib = loadMaterialLibrary  matlib
			)
		)
		

	
	lib
)
	
	
function wallworm_VMFIMPORT_getExistingMaterial matName mats:materials openLib:false = (
		local m
		--look in the existing mats array probably generated by script
		if mats != undefined then (
			for m in mats do (
				
				if m.name == matName then (
					
					return m
				)
			)
		)
					--look in the existing scene mats
			if sceneMaterials.count > 0 then (
				m = sceneMaterials[matName]
				if m != undefined then (
					
					return m
					
				)
			)
			
					--look in the current material library
			if currentMaterialLibrary.count > 0 then (
				m = currentMaterialLibrary[matName]
				if m != undefined then (
					
					return m
					
				)
			)
			
			--optionally, open a material library that matches the root path of the material name. Assumes a library is named from root directories
			if openLib == true then (
				lib = wallworm_getLibraryFromMatName matName 
				
				if lib != undefined AND lib != false then (
					if currentMaterialLibrary.count > 0 then (
						m = currentMaterialLibrary[matName]
						if m != undefined then (
							
							return m
							
						)
					)
					
				)
			)
			
			m
	)
	
	function wallworm_VMFIMPORT_createMaterial matName openLib:false color:undefined matType:"brush"  extraPath:undefined extraRootPaths:undefined = (
		
		vmt = wallworm_getVMTFromPaths matName extraPath:extraPath  extraRootPaths:extraRootPaths
		
		
		
		if vmt != undefined then (
			newMat =  (wallworm_generateMaterialFromVMT vmt matType:matType overWriteName:matName extraPath:extraPath extraRootPaths:extraRootPaths )
		) else (
			newMat = Standard()
			newMat.name = matName
			if color != undefined then (
				newMat.diffuse = color
			)
		)
		newMat
	)
	
	function wallworm_VMFIMPORT_getMaterial matName mats:materials color:undefined openLib:false matType:undefined extraPath:undefined extraRootPaths:undefined= (
		
		mat = wallworm_VMFIMPORT_getExistingMaterial matName mats:materials openLib:openLib  matType:matType extraPath:extraPath  extraRootPaths:extraRootPaths
		
		if mat == undefined AND extraRootPaths != undefined AND extraRootPaths.count > 0 then (
			
				for p in extraRootPaths  while mat == undefined do (
						
					mat = wallworm_VMFIMPORT_getExistingMaterial (p+"/"+matName) mats:materials openLib:openLib  matType:matType 
				)
		)
		
		
		if mat == undefined then (

			mat = wallworm_VMFIMPORT_createMaterial matName color:color   matType:matType extraPath:extraPath  extraRootPaths:extraRootPaths
			
		)
		return mat
		
	)
	
	function wallworm_update_material_from_vmt mat matType:undefined extraPath:undefined extraRootPaths:undefined color:undefined = (
		
		if mat != undefined then (

			newmat = wallworm_VMFIMPORT_createMaterial mat.name color:color   matType:matType extraPath:extraPath  extraRootPaths:extraRootPaths
			
			if newmat != undefined then (

				if classof mat == directX_9_shader AND mat.renderMaterial != undefined AND classof newmat == directX_9_shader AND newmat.renderMaterial != undefined then (

					index = wallworm_get_ca_index_by_name newmat.renderMaterial "Wallworm Material"
					
					if index != undefined then (
						wallworm_copy_ca index newmat.renderMaterial mat.renderMaterial
						--format "copying % to %\n" newmat mat
					)
					
				) else (
					
					index = wallworm_get_ca_index_by_name newmat "Wallworm Material"
					--format "Root % to %\n" newmat mat
					wallworm_copy_ca index newmat mat
				)
					
			) else (
				
					--print "vmt not loaded"
			)
			
		)
		
		
	)

function wallworm_reload_world_materials = (

	max create mode
	with redraw off
	undo off (
		local mats = for m in scenematerials where (isProperty m "wallworm" AND m.forModel == false) OR (classof m == DirectX_9_Shader)  collect m
		for m in mats  do (

			local matName = m.name
			
			vmt = wallworm_getVMTFromPaths matName
			
			if vmt != undefined then (
				
				newMat =  (wallworm_generateMaterialFromVMT vmt overWriteName:(matName))
				
				if newMat != undefined then (
					
					local objs = for obj in objects where obj.mat == m collect obj
					
					for obj in objs do (
						obj.mat = newMat
					)
				)

			)

			
		)
	)
)
	