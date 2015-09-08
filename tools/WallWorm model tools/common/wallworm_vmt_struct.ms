Struct wallworm_vmt (
	valveShader="VertexLitGeneric",
	mat,
	matName,
	_mat2, --for WOrldVertexTransition
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
	_basetexturetransform2, --for WOrldVertexTransition
	
	
	
	function useSSBump m = (
		
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
				
				return false
		
		),
	
	
	
	--function setPropertiesFromMaterial m = (
	function compileTexture m type frame:undefined runBat:true shoutNotice:true writeVMT:false exportVTF:true = (
		

		
				--try (
					errors = #()
					useDiffColor = false

					if (wallworm_mat_name_limit_check diffName)	== false then (
						append errors ("Your texture named "+diffName+" is invalid because the filename is too long. Limit the texture names to 22 characters or less.")
						
						)
				
					if errors.count == 0 then (

						local mpstring = ""
						
						

						
						if matName != undefined AND matName != "" then (
							materialName = matName
						) else (
							materialName = diffName
						)
						
						
						
						
						if (materialPath != undefined AND materialPath != "") do (
							
							mpstring = materialPath+"\\"
							) 
						
							if writeVMT == false then (
							
							local parmPrefix = " -vmtparam"
							local quotes = "\""
								
							) else (
								
								parmPrefix = "\n	"
								quotes = ""
								)
							
						
							if diffName != "" then (
								
								if exportVTF == true then (
									tga = wwmt_exportMats+"\\"+mpstring+diffName+(toLower ((getFilenameType m)) )
									if doesFileExist tga then (
										deleteFile tga
										
									)
									
									
									copyFile texlist[1] tga		
									
		
								if (toLower ((getFilenameType m)) == ".ifl") then (
								
									tga2 = wwmt_exportMats+"\\"+mpstring+(getTexName texlist[1])+(toLower ((getFilenameType texlist[1])) )
									if doesFileExist tga2 then (
										deleteFile tga2
										
									)
									
									
									copyFile texlist[1] tga2		
								
								
								) else (
								

								
								

								
								)
							)
							if runBat == false then (
								return ""
								)
								
								
								
								batchName  = wallworm_FsToBs (wwmt_exportMats+"\\"+mpstring+diffName+".bat")
								
								
								


								
								
							) else (
								
								if valveShader != "WorldVertexTransition" then (
								
									useDiffColor = true
								)
								writeVMT = true
							)
							
							if useDiffColor == true OR writeVMT == true then (
								materialName = mat.name
								tga = ""
								if forModel == true then (
									if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" then (
										vmfName  = wwmt_gameInfoDir+"\\materials\\"+mpstring+materialName+".vmt"
									) else (
										vmfName  = wwmt_exportMats+"\\"+mpstring+materialName+".vmt"
									)
								) else (
									if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" then (
										vmfName  = wwmt_gameInfoDir+"\\materials\\"+materialName+".vmt"
									) else (
										
										vmfName  = wwmt_exportMats+"\\"+materialName+".vmt"
	
									)

								)
								parmPrefix = "\n	"
								quotes = ""
								--print ("Diffuse Color Mat sent to: "+batchName)
									
								
	
									
									
							)
							
							

								if doesFileExist (getFileNamePath (wwmt_exportMats+"\\"+mpstring+diffName+".txt")) == false then (
									makeDir (getFileNamePath (wwmt_exportMats+"\\"+mpstring+diffName+".txt")) all:true
								)
							
							
	
						local newParams = CreateFile(wwmt_exportMats+"\\"+mpstring+diffName+".txt")			

								
								

						

						
						if  (valveShader=="VertexLitGeneric" OR forModel==true) AND materialPath != undefined then (	
							extra = parmPrefix+" "+quotes+"$model"+quotes+" \"1\""
						) else(
							extra = ""
						)
						

							
						
					    if type=="diff" then (
							--this is diffuse 
							
								--if diffName != materialName do (
									--append extra (" -vmtparam  \"$basetexture\" \""+mpstring+(diffName)+"\"")
									--tga = wwmt_exportMats+"\\"+mpstring+materialName+".tga"
								--)	

							
							if  ((specLevelMap != undefined AND specLevelMap != "" ) OR (classOf mat == Standard AND mat.reflectionMapEnable != undefined AND mat.reflectionMapEnable == true)) then (
								
								--add check for texture
								append extra (parmPrefix+" "+quotes+"$envmap"+quotes+" \"env_cubemap\"")
								
								
							)
							
							if  ((specLevelMap2 != undefined AND specLevelMap2 != "" ) OR (classOf mat2 == Standard AND mat2.reflectionMapEnable != undefined AND mat2.reflectionMapEnable == true)) then (
								
								--add check for texture
								append extra (parmPrefix+" "+quotes+"$envmap"+quotes+" \"env_cubemap\"")
								
								
							)
							
							
							if surfaceproperty != undefined AND surfaceproperty != "" then (
								append extra (parmPrefix+" "+quotes+"$surfaceprop"+quotes+" \""+surfaceproperty+"\"")
								
								)
							
							
								if  writeVMT == true AND valveShader!="WorldVertexTransition" then (
									
									append extra (parmPrefix+" "+quotes+"$basetexture"+quotes+" \""+mpstring+(getTexName(diff))+"\"")
									
								)
								
								if valveShader=="WorldVertexTransition" then (
									
									
									
									
									if diff != undefined do (
										append extra (parmPrefix+" "+quotes+"$basetexture2"+quotes+" \""+(wallworm_getMaterialName mat.map1)+"\"")
								
									) 
									
									
									if diff2 != undefined do (
										append extra (parmPrefix+" "+quotes+"$basetexture"+quotes+" \""+(wallworm_getMaterialName mat.map2)+"\"")
								
									) 

									
								) else (

							
								if refract != undefined then (
									bumpName = "normalmap"
									) else (
									bumpName = "bumpmap"
									)
							
									
									
								if normal != undefined then (
									
									append extra (parmPrefix+" "+quotes+"$"+bumpName+quotes+" \""+mpstring+(getTexName(normal))+"\"")
								
								) else (
									if bump != undefined do (
								
										append extra (parmPrefix+" "+quotes+"$"+bumpName+quotes+" \""+mpstring+(getTexName(bump))+"\"")
								
									)

								)
								
								
								if useSSBump() == true do (
									
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
																append extra (parmPrefix+" "+quotes+"$envmapmask"+quotes+" \""+mpstring+(getTexName(specLevelMap))+"\"")
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
													
-- 												if bump != undefined  do (
-- 													proceed=true
-- 													checkBump = true
-- 													)
-- 												if normal != undefined  do (
-- 													proceed=true
-- 													checkNormal = true
-- 													)
-- 												if illum != undefined  do (
-- 													proceed=true
-- 													checkIllum=true
-- 													)	
													
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
														append extra (parmPrefix+" "+quotes+"$envmapmask"+quotes+" \""+mpstring+(getTexName(specLevelMap))+"\"")
														)
												
												
												)
										
									) else (
										


											
												if (tempBitmap.hasAlpha) then (
													if diff == specLevelMap then (
														
															append extra (parmPrefix+" "+quotes+"$basealphaenvmapmask"+quotes+" \"1\"")
														
														) else if (bump == specLevelMap OR normal == specLevelMap) then (
														
															append extra (parmPrefix+" "+quotes+"$normalmapalphaenvmapmask"+quotes+" \"1\"")
														
														) else (
														
															append extra (parmPrefix+" "+quotes+"$selfillum_envmapmask_alpha"+quotes+" \"1\"")
														
														)

														
												) else (
														
														append extra (parmPrefix+" "+quotes+"$envmapmask"+quotes+" \""+mpstring+(getTexName(specLevelMap))+"\"")
														
														)
												
												

											
									)
								
									
								
								)
								
								
								
								if ambient != undefined do (
								
									append extra (parmPrefix+" "+quotes+"$AmbientOcclusion"+quotes+"\"1\" "+parmPrefix+" "+quotes+"$AmbientOcclTexture"+quotes+" \""+mpstring+(getTexName(ambient))+"\"")
								
								)
								
								if detail != undefined do (
								
									append extra (parmPrefix+" "+quotes+"$detail"+quotes+" \""+mpstring+(getTexName(detail))+"\"")
								
								)
								
								if illum != undefined do (
								
									append extra (parmPrefix+" "+quotes+"$selfillum"+quotes+" \"1\"  "+parmPrefix+" "+quotes+"$selfillumtexture"+quotes+" \""+mpstring+(getTexName(illum))+"\""+parmPrefix+" "+quotes+"$selfillummask"+quotes+" \""+mpstring+(getTexName(illum))+"\"")
								
								)
								
								if spec != undefined AND mat.shaderType == 6 AND valveShader=="VertexLitGeneric"  do (
									--Phong
									append extra (parmPrefix+" "+quotes+"$phong"+quotes+" \"1\" "+parmPrefix+" "+quotes+"$phongexponenttexture"+quotes+" \""+mpstring+(getTexName(spec))+"\" "+parmPrefix+" "+quotes+"$phongboost"+quotes+"  \"1.0\" "+parmPrefix+" "+quotes+"$phongfresnelranges"+quotes+" \" [0 0.5 1]\"")
								)
								
								--check if 2-sided
								
								if mat.refractionMapEnable == true do (
									



										
									local refractAmount = mat.refractionMapAmount / 100

										
									if mat.refractionMap != undefined then(
										
										if classOf mat.refractionMap == BitmapTexture then (
											
										append extra (parmPrefix+" "+quotes+"$refracttinttexture"+quotes+" \""+(mpstring+(getTexName(refract)))+"\" "+parmPrefix+" "+quotes+"$bluramount"+quotes+" \""+(mat.refractionMap.coords.blur as string)+"\"")
											
											
											
											
										) else(
											if classOf mat.refractionMap == Color_Correction then (
											
												append extra (parmPrefix+" "+quotes+"$refracttint"+quotes+" \"{"+(mat.refractionMap.color[1] as string)+" "+(mat.refractionMap.color[2] as string)+" "+(mat.refractionMap.color[3] as string)+"}\" "+parmPrefix+" "+quotes+"$bluramount"+quotes+" \"1\"")
											
											)
											
										)
									)  else()

										append extra (parmPrefix+" "+quotes+"$refractamount"+quotes+" \""+(refractAmount as string)+"\"")
									
								)
								
								
								if mat.reflectionMapEnable == true do (
									
									local reflect = mat.reflectionMapAmount / 100
									local useReflectMap = false
									try (												
										if mat.reflectionMap != undefined AND classOf mat.reflectionMap == Color_Correction do (
												useReflectMap = true
												append extra (parmPrefix+" "+quotes+"$reflectivity"+quotes+" \"{"+(mat.reflectionMap.color[1] as string)+" "+(mat.reflectionMap.color[2] as string)+" "+(mat.reflectionMap.color[3] as string)+"}\"")
											) 
										) catch (
											--probably failed because older version of Max... Color_Correction added in Max 2009
											append extra (parmPrefix+" "+quotes+"$reflectivity"+quotes+" \"["+(reflect as string)+" "+(reflect as string)+" "+(reflect as string)+"]\"")
											)

									if useReflectMap == false do (
										append extra (parmPrefix+" "+quotes+"$reflectivity"+quotes+" \"["+(reflect as string)+" "+(reflect as string)+" "+(reflect as string)+"]\"")
									)
											
											
											
								)

								nocull = false

								
								if (mat.twoSided != undefined AND mat.twoSided == on) do (
									nocull = true
									append extra (parmPrefix+" "+quotes+"$nocull"+quotes+" \"1\"")
									
								)									
								
								
								if forceOpaque == false do (								
								
									

								

								
								if ((mat.opacity != undefined AND mat.opacity != 100) ) do (

									alphavalue = mat.opacity / 100
									append extra (parmPrefix+" "+quotes+"$alpha"+quotes+" \""+(alphavalue as string)+"\"")
									if mat.opacityType == 2 do (
										append extra (parmPrefix+" "+quotes+"$additive"+quotes+" \"1\"")
									)
									
								)
								
								

								
								addTrans = false
								checkForAlpha = false

								if (wwmt_translucentOnlyIfOpacityMap == true OR wwmt_translucentOnlyIfOpacityMap == "true")  then (

										if mat.opacityMap != undefined AND mat.opacityMap.filename == diff do (
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
									
									if (nocull==true AND (valveShader=="VertexLitGeneric" OR forModel==true)) OR illum != undefined then (
											append extra (parmPrefix+" "+quotes+"$alphatest"+quotes+" \"1\"")
									)	else if addTrans==true do (
											append extra (parmPrefix+" "+quotes+"$translucent"+quotes+" \"1\"")										
									)									
									
								)
								
							)

							
							
						)
							
							
							
							) else (
							
							   if type=="normal" do (
								   
								    append extra (parmPrefix+" "+quotes+"$normal"+quotes+" \"1\"")
								   
								   
								   )
									if type=="bump" do (
								   
										
										
								   append extra (parmPrefix+" "+quotes+"$normal"+quotes+" \"1\"")
								   
								   
								   )
								   

								   
							)
							
							
							if doesFileExist (getFileNamePath batchName) == false then (
									makeDir (getFileNamePath batchName) all:true
							)
								

					
					if compression != undefined and compression != "" then (
						
						
						--append gameInfoParam (" -"+(toLower compression))
							
						format ((toLower compression)+" 1\n") to:newParams	
							
							
					)
					if texlist.count > 1 then (
						
						format ("startframe 0\nendframe "+((texlist.count-1)	 as string)+"\n") to:newParams	
					
					)
					
					
					local shaderUsed = valveShader
					if type != "diff" AND valveShader=="WorldVertexTransition" do (
						shaderUsed = "LightmappedGeneric"
						)
					if valveShader!="WorldVertexTransition" AND type=="diff" AND mat.refractionMapEnable == true then (
						shaderUsed = "Refract"
						)	

						
					if  writeVMT==true then (
						
						
						if useDiffColor == true AND valveShader!="WorldVertexTransition"  then (
							
							append extra (parmPrefix+" "+quotes+"$color"+quotes+" \"{"+((mat.diffuse as color).r as string)+" "+((mat.diffuse as color).g as string)+" "+((mat.diffuse as color).b as string)+"}\"")
							
						) else (
							
								
							
						)
						if doesFileExist (getFileNamePath vmfName) == false then (
							makeDir (getFileNamePath vmfName) all:true
						)
									
						try (		
							local newVMF = CreateFile(vmfName)		
						) catch (
							
							local newVMF = OpenFile vmfName mode:"w"	
						)		
						
						bt = "\""+shaderUsed+"\"\n{\n"+extra+"\n}"
						Format bt to:newVMF

						close newVMF



						) else (
						
							
					
					local gameInfoParam = ""
					if useDiffColor == false do (								
								try (										
									local newBatch = CreateFile(batchName)	
-- 									if doesFileExist  batchName == true then (
-- 										
-- 									
-- 									) else (
-- 									
-- 										
-- 									)
								

										
								) catch (
									try (
										local newBatch = OpenFile batchName mode:"w"	
									) catch (
										local newBatch = CreateFile(batchName)	
										
										)
								)				
								

							

					Format "@echo on\n" to:newBatch		
					local bt = "cd \""+wwmt_binDir+">\"\n" 
				    Format bt to:newBatch
							
					
					if wwmt_gameInfoDir != undefined AND wwmt_gameInfoDir != "" do (
						gameInfoParam = " -game \""+wwmt_gameInfoDir+"\""
						
						) 
					)
						
					if writeVMT==true then (
						extra = ""
						) else (
						
						extra = " -shader "+shaderUsed+extra
						)	
						
						
					if runBat == false then (
						
						append gameInfoParam " -nopause"
						)
						
					bt = "vtex.exe"+gameInfoParam+" -mkdir "+extra+" \""+tga+"\"\n"

						
					Format bt to:newBatch
					/*	
					if batchstring != "" then (
						
						format batchstring to:newBatch
						
						)	
					*/
					Format "@pause\n" to:newBatch
					
					close newBatch
							
							
							

						
						
	
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

						if runBat == true AND exportVTF == true then (
							shellLaunch batchName ""
						)
					--)
						
					
						
					--if (wwmtAutoCompile == "true") do (
							
							--compileBatStr = wwDir+"\\"+modelName+".bat"
						--print compileBatStr
							--shellLaunch batchName ""
							
					--)			
						
						
						
						
						)
						
					close newParams
						
						if 	runBat == false then (
						
						return bt
						
						) else ()		
		
						
					) else (
					 

					)

	
			--) catch (
				--append errors ( "The texture was not exported. The main reasons are that MAXScript does not have permission to write to your Materialsrc folder or Steam is not running.\n\n"+getCurrentException()+"\n\nMake sure that the folder for this material exists in your materialsrc folder in SDK.")

				--messagebox m
				
				--)
				if errors.count > 0 then (
					out = "There were errors. Please read the following notes:\n\n##########################\n\n"
					for er in errors do (
						 append out ("* "+er+"\n\n")
					)
					 if shoutNotice == true then (
					 messagebox out	
					 ) else (
						 print out
					)
				)
		
		),
	
	
	
	)