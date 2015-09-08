/*

Function for creating a displacement for each face in the selection.

*/
	filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
	fileIn "$scripts/WallWorm.com/common/mse/wallwormVMF.mse"	
	
	if selection.count > 0 then (
		theHold.SuperBegin()
		
		disps = #()
		tempSel = (selection as array) 
		clearSelection()
		
		wwallowedsegCount = #(4,8,16)
		
		for obj in tempSel where classOf obj == Plane AND obj.lengthsegs == obj.widthsegs AND (findItem wwallowedsegCount obj.lengthsegs) != 0 do (
			--print obj
			global ww_wwdt_displacement_power
			if ww_wwdt_displacement_power == undefined then (
				ww_wwdt_displacement_power = 2
			)
	
			theDisp =  (ww_wwdt_makeDisplacement ww_wwdt_displacement_power obj.length obj.width obj.pos brsh:obj)

			if theDisp != undefined AND theDisp[1] != undefined then (
				append disps theDisp[1]
			)
		)					
					


		
		if disps.count == 0 then (
			messagebox "No Displacements were made!\n\nYou can only make displacements from Planes with 4, 8 or 16 length segments and width segments."
			select tempSel
		) else (
			with undo off (
				select disps
				unhide disps
			)
		)
		
		theHold.SuperAccept "Convert Planes to Displacements"
		

	) else (
		
		messagebox "You need to select Plane objects for this function to work."
		
		)