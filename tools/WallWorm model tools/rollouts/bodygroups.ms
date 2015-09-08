rollout wallwormBodyGroups "Bodygroups" width:287 height:615
(
	local currentBodygroups = #()
	
	
	button btnSetCurrent "Set Current Bodygroup Selection" pos:[18,21] width:249 height:52 toolTip:"Set your BodyGroup dummy helpers for adding/removing WWMT helpers to."
	button btnAssignToBodygroups "Assign Selected WWMT To Current Bodygroups" pos:[19,85] width:249 height:51 toolTip:"Set the selected WWMT helpers as belonging to the currently assigned bodygroup dummies."
	button btnRemoveFromBodygroups "Remove Selected WWMT from Current Bodygroup" pos:[20,152] width:249 height:58 toolTip:"Remove the selected WWMT helpers from the currently assigned bodygroup dummies."
	button btnFlashBG "Hilight Current Bodygroup Helpers" pos:[47,250] width:180 height:56 toolTip:"Flash the current Bodygroups."
	button btnSelectBG "Select Current BG Helpers" pos:[47,320] width:182 height:50 toolTip:"Select the bodygroup dummies currently assigned to the UI."
	button btnFlashWWMT "Hilight Current BG WWMT" pos:[50,395] width:181 height:61 toolTip:"Flash the WWMT helpers that belong to the selected bodygroup dummies."
	button btnSelectWWMT "Select Current BG WWMT" pos:[49,472] width:182 height:61 toolTip:"Select all WWMT helpers that are part of the selected bodygroup dummies."
	HyperLink lnkDocs "Bodygroup Help" pos:[183,575] width:76 height:15 address:"http://dev.wallworm.com/document/72/export_body_groups__bodygroup.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) 
	
	
	groupBox grp1 "Hilight and Get" pos:[21,223] width:246 height:332
	
	on wallwormBodyGroups open do (
		global wallworm_bodygroup_CA
		if wallworm_bodygroup_CA  == undefined then (
			fileIn "$scripts\\WallWorm.com\\custom_attributes\\bodygroups.ms"	
		)
	)
	
	
	on btnSetCurrent pressed do
	(
			currentBodygroups = selection as array
	)
	on btnAssignToBodygroups pressed do
	(
			if selection.count > 0 then (
				for bg in currentBodygroups WHERE classOf bg == Dummy do (
					
					
					theBG = ww_wwmt_bodygroup()
					theBG.setHelper bg
					
					for wwmt in (selection as array) do (
						theBG.bghelper.addWWMT wwmt 
					)
					
					
				)
			) else (
				messagebox "Oops... you don't have any objects selected."
			)
			
		)
	on btnRemoveFromBodygroups pressed do
	(
			
			 if selection.count > 0 then (
				for bg in currentBodygroups WHERE classOf bg == Dummy do (
					
					
					theBG = ww_wwmt_bodygroup()
					theBG.setHelper bg
					
					for wwmt in selection do (
						
						theBG.bghelper.removeWWMT wwmt 
					)
					
					
				)
			) else (
				messagebox "Oops... you don't have any objects selected."
			)
		)
	on btnFlashBG pressed do
	(
			
			if currentBodygroups.count > 0 then (
				flashnodes currentBodygroups
				forceCompleteredraw()
			)
		)
	on btnSelectBG pressed do
	(
			
			if currentBodygroups.count > 0 then (
				select currentBodygroups
			)
		)
	on btnFlashWWMT pressed do
	(
			
			if currentBodygroups.count > 0 then (
				
					local wwmts = #()
					for bg in currentBodygroups WHERE classOf bg == Dummy do (
						
						
						bg.hilightItems()
						
						
					)
				

			)
		)
	on btnSelectWWMT pressed do
	(
			
			if currentBodygroups.count > 0 then (
				
					local wwmts = #()
					for bg in currentBodygroups WHERE classOf bg == Dummy do (
						
						
						theBG = ww_wwmt_bodygroup()
						theBG.setHelper bg
						
						join wwmts theBG.bgmodels
						
						
					)
				
				
				makeUniqueArray wwmts
				local toFlash = #()	
				for wwmt in wwmts do (
				
						appendIfUnique toFlash wwmt.target
					
				)	
				
				if toFlash.count >0 then (
					select toFlash
				)
			)
		)
)
