macroScript WallWormSimpleDisplacementMCR
category:"wallworm.com"
tooltip:"Wall Worm Anvil Level Editor Tools"
buttontext:"Anvil"
(
	
	function closeAnvil = (
		global wallworm_anvil
		try(destroyDialog wallworm_anvil)catch()
		
	)
	
	on isChecked do (
			global wallworm_anvil
		
			if wallworm_anvil == undefined then (
					return false
			) else (
					return true
			)
		
	)
	on closeDialogs do (
		closeAnvil()
	)
	
	
	on execute do (
		
		global wallworm_anvil
		
		if wallworm_anvil == undefined then (
			if doesFileExist "$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\anvil.ms" then (
				fileIn "$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\anvil.ms"
			) else (
				messagebox "Wall Worm Anvil is missing. Reinstall Wall Worm."
			)
		) else (
			closeAnvil()
		)
		
	)

)

macroscript WallWormCorVexUtilities
category:"wallworm.com"
tooltip:"CorVex Utility Floater"
buttonText:"CorVex Utility Floater"
(
	on execute do (
		
		
		global CorVex
		
		if CorVex == undefined then (
			try (
				
				crvstring = "crv = CorVex()"
				execute crvstring
				global crv
				delete crv
			) catch ()
		)
		
		if CorVex == undefined then (
			
			
			if (querybox "CorVex is a commercial Addon Plugin for Wall Worm that is not installed. Would you like to learn more about CorVex?") == true then (
				
				shellLaunch "http://dev.wallworm.com/topic/66/corvex.html" ""
			)
			

			
		) else (
			local crv = createInstance CorVex
			if crv.openCorVexUtilities != undefined then (
				crv.openCorVexUtilities()
			) else (
				messagebox "Your version of CorVex is now out-of-date. Please download the latest version of CorVex."
				
			)
			crv = undefined
			
		)
		
	)
)

macroScript WallWormRemoveDisplacementsStartupMCR
category:"wallworm.com"
tooltip:"Remove Displacement Startup Script"
buttontext:"Remove Displacement Startup Script"
(
	on execute do (
		
		callbacks.removeScripts  id:#wwdt_displacement_topo_handler
		callbacks.removeScripts id:#wwdt_displacement_clone_handler

		
		
	)
	
	
)

macroScript WallWormBreakNonPlanarMCR
category:"wallworm.com"
tooltip:"Break Non Planar Faces"
buttontext:"Break Non Planar Faces"
(
	
	on execute  do with undo label:"Break Non Planar Faces" on (
		if selection.count > 0 then (
			
			objs = for obj in selection WHERE superclassof obj == GeometryClass collect obj
			if objs.count > 0 then (	
				addmodifier objs (turn_to_poly requirePlanar:on planarThresh:0.1)
				convertToPoly objs
			)
		)
		)
	
	)






macroScript WallWormDisplacementsCheckMCR
category:"wallworm.com"
tooltip:"Check to remove displacements callback"
buttontext:"Check to remove displacements callback"
(
	
	on execute do (
			local dispslist = for disp in objects where isProperty disp "ww_displacement" == true OR isProperty disp "wallworm_edit_mesh" == true OR (getUserProp disp "ww_wwdt_displacement_brush" != undefined AND getUserProp disp "ww_wwdt_displacement_brush" != "undefined" ) collect disp 
			if dispslist==undefined OR dispslist.count == 0 then (
				macros.run "wallworm.com" "WallWormRemoveDisplacementsStartupMCR"
				return false
			)
			return true
		)
	
)

	
macroScript WallWormDisplacementsQuadrifyMCR
category:"wallworm.com"
tooltip:"Quadrify Displacements"
buttontext:"Quadrify Displacements"
(
	
	on execute do (
		
			local dispslist = for disp in objects where isProperty disp "ww_displacement" == true OR isProperty disp "wallworm_edit_mesh" == true collect disp 
			if dispslist.count >0  then (
				oldSel = selection as array
				
				for disp in dispslist do (
					disp.qaudrifyMe()
				)
				
				

				if oldSel.count > 0 then (
					select oldSel
				) else (
					max select none
				)
				return true
			)
			return false
		)
	
)

