rollout wwmt_bone_options "Bone Options" width:237 height:659
(
	
	local startSurf = undefined
	local startBias = undefined
	local animatedfriction = undefined
	local startjointskip  = undefined
	local currentBone = undefined
	
	local wwmt_jointmassbias = undefined
	local wwmt_surfaceprop_bone = undefined
	local wwmt_animatedfriction = undefined
	local wwmt_jointskip = undefined
	
	local hitboxHelper = undefined
	local hboxsets = #("default")
function wallworm_remove_zero_bones sk = (
	
	
	local numBones = skinOps.GetNumberBones sk
	
	local numVerts = skinOps.GetNumberVertices sk
	
	local getBID = skinOps.GetVertexWeightBoneID
	
	
	for b = 1 to numBones do (
			local hasWeight = false
			for i = 1 to numVerts while hasWeight == false  do (
				
				if getBID sk i b > 0 then (
					
					hasWeight = true
				)
			)
			if NOT hasWeight then (
			skinOps.removebone sk b 
			)
		
	)
	
)
	combobox cbxBoneSurfaceProp "Bone Surface Properties" pos:[17,49] width:203 height:7
	spinner spn_mass_bias "Mass Bias" pos:[25,185] width:114 height:16 range:[0,100,1] type:#float
	button btnGetBoneInfo "Get From Selected Bone" pos:[17,11] width:203 height:32 toolTip:"Get the surface property and mass bias of the selected bone."
	button btnSetBoneInfo "Set All Values on Selection" pos:[15,241] width:139 height:32 toolTip:"Set both the surfaceproperty and the mass bias in all selected bones to the values above."
	button btnSetBias "Set" pos:[143,186] width:37 height:16 toolTip:"Set the Mass Bias of the selected bones to that value of the Mass Bias Spinner."
	button btnUnsetBias "Unset" pos:[183,186] width:36 height:16 toolTip:"Remove mass bias from selected nodes."
	button btnSetSurf "Set" pos:[147,50] width:31 height:13 toolTip:"Set the surfaceprop for the selected bones."
	button btnUnsetSurf "Unset" pos:[185,50] width:34 height:13 toolTip:"Unset the surfaceprop for the selected bones."
	HyperLink bonehelp "Help" pos:[200,624] width:36 height:15 address:"http://dev.wallworm.com/document/120/hitboxes_and_bone_properties.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	/*label lbl1 "$animatedfriction" pos:[16,228] width:91 height:19
	edittext edt_animatedfriction "" pos:[11,246] width:134 height:22
	button btn_animatedfriction "Set" pos:[148,246] width:33 height:21
	button btn_unset_animatedfriction "Unset" pos:[183,246] width:35 height:21*/
	checkbox chk_jointskip "$jointskip" pos:[15,215] width:69 height:18
	button btnSetSkip "Set" pos:[90,215] width:39 height:15
	button btn_jointskip_off "Unset" pos:[138,215] width:38 height:15

	
	
		
	
	function setInitialValues forceReset:false= (
		if startSurf == undefined OR forceReset==true then (
			startSurf = wwmt_surfaceprop_bone
		)		
		if startBias == undefined OR forceReset==true then (
			startBias = wwmt_jointmassbias
		)	
	/*	if animatedfriction == undefined OR forceReset==true then (
			animatedfriction = wwmt_animatedfriction
		)	*/
		if startjointskip == undefined OR forceReset==true then (
			startjointskip = wwmt_jointskip
		)	
		
	)
	
	
	function setUiFromBoneInfo = (
			if selection.count == 1 then (
				local binfo = wwmt_getBoneInfo selection[1]
				wwmt_surfaceprop_bone = binfo[2]
				wwmt_jointmassbias = binfo[1]
				--wwmt_animatedfriction = binfo[3]
				wwmt_jointskip = binfo[3]
				if currentBone != selection[1] then (
					currentBone = selection[1]
					setInitialValues()
				)
			)
			

			if wwmt_surfaceprop_bone != undefined then (
				
				
				if findItem cbxBoneSurfaceProp.items wwmt_surfaceprop_bone == 0 then (
					
					local newlist = cbxBoneSurfaceProp.items
					append newlist wwmt_surfaceprop_bone
					try (
					cbxBoneSurfaceProp.items = newlist
					) catch (
						cbxBoneSurfaceProp.items = wwmt_surfaceprop_list
					)
				)
				
				try (
				cbxBoneSurfaceProp.selection = findItem cbxBoneSurfaceProp.items (wwmt_surfaceprop_bone as string)
				) catch ()
				
				
				
			)
		
			if wwmt_jointmassbias != undefined then (
				
				
				
				spn_mass_bias.value = (wwmt_jointmassbias as float)
				
				
			)
			
			
			/*
			if wwmt_animatedfriction != undefined then (
				edt_animatedfriction.text = wwmt_animatedfriction
			)
*/
			
			if wwmt_jointskip != undefined AND (wwmt_jointskip == true OR wwmt_jointskip == "true") then (
				chk_jointskip.checked = true
			) else (
				
				chk_jointskip.checked = false	
			)
			
			
			
			
			
		)
	
	
		
fn reconstructBones root parent =
 (
	 
	/* function from johnLauf
	 at http://forums.cgsociety.org/archive/index.php/t-795590.html
	 */
 if (classof root) == BoneGeometry then
 (
 b = BoneSys.createBone root.transform.row4 (root.pos+root.transform.row1*root.length) [0,0,1]
 b.parent = parent
 )
 else
 (
 b = point()
 b.transform = root.transform
 b.parent = parent
 )
 b.wirecolor = yellow
 for c in root.children do (reconstructBones c b)
 )
		
	

	
	button btnGetHitbox "Get Hitboxes" pos:[24,305] width:72 height:33 toolTip:"Select all existing hitboxes for the selected bone."
	button btnCreateHB "Create Hitboxes" pos:[107,305] width:103 height:33 toolTip:"Create a hitbox for all the selected object."
	combobox cbxHboxSet "Hboxset" pos:[25,347] width:134 height:4 items:#("default")
	button btnUpdateHboxList "Update" pos:[165,367] width:47 height:22 toolTip:"Update the HBoxset list from the bone's hitboxes."
	button btnSetHboxset "Set" pos:[165,396] width:47 height:24 toolTip:"Set the selected Hitboxes to the HBoxset to the left."
		
			
	GroupBox grp1 "Hitbox Functions" pos:[11,281] width:213 height:185
	spinner spnHitboxGroup "Hitbox Group" pos:[56,437] width:77 height:16 range:[0,100,0] type:#integer scale:1
	button btnSetHBGroup "Set" pos:[142,437] width:31 height:17 toolTip:"Set the Hitbox Group for the selected Hitboxes."
	button btnUnsetHBGroup "Unset" pos:[179,437] width:36 height:18 toolTip:"Remove the collision group for selected hitboxes (will return to 0)."
	button btnMakeBones "Make Node Bones" pos:[12,538] width:212 height:31
		
	
	button btnAssign "Assign" pos:[18,488] width:61 height:32
	button btnRemove "Remove" pos:[84,488] width:59 height:32
	button btnOrigin "Root" pos:[148,488] width:75 height:34 toolTip:"Make the selected bone the ROOT/$origin node of the current WWMT object."
	
		
		
		
		
	button btnSkinEach "Skin on Each Object Selected" pos:[11,577] width:214 height:36 toolTip:"Add a separate skin modifier to each object in the selection."

		
	button btn_hierarchy "Hierarchy" pos:[158,242] width:62 height:32

	
	

	/*on btn_animatedfriction pressed do
	(
		if selection.count > 0 then (
			for obj in selection do (
				wwmt_setAnimatedfriction obj vals:edt_animatedfriction.text
			)
			pushPrompt "Bone $animatedfriction set for selection."
		) else (
			messagebox "No objects are selected! Select some bones first."
		)
	)
	on btn_unset_animatedfriction pressed do
	(
		if selection.count > 0 then (
			for obj in selection do (
				setUserProp obj "wwmt_animatedfriction" ""
			)
			pushPrompt "Bone $animatedfriction removed for selection."
		) else (
			messagebox "No objects are selected! Select some bones first."
		)
	)*/

	on wwmt_bone_options open do
	(
		global wwmt_surfaceprop_list
		cbxBoneSurfaceProp.items = wwmt_surfaceprop_list
	
		if selection.count == 1 then (
			
				setUiFromBoneInfo()
				hbs = wwmt_get_hitboxes()
				hboxset = wwmt_get_hitboxsets hboxsets objs:hbs
				cbxHboxSet.items = hboxsets
		)
	
	)
	on btnGetBoneInfo pressed do
	(
			if selection.count == 1 then (
				setUiFromBoneInfo()
			) else (
				messagebox "You must select one individual bone to set the value."
			)
	
	)
	on btnSetBoneInfo pressed do
	(
			if selection.count > 0 then (
				for obj in selection do (
					wwmt_setBoneMassBias obj amount:spn_mass_bias.value
					wwmt_setBoneSurfaceprop obj prop:cbxBoneSurfaceProp.selected
		wwmt_setJointSkip obj vals:chk_jointskip.checked
		--wwmt_setAnimatedfriction obj vals:edt_animatedfriction.text
				)
				pushPrompt "Bone Surfaceprop and Mass Bias set for selection."
			) else (
				messagebox "No objects are selected! Select some bones first."
			)
			
	)
	on btnSetBias pressed do
	(
		if selection.count > 0 then (
			for obj in selection do (
				wwmt_setBoneMassBias obj amount:spn_mass_bias.value
			)
			pushPrompt "Bone Mass Bias set for selection."
		) else (
			messagebox "No objects are selected! Select some bones first."
		)
	)
	on btnUnsetBias pressed do
	(
			if selection.count > 0 then (
					for obj in selection do (
						wwmt_setBoneMassBias obj amount:1.0
					)
					pushPrompt "Bone Mass Bias reset to 1.0 for selection."
				) else (
					messagebox "No objects are selected! Select some bones first."
				)
		)
	on btnSetSurf pressed do
	(
			
			if selection.count > 0 then (
				for obj in selection do (
					wwmt_setBoneSurfaceprop obj prop:cbxBoneSurfaceProp.selected
				)
				pushPrompt "Bone Surfaceprop set for selection."
			) else (
				messagebox "No objects are selected! Select some bones first."
			)
			
			
		)
	on btnUnsetSurf pressed do
	(
	
			if selection.count > 0 then (
				for obj in selection do (
					wwmt_setBoneSurfaceprop obj prop:""
				)
				pushPrompt "Bone Surfaceprop cleared for selection."
			) else (
				messagebox "No objects are selected! Select some bones first."
			)
	
	
	)
	on btnSetSkip pressed do
	(
		if selection.count > 0 then (
			for obj in selection do (
				wwmt_setJointSkip obj vals:chk_jointskip.checked
			)
			pushPrompt "Joint Skip set for selection."
		) else (
			messagebox "No objects are selected! Select some bones first."
		)
	)
	on btn_jointskip_off pressed do
	(
		if selection.count > 0 then (
			for obj in selection do (
				wwmt_setJointSkip obj vals:false
			)
			pushPrompt "Joint Skip set for selection."
		) else (
			messagebox "No objects are selected! Select some bones first."
		)
	)
	on btnGetHitbox pressed do
	(
			if selection.count > 0 then (
	
				hbs = wwmt_get_hitboxes()
				hboxset = wwmt_get_hitboxsets hboxset objs:hbs
				
				cbxHboxSet.items = hboxsets
				if hbs != undefined AND hbs.count > 0 then (
					select hbs
					unhide hbs
				)
			) else (
				
				
				
				messagebox "This function only works when you have objects selected. "
			)
			
			
			)
	on btnCreateHB pressed do
	(
			
			if selection.count > 0 then (
					local hbs = #()
				
				for obj in selection do (
					local newhb = wwmt_createBoneHitbox obj
					if newhb != undefined then (
						appendIfUnique hbs newhb	
					)
				)
					
					clearSelection()
					
					if hbs.count > 0 then (
						select hbs
					)
						
						
			) else (
	
					messagebox "This function only works when you have objects selected. "
			)
			
			
		)
	on btnUpdateHboxList pressed do
	(
		oldsel = selection
		hbs = wwmt_get_hitboxes()
		
		wwmt_get_hitboxsets hboxsets objs:hbs
		cbxHboxSet.items = hboxsets
		if oldsel.count > 0 then (
			select oldsel
			)
	)
	on btnSetHboxset pressed do
	(
				
				if selection.count > 0 then (
					
					
					if cbxHboxSet.text != undefined AND cbxHboxSet.text != "" then (
						
						
						if findItem cbxHboxSet.items cbxHboxSet.text == 0 then (
							startItem = cbxHboxSet.text
							newitems = cbxHboxSet.items
							appendIfUnique newitems cbxHboxSet.text
							sort newitems
							cbxHboxSet.items = newitems
							
							cbxHboxSet.selection = (findItem cbxHboxSet.items startItem)
							
							)
						
						wwmt_setHboxSets selection val:cbxHboxSet.selected
						
						
					) else (
						
						messagebox "There is no hboxset selected."
					)
					
					
					
					
				)
				
				
			)
	on btnSetHBGroup pressed do
	(
			
			
			if selection.count > 0 then (
				
				for hb in selection WHERE (getUserProp hb "wwmt_hitbox" != undefined AND (getUserProp hb "wwmt_hitbox" == "true" OR getUserProp hb "wwmt_hitbox"==true)) do (
					
					
					wwmt_setHitboxGroup hb grp:spnHitboxGroup.value
					
				)
				
				
				) else (
				
				messagebox "This function requires you to select hitboxes"
				
				)
			
			
			
			)
	on btnUnsetHBGroup pressed do
	(
			
			
			if selection.count > 0 then (
				
				for hb in selection WHERE (getUserProp hb "wwmt_hitbox" != undefined AND (getUserProp hb "wwmt_hitbox" == "true" OR getUserProp hb "wwmt_hitbox"==true)) do (
					
					
					wwmt_setHitboxGroup hb grp:0
					
				)
				
				
				) else (
				
				messagebox "This function requires you to select hitboxes"
				
				)
			
			
			
			)
	on btnMakeBones pressed do
	(
			/*
			objArray = selection as array
			bnArray = #()
			
			for obj in objArray do (
				--local bn = snapshot obj
				
				
				local bn = BoneSys.createBone obj.pos <point3>endPos <point3>zAxis
				
				bn.name = (uniqueName (obj.name + "Bone"))
				bn.renderable = off
				bn.mat = undefined
				bn.boneEnable=true
				bn.transform = obj.transform
					
				append bnArray bn
				
				
			)
			
	
			
			for i=1 to objArray.count do (
	
				obj = objArray[i]
				if obj.parent != undefined then (
					
						theParentIndex = findItem objArray obj.parent
						if theParentIndex != 0 then (
								bnArray[i].parent = bnArray[theParentIndex]
							
						)
					
					
				)
				
			)
			
	
			
			
			for i=1 to objArray.count do (
						local ls = bnArray[i].controller = Link_Constraint()
						ls.addTarget  objArray[i] 1
	
			)
			
			
			*/
			
			
			for obj in selection where obj.parent == undefined do (
				reconstructBones obj undefined
				
				)
			
			
		)
	on btnAssign pressed do
	(
			global ww_scene_lods
			if ww_scene_lods != undefined AND classOf ww_scene_lods == ww_LOD_wrapper AND ww_scene_lods.target != undefined then (
				if selection.count > 0 then (
							ww_scene_lods.addToBones selection
				) else (
					messagebox "You need to select bones or nodes first."
				)
				
				
			) else (
					messagebox "You need to assign a model in the WWMT UI before this function can work."
			)
			
		)
	on btnRemove pressed do
	(
			global ww_scene_lods
			if ww_scene_lods != undefined AND classOf ww_scene_lods == ww_LOD_wrapper AND ww_scene_lods.target != undefined then (
				if selection.count > 0 then (
							ww_scene_lods.removeFromBones selection
				) else (
					messagebox "You need to select bones or nodes first."
				)
				
				
			) else (
					messagebox "You need to assign a model in the WWMT UI before this function can work."
			)
			
		)
	on btnOrigin pressed do
	(
			global ww_scene_lods
			if ww_scene_lods != undefined AND classOf ww_scene_lods == ww_LOD_wrapper AND ww_scene_lods.target != undefined then (
				if selection.count == 1 then (
					
					if (ww_scene_lods.addObjToObjects $) then (
						ww_scene_lods.targets[ww_scene_lods.targets.count] = ww_scene_lods.targets[1]
						ww_scene_lods.targets[1] = $
						ww_scene_lods.setTargetCust()

						ww_scene_lods.target.targets = ww_scene_lods.targets as array
						--ww_scene_lods.addToBones selection
						
						--print ww_scene_lods.target.targets 
					)
					
					
				) else (
					messagebox "You need to select bones or nodes first."
				)
				
				
			) else (
					messagebox "You need to assign a model in the WWMT UI before this function can work."
			)
			
		)
	on btnSkinEach pressed do
	(
			objs = for obj in selection where validModifier obj Skin == true AND obj.modifiers[#Skin] == undefined collect obj
	
	
				
			if objs.count > 0 then (
				
				for obj in objs do (
					addModifier obj (Skin())
				)
			)
			
		)
	on btn_hierarchy pressed do
	(
	
	setCommandPanelTaskMode mode:#hierarchy
	cui.commandPanelOpen = true
	
	)
)
