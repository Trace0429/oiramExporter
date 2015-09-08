Macroscript wallwormbrushmodetoggle
category:"wallworm.com"
tooltip:"Wall Worm Brush Mode"
buttontext:"Brush Mode"
/*autoUndoEnabled:false*/
(
	global wallwormbrusmodestate
	
	global wallworm_brush_mode_create1 = function wallworm_brush_mode_create1 = (
		
				obj = callbacks.notificationParam()
		
				local canAdd = false
		
				if isDeleted obj == false and (canConvertTo obj Editable_poly == true or isGroupHead obj == true) and (getUserProp obj "ww_wwdt_displacement_brush") == undefined and (getUserProp obj "wwmt_decal") == undefined AND (getUserProp obj "wwmt_LOD_Gizmo" == undefined) AND  getUserProp obj "wwmt_proxie_source" == undefined  then (
				local canAdd = true
				
				try (

					if nvpx.IsConvex obj ==false then (
						format "% may not be Convex!!\n" obj.name

						)
				) catch (

				)
				
				if isProperty obj "wallworm" == true then (
				
					if isProperty obj "entityType" == true  AND obj.entityType == "PointClass" then (
						
						canAdd = false
					)
					
				) else (

				)

				
				if canAdd == true then (
					if classof obj.baseobject == Corvex then (
						obj.isWorldGeometry = true
						
					) else (
						local theClass = classof obj
						if findItem (#(Plane,Torus,Tube,Teapot,L_Ext,Torus_Knot,C_Ext,RingWave,Hose)) theClass == 0  then (
							setUserProp obj "wwdt_brush_geometry_export" "true"
						)
					)
				)
			  )
	)

	function removeBrushMode = (
		callbacks.removeScripts id:#wallwormbrushmode
		/*callbacks.removeScripts  #nodeCreate  id:#wallwormbrushmode
		callbacks.removeScripts  #nodeCloned  id:#wallwormbrushmode 
		callbacks.removeScripts  #sceneNodeAdded id:#wallwormbrushmode */
		wallwormbrusmodestate = false	
	)
	
	
	on isEnabled return wallwormbrusmodestate
	on isChecked return wallwormbrusmodestate --check or uncheck the Macro button
	on closeDialogs do (
		removeBrushMode()
	)
	
	on execute do (
		if wallwormbrusmodestate == undefined then (
		
			wallwormbrusmodestate = false	
			
		)
		
		if wallwormbrusmodestate == false then (
			callbacks.addScript #nodeCreated "wallworm_brush_mode_create1()" id:#wallwormbrushmode persistent:true
			callbacks.addScript #nodeCloned "wallworm_brush_mode_create1()" id:#wallwormbrushmode persistent:true
			callbacks.addScript #sceneNodeAdded "wallworm_brush_mode_create1()" id:#wallwormbrushmode persistent:true
			
			wallwormbrusmodestate = true
			
		) else (
			
				removeBrushMode()
		)
	)
)
