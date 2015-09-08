
						global wallworm_tex_already_exported = #()
						
						function wallworm_should_export_tex tex = (
							
							global wallworm_tex_already_exported
							if (findItem wallworm_tex_already_exported tex) > 0 then (
								--print (tex + " already found. Not exporting.")
								return false
								) else (
								append wallworm_tex_already_exported tex
								--print (tex + " exporting.")
								return true
							)
							
							
						)
						

(
				
print "Starting Wall Worm Model VTF exporter."

fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
	
wwProceedTexCompile = wallworm_canCompileTextures() 
if wwProceedTexCompile == true then (
	
	forcePrompt  = false
	runExport = true
					if selection.count > 0 then (
					   oldsel = selection as array
						reSelect = true
					) else (
						
						
						forcePrompt = true
						
						
						oldsel = objects as array
						
						refObjects = wallworm_get_all_objects()
						if refObjects.count > 0 then (
							join oldsel refObjects
						)
						
						reSelect = false
						)
					   
						
						if forcePrompt then ( runExport = queryBox "Since you did not select specific WWMT Helpers, all Model's will export textures... which can take a long time.\n\nAre you sure?" ) 
						
						if runExport then (
						--print oldsel.count 
					    clearSelection()
						for obj in oldsel WHERE (getUserProp obj "wwmt_source_helper") != undefined do (
							
							isWWMTSource = isProperty obj "wwmt_ca" OR getUserProp obj "wwmt_source_helper"	
							
							
							 if isDeleted obj == false AND  isWWMTSource==true do (
								 
										global wwmt_oldModelVTFPath
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel obj tempWWMT
										tempWWMT.populateMyMaterials()
										for m in tempWWMT.materials do (
											m.forModel = true
											if m.mat1 == undefined then m.mat1 = m.mat
											
											if wwmt_oldModelVTFPath == true then (
												
												wwmt_vtfMmatPath = tempWWMT.materialPath
												) else (
												
												wwmt_vtfMmatPath = ""
												
												)
											m.matName = wallworm_getMaterialName m.mat1 forModel:true
											
											--try (
			
												if m.diff != undefined AND (wallworm_should_export_tex m.diff) == true do (
													--
													
													thisNorm = false
													if m.bump == m.diff OR m.normal == m.diff then (
														thisNorm = true
														)
													wallworm_copy_bitmap_to_sdk m.mat.diffuseMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:thisNorm
													wallworm_write_vtf_bat m.mat.diffuseMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
				
													
													
												)
											--) catch(
												--print (getCurrentException())
												--)
											try (
												if m.bump != undefined  AND (wallworm_should_export_tex m.bump) == true  do (
												--m.compileTexture m.bump "bump" shoutNotice:false
													wallworm_copy_bitmap_to_sdk m.mat.bumpMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:true
													wallworm_write_vtf_bat m.mat.bumpMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
													
													)
											) catch()

											try (
												if m.normal != undefined AND (wallworm_should_export_tex m.normal) == true  do (
													--m.compileTexture m.normal "normal" shoutNotice:false
													wallworm_copy_bitmap_to_sdk m.mat.displacementMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:true
													wallworm_write_vtf_bat m.mat.displacementMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
												)
											) catch()
											try (
												if m.spec != undefined AND (wallworm_should_export_tex m.spec) == true  do (
													--m.compileTexture m.spec "spec" shoutNotice:false
													wallworm_copy_bitmap_to_sdk m.mat.specularMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:false
													wallworm_write_vtf_bat m.mat.specularMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
												)
											) catch()
											
											try (
												if m.ambient != undefined  AND (wallworm_should_export_tex m.ambient) == true  do (
													--m.compileTexture m.ambient "ambient" shoutNotice:false
													wallworm_copy_bitmap_to_sdk m.mat.ambientMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:false
													wallworm_write_vtf_bat m.mat.ambientMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
													
													
												)
											) catch()
											
											try (
												if m.specLevelMap != undefined AND (wallworm_should_export_tex m.specLevelMap) == true  do (
													m.compileTexture m.specLevelMap "specLevelMap" shoutNotice:false
													wallworm_copy_bitmap_to_sdk m.mat.specularLevelMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:false
													wallworm_write_vtf_bat m.mat.specularLevelMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
												)
											) catch()
											try (
												if m.illum != undefined AND (wallworm_should_export_tex m.illum) == true  do (
													--m.compileTexture m.illum "illum" shoutNotice:false
													wallworm_copy_bitmap_to_sdk m.mat.selfIllumMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:false
													wallworm_write_vtf_bat m.mat.selfIllumMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
													
												)
											) catch()
		
											try (
												if m.refract != undefined AND (wallworm_should_export_tex m.refract) == true  do (
													--m.compileTexture m.refract "refract" shoutNotice:false
													wallworm_copy_bitmap_to_sdk m.mat.refractionMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:false
													wallworm_write_vtf_bat m.mat.refractionMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
												)
											) catch()
											
											try (
												if m.detail != undefined AND (wallworm_should_export_tex m.detail) == true  do (
													
													detailMap = wallworm_detailMapTex m.mat1
													--m.compileTexture m.detail "detail" shoutNotice:false
													wallworm_copy_bitmap_to_sdk detailMap forcePath:wwmt_vtfMmatPath compression:tempWWMT.compression norm:false
													wallworm_write_vtf_bat detailMap  dir:wwmt_vtfMmatPath VMTWritten:true runBat:true exportVTF:true shaderUsed:tempWWMT.shaderType
													
												)
											) catch()
											

											
											m.compileTexture m.mat.diffuseMap "diff" shoutNotice:false writeVMT:true exportVTF:false
											
											
										
										)
		
							)
						
						)
					
					)
						if reSelect == true then (
							select oldsel
						)
					
						print "Finished Wall Worm Model VTF exporter."
) else (
	
	msg = "There are problems:\n\n"
	for er in wwProceedTexCompile do (
		append msg ("* "+er+"\n")
		)
	 messagebox msg
	)
	)