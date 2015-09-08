rollout wallwormlights "Lights" width:385 height:73
(
	colorPicker cpHDRBrightness "HDR Color" pos:[47,38] width:114 height:19 enabled:false color:(color 255 255 255) title:"Choose Brightness (HDR Color)"
	checkbox chkUseBrightness "Use LDR Brightness" pos:[173,39] width:121 height:16 checked:true toolTip:"Reuse the light's color as the HDR color in all selected lights."
	spinner spnHDRScale "HDR Scale" pos:[55,13] width:85 height:16 range:[1,100,1] type:#float scale:0.01 toolTip:"Sets the HDR scale to this value for all selected lights."
	button btnFromLight "Get" pos:[169,13] width:55 height:19 toolTip:"Set the UI values to those found in the selected light."
	button btnSetLights "Set" pos:[230,13] width:58 height:19 toolTip:"Set the selected lights to use all of the values in this UI."
	
	function useHDRBrightness state = (
		
		if state == true then (
			cpHDRBrightness.enabled = true
			chkUseBrightness.checked = false
		) else (
			cpHDRBrightness.enabled = false
			chkUseBrightness.checked = true
			
		)

	)
	
	
	
	
	on chkUseBrightness changed state do
	(
	
	useHDRBrightness (not state)
	)
	on btnFromLight pressed do
	(
			
			if selection.count == 1 AND superClassOf $ == light then (
				
				
						if isProperty $ "_lightHDR" then (
							_lightHDR = $._lightHDR
						) else (
							_lightHDR = getUserProp $ "_lightHDR"
						)
						

						_UseBrightness = getUserProp $ "_UseBrightness"

						
						if isProperty $ "_lightscaleHDR" then (
							_lightscaleHDR = $._lightscaleHDR
						) else (
							
							_lightscaleHDR = getUserProp $ "_lightscaleHDR"
						)
				
						if _lightHDR != undefined then (
							if classof _lightHDR == color then (
								cpHDRBrightness.color = _lightHDR
							) else (
							global wwtempColor
							execute ( "wwtempColor = "+_lightHDR)
							cpHDRBrightness.color = wwtempColor
							wwtempColor = undefined
							)
							)
						if _UseBrightness != undefined then (
							
							chkUseBrightness.state = _UseBrightness
						)
						
						if _lightscaleHDR != undefined then (
							 spnHDRScale.value = _lightscaleHDR
							
						)
						
						useHDRBrightness (not chkUseBrightness.state)
				) else (
				
				 messagebox "This function only works when there is one single light selected."
				)
			
			
			
			)
	on btnSetLights pressed do
	(
	 if selection.count > 0 then ( 
		local foundLights = false
		for l in selection WHERE superClassOf l == light do (
			foundLights = true
			
			if isProperty l "_lightHDR" then (
				l._lightHDR = cpHDRBrightness.color
			) else (
			 setUserProp l "_lightHDR" (cpHDRBrightness.color as string)
			)
			setUserProp l "_UseBrightness" (chkUseBrightness.state as string)
			if isProperty l "_lightscaleHDR" then (
				l._lightscaleHDR = spnHDRScale.value
			) else (
				setUserProp l "_lightscaleHDR" (spnHDRScale.value as string)
			)
		)
		if foundLights == false then (
			messagebox "There were no lights in the selection."
			)
	) else ( 
		 
		messagebox "You must have at least one light selected."
		 
	)
	
	
	
	
	)
)
