rollout wallwormRemapMaterials "Remap Material and Bitmap Paths" width:408 height:332
(
	checkbox chkSelected "Limited to Selected Object Materials" pos:[18,26] width:250 height:15 checked:true toolTip:"When checked, limits remapping to materials in current object selection."
	checkbox chkBitmaps "Remap Bitmaps" pos:[17,48] width:95 height:15 toolTip:"When checked, remaps the bitmap names as well as material."
	
	checkbox chkPrepend "Prepend" pos:[124,47] width:59 height:15 toolTip:"When checked, the remapping is prepended to the current names."
	

	
	edittext edtMatch "" pos:[14,102] width:377 height:28
	label lbl2 "Match Pattern" pos:[18,77] width:168 height:22
	
	label lbl3 "Skip Pattern" pos:[17,147] width:168 height:16
	edittext edtSkip "" pos:[16,164] width:377 height:28
	
	label lbl1 "New Path" pos:[20,209] width:166 height:18
	edittext edtNewPath "" pos:[14,231] width:382 height:25
	
	
	button btn1 "Run Material Remap" pos:[17,274] width:377 height:38 toolTip:"Remap the names of the materials and possibly their bitmaps."
	
	
	
	
	on btn1 pressed do
	(
			fileIn "$scripts/WallWorm.com/common/matfuncs1.ms"
			/*requires $scripts/WallWorm.com/common/matfuncs1.ms*/
		
			local mats
			if chkSelected.checked == true then (
				mats = for obj in selection WHERE obj.mat != undefined collect obj.mat
			) else (
				mats = sceneMaterials
			)
			
		
			wallworm_material_redirect mats edtNewPath.text prepend:chkPrepend.checked maps:chkBitmaps.checked texNameToPath:true texPathOnlyForBitmaps:true skipPattern:edtSkip.text	
		)
)
