 /*
 Wall Worm Quick Parent Link
 Version 1.5
 
 Copyright (c) 2012-2013 by Shawn Olson
 http://www.shawnolson.net
 
 This script will let you start picking objects in the scene to quickly chain/parent them.
 
 Installation
 
 Run this script once. You can then assign it to a  keyboard shortcut, quad or button by going to
 Customize > Customize User Interface then opening the type of shortcut you want to add this to.
 You can find this function under the wallworm.com category as "Quickly Link Objects by Picking".
 
 Changelog:
 
 1.5
 * Added new Macroscript for parenting selection based on order of selection.
 
 1.4 
 * Added more color coding. Grandparents are now always some shade of blue.
 * Added support to overlap hierarchies and reuse nodes already in a stroke set.
 * Fixed false logical error when trying to parent a chain to another chain that unset a parent.
 
 1.3 Added visual cue regarding the chain of picked objects.
 
 1.2 Added functionality so that you can paint the parenting.
 
 1.1 Fixed a bug in code that failed when I used local variables improperly in the MacroScript. Improper
 testing caused this.
 
*/

macroscript WallWormQuickParentSelection
category:"wallworm.com"
tooltip:"Quickly Link Selected objects by order of selection."
buttontext:"Quick Parent Selection"
(
	on execute do (
		function parentTheArray ar = (
			/*Need multiple objects selected to make parent > child links*/
			if ar.count > 1 then (
				
				lastObj = ar[ar.count]
				/*Start index at 2 because it is the next object in line to be a parent of current object.*/
				ind = 2
				
				for obj in ar while obj != lastObj do (

					/*Check for a dependency loop that would otherwise crash the script.*/
					if refs.dependencyLoopTest ar[ind] obj  == true then (
						ar[ind].parent = undefined
					)
					obj.parent = ar[ind]
					ind += 1
				)
			)
		)

		if selection.count > 1 then (
			parentTheArray (selection as array)
		) else (
				messagebox "You must make a selection first with at least two objects. The order of selected objects will affect the results."
		)
	)
)

 macroscript WallWormQuickParentPick
category:"wallworm.com"
tooltip:"Quickly Link objects by clicking."
buttontext:"Quick Parent Link"
(
on execute do (
 
 
global wallworm_last_link_object = undefined
--global wallworm_last_link_copy = undefined
global wallworm_quick_link_array = #()
global wallworm_quick_link_array_copy = #()	
global  wallworm_sortByDistance
global wallworm_link_from_mouse_action
global wallworm_kill_link_arrays
global wallworm_link_strokes = #()
global wallworm_update_link_colors
	

	function wallworm_update_link_colors = (
		
		local theColor = 255
		
		
		
		for nodes in wallworm_link_strokes do (
			
			
			for obj in nodes do (
				obj.wireColor = (color 0 0 (theColor) )
			)
			theColor = theColor - 40
			if theColor < 40 then (
				theColor = 255
				)
			
			)
		
		
		
		)
	
function wallworm_sortByDistance n1 n2 pos:[0,0,0] = (
	 --sort function provide by denisT
	 local d1 = distance n1[2].pos pos
	 local d2 = distance n2[2].pos pos
	 if d1 > d2 then 1 else if d1 < d2 then -1 else 0
 )
 
 	 function wallworm_kill_link_arrays deleteNodes:true= (
		 
		 
			global wallworm_quick_link_array_copy
			global wallworm_quick_link_array
			global wallworm_link_strokes
			if wallworm_quick_link_array.count > 0 then (

				if wallworm_link_strokes.count > 0 AND deleteNodes == true then (
					
					
					for ar in wallworm_link_strokes do (
						delete ar
						)
					
				)
				if wallworm_quick_link_array_copy.count > 0 AND deleteNodes == true then (

						delete wallworm_quick_link_array_copy

				)
				
				
				local newArray = #()
				--for ar in wallworm_link_strokes do (
				for o in wallworm_quick_link_array WHERE isDeleted o == false do (
					appendIfUnique newArray o
					)
				--)
					
				if deleteNodes == true then (
					unhide  newArray
				)
				flashnodes newArray
				 
				if deleteNodes == true then (
					wallworm_quick_link_array = #()
					wallworm_link_strokes = #()
				)
				newArray = undefined
				wallworm_quick_link_array_copy = #()
				forceCompleteredraw()
			)
		 
	)
 
 
 
 function wallworm_link_from_mouse_action msg ir obj faceNum shift ctrl alt = (
	local node
	global wallworm_quick_link_array
	global wallworm_last_link_object
	global wallworm_quick_link_array_copy 
	global wallworm_kill_link_arrays
	global wallworm_link_strokes

			 wray = mapScreenToWorldRay mouse.pos
				 
			 inodes = intersectRayScene wray 
			--
			--( findItem (wallworm_link_strokes[wallworm_link_strokes.count]) obj[1] == 0) 
	 
			 inodes = for obj in inodes where not obj[1].ishiddenInVpt AND (findItem wallworm_quick_link_array_copy obj[1] == 0) collect obj
			 if inodes.count > 0 do  (
				 qsort inodes wallworm_sortByDistance pos:wray.pos

				 node = inodes[1][1]

				 local sourceName = getUserProp node "wallworm_link_source"
				 if sourceName != undefined then (
					 
							local theBrsh = getNodeByName sourceName
							if theBrsh != undefined do (
							
								node = theBrsh
							)
					 
					 ) else (
					 
					 )

				appendIfUnique wallworm_quick_link_array node
				if wallworm_last_link_object != undefined  AND alt == false then (
					if wallworm_last_link_object != undefined AND isDeleted wallworm_last_link_object == false  then (
						appendIfUnique wallworm_quick_link_array wallworm_last_link_object
					)
					/*
					if wallworm_last_link_object == node.parent then (
						node.parent = undefined
					)*/
					
					try (
						wallworm_last_link_object.parent = node
					) catch (
						--print (getCurrentException())
					)
					
					
				) else (
					
					
					append wallworm_link_strokes wallworm_quick_link_array_copy
					wallworm_update_link_colors()
					wallworm_kill_link_arrays deleteNodes:false
					
					wallworm_quick_link_array_copy = #()
					
					appendIfUnique wallworm_quick_link_array node
					
					)	 
				wallworm_last_link_object = node
				
				
					
					
				local newnode = copy node
				newnode.name = uniqueName ("wwtemplink")
				newnode.mat= undefined
				newnode.wireColor = (color 255 0 0)
				append wallworm_quick_link_array_copy newnode
				setUserProp newnode "wallworm_link_source" (wallworm_last_link_object.name)
				hide wallworm_last_link_object
					

								
					

				
			)


	 

	 )
	 

 
 
	 function wallworm_link_pick msg ir obj faceNum shift ctrl alt = (

		 case msg of (
			 #mouseMove:
			(
				wallworm_link_from_mouse_action msg ir obj faceNum shift ctrl alt
			)
			 #mousePoint:
			(
				wallworm_link_from_mouse_action msg ir obj faceNum shift ctrl alt
			)
		 )

		 if msg == #mouseAbort then (

			 wallworm_kill_link_arrays()
			 return #abort
			 ) else ( return #continue )
	 )


	with undo off mouseTrack trackCallback:wallworm_link_pick

 )
 
 )