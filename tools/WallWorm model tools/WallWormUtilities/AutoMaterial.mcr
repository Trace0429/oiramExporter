/*
Wall Worm Auto Material

http://www.shawnolson.net/a/1831/wall_worm_auto_material.html

Copyright (c) 2013 by Shawn Olson
http://www.shawnolson.net

Version 1.1

Changelog:

Version 1.1

* No longer adds callback to #sceneNodeAdded


Auto Material will auotmatically apply a material to objects that you create, copy or add to scene that happen to have no materials. If you copy an object with no material, the copy will get a material.

Note that the material chosen is from the currently active material in the material editor. If you have a version of Max with Slate, it will prefer the Slate editor.


This function is packaged in Wall Worm.

*/

macroscript wallwormAutoMaterial
category:"wallworm.com"
tooltip:"Automatically Give Material to New Objects"
buttontext:"Auto Material"
/*autoUndoEnabled:false*/
(
	global wallwormautomatmodestate
	global wallworm_create_apply_material = function wallworm_create_apply_material = (
		
		obj = callbacks.notificationParam()
		if isDeleted obj == false and  isProperty obj "mat"  then (


				
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
	global wallworm_removeAutoMatMode = function wallworm_removeAutoMatMode = (
		callbacks.removeScripts id:#wallwormmaterialmode
		global wallwormautomatmodestate
		wallwormautomatmodestate = false	
	)
	
	on isChecked return wallwormautomatmodestate --check or uncheck the Macro button
	on closeDialogs do (
		wallworm_removeAutoMatMode()
	)
	
	on execute do (
		if wallwormautomatmodestate == undefined then (
		
			wallwormautomatmodestate = false	
			
		)
		
		if wallwormautomatmodestate == false then (
			
			/*Add all the event callback functions we want.*/
			callbacks.addScript #nodeCreated "wallworm_create_apply_material()" id:#wallwormmaterialmode persistent:false
			callbacks.addScript #nodeCloned "wallworm_create_apply_material()" id:#wallwormmaterialmode persistent:false
			--callbacks.addScript #sceneNodeAdded "wallworm_create_apply_material()" id:#wallwormmaterialmode persistent:false
			/*Remove the callback when file saved... if do not do this is can Crash Max and possible corrupt the file. Why?*/
			callbacks.addScript #filePreSave "wallworm_removeAutoMatMode()" id:#wallwormmaterialmode persistent:false
			wallwormautomatmodestate = true
			
		) else (
			
				wallworm_removeAutoMatMode()
		)
	)
)
