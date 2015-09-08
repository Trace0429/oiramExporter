rollout wallwormSMDExport "Wall Worm SMD/VTA Export" width:235 height:505
(
	
	local originNode
	local smdFileName
	
	radiobuttons rdoType "Type" pos:[13,12] width:100 height:62 labels:#("Reference SMD", "Sequence SMD", "VTA")
	spinner spnStart "Start" pos:[32,293] width:72 height:16 range:[0,999999,0] type:#integer scale:1 toolTip:"Set the beggining frame for a sequence or VTA. For reference, set the reference frame."
	spinner spnEnd "End" pos:[128,294] width:72 height:16 range:[0,999999,100] type:#integer scale:1 toolTip:"Set the end frame for sequence and VTA exports."
	checkbox chkMeshAsBone "Export Non-Renderable Mesh as Bone" pos:[13,253] width:205 height:18 toolTip:"Force the exporter to skip the vertices of objects that are non-renderable--and only use the pivot point as a bone. Needed for some bone systems like CAT rigs."
	spinner spnUVW "UVW Channel" pos:[123,357] width:91 height:16 range:[-1,100,1] type:#integer scale:1 toolTip:"Select the UVW channel used in this model. 0 and -1 are auto-detect values. Default comes form global WW settings."
	button btnExport "Export" pos:[11,402] width:201 height:29
	HyperLink WormLink "Wall Worm" pos:[12,441] width:96 height:15 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com"
	HyperLink DonateLink "Donate" pos:[112,441] width:96 height:15 color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255) address:"http://dev.wallworm.com/topic/42/donate.html"
	checkbox chkStatic "Static Prop" pos:[129,17] width:94 height:16 checked:false toolTip:"Tell the exporter that this object has no moving parts."
	checkbox chkFirst "Local Origin as World Origin" pos:[18,101] width:203 height:15 toolTip:"When set, the exporter uses the pivot point of the origin node (or first object in the selection if no node designated) as the working reference point for creating node and vertex positions."
	pickbutton btnOriginNode "Pick Origin Node" pos:[18,179] width:200 height:25
	button btnclear "Clear Origin" pos:[18,208] width:68 height:18 toolTip:"Clear the Origin Node."
	button btnGetOrigin "Get Origin" pos:[88,208] width:59 height:18 toolTip:"Click here to select the origin node in the scene."
	button btnHilightOrigin "Hilight Origin" pos:[152,208] width:66 height:18
	GroupBox grp1 "Origin Offset" pos:[8,81] width:218 height:160
	checkbox chkRefCurrentTime "Ref from Current Time" pos:[86,334] width:130 height:17 toolTip:"When checked, reference models are generated from the state of the model at the current frame in the timeline. Otherwise at the start-frame designated in the range."
	radiobuttons rdoSMDExportSelections "Export" pos:[13,330] width:67 height:62 labels:#("Auto", "Scene", "Selection") columns:1
	GroupBox grp13 "Range" pos:[10,274] width:215 height:48
	label lblVersion "SMD Exporter" pos:[13,464] width:196 height:19
	checkbox chkLockOrigin "Lock Origin State" pos:[18,158] width:107 height:18 toolTip:"Check this option if the root node is animated in its own space. Only useful for Sequence SMDs where the root node is animated in World Space."
	dropdownList ddlNormals "Normals" pos:[115,42] width:109 height:40 items:#("Face Render Normals", "Explicit Normals","Auto") selection:3
	checkbox chkRotate "Rotate World" pos:[18,120] width:88 height:17 toolTip:"Rotate the output by 90 degrees. Useful for making props use [0 0 0] alignment in Hammer's prop seittings straight from the SMD."
	checkbox chkFlip "Flip" pos:[18,138] width:151 height:19 toolTip:"Flip the SMD by 180 degrees. If Rotate is also used, the model is rotated 270 degrees."
	checkbox chkVis "Only Visible Objects" pos:[88,379] width:125 height:14 toolTip:"Only include those objects that are visible in the scene when this option is checked."
	
	function returnCurrentOriginNode = (
		if originNode != undefined AND isDeleted originNode == false then (
		
			return originNode

		
		) else (
			
			if selection.count > 0 then (
				
				return selection[1]
				
				) else (
					if objects.count > 0 then (
						return objects[1]
						
						)
					
					)
			
			
			)
			undefined
	)
	
	function returnNodeList = (
		
		local choose = undefined
		
			case rdoSMDExportSelections.state of (
				1:(if selection.count > 0 then (choose = selection) else (if objects.count > 0 then (choose = objects)))
				2:( if objects.count > 0 then (choose = objects))
				3:(if selection.count > 0 then (choose = selection) )
			)
			
			if choose != undefined AND choose.count > 0 then (
				
				
				
				if chkVis.checked then ( 
						choose = for obj in choose where obj.visibility == true AND (getUserProp obj "wwmt_hitbox" == undefined AND getUserProp obj "wwmt_is_attachment" == undefined AND getUserProp obj "wwmt_source_helper" == undefined AND getUserProp obj "wwmt_LOD_Gizmo" == undefined AND getUserProp obj "wwmt_LOD_target" == undefined) collect obj
			
					) else (
						choose = for obj in choose where (getUserProp obj "wwmt_hitbox" == undefined AND getUserProp obj "wwmt_is_attachment" == undefined AND getUserProp obj "wwmt_source_helper" == undefined AND getUserProp obj "wwmt_LOD_Gizmo" == undefined AND getUserProp obj "wwmt_LOD_target" == undefined) collect obj
			
					)
	
				)
			
			return choose
		)
	
	
	on wallwormSMDExport open do
	(
			local smd = wallwormSMD()
			lblVersion.text = ("SMD Exporter Version "+ smd.exporterVersion as string)
			smd = undefined
		
			spnUVW.value = wwmt_mappingChannel
	
	
	
	
			)
