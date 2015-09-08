rollout wallworm_proxy_tools "Wall Worm Proxy Tools" width:402 height:677
(
	
	global wallworm_proxies_lastSelection
	global wallWormDistanceHelper

	button btnCollectSkins "Collect Skins from Proxies" pos:[28,86] width:146 height:32 toolTip:"Collect materials from proxies of the selected wwmt models and add them to the model's skins."
	button btnCreateProxy "Create Proxies from WWMT" pos:[13,10] width:172 height:51 toolTip:"Create a proxy of the selected WWMT models for re-use in the scene."
	button btn5 "Exclude" pos:[206,103] width:75 height:35 toolTip:"Click this to exclude the selected WWMT models from the VMF Exporter. Only the model's proxies will be exported."
	button btn6 "Include" pos:[289,103] width:72 height:35 toolTip:"Include the root WWMT as well as its proxies in the VMF export."
	GroupBox grp1 "WWMT VMF Export Tags" pos:[192,76] width:181 height:73
	dropdownList ddl_propType "Set Prop Types of Selected Models" pos:[195,10] width:179 height:40 items:#("prop_static", "prop_detail", "prop_physics", "prop_physics_multiplayer", "prop_dynamic", "prop_door_rotating", "prop_ragdoll", "prop_dynamic_ornament", "prop_dynamic_override", "prop_physics_override") toolTip:"Set the selected WWMT helpers to the following prop type. Will propagate to the helper's proxies. Or assign prop type to individual proxies."
	HyperLink proxyhelp "Help and Tips" pos:[287,644] width:100 height:15 address:"http://dev.wallworm.com/topic/56/wwmt_proxy_tools.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	button btnGetWWMT "Get WWMT of Selected Proxies" pos:[18,160] width:176 height:40 toolTip:"Get/Select the WWMT helper(s) of the selected Proxies. After clicking, Click Z to zoom the viewport to display the helpers."
	button btnGetProxies "Get Proxies of Selected WWMT" pos:[206,159] width:168 height:41 toolTip:"Get/Select all the Proxies of the selected WWMT helper. After clicking, Click Z to zoom the viewport to display the proxies."
	button btnRandomizeSkins "Randomize Proxy Skins" pos:[28,123] width:146 height:20 toolTip:"Randomize the skins of the proxies based off of the current Skins MultiMaterial."
	button btnModelMaxDist "Get Distance Helper" pos:[37,438] width:157 height:27 toolTip:"Get the Max Distance Helper"
	button btnUnas "Remove Max Distance" pos:[214,609] width:173 height:28 toolTip:"Unassign max-distance for selected models."
	button btnAssignDist "Set Max Distance From Helper" pos:[37,513] width:158 height:34 toolTip:"Assign the Max Distance for the selected items based on the distance of the models and the Distance Helper"
	button btnRemoveStartFade "Remove Start Fade" pos:[33,609] width:171 height:28 toolTip:"Unassign start fade distance for selected models."
	button btnAssignStartFade "Set Start Fade From Helper" pos:[37,470] width:158 height:37 toolTip:"Assign the start fade Distance for the selected items based on the distance of the models and the Distance Helper"
	button btn85 "Select Used Props" pos:[295,524] width:92 height:29 toolTip:"Set the current selection to the stored prop list you last assigned fade distances to or that you manually assigned to the prop list."
	button btnSetStartFadeFromViewport "Set Start Fade From Viewport" pos:[222,441] width:158 height:31 toolTip:"Set the Start Fade Distance for the selected props based off of the distance of the prop to the viewport camera."
	button btnSetMaxFadeFromViewport "Set Max Distance from Viewport" pos:[222,479] width:158 height:32 toolTip:"Set the Max Fade Distance for the selected props based off of the distance of the prop to the viewport camera."
	button btnSetPropsList "Set Used Props" pos:[211,524] width:81 height:29 toolTip:"Set the current selection to the prop list for later recall by using the Select Used Props button."
	GroupBox grp2 "Fade by Helper Distance" pos:[31,418] width:170 height:136
	GroupBox grp3 "Fade by Viewport Distance" pos:[212,418] width:175 height:100
	GroupBox grp4 "Skin Functions" pos:[15,67] width:170 height:82
	GroupBox grp5 "Prop Fade Functions" pos:[19,398] width:374 height:200			
			
			
	button BoxModeOn "Box Mode On" pos:[25,362] width:78 height:19 toolTip:"Turn Box Mode on for selected wwmt and proxies to increase viewport performance. If none selected, use all in scene."
	button btnBoxModeOff "Box Mode Off" pos:[108,362] width:78 height:19 toolTip:"Turn Box Mode off for selected wwmt and proxies to see their meshes. If none selected, use all in scene."
	button btn51 "Backface Cull On" pos:[194,362] width:91 height:19 toolTip:"Turn On Backface Cull (do not display 2-sided material) for selected wwmt and proxies to increase viewport performance. If none selected, use all in scene."
	button btn52 "Backface Cull Off" pos:[289,362] width:94 height:19 toolTip:"Turn Off Backface Cull (display 2-sided material) for selected wwmt and proxies. If none selected, use all in scene."
	GroupBox grp21 "Viewport Performance" pos:[18,341] width:370 height:52	
	

	spinner spnStartFade "Start Fade" pos:[47,568] width:95 height:16 range:[-1,64000,-1]
	spinner spnMaxFade "Max Fade" pos:[218,568] width:118 height:16 range:[-1,64000,-1] type:#float
	button btnSetStartFadeFromSpinner "Set" pos:[148,569] width:27 height:16 toolTip:"Set selected models and proxies to start fade at this distance."
	button btnSetMaxFadeFromSpinner "Set" pos:[344,569] width:32 height:16 toolTip:"Set selected models and proxies to end fade at this distance."

	button btnUpdateProxies "Update Selected Proxy Meshes" pos:[19,310] width:356 height:23 toolTip:"Run this function on selected proxies if you have updated the WWMT model. Be careful if you had other binds to this node."
	combobox cbxSelWWMT "Select WWMT in Scene" pos:[19,208] width:265 height:5
	button btnRefesh "Refresh" pos:[292,207] width:81 height:40 tooltip:"Refresh the list of WWMT Helpers in the list to the left."
	button btnMakeProx "Make Prox" pos:[293,254] width:81 height:51 toolTip:"Create and a proxy from the selected WWMT Helper to the left."	
	
	

		function setwallworm_proxies_lastSelection = (
			global wallworm_proxies_lastSelection
			wallworm_proxies_lastSelection = selection as array
		)
		function getwallworm_proxies_lastSelection = (
			global wallworm_proxies_lastSelection
			select wallworm_proxies_lastSelection
			
			)
			
		function getRandomMaterialFromMultiMat multimat alreadyListed:#{} returnMat:true= (
			
			local theMat 
			
			if classOf multimat != MultiMaterial then 
			(
				if returnMat == true then (
					theMat = multimat
				) else (
					theMat = 1
				)
			) else (
				
				
				newID = random 1 multimat.numsubs
				
				
				if multimat.materialList[newId] != undefined then (
						if returnMat == true then (
							theMat = multimat.materialList[newId]
						) else (
							theMat = newId
						)
				) else (
						alreadyListed[newId] = true
							
						if alreadyListed.numberSet == multimat.numsubs then (
							
							
						) else (
							
							theMat =  getRandomMaterialFromMultiMat multimat returnMat:returnMat
						)
				)
				
				
			)
			
			
			
			
			
				theMat
			)	

		fn compareFN v1 v2 =

		(



		case of

		(

		( v1.modelname < v2.modelname ) : -1

		( v1.modelname > v2.modelname ) : 1

		default: 0

		)

		)

					
	function getWWMTCollection refresh:false= (
		global wallworm_wwmt_collection
		
		
		
		if refresh == true OR wallworm_wwmt_collection == undefined then (
			wallworm_wwmt_collection = wallworm_get_all_objects()
			join wallworm_wwmt_collection (objects as array)
			
			wallworm_wwmt_collection = for wwmt in wallworm_wwmt_collection where isProperty wwmt "wwmt_ca" == true    collect wwmt
				
			for wwmt in wallworm_wwmt_collection where wwmt.Wallworm_Model_Tools.version < 12  do (
				
				wwmt.getWWMT refresh:true
				--wallworm_update_wwmt_cas wwmt
			)
			
			qsort wallworm_wwmt_collection compareFN
			
		)
		cbxSelWWMT.items = for wwmt in wallworm_wwmt_collection WHERE isValidNode wwmt == true collect wwmt.modelname
		wallworm_wwmt_collection
	)
			
	function getWallWormMaxDistanceHelper = (
		
		global wallWormDistanceHelper
	  if wallWormDistanceHelper == undefined OR isDeleted wallWormDistanceHelper == true then (
		  local findHelper = getNodeByName "wallWormDistanceHelper"
		  if findHelper != undefined then (
		   wallWormDistanceHelper = findeHelper
		  )
		)
		if wallWormDistanceHelper == undefined OR isDeleted wallWormDistanceHelper == true then (
			
			wallWormDistanceHelper = Point pos:[0,0,0] isSelected:off Calculate:off
			wallWormDistanceHelper.name = "wallWormDistanceHelper"
			wallWormDistanceHelper.size = 256	
			wallWormDistanceHelper.axistripod = off
			wallWormDistanceHelper.cross = on
			wallWormDistanceHelper.Box = off
			
		)
		return wallWormDistanceHelper
	)		
	

	
	on wallworm_proxy_tools open do
	(
			getWWMTCollection()
		)
	on btnCollectSkins pressed do
	(
	
		
					if selection.count == 0 then (
					
					messagebox "This function only works when you have selected a set of WWMT helpers."
					
					) else (
						   oldsel = selection as array
						    local wwmts = 0
						    clearSelection()
							for obj in oldsel do (
								
								isWWMTSource = getUserProp obj "wwmt_source_helper"	
								 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
											local tempWWMT = ww_LOD_wrapper()
											tempWWMT.init()					
											tempWWMT.setTargetModel obj tempWWMT
	
											tempWWMT.gatherMySkins()
	
											wwmts+=1
									
									
								)
							
							)
							
							
							
							select oldsel
							
							if wwmts == 0 then (
								
								messagebox "No WWMT helpers were selected; no skins were collected."
								
								) else (
								
								messagebox ((wwmts as string)+ " models were updated.")
								
								)
							
						)
		
	)
	on btnCreateProxy pressed do
	(
		macros.run "wallworm.com" "WallWormModelToolsCreateProxyiesMCR"
	)
	on btn5 pressed do
	(
	  macros.run "wallworm.com" "WallWormVMFExcludeWWMT"
	
	)
	on btn6 pressed do
	(
	  macros.run "wallworm.com" "WallWormVMFIncludeWWMT"
	
	)
	on ddl_propType selected sel do
	(
	
		if selection.count > 0 then (
			wallworm_set_props_type ddl_propType.selected sel:selection reselect:true
		) else (
			messagebox "You need to select some Proxies or WWMT Helpers for this function to work."
			)
	
	)
	on btnGetWWMT pressed do
	(
			
			validproxies = for proxy in selection WHERE getUserProp proxy "wwmt_proxie_source" != undefined collect proxy
			if validproxies != undefined AND validproxies.count > 0 then (
				clearselection()
				
				for prox in validproxies do (
					
					wwmtsrc = getNodeByName (getUserProp prox "wwmt_proxie_source")
					if wwmtsrc != undefined AND isDeleted wwmtsrc == false then (
						selectMore wwmtsrc
						)
					
					)
				
				
				)
			
			
			)
	on btnGetProxies pressed do
	(
	
						
					    oldsel = selection as array
					    local wwmts = 0
					    clearSelection()
						for obj in oldsel WHERE isDeleted obj == false AND (getUserProp obj "wwmt_source_helper") != undefined  do (
							
	
	
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel obj tempWWMT
										newProxies = tempWWMT.getProxies()
							
										if newProxies != undefined AND newProxies.count > 0 then (
											
											selectMore newProxies
											
											
										)
	
	
						
						)
						
						setwallworm_proxies_lastSelection()
						
	
						
					)
	on btnRandomizeSkins pressed do
	(
			
							oldsel = selection as array
						    local wwmts = 0
						    clearSelection()
							for obj in oldsel do (
								
								isWWMTSource = getUserProp obj "wwmt_source_helper"	
								 if isDeleted obj == false AND isWWMTSource != undefined AND isWWMTSource==true do (
											local tempWWMT = ww_LOD_wrapper()
											tempWWMT.init()					
											tempWWMT.setTargetModel obj tempWWMT
											newProxies = tempWWMT.getProxies()
											if newProxies != undefined AND newProxies.count > 0 then (
												for prox in newProxies do (
													if isProperty prox "skin" then (
														prox.skin = (getRandomMaterialFromMultiMat obj.mat returnMat:false) - 1
													) else (
													--format "Proxy % now has material: %\n" prox prox.mat
														prox.mat = getRandomMaterialFromMultiMat obj.mat returnMat:true
													--format "Proxy % now has material: %\n" prox prox.mat
													)
												)
											)
		
								)
							
							)
			
							select oldsel
			)
	on btnModelMaxDist pressed do
	(
	
		select (getWallWormMaxDistanceHelper())
	
	)
	on btnUnas pressed do
	(
		
		
		
			if selection.count > 0 then (
				setwallworm_proxies_lastSelection()
				
				local sel = selection as array
				mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source_helper") != undefined OR (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
				
				if mdls != undefined AND mdls.count > 0 then (
						
					wallWormDistanceHelper =	getWallWormMaxDistanceHelper()
					for mdl in mdls do (
						--local theDistance = ceil ( distance wallWormDistanceHelper mdl)
						
						
	
						
						if isProperty mdl "fademaxdist" then (
							mdl.fademaxdist = -1
						)
						
						
						
						if (getUserProp mdl "wwmt_source") == undefined then (
							/*This is a WWMT Helper or a WWMT Proxie*/
	
							setUserProp mdl "wwmt_max_distance" "-1"
						) else (
								/*This is a refnode of a WWMT helper*/
								local wwmtSource =getNodeByName (getUserProp mdl "wwmt_source") 
								if wwmtSource != undefined then (
									setUserProp wwmtSource "wwmt_max_distance" "-1"
									if isProperty wwmtSource "fademaxdist" then (
										wwmtSource.fademaxdist = -1
									)
									
									
								)
	
						)
					)
				)
				select sel
			)
			
		
		)
	on btnAssignDist pressed do
	(
			
			
			if selection.count > 0 then (
				setwallworm_proxies_lastSelection()
				
				local sel = selection as array
				mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source_helper") != undefined OR (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
				
				if mdls != undefined AND mdls.count > 0 then (
						
					wallWormDistanceHelper =	getWallWormMaxDistanceHelper()
					for mdl in mdls do (
						--local theDistance = ceil ( distance wallWormDistanceHelper mdl)
						
						local theDistance = ceil ( distance wallWormDistanceHelper mdl)
						if isProperty mdl "fademaxdist" then (
							mdl.fademaxdist = theDistance
						)
						
						
						
						if (getUserProp mdl "wwmt_proxie_source") != undefined then (
							/*This is a Proxie*/
							
							setUserProp mdl "wwmt_max_distance" (theDistance as string)
						) else (
							
							if getUserProp mdl "wwmt_source" != undefined then (
								/*This is a refnode of a WWMT helper*/
								--print "refnode"
								local theDistance = ceil ( distance wallWormDistanceHelper mdl)
								local wwmtSource =getNodeByName (getUserProp mdl "wwmt_source") 
								if wwmtSource != undefined then (
									setUserProp wwmtSource "wwmt_max_distance" (theDistance as string)
									if isProperty wwmtSource "fademaxdist" then (
										wwmtSource.fademaxdist = theDistance
									)
									
									
								)
								
								
								) else (
								/*This is a WWMT helper*/
									--print "wwmt helper startfade"
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel mdl tempWWMT
								
								
									local theDistance = ceil ( distance wallWormDistanceHelper tempWWMT.targets[1])
	
									setUserProp mdl "wwmt_max_distance" (theDistance as string)
									if isProperty mdl "fademaxdist" then (
										mdl.fademaxdist = theDistance
									)
								
							)
							
	
						)
					)
				)
				
				
				
				select sel
				
			)
			
			
			
			)
	on btnRemoveStartFade pressed do
	(
		
			if selection.count > 0 then (
				setwallworm_proxies_lastSelection()
				
				local sel = selection as array
				mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source_helper") != undefined OR (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
				
				if mdls != undefined AND mdls.count > 0 then (
						
					wallWormDistanceHelper =	getWallWormMaxDistanceHelper()
					for mdl in mdls do (
						--local theDistance = ceil ( distance wallWormDistanceHelper mdl)
						
						
						if isProperty mdl "fademindist" then (
							mdl.fademindist = -1
						)
						
						if (getUserProp mdl "wwmt_source") == undefined then (
							/*This is a WWMT Helper or a WWMT Proxie*/
	
							setUserProp mdl "wwmt_start_fade" "-1"
						) else (
								/*This is a refnode of a WWMT helper*/
								local wwmtSource =getNodeByName (getUserProp mdl "wwmt_source") 
								if wwmtSource != undefined then (
									setUserProp wwmtSource "wwmt_start_fade" "-1"
									if isProperty wwmtSource "fademindist" then (
										wwmtSource.fademindist = -1
									)
								)
	
						)
					)
				)
				select sel
			)
		
		)
	on btnAssignStartFade pressed do
	(
			
			if selection.count > 0 then (
				setwallworm_proxies_lastSelection()
				
				local sel = selection as array
				mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source_helper") != undefined OR (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
				
				if mdls != undefined AND mdls.count > 0 then (
						
					wallWormDistanceHelper =	getWallWormMaxDistanceHelper()
					for mdl in mdls do (
						--local theDistance = ceil ( distance wallWormDistanceHelper mdl)
						
						
						local theDistance = ceil ( distance wallWormDistanceHelper mdl)
						if isProperty mdl "fademindist" then (
							mdl.fademindist = theDistance
						)
						if (getUserProp mdl "wwmt_proxie_source") != undefined then (
							/*This is a Proxie*/
							
							setUserProp mdl "wwmt_start_fade" (theDistance as string)
						) else (
							
							if getUserProp mdl "wwmt_source" != undefined then (
								/*This is a refnode of a WWMT helper*/
								--print "refnode"
								local theDistance = ceil ( distance wallWormDistanceHelper mdl)
								local wwmtSource =getNodeByName (getUserProp mdl "wwmt_source") 
								if wwmtSource != undefined then (
									setUserProp wwmtSource "wwmt_start_fade" (theDistance as string)
									
									if isProperty wwmtSource "fademindist" then (
										wwmtSource.fademindist = theDistance
									)
								)
								
								
								) else (
								/*This is a WWMT helper*/
									--print "wwmt helper startfade"
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel mdl tempWWMT
								
								
									local theDistance = ceil ( distance wallWormDistanceHelper tempWWMT.targets[1])
	
									setUserProp mdl "wwmt_start_fade" (theDistance as string)
									if isProperty mdl "fademindist" then (
										mdl.fademindist = theDistance
									)
								
							)
							
	
						)
					)
				)
				
				
				
				select sel
				
			)
			
			
			
		)
	on btn85 pressed do
	(
	getwallworm_proxies_lastSelection()
	)
	on btnSetStartFadeFromViewport pressed do
	(
		
		if selection.count > 0 then (
			setwallworm_proxies_lastSelection()
			
			local sel = selection as array
			mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source_helper") != undefined OR  (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
			
			if mdls != undefined AND mdls.count > 0 then (
					
	
				for mdl in mdls do (
					
					local measureAgainst = (getViewTM()).row4
					
					
						
						
						
						
						if (getUserProp mdl "wwmt_proxie_source") != undefined then (
							/*This is a Proxie*/
							local theDistance = ceil ( distance measureAgainst mdl.pos)
							setUserProp mdl "wwmt_start_fade" (theDistance as string)
							if isProperty mdl "fademindist" then (
								mdl.fademindist = theDistance
							)
							
						) else (
							
							if getUserProp mdl "wwmt_source" != undefined then (
								/*This is a refnode of a WWMT helper*/
	
								local theDistance = ceil ( distance measureAgainst mdl.pos)
								local wwmtSource =getNodeByName (getUserProp mdl "wwmt_source") 
								if wwmtSource != undefined then (
									setUserProp wwmtSource "wwmt_start_fade" (theDistance as string)
									if isProperty wwmtSource "fademindist" then (
										wwmtSource.fademindist = theDistance
									)
								)
								
								
								) else (
								/*This is a WWMT helper*/
									
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel mdl tempWWMT
								
								
			
									local theDistance = ceil ( distance measureAgainst tempWWMT.targets[1].pos)
									setUserProp mdl "wwmt_start_fade" (theDistance as string)
									if isProperty mdl "fademindist" then (
										mdl.fademindist = theDistance
									)
								
							)
							
	
						)
	
	
	
	
	
	
	/*						
					if (getUserProp mdl "wwmt_source") == undefined then (
						setUserProp mdl "wwmt_start_fade" (theDistance as string)
					) else (
						local wwmtSource =getNodeByName (getUserProp mdl "wwmt_source") 
						if wwmtSource != undefined then (
							setUserProp wwmtSource "wwmt_start_fade" (theDistance as string)
						)
					)
					
					*/
					
					
				)
			)
			
			
			
			
			
			)
		
		
		
	
	
	)
	on btnSetMaxFadeFromViewport pressed do
	(
		if selection.count > 0 then (
			setwallworm_proxies_lastSelection()
			
			local sel = selection as array
			mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source_helper") != undefined OR  (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
			
			if mdls != undefined AND mdls.count > 0 then (
					
	
				for mdl in mdls do (
					
					local measureAgainst = (getViewTM()).row4
					
					
						
						
						
						
						if (getUserProp mdl "wwmt_proxie_source") != undefined then (
							/*This is a Proxie*/
							local theDistance = ceil ( distance measureAgainst mdl.pos)
							setUserProp mdl "wwmt_max_distance" (theDistance as string)
							if isProperty mdl "fademaxdist" then (
								mdl.fademaxdist = theDistance
							)
							
						) else (
							
							if getUserProp mdl "wwmt_source" != undefined then (
								/*This is a refnode of a WWMT helper*/
								print "refnode"
								local theDistance = ceil ( distance measureAgainst mdl.pos)
								local wwmtSource =getNodeByName (getUserProp mdl "wwmt_source") 
								if wwmtSource != undefined then (
									setUserProp wwmtSource "wwmt_max_distance" (theDistance as string)
									if isProperty wwmtSource "fademaxdist" then (
										wwmtSource.fademaxdist = theDistance
									)
								)
								
								
								) else (
								/*This is a WWMT helper*/
									print "wwmt helper startfade"
										local tempWWMT = ww_LOD_wrapper()
										tempWWMT.init()					
										tempWWMT.setTargetModel mdl tempWWMT
								
								
			
									local theDistance = ceil ( distance measureAgainst tempWWMT.targets[1].pos)
									setUserProp mdl "wwmt_max_distance" (theDistance as string)
									if isProperty mdl "fademaxdist" then (
										mdl.fademaxdist = theDistance
									)
								
							)
							
	
						)
					
				)
			)
			
			
			
			
			
			)
	)
	on btnSetPropsList pressed do
	(
	setwallworm_proxies_lastSelection()
	)
	on BoxModeOn pressed do
	(
		
			local sel 
			if selection.count > 0 then (
				sel = selection as array 
			) else (
				 sel = objects
			)
	
			mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
			if mdls != undefined AND mdls.count > 0 then (
				mdls.boxmode = on
			)
			mdls = undefined
			 
		)
	on btnBoxModeOff pressed do
	(
		local sel 
		if selection.count > 0 then (
			sel = selection as array 
		) else (
			 sel = objects
		)
	
		mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
		if mdls != undefined AND mdls.count > 0 then (
			mdls.boxmode = off
		)
		mdls = undefined
	)
	on btn51 pressed do
	(
		local sel 
		if selection.count > 0 then (
			sel = selection as array 
		) else (
			 sel = objects
		)
	
		mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
		if mdls != undefined AND mdls.count > 0 then (
			mdls.backfacecull = on
		)
		mdls = undefined
		
		
		
	)
	on btn52 pressed do
	(
		local sel 
		if selection.count > 0 then (
			sel = selection as array 
		) else (
			 sel = objects
		)
	
		mdls = for wwmt in sel WHERE (getUserProp wwmt "wwmt_source") != undefined OR  (getUserProp wwmt "wwmt_proxie_source") != undefined  collect wwmt
		if mdls != undefined AND mdls.count > 0 then (
			mdls.backfacecull = off
		)
		mdls = undefined
		
	
	)
	on btnSetStartFadeFromSpinner pressed do
	(
				theDistance = spnStartFade.value
				for mdl in selection do (
					setUserProp mdl "wwmt_start_fade" (theDistance as string)
					
					if isProperty mdl "fademindist" then (
						mdl.fademindist = theDistance
					)
				)
		)
	on btnSetMaxFadeFromSpinner pressed do
	(
				theDistance = spnMaxFade.value
				for mdl in selection do (
					setUserProp mdl "wwmt_max_distance" (theDistance as string)
					if isProperty mdl "fademaxdist" then (
						mdl.fademaxdist = theDistance
					)
				)
		)
	on btnUpdateProxies pressed do
	(
	
	wallworm_update_proxies (selection)
	)
	on cbxSelWWMT selected sel do
	(
		global wallworm_wwmt_collection
		if wallworm_wwmt_collection == undefined then (
			getWWMTCollection()
	
		)
		if wallworm_wwmt_collection.count > 0 AND cbxSelWWMT.selection != 0   AND isValidNode wallworm_wwmt_collection[cbxSelWWMT.selection] then (
			
			flashNodes (#(wallworm_wwmt_collection[cbxSelWWMT.selection]))
			forceCompleteredraw() 
			
		)
		
	)
	on cbxSelWWMT rightClick do
	(
		global wallworm_wwmt_collection
		if wallworm_wwmt_collection == undefined then (
			getWWMTCollection()
	
		)
		if wallworm_wwmt_collection.count > 0 AND cbxSelWWMT.selection > 0 AND isValidNode wallworm_wwmt_collection[cbxSelWWMT.selection] then (
			
			select wallworm_wwmt_collection[cbxSelWWMT.selection]
		)
		
	)
	on btnRefesh pressed do
	(
			getWWMTCollection refresh:true
			global wallworm_wwmt_collection
			cbxSelWWMT.items = for wwmt in wallworm_wwmt_collection collect wwmt.modelname
			
	)
	on btnMakeProx pressed do
	(
			global wallworm_wwmt_collection
			if wallworm_wwmt_collection == undefined then (
				getWWMTCollection()
		
			)
			if wallworm_wwmt_collection.count > 0 AND cbxSelWWMT.selection > 0 then (
				wwmt = wallworm_wwmt_collection[cbxSelWWMT.selection]
	
				wwmstruct = wwmt.getWWMT()
				if wwmstruct != undefined then (
	
					newProx = wwmstruct.createProxy()
					if newProx != undefined then (
						select newProx
					)
				)
	
			)
		)
)
