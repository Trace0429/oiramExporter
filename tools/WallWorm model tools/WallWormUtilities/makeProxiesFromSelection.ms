	include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
	(
	if selection.count == 0 then (
						
						messagebox "This function only works when you have selected a set of WWMT helpers."
						
						) else (
							   oldsel = selection as array
							    local wwmts = 0
							    clearSelection()
								for obj in oldsel where  (getUserProp obj "wwmt_source_helper" != undefined) do (
									
									isWWMTSource = getUserProp obj "wwmt_source_helper"	
									 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
												local tempWWMT = ww_LOD_wrapper()
												tempWWMT.init()					
												tempWWMT.setTargetModel obj tempWWMT

												selectMore (tempWWMT.createProxy())
		
												wwmts+=1
										
										
									)
								
								)
								
								
								
								
								
								if wwmts == 0 then (
									
									messagebox "No WWMT helpers were selected; no proxies were created."
									
									) else (
									
									messagebox ((wwmts as string)+ " proxies were created.")
									
									)
								
							)
	)