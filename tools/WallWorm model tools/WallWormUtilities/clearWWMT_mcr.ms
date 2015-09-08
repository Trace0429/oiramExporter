macroscript WallWormClearWWMTMCR
category:"wallworm.com"
tooltip:"Clean WWMT data from mesh."
buttontext:"Clear WWMT Data"
(
on execute do (
	
if selection.count > 0 do (

	
			local vals = #("wwmt_source","wwmt_phys_copy","wwmt_phys_source","wwmt_target","wwmt_original_name","wwmt_proxie_source")
	
	
			for obj in selection do (
				
				
				for v in vals do (
					
					if (getUserProp obj v) != undefined do (
						setUserProp obj v ""
						
						)
					)
				
				)
			
			)
	)

)




macroscript WallWormDeleteWWMTMCR
category:"wallworm.com"
tooltip:"Delete WWMT data and WWMT Helpers."
buttontext:"Delete WWMT Helpers"
(
on execute do (
	
if selection.count > 0 do (
			
	
	
	
	
	

			
						allObj = selection as array
				   
						isInUI=false
						
						
						for obj in allObj do (
							
							if isDeleted obj == false  do (
								isSource = getUserProp obj "wwmt_source_helper"
								if isSource != undefined do (
									
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel obj tempWWMT
									
									
									  if ww_scene_lods.target !=undefined AND isInUI==false AND ww_scene_lods.target == tempWWMT.target do (
										  isInUI=true
										  
										  )
									
									    tempWWMT.deleteWWMT()
									    
									)							
							)	
						
						)
						
					if isInUI == true do (
						
						
						ww_scene_lods= ww_LOD_wrapper()
						ww_scene_lods.init()
						wwmt_activateLODMenus ww_scene_lods.lods
						disableUI()
						)
						
						
						allObj = for obj in allObj where isDeleted obj == false collect obj
						select allObj
						
						macros.Run  "wallworm.com" "WallWormClearWWMTMCR"
			
			)
	)

)






