
	
try(destroyDialog wwmtSpecToAlpha)catch(
	
	   --there was not any open
)

wwmt_matsforAlphaSpec = #()
wwmt_specSelectedMat = undefined
wwmt_material_targets = #("Bump", "Displacement", "Self-Illumination", "Diffuse")
wwmt_specTargetState = 1

wwmt_alpha_inverstatus = false


fn wwmt_rgbToAlpha source &dest =
 (
	 --function provided by lo_ in the Area forums
  if source.width != dest.width or source.height != dest.height do return undefined --only allow same size images
	  local w = source.width
	  for y = 0 to source.height-1 do
	  (
		  local sourceRow = getPixels source [0,y] w
		  local destRow = getPixels dest [0,y] w
		  for x = 1 to sourceRow.count do destRow[x].alpha = sourceRow[x].value 
			setPixels dest [0,y] destRow 

	)
  dest
)


function wwmt_alphacompfn specularLevel specPoint bumpColor bumpPoint = 
(
		--res = bumpColor -- keep bump colors
		
		bumpColor.alpha = specularLevel.value -- use specular value as bump alpha

	bumpColor
)






function wwmt_hasBumpmap mat = (
	local found = false
	
	if mat.bumpMap == undefined AND mat.displacementMap == undefined do (

		 return false
		)
	
	if (mat.displacementMap != undefined  AND (classOf mat.displacementMap == Bitmaptexture OR (classOf mat.displacementMap == Normal_Bump AND classOf mat.displacementMap.normal_map== Bitmaptexture))) then (
		return true
	) else (

		if (mat.bumpMap != undefined  AND (classOf mat.bumpMap == Bitmaptexture OR (classOf mat.bumpMap == Normal_Bump AND classOf mat.bumpMap.normal_map== Bitmaptexture))) then (

				return true
			
				) else (
			

			
			)
		)
		
		return false
		
	)

	
