
--Functions for the Wall Worm Model Tools

global elementsArray = #()

function checkMaterial obj = (
	print obj.material
	if obj.material == undefined then (
				
				messageBox "The model has no material. Please add a standard material with a Bitmap in the diffuse slot."
				return false
				) else (
		
		--add check for diffuse bitmaps
		return true
		
		)
	
	)

function ww_makeCollisionModel SourceOBJ = (
	
	
	elementsArray = #()
	disableSceneRedraw()
	
	
	convertTo SourceOBJ Editable_Poly
	try(
		max create mode


		if (classof SourceOBJ  == editable_poly) then (ww_DetachPolyElements_fn SourceOBJ)			-- operates only on those objects that are editable polys
		

				
		--hull = EditablePoly()
		hull = elementsArray[1]
	
		if(elementsArray.count > 1) then (
		--Only attach items if there are multiple subobjects
	
			for ee in 2 to elementsArray.count do (
			--iterate through the elementsArray and attach them to hull
			hull.attach elementsArray[ee] ww_scene_lods.target
			--hull.attach elementsArray[ee] ww_scene_lods.target
			)
		)
		
		--name the hull
		hull.name = ww_scene_lods.target.name+"_hull"
		
		ww_scene_lods.phys = hull;
		ww_scene_lods.processPhys()
			
		
		

			
-- 			--wire the PRS of the phys hull to the master object
-- 					paramWire.connect ww_scene_lods.target.pos.controller[#X_Position] ww_scene_lods.phys.pos.controller[#X_Position] "X_Position"
-- 					paramWire.connect ww_scene_lods.target.pos.controller[#Y_Position] ww_scene_lods.phys.pos.controller[#Y_Position] "Y_Position"
-- 					paramWire.connect ww_scene_lods.target.pos.controller[#Z_Position] ww_scene_lods.phys.pos.controller[#Z_Position] "Z_Position"
-- 					paramWire.connect2way ww_scene_lods.target.rotation.controller[#X_Rotation] ww_scene_lods.phys.rotation.controller[#X_Rotation] "X_Rotation" "X_Rotation"
-- 					paramWire.connect2way ww_scene_lods.target.rotation.controller[#Y_Rotation] ww_scene_lods.phys.rotation.controller[#Y_Rotation] "Y_Rotation" "Y_Rotation"
-- 					paramWire.connect2way ww_scene_lods.target.rotation.controller[#Z_Rotation] ww_scene_lods.phys.rotation.controller[#Z_Rotation] "Z_Rotation" "Z_Rotation"
-- 			
		
		max views redraw			
		
			


	
		) catch(
			messagebox "There was a problem making the Collision Mesh. The most likely reason is that you do not have the nVidia PhysX plugin."
			)
			
		enableSceneRedraw()	
	)
	
	
	--Functions based off one written by Chris Harvey
    --I found the basis for this function at http://www.scriptspot.com/3ds-max/scripts/detachelements
	FN ww_DetachPolyElements_fn SourceOBJ =
	(--start function for detaching elements from an editable poly object
		
		disableSceneRedraw()
		MasterObj = SourceOBJ 
		faceCount = MasterObj.getnumfaces()
		
		FaceTest = ((MasterObj.getnumfaces()) != 0)
		sg = 1
		for ii in 1 to faceCount while FaceTest do	--ends loop when there are no faces left to select
		(--start element detach loop
			newName = (uniquename (MasterObj.name as string))
			
			MasterObj.EditablePoly.SetSelection #Face #{1}
			MasterObj.selectElement()
			TargetElement = polyop.getFaceSelection MasterObj
			polyop.detachFaces MasterObj TargetElement asNode:true name:newName
			
			NewObj = getnodebyname newName
			resetXForm NewObj 
			convertTo NewObj (Editable_Poly)
			ResetTransform NewObj 
			ResetScale NewObj 
			ResetPivot NewObj 
			centerpivot NewObj
				
			--o = $
			--
			
			select newObj
				
				
			
			modPanel.addModToSelection (PhysX_Rigid_Body ()) ui:on
			--set mesh type to 4 (convex)
            NewObj.modifiers[#PhysX_Rigid_Body].meshType = 4
			
			

				
			modPanel.addModToSelection (smooth ()) ui:on
			NewObj.modifiers[#Smooth].smoothingBits = sg
				
			--this is not actually working as expected... the collision hull is not collapsing
			--I think I need to find a way to GET NewObj.modifiers[#PhysX_Rigid_Body].meshCustomMesh
			--When I look at the listener and add a PhysX Rigid Body Modifier and then click the 
			--"Convert to Custom Mesh" button, it references $Object001 but I cannot seem to use it
			--as is demonstrated in the next block of commented code... it's at a state where I gave up
			--playing with it for now
				
			collapseStack NewObj 
			append elementsArray NewObj
				
				
				
				
				
				
-- 			modPanel.addModToSelection (PhysX_Rigid_Body ()) ui:on	
-- 			h = $Object001;
-- 			--h.name = newName+" hull"	
-- 			
-- 			NewObj.modifiers[#PhysX_Rigid_Body].meshType = 6	
-- 			NewObj.modifiers[#PhysX_Rigid_Body].meshCustomMesh =	h
-- 			select h
-- 			modPanel.addModToSelection (smooth ()) ui:on
-- 			h.modifiers[#Smooth].smoothingBits = sg
-- 			collapseStack h 
-- 			append elementsArray h


				
			sg = sg*2
			FaceTest = ((MasterObj.getnumfaces()) != 0)
		)--end element detach loop
		delete MasterObj	
		enableSceneRedraw()
	)--end function for detaching elements from an editable poly object
	--End Functions written by Chris Harvey