macroScript WallWormDisplacementsTriangulateMCR
category:"wallworm.com"
tooltip:"Triangulate Displacements"
buttontext:"Triangulate Displacements"
(
	
	on execute do (
		suspendEditing()
		with redraw off (
			local dispslist = for disp in objects where isProperty disp "ww_displacement" == true OR isProperty disp "wallworm_edit_mesh" == true collect disp 
				for disp in dispslist do (
						disp.traingulateMe()
				)
			)
			resumeEditing()
		)
		
)


macroScript wallwormParseFGD2
category:"wallworm.com"
tooltip:"Parse FGD File"
buttontext:"Parse FGD File"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/common/mse/parseFGD2.ms" then (

			filein "$scripts/WallWorm.com/common/mse/parseFGD2.ms"
		) else (
			messagebox "WW FGD Parser 2 is Missing. Reinstall Wall Worm."
			)
	)
)

macroScript wallwormPointEntities
category:"wallworm.com"
tooltip:"Point Entities"
buttontext:"Point Entities"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/rollouts/pointEntities.ms" then (

			filein "$scripts/WallWorm.com/rollouts/pointEntities.ms"
		) else (
			messagebox "WW Point Entities is Missing. Reinstall Wall Worm."
			)
	)
)

macroScript wallwormBrushEntities
category:"wallworm.com"
tooltip:"Brush Entities"
buttontext:"Brush Entities"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/rollouts/brushEntities.ms" then (
			filein "$scripts/WallWorm.com/rollouts/brushEntities.ms"
		) else (
			messagebox "WW Point Entities is Missing. Reinstall Wall Worm."
		)
	)
)	
	
macroScript WallWormLoadLeakFileMCR
category:"wallworm.com"
tooltip:"Load Leak File"
buttontext:"Load Leak File"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/LoadLineFile.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/LoadLineFile.ms"
		) else (
			messagebox "WW Line File Loader is Missing. Reinstall Wall Worm."
			)
	)
	
)

macroScript WallWormLoadPRTFileMCR
category:"wallworm.com"
tooltip:"Load PRT File"
buttontext:"Load PRT File"
(
	on execute do (
		
		global wallworm_prt
		
		
		if wallworm_prt == undefined then (
			if doesFileExist "$scripts/WallWorm.com/WallWormSimpleDisplacement/prt.ms" then (

				filein "$scripts/WallWorm.com/WallWormSimpleDisplacement/prt.ms"
			) else (
				messagebox "WW Line File Loader is Missing. Reinstall Wall Worm."
			)			
		)
		if wallworm_prt != undefined then (
			local prt = wallworm_prt()
			if (prt.parse_visibility()) then (
				prt.construct_leaves()
				prt.creatPortalSpines()
			)
		)

	)
	
)



macroScript WallWormGetBrushByIDMCR
category:"wallworm.com"
tooltip:"Get Brush By ID"
buttontext:"Get Brush By ID"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/getBrushById.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/getBrushById.ms"
		) else (
			messagebox "WW Brush ID script is Missing. Reinstall Wall Worm."
			)
	)
)

	
macroScript WallWormRemapMaterialsMCR
category:"wallworm.com"
tooltip:"Redirect Material Paths"
buttontext:"Redirect Material Paths"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/RemapMaterials.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/RemapMaterials.ms"
		) else (
			messagebox "WW Remap Materials Script is Missing. Reinstall Wall Worm."
			)
	)
)


macroScript WallWormDisplacementPropertiesMCR
category:"wallworm.com"
tooltip:"Edit Displacement Properties"
buttontext:"Edit Displacement Properties"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/DisplacementTools.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/DisplacementTools.ms"
		) else (
			messagebox "WW Displacement Tool is Missing. Reinstall Wall Worm."
			)
	)
)

macroScript WallWormDisplacementCreateFromSelectionMCR
category:"wallworm.com"
tooltip:"Create Displacements From Selection"
buttontext:"Create Displacements From Selection"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/CreateDisplacementsFromSelection.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/CreateDisplacementsFromSelection.ms"
		) else (
			messagebox "Create Displacements From Selection Script is missing. Reinstall Wall Worm."
			)
	)
)

