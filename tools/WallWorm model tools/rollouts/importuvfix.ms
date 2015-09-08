rollout wallworm_brush_plane_fix "Fix Imported UVS" (
	local importedBrush

	combobox cmbPlanes "Planes"
	label fnlbl "Face Normal"
	function updatePlanesFromCurrentObject obj = (
		
		
		
		theBrushID = getUserProp obj "ww_anvil_new_brush_id"
		
		if theBrushID != undefined AND theBrushID as integer != undefined then (
			global theWallWormVMFImport
				importedBrush = theWallWormVMFImport.brushes[theBrushID]
				
			
					if importedBrush == undefined then (
						
						entbrushes = for ent in theWallWormVMFImport.entities WHERE ent.brushes != undefined AND ent.brushes.count > 0  collect ent.brushes
						ents = #()	
						for eb in entbrushes do (
							join ents eb
						)
						
						entbrushes = for entbrush in ents WHERE entbrush.id == theBrushID collect entbrush
						if entbrushes.count == 1 then (
							importedBrush = entbrushes[1]
						)
					)
			
			
				if importedBrush != undefined then (
				if NOT isValidNode importedBrush.nd then (
					importedBrush.nd = obj
				)
				
				cmbPlanes.items = (for pl in importedBrush.planes collect pl.faceNormal as string)
			)
		)
		
		
	)
	
	function getCurrentFaceSel = (
		local fi = 0
		if  importedBrush != undefined AND isValidNode  importedBrush.nd then (
			local faceSel = polyop.getFaceSelection importedBrush.nd
			if faceSel.numberset == 1 then (		

				local fi = ((faceSel as array)[1])
			)
		)
		fi
	)
	
	
	function getCurrentFaceNormal = (
		local fi = getCurrentFaceSel()
		local currentNorm
		if fi != 0 then (
			currentNorm =  (in coordsys world (polyop.getFaceNormal importedBrush.nd fi node:importedBrush.nd))
			fnlbl.text = currentNorm as string
				
		)
		currentNorm
	)
	function getCurrentMaterialID = (
		local fi = getCurrentFaceSel()
		local matID = 1
		if fi != 0 then (		
			matID = polyop.getFaceMatID  importedBrush.nd fi
		)
		matID
	)
	

	
	function updateUVONObject = (
		local fi = getCurrentFaceSel()
		if fi != 0 then (		
			p = importedBrush.planes[cmbPlanes.selection]
			wallworm_ApplyPlanarMap importedBrush.nd fi uvwmatrix:p.uvwmatrix  uaxis:p.uNOrmal vaxis:p.vNOrmal uscale:(p.uscale) uoffset:p.uoffset  vscale:(p.vscale) voffset:p.voffset mat:p.mat 
		)
	)
	
	checkbox chkAuto "Auto Update"
	
	button chkUpdateFaceNormal "Get Face Normal"
	
	button btnUpdateFromSel "Update the UV"
	
	dropdownlist matlist "Materials"
	
	
	function getPlanerFaceIndex face = (
		index = 0
		for f= 1 to importedBrush.planes.count while index == 0 do ( 
			if p.faceindex == face then (
				index = f
			)
		)
		index
	)
	
	function getBestPlaneIndex  = (
	local index = 0	
	local currentNormal = getCurrentFaceNormal()
	if currentNormal  != undefined then (
	local fi = getCurrentFaceSel()
		local bestCandidate

		for f = 1 to importedBrush.planes.count  do ( 
			local pl = importedBrush.planes[f]
			
			local d = dot (currentNormal) (pl.faceNormal)
			if d == 1.0 then (
				bestCandidate = pl
				index = f
			) else (
				if acos d < 1.0 then (
				bestCandidate = pl
				index = f
					
				)
				
			)
			
			
			
		)
	)
		index
	)
	
	
	on chkUpdateFaceNormal pressed do (
		index = getBestPlaneIndex()
		if index != 0 then (
			cmbPlanes.selection = index
			updateUVONObject()
		)
	)
	
	
	function getCurrentMaterial = (
		
		if importedBrush != undefined AND importedBrush.nd.mat != undefined then (
			
			if classof importedBrush.nd.mat == MultiMaterial then (
				--matlist.items = importedBrush.nd.mat.names as array
				
				matlist.items = for m in  importedBrush.nd.mat.materialList collect m.name
				matlist.selection = getCurrentMaterialID()
			) else (
				matlist.items = #(importedBrush.nd.mat.name)
				
			)
		) else (
			matlist.items = #()
		)
	)
	
	on btnUpdateFromSel pressed do (
		getCurrentFaceNormal()	
		if selection.count == 1 then (
			
			if importedBrush != undefined AND (NOT isValidNode importedBrush.nd OR selection[1] != importedBrush.nd) then (
				updatePlanesFromCurrentObject selection[1]
			)
			
			
			updateUVONObject()
			getCurrentMaterial()
		)
		
		
	)
	on cmbPlanes selected sel do (
		if chkAuto.checked == true then (
			updateUVONObject()
		)
	)
	
	
	on wallworm_brush_plane_fix open do (
		
		if selection.count == 1 then (
			updatePlanesFromCurrentObject selection[1]
		)
		
		getCurrentFaceNormal()
		
		getCurrentMaterial()
	)
	
	
	on matlist selected sel do (
		polyop.setFaceMatID  importedBrush.nd (getCurrentFaceSel()) sel
	)
)