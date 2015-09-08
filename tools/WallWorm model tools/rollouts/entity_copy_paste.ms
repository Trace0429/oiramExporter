rollout wallworm_entity_copy_rollout "Copy Entity Properties" width:358 height:101
(
	button btnCopy "Copy Entity" pos:[217,20] width:123 height:21 toolTip:"Set the currently selected entity as the copy-from entity for the Paste function."
	button btnPaste "Paste Entity" pos:[217,44] width:123 height:37 toolTip:"Paste the current properties."
	GroupBox grpCopy "Copy/Paste Properties" pos:[7,7] width:339 height:86
	checkbox chkProperties "Properties" pos:[16,29] width:82 height:15 toolTip:"When pasting an entity onto others, paste all of the properties."
	checkbox chkOutputs "Outputs" pos:[16,48] width:64 height:15 toolTip:"When pasting an entity onto others, paste all of the outputs. When Append to Current is set, the outputs are appended to the target's current output list (if any). Otherwise, the existing outputs are over-written."
	checkbox chkSpawnflags "Spawn Flags" pos:[16,67] width:84 height:15 toolTip:"Paste the spawnflags (over-writing any existing values)."
	checkbox chkAppendOutputs "Append to Current" pos:[92,48] width:114 height:16 toolTip:"When on, the outputs are appended to the target's current output list (if any). Otherwise, the existing outputs are over-written."

	on wallworm_entity_copy_rollout open do
	(
		
			global wallworm_userIni

			
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
	
					global wallworm_addEntProps
					theSelection = selection as array
					wallworm_addEntProps theSelection wallworm_copy_entity.entName
					
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