macroScript WallWormDisplacementCreateFromPlanesMCR
category:"wallworm.com"
tooltip:"Convert Planes to Displacements"
buttontext:"Convert Planes to Displacements"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/ConvertPlanesToDisplacements.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/ConvertPlanesToDisplacements.ms"
		) else (
			messagebox "Create Displacements From Selection Script is missing. Reinstall Wall Worm."
			)
	)
)


macroScript WallWormDisplacementPainterMCR
category:"wallworm.com"
tooltip:"Create Displacements By Painting"
buttontext:"Create Displacements By Painting"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/PaintDisplacementsOnFaces.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/PaintDisplacementsOnFaces.ms"
		) else (
			messagebox "Create Displacements By Painting Script is missing. Reinstall Wall Worm."
			)
	)
)

macroScript WallWormImportVBSPMCR
category:"wallworm.com"
tooltip:"Import Detail VBSP File"
buttontext:"Import VBSP File"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/ImportDetailVBSP.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/ImportDetailVBSP.ms"
		) else (
			messagebox "WW VBSP Import is Missing. Reinstall Wall Worm."
			)
	)
)


macroScript WallWormImportVMFMCR
category:"wallworm.com"
tooltip:"Import VMF File"
buttontext:"Import VMF or Map File"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/VMFImporterUI.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/VMFImporterUI.ms"
		) else (
			messagebox "WW VMF Import is Missing. Reinstall Wall Worm."
			)
	)
)


macroScript WallWormImportDXFMCR
category:"wallworm.com"
tooltip:"Import DXF File"
buttontext:"Import DXF File"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/import_dxf.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/import_dxf.ms"
		) else (
			messagebox "WW DXF Import is Missing. Reinstall Wall Worm."
			)
	)
)

macroScript WallWormExportOverviewMCR
category:"wallworm.com"
tooltip:"Export Overview Texture"
buttontext:"Export Overview Texture"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/overview_export.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/overview_export.ms"
		) else (
			messagebox "WW Overview Exporter is Missing. Reinstall Wall Worm."
			)
	)
)

macroScript WallWormRepairDXRenderMatNamesMCR
category:"wallworm.com"
tooltip:"Repair DX Mat Names"
buttontext:"Repair DX Mat Names"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/repair_dx_matnames.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/repair_dx_matnames.ms"
		) else (
			messagebox "Repair DX Mat Names Missing. Reinstall Wall Worm.\n\nIf the file is missing from the latest download, the 3ds Max has an update that fixes the problem."
			)
	)
)




macroScript WallWormExportVMFMCR
category:"wallworm.com"
tooltip:"Export Scene as VMF"
buttontext:"Export Scene as VMF"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/exportSceneAsVMF.ms" then (

			filein "$scripts/WallWorm.com/WallWormUtilities/exportSceneAsVMF.ms"
		) else (
			messagebox "WW VMF Exporter is Missing. Reinstall Wall Worm."
			)
	)
)

macroScript WallWormCordonManagerMCR
category:"wallworm.com"
tooltip:"Cordon Manager"
buttontext:"Cordon Manager"
(
	on execute do (
		if doesFileExist "$scripts/WallWorm.com/WallWormUtilities/cordontools.ms" then (
			filein "$scripts/WallWorm.com/WallWormUtilities/cordontools.ms"
		) else (
			messagebox "The Cordon Manager is missing. Please reinstall Wall Worm."
		)
	)
)


macroScript WallWormDesignateSelectionAsConcave
category:"wallworm.com"
toolTip:"Set as Concave Brush"
buttonText:"Set as Concave Brush"
(
	on execute do (
		if selection.count > 0 then (
			

			setUserProp selection "explode_on_export" "true"
			macros.run "wallworm.com" "WallWormDesignateSelectionAsBrushes"
			
		)
		
	)
	
)

