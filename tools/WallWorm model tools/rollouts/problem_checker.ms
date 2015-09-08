rollout wallwormProblemChecker "Check For Problems" width:250 (
	
	local theObjs = #()
	
	
	group "General Problems" (
		checkbox chkVersions "Check for 3ds Max Version" align:#left toolTip:"See if there are any known problems with your version of Max."
		checkbox chkWWMTVersion "Check for Wall Worm updates" align:#left toolTip:"Check to see if you have the latest version of Wall Worm."
		checkbox chkSMDMaterial "Check Wall Worm Settings" align:#left toolTip:"Check for problems with your global WW settings." checked:true 		
		checkbox chkEntVersions "Out-Of-Date Entities" align:#left tooltip:"Check if there are any entities in the scene that are out-of-date or the FGD needs re-parsed?"  checked:true 	
		
	)

	group "Level and VMF checks" (
		
		checkbox chkInvalidObjects "Concave Geometry" align:#left toolTip:"Selects objects that are not valid brushes because they are concave (not convex)."
		checkbox chkEntsOutOfBounds "Entities Out of Bounds" align:#left tooltip:"Check for entities that are outside the bounds of the compilable space."
		checkbox chkBrushOutOfBounds "Brushes Out of Bounds" align:#left tooltip:"Check for brushes that have verts outside the bounds of the compilable space."
		checkbox chkNonPlanarFaces "Brush Geometry with Non-Planar Faces" align:#left toolTip:"Find objects that have polygons that are non-planar. Non planar faces may be convex, but will not always export as intended."
		checkbox chkLimitToTaggedBrush "Only Check Tagged Geometry" align:#left checked:true toolTip:"When checked, only include objects that have been tagged as world geometry with Anvil."

	)
	
	group "Models and Proxies" (
		
		checkbox chkModelsNotYesExported "Models in Scene that aren't Exported yet" align:#left toolTip:"Check for WWMT helpers in the scene that have no MDL file compiled into the game directory."
 		checkbox chkExportedMaterials "Models with missing VMTs." align:#left toolTip:"Check to see if there are any WWMT models that are missing some VMTs." enabled:false
	)
	
	group "Options" (
		checkbox chkUseCurrentSelection "Limit to Current Selection"  align:#left toolTip:"Only search for problems within the current selection."
		checkbox chkSelectResults "Select Problem Objects" align:#left toolTip:"If errors are found, set the current selection to those problem objects."
		checkbox chkIgnoreHidden "Ignore Hidden Objects" align:#left toolTip:"Do not check hidden objects for problems."
	)
	
	button btnDoIt "Check For Problems Now" align:#center
	button btnGetLastRes "Select Last Results" align:#center
	

	
	group "Actions" (
		
		button btnGetMaxUpdates "Download Latest 3ds Max Updates" align:#left toolTip:"Open the Web Page of the latest updates for Max."
		button btnBreakFacesSelected "Break Non Planar Faces on Selection" align:#left toolTip:"This function will convert all selected objects to an editable poly... and then break any polygons that have faces not in the same plane."
		button cvxSceneChecker "Launch Convexity Scene Checker" align:#left toolTip:"Opens the Convexity Scene Checker if you have Convexity installed. Get Convexity at Maple3D.com."
		
	)
	
	function selectLastResults = (
		if theObjs.count > 0 then (
		
				clearSelection()
				select theObjs
				
		)	
	)
	
	on wallwormProblemChecker open do (
		if selection.count == 0 then (

			chkSelectResults.checked = true
		)

	)
	
	on btnGetLastRes pressed do (
		
		selectLastResults()
	)
	
	on cvxSceneChecker pressed do (
		
		
		try (
			macros.run "Maple3D-Convexity" "SceneChecker"

			) catch (
			
			messagebox "Convexity not found. For details, see www.maple3d.com ."
			)
		
		)
	
		
	on btnGetMaxUpdates pressed do (
		macros.run "Help" "Help_Web_Updates"
	)
	
	on btnBreakFacesSelected pressed do (
		macros.run "wallworm.com" "WallWormBreakNonPlanarMCR"
	)
	
	
		
	
	function useThisNode node = (
		if chkUseCurrentSelection.checked == true and node.isSelected == false then (
			return false
		) else (
			
			if chkIgnoreHidden.checked == true AND node.isHidden ==true then (
				return false
			)
			
		)
		
		true
	)
	
	
	function useThisBrushNode node = (
			if useThisNode node == false then (
				return false
			) else (
				if chkLimitToTaggedBrush.checked == true AND getUserProp node "wwdt_brush_geometry_export" != true then (
					return false
				)
				
			)
		true
	)
	
	on btnDoIt pressed do (
		theObjs = #()
		local nonConvex = #()
		local nonPlanar = #()
		local unExportedModels = #()
		local versionProblems = #()
		local settingsErrors = #()
		local outofboundproblems = #()
		local wwold = false
		
		if chkWWMTVersion.checked == true then (
			wwold = wallworm_need_update()
		)
		
		if chkUseCurrentSelection.checked == true then (
			local objCollection = selection as array
				
		) else (
				
			objCollection = objects as array
		)
			
		if chkUseCurrentSelection.checked == true AND selection.count == 0 then (
			messagebox "Oops! You checked the option to limit results to the current selection but no objects are selected."
			return false
			
		) else (
			

			
			
			
			if chkModelsNotYesExported.checked == true then (
				local wwmt = for obj in objCollection WHERE useThisNode obj == true AND getUserProp obj "wwmt_source_helper" == true collect obj

				for mdl in wwmt do (
						
						local wwmt_modelPath = getUserProp mdl "wwmt_modelPath"
						local wwmt_modelname = getUserProp mdl "wwmt_modelname"
						if wwmt_modelPath != undefined AND wwmt_modelPath != "" AND wwmt_modelname != undefined AND wwmt_modelname != "" then (
							global wwmt_gameInfoDir
							theMdlPath = wwmt_gameInfoDir + "\\models\\"+wwmt_modelPath+"\\"+wwmt_modelname+".mdl"
							
							if doesFileExist theMdlPath == false then (
								append unExportedModels mdl
								
								)
							
						)
				)
				
						
				join theObjs unExportedModels

				
				
			)
			
			

		
			if chkInvalidObjects.checked == true OR chkNonPlanarFaces.checked == true OR chkEntsOutOfBounds.checked == true OR chkBrushOutOfBounds.checked == true then (
				--collect objects exporting as world geometry
				
			function isNodeInExportablePos position  = 
			 (
				global wallworm_mapsize
				local minX = wallworm_mapsize.x	
				local maxY = wallworm_mapsize.y	

				local minCorner = [minX,minX,minX]
				local maxCorner = [maxY,maxY,maxY]	 

				 minCorner.x < position.x and maxCorner.x > position.x \
				 and
				 minCorner.y < position.y and maxCorner.y > position.y \
				 and
				 minCorner.z < position.z and maxCorner.z > position.z
			)
				
			if chkEntsOutOfBounds.checked then (
				global wallworm_mapsize
				
				if wallworm_mapsize == undefined then (
					wallworm_mapsize =  [-16384,16384]
				)
				
				
				local ents =  for obj in objCollection WHERE (isProperty obj "entName" OR getUserProp obj "wwmt_proxie_source" != undefined ) collect obj
				join ents (lights as array)
				
				in coordsys world (

					outofboundproblems = for obj in ents WHERE NOT isNodeInExportablePos obj.pivot collect obj
				)
				if outofboundproblems.count > 0 then (
					join theObjs outofboundproblems
					
				)
			)
			
			function isNodeInExportable node  = 
			 (
				global wallworm_mapsize
				local minX = wallworm_mapsize.x	
				local maxY = wallworm_mapsize.y	

				local minCorner = [minX,minX,minX]
				local maxCorner = [maxY,maxY,maxY]	 

				 minCorner.x < node.min.x and maxCorner.x > node.max.x \
				 and
				 minCorner.y < node.min.y and maxCorner.y > node.max.y \
				 and
				 minCorner.z < node.min.z and maxCorner.z > node.max.z
			)
				
			if chkBrushOutOfBounds.checked then (
				global wallworm_mapsize
				
				if wallworm_mapsize == undefined then (
					wallworm_mapsize =  [-16384,16384]
				)
				
				
				local ents =  for obj in objCollection WHERE superClassOf obj == GeometryClass AND ( ((isProperty obj "entityType" AND obj.entityType == "SolidClass") OR (classof obj == Corvex AND obj.isWorldGeometry == true) OR (obj.layer.name == "Convexity Walls" OR obj.layer.name == "Convexity Floors") OR (getUserProp obj "wwdt_brush_geometry_export" != undefined AND getUserProp obj "wwdt_brush_geometry_export" == true) )) collect obj

				
				in coordsys world (

					outofboundproblems2 = for obj in ents WHERE NOT isNodeInExportable obj collect obj
				)
				if outofboundproblems2.count > 0 then (
					join theObjs outofboundproblems2
					
					join outofboundproblems outofboundproblems2
					
				)
				
			)
		
				
				
				
				if chkInvalidObjects.checked == true then (
					nonConvex = for obj in objCollection WHERE useThisBrushNode obj == true AND wallworm_isConvex obj == false collect obj
					if nonConvex.count > 0 then (
						join theObjs nonConvex
					)
				
				)

				
				if chkNonPlanarFaces.checked == true then (
				
					nonPlanar = for obj in objCollection WHERE useThisBrushNode obj == true AND  superClassOf obj == GeometryClass AND wallworm_hasNonPlanarPolygon obj == true AND isGroupHead obj == false collect obj
					if nonPlanar.count > 0 then (
						join theObjs nonPlanar
					)
				
				)
				
				
				
			)
				
		)
		

		
		
			if chkVersions.checked then (
				
				
				maxExeVersionArr = wallworm_getMaxVersion()
				
				local version = maxExeVersionArr[1] as integer
				local patchversion = maxExeVersionArr[2] as integer
				

				if version == 16 and patchversion < 3 then (
					append versionProblems ("Wall Worm does not work properly on 3ds Max 2014 unless you have Product Update / Service Pack 2 or later installed. Service Pack 5 is now available. Please download the latest service pack for 3ds Max 2014.")
				)	else (
					if version == 16 and patchversion < 5 do (
						append versionProblems ("Service Pack 5 is now available. Please download the latest service pack for 3ds Max 2014.")
					)						
					
				)
				
				if version == 15 and patchversion < 2 then (
					append versionProblems ("Wall Worm does not work properly on 3ds Max 2013 unless you have Product Update / Service Pack 2 or later installed. Please download the latest service pack for 3ds Max 2013.")
				)	else (
					if version == 15 and patchversion < 6 do (
						append versionProblems ("Service Pack 6 is now available. Please download the latest service pack for 3ds Max 2013.")
					)	
				)		
				
				if version == 14 and patchversion < 2 do (
					append versionProblems ("Wall Worm does not work properly on 3ds Max 2012 unless you have Product Update / Service Pack 2 or later installed. Please download the latest service pack for 3ds Max 2012.")
					
				)
				
				

				
				if version < 13  do (
					
					append versionProblems ("The Show Walkable function in Wall Worm Anvil only works in 3ds Max 2011+.")
					
				)
				
				if version == 9 and appendIfUnique == undefined do (
					
					append versionProblems ("Wall Worm is not officially supported on 3ds Max 9 but users have reported it works if you have the AVguard extension installed. Please download the latest patch for your Max and get AVGuard from ScriptSpot.com.")
					
				)
				
				if version < 9  do (
					
					append versionProblems ("Wall Worm cannot work on versions of Max older than 3ds Max 9.")
					
				)
				
				if version < 16 AND maxOps.productVersion == #productVersionEdu  then (
					append versionProblems ("You are not using the latest version of 3ds Max. Since you have an educational version of Max and can freely get the latest version, you should consider updating to 3ds Max 2014+ since Wall Worm is generally tested on the latest versions more thoroughly.")
					
				)
				
				
			)
			entityProblems = #()
			
			if chkEntVersions.checked == true then (
				
				filein "$scripts\\WallWorm.com\\common\\mse\\fgd2.mse"
				
				global wallworm_game_settings
				global wallworm_entity_version
				
				if wallworm_game_settings != undefined AND wallworm_game_settings.ents != undefined AND wallworm_game_settings.ents.count > 0 then (

					) else (
					
					macros.run "wallworm.com" "wallwormParseFGD2"
					
				)

				if wallworm_game_settings != undefined AND wallworm_game_settings.ents != undefined AND wallworm_game_settings.ents.count > 0 then (
					
					
					test = wallworm_game_settings.get_entity_by_name  wallworm_game_settings.ents[1].name
					local bb = box()
					custAttributes.add bb test.ca
					if bb.version < wallworm_entity_version then (
						append entityProblems ("The FGD is out-dated... you need to re-parse it in the global settings.")
						
					)
					
					delete bb
				) else (
					
					append entityProblems ("The FGD has not been parsed. You may need to re-parse it in the global settings or set a FGD. Until this is done, you cannot use the Wall Worm entity tools.")
				)
				
				
				oldEntities = for obj in objects WHERE isProperty obj "wallworm" == true AND isProperty obj "entityType" == true AND obj.version < wallworm_entity_version collect obj
					
				if oldEntities.count > 0 then (
					append entityProblems ("There are entities in the scene with out-dated entity custom attributes. Wall Worm has updated the entity definitions since these entities were created. You should update them by opening the MAXScript listener and pasting this code: wallworm_update_all_entities() and hitting ENTER..")
					
				)
				
				
				
				
			)
			
			
		
			if chkSMDMaterial.checked == true then (
				
				
				if wwmtExporter == "3" then ( 
					
					if wwmt_legacy_names == "true" then ( 
						
					
					append settingsErrors "You are using the Wall Worm SMD Exporter... but you have Legacy Material Names turned on. You *should* turn that off in your global settings"
						
					)
					
					if wwmt_oldModelVTFPath == "true" then (
						
						append settingsErrors "You are using the Wall Worm SMD Exporter... but you have Legacy VTF paths turned on. You *should* turn that off in your global settings."
					)

				) else (
					
					if wwmt_legacy_names == "false" then ( 
						
					
					append settingsErrors "Your current SMD Exporter does not support the naming convention used in your Material Export settings. You *should* switch to the Wall Worm SMD Exporter *or* turn on Legacy Material Names in your global settings."
						
					)
					
					if wwmt_oldModelVTFPath == "false" then (
						
						append settingsErrors "Your current SMD Exporter does not support the naming convention used in your Material Export settings. You *should switch* to the Wall Worm SMD Exporter *or turn on* Legacy Material Names in your global settings."
					)
					
					
				)
				
				if wwmt_makeHullsNonRenderable == "true" AND wwmt_exportNonRenderableMeshAsBone == "true" then (
					
					append settingsErrors "You have both Export Non Renderable Mesh as Bone checked as well as the option Processed Hulls become Non Renderable. You should not use these settings together because it can lead to hulls that do not export any geometry."

				)
				
				
				if (units.DisplayType == #Generic) == false then (
					append settingsErrors ("For using 3ds Max for Source, you should set the Display Units to Generic. You currently are using "+(units.DisplayType as string)+" units. Click Customize > Units Setup to change this setting.")

				)
				
				if (units.SystemType == #inches) == false OR units.SystemScale != 1.0 then (
					append settingsErrors ("For using 3ds Max for Source, you should set the System Units to Inches where 1 unit equals one inch. You currently are using a setting where 1 unit equals "+(units.SystemScale as string)+" "+(units.SystemType as string)+". Click Customize > Units Setup > System Unit Setup to change this setting.")

				)
				
				
				
				if wallworm_binSet "tex" == false then (
					append settingsErrors "The Bin Directory you've set for Wall Worm does not include vtex.exe. Without VTEX, you cannot export textures. Find the correct path for VTEX. Note that sometimes Steam deletes VTEX after a steam update. If this is the case, you may only need to restart Steam and/or re-open Hammer for your mod."
				)
				
				
				if wallworm_binSet "model" == false then (
					append settingsErrors "The Bin Directory you've set for Wall Worm does not include studiomdl.exe. Without STUDIOMDL, you cannot export and compile models. Find the correct path for STUDIOMDL. Note that sometimes Steam deletes STUDIOMDL after a steam update. If this is the case, you may only need to restart Steam and/or re-open Hammer for your mod."
				)
				
				
			)

		if theObjs.count > 0 OR versionProblems.count > 0 OR unExportedModels.count > 0 OR settingsErrors.count > 0 OR entityProblems.count >0  OR wwold == true OR 	outofboundproblems.count > 0 then (
		
		
			if chkSelectResults.checked == true  then (
				selectLastResults()
				
			)

			clearListener()
			messagebox "There were errors. Check the MAXScript listener (press F11)."
			
			if nonConvex.count > 0 then (
			
				format "\n\n######################\n\nThe following items MAY not be convex.\n\n"
				for obj in nonConvex do (
					
					format "%\n" obj
					
					)
			
				
				
			)
			
			
			if outofboundproblems.count  > 0 then (
				format "\n\n######################\n\nThe following items are either out of bounds (entity positions) or have vertices that go out of bounds (brushes).\n\n"
				for obj in outofboundproblems do (
					
					format "%\n" obj
					
				)
			)
			
			
			if nonPlanar.count > 0 then (
			
				format "\n\n######################\n\nThe following items have non-planar polygons.\n\n"
				for obj in nonPlanar do (
					
					format "%\n" obj
					
				)
			
				
				
			)
		
			
			if unExportedModels.count > 0  then (
				
				
				format "\n\n######################\n\nThe following models have not been compiled into game yet.\n\n"
				for obj in unExportedModels do (
					
					
					if classOf obj == Text then (
						format "% @ %\n" obj.text obj.pos
					) else ()
						format "%\n" obj
					)
				
				
				
				
			)
			
			
			
			if settingsErrors.count > 0 then (
				
				format "\n\n######################\n\nThe following warnings were produced for your global  Wall Worm Settings.\n\n"
				for er in settingsErrors do (
					
					format "* %\n\n" er
					
				)
				
			)
			
			if entityProblems.count > 0 then (
				
				format "\n\n######################\n\nThe following warnings were produced for your Entities and FGD.\n\n"
				for er in entityProblems do (
					
					format "* %\n\n" er
					
				)
				
			)
			
			
			
			
			if versionProblems.count > 0 then (
				
				format "\n\n######################\n\nThe following warnings were produced for your version of 3ds Max.\n\n"
				for er in versionProblems do (
					
					format "* %\n\n" er
					
				)
				
			)

			if wwold == true then (
					
				format "\n\n######################\n\n***\tWall Worm is out-of-date! You should download the latest version at http://dev.wallworm.com .\n\n"
			)
			
			
			
		) else (
			

				messagebox "No problems detected."
			
			
			
		)
	)
		
		
)