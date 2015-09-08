
global wallwormraymesh
include "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"
include "$scripts/WallWorm.com/common/settings_struct.ms"
filein "$scripts\\WallWorm.com\\common\\mse\\fgd2.mse"
include "$scripts\\WallWorm.com\\common\\matgenfuncs.ms"
--include "$scripts/WallWorm.com/importers/Mario_Kart_SMD_Importer.ms"

global wallworm_game_settings
if wallworm_game_settings != undefined AND wallworm_game_settings.ents != undefined AND wallworm_game_settings.ents.count > 0 then (

	) else (
	
	macros.run "wallworm.com" "wallwormParseFGD2"
	
)

if wallworm_game_settings != undefined AND wallworm_game_settings.ents != undefined AND wallworm_game_settings.ents.count > 0 then (


	
	
	

	
try (destroyDialog pointEntititesUI) catch ()

rollout pointEntititesUI "Point Entities" width:356 height:420
(

	local rootParam

	
	combobox entslist "Available Entities" pos:[12,6] width:184 height:16
	button btnConvEntity "Selection As Point Entity" pos:[213,132] width:125 height:48 toolTip:"Assign the selected object(s) as point entities. Usefull for assigning entity properties to Proxies, etc. Also updates current entities to selected entity class."
	button btnPlaceEntity "Place Entities" pos:[201,49] width:146 height:49 toolTip:"Start Dropping Entities. Right Click to stop."
		
	button btnMoveToWorld "Detach Entity" pos:[214,187] width:124 height:39 toolTip:"Remove the entity data from selected object."
		
	GroupBox grp1 "More Functions" pos:[202,111] width:145 height:125
	checkbox pointOrigin "Picked Point Origin" pos:[201,29] width:143 height:15 toolTip:"If on, the picked point is the origin of your entity. If off... the picked point is the bottom of the entity (and the origin is 8 units above)."

	button btnSelectEntTypes "Select All of Type in Scene" pos:[162,269] width:168 height:29
	--subRollout attribs "Entity Attributes" pos:[10,324] width:330 height:168
	checkbox chkExcludeWWMT "Exclude WWMT Helpers" pos:[15,267] width:138 height:15
	checkbox chkExcludeWWMTProxies "Exclude WWMT Proxies" pos:[15,287] width:141 height:18
	GroupBox grp3 "Selection Tools" pos:[9,244] width:338 height:70
	
	button btnCopy "Copy Entity" pos:[218,334] width:123 height:21 toolTip:"Set the currently selected entity as the copy-from entity for the Paste function."
	button btnPaste "Paste Entity" pos:[218,358] width:123 height:37 tooltip:"Paste the current properties."
	GroupBox grpCopy "Copy/Paste Properties" pos:[8,321] width:339 height:86
	checkbox chkProperties "Properties" pos:[17,343] width:82 height:15 tooltip:"When pasting an entity onto others, paste all of the properties."
	checkbox chkOutputs "Outputs" pos:[17,362] width:64 height:15 tooltip:"When pasting an entity onto others, paste all of the outputs. When Append to Current is set, the outputs are appended to the target's current output list (if any). Otherwise, the existing outputs are over-written."
	checkbox chkSpawnflags "Spawn Flags" pos:[17,381] width:84 height:15 tooltip:"Paste the spawnflags (over-writing any existing values)."
	checkbox chkAppendOutputs "Append to Current" pos:[93,362] width:114 height:16 tooltip:"When on, the outputs are appended to the target's current output list (if any). Otherwise, the existing outputs are over-written."
	
	function shouldCheckForUnique = (findItem (#("sky_camera","light_environment","env_fog_controller","shadow_control")) entslist.selected != 0)
	
	function testExisting = (
			local existing = undefined
			local uniqueproblem = false
			if (shouldCheckForUnique()) then (
				existing = (for obj in objects where isProperty obj "wallworm" AND isProperty obj "entityType" AND isProperty obj "entname" AND obj.entname == entslist.selected  collect obj)
				if existing.count > 0 then (
					
					uniqueproblem = true
				)
			)
			uniqueproblem
	)
	
	
	function bind_light_params ent = (
		ent._light =ent.color
	)
	
	
	function pickAnotherPoint = (
		local ent
		max create mode
		p = pickPoint snap:#3D prompt:"\nPlace entities at the picked points.\n"
		if classOf p == Point3 then (
			
				if pointOrigin.checked == false then (
					
						p = p + [0,0,8]
				)
			
				--try (
				
				
				
				
				
				
					if testExisting() == false then (
				
				
				
				
				
				
				
					test = wallworm_game_settings.get_entity_by_name  entslist.selected
			


					if test != undefined AND test.ca != undefined then (
						local ent
						
						case (entslist.selected) of  (
						
						"light":(
							ent = Omnilight()
						)	
						"light_spot":(
							ent = FreeSpot()
						)
						"light_dynamic":(
							ent = FreeSpot()
						)
						
						"light_spot":(
							ent = FreeSpot()
						)
						"light_environment":(
							ent = Directionallight()
							ent.overshoot = true
						)
						"light_directional":(
							ent = Directionallight()
							ent.overshoot = true
						)
						default:(
							
								ent = Box height: 16 width:16 length:16
								ent.pivot = ent.center
							)
						)
						
						ent.pos = p
					
					

					
						
						
						ent.name = uniquename test.name
				
				 
						--convertToPoly ent
						custAttributes.add ent test.ca
						
						
						if isProperty ent "targetName" == true then (
							ent.targetName = ent.name
						)
						
						/*
						Maybe add model importing....
						
						if  isProperty ent "studio"  AND ent.studio != undefined then (
						
						
							lookFor = substituteString ent.studio ".mdl" ""
							append lookFor ".qc"
							print lookFor
							replacementEnt = (wallworm_import_smd lookFor rotateModel:false) 

							--ent.setUserPropBuffer ent ""
							
							
						)
					
						
						*/
						
						if superclassof ent != light then (
						
							if isProperty ent "entcolor" AND ent.entcolor != undefined AND classOf ent.entcolor == color then (
								ent.wireColor = ent.entcolor
							) else (
								ent.wireColor = (color 192 13 208)
							) 
							
							if   isProperty ent "iconsprite"  AND ent.iconsprite != undefined then (
								lookFor = substituteString ent.iconsprite ".vmt" ""
								themat = wallworm_VMFIMPORT_getMaterial lookFor  color:ent.wireColor openLib:true
								ent.mat = themat
								
								ent.mapcoords = on
							)
						
						
						

						) else (
							if isProperty ent "color" AND isProperty ent "_light"  then (
								
								ent._light = ent.color
							)
						)

						
						
						
						
						
					) else (
						
						messagebox "Oops... this entity was not found in the Entity Cache. You may need to reparse the FGD in the WW Settings."
						
					)
					
					
					
					--) catch (
							--messagebox "Oops... there was an error. Click F11 for more info."
							--print (getCurrentException())
					--)
					pickAnotherPoint()
					
					
				) else (
					
					messagebox "Oops... this entity is only allowed to exist once in the scene."
					
					
					select ((for obj in objects where isProperty obj "wallworm" AND isProperty obj "entityType" AND isProperty obj "entname" AND obj.entname == entslist.selected collect obj))
				)
			)




			if ent != undefined then (
					select ent
				
					max modify mode
			)
	 
	 
	)
	
	
	
	
		

		
		


/*
	function clearRootParam = (
		if rootParam != undefined then (
			removeSubRollout attribs rootParam
		)
		
		wallworm_remove_entity rootNode
	)
	
	on pointEntititesUI close do
	(
		clearRootParam()
	)
	*/


	
	function addEntProps theSelection entName= (
		
		max create mode
		
		theSelection = for obj in theSelection WHERE isProperty obj "ww_displacement_brush" == false AND  isProperty obj "ww_displacement" == false AND isProperty obj "wallworm_edit_mesh" == false collect obj
		
		
		if theSelection.count > 0 then (
			
		
			
		
			if (shouldCheckForUnique()) == true AND (theSelection.count > 1 OR testExisting() == true) then (
				
				messagebox "This entity should only be added once to the scene. You cannot apply it to multiple objects."
				
			) else (
				
	
		
				test = wallworm_game_settings.get_entity_by_name entName  
			
				
			
				if test != undefined AND test.ca != undefined then (
					
					toprocess = wallworm_update_entities theSelection test
					
					
					if toprocess.count > 0 then (
						--wallworm_remove_entities toprocess
						custAttributes.add toprocess test.ca
					)
					
					for obj in (theSelection as array) do (
						
						
						if isProperty obj "model" then (
						
							local wwmtname = getUserProp obj "wwmt_proxie_source"
							if wwmtname != undefined then (
								wwmtnode = getNodeByName wwmtname
								
								
								
								if isProperty wwmtnode "modelName" then (
									obj.model = (wallworm_remove_last_slash (wwmtnode.modelPath)) + "/"+ wwmtnode.modelName+".mdl"
								)
								
								
							)
						)
						
						
						if superclassof obj == light then (
							if isProperty obj "brightness" then (
								
								--$
							)
						)
					
						legacyDats = getUserProp obj "GLBPntData"
						legacyValus = getUserProp obj "GLBPntValu"
						legacyFlags = getUserProp obj "GLBFlags"
						
						if legacyDats != undefined AND legacyDats != "" AND legacyValus != undefined AND legacyValus != "" then (
							
							props = filterString legacyDats "," splitEmptyTokens:true
							vals = filterString legacyValus "," splitEmptyTokens:true
							
							if props.count == vals.count then (
								
								for i = 2 to props.count do (
								
									if vals[i] != undefined AND vals[i] != "" AND vals[i] != ";" then (
										
											if isProperty obj props[i] == true then (
												try (
													setProperty obj props[i] (vals[i] as (classof (getProperty obj props[i] )))
												) catch ()
											)
									)
									
								)
								
								
							)
							
							
							
						)
							
	
							
						if legacyFlags != undefined AND legacyFlags != "" AND isProperty obj "spawnflags" == true AND ((legacyFlags as integer) != undefined) then (

								setProperty obj "spawnflags" (legacyFlags as integer)
	
						)
							
						
						
						
						
						
						
							
							if legacyDats != undefined then (
								setUserProp obj "GLBPntData" ""
							)

							if legacyValus != undefined then (
								setUserProp obj "GLBPntValu" ""
							)
							if legacyFlags != undefined then (
								setUserProp obj "GLBFlags" ""
							)
	
							if isProperty obj "entcolor" AND obj.entcolor != undefined AND classOf obj.entcolor == color then (
								obj.wireColor = obj.entcolor
							) else (
								
							) 
							
							if obj.mat == undefined AND  isProperty obj "iconsprite"  AND obj.iconsprite != undefined then (
								lookFor = substituteString obj.iconsprite ".vmt" ""
								themat = wallworm_VMFIMPORT_getMaterial lookFor  color:obj.wireColor openLib:true
								obj.mat = themat
								if isProperty obj "mapcoords" == true then (
									obj.mapcoords = on
								)
							)
							
							if superclassof obj == light then (
								if classof obj == Directionallight then (

									obj.overshoot = true
								)
								
								if isProperty obj "color" AND isProperty obj "_light"  then (
									
									obj._light = obj.color
								)
								
							)
							
							local legacyDist = getUserProp obj "wwmt_max_distance"
							if legacyDist != undefined AND legacyDist != "" AND legacyDist as float != undefined AND isProperty obj "fademaxdist" then (
								
									obj.fademaxdist = legacyDist as float
									setUserProp obj "wwmt_max_distance" undefined
							) 
							
							
							local legacyStartDist = getUserProp obj "wwmt_start_fade"
							if legacyStartDist != undefined AND legacyStartDist != "" AND legacyStartDist as float != undefined AND isProperty obj "fademindist" then (
								
									obj.fademaxdist = legacyStartDist as float
									setUserProp obj "wwmt_start_fade" undefined
							) 
							

							
							
						)
					
					
					) else (
						
						messagebox "Oops... this entity was not found in the Entity Cache. You may need to reparse the FGD in the WW Settings."
						
						
						
					)
				)
			
				if selection.count == 1 then (
					max modify mode	
				)

			
			
			) else (
				
				messagebox "Oops... you need to select some objects to us this function."
				
			)
		
	)
	
		

	on pointEntititesUI open do
	(
		global wallworm_game_settings
		pointents = wallworm_game_settings.getAllPointEntities()
		entslist.items = sort ( for ent in pointents WHERE ent != undefined collect ent.name)
		
		global wallworm_userIni
		last = getINISetting wallworm_userIni "Menus" "anvil_last_point_entity"
		entslist.selection = findItem entslist.items last
		
		
		
		entity_paste_props = getINISetting wallworm_userIni "Menus" "entity_paste_props"
		entity_paste_outputs = getINISetting wallworm_userIni "Menus" "entity_paste_outputs"
		entity_paste_spawnflags = getINISetting wallworm_userIni "Menus" "entity_paste_spawnflags"
		entity_paste_outputs_append = getINISetting wallworm_userIni "Menus" "entity_paste_outputs_append"
		if entity_paste_props == "" OR entity_paste_props == "true" then (
			chkProperties.checked = true
		)
		if entity_paste_outputs == "true" then (
			chkOutputs.checked = true
		)
		if entity_paste_spawnflags == "true" then (
			chkSpawnflags.checked = true
		)		
		
		if entity_paste_outputs_append == "" OR entity_paste_outputs_append == "true" then (
			chkAppendOutputs.checked = true
		)


		
	)
	on entslist selected sel do
	(
			
			/*change global last ent*/
			
			/*
			test = wallworm_game_settings.get_entity_by_name  entslist.selected
	
	
	
			if test != undefined AND test.ca != undefined then (
				
				
				clearRootParam()
	
				
				custAttributes.add rootNode test.ca
			
	
			
				rootParam = rootNode.custattributes[rootNode.custattributes.count].params
			
			--addRollout rootNode.custattributes[rootNode.custattributes.count].params
			
				addSubRollout attribs rootParam
				
			)		
	
					
				*/	 
	
							
			
			/*
				open rollouts with values to send to selected objs
			*/
			if entslist.selected != undefined AND entslist.selected != "" then (
				global wallworm_userIni
				setINISetting wallworm_userIni "Menus" "anvil_last_point_entity" (entslist.selected as string)
			)
	)
	on btnConvEntity pressed do
	(
	
		theSelection = selection as array
		addEntProps theSelection entslist.selected
	
	)
	on btnPlaceEntity pressed do
	(
		pickAnotherPoint()
	)
	on btnMoveToWorld pressed do
	(
			
			if selection.count > 0 then (
				wallworm_remove_entities selection
			) else (
					messagebox "Oops... no objects were selected."
			)
		)
	on btnSelectEntTypes pressed do
	(
			
			local entname = entslist.selected
			if entname != undefined AND entname != "" then (
				local ents = for obj in objects where isProperty obj "entname" AND obj.entname == entname AND ((NOT chkExcludeWWMT.checked ) OR  ( chkExcludeWWMT.checked  AND NOT  isProperty obj "wwmt_ca")) AND ((NOT chkExcludeWWMTProxies.checked)  OR   (chkExcludeWWMTProxies.checked AND getuserprop obj "wwmt_proxie_source" == undefined)) collect obj
				if ents.count > 0 then (
					select ents
				)
			)
		)
	on btnCopy pressed do
	(
			global wallworm_copy_entity
			
			if selection.count == 1 AND isProperty selection[1] "entName" then (
				wallworm_copy_entity = selection[1]
			) else (
				messagebox "This function only works when you have a single entity object selected."
			)
	 		
		)
	on btnPaste pressed do
	(
			global wallworm_copy_entity
			if isValidNode wallworm_copy_entity AND isProperty wallworm_copy_entity "entName" then (
				if selection.count > 0  then (
	
	
					theSelection = selection as array
					addEntProps theSelection wallworm_copy_entity.entName
					
					if chkProperties.checked then (
						if isProperty wallworm_copy_entity "exportProps" AND wallworm_copy_entity.exportProps != undefined then (
							for p in wallworm_copy_entity.exportProps do (
								v = getProperty wallworm_copy_entity p
								if v != undefined then (
									
									objs = for obj in theSelection where isProperty obj p collect obj
									if objs.count > 0 then (
										for obj in objs do (
											setProperty obj p v
										)
									)
								)
							)
					
						)
					)
					
					
					if chkOutputs.checked then (
						if isProperty wallworm_copy_entity "outputs" AND wallworm_copy_entity.outputs != undefined  then (
								objs = for obj in theSelection where isProperty obj "outputs" collect obj
								local copiedouts= wallworm_copy_entity.outputs as array
								
								if chkAppendOutputs.checked then (
									if objs.count > 0 then (
										for obj in objs do (
											ar1 = obj.outputs as array
											join ar1 copiedouts
											obj.outputs = ar1
										)
									)
								) else (
									objs.outputs = copiedouts
								)
						)
					)
					
					if chkSpawnflags.checked then (
						if isProperty wallworm_copy_entity "spawnflags" AND wallworm_copy_entity.spawnflags != undefined then (
								objs = for obj in theSelection where isProperty obj "spawnflags" collect obj
								objs.spawnflags = wallworm_copy_entity.spawnflags
						)
					)
				) else (
					messagebox "This function only works when you have a single entity object selected."
				)
				
	 		) else (
				messagebox "You must first copy an entity properties from the scene."
			)
		)
	on chkProperties changed stat do
	(
			global wallworm_userIni
			setINISetting wallworm_userIni "Menus" "entity_paste_props" (stat as string)
		)
	on chkOutputs changed stat do
	(
			global wallworm_userIni
			setINISetting wallworm_userIni "Menus" "entity_paste_outputs" (stat as string)
		)
	on chkSpawnflags changed stat do
	(
			global wallworm_userIni
			setINISetting wallworm_userIni "Menus" "entity_paste_spawnflags" (stat as string)
	)
	
	on chkAppendOutputs changed stat do
	(
			global wallworm_userIni
			setINISetting wallworm_userIni "Menus" "entity_paste_outputs_append" (stat as string)
	)
	
	
)
	
		
	createDialog pointEntititesUI
		


		
) else (
	messagebox "There is no FGD file. Please set one in the settings!"
	macros.run "wallworm.com" "WallWormModelToolsConfigMCR"
)
