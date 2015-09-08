--super datch
--by feilang
--2008-05-09


try destroydialog L_detach catch()
--Functions
	FN DetachPolyElements_fn SourceOBJ =
	(--start function for detaching elements from an editable poly object
		MasterObj = SourceOBJ 
		faceCount = MasterObj.getnumfaces()
		FaceTest = ((MasterObj.getnumfaces()) != 0)
		for ii in 1 to faceCount while FaceTest do	--ends loop when there are no faces left to select
		(--start element detach loop
			newName = (uniquename (MasterObj.name as string+"_"))
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
			FaceTest = ((MasterObj.getnumfaces()) != 0)
		)--end element detach loop
		delete MasterObj
	)--end function for detaching elements from an editable poly object
	fn getLagforFaces pickedOBJ=
	(	ElementSource = pickedOBJ
		convertTo ElementSource (Editable_Poly) 
		faceCount = ElementSource.getnumfaces()
		facesNum=#{}
		Nthface=1
		for i in 1 to faceCount where faceCount != 0 do
		(
			ElementSource.EditablePoly.SetSelection #Face #{Nthface}
			ElementSource.selectElement()
			tempFaces=polyOp.getFaceSelection ElementSource
			selectedFaces=for i in tempFaces where try(not i) catch(true) collect i
			faceCount-=selectedFaces.count
			append facesNum Nthface
			Nthface+=selectedFaces.count
		)
		ElementSource.EditablePoly.SetSelection #Face #{}
		facesNum	
	)
	FN DetachPolyasPicked SourceOBJ ElementFaces=
	(	--start function for detaching elements from an editable poly object
		MasterObj = SourceOBJ 
		faceCount = MasterObj.getnumfaces()
		FaceTest = ((MasterObj.getnumfaces()) != 0)
		for ii in 1 to faceCount while FaceTest do	--ends loop when there are no faces left to select
		(--start element detach loop
			newName = (uniquename (MasterObj.name as string+"_"))
			MasterObj.EditablePoly.SetSelection #Face ElementFaces
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
			FaceTest = ((MasterObj.getnumfaces()) != 0)
		)--end element detach loop
		delete MasterObj
	)--end function for detaching elements from an editable poly object
	FN DetachMeshElements_fn SourceOBJ =
	(--start function for detaching elements from an editable Mesh object
		MasterObj = SourceOBJ
		convertTo MasterObj (Editable_Poly) 
		faceCount = MasterObj.getnumfaces()
		FaceTest = ((MasterObj.getnumfaces()) != 0)
		for ii in 1 to faceCount while FaceTest do	--ends loop when there are no faces left to select
		(--start element detach loop
			newName = (uniquename (MasterObj.name as string+"_"))
			MasterObj.EditablePoly.SetSelection #Face #{1}
			MasterObj.selectElement()
			TargetElement = polyop.getFaceSelection MasterObj
			polyop.detachFaces MasterObj TargetElement asNode:true name:newName
			NewObj = getnodebyname newName
			resetXForm NewObj 
			convertTo NewObj (Editable_Mesh)
			ResetTransform NewObj 
			ResetScale NewObj 
			ResetPivot NewObj 
			centerpivot NewObj
			FaceTest = ((MasterObj.getnumfaces()) != 0)
		)--end element detach loop
		delete MasterObj	
	)--end function for detaching elements from an editable Mesh object
	
	FN DetachMeshasPicked SourceOBJ ElementFaces=
	(	--start function for detaching elements from an editable Mesh object
		MasterObj = SourceOBJ
		convertTo MasterObj (Editable_Poly) 
		faceCount = MasterObj.getnumfaces()
		FaceTest = ((MasterObj.getnumfaces()) != 0)
		for ii in 1 to faceCount while FaceTest do	--ends loop when there are no faces left to select
		(--start element detach loop
			newName = (uniquename (MasterObj.name as string+"_"))
			MasterObj.EditablePoly.SetSelection #Face ElementFaces
			MasterObj.selectElement()
			TargetElement = polyop.getFaceSelection MasterObj
			polyop.detachFaces MasterObj TargetElement asNode:true name:newName
			NewObj = getnodebyname newName
			resetXForm NewObj 
			convertTo NewObj (Editable_Mesh)
			ResetTransform NewObj 
			ResetScale NewObj 
			ResetPivot NewObj 
			centerpivot NewObj
			FaceTest = ((MasterObj.getnumfaces()) != 0)
		)--end element detach loop
		delete MasterObj	
	)--end function for detaching elements from an editable Mesh object
fn DetachByface_ploy sourceObj =
(		MasterObj = SourceOBJ 
		faceCount = MasterObj.getnumfaces()
		FaceTest = ((MasterObj.getnumfaces()) != 0)
		for ii in 1 to faceCount while FaceTest do	--ends loop when there are no faces left to select
		(--start element detach loop
			newName = (uniquename (MasterObj.name as string+"_"))
			polyop.detachFaces MasterObj 1 asNode:true name:newName
			NewObj = getnodebyname newName
			resetXForm NewObj 
			convertTo NewObj (Editable_Poly)
			ResetTransform NewObj 
			ResetScale NewObj 
			ResetPivot NewObj 
			centerpivot NewObj
			FaceTest = ((MasterObj.getnumfaces()) != 0)
		)--end element detach loop
		delete MasterObj
)

