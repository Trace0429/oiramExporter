rollout wallworm_shape_path "Wall Worm Shape To Paths" width:342 height:325
(
	
	local proxlist
	
	
	
	dropdownList ddlEntityType "Path Type" pos:[8,11] width:117 height:40 items:#("path_track", "rope", "path_corner", "path_corner_crash") toolTip:"Choose the type of path entities to make on this path."
	button btnGeneratePaths "Generate Path Points" pos:[10,89] width:316 height:39 toolTip:"Generate a path entity at each vertex/knot of the selected splines."
	checkbox chkBindToVertex "Bind Entity to Vertex" pos:[9,61] width:123 height:14 enabled:false toolTip:"Click here to bind the path entities to the generating vertex. Not yet implemented."
	dropdownList ddl2 "Placement" pos:[138,11] width:185 height:40 items:#("Spline Knots", "Interpolated Points (More Points)")
	checkbox chkUseLookat "Use Look At Constraint" pos:[139,62] width:185 height:16 toolTip:"Use a LookAt constraint between the nodes. Can crash Max if spline is too complex so beware!"
	button btnCreateFuncTrackTrain "Create Func TrackTrain above Selected Path Tracks" pos:[9,136] width:317 height:37 tooltip:"Create func_tracktrain objects above all currently selected path_track entities and point them to the correct entity."
	button btnProxies "Set Proxies to Distribute" pos:[20,202] width:134 height:41 tooltip:"Set the collection of proxies to distribute above func_tracktrain nodes."
	dropdownList ddlDistribution "Prop Distribution" pos:[157,203] width:156 height:40 items:#("Random", "Sequential") tooltip:"Choose how to distribute the proxies. Random will use all the currently set proxies to get places randomly above each func_tracktrain. Sequentially will distribute them in the order the proxies were selected and repeats when list end reached."
	button btnPlaceProps "Distribute Props" pos:[203,260] width:111 height:37 tooltip:"Click to distribute the current Proxy Set above the currently selection of func_tracktrain objects."
	GroupBox grp1 "Prop Distribution" pos:[10,185] width:315 height:122
	
	
	
	
	
	
	checkbox chkOrientProxies "Orient Proxies to Func Train" pos:[23,261] width:157 height:18 tooltip:"Orient the proxies in the Max scene to match the orientation of the func_tracktrain objects."
	
	on wallworm_shape_path open do
	(
			global wallworm_get_entity_by_name
		
			if wallworm_get_entity_by_name == undefined then (
				wallworm_get_entity_by_name = function wallworm_get_entity_by_name type = ()
			)
			
			global wallworm_VMFIMPORT_getMaterial
			if wallworm_VMFIMPORT_getMaterial == undefined then (
				wallworm_VMFIMPORT_getMaterial = function wallworm_VMFIMPORT_getMaterial lookFor = ()
			)
	
		)
	on btnGeneratePaths pressed do
	(
	
		
		
		local newPathEnts = #()
		
		for splines in selection where (superClassOf splines == Shape) do (
			join newPathEnts (wallworm_spline_to_path splines type:ddlEntityType.selected placement:ddl2.selection useLookat:chkUseLookat.state)
	
		)
		if newPathEnts.count > 0 then (
			

			
			if  ddlEntityType.selected == "path_track"  then (
				for ent in newPathEnts WHERE ent != undefined AND ent[1] != undefined AND isProperty ent[1] "orientationtype" do (
					
					if chkUseLookat.state == true then (
						ent[1].orientationtype = "2"
					) else (
						ent[1].orientationtype = "1"
					)

					
				)
				
				if newPathEnts.count > 1 then (
					lastEnt = newPathEnts[newPathEnts.count][1]
					if isProperty  lastEnt "orientationtype" then (
						lastEnt.orientationtype = "0"	
					)
				)
				
				
			)
			
			local newEnts = (for ent in newPathEnts WHERE ent != undefined AND ent[1] != undefined collect ent[1]) as array
			if newEnts.count > 0 then (
				

				
				select newEnts
				

			)
			
			forcecompleteredraw()		
		)
	)
	on btnCreateFuncTrackTrain pressed do
	(
	
					local test = wallworm_get_entity_by_name  "func_tracktrain"
					if test != undefined AND test.ca != undefined then (
						
						newObjs = #()

						for obj in selection where isProperty obj "entName" AND obj.entName == "path_track" do (
							
							
							ent = Box height: 8 width:64 length:64 lengthsegs:1 widthsegs:1 heightsegs:1
								
							ent.transform = obj.transform
							in coordsys local ent.pos += [0,0,obj.max.z]
	
							ent.name = uniquename "TrackTrain"
							
							--convertToPoly ent
							custAttributes.add ent test.ca
							ent.parent = obj
							ent.wwmt_target = obj.targetname
							ent.orientationType = "1"
							ent.targetname = ent.name
							ent.spawnflags = 138
							append newObjs ent
							
							
							
							
						)
						if newObjs.count > 0 then (
							
							local triansStartSpeed = sliderManipulator xPos:0.785219 yPos:0.272515 
							triansStartSpeed.name = uniqueName "Train Start Speed "
							triansStartSpeed.maxVal = 16000

							triansStartSpeed.sldName = triansStartSpeed.name
							
							
							local trainSpeed = sliderManipulator xPos:0.783487 yPos:0.319298 
							trainSpeed.maxVal = 16000
							trainSpeed.name = uniqueName "Train Speed"
							trainSpeed.sldName = trainSpeed.name  
							
							logics = #()
							
							for obj in newObjs do (
								
								paramWire.connect2way obj.baseObject.WW_Entity_func_tracktrain[#startspeed] triansStartSpeed.baseObject[#value] "value" "startspeed"
								paramWire.connect2way obj.baseObject.WW_Entity_func_tracktrain[#speed] trainSpeed.baseObject[#value] "value" "speed"
								
								--append logics ("OnMapSpawn>"+obj.targetname+">TelePortToPathNode>>0.0>-1")
								append logics ("OnMapSpawn>"+obj.targetname+">StartForward>>0.0>-1")
								

							)
							
							
							trainSpeed.value = 25
							triansStartSpeed.value = 25
							
							if isProperty ent "entcolor" AND ent.entcolor != undefined AND classOf ent.entcolor == color then (
								newObjs.wireColor = ent.entcolor
							) else (
								newObjs.wireColor = (color 192 13 208)
							) 
							
							if  isProperty ent "iconsprite"  AND ent.iconsprite != undefined then (
								lookFor = substituteString ent.iconsprite ".vmt" ""
							) else (
								
								lookFor = "tools/toolsinvisible"
							)
						
							themat = wallworm_VMFIMPORT_getMaterial lookFor  openLib:true
							
							if themat == undefined then (
								themat = Standard()
								themat.name = "tools/toolsinvisible"
							)
							
							
							newObjs.mat = themat
							newObjs.mapcoords = on
							
							
							
							test = wallworm_game_settings.get_entity_by_name  "logic_auto"
							if test != undefined then (
								ent = Box height: 16 width:16 length:16
								ent.name = uniquename "Train Logic Auto"
										--convertToPoly ent
								custAttributes.add ent test.ca
								ent.outputs = logics

							)
							
							
						)
						forcecompleteredraw()		
					)
			
		)
	on btnProxies pressed do
	(
			proxlist = selection as array
			
		)
	on btnPlaceProps pressed do
	(
	
			
				if proxlist == undefined or proxlist.count == 0 then (
					
						messagebox "You need to set the objects to distribute."
				) else (
					newEnts = #()
					global wallworm_game_settings
					local test = wallworm_get_entity_by_name  "prop_dynamic"
					if test != undefined AND test.ca != undefined then (
						
						
						proxCount = proxlist.count
						local useRandom
						if ddlDistribution.selection == 1 then ( 
						
							useRandom = true
							
						) else (
							
							local startCount = 1
							
							useRandom = false
						)
						
						
						
						for obj in selection where isProperty obj "entName" AND obj.entName == "func_tracktrain" do (
							
							
							if useRandom then (
								theOriginalProx = proxlist[(random 1 proxCount)]
							) else (
	
								theOriginalProx = proxlist[startCount]
								startCount += 1
								
								if startCount > proxlist.count then (
									startCount = 1
								)
							)
							ent = copy theOriginalProx
							
							if (getUserProp theOriginalProx "wwmt_proxie_source" != undefined) then (
								
									setUserProp ent "wwmt_proxie_source" (getUserProp theOriginalProx "wwmt_proxie_source")
							)
							
	
							toprocess = wallworm_update_entities (#(ent)) test
							
							
							if toprocess.count > 0 then (
								--wallworm_remove_entities toprocess
								custAttributes.add ent test.ca
							)
	
							
							if chkOrientProxies.checked == true then (
								ent.transform = obj.transform
							) else (
								in coordsys world ent.pos = obj.pos
							)
							in coordsys local ent.pos += [0,0,obj.max.z]
	
	
							ent.parent = obj
							ent.parentname = obj.targetname
							
							
							
						)
							
					)		
					forcecompleteredraw()					
					
				)
			
	
			
		)
)
