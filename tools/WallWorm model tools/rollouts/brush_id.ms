rollout wallwormBrushID "Go To Brush" width:401
(
	edittext edtBrushID "" pos:[90,4] width:114
	label lbl4 "Go To Brush ID" pos:[6,7] width:84 height:18
	button btnGo "Go" pos:[327,3] width:51 height:20 toolTip:"Go To and Select a Brush by it's ID after the scene has been exported to VMF."
	checkbox chkAlt "Collection Check" pos:[211,5] width:109 height:17 tooltip:"If the brush you are looking for was part of a Wall Object or a group object, it may be part of a collection. If you don't find the object from the default setting, click this checkbox, but the search may be a bit slower."
	
	group "Portals and Vis Leaves" (
		
		spinner spLeafA "Leaf A" type:#integer range:[0,16000,0] across:2
		button btnLeafA "Select this Leaf" 
		
		spinner spLeafB "Leaf B" type:#integer range:[0,16000,0] across:2
		button btnLeafB "Select this Leaf" 
		
		button getFromBoth "Get Portals Using Both A and B"
		
		button loadPortalFile "Load Portal File"
		
	)
	
	on btnLeafA pressed do (
		
		local lA = for obj in objects where isProperty obj "wallworm_portal" AND (obj.leafA == spLeafA.value OR obj.leafB == spLeafA.value) collect obj
		if lA.count > 0  then (
			select lA
			max zoomext sel

		)
	)
	
	on btnLeafB pressed do (
		
		local lA = for obj in objects where isProperty obj "wallworm_portal" AND (obj.leafA == spLeafB.value OR obj.leafB == spLeafB.value) collect obj
		if lA.count > 0  then (
			select lA
			max zoomext sel

		)
	)
	
	on getFromBoth pressed do (
		
		local lA = for obj in objects where isProperty obj "wallworm_portal" AND (obj.leafA == spLeafA.value OR obj.leafB == spLeafA.value)  AND (obj.leafA == spLeafB.value OR obj.leafB == spLeafB.value) collect obj
		if lA.count > 0  then (
			select lA
			max zoomext sel

		)
	)
	
	
	
	button leakLoad "Load Leak File" tooltip:"Load a Leak File"
	on btnGo pressed do
	(
			local brshs = #()
			local ars = #(edtBrushID.text)
			if matchPattern edtBrushID.text pattern:"*,*" then (
				
				ars = filterString edtBrushID.text ","
				
				if ars.count > 0 then (
					
					
					for n in ars do (

						join brshs (wallworm_get_exported_brush_by_id (n as integer) identical:(not chkAlt.checked))
					)
					
				)
				
				
			) else (
				brshs = wallworm_get_exported_brush_by_id (edtBrushID.text as integer) identical:(not chkAlt.checked)
			)
		
				
				if brshs.count > 0 then (
					
					
					if chkAlt.checked then (
						
						
						for b in brshs do (
							
							local faceSel = #{}
							
							local elements = wallwormGetElements b
							
							local brushIDstring  = getUserProp b "wallworm_exported_brush_ids"
							
							local brushIDs = filterString brushIDstring ","
							
							
							local elementsSelected = 0
							
							for i = ars.count to 1 by -1 do (
								
								local foundID = findItem brushIDs ars[i]
								if foundID > 0 then (
									--print ("Element "+foundID as string)
									join faceSel elements[foundID]
									deleteItem ars i
									elementsSelected += 1
								)
								
								
							)
							--
							
							if elementsSelected > 0 then (
								print faceSel
								setFaceSelection b.mesh  faceSel --name:"Selected Brushes"
								theMod = Mesh_Select()
								theMod.name = "Brush Selection"
								
								addModifier b theMod

							)
							
						)
						
						
					)
					
					
					
					select brshs
					max tool zoomextents
				) else (
					messagebox "No matching brushes were found."
				)
		)
		
		on loadPortalFile pressed do (
			macros.run "wallworm.com" "WallWormLoadPRTFileMCR"
		)
		on leakLoad pressed  do (
			macros.run "wallworm.com" "WallWormLoadLeakFileMCR"
		)
)