/*	on spnStart changed val do
	(
	
	if spnStart.value >= spnEnd.value then (
	 spnEnd.value = spnStart.value + 1
	)
	
	)
	on spnEnd changed val do
	(
	
	if spnEnd.value <= spnStart.value then (
	 spnStart.value = spnEnd.value - 1
	)
	
	)*/
	on btnExport pressed do
	(
		
		
							local smd = 	wallwormSMD()
							smd.type = case rdoType.state of (
								1:("Reference")
								2:("Sequence")
								3:("VTA")
								default:("Reference")
								)
		
							/*
								Consider allowing the Start spinner to set the reference time.
								At the moment, Reference always uses frame 0.
								To update, need to re-write logic in SMD Export class.
								*/
							if smd.type != "Reference" then (
								smd.range = #()
								for r = spnStart.value to spnEnd.value do (
									append smd.range r
								)	
								
							)	else (
								
								if chkRefCurrentTime.checked == true then (
								
									smd.range = #((currentTime as integer)/TicksPerFrame)
								) else (
									
									smd.range = #(spnStart.value)
									
								)
							)
								
							local filetype = "SMD(*.smd)|*.smd"
							local exportCaption = "Export SMD"
							if smd.type == "VTA" then (
								filetype = "VTA(*.vta)|*.vta"
								exportCaption = "Export VTA"
								) else ()
							
							
							smd.uvwchannel = spnUVW.value
							local desel = false	
								
							smd.nonRenderableAsBone=chkMeshAsBone.checked
							smd.staticprop = chkStatic.checked	
							smd.origin = chkFirst.checked
							smd.internalOrigin	 = chkFirst.checked
							smd.rotateRefsystem = chkRotate.checked	
							smd.flip = chkFlip.checked
							smd.lockInitialOrigin = chkLockOrigin.checked
							smd.normalMethod = ddlNormals.selection
							if selection.count > 0 then (	
	
							if chkFirst.checked == true then (
								
								if originNode != undefined AND isDeleted originNode == false then ( 
									smd.refNode = originNode
									
									) else ( 
									
									smd.refNode = selection[1]
									)
								
								
								)	
							--smd.makeNodeList selection
	
							) else (
								if chkFirst.checked == true then (
									
									
									if originNode != undefined AND isDeleted originNode == false then ( 
										smd.refNode = originNode
									
									) else ( 
										smd.refNode = objects[1]
									)
								)	
								
								--smd.makeNodeList objects
								desel = true	
							)
	
							nodes = returnNodeList()
							if nodes != undefined AND nodes.count>0 then (
								
								smd.makeNodeList nodes
								try (
									if smdFileName == undefined then (
										fname = wwmt_def_model_path+"\\"+(getFilenameFile maxFileName)+".smd"
									) else (
										
										fname = smdFileName 
										)
									local filename = getSaveFileName filename:fname caption:exportCaption types:filetype historyCategory:"Wall Worm SMD Exporter"
	
									) catch (
									
									local filename = getSaveFileName caption:exportCaption types:filetype historyCategory:"Wall Worm SMD Exporter"
	
									)
								
								if filename != undefined then (
									smdFileName = filename
									smd.exportSMD filename
									
									if smd.errors.count == 0 then (
										messagebox "File saved."
										
										)else()
									
								) else (
									messagebox "The export was cancelled."
									)
								smd = undefined
									if desel == true then (
										max select none
									) else ()	
								
								) else (
									
									messagebox "There were no objects to export."
									)
							
							
							--smd.refNode = targets[1]
		
	
		
		)
	on btnOriginNode picked obj do
	(
	originNode = obj
	
	)
	on btnclear pressed do
	(
	
	originNode = undefined
	
	)
	on btnGetOrigin pressed do
	(
	
		orig = returnCurrentOriginNode()
		if orig != undefined then (
			select orig
			)
	
	)
	on btnHilightOrigin pressed do
	(
		
		orig = returnCurrentOriginNode()
		if orig != undefined then (
			flashNodes (#(orig))
			forceCompleteredraw()
			)
	)
)