macroScript WallWormDesignateSelectionAsConvex
category:"wallworm.com"
toolTip:"Set as Convex Brush"
buttonText:"Set as Convex Brush"
(
	on execute do (
		if selection.count > 0 then (
			setUserProp selection "explode_on_export" "false"
		)
		
	)
	
)


macroScript WallWormDesignateSelectionAsBrushes
category:"wallworm.com"
toolTip:"Set Selection as Brush Geometry"
buttonText:"Set Selection as Brush Geometry"
(
	on execute do (
		  local errors = false
		  for obj in selection where isValidNode obj  and (superClassOf obj == GeometryClass or isGroupHead obj ) and (getUserProp obj "ww_wwdt_displacement_brush") == undefined and (getUserProp obj "wwmt_decal") == undefined AND (getUserProp obj "wwmt_LOD_Gizmo" == undefined)  do (
			local canAdd = true
			
				try (
				--only add Convex geometry but put in try block since not all people have MassFX/PhysX
				--canAdd = nvpx.IsConvex obj 
				if nvpx.IsConvex obj ==false then (
					format "% may not be Convex!!\n" obj.name
					errors = true
					)
				) catch (
				--canAdd = true
				)
			
			--if canAdd == true then (
				
				if classof obj.baseobject == Corvex then (
					obj.isWorldGeometry = true
					
				) else (

					if superClassOf obj == GeometryClass AND  getUserProp obj "wwmt_proxie_source" == undefined then (
						setUserProp obj "wwdt_brush_geometry_export" "true"
					)
				)
				
			--) else ()
			
		  )
			if errors == true then (
				--messagebox "There were some errors. Please check the MAXScript listener (press F11)."
				)
	)
	
	
)

macroScript WallWormRemoveSelectionFromBrushes
category:"wallworm.com"
toolTip:"Remove Selection from Brush Geometry"
buttonText:"Remove Selection from Brush Geometry"
(
	on execute do (
		
		for obj in selection where isDeleted obj == false do (
			
			
				if classof obj.baseobject == Corvex then (
					obj.isWorldGeometry = false
				) else (
			
					setUserProp obj "wwdt_brush_geometry_export" "false"
			
				)
		)
		
	)
	
	
)




macroScript WallWormVMFExcludeWWMT
category:"wallworm.com"
toolTip:"Exclude Export of Model in VMF"
buttonText:"Exclude Export of Model"
(
	on execute do (
		  for obj in selection where isDeleted obj == false and  (getUserProp obj "wwmt_source_helper" != undefined) do (
				 
				 if isProperty obj "exclude_vmf" then (
					 obj.exclude_vmf = true
				) else (
					 setUserProp obj "wallworm_exclude_vmf" "true"
				)
			  
		  )
		
	)

)


macroScript WallWormVMFIncludeWWMT
category:"wallworm.com"
toolTip:"Include Export of Model in VMF"
buttonText:"Include Export of Model"
(
	on execute do (
		  for obj in selection where isDeleted obj == false and  (getUserProp obj "wwmt_source_helper" != undefined) do (
				 if isProperty obj "exclude_vmf" then (
					 obj.exclude_vmf = false
				) else (
					 setUserProp obj "wallworm_exclude_vmf" "false"
				)
		  )
		
	)

)



macroScript WallWormDesignateSelectionAsSky
category:"wallworm.com"
toolTip:"Set Selection as Skybox Item"
buttonText:"Set Selection as Skybox Item"
(
	on execute do (
		
		  for obj in selection where isDeleted obj == false do (
				 if isProperty obj "skybox" then (
					 obj.skybox = true
				) else (
					 setUserProp obj "wwdt_skybox_export" "true"
				)
		  )
		
	)
)

macroScript WallWormRemoveSelectionFromSky
category:"wallworm.com"
toolTip:"Remove Selection from Skybox Items."
buttonText:"Remove Selection from Skybox Items"
(
	on execute do (
		
		for obj in selection where isDeleted obj == false do (
			
				 if isProperty obj "skybox" then (
					 obj.skybox = false
				) else (
					 setUserProp obj "wwdt_skybox_export" "false"
				)
		)
		
	)
	
	
)

