fileIn "$scripts/WallWorm.com/common/matfuncs1.ms"
fileIn "$scripts/WallWorm.com/WallWormModelTools/ww_structs.ms"


function wallworm_give_selected_materials_ww = (


	local mtlArr = #()
	v = sme.activeView
	if v > 0 do
	(
 
			view = sme.GetView v
			numNodes = view.GetNumNodes()
		
		/*	if view.GetSelectedNodes != undefined then (
				
			) else (			)*/
		
		if numNodes > 0 then (
				for n=1 to numNodes   do (
					nd=view.GetNode n 
					if (nd != undefined AND (isProperty nd "selected" == true AND  nd.selected == undefined OR nd.selected==true)) then (
						ref = trackViewNodes[#sme][v][n].reference
						if  (classOf ref == Standard OR classOf ref == Blend ) then (
							append mtlArr ref
						)
					)
				)				

			)
		
		


	)
	if (mtlArr.count) != 0 then
	(
		for mat in mtlArr WHERE (classOf mat == Standard OR classOf mat == Blend )  do wallworm_give_mat_ww mat

	) else (
		return	false
	)

	mtlArr
)




				if sme != undefined  then (
					
					if wallworm_give_selected_materials_ww() == false then (
					
						mat = sme.GetMtlInParamEditor() 
						if mat != undefined AND (classOf mat == Standard OR classOf mat == Blend) then (
							wallworm_give_mat_ww mat	
						)
					) 
				) 
				if mat == undefined then (
						
					mat = medit.GetCurMtl()		
					
						if mat != undefined  AND (classOf mat == Standard OR classOf mat == Blend)  then (
							wallworm_give_mat_ww mat	
						)
				)
				
				
				