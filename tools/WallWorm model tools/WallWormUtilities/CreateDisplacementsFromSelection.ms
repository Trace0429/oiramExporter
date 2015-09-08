/*

Function for creating a displacement for each face in the selection.

*/
	filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
	fileIn "$scripts/WallWorm.com/common/mse/wallwormVMF.mse"	
	
	if selection.count > 0 then (
		
		
		theDisp = wallworm_create_displacements_from_array ar:selection
		with undo off (
		if theDisp.count > 0 then (
			clearSelection()
			
			newcol = for disps in theDisp WHERE disps[1] != undefined collect disps[1]
			if newcol.count > 0 then (
				select newcol
				unhide newcol
			)
			
			/*
			for disp in theDisp do (
				if disp != undefined AND disp[1] != undefined then (
					selectMore disp[1]
				)
			)
			*/
			
		)
	)
	) else (
		
		messagebox "You need to select objects for this function to work."
		
		)