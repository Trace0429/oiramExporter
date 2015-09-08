rollout wallworm_lightmap "Lightmap" width:396 height:42
(
	spinner spnLightmapScale "Lightmap Scale" pos:[65,14] width:100 height:16 range:[1,256,16] type:#integer scale:1 toolTip:"Control the lightmap scale of the selected objects. By default, all are 16."
	button btn3 "Get" pos:[175,15] width:40 height:15 toolTip:"Prefill the Lightmap Scale spinner with the lightmap scale of the selected object."
	button btn4 "Set Lightmap Scale" pos:[225,15] width:108 height:16 toolTip:"Set the selected Brushes and Displacements to use this lightmap scale."
	HyperLink lightmaphelp "Help" pos:[350,15] width:33 height:15 address:"http://dev.wallworm.com/document/101/lightmap_scale.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
 

	
	on wallworm_lightmap open do
	(
			
			if selection.count == 1 then (
				local getVal = ww_wwdt_getLightmapscale $
				if getVal != undefined then (
					spnLightmapScale.value = getVal
				)
			) else ()
			
		)
	on btn3 pressed do
	(
	if selection.count == 1 then (
		if ww_wwdt_getLightmapscale $ != undefined then (
		spnLightmapScale.value = ww_wwdt_getLightmapscale $
		)
	) else (
		messagebox "This function only works on a single selected object."
		)
	
	)
	on btn4 pressed do
	(
	
	if selection.count > 0 then (
		
		local oldSel = selection
		local modify = getCommandPanelTaskMode()
		local sublevel = subobjectLevel
		for obj in selection do (
			
			ww_wwdt_setLightmapscale obj amount:spnLightmapScale.value
			)
			
		select oldSel 
		try (
		setCommandPanelTaskMode mode:modify
		subobjectLevel = sublevel
		) catch()	
		) else (
			messagebox "This function requires you to select objects to apply this scale to."
		)
	
	)
)