macroScript WallWormDesignateSelectionAsFuncDetail
category:"wallworm.com"
toolTip:"Set Selection as Func Detail"
buttonText:"Set Selection as Func Detail Item"
(
	on execute do (
		

			macros.run "wallworm.com" "WallWormDesignateSelectionAsBrushes"
		  for obj in selection where isDeleted obj == false do (

			setUserProp obj "wwdt_func_detail" "true"
			setUserProp obj "GLBEntData" "func_detail,mindxlevel,maxdxlevel"
			setUserProp obj "GLBEntValu" ",0,0"
		  )
		
	)
	
	
)

macroScript WallWormDesignateSelectionAsFuncDetailGroup
category:"wallworm.com"
toolTip:"Set Selection as Grouped Func Detail"
buttonText:"Set Selection as Grouped Func Detail"
(
	on execute do (
		
		
			if selection.count > 1 then (
				local selnodes = selection as array
				macros.run "wallworm.com" "WallWormDesignateSelectionAsFuncDetail"
				
				newgroup = group selnodes name:(uniqueName "WW Func Detail")  select:true
				
				for obj in newgroup do ( 
					
					if (isGroupHead obj == true) then (
						setUserProp obj "wwdt_func_detail" "true"
						setUserProp obj "GLBEntData" "func_detail,mindxlevel,maxdxlevel"
						setUserProp obj "GLBEntValu" ",0,0"
					) 
					
				)
			
				selnodes = undefined

				select newgroup
			)
			macros.run "wallworm.com" "WallWormDesignateSelectionAsFuncDetail"

	)
	
	
)



macroScript WallWormRemoveSelectionFromFuncDetail
category:"wallworm.com"
toolTip:"Remove Selection from Func Detail Items."
buttonText:"Remove Selection from Func Detail Items"
(
	on execute do (
		
		for obj in selection where isDeleted obj == false do (
			setUserProp obj "wwdt_func_detail" "false"
			setUserProp obj "GLBEntData" ""
			setUserProp obj "GLBEntValu" ""
		)
		
	)
	
	
)

Macroscript wallwormHideAllBrushes
category:"wallworm.com"
tooltip:"Hide All Displacement Brushes"
buttontext:"Hide All Displacement Brushes"
(
		on execute do (
		brushes = for obj in objects WHERE obj.isHidden == false AND (((isProperty obj "ww_displacement_brush" == true OR getUserProp obj "ww_wwdt_displacement_target" != undefined)) OR (classof obj == Corvex AND obj.isWorldGeometry == true)) collect obj
		hide brushes	
		)
	
)

Macroscript wallwormSelectAllBrushes
category:"wallworm.com"
tooltip:"Select Brushes"
buttontext:"Select Brushes"
(
	
	on execute do (
		if selection.count > 0 then (
			select (for obj in selection where  ((getUserProp obj "wwdt_brush_geometry_export") != undefined AND (getUserProp obj "wwdt_brush_geometry_export") == true) OR (classof obj == Corvex AND obj.isWorldGeometry == true) collect obj)
		) else (
			select (for obj in objects where  ((getUserProp obj "wwdt_brush_geometry_export") != undefined AND (getUserProp obj "wwdt_brush_geometry_export") == true) OR  (classof obj == Corvex AND obj.isWorldGeometry == true) collect obj)
		)
	
	)
)



Macroscript wallwormSelectAllDetails
category:"wallworm.com"
tooltip:"Select Func Details"
buttontext:"Select Func Details"
(
	
	on execute do (
		if selection.count > 0 then (
			select (for obj in selection where ((getUserProp obj "wwdt_func_detail") != undefined AND ((getUserProp obj "wwdt_func_detail") == true)) AND  (((getUserProp obj "wwdt_brush_geometry_export") != undefined AND (getUserProp obj "wwdt_brush_geometry_export") == true) OR (classof obj == Corvex AND obj.isWorldGeometry == true)) collect obj)
		) else (
			select (for obj in objects where ((getUserProp obj "wwdt_func_detail") != undefined AND (getUserProp obj "wwdt_func_detail") == true) AND  ( ((getUserProp obj "wwdt_brush_geometry_export") != undefined AND (getUserProp obj "wwdt_brush_geometry_export") == true) OR  (classof obj == Corvex AND obj.isWorldGeometry == true)) collect obj)
		)
	
	)
)




