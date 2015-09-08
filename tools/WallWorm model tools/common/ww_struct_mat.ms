/*
Material Struct for Wall Worm Mod Tools
Copyright (c) 2010-2014
All Rights Reserved

http://www.wallworm.com

Written by Shawn Olson
http://www.shawnolson.net

Unfortunately, this struct was started early in my MAXScripting days... and it is very inneficient in many ways.

But like they say, if it ain't broke, don't fix it. I'll likely start from scratch at some point, though.


*/

Struct ww_vmt(
	mat,
	mat1,
	mat2,
	diff,
	diff2,
	diffColor,
	useDiffColor = true,
	bump,
	bump2,
	normal,
	normal2,
	detail,
	detail2,
	spec,
	spec2,
	ambient,
	illum,
	illum2,
	refract,
	materialPath,
	materialPath2,
	specLevelMap,
	specLevelMap2,
	reflectionMap,
	reflectionMap2,
	blendmodulate,
	blendmodulatetransform,
	decal = false,
	rotationAngle = undefined,
	/*
	_model, --VertexLitGeneric
	_basetexture,
	_basetexture2, --for WOrldVertexTransition
	_envmap,
	_envmap2, --for WOrldVertexTransition
	_basetexturenoenvmap =false,
	_basetexture2noenvmap =false, --for WOrldVertexTransition
	_blendmodulatetexture, --for WOrldVertexTransition
	_ssbump = false,
	_ssbump2 = false, --for WOrldVertexTransition
	_normalmap,
	_normalmap2, --for WOrldVertexTransition
	_bumpmap,
	_bumpmap2, --for WOrldVertexTransition
	_basealphaenvmapmask,
	_basealphaenvmapmask2, --for WOrldVertexTransition
	_selfillum_envmapmask_alpha,
	_selfillum_envmapmask_alpha2, --for WOrldVertexTransition
	_envmapmask,
	_envmapmask2, --for WOrldVertexTransition
	_normalmapalphaenvmapmask,
	_normalmapalphaenvmapmask2, --for WOrldVertexTransition
	_AmbientOcclusion,
	_AmbientOcclTexture,
	_detail,
	_detail2, --for WOrldVertexTransition
	_selfillum,
	_selfillum2, --for WOrldVertexTransition
	_selfillumtexture,
	_selfillumtexture2, --for WOrldVertexTransition
	_selfillummask,
	_selfillummask2, --for WOrldVertexTransition
	_phong, --VertexLitGeneric
	_phongexponenttexture, --VertexLitGeneric
	_phongboost, --VertexLitGeneric
	_phongfresnelranges, --VertexLitGeneric
	_refracttinttexture,
	_refracttinttexture2,--for WOrldVertexTransition
	_bluramount,
	_bluramount2,--for WOrldVertexTransition
	_refracttint,
	_refracttint2,--for WOrldVertexTransition
	_bluramount,
	_bluramount2,--for WOrldVertexTransition
	_refractamount,
	_refractamount2,--for WOrldVertexTransition
	_reflectivity,
	_reflectivity2,--for WOrldVertexTransition
	_alpha,
	_alpha2,--for WOrldVertexTransition
	_alphatest=false,
	_alphatest2=false,--for WOrldVertexTransition
	_translucent=false,
	_translucent2=false,--for WOrldVertexTransition
	_color,
	_color2,--for WOrldVertexTransition
	_nocull = false,
	_vertexalpha,
	_vertexcolor,
	_surfaceprop,
	_surfaceprop2,
	_seamless_scale,--for WOrldVertexTransition
	_basetexturetransform,
	_basetexturetransform2, --for WOrldVertexTransition*/
	basetexturetransform,
	basetexturetransform2,
	envmapmasktransform,
	envmapmasktransform2,
	bumptransform,
	bumptransform2,
	detailtexturetransform,
	detailtexturetransform2,
	selfillumtexturetransform,
	selfillumtexturetransform2,
	speculartransform,
	speculartransform2,
	lightwarptexture,
	lightwarptexture2,
	lightwarptexturetransform,
	parallaxmap,
	parallaxmaptransform,
	parallaxmap2,
	parallaxmapscale,
	valveShader="VertexLitGeneric",
	matName="",
	matName2="",
	forModel=true,
	getNameFromPath=false,
	forceOpaque=false,
	allowedDimension=#(4,16,32,64,128,256,512,1024,2048,4096),
	compression = "dxt5",
	surfaceproperty = "",
    detailtype="",
	frames=#(),
	function getTexName p = (
		--materialNamePath = filterString m "\\"
		--materialNameBats = filterString (materialNamePath[materialNamePath.count]) "." 
		--return materialNameBats[1]
		try (
		f = getFileNameFile p
			
		return f
		) catch (
			return ""
			)
		),
	function outputTexName p = (
		return wallworm_outputTexName p
	),
	function GetVectorsAngle v1 v2 = 
	(
		theAngle = acos(dot (normalize v1) (normalize v2))
	),
	function getBlendToolTexName = (
				--toolName =  ((wallworm_safe_local (wallworm_remove_last_slash mat.name))+"_tool")
				toolName = mat.name + "_tool"
				if classOf mat == Blend AND mat.mask != undefined then (
					
					--mat.mask.name = toolName
					
					--return mat.mask.name
					
				) else (
					
					--return ((wallworm_safe_local mat.name)+"_tool")
				)
			return toolName
		),
		
		/*		
	function getRotationProxie bm type:"basetexturetransform" = (

			"LinearRamp"
            {
                "rate" 45
                "initialValue" 0.0
                "resultVar" "$angle"
            }

            "TextureTransform"
            {
                "translateVar" "$translate"
                "rotateVar" "$angle"
                "centerVar" "$center"
                "resultVar" "$basetexturetransform"
            }


		),	
		*/
	function getScrollProxie bm type:"basetexturetransform"= (
		out = ""
		
		if classOf bm == Normal_Bump then (
			
			if type == "bumptransform" then (
				
				bm = bm.normal_map

				) else (
				
				if type=="detailtransform" then (
					
					bm = bm.bump_map
					)
				
				)
			
			)
		
		
		if classOf bm == BitmapTexture AND bm.numSubs != undefined AND bm.numSubs > 0 then (
			local co = undefined 
			local scrollAngle = undefined
			for i = 1 to bm.numSubs while co == undefined do (
				if ((getSubAnimName bm i asString:true) == "Coordinates") then (
					co = getSubAnim bm i
				) else ()
				
			)
			
			if co != undefined then (

				local timeStart = 0f
				local timeEnd = 0f
				
				
				if co.U_Offset.keys != undefined OR  co.V_Offset.keys != undefined then (
				
				
				if co.U_Offset.keys != undefined AND co.U_Offset.keys.count > 1 then (
					timeStart = co.U_Offset.keys[1].time
					timeEnd = co.U_Offset.keys[2].time
				)
				
				if co.V_Offset.keys != undefined AND co.V_Offset.keys.count >1 then (
					
					if co.V_Offset.keys[1].time.frame < timeStart.frame then (
						timeStart = co.V_Offset.keys[1].time
					)
					
					if co.V_Offset.keys[2].time.frame > timeEnd.frame then (
						timeEnd = co.V_Offset.keys[2].time
					)
				)
				
				--format "############\nKeys for %\n\tU_OFFSET:\t%\n\tV_OFFSET:\t%\n" type ((co.U_Offset.keys)) ((co.V_Offset.keys))
				
				if  timeStart != timeEnd then (
					--print type
					try (
						
					/*local StartA = (at time (timeStart.frame) ([((bm.coordinates.U_Offset * bm.bitmap.width) - bm.bitmap.width), ((bm.coordinates.V_Offset * bm.bitmap.height) - bm.bitmap.height ),0]) ) 
					local EndA = (at time (timeEnd.frame) ([((bm.coordinates.U_Offset * bm.bitmap.width) - bm.bitmap.width), ((bm.coordinates.V_Offset * bm.bitmap.height) - bm.bitmap.height ),0]) ) */
					
					--local StartA = (at time (timeStart.frame) ([((bm.coordinates.U_Offset * bm.bitmap.width)), ((bm.coordinates.V_Offset) - bm.bitmap.height),0]) ) 
					--local EndA = (at time (timeEnd.frame) ([((bm.coordinates.U_Offset * bm.bitmap.width)), ((bm.coordinates.V_Offset) - bm.bitmap.height),0]) ) 	
						
					local Start = at time (timeStart.frame) ([bm.coordinates.U_Offset,bm.coordinates.V_Offset,0])
					local End = at time (timeEnd.frame) ([bm.coordinates.U_Offset,bm.coordinates.V_Offset,0])
					
					local rate = bm.playBackRate 
					try (
						
						rate = (distance Start End) / ((timeEnd.frame - timeStart.frame) / framerate)--/ frameRate
					) catch (
						print (getCurrentException())
					)
					
					scrollAngle = ((GetVectorsAngle Start End) - 180) * -1
					
					out = ( "\n\tTextureScroll\n\t{\n\t\ttexturescrollvar $"+type+"\n\t\ttexturescrollrate "+(formattedPrint (rate))+"\n\t\ttexturescrollangle "+(formattedPrint scrollAngle)+"\n\t}\n")
											
						
					) catch (
						print (getCurrentException())
						)

					

				) else (
					
					--print "wrong vals"
					
				)
				
			)
				


				
				
				if co.W_Angle.keys != undefined AND co.W_Angle.keys.count > 1 then (
				timeStart = 0f
				timeEnd = 0f
					
					
					timeStart = co.W_Angle.keys[1].time
					timeEnd = co.W_Angle.keys[2].time


				
				--format "############\nKeys for %\n\tU_OFFSET:\t%\n\tV_OFFSET:\t%\n" type ((co.U_Offset.keys)) ((co.V_Offset.keys))
				
				if  timeStart != timeEnd then (
					--print type
					try (
							
						local Start = at time (timeStart.frame) ((bm.coordinates.W_Angle ) )
						local End = at time (timeEnd.frame) ((bm.coordinates.W_Angle ) )
						
						local rate = bm.playBackRate 
						try (
							
							rate = (End - Start) / ((timeEnd.frame - timeStart.frame) / framerate)--/ frameRate
						) catch (
							print (getCurrentException())
						)
						/*
						if scrollAngle == undefined then (
						scrollAngle = ((GetVectorsAngle Start End) - 180) * -1
						)*/
						
						if rotationAngle == undefined then (
							rotationAngle = Start * -1
							out += ("\n\t\"LinearRamp\"\n\n\t\t{\n\n\t\t\t\"rate\" \""+(formattedPrint (rate * -1))+"\"\n\n\t\t\t\"initialValue\" \""+(formattedPrint (Start * -1))+"\"\n\n\t\t\t\"resultVar\" \"$angle\"\n\n\t\t}\n")
						)
						out += ("\n\t\"TextureTransform\"\n\n\t\t{\n\n\t\t\t\"rotateVar\" \"$angle\"\n\n\n\t\t\t\"resultVar\" \"$"+type+"\"\n\n\t\t}\n")

					) catch (
						print (getCurrentException())
					)

					

				) else (
					
					--print "wrong vals"
					
				)
			)
							
				
				
				
				
			) else (
				--print "no coordinate subanim found"
				
				)
			
		) else (
			--print "no subanims"
			)
		
		
		
		return out
		),
	
	function isValidBitmap ext = (
		t = wallworm_isValidBitmap ext
		return t
	),
	function parseIFL f = (

		return wallworm_parseIFL f
	),	
	function useSSBump m = (
		
		if isProperty m "ssbump" == true then (
			return m.ssbump
		) else (
		
		
				if valveShader != "LightmappedGeneric" do (
					
					return false
					
					)

				if m.displacementMap  != undefined then (
					
					
						if classOf m.displacementMap == Normal_Bump do (
						
							mapToUse = m.displacementMap.normal_map
						
							if m.displacementMap.normal_map != undefined AND classOf m.displacementMap.normal_map == Bitmaptexture AND m.displacementMap.normal_map.bitmap.hasAlpha==true do (
								return true
							)
						
							
							
						)
					
					

				)	else (
						
					if m.bumpMap  != undefined do (
				
						if classOf m.bumpMap == Normal_Bump do (
						
							if m.bumpMap.normal_map != undefined AND classOf m.bumpMap.normal_map == Bitmaptexture AND m.bumpMap.normal_map.bitmap.hasAlpha==true do (
								return true
							)
						
						
					

						)			
						
					)

				)
			)
		false
		),
	function checkDimensions bm = (
		--checks whether the dimensions of the texture are valid
		local status = #(true,true)
		try(
			local bmf = openBitMap bm
			if findItem allowedDimension bmf.height == 0 do (
				status[1] = false
			)
			if findItem allowedDimension bmf.width == 0 do (
				status[2] = false
			)
		) catch (
			status = #(false,false)
		)
		return status
		),
		
	function setShader s = (
		
		
		case s of (
			"VertexLitGeneric":valveShader="VertexLitGeneric"
			"UnlitGeneric":valveShader="UnlitGeneric"
			"LightmappedGeneric":valveShader="LightmappedGeneric"
			"model":valveShader="VertexLitGeneric"
			"model2":valveShader="UnlitGeneric"
			"brush":valveShader="LightmappedGeneric"
			"blend":valveShader="WorldVertexTransition"
			"Refract":valveShader="Refract"
			default: 
			--wallworm_appendBitmaps &mat &materials valveShader
			if (classOf mat == Blend) then (
				valveShader="WorldVertexTransition"
				) else (
			

					valveShader="VertexLitGeneric"

				
				)
			)
		
		
		),
	



	function checkForAnimatedRotation m = (
		
		
		
		
		false
		),



		function transformCheck mat m = (

			
			if isProperty mat "wallworm" == true AND isProperty mat "exportTexTransforms" == true AND mat.forModel == false then (

				if mat.exportTexTransforms == true  then (

						return true
				) else (
						return false
				)
					
			) else (
				
				if forModel == false AND decal == false then (
						return false
				)					

			)
			




			
			
			if forModel == true OR decal==true then (
				
				/*Only check for these in models/decals since these are controlled in the VMF for world textures.*/
				if m.coords.U_Tiling != 1.0 then (
						return true
				)
				if m.coords.V_Tiling != 1.0 then (
						return true
				)

				if m.coords.U_Offset != 0.0 then (
						return true
				)
				if m.coords.V_Offset != 0.0 then (
						return true
				)
				if m.coords.W_Angle != 0.0 then (
						return true
				)
				
			) else (

				if isProperty mat "wallworm" == true AND isProperty mat "exportTexTransforms" == true  then (
					
					return mat.exportTexTransforms
					
				) else (
				
				
				
					local co = undefined
					for i = 1 to m.numSubs while co == undefined do (
						if ((getSubAnimName m i asString:true) == "Coordinates") then (
							co = getSubAnim m i
						) else ()
						
					)
					
					if co != undefined then (
						
						return true
					)
				)
			
			)
			
			false
			),
		
		/*
				Pass the texture map's uv coordinates
		*/
		function outputTransform coords = (
			
			/*The center value does not seem to be correct. It should be offset when there is a Rotation, but by how much?*/
			("center "+((coords.U_Tiling / 2 ) as string)+" "+((coords.V_Tiling / 2 ) as string)+" scale "+((coords.U_Tiling ) as string)+" "+((coords.V_Tiling ) as string)+" rotate "+(((coords.W_Angle * -1) ) as string)+" translate "+(((mod coords.U_Offset  1) * coords.U_Tiling  ) as string)+" "+(((mod coords.V_Offset 1 ) * coords.V_Tiling) as string))
			
	
		),


		function setTransforms rot:0.0 = (
			
			
			--return false

			
				if mat1 == undefined then mat1 = mat
				
				at time 0 (
			
					if mat1.diffuseMap != undefined AND classOf mat1.diffuseMap == BitmapTexture AND mat1.diffuseMap.filename != undefined do (

							if ( isValidBitmap  (getFilenameType mat1.diffuseMap.filename) == true AND transformCheck mat1 mat1.diffuseMap == true) do (
									if forModel == true then (
										--basetexturetransform = ("center 0.5 0.5 scale "+(mat1.diffuseMap.coords.U_Tiling as string)+" "+(mat1.diffuseMap.coords.V_Tiling as string)+" rotate "+(((mat1.diffuseMap.coords.W_Angle * -1) + rot) as string)+" translate "+((mat1.diffuseMap.coords.U_Offset * mat1.diffuseMap.coords.U_Tiling * -1) as string)+" "+((mat1.diffuseMap.coords.V_Offset * mat1.diffuseMap.coords.V_Tiling * -1) as string))
										basetexturetransform=outputTransform mat1.diffuseMap.coords
									) else (
										basetexturetransform = ("center 0 0 scale "+(mat1.diffuseMap.coords.V_Tiling as string)+" "+(mat1.diffuseMap.coords.U_Tiling as string)+" rotate "+(((mat1.diffuseMap.coords.W_Angle * -1) + rot) as string)+" translate "+((mat1.diffuseMap.coords.V_Offset * mat1.diffuseMap.coords.V_Tiling * -1) as string)+" "+((mat1.diffuseMap.coords.U_Offset * mat1.diffuseMap.coords.U_Tiling ) as string))
									)
							)

					)

				if blendmodulate  != undefined AND classOf blendmodulate  == Bitmaptexture AND  blendmodulate.filename != undefined do(
						--parsedFilename = filterString mat1.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat1.specularMap.filename) "."
							if ( isValidBitmap  (getFilenameType blendmodulate.filename) == true  AND transformCheck mat1 blendmodulate == true) do (
								if forModel == true then (
									blendmodulatetransform = outputTransform blendmodulate.coords
								) else (
									blendmodulatetransform = ("center 0 0 scale "+(blendmodulate.coords.V_Tiling as string)+" "+(blendmodulate.coords.U_Tiling as string)+" rotate "+(((blendmodulate.coords.W_Angle * -1) + rot) as string)+" translate "+((blendmodulate.coords.V_Offset *blendmodulate.coords.V_Tiling * -1) as string)+" "+((blendmodulate.coords.U_Offset * blendmodulate.coords.U_Tiling) as string))
								)
							)
				)	
					
				
				
				if parallaxmap  != undefined AND classOf parallaxmap  == Bitmaptexture AND  parallaxmap.filename != undefined do(
						--parsedFilename = filterString mat1.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat1.specularMap.filename) "."
							if ( isValidBitmap  (getFilenameType parallaxmap.filename) == true  AND transformCheck mat1 parallaxmap == true) do (
								if forModel == true then (
									parallaxmaptransform = outputTransform parallaxmap.coords
								) else (
									parallaxmaptransform = ("center 0 0 scale "+(parallaxmap.coords.V_Tiling as string)+" "+(parallaxmap.coords.U_Tiling as string)+" rotate "+(((parallaxmap.coords.W_Angle * -1) + rot) as string)+" translate "+((parallaxmap.coords.V_Offset *parallaxmap.coords.V_Tiling * -1) as string)+" "+((parallaxmap.coords.U_Offset * parallaxmap.coords.U_Tiling) as string))
								)
							)
				)	
				

				
				if mat1.specularLevelMap  != undefined do (
					if classOf mat1.specularLevelMap  == Bitmaptexture do (
						if mat1.specularLevelMap.filename != undefined do (
						--parsedFilename = filterString mat1.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat1.specularMap.filename) "."
							if ( isValidBitmap  (getFilenameType mat1.specularLevelMap.filename) == true  AND transformCheck mat1 mat1.specularLevelMap == true) do (
								if forModel == true then (
									envmapmasktransform = outputTransform mat1.specularLevelMap.coords
								) else (
									envmapmasktransform = ("center 0 0 scale "+(mat1.specularLevelMap.coords.V_Tiling as string)+" "+(mat1.specularLevelMap.coords.U_Tiling as string)+" rotate "+(((mat1.specularLevelMap.coords.W_Angle * -1) + rot) as string)+" translate "+((mat1.specularLevelMap.coords.V_Offset *mat1.specularLevelMap.coords.V_Tiling * -1) as string)+" "+((mat1.specularLevelMap.coords.U_Offset * mat1.specularLevelMap.coords.U_Tiling) as string))
								)
							)
						)
					)
				)		
				
				if mat1.selfIllumMap  != undefined do (
					if classOf mat1.selfIllumMap  == Bitmaptexture do (
						if mat1.selfIllumMap.filename != undefined do (
						--parsedFilename = filterString mat1.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat1.specularMap.filename) "."
							if ( isValidBitmap  (getFilenameType mat1.selfIllumMap.filename) == true  AND transformCheck mat1 mat1.selfIllumMap == true ) do (

								--
								--selfillummasktransform =	("center 0 0 scale 1 1 rotate "+(rot as string)+" translate 0 0")
								if forModel == true then (
									selfillumtexturetransform =  outputTransform mat1.selfIllumMap.coords 
								) else (
									selfillumtexturetransform = ("center 0 0 scale "+(mat1.selfIllumMap.coords.V_Tiling as string)+" "+(mat1.selfIllumMap.coords.U_Tiling as string)+" rotate "+(((mat1.selfIllumMap.coords.W_Angle * -1) + rot) as string)+" translate "+((mat1.selfIllumMap.coords.V_Offset * mat1.selfIllumMap.coords.V_Tiling * -1) as string)+" "+((mat1.selfIllumMap.coords.U_Offset * mat1.selfIllumMap.coords.U_Tiling ) as string))
								)
								
								)
						)
					)
				)		

				
				
				
				if mat1.bumpMap  != undefined  do (
					
					
					if classOf mat1.bumpMap == Normal_Bump then (
						
						mapToUse = mat1.bumpMap.normal_map
						
						
						if mat1.bumpMap.bump_map != undefined AND classOf mat1.bumpMap.bump_map == Bitmaptexture  AND transformCheck mat1 mat1.bumpMap.bump_map == true  do (
									detailMap = mat1.bumpMap.bump_map
									if forModel == true then (
										detailtexturetransform =  outputTransform detailMap.coords
									) else (
										detailtexturetransform = ("center 0 0 scale "+(detailMap.coords.V_Tiling as string)+" "+(detailMap.coords.U_Tiling as string)+" rotate "+(((detailMap.coords.W_Angle * -1) + rot) as string)+" translate "+((detailMap.coords.V_Offset * detailMap.coords.V_Tiling * -1) as string)+" "+((detailMap.coords.U_Offset * detailMap.coords.U_Tiling ) as string))
						
										)
							)
						) else (
							mapToUse = mat1.bumpMap

						)
					
					if classOf mapToUse  == Bitmaptexture do (
						if mapToUse.filename != undefined do (
						--parsedFilename = filterString mat1.bumpMap.filename "."
							if ( isValidBitmap  (getFilenameType mapToUse.filename) == true  AND transformCheck mat1 mapToUse == true) do (

								if forModel == true then (
									bumptransform = outputTransform mapToUse.coords
								) else (
									bumptransform = ("center 0 0 scale "+(mapToUse.coords.V_Tiling as string)+" "+(mapToUse.coords.U_Tiling as string)+" rotate "+(((mapToUse.coords.W_Angle * -1) + rot) as string)+" translate "+((mapToUse.coords.V_Offset * mapToUse.coords.V_Tiling * -1) as string)+" "+((mapToUse.coords.U_Offset * mapToUse.coords.U_Tiling ) as string))
								)

							)
						)
					) 
				)							
					

				if mat1.displacementMap  != undefined do (
					
					
						if classOf mat1.displacementMap == Normal_Bump then (
						
							mapToUse = mat1.displacementMap.normal_map
						
							if mat1.displacementMap.bump_map != undefined AND classOf mat1.displacementMap.bump_map == Bitmaptexture  AND transformCheck mat1 mat1.displacementMap.bump_map == true do (
										detailMap = mat1.displacementMap.bump_map
								if forModel == true then (	
									detailtexturetransform = outputTransform detailMap.coords
								) else (
									detailtexturetransform = ("center 0 0 scale "+(detailMap.coords.V_Tiling as string)+" "+(detailMap.coords.U_Tiling as string)+" rotate "+(((detailMap.coords.W_Angle * -1) + rot) as string)+" translate "+((detailMap.coords.V_Offset * detailMap.coords.V_Tiling * -1) as string)+" "+((detailMap.coords.U_Offset * detailMap.coords.U_Tiling ) as string))
								)
							)
						
							
							
						) else (
							mapToUse = mat1.displacementMap

						)
					
					
					if classOf mapToUse  == Bitmaptexture do (
						if mapToUse.filename != undefined do (
						--parsedFilename = filterString mat1.displacementMap.filename "."
							if ( isValidBitmap  (getFilenameType mapToUse.filename) == true  AND transformCheck mat1 mapToUse == true) do (

								normal = mapToUse.filename
								
									if forModel == true then (
										bumptransform =   outputTransform mapToUse.coords
									) else (
										bumptransform = ("center 0 0 scale "+(mapToUse.coords.V_Tiling as string)+" "+(mapToUse.coords.U_Tiling as string)+" rotate "+(((mapToUse.coords.W_Angle * -1) + rot) as string)+" translate "+((mapToUse.coords.V_Offset * mapToUse.coords.V_Tiling * -1) as string)+" "+((mapToUse.coords.U_Offset * mapToUse.coords.U_Tiling ) as string))
									)

							)
						)
					)
				)	
			
			
				if mat2 != undefined then (
					
				if mat2.diffuseMap != undefined AND classOf mat2.diffuseMap == BitmapTexture AND mat2.diffuseMap.filename != undefined do (

							if ( isValidBitmap  (getFilenameType mat2.diffuseMap.filename) == true  AND transformCheck mat2 mat2.diffuseMap == true ) do (
								if forModel == true then (
									basetexturetransform2 = ("center 0 0 scale "+(mat2.diffuseMap.coords.U_Tiling as string)+" "+(mat2.diffuseMap.coords.V_Tiling as string)+" rotate "+(((mat2.diffuseMap.coords.W_Angle * -1) + rot) as string)+" translate "+((mat2.diffuseMap.coords.U_Offset * -1) as string)+" "+((mat2.diffuseMap.coords.V_Offset * -1) as string))
								) else (
									basetexturetransform2 = ("center 0 0 scale "+(mat2.diffuseMap.coords.V_Tiling as string)+" "+(mat2.diffuseMap.coords.U_Tiling as string)+" rotate "+(((mat2.diffuseMap.coords.W_Angle * -1) + rot) as string)+" translate "+((mat2.diffuseMap.coords.V_Offset * -1) as string)+" "+((mat2.diffuseMap.coords.U_Offset ) as string))
								)
							)

					)
							
							

						
				--add specular level map as phong exponent texture
				if mat2.specularLevelMap  != undefined do (
					if classOf mat2.specularLevelMap  == Bitmaptexture do (
						if mat2.specularLevelMap.filename != undefined do (
						--parsedFilename = filterString mat2.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat2.specularMap.filename) "."
							if ( isValidBitmap  (getFilenameType mat2.specularLevelMap.filename) == true  AND transformCheck mat2 mat2.specularLevelMap == true) do (

										envmapmasktransform2 = ("center 0 0 scale "+(mat2.specularLevelMap.coords.V_Tiling as string)+" "+(mat2.specularLevelMap.coords.U_Tiling as string)+" rotate "+(((mat2.specularLevelMap.coords.W_Angle * -1) + rot) as string)+" translate "+((mat2.specularLevelMap.coords.V_Offset * mat2.specularLevelMap.coords.V_Tiling * -1) as string)+" "+((mat2.specularLevelMap.coords.U_Offset * mat2.specularLevelMap.coords.U_Tiling) as string))

								)
						)
					)
				)				
									
						
							
				if mat2.selfIllumMap  != undefined do (
					if classOf mat2.selfIllumMap  == Bitmaptexture do (
						if mat2.selfIllumMap.filename != undefined do (
						--parsedFilename = filterString mat1.specularMap.filename "."
							--parsedFilename = filterString (filenameFromPath mat1.specularMap.filename) "."
							if ( isValidBitmap  (getFilenameType mat2.selfIllumMap.filename) == true  AND transformCheck mat2 mat2.selfIllumMap == true) do (
									--
									--selfillummasktransform2 =	("center 0 0 scale 1 1 rotate "+(rot as string)+" translate 0 0")

									selfillumtexturetransform2 = ("center 0 0 scale "+(mat2.selfIllumMap.coords.V_Tiling as string)+" "+(mat2.selfIllumMap.coords.U_Tiling as string)+" rotate "+(((mat2.selfIllumMap.coords.W_Angle * -1) + rot) as string)+" translate "+((mat2.selfIllumMap.coords.V_Offset * mat2.selfIllumMap.coords.V_Tiling * -1) as string)+" "+((mat2.selfIllumMap.coords.U_Offset * mat2.selfIllumMap.coords.U_Tiling) as string))

							)
						)
					)
				)		

				
				if mat2.bumpMap  != undefined do (
					
					
					if classOf mat2.bumpMap == Normal_Bump then (
						
						mapToUse = mat2.bumpMap.normal_map
						
						
						if mat2.bumpMap.bump_map != undefined AND classOf mat2.bumpMap.bump_map == Bitmaptexture  AND transformCheck mat2 mat2.bumpMap.bump_map == true do (

									detailtexturetransform2 = ("center 0 0 scale "+(mat2.bumpMap.bump_map.coords.V_Tiling as string)+" "+(mat2.bumpMap.bump_map.coords.U_Tiling as string)+" rotate "+(((mat2.bumpMap.bump_map.coords.W_Angle * -1) + rot) as string)+" translate "+((mat2.bumpMap.bump_map.coords.V_Offset * mat2.bumpMap.bump_map.coords.V_Tiling * -1) as string)+" "+((mat2.bumpMap.bump_map.coords.U_Offset * mat2.bumpMap.bump_map.coords.U_Tiling ) as string))

						)
						
						) else (
							mapToUse = mat2.bumpMap

						)
					
					if classOf mapToUse  == Bitmaptexture do (
						if mapToUse.filename != undefined do (
						--parsedFilename = filterString mat2.bumpMap.filename "."
							if ( isValidBitmap  (getFilenameType mapToUse.filename) == true  AND transformCheck mat2 mapToUse == true) do (


								bumptransform2 = ("center 0 0 scale "+(mapToUse.coords.V_Tiling as string)+" "+(mapToUse.coords.U_Tiling as string)+" rotate "+(((mapToUse.coords.W_Angle * -1) + rot) as string)+" translate "+((mapToUse.coords.V_Offset * mapToUse.coords.V_Tiling * -1) as string)+" "+((mapToUse.coords.U_Offset * mapToUse.coords.U_Tiling) as string))


							)
						)
					) 
				)							
					
				
				
				

				if mat2.displacementMap  != undefined do (
					
					
						if classOf mat2.displacementMap == Normal_Bump then (
						
							mapToUse = mat2.displacementMap.normal_map
							if mat2.displacementMap.bump_map != undefined AND classOf mat2.displacementMap.bump_map == Bitmaptexture  AND transformCheck mat2 mat2.displacementMap.bump_map == true do (

								detailtexturetransform2 = ("center 0 0 scale "+(mat2.displacementMap.bump_map.coords.V_Tiling as string)+" "+(mat2.displacementMap.bump_map.coords.U_Tiling as string)+" rotate "+(((mat2.displacementMap.bump_map.coords.W_Angle * -1) + rot) as string)+" translate "+((mat2.displacementMap.bump_map.coords.V_Offset * mat2.displacementMap.bump_map.coords.V_Tiling *-1) as string)+" "+((mat2.displacementMap.bump_map.coords.U_Offset * mat2.displacementMap.bump_map.coords.U_Tiling ) as string))

							
							)

						
							
							
						) else (
							mapToUse = mat2.displacementMap

						)
					
					
					if classOf mapToUse  == Bitmaptexture do (
						if mapToUse.filename != undefined do (
						--parsedFilename = filterString mat2.displacementMap.filename "."
							if ( isValidBitmap  (getFilenameType mapToUse.filename) == true  AND transformCheck mat2 mapToUse == true) do (

								normal = mapToUse.filename
								bumptransform2 = ("center 0 0 scale "+(mapToUse.coords.V_Tiling as string)+" "+(mapToUse.coords.U_Tiling as string)+" rotate "+(((mapToUse.coords.W_Angle * -1) + rot) as string)+" translate "+((mapToUse.coords.V_Offset * mapToUse.coords.V_Tiling * -1) as string)+" "+((mapToUse.coords.U_Offset * mapToUse.coords.U_Tiling) as string))


								
							
							)
						)
					)
				)	
				
					
					
					
					
					)

				
				)
			
			),
		
		
		
	function getMaterialPathForMat matin = (
		
				matin.name = substituteString (matin.name) "\t" ""
		
		
				local workingName = matin.name
		
		
				local workingPath = workingName
				--parse from material name
			
				local hasPath = false
				local materialNamePath = filterString workingName "\\"
				
				if (materialNamePath.count > 0) do (
					
					workingName = substring workingName 1 (workingName.count - materialNamePath[materialNamePath.count].count) 
					workingPath =  substring workingPath 1 (workingPath.count - workingName.count) 
					hasPath = true
					) 
			

					
				materialNamePath = filterString workingName "/"
				
				if (materialNamePath.count > 0) do (
					
					workingName = substring workingName 1 (workingName.count - materialNamePath[materialNamePath.count].count) 
					--print workingName
					workingPath =  substring workingPath 1 (workingPath.count - workingName.count) 
					--print workingPath
					hasPath = true
				) 
				
					
				if hasPath==true then (
					return workingPath
				) else (
					return ""
					)
					
		
		
		
		
		
		),
		
	function setMaterialPath mp = (
		
		if (valveShader=="VertexLitGeneric" OR forModel==true) then (
			
			if mp == ""  then (
				if isProperty mat "wallworm" AND mat.cdmaterials != "" then (	
					mp = mat.cdmaterials
				) else (
					mp = getFileNamePath mat.name
				)
					
			)
			
			materialPath = mp

		) else(
			materialPath = getMaterialPathForMat mat
		)
		
		return materialPath
	),	
		
	function compileTexture tex type frame:undefined runBat:true shoutNotice:true writeVMT:false exportVTF:true = (
		
		--print writeVMT
		--print valveShader
		local m

		useDiffColor = false		
		
		if mat1 == undefined then (
			mat1 = mat
		)
		
		if classOf tex == BitmapTexture then (	
			m = tex.filename	
			texlist = parseIFL m
			
		) else (
			
			--useDiffColor = true
		)
		
		local useWWMat = false
		
		if isProperty mat "wallworm" then (

			if forModel == true then (
					if  (findItem #("VertexLitGeneric","Refract","UnlitGeneric") mat.valveShader) != 0 then (
						valveShader = mat.valveShader
					)
			) else (
					if mat.valveShader != "VertexLitGeneric" then (
						valveShader = mat.valveShader
					)
					
			)
			
			if mat.valveShader == "LightMappedGeneric" OR mat.valveShader == "WorldVertexTransition" then (
				forModel = false
			)
			
			useWWMat = true
		)
		
		
		batchstring = ""
		tga = ""
		
		--if texlist.count == 0 then ( return false)
		

		
				--try (
					errors = #()


					
						if(materialPath == undefined) do (
							setMaterialPath ""
							)
					
						if(wwmt_binDir == undefined) do (
							append errors  "The Bin Directory in the Settings floater must be set to a directory where VTEX.exe is located."

						)
							
						if  materialPath == undefined do (		


							
							if  (valveShader=="VertexLitGeneric" OR forModel==true) AND (materialPath == undefined OR materialPath == "") then (	

								
								append errors "The Material Path for your model must be set."
								
								
							)	else (
								
								--append errors "The Material Path for your model must be set."
							)
							
							
						)	
						
						
						
						
						
						
						

						if ( (makeDir (wwmt_exportMats+"\\"+materialPath) all:true) == false)	do (
						
							append errors ("The material export directory ["+wwmt_exportMats+"\\"+materialPath+"] does not exist and MAXScript could not create it.")

						
						)
						
						
						if ( (makeDir (wwmt_gameInfoDir+"\materials\\"+materialPath) all:true) == false)	do (
						
							append errors ("The directory ["+wwmt_gameInfoDir+"\materials\\"+materialPath+"]  does not exist and MAXScript could not create it.")

						
						)
						
						
						
						studiopath = wwmt_binDir+"\\"+"vtex.exe"
						if doesFileExist (studiopath) ==false do (
							
							append errors "The Bin Directory does not point to a path where vtex.exe is located."
							
						)
							
							
						if m != undefined and (toLower ((getFilenameType m)) == ".ifl") then (
							
							diffName = ((getTexName m) +"0")
							
							) else (
							if texlist != undefined then (
							diffName = getTexName texlist[1]
							) else (
								diffname = wallworm_getMaterialName mat1 forModel:forModel
								useDiffColor = true
								)
						)
						
						--print ("DiffName is "+diffName)
					if diffName == undefined then (
						append errors ("No name found.")
						) else (
						if (wallworm_mat_name_limit_check diffName)	== false then (
							append errors ("Your texture named "+diffName+" is invalid because the filename is too long. Limit the texture names to 22 characters or less.")
						)						
					)
						

				
					if errors.count == 0 then (

						local mpstring = ""
						local proxies = #()
						

						
						if matName != undefined AND matName != "" then (
							materialName = matName
						) else (
							materialName = diffName
						)

						if (materialPath != undefined AND materialPath != "") do (
							mpstring = materialPath+"\\"
							--mpstring = wallworm_bsToFs mpstring
						) 

						
						
							if writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") then (
								local parmPrefix = "\n	"
								local quotes = ""							

								
							) else (
								local parmPrefix = " -vmtparam"
								local quotes = "\""	

								)
							
						
							if diffName != "" then (
								
								if exportVTF == true then (
									

							)
							if runBat == false then (
								return ""
								)
								
								
								
							--	batchName  = wallworm_FsToBs (wwmt_exportMats+"\\"+mpstring+diffName+".bat")
								
								
								


								
								
							) else (
								
								useDiffColor = true
								writeVMT = true
							)
							
							if diffName == "" then (
								useDiffColor = true
							)
							

							
							
							if  useDiffColor == true OR writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "")  then (
								if materialName == undefined then (
									
									
									materialName = wallworm_getMaterialName mat forModel:getNameFromPath
									)
								if diffName == "" then (
									diffName = materialName
								)
								--materialName = 
								if useDiffColor == true then (
								tga = ""
								)
								if forModel == true then (
									
									if wwmt_legacy_names == true then (
									
										if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" then (
											vmfName  = wwmt_gameInfoDir+"\\materials\\"+mpstring+diffName+".vmt"
										) else (
											vmfName  = wwmt_exportMats+"\\"+mpstring+diffName+".vmt"
										)
									) else (
										
										vmfName  = wwmt_gameInfoDir+"\\materials\\"+mpstring+materialName+".vmt"
										
										)
									
								) else (
									
									--materialName = wallworm_getMaterialName mat.name forModel:false
									--materialName = wallworm_getMaterialName mat1 forModel:false
									
									--matName =  wallworm_getMaterialName  mat1
									materialPath =  getMaterialPathForMat mat
									if useDiffColor == false AND classOf mat != Blend then (
									
										if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" then (
											vmfName  = wwmt_gameInfoDir+"\\materials\\"+materialName+".vmt"
											--vmfName  = wwmt_gameInfoDir+"\\materials\\"+materialPath+"\\"+materialName+".vmt"
										) else (
											--vmfName  = wwmt_exportMats+"\\"+materialPath+"\\"+materialName+".vmt"
											vmfName  = wwmt_exportMats+"\\"+materialName+".vmt"
		
										)
									) else (
										if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" then (
											vmfName  = wwmt_gameInfoDir+"\\materials\\"+materialName+".vmt"
										) else (
											
											vmfName  = wwmt_exportMats+"\\"+materialName+".vmt"
		
										)

									)

								)
								parmPrefix = "\n	"
								quotes = ""
								--print ("Diffuse Color Mat sent to: "+batchName)
									
								
	
									
									
							)
							

						
						if  (valveShader!="VertexLitGeneric" AND forModel==true) AND materialPath != undefined AND useWWMat == false then (	
							extra = parmPrefix+" "+quotes+"$model"+quotes+" \"1\""
						) else(
							if useWWMat == true then (
							extra = ("\n"+(mat.outputme forceModel:forModel forceDecal:decal))
							) else (
									extra = ""
							)
						)
						
						if forModel == true AND chkwwmt_oldModelVTFPath==true then (
							forcePath = mpstring
							) else (
							forcePath = ""
						)
							
						
					    if type=="diff" then (
							--this is diffuse 
							
								--if diffName != materialName do (
									--append extra (" -vmtparam  \"$basetexture\" \""+mpstring+(diffName)+"\"")
									--tga = wwmt_exportMats+"\\"+mpstring+materialName+".tga"
								--)	
							
							
							if decal ==true AND useWWMat == false then (
								append extra (parmPrefix+" "+quotes+"$decal"+quotes+" \"1\"")
								
							)

							if basetexturetransform != undefined AND basetexturetransform != "" then (
								append extra (parmPrefix+" "+quotes+"$basetexturetransform"+quotes+" \""+basetexturetransform+"\"")
							)
							
							if  envmapmasktransform != undefined AND envmapmasktransform != "" then (
								append extra (parmPrefix+" "+quotes+"$envmapmasktransform"+quotes+" \""+envmapmasktransform+"\"")
							)
							
							
							if  bumptransform != undefined AND bumptransform != "" then (
								append extra (parmPrefix+" "+quotes+"$bumptransform"+quotes+" \""+bumptransform+"\"")
							)

							if detailtexturetransform != undefined AND detailtexturetransform != "" AND ( isProperty mat1 "usedetailscale" == false OR mat1.usedetailscale == false) then (
								append extra (parmPrefix+" "+quotes+"$detailtexturetransform"+quotes+" \""+detailtexturetransform+"\"")
							)

							if selfillumtexturetransform != undefined AND selfillumtexturetransform != ""  then (
								append extra (parmPrefix+" "+quotes+"$selfillumtexturetransform"+quotes+" \""+selfillumtexturetransform+"\"")
								append extra (parmPrefix+" "+quotes+"$selfillummasktransform"+quotes+" \""+selfillumtexturetransform+"\"")
							)
							

							
							
							
							if useWWMat == false then (
								if surfaceproperty != undefined AND surfaceproperty != "" then (
									append extra (parmPrefix+" "+quotes+"$surfaceprop"+quotes+" \""+surfaceproperty+"\"")
									
								)
							)
							
							if  (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") ) AND useDiffColor == false then (
									
								
								--append extra (parmPrefix+" "+quotes+"$basetexture"+quotes+" \""+(wallworm_safe_path (mpstring+diffName))+"\"")
									
								append extra (parmPrefix+" "+quotes+"$basetexture"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.diffuseMap forcePath:forcePath)+"\"")
								

								
								
								if mat1.diffuseMap != undefined then (
									scrollp = getScrollProxie mat1.diffuseMap type:"basetexturetransform"
									if scrollp != ""  then (
										if rotationAngle != undefined then (
											append extra (parmPrefix+" "+quotes+"$angle"+quotes+" \""+(formattedPrint rotationAngle)+"\"")
										)
										
										
										append proxies scrollp
									) else (
										--print "No scroll"
									)
								) else (
									--print ("no diffusemap in"+mat1 as string)
								)
									
							)
							
							if  diff != undefined AND toLower ((getFilenameType diff)) == ".ifl" AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") ) then (
								
								append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$basetexture"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.diffuseMap.playbackRate * frameRate))+quotes+"\n}\n")
							)

							if  ((specLevelMap != undefined AND specLevelMap != "" ) OR (classOf mat == Standard AND mat1.reflectionMapEnable != undefined AND mat1.reflectionMapEnable == true)) then (
								--add check for texture
								
								if mat1.reflectionMap != undefined AND classof mat1.reflectionMap == Reflect_Refract AND mat1.reflectionMap.outputname != undefined then (
									thecubemapfile = getFileNameFile mat1.reflectionMap.outputname
									thecubemapfile = substitutestring thecubemapfile "_UP" ""
									append extra (parmPrefix+" "+quotes+"$envmap"+quotes+" \""+(wallworm_remove_last_slash (wallworm_safe_path (mat1.reflectionMap.name)))+"/"+thecubemapfile+"\"")
								) else (
									append extra (parmPrefix+" "+quotes+"$envmap"+quotes+" \"env_cubemap\"")
									
								)

								/*
								if (classOf mat == Standard AND mat1.reflectionMapEnable != undefined AND mat1.reflectionMapEnable == true ) then (
									append extra (parmPrefix+" "+quotes+"$envmapmaskscale"+quotes+" \""+(formattedPrint (mat1.reflectionMapAmount / 100) )+"\"")
								)
								*/
								
								if (isProperty mat1 "useEnvSettings" == true AND mat1.useEnvSettings == true) OR (isProperty mat1 "envmaptint" == true AND isProperty mat1 "useEnvSettings" == false) then (
								
								
								
									if isProperty mat1 "envmaptint" == true AND mat1.envmaptint != undefined  then (
										append extra (parmPrefix+" "+quotes+"$envmaptint"+quotes+" \"["+(formattedPrint (mat1.envmaptint.r / 255) format:"1.2g")+" "+(formattedPrint (mat1.envmaptint.g / 255) format:"1.2g")+" "+(formattedPrint (mat1.envmaptint.b / 255) format:"1.2g") +"]\"")
									)
									
									
									if isProperty mat1 "envmapcontrast" == true AND mat1.envmapcontrast != undefined  then (
										append extra (parmPrefix+" "+quotes+"$envmapcontrast"+quotes+" \""+(mat1.envmapcontrast as string )+"\"")
										
									)
									if isProperty mat1 "envmapsaturation" == true AND mat1.envmapsaturation != undefined  then (
										append extra (parmPrefix+" "+quotes+"$envmapsaturation"+quotes+" \""+(mat1.envmapsaturation as string )+"\"")
										
									)
								
								)
								
							)
								
								
							if isProperty mat1 "breakablesurface" == true AND mat1.breakablesurface == true then (
								append proxies (parmPrefix+" "+quotes+"BreakableSurface"+quotes+"\n{\n"+quotes+"\n}\n")
							)
							
							if isProperty mat1 "crackmaterial" == true AND mat1.crackmaterial != undefined then (
								
								append extra (parmPrefix+" "+quotes+"$crackmaterial"+quotes+" \""+mat1.crackmaterial.name+"\"")
								
								
							)							
							
							
							
							
								if valveShader == "Refract" then (
									bumpName = "normalmap"
								) else (
									bumpName = "bumpmap"
								)
							
								
								lookForSSBump = useSSBump mat1
								
								if lookForSSBump AND forModel == false then (
									ssbumpsuffix = "_ssbump"
								)	 else (
									ssbumpsuffix = ""
								)
								
								
								
								if normal != undefined then (
									
									

									/*TODO ... see if the ssbump file exists before using... some Mods don't come equiped with normal2ssbump.exe*/
									append extra (parmPrefix+" "+quotes+"$"+bumpName+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.displacementMap forcePath:forcePath )+ssbumpsuffix+"\"")
										
									if  toLower ((getFilenameType normal)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
										append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$"+bumpName+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.displacementMap.playbackRate * frameRate))+quotes+"\n}\n")
									)
										
									if mat1.displacementMap != undefined then (
										scrollp = getScrollProxie mat1.displacementMap type:"bumptransform"
										if scrollp != "" then (
											append proxies scrollp
										) else (
											--print "No scroll"
										)
									) else (
										--print ("no diffusemap in"+mat1 as string)
									)	
								
								) else (
									if bump != undefined do (
								
										append extra (parmPrefix+" "+quotes+"$"+bumpName+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.bumpMap forcePath:forcePath)+ssbumpsuffix+"\"")
										if  toLower ((getFilenameType bump)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
											append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$"+bumpName+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.bumpMap.playbackRate * frameRate))+quotes+"\n}\n")
										)
										
									if mat1.bumpMap != undefined then (
										scrollp = getScrollProxie mat1.bumpMap type:"bumptransform"
										if scrollp != "" then (
											--"print bump scroll"
											append proxies scrollp
										) else (
											--print "No Bump scroll"
										)
									) else (
										--print ("no diffusemap in"+mat1 as string)
									)	

										

									)

								)
								
								if useWWMat==false AND lookForSSBump == true do (
									
									append extra (parmPrefix+" "+quotes+"$ssbump"+quotes+" \"1\"")
									
								)

								
								if (specLevelMap != undefined and valveShader != "Refract") do (
									
									tempBitmap = openBitmap specLevelMap
									
									

									
									
									
									if (valveShader=="VertexLitGeneric" OR forModel==true) then (
										--http://developer.valvesoftware.com/wiki/$envmapmask
										--A specular map only works on models if there is NO bump/normal map OR the spec comes from diffuse or bump alpha
										if  (normal == undefined AND bump==undefined) then (
											

												
														if diff == specLevelMap  AND (tempBitmap.hasAlpha) then (
															append extra (parmPrefix+" "+quotes+"$basealphaenvmapmask"+quotes+" \"1\"")
														) else if specLevelMap==illum  AND (tempBitmap.hasAlpha) then (
															append extra (parmPrefix+" "+quotes+"$selfillum_envmapmask_alpha"+quotes+" \"1\"")
														) else (
																append extra (parmPrefix+" "+quotes+"$envmapmask"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.specularLevelMap forcePath:forcePath)+"\"")
																	
																if  toLower ((getFilenameType specLevelMap)) == ".ifl" AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
																	append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$envmapmask"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.specularLevelMap.playbackRate * frameRate))+quotes+"\n}\n")
																)
																if mat1.specularLevelMap != undefined then (
																	scrollp = getScrollProxie mat1.specularLevelMap type:"envmapmasktransform"
																	if scrollp != "" then (
																		append proxies scrollp
																	) else (
																		--print "No scroll"
																	)
																) else (
																	--print ("no diffusemap in"+mat1 as string)
																)	
																	
																	
															)
												
										) else (
												
												proceed = false
												checkIllum=false
												checkNormal = false
												checkBump = false
 												if bump != undefined AND bump == specLevelMap do (
 													proceed=true
 													checkBump = true
												)
 												if normal != undefined AND normal == specLevelMap do (
 													proceed=true
 													checkNormal = true
												)
 												if illum != undefined AND illum == specLevelMap do (
 													proceed=true
 													checkIllum=true
												)	

												if (diff == specLevelMap OR proceed == true   ) AND (tempBitmap.hasAlpha) then (
													
														if (checkBump == true OR checkNormal == true  ) then (	
															if (checkBump == true ) then (
																append extra (parmPrefix+" "+quotes+"$normalmapalphaenvmapmask"+quotes+" \"1\"")
															) else(
																if (checkNormal == true ) do (
																	append extra (parmPrefix+"  "+quotes+"$normalmapalphaenvmapmask"+quotes+"\"1\"")
																)
															)
														) else if (checkIllum==true )  then (
														
															append extra (parmPrefix+" "+quotes+"$selfillum_envmapmask_alpha"+quotes+" \"1\"")
														
															) else (
															
																if diff == specLevelMap do (
																
																	append extra (parmPrefix+" "+quotes+"$basealphaenvmapmask"+quotes+" \"1\"")
																
																) 	
															
															
														)

														
												) else (
													append extra (parmPrefix+" "+quotes+"$envmapmask"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.specularLevelMap forcePath:forcePath)+"\"")
															
													if  toLower ((getFilenameType specLevelMap)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
														append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$envmapmask"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.specularLevelMap.playbackRate * frameRate))+quotes+"\n}\n")
													)
																if mat1.specularLevelMap != undefined then (
																	scrollp = getScrollProxie mat1.specularLevelMap type:"envmapmasktransform"
																	if scrollp != "" then (
																		append proxies scrollp
																	) else (
																		--print "No scroll"
																	)
																) else (
																	--print ("no diffusemap in"+mat1 as string)
																)	
		
												)
												
												
												)
										
									) else (
												if (tempBitmap.hasAlpha) then (
													if diff == specLevelMap then (
														append extra (parmPrefix+" "+quotes+"$basealphaenvmapmask"+quotes+" \"1\"")
													) else if (bump == specLevelMap OR normal == specLevelMap) then (
														append extra (parmPrefix+" "+quotes+"$normalmapalphaenvmapmask"+quotes+" \"1\"")
													) else if (bump == illum) then (
														append extra (parmPrefix+" "+quotes+"$selfillum_envmapmask_alpha"+quotes+" \"1\"")
													)
												) else (
														append extra (parmPrefix+" "+quotes+"$envmapmask"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.specularLevelMap forcePath:forcePath)+"\"")
														if  toLower ((getFilenameType specLevelMap)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") ) then (
															append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$envmapmask"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.specularLevelMap.playbackRate * frameRate))+quotes+"\n}\n")
														)
														
																if mat1.specularLevelMap != undefined then (
																	scrollp = getScrollProxie mat1.specularLevelMap type:"envmapmasktransform"
																	if scrollp != "" then (
																		append proxies scrollp
																	) else (
																		--print "No scroll"
																	)
																) else (
																	--print ("no diffusemap in"+mat1 as string)
																)	
														
												)
												
									)
								
									
									close tempBitmap
								)
								
								
								
								if ambient != undefined AND forModel == true do (
								
									append extra (parmPrefix+" "+quotes+"$AmbientOcclusion"+quotes+" \"1\" "+parmPrefix+" "+quotes+"$AmbientOcclTexture"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.ambientMap forcePath:forcePath)+"\"")
									if  toLower ((getFilenameType ambient)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
										append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$AmbientOcclusion"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.ambientMap.playbackRate * frameRate))+quotes+"\n}\n")
									)
								
								)
								
								if detail != undefined do (
									
									
									detailMap = wallworm_detailMapTex mat1 
									append extra (parmPrefix+" "+quotes+"$detail"+quotes+" \""+(wallworm_getVTFPathFromBitmap detailMap forcePath:forcePath)+"\"")
									if  toLower ((getFilenameType detail)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
										append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$detail"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (detailMap.playbackRate * frameRate))+quotes+"\n}\n")
									)
									
									if isProperty mat1 "usedetailscale" == true AND mat1.usedetailscale == true then (

										append extra (parmPrefix+" "+quotes+"$detailscale"+quotes+" \""+(mat1.detailscale as string )+"\"")
									)
									
									
									if isProperty mat1 "useadvanceddetail" == true AND mat1.useadvanceddetail == true then (
											
										
									if isProperty mat1 "detailtint" == true AND mat1.detailtint != undefined  then (
										append extra (parmPrefix+" "+quotes+"$detailtint"+quotes+" \"["+(formattedPrint (mat1.detailtint.r / 255) format:"1.2g")+" "+(formattedPrint (mat1.detailtint.g / 255) format:"1.2g")+" "+(formattedPrint (mat1.detailtint.b / 255) format:"1.2g") +"]\"")
									)
									
									
									if isProperty mat1 "detailblendmode" == true AND mat1.detailblendmode != undefined  then (
										append extra (parmPrefix+" "+quotes+"$detailblendmode"+quotes+" \""+(mat1.detailblendmode as string )+"\"")
										
									)
										
									if isProperty mat1 "detailblendfactor" == true AND mat1.detailblendfactor != undefined  then (
										append extra (parmPrefix+" "+quotes+"$detailblendfactor"+quotes+" \""+(mat1.detailblendfactor as string )+"\"")
										
									)

		
									)

									
									

								
								)
								
								if illum != undefined do (
								
									append extra (parmPrefix+" "+quotes+"$selfillum"+quotes+" \"1\"  "+parmPrefix+" "+quotes+"$selfillumtexture"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.selfIllumMap forcePath:forcePath)+"\""+parmPrefix+" "+quotes+"$selfillummask"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.selfIllumMap forcePath:forcePath)+"\"")
									if  toLower ((getFilenameType illum)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
										append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$selfillumtexture"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.selfIllumMap.playbackRate * frameRate))+quotes+"\n}\n")
									)
									
									if mat1.selfIllumMap != undefined then (
										scrollp = getScrollProxie mat1.selfIllumMap type:"selfillumtransform"
										if scrollp != "" then (
											append proxies scrollp
										) else (
											--print "No scroll"
										)
									) else (
										--print ("no diffusemap in"+mat1 as string)
									)	
									
									
								)
								
								
								--if classOf mat1 == Standardmaterial AND forModel == true AND mat1.specularMapEnable == true AND mat1.shaderByName == "Phong" AND valveShader=="VertexLitGeneric"  do (
								
								if classOf mat1 == Standardmaterial AND forModel == true AND mat1.shaderByName == "Phong" AND valveShader=="VertexLitGeneric"  do (
									--Phong
									
									
									
									append extra (parmPrefix+" "+quotes+"$phong"+quotes+" \"1\"")
									if useWWMat == false then (
										append extra (parmPrefix+" "+quotes+"$phongboost"+quotes+"  \""+((mat1.specularMapAmount / 100.0) as string)+"\" "+parmPrefix+" "+quotes+"$phongfresnelranges"+quotes+" \"[0 0.5 1]\"")

										
									)


									
									if spec != undefined then (
									
										
										tempBitmap = openBitmap spec
										tempBitmap.hasAlpha	
										
										
										case of (
											(diff == spec  ): (
												append extra (parmPrefix+" "+quotes+"$basemapalphaphongmask"+quotes+" \"1\"")			
											)
											
											default:()
										)
										
										
											

								
										close tempBitmap			

										
										
										append extra (parmPrefix+" "+quotes+"$phongexponenttexture"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.specularMap forcePath:forcePath)+"\" ")											
										
										if mat1.specularMap != undefined then (
											scrollp = getScrollProxie mat1.specularMap type:"phongexponenttexturetransform"
											if scrollp != "" then (
												append proxies scrollp
											) else (
												--print "No scroll"
											)
										) else (
											--print ("no diffusemap in"+mat1 as string)
										)	
										
										if  toLower ((getFilenameType spec)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") ) then (
											append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$phongexponenttexture"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.specularMap.playbackRate * frameRate))+quotes+"\n}\n")
										)
										

										
									) else (
										if useWWMat == true then (
											local phongexponent = mat1.phongexponent
											) else (
											local phongexponent = 5
										)
										append extra (parmPrefix+" "+quotes+"$phongexponent"+quotes+" \""+(phongexponent as string)+"\"")

									)
								)
								
								--check if 2-sided
								
								if mat1.refractionMapEnable == true do (
									



										
									local refractAmount = mat1.refractionMapAmount / 100

										
									if mat1.refractionMap != undefined then (
										
										if classOf mat1.refractionMap == BitmapTexture then (
											
											
/*
										scrollp = getScrollProxie mat1.refractionMap type:"selfillumtransform"
										if scrollp != "" then (
											append proxies scrollp
										) else (
											--print "No scroll"
										)

											*/
											
											
										append extra (parmPrefix+" "+quotes+"$refracttinttexture"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat1.refractionMap forcePath:forcePath)+"\" "+parmPrefix+" "+quotes+"$bluramount"+quotes+" \""+(mat1.refractionMap.coords.blur as string)+"\"")
											
										if  toLower ((getFilenameType mat1.refractionMap.filename)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
											append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$refracttinttexture"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+(formattedPrint (mat1.refractionMap.playbackRate * frameRate))+quotes+"\n}\n")
										)
											
											
										) else(
											if classOf mat1.refractionMap == Color_Correction then (
											
												append extra (parmPrefix+" "+quotes+"$refracttint"+quotes+" \"{"+(mat1.refractionMap.color[1] as string)+" "+(mat1.refractionMap.color[2] as string)+" "+(mat1.refractionMap.color[3] as string)+"}\" "+parmPrefix+" "+quotes+"$bluramount"+quotes+" \"1\"")
											
											)
											
										)
									)  else()

										append extra (parmPrefix+" "+quotes+"$refractamount"+quotes+" \""+(refractAmount as string)+"\"")
									
								)
								
								if isProperty mat1 "reflectivity" AND isProperty mat1 "useReflectivity" AND mat1.useReflectivity == true then (
									
									
									append extra (parmPrefix+" "+quotes+"$reflectivity"+quotes+" \"["+formattedPrint (mat.reflectivity.r/255) format:"2.2g"+" "+formattedPrint (mat.reflectivity.g/255) format:"2.2g"+" "+formattedPrint (mat.reflectivity.b/255) format:"2.2g"+"]\"")
									
								) else (
								
									if mat1.reflectionMapEnable == true do (
										
										local reflect = mat1.reflectionMapAmount / 100
										local useReflectMap = false
										try (												
											if mat1.reflectionMap != undefined AND classOf mat1.reflectionMap == Color_Correction do (
												useReflectMap = true
												append extra (parmPrefix+" "+quotes+"$reflectivity"+quotes+" \"{"+(mat1.reflectionMap.color[1] as string)+" "+(mat1.reflectionMap.color[2] as string)+" "+(mat1.reflectionMap.color[3] as string)+"}\"")
											) 
										) catch (
											--probably failed because older version of Max... Color_Correction added in Max 2009
											useReflectMap = false
										)

										if useReflectMap == false do (
											append extra (parmPrefix+" "+quotes+"$reflectivity"+quotes+" \"["+(reflect as string)+" "+(reflect as string)+" "+(reflect as string)+"]\"")
										)
												
												
												
									)
								)
								nocull = false

								
								if (mat1.twoSided != undefined AND mat1.twoSided == on) do (
									nocull = true
									append extra (parmPrefix+" "+quotes+"$nocull"+quotes+" \"1\"")
									
								)									
								
								

								
								
								if forceOpaque == false do (								
								
								if ((mat1.opacity != undefined AND mat1.opacity != 100) ) do (

									alphavalue = mat1.opacity / 100
									append extra (parmPrefix+" "+quotes+"$alpha"+quotes+" \""+(alphavalue as string)+"\"")
									if mat1.opacityType == 2 do (
										append extra (parmPrefix+" "+quotes+"$additive"+quotes+" \"1\"")
									)
									
								)
								


								
								addTrans = false
								checkForAlpha = false

								if (wwmt_translucentOnlyIfOpacityMap == true OR wwmt_translucentOnlyIfOpacityMap == "true")  then (

										if mat1.opacityMap != undefined AND mat1.opacityMap.filename == diff do (
											checkForAlpha = true
										)
								) else (
										
										if mat1.diffusemap != undefined AND classOf mat1.diffusemap == BitmapTexture AND mat1.diffusemap.alphasource == 2 then (
											

											checkForAlpha = false
											
										)	else (
									
											checkForAlpha = true
									
										)
										

								)

									
									if checkForAlpha == true AND diff != undefined do (
										
										diffBitmap = openBitmap diff									
										if (diffBitmap!= undefined AND diffBitmap.hasAlpha == true)  do (
											addTrans = true
										) 
										
									)
								
								
								--format "Check For Alpha: %\n Add Transparency: %\n" checkForAlpha addTrans
								
								if addTrans == true do (
									
									if (nocull==true AND (valveShader=="VertexLitGeneric" OR forModel==true)) OR illum != undefined then (
											if useWWMat == false then (
												append extra (parmPrefix+" "+quotes+"$alphatest"+quotes+" \"1\"")
											) else (
												if mat1.alphatest == false then (
													append extra (parmPrefix+" "+quotes+"$translucent"+quotes+" \"1\"")		
												)
												
											)
									)	else if addTrans==true do (
											append extra (parmPrefix+" "+quotes+"$translucent"+quotes+" \"1\"")										
									)									
									
								)
								
							)
							
							
							
							if lightwarptexture != undefined  then (
								append extra (parmPrefix+" "+quotes+"$lightwarptexture \""+(wallworm_getVTFPathFromBitmap mat1.lightwarptexture forcePath:forcePath)+"\"")
										
							)


							
							
							if parallaxmap != undefined  then (
								append extra (parmPrefix+" "+quotes+"$parallaxmap \""+(wallworm_getVTFPathFromBitmap mat1.parallaxmap forcePath:forcePath)+"\"")
								append extra (parmPrefix+" "+quotes+"$parallaxmapscale \""+(mat1.parallaxmapscale as string)+"\"")	


								if parallaxmaptransform != undefined AND parallaxmaptransform != ""  then (
									append extra (parmPrefix+" "+quotes+"$parallaxmaptransform"+quotes+" \""+parallaxmaptransform+"\"")
								)
								
							)
							
							
							if valveShader == "WorldVertexTransition" AND mat2 != undefined AND writeVMT == true then (
								

								tooltexture = getBlendToolTexName()
								if tooltexture != undefined AND tooltexture != "" then (
									append extra (parmPrefix+" "+quotes+"\%tooltexture"+quotes+" \""+(tooltexture)+"\"")
									
									)
								
								if useWWMat == false then (
									
									if detailtype != undefined AND detailtype != "" then (
										append extra (parmPrefix+" "+quotes+"\%detailtype"+quotes+" \""+(detailtype)+"\"")
										
									)
									
									if surfaceproperty2 != undefined AND surfaceproperty2 != "" then (
										append extra (parmPrefix+" "+quotes+"$surfaceprop2"+quotes+" \""+surfaceproperty2+"\"")
										
									)
									
									
								)
								

							if (materialPath2 != undefined AND materialPath2 != "") do (
								mpstring = materialPath2+"\\"
							) 
								
							
							
							
							
								if blendmodulate != undefined AND classof blendmodulate == BitmapTexture then (
									
									
									
									
									append extra (parmPrefix+" "+quotes+"$blendmodulatetexture \""+(wallworm_getVTFPathFromBitmap blendmodulate forcePath:forcePath)+"\"")
										
									if  toLower ((getFilenameType blendmodulate.filename)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
										append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$blendmodulatetexture"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+"1"+quotes+"\n}\n")
									)

										scrollp = getScrollProxie blendmodulate type:"blendmodulatetransform"
										if scrollp != "" then (
											append proxies scrollp
										) else (

										)

										
										
										
								
								)
							

							
								if lightwarptexture2 != undefined  then (
									
									
									
									
									append extra (parmPrefix+" "+quotes+"$lightwarptexture2 \""+(wallworm_getVTFPathFromBitmap mat2.lightwarptexture forcePath:forcePath)+"\"")
										

								
								)
							
							
							--mpstring = wallworm_bsToFs mpstring
								
							if diff2 != undefined then (
								append extra (parmPrefix+" "+quotes+"$basetexture2"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat2.diffuseMap forcePath:forcePath)+"\"")
								if  toLower ((getFilenameType diff2)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
									append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$basetexture2"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+"1"+quotes+"\n}\n")
								)
								
								if mat2.diffuseMap != undefined then (
									scrollp = getScrollProxie mat2.diffuseMap type:"basetexturetransform2"
									if scrollp != "" then (
										append proxies scrollp
									) else (
										--print "No scroll"
									)
								) else (
									--print ("no diffusemap in"+mat1 as string)
								)
								
								
								
							) else (
								
								--add diffcolor 2
								
								)
							

							
							
								
								
								
							if blendmodulatetransform != undefined AND blendmodulatetransform != "" then (
								append extra (parmPrefix+" "+quotes+"$blendmasktransform"+quotes+" \""+blendmodulatetransform+"\"")
							)
								
								
							if basetexturetransform2 != undefined AND basetexturetransform2 != "" then (
								append extra (parmPrefix+" "+quotes+"$basetexturetransform2"+quotes+" \""+basetexturetransform2+"\"")
							)
							

							
							if envmapmasktransform2 != undefined AND envmapmasktransform2 != "" then (
								append extra (parmPrefix+" "+quotes+"$envmapmasktransform2"+quotes+" \""+envmapmasktransform2+"\"")
							)
							
							
							if bumptransform2 != undefined AND bumptransform2 != "" then (
								append extra (parmPrefix+" "+quotes+"$bumptransform2"+quotes+" \""+bumptransform2+"\"")
							)
							
							if detailtexturetransform2 != undefined AND detailtexturetransform2 != "" then (
								append extra (parmPrefix+" "+quotes+"$detailtexturetransform2"+quotes+" \""+detailtexturetransform2+"\"")
							)
							
							if selfillumtexturetransform2 != undefined AND selfillumtexturetransform2 != ""  then (
								append extra (parmPrefix+" "+quotes+"$selfillumtexturetransform2"+quotes+" \""+selfillumtexturetransform2+"\"")
								append extra (parmPrefix+" "+quotes+"$selfillummasktransform2"+quotes+" \""+selfillumtexturetransform2+"\"")
							)
							
							
								
							if  ((specLevelMap2 != undefined AND specLevelMap2 != "" ) OR (classOf mat2 == Standard AND mat2.reflectionMapEnable != undefined AND mat2.reflectionMapEnable == true)) then (
								--add check for texture
								append extra (parmPrefix+" "+quotes+"$envmap2"+quotes+" \"env_cubemap\"")
							)
							

							
							

							
							



							
								

									
									/*
									if diff2 != undefined do (
										append extra (parmPrefix+" "+quotes+"$basetexture"+quotes+" \""+(wallworm_getMaterialName mat2)+"\"")
								
									) 

									*/


							
								if refract2 != undefined then (
									bumpName = "normalmap2"
									) else (
									bumpName = "bumpmap2"
									)
							
									
									
								if normal2 != undefined then (
									
									append extra (parmPrefix+" "+quotes+"$"+bumpName+quotes+" \""+(wallworm_getVTFPathFromBitmap mat2.displacementMap forcePath:forcePath)+"\"")
										
									if  toLower ((getFilenameType normal2)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
										append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$"+bumpName+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+"1"+quotes+"\n}\n")
									)
									if mat2.displacementMap != undefined then (
										scrollp = getScrollProxie mat2.displacementMap type:"bumptransform"
										if scrollp != "" then (
											append proxies scrollp
										) else (
											--print "No scroll"
										)
									) else (
										--print ("no diffusemap in"+mat1 as string)
									)	
										
										
										
								
								) else (
									if bump2 != undefined do (
								
										append extra (parmPrefix+" "+quotes+"$"+bumpName+quotes+" \""+(wallworm_getVTFPathFromBitmap mat2.bumpMap forcePath:forcePath)+"\"")
											
									if  toLower ((getFilenameType bump2)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") )  then (
										append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$"+bumpName+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+"1"+quotes+"\n}\n")
									)
									if mat2.bumpMap != undefined then (
										scrollp = getScrollProxie mat2.bumpMap type:"bumptransform"
										if scrollp != "" then (
											append proxies scrollp
										) else (
											--print "No scroll"
										)
									) else (
										--print ("no diffusemap in"+mat1 as string)
									)	
											
											
									)

								)
								
								

							
									
								
								
								if useWWMat==false AND  useSSBump mat2 == true do (
									
									append extra (parmPrefix+" "+quotes+"$ssbump2"+quotes+" \"1\"")
									
								)
								
								
								
								
								
								if (specLevelMap2 != undefined and valveShader != "Refract") do (
									
									tempBitmap = openBitmap specLevelMap2
									
												if (tempBitmap.hasAlpha) then (
													if diff2 == specLevelMap2 then (
														
															append extra (parmPrefix+" "+quotes+"$basealphaenvmapmask2"+quotes+" \"1\"")
														
														) else if (bump2 == specLevelMap2 OR normal2 == specLevelMap2) then (
														
															append extra (parmPrefix+" "+quotes+"$normalmapalphaenvmapmask2"+quotes+" \"1\"")
														
														) else if (bump2 == illum2) then (
														
															append extra (parmPrefix+" "+quotes+"$selfillum_envmapmask_alpha2"+quotes+" \"1\"")
														
														)

														
												) else (
														
														append extra (parmPrefix+" "+quotes+"$envmapmask2"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat2.specularLevelMap forcePath:forcePath)+"\"")
														
														if  toLower ((getFilenameType specLevelMap2)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") ) then (
															append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$envmapmask2"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+"1"+quotes+"\n}\n")
														)
														
																if mat2.specularLevelMap != undefined then (
																	scrollp = getScrollProxie mat2.specularLevelMap type:"envmapmasktransform2"
																	if scrollp != "" then (
																		append proxies scrollp
																	) else (
																		--print "No scroll"
																	)
																) else (
																	--print ("no diffusemap in"+mat1 as string)
																)	
															
															
															
															
												)
												
												

											
	
								
									
								
								)
								
								
								/*
								if ambient2 != undefined do (
								
									append extra (parmPrefix+" "+quotes+"$AmbientOcclusion"+quotes+"\"1\" "+parmPrefix+" "+quotes+"$AmbientOcclTexture"+quotes+" \""+mpstring+(getTexName(ambient))+"\"")
								
								)
								*/
								if detail2 != undefined do (
								
									append extra (parmPrefix+" "+quotes+"$detail2"+quotes+" \""+(wallworm_getVTFPathFromBitmap (wallworm_detailMapTex mat2) forcePath:forcePath)+"\"")
								
								)
								
								if illum2 != undefined do (
								
									append extra (parmPrefix+" "+quotes+"$selfillum2"+quotes+" \"1\"  "+parmPrefix+" "+quotes+"$selfillumtexture2"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat2.selfIllumMap forcePath:forcePath)+"\""+parmPrefix+" "+quotes+"$selfillummask2"+quotes+" \""+(wallworm_getVTFPathFromBitmap mat2.selfIllumMap forcePath:forcePath)+"\"")
														
										
										
										if  toLower ((getFilenameType illum2)) == ".ifl"  AND (writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") ) then (
															append proxies (parmPrefix+" "+quotes+"AnimatedTexture"+quotes+"\n{\n"+quotes+"animatedTextureVar"+quotes+" "+quotes+"$selfillumtexture2"+quotes+"\n"+quotes+"animatedTextureFrameNumVar"+quotes+" "+quotes+"$frame"+quotes+"\n"+quotes+"animatedTextureFrameRate"+quotes+" "+quotes+"1"+quotes+"\n}\n")
														)
														
																if mat2.specularLevelMap != undefined then (
																	scrollp = getScrollProxie mat2.specularLevelMap type:"selfillumtexturetransform2"
																	if scrollp != "" then (
																		append proxies scrollp
																	) else (
																		--print "No scroll"
																	)
																) else (
																	--print ("no diffusemap in"+mat1 as string)
																)	
								)
								/*
								if spec2 != undefined AND mat2.shaderType == 6 AND valveShader=="VertexLitGeneric"  do (
									--Phong
									append extra (parmPrefix+" "+quotes+"$phong"+quotes+" \"1\" "+parmPrefix+" "+quotes+"$phongexponenttexture"+quotes+" \""+mpstring+(getTexName(spec))+"\" "+parmPrefix+" "+quotes+"$phongboost"+quotes+"  \"1.0\" "+parmPrefix+" "+quotes+"$phongfresnelranges"+quotes+" \" [0 0.5 1]\"")
								)
								
								--check if 2-sided
								
								if mat2.refractionMapEnable == true do (
									



										
									local refractAmount = mat2.refractionMapAmount / 100

										
									if mat2.refractionMap != undefined then(
										
										if classOf mat2.refractionMap == BitmapTexture then (
											
										append extra (parmPrefix+" "+quotes+"$refracttinttexture"+quotes+" \""+(mpstring+(getTexName(refract)))+"\" "+parmPrefix+" "+quotes+"$bluramount"+quotes+" \""+(mat2.refractionMap.coords.blur as string)+"\"")
											
											
											
											
										) else(
											if classOf mat2.refractionMap == Color_Correction then (
											
												append extra (parmPrefix+" "+quotes+"$refracttint"+quotes+" \"{"+(mat2.refractionMap.color[1] as string)+" "+(mat2.refractionMap.color[2] as string)+" "+(mat2.refractionMap.color[3] as string)+"}\" "+parmPrefix+" "+quotes+"$bluramount"+quotes+" \"1\"")
											
											)
											
										)
									)  else()

										append extra (parmPrefix+" "+quotes+"$refractamount"+quotes+" \""+(refractAmount as string)+"\"")
									
								)
								
								*/
								if mat2.reflectionMapEnable == true do (
									
									local reflect = mat2.reflectionMapAmount / 100
									local useReflectMap = false
									try (												
										if mat2.reflectionMap != undefined AND classOf mat2.reflectionMap == Color_Correction do (
												useReflectMap = true
												append extra (parmPrefix+" "+quotes+"$reflectivity2"+quotes+" \"{"+(mat2.reflectionMap.color[1] as string)+" "+(mat2.reflectionMap.color[2] as string)+" "+(mat2.reflectionMap.color[3] as string)+"}\"")
											) 
										) catch (
											--probably failed because older version of Max... Color_Correction added in Max 2009
											useReflectMap = false
										)

									if useReflectMap == false do (
										append extra (parmPrefix+" "+quotes+"$reflectivity2"+quotes+" \"["+(reflect as string)+" "+(reflect as string)+" "+(reflect as string)+"]\"")
									)
											
											
											
								)

								nocull = false
								if (mat2.twoSided != undefined AND mat2.twoSided == on) do (
									nocull = true
									append extra (parmPrefix+" "+quotes+"$nocull2"+quotes+" \"1\"")
								)									
								if ((mat2.opacity != undefined AND mat2.opacity != 100) ) do (

									alphavalue = mat2.opacity / 100
									append extra (parmPrefix+" "+quotes+"$alpha2"+quotes+" \""+(alphavalue as string)+"\"")
									if mat2.opacityType == 2 do (
										append extra (parmPrefix+" "+quotes+"$additive2"+quotes+" \"1\"")
									)
									
								)
								
								

								
								addTrans = false
								checkForAlpha = false

								if (wwmt_translucentOnlyIfOpacityMap == true OR wwmt_translucentOnlyIfOpacityMap == "true")  then (

										if mat2.opacityMap != undefined AND mat2.opacityMap.filename == diff do (
											checkForAlpha = true
										)
								) else (
										checkForAlpha = true
								)

									
									if checkForAlpha == true do (
										
										diffBitmap = openBitmap diff									
										if (diffBitmap.hasAlpha == true)  do (
											addTrans = true
										) 
										
									)
								
								
								
								
								if addTrans == true do (

											append extra (parmPrefix+" "+quotes+"$translucent"+quotes+" \"1\"")										
							
									
								)

								

								
								/*END MAT 2*/
								
								
								
								
								)

							
							
							
							) else (
							
							   if type=="normal" do (
								   
								    append extra (parmPrefix+" "+quotes+"$normal"+quotes+" \"1\"")
								   
								   
								   )
									if type=="bump" do (
								   
										
										
								   append extra (parmPrefix+" "+quotes+"$normal"+quotes+" \"1\"")
								   
								   
								   )
								   

								   
							)
							

								


					
					
					local shaderUsed = valveShader
					if type != "diff" AND valveShader=="WorldVertexTransition" do (
						shaderUsed = "LightmappedGeneric"
						)
					if valveShader!="WorldVertexTransition" AND type=="diff" AND mat1.refractionMapEnable == true then (
						shaderUsed = "Refract"
						)	

					local VMTWritten = false
					if writeVMT == true OR (wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "") then ( 
						
						
						
						if exportVTF == false OR forModel == true then (
						



							
							
							if useDiffColor == true OR (isProperty mat1 "useColor" AND mat1.useColor == true)   then (
								
								
								local color2 = ""
								if forModel == true AND valveShader=="VertexLitGeneric" then (
									color2 = "2"
									append extra (parmPrefix+" "+quotes+"$color"+color2+quotes+" \"{"+((mat1.diffuse as color).r as string)+" "+((mat1.diffuse as color).g as string)+" "+((mat1.diffuse as color).b as string)+"}\"")
								
									
								) else (
									
									if forModel == true then (
										append extra (parmPrefix+" "+quotes+"$color"+color2+quotes+" \"{"+(((mat1.diffuse as color).r  as integer) as string)+" "+(((mat1.diffuse as color).g as integer) as string)+" "+(((mat1.diffuse as color).b as integer) as string)+"}\"")
									) else (
										
										append extra (parmPrefix+" "+quotes+"$color"+color2+quotes+" \"["+(((mat1.diffuse as color).r/256  as float) as string)+" "+(((mat1.diffuse as color).g/256 as float) as string)+" "+(((mat1.diffuse as color).b/256 as float) as string)+"]\"")

									)
								)
								
								if  (isProperty mat1 "blendTintByBaseAlpha" AND mat1.blendTintByBaseAlpha == true)  then (
									append extra (parmPrefix+" "+quotes+"$blendTintByBaseAlpha"+quotes+" \"1\"")
								)

								if  (isProperty mat1 "blendTintColorOverBase" AND mat1.blendTintColorOverBase > 0.0)  then (
									append extra (parmPrefix+" "+quotes+"$blendTintColorOverBase"+quotes+" \""+mat1.blendTintColorOverBase as string+"\"")
								)
								
							) else (
								
									
								
							)
							if doesFileExist (getFileNamePath vmfName) == false then (
								makeDir (getFileNamePath vmfName) all:true
							)
								print 	vmfName
							
							
							

							
							
							if doesFileExist vmfName == true then (
								local newVMF = OpenFile vmfName mode:"w"	
							) else (
								local newVMF = CreateFile(vmfName)		
							)
							
	
							try (
								
								if proxies.count > 0 then (
									
									append extra ("\nProxies\n{")
									
									for p in proxies do (
										append extra p
										
									)
									
									
									
									append extra ("\n}\n")
									
								)
								
								
								
								bt = ("\""+shaderUsed+"\"\n{\n"+extra+"\n}")
								Format bt to:newVMF
							) catch (
								print (getCurrentException())
							)
							close newVMF
							)
							VMTWritten = true

					) 
					
					(
						
							
					
					local gameInfoParam = ""
					if useDiffColor == false AND exportVTF==true do (								
						wallworm_copy_bitmap_to_sdk tex forcePath:mpstring texlist:texlist compression:compression type:type
						bt = wallworm_write_vtf_bat tex diffName:diffName dir:mpstring VMTWritten:VMTWritten runBat:runBat exportVTF:exportVTF extra:extra shaderUsed:shaderUsed
						
						
					)							
							

						
						
	
						/*
					if ((maxVersion())[1] >= 14000) then (
						if doesFileExist (wwmt_exportMats+"\\"+materialPath+"\\"+materialName+".bat") then (
							newBatch = openFile (wwmt_exportMats+"\\"+materialPath+"\\"+materialName+".bat")
							seek newBatch #eof
							maxlen=filepos newBatch
							seek newBatch 0
							res = readChars newBatch maxlen errorAtEOF:false
							(dotnetclass "System.IO.File").WriteAllText (wwmt_exportMats+"\\"+materialPath+"\\"+materialName+"_2012.bat") res	

							close newBatch
							if runBat == true then (
								shellLaunch (wwmt_exportMats+"\\"+materialPath+"\\"+materialName+"_2012.bat") ""
							)
						) else (
							
							print ("Could not find "+wwmt_exportMats+"\\"+materialPath+"\\"+materialName+".bat")
							
							)
					)	else (
						*/


					--)
						
					
						
					--if (wwmtAutoCompile == "true") do (
							
							--compileBatStr = wwDir+"\\"+modelName+".bat"
						--print compileBatStr
							--shellLaunch batchName ""
							
					--)			
						
						
						
						
						)
						

						
						if 	runBat == false then (
						
						return bt
						
						) else ()		
		
						
					) else (
					 

					)

	
		--	) catch (
			--	append errors ( "The texture was not exported. The main reasons are that MAXScript does not have permission to write to your Materialsrc folder or Steam is not running.\n\n"+getCurrentException()+"\n\nMake sure that the folder for this material exists in your materialsrc folder in SDK.")

				--messagebox m
				
			--)
				if errors.count > 0 then (
					out = "There were errors. Please read the following notes:\n\n##########################\n\n"
					for er in errors do (
						 append out ("* "+er+"\n\n")
					)
					
					 print out
					 if shoutNotice == true then (
					 messagebox out	
					 ) else (
						 
					)
					
				)
		
		),
		function compileMaterial = (
			
							compileTexture diff "diff"
			
							if bump != undefined do (
								
								compileTexture bump "bump"
							)
							
							if detail != undefined do (
								
								compileTexture detail "detail"
							)
							
							
							if diff2 != undefined do (
								
								compileTexture diff2 "diff2"
							)
							
								
							if normal != undefined do (
								
								compileTexture normal "normal"
								
							)
								
							if ambient != undefined do (
								
								compileTexture ambient "ambient"
							)
								
								
							if specLevelMap != undefined do (
								
								compileTexture specLevelMap "specLevelMap"
							)
								
							if illum != undefined do (
								
								compileTexture illum "illum"
							)
							
							if spec != undefined do (
								
								compileTexture spec "spec"
							)
							if refract != undefined do (
								
								compileTexture refract "refract"
							)
							
							if lightwarptexture != undefined then (
								compileTexture lightwarptexture "lightwarptexture"
								
							)
							
							if parallaxmap != undefined then (
								compileTexture parallaxmap "parallaxmap"
								
							)
							
							

							

							
			
			)
	
	
	
	
	)