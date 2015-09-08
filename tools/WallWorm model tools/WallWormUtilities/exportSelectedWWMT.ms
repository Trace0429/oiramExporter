				fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
				
				function wallworm_export_wwmts wwmtcollection =  (
					passed = #()
					failed = #()

					for obj in wwmtcollection  do (
						local tempWWMT = ww_LOD_wrapper()
						tempWWMT.init()					
						tempWWMT.setTargetModel obj tempWWMT
						
						if (tempWWMT.outputModelQC()) != false then (
							append passed tempWWMT
						) else (
							append failed tempWWMT
						)
						tempWWMT = undefined
						gc()

					)
					(#(passed,failed))
				)
	
	
					 oldsel
					 reSelect 
					 dolayers = false
	
					runExport = true
				
					
					if selection.count > 0 then (
					   oldsel = selection as array
						
						
						reSelect = true
					) else (
						
						oldsel = objects as array
						reSelect = false
						
						dolayers = true
						
						runExport = queryBox "Since you did not select specific WWMT Helpers, all Model's will export textures... which can take a long time.\n\nAre you sure?"
						
					)
					
					if runExport then (
					
					
					wwmtcollection = for obj in oldsel where isProperty obj "Wallworm Model Tools" OR getUserProp obj "wwmt_source_helper" != undefined collect obj

					
					

					
					
					
					     wwmts = 0
					     failed = #()
					    clearSelection()
					

						res = wallworm_export_wwmts wwmtcollection
				
						wwmts = res[1].count
				
						join failed  (res[2])
				
						if dolayers then (
				
							
							refObjects = wallworm_get_all_objects()
								
								local wwmtcollection2 = for obj in refObjects where isProperty obj "Wallworm Model Tools" OR getUserProp obj "wwmt_source_helper"  != undefined collect obj
								if wwmtcollection2.count > 0 then (
									res = wallworm_export_wwmts wwmtcollection2
									wwmts += res[1].count
									join failed  (res[2])
								)


							
							
							
							
						)
						
						
						
						if reSelect == true then (
							select oldsel
						)
						 failedmessage = ""
						if failed.count > 0 do (
							
							failedmessage= "\n\n("+(failed.count as string)+") Model(s) failed to export. Press F11 to see the list."
							for i in failed do (
								print (i.modelname)
								)
							)
						
						if wwmts == 0 then (
							
							messagebox ("No no models were exported. Either no WWMT helpers were selected or there were errors."+failedmessage)
							
							) else (
							
							messagebox ((wwmts as string)+ " models were exported."+failedmessage)
							
						)
					)