Macroscript wallwormbrushmodetoggle
category:"wallworm.com"
tooltip:"Wall Worm Brush Mode"
buttontext:"Brush Mode"
/*autoUndoEnabled:false*/
(
	global wallwormbrusmodestate
	
	global wallworm_brush_mode_create = function wallworm_brush_mode_create = (
		
		obj = callbacks.notificationParam()
		if isValidNode obj  and (superClassOf obj == GeometryClass or isGroupHead obj == true  ) and  (getUserProp obj "wwmt_decal") == undefined AND (getUserProp obj "wwmt_proxie_source" == undefined) AND getUserProp obj "ww_wwdt_displacement_target"==undefined AND isProperty obj "wallworm_edit_mesh" == false AND isProperty obj "ww_displacement_target" == false AND (isProperty obj "entityType" == false  OR obj.entityType != "PointClass")  AND (getUserProp obj "wwmt_LOD_Gizmo" == undefined)   then (

			

			if classof obj.baseobject == Corvex then (
				obj.isWorldGeometry = true
				
			) else (
				local theClass = classof obj
				if findItem (#(Plane,Torus,Tube,Teapot,L_Ext,Torus_Knot,C_Ext,RingWave,Hose)) theClass == 0  then (
					setUserProp obj "wwdt_brush_geometry_export" "true"
				)
			)

			local mat 	
			if obj.mat == undefined then (
				if sme != undefined  then (
						mat = sme.GetMtlInParamEditor() 
				) 
				if mat == undefined then (
						
					mat = medit.GetCurMtl()		
				)
				
				if mat != undefined AND superClassOf mat == Material then (
					obj.mat = mat
							
				)
			)
			
			
		)
	)
	
	
	global wallworm_brush_mode_create_spline = function wallworm_brush_mode_create_spline = (
		obj = callbacks.notificationParam()
		if isDeleted obj == false and superClassOf obj == Shape  then (
			
			addModifier obj (Extrude())
		)
		
	)
	
	

	global wallworm_removeBrushMode = function wallworm_removeBrushMode = (
		callbacks.removeScripts id:#wallwormbrushmode
		global wallwormbrusmodestate
		wallwormbrusmodestate = false	
	)
	
	on isChecked return wallwormbrusmodestate --check or uncheck the Macro button
	on closeDialogs do (
		wallworm_removeBrushMode()
	)
	
	on execute do (
		if wallwormbrusmodestate == undefined then (
		
			wallwormbrusmodestate = false	
			
		)
		
		if wallwormbrusmodestate == false then (
			callbacks.addScript #nodeCreated "wallworm_brush_mode_create()" id:#wallwormbrushmode persistent:false
			callbacks.addScript #nodeCloned "wallworm_brush_mode_create()" id:#wallwormbrushmode persistent:false
			--callbacks.addScript #sceneNodeAdded "wallworm_brush_mode_create_spline()" id:#wallwormbrushmode persistent:false
			
			
			callbacks.addScript #filePreSave "wallworm_removeBrushMode()" id:#wallwormbrushmode persistent:false
			
			wallwormbrusmodestate = true
			
		) else (
			
				wallworm_removeBrushMode()
		)
	)
)

macroscript WallWormCarver
category:"wallworm.com"
tooltip:"Wall Worm Carver"
buttonText:"Wall Worm Carver"
(
	on execute do (
		
		
		global wallworm_carver
		

		if wallworm_carver == undefined then (
			
			
			if (querybox "Carver is a commercial Addon Plugin for Wall Worm that is not installed. Would you like to learn more about Carver?") == true then (
				
				shellLaunch "http://dev.wallworm.com/topic/67/carver.html" ""
			)
			

			
		) else (
			local crv =  wallworm_carver()
			crv.displayRollout()
			crv.helperRollout.crvStruct = crv
			crv.displayRollout()
		)
		
	)
)