fn DetachByface_mesh sourceObj =
(		MasterObj = SourceOBJ 
		convertTo MasterObj (Editable_Poly)
		faceCount = MasterObj.getnumfaces()
		FaceTest = ((MasterObj.getnumfaces()) != 0)
		for ii in 1 to faceCount while FaceTest do	--ends loop when there are no faces left to select
		(--start element detach loop
			newName = (uniquename (MasterObj.name as string+"_"))
			polyop.detachFaces MasterObj 1 asNode:true name:newName
			NewObj = getnodebyname newName
			resetXForm NewObj 
			convertTo NewObj (Editable_Mesh)
			ResetTransform NewObj 
			ResetScale NewObj 
			ResetPivot NewObj 
			centerpivot NewObj
			FaceTest = ((MasterObj.getnumfaces()) != 0)
		)--end element detach loop
		delete MasterObj
)


fn isPloyOrMesh obj= (classof obj==Editable_Poly) or (classof obj==Editable_Mesh)
rollout L_detach "超级分离" width:130 height:108
(
	local pickedObj,maxangle=360,minmutiple=0.5,maxmutiple=1.5
	button btn_detach "分离成面" pos:[12,53] width:105 height:20 toolTip:"把选择的物体的每一个面分离出来"
	label lbl_about "CG++出品" pos:[36,83] width:57 height:16
	button btn_byElement "分离成元素" pos:[12,7] width:105 height:20 toolTip:"把选择物体的每一个元素都分离出来"
	checkbox chk_ifPicked "Checkbox" pos:[101,32] width:17 height:18 checked:true
	pickbutton btn_sourceElement "拾取物体" pos:[12,30] width:84 height:20 message:"拾取一个作为参照的物体" filter:isPloyOrMesh toolTip:"如果拾取了物体,分离成元素按钮会以这个为基准分离" autoDisplay:true
	on btn_detach pressed do
	(	max create mode
		ObjsSource = getCurrentSelection()	--create array of all selected objects
		if ObjsSource[1] == undefined then messagebox "Nothing is selected!"    -- checks to see something is selected
		for obj in 1 to ObjsSource.count do 
		(	--start Object loop
			SourceOBJ = ObjsSource[obj]
			if (classof SourceOBJ  == editable_poly) then (DetachByface_ploy SourceOBJ)			
			-- operates only on those objects that are editable polys
			else if (classOf SourceOBJ == Editable_Mesh) then (DetachByface_mesh SourceOBJ)		
			-- operates only on those objects that are editable meshes
		)--end Object loop
		clearUndoBuffer()
	)--end btn_detach
	on btn_byElement pressed do
	(	
			max create mode
			ObjsSource = getCurrentSelection()	--create array of all selected objects
			if ObjsSource[1] == undefined then messagebox "Nothing is selected!"    -- checks to see something is selected
			else 
			(	
				undo off(
				isPicked=(chk_ifPicked.state and btn_sourceElement.object!=undefiend)
				if isPicked then
				(	ElementFaces=try getLagforFaces btn_sourceElement.object catch(0)
					if ElementFaces!=0 then
					(	for obj in 1 to ObjsSource.count do 
						(	--start Object loop
							SourceOBJ = ObjsSource[obj]
							if (classof SourceOBJ  == editable_poly) then (try DetachPolyasPicked SourceOBJ ElementFaces catch())			
							-- operates only on those objects that are editable polys
							else if (classOf SourceOBJ == Editable_Mesh) then (try DetachMeshasPicked SourceOBJ ElementFaces catch())		
							-- operates only on those objects that are editable meshes
						)--end Object loop
					)
					else messagebox "The picked object is no exist"
				)
				else
				(
				for obj in 1 to ObjsSource.count do 
				(	--start Object loop
					SourceOBJ = ObjsSource[obj]
					if (classof SourceOBJ  == editable_poly) then (DetachPolyElements_fn SourceOBJ)			
					-- operates only on those objects that are editable polys
					else if (classOf SourceOBJ == Editable_Mesh) then (DetachMeshElements_fn SourceOBJ)		
					-- operates only on those objects that are editable meshes
				)--end Object loop
				)
				)--end undo off
			)--end else
			clearUndoBuffer()
	)--end btn_detach
	on chk_ifPicked changed state do
	(	case chk_ifPicked.state of
		(	true: btn_sourceElement.enabled=true
			false: btn_sourceElement.enabled=false
		) 

	)
)
if CGplusplusFunc!=undefined  then CGplusplusFunc.createChild L_detach width:130
else createdialog L_detach