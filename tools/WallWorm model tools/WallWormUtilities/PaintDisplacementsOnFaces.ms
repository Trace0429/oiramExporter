/*
Wall Worm Displacement Painter 0.1
http://www.wallworm.com

Copyright (c) 2011-2012 by Shawn Olson
http://www.shawnolson.net

*/
if ww_wwdt_control_mesh == undefined then (
	
global wwmt_WallwormPaintDisp_version = 1.0

global WallwormPaintDisp
global wallwormraymesh

global WallWormFacesAlreadyPainted 

if WallWormFacesAlreadyPainted ==undefined then (
	WallWormFacesAlreadyPainted= #()
)

WallWormPaintedDisplacements= #()

global WallWormPaintedDisplacements = #()
	filein 	"$scripts\\WallWorm.com\\WallWormSimpleDisplacement\\wwdt_event_funcs.ms"
	fileIn "$scripts/WallWorm.com/common/mse/wallwormVMF.mse"	
(

	
function wwmt_WallwormPaintDisp_getMeshFaceData aMesh =
 (
	 -- converted from http://forums.cgsociety.org/archive/index.php/t-714405.html by an Enrico
	 oMesh = copy aMesh
	 convertto oMesh editable_mesh

	 local baMeshFaces = #{1..(meshOp.getNumFaces oMesh)}
	 local aaiFaceGroups = #()

	 local i = baMeshFaces.numberSet
	 while (i > 0) do
	 (
		 baMeshFacesInGroup = meshOp.getPolysUsingFace oMesh (baMeshFaces as Array)[1] ignoreVisEdges:false threshhold:120
		 append aaiFaceGroups (baMeshFacesInGroup as Array)
		 baMeshFaces -= baMeshFacesInGroup
		 i = baMeshFaces.numberSet
	 )
	 
	 local aaiQuadsIndex = #()
	 local afQuadsArea = #()
	 local ap3QuadsNormal = #()

	 local p3TempNormal = [0,0,0]

	 for aiGroup in aaiFaceGroups do(
		 if (aiGroup.count == 2) do (
			 append aaiQuadsIndex aiGroup
			 append afQuadsArea (meshOp.getFaceArea oMesh aiGroup)

			 for iFace in aiGroup do(
				p3TempNormal += getFaceNormal oMesh iFace 
			 )
			 append ap3QuadsNormal (normalize(p3TempNormal))
			 p3TempNormal = [0,0,0]
		 )
	 )
	 delete oMesh
	 return #(aaiFaceGroups, aaiQuadsIndex, afQuadsArea, ap3QuadsNormal)
 )
 







 fn sortByDistance n1 n2 pos:[0,0,0] = (
	 --provide by denisT
	 local d1 = distance n1[2].pos pos
	 local d2 = distance n2[2].pos pos
	 if d1 > d2 then 1 else if d1 < d2 then -1 else 0
 )
 
 fn pickingFace msg ir obj faceNum shift ctrl alt = (
	 --base provide by denisT
	 local node, face, faceid
	 case msg of (
		 #mousePoint:
		 (
		 wray = mapScreenToWorldRay mouse.pos
			 
		 inodes = intersectRayScene wray
		 inodes = for obj in inodes where not obj[1].ishiddenInVpt collect obj
		 if inodes.count > 0 do  (
		 qsort inodes sortByDistance pos:wray.pos

		 node = inodes[1][1]
			 
		if getUserProp node "ww_wwdt_displacement_brush" != undefined then (
			return #continue
			)
/*
		if (findItem WallWormFacesAlreadyPainted node) != 0 then (
			return #continue
			) else (
			
			append WallWormFacesAlreadyPainted node
			
			)
			 */
		 wallwormraymesh.free()
		 wallwormraymesh.Initialize 10
		 wallwormraymesh.addNode node
		 wallwormraymesh.buildGrid()
		 local hits = wallwormraymesh.intersectRay wray.pos wray.dir off

		 faces = for i=1 to hits collect wallwormraymesh.getHitFace i
		 if (i = wallwormraymesh.getClosestHit()) != 0 do face = faces[i]
			 
			 

		 meshData = wwmt_WallwormPaintDisp_getMeshFaceData node
		 /*
		 format "Quads indexes -> %\n" meshData[2]
		 */

			 
			 notface = true	
			 

				
			 

		if classOf node == editable_poly then (	
			 for f = 1 to meshData[2].count while notface do (
				 
				 if (findItem meshData[2][f] face) != 0 do (
					 

					 faceid = f
					 --notface = false
					 
					 )
				 
				 
				 )
			 ) else (
				 print "Paint Function only works on Editable Poly objects."
				 return #continue
				 )
			 
		 if alt == true then (
			 --delete selected displacements
			 
			) else (
				
				global WallWormPaintedDisplacements
			
				global ww_wwdt_displacement_power

			 	newbrush = wallworm_create_plane_from_polygon node faceid power:ww_wwdt_displacement_power
			    
				--format "Clicked % Face % and created %\n" node faceid newbrush
					--print newbrush.lengthsegs
						if newbrush != undefined then (
							
							if (findItem WallWormFacesAlreadyPainted newbrush.pos) == 0 then (
								
								
								theDisp =  (ww_wwdt_makeDisplacement ww_wwdt_displacement_power newbrush.length newbrush.width newbrush.pos mat:undefined brsh:newbrush)
								append WallWormPaintedDisplacements theDisp[1]
								--format "Created %\n" theDisp[1]
								append WallWormFacesAlreadyPainted newbrush.pos
								redrawviews()
							) else (
								
								--format "ALready used %\n" newbrush.pos
								delete newbrush
								)
						)
			 
			 
			    
			)	 

		 )

		 --format "node:% trimesh% face:%\n" node face faceid

		 )
	 )
	 if msg == #mouseAbort then 
		 
	 (
		 if WallWormPaintedDisplacements.count > 0 then (
		 select WallWormPaintedDisplacements
		 )
		 return #abort 
		 
		 
		 )
	 else (
	 return #continue
	 )
 )




try(destroyDialog WallwormPaintDisp)catch(
	
	   --there was not any open
	)



rollout WallwormPaintDisp "Displacement Painter 0.1" width:242 height:119
(



	button btn14 "Start Painting" pos:[12,5] width:85 height:35 toolTip:"Start picking faces to place displacements. Right-Click to end."
	--HyperLink link_help "Help and Info" pos:[117,128] width:79 height:17 address:"http://wallworm.com/projects/utilities/docs/rollouts/worm_face.html" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	HyperLink linkWW "WallWorm.com" pos:[9,94] width:96 height:17 address:"http://www.wallworm.com" color:(color 0 0 255) visitedcolor:(color 0 0 255) hovercolor:(color 255 0 0)
	button btn4 "Clear Face Exclusion" pos:[114,5] width:109 height:35

	--http://denist.cgsociety.org/about/

	label lbl2 "At the moment, the paint function isn't finished. Click on faces to make displacements." pos:[8,46] width:215 height:47


	




	on btn14 pressed do
	(
		
		clearSelection()
		global WallWormPaintedDisplacements
		WallWormPaintedDisplacements= #()
		wallwormraymesh = RayMeshGridIntersect()
		with undo off mouseTrack trackCallback:pickingFace
		wallwormraymesh.free()
	
	)
	on btn4 pressed do
	(
			global WallWormFacesAlreadyPainted 
			WallWormFacesAlreadyPainted= #()
	
		)
)


	createDialog WallwormPaintDisp

	--WallwormPaintDisp.caption += (" Version "+(wwmt_WallwormPaintDisp_version as string))
)
) else (
  messagebox "This function only works when Anvil is not in Edit Mode."

)