function addStandardMaterialToArray &matarray &mat = (
	
	
		if mat != undefined do (
		
		inList = false
			for m in matarray while inList == false do (	
		--for m in materials do (
			try (
				if m.mat == mat  do (inList=true)
			) catch()
			)
		
		if(inList ==false) do(
			if (classOf mat == Standardmaterial ) then (
				
				--
				if mat.specularLevelMap != undefined  AND classOf mat.specularLevelMap == Bitmaptexture AND  ( wwmt_hasBumpmap(mat) ==true ) do (
					--print (classOf mat.specularLevelMap)
					appendIfUnique matarray mat
					
				)
				
				) else (
				
				if (classOf mat == Multimaterial ) then (
					for m in mat.materialList do (
						addStandardMaterialToArray matarray m
						)
					) else (
						
						if (classOf mat ==Shell_Material) do (
							
							addStandardMaterialToArray matarray  mat.bakedMaterial
							
							)
						
						)
				
				)
			
		)
		
	)
	
	)

	
	function copyAlphaFromTo fromTex toTex = (
		
		
		
		if classOf fromTex != Bitmaptexture do (
			messagebox "The Specular texture was invalid."
			return false	
		)
		if classOf fromTex != Bitmaptexture do (
			messagebox "The target texture was invalid."
			return false	
		)
		
		if fromTex.bitmap.height != toTex.bitmap.height do (
			
			messagebox "The specular map and the target map do not have the same height. The must be the same dimensions."
			
			return false
			)
			
		if fromTex.bitmap.width != toTex.bitmap.width do (
			
			messagebox "The specular map and the target map do not have the same width. The must be the same dimensions."
			
			return false
			)
			
			--if (toTex.bitmap.hasAlpha == false) do (
				

				--messagebox ("The target bitmap must have an Alpha channel. Resave this map with an Alpha channel and try again.")

				--return false
				
				--)
		
			
		--m = wwmt_rgbToAlpha fromTex.bitmap toTex.bitmap	
			
		newMap = copy toTex.bitmap
			
		specCopy = copy fromTex
		/*	
		if wwmt_alpha_inverstatus == true then (
			if fromTex.output.invert  == true then ( 
				fromTex.output.invert  = false
			) else (
				fromTex.output.invert = true
			)
		) 		

*/
		
		pastebitmap fromTex.bitmap newMap [0,0] [0,0] type:#function function:wwmt_alphacompfn
/*
		if wwmt_alpha_inverstatus == true then (
			
			if fromTex.output.invert  == true then ( 
				fromTex.output.invert  = false

			) else (
				
				fromTex.output.invert = true
			)
		) 		
		*/
		--m = getChannelAsMask fromTex.bitmap #shaderColor to:toTex.bitmap
		
			--display newMap
			
			--newMap.filename = toTex.bitmap.filename
			--save newMap
			--display newMap	
				
			newFileName = getBitmapSaveFileName caption:"Save New Bitmap" 
			if newFileName != undefined then (
				if (getFilenameType newFileName) != ".tga" then (
					
					messagebox "You must save the image as a TGA file!"
					return false
					) else (
					
						newMap.filename = newFileName
						save newMap	
					
						return newMap				
					
					)
				) else (
					return false
					)
			--save toTex.bitmap
			--display toTex.bitmap

		)
	
	


rollout wwmtSpecToAlpha "Wall Worm Alpha Spec" width:336 height:323
(
	listbox lbxMaterials "Materials With Bump and Specular Level" pos:[7,79] width:318 height:9 selection:0 toolTip:"A list of materials that have Specular Level and a Bump/Displacement map."
	button btnRefreshMaterials "Update Material List" pos:[199,60] width:124 height:33 toolTip:"Click here to generate a list of materials from the current scene selection that are candidates for merging the Specular Level into the Alpha of another bitmap."
	radiobuttons rdoCopyTo "Copy Specular Level to Alpha Of:" pos:[7,227] width:96 height:78 labels:#("Bump", "Displacement", "Self-Illumination", "Diffuse") columns:1
	checkbutton ckbInvert "Invert Alpha" pos:[181,227] width:144 height:29 toolTip:"Reverse the Alpha values."
	button btnSendSpecToAlpha "Do It" pos:[182,260] width:142 height:44 enabled:false
	label lbl4 "This tool is EXPERIMENTAL!!!! Not finished or well tested!" pos:[10,9] width:314 height:30
	HyperLink alphaspcelink "Important Documentation - READ BEFORE USE!" pos:[10,35] width:232 height:15 address:"http://wallworm.com/projects/utilities/docs/rollouts/alpha_spec.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	on lbxMaterials selected sel do
	(
	
		if sel != undefined AND sel > 0 then (
		theMat = wwmt_matsforAlphaSpec[sel]
		wwmt_specSelectedMat = theMat
		local newItems = #() 
		
		if theMat.diffuseMap != undefined AND classOf theMat.diffuseMap == Bitmaptexture do (
			append newItems "Diffuse"
		)
		if theMat.selfIllumMap != undefined AND classOf theMat.selfIllumMap == Bitmaptexture do (
			append newItems "Self-Illumination"
		)
		if (theMat.displacementMap != undefined  AND (classOf theMat.displacementMap == Bitmaptexture OR (classOf theMat.displacementMap == Normal_Bump AND classOf theMat.displacementMap.normal_map== Bitmaptexture)))  do (
			append newItems "Displacement"
		)
		if (theMat.bumpMap != undefined  AND (classOf theMat.bumpMap == Bitmaptexture OR (classOf theMat.bumpMap == Normal_Bump AND classOf theMat.bumpMap.normal_map== Bitmaptexture))) do (
			append newItems "Bump"
		)
		
		
		
		
		--rdoCopyTo.labels = newItems
		
		if newItems.count > 0 then (
			btnSendSpecToAlpha.enabled = true
			) else (
			
			btnSendSpecToAlpha.enabled = false
			)
		)
	)
	on btnRefreshMaterials pressed do
	(
	
	  if selection.count > 0 then (
		  
		wwmt_matsforAlphaSpec = #()
		  
		  for obj in selection do (
			  
			  
			  if obj.mat != undefined do (
				  
				  
				  addStandardMaterialToArray wwmt_matsforAlphaSpec  obj.mat
				  
				  
				  
				  )
			  
			  
			  
			  )
		  
			if wwmt_matsforAlphaSpec.count > 0 then (
			  
				theItems = #()
				for m in wwmt_matsforAlphaSpec do (
					
					append theItems m.name
					
					
					
					
					)
				
				lbxMaterials.items = theItems
					
				btnSendSpecToAlpha.enabled = true
				lbxMaterials.selection = 0
			  ) else (
			  btnSendSpecToAlpha.enabled = false
			  messagebox "No valid materials were found in the selection."
			  )
		  
		  ) else (
		  
			messagebox "You must select some objects."
		  
		  )
	
	
	)
	on rdoCopyTo changed stat do
	(
	
	wwmt_specTargetState = stat
	
	)
	on ckbInvert changed state do
	(
	
	wwmt_alpha_inverstatus = state
		
		print (wwmt_alpha_inverstatus as string)
	
	)
	on btnSendSpecToAlpha pressed do
	(
	
				if wwmt_specSelectedMat == undefined do (
					messagebox "Select a material from the list first."
					return false
					)
		
		
				theMat = wwmt_specSelectedMat
		
		
	--
				selected = wwmt_material_targets[wwmt_specTargetState]
				local copied = false
		
				if selected=="Diffuse" AND theMat.diffuseMap != undefined AND classOf theMat.diffuseMap == Bitmaptexture do (
	
					copied = copyAlphaFromTo theMat.specularLevelMap theMat.diffuseMap
					if copied != false do (
						
						
						
						
							newTex = copy theMat.diffuseMap
							newTex.bitmap = copied
							theMat.specularLevelMap = newTex
							theMat.diffuseMap  = newTex
							--theMat.specularLevelMap.bitmap = copied
						
						)
					
				)
				if selected=="Self-Illumination" AND  theMat.selfIllumMap != undefined AND classOf theMat.selfIllumMap == Bitmaptexture do (
					
					copied = copyAlphaFromTo theMat.specularLevelMap theMat.selfIllumMap
					
						if copied != false do (
							newTex = copy theMat.selfIllumMap
							newTex.bitmap = copied
							theMat.specularLevelMap = newTex
							theMat.selfIllumMap  = newTex
							--theMat.specularLevelMap.bitmap = copied
						
						)
				)
				if selected=="Displacement" AND  (theMat.displacementMap != undefined  AND (classOf theMat.displacementMap == Bitmaptexture OR (classOf theMat.displacementMap == Normal_Bump AND classOf theMat.displacementMap.normal_map== Bitmaptexture)))  do (
					
					if classOf theMat.displacementMap == Bitmaptexture then (
						copied = copyAlphaFromTo theMat.specularLevelMap theMat.displacementMap
						if copied != false do (
							newTex = copy theMat.displacementMap
							newTex.bitmap = copied
							theMat.specularLevelMap = newTex
							theMat.displacementMap  = newTex
							--theMat.specularLevelMap.bitmap = copied
						)
					) else (
						copied = copyAlphaFromTo theMat.specularLevelMap theMat.displacementMap.normal_map
						if copied != false do (
							newTex = copy theMat.displacementMap.normal_map
							newTex.bitmap = copied
							theMat.specularLevelMap = newTex
							theMat.displacementMap.normal_map  = newTex
							--theMat.specularLevelMap.bitmap = copied
						
						)
						)
	
				)
				if selected=="Bump" AND  (theMat.bumpMap != undefined  AND (classOf theMat.bumpMap == Bitmaptexture OR (classOf theMat.bumpMap == Normal_Bump AND classOf theMat.bumpMap.normal_map== Bitmaptexture))) do (
					
					if classOf theMat.bumpMap == Bitmaptexture then (
						copied = copyAlphaFromTo theMat.specularLevelMap theMat.bumpMap
						if copied != false do (
							newTex = copy theMat.bumpMap
							newTex.bitmap = copied
							theMat.specularLevelMap = newTex
							theMat.bumpMap  = newTex
							--theMat.specularLevelMap.bitmap = copied
						
						)
						
					) else (
						copied = copyAlphaFromTo theMat.specularLevelMap theMat.bumpMap.normal_map
						
						if copied != false do (
							newTex = copy theMat.bumpMap.normal_map
							newTex.bitmap = copied
							theMat.specularLevelMap = newTex
							theMat.bumpMap.normal_map  = newTex
							--theMat.specularLevelMap.bitmap = copied
						
						)
						
						)
				)
				if copied != false then (
					
						messagebox ("The specular color was copied to the "+selected+" alpha channel. Also, the specular level map was detached from the Material.")
						--theMat.specularLevelMap = undefined
					
					) else (
					
						messagebox ("The specular color was NOT copied to the "+selected+" alpha channel.")
					)
	
	)
)

createDialog wwmtSpecToAlpha
